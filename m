From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH 1/6] pm80xx : redefine sas_identify_frame structure
Date: Fri, 30 Jan 2015 11:36:40 +0530
Message-ID: <20150130060645.23653-2-Viswas.G@microsemi.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03hn0222.outbound.protection.outlook.com ([104.47.40.222]:15264
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755771AbdHYRMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 13:12:00 -0400
In-Reply-To: <20150130060645.23653-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com

sas_identify structure defined by pm80xx doesn't have CRC field.
So added a new sas_identify structure without CRC.

Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
 drivers/scsi/pm8001/pm8001_sas.h | 95 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 3 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index e4867e690c84..f4331afe9b0b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -157,7 +157,7 @@ struct mpi_msg_hdr{
 struct phy_start_req {
 	__le32	tag;
 	__le32	ase_sh_lm_slr_phyid;
-	struct sas_identify_frame sas_identify;
+	struct sas_identify_frame_local sas_identify;
 	u32	reserved[5];
 } __attribute__((packed, aligned(4)));
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index e81a8fa7ef1a..2e17505ed5b8 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -118,6 +118,101 @@ extern const struct pm8001_dispatch pm8001_80xx_dispatch;
 struct pm8001_hba_info;
 struct pm8001_ccb_info;
 struct pm8001_device;
+#ifdef __LITTLE_ENDIAN_BITFIELD
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  frame_type:4;
+	u8  dev_type:3;
+	u8  _un0:1;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un20:1;
+			u8  smp_iport:1;
+			u8  stp_iport:1;
+			u8  ssp_iport:1;
+			u8  _un247:4;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8  _un30:1;
+			u8 smp_tport:1;
+			u8 stp_tport:1;
+			u8 ssp_tport:1;
+			u8 _un347:4;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+} __packed;
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  _un0:1;
+	u8  dev_type:3;
+	u8  frame_type:4;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un247:4;
+			u8  ssp_iport:1;
+			u8  stp_iport:1;
+			u8  smp_iport:1;
+			u8  _un20:1;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8 _un347:4;
+			u8 ssp_tport:1;
+			u8 stp_tport:1;
+			u8 smp_tport:1;
+			u8 _un30:1;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+} __packed;
+#else
+#error "Bitfield order not defined!"
+#endif
 /* define task management IU */
 struct pm8001_tmf_task {
 	u8	tmf;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 7a443bad6163..1ee2ec210065 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -248,7 +248,7 @@ struct mpi_msg_hdr {
 struct phy_start_req {
 	__le32	tag;
 	__le32	ase_sh_lm_slr_phyid;
-	struct sas_identify_frame sas_identify; /* 28 Bytes */
+	struct sas_identify_frame_local sas_identify; /* 28 Bytes */
 	__le32 spasti;
 	u32	reserved[21];
 } __attribute__((packed, aligned(4)));
-- 
2.12.3
