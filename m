Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7942B2EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474513; cv=none; b=cIs2sdFPie31MigakV4ONQqZjZpsXnZ5s/OILOkQYGewYKqLGUJZXMxq+GGVpCML/tw9CWHBzB2w4Af+Qsoe1QoGdP89YwIKBbu0Xx3jPXZQjFt12bk/NN7Zoiu9/TcWthnIvE2AJuPlpq0NeRMgI/Tt6/G5qMJnTrTK/E2V8Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474513; c=relaxed/simple;
	bh=eyiLdJg6rUhCrnKoC+s2pJMCAoyZmYSq+QaEy02UXmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivTI5nlFuE1gLLEtCZePlG7RU2B2oqIADPJirQl/bOrksXDy8dzhVjVFPBrBU8ZNSwjutuWYmWRWYQu1WzyIPY1ttSiAYGkFm5nvMhDdIjfB+Japdm1uTkflLwrcu07gjSsuhCd6pBrSkA/EWtTGDBblQw4EyF/9sztd/XFMspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=EK6PwtMl; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EK6PwtMl"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2c7f11150cfso5524745ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474512; x=1783079312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KRiRxeyeoEd9Ff29g8OadvIdiJFAPxV4WD1unqxyBao=;
        b=o1nYk28D4Ssnv3UBEO4A9sIG3F8+JB7/zg3q9TD9kirvHDF47O/3IoYSBkbG9zHYAr
         loygyEcLEi58WcYrNHJqsm/Ka1742IuLHNJLNsUY20UjYkkB3JXRgi83/znp0r5xGX1M
         H0KxU2hbxEZMynqDGYYSZA+iwSkJ42bqP/ITfed9lXVB+TrNded/CB8occqllX2cymkQ
         K+uj0i5TR/n9Y9zkwZQb6tGZ7MwxCxrJGO8BhnLzW0pD7ApsDMXedeZuwBfRKmyJh7fB
         HijcOtFgL8cTxXZpDTjkug12aCz5Km8pNQxxlH8eJL5r9l6vgm5sYHSS8BqX4EYqfYCP
         feHg==
X-Gm-Message-State: AOJu0YzHUcxI1frVxMERoAl8o8/O2sdzBbimnfJBJX4TgqJWCFBXx22t
	f5tr4PN9Qlvnsqnb+L7RLowswQaRd/8GH/oxewVli9SwXmbq5MPr0zSCRmvUzdMl6C/SJFPrB5M
	oJ2J1EkEZPIE8V2bGDFsCQQ9M+qn7i9mbwXLfMes0UOvnsG+pyDsq8mumu9fTec11/U+tGfQ1pj
	amHBiPSRsXhzCJa0Qn5rgmQWqWxhG5QPJXC9CxRDc2dH7tuyxqMTE2hgFgK/tQg7vR7Hz4xvTyh
	cXSbx+cg3CGST57
X-Gm-Gg: AfdE7ck9OTu6veGZXcZdvOB3q4E0m+bN9t+nJmQ2OKCEfUsNybVZg98w81ttvzQ3dUQ
	7tECpqG+vgUnYOyTQY8tTw5ObtmSlozt0LiOTKN5eX4e10crQTtU9AdYNfyimj87gwL83cFOHJG
	gYFTLYIag/gPQ29JKOpbSgLacDpLXgevQN+FAmu/nPoMnsPvj9uXDSlvDH1BIdFwdImUvSkR8EM
	Bi9LU05hLLSXZmTGsHMrvWq/E7HXHIHsqBC4065Obu7bFT6alT7PfcDfVuH+Z+0nUF6s+7gXKSN
	FozaKQBSMfYeENz20oOrXKoiJ7GhSwjFWEzS3wCiWdQRZptT7TSwTiX+ubpFNlgXP56o7i1ZKSq
	NfdVAVPy1+mVhC0m/lGYhAMEOI3nwOHwGdAJZ/+45SdA4tXn3rG/TC5BuZwFnkL+PGt/XzKoEkg
	2lxT2TUDXp+hi6WGweEnZKLl61JjLyrhe3vOWcF57JFmnFlQ==
X-Received: by 2002:a05:6a20:734c:b0:3b4:65ac:e2e6 with SMTP id adf61e73a8af0-3bd4b239a52mr7344076637.36.1782474511645;
        Fri, 26 Jun 2026 04:48:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-c93954b13f1sm269380a12.7.2026.06.26.04.48.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30ba395b047so2478858eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474510; x=1783079310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRiRxeyeoEd9Ff29g8OadvIdiJFAPxV4WD1unqxyBao=;
        b=EK6PwtMlltQywGifciCOMW5x574Ld8dUvznq6tDMvK8tJvqYsubP5kp6susBFnKEQZ
         EAYPZeEeWXDByD2q+dCZ0g5C+YGgYKX91zMd0COiaLb9y79RB7bvpJkUaEiQ39pcrcWs
         UuFvXNG3JZ4nJVzFRzZoSyOwyUvnJV/C3gns0=
X-Received: by 2002:a05:7300:510:b0:304:de2b:446f with SMTP id 5a478bee46e88-30c84e31eccmr7276689eec.28.1782474509802;
        Fri, 26 Jun 2026 04:48:29 -0700 (PDT)
X-Received: by 2002:a05:7300:510:b0:304:de2b:446f with SMTP id 5a478bee46e88-30c84e31eccmr7276649eec.28.1782474509097;
        Fri, 26 Jun 2026 04:48:29 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:23 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 01/10] mpi3mr: Skip device shutdown during unload per controller configuration
Date: Fri, 26 Jun 2026 17:11:00 +0530
Message-ID: <20260626114109.43685-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
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
index 31b19ed1528e..eb730318db47 100644
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
+		(driver_pg1.flags &
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

