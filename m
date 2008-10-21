From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/22] sata_inic162x: kill PORT_PRD_ADDR initialization
Date: Tue, 21 Oct 2008 18:17:45 +0900
Message-ID: <1224580680-13698-8-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYJUJUf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:35 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

sata_inic162x doesn't use PRD anymore.  No need to initialize it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/sata_inic162x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 9dd7559..e87349d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -667,8 +667,7 @@ static void init_port(struct ata_port *ap)
 	memset(pp->pkt, 0, sizeof(struct inic_pkt));
 	memset(pp->cpb_tbl, 0, IDMA_CPB_TBL_SIZE);
 
-	/* setup PRD and CPB lookup table addresses */
-	writel(ap->prd_dma, port_base + PORT_PRD_ADDR);
+	/* setup CPB lookup table addresses */
 	writel(pp->cpb_tbl_dma, port_base + PORT_CPB_CPBLAR);
 }
 
-- 
1.5.4.5

