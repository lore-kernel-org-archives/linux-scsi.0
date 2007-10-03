From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 09/21] advansys: Merge ASC_IERR definitions
Date: Tue,  2 Oct 2007 21:55:30 -0400
Message-ID: <11913765422893-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:55216 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXJCBzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:47 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

There were two blocks of ASC_IERR definitions; one for narrow and one for
wide boards.  Some of the same names were used (with the same values),
and some of the same values were used with different names.  This could
only lead to confusion, so I unified them in one block of definitions
with no overlapping values.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ad9639d..4c792db 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -459,14 +459,22 @@ typedef struct asc_risc_sg_list_q {
 #define ASC_WARN_CFG_MSW_RECOVER      0x0040
 
 /*
- * Error code values are set in ASC_DVC_VAR  'err_code'.
- */
-#define ASC_IERR_MCODE_CHKSUM         0x0002
-#define ASC_IERR_SET_PC_ADDR          0x0004
-#define ASC_IERR_START_STOP_CHIP      0x0008
-#define ASC_IERR_SET_SCSI_ID          0x0080
-#define ASC_IERR_BAD_SIGNATURE        0x0200
-#define ASC_IERR_NO_BUS_TYPE          0x0400
+ * Error code values are set in {ASC/ADV}_DVC_VAR  'err_code'.
+ */
+#define ASC_IERR_NO_CARRIER		0x0001	/* No more carrier memory */
+#define ASC_IERR_MCODE_CHKSUM		0x0002	/* micro code check sum error */
+#define ASC_IERR_SET_PC_ADDR		0x0004
+#define ASC_IERR_START_STOP_CHIP	0x0008	/* start/stop chip failed */
+#define ASC_IERR_ILLEGAL_CONNECTION	0x0010	/* Illegal cable connection */
+#define ASC_IERR_SINGLE_END_DEVICE	0x0020	/* SE device on DIFF bus */
+#define ASC_IERR_REVERSED_CABLE		0x0040	/* Narrow flat cable reversed */
+#define ASC_IERR_SET_SCSI_ID		0x0080	/* set SCSI ID failed */
+#define ASC_IERR_HVD_DEVICE		0x0100	/* HVD device on LVD port */
+#define ASC_IERR_BAD_SIGNATURE		0x0200	/* signature not found */
+#define ASC_IERR_NO_BUS_TYPE		0x0400
+#define ASC_IERR_BIST_PRE_TEST		0x0800	/* BIST pre-test error */
+#define ASC_IERR_BIST_RAM_TEST		0x1000	/* BIST RAM test error */
+#define ASC_IERR_BAD_CHIPTYPE		0x2000	/* Invalid chip_type setting */
 
 #define ASC_DEF_MAX_TOTAL_QNG   (0xF0)
 #define ASC_MIN_TAG_Q_PER_DVC   (0x04)
@@ -1698,22 +1706,6 @@ typedef struct adveep_38C1600_config {
 #define ADV_MAX_LUN                     7	/* max. logical unit number */
 
 /*
- * Error code values are set in ADV_DVC_VAR 'err_code'.
- */
-#define ASC_IERR_MCODE_CHKSUM       0x0002	/* micro code check sum error */
-#define ASC_IERR_NO_CARRIER         0x0004	/* No more carrier memory. */
-#define ASC_IERR_START_STOP_CHIP    0x0008	/* start/stop chip failed */
-#define ASC_IERR_SET_SCSI_ID        0x0080	/* set SCSI ID failed */
-#define ASC_IERR_HVD_DEVICE         0x0100	/* HVD attached to LVD connector. */
-#define ASC_IERR_BAD_SIGNATURE      0x0200	/* signature not found */
-#define ASC_IERR_ILLEGAL_CONNECTION 0x0400	/* Illegal cable connection */
-#define ASC_IERR_SINGLE_END_DEVICE  0x0800	/* Single-end used w/differential */
-#define ASC_IERR_REVERSED_CABLE     0x1000	/* Narrow flat cable reversed */
-#define ASC_IERR_BIST_PRE_TEST      0x2000	/* BIST pre-test error */
-#define ASC_IERR_BIST_RAM_TEST      0x4000	/* BIST RAM test error */
-#define ASC_IERR_BAD_CHIPTYPE       0x8000	/* Invalid 'chip_type' setting. */
-
-/*
  * Fixed locations of microcode operating variables.
  */
 #define ASC_MC_CODE_BEGIN_ADDR          0x0028	/* microcode start address */
-- 
1.5.3.1

