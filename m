From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/16]  qla2xxx: Correct LED scheme definition.
Date: Fri, 26 Aug 2005 19:09:00 -0700 (PDT)
Message-ID: <20050827020900.27275.24334.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:63079 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751615AbVH0CJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:01 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Correct LED scheme definition.

Original implementation used an overloaded bit in the EFI
parameters.  The correct bit is BIT_4 of the special_options
section of NVRAM.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_def.h  |    4 ++--
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

54e2e1934181c71de6b758123c74f397b8e8fb00
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -914,7 +914,7 @@ typedef struct {
 	 * MSB BIT 1 =
 	 * MSB BIT 2 =
 	 * MSB BIT 3 =
-	 * MSB BIT 4 =
+	 * MSB BIT 4 = LED mode
 	 * MSB BIT 5 = enable 50 ohm termination
 	 * MSB BIT 6 = Data Rate (2300 only)
 	 * MSB BIT 7 = Data Rate (2300 only)
@@ -1036,7 +1036,7 @@ typedef struct {
 	 * MSB BIT 1 =
 	 * MSB BIT 2 =
 	 * MSB BIT 3 =
-	 * MSB BIT 4 =
+	 * MSB BIT 4 = LED mode
 	 * MSB BIT 5 = enable 50 ohm termination
 	 * MSB BIT 6 = Data Rate (2300 only)
 	 * MSB BIT 7 = Data Rate (2300 only)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1568,7 +1568,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	ha->flags.enable_lip_reset = ((nv->host_p[1] & BIT_1) ? 1 : 0);
 	ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
 	ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);
-	ha->flags.enable_led_scheme = ((nv->efi_parameters & BIT_3) ? 1 : 0);
+	ha->flags.enable_led_scheme = (nv->special_options[1] & BIT_4) ? 1 : 0;
 
 	ha->operating_mode =
 	    (icb->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) >> 4;

-- 
Andrew Vasquez
