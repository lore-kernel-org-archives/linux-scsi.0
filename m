Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF72CECE59B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A28422067B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 07:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfJHHud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:50:33 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34849 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730410AbfJHHu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 03:50:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EC95F20425B;
        Tue,  8 Oct 2019 09:50:23 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 32k40I+Z3OgT; Tue,  8 Oct 2019 09:50:23 +0200 (CEST)
Received: from xtwo70.bingwo.ca (unknown [82.134.31.172])
        by smtp.infotech.no (Postfix) with ESMTPA id 78497204237;
        Tue,  8 Oct 2019 09:50:23 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 12/23] sg: change rwlock to spinlock
Date:   Tue,  8 Oct 2019 09:50:11 +0200
Message-Id: <20191008075022.30055-13-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008075022.30055-1-dgilbert@interlog.com>
References: <20191008075022.30055-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A reviewer suggested that the extra overhead associated with a
rw lock compared to a spinlock was not worth it for short,
oft-used critcal sections.

So the rwlock on the request list/array is changed to a spinlock.
The head of that list is in the owning sf file descriptor object.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d28278a30ced..2796fef42837 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -139,7 +139,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	struct list_head sfd_entry;	/* member sg_device::sfds list */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
-	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
+	spinlock_t rq_list_lock;	/* protect access to list in req_arr */
 	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
@@ -742,17 +742,17 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
 	struct sg_request *resp;
 	unsigned long iflags;
 
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	list_for_each_entry(resp, &sfp->rq_list, entry) {
 		/* look for requests that are ready + not SG_IO owned */
 		if ((resp->done == 1) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
 			resp->done = 2;	/* guard against other readers */
-			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			return resp;
 		}
 	}
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return NULL;
 }
 
@@ -804,9 +804,9 @@ srp_done(struct sg_fd *sfp, struct sg_request *srp)
 	unsigned long flags;
 	int ret;
 
-	read_lock_irqsave(&sfp->rq_list_lock, flags);
+	spin_lock_irqsave(&sfp->rq_list_lock, flags);
 	ret = srp->done;
-	read_unlock_irqrestore(&sfp->rq_list_lock, flags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
 	return ret;
 }
 
@@ -1045,15 +1045,15 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			(srp_done(sfp, srp) || SG_IS_DETACHING(sdp)));
 		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
-		write_lock_irq(&sfp->rq_list_lock);
+		spin_lock_irq(&sfp->rq_list_lock);
 		if (srp->done) {
 			srp->done = 2;
-			write_unlock_irq(&sfp->rq_list_lock);
+			spin_unlock_irq(&sfp->rq_list_lock);
 			result = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
 			return (result < 0) ? result : 0;
 		}
 		srp->orphan = 1;
-		write_unlock_irq(&sfp->rq_list_lock);
+		spin_unlock_irq(&sfp->rq_list_lock);
 		return result;	/* -ERESTARTSYS because signal hit process */
 	case SG_SET_TIMEOUT:
 		result = get_user(val, ip);
@@ -1105,16 +1105,16 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		sfp->force_packid = val ? 1 : 0;
 		return 0;
 	case SG_GET_PACK_ID:
-		read_lock_irqsave(&sfp->rq_list_lock, iflags);
+		spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
-				read_unlock_irqrestore(&sfp->rq_list_lock,
+				spin_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
 				put_user(srp->header.pack_id, ip);
 				return 0;
 			}
 		}
-		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+		spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 		put_user(-1, ip);
 		return 0;
 	case SG_GET_NUM_WAITING:
@@ -1184,9 +1184,9 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
-			read_lock_irqsave(&sfp->rq_list_lock, iflags);
+			spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 			sg_fill_request_table(sfp, rinfo);
-			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = copy_to_user(p, rinfo,
 					      SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
@@ -1484,7 +1484,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	scsi_req_free_cmd(scsi_req(rq));
 	blk_put_request(rq);
 
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
@@ -1492,7 +1492,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
 		/* Now wake up any sg_read() that is waiting for this
@@ -2166,7 +2166,7 @@ sg_add_request(struct sg_fd *sfp)
 	unsigned long iflags;
 	struct sg_request *rp = sfp->req_arr;
 
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (!list_empty(&sfp->rq_list)) {
 		if (!sfp->cmd_q)
 			goto out_unlock;
@@ -2182,10 +2182,10 @@ sg_add_request(struct sg_fd *sfp)
 	rp->parentfp = sfp;
 	rp->header.duration = jiffies_to_msecs(jiffies);
 	list_add_tail(&rp->entry, &sfp->rq_list);
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return rp;
 out_unlock:
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return NULL;
 }
 
@@ -2198,13 +2198,13 @@ sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 
 	if (!sfp || !srp || list_empty(&sfp->rq_list))
 		return res;
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (!list_empty(&srp->entry)) {
 		list_del(&srp->entry);
 		srp->parentfp = NULL;
 		res = 1;
 	}
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return res;
 }
 
@@ -2220,7 +2220,7 @@ sg_add_sfp(struct sg_device *sdp)
 		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
-	rwlock_init(&sfp->rq_list_lock);
+	spin_lock_init(&sfp->rq_list_lock);
 	INIT_LIST_HEAD(&sfp->rq_list);
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
@@ -2265,14 +2265,14 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	unsigned long iflags;
 
 	/* Cleanup any responses which were never read(). */
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp = list_first_entry(&sfp->rq_list, struct sg_request, entry);
 		sg_finish_scsi_blk_rq(srp);
 		list_del(&srp->entry);
 		srp->parentfp = NULL;
 	}
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (sfp->reserve.buflen > 0) {
 		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
@@ -2596,7 +2596,7 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 	k = 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
 		k++;
-		read_lock(&fp->rq_list_lock); /* irqs already disabled */
+		spin_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k,
 			   jiffies_to_msecs(fp->timeout),
@@ -2646,7 +2646,7 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 		}
 		if (list_empty(&fp->rq_list))
 			seq_puts(s, "     No requests active\n");
-		read_unlock(&fp->rq_list_lock);
+		spin_unlock(&fp->rq_list_lock);
 	}
 }
 
-- 
2.23.0

