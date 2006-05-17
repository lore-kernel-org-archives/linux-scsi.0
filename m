From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/15] qla2xxx: Correct endianess comparisons during ISP24xx NVRAM configuration.
Date: Wed, 17 May 2006 15:09:11 -0700
Message-ID: <11479037461703-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:17081 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751210AbWEQWJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:12 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

c91de8e20ac9fdd9bf80fa806365026f1b68604e
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

c91de8e20ac9fdd9bf80fa806365026f1b68604e
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1289a18..7a5d52f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3371,7 +3371,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 		strcpy(ha->model_number, "QLA2462");
 
 	/* Prepare nodename */
-	if ((icb->firmware_options_1 & BIT_14) == 0) {
+	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
 		/*
 		 * Firmware will apply the following mask if the nodename was
 		 * not provided.
@@ -3387,8 +3387,8 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	ha->flags.enable_target_reset = 1;
 	ha->flags.enable_led_scheme = 0;
 
-	ha->operating_mode =
-	    (icb->firmware_options_2 & (BIT_6 | BIT_5 | BIT_4)) >> 4;
+	ha->operating_mode = (le32_to_cpu(icb->firmware_options_2) &
+	    (BIT_6 | BIT_5 | BIT_4)) >> 4;
 
 	memcpy(ha->fw_seriallink_options24, nv->seriallink_options,
 	    sizeof(ha->fw_seriallink_options24));
-- 
1.3.3.g63df


