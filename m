Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05023BA45
	for <linux-scsi@vger.kernel.org>; Sat,  2 Mar 2024 00:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709338620; cv=none; b=ATNWg+NubG7oYP7aXQ15t+CtPbPvc+JzbbScO8+WiPiMgaSyNhjDJyAfVkIki7QDXPkPMwjGOFoZ2SyLHm6bdX1xjvKM+kAht5PVYJ8TIOx6vt3ERhDJXZQEUp3AG/thGeWuJgI5ZwxZvh6nQST6c8AQx+B6D64EsHXiYw8oY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709338620; c=relaxed/simple;
	bh=0GrvhQMeDiqnvSKKSLm4FXuympZbNYitH8oNM1c1K2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l9y5zRsVzEpcUd2/QD4AFSO+G+5H+itKdZIw490nmbhvIgP5rS5zMOdZhuGomMiZiMjfCFVTXtzhTOTTbiXIxJ4GMpVhIipWey+LKyaKTVEdIlNfg6i055eZpXFpIbV4u4TysmQu3/iPtGTbFe+5aI+JfmGWxMNqaNbcfMk2TNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0yuguYux; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0yuguYux"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so3600505276.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 16:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709338618; x=1709943418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBbBICcO6IvwKDEiRI+I7rx8MULu52MOhujWx/5/qGw=;
        b=0yuguYux9axl8wuUNIB9ZYosscBR4VWPmEC2qpbpdU39IR/aOzgFxhOxA53xi652js
         yBK94hTwqpCWRIcmMDEUVyuyT2INDr+TSi8LuQqOfKC1DGFUeOAWDZcbIHjTg2xctgBs
         WdoHq76TAc/zd9WdTH2bQ5NdmNRPDbUa2ZTLzoBrxP0q7GDXexrANykLO0i5CGA0MvJh
         NimvdR+BTk2FvChV8tsQpZAkPJ+B4jAgHUhdcEDLAEcv5OTCj03yLLB4wWbG5/k6zSAb
         bV0z4iamg2qGPFGReNKFRXLaWeRtRKylW/dzAeBy1HtQL++B4QKMXjr7bth+dFofVUEs
         eEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709338618; x=1709943418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBbBICcO6IvwKDEiRI+I7rx8MULu52MOhujWx/5/qGw=;
        b=hpmsa/5C/4JgS+BSBVdwZOJ9lqMOphDCNHbNM7qN2HJjHA5aWOECMe47UC0bYrcecl
         3UpESVHWKlc4vW3LeBHSxPruFx6ZY2Yi532+q3ldcEuAYa3t0GZ1rQ3yfZOu1BHUJqxG
         nZz8W8EjwsDjSpqwrxb1SLTLrCAep04R6FgPvgy9ryK9vIAKmuh6qX/BmWPAy0/StJGw
         2hklWWN416wO1Gp9aE0qYiFNxoL45uzbVUuw4LyXNyfObctzIyNVn9Mi7coT1KKcDRTO
         yzZ9XtTPuPxkXb5GqRg8cUI0N9mSQNWX1YZZ6ABlftRCXeZd36xuR0GF1y3XcyU4Ut6s
         VlJA==
X-Forwarded-Encrypted: i=1; AJvYcCUhq4aGDhPl8w4BvthfRUQ3PCoV9TR71/6dhiuWS6LmZjsF3aWyZ+ZWXZUQfvurngvcRex35gKkan0oY/sJFsXmVpJ+gSfmQ+y4RA==
X-Gm-Message-State: AOJu0Yx4NCP+gRuPjlHuu38agiCcGekQA6HAfYZjjXGBTBfn0p/EPfn9
	9f4xbJw4vLFifZY1XnkANtIf3ljqJyGXj5sSsTKwv7ItOnXL+dbM5PizgJMtT2NyVpfPqPddHHp
	83GS9Hj9Npg==
X-Google-Smtp-Source: AGHT+IEYOP1+6p+cLu9IXpIv81WnNvWYnNfOJaVjXrtSXfWTSKL/ab0M4h6xW8oYE9Vs5fjooC1s26l67OhuZg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:2afe:1a8e:f846:999f])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:18d3:b0:dc7:865b:22c6 with SMTP
 id ck19-20020a05690218d300b00dc7865b22c6mr117555ybb.8.1709338618166; Fri, 01
 Mar 2024 16:16:58 -0800 (PST)
Date: Fri,  1 Mar 2024 16:15:59 -0800
In-Reply-To: <20240302001603.1012084-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240302001603.1012084-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240302001603.1012084-3-ipylypiv@google.com>
Subject: [PATCH v2 2/5] scsi: libsas: Define NCQ Priority sysfs attributes for
 SATA devices
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>
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

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/libsas/sas_ata.c | 92 +++++++++++++++++++++++++++++++++++
 include/scsi/sas_ata.h        |  6 +++
 2 files changed, 98 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 12e2653846e3..e4d07134a0e4 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -964,3 +964,95 @@ int sas_execute_ata_cmd(struct domain_device *device, u8 *fis, int force_phy_id)
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
+	int rc;
+
+	/* This attribute shall be visible for SATA devices only */
+	if (WARN_ON(!dev_is_sata(ddev)))
+		return -EINVAL;
+
+	rc = ata_ncq_prio_supported(ddev->sata_dev.ap, sdev);
+	if (rc < 0)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", rc);
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
+	int rc;
+
+	/* This attribute shall be visible for SATA devices only */
+	if (WARN_ON(!dev_is_sata(ddev)))
+		return -EINVAL;
+
+	rc = ata_ncq_prio_enabled(ddev->sata_dev.ap, sdev);
+	if (rc < 0)
+		return rc;
+
+	return sysfs_emit(buf, "%d\n", rc);
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
+	if (WARN_ON(!dev_is_sata(ddev)))
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
index 2f8c719840a6..cded782fdf33 100644
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
+static const struct attribute_group sas_ata_sdev_attr_group = {
+	.attrs = NULL,
+};
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.44.0.278.ge034bb2e1d-goog

