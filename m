Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9394C3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3B624699
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 03:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCBDdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:33:40 -0500
Received: from smtp.infotech.no ([82.134.31.41]:60676 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgCBDdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 1 Mar 2020 22:33:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4A9D020414E;
        Mon,  2 Mar 2020 04:33:38 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iKclWmnPLbym; Mon,  2 Mar 2020 04:33:36 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id E8629204259;
        Mon,  2 Mar 2020 04:33:30 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v8 34/38] sg: protect multiple receivers
Date:   Sun,  1 Mar 2020 22:32:45 -0500
Message-Id: <20200302033249.4515-35-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200302033249.4515-1-dgilbert@interlog.com>
References: <20200302033249.4515-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If two threads call ioctl(SG_IORECEIVE) [or read()] on the same
file descriptor there is a potential race on the same request
response. Use atomic bit operations to make sure only one thread
gets each request response. [The other thread will either get
another request response or nothing.]

Also make sfp cleanup a bit more robust and report if the
number of submitted requests (which are decremented when
completed) is other than the expected value of zero.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 54 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index eda34bbd3941..9156975d7fd3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -109,6 +109,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
 #define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
 #define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
+#define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
 #define SG_FRQ_BLK_PUT_REQ	8	/* set when blk_put_request() called */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
@@ -1284,6 +1285,7 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
 	/* read in part of v3 or v4 header for pack_id or tag based find */
 	id = pack_id;
+try_again:
 	srp = sg_find_srp_by_id(sfp, id);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1298,6 +1300,10 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 		if (res)
 			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	return sg_receive_v4(sfp, srp, p, h4p);
 }
 
@@ -1334,7 +1340,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
-
+try_again:
 	srp = sg_find_srp_by_id(sfp, pack_id);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1349,6 +1355,10 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	return sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, p);
 }
 
@@ -1501,6 +1511,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			want_id = h2p->pack_id;
 		}
 	}
+try_again:
 	srp = sg_find_srp_by_id(sfp, want_id);
 	if (!srp) {	/* nothing available so wait on packet to arrive or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1516,6 +1527,10 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			return ret;
 		/* otherwise srp should be valid */
 	}
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	if (srp->s_hdr3.interface_id == '\0')
 		ret = sg_read_v1v2(p, (int)count, sfp, srp);
 	else
@@ -3056,32 +3071,33 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		atomic_dec(&sfp->submitted);
 		atomic_dec(&sfp->waiting);
 	}
-	if (srp->bio) {
-		bool us_xfer = !test_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
-
-		if (us_xfer) {
-			ret = blk_rq_unmap_user(srp->bio);
-			if (ret) {	/* -EINTR (-4) can be ignored */
-				SG_LOG(6, sfp,
-				       "%s: blk_rq_unmap_user() --> %d\n",
-				       __func__, ret);
-			}
-		}
-		srp->bio = NULL;
-	}
-	/* In worst case READ data returned to user space by this point */
 
 	/* Expect blk_put_request(rq) already called in sg_rq_end_io() */
 	if (unlikely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
 		struct request *rq = srp->rq;
 
+		srp->rq = NULL;
 		if (rq) {       /* blk_get_request() may have failed */
 			if (scsi_req(rq))
 				scsi_req_free_cmd(scsi_req(rq));
-			srp->rq = NULL;
 			blk_put_request(rq);
 		}
 	}
+	if (srp->bio) {
+		bool us_xfer = !test_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
+		struct bio *bio = srp->bio;
+
+		srp->bio = NULL;
+		if (us_xfer && bio) {
+			ret = blk_rq_unmap_user(bio);
+			if (ret) {	/* -EINTR (-4) can be ignored */
+				SG_LOG(6, sfp,
+				       "%s: blk_rq_unmap_user() --> %d\n",
+				       __func__, ret);
+			}
+		}
+	}
+	/* In worst case, READ data returned to user space by this point */
 }
 
 static int
@@ -3514,6 +3530,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 		return;
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
+	srp->frq_bm[0] = 0;
 	sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true /* force */, __func__);
 	/* maybe orphaned req, thus never read */
 	if (sbp)
@@ -3646,6 +3663,7 @@ static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	__maybe_unused int o_count;
+	int subm;
 	unsigned long idx, iflags;
 	struct sg_device *sdp;
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
@@ -3683,6 +3701,10 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 		SG_LOG(6, sfp, "%s: kfree: srp=%pK --\n", __func__, srp);
 		kfree(srp);
 	}
+	subm = atomic_read(&sfp->submitted);
+	if (subm != 0)
+		SG_LOG(1, sfp, "%s: expected submitted=0 got %d\n",
+		       __func__, subm);
 	xa_destroy(xafp);
 	xa_lock_irqsave(xadp, iflags);
 	e_sfp = __xa_erase(xadp, sfp->idx);
-- 
2.25.1

