Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA047C33CAF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B1420724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgALX6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:42 -0500
Received: from smtp.infotech.no ([82.134.31.41]:52071 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387574AbgALX6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 73DCA20415B;
        Mon, 13 Jan 2020 00:58:39 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4b2gjt4tygey; Mon, 13 Jan 2020 00:58:37 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id D35E92042B0;
        Mon, 13 Jan 2020 00:58:01 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v6 34/37] sg: protect multiple receivers
Date:   Mon, 13 Jan 2020 00:57:52 +0100
Message-Id: <20200112235755.14197-35-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
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

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 73802c7ffea5..51ed55f97bca 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -111,6 +111,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_DIO_IN_USE	3	/* false->indirect_IO,mmap; 1->dio */
 #define SG_FRQ_NO_US_XFER	4	/* no user space transfer of data */
 #define SG_FRQ_DEACT_ORPHAN	7	/* not keeping orphan so de-activate */
+#define SG_FRQ_RECEIVING	8	/* guard against multiple receivers */
 #define SG_FRQ_BLK_PUT_REQ	9	/* set when blk_put_request() called */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
@@ -1325,6 +1326,7 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
 	/* read in part of v3 or v4 header for pack_id or tag based find */
 	id = pack_id;
+try_again:
 	srp = sg_find_srp_by_id(sfp, id);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1339,6 +1341,10 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 		if (res)
 			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	return sg_receive_v4(sfp, srp, p, h4p);
 }
 
@@ -1375,7 +1381,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
-
+try_again:
 	srp = sg_find_srp_by_id(sfp, pack_id);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1390,6 +1396,10 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 	}	/* now srp should be valid */
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	return sg_receive_v3(sfp, srp, p);
 }
 
@@ -1541,6 +1551,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			want_id = h2p->pack_id;
 		}
 	}
+try_again:
 	srp = sg_find_srp_by_id(sfp, want_id);
 	if (!srp) {	/* nothing available so wait on packet to arrive or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
@@ -1556,6 +1567,10 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			return ret;
 		/* otherwise srp should be valid */
 	}
+	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+		cpu_relax();
+		goto try_again;
+	}
 	if (srp->s_hdr3.interface_id == '\0') {
 		ret = sg_read_v1v2(p, (int)count, sfp, srp);
 	} else {
@@ -3549,6 +3564,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 		return;
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
+	srp->frq_bm[0] = 0;
 	sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true /* force */, __func__);
 	/* maybe orphaned req, thus never read */
 	if (sbp)
-- 
2.24.1

