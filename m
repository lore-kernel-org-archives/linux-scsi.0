Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B61E6FD0
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 01:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709688155; cv=none; b=TMd9M63CgJtB/6azotgRezlaSY2Rn4M1vs2XJfUH2YvuremxxPZ+ni7Ld25S5JeLuXQ8m6cdJoJ78JUggEYD0sDzHM2IE2e1P9FU6mLpxV+CeA8FiFlc6Nm8T79UHvxcUPmFSP+spE9JV7hJijg6IBYeZizFlUmQ96KZpJbuRwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709688155; c=relaxed/simple;
	bh=HdE6FN0o7wTsTE4Ul3fnw6MLY1Eiy7U6ACIH7VY572U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I5IwNeHcDYxCWreRb5T5/4htfLk+KizPVzl35fumsC43frveNzFjX7I1IwXj7Ktmf6XidHXH+Whcv5QBJtvd8sMh6rkptYYAzun0mWdN4mVaLuIVCY+Hh6MvgmyExyZyFqnmg/tD0b//Xl6jTu/glB4uZFz1NZtu7WhCr/ZZqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swLQjKvz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swLQjKvz"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609a1063919so26756907b3.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 17:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709688152; x=1710292952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hWaHPf3ur6A4qCJxa5rb9778tyG9D1zv7n6pTIOMylY=;
        b=swLQjKvzg/27APMhBRnnxlopiH/s6Yw8Rc3gmJ1cRzO2DfvEZ9kJEcpCSsrQI3xsdn
         RTEbhpmJyX/7MQalwVDKFuMmUW6ByRtFNSR9W4qs6M0c0Tw3PIvJItqOS7FPmi6X7Xgx
         LBsukHf2AE2J4GKTq78QklDhOxUts4jy4X78MIy5oDkkLQ+f+GjdtNUXKdtHMgrgdoO1
         SyDtjqfJNvvFrSmJGkVeaHjIzgez7GwqkPbIzIFvuDAHbT4WcoqRiqEeA+XgvkBZjSLt
         Eab3muGN9002jgAdhbe8V2yA/qr68TNM4kcHdg79e6uwXouz6t4tBJNtx72beEAlH5Hk
         Dvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709688152; x=1710292952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWaHPf3ur6A4qCJxa5rb9778tyG9D1zv7n6pTIOMylY=;
        b=DfqHJrorI46dVuXSMdjBQTh2La3Qay/YzJG4UXPYxzVENZ492QHv58xlaNQqjmcuO9
         o1EAnst5u/SjNZNnJ/W2hlxDkCqe3GbMj548xdH7DMHS9Y6HA72LQTTprxhTNoKR8oyu
         PAPNCRYDaYX33i9hC8HPGKNzp5hzYSakG+s0/OaxISGZHDcpJ8iZ4smTZJ87Zhd1WsxF
         zTK+tdOomah7Rv4isrYoNd/1maw93/WcyHbBBhsIbBVdI0HcPISlhpbk7vBCgR7AzHHI
         suDHr15/nEQ7stPmBr30VVHsQIdJc5tuBrA/kO3UcH5ifCiTLvasIfUYxzOuTrHxXC9G
         ZrdA==
X-Forwarded-Encrypted: i=1; AJvYcCXi29DDMSFAxhGmPxeiTQzyyqV4tMneevgISA1gHATAjA92JGtYa3h/rj+pW4Oiw9P0JQcsA10nO7eDOGLvHteiEJrmy/NVz0VLSQ==
X-Gm-Message-State: AOJu0YyYt1MUYTl76YIk+doMEU1iDc+kteshF2MzsPtv/P8yBKNoauci
	+NouUMnFKVe8pgENoC4eWWPjPONZCr5ahOIao0aZXGQmuAtAdqxVQB4z/o+XrK4zaIo661v8kNb
	CpT9XJysrjg==
X-Google-Smtp-Source: AGHT+IH1ype8EVVw3Vv5hVUATc5MuGE0VPWUCQs+MGbWunJiewT97ix6EIEegvIOjPQ/ld8NPVGY1dCsazei4w==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:690c:3508:b0:609:3212:94c7 with SMTP
 id fq8-20020a05690c350800b00609321294c7mr3942886ywb.6.1709688152470; Tue, 05
 Mar 2024 17:22:32 -0800 (PST)
Date: Tue,  5 Mar 2024 17:22:20 -0800
In-Reply-To: <20240306012226.3398927-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306012226.3398927-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306012226.3398927-2-ipylypiv@google.com>
Subject: [PATCH v7 1/7] ata: libata-sata: Factor out NCQ Priority
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

Acked-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/ata/libata-sata.c | 140 +++++++++++++++++++++++++++-----------
 include/linux/libata.h    |   6 ++
 2 files changed, 107 insertions(+), 39 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 0fb1934875f2..f00dd02dc6f8 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -848,80 +848,122 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 	    ata_scsi_lpm_show, ata_scsi_lpm_store);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
-static ssize_t ata_ncq_prio_supported_show(struct device *device,
-					   struct device_attribute *attr,
-					   char *buf)
+/**
+ *	ata_ncq_prio_supported - Check if device supports NCQ Priority
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *	@supported: Address of a boolean to store the result
+ *
+ *	Helper to check if device supports NCQ Priority feature.
+ */
+int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev,
+			   bool *supported)
 {
-	struct scsi_device *sdev = to_scsi_device(device);
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
-	bool ncq_prio_supported;
+	unsigned long flags;
 	int rc = 0;
 
-	spin_lock_irq(ap->lock);
+	spin_lock_irqsave(ap->lock, flags);
 	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev)
 		rc = -ENODEV;
 	else
-		ncq_prio_supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
-	spin_unlock_irq(ap->lock);
+		*supported = dev->flags & ATA_DFLAG_NCQ_PRIO;
+	spin_unlock_irqrestore(ap->lock, flags);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ata_ncq_prio_supported);
+
+static ssize_t ata_ncq_prio_supported_show(struct device *device,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	bool supported;
+	int rc;
 
-	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_supported);
+	rc = ata_ncq_prio_supported(ap, sdev, &supported);
+	if (rc)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", supported);
 }
 
 DEVICE_ATTR(ncq_prio_supported, S_IRUGO, ata_ncq_prio_supported_show, NULL);
 EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_supported);
 
-static ssize_t ata_ncq_prio_enable_show(struct device *device,
-					struct device_attribute *attr,
-					char *buf)
+/**
+ *	ata_ncq_prio_enabled - Check if NCQ Priority is enabled
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *	@enabled: Address of a boolean to store the result
+ *
+ *	Helper to check if NCQ Priority feature is enabled.
+ */
+int ata_ncq_prio_enabled(struct ata_port *ap, struct scsi_device *sdev,
+			 bool *enabled)
 {
-	struct scsi_device *sdev = to_scsi_device(device);
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
-	bool ncq_prio_enable;
+	unsigned long flags;
 	int rc = 0;
 
-	spin_lock_irq(ap->lock);
+	spin_lock_irqsave(ap->lock, flags);
 	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev)
 		rc = -ENODEV;
 	else
-		ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED;
-	spin_unlock_irq(ap->lock);
-
-	return rc ? rc : sysfs_emit(buf, "%u\n", ncq_prio_enable);
+		*enabled = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED;
+	spin_unlock_irqrestore(ap->lock, flags);
+	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_ncq_prio_enabled);
 
-static ssize_t ata_ncq_prio_enable_store(struct device *device,
-					 struct device_attribute *attr,
-					 const char *buf, size_t len)
+static ssize_t ata_ncq_prio_enable_show(struct device *device,
+					struct device_attribute *attr,
+					char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(device);
-	struct ata_port *ap;
-	struct ata_device *dev;
-	long int input;
-	int rc = 0;
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	bool enabled;
+	int rc;
 
-	rc = kstrtol(buf, 10, &input);
+	rc = ata_ncq_prio_enabled(ap, sdev, &enabled);
 	if (rc)
 		return rc;
-	if ((input < 0) || (input > 1))
-		return -EINVAL;
 
-	ap = ata_shost_to_port(sdev->host);
-	dev = ata_scsi_find_dev(ap, sdev);
-	if (unlikely(!dev))
-		return  -ENODEV;
+	return sysfs_emit(buf, "%d\n", enabled);
+}
+
+/**
+ *	ata_ncq_prio_enable - Enable/disable NCQ Priority
+ *	@ap: ATA port of the target device
+ *	@sdev: SCSI device
+ *	@enable: true - enable NCQ Priority, false - disable NCQ Priority
+ *
+ *	Helper to enable/disable NCQ Priority feature.
+ */
+int ata_ncq_prio_enable(struct ata_port *ap, struct scsi_device *sdev,
+			bool enable)
+{
+	struct ata_device *dev;
+	unsigned long flags;
+	int rc = 0;
+
+	spin_lock_irqsave(ap->lock, flags);
 
-	spin_lock_irq(ap->lock);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev) {
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
@@ -934,9 +976,29 @@ static ssize_t ata_ncq_prio_enable_store(struct device *device,
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
index 26d68115afb8..6dd9a4f9ca7c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1157,6 +1157,12 @@ extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 				  int queue_depth);
+extern int ata_ncq_prio_supported(struct ata_port *ap, struct scsi_device *sdev,
+				  bool *supported);
+extern int ata_ncq_prio_enabled(struct ata_port *ap, struct scsi_device *sdev,
+				bool *enabled);
+extern int ata_ncq_prio_enable(struct ata_port *ap, struct scsi_device *sdev,
+			       bool enable);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
-- 
2.44.0.278.ge034bb2e1d-goog

