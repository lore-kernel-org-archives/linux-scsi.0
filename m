Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0319D339847
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067625; cv=none; b=eL0HwUE6NtlHno+6BRRw/MYrP42lFCL663TCPkU7rhBKrNuWKq1PxNL05UX9/sT4gDwgDIOIrc1mI83iFof7xt5zlpLezMd+QUiABCPb6jj62aWC4Vrq+cNmtwg5n8OcOt6EgHZgNpnsXBSJFHhpy2IjeeSz4UQXiZy1mUyRKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067625; c=relaxed/simple;
	bh=AFyJhxnhzsGCNHgHfgjwU60LlcWLNt867Evg1DLqiuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbjja6Rk1hv1s4XaJyOjW/Ay1rAQrUuJf1uYQTUCQRvhjx1EqaDhQWFk286dlkbJZFFMZq7VKibGhZNxn036Vf/sxZKn3ht/EpdWtN43gdwRnK8R3xW+RM1wGWC5zETBN8LeBdM3a/XjgrKWC1FmTvx4b0KgwS5WG7bVsAH8mnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RNvFzl9r; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RNvFzl9r"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2d891442388so13810276eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067623; x=1777672423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6935qPu7M5NbZGZx6tTl1p29+OEVIHZ7LTwlaFJBLA=;
        b=RNvFzl9rf0dBzTimWJl5oVfd140Hi+Bm4RlKOLL5QyoNzOKdfbM3xbdqQtCKhrORx9
         ZDt2hQ6Si7IRI3Xtm/+ZwdvJYugSMCw2YMJTizYD8jmH9Ai+zd4kdyBUZh1DpmAHjC/X
         JC2oSSBt84HNUGQZuoOrzNJbFhQR/6vY0LwnJcSj2lg6aYdOlbRUjrkTNDdMhVpr/pv1
         UJMESWNTBNmA1groPXvfA1mJb65HNNQeb25wRPcKuyfEg5hP+P8t96s/scPFJMs/lZFZ
         xN7NrLlTYhiG8W5swPlGvic8RqqHwHJQfpBtsURiBKW45luC43BtjwqzpGtiGgpvizjS
         4uaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067623; x=1777672423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y6935qPu7M5NbZGZx6tTl1p29+OEVIHZ7LTwlaFJBLA=;
        b=OXd7tke5S/fPTCjRdlnOcUNIvMAVL11A2LVwVXy2EJM0syX0CzVh/M+9j2XQqpytO6
         jXeXKKV/bQ30HcWo63/QD/z4aI3+GiZp02bdf/hstFlOFFzH114tSwnU+peEHkFNa7IR
         rYK2q+vwWb4FHSlJP4ahF6qqEvLhliLyVKIq01xtBImdoU1YQKwli9JvtGMuveQYkc4K
         YF/WUeNX39s3V+t4MbVqNNrzVlIL9uCOykX3Q7nWTNCG0XEIJhwB2SZBEIfHatWvRO0u
         7R3t/RbtQ3lG9oBPFNjjvwY07mnymL5/OarwvWlnXwJSid3xiBgHoxZFdyYclALtQ0PF
         Rymw==
X-Forwarded-Encrypted: i=1; AFNElJ/w4kHGJjbpDgMf4+19Lp6wcvZxZzs/V9GPqF21B5xOt3HoKyL0CitEju9AK/KPNrjrzQuQhscx/99Z@vger.kernel.org
X-Gm-Message-State: AOJu0YwIfNqcvPkFw5GurjeimdXeOAlSdt5hHOyyD7hfXdxv9/gNaeg6
	2JaAUAvSYhlepwgTWbXuhQ4xEqhXq6AJ/ALpb9xR0eGNzNYkiOVBTPNIfxQ6DfAoQF4=
X-Gm-Gg: AeBDietK5Fe5dxzXV89y3RqNC1T2jywQeKgmjj4JYQ+EP7NvSM4ffDBKyIWOTaOZCUF
	ep7yOyZbsUiXDhlTyY7LGNEISjc74bqSZWu9mfn8MRGAPVyJviUWeN4V5CVuv2v524z4GKGh8f1
	mjG2cW2eHZXGFYFvA+5sxVBU9AlEWrjI88mpv2A9z2Gy6gbN9xRipwsYoRGgiXrKZFXFREeZZWq
	xi7xGGaQGrK2HZTGRsxTc4iRhdrYqys6OtAuz78tV5ivcht6O1FWawSMA/RODq8NqyE94KIkM62
	/5BphbSNF4VZ5Igcw9KLmPojb6XXwvv1vanM/WwcV2yeY6ZpnbJPIlk+Ih1R5uyCEnK7MSood7x
	Ki8b2FeE9nDQiMTIX/kSu+j7pX4TOI8YBcPwaKp1HMX7KhIBQiuKz2MhruOdG+rr1fxhdvCXljK
	g/wjlh5F4Peh5lOFdYbj6soqFjXOPZgO9LR/P/BYG8hEg9KOg4Tud/N1SjK+YzUSqjlwPhN9nDw
	KyygwSejwGkVfg3ALjAKJbB1/4sYD6HGTSwgDe0pz9TohUDqsqTgGK3d0w8QzqE1Q9cLJSfo93f
	x4IW06usYybWL3xKCPd/rzrnFAp326SKG1hUWvmk77JOzQ==
X-Received: by 2002:a05:7301:3d17:b0:2dd:405f:89b3 with SMTP id 5a478bee46e88-2e4528ce85cmr19190425eec.0.1777067622920;
        Fri, 24 Apr 2026 14:53:42 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:42 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 1/6] scsi: Add INQUIRY data field definitions and accessor helpers
Date: Fri, 24 Apr 2026 14:53:19 -0700
Message-ID: <20260424215324.99045-2-brian@purestorage.com>
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

Add well-documented inline functions and macros to parse INQUIRY data
fields according to SPC-6 section 6.7.2. These helpers provide a
consistent interface for extracting:

- Peripheral qualifier and device type from byte 0
- Removable media bit from byte 1
- Response data format from byte 3
- Capability flags (WBUS16, SYNC, CMDQUE, SFTRE) from byte 7
- Vendor, product, and revision strings

This is preparatory work for adding INQUIRY data update support during
device rescan operations.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 include/scsi/scsi.h | 171 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 08ac3200b4a4b..8f38d9a884f91 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -172,6 +172,177 @@ enum scsi_qc_status {
 #define SCSI_INQ_PQ_NOT_CON     0x01
 #define SCSI_INQ_PQ_NOT_CAP     0x03
 
+/*
+ * INQUIRY data field offsets and lengths
+ */
+#define SCSI_INQ_STD_LEN		36	/* Min standard INQ len */
+#define SCSI_INQ_VENDOR_OFFSET		8
+#define SCSI_INQ_VENDOR_LEN		8
+#define SCSI_INQ_PRODUCT_OFFSET		16
+#define SCSI_INQ_PRODUCT_LEN		16
+#define SCSI_INQ_REVISION_OFFSET	32
+#define SCSI_INQ_REVISION_LEN		4
+
+/*
+ * INQUIRY data byte 0 bit masks
+ */
+#define SCSI_INQ_PERIPH_QUAL_MASK	0xe0	/* bits 5-7 */
+#define SCSI_INQ_PERIPH_QUAL_SHIFT	5
+#define SCSI_INQ_DEVICE_TYPE_MASK	0x1f	/* bits 0-4 */
+
+/*
+ * INQUIRY data byte 1 bit masks
+ */
+#define SCSI_INQ_RMB_MASK		0x80	/* bit 7 */
+
+/*
+ * INQUIRY data byte 3 bit masks
+ */
+#define SCSI_INQ_RESP_DATA_FMT_MASK	0x0f	/* bits 0-3 */
+
+/*
+ * INQUIRY data byte 7 bit masks
+ */
+#define SCSI_INQ_WBUS16			0x20	/* Wide Bus 16 (bit 5) */
+#define SCSI_INQ_SYNC			0x10	/* Synchronous (bit 4) */
+#define SCSI_INQ_CMDQUE			0x02	/* Command Queuing (bit 1) */
+#define SCSI_INQ_SFTRE			0x01	/* Soft Reset (bit 0) */
+
+/**
+ * scsi_inq_periph_qual - Extract peripheral qualifier from byte 0
+ * @inq_byte0: INQUIRY data byte 0
+ *
+ * Returns: Peripheral Qualifier (0-7)
+ */
+static inline unsigned char scsi_inq_periph_qual(unsigned char inq_byte0)
+{
+	return (inq_byte0 & SCSI_INQ_PERIPH_QUAL_MASK) >>
+		SCSI_INQ_PERIPH_QUAL_SHIFT;
+}
+
+/**
+ * scsi_inq_device_type - Extract device type from byte 0
+ * @inq_byte0: INQUIRY data byte 0
+ * @lun: Logical Unit Number
+ *
+ * Extracts the peripheral device type. For well-known logical units
+ * (W-LUNs), corrects the type to TYPE_WLUN if device reports wrong type.
+ *
+ * Returns: Peripheral Device Type (0-31)
+ */
+static inline unsigned char scsi_inq_device_type(unsigned char inq_byte0,
+						 u64 lun)
+{
+	unsigned char type = inq_byte0 & SCSI_INQ_DEVICE_TYPE_MASK;
+
+	/*
+	 * Some devices respond with wrong type for well-known logical
+	 * units. Force well-known type to enumerate them correctly.
+	 */
+	if (scsi_is_wlun(lun) && type != TYPE_WLUN)
+		type = TYPE_WLUN;
+
+	return type;
+}
+
+/**
+ * scsi_inq_removable - Extract removable media bit from byte 1
+ * @inq_byte1: INQUIRY data byte 1
+ *
+ * Returns: true if removable, false if not
+ */
+static inline bool scsi_inq_removable(unsigned char inq_byte1)
+{
+	return inq_byte1 & SCSI_INQ_RMB_MASK;
+}
+
+/**
+ * scsi_inq_resp_data_fmt - Extract response data format from byte 3
+ * @inq_byte3: INQUIRY data byte 3
+ *
+ * Returns: Response Data Format (0-15)
+ */
+static inline unsigned char scsi_inq_resp_data_fmt(unsigned char inq_byte3)
+{
+	return inq_byte3 & SCSI_INQ_RESP_DATA_FMT_MASK;
+}
+
+/**
+ * scsi_inq_wbus16 - Check wide bus support from byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: true if 16-bit wide bus supported, false if not
+ */
+static inline bool scsi_inq_wbus16(unsigned char inq_byte7)
+{
+	return inq_byte7 & SCSI_INQ_WBUS16;
+}
+
+/**
+ * scsi_inq_sync - Check synchronous transfer support from byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: true if synchronous transfers supported, false if not
+ */
+static inline bool scsi_inq_sync(unsigned char inq_byte7)
+{
+	return inq_byte7 & SCSI_INQ_SYNC;
+}
+
+/**
+ * scsi_inq_cmdque - Check command queuing support from byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: true if command queuing supported, false if not
+ */
+static inline bool scsi_inq_cmdque(unsigned char inq_byte7)
+{
+	return inq_byte7 & SCSI_INQ_CMDQUE;
+}
+
+/**
+ * scsi_inq_sftre - Check soft reset support from byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: true if soft reset supported, false if not
+ */
+static inline bool scsi_inq_sftre(unsigned char inq_byte7)
+{
+	return inq_byte7 & SCSI_INQ_SFTRE;
+}
+
+/**
+ * scsi_inq_vendor - Get pointer to vendor string
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 8-byte vendor string (not null-terminated)
+ */
+static inline const char *scsi_inq_vendor(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_VENDOR_OFFSET);
+}
+
+/**
+ * scsi_inq_product - Get pointer to product string
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 16-byte product string (not null-terminated)
+ */
+static inline const char *scsi_inq_product(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_PRODUCT_OFFSET);
+}
+
+/**
+ * scsi_inq_revision - Get pointer to revision string
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 4-byte revision string (not null-terminated)
+ */
+static inline const char *scsi_inq_revision(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_REVISION_OFFSET);
+}
 
 /*
  * Here are some scsi specific ioctl commands which are sometimes useful.
-- 
2.50.1 (Apple Git-155)

