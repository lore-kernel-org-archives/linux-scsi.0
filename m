From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: manage reference on request queue of underlying
 devices
Date: Tue, 12 Jul 2011 10:58:51 -0400
Message-ID: <20110712145851.GA17979@redhat.com>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
 <1310166270-23196-1-git-send-email-roland@kernel.org>
 <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

When processing a request, DM-mpath's map_io() set the cloned request's
request_queue to the appropriate underlying device's request_queue
without getting a reference on that request_queue.

DM-mpath now maintains a reference count on the underlying devices'
request_queue.  This change wasn't motivated by a specific report but
code, like blk_insert_cloned_request(), will access the request_queue
with the understanding that the request_queue is valid.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index eadea8e..629efa3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -161,11 +161,14 @@ static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
 	struct pgpath *pgpath, *tmp;
 	struct multipath *m = ti->private;
+	struct request_queue *q;
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
+		q = bdev_get_queue(pgpath->path.dev->bdev);
 		if (m->hw_handler_name)
-			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
+			scsi_dh_detach(q);
+		blk_put_queue(q);
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
 	}
@@ -552,6 +555,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 {
 	int r;
 	struct pgpath *p;
+	struct request_queue *q;
 	struct multipath *m = ti->private;
 
 	/* we need at least a path arg */
@@ -571,9 +575,14 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (m->hw_handler_name) {
-		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+	q = bdev_get_queue(p->path.dev->bdev);
+	r = blk_get_queue(q);
+	if (r) {
+		ti->error = "error getting request queue";
+		goto bad_queue;
+	}
 
+	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
 			/*
@@ -586,8 +595,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 		if (r < 0) {
 			ti->error = "error attaching hardware handler";
-			dm_put_device(ti, p->path.dev);
-			goto bad;
+			goto bad_finish;
 		}
 
 		if (m->hw_handler_params) {
@@ -596,21 +604,22 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 				ti->error = "unable to set hardware "
 							"handler parameters";
 				scsi_dh_detach(q);
-				dm_put_device(ti, p->path.dev);
-				goto bad;
+				goto bad_finish;
 			}
 		}
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
-	if (r) {
-		dm_put_device(ti, p->path.dev);
-		goto bad;
-	}
+	if (r)
+		goto bad_finish;
 
 	return p;
 
- bad:
+bad_finish:
+	blk_put_queue(q);
+bad_queue:
+	dm_put_device(ti, p->path.dev);
+bad:
 	free_pgpath(p);
 	return ERR_PTR(r);
 }
