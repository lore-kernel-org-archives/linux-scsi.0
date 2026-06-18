Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A4F1DDC1B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825729; cv=none; b=ctiVD6ychXzrmhzJc5/eQ3u2FpHq0zWHJGbrOBN9fEKBi/w9zaQgc9L2sr6K3Bbq+A1ZaAd0eTE4Ne0fcuYpU8bot3kXARbk9f6Lk4twQhKLxE/U8KWJbbNB3rlkpS4qeOcJpOa+H9vTQl6ruChaLnR6p8Fuas0lcdJ512H80/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825729; c=relaxed/simple;
	bh=nwGqd2b0KrzIUw9+S/stz/CaHnyIsgeeaZaBGJeu18s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLJNS38mVKHzbtPG5JQdN80mouf4uG/TMVEPf6YI6RtQeEsGFxCFXQhiSsk3+Wxh3pZRb8i+VjaPCJE6g6cBUGmkXEH+2+sJD35RFkDJ59m2AKxYFIxcKZ4cTUXLWHxJ+H7B2+Nv76UIQC9V+yNSDPKLr9Z+0DXfssKq7SRpn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=S8oSECpz; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="S8oSECpz"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so1536216f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825726; x=1782430526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xGIMvjAlnZNPz18QdiqO2HbZ5jH64Uhf/P81BBcZ4Y=;
        b=S8oSECpzhgkVk8z1kLQ9a/EXXYurdGu0fd1mdKwe5AwLTH/HtzjNyMwPKQIKsyDJjG
         yw2mmSHahm03v0RtRQyzCtX8FatzuHt3i5Ct9om/xnFWluEsqTiP3NpJ5kK35gYmqW3l
         n0s3Zvd/FiEhJ/YJNnfV+xDvynTcrXu0SKh3M1wKE53RSp/YWKh/Rhw+UPBUrrIQxmDd
         AZOZ2gjwcXiZxfA/a5IocehtMSbhHe6mPj0DS0wAedaXBugBntrdq5n/6yjivA3lGrg/
         DbgmMZ8omuxMpsdv6QiaL54htVvbtO6FL70V5cmsiEwVODESxP9dcFWLO54nWR8Nx2wx
         qN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825726; x=1782430526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8xGIMvjAlnZNPz18QdiqO2HbZ5jH64Uhf/P81BBcZ4Y=;
        b=jLrTl5Viyf/mMyqCy5DLKyHnPz5voeGi8RGjjBMh1lLnxpKVrK5BzvWFLPRO4HtXqB
         VImq+iZH/rWaCglv8BJBoFXszQ11WdHDN9mmRP2lYgD94xmEKvmW57peo2wszmT7hju8
         NCxxJO2/yzuGCt0ObuAfEl1STCoO6QHgHUW68SLfkqMqvaJNTbYMpW1yPjm3Kbk5s+a2
         Rw+Vwhq7Iu9T/X8qDy7ch0jRUwYwV6DPMBk6FLkp85IuEDr+p83FPVdecLDzNN0WgfkV
         YkaQYxpHWDEWjJiCkWgidCULOoYJRTJp2vpMjr2xNSwC4ZMwg7yUxEJCGwge7TqTdF2o
         L57g==
X-Gm-Message-State: AOJu0YyQqZeQys+HccaAUxkhJ01gQ8Ch801Y+U45ExnaMY1FewOyLawZ
	7Pky+K3mFdXLumzpl+DZg0kZCynwt8SpNlwvgqi60+iduOszU0Am729/5eV5RrXvSj0+kt4qmLy
	TWiehU5d/9i1p4ADrrkbEL+B6Wu1LAsZQgN5vg1dihWMzPNLYxxdUT0ZNlIJknY/rNApbZZTBdD
	6dXPHwIb76jDehLIGYfODfq69AVBjtMJnvTI1OXE6RXH+yLCw5FQ==
X-Gm-Gg: AfdE7ckUJq9vjU9Gunx72+k3133N+z9u6ujG0lNzSvAHIeezsvInUVqSYW9UeRhSVoe
	BD3EzT3lTwpDuzY7S3MYc6U+weeIeTruijqsNkwDJNfPf6kYzJewgDEQBqEmewQ1AI4nSS5QDsb
	oth4ukynmVbvUbjNIgIvpZEkHDLsDHEzZ2LGR39mIG1sjZZ79a8l3uo3OBfLPk1Xq39VUdQDNi5
	eeEnGDQ1ioeqTj2SH5M9VILp0oqWRRdSs+uQFyUZycIWS+KQcZdAuvYVZVuX2zmSVY+5Czn5V2w
	8eLL7sqp6X0ECC7GWgA0qjhuiA1lnMlsfxgjNhUBqbgWtz6hI2J8EbNzyNmSc3z89E1GET89AKu
	ddkn822hZT5FSv1eNDjzJ1dZkpaMFizI8Ki51vhtg52oYNMg6njSVSiqjA2cqLth9LK5ZK3JV+u
	FJXg5G7ZKNpcoDxCM6PwWzZRF1WASdMvbInGBByhaZrXS+1sT6j85raYxVUkkJpjN4FzF8NE+G9
	AqWqJ3a5I46iOTm69UAw1fhdEcarA1JaSVl2MJVLburxowisc5B/ndlgvmDETdAWi4CuWbVyzqA
	twuQqmX6uBLu
X-Received: by 2002:adf:e005:0:20b0:465:4305:6460 with SMTP id ffacd0b85a97d-46543056618mr461246f8f.9.1781825725925;
        Thu, 18 Jun 2026 16:35:25 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:25 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 1/5] scsi: core: Protect INQUIRY sysfs attributes with mutex
Date: Thu, 18 Jun 2026 16:35:00 -0700
Message-ID: <20260618233508.97960-2-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618233508.97960-1-brian@purestorage.com>
References: <20260618233508.97960-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
rev, cdl_supported, and the binary inquiry attribute) read data that
can be updated during device rescan. These reads must be protected
against concurrent updates.

Use the existing inquiry_mutex to protect access to these sysfs
attributes. This ensures that userspace always sees consistent INQUIRY
data, even if a rescan is updating the buffer concurrently.

Update the sdev_rd_attr macro to take inquiry_mutex around the field
access and switch to sysfs_emit. Since vendor, model, and rev are
NUL-terminated fixed-size arrays, %s format handles all field types
correctly.

This is preparatory work for adding INQUIRY data update support during
device rescan operations.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04..a02341d08ec6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -637,21 +637,30 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 
 /*
  * sdev_rd_attr: macro to create a function and attribute variable for a
- * read only field.
+ * read-only field. inquiry_mutex protects INQUIRY-derived fields against
+ * concurrent updates during device rescan.
  */
 #define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+									\
+	guard(mutex)(&sdev->inquiry_mutex);				\
+	return sysfs_emit(buf, format_string, sdev->field);		\
+}									\
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
 
 /*
  * Create the actual show/store functions and data structures.
  */
-sdev_rd_attr (type, "%d\n");
-sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
-sdev_rd_attr (cdl_supported, "%d\n");
+sdev_rd_attr(type, "%d\n");
+sdev_rd_attr(scsi_level, "%d\n");
+sdev_rd_attr(cdl_supported, "%d\n");
+sdev_rd_attr(vendor, "%s\n");
+sdev_rd_attr(model, "%s\n");
+sdev_rd_attr(rev, "%s\n");
 
 static ssize_t
 sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
@@ -916,6 +925,7 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	guard(mutex)(&sdev->inquiry_mutex);
 	if (!sdev->inquiry)
 		return -EINVAL;
 
-- 
2.54.0

