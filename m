From: David Caldwell <david@porkrind.org>
Subject: [PATCH] Reimplement the SG_FLAG_LUN_INHIBIT flag in sg's SG_IOCTL.
Date: Fri, 16 Dec 2005 13:54:51 -0800
Message-ID: <20051216215447.GA25090@porkrind.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-67-49-70-252.socal.res.rr.com ([67.49.70.252]:33006 "EHLO
	death.porkrind.org") by vger.kernel.org with ESMTP id S932507AbVLPVyz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2005 16:54:55 -0500
Received: from death.porkrind.org (localhost [127.0.0.1])
	by death.porkrind.org (8.13.5/8.13.5/Debian-3) with ESMTP id jBGLsps4025250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 16 Dec 2005 13:54:51 -0800
Received: (from david@localhost)
	by death.porkrind.org (8.13.5/8.13.5/Submit) id jBGLspvg025249
	for linux-scsi@vger.kernel.org; Fri, 16 Dec 2005 13:54:51 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi.c will normally overwrite the second byte of the command with the
appropriate LUN info if the device is a SCSI 2 device. I have a device
that uses the second byte of the cdb for something other than the LUN
(yes, it is a stupid broken device). This flag allows such broken
devices work.

Signed-off-by: David Caldwell <david@porkrind.org>

---

 drivers/scsi/scsi.c         |    3 ++-
 drivers/scsi/sg.c           |    1 +
 include/scsi/scsi_request.h |    1 +
 include/scsi/sg.h           |    2 +-
 4 files changed, 5 insertions(+), 2 deletions(-)

a1c5985460e92ae1262b411b26b095a0af8aa7b7
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 180676d..55506ff 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -567,7 +567,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
-	if (cmd->device->scsi_level <= SCSI_2) {
+	if (cmd->device->scsi_level <= SCSI_2 &&
+	    !(cmd->sc_request && cmd->sc_request->sr_dont_stomp_lun)) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
 	}
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b55c2a8..2441630 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -755,6 +755,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		SRpnt->sr_data_direction = DMA_NONE;
 		break;
 	}
+	SRpnt->sr_dont_stomp_lun = !!(hp->flags & SG_FLAG_LUN_INHIBIT);
 	SRpnt->upper_private_data = srp;
 	srp->data.k_use_sg = 0;
 	srp->data.sglist_len = 0;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index 98d69fd..f8257f9 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -39,6 +39,7 @@ struct scsi_request {
 	int sr_timeout_per_command;
 	unsigned short sr_use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sr_sglist_len;	/* size of malloc'd scatter-gather list */
+	int sr_dont_stomp_lun;	/* Set to 1 to leave sr_cmnd[1] unmolested */
 	unsigned sr_underflow;	/* Return error if less than
 				   this amount is transferred */
  	void *upper_private_data;	/* reserved for owner (usually upper
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 0a487fe..6151e9c 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -139,7 +139,7 @@ typedef struct sg_io_hdr
 
 /* following flag values can be "or"-ed together */
 #define SG_FLAG_DIRECT_IO 1     /* default is indirect IO */
-#define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
+#define SG_FLAG_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
-- 
0.99.9l
