Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2698BC33CAC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC0A20724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgALX6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:15 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51940 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbgALX6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9748320424C;
        Mon, 13 Jan 2020 00:58:13 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4jJMcwqYAMjC; Mon, 13 Jan 2020 00:58:11 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id 45BCE204271;
        Mon, 13 Jan 2020 00:57:58 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v6 11/37] sg: change rwlock to spinlock
Date:   Mon, 13 Jan 2020 00:57:29 +0100
Message-Id: <20200112235755.14197-12-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
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
index 2f8c4eccba7e..a60b02b65392 100644
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
@@ -745,17 +745,17 @@ sg_get_rq_mark(struct sg_fd *sfp, int pack_id)
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
 
@@ -807,9 +807,9 @@ srp_done(struct sg_fd *sfp, struct sg_request *srp)
 	unsigned long flags;
 	int ret;
 
-	read_lock_irqsave(&sfp->rq_list_lock, flags);
+	spin_lock_irqsave(&sfp->rq_list_lock, flags);
 	ret = srp->done;
-	read_unlock_irqrestore(&sfp->rq_list_lock, flags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
 	return ret;
 }
 
@@ -1077,15 +1077,15 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
@@ -1137,15 +1137,15 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
 				return put_user(srp->header.pack_id, ip);
 			}
 		}
-		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+		spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 		return put_user(-1, ip);
 	case SG_GET_NUM_WAITING:
 		return put_user(atomic_read(&sfp->waiting), ip);
@@ -1214,9 +1214,9 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
-			read_lock_irqsave(&sfp->rq_list_lock, iflags);
+			spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 			sg_fill_request_table(sfp, rinfo);
-			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	#ifdef CONFIG_COMPAT
 			if (in_compat_syscall())
 				result = put_compat_request_table(p, rinfo);
@@ -1519,7 +1519,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	scsi_req_free_cmd(scsi_req(rq));
 	blk_put_request(rq);
 
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
@@ -1527,7 +1527,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
-	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
 		/* Now wake up any sg_read() that is waiting for this
@@ -2208,7 +2208,7 @@ sg_add_request(struct sg_fd *sfp)
 	unsigned long iflags;
 	struct sg_request *rp = sfp->req_arr;
 
-	write_lock_irqsave(&sfp->rq_list_lock, iflags);
+	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (!list_empty(&sfp->rq_list)) {
 		if (!sfp->cmd_q)
 			goto out_unlock;
@@ -2224,10 +2224,10 @@ sg_add_request(struct sg_fd *sfp)
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
 
@@ -2240,13 +2240,13 @@ sg_remove_request(struct sg_fd *sfp, struct sg_request *srp)
 
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
 
@@ -2262,7 +2262,7 @@ sg_add_sfp(struct sg_device *sdp)
 		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
-	rwlock_init(&sfp->rq_list_lock);
+	spin_lock_init(&sfp->rq_list_lock);
 	INIT_LIST_HEAD(&sfp->rq_list);
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
@@ -2307,14 +2307,14 @@ sg_remove_sfp_usercontext(struct work_struct *work)
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
@@ -2638,7 +2638,7 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 	k = 0;
 	list_for_each_entry(fp, &sdp->sfds, sfd_entry) {
 		k++;
-		read_lock(&fp->rq_list_lock); /* irqs already disabled */
+		spin_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d "
 			   "(res)sgat=%d low_dma=%d\n", k,
 			   jiffies_to_msecs(fp->timeout),
@@ -2688,7 +2688,7 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 		}
 		if (list_empty(&fp->rq_list))
 			seq_puts(s, "     No requests active\n");
-		read_unlock(&fp->rq_list_lock);
+		spin_unlock(&fp->rq_list_lock);
 	}
 }
 
-- 
2.24.1

