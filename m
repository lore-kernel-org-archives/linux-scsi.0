Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E273F35
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638337; cv=none; b=Hw9OTXHR4vO79r7z26IdSo2tmhU61lbi80ZpCY3/CT/0CW4VJWiU88NNHiGV0gRxWXhHudRRdbGw7gbwc/ccGxmEe1+H+ABrvhX91Q8Dmmu9ONM/LO9e0Qp+UMHDWNiX+jOtewj+vAnydUE9DPkiPydg6JPYtCTMHr8FQGR5vIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638337; c=relaxed/simple;
	bh=IZLFcYg2OIZSLkiQ/W/q/KUUDiPZzSGXAYOJi8me4oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msTpLCVb/nwHmV6tIluCHsvdsUfPyuSltSmghgzEAGo69NUGTXuE33hg3Qqi21NgIRYHbnFiC0+13dZ+z4/an+Tvd78kQfZGgCZWNrAI6gab3vSSXh9WmtxzHaSubsw6VpKGProtS1aQdaGemO1EaUnY3XAl1JKklijDkmM0Exk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3bba50cd318so126573b6e.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638335; x=1709243135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDsDYeayP8K2ZFZQIHRgga96Fxvejuk3hfJv5kIPTZY=;
        b=Uza7LtwtPyOeoTCACmlaLtjqL+5bnqtmUvtlhLmTiEfoCnECo8PcvLKjNfdQyjobe0
         Wd26APIb1WA1PhNuxlzxLpnNXxfSUaESNaaRfrV4dTpcpM0U5RaTVUCqDvfyK1WOHkzn
         Vbpa9M3VVulAaGTwN8npPtbALvPCRbcYlYHX1cf5t9jvSqgmgtyTuuiY8pXq2cGogdW3
         qrQQWqEyvU88+DaAzTH4xISM+7GdbYn4DpSV4N5pBMABUjnJm/h5YaNH1+XCYW+lH6YP
         XOlvCu/+IvUUBh8RGZZ14yeG7bC6cWgUxp6ZRVDdvBpu+xrT6XS81I596A8PDgdm7AMN
         MT3Q==
X-Gm-Message-State: AOJu0Yw85hqlijUwVcjwFUlUE9hs0oudVVMIZXo5kM2QxRx46sZ1+aH4
	WNA++EirZ0GyONXPOP0iZl4RKngRlkD1BxYxlUFutrmXBZIcItjS
X-Google-Smtp-Source: AGHT+IHaMVYC8QyQy3ih8GZtYSEVQOSVIlFYGjDKMPveS8APaGUjP6YcAt/V1rqJGUdtb0uSjotsZw==
X-Received: by 2002:a05:6808:1151:b0:3c1:862d:7e2e with SMTP id u17-20020a056808115100b003c1862d7e2emr178771oiu.50.1708638334668;
        Thu, 22 Feb 2024 13:45:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:34 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 01/11] scsi: core: Query the Block Limits Extension VPD page
Date: Thu, 22 Feb 2024 13:44:49 -0800
Message-ID: <20240222214508.1630719-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse the Reduced Stream Control Supported (RSCS) bit from the block
limits extension VPD page. The RSCS bit is defined in SBC-5 r05
(https://www.t10.org/cgi-bin/ac.pl?t=f&f=sbc5r05.pdf).

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c        |  2 ++
 drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
 drivers/scsi/sd.c          | 13 +++++++++++++
 drivers/scsi/sd.h          |  1 +
 include/scsi/scsi_device.h |  1 +
 5 files changed, 27 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76d369343c7a..74cc3369dd8d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -499,6 +499,8 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
 		if (vpd_buf->data[i] == 0xb2)
 			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
+		if (vpd_buf->data[i] == 0xb7)
+			scsi_update_vpd_page(sdev, 0xb7, &sdev->vpd_pgb7);
 	}
 	kfree(vpd_buf);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 24f6eefb6803..93652a786a46 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,6 +449,7 @@ static void scsi_device_dev_release(struct device *dev)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
+	struct scsi_vpd *vpd_pgb7 = NULL;
 	unsigned long flags;
 
 	might_sleep();
@@ -494,6 +495,8 @@ static void scsi_device_dev_release(struct device *dev)
 				       lockdep_is_held(&sdev->inquiry_mutex));
 	vpd_pgb2 = rcu_replace_pointer(sdev->vpd_pgb2, vpd_pgb2,
 				       lockdep_is_held(&sdev->inquiry_mutex));
+	vpd_pgb7 = rcu_replace_pointer(sdev->vpd_pgb7, vpd_pgb7,
+				       lockdep_is_held(&sdev->inquiry_mutex));
 	mutex_unlock(&sdev->inquiry_mutex);
 
 	if (vpd_pg0)
@@ -510,6 +513,8 @@ static void scsi_device_dev_release(struct device *dev)
 		kfree_rcu(vpd_pgb1, rcu);
 	if (vpd_pgb2)
 		kfree_rcu(vpd_pgb2, rcu);
+	if (vpd_pgb7)
+		kfree_rcu(vpd_pgb7, rcu);
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -921,6 +926,7 @@ sdev_vpd_pg_attr(pg89);
 sdev_vpd_pg_attr(pgb0);
 sdev_vpd_pg_attr(pgb1);
 sdev_vpd_pg_attr(pgb2);
+sdev_vpd_pg_attr(pgb7);
 sdev_vpd_pg_attr(pg0);
 
 static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
@@ -1295,6 +1301,9 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_vpd_pgb2 && !sdev->vpd_pgb2)
 		return 0;
 
+	if (attr == &dev_attr_vpd_pgb7 && !sdev->vpd_pgb7)
+		return 0;
+
 	return S_IRUGO;
 }
 
@@ -1347,6 +1356,7 @@ static struct bin_attribute *scsi_sdev_bin_attrs[] = {
 	&dev_attr_vpd_pgb0,
 	&dev_attr_vpd_pgb1,
 	&dev_attr_vpd_pgb2,
+	&dev_attr_vpd_pgb7,
 	&dev_attr_inquiry,
 	NULL
 };
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0833b3e6aa6e..86b819fa04d9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3108,6 +3108,18 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	rcu_read_unlock();
 }
 
+/* Parse the Block Limits Extension VPD page (0xb7) */
+static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
+{
+	struct scsi_vpd *vpd;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
+	if (vpd && vpd->len >= 2)
+		sdkp->rscs = vpd->data[5] & 1;
+	rcu_read_unlock();
+}
+
 /**
  * sd_read_block_characteristics - Query block dev. characteristics
  * @sdkp: disk to query
@@ -3459,6 +3471,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
+			sd_read_block_limits_ext(sdkp);
 			sd_read_block_characteristics(sdkp);
 			sd_zbc_read_zones(sdkp, buffer);
 			sd_read_cpr(sdkp);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 409dda5350d1..f1120de03d51 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -151,6 +151,7 @@ struct scsi_disk {
 	unsigned	urswrz : 1;
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
+	unsigned	rscs : 1; /* reduced stream control support */
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5ec1e71a09de..f670b55d803a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -153,6 +153,7 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pgb0;
 	struct scsi_vpd __rcu *vpd_pgb1;
 	struct scsi_vpd __rcu *vpd_pgb2;
+	struct scsi_vpd __rcu *vpd_pgb7;
 
 	struct scsi_target      *sdev_target;
 
