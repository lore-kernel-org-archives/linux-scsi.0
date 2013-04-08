From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm mpath:  attach scsi_dh during table resume
Date: Mon,  8 Apr 2013 17:50:16 -0400
Message-ID: <1365457816-31475-2-git-send-email-snitzer@redhat.com>
References: <20130404131631.GA10208@redhat.com>
 <1365457816-31475-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935961Ab3DHVvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Apr 2013 17:51:12 -0400
In-Reply-To: <1365457816-31475-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: hare@suse.de, mpatocka@redhat.com

Preallocate scsi_dh_data using scsi_dh_alloc_data() during table load
but attach the scsi_dh for each path during table resume.  This avoids a
kernel crash that can happen when changing the scsi_dh during table
load.

When we reload a multipath device, there are two instances of the
multipath target - the first instance that is active and the second
instance that is being constructed during table load with "ctr" method.

If the multipath constructor finds out that the device is using a
different device handler, it detaches the existing handler and attaches
a new handler. However, the first instance of the multipath target still
exists and processes requests. If the first instance sends some
path-management request with scsi_dh_activate and the second instance
detaches the device handler while the path-management request is in
flight, a crash happens. The reason for the crash is that the endio
routine for the path-management request is working with structures that
were freed when the handler was detached.

References:
  http://bugzilla.redhat.com/912245
  http://bugzilla.redhat.com/902595

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |  160 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 111 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 37d9ead..fd16be1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -36,6 +36,7 @@ struct pgpath {
 
 	struct dm_path path;
 	struct delayed_work activate_path;
+	struct scsi_dh_data *hw_handler_data;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -144,6 +145,7 @@ static struct pgpath *alloc_pgpath(void)
 
 static void free_pgpath(struct pgpath *pgpath)
 {
+	kfree(pgpath->hw_handler_data);
 	kfree(pgpath);
 }
 
@@ -563,14 +565,53 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 	return 0;
 }
 
+/*
+ * Return: @true if handler is already attached.
+ */
+static bool validate_attached_hardware_handler(struct multipath *m, struct pgpath *p)
+{
+	struct request_queue *q;
+	const char *attached_handler_name;
+	bool handler_already_attached = false;
+
+	q = bdev_get_queue(p->path.dev->bdev);
+	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
+	if (attached_handler_name) {
+		if (!strncmp(attached_handler_name, m->hw_handler_name,
+			     strlen(attached_handler_name)))
+			handler_already_attached = true;
+
+		if (!m->retain_attached_hw_handler) {
+			kfree(attached_handler_name);
+			return handler_already_attached;
+		}
+
+		handler_already_attached = true;
+		/*
+		 * Reset hw_handler_name to match the attached handler
+		 * and clear any hw_handler_params associated with the
+		 * ignored handler.
+		 *
+		 * NB. This modifies the table line to show the actual
+		 * handler instead of the original table passed in.
+		 */
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = attached_handler_name;
+
+		kfree(m->hw_handler_params);
+		m->hw_handler_params = NULL;
+	}
+
+	return handler_already_attached;
+}
+
 static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps,
-			       struct dm_target *ti)
+				 struct dm_target *ti)
 {
 	int r;
 	struct pgpath *p;
 	struct multipath *m = ti->private;
-	struct request_queue *q = NULL;
-	const char *attached_handler_name;
+	bool skip_scsi_dh_alloc_data = false;
 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
@@ -589,59 +630,25 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
+	/*
+	 * Check if scsi_dh_data allocation can be avoided (as an optimization)
+	 * based on which, if any, device handler is already attached.
+	 */
 	if (m->retain_attached_hw_handler || m->hw_handler_name)
-		q = bdev_get_queue(p->path.dev->bdev);
-
-	if (m->retain_attached_hw_handler) {
-		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
-		if (attached_handler_name) {
-			/*
-			 * Reset hw_handler_name to match the attached handler
-			 * and clear any hw_handler_params associated with the
-			 * ignored handler.
-			 *
-			 * NB. This modifies the table line to show the actual
-			 * handler instead of the original table passed in.
-			 */
-			kfree(m->hw_handler_name);
-			m->hw_handler_name = attached_handler_name;
-
-			kfree(m->hw_handler_params);
-			m->hw_handler_params = NULL;
-		}
-	}
+		skip_scsi_dh_alloc_data = validate_attached_hardware_handler(m, p);
 
-	if (m->hw_handler_name) {
+	if (m->hw_handler_name && !skip_scsi_dh_alloc_data) {
 		/*
-		 * Increments scsi_dh reference, even when using an
-		 * already-attached handler.
+		 * Pre-allocate the scsi_dh_data for this path.  Either the scsi_dh
+		 * will take ownership of the memory or free_pgpath() will clean it up.
 		 */
-		r = scsi_dh_attach(q, m->hw_handler_name, NULL);
-		if (r == -EBUSY) {
-			/*
-			 * Already attached to different hw_handler:
-			 * try to reattach with correct one.
-			 */
-			scsi_dh_detach(q);
-			r = scsi_dh_attach(q, m->hw_handler_name, NULL);
-		}
-
-		if (r < 0) {
-			ti->error = "error attaching hardware handler";
+		p->hw_handler_data = scsi_dh_alloc_data(m->hw_handler_name, GFP_KERNEL);
+		if (IS_ERR(p->hw_handler_data)) {
+			ti->error = "error allocating hardware handler data";
 			dm_put_device(ti, p->path.dev);
+			r = PTR_ERR(p->hw_handler_data);
 			goto bad;
 		}
-
-		if (m->hw_handler_params) {
-			r = scsi_dh_set_params(q, m->hw_handler_params);
-			if (r < 0) {
-				ti->error = "unable to set hardware "
-							"handler parameters";
-				scsi_dh_detach(q);
-				dm_put_device(ti, p->path.dev);
-				goto bad;
-			}
-		}
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
@@ -1349,16 +1356,71 @@ static void multipath_postsuspend(struct dm_target *ti)
 	mutex_unlock(&m->work_mutex);
 }
 
+static void __attach_scsi_dh(struct multipath *m, struct pgpath *p)
+{
+	int r;
+	char b[BDEVNAME_SIZE];
+	struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+	/*
+	 * Increments scsi_dh reference, even when using an
+	 * already-attached handler.  On success, scsi_dh_attach() will
+	 * take ownership of p->hw_handler_data.
+	 */
+	r = scsi_dh_attach(q, m->hw_handler_name, p->hw_handler_data);
+	if (r == -EBUSY) {
+		/*
+		 * Already attached to different hw_handler:
+		 * try to reattach with correct one.
+		 */
+		scsi_dh_detach(q);
+		r = scsi_dh_attach(q, m->hw_handler_name, p->hw_handler_data);
+	}
+
+	if (r < 0) {
+		DMERR("error attaching hardware handler to: %s",
+		      bdevname(p->path.dev->bdev, b));
+		return;
+	}
+	/*
+	 * scsi_dh_attach() took ownership of p->hw_handler_data.
+	 */
+	p->hw_handler_data = NULL;
+
+	if (m->hw_handler_params) {
+		r = scsi_dh_set_params(q, m->hw_handler_params);
+		if (r < 0) {
+			DMERR("unable to set hardware handler parameters, "
+			      "detaching hardware handler from: %s",
+			      bdevname(p->path.dev->bdev, b));
+			scsi_dh_detach(q);
+			return;
+		}
+	}
+}
+
 /*
  * Restore the queue_if_no_path setting.
  */
 static void multipath_resume(struct dm_target *ti)
 {
 	struct multipath *m = (struct multipath *) ti->private;
+	struct priority_group *pg;
+	struct pgpath *p;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
 	m->queue_if_no_path = m->saved_queue_if_no_path;
+
+	if (!m->hw_handler_name)
+		goto out;
+
+	/* Attach the named scsi_dh to all paths in the priority groups */
+	list_for_each_entry(pg, &m->priority_groups, list) {
+		list_for_each_entry(p, &pg->pgpaths, list)
+			__attach_scsi_dh(m, p);
+	}
+out:
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
-- 
1.7.1

