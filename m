From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/6] qla2xxx: Honour "Extended BB credits" bit for CNAs.
Date: Fri, 19 Mar 2010 16:59:16 -0700
Message-ID: <1269043161-2265-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46292 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751978Ab0CSX7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:23 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

We now enable/disable "Additional Receive Credits" in f/w based on nvram
parameter "Extended_BB_Credits" bit (i.e. Enhanced-Features: at offset 0x196).
This is applicable only for GEN2 CNAs.

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h  |   18 +++++++++++++++---
 drivers/scsi/qla2xxx/qla_mbx.c |    8 +++++++-
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index cebf4f1..42c5587 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1592,10 +1592,22 @@ struct nvram_81xx {
 
 	/* Offset 384. */
 	uint8_t reserved_21[16];
-	uint16_t reserved_22[8];
+	uint16_t reserved_22[3];
+
+	/*
+	 * BIT 0 = Extended BB credits for LR
+	 * BIT 1 = Virtual Fabric Enable
+	 * BIT 2 = Enhanced Features Unused
+	 * BIT 3-7 = Enhanced Features Reserved
+	 */
+	/* Enhanced Features */
+	uint8_t enhanced_features;
+
+	uint8_t reserved_23;
+	uint16_t reserved_24[4];
 
 	/* Offset 416. */
-	uint16_t reserved_23[32];
+	uint16_t reserved_25[32];
 
 	/* Offset 480. */
 	uint8_t model_name[16];
@@ -1603,7 +1615,7 @@ struct nvram_81xx {
 	/* Offset 496. */
 	uint16_t feature_mask_l;
 	uint16_t feature_mask_h;
-	uint16_t reserved_24[2];
+	uint16_t reserved_26[2];
 
 	uint16_t subsystem_vendor_id;
 	uint16_t subsystem_device_id;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6e53bdb..3ba9a2b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -339,6 +339,7 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 	return rval;
 }
 
+#define	EXTENDED_BB_CREDITS	BIT_0
 /*
  * qla2x00_execute_fw
  *     Start adapter firmware.
@@ -371,7 +372,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
-		mcp->mb[4] = 0;
+		if (IS_QLA81XX(ha)) {
+			struct nvram_81xx *nv = ha->nvram;
+			mcp->mb[4] = (nv->enhanced_features &
+			    EXTENDED_BB_CREDITS);
+		} else
+			mcp->mb[4] = 0;
 		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
 		mcp->in_mb |= MBX_1;
 	} else {
-- 
1.6.2.rc1.30.gd43c

