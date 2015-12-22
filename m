From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 07/77] ncr5380: Split NCR5380_init() into two functions
Date: Tue, 22 Dec 2015 12:17:45 +1100
Message-ID: <20151222011739.965586036@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-bus-wedge
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

This patch splits the NCR5380_init() function into two parts, similar
to the scheme used with atari_NCR5380.c. This avoids two problems.

Firstly, NCR5380_init() may perform a bus reset, which would cause the
chip to assert IRQ. The chip is unable to mask its bus reset interrupt.
Drivers can't call request_irq() before calling NCR5380_init(), because
initialization must happen before the interrupt handler executes. If
driver initialization causes an interrupt it may be problematic on some
platforms. To avoid that, first move the bus reset code into
NCR5380_maybe_reset_bus().

Secondly, NCR5380_init() contains some board-specific interrupt setup code
for the NCR53C400 that does not belong in the core driver. In moving this
code, better not re-order interrupt initialization and bus reset. Again,
the solution is to move the bus reset code into NCR5380_maybe_reset_bus().

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c      |   34 ++++++++++++++++++++--------------
 drivers/scsi/NCR5380.h      |    1 +
 drivers/scsi/arm/cumana_1.c |    2 ++
 drivers/scsi/arm/oak.c      |    2 ++
 drivers/scsi/dmx3191d.c     |    2 ++
 drivers/scsi/dtc.c          |    2 ++
 drivers/scsi/g_NCR5380.c    |    2 ++
 drivers/scsi/pas16.c        |    2 ++
 drivers/scsi/t128.c         |    2 ++
 9 files changed, 35 insertions(+), 14 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:15:34.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:15:35.000000000 +1100
@@ -777,8 +777,7 @@ static void lprint_opcode(int opcode, st
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
 {
-	int i, pass;
-	unsigned long timeout;
+	int i;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
 	if(in_interrupt())
@@ -831,18 +830,26 @@ static int NCR5380_init(struct Scsi_Host
 		NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
 	}
 #endif
+	return 0;
+}
 
-	/* 
-	 * Detect and correct bus wedge problems.
-	 *
-	 * If the system crashed, it may have crashed in a state 
-	 * where a SCSI command was still executing, and the 
-	 * SCSI bus is not in a BUS FREE STATE.
-	 *
-	 * If this is the case, we'll try to abort the currently
-	 * established nexus which we know nothing about, and that
-	 * failing, do a hard reset of the SCSI bus 
-	 */
+/**
+ * NCR5380_maybe_reset_bus - Detect and correct bus wedge problems.
+ * @instance: adapter to check
+ *
+ * If the system crashed, it may have crashed with a connected target and
+ * the SCSI bus busy. Check for BUS FREE phase. If not, try to abort the
+ * currently established nexus, which we know nothing about. Failing that
+ * do a bus reset.
+ *
+ * Note that a bus reset will cause the chip to assert IRQ.
+ *
+ * Returns 0 if successful, otherwise -ENXIO.
+ */
+
+static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
+{
+	int pass;
 
 	for (pass = 1; (NCR5380_read(STATUS_REG) & SR_BSY) && pass <= 6; ++pass) {
 		switch (pass) {
@@ -850,7 +857,6 @@ static int NCR5380_init(struct Scsi_Host
 		case 3:
 		case 5:
 			printk(KERN_INFO "scsi%d: SCSI bus busy, waiting up to five seconds\n", instance->host_no);
-			timeout = jiffies + 5 * HZ;
 			NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, 0, 5*HZ);
 			break;
 		case 2:
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-22 12:15:28.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-22 12:15:35.000000000 +1100
@@ -318,6 +318,7 @@ static void NCR5380_print(struct Scsi_Ho
 static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
 #endif
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
+static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
 static void NCR5380_exit(struct Scsi_Host *instance);
 static void NCR5380_information_transfer(struct Scsi_Host *instance);
 #ifndef DONT_USE_INTR
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2015-12-22 12:15:35.000000000 +1100
@@ -240,6 +240,8 @@ static int cumanascsi1_probe(struct expa
 
 	NCR5380_init(host, 0);
 
+	NCR5380_maybe_reset_bus(host);
+
         priv(host)->ctrl = 0;
         writeb(0, priv(host)->base + CTRL);
 
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2015-12-22 12:15:35.000000000 +1100
@@ -145,6 +145,8 @@ static int oakscsi_probe(struct expansio
 
 	NCR5380_init(host, 0);
 
+	NCR5380_maybe_reset_bus(host);
+
 	ret = scsi_add_host(host, &ec->dev);
 	if (ret)
 		goto out_unmap;
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2015-12-22 12:15:35.000000000 +1100
@@ -97,6 +97,8 @@ static int dmx3191d_probe_one(struct pci
 
 	NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
 
+	NCR5380_maybe_reset_bus(shost);
+
 	pci_set_drvdata(pdev, shost);
 
 	error = scsi_add_host(shost, &pdev->dev);
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2015-12-22 12:15:35.000000000 +1100
@@ -237,6 +237,8 @@ found:
 
 		NCR5380_init(instance, 0);
 
+		NCR5380_maybe_reset_bus(instance);
+
 		NCR5380_write(DTC_CONTROL_REG, CSR_5380_INTR);	/* Enable int's */
 		if (overrides[current_override].irq != IRQ_AUTO)
 			instance->irq = overrides[current_override].irq;
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:15:34.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:15:35.000000000 +1100
@@ -422,6 +422,8 @@ static int __init generic_NCR5380_detect
 
 		NCR5380_init(instance, flags);
 
+		NCR5380_maybe_reset_bus(instance);
+
 		if (overrides[current_override].irq != IRQ_AUTO)
 			instance->irq = overrides[current_override].irq;
 		else
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2015-12-22 12:15:35.000000000 +1100
@@ -384,6 +384,8 @@ static int __init pas16_detect(struct sc
 
 	NCR5380_init(instance, 0);
 
+	NCR5380_maybe_reset_bus(instance);
+
 	if (overrides[current_override].irq != IRQ_AUTO)
 	    instance->irq = overrides[current_override].irq;
 	else 
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2015-12-22 12:15:30.000000000 +1100
+++ linux/drivers/scsi/t128.c	2015-12-22 12:15:35.000000000 +1100
@@ -215,6 +215,8 @@ found:
 
 	NCR5380_init(instance, 0);
 
+	NCR5380_maybe_reset_bus(instance);
+
 	if (overrides[current_override].irq != IRQ_AUTO)
 	    instance->irq = overrides[current_override].irq;
 	else 
