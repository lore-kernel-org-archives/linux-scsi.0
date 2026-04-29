Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB5192B75
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777426066; cv=none; b=jl5o3svDfQiC3DktDvHRkss56OGOHlEvfxU/wp8rfB7myj8NPSqFwcW7VjEDCR+/mXSnw5VaLQBuX4u/Q5nAInT+Bli8wdmHGq1I26sq+GSi1ICuy+dU68CW6MXsCAp77SxfeekRidPIx4jciI0ZZnCLd1EzzOmF2DwaPQlTcOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777426066; c=relaxed/simple;
	bh=hBOTzqekCCHETf79nPt9Gl/27YvJCzpO+v/hvydnjLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec9IN724OBscp/IjK2gzfJFrttGIdUxvRD8N1Po1ZH5LU6UsSypudUOXxtr/g9UaT1WA10aNr8xLZy6hUp+lZZ9xu/eai81AuGw+aJfXyOjj3+VjViqjIVcBR9wxUinAaYjBHShKmCkwU0QkpAhTR/bzKisd+jI71wcfxz9dxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fVpfUNl8; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fVpfUNl8"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2dee127b3c5so3098026eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2026 18:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777426064; x=1778030864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaFCVspXA9Prc2DTVvXCWvBNdQ3yKJ4mWd9c+nV6Eug=;
        b=fVpfUNl8hnqzWnj/EB8TisU2bJz/CY9jCZlsvBpLvePyhDXcZ9llm8tVm0IqeE4evt
         LrIzQea7BftnzZWIEewCaSgqGm8AA6jqVdCaBtgXkt86JXdv7wZgEALsk7kryP047MSF
         hSe2Slusq0CN/u4RDzN75KZGJXjZAGXK6ET7LdFdENIyGPfzCkgCuJUpYTg342aa2gU7
         aZL0aUJdIxj1r8lpo5zTOp+votRqTdtY9rlLqi0dNfIhtqKVNd0bxposHQ3bjVINxIOs
         2w6U3wk+zaoR0BZCKVvVRA/GQaBP1S4IeA8OWkBFqhqF3XPu0b1oMhG/igE/+WOE+uZq
         OVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777426064; x=1778030864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xaFCVspXA9Prc2DTVvXCWvBNdQ3yKJ4mWd9c+nV6Eug=;
        b=Sl3jFxTb11Itr84mYmeCp+HyDlEmcFZAhbn/MD56KBkZo4MXqhkwo9GmPGmz4o2B5T
         VgNgYHN9BzUL6vMOqASuF6+lranFMP7m0kqm65bAln1n8m1CsadSDV0CcJefYteGoKM8
         NWnE37s/xfMzJaAhuC5hno2Dp8/oIPkYLEY+b7G2Rcnpy3Ap0cNU7hKr/cEC1R0D11yK
         hUEwExJ1OzxdTqT/LaqCHK9bBLTwZDqlW3sa9BRSxeEcRJNPyI8V1f5v9Pi9lwjV1KGV
         /aI3InxQHkJpVgknR41qEhVY7CuHQuY5WKPcTGdQAl0Eh+WXSmbIxu2Sei6SLayCerDv
         kIKg==
X-Gm-Message-State: AOJu0YzW12sXpoGThdZimviGViwiw4B09Fkq2Hk/DSuGRNwJkRp8cEp7
	AyiKpVL+FU1w8k12dm6TLBtA/MydpESPXtBboxh/wFrKO1LMxbUF1vTqWQ1dfcbeBPFMhkJApTn
	0BdodBf0cLwgFZ7waN1PT8iDFYtfWYlYBUFaR3PBe6tzGO3ZzZ1DoGvIy0p1+c69xx75kXvAMpJ
	7SbhgoIQ/2w4JjTuK4g9Ri+Qc4sdl/dtDyW3MnCAgN7z+OpUyNVw==
X-Gm-Gg: AeBDiesskvsHK9L2pgNlyrw6Yuj68kIplJjBlgEHTtmHbZbUYTaC2VrjRLCKuF4Pu7l
	YnsBvohJEQhjTCpZoY1uPoJz3vYSN5ur7IV6vZG26VWI1yaBsorWQVAcU1oIbBm5kUEDGTbCChu
	CpLMWBsOEGyXdS1bvCIyWnAXd2sczjK9ADYQkPoi3boJ/1P199l5QNwmTdmFkvWE6UJdeYBHrUy
	OMUT4c7TRnXvUC14uuyluXq6lH7TNm7scYIE7+equRphYakR8r57DnY1UZqSkfMfocZznib/I57
	6FSviNpStaOb7Lbp2uNDseg1d0bOeVSOF8nA7BV2Fo3bwTeX0gUUgL3Uivw6YiBJ6IrNGrP84Vy
	He5msx0M96vgiXo624G96M6lxsWPY0QK9dOlgYeYKPPruulNw18Dibj6um4rg2FI54NEW3podAh
	6xsJxvoeSJ9/6Taa/xX+l1Y0TFLqUGjWXmuHQrmA3r/voEEGifz+02YoOEPMTKUtbt0/8ITIJx5
	xOvnqNsLzHY0JzWEwCoRWT628/Abd+IsEFgfgcAAp/kljsZWs2C6ArR01lB5gjrT9tZ5OyqFwIi
	7G35ovKebPu9DBarbpAj0sbc4TMEX1NGhXA=
X-Received: by 2002:a05:7300:238f:b0:2de:6fac:f666 with SMTP id 5a478bee46e88-2ed0a118364mr2696891eec.27.1777426063438;
        Tue, 28 Apr 2026 18:27:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c0d8f90sm473449eec.30.2026.04.28.18.27.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 18:27:42 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Tue, 28 Apr 2026 18:27:33 -0700
Message-ID: <20260429012733.40855-1-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0a89cb03-31d6-4f5f-a84c-a838d4d99ab5@suse.de>
References: <0a89cb03-31d6-4f5f-a84c-a838d4d99ab5@suse.de>
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

Replace the sdev_rd_attr macro with two new helpers,
sdev_rd_inquiry_attr_int and sdev_rd_inquiry_attr_str, which generate
the show functions for INQUIRY-derived integer and string fields and
take the inquiry_mutex around the field access.

This is preparatory work for adding INQUIRY data update support during
device rescan operations.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
v2:
  - Protect all INQUIRY-derived fields (type, scsi_level, cdl_supported),
    not just the string fields (vendor, model, rev) and binary inquiry
    attribute. If we accept that INQUIRY data can change, we cannot assume
    which fields will change.
  - Replace the sdev_rd_attr macro with sdev_rd_inquiry_attr_int and
    sdev_rd_inquiry_attr_str helpers to avoid duplicating the lock/unlock
    boilerplate across each show function.

 drivers/scsi/scsi_sysfs.c | 69 +++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..4a2b89e13b7bf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -636,22 +636,58 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 }									\
 
 /*
- * sdev_rd_attr: macro to create a function and attribute variable for a
- * read only field.
+ * sdev_rd_inquiry_attr_int: macro to create a function and attribute for a
+ * read-only INQUIRY-derived integer field. The inquiry_mutex protects
+ * against concurrent updates during device rescan.
  */
-#define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
+#define sdev_rd_inquiry_attr_int(field)					\
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	ssize_t ret;							\
+									\
+	mutex_lock(&sdev->inquiry_mutex);				\
+	ret = snprintf(buf, 20, "%d\n", sdev->field);			\
+	mutex_unlock(&sdev->inquiry_mutex);				\
+	return ret;							\
+}									\
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
+
+/*
+ * sdev_rd_inquiry_attr_str: macro to create a function and attribute for a
+ * read-only INQUIRY-derived string field. The inquiry_mutex protects
+ * against concurrent updates during device rescan.
+ */
+#define sdev_rd_inquiry_attr_str(field, accessor, len)			\
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	ssize_t ret;							\
+									\
+	mutex_lock(&sdev->inquiry_mutex);				\
+	if (sdev->inquiry)						\
+		ret = snprintf(buf, 20, "%.*s\n", len,			\
+			       accessor(sdev->inquiry));		\
+	else								\
+		ret = snprintf(buf, 20, "\n");				\
+	mutex_unlock(&sdev->inquiry_mutex);				\
+	return ret;							\
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
+sdev_rd_inquiry_attr_int(type);
+sdev_rd_inquiry_attr_int(scsi_level);
+sdev_rd_inquiry_attr_int(cdl_supported);
+sdev_rd_inquiry_attr_str(vendor, scsi_inq_vendor, SCSI_INQ_VENDOR_LEN);
+sdev_rd_inquiry_attr_str(model, scsi_inq_product, SCSI_INQ_PRODUCT_LEN);
+sdev_rd_inquiry_attr_str(rev, scsi_inq_revision, SCSI_INQ_REVISION_LEN);
 
 static ssize_t
 sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
@@ -915,12 +951,17 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
 
+	mutex_lock(&sdev->inquiry_mutex);
 	if (!sdev->inquiry)
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = memory_read_from_buffer(buf, count, &off, sdev->inquiry,
+					       sdev->inquiry_len);
+	mutex_unlock(&sdev->inquiry_mutex);
 
-	return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
-				       sdev->inquiry_len);
+	return ret;
 }
 
 static const struct bin_attribute dev_attr_inquiry = {
-- 
2.50.1 (Apple Git-155)

