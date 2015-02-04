From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/3] ncr5380: Harmonize jiffies conversion with
 msecs_to_jiffies
Date: Wed, 4 Feb 2015 13:30:20 -0500
Message-ID: <817ecd84bb5ba1bf5cd6b52b8a6225a30d064836.1425880089.git.fthain@telegraphics.com.au>
References: <cover.1425880089.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44155 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbCIICZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2015 04:02:25 -0400
In-Reply-To: <cover.1425880089.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

Instances of var * HZ / 1000 are replaced by msecs_to_jiffies(var).
In addition some timing constants that assumed HZ 100 were adjusted
to HZ independent settings based on review comments from Michael Schmitz
<schmitzmic@gmail.com> and review of the original drivers in 1.0.31 and
2.2.16.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Acked-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c       | 10 +++++-----
 drivers/scsi/atari_NCR5380.c |  2 +-
 drivers/scsi/g_NCR5380.c     |  6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8981701..a777e5c 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -474,11 +474,11 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
  */
 #ifndef USLEEP_SLEEP
 /* 20 ms (reasonable hard disk speed) */
-#define USLEEP_SLEEP (20*HZ/1000)
+#define USLEEP_SLEEP msecs_to_jiffies(20)
 #endif
 /* 300 RPM (floppy speed) */
 #ifndef USLEEP_POLL
-#define USLEEP_POLL (200*HZ/1000)
+#define USLEEP_POLL msecs_to_jiffies(200)
 #endif
 #ifndef USLEEP_WAITLONG
 /* RvC: (reasonable time to wait on select error) */
@@ -576,7 +576,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
-	timeout = jiffies + (250 * HZ / 1000);
+	timeout = jiffies + msecs_to_jiffies(250);
 	probe_irq = NO_IRQ;
 
 	/*
@@ -634,7 +634,7 @@ static void prepare_info(struct Scsi_Host *instance)
 	         "sg_tablesize %d, this_id %d, "
 	         "flags { %s%s%s}, "
 #if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
-	         "USLEEP_POLL %d, USLEEP_WAITLONG %d, "
+		 "USLEEP_POLL %lu, USLEEP_WAITLONG %lu, "
 #endif
 	         "options { %s} ",
 	         instance->hostt->name, instance->io_port, instance->n_io_port,
@@ -1346,7 +1346,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	 * selection.
 	 */
 
-	timeout = jiffies + (250 * HZ / 1000);
+	timeout = jiffies + msecs_to_jiffies(250);
 
 	/* 
 	 * XXX very interesting - we're seeing a bounce where the BSY we 
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index a702554..db87ece 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -1486,7 +1486,7 @@ static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	 * selection.
 	 */
 
-	timeout = jiffies + (250 * HZ / 1000);
+	timeout = jiffies + msecs_to_jiffies(250);
 
 	/*
 	 * XXX very interesting - we're seeing a bounce where the BSY we
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 74ec2f5..f8d2478 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -57,9 +57,9 @@
  */
 
 /* settings for DTC3181E card with only Mustek scanner attached */
-#define USLEEP_POLL	1
-#define USLEEP_SLEEP	20
-#define USLEEP_WAITLONG	500
+#define USLEEP_POLL	msecs_to_jiffies(10)
+#define USLEEP_SLEEP	msecs_to_jiffies(200)
+#define USLEEP_WAITLONG	msecs_to_jiffies(5000)
 
 #define AUTOPROBE_IRQ
 
-- 
2.0.5
