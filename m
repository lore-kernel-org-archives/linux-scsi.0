Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A905E2E7384
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100444; cv=none; b=UbYIUfztSsX0KN+O4lo94lQpu7mClpPMlRgzQNDc7AmfzE2MZCAGLqG4jytNtzijgBzff1RjIvjAO9aI7LIS2HjqanulCpFdyXLmPMLV4DciaXaPSlwcNY0rw2wvnw/B3cuBNl7AMBrj75eSatiowZ0twOmqvQvgu4I2DYLbWTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100444; c=relaxed/simple;
	bh=oj3YydESXEllOPmD5RApchEBmCIs8U7O5hbJbUR/lx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRTK7WwPXK0n6LFaUfAISZin541B9bUZfXw6jSMJTQV26DDbJYLxhaipEHuQaZUCc2SP0Kn9WhRHJGJ5tGREaMYkwd2v/PCdvT40iUNDomWjM8G6TsX4H/lTk5xnnHuW75OuMMRUhol/W7ogpuQDa9CdKfnqP84ObRHuPDDeWaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WWKAKW7R; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WWKAKW7R"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-135e7f4a295so6645574c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100442; x=1780705242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdCuSh/CUgbMv++D6rJhaUKd6Dm8s/fEny68Mn1NlCo=;
        b=WWKAKW7RZgYZG2yt6VHCzoK3Ql7llLt2Pln5Q6Pi+cmoM5erdZhpfa8UIh9fiCtkLW
         A76FWtO9pBiOS2nJEsrA1vjcf6wvx1tZOCXxs/iqEJQDEVtVWI0SQf/SDaJKg2B2Q3iL
         sMNrnE1QJb8mr/L3RTIRQxykEZdL/iJ60OC2kga8+CjLHmWeRhvXtwLSg+vpcNrnLU8g
         BFWRgy+wcrxGF5Uy1DLQsMO8b7y2xPe01/swWWUVDcgvxJXXO8N0oxJXC1gyXDQEnuvK
         k2FBwWuBNqjRodX8qUN01o/gZfEivCsk2In8VztENIAAqSRZapKA49W6dlRMeUxrvOZC
         lfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100442; x=1780705242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IdCuSh/CUgbMv++D6rJhaUKd6Dm8s/fEny68Mn1NlCo=;
        b=OZXZ85NluvQpxo/PEw4QVO+l8yZ49gYfwSDoSdHGwVH+kls8bhATkDN9oxJ5Ubw46i
         ggm/DoPy7g9ZwoLwOE7kSdPPmhJQ+HksX79F8KhgzSkSf+6v/NMs/5SqJHanr9r4fPAL
         70mhzpv5ZLVyvh8ruvsnbdtHVt97/cu0K5zuTKixUKBT2G1TLjoPfGKYlz+gBbugbpxn
         vCPT3MPYzstlpZPYHwFmMrxzFspiAYRe505Z66ZOfwIFWFfuw7jwe6dEvRcUwdV0ljSI
         dcJeObqnHg5ztlwGcyx5+vIgr4kVYVaHX8gzgqHMz6vWoj6peC1RH//VX28VRd8zrOx2
         0ydw==
X-Gm-Message-State: AOJu0YxQa6I4pu+BQZ/TvgOZ0j0VhJY5/PxXk/AEPZd7PW7AhEh1GWzZ
	Roe1Tl51ySRERO1CAkZW1BDpQQYfrTw7nVfp/6YgvvqJAKUfqZhHgkf0Vqh1iyHgTdsnhKs4CMS
	+j2kx8pAK2lntbLRaVz/bZcAyrQ4uBTXcVVNERaH6stAa2j6zzl7Ue5XnURBa7iynv22mG7bKqU
	auN1mJN6VkaxgP4RTmQH4b5W1wr262G7gxj40v8U/3/jau70avLQ==
X-Gm-Gg: Acq92OEf3MO7DAIniDyUKdSY0NiMChUiGdDR5lv6M3pKYAIVSnsnxdqz9HIWr7wSBEm
	q2QDAvZbTl/mzHwBTNeZrL2dHTfS+mU3BCExKLOyOAugoPjKsjrUJtI8lL1u+wRpRpdLzCT9YsA
	C6OmAXTxyu4n5PAoXV3WB/5ldpRd6V9k6faXYSBtPrvMOuLxrsGLsI/B9Z54YEYU+s9gOpoh3Rt
	uucojkyxlOONGtkfNPElRkATSPS464Zgrz7xKGAykhlvKjoDkbVP1CQrTwXxT7BeOR40RJgeVFO
	ElbofxEdyag8RXMsb1QtNsmmbNhp7PLEKKsfbcX1rZPkjeXuVT+w3HCjvRZ2UDyaoqNEzkrO+61
	Vb08TM9zWJFAbQ2yxYBGxZUhx7/9BUcA1efJCWSwQABCErf2X7C0dfCxHmkdNDEKvF0RG5qww9/
	C8nHWwExiSAWtkHf3Wo3Xeit71WIk0b3x8qeZLOJDtPR+6POMPE0AbedgrusdJkbv62FKI0IX6U
	Uz+B6WZNjmuN9p8fC84KNJ/b8dJi/4TvDmU4iq11EotW9t8SJE0o+6X1ltImCak6qSMcpIWZRqf
	WeB7vAtHnzdtqGq2gO9SnB5Y/qwUjpT860Q=
X-Received: by 2002:a05:7022:6183:b0:135:1ae8:39a1 with SMTP id a92af1059eb24-137ae97fb4cmr2000821c88.17.1780100441512;
        Fri, 29 May 2026 17:20:41 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:40 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4 1/5] scsi: core: Protect INQUIRY sysfs attributes with mutex
Date: Fri, 29 May 2026 17:20:15 -0700
Message-ID: <20260530002019.47109-2-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260530002019.47109-1-brian@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
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

