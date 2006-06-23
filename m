From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/13] qla2xxx: Add NVRAM 'Disable Serdes' bit support.
Date: Fri, 23 Jun 2006 16:10:39 -0700
Message-ID: <11511042342175-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:58031 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1752158AbWFWXKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:10:40 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

The host section of ISP24xx NVRAMs contain a new bit which
allows a user to selectively disable ports of an HBA.  These
ports (hosts) will not be presented to the midlayer.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_fw.h   |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |   13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 653e22e..dfcd3a2 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2044,6 +2044,7 @@ typedef struct scsi_qla_host {
 		uint32_t	enable_led_scheme	:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
+		uint32_t	disable_serdes		:1;
 	} flags;
 
 	atomic_t	loop_state;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 3af4786..af023f5 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -141,7 +141,7 @@ struct nvram_24xx {
 	 * BIT 2  = Enable Memory Map BIOS
 	 * BIT 3  = Enable Selectable Boot
 	 * BIT 4  = Disable RISC code load
-	 * BIT 5  =
+	 * BIT 5  = Disable Serdes
 	 * BIT 6  =
 	 * BIT 7  =
 	 *
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 880de6f..2ccdd84 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -89,6 +89,17 @@ qla2x00_initialize_adapter(scsi_qla_host
 
 	ha->isp_ops.nvram_config(ha);
 
+	if (ha->flags.disable_serdes) {
+		/* Mask HBA via NVRAM settings? */
+		qla_printk(KERN_INFO, ha, "Masking HBA WWPN "
+		    "%02x%02x%02x%02x%02x%02x%02x%02x (via NVRAM).\n",
+		    ha->port_name[0], ha->port_name[1],
+		    ha->port_name[2], ha->port_name[3],
+		    ha->port_name[4], ha->port_name[5],
+		    ha->port_name[6], ha->port_name[7]);
+		return QLA_FUNCTION_FAILED;
+	}
+
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
 	retry = 10;
@@ -1639,6 +1650,7 @@ #endif
 	ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
 	ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);
 	ha->flags.enable_led_scheme = (nv->special_options[1] & BIT_4) ? 1 : 0;
+	ha->flags.disable_serdes = 0;
 
 	ha->operating_mode =
 	    (icb->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) >> 4;
@@ -3450,6 +3462,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	ha->flags.enable_lip_full_login = 1;
 	ha->flags.enable_target_reset = 1;
 	ha->flags.enable_led_scheme = 0;
+	ha->flags.disable_serdes = le32_to_cpu(nv->host_p) & BIT_5 ? 1: 0;
 
 	ha->operating_mode = (le32_to_cpu(icb->firmware_options_2) &
 	    (BIT_6 | BIT_5 | BIT_4)) >> 4;
-- 
1.4.1.rc1.gf603


