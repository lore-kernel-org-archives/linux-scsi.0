Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B8E15AF6
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268096; cv=none; b=XIZwBtbI6vAQyaPTjjUM6cyMwR/lAm1AgDGNd7JL2HwWOY3GS46N0266sF913A4n2R4cnsGXuVg45EDmWukwwinTA6ykDe95BI4E2fXmERX8QSvR8OQGTdOs0vMNEbl4jm2/un0vLTHdWbXa8fCu7rjpEmrAw5gqHvAT1w9Ojik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268096; c=relaxed/simple;
	bh=BVkVuV8l2VvSZV2E4PJpFjgR//tyISdKXd85DMZ8qZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZC+STf5emZJEa/oeGkNjQI5cIOBiapWGG7QZMJttlvV7EalTGzRfygtJsCedenuLHVhvykZZd2rCDFMSw3tSzoGXokaeHxQYWABXVMI6UJFc3W1k2hpGZCGe6n5BP73BhWBfaiineO8fLE2Y9CmDM/uYgJaaPCy3dXVJigE5/fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=W5KMD44C; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W5KMD44C"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e3fca72a41so3072249a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 11:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731268093; x=1731872893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+qJPwsVRdHMgfer/Fm/vBstaR7dHI5+5HxGIUSRkCs=;
        b=W5KMD44C9BByr8MDKoasKCGvi4a8KnxT53pS3Tp/xxjlFLLvbdLapEQINLbquETiFA
         rB+/E1GM+431gI1L0yOceFiWyiVr/2zljqnEuACEcZM8a/uyaCbSFURkkq43Od8wiGop
         CVm+rKvJj4HB3VxUYWjS1e12uCo68Y90a14Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731268093; x=1731872893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+qJPwsVRdHMgfer/Fm/vBstaR7dHI5+5HxGIUSRkCs=;
        b=pLGizApI+0qm05FMhJyBZXSbCbdl5E9vQCv9NPNBR5jzS/4lLS4sPXaDZOzsHy9M5j
         s0BYbSs8b8Oic3n7BHoTxizdTvOEmzKnwTb16n1LAEbz+roXrE5U9Sz3tLVeG2JYHjFo
         d93Fg9BDQmmp0KXMsLXtWGUzxizADbKZOX5vOTorQDPOUo1w4BbuNFIvouaL56ON7qWo
         OqcBW2fYef8YfwsKVySC96WL8BoXeEQsUw/RQ05rlzhLdhAlAy6v3CKAV71u0oBCzuMG
         Az0VEDruchwfE+ykdeuXJrsu9OOF09m06OcCBxk6t+kXtQv4Xdjgo7oBgFKjq5TeWNzL
         DrZA==
X-Gm-Message-State: AOJu0Yygw8h5oC+R31+HpbzOPFhd/CulIFiTOJlpkp9DFX5BeLEVw0iK
	bQpdGWSeZKV/rGsVXNZ0fZWtS/l57p2lWyg62ylQonsWUGwJBF7IKS/spnUdSbPafjJOLEPXxp1
	gKlMJ1uH9fzn74dzb9vtXnpRFiUU8d+3QjdxE5RTn9fdOtyA815/v7uFzHTA30zvpvhsk6C0y+9
	IL7FpPrnkvmf3PfbQhR9QFZlhI5x958avc5pwMPg0fmtdmNA==
X-Google-Smtp-Source: AGHT+IEu6mCVcmcSqwE/3XXxNe+sKvw8sjmLRMmAGGwjJH0/VpIQ2DABLpLygCu+c2/YQ18Ll5ivlQ==
X-Received: by 2002:a17:90b:384f:b0:2e2:ddfa:24d5 with SMTP id 98e67ed59e1d1-2e9b1695600mr13267225a91.15.1731268093157;
        Sun, 10 Nov 2024 11:48:13 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9b50dcd9bsm4867586a91.21.2024.11.10.11.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 11:48:12 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/5] mpi3mr: Config pages corrupt when back-to-back PHY enable/disable is executed via sysfs
Date: Mon, 11 Nov 2024 01:14:02 +0530
Message-Id: <20241110194405.10108-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
References: <20241110194405.10108-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver exposes an interface through SAS transport layer
in sysfs to enable/disable Phys in a controller/expander.
When multiple PHYS are disabled and enabled in a succession
through a loop, some times, the persistent and current
config pages related to SAS IO unit/SAS Expander pages could get corrupted.

Driver to use separate config buffer memory for each config request.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 81 ++++++---------------------------
 2 files changed, 13 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fcb0fa31536b..f06ee0aa9ee0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -134,8 +134,6 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
-#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
-
 #define MPI3MR_RESET_TOPOLOGY_SETTLE_TIME	10
 
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
@@ -1133,9 +1131,6 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
- * @cfg_page: Default memory for configuration pages
- * @cfg_page_dma: Configuration page DMA address
- * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
  * @transport_cmds: Command tracker for SAS transport commands
@@ -1332,10 +1327,6 @@ struct mpi3mr_ioc {
 	u16 num_io_throttle_group;
 	struct mpi3mr_throttle_group_info *throttle_groups;
 
-	void *cfg_page;
-	dma_addr_t cfg_page_dma;
-	u16 cfg_page_sz;
-
 	u8 sas_transport_enabled;
 	u8 scsi_device_channel;
 	struct mpi3mr_drv_cmd transport_cmds;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f1ab76351bd8..2e6245bd4282 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4186,17 +4186,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_read_tsu_interval(mrioc);
 	mpi3mr_print_ioc_info(mrioc);
 
-	if (!mrioc->cfg_page) {
-		dprint_init(mrioc, "allocating config page buffers\n");
-		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
-		if (!mrioc->cfg_page) {
-			retval = -1;
-			goto out_failed_noretry;
-		}
-	}
-
 	dprint_init(mrioc, "allocating host diag buffers\n");
 	mpi3mr_alloc_diag_bufs(mrioc);
 
@@ -4768,11 +4757,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-	if (mrioc->cfg_page) {
-		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
-		    mrioc->cfg_page, mrioc->cfg_page_dma);
-		mrioc->cfg_page = NULL;
-	}
+
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
@@ -5392,55 +5377,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
-
-/**
- * mpi3mr_free_config_dma_memory - free memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: memory descriptor structure
- *
- * Check whether the size of the buffer specified by the memory
- * descriptor is greater than the default page size if so then
- * free the memory pointed by the descriptor.
- *
- * Return: Nothing.
- */
-static void mpi3mr_free_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if ((mem_desc->size > mrioc->cfg_page_sz) && mem_desc->addr) {
-		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
-		    mem_desc->addr, mem_desc->dma_addr);
-		mem_desc->addr = NULL;
-	}
-}
-
-/**
- * mpi3mr_alloc_config_dma_memory - Alloc memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: Memory descriptor to hold dma memory info
- *
- * This function allocates new dmaable memory or provides the
- * default config page dmaable memory based on the memory size
- * described by the descriptor.
- *
- * Return: 0 on success, non-zero on failure.
- */
-static int mpi3mr_alloc_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if (mem_desc->size > mrioc->cfg_page_sz) {
-		mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mem_desc->size, &mem_desc->dma_addr, GFP_KERNEL);
-		if (!mem_desc->addr)
-			return -ENOMEM;
-	} else {
-		mem_desc->addr = mrioc->cfg_page;
-		mem_desc->dma_addr = mrioc->cfg_page_dma;
-		memset(mem_desc->addr, 0, mrioc->cfg_page_sz);
-	}
-	return 0;
-}
-
 /**
  * mpi3mr_post_cfg_req - Issue config requests and wait
  * @mrioc: Adapter instance reference
@@ -5596,8 +5532,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 		cfg_req->page_length = cfg_hdr->page_length;
 		cfg_req->page_version = cfg_hdr->page_version;
 	}
-	if (mpi3mr_alloc_config_dma_memory(mrioc, &mem_desc))
-		goto out;
+
+	mem_desc.addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		mem_desc.size, &mem_desc.dma_addr, GFP_KERNEL);
+
+	if (!mem_desc.addr)
+		return retval;
 
 	mpi3mr_add_sg_single(&cfg_req->sgl, sgl_flags, mem_desc.size,
 	    mem_desc.dma_addr);
@@ -5626,7 +5566,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 	}
 
 out:
-	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
+	if (mem_desc.addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc.size,
+			mem_desc.addr, mem_desc.dma_addr);
+		mem_desc.addr = NULL;
+	}
+
 	return retval;
 }
 
-- 
2.31.1

