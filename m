From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 53/77] ncr5380: Use shost_priv helper
Date: Tue, 22 Dec 2015 12:18:31 +1100
Message-ID: <20151222011752.395520807@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-use-shost_priv
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Make use of the shost_priv() helper. Remove HOSTDATA and SETUP_HOSTDATA
macros because they harm readability.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   23 ++++++++++-------------
 drivers/scsi/atari_NCR5380.c |   20 +++++++-------------
 2 files changed, 17 insertions(+), 26 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:51.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:53.000000000 +1100
@@ -464,7 +464,7 @@ static irqreturn_t __init probe_intr(int
 static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 						int possible)
 {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long timeout;
 	int trying_irqs, i, mask;
 
@@ -586,9 +586,7 @@ static int __maybe_unused NCR5380_write_
 static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 	struct Scsi_Host *instance)
 {
-	struct NCR5380_hostdata *hostdata;
-
-	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
@@ -614,8 +612,8 @@ static int __maybe_unused NCR5380_show_i
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	unsigned long deadline;
 
 	if(in_interrupt())
@@ -728,7 +726,7 @@ static int NCR5380_maybe_reset_bus(struc
 
 static void NCR5380_exit(struct Scsi_Host *instance)
 {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	cancel_work_sync(&hostdata->main_task);
 	destroy_workqueue(hostdata->work_q);
@@ -1037,7 +1035,7 @@ static irqreturn_t NCR5380_intr(int irq,
  
 static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char tmp[3], phase;
 	unsigned char *data;
 	int len;
@@ -1511,7 +1509,7 @@ static int NCR5380_transfer_dma(struct S
 	unsigned char saved_data = 0, overrun = 0, residue;
 #endif
 
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
@@ -1743,7 +1741,7 @@ static int NCR5380_transfer_dma(struct S
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance) {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
@@ -2090,8 +2088,7 @@ static void NCR5380_information_transfer
  */
 
 static void NCR5380_reselect(struct Scsi_Host *instance) {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)
-	 instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
 	unsigned char lun, phase;
 	int len;
@@ -2214,7 +2211,7 @@ static void NCR5380_reselect(struct Scsi
 
 #ifdef REAL_DMA
 static void NCR5380_dma_complete(NCR5380_instance * instance) {
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transferred;
 
 	/*
@@ -2268,7 +2265,7 @@ static void NCR5380_dma_complete(NCR5380
 static int NCR5380_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct scsi_cmnd *tmp, **prev;
 	unsigned long flags;
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:51.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:53.000000000 +1100
@@ -196,12 +196,6 @@
  * possible) function may be used.
  */
 
-/* Macros ease life... :-) */
-#define	SETUP_HOSTDATA(in)				\
-    struct NCR5380_hostdata *hostdata =			\
-	(struct NCR5380_hostdata *)(in)->hostdata
-#define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
-
 #define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
 #define	SET_NEXT(cmd,next)	((cmd)->host_scribble = (void *)(next))
 #define	NEXTADDR(cmd)		((struct scsi_cmnd **)&(cmd)->host_scribble)
@@ -672,8 +666,8 @@ static void prepare_info(struct Scsi_Hos
 
 static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
-	SETUP_HOSTDATA(instance);
 	unsigned long deadline;
 
 	hostdata->host = instance;
@@ -1038,7 +1032,7 @@ static void NCR5380_main(struct work_str
 
 static void NCR5380_dma_complete(struct Scsi_Host *instance)
 {
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transferred;
 	unsigned char **data;
 	volatile int *count;
@@ -1248,7 +1242,7 @@ static irqreturn_t NCR5380_intr(int irq,
 
 static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char tmp[3], phase;
 	unsigned char *data;
 	int len;
@@ -1742,7 +1736,7 @@ static int NCR5380_transfer_dma(struct S
 				unsigned char *phase, int *count,
 				unsigned char **data)
 {
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	register int c = *count;
 	register unsigned char p = *phase;
 
@@ -1850,7 +1844,7 @@ static int NCR5380_transfer_dma(struct S
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
 {
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
@@ -2314,7 +2308,7 @@ static void NCR5380_information_transfer
 
 static void NCR5380_reselect(struct Scsi_Host *instance)
 {
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
 	unsigned char lun;
 #ifdef SUPPORT_TAGS
@@ -2521,7 +2515,7 @@ static
 int NCR5380_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
-	SETUP_HOSTDATA(instance);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct scsi_cmnd *tmp, **prev;
 	unsigned long flags;
 
