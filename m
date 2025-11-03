Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B9230B53A
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 13:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175129; cv=none; b=knvr2UqpCrMkzx9I3UDeGXKxmvwmP4nsCfDqgKNOxreMN+TmD9gaWgeV9QEgrnAefi0ohEphpOjRsrr/vP815guMCJTI8nLd5eJ0lq+bKbNUPdLkRnjRj2TuN767VgD7+xAzdyDRf7UWSQiwDO5K7sBbVUiuxcRoZRjD1Hy8r/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175129; c=relaxed/simple;
	bh=ij30OguEuI7Y2LhlP7nwZzEjA3ESY7I4DMVX6svoflg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TnSYOYyqtYDInxj9NvMqznevUimrOfRL/O9+8xczGEomn1HWkn49TXNNCYcq8PZjs6pDsrl9adFbDfr16M2dDYAuFkcBTx7KjabPe9PJ76Va59eE+970FrSlmJ6274HHpDuWqSUxdbQsrxQOup55LePYdU8eY122vqweNLehMZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6GKEddD; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6GKEddD"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso2963716a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 Nov 2025 05:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762175125; x=1762779925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ozVWAVtXHSgX1obV8UGv2F1d+5pDX97t1WQ6RoJB81E=;
        b=A6GKEddDE1r5DmfYEi2F/GFyjr7r3BScabLcBtl5PmgGgBiVbz03zGcY4pXnl/GZ1T
         rmBKZOVyQypip9eerK3j1Mv8L7KajqW47H/k9G+6aYDgN0otBJc6+f7Daoqr/0Y2Gmf1
         I0DdSmURQe8uU2mHwzmchjUoQCjGWlHOxszkbATBxotOgJUedr+UomJFbu36J2Sd/fjS
         YUuQzjDQwFOd1Qdh5AdZ6YzIvh4VZCTdpOHzSjX5HaR4rL0DQFVMoThH1//Q47M3343v
         9k32+vGMekcU9Z0rau3zOOH3LEHUVXJyO+YamUSx4l0g1LoR89t0+SXnGqw+ixBKI7Lb
         eYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762175125; x=1762779925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ozVWAVtXHSgX1obV8UGv2F1d+5pDX97t1WQ6RoJB81E=;
        b=mCdfd6nug3Jpkp9y66puBirmTKHzVSR62zMcQQdwj8esp/xWYFInyJ5LxBkllF8FuL
         q+J9Xz02pt149EquA8wQWfPEuZlykO/tUkhw11FzE9VcOgxvf0rF3JUd+WjaUL8gy9Mt
         lyYx9ABKukouZKXbbl7rybTClzrJ27u/fl27BVbpy/i0wprwNQl+J7EIXpBYhGPnbIe4
         ZvG6fg1HdGwG00CAGhnj3Iy6fLp7bhwOvmRhMEUHEzVqTshZ2s3Haut+dfRiMSdB/sJF
         HrfA4fYFe9yM28NnykTzfksPFUyyqa1lcJCgtvgzmND/+Cvdm+XidDTF5ExnZ7gSYxWi
         IpTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5SOkNBxPF0AxUZj2MQ9H97HXASg+zZQ7CHkgexJ8wNp5/j7dHTvfabWN/XVEoAGL6j2F4anpBjEAp@vger.kernel.org
X-Gm-Message-State: AOJu0YysjO05eZ73Tc4C2at4gcNJ5JkMuPBM2/2cFbxSk7XibTd4Rv8T
	r+UWw3HJrowLEz20QlUbC0Cad6kj6Ub/wHcS5rUUp1NLdh4IP0W0LQGQ
X-Gm-Gg: ASbGnct/1cScG836kxT0RyaH0OYdJcuCPOSarWgY9kZOUde4kUiQGopOn4ssDvNeLRi
	Xwo9YR6NfYmbLxisEnBI/tg+kb1VRt6jZbs9z8zMfjwATaona1AhA0YNTrNEhUhIL3p4Huog38Y
	yIETZwmEJfkkwWdiThenSCZS1BBIKPndDFreHaG2jUgs17jAzwc4Dg3HlqrCsA5Em6GsQGtNoY0
	So/7mMVTeB9RJOvq3TwisqpjU8nxgAtimeo0qcrBfn48yh4M1sO8lFyk/Z1iN1Wu/7XmAoWXBqo
	fNDIqYa93L+0CCrU8pmBAZNr5M3Q4xaCjN4seFedv672ytYs4kAH8pRMagJoYfjS27E8iYUxu4r
	IcFScmLa+/481vFO543KAnwMvVYotfDBsnZ0qu2hPr4mKRx4CTdlVRHRprfMymdzlujoGOAIZT/
	oO1A==
X-Google-Smtp-Source: AGHT+IGHwAzpxLt+4KjyIZZ2CRKiTYWUtpEk4DW5DkV2QX7tfq+tbxLumr3SVs8LIJ3Hd/OpvUVPSA==
X-Received: by 2002:a17:903:230f:b0:28e:aacb:e702 with SMTP id d9443c01a7336-2951a3a64f4mr155339785ad.2.1762175125035;
        Mon, 03 Nov 2025 05:05:25 -0800 (PST)
Received: from fedora ([2401:4900:1f33:62e4:5a30:25f7:ed82:431f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29526871b31sm122753945ad.8.2025.11.03.05.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 05:05:23 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: sathya.prakash@broadcom.com
Cc: sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	i.shihao.999@gmail.com
Subject: [PATCH] scsi: mpt3sas: use sysfs_emit function in sysfs
Date: Mon,  3 Nov 2025 18:35:01 +0530
Message-ID: <20251103130501.40158-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace snprintf() with sysfs_emit() function as it
removes unnecessary use cases of PAGE_SIZE also it is
much preferred for sysfs functions. This conversion
makes code more maintainable and follows current kernel
code guidelines.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 44 +++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 3b951589feeb..749f7163c7ee 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3149,7 +3149,7 @@ version_fw_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
+	return sysfs_emit(buf, "%02d.%02d.%02d.%02d\n",
 	    (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
 	    (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
 	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
@@ -3174,7 +3174,7 @@ version_bios_show(struct device *cdev, struct device_attribute *attr,

 	u32 version = le32_to_cpu(ioc->bios_pg3.BiosVersion);

-	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
+	return sysfs_emit(buf, "%02d.%02d.%02d.%02d\n",
 	    (version & 0xFF000000) >> 24,
 	    (version & 0x00FF0000) >> 16,
 	    (version & 0x0000FF00) >> 8,
@@ -3197,7 +3197,7 @@ version_mpi_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%03x.%02x\n",
+	return sysfs_emit(buf, "%03x.%02x\n",
 	    ioc->facts.MsgVersion, ioc->facts.HeaderVersion >> 8);
 }
 static DEVICE_ATTR_RO(version_mpi);
@@ -3236,7 +3236,7 @@ version_nvdata_persistent_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%08xh\n",
+	return sysfs_emit(buf, "%08xh\n",
 	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionPersistent.Word));
 }
 static DEVICE_ATTR_RO(version_nvdata_persistent);
@@ -3256,7 +3256,7 @@ version_nvdata_default_show(struct device *cdev, struct device_attribute
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%08xh\n",
+	return sysfs_emit(buf, "%08xh\n",
 	    le32_to_cpu(ioc->iounit_pg0.NvdataVersionDefault.Word));
 }
 static DEVICE_ATTR_RO(version_nvdata_default);
@@ -3336,7 +3336,7 @@ io_delay_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->io_missing_delay);
 }
 static DEVICE_ATTR_RO(io_delay);

@@ -3358,7 +3358,7 @@ device_delay_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
+	return sysfs_emit(buf, "%02d\n", ioc->device_missing_delay);
 }
 static DEVICE_ATTR_RO(device_delay);

@@ -3379,7 +3379,7 @@ fw_queue_depth_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->facts.RequestCredit);
+	return sysfs_emit(buf, "%02d\n", ioc->facts.RequestCredit);
 }
 static DEVICE_ATTR_RO(fw_queue_depth);

@@ -3401,7 +3401,7 @@ host_sas_address_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
+	return sysfs_emit(buf, "0x%016llx\n",
 	    (unsigned long long)ioc->sas_hba.sas_address);
 }
 static DEVICE_ATTR_RO(host_sas_address);
@@ -3421,7 +3421,7 @@ logging_level_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->logging_level);
+	return sysfs_emit(buf, "%08xh\n", ioc->logging_level);
 }
 static ssize_t
 logging_level_store(struct device *cdev, struct device_attribute *attr,
@@ -3457,7 +3457,7 @@ fwfault_debug_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->fwfault_debug);
+	return sysfs_emit(buf, "%d\n", ioc->fwfault_debug);
 }
 static ssize_t
 fwfault_debug_store(struct device *cdev, struct device_attribute *attr,
@@ -3494,7 +3494,7 @@ ioc_reset_count_show(struct device *cdev, struct device_attribute *attr,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->ioc_reset_count);
+	return sysfs_emit(buf, "%d\n", ioc->ioc_reset_count);
 }
 static DEVICE_ATTR_RO(ioc_reset_count);

@@ -3522,7 +3522,7 @@ reply_queue_count_show(struct device *cdev,
 	else
 		reply_queue_count = 1;

-	return snprintf(buf, PAGE_SIZE, "%d\n", reply_queue_count);
+	return sysfs_emit(buf, "%d\n", reply_queue_count);
 }
 static DEVICE_ATTR_RO(reply_queue_count);

@@ -3644,7 +3644,7 @@ host_trace_buffer_size_show(struct device *cdev,
 		size = le32_to_cpu(request_data->Size);

 	ioc->ring_buffer_sz = size;
-	return snprintf(buf, PAGE_SIZE, "%d\n", size);
+	return sysfs_emit(buf, "%d\n", size);
 }
 static DEVICE_ATTR_RO(host_trace_buffer_size);

@@ -3731,12 +3731,12 @@ host_trace_buffer_enable_show(struct device *cdev,
 	if ((!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) ||
 	   ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0))
-		return snprintf(buf, PAGE_SIZE, "off\n");
+		return sysfs_emit(buf, "off\n");
 	else if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED))
-		return snprintf(buf, PAGE_SIZE, "release\n");
+		return sysfs_emit(buf, "release\n");
 	else
-		return snprintf(buf, PAGE_SIZE, "post\n");
+		return sysfs_emit(buf, "post\n");
 }

 static ssize_t
@@ -4152,7 +4152,7 @@ drv_support_bitmap_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "0x%08x\n", ioc->drv_support_bitmap);
+	return sysfs_emit(buf, "0x%08x\n", ioc->drv_support_bitmap);
 }
 static DEVICE_ATTR_RO(drv_support_bitmap);

@@ -4172,7 +4172,7 @@ enable_sdev_max_qd_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);

-	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->enable_sdev_max_qd);
+	return sysfs_emit(buf, "%d\n", ioc->enable_sdev_max_qd);
 }

 /**
@@ -4320,7 +4320,7 @@ sas_address_show(struct device *dev, struct device_attribute *attr,
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;

-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
+	return sysfs_emit(buf, "0x%016llx\n",
 	    (unsigned long long)sas_device_priv_data->sas_target->sas_address);
 }
 static DEVICE_ATTR_RO(sas_address);
@@ -4342,7 +4342,7 @@ sas_device_handle_show(struct device *dev, struct device_attribute *attr,
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;

-	return snprintf(buf, PAGE_SIZE, "0x%04x\n",
+	return sysfs_emit(buf, "0x%04x\n",
 	    sas_device_priv_data->sas_target->handle);
 }
 static DEVICE_ATTR_RO(sas_device_handle);
@@ -4380,7 +4380,7 @@ sas_ncq_prio_enable_show(struct device *dev,
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;

-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			sas_device_priv_data->ncq_prio_enable);
 }

--
2.51.0

