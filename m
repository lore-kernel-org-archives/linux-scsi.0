Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D740759D;
	Thu,  6 Aug 2026 21:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050432; cv=pass; b=eqCkd7SGHUZJrEtkE6W75RCV/i6dQRN1fr7w3LQKgTQWCGrxVQ9RF5E/9ECZAUXHlJMEC9s07MbxDXbQzYZQQ86BB8galbniHA59p5CjXopv3OgHXDodkB8PMW7X8g0QLdcSbKlNmGubeUWf5zO25leNCwoagBQXu2DRaOs0rRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050432; c=relaxed/simple;
	bh=iMtKZ68a+ubbhwo0q4OKtISspanP36uJpzOhDWZ0tnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGMboPqcGo4Z3ouVC05oVqtl2mF/pR8p5d8oK43w6pz4axqGu+Q3TP0h1XatWfqEzpqlw6oCs9V7sdVrAsfn0V5uzaNVj09Z2rVFJHyNS4qE9+JepMqw/0txKQxqIhgjTstN/1QcClTpv0fgD3QpLsXvFT1VY7+QmYoqfIPWj9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=jZegdbSQ; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="jZegdbSQ"
ARC-Seal: i=1; a=rsa-sha256; t=1786050423; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=kr6rl66nBfI/k2e3JZOaIRmfEkDLJbCLBcy/0FG+eqYtcsOG17AeSeP3fyGSSNyYSFSWIduJqqRLB9lxt6N8rD059W2DbPN7K7ayqJ+kq4cTfiou44QpGHDhG//SX7Hfl/I1LV0fPwaCPUmVSOsgZFeeOR4VZNh9ZtY9qec+NKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786050423; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vE0KwVzJzVTLYOOEFhJrNRLlcegrQcNMrNQJEwIiqwY=; 
	b=AhWBdKl7usOu+2hApDcuKqlGQ68f9UUzRj8C86ErilYyhk2q+4+/7yp+UFAJsD7w8YyWXAIqxwSgsM0mnWsG8u4J8B2UCvd+UX+5g5BTdEkNAfzJx+5g2ihLc1RU1AHYXVXbv5CTg7r2jB0Tg6pIe4PZTZ+LhXNinWQFocF57+w=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786050423;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vE0KwVzJzVTLYOOEFhJrNRLlcegrQcNMrNQJEwIiqwY=;
	b=jZegdbSQgQ2RbASWjy7ldfx+z79Jbow7KXRiid5IZnGhhJEtmw+V6bJZPAEn8O3o
	ICB+afpD+EDkyH7vKR5DJbqwLjYq0lMTzGl/6L4m9vYZgVo73Y9pJHs4CyQFYL8EowX
	r1U+/ztMmSuEQywOn+A6ScfzITPbArhN0eGzzieQ=
Received: by mx.zoho.eu with SMTPS id 1786050421801147.4987671240699;
	Thu, 6 Aug 2026 23:07:01 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: elx: efct: destroy the mailbox pools when setup fails
Date: Thu,  6 Aug 2026 21:06:27 +0000
Message-ID: <20260806210631.357456-3-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806210631.357456-1-ali@iusegentoo.com>
References: <20260806210631.357456-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_hw_setup() creates two mempools and then calls sli_setup(). Its error
paths return without destroying what it already created:

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
efct_device_interrupts_required() and from efct_xport_attach(). On the
probe path it is the first of those that runs, and when it fails
efct_pci_probe() unwinds through efct_device_free(), freeing the struct
efct that held the only pointers to the pools.

Destroy them on the way out, and clear hw_setup_called, which the function
sets before the first allocation, so that a later call does not take the
early return and hand the caller a half configured hw.

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
 drivers/scsi/elx/efct/efct_hw.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index cc600220168a..20f4821078aa 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -256,7 +256,7 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 					sizeof(struct efct_command_ctx));
 	if (!hw->cmd_ctx_pool) {
 		efc_log_err(hw->os, "failed to allocate mailbox buffer pool\n");
-		return -EIO;
+		goto not_setup;
 	}
 
 	/* Create mailbox request ctx pool for library callback */
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
@@ -313,6 +313,17 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 	(void)efct_hw_read_max_dump_size(hw);
 
 	return 0;
+
+free_mbox_rqst_pool:
+	mempool_destroy(hw->mbox_rqst_pool);
+	hw->mbox_rqst_pool = NULL;
+free_cmd_ctx_pool:
+	mempool_destroy(hw->cmd_ctx_pool);
+	hw->cmd_ctx_pool = NULL;
+not_setup:
+	hw->hw_setup_called = false;
+
+	return -EIO;
 }
 
 static void
-- 
2.55.0

