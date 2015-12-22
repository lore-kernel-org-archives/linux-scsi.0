From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 66/77] ncr5380: Fix soft lockups
Date: Tue, 22 Dec 2015 12:18:44 +1100
Message-ID: <20151222011755.965510468@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-max_sectors
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Because of the rudimentary design of the chip, it is necessary to poll the
SCSI bus signals during PIO and this tends to hog the CPU. The driver will
accept new commands while others execute, and this causes a soft lockup
because the workqueue item will not terminate until the issue queue is
emptied.

When exercising dmx3191d using sequential IO from dd, the driver is sent
512 KiB WRITE commands and 128 KiB READs. For a PIO transfer, the rate is
is only about 300 KiB/s, so these are long-running commands. And although
PDMA may run at several MiB/s, interrupts are disabled for the duration
of the transfer.

Fix the unresponsiveness and soft lockup issues by calling cond_resched()
after each command is completed and by limiting max_sectors for drivers
that don't implement real DMA.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changed since v2:
- Moved max_sectors initialization to wrapper drivers. It isn't really
  relevant to the core driver and compile-time configuration using macros
  like REAL_DMA should be avoided.

---
 drivers/scsi/NCR5380.c       |    6 ++++--
 drivers/scsi/arm/cumana_1.c  |    1 +
 drivers/scsi/arm/oak.c       |    1 +
 drivers/scsi/atari_NCR5380.c |    6 ++++--
 drivers/scsi/dmx3191d.c      |    1 +
 drivers/scsi/dtc.c           |    1 +
 drivers/scsi/g_NCR5380.c     |    1 +
 drivers/scsi/mac_scsi.c      |    1 +
 drivers/scsi/pas16.c         |    1 +
 drivers/scsi/t128.c          |    1 +
 10 files changed, 16 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:17:12.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:17:15.000000000 +1100
@@ -890,10 +890,10 @@ static void NCR5380_main(struct work_str
 	struct scsi_cmnd *cmd;
 	int done;
 	
-	spin_lock_irq(&hostdata->lock);
 	do {
 		done = 1;
 
+		spin_lock_irq(&hostdata->lock);
 		while (!hostdata->connected &&
 		       (cmd = dequeue_next_cmd(instance))) {
 
@@ -930,8 +930,10 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		spin_unlock_irq(&hostdata->lock);
+		if (!done)
+			cond_resched();
 	} while (!done);
-	spin_unlock_irq(&hostdata->lock);
 }
 
 #ifndef DONT_USE_INTR
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:14.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:15.000000000 +1100
@@ -976,10 +976,10 @@ static void NCR5380_main(struct work_str
 	 * alter queues and touch the Falcon lock.
 	 */
 
-	spin_lock_irq(&hostdata->lock);
 	do {
 		done = 1;
 
+		spin_lock_irq(&hostdata->lock);
 		while (!hostdata->connected &&
 		       (cmd = dequeue_next_cmd(instance))) {
 
@@ -1026,8 +1026,10 @@ static void NCR5380_main(struct work_str
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
+		spin_unlock_irq(&hostdata->lock);
+		if (!done)
+			cond_resched();
 	} while (!done);
-	spin_unlock_irq(&hostdata->lock);
 }
 
 
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2015-12-22 12:17:15.000000000 +1100
@@ -209,6 +209,7 @@ static struct scsi_host_template cumanas
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "CumanaSCSI-1",
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 
 static int cumanascsi1_probe(struct expansion_card *ec,
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2015-12-22 12:17:15.000000000 +1100
@@ -115,6 +115,7 @@ static struct scsi_host_template oakscsi
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "oakscsi",
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 
 static int oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-12-22 12:17:15.000000000 +1100
@@ -62,6 +62,7 @@ static struct scsi_host_template dmx3191
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 
 static int dmx3191d_probe_one(struct pci_dev *pdev,
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-12-22 12:17:15.000000000 +1100
@@ -453,5 +453,6 @@ static struct scsi_host_template driver_
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 #include "scsi_module.c"
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:15.000000000 +1100
@@ -729,6 +729,7 @@ static struct scsi_host_template driver_
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 
 #include "scsi_module.c"
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2015-12-22 12:17:15.000000000 +1100
@@ -324,6 +324,7 @@ static struct scsi_host_template mac_scs
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 
 static int __init mac_scsi_probe(struct platform_device *pdev)
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-12-22 12:17:15.000000000 +1100
@@ -563,6 +563,7 @@ static struct scsi_host_template driver_
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 #include "scsi_module.c"
 
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-12-22 12:17:15.000000000 +1100
@@ -407,5 +407,6 @@ static struct scsi_host_template driver_
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
+	.max_sectors		= 128,
 };
 #include "scsi_module.c"
