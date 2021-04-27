Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B74FC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E0D613FE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhD0WAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39044 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239460AbhD0V7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3A9812041AC;
        Tue, 27 Apr 2021 23:59:09 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RG+EXhNHm4We; Tue, 27 Apr 2021 23:59:07 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 36FFF204190;
        Tue, 27 Apr 2021 23:59:06 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 60/83] sg: compress usercontext to uc
Date:   Tue, 27 Apr 2021 17:57:10 -0400
Message-Id: <20210427215733.417746-62-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Abbreviate sg_usercontext_* functions to start with sg_uc_ instead.
Rework associated function.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 58 ++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 045aa96addac..8e0ae40cde87 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -635,7 +635,7 @@ sg_fd_share_ptr(struct sg_fd *sfp)
  * Release resources associated with a prior, successful sg_open(). It can be
  * seen as the (final) close() call on a sg device file descriptor in the user
  * space. The real work releasing all resources associated with this file
- * descriptor is done by sg_remove_sfp_usercontext() which is scheduled by
+ * descriptor is done by sg_uc_remove_sfp() which is scheduled by
  * sg_remove_sfp().
  */
 static int
@@ -4630,24 +4630,25 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return res;
 }
 
+/*
+ * This user context function is called from sg_rq_end_io() when an orphaned
+ * request needs to be cleaned up (e.g. when control C is typed while an
+ * ioctl(SG_IO) is active).
+ */
 static void
-sg_rq_end_io_usercontext(struct work_struct *work)
+sg_uc_rq_end_io_orphaned(struct work_struct *work)
 {
 	struct sg_request *srp = container_of(work, struct sg_request,
 					      ew_orph.work);
 	struct sg_fd *sfp;
 
-	if (unlikely(!srp)) {
-		WARN_ONCE(1, "%s: srp unexpectedly NULL\n", __func__);
-		return;
-	}
 	sfp = srp->parentfp;
 	if (unlikely(!sfp)) {
 		WARN_ONCE(1, "%s: sfp unexpectedly NULL\n", __func__);
 		return;
 	}
 	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
-	if (unlikely(test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm))) {
+	if (test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm)) {
 		sg_finish_scsi_blk_rq(srp);	/* clean up orphan case */
 		sg_deact_request(sfp, srp);
 	}
@@ -4761,18 +4762,19 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	scsi_req_free_cmd(scsi_rp);
 	blk_put_request(rqq);
 
-	if (likely(rqq_state == SG_RQ_AWAIT_RCV)) {
-		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
-		if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
-			wake_up_interruptible(&sfp->cmpl_wait);
-		if (sfp->async_qp && (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
-				      (srp->rq_flags & SGV4_FLAG_SIGNAL)))
-			kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
-		kref_put(&sfp->f_ref, sg_remove_sfp);
-	} else {        /* clean up orphaned request that aren't being kept */
-		INIT_WORK(&srp->ew_orph.work, sg_rq_end_io_usercontext);
+	if (unlikely(rqq_state != SG_RQ_AWAIT_RCV)) {
+		/* clean up orphaned request that aren't being kept */
+		INIT_WORK(&srp->ew_orph.work, sg_uc_rq_end_io_orphaned);
 		schedule_work(&srp->ew_orph.work);
+		return;
 	}
+	/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
+	if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
+		wake_up_interruptible(&sfp->cmpl_wait);
+	if (sfp->async_qp && (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
+			      (srp->rq_flags & SGV4_FLAG_SIGNAL)))
+		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return;
 }
 
@@ -6222,15 +6224,15 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 
 /*
  * A successful call to sg_release() will result, at some later time, to this
- * function being invoked. All requests associated with this file descriptor
- * should be completed or cancelled when this function is called (due to
- * sfp->f_ref). Also the file descriptor itself has not been accessible since
- * it was list_del()-ed by the preceding sg_remove_sfp() call. So no locking
- * is required. sdp should never be NULL but to make debugging more robust,
- * this function will not blow up in that case.
+ * "user context" function being invoked. All requests associated with this
+ * file descriptor should be completed or cancelled when this function is
+ * called (due to sfp->f_ref). Also the file descriptor itself has not been
+ * accessible since it was list_del()-ed by the preceding sg_remove_sfp()
+ * call. So no locking is required. sdp should never be NULL but to make
+ * debugging more robust, this function will not blow up in that case.
  */
 static void
-sg_remove_sfp_usercontext(struct work_struct *work)
+sg_uc_remove_sfp(struct work_struct *work)
 {
 	__maybe_unused int o_count;
 	int subm;
@@ -6295,7 +6297,7 @@ sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
 
-	INIT_WORK(&sfp->ew_fd.work, sg_remove_sfp_usercontext);
+	INIT_WORK(&sfp->ew_fd.work, sg_uc_remove_sfp);
 	schedule_work(&sfp->ew_fd.work);
 }
 
@@ -6342,11 +6344,11 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 		return long_str ? "inflight" : "act";
 	case SG_RQ_AWAIT_RCV:
 		return long_str ? "await_receive" : "rcv";
-	case SG_RQ_BUSY:
+	case SG_RQ_BUSY:	/* state transitioning */
 		return long_str ? "busy" : "bsy";
-	case SG_RQ_SHR_SWAP:	/* only an active read-side has this */
+	case SG_RQ_SHR_SWAP:	/* read-side: awaiting write-side req start */
 		return long_str ? "share swap" : "s_wp";
-	case SG_RQ_SHR_IN_WS:	/* only an active read-side has this */
+	case SG_RQ_SHR_IN_WS:	/* read-side: waiting for inflight write-side */
 		return long_str ? "share write-side active" : "ws_a";
 	default:
 		return long_str ? "unknown" : "unk";
-- 
2.25.1

