Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC42339857
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586332; cv=none; b=KiAs1K0ek96ybxhLqGGSsKK9VO4mdjknRQqkLXevPdESz+q9eHWIEUA1zOMWGofutCZXih1OZ0xPhrM+Sxc/zMx/5nN6eQK0xfaXVVa6yUn6rvLxFFMNdxYQM0HtivZ6AIsK/35Rm298F36NpEPLyq/u93NAHXrmDDmNnOEcMWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586332; c=relaxed/simple;
	bh=qu/Fz4UEyq1oOpxLbieusUW35tltYWUfD2p/iMP7H2k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pu1NbbW0mCrP0rNItDRk4r2pdQlSvIE2mXC8xnmXx6uAmllxBhqu93YQX5Qjet0W+vXNHYW4SeBD+foX5n6w9HYPHf20qWV46q3FjWCtFMMf/M4XVEJ8oo9/sMHI4jr3Jp2dLLya6GVs0HEZm2ioPQ8N9gf43A037hn1+GO3ZDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JgEAEmQj; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JgEAEmQj"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f1f69eec6so23262695ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 09:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768586331; x=1769191131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cY5JYqVcIMLD/+VD15f76fWimBZZz3wJhNHYazJcVMk=;
        b=JgEAEmQjX/HeeUVVj/9DZrFvL0nhOnaBQSpdU8gg4iz/TXcwJcCoZcqUi8NyTc8kQk
         NB6Wva3slhd6sHlBI5CRZHnTETqi+xADMyIeyagkmQ4obcm7IHZ0p5n8QFYiiPi8gIjy
         bSCuEMKED08p4LfMWEfkev/Q0F9hdT2gOv3r219rFBZ5f6XBcMEqymB6i1lGYnw9Xz+V
         lfcBE2lPjrBqANA2inmFDYOqH+D89p/1gZbdAd+xtMc3pYoKO1vxp5Hk4eqMRBX6pj6s
         hPFWC+ZwLAbN2lErJ5U9+PrnO8yRjoz9RG4w14UsWN/3SZgS5AyMb6ifAGoYyJ2mqcJN
         yffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768586331; x=1769191131;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cY5JYqVcIMLD/+VD15f76fWimBZZz3wJhNHYazJcVMk=;
        b=e4T4CyZEFKr+YIWm/zTIaEq6MRSFkHrwk8joQo1KSzpQN60WEKw1tFfIt7p8HmY3ik
         JiPbacbDAbt/cGZW9/WCt74IOFJvbE8Np9ULkw+gxwztCfyC31YxA8g+od2+GDDbtybx
         SzLxIJ/20THk+/RC7+681bef4T4hCVoqLiAreuwK3z/iXfDX6UHWCfAlvaL55Z2b2DBU
         /OmWVcIOfUMeRUvcS0fBramu4r406PVQD9eFA+fA/gCAgQn7Ko+yaU0R6hP5kW23NmKO
         O4xJPu4zZoJOqDsGRsSMemuN7aJhIPr/75sFt+zQDlGOEfc0nk9qxoYLWqIy4i/Antlm
         4POQ==
X-Forwarded-Encrypted: i=1; AJvYcCXO8nhrqhP9ij0CoNgl/6oNSN0r+Fg312m6sYHJeLMMFBbNsowzVaHp4Qz1umLDhTyprpWeGbXDgbbY@vger.kernel.org
X-Gm-Message-State: AOJu0YzlLaOlBYm8Y8kkwIC48u1FShTV7AF80xh+zzjAicdbhlbM94p0
	sotRvWiWX0Abs8qDnxULXT+ywqtBgD71i3mjHkIA2M/GoBmgFe2azOUYggN3mteTmewXYykGl0Y
	J44qEpV/BGzsFVQ==
X-Received: from plbv22.prod.google.com ([2002:a17:903:44d6:b0:297:e585:34c1])
 (user=ipylypiv job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:380e:b0:2a0:9402:2175 with SMTP id d9443c01a7336-2a717569367mr34654095ad.27.1768586330839;
 Fri, 16 Jan 2026 09:58:50 -0800 (PST)
Date: Fri, 16 Jan 2026 09:58:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260116175847.3131464-1-ipylypiv@google.com>
Subject: [PATCH v2] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
From: Igor Pylypiv <ipylypiv@google.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
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

v1->v2 changes:
- Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
- Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().

 drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c  | 14 ++++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 62 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c7d6b76c86d2..16eed661d657 100644
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
@@ -3451,6 +3452,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
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
+	const struct scsi_vpd *vpd_pg80;
+	const unsigned char *d;
+	int len;
+
+	guard(rcu)();
+	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
+	if (!vpd_pg80)
+		return -ENXIO;
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
+	if (sn_size < len + 1)
+		return -EINVAL;
+
+	memcpy(sn, d, len);
+	sn[len] = '\0';
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

