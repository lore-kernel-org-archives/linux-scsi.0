Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7BAC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 17:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D839F64DEC
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 17:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhBORnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 12:43:22 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25672 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhBORmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2021 12:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613410955; x=1644946955;
  h=from:to:cc:subject:date:message-id;
  bh=lEmKmnRYy2zZNtUreXQgtTq74UsNC2Dj4ppANXSbipE=;
  b=jmtHgLq8QsloVDxBT0yfIf34X8HHJy1/J/41uUPpGDCmjlFd6JGP+eWN
   q/n4mW5eFoiCSK5RfXVaTQnI+S8Gxl3GFrZvC+uqoRuVOCPt+5xXc2WiM
   UDWldqpSom979wJBYrwOn+kMMeTsGTt5QDClnCXkyh1PUYiVhnpdgZpCd
   ZoJ6py98TV2zlJ7d5rFQXl1KXZ5oAG2ez04R7YGnGlF7hA2TCwf+goCOE
   jM9bP1LHUtODUi+1UqfLHfIHMuDnz2HIzUXEsrhMoRDTB9Iyxt/wQ3sm6
   V8Ka8aF1uu/HBB/DBPi6H5uB5AUyF5xD+aGzjJtBw/yMiRnIuk1QpUSZT
   Q==;
IronPort-SDR: 8d1PbtF3H8dV7Yz+0Asyd2JyJuQJEyiaXY/ClLOUmZL7R0j2eXLP9Gh778RdGKKyfxx7c4Jn0m
 wkNNAuffm2CfTgdHnyPG2Y+DsK2xthe4vWvj907hUrGs9VRxhfbSK817FSls+3BYBExnnpoJmD
 Tjx4/ecirwqTV0Mx78f1vwrOfFndkahS1x7B8h5oh0F3NGpDLvKW0DsRstcguKEbH8JGUkJiCC
 JAHB2GKELIR32adAYeyD8c6VtvaSfz52tuSTTz7UZL4GHSUHbC7CdcjFpOdPmKV8LAgQMaFFuC
 AsM=
X-IronPort-AV: E=Sophos;i="5.81,181,1610380800"; 
   d="scan'208";a="160015023"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2021 01:41:18 +0800
IronPort-SDR: cVaKwywuFBHtPe91XSFQ+d43P3VVX/a85Z8QOlCuiWtFxoILtpdYr2IKUBCGIan0guhE85lCA5
 v9XkgHRfwKAKckoCnZBTGSiyzFgvIlRI0MyEiDLZOs1Uh9zb4aaX0hxD8g9YFe9lHcXI5AEhWd
 1Zx62OeZqqr4S2pPbkk4hcS9mAhVkvhb0bCGOeLoyXvg5aSu6i5WOZcC0DZORnRBafd4F5f3E/
 VifMNHwmChY0EY/GF0C98sY7a4hdtg6ajw5+aVSZXhUztr0UQ23E1ET+MpHZEw1yfyVRIBkPl1
 jOiVaj4hxeI7sKzK0QVi8HWI
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 09:23:05 -0800
IronPort-SDR: ga1OgsxAbnRRNXVizEKedBb8GyhFAh61STKSV7uqnVNANsEQeK4T2InwPwV6/3LpFi4/yqV109
 QjhJgvHFt/onqQbYgUjTluLbd+j8E3o9wL5oeu3bJmkkftmQ7nR86K/CpjPr67slUEUUS0x5gs
 J9+nyiH+6ZeevCmtwa63FTjH3T3rXnMWqWfBJgbnEMPLyIquli4oBLH7nrLHDytjN5AgCECVra
 yQKaL7f6vhM1qbR5GZ3bMH5wgUXzaEnNCfM8lxMn3GwKRAwTFj2htyzd8+R6cTq2bCs/rpFEEL
 uGs=
WDCIronportException: Internal
Received: from ilb001078.sdcorp.global.sandisk.com ([10.0.231.241])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 Feb 2021 09:41:17 -0800
From:   Arthur Simchaev <Arthur.Simchaev@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw data
Date:   Mon, 15 Feb 2021 19:40:46 +0200
Message-Id: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently the string descriptors sysfs entries are printing in ascii
format. According to Jedec UFS spec the string descriptors data is
Unicode and need-not be ascii convertible. Therefore in case the device
string descriptor contains non ascii convertible characters, it will
produce a wrong output. In order to fix this issue, the new
string descriptors entries will added to sysfs directory.
Those entries will show the string descriptors in raw format

Signed-off-by: Arthur Simchaev <Arthur.Simchaev@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 44 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 34 +++++++++++++++++------
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1bc23c..f6d6a46 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -561,6 +561,50 @@ Description:	This file contains a product revision string. The full
 
 		The file is read only.
 
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/manufacturer_name_raw
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This file contains a device manufactureer name string
+		as raw data. The full information about the descriptor
+		could be found at UFS specifications 2.1.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_name_raw
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This file contains a product name string as raw data.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem_id_raw
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This file contains a OEM ID string as raw data.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/serial_number_raw
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This file contains a device serial number string
+		as raw data. The full information about the descriptor could be
+		found at UFS specifications 2.1.
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_revision_raw
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This file contains a product revision string as raw data.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+
+		The file is read only.
 
 What:		/sys/class/scsi_device/*/device/unit_descriptor/boot_lun_id
 Date:		February 2018
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index acc54f5..f1407ff 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -658,7 +658,7 @@ static const struct attribute_group ufs_sysfs_power_descriptor_group = {
 	.attrs = ufs_sysfs_power_descriptor,
 };
 
-#define UFS_STRING_DESCRIPTOR(_name, _pname)				\
+#define UFS_STRING_DESCRIPTOR(_name, _pname, _is_ascii)		\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
@@ -690,10 +690,18 @@ static ssize_t _name##_show(struct device *dev,				\
 	kfree(desc_buf);						\
 	desc_buf = NULL;						\
 	ret = ufshcd_read_string_desc(hba, index, &desc_buf,		\
-				      SD_ASCII_STD);			\
+				      _is_ascii);			\
 	if (ret < 0)							\
 		goto out;						\
-	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
+	if (_is_ascii) {						\
+		ret = sysfs_emit(buf, "%s\n", desc_buf);		\
+	} else {							\
+		int i;							\
+									\
+		for (i = 0; i < desc_buf[0]; i++)			\
+			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
+		ret = sysfs_emit(buf, "%s\n", buf);			\
+	}			\
 out:									\
 	pm_runtime_put_sync(hba->dev);					\
 	kfree(desc_buf);						\
@@ -702,11 +710,16 @@ out:									\
 }									\
 static DEVICE_ATTR_RO(_name)
 
-UFS_STRING_DESCRIPTOR(manufacturer_name, _MANF_NAME);
-UFS_STRING_DESCRIPTOR(product_name, _PRDCT_NAME);
-UFS_STRING_DESCRIPTOR(oem_id, _OEM_ID);
-UFS_STRING_DESCRIPTOR(serial_number, _SN);
-UFS_STRING_DESCRIPTOR(product_revision, _PRDCT_REV);
+UFS_STRING_DESCRIPTOR(manufacturer_name, _MANF_NAME, 1);
+UFS_STRING_DESCRIPTOR(product_name, _PRDCT_NAME, 1);
+UFS_STRING_DESCRIPTOR(oem_id, _OEM_ID, 1);
+UFS_STRING_DESCRIPTOR(serial_number, _SN, 1);
+UFS_STRING_DESCRIPTOR(product_revision, _PRDCT_REV, 1);
+UFS_STRING_DESCRIPTOR(manufacturer_name_raw, _MANF_NAME, 0);
+UFS_STRING_DESCRIPTOR(product_name_raw, _PRDCT_NAME, 0);
+UFS_STRING_DESCRIPTOR(oem_id_raw, _OEM_ID, 0);
+UFS_STRING_DESCRIPTOR(serial_number_raw, _SN, 0);
+UFS_STRING_DESCRIPTOR(product_revision_raw, _PRDCT_REV, 0);
 
 static struct attribute *ufs_sysfs_string_descriptors[] = {
 	&dev_attr_manufacturer_name.attr,
@@ -714,6 +727,11 @@ static struct attribute *ufs_sysfs_string_descriptors[] = {
 	&dev_attr_oem_id.attr,
 	&dev_attr_serial_number.attr,
 	&dev_attr_product_revision.attr,
+	&dev_attr_manufacturer_name_raw.attr,
+	&dev_attr_product_name_raw.attr,
+	&dev_attr_oem_id_raw.attr,
+	&dev_attr_serial_number_raw.attr,
+	&dev_attr_product_revision_raw.attr,
 	NULL,
 };
 
-- 
2.7.4

