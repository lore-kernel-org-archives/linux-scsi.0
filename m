Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10168C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC96064F8D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhCKUPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:63181 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCKUPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:15:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493711; x=1647029711;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wQPK9ydBdOH4t07UKcUESbinqkmD1c2i56DOpOcoUC0=;
  b=SSrU+IUsifAg8kGU4C3VSLBAx6GyDgLpQJMHVHMMcsNtx4A5AvhqCErl
   djrWNWJE9/mPT0YKML3/+elwIA281pLepT2GyG0RbXZsnDmp4SyrT2Qvs
   I/DW7b5R4EA9R1IhAFnLhdek58yNJTQX2I503oMD3NUaWORpu7q3Ku6J3
   SrRzF9/F8Pi1j2hDZHPRM4HjceRMNpC5tBS7mgCLfTxLeQhir81nKxOYi
   E5bMfbVhvzaUFivoYi7HG4VKN1dwj1aC1PT968RtQR7h7VO1EWfXnGsVT
   AiyLUOiCWjpDHbXm3lfgNqmdns4iWwOJchzXBuU7a0YI1jVQ8YFhBYJ18
   A==;
IronPort-SDR: 5mSrbn7NBofvShlhOyEPbZSK06DNWe0YPzcvV1DWxr+SSotBMiaKSg8uANu2jwUAri1Upj+A8Q
 HCq0qqr7HIiTjRAL08ptMWSf23AiUADmeOh769EfY2yFFgJk4lnjHci7y6sjMFZ/GDf8auJOG3
 H0bp6Kba3H/DumppWydekLP1Ctzg0a5kNgP4sOFOIbfJOm5lAoaZpZ18FAmX8ZfxG6k4qO8NoA
 eM2Rmx51oXDtpNiVeGhhR7/WKS0UlZbeWOwPglRC6gt1VBNR3qjABcaA4108lugrAJFct7RsAu
 uHg=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112405959"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:15:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:15:10 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:15:09 -0700
Subject: [PATCH V5 03/31] smartpqi: add support for product id
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:15:09 -0600
Message-ID: <161549370966.25025.2968242206975557607.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Add in support for newer HW by adding in a
product identifier. This identifier can then be used
to check for the hardware generation.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   11 ++++++++++-
 drivers/scsi/smartpqi/smartpqi_init.c |    7 +++++++
 drivers/scsi/smartpqi/smartpqi_sis.c  |    5 +++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
 4 files changed, 23 insertions(+), 1 deletion(-)

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
index 4533085c4de6..f388ef36cb3f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7151,6 +7151,7 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
+	u32 product_id;
 
 	if (reset_devices) {
 		sis_soft_reset(ctrl_info);
@@ -7187,6 +7188,10 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
+	product_id = sis_get_product_id(ctrl_info);
+	ctrl_info->product_id = (u8)product_id;
+	ctrl_info->product_revision = (u8)(product_id >> 8);
+
 	if (reset_devices) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
@@ -8607,6 +8612,8 @@ static void __attribute__((unused)) verify_structures(void)
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

