Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F1132D0DE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413083; cv=none; b=jGG76SvTjRXA5sDaWy0FPR0jWqLIG5OtAPiKp3GMSR/aaXnI+HH3kSnxWBXFWyBkgVkfmHYqdlI/MbtKXGUooygqINNVPZf3WoU4jggxZssq74sjBpDacrWJ+74XzqSgj0bjOVIsxl9YbWUmxQZG3U5kSve1+NAgemIwJuRvSeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413083; c=relaxed/simple;
	bh=0VlneB30FVhi6ckREc4C/e8nnUhhXw+xlKjHB2aXC68=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YQvhiY6Nwz5N3O0MPzFh/buqiNKhap8JhI/D5rPzkXqxgdy+s5ppnSEJUaK7QGOKhy7jf+i6S+0bBfICOSRStWLk+HJsdYiyjRoIrHqcYIdi74RHoqB2mYnWypBiv+JRtEgc4NPvGRIkLrzIX6+Q3E1MRABipspHY/Vs3CsObZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nxkOf63O; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nxkOf63O"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81c68fef4d4so77061b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2026 09:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768413081; x=1769017881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uHdJBd8jMxMRZo0RZLZ+zHyApr0XgodixoY/B3frsaI=;
        b=nxkOf63ONQUdmFOk+tGK6QWRE0JX74fNcqRRhhgPil9gI3Xyhi1wyAnszHd7wOf3gT
         4RFd8WxfMYuQr6i2MuRzn1YE6JrjndH3FXAAfRWjQ2l861u3giLEJvyB3+dKwHPlt3L3
         J1jKMb3CnIRvJb8vdI+yuNM75rSAKaZeBRc2TSSBPCeYJnF30V07Rdx2rw06ZeXvf+K8
         puK6UlYbXbo25oV7ildb5o+hCc/3LKint3yqLoksyMROwGlZkGdD7/DNAVv9DCQvCfDk
         HHz6w2irIiT3EIYm0Erd26k8IdSufduUURwCIga0zfd6/UUq+Ou1CsUKz8BabCBeNvtv
         Awfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413081; x=1769017881;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uHdJBd8jMxMRZo0RZLZ+zHyApr0XgodixoY/B3frsaI=;
        b=PGaWbXyz4sc7JXbueGDrO2A+SWSIgFc08HurpcgZ28kpHSgYctHzps0nM+5ksg1NeN
         C8Peg/hd30K4RQ2l785ss0FLhI4MZkOVTKvDgI/9fEaADCdty82gt3X/LNmF2IybDNjm
         nSqfr35zLtUJl81OG5ql+SQjeBb8MJ8Nh4Jv+g0vApCt8vUg2/V5b/jZHupePO09FOpO
         DiDGuoqsyhLX0uqwkLy57bkplOgZvDuMscOLkO3KsQBnoGOU1MJWrrySYNp+xjQp5DBE
         oack63xCgKhOwPyNFad4TD/aTpP5BLLXkL9HjZTyUJFkkoYfb6O/F80TniiC9RxxUvaZ
         yqBQ==
X-Gm-Message-State: AOJu0YxbqPvXmv3NzeCbLvkVRHLG/uIl16NzYqL0N93uLNb7Ke3pzluP
	MGrM+uRaIj91YeyaZ3GA0bD9R1dzY8aiYhBkQCLDAGubr51iyP0suX4txMvxPST5vQi4aKofODD
	pyNDqAD+Am6/g5g==
X-Received: from pfay10.prod.google.com ([2002:a05:6a00:180a:b0:81f:7aad:edfa])
 (user=ipylypiv job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6ca4:b0:81e:f43a:3535 with SMTP id d2e1a72fcca58-81f82012706mr2706210b3a.66.1768413080718;
 Wed, 14 Jan 2026 09:51:20 -0800 (PST)
Date: Wed, 14 Jan 2026 09:51:15 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114175115.384741-1-ipylypiv@google.com>
Subject: [PATCH] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
From: Igor Pylypiv <ipylypiv@google.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
exposes the Unit Serial Number, which is derived from the Device
Identification Vital Product Data (VPD) page 0x80.

Whitespace is stripped from the retrieved serial number to handle
the different alignment (right-aligned for SCSI, potentially
left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
of the PRODUCT SERIAL NUMBER field for the translation is not assured."

This attribute is used by tools such as lsblk to display the serial
number of block devices.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/scsi_lib.c    | 53 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c  | 14 ++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 68 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 93031326ac3e..dc09785c050c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
 #include <linux/completion.h>
+#include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/init.h>
@@ -3451,6 +3452,58 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 }
 EXPORT_SYMBOL(scsi_vpd_lun_id);
 
+/**
+ * scsi_vpd_lun_serial - return a unique device serial number
+ * @sdev: SCSI device
+ * @sn:   buffer for the serial number
+ * @sn_size: size of the buffer
+ *
+ * Copies the device serial number into @sn based on the information in
+ * the VPD page 0x80 of the device. The string will be null terminated
+ * and have leading and trailing whitespace stripped.
+ *
+ * Returns the length of the serial number or error on failure.
+ */
+int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
+{
+	int len;
+	const unsigned char *d;
+	const struct scsi_vpd *vpd_pg80;
+
+	rcu_read_lock();
+	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
+	if (!vpd_pg80) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
+
+	len = vpd_pg80->len - 4;
+	d = vpd_pg80->data + 4;
+
+	/* Skip leading spaces */
+	while (len > 0 && isspace(*d)) {
+		len--;
+		d++;
+	}
+
+	/* Skip trailing spaces */
+	while (len > 0 && isspace(d[len - 1]))
+		len--;
+
+	if (sn_size < len + 1) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	memcpy(sn, d, len);
+	sn[len] = '\0';
+
+	rcu_read_unlock();
+
+	return len;
+}
+EXPORT_SYMBOL(scsi_vpd_lun_serial);
+
 /**
  * scsi_vpd_tpg_id - return a target port group identifier
  * @sdev: SCSI device
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 99eb0a30df61..d80a546f54c2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1013,6 +1013,19 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
+static ssize_t
+sdev_show_serial(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	ret = scsi_vpd_lun_serial(sdev, buf, PAGE_SIZE);
+	if (ret < 0)
+		return ret;
+	return sysfs_emit(buf, "%s\n", buf);
+}
+static DEVICE_ATTR(serial, S_IRUGO, sdev_show_serial, NULL);
+
 #define BLIST_FLAG_NAME(name)					\
 	[const_ilog2((__force __u64)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
@@ -1257,6 +1270,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_device_busy.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_model.attr,
+	&dev_attr_serial.attr,
 	&dev_attr_rev.attr,
 	&dev_attr_rescan.attr,
 	&dev_attr_delete.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d32f5841f4f8..9c2a7bbe5891 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -571,6 +571,7 @@ void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
+extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
 
 #ifdef CONFIG_PM
-- 
2.52.0.457.g6b5491de43-goog

