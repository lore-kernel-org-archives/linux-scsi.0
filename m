Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C344C0415
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536039; cv=none; b=LQ+BU29eJkjajOreDUNL4MGDW2LTkmIV1FUh8vokDwsDlCSuEDLuH5/eVo7eTAoUKjwcwyGJeBTQs8/y3jmwi4lQArlBF7EgidVg/dsJL1iZji/6xFSVjcpusqC0o5c3smoxnift3FEZpCxNi+SdnhOgpVa6FU/WUMYfdJohjbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536039; c=relaxed/simple;
	bh=AgI1lfenL3QttQmCDErR5X3jgzdBrM+3dSMvnLzSt/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMxTugzT1LoMNYoeGuTMrmg1xs2vJaUdUZ4aLCI+Pc4zTi1UJeu7pORO5tYP5FSUHIrRGcbx5/kmHOlCRcev0AMAsgpFrxeRr933II9brc5/rNuJ2zQ/RkuP1xqkG7wxmMeVxgSZCxywWj1JsD/II5gZMP0r69G7371ea1Wt+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GB0fizc4; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GB0fizc4"
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso731007a34.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536028; x=1784140828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U+nUSPxnOakJh5Z3IK9y/f9LJ5QdWFq8RiDOB2oDesw=;
        b=kro4dlqG7rtPDfU9DcW+0WVxF2kePPy0QjPG9r6sv1JxIsmryLN4KOmEydGjoRX6kV
         rJ3vE85yoVO4ySAAuzHAWxKaI3sTzw2yva5z2wHMxpy87RrZIeY927zQdWd+OKa5NR7r
         Sv8TMz5Dyxhsx1feWaaCfdX3ORQanh6dOzWUsfq7gcD1AQzQq6mhA75Z7CejfaUIP/L2
         Qcy9eVO6B2l6zDwc9IRBkndXI/XIn6PohfH1MR9oYtraK374VUMplC1xBvnDvNYeyQES
         PObb3Jvo4SK8XASTwsWIDWKYEAEuW3Rk9atJxyw8+HHsWksks8M/WN9rHuJx/QeSkz8J
         Mu/Q==
X-Gm-Message-State: AOJu0YwREInePtXaGZazD+EL/2iMnFm1f5hiTDCZ6LO087RgqTq2H5Ts
	3IGliKydTSAcK7sl//s7zN7lHQ8kv3jgcRJPPX1k3WZ4dDDoBK/4Q6ZuCkWweiFkqZJfPp33MZY
	o1DqM1Ustqr9exvgG+AviwegXUFiQLMlEXwJ1V26E3J5eo4KTnfFQevgXyouVo3rLtkwrjDk01g
	+mKkwZoKocminKgvJ+Zq5qf5KZ0GIlnmu0hpPiYfiH4Rg0HieosyCm3CkQ+cUObWAz6vaFvJUL0
	XFxiVVQDeMm1+vy
X-Gm-Gg: AfdE7cmYlBH7bS0ecLqLxd1/DGF6qPmNchV2tgsZJvebeSQR9S3HbR6Vaob3+yyQWnp
	ps7eyvrPECOeUMvDAEKlgZaIYdKNdqlrkehgsTwVSaXak15S++ZA+PViORnmGE/R1CYA8Zys43B
	cpx1HGwoSN/T2GJUXmf7kc7Z1eYNGPLEPeIb6mydTqZt6yBJcyaWdGWLOdvec89x2K9YPJfOniK
	9sfe7vFBi+SQ+3V751ZWjF1Q8L91YENz9nmQkiyoed/ajioY+rsbHLTyI3BucfXR2w49vvPqmrU
	QydabI54snDzb7GvNd2PJn5S5f3kgeKbKfhDTqZOwbd6Nt3ALkcol2xVl4fSKKZOoGw4aKn4drW
	FzYNHqH82dDt19+p1rKMoVnwUF11H963DMStuS+a0h1nwInhos6ATA4wNlGKpRORJ+ODSYUoPCh
	VOGAhC6MH5fGvpmpewy/mUyaF3HiJ2sK+9JmEC1ZF1mZZf4g==
X-Received: by 2002:a05:6830:6c11:b0:7e9:b4cf:d8cc with SMTP id 46e09a7af769-7ebd0079619mr2442719a34.32.1783536027408;
        Wed, 08 Jul 2026 11:40:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7ebcadfd166sm234699a34.1.2026.07.08.11.40.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8484123e7c9so1148405b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536026; x=1784140826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+nUSPxnOakJh5Z3IK9y/f9LJ5QdWFq8RiDOB2oDesw=;
        b=GB0fizc4WFFTj9d6TKximTJTgrdY9pihd8F/BYs8lpEQHK9S0HD/Nk1FYohVTaSKqU
         bjRFpb6e19LHsQiDsDomCwyQpcdBIk3ITwscEFUbCt/8gjMF4ER6EvOquCKJkDJY4cwX
         EPg6nmi2Loh04h1OJgvJHTvWFLm4CbaVEjp78=
X-Received: by 2002:a05:6a21:485:b0:3bf:7bf7:7913 with SMTP id adf61e73a8af0-3c0bcead3cfmr4171230637.14.1783536025928;
        Wed, 08 Jul 2026 11:40:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:485:b0:3bf:7bf7:7913 with SMTP id adf61e73a8af0-3c0bcead3cfmr4171185637.14.1783536025232;
        Wed, 08 Jul 2026 11:40:25 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:24 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 01/10] mpi3mr: Skip device shutdown during unload per controller configuration
Date: Thu,  9 Jul 2026 00:02:56 +0530
Message-ID: <20260708183305.244485-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
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

Additionally, ensure the driver_pg1.flags field is properly converted
from little-endian to CPU endianness using le32_to_cpu() before
evaluating the shutdown disable flag to prevent failures on big-endian
architectures.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=1
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 35 ++++++++++++++++++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 ++
 3 files changed, 31 insertions(+), 9 deletions(-)

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

