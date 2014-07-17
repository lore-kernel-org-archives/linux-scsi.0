From: Mark Salter <msalter@redhat.com>
Subject: [PATCH] ahci_xgene: add errata workaround for ATA_CMD_SMART
Date: Thu, 17 Jul 2014 13:38:31 -0400
Message-ID: <1405618711.25580.120.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaGQRif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2014 13:38:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stripathi@apm.com
Cc: lho@apm.com, Jon Masters <jcm@redhat.com>, linux-scsi@vger.kernel.org

commit 2a0bdff6b958d1b2:

 ahci_xgene: fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command.

added a workaround for X-Gene AHCI controller errata. This was done
for all ATA_CMD_ID_ATA commands. The errata also appears to affect
ATA_CMD_SMART commands as well. This was discovered when running
smartd or just smartctl -x. This patch adds a dma engine restart for
ATA_CMD_SMART commands which clears up the issues seen with smartd.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/ata/ahci_xgene.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index ee3a365..f9431b4 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -131,7 +131,8 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	struct xgene_ahci_context *ctx = hpriv->plat_data;
 	int rc = 0;
 
-	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
+	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA ||
+		     ctx->last_cmd[ap->port_no] == ATA_CMD_SMART))
 		xgene_ahci_restart_engine(ap);
 
 	rc = ahci_qc_issue(qc);
-- 
1.8.3.1



