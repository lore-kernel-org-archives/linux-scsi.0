From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 19/78] ncr5380: Cleanup bogus {request,
 release}_region() calls
Date: Sun, 03 Jan 2016 16:05:20 +1100
Message-ID: <20160103050506.071792341@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline;
 filename=ncr5380-cleanup-request_region-release_region
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Commit 8b801ead3d7a ("[ARM] rpc: update Acorn SCSI drivers to modern ecard
interfaces") neglected to remove a request_region() call in cumana_1.c.

Commit eda32612f7b2 ("[PATCH] give all LLDD driver a ->release method") in
history/history.git added some pointless release_region() calls in dtc.c,
pas16.c and t128.c.

Fix these issues.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/arm/cumana_1.c |    6 ------
 drivers/scsi/dtc.c          |    2 --
 drivers/scsi/pas16.c        |    2 --
 drivers/scsi/t128.c         |    2 --
 4 files changed, 12 deletions(-)

Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-01-03 16:03:22.000000000 +1100
@@ -245,12 +245,6 @@ static int cumanascsi1_probe(struct expa
         priv(host)->ctrl = 0;
         writeb(0, priv(host)->base + CTRL);
 
-	host->n_io_port = 255;
-	if (!(request_region(host->io_port, host->n_io_port, "CumanaSCSI-1"))) {
-		ret = -EBUSY;
-		goto out_unmap;
-	}
-
 	ret = request_irq(host->irq, cumanascsi_intr, 0,
 			  "CumanaSCSI-1", host);
 	if (ret) {
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:03:22.000000000 +1100
@@ -423,8 +423,6 @@ static int dtc_release(struct Scsi_Host
 	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
 	iounmap(hostdata->base);
 	return 0;
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-01-03 16:03:22.000000000 +1100
@@ -540,8 +540,6 @@ static int pas16_release(struct Scsi_Hos
 	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
 	return 0;
 }
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-01-03 16:03:03.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-01-03 16:03:22.000000000 +1100
@@ -255,8 +255,6 @@ static int t128_release(struct Scsi_Host
 	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
 	iounmap(hostdata->base);
 	return 0;
