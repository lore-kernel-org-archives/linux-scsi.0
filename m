From: David Miller <davem@davemloft.net>
Subject: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Mon, 23 Apr 2007 15:13:22 -0700 (PDT)
Message-ID: <20070423.151322.111205472.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754346AbXDWWNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2007 18:13:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org


If you are on the CC: list you have worked on an ESP related
scsi driver either directly, or indirectly, at some point in
time in the past.  I'd like your porting help if at all
possible since I don't have any of the non-Sparc ESP parts
at hand to do it myself.

I've rewritten the Sun ESP driver to support tagged queueing, use the
generic scsi layer helpers such as the SPI code, and in general
cleaned it up and fixed a lot of bugs.  Amusingly the new driver is
about half the size of the old one.

I determined that the scsi layer maintainers would be thrilled
if all the other bit-rotting ESP drivers could be eliminated,
so I made the necessary abstractions so that ports could be done
using esp.c as the driver code.

The driver below has been getting some good stress testing over the
past few weeks by sparc folks.  The results are very good at this
point.

Writing a chip front-end driver is quite easy.  Create a Kconfig
entry for your driver front-end, make it "select SCSI_ESP_CORE"
then make sure your foo_esp.o module gets linked after esp.o
in drivers/scsi/Makefile.

The esp_driver_ops interface is pretty decently documented in
esp.h as is the driver probe procedure above scsi_esp_register().

I believe that someone even only mildly knowledgable about
a particular existing NCR53C9x.c front-end can do an easy
port to the new esp.c core.

I plan to beef up the EH handling a bit more, but no other changes
to this new driver are planned.

Please send me any front-end driver ports you write and I'll
review and integrate them quickly.

Thanks!

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4cd280e..fcc4cb6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1763,9 +1763,15 @@ config SUN3X_ESP
 	  The ESP was an on-board SCSI controller used on Sun 3/80
 	  machines.  Say Y here to compile in support for it.
 
+config SCSI_ESP_CORE
+	tristate "ESP Scsi Driver Core"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+
 config SCSI_SUNESP
 	tristate "Sparc ESP Scsi Driver"
 	depends on SBUS && SCSI
+	select SCSI_ESP_CORE
 	help
 	  This is the driver for the Sun ESP SCSI host adapter. The ESP
 	  chipset is present in most SPARC SBUS-based computers.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 79ecf4e..ae02ce7 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -106,7 +106,8 @@ obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
-obj-$(CONFIG_SCSI_SUNESP)	+= esp.o
+obj-$(CONFIG_SCSI_ESP_CORE)	+= esp.o
+obj-$(CONFIG_SCSI_SUNESP)	+= sun_esp.o
 obj-$(CONFIG_SCSI_GDTH)		+= gdth.o
 obj-$(CONFIG_SCSI_INITIO)	+= initio.o
 obj-$(CONFIG_SCSI_INIA100)	+= a100u2w.o
diff --git a/drivers/scsi/esp.c b/drivers/scsi/esp.c
index 2c2fe80..030114f 100644
--- a/drivers/scsi/esp.c
+++ b/drivers/scsi/esp.c
@@ -1,598 +1,249 @@
-/* esp.c: ESP Sun SCSI driver.
+/* esp.c: ESP SCSI driver.
  *
- * Copyright (C) 1995, 1998, 2006 David S. Miller (davem@davemloft.net)
- */
-
-/* TODO:
- *
- * 1) Maybe disable parity checking in config register one for SCSI1
- *    targets.  (Gilmore says parity error on the SBus can lock up
- *    old sun4c's)
- * 2) Add support for DMA2 pipelining.
- * 3) Add tagged queueing.
+ * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
  */
 
 #include <linux/kernel.h>
-#include <linux/delay.h>
 #include <linux/types.h>
-#include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/blkdev.h>
-#include <linux/proc_fs.h>
-#include <linux/stat.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <linux/completion.h>
+#include <linux/kallsyms.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
 
-#include "esp.h"
-
-#include <asm/sbus.h>
-#include <asm/dma.h>
-#include <asm/system.h>
-#include <asm/ptrace.h>
-#include <asm/pgtable.h>
-#include <asm/oplib.h>
-#include <asm/io.h>
 #include <asm/irq.h>
-#ifndef __sparc_v9__
-#include <asm/machines.h>
-#include <asm/idprom.h>
-#endif
+#include <asm/io.h>
+#include <asm/dma.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_eh.h>
-#include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
-#define DRV_VERSION "1.101"
-
-#define DEBUG_ESP
-/* #define DEBUG_ESP_HME */
-/* #define DEBUG_ESP_DATA */
-/* #define DEBUG_ESP_QUEUE */
-/* #define DEBUG_ESP_DISCONNECT */
-/* #define DEBUG_ESP_STATUS */
-/* #define DEBUG_ESP_PHASES */
-/* #define DEBUG_ESP_WORKBUS */
-/* #define DEBUG_STATE_MACHINE */
-/* #define DEBUG_ESP_CMDS */
-/* #define DEBUG_ESP_IRQS */
-/* #define DEBUG_SDTR */
-/* #define DEBUG_ESP_SG */
-
-/* Use the following to sprinkle debugging messages in a way which
- * suits you if combinations of the above become too verbose when
- * trying to track down a specific problem.
- */
-/* #define DEBUG_ESP_MISC */
-
-#if defined(DEBUG_ESP)
-#define ESPLOG(foo)  printk foo
-#else
-#define ESPLOG(foo)
-#endif /* (DEBUG_ESP) */
-
-#if defined(DEBUG_ESP_HME)
-#define ESPHME(foo)  printk foo
-#else
-#define ESPHME(foo)
-#endif
-
-#if defined(DEBUG_ESP_DATA)
-#define ESPDATA(foo)  printk foo
-#else
-#define ESPDATA(foo)
-#endif
-
-#if defined(DEBUG_ESP_QUEUE)
-#define ESPQUEUE(foo)  printk foo
-#else
-#define ESPQUEUE(foo)
-#endif
-
-#if defined(DEBUG_ESP_DISCONNECT)
-#define ESPDISC(foo)  printk foo
-#else
-#define ESPDISC(foo)
-#endif
-
-#if defined(DEBUG_ESP_STATUS)
-#define ESPSTAT(foo)  printk foo
-#else
-#define ESPSTAT(foo)
-#endif
-
-#if defined(DEBUG_ESP_PHASES)
-#define ESPPHASE(foo)  printk foo
-#else
-#define ESPPHASE(foo)
-#endif
-
-#if defined(DEBUG_ESP_WORKBUS)
-#define ESPBUS(foo)  printk foo
-#else
-#define ESPBUS(foo)
-#endif
-
-#if defined(DEBUG_ESP_IRQS)
-#define ESPIRQ(foo)  printk foo
-#else
-#define ESPIRQ(foo)
-#endif
-
-#if defined(DEBUG_SDTR)
-#define ESPSDTR(foo)  printk foo
-#else
-#define ESPSDTR(foo)
-#endif
-
-#if defined(DEBUG_ESP_MISC)
-#define ESPMISC(foo)  printk foo
-#else
-#define ESPMISC(foo)
-#endif
-
-/* Command phase enumeration. */
-enum {
-	not_issued    = 0x00,  /* Still in the issue_SC queue.          */
-
-	/* Various forms of selecting a target. */
-#define in_slct_mask    0x10
-	in_slct_norm  = 0x10,  /* ESP is arbitrating, normal selection  */
-	in_slct_stop  = 0x11,  /* ESP will select, then stop with IRQ   */
-	in_slct_msg   = 0x12,  /* select, then send a message           */
-	in_slct_tag   = 0x13,  /* select and send tagged queue msg      */
-	in_slct_sneg  = 0x14,  /* select and acquire sync capabilities  */
-
-	/* Any post selection activity. */
-#define in_phases_mask  0x20
-	in_datain     = 0x20,  /* Data is transferring from the bus     */
-	in_dataout    = 0x21,  /* Data is transferring to the bus       */
-	in_data_done  = 0x22,  /* Last DMA data operation done (maybe)  */
-	in_msgin      = 0x23,  /* Eating message from target            */
-	in_msgincont  = 0x24,  /* Eating more msg bytes from target     */
-	in_msgindone  = 0x25,  /* Decide what to do with what we got    */
-	in_msgout     = 0x26,  /* Sending message to target             */
-	in_msgoutdone = 0x27,  /* Done sending msg out                  */
-	in_cmdbegin   = 0x28,  /* Sending cmd after abnormal selection  */
-	in_cmdend     = 0x29,  /* Done sending slow cmd                 */
-	in_status     = 0x2a,  /* Was in status phase, finishing cmd    */
-	in_freeing    = 0x2b,  /* freeing the bus for cmd cmplt or disc */
-	in_the_dark   = 0x2c,  /* Don't know what bus phase we are in   */
-
-	/* Special states, ie. not normal bus transitions... */
-#define in_spec_mask    0x80
-	in_abortone   = 0x80,  /* Aborting one command currently        */
-	in_abortall   = 0x81,  /* Blowing away all commands we have     */
-	in_resetdev   = 0x82,  /* SCSI target reset in progress         */
-	in_resetbus   = 0x83,  /* SCSI bus reset in progress            */
-	in_tgterror   = 0x84,  /* Target did something stupid           */
-};
+#include "esp.h"
 
-enum {
-	/* Zero has special meaning, see skipahead[12]. */
-/*0*/	do_never,
+#define DRV_MODULE_NAME		"esp"
+#define PFX DRV_MODULE_NAME	": "
+#define DRV_VERSION		"2.000"
+#define DRV_MODULE_RELDATE	"April 19, 2007"
 
-/*1*/	do_phase_determine,
-/*2*/	do_reset_bus,
-/*3*/	do_reset_complete,
-/*4*/	do_work_bus,
-/*5*/	do_intr_end
-};
+/* SCSI bus reset settle time in seconds.  */
+static int esp_bus_reset_settle = 3;
 
-/* Forward declarations. */
-static irqreturn_t esp_intr(int irq, void *dev_id);
-
-/* Debugging routines */
-struct esp_cmdstrings {
-	u8 cmdchar;
-	char *text;
-} esp_cmd_strings[] = {
-	/* Miscellaneous */
-	{ ESP_CMD_NULL, "ESP_NOP", },
-	{ ESP_CMD_FLUSH, "FIFO_FLUSH", },
-	{ ESP_CMD_RC, "RSTESP", },
-	{ ESP_CMD_RS, "RSTSCSI", },
-	/* Disconnected State Group */
-	{ ESP_CMD_RSEL, "RESLCTSEQ", },
-	{ ESP_CMD_SEL, "SLCTNATN", },
-	{ ESP_CMD_SELA, "SLCTATN", },
-	{ ESP_CMD_SELAS, "SLCTATNSTOP", },
-	{ ESP_CMD_ESEL, "ENSLCTRESEL", },
-	{ ESP_CMD_DSEL, "DISSELRESEL", },
-	{ ESP_CMD_SA3, "SLCTATN3", },
-	{ ESP_CMD_RSEL3, "RESLCTSEQ", },
-	/* Target State Group */
-	{ ESP_CMD_SMSG, "SNDMSG", },
-	{ ESP_CMD_SSTAT, "SNDSTATUS", },
-	{ ESP_CMD_SDATA, "SNDDATA", },
-	{ ESP_CMD_DSEQ, "DISCSEQ", },
-	{ ESP_CMD_TSEQ, "TERMSEQ", },
-	{ ESP_CMD_TCCSEQ, "TRGTCMDCOMPSEQ", },
-	{ ESP_CMD_DCNCT, "DISC", },
-	{ ESP_CMD_RMSG, "RCVMSG", },
-	{ ESP_CMD_RCMD, "RCVCMD", },
-	{ ESP_CMD_RDATA, "RCVDATA", },
-	{ ESP_CMD_RCSEQ, "RCVCMDSEQ", },
-	/* Initiator State Group */
-	{ ESP_CMD_TI, "TRANSINFO", },
-	{ ESP_CMD_ICCSEQ, "INICMDSEQCOMP", },
-	{ ESP_CMD_MOK, "MSGACCEPTED", },
-	{ ESP_CMD_TPAD, "TPAD", },
-	{ ESP_CMD_SATN, "SATN", },
-	{ ESP_CMD_RATN, "RATN", },
-};
-#define NUM_ESP_COMMANDS  ((sizeof(esp_cmd_strings)) / (sizeof(struct esp_cmdstrings)))
+static u32 esp_debug;
+#define ESP_DEBUG_INTR		0x00000001
+#define ESP_DEBUG_SCSICMD	0x00000002
+#define ESP_DEBUG_RESET		0x00000004
+#define ESP_DEBUG_MSGIN		0x00000008
+#define ESP_DEBUG_MSGOUT	0x00000010
+#define ESP_DEBUG_CMDDONE	0x00000020
+#define ESP_DEBUG_DISCONNECT	0x00000040
+#define ESP_DEBUG_DATASTART	0x00000080
+#define ESP_DEBUG_DATADONE	0x00000100
+#define ESP_DEBUG_RECONNECT	0x00000200
+#define ESP_DEBUG_AUTOSENSE	0x00000400
 
-/* Print textual representation of an ESP command */
-static inline void esp_print_cmd(u8 espcmd)
-{
-	u8 dma_bit = espcmd & ESP_CMD_DMA;
-	int i;
+#define esp_log_intr(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_INTR) \
+		printk(f, ## a); \
+} while (0)
 
-	espcmd &= ~dma_bit;
-	for (i = 0; i < NUM_ESP_COMMANDS; i++)
-		if (esp_cmd_strings[i].cmdchar == espcmd)
-			break;
-	if (i == NUM_ESP_COMMANDS)
-		printk("ESP_Unknown");
-	else
-		printk("%s%s", esp_cmd_strings[i].text,
-		       ((dma_bit) ? "+DMA" : ""));
-}
+#define esp_log_reset(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_RESET) \
+		printk(f, ## a); \
+} while (0)
 
-/* Print the status register's value */
-static inline void esp_print_statreg(u8 statreg)
-{
-	u8 phase;
+#define esp_log_msgin(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_MSGIN) \
+		printk(f, ## a); \
+} while (0)
 
-	printk("STATUS<");
-	phase = statreg & ESP_STAT_PMASK;
-	printk("%s,", (phase == ESP_DOP ? "DATA-OUT" :
-		       (phase == ESP_DIP ? "DATA-IN" :
-			(phase == ESP_CMDP ? "COMMAND" :
-			 (phase == ESP_STATP ? "STATUS" :
-			  (phase == ESP_MOP ? "MSG-OUT" :
-			   (phase == ESP_MIP ? "MSG_IN" :
-			    "unknown")))))));
-	if (statreg & ESP_STAT_TDONE)
-		printk("TRANS_DONE,");
-	if (statreg & ESP_STAT_TCNT)
-		printk("TCOUNT_ZERO,");
-	if (statreg & ESP_STAT_PERR)
-		printk("P_ERROR,");
-	if (statreg & ESP_STAT_SPAM)
-		printk("SPAM,");
-	if (statreg & ESP_STAT_INTR)
-		printk("IRQ,");
-	printk(">");
-}
+#define esp_log_msgout(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_MSGOUT) \
+		printk(f, ## a); \
+} while (0)
 
-/* Print the interrupt register's value */
-static inline void esp_print_ireg(u8 intreg)
-{
-	printk("INTREG< ");
-	if (intreg & ESP_INTR_S)
-		printk("SLCT_NATN ");
-	if (intreg & ESP_INTR_SATN)
-		printk("SLCT_ATN ");
-	if (intreg & ESP_INTR_RSEL)
-		printk("RSLCT ");
-	if (intreg & ESP_INTR_FDONE)
-		printk("FDONE ");
-	if (intreg & ESP_INTR_BSERV)
-		printk("BSERV ");
-	if (intreg & ESP_INTR_DC)
-		printk("DISCNCT ");
-	if (intreg & ESP_INTR_IC)
-		printk("ILL_CMD ");
-	if (intreg & ESP_INTR_SR)
-		printk("SCSI_BUS_RESET ");
-	printk(">");
-}
+#define esp_log_cmddone(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_CMDDONE) \
+		printk(f, ## a); \
+} while (0)
 
-/* Print the sequence step registers contents */
-static inline void esp_print_seqreg(u8 stepreg)
-{
-	stepreg &= ESP_STEP_VBITS;
-	printk("STEP<%s>",
-	       (stepreg == ESP_STEP_ASEL ? "SLCT_ARB_CMPLT" :
-		(stepreg == ESP_STEP_SID ? "1BYTE_MSG_SENT" :
-		 (stepreg == ESP_STEP_NCMD ? "NOT_IN_CMD_PHASE" :
-		  (stepreg == ESP_STEP_PPC ? "CMD_BYTES_LOST" :
-		   (stepreg == ESP_STEP_FINI4 ? "CMD_SENT_OK" :
-		    "UNKNOWN"))))));
-}
+#define esp_log_disconnect(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_DISCONNECT) \
+		printk(f, ## a); \
+} while (0)
 
-static char *phase_string(int phase)
-{
-	switch (phase) {
-	case not_issued:
-		return "UNISSUED";
-	case in_slct_norm:
-		return "SLCTNORM";
-	case in_slct_stop:
-		return "SLCTSTOP";
-	case in_slct_msg:
-		return "SLCTMSG";
-	case in_slct_tag:
-		return "SLCTTAG";
-	case in_slct_sneg:
-		return "SLCTSNEG";
-	case in_datain:
-		return "DATAIN";
-	case in_dataout:
-		return "DATAOUT";
-	case in_data_done:
-		return "DATADONE";
-	case in_msgin:
-		return "MSGIN";
-	case in_msgincont:
-		return "MSGINCONT";
-	case in_msgindone:
-		return "MSGINDONE";
-	case in_msgout:
-		return "MSGOUT";
-	case in_msgoutdone:
-		return "MSGOUTDONE";
-	case in_cmdbegin:
-		return "CMDBEGIN";
-	case in_cmdend:
-		return "CMDEND";
-	case in_status:
-		return "STATUS";
-	case in_freeing:
-		return "FREEING";
-	case in_the_dark:
-		return "CLUELESS";
-	case in_abortone:
-		return "ABORTONE";
-	case in_abortall:
-		return "ABORTALL";
-	case in_resetdev:
-		return "RESETDEV";
-	case in_resetbus:
-		return "RESETBUS";
-	case in_tgterror:
-		return "TGTERROR";
-	default:
-		return "UNKNOWN";
-	};
-}
+#define esp_log_datastart(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_DATASTART) \
+		printk(f, ## a); \
+} while (0)
 
-#ifdef DEBUG_STATE_MACHINE
-static inline void esp_advance_phase(struct scsi_cmnd *s, int newphase)
-{
-	ESPLOG(("<%s>", phase_string(newphase)));
-	s->SCp.sent_command = s->SCp.phase;
-	s->SCp.phase = newphase;
-}
-#else
-#define esp_advance_phase(__s, __newphase) \
-	(__s)->SCp.sent_command = (__s)->SCp.phase; \
-	(__s)->SCp.phase = (__newphase);
-#endif
-
-#ifdef DEBUG_ESP_CMDS
-static inline void esp_cmd(struct esp *esp, u8 cmd)
-{
-	esp->espcmdlog[esp->espcmdent] = cmd;
-	esp->espcmdent = (esp->espcmdent + 1) & 31;
-	sbus_writeb(cmd, esp->eregs + ESP_CMD);
-}
-#else
-#define esp_cmd(__esp, __cmd)	\
-	sbus_writeb((__cmd), ((__esp)->eregs) + ESP_CMD)
-#endif
-
-#define ESP_INTSOFF(__dregs)	\
-	sbus_writel(sbus_readl((__dregs)+DMA_CSR)&~(DMA_INT_ENAB), (__dregs)+DMA_CSR)
-#define ESP_INTSON(__dregs)	\
-	sbus_writel(sbus_readl((__dregs)+DMA_CSR)|DMA_INT_ENAB, (__dregs)+DMA_CSR)
-#define ESP_IRQ_P(__dregs)	\
-	(sbus_readl((__dregs)+DMA_CSR) & (DMA_HNDL_INTR|DMA_HNDL_ERROR))
-
-/* How we use the various Linux SCSI data structures for operation.
- *
- * struct scsi_cmnd:
- *
- *   We keep track of the synchronous capabilities of a target
- *   in the device member, using sync_min_period and
- *   sync_max_offset.  These are the values we directly write
- *   into the ESP registers while running a command.  If offset
- *   is zero the ESP will use asynchronous transfers.
- *   If the borken flag is set we assume we shouldn't even bother
- *   trying to negotiate for synchronous transfer as this target
- *   is really stupid.  If we notice the target is dropping the
- *   bus, and we have been allowing it to disconnect, we clear
- *   the disconnect flag.
- */
+#define esp_log_datadone(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_DATADONE) \
+		printk(f, ## a); \
+} while (0)
 
+#define esp_log_reconnect(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_RECONNECT) \
+		printk(f, ## a); \
+} while (0)
 
-/* Manipulation of the ESP command queues.  Thanks to the aha152x driver
- * and its author, Juergen E. Fischer, for the methods used here.
- * Note that these are per-ESP queues, not global queues like
- * the aha152x driver uses.
- */
-static inline void append_SC(struct scsi_cmnd **SC, struct scsi_cmnd *new_SC)
-{
-	struct scsi_cmnd *end;
-
-	new_SC->host_scribble = (unsigned char *) NULL;
-	if (!*SC)
-		*SC = new_SC;
-	else {
-		for (end=*SC;end->host_scribble;end=(struct scsi_cmnd *)end->host_scribble)
-			;
-		end->host_scribble = (unsigned char *) new_SC;
-	}
-}
+#define esp_log_autosense(f, a...) \
+do {	if (esp_debug & ESP_DEBUG_AUTOSENSE) \
+		printk(f, ## a); \
+} while (0)
 
-static inline void prepend_SC(struct scsi_cmnd **SC, struct scsi_cmnd *new_SC)
+#define esp_read8(REG)		esp->ops->esp_read8(esp, REG)
+#define esp_write8(VAL,REG)	esp->ops->esp_write8(esp, VAL, REG)
+
+static void esp_log_fill_regs(struct esp *esp,
+			      struct esp_event_ent *p)
 {
-	new_SC->host_scribble = (unsigned char *) *SC;
-	*SC = new_SC;
+	p->sreg = esp->sreg;
+	p->seqreg = esp->seqreg;
+	p->sreg2 = esp->sreg2;
+	p->ireg = esp->ireg;
+	p->select_state = esp->select_state;
+	p->event = esp->event;
 }
 
-static inline struct scsi_cmnd *remove_first_SC(struct scsi_cmnd **SC)
+void scsi_esp_cmd(struct esp *esp, u8 val)
 {
-	struct scsi_cmnd *ptr;
-	ptr = *SC;
-	if (ptr)
-		*SC = (struct scsi_cmnd *) (*SC)->host_scribble;
-	return ptr;
+	struct esp_event_ent *p;
+	int idx = esp->esp_event_cur;
+
+	p = &esp->esp_event_log[idx];
+	p->type = ESP_EVENT_TYPE_CMD;
+	p->val = val;
+	esp_log_fill_regs(esp, p);
+
+	esp->esp_event_cur = (idx + 1) & (ESP_EVENT_LOG_SZ - 1);
+
+	esp_write8(val, ESP_CMD);
 }
+EXPORT_SYMBOL(scsi_esp_cmd);
 
-static inline struct scsi_cmnd *remove_SC(struct scsi_cmnd **SC, int target, int lun)
+static void esp_event(struct esp *esp, u8 val)
 {
-	struct scsi_cmnd *ptr, *prev;
-
-	for (ptr = *SC, prev = NULL;
-	     ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
-	     prev = ptr, ptr = (struct scsi_cmnd *) ptr->host_scribble)
-		;
-	if (ptr) {
-		if (prev)
-			prev->host_scribble=ptr->host_scribble;
-		else
-			*SC=(struct scsi_cmnd *)ptr->host_scribble;
-	}
-	return ptr;
+	struct esp_event_ent *p;
+	int idx = esp->esp_event_cur;
+
+	p = &esp->esp_event_log[idx];
+	p->type = ESP_EVENT_TYPE_EVENT;
+	p->val = val;
+	esp_log_fill_regs(esp, p);
+
+	esp->esp_event_cur = (idx + 1) & (ESP_EVENT_LOG_SZ - 1);
+
+	esp->event = val;
 }
 
-/* Resetting various pieces of the ESP scsi driver chipset/buses. */
-static void esp_reset_dma(struct esp *esp)
+static void esp_dump_cmd_log(struct esp *esp)
 {
-	int can_do_burst16, can_do_burst32, can_do_burst64;
-	int can_do_sbus64;
-	u32 tmp;
-
-	can_do_burst16 = (esp->bursts & DMA_BURST16) != 0;
-	can_do_burst32 = (esp->bursts & DMA_BURST32) != 0;
-	can_do_burst64 = 0;
-	can_do_sbus64 = 0;
-	if (sbus_can_dma_64bit(esp->sdev))
-		can_do_sbus64 = 1;
-	if (sbus_can_burst64(esp->sdev))
-		can_do_burst64 = (esp->bursts & DMA_BURST64) != 0;
-
-	/* Punt the DVMA into a known state. */
-	if (esp->dma->revision != dvmahme) {
-		tmp = sbus_readl(esp->dregs + DMA_CSR);
-		sbus_writel(tmp | DMA_RST_SCSI, esp->dregs + DMA_CSR);
-		sbus_writel(tmp & ~DMA_RST_SCSI, esp->dregs + DMA_CSR);
-	}
-	switch (esp->dma->revision) {
-	case dvmahme:
-		/* This is the HME DVMA gate array. */
+	int idx = esp->esp_event_cur;
+	int stop = idx;
 
-		sbus_writel(DMA_RESET_FAS366, esp->dregs + DMA_CSR);
-		sbus_writel(DMA_RST_SCSI, esp->dregs + DMA_CSR);
+	printk(KERN_INFO PFX "esp%d: Dumping command log\n",
+	       esp->host->unique_id);
+	do {
+		struct esp_event_ent *p = &esp->esp_event_log[idx];
 
-		esp->prev_hme_dmacsr = (DMA_PARITY_OFF|DMA_2CLKS|DMA_SCSI_DISAB|DMA_INT_ENAB);
-		esp->prev_hme_dmacsr &= ~(DMA_ENABLE|DMA_ST_WRITE|DMA_BRST_SZ);
+		printk(KERN_INFO PFX "esp%d: ent[%d] %s ",
+		       esp->host->unique_id, idx,
+		       p->type == ESP_EVENT_TYPE_CMD ? "CMD" : "EVENT");
 
-		if (can_do_burst64)
-			esp->prev_hme_dmacsr |= DMA_BRST64;
-		else if (can_do_burst32)
-			esp->prev_hme_dmacsr |= DMA_BRST32;
+		printk("val[%02x] sreg[%02x] seqreg[%02x] "
+		       "sreg2[%02x] ireg[%02x] ss[%02x] event[%02x]\n",
+		       p->val, p->sreg, p->seqreg,
+		       p->sreg2, p->ireg, p->select_state, p->event);
 
-		if (can_do_sbus64) {
-			esp->prev_hme_dmacsr |= DMA_SCSI_SBUS64;
-			sbus_set_sbus64(esp->sdev, esp->bursts);
-		}
+		idx = (idx + 1) & (ESP_EVENT_LOG_SZ - 1);
+	} while (idx != stop);
+}
 
-		/* This chip is horrible. */
-		while (sbus_readl(esp->dregs + DMA_CSR) & DMA_PEND_READ)
+static void esp_flush_fifo(struct esp *esp)
+{
+	scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+	if (esp->rev == ESP236) {
+		int lim = 1000;
+
+		while (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES) {
+			if (--lim == 0) {
+				printk(KERN_ALERT PFX "esp%d: ESP_FF_BYTES "
+				       "will not clear!\n",
+				       esp->host->unique_id);
+				break;
+			}
 			udelay(1);
+		}
+	}
+}
+
+static void hme_read_fifo(struct esp *esp)
+{
+	int fcnt = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
+	int idx = 0;
 
-		sbus_writel(0, esp->dregs + DMA_CSR);
-		sbus_writel(esp->prev_hme_dmacsr, esp->dregs + DMA_CSR);
+	while (fcnt--) {
+		esp->fifo[idx++] = esp_read8(ESP_FDATA);
+		esp->fifo[idx++] = esp_read8(ESP_FDATA);
+	}
+	if (esp->sreg2 & ESP_STAT2_F1BYTE) {
+		esp_write8(0, ESP_FDATA);
+		esp->fifo[idx++] = esp_read8(ESP_FDATA);
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+	}
+	esp->fifo_cnt = idx;
+}
 
-		/* This is necessary to avoid having the SCSI channel
-		 * engine lock up on us.
-		 */
-		sbus_writel(0, esp->dregs + DMA_ADDR);
+static void esp_set_all_config3(struct esp *esp, u8 val)
+{
+	int i;
 
-		break;
-	case dvmarev2:
-		/* This is the gate array found in the sun4m
-		 * NCR SBUS I/O subsystem.
-		 */
-		if (esp->erev != esp100) {
-			tmp = sbus_readl(esp->dregs + DMA_CSR);
-			sbus_writel(tmp | DMA_3CLKS, esp->dregs + DMA_CSR);
-		}
-		break;
-	case dvmarev3:
-		tmp = sbus_readl(esp->dregs + DMA_CSR);
-		tmp &= ~DMA_3CLKS;
-		tmp |= DMA_2CLKS;
-		if (can_do_burst32) {
-			tmp &= ~DMA_BRST_SZ;
-			tmp |= DMA_BRST32;
-		}
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-		break;
-	case dvmaesc1:
-		/* This is the DMA unit found on SCSI/Ether cards. */
-		tmp = sbus_readl(esp->dregs + DMA_CSR);
-		tmp |= DMA_ADD_ENABLE;
-		tmp &= ~DMA_BCNT_ENAB;
-		if (!can_do_burst32 && can_do_burst16) {
-			tmp |= DMA_ESC_BURST;
-		} else {
-			tmp &= ~(DMA_ESC_BURST);
-		}
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-		break;
-	default:
-		break;
-	};
-	ESP_INTSON(esp->dregs);
+	for (i = 0; i < ESP_MAX_TARGET; i++)
+		esp->target[i].esp_config3 = val;
 }
 
 /* Reset the ESP chip, _not_ the SCSI bus. */
-static void __init esp_reset_esp(struct esp *esp)
+static void esp_reset_esp(struct esp *esp)
 {
 	u8 family_code, version;
-	int i;
 
 	/* Now reset the ESP chip */
-	esp_cmd(esp, ESP_CMD_RC);
-	esp_cmd(esp, ESP_CMD_NULL | ESP_CMD_DMA);
-	esp_cmd(esp, ESP_CMD_NULL | ESP_CMD_DMA);
+	scsi_esp_cmd(esp, ESP_CMD_RC);
+	scsi_esp_cmd(esp, ESP_CMD_NULL | ESP_CMD_DMA);
+	scsi_esp_cmd(esp, ESP_CMD_NULL | ESP_CMD_DMA);
 
 	/* Reload the configuration registers */
-	sbus_writeb(esp->cfact, esp->eregs + ESP_CFACT);
+	esp_write8(esp->cfact, ESP_CFACT);
+
 	esp->prev_stp = 0;
-	sbus_writeb(esp->prev_stp, esp->eregs + ESP_STP);
+	esp_write8(esp->prev_stp, ESP_STP);
+
 	esp->prev_soff = 0;
-	sbus_writeb(esp->prev_soff, esp->eregs + ESP_SOFF);
-	sbus_writeb(esp->neg_defp, esp->eregs + ESP_TIMEO);
+	esp_write8(esp->prev_soff, ESP_SOFF);
+
+	esp_write8(esp->neg_defp, ESP_TIMEO);
 
 	/* This is the only point at which it is reliable to read
 	 * the ID-code for a fast ESP chip variants.
 	 */
 	esp->max_period = ((35 * esp->ccycle) / 1000);
-	if (esp->erev == fast) {
-		version = sbus_readb(esp->eregs + ESP_UID);
+	if (esp->rev == FAST) {
+		version = esp_read8(ESP_UID);
 		family_code = (version & 0xf8) >> 3;
 		if (family_code == 0x02)
-			esp->erev = fas236;
+			esp->rev = FAS236;
 		else if (family_code == 0x0a)
-			esp->erev = fashme; /* Version is usually '5'. */
+			esp->rev = FASHME; /* Version is usually '5'. */
 		else
-			esp->erev = fas100a;
-		ESPMISC(("esp%d: FAST chip is %s (family=%d, version=%d)\n",
-			 esp->esp_id,
-			 (esp->erev == fas236) ? "fas236" :
-			 ((esp->erev == fas100a) ? "fas100a" :
-			  "fasHME"), family_code, (version & 7)));
-
+			esp->rev = FAS100A;
 		esp->min_period = ((4 * esp->ccycle) / 1000);
 	} else {
 		esp->min_period = ((5 * esp->ccycle) / 1000);
@@ -600,3795 +251,2571 @@ static void __init esp_reset_esp(struct esp *esp)
 	esp->max_period = (esp->max_period + 3)>>2;
 	esp->min_period = (esp->min_period + 3)>>2;
 
-	sbus_writeb(esp->config1, esp->eregs + ESP_CFG1);
-	switch (esp->erev) {
-	case esp100:
+	esp_write8(esp->config1, ESP_CFG1);
+	switch (esp->rev) {
+	case ESP100:
 		/* nothing to do */
 		break;
-	case esp100a:
-		sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
+
+	case ESP100A:
+		esp_write8(esp->config2, ESP_CFG2);
 		break;
-	case esp236:
+
+	case ESP236:
 		/* Slow 236 */
-		sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
-		esp->prev_cfg3 = esp->config3[0];
-		sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
+		esp_write8(esp->config2, ESP_CFG2);
+		esp->prev_cfg3 = esp->target[0].esp_config3;
+		esp_write8(esp->prev_cfg3, ESP_CFG3);
 		break;
-	case fashme:
+
+	case FASHME:
 		esp->config2 |= (ESP_CONFIG2_HME32 | ESP_CONFIG2_HMEFENAB);
 		/* fallthrough... */
-	case fas236:
+
+	case FAS236:
 		/* Fast 236 or HME */
-		sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
-		for (i = 0; i < 16; i++) {
-			if (esp->erev == fashme) {
-				u8 cfg3;
-
-				cfg3 = ESP_CONFIG3_FCLOCK | ESP_CONFIG3_OBPUSH;
-				if (esp->scsi_id >= 8)
-					cfg3 |= ESP_CONFIG3_IDBIT3;
-				esp->config3[i] |= cfg3;
-			} else {
-				esp->config3[i] |= ESP_CONFIG3_FCLK;
-			}
+		esp_write8(esp->config2, ESP_CFG2);
+		if (esp->rev == FASHME) {
+			u8 cfg3 = esp->target[0].esp_config3;
+
+			cfg3 |= ESP_CONFIG3_FCLOCK | ESP_CONFIG3_OBPUSH;
+			if (esp->scsi_id >= 8)
+				cfg3 |= ESP_CONFIG3_IDBIT3;
+			esp_set_all_config3(esp, cfg3);
+		} else {
+			u32 cfg3 = esp->target[0].esp_config3;
+
+			cfg3 |= ESP_CONFIG3_FCLK;
+			esp_set_all_config3(esp, cfg3);
 		}
-		esp->prev_cfg3 = esp->config3[0];
-		sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-		if (esp->erev == fashme) {
+		esp->prev_cfg3 = esp->target[0].esp_config3;
+		esp_write8(esp->prev_cfg3, ESP_CFG3);
+		if (esp->rev == FASHME) {
 			esp->radelay = 80;
 		} else {
-			if (esp->diff)
+			if (esp->flags & ESP_FLAG_DIFFERENTIAL)
 				esp->radelay = 0;
 			else
 				esp->radelay = 96;
 		}
 		break;
-	case fas100a:
+
+	case FAS100A:
 		/* Fast 100a */
-		sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
-		for (i = 0; i < 16; i++)
-			esp->config3[i] |= ESP_CONFIG3_FCLOCK;
-		esp->prev_cfg3 = esp->config3[0];
-		sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
+		esp_write8(esp->config2, ESP_CFG2);
+		esp_set_all_config3(esp,
+				    (esp->target[0].esp_config3 |
+				     ESP_CONFIG3_FCLOCK));
+		esp->prev_cfg3 = esp->target[0].esp_config3;
+		esp_write8(esp->prev_cfg3, ESP_CFG3);
 		esp->radelay = 32;
 		break;
+
 	default:
-		panic("esp: what could it be... I wonder...");
 		break;
-	};
+	}
 
 	/* Eat any bitrot in the chip */
-	sbus_readb(esp->eregs + ESP_INTRPT);
+	esp_read8(ESP_INTRPT);
 	udelay(100);
 }
 
-/* This places the ESP into a known state at boot time. */
-static void __init esp_bootup_reset(struct esp *esp)
+static void esp_map_dma(struct esp *esp, struct scsi_cmnd *cmd)
 {
-	u8 tmp;
+	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
+	int dir = cmd->sc_data_direction;
 
-	/* Reset the DMA */
-	esp_reset_dma(esp);
-
-	/* Reset the ESP */
-	esp_reset_esp(esp);
-
-	/* Reset the SCSI bus, but tell ESP not to generate an irq */
-	tmp = sbus_readb(esp->eregs + ESP_CFG1);
-	tmp |= ESP_CONFIG1_SRRDISAB;
-	sbus_writeb(tmp, esp->eregs + ESP_CFG1);
+	if (dir == DMA_NONE)
+		return;
 
-	esp_cmd(esp, ESP_CMD_RS);
-	udelay(400);
+	if (cmd->use_sg == 0) {
+		spriv->u.dma_addr = esp->ops->map_single(esp,
+							 cmd->request_buffer,
+							 cmd->request_bufflen,
+							 dir);
+		spriv->mapping_type = MAPPING_TYPE_SINGLE;
+		spriv->tot_residue = spriv->cur_residue = cmd->request_bufflen;
+		spriv->cur_sg = NULL;
+	} else {
+		struct scatterlist *sg = cmd->request_buffer;
+		int total, i;
 
-	sbus_writeb(esp->config1, esp->eregs + ESP_CFG1);
+		spriv->u.num_sg = esp->ops->map_sg(esp, sg,
+						   cmd->use_sg, dir);
+		spriv->mapping_type = MAPPING_TYPE_SG;
+		spriv->cur_residue = sg_dma_len(sg);
+		spriv->cur_sg = sg;
 
-	/* Eat any bitrot in the chip and we are done... */
-	sbus_readb(esp->eregs + ESP_INTRPT);
+		total = 0;
+		for (i = 0; i < spriv->u.num_sg; i++)
+			total += sg_dma_len(&sg[i]);
+		spriv->tot_residue = total;
+	}
 }
 
-static int __init esp_find_dvma(struct esp *esp, struct sbus_dev *dma_sdev)
+static dma_addr_t esp_cur_dma_addr(struct esp_cmd_entry *ent,
+				   struct scsi_cmnd *cmd)
 {
-	struct sbus_dev *sdev = esp->sdev;
-	struct sbus_dma *dma;
+	struct esp_cmd_priv *p = ESP_CMD_PRIV(cmd);
 
-	if (dma_sdev != NULL) {
-		for_each_dvma(dma) {
-			if (dma->sdev == dma_sdev)
-				break;
-		}
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		return ent->sense_dma +
+			(ent->sense_ptr - cmd->sense_buffer);
+	}
+	if (p->mapping_type == MAPPING_TYPE_SINGLE) {
+		return p->u.dma_addr +
+			(cmd->request_bufflen -
+			 p->cur_residue);
 	} else {
-		for_each_dvma(dma) {
-			/* If allocated already, can't use it. */
-			if (dma->allocated)
-				continue;
+		/* MAPPING_TYPE_SG */
+		return sg_dma_address(p->cur_sg) +
+			(sg_dma_len(p->cur_sg) -
+			 p->cur_residue);
+	}
+}
 
-			if (dma->sdev == NULL)
-				break;
+static unsigned int esp_cur_dma_len(struct esp_cmd_entry *ent,
+				    struct scsi_cmnd *cmd)
+{
+	struct esp_cmd_priv *p = ESP_CMD_PRIV(cmd);
 
-			/* If bus + slot are the same and it has the
-			 * correct OBP name, it's ours.
-			 */
-			if (sdev->bus == dma->sdev->bus &&
-			    sdev->slot == dma->sdev->slot &&
-			    (!strcmp(dma->sdev->prom_name, "dma") ||
-			     !strcmp(dma->sdev->prom_name, "espdma")))
-				break;
-		}
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		return SCSI_SENSE_BUFFERSIZE -
+			(ent->sense_ptr - cmd->sense_buffer);
 	}
+	return p->cur_residue;
+}
 
-	/* If we don't know how to handle the dvma,
-	 * do not use this device.
-	 */
-	if (dma == NULL) {
-		printk("Cannot find dvma for ESP%d's SCSI\n", esp->esp_id);
-		return -1;
-	}
-	if (dma->allocated) {
-		printk("esp%d: can't use my espdma\n", esp->esp_id);
-		return -1;
+static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
+			    struct scsi_cmnd *cmd, unsigned int len)
+{
+	struct esp_cmd_priv *p = ESP_CMD_PRIV(cmd);
+
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		ent->sense_ptr += len;
+		return;
 	}
-	dma->allocated = 1;
-	esp->dma = dma;
-	esp->dregs = dma->regs;
 
-	return 0;
+	p->cur_residue -= len;
+	p->tot_residue -= len;
+	if (p->cur_residue < 0 || p->tot_residue < 0) {
+		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
+		       esp->host->unique_id);
+		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "
+		       "len[%u]\n",
+		       esp->host->unique_id,
+		       p->cur_residue, p->tot_residue, len);
+		p->cur_residue = 0;
+		p->tot_residue = 0;
+	}
+	if (p->mapping_type == MAPPING_TYPE_SG) {
+		if (!p->cur_residue && p->tot_residue) {
+			p->cur_sg++;
+			p->cur_residue = sg_dma_len(p->cur_sg);
+		}
+	}
 }
 
-static int __init esp_map_regs(struct esp *esp, int hme)
+static void esp_unmap_dma(struct esp *esp, struct scsi_cmnd *cmd)
 {
-	struct sbus_dev *sdev = esp->sdev;
-	struct resource *res;
+	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
+	int dir = cmd->sc_data_direction;
 
-	/* On HME, two reg sets exist, first is DVMA,
-	 * second is ESP registers.
-	 */
-	if (hme)
-		res = &sdev->resource[1];
-	else
-		res = &sdev->resource[0];
+	switch (spriv->mapping_type) {
+	case MAPPING_TYPE_SINGLE:
+		esp->ops->unmap_single(esp, spriv->u.dma_addr,
+				       cmd->request_bufflen, dir);
+		break;
 
-	esp->eregs = sbus_ioremap(res, 0, ESP_REG_SIZE, "ESP Registers");
+	case MAPPING_TYPE_SG:
+		esp->ops->unmap_sg(esp, cmd->request_buffer,
+				   spriv->u.num_sg, dir);
+		break;
 
-	if (esp->eregs == 0)
-		return -1;
-	return 0;
+	case MAPPING_TYPE_NONE:
+	default:
+		break;
+	}
 }
 
-static int __init esp_map_cmdarea(struct esp *esp)
+static void esp_save_pointers(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	struct sbus_dev *sdev = esp->sdev;
+	struct scsi_cmnd *cmd = ent->cmd;
+	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
 
-	esp->esp_command = sbus_alloc_consistent(sdev, 16,
-						 &esp->esp_command_dvma);
-	if (esp->esp_command == NULL ||
-	    esp->esp_command_dvma == 0)
-		return -1;
-	return 0;
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		ent->saved_sense_ptr = ent->sense_ptr;
+		return;
+	}
+	ent->saved_cur_residue = spriv->cur_residue;
+	ent->saved_cur_sg = spriv->cur_sg;
+	ent->saved_tot_residue = spriv->tot_residue;
 }
 
-static int __init esp_register_irq(struct esp *esp)
+static void esp_restore_pointers(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	esp->ehost->irq = esp->irq = esp->sdev->irqs[0];
+	struct scsi_cmnd *cmd = ent->cmd;
+	struct esp_cmd_priv *spriv = ESP_CMD_PRIV(cmd);
 
-	/* We used to try various overly-clever things to
-	 * reduce the interrupt processing overhead on
-	 * sun4c/sun4m when multiple ESP's shared the
-	 * same IRQ.  It was too complex and messy to
-	 * sanely maintain.
-	 */
-	if (request_irq(esp->ehost->irq, esp_intr,
-			IRQF_SHARED, "ESP SCSI", esp)) {
-		printk("esp%d: Cannot acquire irq line\n",
-		       esp->esp_id);
-		return -1;
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		ent->sense_ptr = ent->saved_sense_ptr;
+		return;
 	}
-
-	printk("esp%d: IRQ %d ", esp->esp_id,
-	       esp->ehost->irq);
-
-	return 0;
+	spriv->cur_residue = ent->saved_cur_residue;
+	spriv->cur_sg = ent->saved_cur_sg;
+	spriv->tot_residue = ent->saved_tot_residue;
 }
 
-static void __init esp_get_scsi_id(struct esp *esp)
+static void esp_build_sync_msg(struct esp *esp, u8 period, u8 offset)
 {
-	struct sbus_dev *sdev = esp->sdev;
-	struct device_node *dp = sdev->ofdev.node;
-
-	esp->scsi_id = of_getintprop_default(dp,
-					     "initiator-id",
-					     -1);
-	if (esp->scsi_id == -1)
-		esp->scsi_id = of_getintprop_default(dp,
-						     "scsi-initiator-id",
-						     -1);
-	if (esp->scsi_id == -1)
-		esp->scsi_id = (sdev->bus == NULL) ? 7 :
-			of_getintprop_default(sdev->bus->ofdev.node,
-					      "scsi-initiator-id",
-					      7);
-	esp->ehost->this_id = esp->scsi_id;
-	esp->scsi_id_mask = (1 << esp->scsi_id);
+	esp->msg_out[0] = EXTENDED_MESSAGE;
+	esp->msg_out[1] = 3;
+	esp->msg_out[2] = EXTENDED_SDTR;
+	esp->msg_out[3] = period;
+	esp->msg_out[4] = offset;
+	esp->msg_out_len = 5;
+}
 
+static void esp_build_wide_msg(struct esp *esp, int wide)
+{
+	esp->msg_out[0] = EXTENDED_MESSAGE;
+	esp->msg_out[1] = 2;
+	esp->msg_out[2] = EXTENDED_WDTR;
+	esp->msg_out[3] = (wide ? 1 : 0);
+	esp->msg_out_len = 4;
 }
 
-static void __init esp_get_clock_params(struct esp *esp)
+static void esp_check_command_len(struct esp *esp, struct scsi_cmnd *cmd)
 {
-	struct sbus_dev *sdev = esp->sdev;
-	int prom_node = esp->prom_node;
-	int sbus_prom_node;
-	unsigned int fmhz;
-	u8 ccf;
+	if (cmd->cmd_len == 6 ||
+	    cmd->cmd_len == 10 ||
+	    cmd->cmd_len == 12) {
+		esp->flags &= ~ESP_FLAG_DOING_SLOWCMD;
+	} else {
+		esp->flags |= ESP_FLAG_DOING_SLOWCMD;
+	}
+}
 
-	if (sdev != NULL && sdev->bus != NULL)
-		sbus_prom_node = sdev->bus->prom_node;
-	else
-		sbus_prom_node = 0;
+static void esp_write_tgt_config3(struct esp *esp, int tgt)
+{
+	if (esp->rev > ESP100A) {
+		u8 val = esp->target[tgt].esp_config3;
 
-	/* This is getting messy but it has to be done
-	 * correctly or else you get weird behavior all
-	 * over the place.  We are trying to basically
-	 * figure out three pieces of information.
-	 *
-	 * a) Clock Conversion Factor
-	 *
-	 *    This is a representation of the input
-	 *    crystal clock frequency going into the
-	 *    ESP on this machine.  Any operation whose
-	 *    timing is longer than 400ns depends on this
-	 *    value being correct.  For example, you'll
-	 *    get blips for arbitration/selection during
-	 *    high load or with multiple targets if this
-	 *    is not set correctly.
-	 *
-	 * b) Selection Time-Out
-	 *
-	 *    The ESP isn't very bright and will arbitrate
-	 *    for the bus and try to select a target
-	 *    forever if you let it.  This value tells
-	 *    the ESP when it has taken too long to
-	 *    negotiate and that it should interrupt
-	 *    the CPU so we can see what happened.
-	 *    The value is computed as follows (from
-	 *    NCR/Symbios chip docs).
-	 *
-	 *          (Time Out Period) *  (Input Clock)
-	 *    STO = ----------------------------------
-	 *          (8192) * (Clock Conversion Factor)
-	 *
-	 *    You usually want the time out period to be
-	 *    around 250ms, I think we'll set it a little
-	 *    bit higher to account for fully loaded SCSI
-	 *    bus's and slow devices that don't respond so
-	 *    quickly to selection attempts. (yeah, I know
-	 *    this is out of spec. but there is a lot of
-	 *    buggy pieces of firmware out there so bite me)
-	 *
-	 * c) Imperical constants for synchronous offset
-	 *    and transfer period register values
-	 *
-	 *    This entails the smallest and largest sync
-	 *    period we could ever handle on this ESP.
-	 */
+		if (val != esp->prev_cfg3) {
+			esp->prev_cfg3 = val;
+			esp_write8(val, ESP_CFG3);
+		}
+	}
+}
 
-	fmhz = prom_getintdefault(prom_node, "clock-frequency", -1);
-	if (fmhz == -1)
-		fmhz = (!sbus_prom_node) ? 0 :
-			prom_getintdefault(sbus_prom_node, "clock-frequency", -1);
+static void esp_write_tgt_sync(struct esp *esp, int tgt)
+{
+	u8 off = esp->target[tgt].esp_offset;
+	u8 per = esp->target[tgt].esp_period;
 
-	if (fmhz <= (5000000))
-		ccf = 0;
-	else
-		ccf = (((5000000 - 1) + (fmhz))/(5000000));
-
-	if (!ccf || ccf > 8) {
-		/* If we can't find anything reasonable,
-		 * just assume 20MHZ.  This is the clock
-		 * frequency of the older sun4c's where I've
-		 * been unable to find the clock-frequency
-		 * PROM property.  All other machines provide
-		 * useful values it seems.
-		 */
-		ccf = ESP_CCF_F4;
-		fmhz = (20000000);
+	if (off != esp->prev_soff) {
+		esp->prev_soff = off;
+		esp_write8(off, ESP_SOFF);
+	}
+	if (per != esp->prev_stp) {
+		esp->prev_stp = per;
+		esp_write8(per, ESP_STP);
 	}
+}
 
-	if (ccf == (ESP_CCF_F7 + 1))
-		esp->cfact = ESP_CCF_F0;
-	else if (ccf == ESP_CCF_NEVER)
-		esp->cfact = ESP_CCF_F2;
-	else
-		esp->cfact = ccf;
-	esp->raw_cfact = ccf;
+static u32 esp_dma_length_limit(struct esp *esp, u32 dma_addr, u32 dma_len)
+{
+	if (esp->rev == FASHME) {
+		/* Arbitrary segment boundaries, 24-bit counts.  */
+		if (dma_len > (1U << 24))
+			dma_len = (1U << 24);
+	} else {
+		u32 base, end;
 
-	esp->cfreq = fmhz;
-	esp->ccycle = ESP_MHZ_TO_CYCLE(fmhz);
-	esp->ctick = ESP_TICK(ccf, esp->ccycle);
-	esp->neg_defp = ESP_NEG_DEFP(fmhz, ccf);
-	esp->sync_defp = SYNC_DEFP_SLOW;
+		/* ESP chip limits other variants by 16-bits of transfer
+		 * count.  Actually on FAS100A and FAS236 we could get
+		 * 24-bits of transfer count by enabling ESP_CONFIG2_FENAB
+		 * in the ESP_CFG2 register but that causes other unwanted
+		 * changes so we don't use it currently.
+		 */
+		if (dma_len > (1U << 16))
+			dma_len = (1U << 16);
 
-	printk("SCSI ID %d Clk %dMHz CCYC=%d CCF=%d TOut %d ",
-	       esp->scsi_id, (fmhz / 1000000),
-	       (int)esp->ccycle, (int)ccf, (int) esp->neg_defp);
+		/* All of the DMA variants hooked up to these chips
+		 * cannot handle crossing a 24-bit address boundary.
+		 */
+		base = dma_addr & ((1U << 24) - 1U);
+		end = base + dma_len;
+		if (end > (1U << 24))
+			end = (1U <<24);
+		dma_len = end - base;
+	}
+	return dma_len;
 }
 
-static void __init esp_get_bursts(struct esp *esp, struct sbus_dev *dma)
+static int esp_need_to_nego_wide(struct esp_target_data *tp)
 {
-	struct sbus_dev *sdev = esp->sdev;
-	u8 bursts;
+	struct scsi_target *target = tp->starget;
 
-	bursts = prom_getintdefault(esp->prom_node, "burst-sizes", 0xff);
+	return spi_width(target) != tp->nego_goal_width;
+}
 
-	if (dma) {
-		u8 tmp = prom_getintdefault(dma->prom_node,
-					    "burst-sizes", 0xff);
-		if (tmp != 0xff)
-			bursts &= tmp;
-	}
+static int esp_need_to_nego_sync(struct esp_target_data *tp)
+{
+	struct scsi_target *target = tp->starget;
 
-	if (sdev->bus) {
-		u8 tmp = prom_getintdefault(sdev->bus->prom_node,
-					    "burst-sizes", 0xff);
-		if (tmp != 0xff)
-			bursts &= tmp;
-	}
+	/* When offset is zero, period is "don't care".  */
+	if (!spi_offset(target) && !tp->nego_goal_offset)
+		return 0;
 
-	if (bursts == 0xff ||
-	    (bursts & DMA_BURST16) == 0 ||
-	    (bursts & DMA_BURST32) == 0)
-		bursts = (DMA_BURST32 - 1);
+	if (spi_offset(target) == tp->nego_goal_offset &&
+	    spi_period(target) == tp->nego_goal_period)
+		return 0;
 
-	esp->bursts = bursts;
+	return 1;
 }
 
-static void __init esp_get_revision(struct esp *esp)
-{
-	u8 tmp;
-
-	esp->config1 = (ESP_CONFIG1_PENABLE | (esp->scsi_id & 7));
-	esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
-	sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
-
-	tmp = sbus_readb(esp->eregs + ESP_CFG2);
-	tmp &= ~ESP_CONFIG2_MAGIC;
-	if (tmp != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
-		/* If what we write to cfg2 does not come back, cfg2
-		 * is not implemented, therefore this must be a plain
-		 * esp100.
+/* If we get a non-tagged command, we let all the current
+ * tagged commands finish out before issuing the non-tagged
+ * one.  I found that if I did not do this, devices would
+ * completely hang.  In fact the SCSI-2 standard is pretty
+ * explicit about this in section 7.8, "Queued I/O processes":
+ *
+ *	... An initiator may not mix the use of tagged and
+ *	untagged queuing for I/O processes to a logical unit,
+ *	except during a contingent allegiance or extended
+ *	contingent allegiance condition when only untagged
+ *	initial connections are allowed.
+ *
+ * The language at the end means that we have to issue REQUEST_SENSE
+ * commands even if tagged ones are pending, because those tagged
+ * commands will be suspended until the REQUEST_SENSE executes.
+ *
+ * When a request comes in here to issue a non-tagged command which is
+ * not a REQUEST_SENSE, we set the per-lun 'hold' state.  The next
+ * time we try to issue for this lun when 'hold' is true but
+ * 'num_tagged' has dropped to zero, we clear 'hold' and issue the
+ * non-tagged command.
+ *
+ * The 'hold' state exists to make sure we do not keep dispatching
+ * more tagged commands, thus starving out the non-tagged one.
+ */
+static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
+			     struct esp_lun_data *lp)
+{
+	if (!lp) {
+		/* When we don't have lun-data yet, we disallow
+		 * disconnects, so we do not have to see if this
+		 * untagged command matches a disconnected one and
+		 * thus return -EBUSY.
 		 */
-		esp->erev = esp100;
-		printk("NCR53C90(esp100)\n");
-	} else {
-		esp->config2 = 0;
-		esp->prev_cfg3 = esp->config3[0] = 5;
-		sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
-		sbus_writeb(0, esp->eregs + ESP_CFG3);
-		sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
+		return 0;
+	}
 
-		tmp = sbus_readb(esp->eregs + ESP_CFG3);
-		if (tmp != 5) {
-			/* The cfg2 register is implemented, however
-			 * cfg3 is not, must be esp100a.
-			 */
-			esp->erev = esp100a;
-			printk("NCR53C90A(esp100a)\n");
-		} else {
-			int target;
+	if (!ent->tag[0]) {
+		/* Non-tagged, slot already taken?  */
+		if (lp->non_tagged_cmd)
+			return -EBUSY;
 
-			for (target = 0; target < 16; target++)
-				esp->config3[target] = 0;
-			esp->prev_cfg3 = 0;
-			sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
+		if (lp->hold) {
+			/* We are being held by active tagged
+			 * commands.
+			 */
+			if (lp->num_tagged)
+				return -EBUSY;
 
-			/* All of cfg{1,2,3} implemented, must be one of
-			 * the fas variants, figure out which one.
+			/* Tagged commands completed, we can unplug
+			 * the queue and run this untagged command.
 			 */
-			if (esp->raw_cfact > ESP_CCF_F5) {
-				esp->erev = fast;
-				esp->sync_defp = SYNC_DEFP_FAST;
-				printk("NCR53C9XF(espfast)\n");
-			} else {
-				esp->erev = esp236;
-				printk("NCR53C9x(esp236)\n");
-			}
-			esp->config2 = 0;
-			sbus_writeb(esp->config2, esp->eregs + ESP_CFG2);
+			lp->hold = 0;
+		} else if (lp->num_tagged) {
+			/* Plug the queue until num_tagged decreases
+			 * to zero in esp_free_lun_tag.
+			 */
+			lp->hold = 1;
+			return -EBUSY;
 		}
-	}
-}
 
-static void __init esp_init_swstate(struct esp *esp)
-{
-	int i;
+		lp->non_tagged_cmd = ent;
+		return 0;
+	} else {
+		/* Tagged command, see if blocked by a
+		 * non-tagged one.
+		 */
+		if (lp->non_tagged_cmd || lp->hold)
+			return -EBUSY;
+	}
 
-	/* Command queues... */
-	esp->current_SC = NULL;
-	esp->disconnected_SC = NULL;
-	esp->issue_SC = NULL;
+	BUG_ON(lp->tagged_cmds[ent->tag[1]]);
 
-	/* Target and current command state... */
-	esp->targets_present = 0;
-	esp->resetting_bus = 0;
-	esp->snip = 0;
+	lp->tagged_cmds[ent->tag[1]] = ent;
+	lp->num_tagged++;
 
-	init_waitqueue_head(&esp->reset_queue);
+	return 0;
+}
 
-	/* Debugging... */
-	for(i = 0; i < 32; i++)
-		esp->espcmdlog[i] = 0;
-	esp->espcmdent = 0;
+static void esp_free_lun_tag(struct esp_cmd_entry *ent,
+			     struct esp_lun_data *lp)
+{
+	if (!lp)
+		return;
 
-	/* MSG phase state... */
-	for(i = 0; i < 16; i++) {
-		esp->cur_msgout[i] = 0;
-		esp->cur_msgin[i] = 0;
+	if (ent->tag[0]) {
+		BUG_ON(lp->tagged_cmds[ent->tag[1]] != ent);
+		lp->tagged_cmds[ent->tag[1]] = NULL;
+		lp->num_tagged--;
+	} else {
+		BUG_ON(lp->non_tagged_cmd != ent);
+		lp->non_tagged_cmd = NULL;
 	}
-	esp->prevmsgout = esp->prevmsgin = 0;
-	esp->msgout_len = esp->msgin_len = 0;
-
-	/* Clear the one behind caches to hold unmatchable values. */
-	esp->prev_soff = esp->prev_stp = esp->prev_cfg3 = 0xff;
-	esp->prev_hme_dmacsr = 0xffffffff;
 }
 
-static int __init detect_one_esp(struct scsi_host_template *tpnt,
-				 struct device *dev,
-				 struct sbus_dev *esp_dev,
-				 struct sbus_dev *espdma,
-				 struct sbus_bus *sbus,
-				 int hme)
+/* When a contingent allegiance conditon is created, we force feed a
+ * REQUEST_SENSE command to the device to fetch the sense data.  I
+ * tried many other schemes, relying on the scsi error handling layer
+ * to send out the REQUEST_SENSE automatically, but this was difficult
+ * to get right especially in the presence of applications like smartd
+ * which use SG_IO to send out their own REQUEST_SENSE commands.
+ */
+static void esp_autosense(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	static int instance;
-	struct Scsi_Host *esp_host = scsi_host_alloc(tpnt, sizeof(struct esp));
-	struct esp *esp;
-	
-	if (!esp_host)
-		return -ENOMEM;
-
-	if (hme)
-		esp_host->max_id = 16;
-	esp = (struct esp *) esp_host->hostdata;
-	esp->ehost = esp_host;
-	esp->sdev = esp_dev;
-	esp->esp_id = instance;
-	esp->prom_node = esp_dev->prom_node;
-	prom_getstring(esp->prom_node, "name", esp->prom_name,
-		       sizeof(esp->prom_name));
-
-	if (esp_find_dvma(esp, espdma) < 0)
-		goto fail_unlink;
-	if (esp_map_regs(esp, hme) < 0) {
-		printk("ESP registers unmappable");
-		goto fail_dvma_release;
-	}
-	if (esp_map_cmdarea(esp) < 0) {
-		printk("ESP DVMA transport area unmappable");
-		goto fail_unmap_regs;
-	}
-	if (esp_register_irq(esp) < 0)
-		goto fail_unmap_cmdarea;
-
-	esp_get_scsi_id(esp);
+	struct scsi_cmnd *cmd = ent->cmd;
+	struct scsi_device *dev = cmd->device;
+	int tgt, lun;
+	u8 *p, val;
 
-	esp->diff = prom_getbool(esp->prom_node, "differential");
-	if (esp->diff)
-		printk("Differential ");
+	tgt = dev->id;
+	lun = dev->lun;
 
-	esp_get_clock_params(esp);
-	esp_get_bursts(esp, espdma);
-	esp_get_revision(esp);
-	esp_init_swstate(esp);
 
-	esp_bootup_reset(esp);
+	if (!ent->sense_ptr) {
+		esp_log_autosense("esp%d: Doing auto-sense for "
+				  "tgt[%d] lun[%d]\n",
+				  esp->host->unique_id, tgt, lun);
 
-	if (scsi_add_host(esp_host, dev))
-		goto fail_free_irq;
+		ent->sense_ptr = cmd->sense_buffer;
+		ent->sense_dma = esp->ops->map_single(esp,
+						      ent->sense_ptr,
+						      SCSI_SENSE_BUFFERSIZE,
+						      DMA_FROM_DEVICE);
+	}
+	ent->saved_sense_ptr = ent->sense_ptr;
 
-	dev_set_drvdata(&esp_dev->ofdev.dev, esp);
+	esp->active_cmd = ent;
 
-	scsi_scan_host(esp_host);
-	instance++;
+	p = esp->command_block;
+	esp->msg_out_len = 0;
 
-	return 0;
+	*p++ = IDENTIFY(0, lun);
+	*p++ = REQUEST_SENSE;
+	*p++ = ((dev->scsi_level <= SCSI_2) ?
+		(lun << 5) : 0);
+	*p++ = 0;
+	*p++ = 0;
+	*p++ = SCSI_SENSE_BUFFERSIZE;
+	*p++ = 0;
 
-fail_free_irq:
-	free_irq(esp->ehost->irq, esp);
+	esp->select_state = ESP_SELECT_BASIC;
 
-fail_unmap_cmdarea:
-	sbus_free_consistent(esp->sdev, 16,
-			     (void *) esp->esp_command,
-			     esp->esp_command_dvma);
+	val = tgt;
+	if (esp->rev == FASHME)
+		val |= ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT;
+	esp_write8(val, ESP_BUSID);
 
-fail_unmap_regs:
-	sbus_iounmap(esp->eregs, ESP_REG_SIZE);
+	esp_write_tgt_sync(esp, tgt);
+	esp_write_tgt_config3(esp, tgt);
 
-fail_dvma_release:
-	esp->dma->allocated = 0;
+	val = (p - esp->command_block);
 
-fail_unlink:
-	scsi_host_put(esp_host);
-	return -1;
+	if (esp->rev == FASHME)
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+			       val, 16, 0, ESP_CMD_DMA | ESP_CMD_SELA);
 }
 
-/* Detecting ESP chips on the machine.  This is the simple and easy
- * version.
- */
-static int __devexit esp_remove_common(struct esp *esp)
+static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
 {
-	unsigned int irq = esp->ehost->irq;
+	struct esp_cmd_entry *ent;
 
-	scsi_remove_host(esp->ehost);
+	list_for_each_entry(ent, &esp->queued_cmds, list) {
+		struct esp_target_data *tp;
+		struct esp_lun_data *lp;
+		struct scsi_cmnd *cmd = ent->cmd;
+		struct scsi_device *dev = cmd->device;
+		int tgt = dev->id;
+		int lun = dev->lun;
 
-	ESP_INTSOFF(esp->dregs);
-#if 0
-	esp_reset_dma(esp);
-	esp_reset_esp(esp);
-#endif
-
-	free_irq(irq, esp);
-	sbus_free_consistent(esp->sdev, 16,
-			     (void *) esp->esp_command, esp->esp_command_dvma);
-	sbus_iounmap(esp->eregs, ESP_REG_SIZE);
-	esp->dma->allocated = 0;
-
-	scsi_host_put(esp->ehost);
-
-	return 0;
-}
-
-
-#ifdef CONFIG_SUN4
+		if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+			ent->tag[0] = 0;
+			ent->tag[1] = 0;
+			return ent;
+		}
 
-#include <asm/sun4paddr.h>
+		if (!scsi_populate_tag_msg(cmd, &ent->tag[0])) {
+			ent->tag[0] = 0;
+			ent->tag[1] = 0;
+		}
 
-static struct sbus_dev sun4_esp_dev;
+		tp = &esp->target[tgt];
+		lp = tp->lun[lun];
+		if (esp_alloc_lun_tag(ent, lp) < 0)
+			continue;
 
-static int __init esp_sun4_probe(struct scsi_host_template *tpnt)
-{
-	if (sun4_esp_physaddr) {
-		memset(&sun4_esp_dev, 0, sizeof(sun4_esp_dev));
-		sun4_esp_dev.reg_addrs[0].phys_addr = sun4_esp_physaddr;
-		sun4_esp_dev.irqs[0] = 4;
-		sun4_esp_dev.resource[0].start = sun4_esp_physaddr;
-		sun4_esp_dev.resource[0].end =
-			sun4_esp_physaddr + ESP_REG_SIZE - 1;
-		sun4_esp_dev.resource[0].flags = IORESOURCE_IO;
-
-		return detect_one_esp(tpnt, NULL,
-				      &sun4_esp_dev, NULL, NULL, 0);
+		return ent;
 	}
-	return 0;
+
+	return NULL;
 }
 
-static int __devexit esp_sun4_remove(void)
+static void esp_maybe_execute_command(struct esp *esp)
 {
-	struct of_device *dev = &sun4_esp_dev.ofdev;
-	struct esp *esp = dev_get_drvdata(&dev->dev);
+	struct esp_target_data *tp;
+	struct esp_lun_data *lp;
+	struct scsi_device *dev;
+	struct scsi_cmnd *cmd;
+	struct esp_cmd_entry *ent;
+	int tgt, lun, i;
+	u32 val, start_cmd;
+	u8 *p;
 
-	return esp_remove_common(esp);
-}
+	if (esp->active_cmd ||
+	    (esp->flags & ESP_FLAG_RESETTING))
+		return;
 
-#else /* !CONFIG_SUN4 */
+	ent = find_and_prep_issuable_command(esp);
+	if (!ent)
+		return;
 
-static int __devinit esp_sbus_probe(struct of_device *dev, const struct of_device_id *match)
-{
-	struct sbus_dev *sdev = to_sbus_device(&dev->dev);
-	struct device_node *dp = dev->node;
-	struct sbus_dev *dma_sdev = NULL;
-	int hme = 0;
-
-	if (dp->parent &&
-	    (!strcmp(dp->parent->name, "espdma") ||
-	     !strcmp(dp->parent->name, "dma")))
-		dma_sdev = sdev->parent;
-	else if (!strcmp(dp->name, "SUNW,fas")) {
-		dma_sdev = sdev;
-		hme = 1;
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		esp_autosense(esp, ent);
+		return;
 	}
 
-	return detect_one_esp(match->data, &dev->dev,
-			      sdev, dma_sdev, sdev->bus, hme);
-}
+	cmd = ent->cmd;
+	dev = cmd->device;
+	tgt = dev->id;
+	lun = dev->lun;
+	tp = &esp->target[tgt];
+	lp = tp->lun[lun];
 
-static int __devexit esp_sbus_remove(struct of_device *dev)
-{
-	struct esp *esp = dev_get_drvdata(&dev->dev);
+	list_del(&ent->list);
+	list_add(&ent->list, &esp->active_cmds);
 
-	return esp_remove_common(esp);
-}
+	esp->active_cmd = ent;
 
-#endif /* !CONFIG_SUN4 */
+	esp_map_dma(esp, cmd);
+	esp_save_pointers(esp, ent);
 
-/* The info function will return whatever useful
- * information the developer sees fit.  If not provided, then
- * the name field will be used instead.
- */
-static const char *esp_info(struct Scsi_Host *host)
-{
-	struct esp *esp;
-
-	esp = (struct esp *) host->hostdata;
-	switch (esp->erev) {
-	case esp100:
-		return "Sparc ESP100 (NCR53C90)";
-	case esp100a:
-		return "Sparc ESP100A (NCR53C90A)";
-	case esp236:
-		return "Sparc ESP236";
-	case fas236:
-		return "Sparc ESP236-FAST";
-	case fashme:
-		return "Sparc ESP366-HME";
-	case fas100a:
-		return "Sparc ESP100A-FAST";
-	default:
-		return "Bogon ESP revision";
-	};
-}
+	esp_check_command_len(esp, cmd);
 
-/* From Wolfgang Stanglmeier's NCR scsi driver. */
-struct info_str
-{
-	char *buffer;
-	int length;
-	int offset;
-	int pos;
-};
+	p = esp->command_block;
 
-static void copy_mem_info(struct info_str *info, char *data, int len)
-{
-	if (info->pos + len > info->length)
-		len = info->length - info->pos;
+	esp->msg_out_len = 0;
+	if (tp->flags & ESP_TGT_CHECK_NEGO) {
+		/* Need to negotiate.  If the target is broken
+		 * go for synchronous transfers and non-wide.
+		 */
+		if (tp->flags & ESP_TGT_BROKEN) {
+			tp->flags &= ~ESP_TGT_DISCONNECT;
+			tp->nego_goal_period = 0;
+			tp->nego_goal_offset = 0;
+			tp->nego_goal_width = 0;
+			tp->nego_goal_tags = 0;
+		}
 
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
-	if (info->pos < info->offset) {
-		data += (info->offset - info->pos);
-		len  -= (info->offset - info->pos);
-	}
+		/* If the settings are not changing, skip this.  */
+		if (spi_width(tp->starget) == tp->nego_goal_width &&
+		    spi_period(tp->starget) == tp->nego_goal_period &&
+		    spi_offset(tp->starget) == tp->nego_goal_offset) {
+			tp->flags &= ~ESP_TGT_CHECK_NEGO;
+			goto build_identify;
+		}
 
-	if (len > 0) {
-		memcpy(info->buffer + info->pos, data, len);
-		info->pos += len;
-	}
-}
+		if (esp->rev == FASHME && esp_need_to_nego_wide(tp)) {
+			esp_build_wide_msg(esp, tp->nego_goal_width);
+			tp->flags |= ESP_TGT_NEGO_WIDE;
+		} else if (esp_need_to_nego_sync(tp)) {
+			esp_build_sync_msg(esp,
+					   tp->nego_goal_period,
+					   tp->nego_goal_offset);
+			tp->flags |= ESP_TGT_NEGO_SYNC;
+		} else {
+			tp->flags &= ~ESP_TGT_CHECK_NEGO;
+		}
 
-static int copy_info(struct info_str *info, char *fmt, ...)
-{
-	va_list args;
-	char buf[81];
-	int len;
+		/* Process it like a slow command.  */
+		if (tp->flags & (ESP_TGT_NEGO_WIDE | ESP_TGT_NEGO_SYNC))
+			esp->flags |= ESP_FLAG_DOING_SLOWCMD;
+	}
 
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
+build_identify:
+	/* If we don't have a lun-data struct yet, we're probing
+	 * so do not disconnect.  Also, do not disconnect unless
+	 * we have a tag on this command.
+	 */
+	if (lp && (tp->flags & ESP_TGT_DISCONNECT) && ent->tag[0])
+		*p++ = IDENTIFY(1, lun);
+	else
+		*p++ = IDENTIFY(0, lun);
 
-	copy_mem_info(info, buf, len);
-	return len;
-}
+	if (ent->tag[0] && esp->rev == ESP100) {
+		/* ESP100 lacks select w/atn3 command, use select
+		 * and stop instead.
+		 */
+		esp->flags |= ESP_FLAG_DOING_SLOWCMD;
+	}
 
-static int esp_host_info(struct esp *esp, char *ptr, off_t offset, int len)
-{
-	struct scsi_device *sdev;
-	struct info_str info;
-	int i;
+	if (!(esp->flags & ESP_FLAG_DOING_SLOWCMD)) {
+		start_cmd = ESP_CMD_DMA | ESP_CMD_SELA;
+		if (ent->tag[0]) {
+			*p++ = ent->tag[0];
+			*p++ = ent->tag[1];
 
-	info.buffer	= ptr;
-	info.length	= len;
-	info.offset	= offset;
-	info.pos	= 0;
-
-	copy_info(&info, "Sparc ESP Host Adapter:\n");
-	copy_info(&info, "\tPROM node\t\t%08x\n", (unsigned int) esp->prom_node);
-	copy_info(&info, "\tPROM name\t\t%s\n", esp->prom_name);
-	copy_info(&info, "\tESP Model\t\t");
-	switch (esp->erev) {
-	case esp100:
-		copy_info(&info, "ESP100\n");
-		break;
-	case esp100a:
-		copy_info(&info, "ESP100A\n");
-		break;
-	case esp236:
-		copy_info(&info, "ESP236\n");
-		break;
-	case fas236:
-		copy_info(&info, "FAS236\n");
-		break;
-	case fas100a:
-		copy_info(&info, "FAS100A\n");
-		break;
-	case fast:
-		copy_info(&info, "FAST\n");
-		break;
-	case fashme:
-		copy_info(&info, "Happy Meal FAS\n");
-		break;
-	case espunknown:
-	default:
-		copy_info(&info, "Unknown!\n");
-		break;
-	};
-	copy_info(&info, "\tDMA Revision\t\t");
-	switch (esp->dma->revision) {
-	case dvmarev0:
-		copy_info(&info, "Rev 0\n");
-		break;
-	case dvmaesc1:
-		copy_info(&info, "ESC Rev 1\n");
-		break;
-	case dvmarev1:
-		copy_info(&info, "Rev 1\n");
-		break;
-	case dvmarev2:
-		copy_info(&info, "Rev 2\n");
-		break;
-	case dvmarev3:
-		copy_info(&info, "Rev 3\n");
-		break;
-	case dvmarevplus:
-		copy_info(&info, "Rev 1+\n");
-		break;
-	case dvmahme:
-		copy_info(&info, "Rev HME/FAS\n");
-		break;
-	default:
-		copy_info(&info, "Unknown!\n");
-		break;
-	};
-	copy_info(&info, "\tLive Targets\t\t[ ");
-	for (i = 0; i < 15; i++) {
-		if (esp->targets_present & (1 << i))
-			copy_info(&info, "%d ", i);
-	}
-	copy_info(&info, "]\n\n");
-	
-	/* Now describe the state of each existing target. */
-	copy_info(&info, "Target #\tconfig3\t\tSync Capabilities\tDisconnect\tWide\n");
+			start_cmd = ESP_CMD_DMA | ESP_CMD_SA3;
+		}
 
-	shost_for_each_device(sdev, esp->ehost) {
-		struct esp_device *esp_dev = sdev->hostdata;
-		uint id = sdev->id;
+		for (i = 0; i < cmd->cmd_len; i++)
+			*p++ = cmd->cmnd[i];
 
-		if (!(esp->targets_present & (1 << id)))
-			continue;
+		esp->select_state = ESP_SELECT_BASIC;
+	} else {
+		esp->cmd_bytes_left = cmd->cmd_len;
+		esp->cmd_bytes_ptr = &cmd->cmnd[0];
+
+		if (ent->tag[0]) {
+			for (i = esp->msg_out_len - 1;
+			     i >= 0; i--)
+				esp->msg_out[i + 2] = esp->msg_out[i];
+			esp->msg_out[0] = ent->tag[0];
+			esp->msg_out[1] = ent->tag[1];
+			esp->msg_out_len += 2;
+		}
 
-		copy_info(&info, "%d\t\t", id);
-		copy_info(&info, "%08lx\t", esp->config3[id]);
-		copy_info(&info, "[%02lx,%02lx]\t\t\t",
-			esp_dev->sync_max_offset,
-			esp_dev->sync_min_period);
-		copy_info(&info, "%s\t\t",
-			esp_dev->disconnect ? "yes" : "no");
-		copy_info(&info, "%s\n",
-			(esp->config3[id] & ESP_CONFIG3_EWIDE) ? "yes" : "no");
+		start_cmd = ESP_CMD_DMA | ESP_CMD_SELAS;
+		esp->select_state = ESP_SELECT_MSGOUT;
 	}
-	return info.pos > info.offset? info.pos - info.offset : 0;
-}
+	val = tgt;
+	if (esp->rev == FASHME)
+		val |= ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT;
+	esp_write8(val, ESP_BUSID);
 
-/* ESP proc filesystem code. */
-static int esp_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-			 int length, int inout)
-{
-	struct esp *esp = (struct esp *) host->hostdata;
+	esp_write_tgt_sync(esp, tgt);
+	esp_write_tgt_config3(esp, tgt);
 
-	if (inout)
-		return -EINVAL; /* not yet */
+	val = (p - esp->command_block);
 
-	if (start)
-		*start = buffer;
+	if (esp_debug & ESP_DEBUG_SCSICMD) {
+		printk("ESP: tgt[%d] lun[%d] scsi_cmd [ ", tgt, lun);
+		for (i = 0; i < cmd->cmd_len; i++)
+			printk("%02x ", cmd->cmnd[i]);
+		printk("]\n");
+	}
 
-	return esp_host_info(esp, buffer, offset, length);
+	if (esp->rev == FASHME)
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+			       val, 16, 0, start_cmd);
 }
 
-static void esp_get_dmabufs(struct esp *esp, struct scsi_cmnd *sp)
+static struct esp_cmd_entry *esp_get_ent(struct esp *esp)
 {
-	if (sp->use_sg == 0) {
-		sp->SCp.this_residual = sp->request_bufflen;
-		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
-		sp->SCp.buffers_residual = 0;
-		if (sp->request_bufflen) {
-			sp->SCp.have_data_in = sbus_map_single(esp->sdev, sp->SCp.buffer,
-							       sp->SCp.this_residual,
-							       sp->sc_data_direction);
-			sp->SCp.ptr = (char *) ((unsigned long)sp->SCp.have_data_in);
-		} else {
-			sp->SCp.ptr = NULL;
-		}
+	struct list_head *head = &esp->esp_cmd_pool;
+	struct esp_cmd_entry *ret;
+
+	if (list_empty(head)) {
+		ret = kzalloc(sizeof(struct esp_cmd_entry), GFP_ATOMIC);
 	} else {
-		sp->SCp.buffer = (struct scatterlist *) sp->request_buffer;
-		sp->SCp.buffers_residual = sbus_map_sg(esp->sdev,
-						       sp->SCp.buffer,
-						       sp->use_sg,
-						       sp->sc_data_direction);
-		sp->SCp.this_residual = sg_dma_len(sp->SCp.buffer);
-		sp->SCp.ptr = (char *) ((unsigned long)sg_dma_address(sp->SCp.buffer));
+		ret = list_entry(head->next, struct esp_cmd_entry, list);
+		list_del(&ret->list);
+		memset(ret, 0, sizeof(*ret));
 	}
+	return ret;
 }
 
-static void esp_release_dmabufs(struct esp *esp, struct scsi_cmnd *sp)
+static void esp_put_ent(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	if (sp->use_sg) {
-		sbus_unmap_sg(esp->sdev, sp->request_buffer, sp->use_sg,
-			      sp->sc_data_direction);
-	} else if (sp->request_bufflen) {
-		sbus_unmap_single(esp->sdev,
-				  sp->SCp.have_data_in,
-				  sp->request_bufflen,
-				  sp->sc_data_direction);
-	}
+	list_add(&ent->list, &esp->esp_cmd_pool);
 }
 
-static void esp_restore_pointers(struct esp *esp, struct scsi_cmnd *sp)
+static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
+			    struct scsi_cmnd *cmd, unsigned int result)
 {
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	struct scsi_device *dev = cmd->device;
+	int tgt = dev->id;
+	int lun = dev->lun;
 
-	sp->SCp.ptr = ep->saved_ptr;
-	sp->SCp.buffer = ep->saved_buffer;
-	sp->SCp.this_residual = ep->saved_this_residual;
-	sp->SCp.buffers_residual = ep->saved_buffers_residual;
-}
+	esp->active_cmd = NULL;
+	esp_unmap_dma(esp, cmd);
+	esp_free_lun_tag(ent, esp->target[tgt].lun[lun]);
+	cmd->result = result;
 
-static void esp_save_pointers(struct esp *esp, struct scsi_cmnd *sp)
-{
-	struct esp_pointers *ep = &esp->data_pointers[sp->device->id];
+	if (ent->eh_done) {
+		complete(ent->eh_done);
+		ent->eh_done = NULL;
+	}
 
-	ep->saved_ptr = sp->SCp.ptr;
-	ep->saved_buffer = sp->SCp.buffer;
-	ep->saved_this_residual = sp->SCp.this_residual;
-	ep->saved_buffers_residual = sp->SCp.buffers_residual;
-}
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		esp->ops->unmap_single(esp, ent->sense_dma,
+				       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+		ent->sense_ptr = NULL;
 
-/* Some rules:
- *
- *   1) Never ever panic while something is live on the bus.
- *      If there is to be any chance of syncing the disks this
- *      rule is to be obeyed.
- *
- *   2) Any target that causes a foul condition will no longer
- *      have synchronous transfers done to it, no questions
- *      asked.
- *
- *   3) Keep register accesses to a minimum.  Think about some
- *      day when we have Xbus machines this is running on and
- *      the ESP chip is on the other end of the machine on a
- *      different board from the cpu where this is running.
- */
+		/* Restore the message/status bytes to what we actually
+		 * saw originally.  Also, report that we are providing
+		 * the sense data.
+		 */
+		cmd->result = ((DRIVER_SENSE << 24) |
+			       (DID_OK << 16) |
+			       (COMMAND_COMPLETE << 8) |
+			       (SAM_STAT_CHECK_CONDITION << 0));
+
+		ent->flags &= ~ESP_CMD_FLAG_AUTOSENSE;
+		if (esp_debug & ESP_DEBUG_AUTOSENSE) {
+			int i;
+
+			printk("esp%d: tgt[%d] lun[%d] AUTO SENSE[ ",
+			       esp->host->unique_id, tgt, lun);
+			for (i = 0; i < 18; i++)
+				printk("%02x ", cmd->sense_buffer[i]);
+			printk("]\n");
+		}
+	}
 
-/* Fire off a command.  We assume the bus is free and that the only
- * case where we could see an interrupt is where we have disconnected
- * commands active and they are trying to reselect us.
- */
-static inline void esp_check_cmd(struct esp *esp, struct scsi_cmnd *sp)
-{
-	switch (sp->cmd_len) {
-	case 6:
-	case 10:
-	case 12:
-		esp->esp_slowcmd = 0;
-		break;
+	cmd->scsi_done(cmd);
 
-	default:
-		esp->esp_slowcmd = 1;
-		esp->esp_scmdleft = sp->cmd_len;
-		esp->esp_scmdp = &sp->cmnd[0];
-		break;
-	};
-}
+	list_del(&ent->list);
+	esp_put_ent(esp, ent);
 
-static inline void build_sync_nego_msg(struct esp *esp, int period, int offset)
-{
-	esp->cur_msgout[0] = EXTENDED_MESSAGE;
-	esp->cur_msgout[1] = 3;
-	esp->cur_msgout[2] = EXTENDED_SDTR;
-	esp->cur_msgout[3] = period;
-	esp->cur_msgout[4] = offset;
-	esp->msgout_len = 5;
+	esp_maybe_execute_command(esp);
 }
 
-/* SIZE is in bits, currently HME only supports 16 bit wide transfers. */
-static inline void build_wide_nego_msg(struct esp *esp, int size)
+static unsigned int compose_result(unsigned int status, unsigned int message,
+				   unsigned int driver_code)
 {
-	esp->cur_msgout[0] = EXTENDED_MESSAGE;
-	esp->cur_msgout[1] = 2;
-	esp->cur_msgout[2] = EXTENDED_WDTR;
-	switch (size) {
-	case 32:
-		esp->cur_msgout[3] = 2;
-		break;
-	case 16:
-		esp->cur_msgout[3] = 1;
-		break;
-	case 8:
-	default:
-		esp->cur_msgout[3] = 0;
-		break;
-	};
-
-	esp->msgout_len = 4;
+	return (status | (message << 8) | (driver_code << 16));
 }
 
-static void esp_exec_cmd(struct esp *esp)
+static void esp_event_queue_full(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	struct scsi_cmnd *SCptr;
-	struct scsi_device *SDptr;
-	struct esp_device *esp_dev;
-	volatile u8 *cmdp = esp->esp_command;
-	u8 the_esp_command;
-	int lun, target;
-	int i;
+	struct scsi_device *dev = ent->cmd->device;
+	int tgt = dev->id;
+	int lun = dev->lun;
+	struct esp_target_data *tp = &esp->target[tgt];
+	struct esp_lun_data *lp = tp->lun[lun];
 
-	/* Hold off if we have disconnected commands and
-	 * an IRQ is showing...
-	 */
-	if (esp->disconnected_SC && ESP_IRQ_P(esp->dregs))
+	if (!lp) {
+		WARN_ON(1);
 		return;
+	}
 
-	/* Grab first member of the issue queue. */
-	SCptr = esp->current_SC = remove_first_SC(&esp->issue_SC);
-
-	/* Safe to panic here because current_SC is null. */
-	if (!SCptr)
-		panic("esp: esp_exec_cmd and issue queue is NULL");
+	scsi_track_queue_full(dev, lp->num_tagged - 1);
+}
 
-	SDptr = SCptr->device;
-	esp_dev = SDptr->hostdata;
-	lun = SCptr->device->lun;
-	target = SCptr->device->id;
+static int esp_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+{
+	struct scsi_device *dev = cmd->device;
+	struct esp *esp = host_to_esp(dev->host);
+	struct esp_cmd_priv *spriv;
+	struct esp_cmd_entry *ent;
 
-	esp->snip = 0;
-	esp->msgout_len = 0;
+	cmd->scsi_done = done;
 
-	/* Send it out whole, or piece by piece?   The ESP
-	 * only knows how to automatically send out 6, 10,
-	 * and 12 byte commands.  I used to think that the
-	 * Linux SCSI code would never throw anything other
-	 * than that to us, but then again there is the
-	 * SCSI generic driver which can send us anything.
-	 */
-	esp_check_cmd(esp, SCptr);
-
-	/* If arbitration/selection is successful, the ESP will leave
-	 * ATN asserted, causing the target to go into message out
-	 * phase.  The ESP will feed the target the identify and then
-	 * the target can only legally go to one of command,
-	 * datain/out, status, or message in phase, or stay in message
-	 * out phase (should we be trying to send a sync negotiation
-	 * message after the identify).  It is not allowed to drop
-	 * BSY, but some buggy targets do and we check for this
-	 * condition in the selection complete code.  Most of the time
-	 * we'll make the command bytes available to the ESP and it
-	 * will not interrupt us until it finishes command phase, we
-	 * cannot do this for command sizes the ESP does not
-	 * understand and in this case we'll get interrupted right
-	 * when the target goes into command phase.
-	 *
-	 * It is absolutely _illegal_ in the presence of SCSI-2 devices
-	 * to use the ESP select w/o ATN command.  When SCSI-2 devices are
-	 * present on the bus we _must_ always go straight to message out
-	 * phase with an identify message for the target.  Being that
-	 * selection attempts in SCSI-1 w/o ATN was an option, doing SCSI-2
-	 * selections should not confuse SCSI-1 we hope.
-	 */
+	if (dev->id == esp->scsi_id) {
+		cmd->result = DID_NO_CONNECT << 16;
+		cmd->scsi_done(cmd);
+		return 0;
+	}
 
-	if (esp_dev->sync) {
-		/* this targets sync is known */
-#ifndef __sparc_v9__
-do_sync_known:
-#endif
-		if (esp_dev->disconnect)
-			*cmdp++ = IDENTIFY(1, lun);
-		else
-			*cmdp++ = IDENTIFY(0, lun);
+	spriv = ESP_CMD_PRIV(cmd);
+	spriv->u.dma_addr = ~(dma_addr_t)0x0;
+	spriv->mapping_type = MAPPING_TYPE_NONE;
 
-		if (esp->esp_slowcmd) {
-			the_esp_command = (ESP_CMD_SELAS | ESP_CMD_DMA);
-			esp_advance_phase(SCptr, in_slct_stop);
-		} else {
-			the_esp_command = (ESP_CMD_SELA | ESP_CMD_DMA);
-			esp_advance_phase(SCptr, in_slct_norm);
-		}
-	} else if (!(esp->targets_present & (1<<target)) || !(esp_dev->disconnect)) {
-		/* After the bootup SCSI code sends both the
-		 * TEST_UNIT_READY and INQUIRY commands we want
-		 * to at least attempt allowing the device to
-		 * disconnect.
-		 */
-		ESPMISC(("esp: Selecting device for first time. target=%d "
-			 "lun=%d\n", target, SCptr->device->lun));
-		if (!SDptr->borken && !esp_dev->disconnect)
-			esp_dev->disconnect = 1;
-
-		*cmdp++ = IDENTIFY(0, lun);
-		esp->prevmsgout = NOP;
-		esp_advance_phase(SCptr, in_slct_norm);
-		the_esp_command = (ESP_CMD_SELA | ESP_CMD_DMA);
-
-		/* Take no chances... */
-		esp_dev->sync_max_offset = 0;
-		esp_dev->sync_min_period = 0;
-	} else {
-		/* Sorry, I have had way too many problems with
-		 * various CDROM devices on ESP. -DaveM
-		 */
-		int cdrom_hwbug_wkaround = 0;
+	ent = esp_get_ent(esp);
+	if (!ent) {
+		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+	ent->cmd = cmd;
 
-#ifndef __sparc_v9__
-		/* Never allow disconnects or synchronous transfers on
-		 * SparcStation1 and SparcStation1+.  Allowing those
-		 * to be enabled seems to lockup the machine completely.
-		 */
-		if ((idprom->id_machtype == (SM_SUN4C | SM_4C_SS1)) ||
-		    (idprom->id_machtype == (SM_SUN4C | SM_4C_SS1PLUS))) {
-			/* But we are nice and allow tapes and removable
-			 * disks (but not CDROMs) to disconnect.
-			 */
-			if(SDptr->type == TYPE_TAPE ||
-			   (SDptr->type != TYPE_ROM && SDptr->removable))
-				esp_dev->disconnect = 1;
-			else
-				esp_dev->disconnect = 0;
-			esp_dev->sync_max_offset = 0;
-			esp_dev->sync_min_period = 0;
-			esp_dev->sync = 1;
-			esp->snip = 0;
-			goto do_sync_known;
-		}
-#endif /* !(__sparc_v9__) */
+	if (cmd->cmnd[0] == REQUEST_SENSE)
+		list_add(&ent->list, &esp->queued_cmds);
+	else
+		list_add_tail(&ent->list, &esp->queued_cmds);
 
-		/* We've talked to this guy before,
-		 * but never negotiated.  Let's try,
-		 * need to attempt WIDE first, before
-		 * sync nego, as per SCSI 2 standard.
-		 */
-		if (esp->erev == fashme && !esp_dev->wide) {
-			if (!SDptr->borken &&
-			   SDptr->type != TYPE_ROM &&
-			   SDptr->removable == 0) {
-				build_wide_nego_msg(esp, 16);
-				esp_dev->wide = 1;
-				esp->wnip = 1;
-				goto after_nego_msg_built;
-			} else {
-				esp_dev->wide = 1;
-				/* Fall through and try sync. */
-			}
-		}
+	esp_maybe_execute_command(esp);
 
-		if (!SDptr->borken) {
-			if ((SDptr->type == TYPE_ROM)) {
-				/* Nice try sucker... */
-				ESPMISC(("esp%d: Disabling sync for buggy "
-					 "CDROM.\n", esp->esp_id));
-				cdrom_hwbug_wkaround = 1;
-				build_sync_nego_msg(esp, 0, 0);
-			} else if (SDptr->removable != 0) {
-				ESPMISC(("esp%d: Not negotiating sync/wide but "
-					 "allowing disconnect for removable media.\n",
-					 esp->esp_id));
-				build_sync_nego_msg(esp, 0, 0);
-			} else {
-				build_sync_nego_msg(esp, esp->sync_defp, 15);
-			}
-		} else {
-			build_sync_nego_msg(esp, 0, 0);
-		}
-		esp_dev->sync = 1;
-		esp->snip = 1;
-
-after_nego_msg_built:
-		/* A fix for broken SCSI1 targets, when they disconnect
-		 * they lock up the bus and confuse ESP.  So disallow
-		 * disconnects for SCSI1 targets for now until we
-		 * find a better fix.
-		 *
-		 * Addendum: This is funny, I figured out what was going
-		 *           on.  The blotzed SCSI1 target would disconnect,
-		 *           one of the other SCSI2 targets or both would be
-		 *           disconnected as well.  The SCSI1 target would
-		 *           stay disconnected long enough that we start
-		 *           up a command on one of the SCSI2 targets.  As
-		 *           the ESP is arbitrating for the bus the SCSI1
-		 *           target begins to arbitrate as well to reselect
-		 *           the ESP.  The SCSI1 target refuses to drop it's
-		 *           ID bit on the data bus even though the ESP is
-		 *           at ID 7 and is the obvious winner for any
-		 *           arbitration.  The ESP is a poor sport and refuses
-		 *           to lose arbitration, it will continue indefinitely
-		 *           trying to arbitrate for the bus and can only be
-		 *           stopped via a chip reset or SCSI bus reset.
-		 *           Therefore _no_ disconnects for SCSI1 targets
-		 *           thank you very much. ;-)
-		 */
-		if(((SDptr->scsi_level < 3) &&
-		    (SDptr->type != TYPE_TAPE) &&
-		    SDptr->removable == 0) ||
-		    cdrom_hwbug_wkaround || SDptr->borken) {
-			ESPMISC((KERN_INFO "esp%d: Disabling DISCONNECT for target %d "
-				 "lun %d\n", esp->esp_id, SCptr->device->id, SCptr->device->lun));
-			esp_dev->disconnect = 0;
-			*cmdp++ = IDENTIFY(0, lun);
-		} else {
-			*cmdp++ = IDENTIFY(1, lun);
-		}
+	return 0;
+}
 
-		/* ESP fifo is only so big...
-		 * Make this look like a slow command.
+static int esp_check_gross_error(struct esp *esp)
+{
+	if (esp->sreg & ESP_STAT_SPAM) {
+		/* Gross Error, could be one of:
+		 * - top of fifo overwritten
+		 * - top of command register overwritten
+		 * - DMA programmed with wrong direction
+		 * - improper phase change
 		 */
-		esp->esp_slowcmd = 1;
-		esp->esp_scmdleft = SCptr->cmd_len;
-		esp->esp_scmdp = &SCptr->cmnd[0];
-
-		the_esp_command = (ESP_CMD_SELAS | ESP_CMD_DMA);
-		esp_advance_phase(SCptr, in_slct_msg);
-	}
-
-	if (!esp->esp_slowcmd)
-		for (i = 0; i < SCptr->cmd_len; i++)
-			*cmdp++ = SCptr->cmnd[i];
-
-	/* HME sucks... */
-	if (esp->erev == fashme)
-		sbus_writeb((target & 0xf) | (ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT),
-			    esp->eregs + ESP_BUSID);
-	else
-		sbus_writeb(target & 7, esp->eregs + ESP_BUSID);
-	if (esp->prev_soff != esp_dev->sync_max_offset ||
-	    esp->prev_stp  != esp_dev->sync_min_period ||
-	    (esp->erev > esp100a &&
-	     esp->prev_cfg3 != esp->config3[target])) {
-		esp->prev_soff = esp_dev->sync_max_offset;
-		esp->prev_stp = esp_dev->sync_min_period;
-		sbus_writeb(esp->prev_soff, esp->eregs + ESP_SOFF);
-		sbus_writeb(esp->prev_stp, esp->eregs + ESP_STP);
-		if (esp->erev > esp100a) {
-			esp->prev_cfg3 = esp->config3[target];
-			sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-		}
-	}
-	i = (cmdp - esp->esp_command);
-
-	if (esp->erev == fashme) {
-		esp_cmd(esp, ESP_CMD_FLUSH); /* Grrr! */
-
-		/* Set up the DMA and HME counters */
-		sbus_writeb(i, esp->eregs + ESP_TCLOW);
-		sbus_writeb(0, esp->eregs + ESP_TCMED);
-		sbus_writeb(0, esp->eregs + FAS_RLO);
-		sbus_writeb(0, esp->eregs + FAS_RHI);
-		esp_cmd(esp, the_esp_command);
-
-		/* Talk about touchy hardware... */
-		esp->prev_hme_dmacsr = ((esp->prev_hme_dmacsr |
-					 (DMA_SCSI_DISAB | DMA_ENABLE)) &
-					~(DMA_ST_WRITE));
-		sbus_writel(16, esp->dregs + DMA_COUNT);
-		sbus_writel(esp->esp_command_dvma, esp->dregs + DMA_ADDR);
-		sbus_writel(esp->prev_hme_dmacsr, esp->dregs + DMA_CSR);
-	} else {
-		u32 tmp;
-
-		/* Set up the DMA and ESP counters */
-		sbus_writeb(i, esp->eregs + ESP_TCLOW);
-		sbus_writeb(0, esp->eregs + ESP_TCMED);
-		tmp = sbus_readl(esp->dregs + DMA_CSR);
-		tmp &= ~DMA_ST_WRITE;
-		tmp |= DMA_ENABLE;
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-		if (esp->dma->revision == dvmaesc1) {
-			if (i) /* Workaround ESC gate array SBUS rerun bug. */
-				sbus_writel(PAGE_SIZE, esp->dregs + DMA_COUNT);
-		}
-		sbus_writel(esp->esp_command_dvma, esp->dregs + DMA_ADDR);
-
-		/* Tell ESP to "go". */
-		esp_cmd(esp, the_esp_command);
+		printk(KERN_ERR PFX "esp%d: Gross error sreg[%02x]\n",
+		       esp->host->unique_id, esp->sreg);
+		/* XXX Reset the chip. XXX */
+		return 1;
 	}
+	return 0;
 }
 
-/* Queue a SCSI command delivered from the mid-level Linux SCSI code. */
-static int esp_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+static int esp_check_spur_intr(struct esp *esp)
 {
-	struct esp *esp;
-
-	/* Set up func ptr and initial driver cmd-phase. */
-	SCpnt->scsi_done = done;
-	SCpnt->SCp.phase = not_issued;
+	switch (esp->rev) {
+	case ESP100:
+	case ESP100A:
+		/* The interrupt pending bit of the status register cannot
+		 * be trusted on these revisions.
+		 */
+		esp->sreg &= ~ESP_STAT_INTR;
+		break;
 
-	/* We use the scratch area. */
-	ESPQUEUE(("esp_queue: target=%d lun=%d ", SCpnt->device->id, SCpnt->device->lun));
-	ESPDISC(("N<%02x,%02x>", SCpnt->device->id, SCpnt->device->lun));
+	default:
+		if (!(esp->sreg & ESP_STAT_INTR)) {
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if (esp->ireg & ESP_INTR_SR)
+				return 1;
 
-	esp = (struct esp *) SCpnt->device->host->hostdata;
-	esp_get_dmabufs(esp, SCpnt);
-	esp_save_pointers(esp, SCpnt); /* FIXME for tag queueing */
+			/* If the DMA is indicating interrupt pending and the
+			 * ESP is not, the only possibility is a DMA error.
+			 */
+			if (!esp->ops->dma_error(esp)) {
+				printk(KERN_ERR PFX "esp%d: Spurious irq, "
+				       "sreg=%x.\n",
+				       esp->host->unique_id, esp->sreg);
+				return -1;
+			}
 
-	SCpnt->SCp.Status           = CHECK_CONDITION;
-	SCpnt->SCp.Message          = 0xff;
-	SCpnt->SCp.sent_command     = 0;
+			printk(KERN_ERR PFX "esp%d: DMA error\n",
+			       esp->host->unique_id);
 
-	/* Place into our queue. */
-	if (SCpnt->cmnd[0] == REQUEST_SENSE) {
-		ESPQUEUE(("RQSENSE\n"));
-		prepend_SC(&esp->issue_SC, SCpnt);
-	} else {
-		ESPQUEUE(("\n"));
-		append_SC(&esp->issue_SC, SCpnt);
+			/* XXX Reset the chip. XXX */
+			return -1;
+		}
+		break;
 	}
 
-	/* Run it now if we can. */
-	if (!esp->current_SC && !esp->resetting_bus)
-		esp_exec_cmd(esp);
-
 	return 0;
 }
 
-/* Dump driver state. */
-static void esp_dump_cmd(struct scsi_cmnd *SCptr)
+static void esp_schedule_reset(struct esp *esp)
 {
-	ESPLOG(("[tgt<%02x> lun<%02x> "
-		"pphase<%s> cphase<%s>]",
-		SCptr->device->id, SCptr->device->lun,
-		phase_string(SCptr->SCp.sent_command),
-		phase_string(SCptr->SCp.phase)));
+	esp_log_reset("ESP: esp_schedule_reset() from %p\n",
+		      __builtin_return_address(0));
+	esp->flags |= ESP_FLAG_RESETTING;
+	esp_event(esp, ESP_EVENT_RESET);
 }
 
-static void esp_dump_state(struct esp *esp)
+/* In order to avoid having to add a special half-reconnected state
+ * into the driver we just sit here and poll through the rest of
+ * the reselection process to get the tag message bytes.
+ */
+static struct esp_cmd_entry *esp_reconnect_with_tag(struct esp *esp,
+						    struct esp_lun_data *lp)
 {
-	struct scsi_cmnd *SCptr = esp->current_SC;
-#ifdef DEBUG_ESP_CMDS
+	struct esp_cmd_entry *ent;
 	int i;
-#endif
-
-	ESPLOG(("esp%d: dumping state\n", esp->esp_id));
-	ESPLOG(("esp%d: dma -- cond_reg<%08x> addr<%08x>\n",
-		esp->esp_id,
-		sbus_readl(esp->dregs + DMA_CSR),
-		sbus_readl(esp->dregs + DMA_ADDR)));
-	ESPLOG(("esp%d: SW [sreg<%02x> sstep<%02x> ireg<%02x>]\n",
-		esp->esp_id, esp->sreg, esp->seqreg, esp->ireg));
-	ESPLOG(("esp%d: HW reread [sreg<%02x> sstep<%02x> ireg<%02x>]\n",
-		esp->esp_id,
-		sbus_readb(esp->eregs + ESP_STATUS),
-		sbus_readb(esp->eregs + ESP_SSTEP),
-		sbus_readb(esp->eregs + ESP_INTRPT)));
-#ifdef DEBUG_ESP_CMDS
-	printk("esp%d: last ESP cmds [", esp->esp_id);
-	i = (esp->espcmdent - 1) & 31;
-	printk("<"); esp_print_cmd(esp->espcmdlog[i]); printk(">");
-	i = (i - 1) & 31;
-	printk("<"); esp_print_cmd(esp->espcmdlog[i]); printk(">");
-	i = (i - 1) & 31;
-	printk("<"); esp_print_cmd(esp->espcmdlog[i]); printk(">");
-	i = (i - 1) & 31;
-	printk("<"); esp_print_cmd(esp->espcmdlog[i]); printk(">");
-	printk("]\n");
-#endif /* (DEBUG_ESP_CMDS) */
-
-	if (SCptr) {
-		ESPLOG(("esp%d: current command ", esp->esp_id));
-		esp_dump_cmd(SCptr);
+
+	if (!lp->num_tagged) {
+		printk(KERN_ERR PFX "esp%d: Reconnect w/num_tagged==0\n",
+		       esp->host->unique_id);
+		return NULL;
+	}
+
+	esp_log_reconnect("ESP: reconnect tag, ");
+
+	for (i = 0; i < ESP_QUICKIRQ_LIMIT; i++) {
+		if (esp->ops->irq_pending(esp))
+			break;
 	}
-	ESPLOG(("\n"));
-	SCptr = esp->disconnected_SC;
-	ESPLOG(("esp%d: disconnected ", esp->esp_id));
-	while (SCptr) {
-		esp_dump_cmd(SCptr);
-		SCptr = (struct scsi_cmnd *) SCptr->host_scribble;
+	if (i == ESP_QUICKIRQ_LIMIT) {
+		printk(KERN_ERR PFX "esp%d: Reconnect IRQ1 timeout\n",
+		       esp->host->unique_id);
+		return NULL;
 	}
-	ESPLOG(("\n"));
-}
 
-/* Abort a command.  The host_lock is acquired by caller. */
-static int esp_abort(struct scsi_cmnd *SCptr)
-{
-	struct esp *esp = (struct esp *) SCptr->device->host->hostdata;
-	int don;
+	esp->sreg = esp_read8(ESP_STATUS);
+	esp->ireg = esp_read8(ESP_INTRPT);
 
-	ESPLOG(("esp%d: Aborting command\n", esp->esp_id));
-	esp_dump_state(esp);
+	esp_log_reconnect("IRQ(%d:%x:%x), ",
+			  i, esp->ireg, esp->sreg);
 
-	/* Wheee, if this is the current command on the bus, the
-	 * best we can do is assert ATN and wait for msgout phase.
-	 * This should even fix a hung SCSI bus when we lose state
-	 * in the driver and timeout because the eventual phase change
-	 * will cause the ESP to (eventually) give an interrupt.
-	 */
-	if (esp->current_SC == SCptr) {
-		esp->cur_msgout[0] = ABORT;
-		esp->msgout_len = 1;
-		esp->msgout_ctr = 0;
-		esp_cmd(esp, ESP_CMD_SATN);
-		return SUCCESS;
+	if (esp->ireg & ESP_INTR_DC) {
+		printk(KERN_ERR PFX "esp%d: Reconnect, got disconnect.\n",
+		       esp->host->unique_id);
+		return NULL;
 	}
 
-	/* If it is still in the issue queue then we can safely
-	 * call the completion routine and report abort success.
-	 */
-	don = (sbus_readl(esp->dregs + DMA_CSR) & DMA_INT_ENAB);
-	if (don) {
-		ESP_INTSOFF(esp->dregs);
+	if ((esp->sreg & ESP_STAT_PMASK) != ESP_MIP) {
+		printk(KERN_ERR PFX "esp%d: Reconnect, not MIP sreg[%02x].\n",
+		       esp->host->unique_id, esp->sreg);
+		return NULL;
 	}
-	if (esp->issue_SC) {
-		struct scsi_cmnd **prev, *this;
-		for (prev = (&esp->issue_SC), this = esp->issue_SC;
-		     this != NULL;
-		     prev = (struct scsi_cmnd **) &(this->host_scribble),
-			     this = (struct scsi_cmnd *) this->host_scribble) {
-
-			if (this == SCptr) {
-				*prev = (struct scsi_cmnd *) this->host_scribble;
-				this->host_scribble = NULL;
 
-				esp_release_dmabufs(esp, this);
-				this->result = DID_ABORT << 16;
-				this->scsi_done(this);
+	/* DMA in the tag bytes... */
+	esp->command_block[0] = 0xff;
+	esp->command_block[1] = 0xff;
+	esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+			       2, 2, 1, ESP_CMD_DMA | ESP_CMD_TI);
 
-				if (don)
-					ESP_INTSON(esp->dregs);
+	/* ACK the msssage.  */
+	scsi_esp_cmd(esp, ESP_CMD_MOK);
 
-				return SUCCESS;
-			}
+	for (i = 0; i < ESP_RESELECT_TAG_LIMIT; i++) {
+		if (esp->ops->irq_pending(esp)) {
+			esp->sreg = esp_read8(ESP_STATUS);
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if (esp->ireg & ESP_INTR_FDONE)
+				break;
 		}
+		udelay(1);
 	}
-
-	/* Yuck, the command to abort is disconnected, it is not
-	 * worth trying to abort it now if something else is live
-	 * on the bus at this time.  So, we let the SCSI code wait
-	 * a little bit and try again later.
-	 */
-	if (esp->current_SC) {
-		if (don)
-			ESP_INTSON(esp->dregs);
-		return FAILED;
+	if (i == ESP_RESELECT_TAG_LIMIT) {
+		printk(KERN_ERR PFX "esp%d: Reconnect IRQ2 timeout\n",
+		       esp->host->unique_id);
+		return NULL;
 	}
+	esp->ops->dma_drain(esp);
+	esp->ops->dma_invalidate(esp);
 
-	/* It's disconnected, we have to reconnect to re-establish
-	 * the nexus and tell the device to abort.  However, we really
-	 * cannot 'reconnect' per se.  Don't try to be fancy, just
-	 * indicate failure, which causes our caller to reset the whole
-	 * bus.
-	 */
+	esp_log_reconnect("IRQ2(%d:%x:%x) tag[%x:%x]\n",
+			  i, esp->ireg, esp->sreg,
+			  esp->command_block[0],
+			  esp->command_block[1]);
 
-	if (don)
-		ESP_INTSON(esp->dregs);
+	if (esp->command_block[0] < SIMPLE_QUEUE_TAG ||
+	    esp->command_block[0] > ORDERED_QUEUE_TAG) {
+		printk(KERN_ERR PFX "esp%d: Reconnect, bad tag "
+		       "type %02x.\n",
+		       esp->host->unique_id, esp->command_block[0]);
+		return NULL;
+	}
 
-	return FAILED;
+	ent = lp->tagged_cmds[esp->command_block[1]];
+	if (!ent) {
+		printk(KERN_ERR PFX "esp%d: Reconnect, no entry for "
+		       "tag %02x.\n",
+		       esp->host->unique_id, esp->command_block[1]);
+		return NULL;
+	}
+
+	return ent;
 }
 
-/* We've sent ESP_CMD_RS to the ESP, the interrupt had just
- * arrived indicating the end of the SCSI bus reset.  Our job
- * is to clean out the command queues and begin re-execution
- * of SCSI commands once more.
- */
-static int esp_finish_reset(struct esp *esp)
+static int esp_reconnect(struct esp *esp)
 {
-	struct scsi_cmnd *sp = esp->current_SC;
+	struct esp_cmd_entry *ent;
+	struct esp_target_data *tp;
+	struct esp_lun_data *lp;
+	int target, lun;
 
-	/* Clean up currently executing command, if any. */
-	if (sp != NULL) {
-		esp->current_SC = NULL;
-
-		esp_release_dmabufs(esp, sp);
-		sp->result = (DID_RESET << 16);
+	BUG_ON(esp->active_cmd);
+	if (esp->rev == FASHME) {
+		/* FASHME puts the target and lun numbers directly
+		 * into the fifo.
+		 */
+		target = esp->fifo[0];
+		lun = esp->fifo[1] & 0x7;
+	} else {
+		u8 bits = esp_read8(ESP_FDATA);
 
-		sp->scsi_done(sp);
+		/* Older chips put the lun directly into the fifo, but
+		 * the target is given as a sample of the arbitration
+		 * lines on the bus at reselection time.  So we should
+		 * see the ID of the ESP and the one reconnecting target
+		 * set in the bitmap.
+		 */
+		if (!(bits & esp->scsi_id_mask))
+			goto do_reset;
+		bits &= ~esp->scsi_id_mask;
+		if (!bits || (bits & (bits - 1)))
+			goto do_reset;
+
+		target = ffs(bits) - 1;
+		lun = (esp_read8(ESP_FDATA) & 0x7);
+
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+		if (esp->rev == ESP100) {
+			u8 ireg = esp_read8(ESP_INTRPT);
+			/* This chip has a bug during reselection that can
+			 * cause a spurious illegal-command interrupt, which
+			 * we simply ACK here.  Another possibility is a bus
+			 * reset so we must check for that.
+			 */
+			if (ireg & ESP_INTR_SR)
+				goto do_reset;
+		}
+		scsi_esp_cmd(esp, ESP_CMD_NULL);
 	}
+	
+	esp_write_tgt_sync(esp, target);
+	esp_write_tgt_config3(esp, target);
 
-	/* Clean up disconnected queue, they have been invalidated
-	 * by the bus reset.
-	 */
-	if (esp->disconnected_SC) {
-		while ((sp = remove_first_SC(&esp->disconnected_SC)) != NULL) {
-			esp_release_dmabufs(esp, sp);
-			sp->result = (DID_RESET << 16);
+	scsi_esp_cmd(esp, ESP_CMD_MOK);
 
-			sp->scsi_done(sp);
-		}
+	if (esp->rev == FASHME)
+		esp_write8(target | ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT,
+			   ESP_BUSID);
+
+	tp = &esp->target[target];
+	lp = tp->lun[lun];
+	if (!lp) {
+		printk(KERN_ERR PFX "esp%d: Reconnect, no lp "
+		       "tgt[%u] lun[%u]\n",
+		       esp->host->unique_id, target, lun);
+		goto do_reset;
 	}
 
-	/* SCSI bus reset is complete. */
-	esp->resetting_bus = 0;
-	wake_up(&esp->reset_queue);
+	ent = lp->non_tagged_cmd;
+	if (!ent) {
+		ent = esp_reconnect_with_tag(esp, lp);
+		if (!ent)
+			goto do_reset;
+	}
 
-	/* Ok, now it is safe to get commands going once more. */
-	if (esp->issue_SC)
-		esp_exec_cmd(esp);
+	esp->active_cmd = ent;
 
-	return do_intr_end;
-}
+	if (ent->flags & ESP_CMD_FLAG_ABORT) {
+		esp->msg_out[0] = ABORT_TASK_SET;
+		esp->msg_out_len = 1;
+		scsi_esp_cmd(esp, ESP_CMD_SATN);
+	}
 
-static int esp_do_resetbus(struct esp *esp)
-{
-	ESPLOG(("esp%d: Resetting scsi bus\n", esp->esp_id));
-	esp->resetting_bus = 1;
-	esp_cmd(esp, ESP_CMD_RS);
+	esp_event(esp, ESP_EVENT_CHECK_PHASE);
+	esp_restore_pointers(esp, ent);
+	esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+	return 1;
 
-	return do_intr_end;
+do_reset:
+	esp_schedule_reset(esp);
+	return 0;
 }
 
-/* Reset ESP chip, reset hanging bus, then kill active and
- * disconnected commands for targets without soft reset.
- *
- * The host_lock is acquired by caller.
- */
-static int esp_reset(struct scsi_cmnd *SCptr)
+static int esp_finish_select(struct esp *esp)
 {
-	struct esp *esp = (struct esp *) SCptr->device->host->hostdata;
+	struct esp_cmd_entry *ent;
+	struct scsi_cmnd *cmd;
+	u8 orig_select_state;
 
-	spin_lock_irq(esp->ehost->host_lock);
-	(void) esp_do_resetbus(esp);
-	spin_unlock_irq(esp->ehost->host_lock);
+	orig_select_state = esp->select_state;
 
-	wait_event(esp->reset_queue, (esp->resetting_bus == 0));
+	/* No longer selecting.  */
+	esp->select_state = ESP_SELECT_NONE;
 
-	return SUCCESS;
-}
+	esp->seqreg = esp_read8(ESP_SSTEP) & ESP_STEP_VBITS;
+	ent = esp->active_cmd;
+	cmd = ent->cmd;
 
-/* Internal ESP done function. */
-static void esp_done(struct esp *esp, int error)
-{
-	struct scsi_cmnd *done_SC = esp->current_SC;
+	if (esp->ops->dma_error(esp)) {
+		/* If we see a DMA error during or as a result of selection,
+		 * all bets are off.
+		 */
+		esp_schedule_reset(esp);
+		esp_cmd_is_done(esp, ent, cmd, (DID_ERROR << 16));
+		return 0;
+	}
 
-	esp->current_SC = NULL;
+	esp->ops->dma_invalidate(esp);
 
-	esp_release_dmabufs(esp, done_SC);
-	done_SC->result = error;
+	if (esp->ireg == (ESP_INTR_RSEL | ESP_INTR_FDONE)) {
+		struct esp_target_data *tp = &esp->target[cmd->device->id];
 
-	done_SC->scsi_done(done_SC);
+		/* Carefully back out of the selection attempt.  Release
+		 * resources (such as DMA mapping & TAG) and reset state (such
+		 * as message out and command delivery variables).
+		 */
+		if (!(ent->flags & ESP_CMD_FLAG_AUTOSENSE)) {
+			esp_unmap_dma(esp, cmd);
+			esp_free_lun_tag(ent, tp->lun[cmd->device->lun]);
+			tp->flags &= ~(ESP_TGT_NEGO_SYNC | ESP_TGT_NEGO_WIDE);
+			esp->flags &= ~ESP_FLAG_DOING_SLOWCMD;
+			esp->cmd_bytes_ptr = NULL;
+			esp->cmd_bytes_left = 0;
+		} else {
+			esp->ops->unmap_single(esp, ent->sense_dma,
+					       SCSI_SENSE_BUFFERSIZE,
+					       DMA_FROM_DEVICE);
+			ent->sense_ptr = NULL;
+		}
 
-	/* Bus is free, issue any commands in the queue. */
-	if (esp->issue_SC && !esp->current_SC)
-		esp_exec_cmd(esp);
+		/* Now that the state is unwound properly, put back onto
+		 * the issue queue.  This command is no longer active.
+		 */
+		list_del(&ent->list);
+		list_add(&ent->list, &esp->queued_cmds);
+		esp->active_cmd = NULL;
 
-}
+		/* Return value ignored by caller, it directly invokes
+		 * esp_reconnect().
+		 */
+		return 0;
+	}
 
-/* Wheee, ESP interrupt engine. */  
+	if (esp->ireg == ESP_INTR_DC) {
+		struct scsi_device *dev = cmd->device;
 
-/* Forward declarations. */
-static int esp_do_phase_determine(struct esp *esp);
-static int esp_do_data_finale(struct esp *esp);
-static int esp_select_complete(struct esp *esp);
-static int esp_do_status(struct esp *esp);
-static int esp_do_msgin(struct esp *esp);
-static int esp_do_msgindone(struct esp *esp);
-static int esp_do_msgout(struct esp *esp);
-static int esp_do_cmdbegin(struct esp *esp);
+		/* Disconnect.  Make sure we re-negotiate sync and
+		 * wide parameters if this target starts responding
+		 * again in the future.
+		 */
+		esp->target[dev->id].flags |= ESP_TGT_CHECK_NEGO;
 
-#define sreg_datainp(__sreg)  (((__sreg) & ESP_STAT_PMASK) == ESP_DIP)
-#define sreg_dataoutp(__sreg) (((__sreg) & ESP_STAT_PMASK) == ESP_DOP)
+		scsi_esp_cmd(esp, ESP_CMD_ESEL);
+		esp_cmd_is_done(esp, ent, cmd, (DID_BAD_TARGET << 16));
+		return 1;
+	}
 
-/* Read any bytes found in the FAS366 fifo, storing them into
- * the ESP driver software state structure.
- */
-static void hme_fifo_read(struct esp *esp)
-{
-	u8 count = 0;
-	u8 status = esp->sreg;
+	if (esp->ireg == (ESP_INTR_FDONE | ESP_INTR_BSERV)) {
+		/* Selection successful.  On pre-FAST chips we have
+		 * to do a NOP and possibly clean out the FIFO.
+		 */
+		if (esp->rev <= ESP236) {
+			int fcnt = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
 
-	/* Cannot safely frob the fifo for these following cases, but
-	 * we must always read the fifo when the reselect interrupt
-	 * is pending.
-	 */
-	if (((esp->ireg & ESP_INTR_RSEL) == 0)	&&
-	    (sreg_datainp(status)		||
-	     sreg_dataoutp(status)		||
-	     (esp->current_SC &&
-	      esp->current_SC->SCp.phase == in_data_done))) {
-		ESPHME(("<wkaround_skipped>"));
-	} else {
-		unsigned long fcnt = sbus_readb(esp->eregs + ESP_FFLAGS) & ESP_FF_FBYTES;
-
-		/* The HME stores bytes in multiples of 2 in the fifo. */
-		ESPHME(("hme_fifo[fcnt=%d", (int)fcnt));
-		while (fcnt) {
-			esp->hme_fifo_workaround_buffer[count++] =
-				sbus_readb(esp->eregs + ESP_FDATA);
-			esp->hme_fifo_workaround_buffer[count++] =
-				sbus_readb(esp->eregs + ESP_FDATA);
-			ESPHME(("<%02x,%02x>", esp->hme_fifo_workaround_buffer[count-2], esp->hme_fifo_workaround_buffer[count-1]));
-			fcnt--;
-		}
-		if (sbus_readb(esp->eregs + ESP_STATUS2) & ESP_STAT2_F1BYTE) {
-			ESPHME(("<poke_byte>"));
-			sbus_writeb(0, esp->eregs + ESP_FDATA);
-			esp->hme_fifo_workaround_buffer[count++] =
-				sbus_readb(esp->eregs + ESP_FDATA);
-			ESPHME(("<%02x,0x00>", esp->hme_fifo_workaround_buffer[count-1]));
-			ESPHME(("CMD_FLUSH"));
-			esp_cmd(esp, ESP_CMD_FLUSH);
-		} else {
-			ESPHME(("no_xtra_byte"));
+			scsi_esp_cmd(esp, ESP_CMD_NULL);
+
+			if (!fcnt &&
+			    (!esp->prev_soff ||
+			     ((esp->sreg & ESP_STAT_PMASK) != ESP_DIP)))
+				esp_flush_fifo(esp);
 		}
+
+		/* If we are doing a slow command, negotiation, etc.
+		 * we'll do the right thing as we transition to the
+		 * next phase.
+		 */
+		esp_event(esp, ESP_EVENT_CHECK_PHASE);
+		return 0;
 	}
-	ESPHME(("wkarnd_cnt=%d]", (int)count));
-	esp->hme_fifo_workaround_count = count;
+
+	printk("ESP: Unexpected selection completion ireg[%x].\n",
+	       esp->ireg);
+	esp_schedule_reset(esp);
+	return 0;
 }
 
-static inline void hme_fifo_push(struct esp *esp, u8 *bytes, u8 count)
+static int esp_data_bytes_sent(struct esp *esp, struct esp_cmd_entry *ent,
+			       struct scsi_cmnd *cmd)
 {
-	esp_cmd(esp, ESP_CMD_FLUSH);
-	while (count) {
-		u8 tmp = *bytes++;
-		sbus_writeb(tmp, esp->eregs + ESP_FDATA);
-		sbus_writeb(0, esp->eregs + ESP_FDATA);
-		count--;
+	int fifo_cnt, ecount, bytes_sent, flush_fifo;
+
+	fifo_cnt = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
+	if (esp->prev_cfg3 & ESP_CONFIG3_EWIDE)
+		fifo_cnt <<= 1;
+
+	ecount = 0;
+	if (!(esp->sreg & ESP_STAT_TCNT)) {
+		ecount = ((unsigned int)esp_read8(ESP_TCLOW) |
+			  (((unsigned int)esp_read8(ESP_TCMED)) << 8));
+		if (esp->rev == FASHME)
+			ecount |= ((unsigned int)esp_read8(FAS_RLO)) << 16;
 	}
-}
 
-/* We try to avoid some interrupts by jumping ahead and see if the ESP
- * has gotten far enough yet.  Hence the following.
- */
-static inline int skipahead1(struct esp *esp, struct scsi_cmnd *scp,
-			     int prev_phase, int new_phase)
-{
-	if (scp->SCp.sent_command != prev_phase)
-		return 0;
-	if (ESP_IRQ_P(esp->dregs)) {
-		/* Yes, we are able to save an interrupt. */
-		if (esp->erev == fashme)
-			esp->sreg2 = sbus_readb(esp->eregs + ESP_STATUS2);
-		esp->sreg = (sbus_readb(esp->eregs + ESP_STATUS) & ~(ESP_STAT_INTR));
-		esp->ireg = sbus_readb(esp->eregs + ESP_INTRPT);
-		if (esp->erev == fashme) {
-			/* This chip is really losing. */
-			ESPHME(("HME["));
-			/* Must latch fifo before reading the interrupt
-			 * register else garbage ends up in the FIFO
-			 * which confuses the driver utterly.
-			 * Happy Meal indeed....
+	bytes_sent = esp->data_dma_len;
+	bytes_sent -= ecount;
+
+	if (!(ent->flags & ESP_CMD_FLAG_WRITE))
+		bytes_sent -= fifo_cnt;
+
+	flush_fifo = 0;
+	if (!esp->prev_soff) {
+		/* Synchronous data transfer, always flush fifo. */
+		flush_fifo = 1;
+	} else {
+		if (esp->rev == ESP100) {
+			u32 fflags, phase;
+
+			/* ESP100 has a chip bug where in the synchronous data
+			 * phase it can mistake a final long REQ pulse from the
+			 * target as an extra data byte.  Fun.
+			 * 
+			 * To detect this case we resample the status register
+			 * and fifo flags.  If we're still in a data phase and
+			 * we see spurious chunks in the fifo, we return error
+			 * to the caller which should reset and set things up
+			 * such that we only try future transfers to this
+			 * target in synchronous mode.
 			 */
-			ESPHME(("fifo_workaround]"));
-			if (!(esp->sreg2 & ESP_STAT2_FEMPTY) ||
-			    (esp->sreg2 & ESP_STAT2_F1BYTE))
-				hme_fifo_read(esp);
+			esp->sreg = esp_read8(ESP_STATUS);
+			phase = esp->sreg & ESP_STAT_PMASK;
+			fflags = esp_read8(ESP_FFLAGS);
+
+			if ((phase == ESP_DOP &&
+			     (fflags & ESP_FF_ONOTZERO)) ||
+			    (phase == ESP_DIP &&
+			     (fflags & ESP_FF_FBYTES)))
+				return -1;
 		}
-		if (!(esp->ireg & ESP_INTR_SR))
-			return 0;
-		else
-			return do_reset_complete;
+		if (!(ent->flags & ESP_CMD_FLAG_WRITE))
+			flush_fifo = 1;
 	}
-	/* Ho hum, target is taking forever... */
-	scp->SCp.sent_command = new_phase; /* so we don't recurse... */
-	return do_intr_end;
+
+	if (flush_fifo)
+		esp_flush_fifo(esp);
+
+	return bytes_sent;
 }
 
-static inline int skipahead2(struct esp *esp, struct scsi_cmnd *scp,
-			     int prev_phase1, int prev_phase2, int new_phase)
+static void esp_setsync(struct esp *esp, struct esp_target_data *tp,
+			u8 scsi_period, u8 scsi_offset,
+			u8 esp_stp, u8 esp_soff)
 {
-	if (scp->SCp.sent_command != prev_phase1 &&
-	    scp->SCp.sent_command != prev_phase2)
-		return 0;
-	if (ESP_IRQ_P(esp->dregs)) {
-		/* Yes, we are able to save an interrupt. */
-		if (esp->erev == fashme)
-			esp->sreg2 = sbus_readb(esp->eregs + ESP_STATUS2);
-		esp->sreg = (sbus_readb(esp->eregs + ESP_STATUS) & ~(ESP_STAT_INTR));
-		esp->ireg = sbus_readb(esp->eregs + ESP_INTRPT);
-		if (esp->erev == fashme) {
-			/* This chip is really losing. */
-			ESPHME(("HME["));
-
-			/* Must latch fifo before reading the interrupt
-			 * register else garbage ends up in the FIFO
-			 * which confuses the driver utterly.
-			 * Happy Meal indeed....
-			 */
-			ESPHME(("fifo_workaround]"));
-			if (!(esp->sreg2 & ESP_STAT2_FEMPTY) ||
-			    (esp->sreg2 & ESP_STAT2_F1BYTE))
-				hme_fifo_read(esp);
+	spi_period(tp->starget) = scsi_period;
+	spi_offset(tp->starget) = scsi_offset;
+	spi_width(tp->starget) = (tp->flags & ESP_TGT_WIDE) ? 1 : 0;
+
+	if (esp_soff) {
+		esp_stp &= 0x1f;
+		esp_soff |= esp->radelay;
+		if (esp->rev >= FAS236) {
+			u8 bit = ESP_CONFIG3_FSCSI;
+			if (esp->rev >= FAS100A)
+				bit = ESP_CONFIG3_FAST;
+
+			if (scsi_period < 50) {
+				if (esp->rev == FASHME)
+					esp_soff &= ~esp->radelay;
+				tp->esp_config3 |= bit;
+			} else {
+				tp->esp_config3 &= ~bit;
+			}
+			esp->prev_cfg3 = tp->esp_config3;
+			esp_write8(esp->prev_cfg3, ESP_CFG3);
 		}
-		if (!(esp->ireg & ESP_INTR_SR))
-			return 0;
-		else
-			return do_reset_complete;
 	}
-	/* Ho hum, target is taking forever... */
-	scp->SCp.sent_command = new_phase; /* so we don't recurse... */
-	return do_intr_end;
-}
 
-/* Now some dma helpers. */
-static void dma_setup(struct esp *esp, __u32 addr, int count, int write)
-{
-	u32 nreg = sbus_readl(esp->dregs + DMA_CSR);
+	tp->esp_period = esp->prev_stp = esp_stp;
+	tp->esp_offset = esp->prev_soff = esp_soff;
 
-	if (write)
-		nreg |= DMA_ST_WRITE;
-	else
-		nreg &= ~(DMA_ST_WRITE);
-	nreg |= DMA_ENABLE;
-	sbus_writel(nreg, esp->dregs + DMA_CSR);
-	if (esp->dma->revision == dvmaesc1) {
-		/* This ESC gate array sucks! */
-		__u32 src = addr;
-		__u32 dest = src + count;
-
-		if (dest & (PAGE_SIZE - 1))
-			count = PAGE_ALIGN(count);
-		sbus_writel(count, esp->dregs + DMA_COUNT);
-	}
-	sbus_writel(addr, esp->dregs + DMA_ADDR);
-}
+	esp_write8(esp_soff, ESP_SOFF);
+	esp_write8(esp_stp, ESP_STP);
 
-static void dma_drain(struct esp *esp)
-{
-	u32 tmp;
+	tp->flags &= ~(ESP_TGT_NEGO_SYNC | ESP_TGT_CHECK_NEGO);
 
-	if (esp->dma->revision == dvmahme)
-		return;
-	if ((tmp = sbus_readl(esp->dregs + DMA_CSR)) & DMA_FIFO_ISDRAIN) {
-		switch (esp->dma->revision) {
-		default:
-			tmp |= DMA_FIFO_STDRAIN;
-			sbus_writel(tmp, esp->dregs + DMA_CSR);
-
-		case dvmarev3:
-		case dvmaesc1:
-			while (sbus_readl(esp->dregs + DMA_CSR) & DMA_FIFO_ISDRAIN)
-				udelay(1);
-		};
-	}
+	spi_display_xfer_agreement(tp->starget);
 }
 
-static void dma_invalidate(struct esp *esp)
+static void esp_msgin_reject(struct esp *esp)
 {
-	u32 tmp;
+	struct esp_cmd_entry *ent = esp->active_cmd;
+	struct scsi_cmnd *cmd = ent->cmd;
+	struct esp_target_data *tp;
+	int tgt;
 
-	if (esp->dma->revision == dvmahme) {
-		sbus_writel(DMA_RST_SCSI, esp->dregs + DMA_CSR);
+	tgt = cmd->device->id;
+	tp = &esp->target[tgt];
 
-		esp->prev_hme_dmacsr = ((esp->prev_hme_dmacsr |
-					 (DMA_PARITY_OFF | DMA_2CLKS |
-					  DMA_SCSI_DISAB | DMA_INT_ENAB)) &
-					~(DMA_ST_WRITE | DMA_ENABLE));
+	if (tp->flags & ESP_TGT_NEGO_WIDE) {
+		tp->flags &= ~(ESP_TGT_NEGO_WIDE | ESP_TGT_WIDE);
 
-		sbus_writel(0, esp->dregs + DMA_CSR);
-		sbus_writel(esp->prev_hme_dmacsr, esp->dregs + DMA_CSR);
-
-		/* This is necessary to avoid having the SCSI channel
-		 * engine lock up on us.
-		 */
-		sbus_writel(0, esp->dregs + DMA_ADDR);
-	} else {
-		while ((tmp = sbus_readl(esp->dregs + DMA_CSR)) & DMA_PEND_READ)
-			udelay(1);
+		if (!esp_need_to_nego_sync(tp)) {
+			tp->flags &= ~ESP_TGT_CHECK_NEGO;
+			scsi_esp_cmd(esp, ESP_CMD_RATN);
+		} else {
+			esp_build_sync_msg(esp,
+					   tp->nego_goal_period,
+					   tp->nego_goal_offset);
+			tp->flags |= ESP_TGT_NEGO_SYNC;
+			scsi_esp_cmd(esp, ESP_CMD_SATN);
+		}
+		return;
+	}
 
-		tmp &= ~(DMA_ENABLE | DMA_ST_WRITE | DMA_BCNT_ENAB);
-		tmp |= DMA_FIFO_INV;
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-		tmp &= ~DMA_FIFO_INV;
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
+	if (tp->flags & ESP_TGT_NEGO_SYNC) {
+		tp->flags &= ~(ESP_TGT_NEGO_SYNC | ESP_TGT_CHECK_NEGO);
+		tp->esp_period = 0;
+		tp->esp_offset = 0;
+		esp_setsync(esp, tp, 0, 0, 0, 0);
+		scsi_esp_cmd(esp, ESP_CMD_RATN);
+		return;
 	}
-}
 
-static inline void dma_flashclear(struct esp *esp)
-{
-	dma_drain(esp);
-	dma_invalidate(esp);
+	esp->msg_out[0] = ABORT_TASK_SET;
+	esp->msg_out_len = 1;
+	scsi_esp_cmd(esp, ESP_CMD_SATN);
 }
 
-static int dma_can_transfer(struct esp *esp, struct scsi_cmnd *sp)
+static void esp_msgin_sdtr(struct esp *esp, struct esp_target_data *tp)
 {
-	__u32 base, end, sz;
+	u8 period = esp->msg_in[3];
+	u8 offset = esp->msg_in[4];
+	u8 stp;
 
-	if (esp->dma->revision == dvmarev3) {
-		sz = sp->SCp.this_residual;
-		if (sz > 0x1000000)
-			sz = 0x1000000;
-	} else {
-		base = ((__u32)((unsigned long)sp->SCp.ptr));
-		base &= (0x1000000 - 1);
-		end = (base + sp->SCp.this_residual);
-		if (end > 0x1000000)
-			end = 0x1000000;
-		sz = (end - base);
-	}
-	return sz;
-}
+	if (!(tp->flags & ESP_TGT_NEGO_SYNC))
+		goto do_reject;
 
-/* Misc. esp helper macros. */
-#define esp_setcount(__eregs, __cnt, __hme) \
-	sbus_writeb(((__cnt)&0xff), (__eregs) + ESP_TCLOW); \
-	sbus_writeb((((__cnt)>>8)&0xff), (__eregs) + ESP_TCMED); \
-	if (__hme) { \
-		sbus_writeb((((__cnt)>>16)&0xff), (__eregs) + FAS_RLO); \
-		sbus_writeb(0, (__eregs) + FAS_RHI); \
-	}
+	if (offset > 15)
+		goto do_reject;
 
-#define esp_getcount(__eregs, __hme) \
-	((sbus_readb((__eregs) + ESP_TCLOW)&0xff) | \
-	 ((sbus_readb((__eregs) + ESP_TCMED)&0xff) << 8) | \
-         ((__hme) ? sbus_readb((__eregs) + FAS_RLO) << 16 : 0))
+	if (offset) {
+		int rounded_up, one_clock;
 
-#define fcount(__esp) \
-	(((__esp)->erev == fashme) ? \
-	  (__esp)->hme_fifo_workaround_count : \
-	  sbus_readb(((__esp)->eregs) + ESP_FFLAGS) & ESP_FF_FBYTES)
-
-#define fnzero(__esp) \
-	(((__esp)->erev == fashme) ? 0 : \
-	 sbus_readb(((__esp)->eregs) + ESP_FFLAGS) & ESP_FF_ONOTZERO)
-
-/* XXX speculative nops unnecessary when continuing amidst a data phase
- * XXX even on esp100!!!  another case of flooding the bus with I/O reg
- * XXX writes...
- */
-#define esp_maybe_nop(__esp) \
-	if ((__esp)->erev == esp100) \
-		esp_cmd((__esp), ESP_CMD_NULL)
-
-#define sreg_to_dataphase(__sreg) \
-	((((__sreg) & ESP_STAT_PMASK) == ESP_DOP) ? in_dataout : in_datain)
-
-/* The ESP100 when in synchronous data phase, can mistake a long final
- * REQ pulse from the target as an extra byte, it places whatever is on
- * the data lines into the fifo.  For now, we will assume when this
- * happens that the target is a bit quirky and we don't want to
- * be talking synchronously to it anyways.  Regardless, we need to
- * tell the ESP to eat the extraneous byte so that we can proceed
- * to the next phase.
- */
-static int esp100_sync_hwbug(struct esp *esp, struct scsi_cmnd *sp, int fifocnt)
-{
-	/* Do not touch this piece of code. */
-	if ((!(esp->erev == esp100)) ||
-	    (!(sreg_datainp((esp->sreg = sbus_readb(esp->eregs + ESP_STATUS))) &&
-	       !fifocnt) &&
-	     !(sreg_dataoutp(esp->sreg) && !fnzero(esp)))) {
-		if (sp->SCp.phase == in_dataout)
-			esp_cmd(esp, ESP_CMD_FLUSH);
-		return 0;
+		if (period > esp->max_period) {
+			period = offset = 0;
+			goto do_sdtr;
+		}
+		if (period < esp->min_period)
+			goto do_reject;
+
+		one_clock = esp->ccycle / 1000;
+		rounded_up = (period << 2);
+		rounded_up = (rounded_up + one_clock - 1) / one_clock;
+		stp = rounded_up;
+		if (stp && esp->rev >= FAS236) {
+			if (stp >= 50)
+				stp--;
+		}
 	} else {
-		/* Async mode for this guy. */
-		build_sync_nego_msg(esp, 0, 0);
-
-		/* Ack the bogus byte, but set ATN first. */
-		esp_cmd(esp, ESP_CMD_SATN);
-		esp_cmd(esp, ESP_CMD_MOK);
-		return 1;
+		stp = 0;
 	}
-}
 
-/* This closes the window during a selection with a reselect pending, because
- * we use DMA for the selection process the FIFO should hold the correct
- * contents if we get reselected during this process.  So we just need to
- * ack the possible illegal cmd interrupt pending on the esp100.
- */
-static inline int esp100_reconnect_hwbug(struct esp *esp)
-{
-	u8 tmp;
+	esp_setsync(esp, tp, period, offset, stp, offset);
+	return;
 
-	if (esp->erev != esp100)
-		return 0;
-	tmp = sbus_readb(esp->eregs + ESP_INTRPT);
-	if (tmp & ESP_INTR_SR)
-		return 1;
-	return 0;
-}
+do_reject:
+	esp->msg_out[0] = MESSAGE_REJECT;
+	esp->msg_out_len = 1;
+	scsi_esp_cmd(esp, ESP_CMD_SATN);
+	return;
 
-/* This verifies the BUSID bits during a reselection so that we know which
- * target is talking to us.
- */
-static inline int reconnect_target(struct esp *esp)
-{
-	int it, me = esp->scsi_id_mask, targ = 0;
-
-	if (2 != fcount(esp))
-		return -1;
-	if (esp->erev == fashme) {
-		/* HME does not latch it's own BUS ID bits during
-		 * a reselection.  Also the target number is given
-		 * as an unsigned char, not as a sole bit number
-		 * like the other ESP's do.
-		 * Happy Meal indeed....
-		 */
-		targ = esp->hme_fifo_workaround_buffer[0];
-	} else {
-		it = sbus_readb(esp->eregs + ESP_FDATA);
-		if (!(it & me))
-			return -1;
-		it &= ~me;
-		if (it & (it - 1))
-			return -1;
-		while (!(it & 1))
-			targ++, it >>= 1;
-	}
-	return targ;
+do_sdtr:
+	tp->nego_goal_period = period;
+	tp->nego_goal_offset = offset;
+	esp_build_sync_msg(esp,
+			   tp->nego_goal_period,
+			   tp->nego_goal_offset);
+	scsi_esp_cmd(esp, ESP_CMD_SATN);
 }
 
-/* This verifies the identify from the target so that we know which lun is
- * being reconnected.
- */
-static inline int reconnect_lun(struct esp *esp)
+static void esp_msgin_wdtr(struct esp *esp, struct esp_target_data *tp)
 {
-	int lun;
+	int size = 8 << esp->msg_in[3];
+	u8 cfg3;
 
-	if ((esp->sreg & ESP_STAT_PMASK) != ESP_MIP)
-		return -1;
-	if (esp->erev == fashme)
-		lun = esp->hme_fifo_workaround_buffer[1];
-	else
-		lun = sbus_readb(esp->eregs + ESP_FDATA);
+	if (esp->rev != FASHME)
+		goto do_reject;
+		
+	if (size != 8 && size != 16)
+		goto do_reject;
 
-	/* Yes, you read this correctly.  We report lun of zero
-	 * if we see parity error.  ESP reports parity error for
-	 * the lun byte, and this is the only way to hope to recover
-	 * because the target is connected.
-	 */
-	if (esp->sreg & ESP_STAT_PERR)
-		return 0;
+	if (!(tp->flags & ESP_TGT_NEGO_WIDE))
+		goto do_reject;
 
-	/* Check for illegal bits being set in the lun. */
-	if ((lun & 0x40) || !(lun & 0x80))
-		return -1;
+	cfg3 = tp->esp_config3;
+	if (size == 16) {
+		tp->flags |= ESP_TGT_WIDE;
+		cfg3 |= ESP_CONFIG3_EWIDE;
+	} else {
+		tp->flags &= ~ESP_TGT_WIDE;
+		cfg3 &= ~ESP_CONFIG3_EWIDE;
+	}
+	tp->esp_config3 = cfg3;
+	esp->prev_cfg3 = cfg3;
+	esp_write8(cfg3, ESP_CFG3);
 
-	return lun & 7;
-}
+	tp->flags &= ~ESP_TGT_NEGO_WIDE;
 
-/* This puts the driver in a state where it can revitalize a command that
- * is being continued due to reselection.
- */
-static inline void esp_connect(struct esp *esp, struct scsi_cmnd *sp)
-{
-	struct esp_device *esp_dev = sp->device->hostdata;
-
-	if (esp->prev_soff  != esp_dev->sync_max_offset ||
-	    esp->prev_stp   != esp_dev->sync_min_period ||
-	    (esp->erev > esp100a &&
-	     esp->prev_cfg3 != esp->config3[sp->device->id])) {
-		esp->prev_soff = esp_dev->sync_max_offset;
-		esp->prev_stp = esp_dev->sync_min_period;
-		sbus_writeb(esp->prev_soff, esp->eregs + ESP_SOFF);
-		sbus_writeb(esp->prev_stp, esp->eregs + ESP_STP);
-		if (esp->erev > esp100a) {
-			esp->prev_cfg3 = esp->config3[sp->device->id];
-			sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-		}
+	spi_period(tp->starget) = 0;
+	spi_offset(tp->starget) = 0;
+	if (!esp_need_to_nego_sync(tp)) {
+		tp->flags &= ~ESP_TGT_CHECK_NEGO;
+		scsi_esp_cmd(esp, ESP_CMD_RATN);
+	} else {
+		esp_build_sync_msg(esp,
+				   tp->nego_goal_period,
+				   tp->nego_goal_offset);
+		tp->flags |= ESP_TGT_NEGO_SYNC;
+		scsi_esp_cmd(esp, ESP_CMD_SATN);
 	}
-	esp->current_SC = sp;
-}
+	return;
 
-/* This will place the current working command back into the issue queue
- * if we are to receive a reselection amidst a selection attempt.
- */
-static inline void esp_reconnect(struct esp *esp, struct scsi_cmnd *sp)
-{
-	if (!esp->disconnected_SC)
-		ESPLOG(("esp%d: Weird, being reselected but disconnected "
-			"command queue is empty.\n", esp->esp_id));
-	esp->snip = 0;
-	esp->current_SC = NULL;
-	sp->SCp.phase = not_issued;
-	append_SC(&esp->issue_SC, sp);
+do_reject:
+	esp->msg_out[0] = MESSAGE_REJECT;
+	esp->msg_out_len = 1;
+	scsi_esp_cmd(esp, ESP_CMD_SATN);
 }
 
-/* Begin message in phase. */
-static int esp_do_msgin(struct esp *esp)
+static void esp_msgin_extended(struct esp *esp)
 {
-	/* Must be very careful with the fifo on the HME */
-	if ((esp->erev != fashme) ||
-	    !(sbus_readb(esp->eregs + ESP_STATUS2) & ESP_STAT2_FEMPTY))
-		esp_cmd(esp, ESP_CMD_FLUSH);
-	esp_maybe_nop(esp);
-	esp_cmd(esp, ESP_CMD_TI);
-	esp->msgin_len = 1;
-	esp->msgin_ctr = 0;
-	esp_advance_phase(esp->current_SC, in_msgindone);
-	return do_work_bus;
-}
+	struct esp_cmd_entry *ent = esp->active_cmd;
+	struct scsi_cmnd *cmd = ent->cmd;
+	struct esp_target_data *tp;
+	int tgt = cmd->device->id;
 
-/* This uses various DMA csr fields and the fifo flags count value to
- * determine how many bytes were successfully sent/received by the ESP.
- */
-static inline int esp_bytes_sent(struct esp *esp, int fifo_count)
-{
-	int rval = sbus_readl(esp->dregs + DMA_ADDR) - esp->esp_command_dvma;
+	tp = &esp->target[tgt];
+	if (esp->msg_in[2] == EXTENDED_SDTR) {
+		esp_msgin_sdtr(esp, tp);
+		return;
+	}
+	if (esp->msg_in[2] == EXTENDED_WDTR) {
+		esp_msgin_wdtr(esp, tp);
+		return;
+	}
 
-	if (esp->dma->revision == dvmarev1)
-		rval -= (4 - ((sbus_readl(esp->dregs + DMA_CSR) & DMA_READ_AHEAD)>>11));
-	return rval - fifo_count;
-}
+	printk("ESP: Unexpected extended msg type %x\n",
+	       esp->msg_in[2]);
 
-static inline void advance_sg(struct scsi_cmnd *sp)
-{
-	++sp->SCp.buffer;
-	--sp->SCp.buffers_residual;
-	sp->SCp.this_residual = sg_dma_len(sp->SCp.buffer);
-	sp->SCp.ptr = (char *)((unsigned long)sg_dma_address(sp->SCp.buffer));
+	esp->msg_out[0] = ABORT_TASK_SET;
+	esp->msg_out_len = 1;
+	scsi_esp_cmd(esp, ESP_CMD_SATN);
 }
 
-/* Please note that the way I've coded these routines is that I _always_
- * check for a disconnect during any and all information transfer
- * phases.  The SCSI standard states that the target _can_ cause a BUS
- * FREE condition by dropping all MSG/CD/IO/BSY signals.  Also note
- * that during information transfer phases the target controls every
- * change in phase, the only thing the initiator can do is "ask" for
- * a message out phase by driving ATN true.  The target can, and sometimes
- * will, completely ignore this request so we cannot assume anything when
- * we try to force a message out phase to abort/reset a target.  Most of
- * the time the target will eventually be nice and go to message out, so
- * we may have to hold on to our state about what we want to tell the target
- * for some period of time.
- */
-
-/* I think I have things working here correctly.  Even partial transfers
- * within a buffer or sub-buffer should not upset us at all no matter
- * how bad the target and/or ESP fucks things up.
+/* Analyze msgin bytes received from target so far.  Return non-zero
+ * if there are more bytes needed to complete the message.
  */
-static int esp_do_data(struct esp *esp)
+static int esp_msgin_process(struct esp *esp)
 {
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	int thisphase, hmuch;
-
-	ESPDATA(("esp_do_data: "));
-	esp_maybe_nop(esp);
-	thisphase = sreg_to_dataphase(esp->sreg);
-	esp_advance_phase(SCptr, thisphase);
-	ESPDATA(("newphase<%s> ", (thisphase == in_datain) ? "DATAIN" : "DATAOUT"));
-	hmuch = dma_can_transfer(esp, SCptr);
-	if (hmuch > (64 * 1024) && (esp->erev != fashme))
-		hmuch = (64 * 1024);
-	ESPDATA(("hmuch<%d> ", hmuch));
-	esp->current_transfer_size = hmuch;
-
-	if (esp->erev == fashme) {
-		u32 tmp = esp->prev_hme_dmacsr;
-
-		/* Always set the ESP count registers first. */
-		esp_setcount(esp->eregs, hmuch, 1);
-
-		/* Get the DMA csr computed. */
-		tmp |= (DMA_SCSI_DISAB | DMA_ENABLE);
-		if (thisphase == in_datain)
-			tmp |= DMA_ST_WRITE;
-		else
-			tmp &= ~(DMA_ST_WRITE);
-		esp->prev_hme_dmacsr = tmp;
-
-		ESPDATA(("DMA|TI --> do_intr_end\n"));
-		if (thisphase == in_datain) {
-			sbus_writel(hmuch, esp->dregs + DMA_COUNT);
-			esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-		} else {
-			esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-			sbus_writel(hmuch, esp->dregs + DMA_COUNT);
-		}
-		sbus_writel((__u32)((unsigned long)SCptr->SCp.ptr), esp->dregs+DMA_ADDR);
-		sbus_writel(esp->prev_hme_dmacsr, esp->dregs + DMA_CSR);
-	} else {
-		esp_setcount(esp->eregs, hmuch, 0);
-		dma_setup(esp, ((__u32)((unsigned long)SCptr->SCp.ptr)),
-			  hmuch, (thisphase == in_datain));
-		ESPDATA(("DMA|TI --> do_intr_end\n"));
-		esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-	}
-	return do_intr_end;
-}
+	u8 msg0 = esp->msg_in[0];
+	int len = esp->msg_in_len;
 
-/* See how successful the data transfer was. */
-static int esp_do_data_finale(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	struct esp_device *esp_dev = SCptr->device->hostdata;
-	int bogus_data = 0, bytes_sent = 0, fifocnt, ecount = 0;
-
-	ESPDATA(("esp_do_data_finale: "));
-
-	if (SCptr->SCp.phase == in_datain) {
-		if (esp->sreg & ESP_STAT_PERR) {
-			/* Yuck, parity error.  The ESP asserts ATN
-			 * so that we can go to message out phase
-			 * immediately and inform the target that
-			 * something bad happened.
-			 */
-			ESPLOG(("esp%d: data bad parity detected.\n",
-				esp->esp_id));
-			esp->cur_msgout[0] = INITIATOR_ERROR;
-			esp->msgout_len = 1;
-		}
-		dma_drain(esp);
+	if (msg0 & 0x80) {
+		/* Identify */
+		printk("ESP: Unexpected msgin identify\n");
+		return 0;
 	}
-	dma_invalidate(esp);
-
-	/* This could happen for the above parity error case. */
-	if (esp->ireg != ESP_INTR_BSERV) {
-		/* Please go to msgout phase, please please please... */
-		ESPLOG(("esp%d: !BSERV after data, probably to msgout\n",
-			esp->esp_id));
-		return esp_do_phase_determine(esp);
-	}	
-
-	/* Check for partial transfers and other horrible events.
-	 * Note, here we read the real fifo flags register even
-	 * on HME broken adapters because we skip the HME fifo
-	 * workaround code in esp_handle() if we are doing data
-	 * phase things.  We don't want to fuck directly with
-	 * the fifo like that, especially if doing synchronous
-	 * transfers!  Also, will need to double the count on
-	 * HME if we are doing wide transfers, as the HME fifo
-	 * will move and count 16-bit quantities during wide data.
-	 * SMCC _and_ Qlogic can both bite me.
-	 */
-	fifocnt = (sbus_readb(esp->eregs + ESP_FFLAGS) & ESP_FF_FBYTES);
-	if (esp->erev != fashme)
-		ecount = esp_getcount(esp->eregs, 0);
-	bytes_sent = esp->current_transfer_size;
-
-	ESPDATA(("trans_sz(%d), ", bytes_sent));
-	if (esp->erev == fashme) {
-		if (!(esp->sreg & ESP_STAT_TCNT)) {
-			ecount = esp_getcount(esp->eregs, 1);
-			bytes_sent -= ecount;
-		}
 
-		/* Always subtract any cruft remaining in the FIFO. */
-		if (esp->prev_cfg3 & ESP_CONFIG3_EWIDE)
-			fifocnt <<= 1;
-		if (SCptr->SCp.phase == in_dataout)
-			bytes_sent -= fifocnt;
-
-		/* I have an IBM disk which exhibits the following
-		 * behavior during writes to it.  It disconnects in
-		 * the middle of a partial transfer, the current sglist
-		 * buffer is 1024 bytes, the disk stops data transfer
-		 * at 512 bytes.
-		 *
-		 * However the FAS366 reports that 32 more bytes were
-		 * transferred than really were.  This is precisely
-		 * the size of a fully loaded FIFO in wide scsi mode.
-		 * The FIFO state recorded indicates that it is empty.
-		 *
-		 * I have no idea if this is a bug in the FAS366 chip
-		 * or a bug in the firmware on this IBM disk.  In any
-		 * event the following seems to be a good workaround.  -DaveM
-		 */
-		if (bytes_sent != esp->current_transfer_size &&
-		    SCptr->SCp.phase == in_dataout) {
-			int mask = (64 - 1);
+	switch (msg0) {
+	case EXTENDED_MESSAGE:
+		if (len == 1)
+			return 1;
+		if (len < esp->msg_in[1] + 2)
+			return 1;
+		esp_msgin_extended(esp);
+		return 0;
 
-			if ((esp->prev_cfg3 & ESP_CONFIG3_EWIDE) == 0)
-				mask >>= 1;
+	case IGNORE_WIDE_RESIDUE: {
+		struct esp_cmd_entry *ent;
+		struct esp_cmd_priv *spriv;
+		if (len == 1)
+			return 1;
 
-			if (bytes_sent & mask)
-				bytes_sent -= (bytes_sent & mask);
-		}
-	} else {
-		if (!(esp->sreg & ESP_STAT_TCNT))
-			bytes_sent -= ecount;
-		if (SCptr->SCp.phase == in_dataout)
-			bytes_sent -= fifocnt;
-	}
+		if (esp->msg_in[1] != 1)
+			goto do_reject;
 
-	ESPDATA(("bytes_sent(%d), ", bytes_sent));
+		ent = esp->active_cmd;
+		spriv = ESP_CMD_PRIV(ent->cmd);
 
-	/* If we were in synchronous mode, check for peculiarities. */
-	if (esp->erev == fashme) {
-		if (esp_dev->sync_max_offset) {
-			if (SCptr->SCp.phase == in_dataout)
-				esp_cmd(esp, ESP_CMD_FLUSH);
+		if (spriv->mapping_type == MAPPING_TYPE_SINGLE) {
+			spriv->cur_residue++;
 		} else {
-			esp_cmd(esp, ESP_CMD_FLUSH);
+			if (spriv->cur_residue == sg_dma_len(spriv->cur_sg)) {
+				spriv->cur_sg--;
+				spriv->cur_residue = 1;
+			} else
+				spriv->cur_residue++;
 		}
-	} else {
-		if (esp_dev->sync_max_offset)
-			bogus_data = esp100_sync_hwbug(esp, SCptr, fifocnt);
-		else
-			esp_cmd(esp, ESP_CMD_FLUSH);
+		spriv->tot_residue++;
+		return 0;
 	}
+	case NOP:
+		return 0;
+	case RESTORE_POINTERS:
+		esp_restore_pointers(esp, esp->active_cmd);
+		return 0;
+	case SAVE_POINTERS:
+		esp_save_pointers(esp, esp->active_cmd);
+		return 0;
 
-	/* Until we are sure of what has happened, we are certainly
-	 * in the dark.
-	 */
-	esp_advance_phase(SCptr, in_the_dark);
-
-	if (bytes_sent < 0) {
-		/* I've seen this happen due to lost state in this
-		 * driver.  No idea why it happened, but allowing
-		 * this value to be negative caused things to
-		 * lock up.  This allows greater chance of recovery.
-		 * In fact every time I've seen this, it has been
-		 * a driver bug without question.
-		 */
-		ESPLOG(("esp%d: yieee, bytes_sent < 0!\n", esp->esp_id));
-		ESPLOG(("esp%d: csz=%d fifocount=%d ecount=%d\n",
-			esp->esp_id,
-			esp->current_transfer_size, fifocnt, ecount));
-		ESPLOG(("esp%d: use_sg=%d ptr=%p this_residual=%d\n",
-			esp->esp_id,
-			SCptr->use_sg, SCptr->SCp.ptr, SCptr->SCp.this_residual));
-		ESPLOG(("esp%d: Forcing async for target %d\n", esp->esp_id, 
-			SCptr->device->id));
-		SCptr->device->borken = 1;
-		esp_dev->sync = 0;
-		bytes_sent = 0;
-	}
+	case COMMAND_COMPLETE:
+	case DISCONNECT: {
+		struct esp_cmd_entry *ent = esp->active_cmd;
 
-	/* Update the state of our transfer. */
-	SCptr->SCp.ptr += bytes_sent;
-	SCptr->SCp.this_residual -= bytes_sent;
-	if (SCptr->SCp.this_residual < 0) {
-		/* shit */
-		ESPLOG(("esp%d: Data transfer overrun.\n", esp->esp_id));
-		SCptr->SCp.this_residual = 0;
+		ent->message = msg0;
+		esp_event(esp, ESP_EVENT_FREE_BUS);
+		esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+		return 0;
 	}
+	case MESSAGE_REJECT:
+		esp_msgin_reject(esp);
+		return 0;
 
-	/* Maybe continue. */
-	if (!bogus_data) {
-		ESPDATA(("!bogus_data, "));
-
-		/* NO MATTER WHAT, we advance the scatterlist,
-		 * if the target should decide to disconnect
-		 * in between scatter chunks (which is common)
-		 * we could die horribly!  I used to have the sg
-		 * advance occur only if we are going back into
-		 * (or are staying in) a data phase, you can
-		 * imagine the hell I went through trying to
-		 * figure this out.
-		 */
-		if (SCptr->use_sg && !SCptr->SCp.this_residual)
-			advance_sg(SCptr);
-		if (sreg_datainp(esp->sreg) || sreg_dataoutp(esp->sreg)) {
-			ESPDATA(("to more data\n"));
-			return esp_do_data(esp);
-		}
-		ESPDATA(("to new phase\n"));
-		return esp_do_phase_determine(esp);
+	default:
+	do_reject:
+		esp->msg_out[0] = MESSAGE_REJECT;
+		esp->msg_out_len = 1;
+		scsi_esp_cmd(esp, ESP_CMD_SATN);
+		return 0;
 	}
-	/* Bogus data, just wait for next interrupt. */
-	ESPLOG(("esp%d: bogus_data during end of data phase\n",
-		esp->esp_id));
-	return do_intr_end;
 }
 
-/* We received a non-good status return at the end of
- * running a SCSI command.  This is used to decide if
- * we should clear our synchronous transfer state for
- * such a device when that happens.
- *
- * The idea is that when spinning up a disk or rewinding
- * a tape, we don't want to go into a loop re-negotiating
- * synchronous capabilities over and over.
- */
-static int esp_should_clear_sync(struct scsi_cmnd *sp)
+static int esp_process_event(struct esp *esp)
 {
-	u8 cmd = sp->cmnd[0];
+	int write;
 
-	/* These cases are for spinning up a disk and
-	 * waiting for that spinup to complete.
-	 */
-	if (cmd == START_STOP)
-		return 0;
+again:
+	write = 0;
+	switch (esp->event) {
+	case ESP_EVENT_CHECK_PHASE:
+		switch (esp->sreg & ESP_STAT_PMASK) {
+		case ESP_DOP:
+			esp_event(esp, ESP_EVENT_DATA_OUT);
+			break;
+		case ESP_DIP:
+			esp_event(esp, ESP_EVENT_DATA_IN);
+			break;
+		case ESP_STATP:
+			esp_flush_fifo(esp);
+			scsi_esp_cmd(esp, ESP_CMD_ICCSEQ);
+			esp_event(esp, ESP_EVENT_STATUS);
+			esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+			return 1;
 
-	if (cmd == TEST_UNIT_READY)
-		return 0;
+		case ESP_MOP:
+			esp_event(esp, ESP_EVENT_MSGOUT);
+			break;
 
-	/* One more special case for SCSI tape drives,
-	 * this is what is used to probe the device for
-	 * completion of a rewind or tape load operation.
-	 */
-	if (sp->device->type == TYPE_TAPE) {
-		if (cmd == MODE_SENSE)
+		case ESP_MIP:
+			esp_event(esp, ESP_EVENT_MSGIN);
+			break;
+
+		case ESP_CMDP:
+			esp_event(esp, ESP_EVENT_CMD_START);
+			break;
+
+		default:
+			printk("ESP: Unexpected phase, sreg=%02x\n",
+			       esp->sreg);
+			esp_schedule_reset(esp);
 			return 0;
-	}
+		}
+		goto again;
+		break;
 
-	return 1;
-}
+	case ESP_EVENT_DATA_IN:
+		write = 1;
+		/* fallthru */
 
-/* Either a command is completing or a target is dropping off the bus
- * to continue the command in the background so we can do other work.
- */
-static int esp_do_freebus(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	struct esp_device *esp_dev = SCptr->device->hostdata;
-	int rval;
-
-	rval = skipahead2(esp, SCptr, in_status, in_msgindone, in_freeing);
-	if (rval)
-		return rval;
-	if (esp->ireg != ESP_INTR_DC) {
-		ESPLOG(("esp%d: Target will not disconnect\n", esp->esp_id));
-		return do_reset_bus; /* target will not drop BSY... */
-	}
-	esp->msgout_len = 0;
-	esp->prevmsgout = NOP;
-	if (esp->prevmsgin == COMMAND_COMPLETE) {
-		/* Normal end of nexus. */
-		if (esp->disconnected_SC || (esp->erev == fashme))
-			esp_cmd(esp, ESP_CMD_ESEL);
-
-		if (SCptr->SCp.Status != GOOD &&
-		    SCptr->SCp.Status != CONDITION_GOOD &&
-		    ((1<<SCptr->device->id) & esp->targets_present) &&
-		    esp_dev->sync &&
-		    esp_dev->sync_max_offset) {
-			/* SCSI standard says that the synchronous capabilities
-			 * should be renegotiated at this point.  Most likely
-			 * we are about to request sense from this target
-			 * in which case we want to avoid using sync
-			 * transfers until we are sure of the current target
-			 * state.
-			 */
-			ESPMISC(("esp: Status <%d> for target %d lun %d\n",
-				 SCptr->SCp.Status, SCptr->device->id, SCptr->device->lun));
-
-			/* But don't do this when spinning up a disk at
-			 * boot time while we poll for completion as it
-			 * fills up the console with messages.  Also, tapes
-			 * can report not ready many times right after
-			 * loading up a tape.
-			 */
-			if (esp_should_clear_sync(SCptr) != 0)
-				esp_dev->sync = 0;
+	case ESP_EVENT_DATA_OUT: {
+		struct esp_cmd_entry *ent = esp->active_cmd;
+		struct scsi_cmnd *cmd = ent->cmd;
+		dma_addr_t dma_addr = esp_cur_dma_addr(ent, cmd);
+		unsigned int dma_len = esp_cur_dma_len(ent, cmd);
+
+		if (esp->rev == ESP100)
+			scsi_esp_cmd(esp, ESP_CMD_NULL);
+
+		if (write)
+			ent->flags |= ESP_CMD_FLAG_WRITE;
+		else
+			ent->flags &= ~ESP_CMD_FLAG_WRITE;
+
+		dma_len = esp_dma_length_limit(esp, dma_addr, dma_len);
+		esp->data_dma_len = dma_len;
+
+		if (!dma_len) {
+			printk(KERN_ERR PFX "esp%d: DMA length is zero!\n",
+			       esp->host->unique_id);
+			printk(KERN_ERR PFX "esp%d: cur adr[%08x] len[%08x]\n",
+			       esp->host->unique_id,
+			       esp_cur_dma_addr(ent, cmd),
+			       esp_cur_dma_len(ent, cmd));
+			esp_schedule_reset(esp);
+			return 0;
 		}
-		ESPDISC(("F<%02x,%02x>", SCptr->device->id, SCptr->device->lun));
-		esp_done(esp, ((SCptr->SCp.Status & 0xff) |
-			       ((SCptr->SCp.Message & 0xff)<<8) |
-			       (DID_OK << 16)));
-	} else if (esp->prevmsgin == DISCONNECT) {
-		/* Normal disconnect. */
-		esp_cmd(esp, ESP_CMD_ESEL);
-		ESPDISC(("D<%02x,%02x>", SCptr->device->id, SCptr->device->lun));
-		append_SC(&esp->disconnected_SC, SCptr);
-		esp->current_SC = NULL;
-		if (esp->issue_SC)
-			esp_exec_cmd(esp);
-	} else {
-		/* Driver bug, we do not expect a disconnect here
-		 * and should not have advanced the state engine
-		 * to in_freeing.
-		 */
-		ESPLOG(("esp%d: last msg not disc and not cmd cmplt.\n",
-			esp->esp_id));
-		return do_reset_bus;
-	}
-	return do_intr_end;
-}
 
-/* When a reselect occurs, and we cannot find the command to
- * reconnect to in our queues, we do this.
- */
-static int esp_bad_reconnect(struct esp *esp)
-{
-	struct scsi_cmnd *sp;
-
-	ESPLOG(("esp%d: Eieeee, reconnecting unknown command!\n",
-		esp->esp_id));
-	ESPLOG(("QUEUE DUMP\n"));
-	sp = esp->issue_SC;
-	ESPLOG(("esp%d: issue_SC[", esp->esp_id));
-	while (sp) {
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-		sp = (struct scsi_cmnd *) sp->host_scribble;
-	}
-	ESPLOG(("]\n"));
-	sp = esp->current_SC;
-	ESPLOG(("esp%d: current_SC[", esp->esp_id));
-	if (sp)
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-	else
-		ESPLOG(("<NULL>"));
-	ESPLOG(("]\n"));
-	sp = esp->disconnected_SC;
-	ESPLOG(("esp%d: disconnected_SC[", esp->esp_id));
-	while (sp) {
-		ESPLOG(("<%02x,%02x>", sp->device->id, sp->device->lun));
-		sp = (struct scsi_cmnd *) sp->host_scribble;
-	}
-	ESPLOG(("]\n"));
-	return do_reset_bus;
-}
+		esp_log_datastart("ESP: start data addr[%08x] len[%u] "
+				  "write(%d)\n",
+				  dma_addr, dma_len, write);
 
-/* Do the needy when a target tries to reconnect to us. */
-static int esp_do_reconnect(struct esp *esp)
-{
-	int lun, target;
-	struct scsi_cmnd *SCptr;
-
-	/* Check for all bogus conditions first. */
-	target = reconnect_target(esp);
-	if (target < 0) {
-		ESPDISC(("bad bus bits\n"));
-		return do_reset_bus;
-	}
-	lun = reconnect_lun(esp);
-	if (lun < 0) {
-		ESPDISC(("target=%2x, bad identify msg\n", target));
-		return do_reset_bus;
+		esp->ops->send_dma_cmd(esp, dma_addr, dma_len, dma_len,
+				       write, ESP_CMD_DMA | ESP_CMD_TI);
+		esp_event(esp, ESP_EVENT_DATA_DONE);
+		break;
 	}
+	case ESP_EVENT_DATA_DONE: {
+		struct esp_cmd_entry *ent = esp->active_cmd;
+		struct scsi_cmnd *cmd = ent->cmd;
+		int bytes_sent;
 
-	/* Things look ok... */
-	ESPDISC(("R<%02x,%02x>", target, lun));
+		if (esp->ops->dma_error(esp)) {
+			printk("ESP: data done, DMA error, resetting\n");
+			esp_schedule_reset(esp);
+			return 0;
+		}
 
-	/* Must not flush FIFO or DVMA on HME. */
-	if (esp->erev != fashme) {
-		esp_cmd(esp, ESP_CMD_FLUSH);
-		if (esp100_reconnect_hwbug(esp))
-			return do_reset_bus;
-		esp_cmd(esp, ESP_CMD_NULL);
-	}
+		if (ent->flags & ESP_CMD_FLAG_WRITE) {
+			/* XXX parity errors, etc. XXX */
 
-	SCptr = remove_SC(&esp->disconnected_SC, (u8) target, (u8) lun);
-	if (!SCptr)
-		return esp_bad_reconnect(esp);
+			esp->ops->dma_drain(esp);
+		}
+		esp->ops->dma_invalidate(esp);
 
-	esp_connect(esp, SCptr);
-	esp_cmd(esp, ESP_CMD_MOK);
+		if (esp->ireg != ESP_INTR_BSERV) {
+			/* We should always see exactly a bus-service
+			 * interrupt at the end of a successful transfer.
+			 */
+			printk("ESP: data done, not BSERV, resetting\n");
+			esp_schedule_reset(esp);
+			return 0;
+		}
 
-	if (esp->erev == fashme)
-		sbus_writeb(((SCptr->device->id & 0xf) |
-			     (ESP_BUSID_RESELID | ESP_BUSID_CTR32BIT)),
-			    esp->eregs + ESP_BUSID);
+		bytes_sent = esp_data_bytes_sent(esp, ent, cmd);
 
-	/* Reconnect implies a restore pointers operation. */
-	esp_restore_pointers(esp, SCptr);
+		esp_log_datadone("ESP: data done flgs[%x] sent[%d]\n",
+				 ent->flags, bytes_sent);
 
-	esp->snip = 0;
-	esp_advance_phase(SCptr, in_the_dark);
-	return do_intr_end;
-}
+		if (bytes_sent < 0) {
+			/* XXX force sync mode for this target XXX */
+			esp_schedule_reset(esp);
+			return 0;
+		}
 
-/* End of NEXUS (hopefully), pick up status + message byte then leave if
- * all goes well.
- */
-static int esp_do_status(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	int intr, rval;
-
-	rval = skipahead1(esp, SCptr, in_the_dark, in_status);
-	if (rval)
-		return rval;
-	intr = esp->ireg;
-	ESPSTAT(("esp_do_status: "));
-	if (intr != ESP_INTR_DC) {
-		int message_out = 0; /* for parity problems */
-
-		/* Ack the message. */
-		ESPSTAT(("ack msg, "));
-		esp_cmd(esp, ESP_CMD_MOK);
-
-		if (esp->erev != fashme) {
-			dma_flashclear(esp);
-
-			/* Wait till the first bits settle. */
-			while (esp->esp_command[0] == 0xff)
-				udelay(1);
+		esp_advance_dma(esp, ent, cmd, bytes_sent);
+		esp_event(esp, ESP_EVENT_CHECK_PHASE);
+		goto again;
+		break;
+	}
+
+	case ESP_EVENT_STATUS: {
+		struct esp_cmd_entry *ent = esp->active_cmd;
+
+		if (esp->ireg & ESP_INTR_FDONE) {
+			ent->status = esp_read8(ESP_FDATA);
+			ent->message = esp_read8(ESP_FDATA);
+			scsi_esp_cmd(esp, ESP_CMD_MOK);
+		} else if (esp->ireg == ESP_INTR_BSERV) {
+			ent->status = esp_read8(ESP_FDATA);
+			ent->message = 0xff;
+			esp_event(esp, ESP_EVENT_MSGIN);
+			return 0;
+		}
+
+		if (ent->message != COMMAND_COMPLETE) {
+			printk("ESP: Unexpected message %x in status\n",
+			       ent->message);
+			esp_schedule_reset(esp);
+			return 0;
+		}
+
+		esp_event(esp, ESP_EVENT_FREE_BUS);
+		esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+		break;
+	}
+	case ESP_EVENT_FREE_BUS: {
+		struct esp_cmd_entry *ent = esp->active_cmd;
+		struct scsi_cmnd *cmd = ent->cmd;
+
+		if (ent->message == COMMAND_COMPLETE ||
+		    ent->message == DISCONNECT)
+			scsi_esp_cmd(esp, ESP_CMD_ESEL);
+
+		if (ent->message == COMMAND_COMPLETE) {
+			esp_log_cmddone("ESP: Command done status[%x] "
+					"message[%x]\n",
+					ent->status, ent->message);
+			if (ent->status == SAM_STAT_TASK_SET_FULL)
+				esp_event_queue_full(esp, ent);
+
+			if (ent->status == SAM_STAT_CHECK_CONDITION &&
+			    !(ent->flags & ESP_CMD_FLAG_AUTOSENSE)) {
+				ent->flags |= ESP_CMD_FLAG_AUTOSENSE;
+				esp_autosense(esp, ent);
+			} else {
+				esp_cmd_is_done(esp, ent, cmd,
+						compose_result(ent->status,
+							       ent->message,
+							       DID_OK));
+			}
+		} else if (ent->message == DISCONNECT) {
+			esp_log_disconnect("ESP: Disconnecting tgt[%d] "
+					   "tag[%x:%x]\n",
+					   cmd->device->id,
+					   ent->tag[0], ent->tag[1]);
+
+			esp->active_cmd = NULL;
+			esp_maybe_execute_command(esp);
 		} else {
-			esp->esp_command[0] = esp->hme_fifo_workaround_buffer[0];
-			esp->esp_command[1] = esp->hme_fifo_workaround_buffer[1];
+			printk("ESP: Unexpected message %x in freebus\n",
+			       ent->message);
+			esp_schedule_reset(esp);
+			return 0;
 		}
+		if (esp->active_cmd)
+			esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+		break;
+	}
+	case ESP_EVENT_MSGOUT: {
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
 
-		ESPSTAT(("got something, "));
-		/* ESP chimes in with one of
-		 *
-		 * 1) function done interrupt:
-		 *	both status and message in bytes
-		 *	are available
-		 *
-		 * 2) bus service interrupt:
-		 *	only status byte was acquired
-		 *
-		 * 3) Anything else:
-		 *	can't happen, but we test for it
-		 *	anyways
-		 *
-		 * ALSO: If bad parity was detected on either
-		 *       the status _or_ the message byte then
-		 *       the ESP has asserted ATN on the bus
-		 *       and we must therefore wait for the
-		 *       next phase change.
-		 */
-		if (intr & ESP_INTR_FDONE) {
-			/* We got it all, hallejulia. */
-			ESPSTAT(("got both, "));
-			SCptr->SCp.Status = esp->esp_command[0];
-			SCptr->SCp.Message = esp->esp_command[1];
-			esp->prevmsgin = SCptr->SCp.Message;
-			esp->cur_msgin[0] = SCptr->SCp.Message;
-			if (esp->sreg & ESP_STAT_PERR) {
-				/* There was bad parity for the
-				 * message byte, the status byte
-				 * was ok.
-				 */
-				message_out = MSG_PARITY_ERROR;
+		if (esp_debug & ESP_DEBUG_MSGOUT) {
+			int i;
+			printk("ESP: Sending message [ ");
+			for (i = 0; i < esp->msg_out_len; i++)
+				printk("%02x ", esp->msg_out[i]);
+			printk("]\n");
+		}
+
+		if (esp->rev == FASHME) {
+			int i;
+
+			/* Always use the fifo.  */
+			for (i = 0; i < esp->msg_out_len; i++) {
+				esp_write8(esp->msg_out[i], ESP_FDATA);
+				esp_write8(0, ESP_FDATA);
 			}
-		} else if (intr == ESP_INTR_BSERV) {
-			/* Only got status byte. */
-			ESPLOG(("esp%d: got status only, ", esp->esp_id));
-			if (!(esp->sreg & ESP_STAT_PERR)) {
-				SCptr->SCp.Status = esp->esp_command[0];
-				SCptr->SCp.Message = 0xff;
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+		} else {
+			if (esp->msg_out_len == 1) {
+				esp_write8(esp->msg_out[0], ESP_FDATA);
+				scsi_esp_cmd(esp, ESP_CMD_TI);
 			} else {
-				/* The status byte had bad parity.
-				 * we leave the scsi_pointer Status
-				 * field alone as we set it to a default
-				 * of CHECK_CONDITION in esp_queue.
-				 */
-				message_out = INITIATOR_ERROR;
+				/* Use DMA. */
+				memcpy(esp->command_block,
+				       esp->msg_out,
+				       esp->msg_out_len);
+
+				esp->ops->send_dma_cmd(esp,
+						       esp->command_block_dma,
+						       esp->msg_out_len,
+						       esp->msg_out_len,
+						       0,
+						       ESP_CMD_DMA|ESP_CMD_TI);
 			}
+		}
+		esp_event(esp, ESP_EVENT_MSGOUT_DONE);
+		break;
+	}
+	case ESP_EVENT_MSGOUT_DONE:
+		if (esp->rev == FASHME) {
+			scsi_esp_cmd(esp, ESP_CMD_FLUSH);
 		} else {
-			/* This shouldn't happen ever. */
-			ESPSTAT(("got bolixed\n"));
-			esp_advance_phase(SCptr, in_the_dark);
-			return esp_do_phase_determine(esp);
+			if (esp->msg_out_len > 1)
+				esp->ops->dma_invalidate(esp);
 		}
 
-		if (!message_out) {
-			ESPSTAT(("status=%2x msg=%2x, ", SCptr->SCp.Status,
-				SCptr->SCp.Message));
-			if (SCptr->SCp.Message == COMMAND_COMPLETE) {
-				ESPSTAT(("and was COMMAND_COMPLETE\n"));
-				esp_advance_phase(SCptr, in_freeing);
-				return esp_do_freebus(esp);
+		if (!(esp->ireg & ESP_INTR_DC)) {
+			if (esp->rev != FASHME)
+				scsi_esp_cmd(esp, ESP_CMD_NULL);
+		}
+		esp_event(esp, ESP_EVENT_CHECK_PHASE);
+		goto again;
+	case ESP_EVENT_MSGIN:
+		if (esp->ireg & ESP_INTR_BSERV) {
+			if (esp->rev == FASHME) {
+				if (!(esp_read8(ESP_STATUS2) &
+				      ESP_STAT2_FEMPTY))
+					scsi_esp_cmd(esp, ESP_CMD_FLUSH);
 			} else {
-				ESPLOG(("esp%d: and _not_ COMMAND_COMPLETE\n",
-					esp->esp_id));
-				esp->msgin_len = esp->msgin_ctr = 1;
-				esp_advance_phase(SCptr, in_msgindone);
-				return esp_do_msgindone(esp);
+				scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+				if (esp->rev == ESP100)
+					scsi_esp_cmd(esp, ESP_CMD_NULL);
 			}
-		} else {
-			/* With luck we'll be able to let the target
-			 * know that bad parity happened, it will know
-			 * which byte caused the problems and send it
-			 * again.  For the case where the status byte
-			 * receives bad parity, I do not believe most
-			 * targets recover very well.  We'll see.
-			 */
-			ESPLOG(("esp%d: bad parity somewhere mout=%2x\n",
-				esp->esp_id, message_out));
-			esp->cur_msgout[0] = message_out;
-			esp->msgout_len = esp->msgout_ctr = 1;
-			esp_advance_phase(SCptr, in_the_dark);
-			return esp_do_phase_determine(esp);
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+			esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+			return 1;
 		}
-	} else {
-		/* If we disconnect now, all hell breaks loose. */
-		ESPLOG(("esp%d: whoops, disconnect\n", esp->esp_id));
-		esp_advance_phase(SCptr, in_the_dark);
-		return esp_do_phase_determine(esp);
-	}
-}
+		if (esp->ireg & ESP_INTR_FDONE) {
+			u8 val;
 
-static int esp_enter_status(struct esp *esp)
-{
-	u8 thecmd = ESP_CMD_ICCSEQ;
-
-	esp_cmd(esp, ESP_CMD_FLUSH);
-	if (esp->erev != fashme) {
-		u32 tmp;
-
-		esp->esp_command[0] = esp->esp_command[1] = 0xff;
-		sbus_writeb(2, esp->eregs + ESP_TCLOW);
-		sbus_writeb(0, esp->eregs + ESP_TCMED);
-		tmp = sbus_readl(esp->dregs + DMA_CSR);
-		tmp |= (DMA_ST_WRITE | DMA_ENABLE);
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-		if (esp->dma->revision == dvmaesc1)
-			sbus_writel(0x100, esp->dregs + DMA_COUNT);
-		sbus_writel(esp->esp_command_dvma, esp->dregs + DMA_ADDR);
-		thecmd |= ESP_CMD_DMA;
-	}
-	esp_cmd(esp, thecmd);
-	esp_advance_phase(esp->current_SC, in_status);
+			if (esp->rev == FASHME)
+				val = esp->fifo[0];
+			else
+				val = esp_read8(ESP_FDATA);
+			esp->msg_in[esp->msg_in_len++] = val;
 
-	return esp_do_status(esp);
-}
+			esp_log_msgin("ESP: Got msgin byte %x\n", val);
 
-static int esp_disconnect_amidst_phases(struct esp *esp)
-{
-	struct scsi_cmnd *sp = esp->current_SC;
-	struct esp_device *esp_dev = sp->device->hostdata;
+			if (!esp_msgin_process(esp))
+				esp->msg_in_len = 0;
 
-	/* This means real problems if we see this
-	 * here.  Unless we were actually trying
-	 * to force the device to abort/reset.
-	 */
-	ESPLOG(("esp%d Disconnect amidst phases, ", esp->esp_id));
-	ESPLOG(("pphase<%s> cphase<%s>, ",
-		phase_string(sp->SCp.phase),
-		phase_string(sp->SCp.sent_command)));
+			if (esp->rev == FASHME)
+				scsi_esp_cmd(esp, ESP_CMD_FLUSH);
 
-	if (esp->disconnected_SC != NULL || (esp->erev == fashme))
-		esp_cmd(esp, ESP_CMD_ESEL);
+			scsi_esp_cmd(esp, ESP_CMD_MOK);
 
-	switch (esp->cur_msgout[0]) {
-	default:
-		/* We didn't expect this to happen at all. */
-		ESPLOG(("device is bolixed\n"));
-		esp_advance_phase(sp, in_tgterror);
-		esp_done(esp, (DID_ERROR << 16));
+			if (esp->event != ESP_EVENT_FREE_BUS)
+				esp_event(esp, ESP_EVENT_CHECK_PHASE);
+		} else {
+			printk("ESP: MSGIN neither BSERV not FDON, resetting");
+			esp_schedule_reset(esp);
+			return 0;
+		}
 		break;
-
-	case BUS_DEVICE_RESET:
-		ESPLOG(("device reset successful\n"));
-		esp_dev->sync_max_offset = 0;
-		esp_dev->sync_min_period = 0;
-		esp_dev->sync = 0;
-		esp_advance_phase(sp, in_resetdev);
-		esp_done(esp, (DID_RESET << 16));
+	case ESP_EVENT_CMD_START:
+		memcpy(esp->command_block, esp->cmd_bytes_ptr,
+		       esp->cmd_bytes_left);
+		if (esp->rev == FASHME)
+			scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+		esp->ops->send_dma_cmd(esp, esp->command_block_dma,
+				       esp->cmd_bytes_left, 16, 0,
+				       ESP_CMD_DMA | ESP_CMD_TI);
+		esp_event(esp, ESP_EVENT_CMD_DONE);
+		esp->flags |= ESP_FLAG_QUICKIRQ_CHECK;
+		break;
+	case ESP_EVENT_CMD_DONE:
+		esp->ops->dma_invalidate(esp);
+		if (esp->ireg & ESP_INTR_BSERV) {
+			esp_event(esp, ESP_EVENT_CHECK_PHASE);
+			goto again;
+		}
+		esp_schedule_reset(esp);
+		return 0;
 		break;
 
-	case ABORT:
-		ESPLOG(("device abort successful\n"));
-		esp_advance_phase(sp, in_abortone);
-		esp_done(esp, (DID_ABORT << 16));
+	case ESP_EVENT_RESET:
+		scsi_esp_cmd(esp, ESP_CMD_RS);
 		break;
 
-	};
-	return do_intr_end;
+	default:
+		printk("ESP: Unexpected event %x, resetting\n",
+		       esp->event);
+		esp_schedule_reset(esp);
+		return 0;
+		break;
+	}
+	return 1;
 }
 
-static int esp_enter_msgout(struct esp *esp)
+static void esp_reset_cleanup_one(struct esp *esp, struct esp_cmd_entry *ent)
 {
-	esp_advance_phase(esp->current_SC, in_msgout);
-	return esp_do_msgout(esp);
-}
+	struct scsi_cmnd *cmd = ent->cmd;
+	int tgt = cmd->device->id;
+	int lun = cmd->device->lun;
 
-static int esp_enter_msgin(struct esp *esp)
-{
-	esp_advance_phase(esp->current_SC, in_msgin);
-	return esp_do_msgin(esp);
-}
+	esp_unmap_dma(esp, cmd);
+	esp_free_lun_tag(ent, esp->target[tgt].lun[lun]);
+	cmd->result = DID_RESET << 16;
 
-static int esp_enter_cmd(struct esp *esp)
-{
-	esp_advance_phase(esp->current_SC, in_cmdbegin);
-	return esp_do_cmdbegin(esp);
+	if (ent->flags & ESP_CMD_FLAG_AUTOSENSE) {
+		esp->ops->unmap_single(esp, ent->sense_dma,
+				       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+		ent->sense_ptr = NULL;
+	}
+
+	cmd->scsi_done(cmd);
+	list_del(&ent->list);
+	esp_put_ent(esp, ent);
 }
 
-static int esp_enter_badphase(struct esp *esp)
+static void esp_reset_cleanup(struct esp *esp)
 {
-	ESPLOG(("esp%d: Bizarre bus phase %2x.\n", esp->esp_id,
-		esp->sreg & ESP_STAT_PMASK));
-	return do_reset_bus;
-}
+	struct esp_cmd_entry *ent, *tmp;
+	int i;
 
-typedef int (*espfunc_t)(struct esp *);
-
-static espfunc_t phase_vector[] = {
-	esp_do_data,		/* ESP_DOP */
-	esp_do_data,		/* ESP_DIP */
-	esp_enter_cmd,		/* ESP_CMDP */
-	esp_enter_status,	/* ESP_STATP */
-	esp_enter_badphase,	/* ESP_STAT_PMSG */
-	esp_enter_badphase,	/* ESP_STAT_PMSG | ESP_STAT_PIO */
-	esp_enter_msgout,	/* ESP_MOP */
-	esp_enter_msgin,	/* ESP_MIP */
-};
+	list_for_each_entry_safe(ent, tmp, &esp->queued_cmds, list) {
+		struct scsi_cmnd *cmd = ent->cmd;
 
-/* The target has control of the bus and we have to see where it has
- * taken us.
- */
-static int esp_do_phase_determine(struct esp *esp)
-{
-	if ((esp->ireg & ESP_INTR_DC) != 0)
-		return esp_disconnect_amidst_phases(esp);
-	return phase_vector[esp->sreg & ESP_STAT_PMASK](esp);
+		list_del(&ent->list);
+		cmd->result = DID_RESET << 16;
+		cmd->scsi_done(cmd);
+		esp_put_ent(esp, ent);
+	}
+
+	list_for_each_entry_safe(ent, tmp, &esp->active_cmds, list) {
+		if (ent == esp->active_cmd)
+			esp->active_cmd = NULL;
+		esp_reset_cleanup_one(esp, ent);
+	}
+
+	BUG_ON(esp->active_cmd != NULL);
+
+	/* Force renegotiation of sync/wide transfers.  */
+	for (i = 0; i < ESP_MAX_TARGET; i++) {
+		struct esp_target_data *tp = &esp->target[i];
+		int lun;
+
+		tp->esp_period = 0;
+		tp->esp_offset = 0;
+		tp->esp_config3 &= ~(ESP_CONFIG3_EWIDE |
+				     ESP_CONFIG3_FSCSI |
+				     ESP_CONFIG3_FAST);
+		tp->flags &= ~ESP_TGT_WIDE;
+		tp->flags |= ESP_TGT_CHECK_NEGO;
+
+		for (lun = 0; lun < ESP_MAX_LUN; lun++) {
+			struct esp_lun_data *lp = tp->lun[lun];
+
+			if (lp) {
+				BUG_ON(lp->num_tagged);
+				lp->hold = 0;
+			}
+		}
+	}
 }
 
-/* First interrupt after exec'ing a cmd comes here. */
-static int esp_select_complete(struct esp *esp)
+/* Runs under host->lock */
+static void __esp_interrupt(struct esp *esp)
 {
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	struct esp_device *esp_dev = SCptr->device->hostdata;
-	int cmd_bytes_sent, fcnt;
+	int finish_reset, intr_done;
+	u8 phase;
 
-	if (esp->erev != fashme)
-		esp->seqreg = (sbus_readb(esp->eregs + ESP_SSTEP) & ESP_STEP_VBITS);
+	esp->sreg = esp_read8(ESP_STATUS);
 
-	if (esp->erev == fashme)
-		fcnt = esp->hme_fifo_workaround_count;
-	else
-		fcnt = (sbus_readb(esp->eregs + ESP_FFLAGS) & ESP_FF_FBYTES);
+	if (esp->flags & ESP_FLAG_RESETTING) {
+		finish_reset = 1;
+	} else {
+		if (esp_check_gross_error(esp))
+			return;
+
+		finish_reset = esp_check_spur_intr(esp);
+		if (finish_reset < 0)
+			return;
+	}
 
-	cmd_bytes_sent = esp_bytes_sent(esp, fcnt);
-	dma_invalidate(esp);
+	esp->ireg = esp_read8(ESP_INTRPT);
 
-	/* Let's check to see if a reselect happened
-	 * while we we're trying to select.  This must
-	 * be checked first.
-	 */
-	if (esp->ireg == (ESP_INTR_RSEL | ESP_INTR_FDONE)) {
-		esp_reconnect(esp, SCptr);
-		return esp_do_reconnect(esp);
+	if (esp->ireg & ESP_INTR_SR)
+		finish_reset = 1;
+
+	if (finish_reset) {
+		esp_reset_cleanup(esp);
+		if (esp->eh_reset) {
+			complete(esp->eh_reset);
+			esp->eh_reset = NULL;
+		}
+		return;
 	}
 
-	/* Looks like things worked, we should see a bus service &
-	 * a function complete interrupt at this point.  Note we
-	 * are doing a direct comparison because we don't want to
-	 * be fooled into thinking selection was successful if
-	 * ESP_INTR_DC is set, see below.
-	 */
-	if (esp->ireg == (ESP_INTR_FDONE | ESP_INTR_BSERV)) {
-		/* target speaks... */
-		esp->targets_present |= (1<<SCptr->device->id);
+	phase = (esp->sreg & ESP_STAT_PMASK);
+	if (esp->rev == FASHME) {
+		if (((phase != ESP_DIP && phase != ESP_DOP) &&
+		     esp->select_state == ESP_SELECT_NONE &&
+		     esp->event != ESP_EVENT_STATUS &&
+		     esp->event != ESP_EVENT_DATA_DONE) ||
+		    (esp->ireg & ESP_INTR_RSEL)) {
+			esp->sreg2 = esp_read8(ESP_STATUS2);
+			if (!(esp->sreg2 & ESP_STAT2_FEMPTY) ||
+			    (esp->sreg2 & ESP_STAT2_F1BYTE))
+				hme_read_fifo(esp);
+		}
+	}
 
-		/* What if the target ignores the sdtr? */
-		if (esp->snip)
-			esp_dev->sync = 1;
+	esp_log_intr("ESP: intr sreg[%02x] seqreg[%02x] "
+		     "sreg2[%02x] ireg[%02x]\n",
+		     esp->sreg, esp->seqreg, esp->sreg2, esp->ireg);
 
-		/* See how far, if at all, we got in getting
-		 * the information out to the target.
-		 */
-		switch (esp->seqreg) {
-		default:
+	intr_done = 0;
 
-		case ESP_STEP_ASEL:
-			/* Arbitration won, target selected, but
-			 * we are in some phase which is not command
-			 * phase nor is it message out phase.
-			 *
-			 * XXX We've confused the target, obviously.
-			 * XXX So clear it's state, but we also end
-			 * XXX up clearing everyone elses.  That isn't
-			 * XXX so nice.  I'd like to just reset this
-			 * XXX target, but if I cannot even get it's
-			 * XXX attention and finish selection to talk
-			 * XXX to it, there is not much more I can do.
-			 * XXX If we have a loaded bus we're going to
-			 * XXX spend the next second or so renegotiating
-			 * XXX for synchronous transfers.
-			 */
-			ESPLOG(("esp%d: STEP_ASEL for tgt %d\n",
-				esp->esp_id, SCptr->device->id));
-
-		case ESP_STEP_SID:
-			/* Arbitration won, target selected, went
-			 * to message out phase, sent one message
-			 * byte, then we stopped.  ATN is asserted
-			 * on the SCSI bus and the target is still
-			 * there hanging on.  This is a legal
-			 * sequence step if we gave the ESP a select
-			 * and stop command.
-			 *
-			 * XXX See above, I could set the borken flag
-			 * XXX in the device struct and retry the
-			 * XXX command.  But would that help for
-			 * XXX tagged capable targets?
-			 */
+	if (esp->ireg & (ESP_INTR_S | ESP_INTR_SATN | ESP_INTR_IC)) {
+		printk("ESP: unexpected IREG %02x\n", esp->ireg);
+		if (esp->ireg & ESP_INTR_IC)
+			esp_dump_cmd_log(esp);
 
-		case ESP_STEP_NCMD:
-			/* Arbitration won, target selected, maybe
-			 * sent the one message byte in message out
-			 * phase, but we did not go to command phase
-			 * in the end.  Actually, we could have sent
-			 * only some of the message bytes if we tried
-			 * to send out the entire identify and tag
-			 * message using ESP_CMD_SA3.
-			 */
-			cmd_bytes_sent = 0;
-			break;
+		esp_schedule_reset(esp);
+	} else {
+		if (!(esp->ireg & ESP_INTR_RSEL)) {
+			/* Some combination of FDONE, BSERV, DC.  */
+			if (esp->select_state != ESP_SELECT_NONE)
+				intr_done = esp_finish_select(esp);
+		} else if (esp->ireg & ESP_INTR_RSEL) {
+			if (esp->active_cmd)
+				(void) esp_finish_select(esp);
+			intr_done = esp_reconnect(esp);
+		}
+	}
+	while (!intr_done)
+		intr_done = esp_process_event(esp);
+}
 
-		case ESP_STEP_PPC:
-			/* No, not the powerPC pinhead.  Arbitration
-			 * won, all message bytes sent if we went to
-			 * message out phase, went to command phase
-			 * but only part of the command was sent.
-			 *
-			 * XXX I've seen this, but usually in conjunction
-			 * XXX with a gross error which appears to have
-			 * XXX occurred between the time I told the
-			 * XXX ESP to arbitrate and when I got the
-			 * XXX interrupt.  Could I have misloaded the
-			 * XXX command bytes into the fifo?  Actually,
-			 * XXX I most likely missed a phase, and therefore
-			 * XXX went into never never land and didn't even
-			 * XXX know it.  That was the old driver though.
-			 * XXX What is even more peculiar is that the ESP
-			 * XXX showed the proper function complete and
-			 * XXX bus service bits in the interrupt register.
-			 */
+irqreturn_t scsi_esp_intr(int irq, void *dev_id)
+{
+	struct esp *esp = dev_id;
+	unsigned long flags;
+	irqreturn_t ret;
 
-		case ESP_STEP_FINI4:
-		case ESP_STEP_FINI5:
-		case ESP_STEP_FINI6:
-		case ESP_STEP_FINI7:
-			/* Account for the identify message */
-			if (SCptr->SCp.phase == in_slct_norm)
-				cmd_bytes_sent -= 1;
-		};
+	spin_lock_irqsave(esp->host->host_lock, flags);
+	ret = IRQ_NONE;
+	if (esp->ops->irq_pending(esp)) {
+		ret = IRQ_HANDLED;
+		for (;;) {
+			int i;
 
-		if (esp->erev != fashme)
-			esp_cmd(esp, ESP_CMD_NULL);
+			__esp_interrupt(esp);
+			if (!(esp->flags & ESP_FLAG_QUICKIRQ_CHECK))
+				break;
+			esp->flags &= ~ESP_FLAG_QUICKIRQ_CHECK;
 
-		/* Be careful, we could really get fucked during synchronous
-		 * data transfers if we try to flush the fifo now.
-		 */
-		if ((esp->erev != fashme) && /* not a Happy Meal and... */
-		    !fcnt && /* Fifo is empty and... */
-		    /* either we are not doing synchronous transfers or... */
-		    (!esp_dev->sync_max_offset ||
-		     /* We are not going into data in phase. */
-		     ((esp->sreg & ESP_STAT_PMASK) != ESP_DIP)))
-			esp_cmd(esp, ESP_CMD_FLUSH); /* flush is safe */
-
-		/* See how far we got if this is not a slow command. */
-		if (!esp->esp_slowcmd) {
-			if (cmd_bytes_sent < 0)
-				cmd_bytes_sent = 0;
-			if (cmd_bytes_sent != SCptr->cmd_len) {
-				/* Crapola, mark it as a slowcmd
-				 * so that we have some chance of
-				 * keeping the command alive with
-				 * good luck.
-				 *
-				 * XXX Actually, if we didn't send it all
-				 * XXX this means either we didn't set things
-				 * XXX up properly (driver bug) or the target
-				 * XXX or the ESP detected parity on one of
-				 * XXX the command bytes.  This makes much
-				 * XXX more sense, and therefore this code
-				 * XXX should be changed to send out a
-				 * XXX parity error message or if the status
-				 * XXX register shows no parity error then
-				 * XXX just expect the target to bring the
-				 * XXX bus into message in phase so that it
-				 * XXX can send us the parity error message.
-				 * XXX SCSI sucks...
-				 */
-				esp->esp_slowcmd = 1;
-				esp->esp_scmdp = &(SCptr->cmnd[cmd_bytes_sent]);
-				esp->esp_scmdleft = (SCptr->cmd_len - cmd_bytes_sent);
+			for (i = 0; i < ESP_QUICKIRQ_LIMIT; i++) {
+				if (esp->ops->irq_pending(esp))
+					break;
 			}
+			if (i == ESP_QUICKIRQ_LIMIT)
+				break;
 		}
-
-		/* Now figure out where we went. */
-		esp_advance_phase(SCptr, in_the_dark);
-		return esp_do_phase_determine(esp);
 	}
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
 
-	/* Did the target even make it? */
-	if (esp->ireg == ESP_INTR_DC) {
-		/* wheee... nobody there or they didn't like
-		 * what we told it to do, clean up.
-		 */
+	return ret;
+}
+EXPORT_SYMBOL(scsi_esp_intr);
 
-		/* If anyone is off the bus, but working on
-		 * a command in the background for us, tell
-		 * the ESP to listen for them.
-		 */
-		if (esp->disconnected_SC)
-			esp_cmd(esp, ESP_CMD_ESEL);
-
-		if (((1<<SCptr->device->id) & esp->targets_present) &&
-		    esp->seqreg != 0 &&
-		    (esp->cur_msgout[0] == EXTENDED_MESSAGE) &&
-		    (SCptr->SCp.phase == in_slct_msg ||
-		     SCptr->SCp.phase == in_slct_stop)) {
-			/* shit */
-			esp->snip = 0;
-			ESPLOG(("esp%d: Failed synchronous negotiation for target %d "
-				"lun %d\n", esp->esp_id, SCptr->device->id, SCptr->device->lun));
-			esp_dev->sync_max_offset = 0;
-			esp_dev->sync_min_period = 0;
-			esp_dev->sync = 1; /* so we don't negotiate again */
-
-			/* Run the command again, this time though we
-			 * won't try to negotiate for synchronous transfers.
-			 *
-			 * XXX I'd like to do something like send an
-			 * XXX INITIATOR_ERROR or ABORT message to the
-			 * XXX target to tell it, "Sorry I confused you,
-			 * XXX please come back and I will be nicer next
-			 * XXX time".  But that requires having the target
-			 * XXX on the bus, and it has dropped BSY on us.
-			 */
-			esp->current_SC = NULL;
-			esp_advance_phase(SCptr, not_issued);
-			prepend_SC(&esp->issue_SC, SCptr);
-			esp_exec_cmd(esp);
-			return do_intr_end;
-		}
+static void __devinit esp_get_revision(struct esp *esp)
+{
+	u8 val;
 
-		/* Ok, this is normal, this is what we see during boot
-		 * or whenever when we are scanning the bus for targets.
-		 * But first make sure that is really what is happening.
+	esp->config1 = (ESP_CONFIG1_PENABLE | (esp->scsi_id & 7));
+	esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
+	esp_write8(esp->config2, ESP_CFG2);
+
+	val = esp_read8(ESP_CFG2);
+	val &= ~ESP_CONFIG2_MAGIC;
+	if (val != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
+		/* If what we write to cfg2 does not come back, cfg2 is not
+		 * implemented, therefore this must be a plain esp100.
 		 */
-		if (((1<<SCptr->device->id) & esp->targets_present)) {
-			ESPLOG(("esp%d: Warning, live target %d not responding to "
-				"selection.\n", esp->esp_id, SCptr->device->id));
-
-			/* This _CAN_ happen.  The SCSI standard states that
-			 * the target is to _not_ respond to selection if
-			 * _it_ detects bad parity on the bus for any reason.
-			 * Therefore, we assume that if we've talked successfully
-			 * to this target before, bad parity is the problem.
+		esp->rev = ESP100;
+	} else {
+		esp->config2 = 0;
+		esp_set_all_config3(esp, 5);
+		esp->prev_cfg3 = 5;
+		esp_write8(esp->config2, ESP_CFG2);
+		esp_write8(0, ESP_CFG3);
+		esp_write8(esp->prev_cfg3, ESP_CFG3);
+
+		val = esp_read8(ESP_CFG3);
+		if (val != 5) {
+			/* The cfg2 register is implemented, however
+			 * cfg3 is not, must be esp100a.
 			 */
-			esp_done(esp, (DID_PARITY << 16));
+			esp->rev = ESP100A;
 		} else {
-			/* Else, there really isn't anyone there. */
-			ESPMISC(("esp: selection failure, maybe nobody there?\n"));
-			ESPMISC(("esp: target %d lun %d\n",
-				 SCptr->device->id, SCptr->device->lun));
-			esp_done(esp, (DID_BAD_TARGET << 16));
+			esp_set_all_config3(esp, 0);
+			esp->prev_cfg3 = 0;
+			esp_write8(esp->prev_cfg3, ESP_CFG3);
+
+			/* All of cfg{1,2,3} implemented, must be one of
+			 * the fas variants, figure out which one.
+			 */
+			if (esp->cfact == 0 || esp->cfact > ESP_CCF_F5) {
+				esp->rev = FAST;
+				esp->sync_defp = SYNC_DEFP_FAST;
+			} else {
+				esp->rev = ESP236;
+			}
+			esp->config2 = 0;
+			esp_write8(esp->config2, ESP_CFG2);
 		}
-		return do_intr_end;
 	}
-
-	ESPLOG(("esp%d: Selection failure.\n", esp->esp_id));
-	printk("esp%d: Currently -- ", esp->esp_id);
-	esp_print_ireg(esp->ireg); printk(" ");
-	esp_print_statreg(esp->sreg); printk(" ");
-	esp_print_seqreg(esp->seqreg); printk("\n");
-	printk("esp%d: New -- ", esp->esp_id);
-	esp->sreg = sbus_readb(esp->eregs + ESP_STATUS);
-	esp->seqreg = sbus_readb(esp->eregs + ESP_SSTEP);
-	esp->ireg = sbus_readb(esp->eregs + ESP_INTRPT);
-	esp_print_ireg(esp->ireg); printk(" ");
-	esp_print_statreg(esp->sreg); printk(" ");
-	esp_print_seqreg(esp->seqreg); printk("\n");
-	ESPLOG(("esp%d: resetting bus\n", esp->esp_id));
-	return do_reset_bus; /* ugh... */
 }
 
-/* Continue reading bytes for msgin phase. */
-static int esp_do_msgincont(struct esp *esp)
+static void __devinit esp_init_swstate(struct esp *esp)
 {
-	if (esp->ireg & ESP_INTR_BSERV) {
-		/* in the right phase too? */
-		if ((esp->sreg & ESP_STAT_PMASK) == ESP_MIP) {
-			/* phew... */
-			esp_cmd(esp, ESP_CMD_TI);
-			esp_advance_phase(esp->current_SC, in_msgindone);
-			return do_intr_end;
-		}
+	int i;
 
-		/* We changed phase but ESP shows bus service,
-		 * in this case it is most likely that we, the
-		 * hacker who has been up for 20hrs straight
-		 * staring at the screen, drowned in coffee
-		 * smelling like retched cigarette ashes
-		 * have miscoded something..... so, try to
-		 * recover as best we can.
-		 */
-		ESPLOG(("esp%d: message in mis-carriage.\n", esp->esp_id));
+	INIT_LIST_HEAD(&esp->queued_cmds);
+	INIT_LIST_HEAD(&esp->active_cmds);
+	INIT_LIST_HEAD(&esp->esp_cmd_pool);
+
+	/* Start with a clear state, domain validation (via ->slave_configure,
+	 * spi_dv_device()) will attempt to enable SYNC, WIDE, and tagged
+	 * commands.
+	 */
+	for (i = 0 ; i < ESP_MAX_TARGET; i++) {
+		esp->target[i].flags = 0;
+		esp->target[i].nego_goal_period = 0;
+		esp->target[i].nego_goal_offset = 0;
+		esp->target[i].nego_goal_width = 0;
+		esp->target[i].nego_goal_tags = 0;
 	}
-	esp_advance_phase(esp->current_SC, in_the_dark);
-	return do_phase_determine;
 }
 
-static int check_singlebyte_msg(struct esp *esp)
+/* This places the ESP into a known state at boot time. */
+static void __devinit esp_bootup_reset(struct esp *esp)
 {
-	esp->prevmsgin = esp->cur_msgin[0];
-	if (esp->cur_msgin[0] & 0x80) {
-		/* wheee... */
-		ESPLOG(("esp%d: target sends identify amidst phases\n",
-			esp->esp_id));
-		esp_advance_phase(esp->current_SC, in_the_dark);
-		return 0;
-	} else if (((esp->cur_msgin[0] & 0xf0) == 0x20) ||
-		   (esp->cur_msgin[0] == EXTENDED_MESSAGE)) {
-		esp->msgin_len = 2;
-		esp_advance_phase(esp->current_SC, in_msgincont);
-		return 0;
-	}
-	esp_advance_phase(esp->current_SC, in_the_dark);
-	switch (esp->cur_msgin[0]) {
-	default:
-		/* We don't want to hear about it. */
-		ESPLOG(("esp%d: msg %02x which we don't know about\n", esp->esp_id,
-			esp->cur_msgin[0]));
-		return MESSAGE_REJECT;
+	u8 val;
 
-	case NOP:
-		ESPLOG(("esp%d: target %d sends a nop\n", esp->esp_id,
-			esp->current_SC->device->id));
-		return 0;
+	/* Reset the DMA */
+	esp->ops->reset_dma(esp);
 
-	case RESTORE_POINTERS:
-		/* In this case we might also have to backup the
-		 * "slow command" pointer.  It is rare to get such
-		 * a save/restore pointer sequence so early in the
-		 * bus transition sequences, but cover it.
-		 */
-		if (esp->esp_slowcmd) {
-			esp->esp_scmdleft = esp->current_SC->cmd_len;
-			esp->esp_scmdp = &esp->current_SC->cmnd[0];
-		}
-		esp_restore_pointers(esp, esp->current_SC);
-		return 0;
+	/* Reset the ESP */
+	esp_reset_esp(esp);
 
-	case SAVE_POINTERS:
-		esp_save_pointers(esp, esp->current_SC);
-		return 0;
+	/* Reset the SCSI bus, but tell ESP not to generate an irq */
+	val = esp_read8(ESP_CFG1);
+	val |= ESP_CONFIG1_SRRDISAB;
+	esp_write8(val, ESP_CFG1);
 
-	case COMMAND_COMPLETE:
-	case DISCONNECT:
-		/* Freeing the bus, let it go. */
-		esp->current_SC->SCp.phase = in_freeing;
-		return 0;
+	scsi_esp_cmd(esp, ESP_CMD_RS);
+	udelay(400);
 
-	case MESSAGE_REJECT:
-		ESPMISC(("msg reject, "));
-		if (esp->prevmsgout == EXTENDED_MESSAGE) {
-			struct esp_device *esp_dev = esp->current_SC->device->hostdata;
+	esp_write8(esp->config1, ESP_CFG1);
 
-			/* Doesn't look like this target can
-			 * do synchronous or WIDE transfers.
-			 */
-			ESPSDTR(("got reject, was trying nego, clearing sync/WIDE\n"));
-			esp_dev->sync = 1;
-			esp_dev->wide = 1;
-			esp_dev->sync_min_period = 0;
-			esp_dev->sync_max_offset = 0;
-			return 0;
-		} else {
-			ESPMISC(("not sync nego, sending ABORT\n"));
-			return ABORT;
-		}
-	};
+	/* Eat any bitrot in the chip and we are done... */
+	esp_read8(ESP_INTRPT);
 }
 
-/* Target negotiates for synchronous transfers before we do, this
- * is legal although very strange.  What is even funnier is that
- * the SCSI2 standard specifically recommends against targets doing
- * this because so many initiators cannot cope with this occurring.
- */
-static int target_with_ants_in_pants(struct esp *esp,
-				     struct scsi_cmnd *SCptr,
-				     struct esp_device *esp_dev)
+static void __devinit esp_set_clock_params(struct esp *esp)
 {
-	if (esp_dev->sync || SCptr->device->borken) {
-		/* sorry, no can do */
-		ESPSDTR(("forcing to async, "));
-		build_sync_nego_msg(esp, 0, 0);
-		esp_dev->sync = 1;
-		esp->snip = 1;
-		ESPLOG(("esp%d: hoping for msgout\n", esp->esp_id));
-		esp_advance_phase(SCptr, in_the_dark);
-		return EXTENDED_MESSAGE;
-	}
+	int fmhz;
+	u8 ccf;
 
-	/* Ok, we'll check them out... */
-	return 0;
-}
+	/* This is getting messy but it has to be done correctly or else
+	 * you get weird behavior all over the place.  We are trying to
+	 * basically figure out three pieces of information.
+	 *
+	 * a) Clock Conversion Factor
+	 *
+	 *    This is a representation of the input crystal clock frequency
+	 *    going into the ESP on this machine.  Any operation whose timing
+	 *    is longer than 400ns depends on this value being correct.  For
+	 *    example, you'll get blips for arbitration/selection during high
+	 *    load or with multiple targets if this is not set correctly.
+	 *
+	 * b) Selection Time-Out
+	 *
+	 *    The ESP isn't very bright and will arbitrate for the bus and try
+	 *    to select a target forever if you let it.  This value tells the
+	 *    ESP when it has taken too long to negotiate and that it should
+	 *    interrupt the CPU so we can see what happened.  The value is
+	 *    computed as follows (from NCR/Symbios chip docs).
+	 *
+	 *          (Time Out Period) *  (Input Clock)
+	 *    STO = ----------------------------------
+	 *          (8192) * (Clock Conversion Factor)
+	 *
+	 *    We use a time out period of 250ms (ESP_BUS_TIMEOUT).
+	 *
+	 * c) Imperical constants for synchronous offset and transfer period
+         *    register values
+	 *
+	 *    This entails the smallest and largest sync period we could ever
+	 *    handle on this ESP.
+	 */
+	fmhz = esp->cfreq;
 
-static void sync_report(struct esp *esp)
-{
-	int msg3, msg4;
-	char *type;
-
-	msg3 = esp->cur_msgin[3];
-	msg4 = esp->cur_msgin[4];
-	if (msg4) {
-		int hz = 1000000000 / (msg3 * 4);
-		int integer = hz / 1000000;
-		int fraction = (hz - (integer * 1000000)) / 10000;
-		if ((esp->erev == fashme) &&
-		    (esp->config3[esp->current_SC->device->id] & ESP_CONFIG3_EWIDE)) {
-			type = "FAST-WIDE";
-			integer <<= 1;
-			fraction <<= 1;
-		} else if ((msg3 * 4) < 200) {
-			type = "FAST";
-		} else {
-			type = "synchronous";
-		}
+	ccf = ((fmhz / 1000000) + 4) / 5;
+	if (ccf == 1)
+		ccf = 2;
 
-		/* Do not transform this back into one big printk
-		 * again, it triggers a bug in our sparc64-gcc272
-		 * sibling call optimization.  -DaveM
-		 */
-		ESPLOG((KERN_INFO "esp%d: target %d ",
-			esp->esp_id, esp->current_SC->device->id));
-		ESPLOG(("[period %dns offset %d %d.%02dMHz ",
-			(int) msg3 * 4, (int) msg4,
-			integer, fraction));
-		ESPLOG(("%s SCSI%s]\n", type,
-			(((msg3 * 4) < 200) ? "-II" : "")));
-	} else {
-		ESPLOG((KERN_INFO "esp%d: target %d asynchronous\n",
-			esp->esp_id, esp->current_SC->device->id));
+	/* If we can't find anything reasonable, just assume 20MHZ. 
+	 * This is the clock frequency of the older sun4c's where I've
+	 * been unable to find the clock-frequency PROM property.  All
+	 * other machines provide useful values it seems.
+	 */
+	if (fmhz <= 5000000 || ccf < 1 || ccf > 8) {
+		fmhz = 20000000;
+		ccf = 4;
 	}
+
+	esp->cfact = (ccf == 8 ? 0 : ccf);
+	esp->cfreq = fmhz;
+	esp->ccycle = ESP_MHZ_TO_CYCLE(fmhz);
+	esp->ctick = ESP_TICK(ccf, esp->ccycle);
+	esp->neg_defp = ESP_NEG_DEFP(fmhz, ccf);
+	esp->sync_defp = SYNC_DEFP_SLOW;
 }
 
-static int check_multibyte_msg(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	struct esp_device *esp_dev = SCptr->device->hostdata;
-	u8 regval = 0;
-	int message_out = 0;
-
-	ESPSDTR(("chk multibyte msg: "));
-	if (esp->cur_msgin[2] == EXTENDED_SDTR) {
-		int period = esp->cur_msgin[3];
-		int offset = esp->cur_msgin[4];
-
-		ESPSDTR(("is sync nego response, "));
-		if (!esp->snip) {
-			int rval;
-
-			/* Target negotiates first! */
-			ESPSDTR(("target jumps the gun, "));
-			message_out = EXTENDED_MESSAGE; /* we must respond */
-			rval = target_with_ants_in_pants(esp, SCptr, esp_dev);
-			if (rval)
-				return rval;
-		}
+static const char *esp_chip_names[] = {
+	"ESP100",
+	"ESP100A",
+	"ESP236",
+	"FAS236",
+	"FAS100A",
+	"FAST",
+	"FASHME",
+};
 
-		ESPSDTR(("examining sdtr, "));
+static struct scsi_transport_template *esp_transport_template;
 
-		/* Offset cannot be larger than ESP fifo size. */
-		if (offset > 15) {
-			ESPSDTR(("offset too big %2x, ", offset));
-			offset = 15;
-			ESPSDTR(("sending back new offset\n"));
-			build_sync_nego_msg(esp, period, offset);
-			return EXTENDED_MESSAGE;
-		}
+int __devinit scsi_esp_register(struct esp *esp, struct device *dev)
+{
+	static int instance;
+	int err;
 
-		if (offset && period > esp->max_period) {
-			/* Yeee, async for this slow device. */
-			ESPSDTR(("period too long %2x, ", period));
-			build_sync_nego_msg(esp, 0, 0);
-			ESPSDTR(("hoping for msgout\n"));
-			esp_advance_phase(esp->current_SC, in_the_dark);
-			return EXTENDED_MESSAGE;
-		} else if (offset && period < esp->min_period) {
-			ESPSDTR(("period too short %2x, ", period));
-			period = esp->min_period;
-			if (esp->erev > esp236)
-				regval = 4;
-			else
-				regval = 5;
-		} else if (offset) {
-			int tmp;
-
-			ESPSDTR(("period is ok, "));
-			tmp = esp->ccycle / 1000;
-			regval = (((period << 2) + tmp - 1) / tmp);
-			if (regval && ((esp->erev == fas100a ||
-					esp->erev == fas236  ||
-					esp->erev == fashme))) {
-				if (period >= 50)
-					regval--;
-			}
-		}
+	esp->host->transportt = esp_transport_template;
+	esp->host->max_lun = ESP_MAX_LUN;
+	esp->host->cmd_per_lun = 2;
 
-		if (offset) {
-			u8 bit;
-
-			esp_dev->sync_min_period = (regval & 0x1f);
-			esp_dev->sync_max_offset = (offset | esp->radelay);
-			if (esp->erev == fas100a || esp->erev == fas236 || esp->erev == fashme) {
-				if ((esp->erev == fas100a) || (esp->erev == fashme))
-					bit = ESP_CONFIG3_FAST;
-				else
-					bit = ESP_CONFIG3_FSCSI;
-				if (period < 50) {
-					/* On FAS366, if using fast-20 synchronous transfers
-					 * we need to make sure the REQ/ACK assert/deassert
-					 * control bits are clear.
-					 */
-					if (esp->erev == fashme)
-						esp_dev->sync_max_offset &= ~esp->radelay;
-					esp->config3[SCptr->device->id] |= bit;
-				} else {
-					esp->config3[SCptr->device->id] &= ~bit;
-				}
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
-				sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-			}
-			esp->prev_soff = esp_dev->sync_max_offset;
-			esp->prev_stp = esp_dev->sync_min_period;
-			sbus_writeb(esp->prev_soff, esp->eregs + ESP_SOFF);
-			sbus_writeb(esp->prev_stp, esp->eregs + ESP_STP);
-			ESPSDTR(("soff=%2x stp=%2x cfg3=%2x\n",
-				 esp_dev->sync_max_offset,
-				 esp_dev->sync_min_period,
-				 esp->config3[SCptr->device->id]));
-
-			esp->snip = 0;
-		} else if (esp_dev->sync_max_offset) {
-			u8 bit;
-
-			/* back to async mode */
-			ESPSDTR(("unaccaptable sync nego, forcing async\n"));
-			esp_dev->sync_max_offset = 0;
-			esp_dev->sync_min_period = 0;
-			esp->prev_soff = 0;
-			esp->prev_stp = 0;
-			sbus_writeb(esp->prev_soff, esp->eregs + ESP_SOFF);
-			sbus_writeb(esp->prev_stp, esp->eregs + ESP_STP);
-			if (esp->erev == fas100a || esp->erev == fas236 || esp->erev == fashme) {
-				if ((esp->erev == fas100a) || (esp->erev == fashme))
-					bit = ESP_CONFIG3_FAST;
-				else
-					bit = ESP_CONFIG3_FSCSI;
-				esp->config3[SCptr->device->id] &= ~bit;
-				esp->prev_cfg3 = esp->config3[SCptr->device->id];
-				sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-			}
-		}
+	esp_set_clock_params(esp);
 
-		sync_report(esp);
+	esp_get_revision(esp);
 
-		ESPSDTR(("chk multibyte msg: sync is known, "));
-		esp_dev->sync = 1;
+	esp_init_swstate(esp);
 
-		if (message_out) {
-			ESPLOG(("esp%d: sending sdtr back, hoping for msgout\n",
-				esp->esp_id));
-			build_sync_nego_msg(esp, period, offset);
-			esp_advance_phase(SCptr, in_the_dark);
-			return EXTENDED_MESSAGE;
-		}
+	esp_bootup_reset(esp);
 
-		ESPSDTR(("returning zero\n"));
-		esp_advance_phase(SCptr, in_the_dark); /* ...or else! */
-		return 0;
-	} else if (esp->cur_msgin[2] == EXTENDED_WDTR) {
-		int size = 8 << esp->cur_msgin[3];
-
-		esp->wnip = 0;
-		if (esp->erev != fashme) {
-			ESPLOG(("esp%d: AIEEE wide msg received and not HME.\n",
-				esp->esp_id));
-			message_out = MESSAGE_REJECT;
-		} else if (size > 16) {
-			ESPLOG(("esp%d: AIEEE wide transfer for %d size "
-				"not supported.\n", esp->esp_id, size));
-			message_out = MESSAGE_REJECT;
-		} else {
-			/* Things look good; let's see what we got. */
-			if (size == 16) {
-				/* Set config 3 register for this target. */
-				esp->config3[SCptr->device->id] |= ESP_CONFIG3_EWIDE;
-			} else {
-				/* Just make sure it was one byte sized. */
-				if (size != 8) {
-					ESPLOG(("esp%d: Aieee, wide nego of %d size.\n",
-						esp->esp_id, size));
-					message_out = MESSAGE_REJECT;
-					goto finish;
-				}
-				/* Pure paranoia. */
-				esp->config3[SCptr->device->id] &= ~(ESP_CONFIG3_EWIDE);
-			}
-			esp->prev_cfg3 = esp->config3[SCptr->device->id];
-			sbus_writeb(esp->prev_cfg3, esp->eregs + ESP_CFG3);
-
-			/* Regardless, next try for sync transfers. */
-			build_sync_nego_msg(esp, esp->sync_defp, 15);
-			esp_dev->sync = 1;
-			esp->snip = 1;
-			message_out = EXTENDED_MESSAGE;
-		}
-	} else if (esp->cur_msgin[2] == EXTENDED_MODIFY_DATA_POINTER) {
-		ESPLOG(("esp%d: rejecting modify data ptr msg\n", esp->esp_id));
-		message_out = MESSAGE_REJECT;
-	}
-finish:
-	esp_advance_phase(SCptr, in_the_dark);
-	return message_out;
-}
+	printk(KERN_INFO PFX "esp%u, regs[%1p:%1p] irq[%u]\n",
+	       esp->host->unique_id, esp->regs, esp->dma_regs,
+	       esp->host->irq);
+	printk(KERN_INFO PFX "esp%u is a %s, %u MHz (ccf=%u), SCSI ID %u\n",
+	       esp->host->unique_id, esp_chip_names[esp->rev],
+	       esp->cfreq / 1000000, esp->cfact, esp->scsi_id);
 
-static int esp_do_msgindone(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	int message_out = 0, it = 0, rval;
+	/* Let the SCSI bus reset settle. */
+	schedule_timeout_uninterruptible(esp_bus_reset_settle * HZ);
 
-	rval = skipahead1(esp, SCptr, in_msgin, in_msgindone);
-	if (rval)
-		return rval;
-	if (SCptr->SCp.sent_command != in_status) {
-		if (!(esp->ireg & ESP_INTR_DC)) {
-			if (esp->msgin_len && (esp->sreg & ESP_STAT_PERR)) {
-				message_out = MSG_PARITY_ERROR;
-				esp_cmd(esp, ESP_CMD_FLUSH);
-			} else if (esp->erev != fashme &&
-			  (it = (sbus_readb(esp->eregs + ESP_FFLAGS) & ESP_FF_FBYTES)) != 1) {
-				/* We certainly dropped the ball somewhere. */
-				message_out = INITIATOR_ERROR;
-				esp_cmd(esp, ESP_CMD_FLUSH);
-			} else if (!esp->msgin_len) {
-				if (esp->erev == fashme)
-					it = esp->hme_fifo_workaround_buffer[0];
-				else
-					it = sbus_readb(esp->eregs + ESP_FDATA);
-				esp_advance_phase(SCptr, in_msgincont);
-			} else {
-				/* it is ok and we want it */
-				if (esp->erev == fashme)
-					it = esp->cur_msgin[esp->msgin_ctr] =
-						esp->hme_fifo_workaround_buffer[0];
-				else
-					it = esp->cur_msgin[esp->msgin_ctr] =
-						sbus_readb(esp->eregs + ESP_FDATA);
-				esp->msgin_ctr++;
-			}
-		} else {
-			esp_advance_phase(SCptr, in_the_dark);
-			return do_work_bus;
-		}
-	} else {
-		it = esp->cur_msgin[0];
-	}
-	if (!message_out && esp->msgin_len) {
-		if (esp->msgin_ctr < esp->msgin_len) {
-			esp_advance_phase(SCptr, in_msgincont);
-		} else if (esp->msgin_len == 1) {
-			message_out = check_singlebyte_msg(esp);
-		} else if (esp->msgin_len == 2) {
-			if (esp->cur_msgin[0] == EXTENDED_MESSAGE) {
-				if ((it + 2) >= 15) {
-					message_out = MESSAGE_REJECT;
-				} else {
-					esp->msgin_len = (it + 2);
-					esp_advance_phase(SCptr, in_msgincont);
-				}
-			} else {
-				message_out = MESSAGE_REJECT; /* foo on you */
-			}
-		} else {
-			message_out = check_multibyte_msg(esp);
-		}
-	}
-	if (message_out < 0) {
-		return -message_out;
-	} else if (message_out) {
-		if (((message_out != 1) &&
-		     ((message_out < 0x20) || (message_out & 0x80))))
-			esp->msgout_len = 1;
-		esp->cur_msgout[0] = message_out;
-		esp_cmd(esp, ESP_CMD_SATN);
-		esp_advance_phase(SCptr, in_the_dark);
-		esp->msgin_len = 0;
-	}
-	esp->sreg = sbus_readb(esp->eregs + ESP_STATUS);
-	esp->sreg &= ~(ESP_STAT_INTR);
-	if ((esp->sreg & (ESP_STAT_PMSG|ESP_STAT_PCD)) == (ESP_STAT_PMSG|ESP_STAT_PCD))
-		esp_cmd(esp, ESP_CMD_MOK);
-	if ((SCptr->SCp.sent_command == in_msgindone) &&
-	    (SCptr->SCp.phase == in_freeing))
-		return esp_do_freebus(esp);
-	return do_intr_end;
-}
+	err = scsi_add_host(esp->host, dev);
+	if (err)
+		return err;
 
-static int esp_do_cmdbegin(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr = esp->current_SC;
-
-	esp_advance_phase(SCptr, in_cmdend);
-	if (esp->erev == fashme) {
-		u32 tmp = sbus_readl(esp->dregs + DMA_CSR);
-		int i;
-
-		for (i = 0; i < esp->esp_scmdleft; i++)
-			esp->esp_command[i] = *esp->esp_scmdp++;
-		esp->esp_scmdleft = 0;
-		esp_cmd(esp, ESP_CMD_FLUSH);
-		esp_setcount(esp->eregs, i, 1);
-		esp_cmd(esp, (ESP_CMD_DMA | ESP_CMD_TI));
-		tmp |= (DMA_SCSI_DISAB | DMA_ENABLE);
-		tmp &= ~(DMA_ST_WRITE);
-		sbus_writel(i, esp->dregs + DMA_COUNT);
-		sbus_writel(esp->esp_command_dvma, esp->dregs + DMA_ADDR);
-		sbus_writel(tmp, esp->dregs + DMA_CSR);
-	} else {
-		u8 tmp;
+	esp->host->unique_id = instance++;
 
-		esp_cmd(esp, ESP_CMD_FLUSH);
-		tmp = *esp->esp_scmdp++;
-		esp->esp_scmdleft--;
-		sbus_writeb(tmp, esp->eregs + ESP_FDATA);
-		esp_cmd(esp, ESP_CMD_TI);
-	}
-	return do_intr_end;
+	scsi_scan_host(esp->host);
+
+	return 0;
 }
+EXPORT_SYMBOL(scsi_esp_register);
 
-static int esp_do_cmddone(struct esp *esp)
+void __devexit scsi_esp_unregister(struct esp *esp)
 {
-	if (esp->erev == fashme)
-		dma_invalidate(esp);
-	else
-		esp_cmd(esp, ESP_CMD_NULL);
-
-	if (esp->ireg & ESP_INTR_BSERV) {
-		esp_advance_phase(esp->current_SC, in_the_dark);
-		return esp_do_phase_determine(esp);
-	}
-
-	ESPLOG(("esp%d: in do_cmddone() but didn't get BSERV interrupt.\n",
-		esp->esp_id));
-	return do_reset_bus;
+	scsi_remove_host(esp->host);
 }
+EXPORT_SYMBOL(scsi_esp_unregister);
 
-static int esp_do_msgout(struct esp *esp)
+static int esp_slave_alloc(struct scsi_device *dev)
 {
-	esp_cmd(esp, ESP_CMD_FLUSH);
-	switch (esp->msgout_len) {
-	case 1:
-		if (esp->erev == fashme)
-			hme_fifo_push(esp, &esp->cur_msgout[0], 1);
-		else
-			sbus_writeb(esp->cur_msgout[0], esp->eregs + ESP_FDATA);
+	struct esp *esp = host_to_esp(dev->host);
+	struct esp_target_data *tp = &esp->target[dev->id];
+	struct esp_lun_data *lp;
 
-		esp_cmd(esp, ESP_CMD_TI);
-		break;
-
-	case 2:
-		esp->esp_command[0] = esp->cur_msgout[0];
-		esp->esp_command[1] = esp->cur_msgout[1];
+	if (dev->id >= ESP_MAX_TARGET || dev->lun >= ESP_MAX_LUN)
+		return -ENXIO;
 
-		if (esp->erev == fashme) {
-			hme_fifo_push(esp, &esp->cur_msgout[0], 2);
-			esp_cmd(esp, ESP_CMD_TI);
-		} else {
-			dma_setup(esp, esp->esp_command_dvma, 2, 0);
-			esp_setcount(esp->eregs, 2, 0);
-			esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-		}
-		break;
+	lp = tp->lun[dev->lun];
+	if (!lp) {
+		lp = kzalloc(sizeof(*lp), GFP_KERNEL);
+		if (!lp)
+			return -ENOMEM;
+		tp->lun[dev->lun] = lp;
+	}
 
-	case 4:
-		esp->esp_command[0] = esp->cur_msgout[0];
-		esp->esp_command[1] = esp->cur_msgout[1];
-		esp->esp_command[2] = esp->cur_msgout[2];
-		esp->esp_command[3] = esp->cur_msgout[3];
-		esp->snip = 1;
+	tp->starget = dev->sdev_target;
 
-		if (esp->erev == fashme) {
-			hme_fifo_push(esp, &esp->cur_msgout[0], 4);
-			esp_cmd(esp, ESP_CMD_TI);
-		} else {
-			dma_setup(esp, esp->esp_command_dvma, 4, 0);
-			esp_setcount(esp->eregs, 4, 0);
-			esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-		}
-		break;
+	spi_min_period(tp->starget) = esp->min_period;
+	spi_max_offset(tp->starget) = 15;
 
-	case 5:
-		esp->esp_command[0] = esp->cur_msgout[0];
-		esp->esp_command[1] = esp->cur_msgout[1];
-		esp->esp_command[2] = esp->cur_msgout[2];
-		esp->esp_command[3] = esp->cur_msgout[3];
-		esp->esp_command[4] = esp->cur_msgout[4];
-		esp->snip = 1;
-
-		if (esp->erev == fashme) {
-			hme_fifo_push(esp, &esp->cur_msgout[0], 5);
-			esp_cmd(esp, ESP_CMD_TI);
-		} else {
-			dma_setup(esp, esp->esp_command_dvma, 5, 0);
-			esp_setcount(esp->eregs, 5, 0);
-			esp_cmd(esp, ESP_CMD_DMA | ESP_CMD_TI);
-		}
-		break;
+	if (esp->flags & ESP_FLAG_WIDE_CAPABLE)
+		spi_max_width(tp->starget) = 1;
+	else
+		spi_max_width(tp->starget) = 0;
 
-	default:
-		/* whoops */
-		ESPMISC(("bogus msgout sending NOP\n"));
-		esp->cur_msgout[0] = NOP;
+	return 0;
+}
 
-		if (esp->erev == fashme) {
-			hme_fifo_push(esp, &esp->cur_msgout[0], 1);
-		} else {
-			sbus_writeb(esp->cur_msgout[0], esp->eregs + ESP_FDATA);
-		}
+static int esp_slave_configure(struct scsi_device *dev)
+{
+	struct esp *esp = host_to_esp(dev->host);
+	struct esp_target_data *tp = &esp->target[dev->id];
+	int goal_tags, queue_depth;
 
-		esp->msgout_len = 1;
-		esp_cmd(esp, ESP_CMD_TI);
-		break;
-	};
+	goal_tags = 0;
 
-	esp_advance_phase(esp->current_SC, in_msgoutdone);
-	return do_intr_end;
-}
+	if (dev->tagged_supported) {
+		/* XXX make this configurable somehow XXX */
+		goal_tags = ESP_DEFAULT_TAGS;
 
-static int esp_do_msgoutdone(struct esp *esp)
-{
-	if (esp->msgout_len > 1) {
-		/* XXX HME/FAS ATN deassert workaround required,
-		 * XXX no DMA flushing, only possible ESP_CMD_FLUSH
-		 * XXX to kill the fifo.
-		 */
-		if (esp->erev != fashme) {
-			u32 tmp;
-
-			while ((tmp = sbus_readl(esp->dregs + DMA_CSR)) & DMA_PEND_READ)
-				udelay(1);
-			tmp &= ~DMA_ENABLE;
-			sbus_writel(tmp, esp->dregs + DMA_CSR);
-			dma_invalidate(esp);
-		} else {
-			esp_cmd(esp, ESP_CMD_FLUSH);
-		}
+		if (goal_tags > ESP_MAX_TAG)
+			goal_tags = ESP_MAX_TAG;
 	}
-	if (!(esp->ireg & ESP_INTR_DC)) {
-		if (esp->erev != fashme)
-			esp_cmd(esp, ESP_CMD_NULL);
-		switch (esp->sreg & ESP_STAT_PMASK) {
-		case ESP_MOP:
-			/* whoops, parity error */
-			ESPLOG(("esp%d: still in msgout, parity error assumed\n",
-				esp->esp_id));
-			if (esp->msgout_len > 1)
-				esp_cmd(esp, ESP_CMD_SATN);
-			esp_advance_phase(esp->current_SC, in_msgout);
-			return do_work_bus;
-
-		case ESP_DIP:
-			break;
 
-		default:
-			/* Happy Meal fifo is touchy... */
-			if ((esp->erev != fashme) &&
-			    !fcount(esp) &&
-			    !(((struct esp_device *)esp->current_SC->device->hostdata)->sync_max_offset))
-				esp_cmd(esp, ESP_CMD_FLUSH);
-			break;
+	queue_depth = goal_tags;
+	if (queue_depth < dev->host->cmd_per_lun)
+		queue_depth = dev->host->cmd_per_lun;
 
-		};
+	if (goal_tags) {
+		scsi_set_tag_type(dev, MSG_ORDERED_TAG);
+		scsi_activate_tcq(dev, queue_depth);
 	} else {
-		ESPLOG(("esp%d: disconnect, resetting bus\n", esp->esp_id));
-		return do_reset_bus;
+		scsi_deactivate_tcq(dev, queue_depth);
 	}
+	tp->flags |= ESP_TGT_DISCONNECT;
 
-	/* If we sent out a synchronous negotiation message, update
-	 * our state.
-	 */
-	if (esp->cur_msgout[2] == EXTENDED_MESSAGE &&
-	    esp->cur_msgout[4] == EXTENDED_SDTR) {
-		esp->snip = 1; /* anal retentiveness... */
-	}
+	if (!spi_initial_dv(dev->sdev_target))
+		spi_dv_device(dev);
 
-	esp->prevmsgout = esp->cur_msgout[0];
-	esp->msgout_len = 0;
-	esp_advance_phase(esp->current_SC, in_the_dark);
-	return esp_do_phase_determine(esp);
+	return 0;
 }
 
-static int esp_bus_unexpected(struct esp *esp)
+static void esp_slave_destroy(struct scsi_device *dev)
 {
-	ESPLOG(("esp%d: command in weird state %2x\n",
-		esp->esp_id, esp->current_SC->SCp.phase));
-	return do_reset_bus;
-}
+	struct esp *esp = host_to_esp(dev->host);
+	struct esp_target_data *tp = &esp->target[dev->id];
+	struct esp_lun_data *lp = tp->lun[dev->lun];
 
-static espfunc_t bus_vector[] = {
-	esp_do_data_finale,
-	esp_do_data_finale,
-	esp_bus_unexpected,
-	esp_do_msgin,
-	esp_do_msgincont,
-	esp_do_msgindone,
-	esp_do_msgout,
-	esp_do_msgoutdone,
-	esp_do_cmdbegin,
-	esp_do_cmddone,
-	esp_do_status,
-	esp_do_freebus,
-	esp_do_phase_determine,
-	esp_bus_unexpected,
-	esp_bus_unexpected,
-	esp_bus_unexpected,
-};
+	tp->lun[dev->lun] = NULL;
+	kfree(lp);
+}
 
-/* This is the second tier in our dual-level SCSI state machine. */
-static int esp_work_bus(struct esp *esp)
+static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	struct scsi_cmnd *SCptr = esp->current_SC;
-	unsigned int phase;
+	struct esp *esp = host_to_esp(cmd->device->host);
+	struct esp_cmd_entry *ent, *tmp;
+	struct completion eh_done;
+	unsigned long flags;
 
-	ESPBUS(("esp_work_bus: "));
-	if (!SCptr) {
-		ESPBUS(("reconnect\n"));
-		return esp_do_reconnect(esp);
+	/* XXX This helps a lot with debugging but might be a bit
+	 * XXX much for the final driver.
+	 */
+	spin_lock_irqsave(esp->host->host_lock, flags);
+	printk(KERN_ERR PFX "esp%d: Aborting command [%p:%02x]\n",
+	       esp->host->unique_id, cmd, cmd->cmnd[0]);
+	ent = esp->active_cmd;
+	if (ent)
+		printk(KERN_ERR PFX "esp%d: Current command [%p:%02x]\n",
+		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
+	list_for_each_entry(ent, &esp->queued_cmds, list) {
+		printk(KERN_ERR PFX "esp%d: Queued command [%p:%02x]\n",
+		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
+	}
+	list_for_each_entry(ent, &esp->active_cmds, list) {
+		printk(KERN_ERR PFX "esp%d: Active command [%p:%02x]\n",
+		       esp->host->unique_id, ent->cmd, ent->cmd->cmnd[0]);
+	}
+	esp_dump_cmd_log(esp);
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
+
+	spin_lock_irqsave(esp->host->host_lock, flags);
+
+	ent = NULL;
+	list_for_each_entry(tmp, &esp->queued_cmds, list) {
+		if (tmp->cmd == cmd) {
+			ent = tmp;
+			break;
+		}
 	}
-	phase = SCptr->SCp.phase;
-	if ((phase & 0xf0) == in_phases_mask)
-		return bus_vector[(phase & 0x0f)](esp);
-	else if ((phase & 0xf0) == in_slct_mask)
-		return esp_select_complete(esp);
-	else
-		return esp_bus_unexpected(esp);
-}
 
-static espfunc_t isvc_vector[] = {
-	NULL,
-	esp_do_phase_determine,
-	esp_do_resetbus,
-	esp_finish_reset,
-	esp_work_bus
-};
+	if (ent) {
+		/* Easiest case, we didn't even issue the command
+		 * yet so it is trivial to abort.
+		 */
+		list_del(&ent->list);
 
-/* Main interrupt handler for an esp adapter. */
-static void esp_handle(struct esp *esp)
-{
-	struct scsi_cmnd *SCptr;
-	int what_next = do_intr_end;
+		cmd->result = DID_ABORT << 16;
+		cmd->scsi_done(cmd);
 
-	SCptr = esp->current_SC;
+		esp_put_ent(esp, ent);
 
-	/* Check for errors. */
-	esp->sreg = sbus_readb(esp->eregs + ESP_STATUS);
-	esp->sreg &= (~ESP_STAT_INTR);
-	if (esp->erev == fashme) {
-		esp->sreg2 = sbus_readb(esp->eregs + ESP_STATUS2);
-		esp->seqreg = (sbus_readb(esp->eregs + ESP_SSTEP) & ESP_STEP_VBITS);
+		goto out_success;
 	}
 
-	if (esp->sreg & (ESP_STAT_SPAM)) {
-		/* Gross error, could be due to one of:
-		 *
-		 * - top of fifo overwritten, could be because
-		 *   we tried to do a synchronous transfer with
-		 *   an offset greater than ESP fifo size
-		 *
-		 * - top of command register overwritten
-		 *
-		 * - DMA setup to go in one direction, SCSI
-		 *   bus points in the other, whoops
-		 *
-		 * - weird phase change during asynchronous
-		 *   data phase while we are initiator
-		 */
-		ESPLOG(("esp%d: Gross error sreg=%2x\n", esp->esp_id, esp->sreg));
+	init_completion(&eh_done);
 
-		/* If a command is live on the bus we cannot safely
-		 * reset the bus, so we'll just let the pieces fall
-		 * where they may.  Here we are hoping that the
-		 * target will be able to cleanly go away soon
-		 * so we can safely reset things.
+	ent = esp->active_cmd;
+	if (ent && ent->cmd == cmd) {
+		/* Command is the currently active command on
+		 * the bus.  If we already have an output message
+		 * pending, no dice.
 		 */
-		if (!SCptr) {
-			ESPLOG(("esp%d: No current cmd during gross error, "
-				"resetting bus\n", esp->esp_id));
-			what_next = do_reset_bus;
-			goto state_machine;
-		}
-	}
+		if (esp->msg_out_len)
+			goto out_failure;
 
-	if (sbus_readl(esp->dregs + DMA_CSR) & DMA_HNDL_ERROR) {
-		/* A DMA gate array error.  Here we must
-		 * be seeing one of two things.  Either the
-		 * virtual to physical address translation
-		 * on the SBUS could not occur, else the
-		 * translation it did get pointed to a bogus
-		 * page.  Ho hum...
+		/* Send out an abort, encouraging the target to
+		 * go to MSGOUT phase by asserting ATN.
 		 */
-		ESPLOG(("esp%d: DMA error %08x\n", esp->esp_id,
-			sbus_readl(esp->dregs + DMA_CSR)));
+		esp->msg_out[0] = ABORT_TASK_SET;
+		esp->msg_out_len = 1;
+		ent->eh_done = &eh_done;
 
-		/* DMA gate array itself must be reset to clear the
-		 * error condition.
+		scsi_esp_cmd(esp, ESP_CMD_SATN);
+	} else {
+		/* The command is disconnected.  This is not easy to
+		 * abort.  For now we fail and let the scsi error
+		 * handling layer go try a scsi bus reset or host
+		 * reset.
+		 *
+		 * What we could do is put together a scsi command
+		 * solely for the purpose of sending an abort message
+		 * to the target.  Coming up with all the code to
+		 * cook up scsi commands, special case them everywhere,
+		 * etc. is for questionable gain and it would be better
+		 * if the generic scsi error handling layer could do at
+		 * least some of that for us.
+		 *
+		 * Anyways this is an area for potential future improvement
+		 * in this driver.
 		 */
-		esp_reset_dma(esp);
-
-		what_next = do_reset_bus;
-		goto state_machine;
+		goto out_failure;
 	}
 
-	esp->ireg = sbus_readb(esp->eregs + ESP_INTRPT);   /* Unlatch intr reg */
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
 
-	if (esp->erev == fashme) {
-		/* This chip is really losing. */
-		ESPHME(("HME["));
+	if (!wait_for_completion_timeout(&eh_done, 5 * HZ)) {
+		spin_lock_irqsave(esp->host->host_lock, flags);
+		ent->eh_done = NULL;
+		spin_unlock_irqrestore(esp->host->host_lock, flags);
 
-		ESPHME(("sreg2=%02x,", esp->sreg2));
-		/* Must latch fifo before reading the interrupt
-		 * register else garbage ends up in the FIFO
-		 * which confuses the driver utterly.
-		 */
-		if (!(esp->sreg2 & ESP_STAT2_FEMPTY) ||
-		    (esp->sreg2 & ESP_STAT2_F1BYTE)) {
-			ESPHME(("fifo_workaround]"));
-			hme_fifo_read(esp);
-		} else {
-			ESPHME(("no_fifo_workaround]"));
-		}
-	}
-
-	/* No current cmd is only valid at this point when there are
-	 * commands off the bus or we are trying a reset.
-	 */
-	if (!SCptr && !esp->disconnected_SC && !(esp->ireg & ESP_INTR_SR)) {
-		/* Panic is safe, since current_SC is null. */
-		ESPLOG(("esp%d: no command in esp_handle()\n", esp->esp_id));
-		panic("esp_handle: current_SC == penguin within interrupt!");
+		return FAILED;
 	}
 
-	if (esp->ireg & (ESP_INTR_IC)) {
-		/* Illegal command fed to ESP.  Outside of obvious
-		 * software bugs that could cause this, there is
-		 * a condition with esp100 where we can confuse the
-		 * ESP into an erroneous illegal command interrupt
-		 * because it does not scrape the FIFO properly
-		 * for reselection.  See esp100_reconnect_hwbug()
-		 * to see how we try very hard to avoid this.
-		 */
-		ESPLOG(("esp%d: invalid command\n", esp->esp_id));
-
-		esp_dump_state(esp);
-
-		if (SCptr != NULL) {
-			/* Devices with very buggy firmware can drop BSY
-			 * during a scatter list interrupt when using sync
-			 * mode transfers.  We continue the transfer as
-			 * expected, the target drops the bus, the ESP
-			 * gets confused, and we get a illegal command
-			 * interrupt because the bus is in the disconnected
-			 * state now and ESP_CMD_TI is only allowed when
-			 * a nexus is alive on the bus.
-			 */
-			ESPLOG(("esp%d: Forcing async and disabling disconnect for "
-				"target %d\n", esp->esp_id, SCptr->device->id));
-			SCptr->device->borken = 1; /* foo on you */
-		}
-
-		what_next = do_reset_bus;
-	} else if (!(esp->ireg & ~(ESP_INTR_FDONE | ESP_INTR_BSERV | ESP_INTR_DC))) {
-		if (SCptr) {
-			unsigned int phase = SCptr->SCp.phase;
+	return SUCCESS;
 
-			if (phase & in_phases_mask) {
-				what_next = esp_work_bus(esp);
-			} else if (phase & in_slct_mask) {
-				what_next = esp_select_complete(esp);
-			} else {
-				ESPLOG(("esp%d: interrupt for no good reason...\n",
-					esp->esp_id));
-				what_next = do_intr_end;
-			}
-		} else {
-			ESPLOG(("esp%d: BSERV or FDONE or DC while SCptr==NULL\n",
-				esp->esp_id));
-			what_next = do_reset_bus;
-		}
-	} else if (esp->ireg & ESP_INTR_SR) {
-		ESPLOG(("esp%d: SCSI bus reset interrupt\n", esp->esp_id));
-		what_next = do_reset_complete;
-	} else if (esp->ireg & (ESP_INTR_S | ESP_INTR_SATN)) {
-		ESPLOG(("esp%d: AIEEE we have been selected by another initiator!\n",
-			esp->esp_id));
-		what_next = do_reset_bus;
-	} else if (esp->ireg & ESP_INTR_RSEL) {
-		if (SCptr == NULL) {
-			/* This is ok. */
-			what_next = esp_do_reconnect(esp);
-		} else if (SCptr->SCp.phase & in_slct_mask) {
-			/* Only selection code knows how to clean
-			 * up properly.
-			 */
-			ESPDISC(("Reselected during selection attempt\n"));
-			what_next = esp_select_complete(esp);
-		} else {
-			ESPLOG(("esp%d: Reselected while bus is busy\n",
-				esp->esp_id));
-			what_next = do_reset_bus;
-		}
-	}
+out_success:
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	return SUCCESS;
 
-	/* This is tier-one in our dual level SCSI state machine. */
-state_machine:
-	while (what_next != do_intr_end) {
-		if (what_next >= do_phase_determine &&
-		    what_next < do_intr_end) {
-			what_next = isvc_vector[what_next](esp);
-		} else {
-			/* state is completely lost ;-( */
-			ESPLOG(("esp%d: interrupt engine loses state, resetting bus\n",
-				esp->esp_id));
-			what_next = do_reset_bus;
-		}
-	}
+out_failure:
+	/* XXX This might be a good location to set ESP_TGT_BROKEN
+	 * XXX since we know which target/lun in particular is
+	 * XXX causing trouble.
+	 */
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	return FAILED;
 }
 
-/* Service only the ESP described by dev_id. */
-static irqreturn_t esp_intr(int irq, void *dev_id)
+static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct esp *esp = dev_id;
+	struct esp *esp = host_to_esp(cmd->device->host);
+	struct completion eh_reset;
 	unsigned long flags;
 
-	spin_lock_irqsave(esp->ehost->host_lock, flags);
-	if (ESP_IRQ_P(esp->dregs)) {
-		ESP_INTSOFF(esp->dregs);
+	init_completion(&eh_reset);
 
-		ESPIRQ(("I[%d:%d](", smp_processor_id(), esp->esp_id));
-		esp_handle(esp);
-		ESPIRQ((")"));
+	spin_lock_irqsave(esp->host->host_lock, flags);
 
-		ESP_INTSON(esp->dregs);
+	esp->eh_reset = &eh_reset;
+
+	/* XXX This is too simple... We should add lots of
+	 * XXX checks here so that if we find that the chip is
+	 * XXX very wedged we return failure immediately so
+	 * XXX that we can perform a full chip reset.
+	 */
+	esp->flags |= ESP_FLAG_RESETTING;
+	scsi_esp_cmd(esp, ESP_CMD_RS);
+
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
+
+	schedule_timeout_uninterruptible(esp_bus_reset_settle * HZ);
+
+	if (!wait_for_completion_timeout(&eh_reset, 5 * HZ)) {
+		spin_lock_irqsave(esp->host->host_lock, flags);
+		esp->eh_reset = NULL;
+		spin_unlock_irqrestore(esp->host->host_lock, flags);
+
+		return FAILED;
 	}
-	spin_unlock_irqrestore(esp->ehost->host_lock, flags);
 
-	return IRQ_HANDLED;
+	return SUCCESS;
 }
 
-static int esp_slave_alloc(struct scsi_device *SDptr)
+/* All bets are off, reset the entire device.  */
+static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct esp_device *esp_dev =
-		kmalloc(sizeof(struct esp_device), GFP_ATOMIC);
+	struct esp *esp = host_to_esp(cmd->device->host);
+	unsigned long flags;
 
-	if (!esp_dev)
-		return -ENOMEM;
-	memset(esp_dev, 0, sizeof(struct esp_device));
-	SDptr->hostdata = esp_dev;
-	return 0;
+	spin_lock_irqsave(esp->host->host_lock, flags);
+	esp_bootup_reset(esp);
+	esp_reset_cleanup(esp);
+	spin_unlock_irqrestore(esp->host->host_lock, flags);
+
+	schedule_timeout_uninterruptible(esp_bus_reset_settle * HZ);
+
+	return SUCCESS;
 }
 
-static void esp_slave_destroy(struct scsi_device *SDptr)
+static const char *esp_info(struct Scsi_Host *host)
 {
-	struct esp *esp = (struct esp *) SDptr->host->hostdata;
-
-	esp->targets_present &= ~(1 << SDptr->id);
-	kfree(SDptr->hostdata);
-	SDptr->hostdata = NULL;
+	return "esp";
 }
 
-static struct scsi_host_template esp_template = {
+struct scsi_host_template scsi_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "esp",
 	.info			= esp_info,
+	.queuecommand		= esp_queue,
 	.slave_alloc		= esp_slave_alloc,
+	.slave_configure	= esp_slave_configure,
 	.slave_destroy		= esp_slave_destroy,
-	.queuecommand		= esp_queue,
-	.eh_abort_handler	= esp_abort,
-	.eh_bus_reset_handler	= esp_reset,
+	.eh_abort_handler	= esp_eh_abort_handler,
+	.eh_bus_reset_handler	= esp_eh_bus_reset_handler,
+	.eh_host_reset_handler	= esp_eh_host_reset_handler,
 	.can_queue		= 7,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.proc_name		= "esp",
-	.proc_info		= esp_proc_info,
+	.max_sectors		= 0xffff,
 };
+EXPORT_SYMBOL(scsi_esp_template);
 
-#ifndef CONFIG_SUN4
-static struct of_device_id esp_match[] = {
-	{
-		.name = "SUNW,esp",
-		.data = &esp_template,
-	},
-	{
-		.name = "SUNW,fas",
-		.data = &esp_template,
-	},
-	{
-		.name = "esp",
-		.data = &esp_template,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, esp_match);
+static void esp_get_signalling(struct Scsi_Host *host)
+{
+	struct esp *esp = host_to_esp(host);
+	enum spi_signal_type type;
+
+	if (esp->flags & ESP_FLAG_DIFFERENTIAL)
+		type = SPI_SIGNAL_HVD;
+	else
+		type = SPI_SIGNAL_SE;
+
+	spi_signalling(host) = type;
+}
 
-static struct of_platform_driver esp_sbus_driver = {
-	.name		= "esp",
-	.match_table	= esp_match,
-	.probe		= esp_sbus_probe,
-	.remove		= __devexit_p(esp_sbus_remove),
+static void esp_set_offset(struct scsi_target *target, int offset)
+{
+	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
+	struct esp *esp = host_to_esp(host);
+	struct esp_target_data *tp = &esp->target[target->id];
+
+	tp->nego_goal_offset = offset;
+	tp->flags |= ESP_TGT_CHECK_NEGO;
+}
+
+static void esp_set_period(struct scsi_target *target, int period)
+{
+	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
+	struct esp *esp = host_to_esp(host);
+	struct esp_target_data *tp = &esp->target[target->id];
+
+	tp->nego_goal_period = period;
+	tp->flags |= ESP_TGT_CHECK_NEGO;
+}
+
+static void esp_set_width(struct scsi_target *target, int width)
+{
+	struct Scsi_Host *host = dev_to_shost(target->dev.parent);
+	struct esp *esp = host_to_esp(host);
+	struct esp_target_data *tp = &esp->target[target->id];
+
+	tp->nego_goal_width = (width ? 1 : 0);
+	tp->flags |= ESP_TGT_CHECK_NEGO;
+}
+
+static struct spi_function_template esp_transport_ops = {
+	.set_offset		= esp_set_offset,
+	.show_offset		= 1,
+	.set_period		= esp_set_period,
+	.show_period		= 1,
+	.set_width		= esp_set_width,
+	.show_width		= 1,
+	.get_signalling		= esp_get_signalling,
 };
-#endif
 
 static int __init esp_init(void)
 {
-#ifdef CONFIG_SUN4
-	return esp_sun4_probe(&esp_template);
-#else
-	return of_register_driver(&esp_sbus_driver, &sbus_bus_type);
-#endif
+	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
+		     sizeof(struct esp_cmd_priv));
+
+	esp_transport_template = spi_attach_transport(&esp_transport_ops);
+	if (!esp_transport_template)
+		return -ENODEV;
+
+	return 0;
 }
 
 static void __exit esp_exit(void)
 {
-#ifdef CONFIG_SUN4
-	esp_sun4_remove();
-#else
-	of_unregister_driver(&esp_sbus_driver);
-#endif
+	spi_release_transport(esp_transport_template);
 }
 
-MODULE_DESCRIPTION("ESP Sun SCSI driver");
+MODULE_DESCRIPTION("ESP SCSI driver core");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
+module_param(esp_bus_reset_settle, int, 0);
+MODULE_PARM_DESC(esp_bus_reset_settle,
+		 "ESP scsi bus reset delay in seconds");
+
+module_param(esp_debug, int, 0);
+MODULE_PARM_DESC(esp_debug,
+"ESP bitmapped debugging message enable value:\n"
+"	0x00000001	Log interrupt events\n"
+"	0x00000002	Log scsi commands\n"
+"	0x00000004	Log resets\n"
+"	0x00000008	Log message in events\n"
+"	0x00000010	Log message out events\n"
+"	0x00000020	Log command completion\n"
+"	0x00000040	Log disconnects\n"
+"	0x00000080	Log data start\n"
+"	0x00000100	Log data done\n"
+"	0x00000200	Log reconnects\n"
+"	0x00000400	Log auto-sense data\n"
+);
+
 module_init(esp_init);
 module_exit(esp_exit);
diff --git a/drivers/scsi/esp.h b/drivers/scsi/esp.h
index a98cda9..c00dec6 100644
--- a/drivers/scsi/esp.h
+++ b/drivers/scsi/esp.h
@@ -1,246 +1,80 @@
-/* $Id: esp.h,v 1.29 2001/12/11 04:55:47 davem Exp $
- * esp.h:  Defines and structures for the Sparc ESP (Enhanced SCSI
- *         Processor) driver under Linux.
+/* esp.h: Defines and structures for the ESP drier.
  *
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
+ * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
  */
 
 #ifndef _SPARC_ESP_H
 #define _SPARC_ESP_H
 
-/* For dvma controller register definitions. */
-#include <asm/dma.h>
-
-/* The ESP SCSI controllers have their register sets in three
- * "classes":
- *
- * 1) Registers which are both read and write.
- * 2) Registers which are read only.
- * 3) Registers which are write only.
- *
- * Yet, they all live within the same IO space.
- */
-
-/* All the ESP registers are one byte each and are accessed longwords
- * apart with a big-endian ordering to the bytes.
- */
-					/* Access    Description              Offset */
-#define ESP_TCLOW	0x00UL		/* rw  Low bits of the transfer count 0x00   */
-#define ESP_TCMED	0x04UL		/* rw  Mid bits of the transfer count 0x04   */
-#define ESP_FDATA	0x08UL		/* rw  FIFO data bits                 0x08   */
-#define ESP_CMD		0x0cUL		/* rw  SCSI command bits              0x0c   */
-#define ESP_STATUS	0x10UL		/* ro  ESP status register            0x10   */
-#define ESP_BUSID	ESP_STATUS	/* wo  Bus ID for select/reselect     0x10   */
-#define ESP_INTRPT	0x14UL		/* ro  Kind of interrupt              0x14   */
-#define ESP_TIMEO	ESP_INTRPT	/* wo  Timeout value for select/resel 0x14   */
-#define ESP_SSTEP	0x18UL		/* ro  Sequence step register         0x18   */
-#define ESP_STP		ESP_SSTEP	/* wo  Transfer period per sync       0x18   */
-#define ESP_FFLAGS	0x1cUL		/* ro  Bits of current FIFO info      0x1c   */
-#define ESP_SOFF	ESP_FFLAGS	/* wo  Sync offset                    0x1c   */
-#define ESP_CFG1	0x20UL		/* rw  First configuration register   0x20   */
-#define ESP_CFACT	0x24UL		/* wo  Clock conversion factor        0x24   */
-#define ESP_STATUS2	ESP_CFACT	/* ro  HME status2 register           0x24   */
-#define ESP_CTEST	0x28UL		/* wo  Chip test register             0x28   */
-#define ESP_CFG2	0x2cUL		/* rw  Second configuration register  0x2c   */
-#define ESP_CFG3	0x30UL		/* rw  Third configuration register   0x30   */
-#define ESP_TCHI	0x38UL		/* rw  High bits of transfer count    0x38   */
-#define ESP_UID		ESP_TCHI	/* ro  Unique ID code                 0x38   */
-#define FAS_RLO		ESP_TCHI	/* rw  HME extended counter           0x38   */
-#define ESP_FGRND	0x3cUL		/* rw  Data base for fifo             0x3c   */
-#define FAS_RHI		ESP_FGRND	/* rw  HME extended counter           0x3c   */
-#define ESP_REG_SIZE	0x40UL
-
-/* Various revisions of the ESP board. */
-enum esp_rev {
-	esp100     = 0x00,  /* NCR53C90 - very broken */
-	esp100a    = 0x01,  /* NCR53C90A */
-	esp236     = 0x02,
-	fas236     = 0x03,
-	fas100a    = 0x04,
-	fast       = 0x05,
-	fashme     = 0x06,
-	espunknown = 0x07
-};
-
-/* We allocate one of these for each scsi device and attach it to
- * SDptr->hostdata for use in the driver
- */
-struct esp_device {
-  unsigned char sync_min_period;
-  unsigned char sync_max_offset;
-  unsigned sync:1;
-  unsigned wide:1;
-  unsigned disconnect:1;
-};
-
-struct scsi_cmnd;
-
-/* We get one of these for each ESP probed. */
-struct esp {
-	void __iomem		*eregs;		/* ESP controller registers */
-	void __iomem		*dregs;		/* DMA controller registers */
-	struct sbus_dma		*dma;		/* DMA controller sw state */
-	struct Scsi_Host	*ehost;		/* Backpointer to SCSI Host */
-	struct sbus_dev		*sdev;		/* Pointer to SBus entry */
-
-	/* ESP Configuration Registers */
-	u8			config1;	/* Copy of the 1st config register */
-	u8			config2;	/* Copy of the 2nd config register */
-	u8			config3[16];	/* Copy of the 3rd config register */
-
-	/* The current command we are sending to the ESP chip.  This esp_command
-	 * ptr needs to be mapped in DVMA area so we can send commands and read
-	 * from the ESP fifo without burning precious CPU cycles.  Programmed I/O
-	 * sucks when we have the DVMA to do it for us.  The ESP is stupid and will
-	 * only send out 6, 10, and 12 byte SCSI commands, others we need to send
-	 * one byte at a time.  esp_slowcmd being set says that we are doing one
-	 * of the command types ESP doesn't understand, esp_scmdp keeps track of
-	 * which byte we are sending, esp_scmdleft says how many bytes to go.
-	 */
-	volatile u8		*esp_command;    /* Location of command (CPU view)  */
-	__u32			esp_command_dvma;/* Location of command (DVMA view) */
-	unsigned char		esp_clen;	 /* Length of this command */
-	unsigned char		esp_slowcmd;
-	unsigned char		*esp_scmdp;
-	unsigned char		esp_scmdleft;
-
-	/* The following are used to determine the cause of an IRQ. Upon every
-	 * IRQ entry we synchronize these with the hardware registers.
-	 */
-	u8			ireg;		/* Copy of ESP interrupt register */
-	u8			sreg;		/* Copy of ESP status register */
-	u8			seqreg;		/* Copy of ESP sequence step register */
-	u8			sreg2;		/* Copy of HME status2 register */
-
-	/* To save register writes to the ESP, which can be expensive, we
-	 * keep track of the previous value that various registers had for
-	 * the last target we connected to.  If they are the same for the
-	 * current target, we skip the register writes as they are not needed.
-	 */
-	u8			prev_soff, prev_stp;
-	u8			prev_cfg3, __cache_pad;
-
-	/* We also keep a cache of the previous FAS/HME DMA CSR register value.  */
-	u32			prev_hme_dmacsr;
-
-	/* The HME is the biggest piece of shit I have ever seen. */
-	u8			hme_fifo_workaround_buffer[16 * 2];
-	u8			hme_fifo_workaround_count;
-
-	/* For each target we keep track of save/restore data
-	 * pointer information.  This needs to be updated majorly
-	 * when we add support for tagged queueing.  -DaveM
-	 */
-	struct esp_pointers {
-		char			*saved_ptr;
-		struct scatterlist	*saved_buffer;
-		int			saved_this_residual;
-		int			saved_buffers_residual;
-	} data_pointers[16] /*XXX [MAX_TAGS_PER_TARGET]*/;
-
-	/* Clock periods, frequencies, synchronization, etc. */
-	unsigned int		cfreq;		/* Clock frequency in HZ */
-	unsigned int		cfact;		/* Clock conversion factor */
-	unsigned int		raw_cfact;	/* Raw copy from probing */
-	unsigned int		ccycle;		/* One ESP clock cycle */
-	unsigned int		ctick;		/* One ESP clock time */
-	unsigned int		radelay;	/* FAST chip req/ack delay */
-	unsigned int		neg_defp;	/* Default negotiation period */
-	unsigned int		sync_defp;	/* Default sync transfer period */
-	unsigned int		max_period;	/* longest our period can be */
-	unsigned int		min_period;	/* shortest period we can withstand */
-
-	struct esp		*next;		/* Next ESP we probed or NULL */
-	char			prom_name[64];	/* Name of ESP device from prom */
-	int			prom_node;	/* Prom node where ESP found */
-	int			esp_id;		/* Unique per-ESP ID number */
-
-	/* For slow to medium speed input clock rates we shoot for 5mb/s,
-	 * but for high input clock rates we try to do 10mb/s although I
-	 * don't think a transfer can even run that fast with an ESP even
-	 * with DMA2 scatter gather pipelining.
-	 */
-#define SYNC_DEFP_SLOW            0x32   /* 5mb/s  */
-#define SYNC_DEFP_FAST            0x19   /* 10mb/s */
-
-	unsigned int		snip;		/* Sync. negotiation in progress */
-	unsigned int		wnip;		/* WIDE negotiation in progress */
-	unsigned int		targets_present;/* targets spoken to before */
-
-	int		current_transfer_size;	/* Set at beginning of data dma */
-
-	u8			espcmdlog[32];	/* Log of current esp cmds sent. */
-	u8			espcmdent;	/* Current entry in esp cmd log. */
-
-	/* Misc. info about this ESP */
-	enum esp_rev		erev;		/* ESP revision */
-	int			irq;		/* SBus IRQ for this ESP */
-	int			scsi_id;	/* Who am I as initiator? */
-	int			scsi_id_mask;	/* Bitmask of 'me'. */
-	int			diff;		/* Differential SCSI bus? */
-	int			bursts;		/* Burst sizes our DVMA supports */
-
-	/* Our command queues, only one cmd lives in the current_SC queue. */
-	struct scsi_cmnd	*issue_SC;	/* Commands to be issued */
-	struct scsi_cmnd	*current_SC;	/* Who is currently working the bus */
-	struct scsi_cmnd	*disconnected_SC;/* Commands disconnected from the bus */
-
-	/* Message goo */
-	u8			cur_msgout[16];
-	u8			cur_msgin[16];
-	u8			prevmsgout, prevmsgin;
-	u8			msgout_len, msgin_len;
-	u8			msgout_ctr, msgin_ctr;
-
-	/* States that we cannot keep in the per cmd structure because they
-	 * cannot be assosciated with any specific command.
-	 */
-	u8			resetting_bus;
-	wait_queue_head_t	reset_queue;
-};
+					/* Access    Description      Offset */
+#define ESP_TCLOW	0x00UL		/* rw  Low bits transfer count 0x00  */
+#define ESP_TCMED	0x01UL		/* rw  Mid bits transfer count 0x04  */
+#define ESP_FDATA	0x02UL		/* rw  FIFO data bits          0x08  */
+#define ESP_CMD		0x03UL		/* rw  SCSI command bits       0x0c  */
+#define ESP_STATUS	0x04UL		/* ro  ESP status register     0x10  */
+#define ESP_BUSID	ESP_STATUS	/* wo  BusID for sel/resel     0x10  */
+#define ESP_INTRPT	0x05UL		/* ro  Kind of interrupt       0x14  */
+#define ESP_TIMEO	ESP_INTRPT	/* wo  Timeout for sel/resel   0x14  */
+#define ESP_SSTEP	0x06UL		/* ro  Sequence step register  0x18  */
+#define ESP_STP		ESP_SSTEP	/* wo  Transfer period/sync    0x18  */
+#define ESP_FFLAGS	0x07UL		/* ro  Bits current FIFO info  0x1c  */
+#define ESP_SOFF	ESP_FFLAGS	/* wo  Sync offset             0x1c  */
+#define ESP_CFG1	0x08UL		/* rw  First cfg register      0x20  */
+#define ESP_CFACT	0x09UL		/* wo  Clock conv factor       0x24  */
+#define ESP_STATUS2	ESP_CFACT	/* ro  HME status2 register    0x24  */
+#define ESP_CTEST	0x0aUL		/* wo  Chip test register      0x28  */
+#define ESP_CFG2	0x0bUL		/* rw  Second cfg register     0x2c  */
+#define ESP_CFG3	0x0cUL		/* rw  Third cfg register      0x30  */
+#define ESP_TCHI	0x0eUL		/* rw  High bits transf count  0x38  */
+#define ESP_UID		ESP_TCHI	/* ro  Unique ID code          0x38  */
+#define FAS_RLO		ESP_TCHI	/* rw  HME extended counter    0x38  */
+#define ESP_FGRND	0x0fUL		/* rw  Data base for fifo      0x3c  */
+#define FAS_RHI		ESP_FGRND	/* rw  HME extended counter    0x3c  */
+
+#define SBUS_ESP_REG_SIZE	0x40UL
 
 /* Bitfield meanings for the above registers. */
 
 /* ESP config reg 1, read-write, found on all ESP chips */
-#define ESP_CONFIG1_ID        0x07             /* My BUS ID bits */
-#define ESP_CONFIG1_CHTEST    0x08             /* Enable ESP chip tests */
-#define ESP_CONFIG1_PENABLE   0x10             /* Enable parity checks */
-#define ESP_CONFIG1_PARTEST   0x20             /* Parity test mode enabled? */
-#define ESP_CONFIG1_SRRDISAB  0x40             /* Disable SCSI reset reports */
-#define ESP_CONFIG1_SLCABLE   0x80             /* Enable slow cable mode */
+#define ESP_CONFIG1_ID        0x07      /* My BUS ID bits */
+#define ESP_CONFIG1_CHTEST    0x08      /* Enable ESP chip tests */
+#define ESP_CONFIG1_PENABLE   0x10      /* Enable parity checks */
+#define ESP_CONFIG1_PARTEST   0x20      /* Parity test mode enabled? */
+#define ESP_CONFIG1_SRRDISAB  0x40      /* Disable SCSI reset reports */
+#define ESP_CONFIG1_SLCABLE   0x80      /* Enable slow cable mode */
 
 /* ESP config reg 2, read-write, found only on esp100a+esp200+esp236 chips */
-#define ESP_CONFIG2_DMAPARITY 0x01             /* enable DMA Parity (200,236) */
-#define ESP_CONFIG2_REGPARITY 0x02             /* enable reg Parity (200,236) */
-#define ESP_CONFIG2_BADPARITY 0x04             /* Bad parity target abort  */
-#define ESP_CONFIG2_SCSI2ENAB 0x08             /* Enable SCSI-2 features (tmode only) */
-#define ESP_CONFIG2_HI        0x10             /* High Impedance DREQ ???  */
-#define ESP_CONFIG2_HMEFENAB  0x10             /* HME features enable */
-#define ESP_CONFIG2_BCM       0x20             /* Enable byte-ctrl (236)   */
-#define ESP_CONFIG2_DISPINT   0x20             /* Disable pause irq (hme) */
-#define ESP_CONFIG2_FENAB     0x40             /* Enable features (fas100,esp216)      */
-#define ESP_CONFIG2_SPL       0x40             /* Enable status-phase latch (esp236)   */
-#define ESP_CONFIG2_MKDONE    0x40             /* HME magic feature */
-#define ESP_CONFIG2_HME32     0x80             /* HME 32 extended */
-#define ESP_CONFIG2_MAGIC     0xe0             /* Invalid bits... */
+#define ESP_CONFIG2_DMAPARITY 0x01      /* enable DMA Parity (200,236) */
+#define ESP_CONFIG2_REGPARITY 0x02      /* enable reg Parity (200,236) */
+#define ESP_CONFIG2_BADPARITY 0x04      /* Bad parity target abort  */
+#define ESP_CONFIG2_SCSI2ENAB 0x08      /* Enable SCSI-2 features (tgtmode) */
+#define ESP_CONFIG2_HI        0x10      /* High Impedance DREQ ???  */
+#define ESP_CONFIG2_HMEFENAB  0x10      /* HME features enable */
+#define ESP_CONFIG2_BCM       0x20      /* Enable byte-ctrl (236)   */
+#define ESP_CONFIG2_DISPINT   0x20      /* Disable pause irq (hme) */
+#define ESP_CONFIG2_FENAB     0x40      /* Enable features (fas100,216) */
+#define ESP_CONFIG2_SPL       0x40      /* Enable status-phase latch (236) */
+#define ESP_CONFIG2_MKDONE    0x40      /* HME magic feature */
+#define ESP_CONFIG2_HME32     0x80      /* HME 32 extended */
+#define ESP_CONFIG2_MAGIC     0xe0      /* Invalid bits... */
 
 /* ESP config register 3 read-write, found only esp236+fas236+fas100a+hme chips */
-#define ESP_CONFIG3_FCLOCK    0x01             /* FAST SCSI clock rate (esp100a/hme) */
-#define ESP_CONFIG3_TEM       0x01             /* Enable thresh-8 mode (esp/fas236)  */
-#define ESP_CONFIG3_FAST      0x02             /* Enable FAST SCSI     (esp100a/hme) */
-#define ESP_CONFIG3_ADMA      0x02             /* Enable alternate-dma (esp/fas236)  */
-#define ESP_CONFIG3_TENB      0x04             /* group2 SCSI2 support (esp100a/hme) */
-#define ESP_CONFIG3_SRB       0x04             /* Save residual byte   (esp/fas236)  */
-#define ESP_CONFIG3_TMS       0x08             /* Three-byte msg's ok  (esp100a/hme) */
-#define ESP_CONFIG3_FCLK      0x08             /* Fast SCSI clock rate (esp/fas236)  */
-#define ESP_CONFIG3_IDMSG     0x10             /* ID message checking  (esp100a/hme) */
-#define ESP_CONFIG3_FSCSI     0x10             /* Enable FAST SCSI     (esp/fas236)  */
-#define ESP_CONFIG3_GTM       0x20             /* group2 SCSI2 support (esp/fas236)  */
-#define ESP_CONFIG3_IDBIT3    0x20             /* Bit 3 of HME SCSI-ID (hme)         */
-#define ESP_CONFIG3_TBMS      0x40             /* Three-byte msg's ok  (esp/fas236)  */
-#define ESP_CONFIG3_EWIDE     0x40             /* Enable Wide-SCSI     (hme)         */
-#define ESP_CONFIG3_IMS       0x80             /* ID msg chk'ng        (esp/fas236)  */
-#define ESP_CONFIG3_OBPUSH    0x80             /* Push odd-byte to dma (hme)         */
+#define ESP_CONFIG3_FCLOCK    0x01     /* FAST SCSI clock rate (esp100a/hme) */
+#define ESP_CONFIG3_TEM       0x01     /* Enable thresh-8 mode (esp/fas236)  */
+#define ESP_CONFIG3_FAST      0x02     /* Enable FAST SCSI     (esp100a/hme) */
+#define ESP_CONFIG3_ADMA      0x02     /* Enable alternate-dma (esp/fas236)  */
+#define ESP_CONFIG3_TENB      0x04     /* group2 SCSI2 support (esp100a/hme) */
+#define ESP_CONFIG3_SRB       0x04     /* Save residual byte   (esp/fas236)  */
+#define ESP_CONFIG3_TMS       0x08     /* Three-byte msg's ok  (esp100a/hme) */
+#define ESP_CONFIG3_FCLK      0x08     /* Fast SCSI clock rate (esp/fas236)  */
+#define ESP_CONFIG3_IDMSG     0x10     /* ID message checking  (esp100a/hme) */
+#define ESP_CONFIG3_FSCSI     0x10     /* Enable FAST SCSI     (esp/fas236)  */
+#define ESP_CONFIG3_GTM       0x20     /* group2 SCSI2 support (esp/fas236)  */
+#define ESP_CONFIG3_IDBIT3    0x20     /* Bit 3 of HME SCSI-ID (hme)         */
+#define ESP_CONFIG3_TBMS      0x40     /* Three-byte msg's ok  (esp/fas236)  */
+#define ESP_CONFIG3_EWIDE     0x40     /* Enable Wide-SCSI     (hme)         */
+#define ESP_CONFIG3_IMS       0x80     /* ID msg chk'ng        (esp/fas236)  */
+#define ESP_CONFIG3_OBPUSH    0x80     /* Push odd-byte to dma (hme)         */
 
 /* ESP command register read-write */
 /* Group 1 commands:  These may be sent at any point in time to the ESP
@@ -248,77 +82,66 @@ struct esp {
  *                    the "SCSI bus reset" command if you have not disabled
  *                    SCSI reset interrupts in the config1 ESP register.
  */
-#define ESP_CMD_NULL          0x00             /* Null command, ie. a nop */
-#define ESP_CMD_FLUSH         0x01             /* FIFO Flush */
-#define ESP_CMD_RC            0x02             /* Chip reset */
-#define ESP_CMD_RS            0x03             /* SCSI bus reset */
+#define ESP_CMD_NULL          0x00     /* Null command, ie. a nop */
+#define ESP_CMD_FLUSH         0x01     /* FIFO Flush */
+#define ESP_CMD_RC            0x02     /* Chip reset */
+#define ESP_CMD_RS            0x03     /* SCSI bus reset */
 
 /* Group 2 commands:  ESP must be an initiator and connected to a target
  *                    for these commands to work.
  */
-#define ESP_CMD_TI            0x10             /* Transfer Information */
-#define ESP_CMD_ICCSEQ        0x11             /* Initiator cmd complete sequence */
-#define ESP_CMD_MOK           0x12             /* Message okie-dokie */
-#define ESP_CMD_TPAD          0x18             /* Transfer Pad */
-#define ESP_CMD_SATN          0x1a             /* Set ATN */
-#define ESP_CMD_RATN          0x1b             /* De-assert ATN */
+#define ESP_CMD_TI            0x10     /* Transfer Information */
+#define ESP_CMD_ICCSEQ        0x11     /* Initiator cmd complete sequence */
+#define ESP_CMD_MOK           0x12     /* Message okie-dokie */
+#define ESP_CMD_TPAD          0x18     /* Transfer Pad */
+#define ESP_CMD_SATN          0x1a     /* Set ATN */
+#define ESP_CMD_RATN          0x1b     /* De-assert ATN */
 
 /* Group 3 commands:  ESP must be in the MSGOUT or MSGIN state and be connected
  *                    to a target as the initiator for these commands to work.
  */
-#define ESP_CMD_SMSG          0x20             /* Send message */
-#define ESP_CMD_SSTAT         0x21             /* Send status */
-#define ESP_CMD_SDATA         0x22             /* Send data */
-#define ESP_CMD_DSEQ          0x23             /* Discontinue Sequence */
-#define ESP_CMD_TSEQ          0x24             /* Terminate Sequence */
-#define ESP_CMD_TCCSEQ        0x25             /* Target cmd cmplt sequence */
-#define ESP_CMD_DCNCT         0x27             /* Disconnect */
-#define ESP_CMD_RMSG          0x28             /* Receive Message */
-#define ESP_CMD_RCMD          0x29             /* Receive Command */
-#define ESP_CMD_RDATA         0x2a             /* Receive Data */
-#define ESP_CMD_RCSEQ         0x2b             /* Receive cmd sequence */
+#define ESP_CMD_SMSG          0x20     /* Send message */
+#define ESP_CMD_SSTAT         0x21     /* Send status */
+#define ESP_CMD_SDATA         0x22     /* Send data */
+#define ESP_CMD_DSEQ          0x23     /* Discontinue Sequence */
+#define ESP_CMD_TSEQ          0x24     /* Terminate Sequence */
+#define ESP_CMD_TCCSEQ        0x25     /* Target cmd cmplt sequence */
+#define ESP_CMD_DCNCT         0x27     /* Disconnect */
+#define ESP_CMD_RMSG          0x28     /* Receive Message */
+#define ESP_CMD_RCMD          0x29     /* Receive Command */
+#define ESP_CMD_RDATA         0x2a     /* Receive Data */
+#define ESP_CMD_RCSEQ         0x2b     /* Receive cmd sequence */
 
 /* Group 4 commands:  The ESP must be in the disconnected state and must
  *                    not be connected to any targets as initiator for
  *                    these commands to work.
  */
-#define ESP_CMD_RSEL          0x40             /* Reselect */
-#define ESP_CMD_SEL           0x41             /* Select w/o ATN */
-#define ESP_CMD_SELA          0x42             /* Select w/ATN */
-#define ESP_CMD_SELAS         0x43             /* Select w/ATN & STOP */
-#define ESP_CMD_ESEL          0x44             /* Enable selection */
-#define ESP_CMD_DSEL          0x45             /* Disable selections */
-#define ESP_CMD_SA3           0x46             /* Select w/ATN3 */
-#define ESP_CMD_RSEL3         0x47             /* Reselect3 */
+#define ESP_CMD_RSEL          0x40     /* Reselect */
+#define ESP_CMD_SEL           0x41     /* Select w/o ATN */
+#define ESP_CMD_SELA          0x42     /* Select w/ATN */
+#define ESP_CMD_SELAS         0x43     /* Select w/ATN & STOP */
+#define ESP_CMD_ESEL          0x44     /* Enable selection */
+#define ESP_CMD_DSEL          0x45     /* Disable selections */
+#define ESP_CMD_SA3           0x46     /* Select w/ATN3 */
+#define ESP_CMD_RSEL3         0x47     /* Reselect3 */
 
 /* This bit enables the ESP's DMA on the SBus */
-#define ESP_CMD_DMA           0x80             /* Do DMA? */
-
+#define ESP_CMD_DMA           0x80     /* Do DMA? */
 
 /* ESP status register read-only */
-#define ESP_STAT_PIO          0x01             /* IO phase bit */
-#define ESP_STAT_PCD          0x02             /* CD phase bit */
-#define ESP_STAT_PMSG         0x04             /* MSG phase bit */
-#define ESP_STAT_PMASK        0x07             /* Mask of phase bits */
-#define ESP_STAT_TDONE        0x08             /* Transfer Completed */
-#define ESP_STAT_TCNT         0x10             /* Transfer Counter Is Zero */
-#define ESP_STAT_PERR         0x20             /* Parity error */
-#define ESP_STAT_SPAM         0x40             /* Real bad error */
+#define ESP_STAT_PIO          0x01     /* IO phase bit */
+#define ESP_STAT_PCD          0x02     /* CD phase bit */
+#define ESP_STAT_PMSG         0x04     /* MSG phase bit */
+#define ESP_STAT_PMASK        0x07     /* Mask of phase bits */
+#define ESP_STAT_TDONE        0x08     /* Transfer Completed */
+#define ESP_STAT_TCNT         0x10     /* Transfer Counter Is Zero */
+#define ESP_STAT_PERR         0x20     /* Parity error */
+#define ESP_STAT_SPAM         0x40     /* Real bad error */
 /* This indicates the 'interrupt pending' condition on esp236, it is a reserved
  * bit on other revs of the ESP.
  */
 #define ESP_STAT_INTR         0x80             /* Interrupt */
 
-/* HME only: status 2 register */
-#define ESP_STAT2_SCHBIT      0x01 /* Upper bits 3-7 of sstep enabled */
-#define ESP_STAT2_FFLAGS      0x02 /* The fifo flags are now latched */
-#define ESP_STAT2_XCNT        0x04 /* The transfer counter is latched */
-#define ESP_STAT2_CREGA       0x08 /* The command reg is active now */
-#define ESP_STAT2_WIDE        0x10 /* Interface on this adapter is wide */
-#define ESP_STAT2_F1BYTE      0x20 /* There is one byte at top of fifo */
-#define ESP_STAT2_FMSB        0x40 /* Next byte in fifo is most significant */
-#define ESP_STAT2_FEMPTY      0x80 /* FIFO is empty */
-
 /* The status register can be masked with ESP_STAT_PMASK and compared
  * with the following values to determine the current phase the ESP
  * (at least thinks it) is in.  For our purposes we also add our own
@@ -331,34 +154,35 @@ struct esp {
 #define ESP_MOP   (ESP_STAT_PMSG|ESP_STAT_PCD)              /* Message Out */
 #define ESP_MIP   (ESP_STAT_PMSG|ESP_STAT_PCD|ESP_STAT_PIO) /* Message In */
 
+/* HME only: status 2 register */
+#define ESP_STAT2_SCHBIT      0x01 /* Upper bits 3-7 of sstep enabled */
+#define ESP_STAT2_FFLAGS      0x02 /* The fifo flags are now latched */
+#define ESP_STAT2_XCNT        0x04 /* The transfer counter is latched */
+#define ESP_STAT2_CREGA       0x08 /* The command reg is active now */
+#define ESP_STAT2_WIDE        0x10 /* Interface on this adapter is wide */
+#define ESP_STAT2_F1BYTE      0x20 /* There is one byte at top of fifo */
+#define ESP_STAT2_FMSB        0x40 /* Next byte in fifo is most significant */
+#define ESP_STAT2_FEMPTY      0x80 /* FIFO is empty */
+
 /* ESP interrupt register read-only */
-#define ESP_INTR_S            0x01             /* Select w/o ATN */
-#define ESP_INTR_SATN         0x02             /* Select w/ATN */
-#define ESP_INTR_RSEL         0x04             /* Reselected */
-#define ESP_INTR_FDONE        0x08             /* Function done */
-#define ESP_INTR_BSERV        0x10             /* Bus service */
-#define ESP_INTR_DC           0x20             /* Disconnect */
-#define ESP_INTR_IC           0x40             /* Illegal command given */
-#define ESP_INTR_SR           0x80             /* SCSI bus reset detected */
-
-/* Interrupt status macros */
-#define ESP_SRESET_IRQ(esp)  ((esp)->intreg & (ESP_INTR_SR))
-#define ESP_ILLCMD_IRQ(esp)  ((esp)->intreg & (ESP_INTR_IC))
-#define ESP_SELECT_WITH_ATN_IRQ(esp)     ((esp)->intreg & (ESP_INTR_SATN))
-#define ESP_SELECT_WITHOUT_ATN_IRQ(esp)  ((esp)->intreg & (ESP_INTR_S))
-#define ESP_SELECTION_IRQ(esp)  ((ESP_SELECT_WITH_ATN_IRQ(esp)) ||         \
-				 (ESP_SELECT_WITHOUT_ATN_IRQ(esp)))
-#define ESP_RESELECTION_IRQ(esp)         ((esp)->intreg & (ESP_INTR_RSEL))
+#define ESP_INTR_S            0x01     /* Select w/o ATN */
+#define ESP_INTR_SATN         0x02     /* Select w/ATN */
+#define ESP_INTR_RSEL         0x04     /* Reselected */
+#define ESP_INTR_FDONE        0x08     /* Function done */
+#define ESP_INTR_BSERV        0x10     /* Bus service */
+#define ESP_INTR_DC           0x20     /* Disconnect */
+#define ESP_INTR_IC           0x40     /* Illegal command given */
+#define ESP_INTR_SR           0x80     /* SCSI bus reset detected */
 
 /* ESP sequence step register read-only */
-#define ESP_STEP_VBITS        0x07             /* Valid bits */
-#define ESP_STEP_ASEL         0x00             /* Selection&Arbitrate cmplt */
-#define ESP_STEP_SID          0x01             /* One msg byte sent */
-#define ESP_STEP_NCMD         0x02             /* Was not in command phase */
-#define ESP_STEP_PPC          0x03             /* Early phase chg caused cmnd
-                                                * bytes to be lost
-                                                */
-#define ESP_STEP_FINI4        0x04             /* Command was sent ok */
+#define ESP_STEP_VBITS        0x07     /* Valid bits */
+#define ESP_STEP_ASEL         0x00     /* Selection&Arbitrate cmplt */
+#define ESP_STEP_SID          0x01     /* One msg byte sent */
+#define ESP_STEP_NCMD         0x02     /* Was not in command phase */
+#define ESP_STEP_PPC          0x03     /* Early phase chg caused cmnd
+                                        * bytes to be lost
+                                        */
+#define ESP_STEP_FINI4        0x04     /* Command was sent ok */
 
 /* Ho hum, some ESP's set the step register to this as well... */
 #define ESP_STEP_FINI5        0x05
@@ -366,41 +190,378 @@ struct esp {
 #define ESP_STEP_FINI7        0x07
 
 /* ESP chip-test register read-write */
-#define ESP_TEST_TARG         0x01             /* Target test mode */
-#define ESP_TEST_INI          0x02             /* Initiator test mode */
-#define ESP_TEST_TS           0x04             /* Tristate test mode */
+#define ESP_TEST_TARG         0x01     /* Target test mode */
+#define ESP_TEST_INI          0x02     /* Initiator test mode */
+#define ESP_TEST_TS           0x04     /* Tristate test mode */
 
 /* ESP unique ID register read-only, found on fas236+fas100a only */
-#define ESP_UID_F100A         0x00             /* ESP FAS100A  */
-#define ESP_UID_F236          0x02             /* ESP FAS236   */
-#define ESP_UID_REV           0x07             /* ESP revision */
-#define ESP_UID_FAM           0xf8             /* ESP family   */
+#define ESP_UID_F100A         0x00     /* ESP FAS100A  */
+#define ESP_UID_F236          0x02     /* ESP FAS236   */
+#define ESP_UID_REV           0x07     /* ESP revision */
+#define ESP_UID_FAM           0xf8     /* ESP family   */
 
 /* ESP fifo flags register read-only */
 /* Note that the following implies a 16 byte FIFO on the ESP. */
-#define ESP_FF_FBYTES         0x1f             /* Num bytes in FIFO */
-#define ESP_FF_ONOTZERO       0x20             /* offset ctr not zero (esp100) */
-#define ESP_FF_SSTEP          0xe0             /* Sequence step */
+#define ESP_FF_FBYTES         0x1f     /* Num bytes in FIFO */
+#define ESP_FF_ONOTZERO       0x20     /* offset ctr not zero (esp100) */
+#define ESP_FF_SSTEP          0xe0     /* Sequence step */
 
 /* ESP clock conversion factor register write-only */
-#define ESP_CCF_F0            0x00             /* 35.01MHz - 40MHz */
-#define ESP_CCF_NEVER         0x01             /* Set it to this and die */
-#define ESP_CCF_F2            0x02             /* 10MHz */
-#define ESP_CCF_F3            0x03             /* 10.01MHz - 15MHz */
-#define ESP_CCF_F4            0x04             /* 15.01MHz - 20MHz */
-#define ESP_CCF_F5            0x05             /* 20.01MHz - 25MHz */
-#define ESP_CCF_F6            0x06             /* 25.01MHz - 30MHz */
-#define ESP_CCF_F7            0x07             /* 30.01MHz - 35MHz */
+#define ESP_CCF_F0            0x00     /* 35.01MHz - 40MHz */
+#define ESP_CCF_NEVER         0x01     /* Set it to this and die */
+#define ESP_CCF_F2            0x02     /* 10MHz */
+#define ESP_CCF_F3            0x03     /* 10.01MHz - 15MHz */
+#define ESP_CCF_F4            0x04     /* 15.01MHz - 20MHz */
+#define ESP_CCF_F5            0x05     /* 20.01MHz - 25MHz */
+#define ESP_CCF_F6            0x06     /* 25.01MHz - 30MHz */
+#define ESP_CCF_F7            0x07     /* 30.01MHz - 35MHz */
 
 /* HME only... */
 #define ESP_BUSID_RESELID     0x10
 #define ESP_BUSID_CTR32BIT    0x40
 
-#define ESP_BUS_TIMEOUT        275             /* In milli-seconds */
+#define ESP_BUS_TIMEOUT        250     /* In milli-seconds */
 #define ESP_TIMEO_CONST       8192
 #define ESP_NEG_DEFP(mhz, cfact) \
         ((ESP_BUS_TIMEOUT * ((mhz) / 1000)) / (8192 * (cfact)))
 #define ESP_MHZ_TO_CYCLE(mhertz)  ((1000000000) / ((mhertz) / 1000))
 #define ESP_TICK(ccf, cycle)  ((7682 * (ccf) * (cycle) / 1000))
 
+/* For slow to medium speed input clock rates we shoot for 5mb/s, but for high
+ * input clock rates we try to do 10mb/s although I don't think a transfer can
+ * even run that fast with an ESP even with DMA2 scatter gather pipelining.
+ */
+#define SYNC_DEFP_SLOW            0x32   /* 5mb/s  */
+#define SYNC_DEFP_FAST            0x19   /* 10mb/s */
+
+struct esp_cmd_priv {
+	union {
+		dma_addr_t	dma_addr;
+		int		num_sg;
+	} u;
+
+	int			mapping_type;
+#define MAPPING_TYPE_NONE	0
+#define MAPPING_TYPE_SINGLE	1
+#define MAPPING_TYPE_SG		2
+
+	unsigned int		cur_residue;
+	struct scatterlist	*cur_sg;
+	unsigned int		tot_residue;
+};
+#define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
+
+enum esp_rev {
+	ESP100     = 0x00,  /* NCR53C90 - very broken */
+	ESP100A    = 0x01,  /* NCR53C90A */
+	ESP236     = 0x02,
+	FAS236     = 0x03,
+	FAS100A    = 0x04,
+	FAST       = 0x05,
+	FASHME     = 0x06,
+};
+
+struct esp_cmd_entry {
+	struct list_head	list;
+
+	struct scsi_cmnd	*cmd;
+
+	unsigned int		saved_cur_residue;
+	struct scatterlist	*saved_cur_sg;
+	unsigned int		saved_tot_residue;
+
+	u8			flags;
+#define ESP_CMD_FLAG_WRITE	0x01 /* DMA is a write */
+#define ESP_CMD_FLAG_ABORT	0x02 /* being aborted */
+#define ESP_CMD_FLAG_AUTOSENSE	0x04 /* Doing automatic REQUEST_SENSE */
+
+	u8			tag[2];
+
+	u8			status;
+	u8			message;
+
+	unsigned char		*sense_ptr;
+	unsigned char		*saved_sense_ptr;
+	dma_addr_t		sense_dma;
+
+	struct completion	*eh_done;
+};
+
+/* XXX make this configurable somehow XXX */
+#define ESP_DEFAULT_TAGS	16
+
+#define ESP_MAX_TARGET		16
+#define ESP_MAX_LUN		8
+#define ESP_MAX_TAG		256
+
+struct esp_lun_data {
+	struct esp_cmd_entry	*non_tagged_cmd;
+	int			num_tagged;
+	int			hold;
+	struct esp_cmd_entry	*tagged_cmds[ESP_MAX_TAG];
+};
+
+struct esp_target_data {
+	/* These are the ESP_STP, ESP_SOFF, and ESP_CFG3 register values which
+	 * match the currently negotiated settings for this target.  The SCSI
+	 * protocol values are maintained in spi_{offset,period,wide}(starget).
+	 */
+	u8			esp_period;
+	u8			esp_offset;
+	u8			esp_config3;
+
+	u8			flags;
+#define ESP_TGT_WIDE		0x01
+#define ESP_TGT_DISCONNECT	0x02
+#define ESP_TGT_NEGO_WIDE	0x04
+#define ESP_TGT_NEGO_SYNC	0x08
+#define ESP_TGT_CHECK_NEGO	0x40
+#define ESP_TGT_BROKEN		0x80
+
+	/* When ESP_TGT_CHECK_NEGO is set, on the next scsi command to this
+	 * device we will try to negotiate the following parameters.
+	 */
+	u8			nego_goal_period;
+	u8			nego_goal_offset;
+	u8			nego_goal_width;
+	u8			nego_goal_tags;
+
+	struct scsi_target	*starget;
+
+	struct esp_lun_data	*lun[ESP_MAX_LUN];
+};
+
+struct esp_event_ent {
+	u8			type;
+#define ESP_EVENT_TYPE_EVENT	0x01
+#define ESP_EVENT_TYPE_CMD	0x02
+	u8			val;
+
+	u8			sreg;
+	u8			seqreg;
+	u8			sreg2;
+	u8			ireg;
+	u8			select_state;
+	u8			event;
+	u8			__pad;
+};
+
+struct esp;
+struct esp_driver_ops {
+	/* Read and write the ESP 8-bit registers.  On some
+	 * applications of the ESP chip the registers are at 4-byte
+	 * instead of 1-byte intervals.
+	 */
+	void (*esp_write8)(struct esp *esp, u8 val, unsigned long reg);
+	u8 (*esp_read8)(struct esp *esp, unsigned long reg);
+
+	/* Map and unmap DMA memory.  Eventually the driver will be
+	 * converted to the generic DMA API as soon as SBUS is able to
+	 * cope with that.  At such time we can remove this.
+	 */
+	dma_addr_t (*map_single)(struct esp *esp, void *buf,
+				 size_t sz, int dir);
+	int (*map_sg)(struct esp *esp, struct scatterlist *sg,
+		      int num_sg, int dir);
+	void (*unmap_single)(struct esp *esp, dma_addr_t addr,
+			     size_t sz, int dir);
+	void (*unmap_sg)(struct esp *esp, struct scatterlist *sg,
+			 int num_sg, int dir);
+
+	/* Return non-zero if there is an IRQ pending.  Usually this
+	 * status bit lives in the DMA controller sitting in front of
+	 * the ESP.  This has to be accurate or else the ESP interrupt
+	 * handler will not run.
+	 */
+	int (*irq_pending)(struct esp *esp);
+
+	/* Reset the DMA engine entirely.  On return, ESP interrupts
+	 * should be enabled.  Often the interrupt enabling is
+	 * controlled in the DMA engine.
+	 */
+	void (*reset_dma)(struct esp *esp);
+
+	/* Drain any pending DMA in the DMA engine after a transfer.
+	 * This is for writes to memory.
+	 */
+	void (*dma_drain)(struct esp *esp);
+
+	/* Invalidate the DMA engine after a DMA transfer.  */
+	void (*dma_invalidate)(struct esp *esp);
+
+	/* Setup an ESP command that will use a DMA transfer.
+	 * The 'esp_count' specifies what transfer length should be
+	 * programmed into the ESP transfer counter registers, whereas
+	 * the 'dma_count' is the length that should be programmed into
+	 * the DMA controller.  Usually they are the same.  If 'write'
+	 * is non-zero, this transfer is a write into memory.  'cmd'
+	 * holds the ESP command that should be issued by calling
+	 * scsi_esp_cmd() at the appropriate time while programming
+	 * the DMA hardware.
+	 */
+	void (*send_dma_cmd)(struct esp *esp, u32 dma_addr, u32 esp_count,
+			     u32 dma_count, int write, u8 cmd);
+
+	/* Return non-zero if the DMA engine is reporting an error
+	 * currently.
+	 */
+	int (*dma_error)(struct esp *esp);
+};
+
+#define ESP_MAX_MSG_SZ		8
+#define ESP_EVENT_LOG_SZ	32
+
+#define ESP_QUICKIRQ_LIMIT	100
+#define ESP_RESELECT_TAG_LIMIT	2500
+
+struct esp {
+	void __iomem		*regs;
+	void __iomem		*dma_regs;
+
+	const struct esp_driver_ops *ops;
+
+	struct Scsi_Host	*host;
+	void			*dev;
+
+	struct esp_cmd_entry	*active_cmd;
+
+	struct list_head	queued_cmds;
+	struct list_head	active_cmds;
+
+	u8			*command_block;
+	dma_addr_t		command_block_dma;
+
+	unsigned int		data_dma_len;
+
+	/* The following are used to determine the cause of an IRQ. Upon every
+	 * IRQ entry we synchronize these with the hardware registers.
+	 */
+	u8			sreg;
+	u8			seqreg;
+	u8			sreg2;
+	u8			ireg;
+
+	u32			prev_hme_dmacsr;
+	u8			prev_soff;
+	u8			prev_stp;
+	u8			prev_cfg3;
+	u8			__pad;
+
+	struct list_head	esp_cmd_pool;
+
+	struct esp_target_data	target[ESP_MAX_TARGET];
+
+	int			fifo_cnt;
+	u8			fifo[16];
+
+	struct esp_event_ent	esp_event_log[ESP_EVENT_LOG_SZ];
+	int			esp_event_cur;
+
+	u8			msg_out[ESP_MAX_MSG_SZ];
+	int			msg_out_len;
+
+	u8			msg_in[ESP_MAX_MSG_SZ];
+	int			msg_in_len;
+
+	u8			bursts;
+	u8			config1;
+	u8			config2;
+
+	u8			scsi_id;
+	u32			scsi_id_mask;
+
+	enum esp_rev		rev;
+
+	u32			flags;
+#define ESP_FLAG_DIFFERENTIAL	0x00000001
+#define ESP_FLAG_RESETTING	0x00000002
+#define ESP_FLAG_DOING_SLOWCMD	0x00000004
+#define ESP_FLAG_WIDE_CAPABLE	0x00000008
+#define ESP_FLAG_QUICKIRQ_CHECK	0x00000010
+
+	u8			select_state;
+#define ESP_SELECT_NONE		0x00 /* Not selecting */
+#define ESP_SELECT_BASIC	0x01 /* Select w/o MSGOUT phase */
+#define ESP_SELECT_MSGOUT	0x02 /* Select with MSGOUT */
+
+	/* When we are not selecting, we are expecting an event.  */
+	u8			event;
+#define ESP_EVENT_NONE		0x00
+#define ESP_EVENT_CMD_START	0x01
+#define ESP_EVENT_CMD_DONE	0x02
+#define ESP_EVENT_DATA_IN	0x03
+#define ESP_EVENT_DATA_OUT	0x04
+#define ESP_EVENT_DATA_DONE	0x05
+#define ESP_EVENT_MSGIN		0x06
+#define ESP_EVENT_MSGIN_MORE	0x07
+#define ESP_EVENT_MSGIN_DONE	0x08
+#define ESP_EVENT_MSGOUT	0x09
+#define ESP_EVENT_MSGOUT_DONE	0x0a
+#define ESP_EVENT_STATUS	0x0b
+#define ESP_EVENT_FREE_BUS	0x0c
+#define ESP_EVENT_CHECK_PHASE	0x0d
+#define ESP_EVENT_RESET		0x10
+
+	/* Probed in esp_get_clock_params() */
+	u32			cfact;
+	u32			cfreq;
+	u32			ccycle;
+	u32			ctick;
+	u32			neg_defp;
+	u32			sync_defp;
+
+	/* Computed in esp_reset_esp() */
+	u32			max_period;
+	u32			min_period;
+	u32			radelay;
+
+	/* Slow command state.  */
+	u8			*cmd_bytes_ptr;
+	int			cmd_bytes_left;
+
+	struct completion	*eh_reset;
+
+	struct sbus_dma		*dma;
+};
+
+#define host_to_esp(host)	((struct esp *)(host)->hostdata)
+
+/* A front-end driver for the ESP chip should do the following in
+ * it's device probe routine:
+ * 1) Allocate the host and private area using scsi_host_alloc()
+ *    with size 'sizeof(struct esp)'.  The first argument to
+ *    scsi_host_alloc() should be &scsi_esp_template.
+ * 2) Set host->max_id as appropriate.
+ * 3) Set esp->host to the scsi_host itself, and esp->dev
+ *    to the device object pointer.
+ * 4) Hook up esp->ops to the front-end implementation.
+ * 5) If the ESP chip supports wide transfers, set ESP_FLAG_WIDE_CAPABLE
+ *    in esp->flags.
+ * 6) Map the DMA and ESP chip registers.
+ * 7) DMA map the ESP command block, store the DMA address
+ *    in esp->command_block_dma.
+ * 8) Register the scsi_esp_intr() interrupt handler.
+ * 9) Probe for and provide the following chip properties:
+ *    esp->scsi_id (assign to esp->host->this_id too)
+ *    esp->scsi_id_mask
+ *    If ESP bus is differential, set ESP_FLAG_DIFFERENTIAL
+ *    esp->cfreq
+ *    DMA burst bit mask in esp->bursts, if necessary
+ * 10) Perform any actions necessary before the ESP device can
+ *     be programmed for the first time.  On some configs, for
+ *     example, the DMA engine has to be reset before ESP can
+ *     be programmed.
+ * 11) If necessary, call dev_set_drvdata() as needed.
+ * 12) Call scsi_esp_register() with prepared 'esp' structure
+ *     and a device pointer if possible.
+ * 13) Check scsi_esp_register() return value, release all resources
+ *     if an error was returned.
+ */
+extern struct scsi_host_template scsi_esp_template;
+extern int scsi_esp_register(struct esp *, struct device *);
+
+extern void scsi_esp_unregister(struct esp *);
+extern irqreturn_t scsi_esp_intr(int, void *);
+extern void scsi_esp_cmd(struct esp *, u8);
+
 #endif /* !(_SPARC_ESP_H) */
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
new file mode 100644
index 0000000..2a764fe
--- /dev/null
+++ b/drivers/scsi/sun_esp.c
@@ -0,0 +1,634 @@
+/* sun_esp.c: ESP front-end for Sparc SBUS systems.
+ *
+ * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/dma.h>
+
+#include <asm/sbus.h>
+
+#include <scsi/scsi_host.h>
+
+#include "esp.h"
+
+#define DRV_MODULE_NAME		"sun_esp"
+#define PFX DRV_MODULE_NAME	": "
+#define DRV_VERSION		"1.000"
+#define DRV_MODULE_RELDATE	"April 19, 2007"
+
+#define dma_read32(REG) \
+	sbus_readl(esp->dma_regs + (REG))
+#define dma_write32(VAL, REG) \
+	sbus_writel((VAL), esp->dma_regs + (REG))
+
+static int __devinit esp_sbus_find_dma(struct esp *esp, struct sbus_dev *dma_sdev)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct sbus_dma *dma;
+
+	if (dma_sdev != NULL) {
+		for_each_dvma(dma) {
+			if (dma->sdev == dma_sdev)
+				break;
+		}
+	} else {
+		for_each_dvma(dma) {
+			if (dma->sdev == NULL)
+				break;
+
+			/* If bus + slot are the same and it has the
+			 * correct OBP name, it's ours.
+			 */
+			if (sdev->bus == dma->sdev->bus &&
+			    sdev->slot == dma->sdev->slot &&
+			    (!strcmp(dma->sdev->prom_name, "dma") ||
+			     !strcmp(dma->sdev->prom_name, "espdma")))
+				break;
+		}
+	}
+
+	if (dma == NULL) {
+		printk(KERN_ERR PFX "[%s] Cannot find dma.\n",
+		       sdev->ofdev.node->full_name);
+		return -ENODEV;
+	}
+	esp->dma = dma;
+	esp->dma_regs = dma->regs;
+
+	return 0;
+
+}
+
+static int __devinit esp_sbus_map_regs(struct esp *esp, int hme)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct resource *res;
+
+	/* On HME, two reg sets exist, first is DVMA,
+	 * second is ESP registers.
+	 */
+	if (hme)
+		res = &sdev->resource[1];
+	else
+		res = &sdev->resource[0];
+
+	esp->regs = sbus_ioremap(res, 0, SBUS_ESP_REG_SIZE, "ESP");
+	if (!esp->regs)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __devinit esp_sbus_map_command_block(struct esp *esp)
+{
+	struct sbus_dev *sdev = esp->dev;
+
+	esp->command_block = sbus_alloc_consistent(sdev, 16,
+						   &esp->command_block_dma);
+	if (!esp->command_block)
+		return -ENOMEM;
+	return 0;
+}
+
+static int __devinit esp_sbus_register_irq(struct esp *esp)
+{
+	struct Scsi_Host *host = esp->host;
+	struct sbus_dev *sdev = esp->dev;
+
+	host->irq = sdev->irqs[0];
+	return request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp);
+}
+
+static void __devinit esp_get_scsi_id(struct esp *esp)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct device_node *dp = sdev->ofdev.node;
+
+	esp->scsi_id = of_getintprop_default(dp, "initiator-id", 0xff);
+	if (esp->scsi_id != 0xff)
+		goto done;
+
+	esp->scsi_id = of_getintprop_default(dp, "scsi-initiator-id", 0xff);
+	if (esp->scsi_id != 0xff)
+		goto done;
+
+	if (!sdev->bus) {
+		/* SUN4 */
+		esp->scsi_id = 7;
+		goto done;
+	}
+
+	esp->scsi_id = of_getintprop_default(sdev->bus->ofdev.node,
+					     "scsi-initiator-id", 7);
+
+done:
+	esp->host->this_id = esp->scsi_id;
+	esp->scsi_id_mask = (1 << esp->scsi_id);
+}
+
+static void __devinit esp_get_differential(struct esp *esp)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct device_node *dp = sdev->ofdev.node;
+
+	if (of_find_property(dp, "differential", NULL))
+		esp->flags |= ESP_FLAG_DIFFERENTIAL;
+	else
+		esp->flags &= ~ESP_FLAG_DIFFERENTIAL;
+}
+
+static void __devinit esp_get_clock_params(struct esp *esp)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct device_node *dp = sdev->ofdev.node;
+	struct device_node *bus_dp;
+	int fmhz;
+
+	bus_dp = NULL;
+	if (sdev != NULL && sdev->bus != NULL)
+		bus_dp = sdev->bus->ofdev.node;
+
+	fmhz = of_getintprop_default(dp, "clock-frequency", 0);
+	if (fmhz == 0)
+		fmhz = (!bus_dp) ? 0 :
+			of_getintprop_default(bus_dp, "clock-frequency", 0);
+
+	esp->cfreq = fmhz;
+}
+
+static void __devinit esp_get_bursts(struct esp *esp, struct sbus_dev *dma)
+{
+	struct sbus_dev *sdev = esp->dev;
+	struct device_node *dp = sdev->ofdev.node;
+	u8 bursts;
+
+	bursts = of_getintprop_default(dp, "burst-sizes", 0xff);
+	if (dma) {
+		struct device_node *dma_dp = dma->ofdev.node;
+		u8 val = of_getintprop_default(dma_dp, "burst-sizes", 0xff);
+		if (val != 0xff)
+			bursts &= val;
+	}
+
+	if (sdev->bus) {
+		u8 val = of_getintprop_default(sdev->bus->ofdev.node,
+					       "burst-sizes", 0xff);
+		if (val != 0xff)
+			bursts &= val;
+	}
+
+	if (bursts == 0xff ||
+	    (bursts & DMA_BURST16) == 0 ||
+	    (bursts & DMA_BURST32) == 0)
+		bursts = (DMA_BURST32 - 1);
+
+	esp->bursts = bursts;
+}
+
+static void __devinit esp_sbus_get_props(struct esp *esp, struct sbus_dev *espdma)
+{
+	esp_get_scsi_id(esp);
+	esp_get_differential(esp);
+	esp_get_clock_params(esp);
+	esp_get_bursts(esp, espdma);
+}
+
+static void sbus_esp_write8(struct esp *esp, u8 val, unsigned long reg)
+{
+	sbus_writeb(val, esp->regs + (reg * 4UL));
+}
+
+static u8 sbus_esp_read8(struct esp *esp, unsigned long reg)
+{
+	return sbus_readb(esp->regs + (reg * 4UL));
+}
+
+static dma_addr_t sbus_esp_map_single(struct esp *esp, void *buf,
+				      size_t sz, int dir)
+{
+	return sbus_map_single(esp->dev, buf, sz, dir);
+}
+
+static int sbus_esp_map_sg(struct esp *esp, struct scatterlist *sg,
+				  int num_sg, int dir)
+{
+	return sbus_map_sg(esp->dev, sg, num_sg, dir);
+}
+
+static void sbus_esp_unmap_single(struct esp *esp, dma_addr_t addr,
+				  size_t sz, int dir)
+{
+	sbus_unmap_single(esp->dev, addr, sz, dir);
+}
+
+static void sbus_esp_unmap_sg(struct esp *esp, struct scatterlist *sg,
+			      int num_sg, int dir)
+{
+	sbus_unmap_sg(esp->dev, sg, num_sg, dir);
+}
+
+static int sbus_esp_irq_pending(struct esp *esp)
+{
+	if (dma_read32(DMA_CSR) & (DMA_HNDL_INTR | DMA_HNDL_ERROR))
+		return 1;
+	return 0;
+}
+
+static void sbus_esp_reset_dma(struct esp *esp)
+{
+	int can_do_burst16, can_do_burst32, can_do_burst64;
+	int can_do_sbus64, lim;
+	u32 val;
+
+	can_do_burst16 = (esp->bursts & DMA_BURST16) != 0;
+	can_do_burst32 = (esp->bursts & DMA_BURST32) != 0;
+	can_do_burst64 = 0;
+	can_do_sbus64 = 0;
+	if (sbus_can_dma_64bit(esp->dev))
+		can_do_sbus64 = 1;
+	if (sbus_can_burst64(esp->sdev))
+		can_do_burst64 = (esp->bursts & DMA_BURST64) != 0;
+
+	/* Put the DVMA into a known state. */
+	if (esp->dma->revision != dvmahme) {
+		val = dma_read32(DMA_CSR);
+		dma_write32(val | DMA_RST_SCSI, DMA_CSR);
+		dma_write32(val & ~DMA_RST_SCSI, DMA_CSR);
+	}
+	switch (esp->dma->revision) {
+	case dvmahme:
+		dma_write32(DMA_RESET_FAS366, DMA_CSR);
+		dma_write32(DMA_RST_SCSI, DMA_CSR);
+
+		esp->prev_hme_dmacsr = (DMA_PARITY_OFF | DMA_2CLKS |
+					DMA_SCSI_DISAB | DMA_INT_ENAB);
+
+		esp->prev_hme_dmacsr &= ~(DMA_ENABLE | DMA_ST_WRITE |
+					  DMA_BRST_SZ);
+
+		if (can_do_burst64)
+			esp->prev_hme_dmacsr |= DMA_BRST64;
+		else if (can_do_burst32)
+			esp->prev_hme_dmacsr |= DMA_BRST32;
+
+		if (can_do_sbus64) {
+			esp->prev_hme_dmacsr |= DMA_SCSI_SBUS64;
+			sbus_set_sbus64(esp->dev, esp->bursts);
+		}
+
+		lim = 1000;
+		while (dma_read32(DMA_CSR) & DMA_PEND_READ) {
+			if (--lim == 0) {
+				printk(KERN_ALERT PFX "esp%d: DMA_PEND_READ "
+				       "will not clear!\n",
+				       esp->host->unique_id);
+				break;
+			}
+			udelay(1);
+		}
+
+		dma_write32(0, DMA_CSR);
+		dma_write32(esp->prev_hme_dmacsr, DMA_CSR);
+
+		dma_write32(0, DMA_ADDR);
+		break;
+
+	case dvmarev2:
+		if (esp->rev != ESP100) {
+			val = dma_read32(DMA_CSR);
+			dma_write32(val | DMA_3CLKS, DMA_CSR);
+		}
+		break;
+
+	case dvmarev3:
+		val = dma_read32(DMA_CSR);
+		val &= ~DMA_3CLKS;
+		val |= DMA_2CLKS;
+		if (can_do_burst32) {
+			val &= ~DMA_BRST_SZ;
+			val |= DMA_BRST32;
+		}
+		dma_write32(val, DMA_CSR);
+		break;
+
+	case dvmaesc1:
+		val = dma_read32(DMA_CSR);
+		val |= DMA_ADD_ENABLE;
+		val &= ~DMA_BCNT_ENAB;
+		if (!can_do_burst32 && can_do_burst16) {
+			val |= DMA_ESC_BURST;
+		} else {
+			val &= ~(DMA_ESC_BURST);
+		}
+		dma_write32(val, DMA_CSR);
+		break;
+
+	default:
+		break;
+	}
+
+	/* Enable interrupts.  */
+	val = dma_read32(DMA_CSR);
+	dma_write32(val | DMA_INT_ENAB, DMA_CSR);
+}
+
+static void sbus_esp_dma_drain(struct esp *esp)
+{
+	u32 csr;
+	int lim;
+
+	if (esp->dma->revision == dvmahme)
+		return;
+
+	csr = dma_read32(DMA_CSR);
+	if (!(csr & DMA_FIFO_ISDRAIN))
+		return;
+
+	if (esp->dma->revision != dvmarev3 && esp->dma->revision != dvmaesc1)
+		dma_write32(csr | DMA_FIFO_STDRAIN, DMA_CSR);
+
+	lim = 1000;
+	while (dma_read32(DMA_CSR) & DMA_FIFO_ISDRAIN) {
+		if (--lim == 0) {
+			printk(KERN_ALERT PFX "esp%d: DMA will not drain!\n",
+			       esp->host->unique_id);
+			break;
+		}
+		udelay(1);
+	}
+}
+
+static void sbus_esp_dma_invalidate(struct esp *esp)
+{
+	if (esp->dma->revision == dvmahme) {
+		dma_write32(DMA_RST_SCSI, DMA_CSR);
+
+		esp->prev_hme_dmacsr = ((esp->prev_hme_dmacsr |
+					 (DMA_PARITY_OFF | DMA_2CLKS |
+					  DMA_SCSI_DISAB | DMA_INT_ENAB)) &
+					~(DMA_ST_WRITE | DMA_ENABLE));
+
+		dma_write32(0, DMA_CSR);
+		dma_write32(esp->prev_hme_dmacsr, DMA_CSR);
+
+		/* This is necessary to avoid having the SCSI channel
+		 * engine lock up on us.
+		 */
+		dma_write32(0, DMA_ADDR);
+	} else {
+		u32 val;
+		int lim;
+
+		lim = 1000;
+		while ((val = dma_read32(DMA_CSR)) & DMA_PEND_READ) {
+			if (--lim == 0) {
+				printk(KERN_ALERT PFX "esp%d: DMA will not "
+				       "invalidate!\n", esp->host->unique_id);
+				break;
+			}
+			udelay(1);
+		}
+
+		val &= ~(DMA_ENABLE | DMA_ST_WRITE | DMA_BCNT_ENAB);
+		val |= DMA_FIFO_INV;
+		dma_write32(val, DMA_CSR);
+		val &= ~DMA_FIFO_INV;
+		dma_write32(val, DMA_CSR);
+	}
+}
+
+static void sbus_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
+				  u32 dma_count, int write, u8 cmd)
+{
+	u32 csr;
+
+	BUG_ON(!(cmd & ESP_CMD_DMA));
+
+	sbus_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
+	sbus_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
+	if (esp->rev == FASHME) {
+		sbus_esp_write8(esp, (esp_count >> 16) & 0xff, FAS_RLO);
+		sbus_esp_write8(esp, 0, FAS_RHI);
+
+		scsi_esp_cmd(esp, cmd);
+
+		csr = esp->prev_hme_dmacsr;
+		csr |= DMA_SCSI_DISAB | DMA_ENABLE;
+		if (write)
+			csr |= DMA_ST_WRITE;
+		else
+			csr &= ~DMA_ST_WRITE;
+		esp->prev_hme_dmacsr = csr;
+
+		dma_write32(dma_count, DMA_COUNT);
+		dma_write32(addr, DMA_ADDR);
+		dma_write32(csr, DMA_CSR);
+	} else {
+		csr = dma_read32(DMA_CSR);
+		csr |= DMA_ENABLE;
+		if (write)
+			csr |= DMA_ST_WRITE;
+		else
+			csr &= ~DMA_ST_WRITE;
+		dma_write32(csr, DMA_CSR);
+		if (esp->dma->revision == dvmaesc1) {
+			u32 end = PAGE_ALIGN(addr + dma_count + 16U);
+			dma_write32(end - addr, DMA_COUNT);
+		}
+		dma_write32(addr, DMA_ADDR);
+
+		scsi_esp_cmd(esp, cmd);
+	}
+
+}
+
+static int sbus_esp_dma_error(struct esp *esp)
+{
+	u32 csr = dma_read32(DMA_CSR);
+
+	if (csr & DMA_HNDL_ERROR)
+		return 1;
+
+	return 0;
+}
+
+static const struct esp_driver_ops sbus_esp_ops = {
+	.esp_write8	=	sbus_esp_write8,
+	.esp_read8	=	sbus_esp_read8,
+	.map_single	=	sbus_esp_map_single,
+	.map_sg		=	sbus_esp_map_sg,
+	.unmap_single	=	sbus_esp_unmap_single,
+	.unmap_sg	=	sbus_esp_unmap_sg,
+	.irq_pending	=	sbus_esp_irq_pending,
+	.reset_dma	=	sbus_esp_reset_dma,
+	.dma_drain	=	sbus_esp_dma_drain,
+	.dma_invalidate	=	sbus_esp_dma_invalidate,
+	.send_dma_cmd	=	sbus_esp_send_dma_cmd,
+	.dma_error	=	sbus_esp_dma_error,
+};
+
+static int __devinit esp_sbus_probe_one(struct device *dev,
+					struct sbus_dev *esp_dev,
+					struct sbus_dev *espdma,
+					struct sbus_bus *sbus,
+					int hme)
+{
+	struct scsi_host_template *tpnt = &scsi_esp_template;
+	struct Scsi_Host *host;
+	struct esp *esp;
+	int err;
+
+	host = scsi_host_alloc(tpnt, sizeof(struct esp));
+
+	err = -ENOMEM;
+	if (!host)
+		goto fail;
+
+	host->max_id = (hme ? 16 : 8);
+	esp = host_to_esp(host);
+
+	esp->host = host;
+	esp->dev = esp_dev;
+	esp->ops = &sbus_esp_ops;
+
+	if (hme)
+		esp->flags |= ESP_FLAG_WIDE_CAPABLE;
+
+	err = esp_sbus_find_dma(esp, espdma);
+	if (err < 0)
+		goto fail_unlink;
+
+	err = esp_sbus_map_regs(esp, hme);
+	if (err < 0)
+		goto fail_unlink;
+
+	err = esp_sbus_map_command_block(esp);
+	if (err < 0)
+		goto fail_unmap_regs;
+
+	err = esp_sbus_register_irq(esp);
+	if (err < 0)
+		goto fail_unmap_command_block;
+
+	esp_sbus_get_props(esp, espdma);
+
+	/* Before we try to touch the ESP chip, ESC1 dma can
+	 * come up with the reset bit set, so make sure that
+	 * is clear first.
+	 */
+	if (esp->dma->revision == dvmaesc1) {
+		u32 val = dma_read32(DMA_CSR);
+
+		dma_write32(val & ~DMA_RST_SCSI, DMA_CSR);
+	}
+
+	dev_set_drvdata(&esp_dev->ofdev.dev, esp);
+
+	err = scsi_esp_register(esp, dev);
+	if (err)
+		goto fail_free_irq;
+
+	return 0;
+
+fail_free_irq:
+	free_irq(host->irq, esp);
+fail_unmap_command_block:
+	sbus_free_consistent(esp->dev, 16,
+			     esp->command_block,
+			     esp->command_block_dma);
+fail_unmap_regs:
+	sbus_iounmap(esp->regs, SBUS_ESP_REG_SIZE);
+fail_unlink:
+	scsi_host_put(host);
+fail:
+	return err;
+}
+
+static int __devinit esp_sbus_probe(struct of_device *dev, const struct of_device_id *match)
+{
+	struct sbus_dev *sdev = to_sbus_device(&dev->dev);
+	struct device_node *dp = dev->node;
+	struct sbus_dev *dma_sdev = NULL;
+	int hme = 0;
+
+	if (dp->parent &&
+	    (!strcmp(dp->parent->name, "espdma") ||
+	     !strcmp(dp->parent->name, "dma")))
+		dma_sdev = sdev->parent;
+	else if (!strcmp(dp->name, "SUNW,fas")) {
+		dma_sdev = sdev;
+		hme = 1;
+	}
+
+	return esp_sbus_probe_one(&dev->dev, sdev, dma_sdev,
+				  sdev->bus, hme);
+}
+
+static int __devexit esp_sbus_remove(struct of_device *dev)
+{
+	struct esp *esp = dev_get_drvdata(&dev->dev);
+	unsigned int irq = esp->host->irq;
+	u32 val;
+
+	scsi_esp_unregister(esp);
+
+	/* Disable interrupts.  */
+	val = dma_read32(DMA_CSR);
+	dma_write32(val & ~DMA_INT_ENAB, DMA_CSR);
+
+	free_irq(irq, esp);
+	sbus_free_consistent(esp->dev, 16,
+			     esp->command_block,
+			     esp->command_block_dma);
+	sbus_iounmap(esp->regs, SBUS_ESP_REG_SIZE);
+
+	scsi_host_put(esp->host);
+
+	return 0;
+}
+
+static struct of_device_id esp_match[] = {
+	{
+		.name = "SUNW,esp",
+	},
+	{
+		.name = "SUNW,fas",
+	},
+	{
+		.name = "esp",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, esp_match);
+
+static struct of_platform_driver esp_sbus_driver = {
+	.name		= "esp",
+	.match_table	= esp_match,
+	.probe		= esp_sbus_probe,
+	.remove		= __devexit_p(esp_sbus_remove),
+};
+
+static int __init sunesp_init(void)
+{
+	return of_register_driver(&esp_sbus_driver, &sbus_bus_type);
+}
+
+static void __exit sunesp_exit(void)
+{
+	of_unregister_driver(&esp_sbus_driver);
+}
+
+MODULE_DESCRIPTION("Sun ESP SCSI driver");
+MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(sunesp_init);
+module_exit(sunesp_exit);
