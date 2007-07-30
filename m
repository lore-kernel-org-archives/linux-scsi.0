From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 18/23] advansys: Stop using n_io_port in Scsi_Host structure
Date: Mon, 30 Jul 2007 10:57:03 -0600
Message-ID: <11858146281160-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx> <11858146283924-git-send-email-matthew@wil.cx> <1185814628436-git-send-email-matthew@wil.cx> <11858146281677-git-send-email-matthew@wil.cx> <11858146282603-git-send-email-matthew@wil.cx> <11858146281750-git-send-email-matthew@wil.cx> <11858146282891-git-send-email-matthew@wil.cx> <11858146284113-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:47055 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936900AbXG3Q5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:12 -0400
In-Reply-To: <11858146284113-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

n_io_port isn't suitable for advansys because some of the boards have
more than 255 bytes of io port space.  There's already a driver-private
replacement, asc_n_io_port, but for some reason the driver was still
setting and occasionally reporting n_io_port.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   38 ++++++++------------------------------
 1 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2f37076..e79f795 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2289,10 +2289,8 @@ typedef struct adveep_38C1600_config {
 #define BIOS_CTRL_AIPP_DIS           0x2000
 
 #define ADV_3550_MEMSIZE   0x2000	/* 8 KB Internal Memory */
-#define ADV_3550_IOLEN     0x40	/* I/O Port Range in bytes */
 
 #define ADV_38C0800_MEMSIZE  0x4000	/* 16 KB Internal Memory */
-#define ADV_38C0800_IOLEN    0x100	/* I/O Port Range in bytes */
 
 /*
  * XXX - Since ASC38C1600 Rev.3 has a local RAM failure issue, there is
@@ -2302,8 +2300,6 @@ typedef struct adveep_38C1600_config {
  * #define ADV_38C1600_MEMSIZE  0x8000L   * 32 KB Internal Memory *
  */
 #define ADV_38C1600_MEMSIZE  0x4000	/* 16 KB Internal Memory */
-#define ADV_38C1600_IOLEN    0x100	/* I/O Port Range 256 bytes */
-#define ADV_38C1600_MEMLEN   0x1000	/* Memory Range 4KB bytes */
 
 /*
  * Byte I/O register address from base of 'iop_base'.
@@ -3952,7 +3948,6 @@ static const char *advansys_info(struct Scsi_Host *shost)
 	ASC_DVC_VAR *asc_dvc_varp;
 	ADV_DVC_VAR *adv_dvc_varp;
 	char *busname;
-	int iolen;
 	char *widename = NULL;
 
 	boardp = ASC_BOARDP(shost);
@@ -3966,13 +3961,12 @@ static const char *advansys_info(struct Scsi_Host *shost)
 			} else {
 				busname = "ISA";
 			}
-			/* Don't reference 'shost->n_io_port'; It may be truncated. */
 			sprintf(info,
 				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X, DMA 0x%X",
 				ASC_VERSION, busname,
 				(ulong)shost->io_port,
-				(ulong)shost->io_port + boardp->asc_n_io_port -
-				1, shost->irq, shost->dma_channel);
+				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
+				shost->irq, shost->dma_channel);
 		} else {
 			if (asc_dvc_varp->bus_type & ASC_IS_VL) {
 				busname = "VL";
@@ -3991,12 +3985,11 @@ static const char *advansys_info(struct Scsi_Host *shost)
 					   "bus type %d\n", boardp->id,
 					   asc_dvc_varp->bus_type);
 			}
-			/* Don't reference 'shost->n_io_port'; It may be truncated. */
 			sprintf(info,
 				"AdvanSys SCSI %s: %s: IO 0x%lX-0x%lX, IRQ 0x%X",
 				ASC_VERSION, busname, (ulong)shost->io_port,
-				(ulong)shost->io_port + boardp->asc_n_io_port -
-				1, shost->irq);
+				(ulong)shost->io_port + ASC_IOADR_GAP - 1,
+				shost->irq);
 		}
 	} else {
 		/*
@@ -4008,19 +4001,16 @@ static const char *advansys_info(struct Scsi_Host *shost)
 		 */
 		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
 		if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
-			iolen = ADV_3550_IOLEN;
 			widename = "Ultra-Wide";
 		} else if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800) {
-			iolen = ADV_38C0800_IOLEN;
 			widename = "Ultra2-Wide";
 		} else {
-			iolen = ADV_38C1600_IOLEN;
 			widename = "Ultra3-Wide";
 		}
 		sprintf(info,
 			"AdvanSys SCSI %s: PCI %s: PCIMEM 0x%lX-0x%lX, IRQ 0x%X",
 			ASC_VERSION, widename, (ulong)adv_dvc_varp->iop_base,
-			(ulong)adv_dvc_varp->iop_base + iolen - 1, shost->irq);
+			(ulong)adv_dvc_varp->iop_base + boardp->asc_n_io_port - 1, shost->irq);
 	}
 	ASC_ASSERT(strlen(info) < ASC_INFO_SIZE);
 	ASC_DBG(1, "advansys_info: end\n");
@@ -6700,10 +6690,7 @@ static int asc_prt_driver_conf(struct Scsi_Host *shost, char *cp, int cplen)
 			   boardp->asc_n_io_port);
 	ASC_PRT_NEXT();
 
-	/* 'shost->n_io_port' may be truncated because it is only one byte. */
-	len = asc_prt_line(cp, leftlen,
-			   " io_port 0x%x, n_io_port 0x%x\n",
-			   shost->io_port, shost->n_io_port);
+	len = asc_prt_line(cp, leftlen, " io_port 0x%x\n", shost->io_port);
 	ASC_PRT_NEXT();
 
 	if (ASC_NARROW_BOARD(boardp)) {
@@ -7595,8 +7582,8 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	printk(" host_busy %u, host_no %d, last_reset %d,\n",
 	       s->host_busy, s->host_no, (unsigned)s->last_reset);
 
-	printk(" base 0x%lx, io_port 0x%lx, n_io_port %u, irq 0x%x,\n",
-	       (ulong)s->base, (ulong)s->io_port, s->n_io_port, s->irq);
+	printk(" base 0x%lx, io_port 0x%lx, irq 0x%x,\n",
+	       (ulong)s->base, (ulong)s->io_port, s->irq);
 
 	printk(" dma_channel %d, this_id %d, can_queue %d,\n",
 	       s->dma_channel, s->this_id, s->can_queue);
@@ -17537,15 +17524,6 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	}
 
 	/*
-	 * 'n_io_port' currently is one byte.
-	 *
-	 * Set a value to 'n_io_port', but never referenced it because
-	 * it may be truncated.
-	 */
-	shost->n_io_port = boardp->asc_n_io_port <= 255 ?
-	    boardp->asc_n_io_port : 255;
-
-	/*
 	 * Following v1.3.89, 'cmd_per_lun' is no longer needed
 	 * and should be set to zero.
 	 *
-- 
1.4.4.4

