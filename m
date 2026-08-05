Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414CA432BE3
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928455; cv=none; b=W7VLvfhEksHfpRSzCJaF+oDGrLyg0lpHlpK99h2+C/Fjuh/11d+AvUDW+6R4Bssjs8fxkBUFC0brnICAYY7wDRW8O1cLq7tSSivqECGO9U17moBsgq8vdoyonbuOHkGvupKxO8liXmEh2UhcKheZJddcrmnqZ0fitacYD9UaGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928455; c=relaxed/simple;
	bh=KN+ul6i3x9eKvBQzJJ7j2q9bd7SXEnRF9RHlgoJTIFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQPVWfE+BSQMM0/B2Ht2Gl3OIFXkcx1bwvSQ3OVUB48ijrCkm29gBBzjQkI3GVyXv9IC3ME6JVfhIHLtYUJQbZw991nLcVM0Vok1j+gTJrEVw0jkgwH0FRvS8QZjw6vAqCIP7XH269WG7YKMhzSWmRHUgYrJBxHq8TbanC1s670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Uxq3sSQ6; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uxq3sSQ6"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so809306a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928453; x=1786533253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xUUzcIobmhtLoLj0b/LsrMCBLXsMLqFua2DUeD+nzr0=;
        b=TfyZKE/ZAZ4S7vQKi9GF45Dw3HglbukFxJdpY3N4Z19qL7D3tI9pl3fFb948b3K8gc
         v2rwfFUSNDJp+mFXtc5vpsBtzxD3ItQfBlLv9DldS1NkR95Dvn6jnlTl3PVp7g0iCJPv
         wya3pzD7wpWQYQ1AVKS97Lf+qEFWA3fi2cjbbP47XuEMHH7UzKBGw2eA7lNZW8z57KoC
         mGBi/n5+rsb4TQx1AWZinJlvR1pd/GzIYYfPivquLl+PBqauB+6fPxQIfh1XgqOd2eOH
         RCTlkJGxiz/J2+F5mffwI7y/EMwDVBpau86/T2y8jRghI0X3O06SiwIg9U++grOGGb4/
         H5cA==
X-Gm-Message-State: AOJu0YxV1k90ImssewKhwUaz1HFxsbw85RzKwgYrjBB8iwPd+nOSk+F+
	2SxQDHNjt2Nmqg8aTCVLKw94HvQm5aq6vUSsf5qP0RWoRUjcUMlVeopzo53rtQ/VMz2B4f0SPJ0
	zTy9JGHEOZCGg5G0iUvxqyR0yBiWSK7NizK4n/ZIvzvaq0uXraq5buquGfk6jh85MsoPY6J98SZ
	f2eyD1vfazLmel8VxVNbOjIH+BAYzak2FSdYScu08zyKgZD0U7V5zmhuEXCMLXDUrgT70QZMD81
	B45h8Rgw5kASr/T
X-Gm-Gg: AR+sD12i3l3uK8zm5lW9o4/t5OaVstSnsd7WYL2CvOhyQIMPxWdm9CWkGL2Yl4BtE3m
	eh4iOh7zy/+/q3OSv/8zvknog6WrgvPVDQtxg4P2Z5VjSiAr11NN4FQy/Mc5FvUrQ8XI9hUYX+x
	Up92Gj3x2UcEY2nMfUZDRTCzaC0KzkcdH3kkIwjywewwVA3vQ0dVeaNNvXpYv++YoQOGun5wnGS
	com7SA2tClsROp4s+pyHxaP8ASUacQnJRreidwojDDtK4Vf3150J8WvJ3F8lO8LXRbOGzrOf4ij
	lXg7bWVZ92TE8wmbf5P9heAGDir5D8E7w6JmWiomOu4RtnodZoJhYlW9OjBpB1rEOVsi7Eoo6mD
	9biFgomlUDuoQwBUMo+J+cn9hrwJjtsNSZvnekjvzCZyiP/AcUfIuSjlNXf6f4IRVIy0cVnNNVB
	SachoXsyiCQPigSR4CBFUjMXpJsoPoiROSQsA=
X-Received: by 2002:a17:90b:528c:b0:380:9f17:6df3 with SMTP id 98e67ed59e1d1-3903c5448dcmr6435948a91.4.1785928453410;
        Wed, 05 Aug 2026 04:14:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-390392b0042sm784736a91.7.2026.08.05.04.14.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso1255931a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928452; x=1786533252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xUUzcIobmhtLoLj0b/LsrMCBLXsMLqFua2DUeD+nzr0=;
        b=Uxq3sSQ6PxUv1TIee66btPhXqiM/kaDVJCCCIUGK/CZXsF3aB9/9370JdUP7hHBTHA
         HPLc1xNGnKngoNK4oHJuT2JlyvJz1ry1IVsIMxqvR49F1wbRl1QqwK9p5U47X+0+JpfZ
         Le+k0ioHRrZKiuj7RNpseG/DMezfSTIZhyYw8=
X-Received: by 2002:a05:6300:220a:b0:3c3:7cfe:b32a with SMTP id adf61e73a8af0-3cb85ea6fb0mr7645722637.27.1785928451589;
        Wed, 05 Aug 2026 04:14:11 -0700 (PDT)
X-Received: by 2002:a05:6300:220a:b0:3c3:7cfe:b32a with SMTP id adf61e73a8af0-3cb85ea6fb0mr7645640637.27.1785928451003;
        Wed, 05 Aug 2026 04:14:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:10 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 01/10] mpi3mr: Skip device shutdown during unload per controller configuration
Date: Wed,  5 Aug 2026 16:36:25 +0530
Message-ID: <20260805110634.346670-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
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
index 1353a8ff9c85..fca5357a515d 100644
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
index 31b19ed1528e..59241038f689 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4107,26 +4107,35 @@ static int mpi3mr_repost_diag_bufs(struct mpi3mr_ioc *mrioc)
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
@@ -4432,7 +4441,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed_noretry;
 	}
 
-	mpi3mr_read_tsu_interval(mrioc);
+	mpi3mr_read_driver_page1(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	dprint_init(mrioc, "allocating host diag buffers\n");
@@ -4604,7 +4613,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
-	mpi3mr_read_tsu_interval(mrioc);
+	mpi3mr_read_driver_page1(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	if (is_resume) {
@@ -5089,8 +5098,16 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
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
index 402d1f35d214..d2a20f2721db 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5665,6 +5665,8 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		return;
 
 	mrioc = shost_priv(shost);
+	mrioc->is_unload = true;
+
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
-- 
2.47.3

