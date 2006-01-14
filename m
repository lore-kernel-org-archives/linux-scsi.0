From: andrew.vasquez@qlogic.com
Subject: [PATCH 09/15] qla2xxx: Correct swing/emphasis settings for ISP24XX.
Date: Fri, 13 Jan 2006 17:05:32 -0800
Message-ID: <11372007261204-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:3877 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945933AbWANBFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:32 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Swing/emphasis settings in NVRAM were not being honoured due
to the driver not converting the serial-link options from LE
to host-endian format.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

cbbd53fecea341f1b998d3726a5f922e3036204a
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e21316a..49e8315 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1014,11 +1014,13 @@ qla24xx_update_fw_options(scsi_qla_host_
 	int rval;
 
 	/* Update Serial Link options. */
-	if ((ha->fw_seriallink_options24[0] & BIT_0) == 0)
+	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
 
-	rval = qla2x00_set_serdes_params(ha, ha->fw_seriallink_options24[1],
-	    ha->fw_seriallink_options24[2], ha->fw_seriallink_options24[3]);
+	rval = qla2x00_set_serdes_params(ha,
+	    le16_to_cpu(ha->fw_seriallink_options24[1]),
+	    le16_to_cpu(ha->fw_seriallink_options24[2]),
+	    le16_to_cpu(ha->fw_seriallink_options24[3]));
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Unable to update Serial Link options (%x).\n", rval);
-- 
1.1.1-g4c34


