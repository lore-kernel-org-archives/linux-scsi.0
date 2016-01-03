From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 05/78] ncr5380: Remove NCR5380_local_declare and
 NCR5380_setup macros
Date: Sun, 03 Jan 2016 16:05:06 +1100
Message-ID: <20160103050502.371803537@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-eliminate-local_declare-macros
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

The NCR5380_local_declare and NCR5380_setup macros exist to define and
initialize a particular local variable, to provide the address of the
chip registers needed for the driver's implementation of its
NCR5380_read/write register access macros.

In cumana_1 and macscsi, these macros generate pointless code like this,
	struct Scsi_Host *_instance;
	_instance = instance;

In pas16, the use of NCR5380_read/write in pas16_hw_detect() requires that
the io_port local variable has been defined and initialized, but the
NCR5380_local_declare and NCR5380_setup macros can't be used for that
purpose because the Scsi_Host struct has not yet been instantiated.

Moreover, these macros were removed from atari_NCR5380.c long ago and
now they constitute yet another discrepancy between the two core driver
forks.

Remove these "optimizations".

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---

Any performance penalty is highly unlikely given the algorithms involved
and the improvements made to compilers over the last two decades. (And
I'd probably accept some loss anyway given the maintainability benefit.)

Following the example of atari_NCR5380.c, the Scsi_Host pointer is now
always named "instance", and the NCR5380_read/write macros depend on this.
I think it is poor style to hard-code the identifier "instance" in these
macros but it is actually an improvement -- previously each NCR5380 driver
named a different local variable in its macro definitions.

Eventually, the NCR5380_read/write macros may have to become function
calls if this is to become a platform driver or a library. The instance
pointer or hostdata pointer will then have to be passed as an argument.

This patch is a step in that direction, in that it rewrites the
NCR5380_read/write macros in terms of hostdata and removes the
NCR5380_read/write usage from pas16_hw_detect() where there is no
Scsi_Host instance as yet.

---
 drivers/scsi/NCR5380.c      |   60 ++++++--------------------------------------
 drivers/scsi/arm/cumana_1.c |    6 +---
 drivers/scsi/arm/oak.c      |    9 +++---
 drivers/scsi/dmx3191d.c     |    6 +---
 drivers/scsi/dtc.c          |   14 +++-------
 drivers/scsi/dtc.h          |    9 +-----
 drivers/scsi/g_NCR5380.c    |   27 ++++++++++---------
 drivers/scsi/g_NCR5380.h    |   30 ++++++++--------------
 drivers/scsi/mac_scsi.c     |   15 +----------
 drivers/scsi/pas16.c        |   16 +++++------
 drivers/scsi/pas16.h        |   11 +-------
 drivers/scsi/t128.c         |   26 +++++++++----------
 drivers/scsi/t128.h         |    9 +-----
 13 files changed, 77 insertions(+), 161 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:02:42.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:02:56.000000000 +1100
@@ -230,11 +230,6 @@
  * USLEEP_POLL - amount of time, in jiffies, to poll
  *
  * These macros MUST be defined :
- * NCR5380_local_declare() - declare any local variables needed for your
- *      transfer routines.
- *
- * NCR5380_setup(instance) - initialize any local variables needed from a given
- *      instance of the host adapter for NCR5380_{read,write,pread,pwrite}
  * 
  * NCR5380_read(register)  - read from the specified register
  *
@@ -267,8 +262,8 @@
  * possible) function may be used.
  */
 
-static int do_abort(struct Scsi_Host *host);
-static void do_reset(struct Scsi_Host *host);
+static int do_abort(struct Scsi_Host *);
+static void do_reset(struct Scsi_Host *);
 
 /*
  *	initialize_SCp		-	init the scsi pointer field
@@ -313,12 +308,9 @@ static inline void initialize_SCp(struct
  
 static int NCR5380_poll_politely(struct Scsi_Host *instance, int reg, int bit, int val, int t)
 {
-	NCR5380_local_declare();
 	int n = 500;		/* At about 8uS a cycle for the cpu access */
 	unsigned long end = jiffies + t;
 	int r;
-	
-	NCR5380_setup(instance);
 
 	while( n-- > 0)
 	{
@@ -406,9 +398,7 @@ mrs[] = {
 
 static void NCR5380_print(struct Scsi_Host *instance)
 {
-	NCR5380_local_declare();
 	unsigned char status, data, basr, mr, icr, i;
-	NCR5380_setup(instance);
 
 	data = NCR5380_read(CURRENT_SCSI_DATA_REG);
 	status = NCR5380_read(STATUS_REG);
@@ -447,10 +437,8 @@ static void NCR5380_print(struct Scsi_Ho
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
 {
-	NCR5380_local_declare();
 	unsigned char status;
 	int i;
-	NCR5380_setup(instance);
 
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
@@ -566,11 +554,9 @@ static irqreturn_t __init probe_intr(int
 static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 						int possible)
 {
-	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	unsigned long timeout;
 	int trying_irqs, i, mask;
-	NCR5380_setup(instance);
 
 	for (trying_irqs = 0, i = 1, mask = 2; i < 16; ++i, mask <<= 1)
 		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
@@ -791,7 +777,6 @@ static void lprint_opcode(int opcode, st
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
 {
-	NCR5380_local_declare();
 	int i, pass;
 	unsigned long timeout;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
@@ -808,8 +793,6 @@ static int NCR5380_init(struct Scsi_Host
 		instance->NCR5380_instance_name += NCR53C400_address_adjust;
 #endif
 
-	NCR5380_setup(instance);
-
 	hostdata->aborted = 0;
 	hostdata->id_mask = 1 << instance->this_id;
 	for (i = hostdata->id_mask; i <= 0x80; i <<= 1)
@@ -1100,7 +1083,6 @@ static void NCR5380_main(struct work_str
 
 static irqreturn_t NCR5380_intr(int dummy, void *dev_id)
 {
-	NCR5380_local_declare();
 	struct Scsi_Host *instance = dev_id;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int done;
@@ -1114,7 +1096,6 @@ static irqreturn_t NCR5380_intr(int dumm
 		done = 1;
 		spin_lock_irqsave(instance->host_lock, flags);
 		/* Look for pending interrupts */
-		NCR5380_setup(instance);
 		basr = NCR5380_read(BUS_AND_STATUS_REG);
 		/* XXX dispatch to appropriate routine if found and done=0 */
 		if (basr & BASR_IRQ) {
@@ -1205,7 +1186,6 @@ static irqreturn_t NCR5380_intr(int dumm
  
 static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
-	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	unsigned char tmp[3], phase;
 	unsigned char *data;
@@ -1213,7 +1193,6 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned long timeout;
 	unsigned char value;
 	int err;
-	NCR5380_setup(instance);
 
 	if (hostdata->selecting)
 		goto part2;
@@ -1487,7 +1466,6 @@ failed:
  */
 
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data) {
-	NCR5380_local_declare();
 	unsigned char p = *phase, tmp;
 	int c = *count;
 	unsigned char *d = *data;
@@ -1496,7 +1474,6 @@ static int NCR5380_transfer_pio(struct S
 	 */
 	int break_allowed = 0;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
-	NCR5380_setup(instance);
 
 	if (!(p & SR_IO))
 		dprintk(NDEBUG_PIO, "scsi%d : pio write %d bytes\n", instance->host_no, c);
@@ -1623,10 +1600,8 @@ static int NCR5380_transfer_pio(struct S
  *	Locks: caller holds queue lock
  */
  
-static void do_reset(struct Scsi_Host *host) {
-	NCR5380_local_declare();
-	NCR5380_setup(host);
-
+static void do_reset(struct Scsi_Host *instance)
+{
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST);
 	udelay(25);
@@ -1645,13 +1620,11 @@ static void do_reset(struct Scsi_Host *h
  *	FIXME: sort this out and get new_eh running
  */
 
-static int do_abort(struct Scsi_Host *host) {
-	NCR5380_local_declare();
+static int do_abort(struct Scsi_Host *instance)
+{
 	unsigned char *msgptr, phase, tmp;
 	int len;
 	int rc;
-	NCR5380_setup(host);
-
 
 	/* Request message out phase */
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1666,7 +1639,7 @@ static int do_abort(struct Scsi_Host *ho
 	 * the target sees, so we just handshake.
 	 */
 
-	rc = NCR5380_poll_politely(host, STATUS_REG, SR_REQ, SR_REQ, 60 * HZ);
+	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 60 * HZ);
 	
 	if(rc < 0)
 		return -1;
@@ -1677,7 +1650,7 @@ static int do_abort(struct Scsi_Host *ho
 
 	if ((tmp & PHASE_MASK) != PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-		rc = NCR5380_poll_politely(host, STATUS_REG, SR_REQ, 0, 3*HZ);
+		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 		if(rc == -1)
 			return -1;
@@ -1686,7 +1659,7 @@ static int do_abort(struct Scsi_Host *ho
 	msgptr = &tmp;
 	len = 1;
 	phase = PHASE_MSGOUT;
-	NCR5380_transfer_pio(host, &phase, &len, &msgptr);
+	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
 
 	/*
 	 * If we got here, and the command completed successfully,
@@ -1719,7 +1692,6 @@ static int do_abort(struct Scsi_Host *ho
 
 
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data) {
-	NCR5380_local_declare();
 	register int c = *count;
 	register unsigned char p = *phase;
 	register unsigned char *d = *data;
@@ -1732,8 +1704,6 @@ static int NCR5380_transfer_dma(struct S
 
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
-	NCR5380_setup(instance);
-
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
 		return -1;
@@ -2000,7 +1970,6 @@ static int NCR5380_transfer_dma(struct S
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance) {
-	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 	unsigned char msgout = NOP;
 	int sink = 0;
@@ -2014,8 +1983,6 @@ static void NCR5380_information_transfer
 	/* RvC: we need to set the end of the polling time */
 	unsigned long poll_time = jiffies + USLEEP_POLL;
 
-	NCR5380_setup(instance);
-
 	while (1) {
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
@@ -2406,7 +2373,6 @@ static void NCR5380_information_transfer
  */
 
 static void NCR5380_reselect(struct Scsi_Host *instance) {
-	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)
 	 instance->hostdata;
 	unsigned char target_mask;
@@ -2416,7 +2382,6 @@ static void NCR5380_reselect(struct Scsi
 	unsigned char *data;
 	struct scsi_cmnd *tmp = NULL, *prev;
 	int abort = 0;
-	NCR5380_setup(instance);
 
 	/*
 	 * Disable arbitration, etc. since the host adapter obviously
@@ -2525,10 +2490,8 @@ static void NCR5380_reselect(struct Scsi
 
 #ifdef REAL_DMA
 static void NCR5380_dma_complete(NCR5380_instance * instance) {
-	NCR5380_local_declare();
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int transferred;
-	NCR5380_setup(instance);
 
 	/*
 	 * XXX this might not be right.
@@ -2581,7 +2544,6 @@ static void NCR5380_dma_complete(NCR5380
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
 {
-	NCR5380_local_declare();
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	struct scsi_cmnd *tmp, **prev;
@@ -2590,8 +2552,6 @@ static int NCR5380_abort(struct scsi_cmn
 
 	NCR5380_print_status(instance);
 
-	NCR5380_setup(instance);
-
 	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
 	dprintk(NDEBUG_ABORT, "        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG));
 
@@ -2737,8 +2697,6 @@ static int NCR5380_bus_reset(struct scsi
 {
 	struct Scsi_Host *instance = cmd->device->host;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
 	NCR5380_print_status(instance);
 
 	spin_lock_irq(instance->host_lock);
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-01-03 16:02:38.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-01-03 16:02:56.000000000 +1100
@@ -20,10 +20,8 @@
 #define PSEUDO_DMA
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
-#define NCR5380_local_declare()		struct Scsi_Host *_instance
-#define NCR5380_setup(instance)		_instance = instance
-#define NCR5380_read(reg)		cumanascsi_read(_instance, reg)
-#define NCR5380_write(reg, value)	cumanascsi_write(_instance, reg, value)
+#define NCR5380_read(reg)		cumanascsi_read(instance, reg)
+#define NCR5380_write(reg, value)	cumanascsi_write(instance, reg, value)
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
 #define NCR5380_info			cumanascsi_info
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-01-03 16:02:38.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-01-03 16:02:56.000000000 +1100
@@ -20,11 +20,12 @@
 #define DONT_USE_INTR
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
-#define NCR5380_local_declare()		void __iomem *_base
-#define NCR5380_setup(host)		_base = priv(host)->base
 
-#define NCR5380_read(reg)		readb(_base + ((reg) << 2))
-#define NCR5380_write(reg, value)	writeb(value, _base + ((reg) << 2))
+#define NCR5380_read(reg) \
+	readb(priv(instance)->base + ((reg) << 2))
+#define NCR5380_write(reg, value) \
+	writeb(value, priv(instance)->base + ((reg) << 2))
+
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
 #define NCR5380_show_info		oakscsi_show_info
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-01-03 16:02:38.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-01-03 16:02:56.000000000 +1100
@@ -36,12 +36,10 @@
 
 #define DONT_USE_INTR
 
-#define NCR5380_read(reg)		inb(port + reg)
-#define NCR5380_write(reg, value)	outb(value, port + reg)
+#define NCR5380_read(reg)		inb(instance->io_port + reg)
+#define NCR5380_write(reg, value)	outb(value, instance->io_port + reg)
 
 #define NCR5380_implementation_fields	/* none */
-#define NCR5380_local_declare()		unsigned int port
-#define NCR5380_setup(instance)		port = instance->io_port
 
 /*
  * Includes needed for NCR5380.[ch] (XXX: Move them to NCR5380.h)
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:02:47.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:02:56.000000000 +1100
@@ -325,8 +325,6 @@ static inline int NCR5380_pread(struct S
 	unsigned char *d = dst;
 	int i;			/* For counting time spent in the poll-loop */
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
 
 	i = 0;
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -342,7 +340,7 @@ static inline int NCR5380_pread(struct S
 		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
 			++i;
 		rtrc(3);
-		memcpy_fromio(d, base + DTC_DATA_BUF, 128);
+		memcpy_fromio(d, hostdata->base + DTC_DATA_BUF, 128);
 		d += 128;
 		len -= 128;
 		rtrc(7);
@@ -377,8 +375,6 @@ static inline int NCR5380_pwrite(struct
 {
 	int i;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
 
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	NCR5380_write(MODE_REG, MR_ENABLE_EOP_INTR | MR_DMA_MODE);
@@ -394,7 +390,7 @@ static inline int NCR5380_pwrite(struct
 		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
 			++i;
 		rtrc(3);
-		memcpy_toio(base + DTC_DATA_BUF, src, 128);
+		memcpy_toio(hostdata->base + DTC_DATA_BUF, src, 128);
 		src += 128;
 		len -= 128;
 	}
@@ -420,15 +416,15 @@ MODULE_LICENSE("GPL");
 
 static int dtc_release(struct Scsi_Host *shost)
 {
-	NCR5380_local_declare();
-	NCR5380_setup(shost);
+	struct NCR5380_hostdata *hostdata = shost_priv(shost);
+
 	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
-	iounmap(base);
+	iounmap(hostdata->base);
 	return 0;
 }
 
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-01-03 16:02:47.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-01-03 16:02:56.000000000 +1100
@@ -21,13 +21,8 @@
 #define NCR5380_implementation_fields \
     void __iomem *base
 
-#define NCR5380_local_declare() \
-    void __iomem *base
-
-#define NCR5380_setup(instance) \
-    base = ((struct NCR5380_hostdata *)(instance)->hostdata)->base
-
-#define DTC_address(reg) (base + DTC_5380_OFFSET + reg)
+#define DTC_address(reg) \
+	(((struct NCR5380_hostdata *)shost_priv(instance))->base + DTC_5380_OFFSET + reg)
 
 #define NCR5380_read(reg) (readb(DTC_address(reg)))
 #define NCR5380_write(reg, value) (writeb(value, DTC_address(reg)))
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:02:54.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:02:56.000000000 +1100
@@ -459,9 +459,6 @@ static int __init generic_NCR5380_detect
  
 static int generic_NCR5380_release_resources(struct Scsi_Host *instance)
 {
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-	
 	if (instance->irq != NO_IRQ)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
@@ -520,13 +517,13 @@ generic_NCR5380_biosparam(struct scsi_de
  
 static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
 {
+#ifdef SCSI_G_NCR5380_MEM
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+#endif
 	int blocks = len / 128;
 	int start = 0;
 	int bl;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-
 	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE | CSR_TRANS_DIR);
 	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
 	while (1) {
@@ -547,7 +544,8 @@ static inline int NCR5380_pread(struct S
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_fromio(dst + start, iomem + NCR53C400_host_buffer, 128);
+		memcpy_fromio(dst + start,
+		              hostdata->iomem + NCR53C400_host_buffer, 128);
 #endif
 		start += 128;
 		blocks--;
@@ -567,7 +565,8 @@ static inline int NCR5380_pread(struct S
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_fromio(dst + start, iomem + NCR53C400_host_buffer, 128);
+		memcpy_fromio(dst + start,
+		              hostdata->iomem + NCR53C400_host_buffer, 128);
 #endif
 		start += 128;
 		blocks--;
@@ -604,14 +603,14 @@ static inline int NCR5380_pread(struct S
 
 static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
 {
+#ifdef SCSI_G_NCR5380_MEM
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+#endif
 	int blocks = len / 128;
 	int start = 0;
 	int bl;
 	int i;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-
 	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
 	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
 	while (1) {
@@ -632,7 +631,8 @@ static inline int NCR5380_pwrite(struct
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_toio(iomem + NCR53C400_host_buffer, src + start, 128);
+		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+		            src + start, 128);
 #endif
 		start += 128;
 		blocks--;
@@ -648,7 +648,8 @@ static inline int NCR5380_pwrite(struct
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_toio(iomem + NCR53C400_host_buffer, src + start, 128);
+		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+		            src + start, 128);
 #endif
 		start += 128;
 		blocks--;
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:02:54.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:02:56.000000000 +1100
@@ -46,17 +46,12 @@
 #define NCR5380_region_size 8
 #endif
 
-#define NCR5380_read(reg) (inb(NCR5380_map_name + (reg)))
-#define NCR5380_write(reg, value) (outb((value), (NCR5380_map_name + (reg))))
+#define NCR5380_read(reg) \
+	inb(instance->io_port + (reg))
+#define NCR5380_write(reg, value) \
+	outb(value, instance->io_port + (reg))
 
-#define NCR5380_implementation_fields \
-    NCR5380_map_type NCR5380_map_name
-
-#define NCR5380_local_declare() \
-    register NCR5380_implementation_fields
-
-#define NCR5380_setup(instance) \
-    NCR5380_map_name = (NCR5380_map_type)((instance)->NCR5380_instance_name)
+#define NCR5380_implementation_fields /* none */
 
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
@@ -70,19 +65,16 @@
 #define NCR53C400_host_buffer 0x3900
 #define NCR5380_region_size 0x3a00
 
-#define NCR5380_read(reg) readb(iomem + NCR53C400_mem_base + (reg))
-#define NCR5380_write(reg, value) writeb(value, iomem + NCR53C400_mem_base + (reg))
+#define NCR5380_read(reg) \
+	readb(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+	      NCR53C400_mem_base + (reg))
+#define NCR5380_write(reg, value) \
+	writeb(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+	       NCR53C400_mem_base + (reg))
 
 #define NCR5380_implementation_fields \
-    NCR5380_map_type NCR5380_map_name; \
     void __iomem *iomem;
 
-#define NCR5380_local_declare() \
-    register void __iomem *iomem
-
-#define NCR5380_setup(instance) \
-    iomem = (((struct NCR5380_hostdata *)(instance)->hostdata)->iomem)
-
 #endif
 
 #define NCR5380_intr generic_NCR5380_intr
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-01-03 16:02:38.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-01-03 16:02:56.000000000 +1100
@@ -32,11 +32,9 @@
 #define PSEUDO_DMA
 
 #define NCR5380_implementation_fields   unsigned char *pdma_base
-#define NCR5380_local_declare()         struct Scsi_Host *_instance
-#define NCR5380_setup(instance)         _instance = instance
 
-#define NCR5380_read(reg)               macscsi_read(_instance, reg)
-#define NCR5380_write(reg, value)       macscsi_write(_instance, reg, value)
+#define NCR5380_read(reg)               macscsi_read(instance, reg)
+#define NCR5380_write(reg, value)       macscsi_write(instance, reg, value)
 
 #define NCR5380_pread                   macscsi_pread
 #define NCR5380_pwrite                  macscsi_pwrite
@@ -129,9 +127,6 @@ static void mac_scsi_reset_boot(struct S
 {
 	unsigned long end;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-	
 	/*
 	 * Do a SCSI reset to clean up the bus during initialization. No messing
 	 * with the queues, interrupts, or locks necessary here.
@@ -235,9 +230,6 @@ static int macscsi_pread(struct Scsi_Hos
 	unsigned char *d;
 	unsigned char *s;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-
 	s = hostdata->pdma_base + (INPUT_DATA_REG << 4);
 	d = dst;
 
@@ -329,9 +321,6 @@ static int macscsi_pwrite(struct Scsi_Ho
 	unsigned char *s;
 	unsigned char *d;
 
-	NCR5380_local_declare();
-	NCR5380_setup(instance);
-
 	s = src;
 	d = hostdata->pdma_base + (OUTPUT_DATA_REG << 4);
 
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2016-01-03 16:02:54.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2016-01-03 16:02:56.000000000 +1100
@@ -103,16 +103,9 @@
 #define CAN_QUEUE 32 
 #endif
 
-#define NCR5380_implementation_fields \
-    volatile unsigned short io_port
+#define NCR5380_implementation_fields /* none */
 
-#define NCR5380_local_declare() \
-    volatile unsigned short io_port
-
-#define NCR5380_setup(instance) \
-    io_port = (instance)->io_port
-
-#define PAS16_io_port(reg) ( io_port + pas16_offset[(reg)] )
+#define PAS16_io_port(reg) (instance->io_port + pas16_offset[(reg)])
 
 #define NCR5380_read(reg) ( inb(PAS16_io_port(reg)) )
 #define NCR5380_write(reg, value) ( outb((value),PAS16_io_port(reg)) )
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-01-03 16:02:47.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-01-03 16:02:56.000000000 +1100
@@ -248,15 +248,15 @@ found:
 
 static int t128_release(struct Scsi_Host *shost)
 {
-	NCR5380_local_declare();
-	NCR5380_setup(shost);
+	struct NCR5380_hostdata *hostdata = shost_priv(shost);
+
 	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
-	iounmap(base);
+	iounmap(hostdata->base);
 	return 0;
 }
 
@@ -302,14 +302,14 @@ static int t128_biosparam(struct scsi_de
  * 	timeout.
  */
 
-static inline int NCR5380_pread (struct Scsi_Host *instance, unsigned char *dst,
-    int len) {
-    NCR5380_local_declare();
-    void __iomem *reg;
+static inline int
+NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	void __iomem *reg, *base = hostdata->base;
     unsigned char *d = dst;
     register int i = len;
 
-    NCR5380_setup(instance);
     reg = base + T_DATA_REG_OFFSET;
 
 #if 0
@@ -348,14 +348,14 @@ static inline int NCR5380_pread (struct
  * 	timeout.
  */
 
-static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src,
-    int len) {
-    NCR5380_local_declare();
-    void __iomem *reg;
+static inline int
+NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	void __iomem *reg, *base = hostdata->base;
     unsigned char *s = src;
     register int i = len;
 
-    NCR5380_setup(instance);
     reg = base + T_DATA_REG_OFFSET;
 
 #if 0
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-01-03 16:02:54.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-01-03 16:02:56.000000000 +1100
@@ -78,13 +78,8 @@
 #define NCR5380_implementation_fields \
     void __iomem *base
 
-#define NCR5380_local_declare() \
-    void __iomem *base
-
-#define NCR5380_setup(instance) \
-    base = ((struct NCR5380_hostdata *)(instance->hostdata))->base
-
-#define T128_address(reg) (base + T_5380_OFFSET + ((reg) * 0x20))
+#define T128_address(reg) \
+	(((struct NCR5380_hostdata *)shost_priv(instance))->base + T_5380_OFFSET + ((reg) * 0x20))
 
 #define NCR5380_read(reg) readb(T128_address(reg))
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-01-03 16:02:54.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-01-03 16:02:56.000000000 +1100
@@ -188,7 +188,7 @@ static void __init
 	outb( 0x01, io_port + P_TIMEOUT_STATUS_REG_OFFSET );   /* Reset TC */
 	outb( 0x01, io_port + WAIT_STATE );   /* 1 Wait state */
 
-	NCR5380_read( RESET_PARITY_INTERRUPT_REG );
+	inb(io_port + pas16_offset[RESET_PARITY_INTERRUPT_REG]);
 
 	/* Set the SCSI interrupt pointer without mucking up the sound
 	 * interrupt pointer in the same byte.
@@ -263,13 +263,13 @@ static int __init
      * put in an additional test to try to weed them out.
      */
 
-    outb( 0x01, io_port + WAIT_STATE ); 	/* 1 Wait state */
-    NCR5380_write( MODE_REG, 0x20 );		/* Is it really SCSI? */
-    if( NCR5380_read( MODE_REG ) != 0x20 )	/* Write to a reg.    */
-	return 0;				/* and try to read    */
-    NCR5380_write( MODE_REG, 0x00 );		/* it back.	      */
-    if( NCR5380_read( MODE_REG ) != 0x00 )
-	return 0;
+	outb(0x01, io_port + WAIT_STATE);             /* 1 Wait state */
+	outb(0x20, io_port + pas16_offset[MODE_REG]); /* Is it really SCSI? */
+	if (inb(io_port + pas16_offset[MODE_REG]) != 0x20) /* Write to a reg. */
+		return 0;                                  /* and try to read */
+	outb(0x00, io_port + pas16_offset[MODE_REG]);      /* it back. */
+	if (inb(io_port + pas16_offset[MODE_REG]) != 0x00)
+		return 0;
 
     return 1;
 }
