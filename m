Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D4F3FB32
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709410613; cv=none; b=UyvcbNhAcsy7IEOtVFxAV5dfw1t/cu05y9lR4x0uHiKSieKLlFxUiYVuIpd7IVTSEGdZXFAEQGpTd7Kv+IYppgzeqBlscZGOHqyqhkysCMby0qhXuTeoc4iJ4mCgeJ4U5THE9KNQSG1/p2q0KmaeStckLJwDHg0ZG7+uuPKIE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709410613; c=relaxed/simple;
	bh=Dr1gHME6UhZzljl3CDtFvx0fMB3rr1EwYhk4f6Q7U3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RVRH0VimJs7/1MXvxawGo+y9IhvEoM+qS5f3w2UYr6jA2EQWEfUlRLVo4I0XMfL+x7Cnat9tfet42CM6+wY6JGsgm5xvUX7g9VttXMFsWeI+8UpwqHc8FFdQxpIkFZbD6GQOmjEZrHvzhptPhKjfUwNC2gc0X+dvPa/acowsW9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SEsPWD7I; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SEsPWD7I"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso6963732276.1
        for <linux-scsi@vger.kernel.org>; Sat, 02 Mar 2024 12:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709410610; x=1710015410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4qRVCwUT6U2lE1it/3KAP9Dql1inh3yxdaUzH18pmU=;
        b=SEsPWD7IVOO+3ST4gdLVG0GO4xL+t4KuVrEYFMnDeb2SLrvfxK0BFOBayljFLQftXJ
         70zkYmungWf0fLlyyXBnht+IErLAMGFb//cBhPgxmrRF7SuBtwYI8QU8RAgKaaKJ86t3
         DlIHaMx0jDhCSDE38N6qB72DZUBHXVQeKwtIZwz8AIJeKLo9zLmM8A6ncIbRXb4gNJor
         nWAFtqGyfnPuTNsHJXdbSScbe/LR0ryGM1EjIVmU8SMAlClgpPIX4LI1KXn7WH9r4+vk
         Vo59BGXw7NucrJukJMYQQ/nyF8cg55RWtlP1pcAfgCfqqcHro5I9ByOZ9axjgw2bbYO3
         UcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709410610; x=1710015410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4qRVCwUT6U2lE1it/3KAP9Dql1inh3yxdaUzH18pmU=;
        b=gFjGTphSjX69Bor6NXbvQZs2rsm9B0h5ziWJ2E4V3JdArNOKgBfF0e/Lwc7ZAKPbOq
         NKeO4m/WzPd9ZBp+Xbk328vLO7rzk93JGyyYkRIgLcpir3rPBr+e9KUgGdJGyw0FZHDo
         aPl6/OobeY0Mi9cbb7WbKWkap6wQ1GBrXNzjSXFxLbza5nuvW5Qv3VB7B/zB02ea/H0f
         TboJlcBZ80dYxRqD/NXZAwxVVjPs93xL1Sw4kz4LU2Wb/i4hwZYL+zS+g/7j6De5xNvu
         PWbo4SaIb1lrcwjd3gMEzW8MDsRxh2D/Ea8XqU1ma3DhGZ5xk/muSlzD2p/YKs7PY6oV
         fWlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQVSObHGmLH5dGLusviWktGwxqT5lgY1SgmA+Xr3jAlv06ntyb34bjnjLrqHu0zaSc3DVIVUWzrTLXeJDPUpcMEMJmV2XVDxCiOw==
X-Gm-Message-State: AOJu0Yz6vmVK0B4m0XQnld/OXEFnV1P86/ZpTtmr4DfxljjzRoJ5+O1d
	pYd2YAXJNcQqI0qUmFYIq7wvLCR/PGCIid58fq1I1Ayo+S6QCMsr4JxEM34COPXlbYojEXhGhHs
	DixygcXUT6A==
X-Google-Smtp-Source: AGHT+IGOW7SBJh4WP3KpmE2TKXdeEoDMr8V7/Lvbu1fuVnc60rYhGJoHBqHZ0S79O1x3nEtKwjjpI25HI3zqFA==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:41a7:9019:9a7:b404])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:2492:b0:dcb:b9d7:2760 with SMTP
 id ds18-20020a056902249200b00dcbb9d72760mr1372955ybb.13.1709410610740; Sat,
 02 Mar 2024 12:16:50 -0800 (PST)
Date: Sat,  2 Mar 2024 12:16:30 -0800
In-Reply-To: <20240302201636.1228331-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240302201636.1228331-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302201636.1228331-2-ipylypiv@google.com>
Subject: [PATCH v3 1/7] ata: libata-sata: Factor out NCQ Priority
 configuration helpers
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

Export libata NCQ Priority configuration helpers to be reused
for libsas managed SATA devices.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/ata/libata-sata.c | 139 +++++++++++++++++++++++++++-----------
 include/linux/libata.h    |   4 ++
 2 files changed, 103 insertions(+), 40 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 0fb1934875f2..a8d5e36d5211 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -848,29 +848,73 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 	    ata_scsi_lpm_show, ata_scsi_lpm_store);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+/**
+ *	ata_ncq_prio_supported - Check if device supports NCQ Priority
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *
+ *	Helper to check if device supports NCQ Priority feature,
+ *	usable with both libsas and libata.
+ */
+int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev)
+{
+	struct ata_device *dev;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev)
+		rc = -ENODEV;
+	else
+		rc = !!(dev->flags & ATA_DFLAG_NCQ_PRIO);
+	spin_unlock_irqrestore(ap->lock, flags);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_ncq_prio_supported);
+
 static ssize_t ata_ncq_prio_supported_show(struct device *device,
 					   struct device_attribute *attr,
 					   char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(device);
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	int rc;
+
+	rc = ata_ncq_prio_supported(ap, sdev);
+	if (rc < 0)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", rc);
+}
+
+DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
+EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
+
+/**
+ *	ata_ncq_prio_enabled - Check if NCQ Priority is enabled
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *
+ *	Helper to check if NCQ Priority feature is enabled,
+ *	usable with both libsas and libata.
+ */
+int ata_ncq_prio_enabled(struct ata_port *ap, struct scsi_device *sdev)
+{
 	struct ata_device *dev;
-	bool ncq_prio_supported;
-	int rc = 0;
+	unsigned long flags;
+	int rc;
 
-	spin_lock_irq(ap->lock);
+	spin_lock_irqsave(ap->lock, flags);
 	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev)
 		rc = -ENODEV;
 	else
-		ncq_prio_supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
-	spin_unlock_irq(ap->lock);
-
-	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_supported);
+		rc = !!(dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED);
+	spin_unlock_irqrestore(ap->lock, flags);
+	return rc;
 }
-
-DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
-EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
+EXPORT_SYMBOL_GPL(ata_ncq_prio_enabled);
 
 static ssize_t ata_ncq_prio_enable_show(struct device *device,
 					struct device_attribute *attr,
@@ -878,50 +922,45 @@ static ssize_t ata_ncq_prio_enable_show(struct device *device,
 {
 	struct scsi_device *sdev = to_scsi_device(device);
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *dev;
-	bool ncq_prio_enable;
-	int rc = 0;
+	int rc;
 
-	spin_lock_irq(ap->lock);
-	dev = ata_scsi_find_dev(ap, sdev);
-	if (!dev)
-		rc = -ENODEV;
-	else
-		ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED;
-	spin_unlock_irq(ap->lock);
+	rc = ata_ncq_prio_enabled(ap, sdev);
+	if (rc < 0)
+		return rc;
 
-	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_enable);
+	return sysfs_emit(buf, "%d\n", rc);
 }
 
-static ssize_t ata_ncq_prio_enable_store(struct device *device,
-					 struct device_attribute *attr,
-					 const char *buf, size_t len)
+/**
+ *	ata_ncq_prio_enable - Enable/disable NCQ Priority
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *	@enable: true - enable NCQ Priority, false - disable NCQ Priority
+ *
+ *	Helper to enable/disable NCQ Priority feature, usable with both
+ *	libsas and libata.
+ */
+int ata_ncq_prio_enable(struct ata_port *ap, struct scsi_device *sdev,
+			bool enable)
 {
-	struct scsi_device *sdev = to_scsi_device(device);
-	struct ata_port *ap;
 	struct ata_device *dev;
-	long int input;
+	unsigned long flags;
 	int rc = 0;
 
-	rc = kstrtol(buf, 10, &input);
-	if (rc)
-		return rc;
-	if ((input < 0) || (input > 1))
-		return -EINVAL;
+	spin_lock_irqsave(ap->lock, flags);
 
-	ap = ata_shost_to_port(sdev->host);
 	dev = ata_scsi_find_dev(ap, sdev);
-	if (unlikely(!dev))
-		return  -ENODEV;
-
-	spin_lock_irq(ap->lock);
+	if (unlikely(!dev)) {
+		rc = -ENODEV;
+		goto unlock;
+	}
 
 	if (!(dev->flags & ATA_DFLAG_NCQ_PRIO)) {
 		rc = -EINVAL;
 		goto unlock;
 	}
 
-	if (input) {
+	if (enable) {
 		if (dev->flags & ATA_DFLAG_CDL_ENABLED) {
 			ata_dev_err(dev,
 				"CDL must be disabled to enable NCQ priority\n");
@@ -934,9 +973,29 @@ static ssize_t ata_ncq_prio_enable_store(struct device *device,
 	}
 
 unlock:
-	spin_unlock_irq(ap->lock);
+	spin_unlock_irqrestore(ap->lock, flags);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_ncq_prio_enable);
+
+static ssize_t ata_ncq_prio_enable_store(struct device *device,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	bool enable;
+	int rc;
+
+	rc = kstrtobool(buf, &enable);
+	if (rc)
+		return rc;
+
+	rc = ata_ncq_prio_enable(ap, sdev, enable);
+	if (rc)
+		return rc;
 
-	return rc ? rc : len;
+	return len;
 }
 
 DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 26d68115afb8..f3ff2bf3ec6b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1157,6 +1157,10 @@ extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 				  int queue_depth);
+extern int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev);
+extern int ata_ncq_prio_enabled(struct ata_port *ap, struct scsi_device *sdev);
+extern int ata_ncq_prio_enable(struct ata_port *ap, struct scsi_device *sdev,
+			       bool enable);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
-- 
2.44.0.278.ge034bb2e1d-goog

