From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v4 03/10] ufs: sysfs: interconnect descriptor
Date: Thu,  1 Feb 2018 18:15:39 +0200
Message-ID: <1517501746-19075-4-git-send-email-stanislav.nijnikov@wdc.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jaegeuk@kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS interconnect
descriptor parameters. The group adds "interconnect_descriptor" folder
under the UFS driver sysfs entry (/sys/bus/platform/drivers/ufshcd/*).
The parameters are shown as hexadecimal numbers. The full information
about the parameters could be found at UFS specifications 2.1.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 19 +++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 18 ++++++++++++++++++
 drivers/scsi/ufs/ufs.h                     |  8 ++++++++
 3 files changed, 45 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 8da7b84..099e6fa 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -221,3 +221,22 @@ Description:	This file shows the command maximum timeout for a change
 		parameters. The full information about the descriptor could
 		be found at UFS specifications 2.1.
 		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the MIPI UniPro version number in BCD format.
+		This is one of the UFS interconnect descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/mphy_version
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the MIPI M-PHY version number in BCD format.
+		This is one of the UFS interconnect descriptor parameters.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 372e281..460378b 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -264,9 +264,27 @@ static const struct attribute_group ufs_sysfs_device_descriptor_group = {
 	.attrs = ufs_sysfs_device_descriptor,
 };
 
+#define UFS_INTERCONNECT_DESC_PARAM(_name, _uname, _size)                     \
+	UFS_DESC_PARAM(_name, _uname, INTERCONNECT, _size)
+
+UFS_INTERCONNECT_DESC_PARAM(unipro_version, _UNIPRO_VER, WORD);
+UFS_INTERCONNECT_DESC_PARAM(mphy_version, _MPHY_VER, WORD);
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
 	&ufs_sysfs_default_group,
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
