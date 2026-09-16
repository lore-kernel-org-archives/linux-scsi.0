Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C9F469834
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547718; cv=none; b=JRUE98nk54HAhM/oHpONhnNTOgnxT/nzRWfUKHDOn5CnBEP537MMiELoUkjXGcMWDU3/4KJ4n1/TaBwEocJZMkDoluZkpmdXdw4TWww+slDa2hkZCPG3ywiiUForR6zhA1a+e8Y9yuajnlR1RGlA9pBmBKQT4WAiTBBl17oaq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547718; c=relaxed/simple;
	bh=VFdPWIhKngAB8+uN5uUlMUR+I11dim98xm/Ab5XEhgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US6jZGaojqoK5HRic9wTyG///AWsgmrK6aTwNRDJ6xfzvU6LY4I9ng4Fa5Fhv6FsQ1Ktkb3w9LZfn7xTrjTzNQgGc0WzLEmj1eueVUh3O8y0pcv182hWZB+dgmOxx2Rtzt9Drf+dw4TCzkvDDckKelnrrn0TYdiDzWAHBgBji3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Y6aY+Ll2; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y6aY+Ll2"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-86ec25cf7ecso1800684b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547714; x=1790152514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PAwP0d05XDng9tfNpu86dXCVZ78AlMnSPOylRurVkys=;
        b=YqPKtAfIKueIXaRd4M9kzxYjP0nU9PtxQKumouowCuNnAVtIzt+bwyYXKXxVhvz9DU
         k+ETGMTXzFAqBFxIGmvnLB7xikKmEZUAlQ7ITDX0A4W/qgDPnTZfPZgtnac9hIXw58wI
         l26HjBoRbSpqIuIOnGTMOR9EBzTWVbfdwQidlp12hKIFN+r/Fk1wEgpaIooTjNm6ksBa
         E1p1jmzeKTsoSUTAz+4xoeYgod82UKZr/o4jBi0F2VTcqcnBHbRdBjLxqqrau+8msysH
         uipFY33/r0TopbZpjWlSVrxyCZQxK82Te67huKEP/3kOKvMNIny2029ssU4Wka8lGjag
         IJrA==
X-Gm-Message-State: AFuF++knJdIzbosbW2IFBeJgb9gQgLeZp+aJ/6Sx1bI8i6k8InngyvIg
	LuzL0jEFmeYI/3ZC4u6X7WO1xRgwLCROULSgKXpf+9/o2CwUlk5zkSsOWw5rjWtCHsCKxBX6aSm
	V33cBw0phA6A0+f8TOt5ZFxVhNIbQOPaCBZTcuewOWPumi81GWVvYcLtNy2ZStNg0sNceUCfXxL
	tSnl2x+rceOPqmLg8QK/wp5p0wRbyihf0DMqdXUtMQZG+py5Q/Pav5mFApDxz1jWrLFe7cWAWYH
	nkYfmmtYCKGwD8B
X-Gm-Gg: AYBFou39ZDJ/fZAaneuDv2xGCQiUCuKKIMp+tbGLYm9ssez6eK+vkFv/sCMNG7EXAev
	TJK8G9ZndaQ/3ILLN2ih0KGp3WY8xwG8M3CgsZSJxKlUnnapov6Ukwi9jthhMhiCi6/UelbpU0I
	EQV9QI/jBUiNLc1z6ZP9bwkYObuEPBPP03OAAkU/hDcpyvdLwgs1woWTjy93b1ymh6Zm5futGZL
	e6Q79UKFZ7y9t9ZKgYxC9FHGUqvz/A4py2jClrvZ9oymQ4EBJcz+G6QkkoI/H7kNiA5FBNc0Gua
	z2Ux6KMt7318/nmeYiSgCECpRekEE1BGqoBBHeIjLL4WwQjHWgHBIGpDl6buDywF2i9Ei2VXnE5
	h039IYim9qQ1iOE89Y7HqBMJqjgAH0211o+9f9xzH/wOgX1O78mcr8NOav/zeec/FcWqJV/y5H9
	2WEl0OZsH72NV0TQ11WoE3h/M1ESMqD7LBZ70=
X-Received: by 2002:a05:6a00:c58e:20b0:872:a4fa:381a with SMTP id d2e1a72fcca58-872a4fa7d2emr496278b3a.2.1789547714054;
        Wed, 16 Sep 2026 01:35:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8720104c4dcsm598753b3a.6.2026.09.16.01.35.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:35:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2dd667770efso18699875ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 01:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789547712; x=1790152512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PAwP0d05XDng9tfNpu86dXCVZ78AlMnSPOylRurVkys=;
        b=Y6aY+Ll2LRJ6jEFkipkBxCkD4umavAPyZu5wGNQxKLjUPGlJqbrUT2RCojl0NHUFX8
         o3QtUmUwx/Hjn5ImAeIIfsEWrpDHUlIPJqa7fO3N4SoaXYhQNlQr+i2v49x6M70fQPL5
         YnPLrhWlC+sXjuvPTp5lR0/b9jd5oovx/70yg=
X-Received: by 2002:a17:902:f707:b0:2dd:4438:4290 with SMTP id d9443c01a7336-2dd764a7f0amr93620845ad.3.1789547712002;
        Wed, 16 Sep 2026 01:35:12 -0700 (PDT)
X-Received: by 2002:a17:902:f707:b0:2dd:4438:4290 with SMTP id d9443c01a7336-2dd764a7f0amr93620245ad.3.1789547711317;
        Wed, 16 Sep 2026 01:35:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ac47cfsm5226261eec.17.2026.09.16.01.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:35:10 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/10] mpi3mr: Skip device shutdown during unload per controller configuration
Date: Wed, 16 Sep 2026 13:56:56 +0530
Message-ID: <20260916082705.44712-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
References: <20260916082705.44712-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The controller may be configured through Driver Page 1 to suppress
device shutdown requests during driver unload. Cache this setting and
skip the device shutdown request during IOC shutdown when unloading
the driver.

Additionally, ensure the driver_pg1 fields are properly converted
from little-endian to CPU endianness using le32_to_cpu() and le16_to_cpu()
before evaluating the shutdown disable flag and allocating diag buffers.
This prevents failures and massive memory allocation errors on big-endian
architectures.

Also harden the diagnostic buffer allocation retry loops against
invalid firmware-provided decrement sizes. The trace buffer loop
already guarded against a zero or oversized decrement size (infinite
loop or unsigned underflow). The firmware buffer loop had the same
gap and now carries the same guard.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260724102505.115136-1-ranjan.kumar@broadcom.com?part=1
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 44 ++++++++++++++++++++------------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 35 ++++++++++++++++++-------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  2 ++
 4 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index c25525fe0671..39096004c60a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1410,6 +1410,9 @@ struct mpi3mr_ioc {
 	struct dma_pool *trace_buf_pool;
 	struct segments *trace_buf;
 	u8 invalid_io_comp;
+	bool is_unload;
+	bool skip_dev_shutdown_on_unload;
+
 
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0cdcb8d236d3..5184d9d516a8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -141,25 +141,27 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 		trace_min_size = fw_min_size = MPI3MR_DEFAULT_HDB_MIN_SZ;
 
 	} else {
-		trace_size = driver_pg1.host_diag_trace_max_size * 1024;
-		trace_dec_size = driver_pg1.host_diag_trace_decrement_size
+		trace_size = le16_to_cpu(driver_pg1.host_diag_trace_max_size) * 1024;
+		trace_dec_size = le16_to_cpu(driver_pg1.host_diag_trace_decrement_size)
 			 * 1024;
-		trace_min_size = driver_pg1.host_diag_trace_min_size * 1024;
-		fw_size = driver_pg1.host_diag_fw_max_size * 1024;
-		fw_dec_size = driver_pg1.host_diag_fw_decrement_size * 1024;
-		fw_min_size = driver_pg1.host_diag_fw_min_size * 1024;
+		trace_min_size = le16_to_cpu(driver_pg1.host_diag_trace_min_size) * 1024;
+		fw_size = le16_to_cpu(driver_pg1.host_diag_fw_max_size) * 1024;
+		fw_dec_size = le16_to_cpu(driver_pg1.host_diag_fw_decrement_size) * 1024;
+		fw_min_size = le16_to_cpu(driver_pg1.host_diag_fw_min_size) * 1024;
 		dprint_init(mrioc,
 		    "%s:trace diag buffer sizes read from driver\n"
 		    "page1: maximum size = %dKB, decrement size = %dKB\n"
-		    ", minimum size = %dKB\n", __func__, driver_pg1.host_diag_trace_max_size,
-		    driver_pg1.host_diag_trace_decrement_size,
-		    driver_pg1.host_diag_trace_min_size);
+		    ", minimum size = %dKB\n", __func__,
+		    le16_to_cpu(driver_pg1.host_diag_trace_max_size),
+		    le16_to_cpu(driver_pg1.host_diag_trace_decrement_size),
+		    le16_to_cpu(driver_pg1.host_diag_trace_min_size));
 		dprint_init(mrioc,
 		    "%s:firmware diag buffer sizes read from driver\n"
 		    "page1: maximum size = %dKB, decrement size = %dKB\n"
-		    ", minimum size = %dKB\n", __func__, driver_pg1.host_diag_fw_max_size,
-		    driver_pg1.host_diag_fw_decrement_size,
-		    driver_pg1.host_diag_fw_min_size);
+		    ", minimum size = %dKB\n", __func__,
+		    le16_to_cpu(driver_pg1.host_diag_fw_max_size),
+		    le16_to_cpu(driver_pg1.host_diag_fw_decrement_size),
+		    le16_to_cpu(driver_pg1.host_diag_fw_min_size));
 		if ((trace_size == 0) && (fw_size == 0))
 			return;
 	}
@@ -179,6 +181,12 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 		    mpi3mr_alloc_trace_buffer(mrioc, trace_size)) {
 
 			retry = true;
+
+			if (!trace_dec_size || trace_dec_size > trace_size) {
+				retry = false;
+				goto retry_fw;
+			}
+
 			trace_size -= trace_dec_size;
 			dprint_init(mrioc, "trace diag buffer allocation failed\n"
 			"retrying smaller size %dKB\n", trace_size / 1024);
@@ -211,11 +219,13 @@ void mpi3mr_alloc_diag_bufs(struct mpi3mr_ioc *mrioc)
 			diag_buffer->size = fw_size;
 		} else {
 			retry = true;
-			fw_size -= fw_dec_size;
-			dprint_init(mrioc, "%s:trace diag buffer allocation failed,\n"
-					"retrying smaller size %dKB\n",
-					__func__, fw_size / 1024);
-			goto retry_fw;
+			if (fw_dec_size && fw_dec_size <= fw_size) {
+				fw_size -= fw_dec_size;
+				dprint_init(mrioc, "%s:trace diag buffer allocation failed,\n"
+						"retrying smaller size %dKB\n",
+						__func__, fw_size / 1024);
+				goto retry_fw;
+			}
 		}
 	}
 }
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5c2547bb67a5..d122e95c9081 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4127,26 +4127,35 @@ static int mpi3mr_repost_diag_bufs(struct mpi3mr_ioc *mrioc)
 }
 
 /**
- * mpi3mr_read_tsu_interval - Update time stamp interval
+ * mpi3mr_read_driver_page1 - Read Driver Page 1 parameters
  * @mrioc: Adapter instance reference
  *
- * Update time stamp interval if its defined in driver page 1,
- * otherwise use default value.
+ * Reads and caches Driver Page 1 parameters such as
+ * timestamp update interval and driver behavior flags.
  *
  * Return: Nothing
  */
 static void
-mpi3mr_read_tsu_interval(struct mpi3mr_ioc *mrioc)
+mpi3mr_read_driver_page1(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3_driver_page1 driver_pg1;
 	u16 pg_sz = sizeof(driver_pg1);
 	int retval = 0;
 
 	mrioc->ts_update_interval = MPI3MR_TSUPDATE_INTERVAL;
+	mrioc->skip_dev_shutdown_on_unload = 0;
 
 	retval = mpi3mr_cfg_get_driver_pg1(mrioc, &driver_pg1, pg_sz);
-	if (!retval && driver_pg1.time_stamp_update)
+
+	if (retval)
+		return;
+
+	if (driver_pg1.time_stamp_update)
 		mrioc->ts_update_interval = (driver_pg1.time_stamp_update * 60);
+
+	mrioc->skip_dev_shutdown_on_unload =
+		(le32_to_cpu(driver_pg1.flags) &
+		 MPI3_DRIVER1_FLAGS_DEVICE_SHUTDOWN_ON_UNLOAD_DISABLE) ? 1 : 0;
 }
 
 /**
@@ -4452,7 +4461,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed_noretry;
 	}
 
-	mpi3mr_read_tsu_interval(mrioc);
+	mpi3mr_read_driver_page1(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	dprint_init(mrioc, "allocating host diag buffers\n");
@@ -4624,7 +4633,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
-	mpi3mr_read_tsu_interval(mrioc);
+	mpi3mr_read_driver_page1(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	if (is_resume) {
@@ -5109,8 +5118,16 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	shutdown_action = MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL |
-	    MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
+	shutdown_action = MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL;
+
+	if (!(mrioc->is_unload && mrioc->skip_dev_shutdown_on_unload))
+		shutdown_action |=
+			MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
+	else
+		ioc_info(mrioc,
+		    "The shutdown request is issued without the device shutdown bit set\n"
+		    "as indicated by the controller configuration\n");
+
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config |= shutdown_action;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a389f7f2c741..07a2a45b4957 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5728,6 +5728,8 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		return;
 
 	mrioc = shost_priv(shost);
+	mrioc->is_unload = true;
+
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
-- 
2.47.3

