From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 13/15] qla4xxx: remove unwanted check for bad spd
Date: Wed, 6 Oct 2010 22:51:09 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406790@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:39130 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:51:11 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   17 -----------------
 drivers/scsi/qla4xxx/ql4_nx.h |    3 ---
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 66946d8..2dd4d4c 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1080,21 +1080,6 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 	return 0;
 }
 
-static int qla4_8xxx_check_for_bad_spd(struct scsi_qla_host *ha)
-{
-	u32 val = 0;
-	val = qla4_8xxx_rd_32(ha, BOOT_LOADER_DIMM_STATUS) ;
-	val &= QLA82XX_BOOT_LOADER_MN_ISSUE;
-	if (val & QLA82XX_PEG_TUNE_MN_SPD_ZEROED) {
-		printk("Memory DIMM SPD not programmed.  Assumed valid.\n");
-		return 1;
-	} else if (val) {
-		printk("Memory DIMM type incorrect.  Info:%08X.\n", val);
-		return 2;
-	}
-	return 0;
-}
-
 static int
 qla4_8xxx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
 {
@@ -1379,8 +1364,6 @@ static int qla4_8xxx_cmdpeg_ready(struct scsi_qla_host *ha, int pegtune_val)
 
 		} while (--retries);
 
-		qla4_8xxx_check_for_bad_spd(ha);
-
 		if (!retries) {
 			pegtune_val = qla4_8xxx_rd_32(ha,
 				QLA82XX_ROMUSB_GLB_PEGTUNE_DONE);
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 429df5e..a0f7782 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -24,7 +24,6 @@
 
 #define CRB_CMDPEG_STATE		QLA82XX_REG(0x50)
 #define CRB_RCVPEG_STATE		QLA82XX_REG(0x13c)
-#define BOOT_LOADER_DIMM_STATUS		QLA82XX_REG(0x54)
 #define CRB_DMA_SHIFT			QLA82XX_REG(0xcc)
 
 #define QLA82XX_HW_H0_CH_HUB_ADR	0x05
@@ -529,8 +528,6 @@
 # define QLA82XX_CAM_RAM_BASE	(QLA82XX_CRB_CAM + 0x02000)
 # define QLA82XX_CAM_RAM(reg)	(QLA82XX_CAM_RAM_BASE + (reg))
 
-#define QLA82XX_PEG_TUNE_MN_SPD_ZEROED	0x80000000
-#define QLA82XX_BOOT_LOADER_MN_ISSUE	0xff00ffff
 #define QLA82XX_PORT_MODE_ADDR		(QLA82XX_CAM_RAM(0x24))
 #define QLA82XX_PEG_HALT_STATUS1	(QLA82XX_CAM_RAM(0xa8))
 #define QLA82XX_PEG_HALT_STATUS2	(QLA82XX_CAM_RAM(0xac))
-- 
1.6.6

