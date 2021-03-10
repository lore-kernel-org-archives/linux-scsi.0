Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC941C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8367D64FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhCJUBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:01:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51658 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhCJUBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:01:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406473; x=1646942473;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dym5/6ZSNO5eq0j1a9Z7Q7QdxSj2G0Kf/twUM2X1wVY=;
  b=uaZM355+Ujp3BAjkMh/jWfq2eLyPD+nuJnfgP9keZBtbYA3w++/xfhc5
   uG9/DbnylHOPHgqHeEFtcV59ZUIseBRVCIbg4Ur2FFguOuU1QBYQX2ALo
   Ppx3CcckolUAhPxkV/CKOlTSC4ULRUAVoz2TRuDdm5k/bj7ApZ3kgBF2v
   ZBBh0W5MDnZqKg322MRwirapYMoxHoq61STvvaFwwTG1u46UqmhdSK2m1
   rJD2VNupT/o+qK+7AHYwhQw2kXcr7h/XquMCRzeL4ZUXBIVxYnGmlHyKJ
   7mv7+GFRfxsdrIhwdWCrbux8gliX5wVL6z3xwm0+AB1Yml58sIUR7uHle
   w==;
IronPort-SDR: oKdym1tJklfbiEZPuJUc760IwpnDXIgxcK1mEl+x8Wyyw5yE/VB6XdcQtH/SZB5ZyJbGpd1KXR
 blO1KMqFzif/FHmhXamZkqLohp0xuAiZO6ROhIvhvFO37QkRdI1OcB3NTp9uuDYCpYxLaT1LLC
 TkN934JH3c67tKJX40VMmqpDnWVXgWuK+xW7XkZAY05jk4/sl05hGVGl/ls8Hn70yNBifQttIx
 L4YYHCPxKZ61x4YYXyAtXjPLM10OJwNQ15AI9GbFyS0wnE9Tx5riAKya1qe7upKI+FE3RuggFU
 E9k=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="47022227"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:01:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:01:02 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:01:02 -0700
Subject: [PATCH V4 03/31] smartpqi: add support for product id
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:01:02 -0600
Message-ID: <161540646236.19430.10915799926681000337.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
index 2886884ad584..f710a803f781 100644
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

