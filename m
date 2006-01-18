From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] unbreak ecoscsi
Date: Thu, 19 Jan 2006 00:04:26 +0300
Message-ID: <20060118210426.GK12771@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.199]:38997 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030433AbWARUrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 15:47:05 -0500
Received: by uproxy.gmail.com with SMTP id s2so40397uge
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 12:47:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/arm/ecoscsi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/scsi/arm/ecoscsi.c
+++ b/drivers/scsi/arm/ecoscsi.c
@@ -175,7 +175,7 @@ static struct Scsi_Host *host;
 static int __init ecoscsi_init(void)
 {
 
-	host = scsi_host_alloc(tpnt, sizeof(struct NCR5380_hostdata));
+	host = scsi_host_alloc(&ecoscsi_template, sizeof(struct NCR5380_hostdata));
 	if (!host)
 		return 0;
 
@@ -218,14 +218,13 @@ static void __exit ecoscsi_exit(void)
 {
 	scsi_remove_host(host);
 
-	if (shpnt->irq != IRQ_NONE)
-		free_irq(shpnt->irq, NULL);
+	if (host->irq != IRQ_NONE)
+		free_irq(host->irq, NULL);
 	NCR5380_exit(host);
-	if (shpnt->io_port)
-		release_region(shpnt->io_port, shpnt->n_io_port);
+	if (host->io_port)
+		release_region(host->io_port, host->n_io_port);
 
 	scsi_host_put(host);
-	return 0;
 }
 
 module_init(ecoscsi_init);

