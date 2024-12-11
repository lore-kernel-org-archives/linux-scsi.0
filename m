Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399772360B7;
	Wed, 11 Dec 2024 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943096; cv=none; b=H256udA3RWVTUgHcyy40QaVeQmCrF0UpBES21cevkgDLJ9rSRmXrNiHxYhWIxRHxX4x8N5WYCKLi9Gsz5kmcsUquoCbkDCU6JKPjg6kdhLLAOznaetlqto3dTAiVkPdQW3hxbjtHoJX/PR3xm6ng3FT/7Y3VEI/I3c/Nh5b+E54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943096; c=relaxed/simple;
	bh=4fhVx/lGMnnaWypL5pAeX32k7LpubOof/ekwQUKsTFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIS5rw7Qe+79dkvD6KibXJMdpLpM6PXX7dvHNB9V0inOWHBl6+U4J+HncxctV3xE/lOKiu8AxqvbwLF1s4Zk+zZaL1X2xLXbex4iycqi8TNGaiWXA6zcHcLPTAfzWh+Zl/ICyNTU5LblXuEhOLDYx3elaCG5cEurwoEIfLWo0r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFol3W0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFol3W0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EC7C4CED2;
	Wed, 11 Dec 2024 18:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943096;
	bh=4fhVx/lGMnnaWypL5pAeX32k7LpubOof/ekwQUKsTFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFol3W0kUgWAfy8SQ4VVD463gRtpC/+9IJL+XjkSAy34rPGP7zBpE8d31/pVd7bzV
	 9E4LHDtQOKOIZxtfyvlcxth51x471TDSJdKKSlz/02ynD+0JWaKk7g4cus7MobeoOb
	 bx3FyjmlerqYpapcRikjWvfySZKd5sI6FJAhCm/ynHyjiXxIkGCYgw+86Bwl1Gynef
	 lPVzZGDHEq/VsNyMB0ubc9CRyDM3ZCu7pv4KCIoHz5bfUa61xX67Ptjg8Kg5ZtDC2M
	 u4YLYjoF8sx+z0UMx5HNe7Elk/cuRHVfq1hwO2oSC+kAO8VU5nY65BU189N2EkXPNt
	 UVcOjMo+eKEYQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Prayas Patel <prayas.patel@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 26/36] scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs
Date: Wed, 11 Dec 2024 13:49:42 -0500
Message-ID: <20241211185028.3841047-26-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
Content-Transfer-Encoding: 8bit

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 711201a8b8334a397440ac0b859df0054e174bc9 ]

The driver, through the SAS transport, exposes a sysfs interface to
enable/disable PHYs in a controller/expander setup.  When multiple PHYs
are disabled and enabled in rapid succession, the persistent and current
config pages related to SAS IO unit/SAS Expander pages could get
corrupted.

Use separate memory for each config request.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 81 ++++++---------------------------
 2 files changed, 13 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 81bb408ce56d8..1e715fd65a7d4 100644
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
index f1ab76351bd81..2e6245bd4282e 100644
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
2.43.0

