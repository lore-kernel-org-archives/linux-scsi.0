From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Bugfix 1/3] eata: Use IDA to manage eata board IDs
Date: Mon, 14 Sep 2015 11:08:57 +0800
Message-ID: <1442200140-30808-2-git-send-email-jiang.liu@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Use IDA to manage eata board IDs, so we could dynamically allocate
and free board IDs later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/scsi/eata.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c2ec2f..b45d3b532b70 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -491,6 +491,7 @@
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -837,9 +838,8 @@ struct hostdata {
 static struct Scsi_Host *sh[MAX_BOARDS];
 static const char *driver_name = "EATA";
 static char sha[MAX_BOARDS];
-
-/* Initialize num_boards so that ihdlr can work while detect is in progress */
-static unsigned int num_boards = MAX_BOARDS;
+static DEFINE_IDA(eata_ida);
+static DECLARE_BITMAP(eata_board_bitmap, MAX_BOARDS);
 
 static unsigned long io_port[] = {
 
@@ -1509,6 +1509,23 @@ static int option_setup(char *str)
 	return 1;
 }
 
+static unsigned int port_probe(unsigned long port_base,
+			       struct scsi_host_template *tpnt)
+{
+	int id;
+
+	id = ida_simple_get(&eata_ida, 0, MAX_BOARDS, GFP_KERNEL);
+	if (id >= 0) {
+		set_bit(id, eata_board_bitmap);
+		if (port_detect(port_base, id, tpnt))
+			return id;
+		clear_bit(id, eata_board_bitmap);
+		ida_simple_remove(&eata_ida, id);
+	}
+
+	return -1;
+}
+
 static void add_pci_ports(void)
 {
 #if defined(CONFIG_PCI)
@@ -1548,7 +1565,7 @@ static void add_pci_ports(void)
 
 static int eata2x_detect(struct scsi_host_template *tpnt)
 {
-	unsigned int j = 0, k;
+	unsigned int k, count = 0;
 
 	tpnt->proc_name = "eata2x";
 
@@ -1582,17 +1599,12 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 			enable_pci_ports();
 	}
 
-	for (k = 0; io_port[k]; k++) {
+	for (k = 0; io_port[k]; k++)
+		if (io_port[k] != SKIP &&
+		    port_probe(io_port[k], tpnt) >= 0)
+			count++;
 
-		if (io_port[k] == SKIP)
-			continue;
-
-		if (j < MAX_BOARDS && port_detect(io_port[k], j, tpnt))
-			j++;
-	}
-
-	num_boards = j;
-	return j;
+	return count;
 }
 
 static void map_dma(unsigned int i, struct hostdata *ha)
@@ -2530,14 +2542,16 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 static irqreturn_t do_interrupt_handler(int dummy, void *shap)
 {
 	struct Scsi_Host *shost;
-	unsigned int j;
+	unsigned int j = (unsigned int)((char *)shap - sha);
 	unsigned long spin_flags;
 	irqreturn_t ret;
 
 	/* Check if the interrupt must be processed by this handler */
-	if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
+	if (j >= MAX_BOARDS || !test_bit(j, eata_board_bitmap))
 		return IRQ_NONE;
 	shost = sh[j];
+	if (!shost)
+		return IRQ_NONE;
 
 	spin_lock_irqsave(shost->host_lock, spin_flags);
 	ret = ihdlr(shost);
-- 
1.7.10.4
