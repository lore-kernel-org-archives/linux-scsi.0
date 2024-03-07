Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4417E13E7CD
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709847872; cv=none; b=h4/C+lvg2j67GyaE1HeL6quwfG0+MhYzBNfZlJGJt2j5iOjvGckgLgxATz9UlYmTgWVFHMxkTOVosI2uR/7Ah3pMw0m2cc5x7zQQIg4sZUdz+Nuvm0BomZ7uf6XYyk2A1AekLm38zuBT0w1GOEiDrxgtR+sJ55HCj46Wx2oABnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709847872; c=relaxed/simple;
	bh=YSRhJbkprUQQfCWFGDumNRfHglngYq6Oc0DzcoBcuzk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HUjYI+sylnbBU7Q07N3c/M+ATywGSlHuqrJRv87UHYEFSq+FQEBp8ciQ2VnrEAJCPKHC2x65QtArdrCB8oATjmgXu8Cif31wj9w5jg6w6MDGKWhY/s1hXDA0fEKLr5CnQ1falylZuxtCB03gkHuitvf/PQt+4x3hF6MUQf0wqEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UNg3IrAZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UNg3IrAZ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso658998276.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Mar 2024 13:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709847868; x=1710452668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/UjozYWsvAN/C5p7VPWLV1GhNI2WpC2ansFPUNxUuY=;
        b=UNg3IrAZIrKJGu0prw6rH31+vj6uMSMTvHYqHzzrTwsCiFFMY6hNGdMSSKRXFILu/8
         hWToUy1UiPES++7Yg5l6bQeDmz9y7l2U5m275rV2L/DY/4T1eTr0JjmOw3Nf2eQns8+l
         b9qiHu68JlaQBCwsAwQt1X/Hlwrzsegg+3Q937fxUsF6WePy5A4seEiT4eht9yWIo6/L
         A8bFBaq8JnUQKkI0y2ogPt8euS/02lVhX25TDLA4IRZuiFKJo+hXC0fQ2WfEhWrFdgeb
         3at+1xADEjBTquij7n0qq6cqvJB7Hi4MSevX8i3zrl2hxr4OpYW62CGl+6P817mxSyuT
         ENuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709847868; x=1710452668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/UjozYWsvAN/C5p7VPWLV1GhNI2WpC2ansFPUNxUuY=;
        b=twW434sXTgxc+biiFOvcCJb2bRjXkUYH17UfuL3lq5zeyqvai6LWtbxvVlCUwlTPgi
         W9kv/YmTLdo8MJzoAJfqZgZm9FmyJxceKjOwmQeWKHXi17680MjJqCOuA8Epmgy54Dl7
         bG9gU9nB1+VI6i9aMCqZPGn1sWd8uJIecBDKr66Ok2gSOaTARWUAI9Ls1Xra974vjQ9a
         XP/m2SZZKuyGrs5mCterGlBmFJNliK39Q1F8oyx88z5yL5D/QA3931o7KbqbNEZYtRXn
         PoLbLOpaSIv6De+CuJ+1DLYzSn6QCml3jyJNU6/HIf14ZfCgj8VPf2UjCS0M6tt3qorM
         8oIA==
X-Forwarded-Encrypted: i=1; AJvYcCVEWB5BtVL4ZE6kVF2foIThhkrb6Q+4TVFidLGbH8cMGOl/5F+dfpYoTS8E6U7zz5uUovMFVN4T7EoS1W1Wh4gcCJk1uAhAEC8erQ==
X-Gm-Message-State: AOJu0Yx+iW2CXOZodS4TRyLwYPSNGUYvCROO15y9rR5offBYKXR4IcNu
	ZeFBEhvBr/aGs9GXA2TYcQVfoU54XEv++wcISIr0U13ElAzR3NNAtcNi9svLU57UuDTlrbfC7u1
	Wamodg6lAWg==
X-Google-Smtp-Source: AGHT+IFw8QcatIQRdLsa6m2Kc7Ojj+5jjhwEI1+rXhke6KtmZMw7oScCyZHQIs5JY2TCjpz6Lgak40Ld5ysn2w==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69c0:c447:593d:278c])
 (user=ipylypiv job=sendgmr) by 2002:a25:4d45:0:b0:dc6:e884:2342 with SMTP id
 a66-20020a254d45000000b00dc6e8842342mr731884ybb.5.1709847868286; Thu, 07 Mar
 2024 13:44:28 -0800 (PST)
Date: Thu,  7 Mar 2024 13:44:13 -0800
In-Reply-To: <20240307214418.3812290-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307214418.3812290-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307214418.3812290-3-ipylypiv@google.com>
Subject: [PATCH v8 2/7] scsi: libsas: Define NCQ Priority sysfs attributes for
 SATA devices
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

Libata sysfs attributes cannot be used for libsas managed SATA devices
because the ata_port location is different for libsas.

Defined sysfs attributes (visible for SATA devices only):
- /sys/block/sda/device/ncq_prio_enable
- /sys/block/sda/device/ncq_prio_supported

The newly defined attributes will pass the correct ata_port to libata
helper functions.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/libsas/sas_ata.c | 82 +++++++++++++++++++++++++++++++++++
 include/scsi/sas_ata.h        |  6 +++
 2 files changed, 88 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 12e2653846e3..b57c041a5544 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -964,3 +964,85 @@ int sas_execute_ata_cmd(struct domain_device *device, u8 *fis, int force_phy_id)
 			       force_phy_id, &tmf_task);
 }
 EXPORT_SYMBOL_GPL(sas_execute_ata_cmd);
+
+static ssize_t sas_ncq_prio_supported_show(struct device *device,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+	bool supported;
+	int rc;
+
+	rc = ata_ncq_prio_supported(ddev->sata_dev.ap, sdev, &supported);
+	if (rc)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", supported);
+}
+
+DEVICE_ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
+
+static ssize_t sas_ncq_prio_enable_show(struct device *device,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+	bool enabled;
+	int rc;
+
+	rc = ata_ncq_prio_enabled(ddev->sata_dev.ap, sdev, &enabled);
+	if (rc)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", enabled);
+}
+
+static ssize_t sas_ncq_prio_enable_store(struct device *device,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+	bool enable;
+	int rc;
+
+	rc = kstrtobool(buf, &enable);
+	if (rc)
+		return rc;
+
+	rc = ata_ncq_prio_enable(ddev->sata_dev.ap, sdev, enable);
+	if (rc)
+		return rc;
+
+	return len;
+}
+
+DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
+	    sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
+
+static struct attribute *sas_ata_sdev_attrs[] = {
+	&dev_attr_ncq_prio_supported.attr,
+	&dev_attr_ncq_prio_enable.attr,
+	NULL
+};
+
+static umode_t sas_ata_attr_is_visible(struct kobject *kobj,
+				       struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+
+	if (!dev_is_sata(ddev))
+		return 0;
+
+	return attr->mode;
+}
+
+const struct attribute_group sas_ata_sdev_attr_group = {
+	.attrs = sas_ata_sdev_attrs,
+	.is_visible = sas_ata_attr_is_visible,
+};
+EXPORT_SYMBOL_GPL(sas_ata_sdev_attr_group);
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index 2f8c719840a6..92e27e7bf088 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -39,6 +39,9 @@ int smp_ata_check_ready_type(struct ata_link *link);
 int sas_discover_sata(struct domain_device *dev);
 int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
 		    struct domain_device *child, int phy_id);
+
+extern const struct attribute_group sas_ata_sdev_attr_group;
+
 #else
 
 static inline void sas_ata_disabled_notice(void)
@@ -123,6 +126,9 @@ static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *p
 	sas_ata_disabled_notice();
 	return -ENODEV;
 }
+
+#define sas_ata_sdev_attr_group ((struct attribute_group) {})
+
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.44.0.278.ge034bb2e1d-goog

