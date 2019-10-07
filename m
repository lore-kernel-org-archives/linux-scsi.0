Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5F8ECE58C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EAA02133F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfJGWbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:31:37 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:54449 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:31:37 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: jwiZ99ShmZ8pLyWqb8V0PXiK+raa4hn2dCd0J/+64o5kSI4CTl7zcRVe4t7O2NHvQ2K2Ctd6So
 bKWKK0VRE5mXDTGYvZ1NmpCT2wVQPx9ZAeAOj1ft2iE0KP1SgfXLUDNRqlkAmuQVUZsHPKHDzd
 YFK6MQNK6GVofBJvGeq/VS1NmAfBMOpVrJrXKYGxQzBDODCBbePw54h6KJ5p0aqpCHHssVQqbo
 t79SBskEz5AMdLgCNdfZVdxlEch5WDyHKV4DM3FhuPXsNNcddWe8GIP3GOC2mUnZCQMhtiE+Rp
 Q98=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="50540779"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:31:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:34 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:34 -0700
Subject: [PATCH 03/10] smartpqi: add inquiry timeouts
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:34 -0500
Message-ID: <157048749461.11757.10013040278241807855.stgit@brunhilda>
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda>
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: koshyaji <ajish.koshy@microsemi.com>

- add timeout field in RAID IU

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: koshyaji <ajish.koshy@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    6 +++++-
 drivers/scsi/smartpqi/smartpqi_init.c |   34 +++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 2aa81b22f269..af0662b8a09c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -276,7 +276,9 @@ struct pqi_raid_path_request {
 	u8	reserved4 : 2;
 	u8	additional_cdb_bytes_usage : 3;
 	u8	reserved5 : 3;
-	u8	cdb[32];
+	u8	cdb[16];
+	u8	reserved6[12];
+	__le32	timeout;
 	struct pqi_sg_descriptor
 		sg_descriptors[PQI_MAX_EMBEDDED_SG_DESCRIPTORS];
 };
@@ -761,6 +763,7 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_OFA			0
 #define PQI_FIRMWARE_FEATURE_SMP			1
 #define PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE	11
+#define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT		13
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1138,6 +1141,7 @@ struct pqi_ctrl_info {
 	u8		pqi_mode_enabled : 1;
 	u8		pqi_reset_quiesce_supported : 1;
 	u8		soft_reset_handshake_supported : 1;
+	u8		raid_iu_timeout_supported: 1;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 793793343950..197d2f4ae34c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6101,6 +6101,9 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
 
 	put_unaligned_le16(iu_length, &request.header.iu_length);
 
+	if (ctrl_info->raid_iu_timeout_supported)
+		put_unaligned_le32(iocommand.Request.Timeout, &request.timeout);
+
 	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header,
 		PQI_SYNC_FLAGS_INTERRUPTABLE, &pqi_error_info, NO_TIMEOUT);
 
@@ -6880,6 +6883,23 @@ static void pqi_firmware_feature_status(struct pqi_ctrl_info *ctrl_info,
 		firmware_feature->feature_name);
 }
 
+static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
+	struct pqi_firmware_feature *firmware_feature)
+{
+	switch (firmware_feature->feature_bit) {
+	case PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE:
+		ctrl_info->soft_reset_handshake_supported =
+			firmware_feature->enabled;
+		break;
+	case PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT:
+		ctrl_info->raid_iu_timeout_supported =
+			firmware_feature->enabled;
+		break;
+	}
+
+	pqi_firmware_feature_status(ctrl_info, firmware_feature);
+}
+
 static inline void pqi_firmware_feature_update(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_firmware_feature *firmware_feature)
 {
@@ -6903,7 +6923,12 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 	{
 		.feature_name = "New Soft Reset Handshake",
 		.feature_bit = PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE,
-		.feature_status = pqi_firmware_feature_status,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
+	{
+		.feature_name = "RAID IU Timeout",
+		.feature_bit = PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT,
+		.feature_status = pqi_ctrl_update_feature_flags,
 	},
 };
 
@@ -6957,7 +6982,6 @@ static void pqi_process_firmware_features(
 		return;
 	}
 
-	ctrl_info->soft_reset_handshake_supported = false;
 	for (i = 0; i < ARRAY_SIZE(pqi_firmware_features); i++) {
 		if (!pqi_firmware_features[i].supported)
 			continue;
@@ -6965,10 +6989,6 @@ static void pqi_process_firmware_features(
 			firmware_features_iomem_addr,
 			pqi_firmware_features[i].feature_bit)) {
 			pqi_firmware_features[i].enabled = true;
-			if (pqi_firmware_features[i].feature_bit ==
-			    PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE)
-				ctrl_info->soft_reset_handshake_supported =
-									true;
 		}
 		pqi_firmware_feature_update(ctrl_info,
 			&pqi_firmware_features[i]);
@@ -8773,6 +8793,8 @@ static void __attribute__((unused)) verify_structures(void)
 		error_index) != 27);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		cdb) != 32);
+	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
+		timeout) != 60);
 	BUILD_BUG_ON(offsetof(struct pqi_raid_path_request,
 		sg_descriptors) != 64);
 	BUILD_BUG_ON(sizeof(struct pqi_raid_path_request) !=

