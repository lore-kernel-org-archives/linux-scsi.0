Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BCFC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C73B022C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgLDXCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:02:03 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:21231 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgLDXCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122922; x=1638658922;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sEiAodSF5h6RWBEkpXfCRMMnzVx5hcszxvTEhuu/XlY=;
  b=gjNVGGLNA9klCed5ltT+A7+LO2HDCX11KOUW82GSKiRl3SJHY8mhkHfd
   rAiXO2p9j4n/s/XVbf9Bw9OoV5h87l+A+YENL05BdqSAY6hJQb8Qc4g5r
   WGxLebkvULimueDOBdUxAUsucnZDdQTW+e0RnShprbu5/AG14Cg6N8/O8
   zJlaVNmzXi9nFK4c6jfx9sVCmwlWxsqThvLhGSHAk+PUaFhfsDc30pdYL
   Xk0pbo+XwXsYr3P+uWHdhEf0pBl+GHtqPreEyJE9gqpcl5HQu22Pvqtnr
   moCcGoyZOwgyJRpwimsxE07vCLGXmrSDiDi3Cxz8YXTC4NZxcmRwjQNTS
   Q==;
IronPort-SDR: QVWDFXrz+S1hPkb1MveFcT18EccMrvBtOogoiYm9ZkE2OaGdbHlqdagI/3RDjgv380s9JVcEVS
 DTQxtS4M/JgwC8ve4YzGJfklPNqQu/SsAhS6mdm7T1iTM5wr+7x5AqAIDOcmap+IQfJvHOAYzQ
 R2/7Uxc3EcazcRn4OR/vVcipOwBOEzcRJNsOmPlYiWdPKr3+OYTr3jwkoIuhofTexElPflK7+D
 bSJ156jF0uQ8fd7VjiUZhE4kJnOMgxIGtDp5ai6K0fflqJwVYbN6l0HB29Or6fqmUhgfecErwv
 KfU=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="36192742"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:00:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:00:57 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:00:56 -0700
Subject: [PATCH 01/25] smartpqi: add support for product id
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:00:56 -0600
Message-ID: <160712285637.21372.13661852121258610588.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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

