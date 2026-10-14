Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593132248BE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015236; cv=none; b=ZuQUYTLjlzqofucI+vPQBuy5K6DoMHyE+eye5XMEIe6kDUULHlagUOvbnzWIy2KDwrifOi0jzrDMghm8KK6iYoGmInJnxuJ/SZ9pJ3flE00MPsFNWecZSZtKeKKLHktPh6/wB1EY6H2H5obE9foj8FlVHIuCBg64rFDCsR2WovE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015236; c=relaxed/simple;
	bh=/wE4A1kl339GStmvJEKdByIjYz3yLBZbC/C8aq2jDP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP+2RTKo24vMPBVDQVfaMVsvmAdjul22xa5k5HEtTy1BBDE2busHKUdc1a0UewwvKqPinyT5+5fhQRrLHZJZCgnMPJBIvo9G92qZaxstpfUl9GrznLSy0PGCn0fNxVW/58QkZRX/KGm/6duBlXYvOStSke7a0MpDEnbkIwf+OTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gAXabjnp; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gAXabjnp"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-154e9d2d979so1468989c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792015234; x=1792620034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kjiTypKsv5pi4NuPP/biNWoLL+FzmsODUoJqQhZBQDQ=;
        b=gAXabjnpHBZ2VUwANnkRAF/RK/jOPCWYekEXehBBYvn5YtjtF9pJf4neDFsTLc0O6r
         arxuhwZXiCRNgI/T4YIElgl8hOBwdC13U56caxcbVlOwfDdL9h8ApaicVk9tlMvLK3UL
         r+L3+Z7sr2ET9O3jJj3oZyW2Ccv+s2yRifo5vPMoLkPD8tMYmyhi41RQeDVxg0rx6OWP
         tW+wxCsNNNE33E0x7fGUL1jdM8UGugVVqOERboEKl7LQsokj4jm17XlQ6/BiOHIrx2nC
         zbzUKvLS3TwbmI1zLaotgl7eRUNUs06gxilIRfbMGW4T3yg699gKbm+0lmPNZ4CjPfKv
         85xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015234; x=1792620034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kjiTypKsv5pi4NuPP/biNWoLL+FzmsODUoJqQhZBQDQ=;
        b=xriCMPneBPb/j88Iq+MrObt6OYmGlVoT3qfAwcf2JXV85PepjJiTAx6/XyzrMaPjVJ
         xLFnCiEq47OIMKdUnsUBTuABMGipPWrg22LEWVnyH34/byieEGxJAiGPvZ+OeemQq6Og
         OyCFdKgbuqS+wT4VAy8sxCzStJrxETUTv4h9PBSFKjTDsXXS3QBjLXGl2bLOmrSAA2fw
         0ZWLQhBZ/bUZOnlQ+LbwZtR/RDdx2MTvNflluZo99ODEZ83plky+ughnQQKFB3My/Q1e
         0D8IsSh5cHMq8SkFlEQckIlQ5yx1ODKxdftZ8WHQ5vvWV7Xg40VTQZmb9Hv5XfB+qnb0
         lUbA==
X-Gm-Message-State: AFq9FYJbfsVw7+HjcqaW+RxgudUJx/24FhgLHec3cc+Cl98o5gx//eZB
	FmvgkWO96FIA8EZXABVFLiIkssLuxaVPCQEL1W88M5zpQ40bn+AJ/wOAyXy/cAvySPi4YntYY0q
	iMvmMIF7vikUmbp88fpr024AaCjPoyya7PYp8avKaNxMtUqY2dsnbb8M/kiAnmA9sEvjGev7lLB
	an71/kyFazfn85KvI/s/QT6MuArdC0bw6l2pRB/ZP3nSowVFTTOw==
X-Gm-Gg: AYBFou31SWOiimlTr47Nz4YOiInQt/2DwmGaR58GHkRDAFbRdET6TQlQIqpmwGznQ80
	IsLgGGFwxOkta4b/SPst2OunL70Nq/a48cOxE6fdtsG3H2eAquNWpCAFQycW4+qL3qFoewoSzmL
	ZakdHON1H23upiSOFFb5gbQ5VYC6WzixfTZ+zPbWbasNo15e3CPPpGmGx1nTeI3BSMSJ4fiy65F
	EkRODUhtIi9e2PIy58VSNFaK2Kl7mOM1RXPWuo0lvPkmXmZc9KG0V9wpUnXRpGn5UHZW2P6PqsF
	00DnI4iEHlXOL9ka7REixrfcXHQ7fNy3Da1rwoZuYF4q++weQDAQVEhgqN++HIEGdlqiC+4lPH3
	rL60FBZRvlF7zf8uSFQC/2mU+X5bxaNBR5RJJ0DbdZj3se51JIz60llIQ2HuN/dbYtznfGH3ukj
	N830R8/ky9YPjodqtbsAadwBFBHO7PzJtLlXiwHMuHxpr20e08/VdSRcTXj/OIwOBfd7x9xVvyq
	RYSqmOtKqzZv9aZl19BcGExSofCd33c1PX9ljyRLTx920Nx6d6banpNb3bzsaWUyvrjz/V9xRxr
	iboUuysSBukSqcWxVIo0jv8UbL+rdRkZQBHEZFI8aYLlymo+vlV+1rthyR9HXQZgQ624C7E=
X-Received: by 2002:a05:7022:285:20b0:159:d448:dd1c with SMTP id a92af1059eb24-16a14227a91mr21577423c88.19.1792015233704;
        Wed, 14 Oct 2026 15:00:33 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm30236633eec.24.2026.10.14.15.00.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 15:00:30 -0700 (PDT)
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
Subject: [PATCH v7 1/5] scsi: core: Protect INQUIRY sysfs attributes with mutex
Date: Wed, 14 Oct 2026 15:00:10 -0700
Message-ID: <20261014220014.94330-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014220014.94330-1-brian@purestorage.com>
References: <20261014220014.94330-1-brian@purestorage.com>
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
2.56.0

