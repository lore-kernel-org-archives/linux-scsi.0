Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E0198E9B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725532299; cv=none; b=egqFQYXcZ9FqBC7XRhBN1UTArDswQ3LbcpYP1/+gCW/VpEs+GdAEzI2u3lPTZgSml6Bg+bloVjuiUqxgRgFeS5Fl5kuhk5mTo6A/DLoW2+F9xpSw+x4514jUFbKEacJyAG7dckERgoCNGDefmARlql5gTBWh+zUrQocMbqoQzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725532299; c=relaxed/simple;
	bh=oMGAg8Sq+FQIfDWIQzkuJXuNgyPxgPPVTG7cib208Xs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DBMWvs13b6wtKnHfeWkrKRVivZOiGV4terplO8SB7yRjH0X6J5vJXTFHUozQbpgJ21GCKiAgvbhcNShMtLkUt4swysa1Ep27+Q1OuEXMwzhIFeQ1FQ4raBaBr4zSuL2ztECxsc5pq/zJf29PqxscpAy0l/7hSaXczxHw8qQKnPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E9WgHeM1; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E9WgHeM1"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-714226888dfso477750b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2024 03:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1725532296; x=1726137096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20LJLdc3ZfnQysenExTF4DcnDtFUWuo5Ky+Jkv7GR50=;
        b=E9WgHeM1Ar1EpYye0zBS9VlpCBl+MYFrn41P6mZKEDs/GAfQuWkMKC8i7+mrM6Gubh
         lD05RYtCoxPawSfLdZRdd5dNmkZxbarWS4c15k+TKNjXQU58dP1+3IV6lSJmirJdhTX6
         PDE6vNtLJOuN04aP9QCfrFxICziZh9L55O5Sg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725532296; x=1726137096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20LJLdc3ZfnQysenExTF4DcnDtFUWuo5Ky+Jkv7GR50=;
        b=pxhVOk9g739XBxxZXjAvPenI4a6KPYrCLESVoRi68IrxKzbXe69nduOTiTsqN1brT5
         kfnqYiqwO4ZKIKKuckYpzK35cex8hE5ZKl4sx4eU8uTulK1Av8/udirp2tO7Lir1i3of
         dir5dTS4FCMf37pHQ1Do5FSYflIXPMsAFITV8HuOHVex30Ot5x5CY4ZZ6pTNktMAHBEl
         DAJqdnrbR4AAGjyMGl3c43Pyo/D9jnJWgX4b6TNwMpdoJcGffznBdR8/VNwin0X8+HNX
         vrzr06yjyPHHdlBKMtlVHzLc1NHg8WM3ELa6x3UXV9j4mjhSBQaITyz6FAXJoKY5p4mz
         OX4w==
X-Gm-Message-State: AOJu0YzAVPoBEfaWVUax1mUMNcKvr2GllCnF9BqwU8dZ+N01dJxpTCku
	2qT7HZexCkQfgUUhm7ECZfA0TRlKSbMZObtzMJqUkd+x5zgsfifWz2o+RdQFBNZEjI8TcGtb0oR
	G9r183H0i67zsX8qbiVOpGwidgLbGlOxxfItQ3b6EPzSuIUX+ohZ9lVaTX4l7KPZQN0D2wLYIQX
	aq2mcmCu3epYdavUdhrVnYXdrtGhlR8IqDJ2kjWbTBXtGBiA==
X-Google-Smtp-Source: AGHT+IEFuYfTaAE0D254atniZ4cbS7UJ0mKrJMjNijYsckFhC+3N+L38UiOKRSHEQYBIzocuSjcxCQ==
X-Received: by 2002:a05:6a00:8a89:b0:717:90cd:7943 with SMTP id d2e1a72fcca58-71790cd7e90mr794945b3a.28.1725532296343;
        Thu, 05 Sep 2024 03:31:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785364f9sm2960177b3a.87.2024.09.05.03.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 03:31:35 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/5] mpi3mr: use firmware provided timestamp update interval
Date: Thu,  5 Sep 2024 15:57:50 +0530
Message-Id: <20240905102753.105310-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver will use the timestamp update interval value provided by
firmware in the driver page 1. If firmware fails to provide
non-zero value, then the driver will fall back to the driver
defined macro.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h |  1 +
 drivers/scsi/mpi3mr/mpi3mr.h         |  4 +++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c      | 27 ++++++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 4b7a8f6314a3..b46bd08eac99 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1327,6 +1327,7 @@ struct mpi3_driver_page0 {
 struct mpi3_driver_page1 {
 	struct mpi3_config_page_header         header;
 	__le32                             flags;
+	u8                                 time_stamp_update;
 	__le32                             reserved0c;
 	__le16                             host_diag_trace_max_size;
 	__le16                             host_diag_trace_min_size;
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 875bad7538f2..9c1d10ba24be 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1091,6 +1091,7 @@ struct scmd_priv {
  * @evtack_cmds_bitmap: Event Ack bitmap
  * @delayed_evtack_cmds_list: Delayed event acknowledgment list
  * @ts_update_counter: Timestamp update counter
+ * @ts_update_interval: Timestamp update interval
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
  * @prev_reset_result: Result of previous reset
@@ -1279,7 +1280,8 @@ struct mpi3mr_ioc {
 	unsigned long *evtack_cmds_bitmap;
 	struct list_head delayed_evtack_cmds_list;
 
-	u32 ts_update_counter;
+	u16 ts_update_counter;
+	u16 ts_update_interval;
 	u8 reset_in_progress;
 	u8 unrecoverable;
 	int prev_reset_result;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 39d7082f2305..0eaf30b6c251 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2694,7 +2694,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
-	if (mrioc->ts_update_counter++ >= MPI3MR_TSUPDATE_INTERVAL) {
+	if (mrioc->ts_update_counter++ >= mrioc->ts_update_interval) {
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
 	}
@@ -3867,6 +3867,29 @@ static int mpi3mr_repost_diag_bufs(struct mpi3mr_ioc *mrioc)
 	return retval;
 }
 
+/**
+ * mpi3mr_read_tsu_interval - Update time stamp interval
+ * @mrioc: Adapter instance reference
+ *
+ * Update time stamp interval if its defined in driver page 1,
+ * otherwise use default value.
+ *
+ * Return: Nothing
+ */
+static void
+mpi3mr_read_tsu_interval(struct mpi3mr_ioc *mrioc)
+{
+	struct mpi3_driver_page1 driver_pg1;
+	u16 pg_sz = sizeof(driver_pg1);
+	int retval = 0;
+
+	mrioc->ts_update_interval = MPI3MR_TSUPDATE_INTERVAL;
+
+	retval = mpi3mr_cfg_get_driver_pg1(mrioc, &driver_pg1, pg_sz);
+	if (!retval && driver_pg1.time_stamp_update)
+		mrioc->ts_update_interval = (driver_pg1.time_stamp_update * 60);
+}
+
 /**
  * mpi3mr_print_ioc_info - Display controller information
  * @mrioc: Adapter instance reference
@@ -4163,6 +4186,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed_noretry;
 	}
 
+	mpi3mr_read_tsu_interval(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	if (!mrioc->cfg_page) {
@@ -4344,6 +4368,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
+	mpi3mr_read_tsu_interval(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
 	if (is_resume) {
-- 
2.31.1

