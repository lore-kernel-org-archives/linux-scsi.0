From: akpm@linux-foundation.org
Subject: [patch 15/23] SCSI: fix bugs and canonicalize NCR5380_intr drivers
Date: Wed, 21 Nov 2007 15:12:27 -0800
Message-ID: <200711212312.lALNCRSx014148@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872AbXKUXRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:17:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com

From: Jeff Garzik <jeff@garzik.org>

* Bug fix:  Make sure request_irq() and free_irq() are called
  with the same dev_id pointer argument.

* Bug fix:  always pass 'irq' and 'dev_id' (aka 'dummy')
  arguments to NCE5380_intr() when calling it manully.  For some drivers
  this doesn't matter, depending on whose copy of NCR5380_intr() is
  being used.

* Bug fix:  always pass Scsi_Host* to NCR5380_intr().  Most
  get this right, but some pass NULL or some other random/ignored
  value.  For some drivers this doesn't matter, depending on whose copy
  of NCR5380_intr() is being used.

* Wrap long request_irq() lines

[akpm@linux-foundation.org: coding style fixes]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/atari_scsi.c    |   10 +++++-----
 drivers/scsi/dtc.c           |    5 +++--
 drivers/scsi/g_NCR5380.c     |    5 +++--
 drivers/scsi/mac_scsi.c      |    4 ++--
 drivers/scsi/pas16.c         |    5 +++--
 drivers/scsi/sun3_scsi.c     |    4 ++--
 drivers/scsi/sun3_scsi_vme.c |    4 ++--
 drivers/scsi/t128.c          |    5 +++--
 8 files changed, 23 insertions(+), 19 deletions(-)

diff -puN drivers/scsi/atari_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/atari_scsi.c
--- a/drivers/scsi/atari_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/atari_scsi.c
@@ -393,7 +393,7 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 
 #if 0
 	/* To be sure the int is not masked */
@@ -458,7 +458,7 @@ static irqreturn_t scsi_falcon_intr(int 
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(0, 0);
+	NCR5380_intr(irq, dummy);
 	return IRQ_HANDLED;
 }
 
@@ -684,7 +684,7 @@ int atari_scsi_detect(struct scsi_host_t
 		 * interrupt after having cleared the pending flag for the DMA
 		 * interrupt. */
 		if (request_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr, IRQ_TYPE_SLOW,
-				 "SCSI NCR5380", scsi_tt_intr)) {
+				 "SCSI NCR5380", instance)) {
 			printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting",IRQ_TT_MFP_SCSI);
 			scsi_unregister(atari_scsi_host);
 			atari_stram_free(atari_dma_buffer);
@@ -701,7 +701,7 @@ int atari_scsi_detect(struct scsi_host_t
 					 IRQ_TYPE_PRIO, "Hades DMA emulator",
 					 hades_dma_emulator)) {
 				printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting (MACH_IS_HADES)",IRQ_AUTO_2);
-				free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+				free_irq(IRQ_TT_MFP_SCSI, instance);
 				scsi_unregister(atari_scsi_host);
 				atari_stram_free(atari_dma_buffer);
 				atari_dma_buffer = 0;
@@ -761,7 +761,7 @@ int atari_scsi_detect(struct scsi_host_t
 int atari_scsi_release(struct Scsi_Host *sh)
 {
 	if (IS_A_TT())
-		free_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr);
+		free_irq(IRQ_TT_MFP_SCSI, sh);
 	if (atari_dma_buffer)
 		atari_stram_free(atari_dma_buffer);
 	return 1;
diff -puN drivers/scsi/dtc.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/dtc.c
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
@@ -459,7 +460,7 @@ static int dtc_release(struct Scsi_Host 
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
diff -puN drivers/scsi/g_NCR5380.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/g_NCR5380.c
@@ -460,7 +460,8 @@ int __init generic_NCR5380_detect(struct
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, generic_NCR5380_intr, IRQF_DISABLED, "NCR5380", instance)) {
+			if (request_irq(instance->irq, generic_NCR5380_intr,
+					IRQF_DISABLED, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
@@ -513,7 +514,7 @@ int generic_NCR5380_release_resources(st
 	NCR5380_setup(instance);
 	
 	if (instance->irq != SCSI_IRQ_NONE)
-		free_irq(instance->irq, NULL);
+		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 
 #ifndef CONFIG_SCSI_G_NCR5380_MEM
diff -puN drivers/scsi/mac_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/mac_scsi.c
--- a/drivers/scsi/mac_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/mac_scsi.c
@@ -303,7 +303,7 @@ int macscsi_detect(struct scsi_host_temp
 
     if (instance->irq != SCSI_IRQ_NONE)
 	if (request_irq(instance->irq, NCR5380_intr, IRQ_FLG_SLOW, 
-		"ncr5380", instance)) {
+			"ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
 	    instance->irq = SCSI_IRQ_NONE;
@@ -326,7 +326,7 @@ int macscsi_detect(struct scsi_host_temp
 int macscsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NCR5380_intr);
+		free_irq(shpnt->irq, shpnt);
 	NCR5380_exit(shpnt);
 
 	return 0;
diff -puN drivers/scsi/pas16.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/pas16.c
--- a/drivers/scsi/pas16.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/pas16.c
@@ -453,7 +453,8 @@ int __init pas16_detect(struct scsi_host
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED, "pas16", instance)) {
+	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED,
+			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -604,7 +605,7 @@ static inline int NCR5380_pwrite (struct
 static int pas16_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
diff -puN drivers/scsi/sun3_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/sun3_scsi.c
@@ -268,7 +268,7 @@ int sun3scsi_detect(struct scsi_host_tem
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380", NULL)) {
+			     0, "Sun3SCSI-5380", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -310,7 +310,7 @@ int sun3scsi_detect(struct scsi_host_tem
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq(shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff -puN drivers/scsi/sun3_scsi_vme.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/sun3_scsi_vme.c
--- a/drivers/scsi/sun3_scsi_vme.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/sun3_scsi_vme.c
@@ -230,7 +230,7 @@ static int sun3scsi_detect(struct scsi_h
         ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
 
 	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380VME", NULL)) {
+			0, "Sun3SCSI-5380VME", instance)) {
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
@@ -279,7 +279,7 @@ static int sun3scsi_detect(struct scsi_h
 int sun3scsi_release (struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
+		free_irq(shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
 
diff -puN drivers/scsi/t128.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers drivers/scsi/t128.c
--- a/drivers/scsi/t128.c~scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers
+++ a/drivers/scsi/t128.c
@@ -259,7 +259,8 @@ found:
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128", instance)) {
+	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128",
+			    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
 		instance->irq = SCSI_IRQ_NONE;
@@ -295,7 +296,7 @@ static int t128_release(struct Scsi_Host
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
 	if (shost->irq)
-		free_irq(shost->irq, NULL);
+		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
_
