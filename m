From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/9] qla1280: always load microcode
Date: Mon, 4 Jul 2005 17:48:46 +0200
Message-ID: <20050704154846.GG30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54988 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261329AbVGDPsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

we have the most recent microcode, make sure to always load it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-26 16:58:46.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-26 16:58:55.000000000 +0200
@@ -1733,69 +1733,6 @@
 	return status;
 }
 
-
-/*
- * ISP Firmware Test
- *      Checks if present version of RISC firmware is older than
- *      driver firmware.
- *
- * Input:
- *      ha = adapter block pointer.
- *
- * Returns:
- *      0 = firmware does not need to be loaded.
- */
-static int
-qla1280_isp_firmware(struct scsi_qla_host *ha)
-{
-	struct nvram *nv = (struct nvram *) ha->response_ring;
-	int status = 0;		/* dg 2/27 always loads RISC */
-	uint16_t mb[MAILBOX_REGISTER_COUNT];
-
-	ENTER("qla1280_isp_firmware");
-
-	dprintk(1, "scsi(%li): Determining if RISC is loaded\n", ha->host_no);
-
-	/* Bad NVRAM data, load RISC code. */
-	if (!ha->nvram_valid) {
-		ha->flags.disable_risc_code_load = 0;
-	} else
-		ha->flags.disable_risc_code_load =
-			nv->cntr_flags_1.disable_loading_risc_code;
-
-	if (ha->flags.disable_risc_code_load) {
-		dprintk(3, "qla1280_isp_firmware: Telling RISC to verify "
-			"checksum of loaded BIOS code.\n");
-
-		/* Verify checksum of loaded RISC code. */
-		mb[0] = MBC_VERIFY_CHECKSUM;
-		/* mb[1] = ql12_risc_code_addr01; */
-		mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
-
-		if (!(status =
-		      qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]))) {
-			/* Start firmware execution. */
-			dprintk(3, "qla1280_isp_firmware: Startng F/W "
-				"execution.\n");
-
-			mb[0] = MBC_EXECUTE_FIRMWARE;
-			/* mb[1] = ql12_risc_code_addr01; */
-			mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
-			qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
-		} else
-			printk(KERN_INFO "qla1280: RISC checksum failed.\n");
-	} else {
-		dprintk(1, "qla1280: NVRAM configured to load RISC load.\n");
-		status = 1;
-	}
-
-	if (status)
-		dprintk(2, "qla1280_isp_firmware: **** Load RISC code ****\n");
-
-	LEAVE("qla1280_isp_firmware");
-	return status;
-}
-
 /*
  * Chip diagnostics
  *      Test chip for proper operation.
@@ -2080,14 +2017,7 @@
 static int
 qla1280_load_firmware(struct scsi_qla_host *ha)
 {
-	int err = -ENODEV;
-
-	/* If firmware needs to be loaded */
-	if (!qla1280_isp_firmware(ha)) {
-		printk(KERN_ERR "scsi(%li): isp_firmware() failed!\n",
-				ha->host_no);
-		goto out;
-	}
+	int err;
 
 	err = qla1280_chip_diag(ha);
 	if (err)
