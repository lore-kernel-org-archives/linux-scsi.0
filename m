From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/11] [SYM2] Remove last vestiges of sym_sniff_inquiry
Date: Tue, 29 Nov 2005 23:08:29 -0500 (EST)
Message-ID: <20051130040829.A859D7626E@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:54718 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750839AbVK3EIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:34 -0500
Received: from mail2.magma.ca (mail2.magma.ca [206.191.0.214])
	by mx2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48Xqp014231
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:34 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48TQV002523
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:33 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The SYM_OPT_SNIFF_INQUIRY define is never set any more, and the
sym_sniff_inquiry() function doesn't exist

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

applies-to: 7657ff9db89cd74775d5b3caf4042076c31480fd
202ebf1182030b892cfd8ae48389eb4504c0b606
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index d3d52f1..c61c23f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -268,6 +268,5 @@ void sym_xpt_async_bus_reset(struct sym_
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
 void sym_log_bus_error(struct sym_hcb *np);
-void sym_sniff_inquiry(struct sym_hcb *np, struct scsi_cmnd *cmd, int resid);
 
 #endif /* SYM_GLUE_H */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a7420ca..113e3b3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5551,15 +5551,6 @@ if (resid)
 	 */
 	sym_set_cam_result_ok(cp, cmd, resid);
 
-#ifdef	SYM_OPT_SNIFF_INQUIRY
-	/*
-	 *  On standard INQUIRY response (EVPD and CmDt 
-	 *  not set), sniff out device capabilities.
-	 */
-	if (cp->cdb_buf[0] == INQUIRY && !(cp->cdb_buf[1] & 0x3))
-		sym_sniff_inquiry(np, cmd, resid);
-#endif
-
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	/*
 	 *  If max number of started ccbs had been reduced,
---
0.99.9.GIT
