From: akpm@linux-foundation.org
Subject: [patch 25/25] ncr5380 warning fixes
Date: Wed, 23 May 2007 14:41:56 -0700
Message-ID: <200705232141.l4NLfuGs001245@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429AbXEWWD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk

From: Andrew Morton <akpm@linux-foundation.org>

squish these:

drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:633: warning: 'NCR5380_print_options' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'NCR5380_proc_info' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:579: warning: 'NCR5380_probe_irq' defined but not used
drivers/scsi/NCR5380.c:360: warning: 'phases' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'notyet_generic_proc_info' defined but not used
drivers/scsi/NCR5380.c:708: warning: 'notyet_generic_proc_info' defined but not used

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |   12 +++++++-----
 drivers/scsi/NCR5380.h |    6 +++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/NCR5380.c~ncr5380-warning-fixes drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~ncr5380-warning-fixes
+++ a/drivers/scsi/NCR5380.c
@@ -357,7 +357,7 @@ static int NCR5380_poll_politely(struct 
 static struct {
 	unsigned char value;
 	const char *name;
-} phases[] = {
+} phases[] __maybe_unused = {
 	{PHASE_DATAOUT, "DATAOUT"}, 
 	{PHASE_DATAIN, "DATAIN"}, 
 	{PHASE_CMDOUT, "CMDOUT"}, 
@@ -575,7 +575,8 @@ static irqreturn_t __init probe_intr(int
  *	Locks: none, irqs must be enabled on entry
  */
 
-static int __init NCR5380_probe_irq(struct Scsi_Host *instance, int possible)
+static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
+						int possible)
 {
 	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -629,7 +630,8 @@ static int __init NCR5380_probe_irq(stru
  *	Locks: none
  */
 
-static void __init NCR5380_print_options(struct Scsi_Host *instance)
+static void __init __maybe_unused
+NCR5380_print_options(struct Scsi_Host *instance)
 {
 	printk(" generic options"
 #ifdef AUTOPROBE_IRQ
@@ -703,8 +705,8 @@ char *lprint_command(unsigned char *cmd,
 static
 char *lprint_opcode(int opcode, char *pos, char *buffer, int length);
 
-static
-int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start, off_t offset, int length, int inout)
+static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
+	char *buffer, char **start, off_t offset, int length, int inout)
 {
 	char *pos = buffer;
 	struct NCR5380_hostdata *hostdata;
diff -puN drivers/scsi/NCR5380.h~ncr5380-warning-fixes drivers/scsi/NCR5380.h
--- a/drivers/scsi/NCR5380.h~ncr5380-warning-fixes
+++ a/drivers/scsi/NCR5380.h
@@ -299,7 +299,7 @@ static void NCR5380_information_transfer
 static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 #endif
 static void NCR5380_main(struct work_struct *work);
-static void NCR5380_print_options(struct Scsi_Host *instance);
+static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
 #ifdef NDEBUG
 static void NCR5380_print_phase(struct Scsi_Host *instance);
 static void NCR5380_print(struct Scsi_Host *instance);
@@ -307,8 +307,8 @@ static void NCR5380_print(struct Scsi_Ho
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
-off_t offset, int length, int inout);
+static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
+	char *buffer, char **start, off_t offset, int length, int inout);
 
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
_
