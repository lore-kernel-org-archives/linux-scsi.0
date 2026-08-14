Received: from mail-m21473.qiye.163.com (mail-m21473.qiye.163.com [117.135.214.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72244398EB
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 09:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.214.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786698646; cv=none; b=oNEf/llbs1Ii0+YZ91TgifKvbmC0gHZG9vLspafLjeAWxYcStbqq34H8JoIsPYA46hptNb6gk28KmqLz/PlV+9WreEeTJVKCst8BfUL8ie54CSSlkIcidC4fRBq318fog20K0vvbhjQT4ioHDIi1JtF1auvta3ecb+N4UyS/EbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786698646; c=relaxed/simple;
	bh=g5bl1qAveVIrUbfoVH0tIGR1YVqR8ACbsq3aYD0lFFw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OIv4Y1fgj6BVEeBg2t1fCG5N6A7K6AmV1GMIRaUgKpgrxFuvqShj6ua3S6bsqY/DlziYJtlPKYpfZlDpjBeNIbqMXln5YfksiR3HKyorBC7Z6WHENz31JKlycWp+IQfCpX+4DeKM13X76ZBse6AdkVE2Fna/fPb4pT7g54NxVS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=dcUVsSyi; arc=none smtp.client-ip=117.135.214.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="dcUVsSyi"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4a0089afc;
	Fri, 14 Aug 2026 17:05:27 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: leapraid: standardize NCQ priority sysfs attributes
Date: Fri, 14 Aug 2026 17:05:26 +0800
Message-Id: <20260814090526.395704-1-doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fff84e43203aekunm9e18d87965957e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCT0oeVhpOGBkYThkeSUsYGFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=dcUVsSyieU/V2weAVO18ZjRQGTEF6pwPqMWk7Gzq+LnZPj8xs5Kw9o/2BO3BIytf+vGTtgrSn4SL0kNe5VZ2r/L0D7snZ/ExXrkDyvKLbco7vQxFHYyq0owSSqwSnRx4sGPpbmtmMwudvTmYzRadmVRaOSDj4gkH6C1cRQuMXeNZZeZgH65HzURDqaiTB2/de3z4qnSwh9j1WIzs8Dt7rXwGtRljWvisYY1+b10YYGh50IuHimbyxrKT1+Xd4k1gtBSPvO5zqBl8n9zznXJowZ2MHHpTbi76J5SJbqZfgcGq4C+u7oGzkAmMr+f0c7clkQm8YV+1USbgwEnsRKkmxQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=PG0vTte6yD3dcyMRsXLz6bSKqbYgU2aWFwvuHhLZe8o=;
	h=date:mime-version:subject:message-id:from;

Replace the earlier LeapRAID ncq_cmd_prio_enable attribute with the
standard sas_ncq_prio_supported and sas_ncq_prio_enable names documented
in Documentation/ABI/testing/sysfs-block-device, and rename the
per-device NCQ priority state to match.

The earlier ncq_cmd_prio_enable name has not yet been established as part
of a released userspace ABI, so no compatibility alias is needed.

For LeapRAID, sas_ncq_prio_enable is backed by the driver's per-device
NCQ priority state and controls whether RT-class I/O requests are issued
with command priority on supported SATA devices.

Update leapraid.rst to describe the standard attribute names and paths,
and clean up the surrounding RST text for consistency with kernel
documentation style.

Also switch the capability check from open-coded VPD page 0x89 parsing to
sas_ata_ncq_prio_supported(), use kstrtobool() for the enable path, and
expose the NCQ priority attributes only for SATA devices using LeapRAID's
target-private SAS device state.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
Changes in v2:
 - Reflow commit message lines to fit within 75 columns.
 - No functional change.

 Documentation/scsi/leapraid.rst       | 14 +++--
 drivers/scsi/leapraid/leapraid_func.h |  4 +-
 drivers/scsi/leapraid/leapraid_os.c   | 87 +++++++++++++++++----------
 3 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/Documentation/scsi/leapraid.rst b/Documentation/scsi/leapraid.rst
index 99930ce2b8d0..d36ff627d9f0 100644
--- a/Documentation/scsi/leapraid.rst
+++ b/Documentation/scsi/leapraid.rst
@@ -22,6 +22,7 @@ Supported devices
 
 Features
 ========
+
 - PCIe Gen4 x8 host interface
 - Support for SAS and SATA devices
 - RAID levels: 0, 1, 10, 5, 50, 6, 60
@@ -50,16 +51,20 @@ LeapRAID specific disk attributes
 
 ::
 
-   /sys/class/scsi_disk/host:bus:target:lun/device/sas_device_handle
-   /sys/class/scsi_disk/host:bus:target:lun/device/ncq_cmd_prio_enable
+   /sys/block/<disk>/device/sas_device_handle
+   /sys/block/<disk>/device/sas_ncq_prio_supported
+   /sys/block/<disk>/device/sas_ncq_prio_enable
 
 The read-only attribute "sas_device_handle" represents the disk's device
 handle, which is a unique identifier maintained by the firmware.
 
-This attribute "ncq_cmd_prio_enable" controls NCQ command priority. A value
+The read-only attribute "sas_ncq_prio_supported" reports whether a SATA
+device supports NCQ command priority.
+
+The attribute "sas_ncq_prio_enable" controls NCQ command priority. A value
 of 0 disables NCQ priority handling for RT-priority I/O. Writing 1 enables
 NCQ priority handling when the device reports support for the feature through
-VPD page 0x89. Unsupported devices keep the effective state at 0.
+VPD page 0x89. Writes to unsupported devices fail with an error.
 
 LeapRAID module parameters
 ==========================
@@ -100,6 +105,7 @@ in io_uring poll mode. The default value is 0.
 
 File Location
 =============
+
 The driver source is located at:
 
 ``drivers/scsi/leapraid/``
diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/leapraid_func.h
index 923596211aa1..4c0b9ca728d8 100644
--- a/drivers/scsi/leapraid/leapraid_func.h
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -1064,7 +1064,7 @@ struct leapraid_starget_priv {
  * @starget_priv: Associated target private data.
  * @lun: Logical Unit Number.
  * @flg: Flags.
- * @ncq_cmd_prio_enable: Enables NCQ command priority for RT I/O.
+ * @ncq_prio_enable: Enables NCQ command priority for RT I/O.
  * @block: Block flag.
  * @deleted: Deletion flag.
  * @sep: SEP flag.
@@ -1073,7 +1073,7 @@ struct leapraid_sdev_priv {
 	struct leapraid_starget_priv *starget_priv;
 	unsigned int lun;
 	u32 flg;
-	u8 ncq_cmd_prio_enable;
+	u8 ncq_prio_enable;
 	u8 block;
 	u8 deleted;
 	u8 sep;
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
index a8e1c9f33896..ee3242779dfd 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -859,7 +859,7 @@ static u32 build_scsiio_req_control(struct scsi_cmnd *scmd,
 
 	control |= LEAPRAID_SCSIIO_CTRL_SIMPLEQ;
 
-	if (sdev_priv->ncq_cmd_prio_enable &&
+	if (sdev_priv->ncq_prio_enable &&
 	    (IOPRIO_PRIO_CLASS(req_get_ioprio(scsi_cmd_to_rq(scmd))) ==
 	     IOPRIO_CLASS_RT))
 		control |= LEAPRAID_SCSIIO_CTRL_CMDPRI;
@@ -1854,7 +1854,16 @@ static ssize_t sas_device_handle_show(struct device *dev,
 			  sas_device_priv_data->starget_priv->hdl);
 }
 
-static ssize_t ncq_cmd_prio_enable_show(struct device *dev,
+static ssize_t sas_ncq_prio_supported_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sysfs_emit(buf, "%d\n", sas_ata_ncq_prio_supported(sdev));
+}
+
+static ssize_t sas_ncq_prio_enable_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
@@ -1867,19 +1876,16 @@ static ssize_t ncq_cmd_prio_enable_show(struct device *dev,
 		return -EINVAL;
 	}
 
-	return sysfs_emit(buf, "%d\n",
-			  sas_device_priv_data->ncq_cmd_prio_enable);
+	return sysfs_emit(buf, "%d\n", sas_device_priv_data->ncq_prio_enable);
 }
 
-static ssize_t ncq_cmd_prio_enable_store(struct device *dev,
+static ssize_t sas_ncq_prio_enable_store(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct leapraid_sdev_priv *sas_device_priv_data = sdev->hostdata;
-	struct scsi_vpd *vpd_pg89;
-	int ncq_cmd_prio_enable;
-	bool ncq_supported;
+	bool enable;
 
 	if (!sas_device_priv_data) {
 		dev_err(&sdev->sdev_gendev,
@@ -1887,44 +1893,63 @@ static ssize_t ncq_cmd_prio_enable_store(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (kstrtoint(buf, 0, &ncq_cmd_prio_enable))
-		return -EINVAL;
-
-	if (ncq_cmd_prio_enable != 0 && ncq_cmd_prio_enable != 1) {
-		dev_err(&sdev->sdev_gendev,
-			"%s: Invalid NCQ cmd prio %d (0/1 only)\n",
-			__func__, ncq_cmd_prio_enable);
+	if (kstrtobool(buf, &enable))
 		return -EINVAL;
-	}
 
-	rcu_read_lock();
-	vpd_pg89 = rcu_dereference(sdev->vpd_pg89);
-	if (!vpd_pg89 || vpd_pg89->len < LEAPRAID_VPD_PG89_MIN_LEN) {
-		rcu_read_unlock();
+	if (!sas_ata_ncq_prio_supported(sdev))
 		return -EINVAL;
-	}
 
-	ncq_supported = (vpd_pg89->data[LEAPRAID_VPD_PG89_NCQ_BYTE_IDX] >>
-			 LEAPRAID_VPD_PG89_NCQ_BIT_SHIFT) &
-			LEAPRAID_VPD_PG89_NCQ_BIT_MASK;
-	rcu_read_unlock();
-	if (ncq_supported)
-		sas_device_priv_data->ncq_cmd_prio_enable =
-			ncq_cmd_prio_enable;
+	sas_device_priv_data->ncq_prio_enable = enable;
 	return count;
 }
 
 static DEVICE_ATTR_RO(sas_device_handle);
+static DEVICE_ATTR_RO(sas_ncq_prio_supported);
+static DEVICE_ATTR_RW(sas_ncq_prio_enable);
+
+static bool leapraid_sdev_is_sata(struct scsi_device *sdev)
+{
+	struct scsi_target *starget = sdev->sdev_target;
+	struct leapraid_starget_priv *starget_priv = starget->hostdata;
+	struct leapraid_sas_dev *sas_dev;
 
-static DEVICE_ATTR_RW(ncq_cmd_prio_enable);
+	if (!starget_priv)
+		return false;
+
+	sas_dev = starget_priv->sas_dev;
+	return sas_dev && (sas_dev->dev_info & LEAPRAID_DEVTYP_SATA_DEV);
+}
 
 static struct attribute *leapraid_sdev_attrs[] = {
 	&dev_attr_sas_device_handle.attr,
-	&dev_attr_ncq_cmd_prio_enable.attr,
+	&dev_attr_sas_ncq_prio_supported.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL,
 };
 
-ATTRIBUTE_GROUPS(leapraid_sdev);
+static umode_t leapraid_sdev_attr_is_visible(struct kobject *kobj,
+					     struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	if (attr == &dev_attr_sas_ncq_prio_supported.attr ||
+	    attr == &dev_attr_sas_ncq_prio_enable.attr)
+		if (!leapraid_sdev_is_sata(sdev))
+			return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group leapraid_sdev_attr_group = {
+	.attrs = leapraid_sdev_attrs,
+	.is_visible = leapraid_sdev_attr_is_visible,
+};
+
+static const struct attribute_group *leapraid_sdev_groups[] = {
+	&leapraid_sdev_attr_group,
+	NULL,
+};
 
 static struct scsi_host_template leapraid_driver_template = {
 	.module = THIS_MODULE,
-- 
2.25.1

