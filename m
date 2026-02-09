Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEFD30F803
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 21:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770672119; cv=none; b=RSv/iJoJHxqWEBj0Unz5dxs2GhiIFTYCKy/R5nIMek0HvGMa+Ozf3EWnlJEQHueQiDfpGakbRv3hpQ37qHxyQEPYUutM4HxMpOnxHtNm6LPdJeJZIK8OfDdW3PdNRKL7UTWJ4OoKa5WMG6VXKG+KY8QvKhcwl3EsezKjYvEqqVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770672119; c=relaxed/simple;
	bh=jgWvaQR0EIAORcGXYrAtndNCUokb7X0l1Mv6K8fcCfw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WmaVCEi+cgEJJsqmlMWnU6D6Y0/3CLTzw1KbWnnfkjbOP1acFhV9/pzUQfQ2LeA5575Y3dz5/WqEQdJHRG94jowlFuer7NLUo29MiJhhczeEW8oNsJS1jX0AcgM+xzpu7o8OgH4KBqd1xSedVwVyByLybcpjOwvWQ16O/m6Nry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TfmwBafU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TfmwBafU"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a77040ede0so1138305ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Feb 2026 13:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770672115; x=1771276915; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GP/nw0GntmUv4Aco/T3zEuIFJQ9TGTiXcOsKoDvcON0=;
        b=TfmwBafUCrkX+YM3Ll28XgY7kMvPcbOkEbxESiS21BR7elgq/DWy9kkVcnssOhuLGE
         hoQuefTj5IDpdYhULy+RS8de5MCOQRsQ5JReVAo3y/771TVJjmMmrgPNuFTH2QG8P6oh
         a6x3nmuNeqFDQmdWcnwVyKiXyvOSSNjLjvNJ4vZf7NOy8Bf090u8kOArf5b7jzSdF4KS
         3/Lv3OilEvJDe2OFPdCJP6CQyhitaMeLZ3OfqBNYCoDPLPZTeLSobcvj4RS5woyIZEsL
         nbSGh6/U+orO8Le+USD3hTlSv4o7UHBWY4QcS9ngkIjBNKY5/vieP+5TAIhIKfFqdX5n
         vKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770672115; x=1771276915;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GP/nw0GntmUv4Aco/T3zEuIFJQ9TGTiXcOsKoDvcON0=;
        b=B00cehtz8H79en/ZF1uPCMeYgoQzB9XnCfwFMOVOwan/98Y96KDUYOyS8kqa1XPveZ
         9BlRwB82dHy3+Esbqwn7dyZ98CfwwHYCkNuRrW99USzs++SM1tZz+AujRLKtStpaa7er
         3aCS+gao+CyHg2l609B0nBq0KHxk5thm7viewiDOVdH0WCCjOTFlVpsNFD7PyiAgW+0v
         bvDWf99bwgu60QTOt5cq1g552uIAlt9R8mIqz6QD5WQNXS9a74CKRnu+L6GobBSjsZxA
         0pPv84iqNxOoJlMsrMQoNtvBnkpYz1cirYcqFjx/EGbQj5cTbus6Twz61qi8UuWnwzlw
         d7FA==
X-Forwarded-Encrypted: i=1; AJvYcCV+GtT9yMPp3kQiDSiNRaZd8N3qOuClikhBhejF4NG2z8v1dwcn36LLWp2fwFdb60nmqNOOJQsO9N/K@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6faPB7a9fk2JewA7NUdzoGP8lVgOgUckWWwtvA8PM1KNNAnLN
	C2loZF7YQpm2cuVN6pCJk1q+orW68IStvf+TWLxayC364zf2eIcj6VBgoTyqTLtkxPDi/58xm08
	yEIHvgRlEJftupQ==
X-Received: from pjbst4.prod.google.com ([2002:a17:90b:1fc4:b0:356:2fe0:f5b4])
 (user=ipylypiv job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e7c3:b0:356:35a5:4a64 with SMTP id 98e67ed59e1d1-35635a5534fmr4964057a91.4.1770672114993;
 Mon, 09 Feb 2026 13:21:54 -0800 (PST)
Date: Mon,  9 Feb 2026 13:21:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209212151.342151-1-ipylypiv@google.com>
Subject: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
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

v2->v3 changes:
- Replaced sysfs_emit(buf, "%s\n", buf) with a manual newline placement
  to avoid undefined behavior of passing the output buffer as an input.

v1->v2 changes:
- Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
- Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().


 drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c  | 16 +++++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 64 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4a902c9dfd8b..c17fbe4dd845 100644
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
@@ -3459,6 +3460,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
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
index 99eb0a30df61..9c4f47e7a298 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1013,6 +1013,21 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
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
+
+	buf[ret] = '\n';
+	return ret + 1;
+}
+static DEVICE_ATTR(serial, S_IRUGO, sdev_show_serial, NULL);
+
 #define BLIST_FLAG_NAME(name)					\
 	[const_ilog2((__force __u64)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
@@ -1257,6 +1272,7 @@ static struct attribute *scsi_sdev_attrs[] = {
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
2.53.0.rc2.204.g2597b5adb4-goog

