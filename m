From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v1 2/9] ufs: sysfs: interconnect descriptor
Date: Mon, 25 Dec 2017 10:34:31 +0200
Message-ID: <1514190878-5571-3-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514190878-5571-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:33021 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdLYIfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Dec 2017 03:35:04 -0500
In-Reply-To: <1514190878-5571-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 19 +++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 18 ++++++++++++++++++
 drivers/scsi/ufs/ufs.h                     |  8 ++++++++
 3 files changed, 45 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index da39c63..35a8731 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -221,3 +221,22 @@ Description:	This file shows the command maximum timeout for a change
 		parameters. The full information about the descriptor could
 		be found at UFS specifications 2.1.
 		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the MIPI UniPro version number in BCD format.
+		This is one of the UFS interconnect descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/mphy_version
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the MIPI M-PHY version number in BCD format.
+		This is one of the UFS interconnect descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
\ No newline at end of file
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 1d7867c..0e2bfdb 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -132,8 +132,26 @@ static const struct attribute_group ufs_sysfs_device_descriptor_group = {
 	.attrs = ufs_sysfs_device_descriptor,
 };
 
+#define UFS_INTERCONNECT_DESC_PARAM(_name, _uname, _size)                     \
+	UFS_DESC_PARAM(_name, _uname, INTERCONNECT, _size)
+
+UFS_INTERCONNECT_DESC_PARAM(unipro_version, UNIPRO_VER, WORD);
+UFS_INTERCONNECT_DESC_PARAM(mphy_version, MPHY_VER, WORD);
+
+static struct attribute *ufs_sysfs_interconnect_descriptor[] = {
+	&dev_attr_unipro_version.attr,
+	&dev_attr_mphy_version.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_interconnect_descriptor_group = {
+	.name = "interconnect_descriptor",
+	.attrs = ufs_sysfs_interconnect_descriptor,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
+	&ufs_sysfs_interconnect_descriptor_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 6ae1e08..773c049 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -230,6 +230,14 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
 };
 
+/* Interconnect descriptor parameters offsets in bytes*/
+enum interconnect_desc_param {
+	INTERCONNECT_DESC_PARAM_LEN		= 0x0,
+	INTERCONNECT_DESC_PARAM_TYPE		= 0x1,
+	INTERCONNECT_DESC_PARAM_UNIPRO_VER	= 0x2,
+	INTERCONNECT_DESC_PARAM_MPHY_VER	= 0x4,
+};
+
 /*
  * Logical Unit Write Protect
  * 00h: LU not write protected
-- 
2.7.4
