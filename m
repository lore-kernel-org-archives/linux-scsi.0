From: Loc Ho <lho@apm.com>
Subject: [PATCH] ata: Fix compiler warning with APM X-Gene host controller driver
Date: Tue, 18 Mar 2014 12:14:37 -0600
Message-ID: <1395166477-26408-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:52574 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757287AbaCRSOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 14:14:47 -0400
Received: by mail-pd0-f181.google.com with SMTP id p10so7387317pdj.26
        for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2014 11:14:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

This patch fixes an compiler warning with APM X-Gene host controller
driver when compiled with DEBUG enabled.

Signed-off-by: Loc Ho <lho@apm.com>
---
 drivers/ata/ahci_xgene.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index fcf21f1..77c89bf 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -329,7 +329,7 @@ static int xgene_ahci_hw_init(struct ahci_host_priv *hpriv)
 	writel(0xffffffff, hpriv->mmio + HOST_IRQ_STAT);
 	readl(hpriv->mmio + HOST_IRQ_STAT); /* Force a barrier */
 	writel(0, ctx->csr_core + INTSTATUSMASK);
-	readl(ctx->csr_core + INTSTATUSMASK); /* Force a barrier */
+	val = readl(ctx->csr_core + INTSTATUSMASK); /* Force a barrier */
 	dev_dbg(ctx->dev, "top level interrupt mask 0x%X value 0x%08X\n",
 		INTSTATUSMASK, val);
 
-- 
1.5.5

