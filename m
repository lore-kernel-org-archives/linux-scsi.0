Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E5E192B7F
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543432; cv=none; b=dAEGTzerhLiAoNBTY+lM4jGscgt28AvcN1zIJ1Pye53QMzHgeZdrbg2HefZxixOOlXMmZ6Z3E18VAnA5d8YkNAKFQOWBRHDq1jglKIWsIuM4Gs2UN9N4zRM8eUd9qCmG60J2w6D0n4oPmDBP6szNvAZKUMTjpvVUc1hYVXMVBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543432; c=relaxed/simple;
	bh=3Go/PZyu/K4D4xKrpApeeRJrQZXrkB71scXFvQZQDOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FB+7E7MfPaKpGfhM+A+ROznEOXwEY7I+Z9Usng0+ix/vfCH8Bu+8M3tY47zPlTckKgiKsQ6BuGx7gffcvMuT0pxb/EGOaWJSF6/ZLghDLzmcMGmkhcblXKTGEDVHMvdPdlhZokGMNUVs7DtfHwzJpiFBonkfTKt0dbg4qD13Wg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=Lcm8r229; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="Lcm8r229"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=NeqVt7amgvIxmptxFb8tKAWnqzkJFXJev23JSQNq7aw=;
	b=Lcm8r229ixtrKrKborSvcEAVWeBY4FNnC/gubLuM9fefkH9EOzmC2e6C1NezVDWIM3eu4KNNGItuY
	 qbBT4C5t3DygPLTYHmR8wb1ARnx9H9KKsZQL5ucfkYekRJYvD/C9U6Q86QQ0+J0BlVBoeIJz5TtGa/
	 R9DlSviSRd61wWgujXrJYccfs5wSkOGUTeUeNNIULthKL7DCq+SK727fvXotOeaEgYti5KCsYiKnPo
	 91wF/g1sGiGQGyWWxeD5yORR08IojGcAFRUv90jXkyEazKwXCd2WmNngtXTIam+I2A2NAzWTG2MzTG
	 kxE2vS3ZrHPLBUqzvvw2pWvVORue5TQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 0837c1a6-ab36-11ef-8882-005056bdd08f;
	Mon, 25 Nov 2024 16:03:22 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 4/4] scsi: st: Add sysfs file reset_blocked
Date: Mon, 25 Nov 2024 16:03:01 +0200
Message-ID: <20241125140301.3912-5-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the value read from the file is 1, reads and writes from/to the
device are blocked because the tape position may not match user's
expectation (tape rewound after device reset).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 Documentation/scsi/st.rst |  5 +++++
 drivers/scsi/st.c         | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
index d3b28c28d74c..2209f03faad3 100644
--- a/Documentation/scsi/st.rst
+++ b/Documentation/scsi/st.rst
@@ -157,6 +157,11 @@ enabled driver and mode options. The value in the file is a bit mask where the
 bit definitions are the same as those used with MTSETDRVBUFFER in setting the
 options.
 
+Each directory contains the entry 'reset_blocked'. If this value is one,
+reading and writing to the device is blocked after device reset. Most
+devices rewind the tape after reset and the writes/read don't access the
+tape position the user expects.
+
 A link named 'tape' is made from the SCSI device directory to the class
 directory corresponding to the mode 0 auto-rewind device (e.g., st0).
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ad86dfbc8919..0e6a87f1f47f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4697,6 +4697,24 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(options);
 
+/**
+ * reset_blocked_show - Value 1 indicates that reads, writes, etc. are blocked
+ * because a device reset has occurred and no operation positioning the tape
+ * has been issued.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t reset_blocked_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+	struct scsi_tape *STp = STm->tape;
+
+	return sprintf(buf, "%d", STp->pos_unknown);
+}
+static DEVICE_ATTR_RO(reset_blocked);
+
 /* Support for tape stats */
 
 /**
@@ -4881,6 +4899,7 @@ static struct attribute *st_dev_attrs[] = {
 	&dev_attr_default_density.attr,
 	&dev_attr_default_compression.attr,
 	&dev_attr_options.attr,
+	&dev_attr_reset_blocked.attr,
 	NULL,
 };
 
-- 
2.43.0

