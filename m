From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Thu, 10 May 2012 10:10:58 -0400
Message-ID: <20120510141057.GA1983@redhat.com>
References: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
 <20120510065548.GA5728@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2EJOLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 10:11:10 -0400
Content-Disposition: inline
In-Reply-To: <20120510065548.GA5728@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com

On Thu, May 10 2012 at  2:55am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 09, 2012 at 09:12:46PM -0400, Mike Snitzer wrote:
> > Originally posted to dm-devel but Chandra reminded me to post to
> > linux-scsi for James to pick it up.
> > 
> > -------8<-------
> > 
> > Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> > scsi_dh that is attached to the scsi_device associated with the provided
> > request queue.  Returns NULL if a scsi_dh is not attached.
> > 
> > Also, fix scsi_dh_{attach,detach} function header comments to document
> > @q rather than @sdev.
> 
> Wha'ts the use case for this?

See this patch:
http://www.redhat.com/archives/dm-devel/2012-May/msg00046.html

(I attributed this change to Hannes because it was based on his earlier
patch... I should probably change that given that in the end I
re-wrote/merged his patch with my earlier patch...)

Anyway, DM mpath doesn't want to know about the "scsi_dh" structure, but
we need the name of the attached handler (to adjust the multipath
device's 'hw_handler_name' and to get an additional ref on the attached
scsi_dh via dm-mapth.c:parse_path's scsi_dh_attach).

BTW, only reason I split the scsi_dh change from the above dm-mpath
patch is because I'm patching SCSI and DM and need to send the changes
through different trees.

> The name is stale as soon as the function returns.

Yeah, I have since wondered about that myself.  In practice the attached
handler should remain attached so the name really won't be stale.

But in theory there could be a race with scsi_dh_detach.  So I think the
following should address your concern?

If so I'll refresh and repost the appropriate patches.

Thanks.

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1039e7f..6f11956 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -592,10 +592,11 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		q = bdev_get_queue(p->path.dev->bdev);
 
 	if (m->use_default_hw_handler) {
-		const char *attached_handler_name = scsi_dh_attached_handler_name(q);
+		const char *attached_handler_name =
+			scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			kfree(m->hw_handler_name);
-			m->hw_handler_name = kstrdup(attached_handler_name, GFP_KERNEL);
+			m->hw_handler_name = attached_handler_name;
 		}
 	}
 
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 83071e4..33e422e 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -533,10 +533,12 @@ EXPORT_SYMBOL_GPL(scsi_dh_detach);
  * scsi_dh_attached_handler_name - Get attached device handler's name
  * @q - Request queue that is associated with the scsi_device
  *      that may have a device handler attached
+ * @gfp - the GFP mask used in the kmalloc() call when allocating memory
  *
  * Returns name of attached handler, NULL if no handler is attached.
+ * Caller must take care to free the returned string.
  */
-const char *scsi_dh_attached_handler_name(struct request_queue *q)
+const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 {
 	unsigned long flags;
 	struct scsi_device *sdev;
@@ -552,7 +554,7 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q)
 		return NULL;
 
 	if (sdev->scsi_dh_data)
-		handler_name = sdev->scsi_dh_data->scsi_dh->name;
+		handler_name = kstrdup(sdev->scsi_dh_data->scsi_dh->name, gfp);
 
 	put_device(&sdev->sdev_gendev);
 	return handler_name;
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 94f502b..620c723 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -60,7 +60,7 @@ extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
-extern const char *scsi_dh_attached_handler_name(struct request_queue *q);
+extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
@@ -81,7 +81,8 @@ static inline void scsi_dh_detach(struct request_queue *q)
 {
 	return;
 }
-static inline const char *scsi_dh_attached_handler_name(struct request_queue *q)
+static inline const char *scsi_dh_attached_handler_name(struct request_queue *q,
+							gfp_t gfp)
 {
 	return NULL;
 }



