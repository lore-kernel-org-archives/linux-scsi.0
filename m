Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A63C47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71F3206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfJGWby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:31:54 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17294 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:31:54 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: YspnUP7MqO8sGaQ5Ds4sbaPDLuH64TvPulc72UOmtt8fciDU2/X3ALMDk6iA/Peqcfq467UW5U
 jixipIIFwsrk7WLJDpvGoMYuL7t47lNHgHyfqihc8q3u+0jIPvAepz9HJ5m+AUBDu1dkxPKR5y
 BWTS3Vw3E4u677re+L34mkWSnhac4iZ+gOAo/kFMoy1C2eMY4/IoWytjhR9gZMiUeTMhFDzIit
 mgjofGL2L5sY/jLGvnKFJwmrjL0AY/DhhUXem0+BTzFnGqo2fYqqm7H+M+HN5gG8aaSNygKaya
 o1E=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="49125677"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:31:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:41 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:41 -0700
Subject: [PATCH 04/10] smartpqi: fix LUN reset when fw bkgnd thread is hung
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:40 -0500
Message-ID: <157048750055.11757.9689400788261610618.stgit@brunhilda>
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

From: Murthy Bhat <Murthy.Bhat@microsemi.com>

- add support for a timeout on LUN resets.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    5 ++++-
 drivers/scsi/smartpqi/smartpqi_init.c |   21 ++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index af0662b8a09c..c09d48366d38 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -387,7 +387,8 @@ struct pqi_task_management_request {
 	struct pqi_iu_header header;
 	__le16	request_id;
 	__le16	nexus_id;
-	u8	reserved[4];
+	u8	reserved[2];
+	__le16  timeout;
 	u8	lun_number[8];
 	__le16	protocol_specific;
 	__le16	outbound_queue_id_to_manage;
@@ -764,6 +765,7 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_SMP			1
 #define PQI_FIRMWARE_FEATURE_SOFT_RESET_HANDSHAKE	11
 #define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT		13
+#define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT		14
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
@@ -1142,6 +1144,7 @@ struct pqi_ctrl_info {
 	u8		pqi_reset_quiesce_supported : 1;
 	u8		soft_reset_handshake_supported : 1;
 	u8		raid_iu_timeout_supported: 1;
+	u8		tmf_iu_timeout_supported: 1;
 
 	struct list_head scsi_device_list;
 	spinlock_t	scsi_device_list_lock;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 197d2f4ae34c..6abd51d57ad7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5693,7 +5693,8 @@ static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 	complete(waiting);
 }
 
-#define PQI_LUN_RESET_TIMEOUT_SECS	10
+#define PQI_LUN_RESET_TIMEOUT_SECS	60
+#define PQI_LUN_RESET_POLL_COMPLETION_SECS	10
 
 static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct completion *wait)
@@ -5702,7 +5703,7 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 
 	while (1) {
 		if (wait_for_completion_io_timeout(wait,
-			PQI_LUN_RESET_TIMEOUT_SECS * PQI_HZ)) {
+			PQI_LUN_RESET_POLL_COMPLETION_SECS * PQI_HZ)) {
 			rc = 0;
 			break;
 		}
@@ -5739,6 +5740,9 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	memcpy(request->lun_number, device->scsi3addr,
 		sizeof(request->lun_number));
 	request->task_management_function = SOP_TASK_MANAGEMENT_LUN_RESET;
+	if (ctrl_info->tmf_iu_timeout_supported)
+		put_unaligned_le16(PQI_LUN_RESET_TIMEOUT_SECS,
+					&request->timeout);
 
 	pqi_start_io(ctrl_info,
 		&ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
@@ -5768,7 +5772,7 @@ static int _pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 
 	for (retries = 0;;) {
 		rc = pqi_lun_reset(ctrl_info, device);
-		if (rc != -EAGAIN || ++retries > PQI_LUN_RESET_RETRIES)
+		if (rc == 0 || ++retries > PQI_LUN_RESET_RETRIES)
 			break;
 		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
 	}
@@ -6895,6 +6899,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
 		ctrl_info->raid_iu_timeout_supported =
 			firmware_feature->enabled;
 		break;
+	case PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT:
+		ctrl_info->tmf_iu_timeout_supported =
+			firmware_feature->enabled;
+		break;
 	}
 
 	pqi_firmware_feature_status(ctrl_info, firmware_feature);
@@ -6930,6 +6938,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "TMF IU Timeout",
+		.feature_bit = PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT,
+		.feature_status = pqi_ctrl_update_feature_flags,
+	},
 };
 
 static void pqi_process_firmware_features(
@@ -8949,6 +8962,8 @@ static void __attribute__((unused)) verify_structures(void)
 		request_id) != 8);
 	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
 		nexus_id) != 10);
+	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
+		timeout) != 14);
 	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,
 		lun_number) != 16);
 	BUILD_BUG_ON(offsetof(struct pqi_task_management_request,

