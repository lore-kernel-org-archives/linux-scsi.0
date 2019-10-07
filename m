Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A3BC47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 350002133F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfJGWcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:32:01 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17316 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729504AbfJGWcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:32:00 -0400
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
IronPort-SDR: nbGx2idFiqo+WzAPfw746P5fHNWRHE8wH7B9RMaRaJoo+jqy8Jpq7WfiTyaBA74laNkXed9Kep
 IhBc6AHwzQjpITmKOk8AQf14JqeC6DoeBg1CnaZgK7wkBz3Zq71xk2wOFjzaV2JIuF8C+V2VId
 OJbK6CBz+4zgNya2oaja9XFKBe/VHzsWDgMLSD38cg9nOP1dfiUFwsJO6jEWbQGI9leVNcv3al
 HZ1WYaHJ5umzYIyU5kF+VQ0+UxkL6lB6n//xMoRYsUqL3hcajrqt7MfA81ZB0EUxZPJRSnMZ7f
 pX4=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="49125740"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:32:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:31:59 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:31:57 -0700
Subject: [PATCH 07/10] smartpqi: fix problem with unique ID for physical
 device
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:31:58 -0500
Message-ID: <157048751833.11757.11996314786914610803.stgit@brunhilda>
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

From: Kevin Barnett <kevin.barnett@microsemi.com>

- obtain the unique IDs from the RLL and RPL instead
  of VPD page 83h.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 
 drivers/scsi/smartpqi/smartpqi_init.c |   99 ++++-----------------------------
 2 files changed, 12 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index c09d48366d38..068336904477 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -912,7 +912,6 @@ struct pqi_scsi_dev {
 	u8	scsi3addr[8];
 	__be64	wwid;
 	u8	volume_id[16];
-	u8	unique_id[16];
 	u8	is_physical_device : 1;
 	u8	is_external_raid_device : 1;
 	u8	is_expander_smp_device : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3085e88c2c9a..e443b682a89c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -648,79 +648,6 @@ static inline int pqi_scsi_inquiry(struct pqi_ctrl_info *ctrl_info,
 		buffer, buffer_length, vpd_page, NULL, NO_TIMEOUT);
 }
 
-static bool pqi_vpd_page_supported(struct pqi_ctrl_info *ctrl_info,
-	u8 *scsi3addr, u16 vpd_page)
-{
-	int rc;
-	int i;
-	int pages;
-	unsigned char *buf, bufsize;
-
-	buf = kzalloc(256, GFP_KERNEL);
-	if (!buf)
-		return false;
-
-	/* Get the size of the page list first */
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_SUPPORTED_PAGES,
-				buf, SCSI_VPD_HEADER_SZ);
-	if (rc != 0)
-		goto exit_unsupported;
-
-	pages = buf[3];
-	if ((pages + SCSI_VPD_HEADER_SZ) <= 255)
-		bufsize = pages + SCSI_VPD_HEADER_SZ;
-	else
-		bufsize = 255;
-
-	/* Get the whole VPD page list */
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_SUPPORTED_PAGES,
-				buf, bufsize);
-	if (rc != 0)
-		goto exit_unsupported;
-
-	pages = buf[3];
-	for (i = 1; i <= pages; i++)
-		if (buf[3 + i] == vpd_page)
-			goto exit_supported;
-
-exit_unsupported:
-	kfree(buf);
-	return false;
-
-exit_supported:
-	kfree(buf);
-	return true;
-}
-
-static int pqi_get_device_id(struct pqi_ctrl_info *ctrl_info,
-	u8 *scsi3addr, u8 *device_id, int buflen)
-{
-	int rc;
-	unsigned char *buf;
-
-	if (!pqi_vpd_page_supported(ctrl_info, scsi3addr, SCSI_VPD_DEVICE_ID))
-		return 1; /* function not supported */
-
-	buf = kzalloc(64, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_DEVICE_ID,
-				buf, 64);
-	if (rc == 0) {
-		if (buflen > 16)
-			buflen = 16;
-		memcpy(device_id, &buf[SCSI_VPD_DEVICE_ID_IDX], buflen);
-	}
-
-	kfree(buf);
-
-	return rc;
-}
-
 static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *buffer,
@@ -1405,14 +1332,6 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 		}
 	}
 
-	if (pqi_get_device_id(ctrl_info, device->scsi3addr,
-		device->unique_id, sizeof(device->unique_id)) < 0)
-		dev_warn(&ctrl_info->pci_dev->dev,
-			"Can't get device id for scsi %d:%d:%d:%d\n",
-			ctrl_info->scsi_host->host_no,
-			device->bus, device->target,
-			device->lun);
-
 out:
 	kfree(buffer);
 
@@ -6326,7 +6245,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 	struct scsi_device *sdev;
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
-	unsigned char uid[16];
+	u8 unique_id[16];
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -6339,16 +6258,22 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 			flags);
 		return -ENODEV;
 	}
-	memcpy(uid, device->unique_id, sizeof(uid));
+
+	if (device->is_physical_device) {
+		memset(unique_id, 0, 8);
+		memcpy(unique_id + 8, &device->wwid, sizeof(device->wwid));
+	} else {
+		memcpy(unique_id, device->volume_id, sizeof(device->volume_id));
+	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
 	return snprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
-		uid[0], uid[1], uid[2], uid[3],
-		uid[4], uid[5], uid[6], uid[7],
-		uid[8], uid[9], uid[10], uid[11],
-		uid[12], uid[13], uid[14], uid[15]);
+		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
+		unique_id[4], unique_id[5], unique_id[6], unique_id[7],
+		unique_id[8], unique_id[9], unique_id[10], unique_id[11],
+		unique_id[12], unique_id[13], unique_id[14], unique_id[15]);
 }
 
 static ssize_t pqi_lunid_show(struct device *dev,

