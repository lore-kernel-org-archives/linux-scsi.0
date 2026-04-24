Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB03537C6
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067626; cv=none; b=GCKBBrTlhsVFVl1x8MUidgLIQvaFIHFApjZWCBTt5kVesj36tv7bjlfTtmo1h66I3uFT2QnzJPxjpDrF1/qfVMj/TQrxmGGco2tUnhmioDlzU1goQmwYjTbBaZquHzDgZGLZ7CVCiUVr+fabF7GhXSKG/hiFpSUUVO3fehVkND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067626; c=relaxed/simple;
	bh=CWkwJfEvJKYFSKoY1DhWa14Eivfz0oLNg9NY2vpkZ6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqQyQcTBBB9HxoxiSiibBmR10QGiUgUeKVJYfvxAqUudrZjb/7MrPoem76e6Q8XulKbQi0O17hQikh5Rjgz7yk1mXLd/OVhKCI4lGoJQiNRIisTbSQzP/TucBykQUcIqO/5AtacQVYsktcg+Q4Yr4DxmL3IrGQ3kesSM1k5ea+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bRCjR18q; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bRCjR18q"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2d868d014a5so8216473eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067624; x=1777672424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Pf3hvjVift4BVuqG7MdiHNfD88WChbdDshCkNy8k0s=;
        b=bRCjR18qJtg1qpbRoHfhMKc7HGOLt5NVzvFwO7XLsFAk6a3idMJ4fo2HO4m5o8Yfck
         31Qn6objn6CgDegrXBRQZoGJpQOL1UQscxIeBdDKiOup2pdGUyL9sFHh3V01xc+2Yhlb
         v8+4iaDNWfSXpxVcDkqTXWsLIqyOExV0w8ExUFpKtnfsGjUrLiaCPFIux0icz2diTFMG
         2SUGrgiV0B2lHoSJFlSjRAo3Ql8qYjQG2xPw/9hu3w+2Ge8CY4AE1PQqgghoS6kdxrQN
         hGnaSfgWhk9s7ad9NXATf0qGdbtMS2o2wFZdiw0mrCPuTcrf24UfgB2ybUDLZ/d/hq8T
         VyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067624; x=1777672424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Pf3hvjVift4BVuqG7MdiHNfD88WChbdDshCkNy8k0s=;
        b=gmhq9sbAK8Lyv+vXrYQhOZanCalu9QDz0AUMqUukUX/lzGaO8rpScRDkqYZI1UzPth
         PqcnRSbxp07Adqc6w2066THkCt35xQKvP8sTCXJMkUHvqEGzaW+VqgUyyfSUOO4zpTUI
         Cjtdgtg1l5MY9wFNaoDq5xadwTt/lw45eX09hB3nPF7+zOJen0sucgcTzhySks1Oo598
         umFGvEf8B9lc+oGrmXTstdYbWZz/pOrSTQWhKKk0vFOBYIvTPAom5aFSzoITQEet3xr7
         1NiXoFGyWD6YtmocN7O64aB1Jr9cxZMMgscKAnKtZSMKPapDTDsNAdm85MQZgG61N76b
         /gsw==
X-Forwarded-Encrypted: i=1; AFNElJ/6yl06TvQC8n6p8E8lf8vZwacPlDHgBM+Jam8nfOf0EUbW0lV0I/oyAwj24wRO22DvPl2oag8Bba+z@vger.kernel.org
X-Gm-Message-State: AOJu0YwM9CK957iZI+1i8BAjNE69Kq78h5vcBjo5PGEZnjfG6LgzUa05
	tqGf6GqbGofiq3bGmiRLuWu3cjOId+Z7IlPBxz7JJjwLElIHaoXSCeR0zYUsJAWmsLCCs5Uxwu4
	/C4KKqPk=
X-Gm-Gg: AeBDiespCZMXo/fkb+Dkie1SNM981imwiSXdLmwqtwtHLheUg/GubSaAPo2/WWeo+7L
	EpvLyCiJwdZN8xS6EzhX5OtV+nLdWyoT27k5GWQfSjjilX+bFEgWQSMDBqIVOmkKA/dbyJJw41V
	KXXENsffIq/KAzTWDC5hkrm55CvI7otFT2mlm9bM6qr/SvDtgs44zxMmKzjyQ0ijN54ZRLrHEuU
	5X2nLQ4vKWak9J1clmGvt4GaQHtHrPNsi24NMbUVcNOFEKRSJHFZblMqbwkfPvZirv9Cl14Wg6m
	icBPnm/aTpcf25yFiCbxXi1tEY2RteZ15Ys5S+VLxB7MGZEXLVOZ1q1MDSH/Gr/PQx2gu8IcVoC
	oUZfKshJriox1V+HkgMd1sQzxLWh7XOeEt5SZhL/qVkhXzmJDOIZr7PspVCjet19f8KYRst463q
	iVp0u473ahsJvyMHEnO8cNBZr/EJuUqEb8gHJDhMqvLktxtugAB52dO+gpLu2Cr4F24QqWzzTDq
	LICR5c7azYp5VcLhkktoPbnMsQWdlkcgTkPqQUvkIjF3DcTaRHeo24Nfnj2tQrT/pxxg5hUHo9s
	J1hTn9mExm/uKV/SUUrdqEg3sOrwu3YhnVs=
X-Received: by 2002:a05:7300:ac8a:b0:2d9:bc8d:f62a with SMTP id 5a478bee46e88-2e47873aadbmr18016574eec.16.1777067623796;
        Fri, 24 Apr 2026 14:53:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Fri, 24 Apr 2026 14:53:20 -0700
Message-ID: <20260424215324.99045-3-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424215324.99045-1-brian@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vendor, model, rev, and inquiry sysfs attributes read data directly
from the inquiry buffer. When INQUIRY data can be updated during device
rescan, these reads must be protected against concurrent updates.

Use the existing inquiry_mutex to protect access to these sysfs
attributes. This ensures that userspace always sees consistent INQUIRY
data, even if a rescan is updating the buffer concurrently.

This is preparatory work for adding INQUIRY data update support during
device rescan operations.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi_sysfs.c | 74 +++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..c34c69487205f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -648,9 +648,63 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
  */
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
+
+/*
+ * Custom show functions for INQUIRY strings that take the inquiry_mutex.
+ * These strings point into the inquiry buffer which can be updated during
+ * device rescan, so we need to protect against concurrent access.
+ */
+static ssize_t
+sdev_show_vendor(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_VENDOR_LEN,
+			       scsi_inq_vendor(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(vendor, S_IRUGO, sdev_show_vendor, NULL);
+
+static ssize_t
+sdev_show_model(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_PRODUCT_LEN,
+			       scsi_inq_product(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(model, S_IRUGO, sdev_show_model, NULL);
+
+static ssize_t
+sdev_show_rev(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_REVISION_LEN,
+			       scsi_inq_revision(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(rev, S_IRUGO, sdev_show_rev, NULL);
+
 sdev_rd_attr (cdl_supported, "%d\n");
 
 static ssize_t
@@ -915,12 +969,18 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
 
-	if (!sdev->inquiry)
-		return -EINVAL;
+	mutex_lock(&sdev->inquiry_mutex);
+	if (!sdev->inquiry) {
+		ret = -EINVAL;
+	} else {
+		ret = memory_read_from_buffer(buf, count, &off, sdev->inquiry,
+					       sdev->inquiry_len);
+	}
+	mutex_unlock(&sdev->inquiry_mutex);
 
-	return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
-				       sdev->inquiry_len);
+	return ret;
 }
 
 static const struct bin_attribute dev_attr_inquiry = {
-- 
2.50.1 (Apple Git-155)

