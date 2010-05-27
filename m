From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/24] hpsa: fix leak of ioremapped memory
Date: Thu, 27 May 2010 15:13:22 -0500
Message-ID: <20100527201322.3116.86053.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:5364 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab0E0UIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:43 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix leak of ioremapped memory
in hpsa_pci_init error path.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3ed0fd7..3745047 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3387,7 +3387,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	if (err)
 		goto err_out_free_res;
 	h->vaddr = remap_pci_mem(h->paddr, 0x250);
-
+	if (!h->vaddr) {
+		err = -ENOMEM;
+		goto err_out_free_res;
+	}
 	err = hpsa_wait_for_board_ready(h);
 	if (err)
 		goto err_out_free_res;
@@ -3474,6 +3477,12 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	return 0;
 
 err_out_free_res:
+	if (h->transtable)
+		iounmap(h->transtable);
+	if (h->cfgtable)
+		iounmap(h->cfgtable);
+	if (h->vaddr)
+		iounmap(h->vaddr);
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
@@ -3692,6 +3701,8 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 	hpsa_shutdown(pdev);
 	iounmap(h->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
 	hpsa_free_sg_chain_blocks(h);
 	pci_free_consistent(h->pdev,
 		h->nr_cmds * sizeof(struct CommandList),

