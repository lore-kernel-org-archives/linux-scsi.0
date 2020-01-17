Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2576EC33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE5AA2073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgAQHKy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:54 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:16701 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729299AbgAQHKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:54 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: /2dUEN2r4nYyg/zxnaGwTuoXe1Q4QatsnY+f3Jhosh18OEgnx92Y/8eQQ0gxJaGhZ1JhmLgb4V
 443hUFNb5KXDKrlYopNb3UkCOOR329w+kr1nHbL6PVZMD5j7i3p0v3U0k0Znnh/Bf2YnyM3wPe
 XEVGfN7oez0irah987E5fNZQa1f/UcVjsDKFyRlFP9FIwVqMGIP2PIOVNypVI0ZhhOSQXaevAg
 DfBZyalW4A0AMh+SRV22db9+WE/tQLyonV7PrmZGRdM6wpnxY5+Gj4y/t0dVdhIxwg6aAE/wUA
 ln8=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="62253236"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:54 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:52 -0800
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:51 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 12/13] pm80xx : Introduce read and write length for IOCTL payload structure.
Date:   Fri, 17 Jan 2020 12:49:22 +0530
Message-ID: <20200117071923.7445-13-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Removed the common length and introduce read and write length for
IOCTL payload structure.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |  6 +++---
 drivers/scsi/pm8001/pm8001_hwi.c  | 22 +++++++++++-----------
 drivers/scsi/pm8001/pm8001_init.c | 12 ++++++------
 drivers/scsi/pm8001/pm8001_sas.h  |  3 ++-
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 9fce19024945..887a15ee69f6 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -486,7 +486,7 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
 	pm8001_ha->nvmd_completion = &completion;
 	payload.minor_function = 7;
 	payload.offset = 0;
-	payload.length = 4096;
+	payload.rd_length = 4096;
 	payload.func_specific = kzalloc(4096, GFP_KERNEL);
 	if (!payload.func_specific)
 		return -ENOMEM;
@@ -697,7 +697,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
 	memcpy((u8 *)&payload->func_specific, (u8 *)pm8001_ha->fw_image->data,
 				pm8001_ha->fw_image->size);
-	payload->length = pm8001_ha->fw_image->size;
+	payload->wr_length = pm8001_ha->fw_image->size;
 	payload->id = 0;
 	payload->minor_function = 0x1;
 	pm8001_ha->nvmd_completion = &completion;
@@ -743,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
 					IOCTL_BUF_SIZE);
 		for (loopNumber = 0; loopNumber < loopcount; loopNumber++) {
 			payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
-			payload->length = 1024*16;
+			payload->wr_length = 1024*16;
 			payload->id = 0;
 			fwControl =
 			      (struct fw_control_info *)&payload->func_specific;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f9395d9fd530..16dc7a92ad68 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4841,7 +4841,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	if (!fw_control_context)
 		return -ENOMEM;
 	fw_control_context->usrAddr = (u8 *)ioctl_payload->func_specific;
-	fw_control_context->len = ioctl_payload->length;
+	fw_control_context->len = ioctl_payload->rd_length;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
@@ -4862,7 +4862,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
 			twi_page_size << 8 | TWI_DEVICE);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
 		nvmd_req.resp_addr_lo =
@@ -4871,7 +4871,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	case C_SEEPROM: {
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | C_SEEPROM);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
 		nvmd_req.resp_addr_lo =
@@ -4880,7 +4880,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	case VPD_FLASH: {
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | VPD_FLASH);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
 		nvmd_req.resp_addr_lo =
@@ -4889,7 +4889,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	case EXPAN_ROM: {
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | EXPAN_ROM);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
 		nvmd_req.resp_addr_lo =
@@ -4898,7 +4898,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	case IOP_RDUMP: {
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | IOP_RDUMP);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.vpd_offset = cpu_to_le32(ioctl_payload->offset);
 		nvmd_req.resp_addr_hi =
 		cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
@@ -4938,7 +4938,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		&ioctl_payload->func_specific,
-		ioctl_payload->length);
+		ioctl_payload->wr_length);
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc) {
@@ -4957,7 +4957,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
 			twi_page_size << 8 | TWI_DEVICE);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
 		nvmd_req.resp_addr_lo =
@@ -4966,7 +4966,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	case C_SEEPROM:
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | C_SEEPROM);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
 		nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
@@ -4975,7 +4975,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		break;
 	case VPD_FLASH:
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | VPD_FLASH);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
 		nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
@@ -4984,7 +4984,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		break;
 	case EXPAN_ROM:
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | EXPAN_ROM);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
 		nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index b74282bc1ed0..6e037638656d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -643,22 +643,22 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	if (pm8001_ha->chip_id == chip_8001) {
 		if (deviceid == 0x8081 || deviceid == 0x0042) {
 			payload.minor_function = 4;
-			payload.length = 4096;
+			payload.rd_length = 4096;
 		} else {
 			payload.minor_function = 0;
-			payload.length = 128;
+			payload.rd_length = 128;
 		}
 	} else if ((pm8001_ha->chip_id == chip_8070 ||
 			pm8001_ha->chip_id == chip_8072) &&
 			pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
 		payload.minor_function = 4;
-		payload.length = 4096;
+		payload.rd_length = 4096;
 	} else {
 		payload.minor_function = 1;
-		payload.length = 4096;
+		payload.rd_length = 4096;
 	}
 	payload.offset = 0;
-	payload.func_specific = kzalloc(payload.length, GFP_KERNEL);
+	payload.func_specific = kzalloc(payload.rd_length, GFP_KERNEL);
 	if (!payload.func_specific) {
 		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("mem alloc fail\n"));
 		return;
@@ -728,7 +728,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	/* SAS ADDRESS read from flash / EEPROM */
 	payload.minor_function = 6;
 	payload.offset = 0;
-	payload.length = 4096;
+	payload.rd_length = 4096;
 	payload.func_specific = kzalloc(4096, GFP_KERNEL);
 	if (!payload.func_specific)
 		return -ENOMEM;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ae5f880dd9bb..13d7813b8d74 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -164,10 +164,11 @@ struct pm8001_ioctl_payload {
 	u32	signature;
 	u16	major_function;
 	u16	minor_function;
-	u16	length;
 	u16	status;
 	u16	offset;
 	u16	id;
+	u32	wr_length;
+	u32	rd_length;
 	u8	*func_specific;
 };
 
-- 
2.16.3

