From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [7/15]  qla2xxx: Firmware options fixes
Date: Thu, 6 May 2004 22:54:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055400.GA4922@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:35833 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263184AbUEGFwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:52:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1928 04/04/30 12:47:27 andrew.vasquez@apc.qlogic.com +1 -0
  Cleanup retrieval and update of firmware options:
  
  	o Update only valid for non-(2[12]00) ISPs.
  	o Instruct firmware to return completed IOCBs without
  	  waiting for an ABTS to complete.

 drivers/scsi/qla2xxx/qla_init.c |   79 +++++++++++++++++++++++++---------------
 1 files changed, 50 insertions(+), 29 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:14:42 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:14:42 2004
@@ -772,6 +772,54 @@
 }
 
 /**
+ * qla2x00_update_fw_options() - Read and process firmware options.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static void
+qla2x00_update_fw_options(scsi_qla_host_t *ha)
+{
+	/* Setup seriallink options */
+	uint16_t swing, emphasis;
+
+	memset(ha->fw_options, 0, sizeof(ha->fw_options));
+	qla2x00_get_fw_options(ha, ha->fw_options);
+
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return;
+
+	/* Serial Link options. */
+	DEBUG3(printk("scsi(%ld): Serial link options:\n",
+	    ha->host_no));
+	DEBUG3(qla2x00_dump_buffer((uint8_t *)&ha->fw_seriallink_options,
+	    sizeof(ha->fw_seriallink_options)));
+
+	ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
+	if (ha->fw_seriallink_options[1] & BIT_2)
+		ha->fw_options[1] |= FO1_SET_EMPHASIS_SWING;
+
+	/*  1G settings */
+	swing = ha->fw_seriallink_options[0] & (BIT_2 | BIT_1 | BIT_0);
+	emphasis = ha->fw_seriallink_options[0] & (BIT_4 | BIT_3);
+	emphasis >>= 3;
+	ha->fw_options[10] = (emphasis << 14) | (swing << 8) | 0x3;
+
+	/*  2G settings */
+	swing = ha->fw_seriallink_options[0] & (BIT_7 | BIT_6 | BIT_5);
+	swing >>= 5;
+	emphasis = ha->fw_seriallink_options[1] & (BIT_1 | BIT_0);
+	ha->fw_options[11] = (emphasis << 14) | (swing << 8) | 0x3;
+
+	/* FCP2 options. */
+	/*  Return command IOCBs without waiting for an ABTS to complete. */
+	ha->fw_options[3] |= BIT_13;
+
+	/* Update Serial Link options. */
+	qla2x00_set_fw_options(ha, ha->fw_options);
+}
+
+/**
  * qla2x00_init_rings() - Initializes firmware.
  * @ha: HA context
  *
@@ -824,35 +872,8 @@
 		DEBUG2_3(printk("scsi(%ld): Init firmware **** FAILED ****.\n",
 		    ha->host_no));
 	} else {
-		/* Setup seriallink options */
-		uint16_t swing, emphasis;
-
-		DEBUG3(printk("scsi(%ld): Serial link options:\n",
-		    ha->host_no));
-		DEBUG3(qla2x00_dump_buffer(
-		    (uint8_t *)&ha->fw_seriallink_options,
-		    sizeof(ha->fw_seriallink_options)));
-
-		memset(ha->fw_options, 0, sizeof(ha->fw_options));
-		qla2x00_get_fw_options(ha, ha->fw_options);
-
-		ha->fw_options[1] &= ~FO1_SET_EMPHASIS_SWING;
-		if (ha->fw_seriallink_options[1] & BIT_2)
-			ha->fw_options[1] |= FO1_SET_EMPHASIS_SWING;
-
-		/* 1G settings */
-		swing = ha->fw_seriallink_options[0] & (BIT_2 | BIT_1 | BIT_0);
-		emphasis = ha->fw_seriallink_options[0] & (BIT_4 | BIT_3);
-		emphasis >>= 3;
-		ha->fw_options[10] = (emphasis << 14) | (swing << 8) | 0x3;
-
-		/* 2G settings */
-		swing = ha->fw_seriallink_options[0] & (BIT_7 | BIT_6 | BIT_5);
-		swing >>= 5;
-		emphasis = ha->fw_seriallink_options[1] & (BIT_1 | BIT_0);
-		ha->fw_options[11] = (emphasis << 14) | (swing << 8) | 0x3;
-
-		qla2x00_set_fw_options(ha, ha->fw_options);
+		/* Update any ISP specific firmware options. */
+		qla2x00_update_fw_options(ha);
 
 		DEBUG3(printk("scsi(%ld): Init firmware -- success.\n",
 		    ha->host_no));
