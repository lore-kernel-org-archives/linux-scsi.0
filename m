Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7558FC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 430CA22CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393296AbfHVUjX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:39:23 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2856 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfHVUjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:39:22 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: D79roj8hjz3RTLSyXizI39ovV4tpHOlMLpHobOBh4sFe6DtKw7DJ+/hJvaHfpX8IIhgjXszHbB
 jRJ7APZD52hkIBI1DtKNNFn7vM3ptJbSO8UzuUvPXPeGve2/2aZI6YCf6CzuFD2lgRRzFZrO3Y
 rHdxHFSAI2MiyFjh7ym2RgEfjOeobJK4MvuvyuzBhO2jl/8cGkpzU4BKgfjVxKIWmXTGjOjDOs
 NQc9YTWQNPJB5nJoL2Yqm4exEcKeWm9WN7OBnZeYnjWSO7ypHzKPaves5aC2hgtWl9xNySn6MS
 kAM=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="44671306"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:39:22 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:20 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:19 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:39:18 -0700
Subject: [PATCH 04/11] smartpqi: add sysfs entries
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:39:18 -0500
Message-ID: <156650635810.18562.465423962992706538.stgit@brunhilda>
In-Reply-To: <156650628375.18562.9889154437665249418.stgit@brunhilda>
References: <156650628375.18562.9889154437665249418.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microsemi.com>

 - serial number
 - model
 - vendor

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   15 +++-
 drivers/scsi/smartpqi/smartpqi_init.c |  125 +++++++++++++++++++++++++++++----
 2 files changed, 124 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 0a629f2f447a..2b21c4ebc491 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1074,6 +1074,9 @@ struct pqi_ctrl_info {
 	unsigned int	ctrl_id;
 	struct pci_dev	*pci_dev;
 	char		firmware_version[11];
+	char		serial_number[17];
+	char		model[17];
+	char		vendor[9];
 	void __iomem	*iomem_base;
 	struct pqi_ctrl_registers __iomem *registers;
 	struct pqi_device_registers __iomem *pqi_registers;
@@ -1225,9 +1228,17 @@ struct bmic_identify_controller {
 	__le16	extended_logical_unit_count;
 	u8	reserved1[34];
 	__le16	firmware_build_number;
-	u8	reserved2[100];
+	u8	reserved2[8];
+	u8	vendor_id[8];
+	u8	product_id[16];
+	u8	reserved3[68];
 	u8	controller_mode;
-	u8	reserved3[32];
+	u8	reserved4[32];
+};
+
+struct bmic_sense_subsystem_info {
+	u8	reserved[44];
+	u8	ctrl_serial_number[16];
 };
 
 #define SA_EXPANDER_SMP_DEVICE		0x05
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f289fbd4220d..7d09998db1b1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -484,6 +484,7 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		/* fall through */
 	case BMIC_IDENTIFY_CONTROLLER:
 	case BMIC_IDENTIFY_PHYSICAL_DEVICE:
+	case BMIC_SENSE_SUBSYSTEM_INFORMATION:
 		request->data_direction = SOP_READ_FLAG;
 		cdb[0] = BMIC_READ;
 		cdb[6] = cmd;
@@ -612,6 +613,14 @@ static inline int pqi_identify_controller(struct pqi_ctrl_info *ctrl_info,
 			buffer, sizeof(*buffer));
 }
 
+static inline int pqi_sense_subsystem_info(struct  pqi_ctrl_info *ctrl_info,
+		struct bmic_sense_subsystem_info *sense_info)
+{
+	return pqi_send_ctrl_raid_request(ctrl_info,
+			BMIC_SENSE_SUBSYSTEM_INFORMATION,
+			sense_info, sizeof(*sense_info));
+}
+
 static inline int pqi_scsi_inquiry(struct pqi_ctrl_info *ctrl_info,
 	u8 *scsi3addr, u16 vpd_page, void *buffer, size_t buffer_length)
 {
@@ -6129,23 +6138,65 @@ static int pqi_ioctl(struct scsi_device *sdev, unsigned int cmd,
 	return rc;
 }
 
-static ssize_t pqi_version_show(struct device *dev,
+static ssize_t pqi_firmware_version_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
-	ssize_t count = 0;
 	struct Scsi_Host *shost;
 	struct pqi_ctrl_info *ctrl_info;
 
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	count += snprintf(buffer + count, PAGE_SIZE - count,
-		"  driver: %s\n", DRIVER_VERSION BUILD_TIMESTAMP);
+	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->firmware_version);
+}
+
+static ssize_t pqi_driver_version_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+
+	shost = class_to_shost(dev);
+	ctrl_info = shost_to_hba(shost);
 
-	count += snprintf(buffer + count, PAGE_SIZE - count,
-		"firmware: %s\n", ctrl_info->firmware_version);
+	return snprintf(buffer, PAGE_SIZE,
+		"%s\n", DRIVER_VERSION BUILD_TIMESTAMP);
+}
 
-	return count;
+static ssize_t pqi_serial_number_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+
+	shost = class_to_shost(dev);
+	ctrl_info = shost_to_hba(shost);
+
+	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
+}
+
+static ssize_t pqi_model_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+
+	shost = class_to_shost(dev);
+	ctrl_info = shost_to_hba(shost);
+
+	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
+}
+
+static ssize_t pqi_vendor_show(struct device *dev,
+	struct device_attribute *attr, char *buffer)
+{
+	struct Scsi_Host *shost;
+	struct pqi_ctrl_info *ctrl_info;
+
+	shost = class_to_shost(dev);
+	ctrl_info = shost_to_hba(shost);
+
+	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
 }
 
 static ssize_t pqi_host_rescan_store(struct device *dev,
@@ -6198,13 +6249,21 @@ static ssize_t pqi_lockup_action_store(struct device *dev,
 	return -EINVAL;
 }
 
-static DEVICE_ATTR(version, 0444, pqi_version_show, NULL);
+static DEVICE_ATTR(driver_version, 0444, pqi_driver_version_show, NULL);
+static DEVICE_ATTR(firmware_version, 0444, pqi_firmware_version_show, NULL);
+static DEVICE_ATTR(model, 0444, pqi_model_show, NULL);
+static DEVICE_ATTR(serial_number, 0444, pqi_serial_number_show, NULL);
+static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
 static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
 static DEVICE_ATTR(lockup_action, 0644,
 	pqi_lockup_action_show, pqi_lockup_action_store);
 
 static struct device_attribute *pqi_shost_attrs[] = {
-	&dev_attr_version,
+	&dev_attr_driver_version,
+	&dev_attr_firmware_version,
+	&dev_attr_model,
+	&dev_attr_serial_number,
+	&dev_attr_vendor,
 	&dev_attr_rescan,
 	&dev_attr_lockup_action,
 	NULL
@@ -6596,7 +6655,30 @@ static int pqi_reset(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static int pqi_get_ctrl_firmware_version(struct pqi_ctrl_info *ctrl_info)
+static int pqi_get_ctrl_serial_number(struct pqi_ctrl_info *ctrl_info)
+{
+	int rc;
+	struct bmic_sense_subsystem_info *sense_info;
+
+	sense_info = kzalloc(sizeof(*sense_info), GFP_KERNEL);
+	if (!sense_info)
+		return -ENOMEM;
+
+	rc = pqi_sense_subsystem_info(ctrl_info, sense_info);
+	if (rc)
+		goto out;
+
+	memcpy(ctrl_info->serial_number, sense_info->ctrl_serial_number,
+		sizeof(sense_info->ctrl_serial_number));
+	ctrl_info->serial_number[sizeof(sense_info->ctrl_serial_number)] = '\0';
+
+out:
+	kfree(sense_info);
+
+	return rc;
+}
+
+static int pqi_get_ctrl_product_details(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
 	struct bmic_identify_controller *identify;
@@ -6617,6 +6699,14 @@ static int pqi_get_ctrl_firmware_version(struct pqi_ctrl_info *ctrl_info)
 		sizeof(ctrl_info->firmware_version),
 		"-%u", get_unaligned_le16(&identify->firmware_build_number));
 
+	memcpy(ctrl_info->model, identify->product_id,
+		sizeof(identify->product_id));
+	ctrl_info->model[sizeof(identify->product_id)] = '\0';
+
+	memcpy(ctrl_info->vendor, identify->vendor_id,
+		sizeof(identify->vendor_id));
+	ctrl_info->vendor[sizeof(identify->vendor_id)] = '\0';
+
 out:
 	kfree(identify);
 
@@ -7136,10 +7226,17 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	if (rc)
 		return rc;
 
-	rc = pqi_get_ctrl_firmware_version(ctrl_info);
+	rc = pqi_get_ctrl_product_details(ctrl_info);
+	if (rc) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"error obtaining product details\n");
+		return rc;
+	}
+
+	rc = pqi_get_ctrl_serial_number(ctrl_info);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"error obtaining firmware version\n");
+			"error obtaining ctrl serial number\n");
 		return rc;
 	}
 
@@ -7279,10 +7376,10 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 	}
 
-	rc = pqi_get_ctrl_firmware_version(ctrl_info);
+	rc = pqi_get_ctrl_product_details(ctrl_info);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"error obtaining firmware version\n");
+			"error obtaining product detail\n");
 		return rc;
 	}
 

