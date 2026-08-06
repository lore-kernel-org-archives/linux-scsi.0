Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A2E4D2ECC;
	Thu,  6 Aug 2026 19:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044267; cv=pass; b=s2W6f1EsSpYF2AEIf7hiQxX2oy5YnMYLUEtgTtWMcnRNIPe2KNQZKoFQHEkzijkWcl27LSw36z/Lun+zQu0uj4je4+A0+ybuzJG+x/PJV/iV8eCG5wYLM8Zht4aw+61KG9Pze8F+ojmzUSVeBrOTOS8per5p9/1zn93L1nV+Qhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044267; c=relaxed/simple;
	bh=lfnjD86EbQDLQcLvbO79G/C1EoI4gKr2Au25BGtobio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu17UGZqq8TikGuJYH3K/h7CULmBglAGbZ5/CSylEygTSZjb89LYDBPG6mlZot9NR+4UlCmV9eDSX3q4Vh+A4UAJ8WM97D0fq7UTCgvyrgMgdICjgNxFkeQq9m4UK3AdhASBeToJlBKHBqQGzT7biV91wi6XkNL7+MSm9LXiRbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=nUMdlA9e; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="nUMdlA9e"
ARC-Seal: i=1; a=rsa-sha256; t=1786044245; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=cgO3Y87ujQhsGiAIQwcv2sSNj6Ym20RL+XQetGCPqd5CiIwobL5ECVYbZEkvsDiFJatzQu1Y5SNUY/ERFIBTT2ZAMSUzfePxn8P/bq3ziu1p0qG/bbIEuBK5yI2fRamKQmmNIPKNAShe4zKd+0M1Ld0/xSRzJKGpFPjO+AznZFY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044245; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=8B3CIgkL3b4Ph6zdSr6uHE4ZnrtlHzQtDq/MLv5BOY0=; 
	b=hv3DSYcBkvaAiXAHLq8mGk/ktuMlYx1ReAd+II6t/3dXSngmNyw/MVGYYB6DN1Wm6R1Fm5vxLc36K8kfgWLD++R1hiVittQaSnB485vJzfy543/7/STE7vATN9jM03vdSjIvXTRWg3EmUomUR+pZd9G1BezWV6IsRIq86NnER2I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044245;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=8B3CIgkL3b4Ph6zdSr6uHE4ZnrtlHzQtDq/MLv5BOY0=;
	b=nUMdlA9enbfmygXi6bXld5LX/yrxIPhbx9Q+hCmt1kZqDX65BBBcu8gM1uDzty1n
	2UQHhq1xpWIu1PWlNJL1OF8eKMzwr8hdwo/6PQQNh0yevXl9H/F9hOEG6j7Wl2Mk5JD
	o8U4b1ML4K6CK8Axob6VbetVNf/JlSF61GDrgjNc=
Received: by mx.zoho.eu with SMTPS id 1786044242652183.80503244895579;
	Thu, 6 Aug 2026 21:24:02 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] scsi: elx: efct: destroy the mailbox pools when setup fails
Date: Thu,  6 Aug 2026 19:23:45 +0000
Message-ID: <20260806192345.328621-6-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_hw_setup() creates two mempools and then calls sli_setup(). Both of
its error paths return without destroying what it already created:

	hw->cmd_ctx_pool = mempool_create_kmalloc_pool(...);
	if (!hw->cmd_ctx_pool)
		return -EIO;

	hw->mbox_rqst_pool = mempool_create_kmalloc_pool(...);
	if (!hw->mbox_rqst_pool)
		return -EIO;
	...
	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct *)os)->reg))
		return -EIO;

mempool_destroy() for these two runs only in efct_hw_teardown(), which is
not reached here. efct_hw_setup() is called from
efct_device_interrupts_required(), and when it fails efct_pci_probe()
unwinds through efct_device_free(), freeing the struct efct that held the
only pointers to the pools.

Destroy them on the way out, and clear hw_setup_called so that a later
call does not take the early return and hand the caller a half configured
hw.

Reproduced by binding the driver to a PCI device that is not an SLI-4
adapter, so sli_setup() fails, and repeating the probe 61 times. Before,
with CONFIG_DEBUG_KMEMLEAK:

  unreferenced object 0xffff888008449680 (size 96):
    comm "init", pid 1
    backtrace:
      __kmalloc_cache_node_noprof+0x3b9/0x430
      mempool_create_node_noprof+0x78/0xe0
      efct_hw_setup+0x1db/0xb50
      efct_pci_probe+0x3cb/0x6dd
      local_pci_probe+0xd4/0x170

1566 objects in total, every one of them from efct_hw_setup(). After the
change the same run reports none, and the probe still fails the same way.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index d645ce256b8a..efbf29d3386e 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -264,7 +264,7 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 					sizeof(struct efct_mbox_rqst_ctx));
 	if (!hw->mbox_rqst_pool) {
 		efc_log_err(hw->os, "failed to allocate mbox request pool\n");
-		return -EIO;
+		goto free_cmd_ctx_pool;
 	}
 
 	spin_lock_init(&hw->io_lock);
@@ -277,7 +277,7 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 	hw->config.speed = SLI4_LINK_SPEED_AUTO_16_8_4;
 	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct *)os)->reg)) {
 		efc_log_err(hw->os, "SLI setup failed\n");
-		return -EIO;
+		goto free_mbox_rqst_pool;
 	}
 
 	efct_hw_link_event_init(hw);
@@ -313,6 +313,16 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 	(void)efct_hw_read_max_dump_size(hw);
 
 	return 0;
+
+free_mbox_rqst_pool:
+	mempool_destroy(hw->mbox_rqst_pool);
+	hw->mbox_rqst_pool = NULL;
+free_cmd_ctx_pool:
+	mempool_destroy(hw->cmd_ctx_pool);
+	hw->cmd_ctx_pool = NULL;
+	hw->hw_setup_called = false;
+
+	return -EIO;
 }
 
 static void
-- 
2.55.0

