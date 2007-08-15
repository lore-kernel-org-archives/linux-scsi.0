From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] ibmmca: Stop leaking scsi_hosts on exit
Date: Wed, 15 Aug 2007 12:56:58 -0600
Message-ID: <1187204221432-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
 <11872042211224-git-send-email-matthew@wil.cx>
 <11872042212630-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45787 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761485AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <11872042212630-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

There was a missing call to scsi_host_put() causing us to leak a scsi
host every time this module was unloaded.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/ibmmca.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4275d1b..82f116a 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1693,6 +1693,7 @@ static int __devexit ibmmca_remove(struct device *dev)
 	scsi_remove_host(shpnt);
 	release_region(shpnt->io_port, shpnt->n_io_port);
 	free_irq(shpnt->irq, dev);
+	scsi_host_put(shpnt);
 	return 0;
 }
 
-- 
1.5.2.4

