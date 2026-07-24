Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1451E421255
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889160; cv=none; b=g/aWt7/VfHLasdVArPe1uIOmyH8WNDTuuhAllig0Jc9QE/Wt5Nd/Olk6d952gckSXHgX03WXOiDwORDBYFY7zZAvBxSStUBGG6pnKVvaa8SCfW8r4d2Pi8DA71HxqKqOdlPwG0x1haxe9fOJe20doFaR42lIlpHo+iUzbsXED+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889160; c=relaxed/simple;
	bh=i5BWGeBqIh030tdu8nCsh4rKoia8xgt8aOyg7s8yBOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzwqoX67zVzaIYnb0qwCZuMte484IeacfWB9XZEGTnvdbIsAF7dNP/e00ZjLz4hOn2bTeqpidoQtVaFACkR3LjKUERRh1XoyFIKccNx9aiNtjomrmGN+XZ4SNUIG8S0dRMurZrflNpOWIE2SObrg4YvcuPyZ+opd9huQpGdohnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NkszCn0d; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NkszCn0d"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-8efef6533aaso1891396d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889157; x=1785493957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cx0eiu6qBVGdDNpZQpNCH6AY9qodZZ80nOtR+w6sVX0=;
        b=FZOIFNNLdQgdT9EmI7D/jOzo57yYdDNDrJ5ysdTjSmzP3AJTOg9WEvTqjpH3tw6UIj
         ehV8Ee8DdPpODBYiObG2MUxK78fukycFdMGfyvllu0cJCFDbq6hmClhNN3DNncNCnxq4
         vP4Twz6TvSi35GtOm4+UhYqooYmRPX1+Rx/Y0WERbrI9J/YKTmkeQClSl+79S+MtiNQx
         TClvtA5CFlH7Tqy6qPcF/mW0ylPfmRz9LDqjNnsi2XWK2JCxN1g7bjNsPFvCeJgtNDmh
         wCfY0t9jslU2qyvQTmSVKtFmv47w57Rlo67svWcfAwlGhBZ78pVS97Lg+FJSYEn3eFwx
         wDLg==
X-Gm-Message-State: AOJu0YzSU8au7TKyqEeWS3DT9yeScAb38O1yzV9EEwwT8ARTaLzgFmCh
	hNdrPa6wzazRyA/nLxDlYf8QqM5lAFnxNHpOY8j1cuf6BWriKfKsXL2u2MUlQmAujJkeJwghRlr
	hCVlHthxoIZ91uyVruMFzK0+O0dAwBcBet/VKjNB6c1Khd6mxZ58/nzjyTOc4gAu5CzwjOSSqFf
	dE7ju3Sh8+dMI3QxfeUHRIq35mtGDIQysAadDeqAyzYl7GcXs/Tp2vdR0+FjA/LZ6KihmzLbQWc
	WXHgHzk2XehuB7h
X-Gm-Gg: AR+sD13A95gaQqq+dKeGEfXX1ipO8E1F3+lmOfW9xV4XwiOkhrrO37y1WgZnoTro2st
	4FUGRhViITwoMu8/vz1oVjBfiTtxslMTekl+qmjWlFWd7Prk5AHwj9dm202b2+p3FXQSzfOi1c1
	SuB57/1k465z9U4vgMYcTvXcxnVvk5eJEyOggtHkd18mejdJ6cIoXRW3KSSLv980S5XNV4Pfnp6
	Xtjrpq1L4NqZ9uaA8NUuTUg3vrENhlW45nI8qaboUYkUj4gdOIT0N8Wc45RxCNFgFzEp5D/ujoj
	3QHecBpYG5rBenSPZ/6Axno4qZsn/08CMmlo9Zx1m8vt8IyGZXHSkUfl16MuGvPIQ+nQUe7YqC+
	alUmaD37mUxbHhjNb0ToSVbuApZDieelPnA9vlTCr0Fduf/KVIPXilu1V8dX0aGXgWaGjgrAPKK
	fZpV51MPBbgu7tY/4jUNlVY7cStrNp8G3AKAI=
X-Received: by 2002:a05:6214:5c49:b0:8fd:6df3:b377 with SMTP id 6a1803df08f44-907ca5c1599mr73115506d6.59.1784889156696;
        Fri, 24 Jul 2026 03:32:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-907baa205fcsm4876646d6.24.2026.07.24.03.32.36
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so317820a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889155; x=1785493955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cx0eiu6qBVGdDNpZQpNCH6AY9qodZZ80nOtR+w6sVX0=;
        b=NkszCn0dmD248oyl60jum9gX7lPy72IlKNpzKId2v3VXH8aK5sUfCOnZ0hj0cbEeDG
         mO7fKUHieyjD86fkoBW1E5iAqRImhQpw6bOPsZ+9udpX7H37TtvgjGZStLsAcUzx+RBb
         6x1GeuVg74BFb1nl/PlFFU+zF1OUp2R9DPOLw=
X-Received: by 2002:a05:6a21:4801:b0:3bf:e66f:266a with SMTP id adf61e73a8af0-3c44b1e07b3mr7073256637.59.1784889155378;
        Fri, 24 Jul 2026 03:32:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:4801:b0:3bf:e66f:266a with SMTP id adf61e73a8af0-3c44b1e07b3mr7073224637.59.1784889154807;
        Fri, 24 Jul 2026 03:32:34 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:34 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 01/10] mpi3mr: Skip device shutdown during unload per controller configuration
Date: Fri, 24 Jul 2026 15:54:56 +0530
Message-ID: <20260724102505.115136-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
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

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=1
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=1
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 24 ++++++++++++----------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 35 ++++++++++++++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  2 ++
 4 files changed, 44 insertions(+), 20 deletions(-)

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
index 1353a8ff9c85..49243ef86dca 100644
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
 		trace_min_size = driver_pg1.host_diag_trace_min_size * 1024;
-		fw_size = driver_pg1.host_diag_fw_max_size * 1024;
-		fw_dec_size = driver_pg1.host_diag_fw_decrement_size * 1024;
-		fw_min_size = driver_pg1.host_diag_fw_min_size * 1024;
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

