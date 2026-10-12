Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204384BE453
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839151; cv=none; b=pEQvP9+qtdYL9r0PI0sjnzEGlsLAQlCPEtUpkCLjawfty0e6W6VqdKHdWdBNAfbHUGiX38fpeU5kUccXc97H1b71YumPiIyh0wBdXWgrPTT6RCZyG4wBxMAALQTWLjYact7Eg0Fx3muULQJOTJGZsKeq5iHyRBNl97aRE2sIV+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839151; c=relaxed/simple;
	bh=5htZCxWLYnTkU02lkDQnZXcw9tuZDiUo789ZEkIQNn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFDO2KwI4YsuWGZ42y3f/vYsp+KIZHF7/U5zwRPQPFkS+WopuPTRj5tdAfwy6TVdvjPQHYLp6f4iCoCJ4RxCmGaZNv+XZn1PQdSevhdQYazxUemh4KvU9kvYH8XJDk32hiUsRaM40C/M8RpqeiktkfN6U5g/WEewBjWo2AFAksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Eyr6qdS1; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Eyr6qdS1"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15168a20b47so1416426c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839149; x=1792443949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZCsg4itLPq8kFoyEU0Kaz7NAtjNmz12+fgRDDLRWfA=;
        b=Eyr6qdS16MAu3WEhYIljcbHy59o33r5w20MswncdiIN5fBaSNgafGuBj3VPm/drNUs
         tHDEBX7ihXr98D7Y/w5NNh6ebes9698Yo72t9hrmn2lC3nw18DW3xfrUKcxbuqEHG9/q
         7eldcKGsJkdoA683+lN2W9J4zlbudVDwsisSfCDpc+p6WnlMBO/jGUwKTaVFDeMA3yI5
         LjGtoi8Xy/jpYAwfpiAl4Qc+LIDdcZUWZ9zXQ9SFBcfuHtBSYHvE1ziDxfifWPSrNBgM
         ZJCooOdW1LdRBDlCAMH+0F6EW7R/g8MprbrD4zHGe2/R40D2yGq9utB72AQyqkK9O256
         6JdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839149; x=1792443949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NZCsg4itLPq8kFoyEU0Kaz7NAtjNmz12+fgRDDLRWfA=;
        b=kyGIf4raL1DCa+Kftm8H7sQDkK+Mlp7o/KHGT7OJnjTg9KLZezTwRGoUvXDn0Nkd3X
         OiY469oBKPP2BzQNwPpVHucorHXO1cbChyWA/28OM5dSk/293GQRG5Mijmpxltn04p1h
         atAKki1sQkUnQWUjVJ/cG6SDllXnCPzDhSqXcV1lTYXkPVxnZndZqDlXrDeMcHFHNPwD
         PKShcFBnkqUVfFw/C91+jNs6KvS2XFW0xTVZVqquFs6iSzQXGcwSCK22kiq8Ag9uglbm
         jEJ6mbqi2ntqVEeiF2s6aInsfkT/TQcBmZM3RPodBKFaD4TeSZE6inarYwcV4qJ9hmTH
         2yJQ==
X-Gm-Message-State: AFq9FYJY/A9SEqc+mnkhOD987j4cttq/noI+PK67LDjC0yCcbbsmCL7k
	N35MsgFVDMQ5qXEHMn0gpX2wjl4bVPEI4GltQTTuVnfJN+ngb1ZKche5R5Qk7h6u6vxmDgYvBKU
	TX8jRNwy6n/p22/TNgPLdhfKufk+x4mJBEW6EPdZfWX9E2l48Eh3RXvWg4Hbka+QCJChj1lNZ7K
	HwQoF0SLXSxGbGlzlSy6yj5qI823LEhvMMlFz+CgAFqeAfgbXrgA==
X-Gm-Gg: AYBFou1DKsyrjoIrBC0cFKKE57M4c+j8U0X3vgs335dM3sb172Qbuo7f7NqaY2HlMR6
	/GSLcdRU14OrjN+Lz8GqUrYAPCaMSlRpJ8lRMRWulynzK1ccEgHNt7rpkp8+EGP3vElbOMEOGDm
	TejcdrEpAc8bbONy7Jh3p1oTA/BZDyS/Xrnt5XMmZjOiGPXGaJWwmyO8FvHtmt7+Et/T6FKW7w6
	e0lM4LOxLve7BBr9JoIMLjxNSSfiBx+8mAIRXOvBFeVaWrW0eOTQAivrlMFvlmOrxqmPh5bM6Gm
	lcbyylfHM6FsSHCneDT7Cf4cjLCYNyB2KxnKAeG6IiMqeKnkh2XIk4bFZThXKh7sFmIqEsMdBP+
	PaAwm/HXQtYX+bblzv88uch8sjr1ps7Irr4sLNF13dhTBi51z/ZQXXfjSnyy/Dq6ODzUXcqM9By
	jL2Ku+GwzkYh7WX/hzfNqjNMq5rmi/7o6EjT01SppuY8c7SV3kKJVkwlKDH79cpeS6mDOjWd5dL
	AgR3+nDORZPxOQCA4RZd/rLUDG49BBkn4UhOObpq7K3vWQzYJ+Fj59v/uDkANYR7wF7RGwtBHo8
	QITRqdKfTLFCsg72nFkvsxzAhuCNUzScJlvx8hErZEi13WPee7fad7uHCEamg7tvyzhk2VVW+L5
	bng6W
X-Received: by 2002:a05:7300:8410:b0:353:599f:d63a with SMTP id 5a478bee46e88-3537e0202abmr13464381eec.17.1791839148510;
        Mon, 12 Oct 2026 14:05:48 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.05.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:05:48 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v6 1/5] scsi: core: Protect INQUIRY sysfs attributes with mutex
Date: Mon, 12 Oct 2026 14:05:02 -0700
Message-ID: <20261012210511.16061-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012210511.16061-1-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_sysfs.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..a20707f6f1ac 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -638,21 +638,30 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 
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
@@ -917,6 +926,7 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	guard(mutex)(&sdev->inquiry_mutex);
 	if (!sdev->inquiry)
 		return -EINVAL;
 
-- 
2.55.0

