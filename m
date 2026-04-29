Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63836BCC9
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777502989; cv=none; b=OPhwqbYYPmeLzHfocueQIA8ll8svbSkFWMBpmD1mZwZKEnUg6IO+5nYBUcD03YCJtpaKr5uo/WHxlNai2S5p1hWaeBvEERcJGRqtTWW02X79mWkzyb5aRlTzjUo2xxE9xnkya7ctxVc1lWW3H+p5hc6BgIFmSqORQtbRgjU5cTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777502989; c=relaxed/simple;
	bh=IFhEGY9BlOoQONtUkaRerEM6UrLsmOCDKf2/9prRx8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeDj+aisdKF59FQa6V/Mcqb8DMFhkZ3/c5rAOKwykMo+IEC2+WfJgnWYSH5nneLrgYlDkn4QbE+tYsynMtTjMVXaVeWVEwtnY33TvXOdBmxB8W0F2jO8Xkb2rzcXagGDeSf0aatf2OLOBLEKi9L5oNpVn8F9GvDmx1sRaZIBDXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QdvCcjAk; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QdvCcjAk"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2d891442388so784260eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 15:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777502986; x=1778107786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4hDdFnXoHRRwpFGqoMHe7UXYI9U7R8RD4qprGz1SYE=;
        b=QdvCcjAkp/EiXqS6w2g7Aky0L8MyaClFGpVWoZ2FK9dfNmOMRryoMlf3GbJ9oHXJ+v
         l6M64Ig1Cqm1WzR0E7B+dPnOcOnxwaUv+2QYmcOImC1saZIzQ+utAPpMc4Fg6SkVD+Pt
         QdDbBujDsPmoXw/fOl8/6oZ3zn5KbxqGzmNkLJRhjzwObamUYsFrH9SOweVr84uSQ3GS
         YFBKWXE1LdwSGCMc2oDWTFfUm/zv2WgYLv+ltgK0+RH22H4iqdhWFWesnqCV6L9Osm/N
         CpIT3NzkNFvKmCgXCiqivHdcCse/eIALbUpKg/zvvPA0m9srO19+DsjVHd2Em3PzVeaR
         uspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777502986; x=1778107786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V4hDdFnXoHRRwpFGqoMHe7UXYI9U7R8RD4qprGz1SYE=;
        b=qUcLRlqeZSKhkfxt6pK129+l7Ui1n9pPBt87400kVOrF9tLPa5lfYPWawnLMldxzai
         3O0yPc+gEg7pUfOxE9nwSUqgyTC5Y4boeRrIw/U8uZCN23j8jl1IcepcTJ3hO+xtbT7t
         VJaWist/opo4lOOfUQ5meNi5AmUJudXSnYjVudVPX+fTbEIucxIaY/ejunHuySLcs2NZ
         K0iJDBa/YKOSraZto8mKecZX1SYlPbsNU2lMnlC/vwLWgF74NZrbvPVTCuuz4mbd8/b+
         1JzNjazbMRnKT2+jq7XIBtp7brIErhZ9dAeZWOY8EiE9zNN2aYv+Mdtfl3xxVqnVBg5L
         yqQQ==
X-Gm-Message-State: AOJu0Yx1scrOMS2voRGamZ3IG+B0arNwX1MWJb+bE5j/BUn4AAZTxyft
	h4gPwjzNH+nbLSdvjajrq47bFLm7migzCkt0f9bW/46mdY/HJJ6pTmrO7cJwR2Njg0WHyJi64vy
	9rjM6G7aSPLKr67yiOf7X8WsEe2wAF+fYBgfqRVzKj1Es06BoQzzVVZa0Gr0lWDfr+jCtpdqVVp
	5ULJE1CgNs9/wGmwPr8T2fF6evtTtHEUye5OQvsT8FckXALg21VQ==
X-Gm-Gg: AeBDiesniCMEzIdXZqEN7f4ugCyLuWsEZIdVrtGLujcyiM73GJHGfuMafAmSi6mMvxn
	q1PyC7bXkCW7szUI40k27PHlws3xMcQurGa8ndBFUzi/LakZZoTxB2XlXk/+vmLgEgqNnonaJzW
	m5HWwBYjtMCGHZDoqdbgQGYAPPNFOvI/6/IC74v8ICIoSEToLxWmGLrq+ATQWs4ZgmO03tnffjF
	3tppwx6Ym/PubjiZqdbCDCCVfdHfcgx8WWYybUwNXpJN600XaD+XODGcZ16FOxZ5+Ep2xPJpzeS
	MwK2WsyamSkqgGyKx5oqdnbs0XXYwXvRwoMVbTJKdCF8s9EMypPtpjA9jvmmi5yEnCdHvlUoGs6
	R1hei9yLfxpH7HucphmbXxV/Q8QVJWkURIBE0KnW7GIj8ALFkR40KlhetAu810GlXQzWDbuYs0j
	gYoGLFv06RELeGJ+TWoj46oa710QANW6fKkywJOhndg84kUpnunVBZPj1L5FNgbr6jbYRSSjjjI
	BkEi1etS+ncsBJtLYP4tb81hwui6ca1eQ201OCrsJm4Uzyk8Ub8wUV/SurwNgrOb3tyaoVD2PHm
	8nIFwmcJ+auSj+YSLROG2SouMwTOgCiasxE=
X-Received: by 2002:a05:7301:19a6:b0:2d9:fa9c:87a9 with SMTP id 5a478bee46e88-2ed3d2bf86amr147820eec.5.1777502986098;
        Wed, 29 Apr 2026 15:49:46 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1bf8ddaasm4382609eec.7.2026.04.29.15.49.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Apr 2026 15:49:45 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Wed, 29 Apr 2026 15:49:39 -0700
Message-ID: <20260429224939.77082-1-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429012733.40855-1-brian@purestorage.com>
References: <20260429012733.40855-1-brian@purestorage.com>
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
v3:
  - Use sysfs_emit() instead of snprintf() in the new show functions.
  - Use guard(mutex)() for scoped lock acquisition and drop the local
    ret variable.

v2:
  - Protect all INQUIRY-derived fields (type, scsi_level, cdl_supported),
    not just the string fields (vendor, model, rev) and binary inquiry
    attribute. If we accept that INQUIRY data can change, we cannot assume
    which fields will change.
  - Replace the sdev_rd_attr macro with sdev_rd_inquiry_attr_int and
    sdev_rd_inquiry_attr_str helpers to avoid duplicating the lock/unlock
    boilerplate across each show function.

 drivers/scsi/scsi_sysfs.c | 52 ++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..9201f1f04d6b4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -636,22 +636,51 @@ sdev_show_##field (struct device *dev, struct device_attribute *attr,	\
 }									\
 
 /*
- * sdev_rd_attr: macro to create a function and attribute variable for a
- * read only field.
+ * sdev_rd_inquiry_attr_int: macro to create a function and attribute for a
+ * read-only INQUIRY-derived integer field. The inquiry_mutex protects
+ * against concurrent updates during device rescan.
+ */
+#define sdev_rd_inquiry_attr_int(field)					\
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+									\
+	guard(mutex)(&sdev->inquiry_mutex);				\
+	return sysfs_emit(buf, "%d\n", sdev->field);			\
+}									\
+static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
+
+/*
+ * sdev_rd_inquiry_attr_str: macro to create a function and attribute for a
+ * read-only INQUIRY-derived string field. The inquiry_mutex protects
+ * against concurrent updates during device rescan.
  */
-#define sdev_rd_attr(field, format_string)				\
-	sdev_show_function(field, format_string)			\
-static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
+#define sdev_rd_inquiry_attr_str(field, accessor, len)			\
+static ssize_t								\
+sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
+		  char *buf)						\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+									\
+	guard(mutex)(&sdev->inquiry_mutex);				\
+	if (sdev->inquiry)						\
+		return sysfs_emit(buf, "%.*s\n", len,			\
+				  accessor(sdev->inquiry));		\
+	return sysfs_emit(buf, "\n");					\
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
@@ -916,6 +945,7 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
 
+	guard(mutex)(&sdev->inquiry_mutex);
 	if (!sdev->inquiry)
 		return -EINVAL;
 
-- 
2.50.1 (Apple Git-155)

