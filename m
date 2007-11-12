From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI: Fix bugs and canonicalize irq handler usage in NCR5380 drivers
Date: Sun, 11 Nov 2007 19:52:05 -0500 (EST)
Message-ID: <20071112005205.BC5F71F81F5@havoc.gtf.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:53803 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXKLAwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Nov 2007 19:52:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

* Always pass the same value to free_irq() that we pass to
  request_irq().  This fixes several bugs.

* Always call NCR5380_intr() with 'irq' and 'dev_id' arguments.

  Note, scsi_falcon_intr() is the only case now where dev_id is not the
  scsi_host.

* Always pass Scsi_Host to request_irq().  For most cases, the drivers
  already did so, and I merely neated the source code line.  In other
  cases, either NULL or a non-sensical value was passed, verified to be
  unused, then changed to be Scsi_Host in anticipation of the future.

In addition to the bugs fixes, this change makes the interface usage
consistent, which in turn enables the possibility of directly
referencing Scsi_Host from all NCR5380_intr() invocations.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Resend #1.  Originally sent on Oct 26.

Please send upstream for 2.6.24-rc in some form, this fixes obvious
free_irq() problems that prevent irq release.


 drivers/scsi/atari_scsi.c    |   10 +++++-----
 drivers/scsi/dtc.c           |    5 +++--
 drivers/scsi/g_NCR5380.c     |    5 +++--
 drivers/scsi/mac_scsi.c      |    4 ++--
 drivers/scsi/pas16.c         |    5 +++--
 drivers/scsi/sun3_scsi.c     |    4 ++--
 drivers/scsi/sun3_scsi_vme.c |    4 ++--
 drivers/scsi/t128.c          |    5 +++--
 8 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 6f8403b..f5732d8 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -393,7 +393,7 @@ static irqreturn_t scsi_tt_intr(int irq, void *dummy)
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 
 #if 0
 	/* To be sure the int is not masked */
@@ -458,7 +458,7 @@ static irqreturn_t scsi_falcon_intr(int irq, void *dummy)
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 	return IRQ_HANDLED;
 }
 
@@ -684,7 +684,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 		 * interrupt after having cleared the pending flag for the DMA
 		 * interrupt. */
 		if (request_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr, IRQ_TYPE_SLOW,
-				 "SCSI NCR5380", scsi_tt_intr)) {
+				 "SCSI NCR5380", instance)) {
 			printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting",IRQ_TT_MFP_SCSI);
 			scsi_unregister(atari_scsi_host);
 			atari_stram_free(atari_dma_buffer);
@@ -701,7 +701,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 					 IRQ_TYPE_PRIO, "Hades DMA emulator",
 					 hades_dma_emulator)) {
 				printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting (MACH_IS_HADES)",IRQ_AUTO_2);
-				free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+				free_irq(IRQ_TT_MFP_SCSI, instance);
 				scsi_unregister(atari_scsi_host);
 				atari_stram_free(atari_dma_buffer);
 				atari_dma_buffer = 0;
@@ -761,7 +761,7 @@ int atari_scsi_detect(struct scsi_host_template *host)
 int atari_scsi_release(struct Scsi_Host *sh)
 {
 	if (IS_A_TT())
-		free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+		free_irq(IRQ_TT_MFP_SCSI, sh);
 	if (atari_dma_buffer)
 		atari_stram_free(atari_dma_buffer);
 	return 1;
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 2596165..c2677ba 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -277,7 +277,8 @@ found:
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED, "dtc", instance)) {
+			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED,
+					"dtc", instance)) {
 				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
@@ -459,7 +460,7 @@ static int dtc_release(struct Scsi_Host *shost)
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 607336f..75585a5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -460,7 +460,8 @@ int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, generic_NCR5380_intr, IRQF_DISABLED, "NCR5380", instance)) {
+			if (request_irq(instance->irq, generic_NCR5380_intr,
+					IRQF_DISABLED, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
@@ -513,7 +514,7 @@ int generic_NCR5380_release_resources(struct Scsi_Host *instance)
 	NCR5380_setup(instance);
 	
 	if (instance->irq != SCSI_IRQ_NONE)
-		free_irq(instance->irq, NULL);
+		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 
 #ifndef CONFIG_SCSI_G_NCR5380_MEM
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index abe2bda..81d1f3f 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -303,7 +303,7 @@ int macscsi_detect(struct scsi_host_template * tpnt)
 
     if (instance->irq != SCSI_IRQ_NONE)
 	if (request_irq(instance->irq, NCR5380_intr, IRQ_FLG_SLOW, 
-		"ncr5380", instance)) {
+			"ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
 	    instance->irq = SCSI_IRQ_NONE;
@@ -326,7 +326,7 @@ int macscsi_detect(struct scsi_host_template * tpnt)
 int macscsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NCR5380_intr);
+		free_irq (shpnt->irq, shpnt);
 	NCR5380_exit(shpnt);
 
 	return 0;
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index ee59656..f2018b4 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -453,7 +453,8 @@ int __init pas16_detect(struct scsi_host_template * tpnt)
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED, "pas16", instance)) {
+	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED,
+			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -604,7 +605,7 @@ static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src
 static int pas16_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 5e46d84..320b2a8 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -268,7 +268,7 @@ int sun3scsi_detect(struct scsi_host_template * tpnt)
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380", NULL)) {
+			     0, "Sun3SCSI-5380", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -310,7 +310,7 @@ int sun3scsi_detect(struct scsi_host_template * tpnt)
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq (shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 7cb4a31..5af057e 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -230,7 +230,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380VME", NULL)) {
+			0, "Sun3SCSI-5380VME", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -279,7 +279,7 @@ static int sun3scsi_detect(struct scsi_host_template * tpnt)
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq (shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 248d60b..371a325 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -259,7 +259,8 @@ found:
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128", instance)) {
+	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128",
+	    		    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -295,7 +296,7 @@ static int t128_release(struct Scsi_Host *shost)
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
-- 
1.5.3.3

