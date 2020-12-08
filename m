Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51304C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA5923B1A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgLHVG3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:06:29 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:62372 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHVG1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607461586; x=1638997586;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sEiAodSF5h6RWBEkpXfCRMMnzVx5hcszxvTEhuu/XlY=;
  b=jVjEP40NVkpTiiRuAaphhF9Z6DIKdF8A5b1J+iYEn+O1eMHP4qUi4W6M
   CLoXaHOM+TQ7V1b7AXGumGKWXCwZXzlfgyraLI8iJ7v/FIaxksmWqPclk
   +5fQTLL69jzuUnHl5pXP0bBmdhIfvYdJ0cE4jcH/XZXJrlSM+bIxNjLQT
   swbAxSMCSOJfBQxpc/tz+mz7rVOQHnVYttBmNBiEIULLVXCT/F40uVlii
   Fy/FHqcXXcRf1/W6kZ/Yg9Atb+KvCnDFRvhdjWV0HtIDQiRlgGs2K+4rA
   APfqC51I2HVBAvBg9t0J1bQVbCokEhZdvd8Zy7iG0KCcwq6vtgzamIWtw
   Q==;
IronPort-SDR: rFpL6NSShswmv0AWQUG3r+YHrIibiLha+bU39aFDX2pCkX0hyQf3f+0+AITafa/eqAuKecKBsl
 BxRIRK/lBOBO6pM0DeveYDyt62Pds4eHvvkiYgSnDrmq2i/YK6ChfeiEHqJ/1nEffy9McPP1So
 DPaVPsr72cmdZXcVf5S5F7z4BTNxYmxViQqbv4B0+Ac1//c6nvNQHHWG7rN0InLF/NGhFGszOY
 DPUcY0xXoBq1aMRkEqk+uqiaRIDdzntT6hw12EE5nv7krdgG77KYi9Ij0dsa/pg5K0WmI51/vb
 VUA=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="36639911"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:36:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:36:41 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:36:40 -0700
Subject: [PATCH V2 01/25] smartpqi: add support for product id
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:36:40 -0600
Message-ID: <160745620079.13450.2594468040754332209.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   11 ++++++++++-
 drivers/scsi/smartpqi/smartpqi_init.c |   11 +++++++++--
 drivers/scsi/smartpqi/smartpqi_sis.c  |    5 +++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 3e54590e6e92..7d3f956e949f 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -79,7 +79,8 @@ struct pqi_ctrl_registers {
 	__le32	sis_ctrl_to_host_doorbell_clear;	/* A0h */
 	u8	reserved4[0xb0 - (0xa0 + sizeof(__le32))];
 	__le32	sis_driver_scratch;			/* B0h */
-	u8	reserved5[0xbc - (0xb0 + sizeof(__le32))];
+	__le32  sis_product_identifier;			/* B4h */
+	u8	reserved5[0xbc - (0xb4 + sizeof(__le32))];
 	__le32	sis_firmware_status;			/* BCh */
 	u8	reserved6[0x1000 - (0xbc + sizeof(__le32))];
 	__le32	sis_mailbox[8];				/* 1000h */
@@ -585,6 +586,7 @@ struct pqi_raid_error_info {
 /* these values are defined by the PQI spec */
 #define PQI_MAX_NUM_ELEMENTS_ADMIN_QUEUE	255
 #define PQI_MAX_NUM_ELEMENTS_OPERATIONAL_QUEUE	65535
+
 #define PQI_QUEUE_ELEMENT_ARRAY_ALIGNMENT	64
 #define PQI_QUEUE_ELEMENT_LENGTH_ALIGNMENT	16
 #define PQI_ADMIN_INDEX_ALIGNMENT		64
@@ -1082,6 +1084,11 @@ struct pqi_event {
 	(PQI_RESERVED_IO_SLOTS_LUN_RESET + PQI_RESERVED_IO_SLOTS_EVENT_ACK + \
 	PQI_RESERVED_IO_SLOTS_SYNCHRONOUS_REQUESTS)
 
+#define PQI_CTRL_PRODUCT_ID_GEN1	0
+#define PQI_CTRL_PRODUCT_ID_GEN2	7
+#define PQI_CTRL_PRODUCT_REVISION_A	0
+#define PQI_CTRL_PRODUCT_REVISION_B	1
+
 struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
@@ -1089,6 +1096,8 @@ struct pqi_ctrl_info {
 	char		serial_number[17];
 	char		model[17];
 	char		vendor[9];
+	u8		product_id;
+	u8		product_revision;
 	void __iomem	*iomem_base;
 	struct pqi_ctrl_registers __iomem *registers;
 	struct pqi_device_registers __iomem *pqi_registers;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c53f456fbd09..68fc4327944e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6259,8 +6259,8 @@ static DEVICE_ATTR(model, 0444, pqi_model_show, NULL);
 static DEVICE_ATTR(serial_number, 0444, pqi_serial_number_show, NULL);
 static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
-static DEVICE_ATTR(lockup_action, 0644,
-	pqi_lockup_action_show, pqi_lockup_action_store);
+static DEVICE_ATTR(lockup_action, 0644, pqi_lockup_action_show,
+	pqi_lockup_action_store);
 
 static struct device_attribute *pqi_shost_attrs[] = {
 	&dev_attr_driver_version,
@@ -7146,6 +7146,7 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
+	u32 product_id;
 
 	if (reset_devices) {
 		sis_soft_reset(ctrl_info);
@@ -7182,6 +7183,10 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
+	product_id = sis_get_product_id(ctrl_info);
+	ctrl_info->product_id = (u8)product_id;
+	ctrl_info->product_revision = (u8)(product_id >> 8);
+
 	if (reset_devices) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
@@ -8602,6 +8607,8 @@ static void __attribute__((unused)) verify_structures(void)
 		sis_ctrl_to_host_doorbell_clear) != 0xa0);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_driver_scratch) != 0xb0);
+	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
+		sis_product_identifier) != 0xb4);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_firmware_status) != 0xbc);
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 26ea6b9d4199..f0199bd87dd1 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -149,6 +149,11 @@ bool sis_is_kernel_up(struct pqi_ctrl_info *ctrl_info)
 				SIS_CTRL_KERNEL_UP;
 }
 
+u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info)
+{
+	return readl(&ctrl_info->registers->sis_product_identifier);
+}
+
 /* used for passing command parameters/results when issuing SIS commands */
 struct sis_sync_cmd_params {
 	u32	mailbox[6];	/* mailboxes 0-5 */
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 878d34ca6532..12cd2ab1aead 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -27,5 +27,6 @@ int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
 u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
 void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
+u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
 
 #endif	/* _SMARTPQI_SIS_H */

