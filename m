From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH]  qla2xxx: Add firmware version number to qla24xx_fw_version_str().
Date: Fri, 8 Jul 2005 17:58:43 -0700
Message-ID: <20050709005842.GH24126@plap.qlogic.org>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com> <20050709005626.GG24126@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28530 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263063AbVGIA6p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 20:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20050709005626.GG24126@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add firmware version number to qla24xx_fw_version_str().

Original code was accidently trimmed during port.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

21fad7fa5cb535355f128fc0459a2de79f1975be
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -317,6 +317,10 @@ qla2x00_fw_version_str(struct scsi_qla_h
 char *
 qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
+	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
+	    ha->fw_minor_version,
+	    ha->fw_subminor_version);
+
 	if (ha->fw_attributes & BIT_0)
 		strcat(str, "[Class 2] ");
 	if (ha->fw_attributes & BIT_1)
@@ -326,7 +330,6 @@ qla24xx_fw_version_str(struct scsi_qla_h
 	if (ha->fw_attributes & BIT_13)
 		strcat(str, "[Experimental]");
 	return str;
-
 }
 
 static inline srb_t *
------------
