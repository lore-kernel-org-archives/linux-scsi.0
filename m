Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A412EBC6
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683116; cv=none; b=Q4EOvPbykaHtrPYt8mdeC1KktUIQlu7jJW9Hpg3pvX2XFESzKE5OLYutKDolVBLJL6sLXFH0kA9kEQoyN1fJdhXLJagt2WcxMPaQwsDNOPtuJWsZ6lYOajqpO6aiDMNOj3tDu2chpPUCYpTnyR1aysazo1v1L93FlopuD8kJAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683116; c=relaxed/simple;
	bh=tljO3YNKojGQKl4/nogEVW1mt1rHvPdAvzEjzTFZ6pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qlEh9MPU5VIc831fW7z4917m+iHLglW8ydgf/WEsBONPd2pFnjz89qpkewzfIihOv/zzCjnzOIxRYU7OwwC0U+iG6QaWJdECCQr6A+HQwaIRMgm5zaLek51wMJt4dQ+SbQ5f2/TRsWyyhlx3snsW+/7t3g/DpdugJe958D69Les=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sx8lDWtT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sx8lDWtT"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so12186578276.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683113; x=1710287913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3IbqjAWtZG0ah6rSd6ZSYfM1o+jFUFiPix71IOwviDA=;
        b=sx8lDWtT4hWa48qP3Am/fxk3aVUl83KAOHLkcAwFfGv3O+PiAWZ8MglWGRCS2a4SH9
         FRICui0TbGKzjycyfE6abJdBxx4ZfU4+MVN7M+Wwh/4AMjbZTieg0WtW1r3tDkpj08pj
         aT04dYWsnVgMUuTo/FIoT9j941FgjAJJqmcStZtIG/rgfHQPb0iznU+/yjIm9Iv0qowC
         1TqBavTYHYL6Ok0UoMO8WOTsWtU22lLfRpqtGF4jxruSrQLjEQcJld+zqB7FIw+UufQJ
         hAyOH+uRkGb8fTRS5VkVw6MhfPQSe9iws+ts5VoYZfBJDBEc1C3Fn/PkJvoWzlAEyEOc
         X34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683113; x=1710287913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3IbqjAWtZG0ah6rSd6ZSYfM1o+jFUFiPix71IOwviDA=;
        b=Z63HGj4pScxxsJZ1zauULantxtC590b1P+6fzCHgBRNn5DIIC9gQr7v9RJ2t9w2H98
         MDms/mr8RR1RP2L2PkquzLFw4d+WVKJdAF2rqjMf9afSC7PhTUPdp2Qe/cHppr82D/15
         BMbvidkirDChcJ79dBoDDqMnUwCPQBEUkuk8qVF+xL42vKfN4GmzYh8YxWg8OPgIMdbZ
         wwLxoB+YhQkqqmGH2nHOitDLrwERRMXHTvolDfJtLtViJiL0AnW5aURSECkpHNaZ/kc5
         4Hc8PdGoJMvA7wrDEpJM4ONUtmWCx8rb/SytEPub79p1+aTfyu2NoX5f7j20YdpFZrn2
         FiiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXw8/1/hFVSZaJHfk/fqs76UmRpdX9B1tfOm1s0e24JrPyHX/VuJkgNVjbFiuTxm0YdttXEENeFkWjmiaCte8dtjj9N05t8jLKI/w==
X-Gm-Message-State: AOJu0YyH37rDzlZV6plVV+9efWxnVYCIDmDEYS01+367I+HVY4KDLAop
	srQeSAMPB1qlrxHF5hBz+3+0AsHlXJRVSfUMJ42dmAHaoQYehopyVMabbcnHFqjQP7NFFThpWQI
	0Lmu0lx8Btg==
X-Google-Smtp-Source: AGHT+IFXxAYiJwdVSZE8mHvAfunpdCHDxq3qHZGle0aN74vGiPj3t3l+o4Wf8Kbr7CjkWhD3mljTyMnh9hhPgw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:724:b0:dcc:5a91:aee9 with SMTP
 id l4-20020a056902072400b00dcc5a91aee9mr3344267ybt.7.1709683113424; Tue, 05
 Mar 2024 15:58:33 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:17 -0800
In-Reply-To: <20240305235823.3308225-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305235823.3308225-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-3-ipylypiv@google.com>
Subject: [PATCH v6 2/7] scsi: libsas: Define NCQ Priority sysfs attributes for
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
 drivers/scsi/libsas/sas_ata.c | 94 +++++++++++++++++++++++++++++++++++
 include/scsi/sas_ata.h        |  6 +++
 2 files changed, 100 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 12e2653846e3..04b0bd9a4e01 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -964,3 +964,97 @@ int sas_execute_ata_cmd(struct domain_device *device, u8 *fis, int force_phy_id)
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
+	/* This attribute shall be visible for SATA devices only */
+	if (WARN_ON_ONCE(!dev_is_sata(ddev)))
+		return -EINVAL;
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
+	/* This attribute shall be visible for SATA devices only */
+	if (WARN_ON_ONCE(!dev_is_sata(ddev)))
+		return -EINVAL;
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
+	/* This attribute shall be visible for SATA devices only */
+	if (WARN_ON_ONCE(!dev_is_sata(ddev)))
+		return -EINVAL;
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
index 2f8c719840a6..59a75cd8b5e0 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -39,6 +39,8 @@ int smp_ata_check_ready_type(struct ata_link *link);
 int sas_discover_sata(struct domain_device *dev);
 int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
 		    struct domain_device *child, int phy_id);
+
+extern const struct attribute_group sas_ata_sdev_attr_group;
 #else
 
 static inline void sas_ata_disabled_notice(void)
@@ -123,6 +125,10 @@ static inline int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *p
 	sas_ata_disabled_notice();
 	return -ENODEV;
 }
+
+static const struct attribute_group sas_ata_sdev_attr_group __maybe_unused = {
+	.attrs = NULL,
+};
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.44.0.278.ge034bb2e1d-goog

