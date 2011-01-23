From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 2/3] libata: fix locking for sas paths
Date: Sun, 23 Jan 2011 08:30:00 -0600
Message-ID: <1295793000.3007.16.camel@mulgrave.site>
References: <1295792806.3007.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1AWOaE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:30:04 -0500
In-Reply-To: <1295792806.3007.12.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>

For historical reasons, libsas uses the scsi host lock as the ata port
lock, and libata always uses the ata host.  For the old eh, this was
largely irrelevant since the two locks were never mixed inside the
code.  However, the new eh has a case where it nests acquisition of
the host lock inside the port lock (this does look rather deadlock
prone).  Obviously this would be an instant deadlock if the port lock
were the host lock, so switch the libsas paths to use the ata host
lock as well.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8970667..b935f3a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3747,7 +3747,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 		return NULL;
 
 	ap->port_no = 0;
-	ap->lock = shost->host_lock;
+	ap->lock = &host->lock;
 	ap->pio_mask = port_info->pio_mask;
 	ap->mwdma_mask = port_info->mwdma_mask;
 	ap->udma_mask = port_info->udma_mask;
-- 
1.7.2.3



