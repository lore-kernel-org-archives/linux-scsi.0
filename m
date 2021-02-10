Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA557C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 10:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5394A64E40
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 10:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhBJK5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 05:57:13 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33841 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhBJKzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 05:55:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1612954509; x=1644490509;
  h=from:to:cc:subject:date:message-id;
  bh=QUxTHn86SkMNd/9RtbLZhC4AogfF7Hfr2MyKmgOWQ8o=;
  b=16/QuUsORQl95qKp853Fs1kQVl/yn312vjFZmjtnYCG2B/MEl2BjTmCg
   Nb5hSPDEwNGs6vpje1V46GewtXwgWn3KimZ1i6+rWOUlTE2FZDJmHIoHw
   UafalgNz5xihiu8/mmatZ7SVmAuhNJFCYi3pE//dyoFlH/yGVzabnQ+gx
   3gjX2umFmDyRLhHtWuCALJDR6XUaNvEM+0RANoMtFcDWumPrSmnXVxC2/
   kvlvia9REH5vBZciTIf/aBAT6sw6OHwLsbMiEhS4b2pH4OD/H0FwCJG5o
   KRW9Ga9UeyOXqyCCdmMQPPQYpq0tr/XzEBLVUKpzZ2PbmKJgyk7ElVajF
   g==;
IronPort-SDR: Mz07YtmEThSCYZNLySvyJERs6SB/VropMK5Qv6pcy20IhFzK5F1UFsQ2iKldXF5bgGrMfZTtXB
 CnKb2IFNl0FT1cVCIEtGnanJko1esLeNObv+1BZLNkeoZurEuXSOfTHFyrFcxEJD8A+jwsfXq6
 thP5zNXR9k9gppFlRCenwoZR/EEcmNqOYSPLoEe3hrS9IYIqRILCqRNxENVDXiFIJ9ifhcwbo7
 lk95fUWNr0jrZc25HNmbEGtwaeKmPF/w7tS41sNBAu0hDlB4/8KTc/xp5t5PCSMzcxJ4u4pJy6
 lsI=
X-IronPort-AV: E=Sophos;i="5.81,168,1610380800"; 
   d="scan'208";a="270102607"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2021 18:53:51 +0800
IronPort-SDR: k76807AJXGa4mp8wOvFLcGIaUAVjtOBLww/iScqD+793Olv34U8ImucbHwgH+J5g1Z+eIi08VW
 ebwVqi3Fzt52pAbMfzgxB8QKxzN1hF/intRa75S3m50ln8F9+1V6RjNURal6zIqy//bBsvVqXk
 QkRc2tQ2dbxUTEpkmkCdsSlcpccChwtEvpnIREhw2T+/Rw91GJKwreLj8dEcDfzZYPwdMTIYrL
 OUzSx98DnWN8JY+L2Lk4tBUSL0yOaGXDA+LJPSRV+dLVzcIQNJ//2ZIq8nKnYoIodrTXFbntap
 IdX6BbzN6H3HTMQSgDojdq2h
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 02:37:35 -0800
IronPort-SDR: fMBKU3qIGmFehGUw1iQec26lbAGlShd6t1OWDxqFQyESmkYHRJOT1XSa/AqQM2hosPxnL4GwiL
 QcRzmDYG1nI0qI0KmI8szk/2SR46+aFKEd02j9ZAWJ+EoxpZI90FWWYrAURH84v71aVapqqa0i
 dqdlBHKwgASurc12zeeFGb8uw1GX+AVMS2XUAoLt7IE8JdB+yPJs3QQmXbk99GNMWUOQeQJ7Zm
 /fYPB4ZNJ4F8pgUWiaSuKTxjBF6zRyy9xwAiFCvvnaKQzqWjxSSFYJWGAspUSIoam3Vi9VMyif
 pzo=
WDCIronportException: Internal
Received: from cnf008142.ad.shared (HELO ilb001078.hgst.com) ([10.86.63.178])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Feb 2021 02:53:50 -0800
From:   Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Arthur Simchaev <Arthur.Simchaev@sandisk.com>
Subject: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
Date:   Wed, 10 Feb 2021 12:53:45 +0200
Message-Id: <1612954425-6705-1-git-send-email-Arthur.Simchaev@sandisk.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arthur Simchaev <arthur.simchaev@wdc.com>

Currently the string descriptors sysfs entries are printing in ascii
format. According to Jedec UFS spec the string descriptors data is
Unicode and may not be ascii convertible. Therefore in case the device
string descriptor contains non ascii convertible characters, it will
produce a wrong output. In order to fix this issue, the new
"is_ascii_output" entry will be added to string descriptor's sysfs
directory. According to the entry value, the user will receive the
string descriptor output in raw or ascii data

Signed-off-by: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  9 +++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 32 ++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1bc23c..c7d8d8d 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -561,6 +561,15 @@ Description:	This file contains a product revision string. The full
 
 		The file is read only.
 
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/is_ascii_output
+Date:		February 2021
+Contact:	Arthur Simchaev <arthur.simchaev@wdc.com>
+Description:	This entry could be used to set the string descriptor
+		output format:
+		0 will print raw string descriptor data as defined in
+		UFS JEDEC spec.
+		1 will convert the string descriptor data to ascii string
+		and print it.
 
 What:		/sys/class/scsi_device/*/device/unit_descriptor/boot_lun_id
 Date:		February 2018
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index acc54f5..83c8104 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -9,6 +9,8 @@
 #include "ufs.h"
 #include "ufs-sysfs.h"
 
+static bool is_ascii_output = true;
+
 static const char *ufschd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -693,7 +695,15 @@ static ssize_t _name##_show(struct device *dev,				\
 				      SD_ASCII_STD);			\
 	if (ret < 0)							\
 		goto out;						\
-	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
+	if (is_ascii_output) {						\
+		ret = sysfs_emit(buf, "%s\n", desc_buf);		\
+	} else {							\
+		int i;							\
+									\
+		for (i = 0; i < desc_buf[0]; i++)			\
+			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
+		ret = sysfs_emit(buf, "%s\n", buf);			\
+	}								\
 out:									\
 	pm_runtime_put_sync(hba->dev);					\
 	kfree(desc_buf);						\
@@ -708,13 +718,31 @@ UFS_STRING_DESCRIPTOR(oem_id, _OEM_ID);
 UFS_STRING_DESCRIPTOR(serial_number, _SN);
 UFS_STRING_DESCRIPTOR(product_revision, _PRDCT_REV);
 
+static ssize_t is_ascii_output_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", is_ascii_output);
+}
+
+static ssize_t is_ascii_output_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	if (kstrtobool(buf, &is_ascii_output))
+		return -EINVAL;
+	return count;
+}
+
+static DEVICE_ATTR_RW(is_ascii_output);
+
 static struct attribute *ufs_sysfs_string_descriptors[] = {
 	&dev_attr_manufacturer_name.attr,
 	&dev_attr_product_name.attr,
 	&dev_attr_oem_id.attr,
 	&dev_attr_serial_number.attr,
 	&dev_attr_product_revision.attr,
-	NULL,
+	&dev_attr_is_ascii_output.attr,
+	NULL
 };
 
 static const struct attribute_group ufs_sysfs_string_descriptors_group = {
-- 
2.7.4

