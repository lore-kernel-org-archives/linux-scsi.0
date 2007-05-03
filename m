From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] ibmmca: convert to new probing API and fix oopses
Date: Thu, 03 May 2007 11:13:08 -0500
Message-ID: <1178208788.3714.38.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56658 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162159AbXECQNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 12:13:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

This is basically a straight conversion.  I have one of these things, so
I know it works ... my problem is that it has a wierd SCA like
connector, so I can't connect anything to it (no cables).

However, previously it panic'd in the interrupt, now it completes a bus
scan.  It depends on the integrated function registration for the MCA
bus patch.  If anyone still has a PS/2, I'd be interested in knowing if
this works.

James

Index: BUILD-voyager/drivers/scsi/ibmmca.c
===================================================================
--- BUILD-voyager.orig/drivers/scsi/ibmmca.c	2007-05-03 08:44:53.000000000 -0500
+++ BUILD-voyager/drivers/scsi/ibmmca.c	2007-05-03 09:09:55.000000000 -0500
@@ -31,14 +31,21 @@
 #include <linux/mca.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
-#include <linux/mca-legacy.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "ibmmca.h"
+
+/* Common forward declarations for all Linux-versions: */
+static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
+static int ibmmca_abort (Scsi_Cmnd *);
+static int ibmmca_host_reset (Scsi_Cmnd *);
+static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
+static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout);
+
+
 
 /* current version of this driver-source: */
 #define IBMMCA_SCSI_DRIVER_VERSION "4.0b-ac"
@@ -65,11 +72,11 @@
 #define IM_DEBUG_CMD_DEVICE	TYPE_TAPE
 
 /* relative addresses of hardware registers on a subsystem */
-#define IM_CMD_REG(hi)	(hosts[(hi)]->io_port)	/*Command Interface, (4 bytes long) */
-#define IM_ATTN_REG(hi)	(hosts[(hi)]->io_port+4)	/*Attention (1 byte) */
-#define IM_CTR_REG(hi)	(hosts[(hi)]->io_port+5)	/*Basic Control (1 byte) */
-#define IM_INTR_REG(hi)	(hosts[(hi)]->io_port+6)	/*Interrupt Status (1 byte, r/o) */
-#define IM_STAT_REG(hi)	(hosts[(hi)]->io_port+7)	/*Basic Status (1 byte, read only) */
+#define IM_CMD_REG(h)	((h)->io_port)	/*Command Interface, (4 bytes long) */
+#define IM_ATTN_REG(h)	((h)->io_port+4)	/*Attention (1 byte) */
+#define IM_CTR_REG(h)	((h)->io_port+5)	/*Basic Control (1 byte) */
+#define IM_INTR_REG(h)	((h)->io_port+6)	/*Interrupt Status (1 byte, r/o) */
+#define IM_STAT_REG(h)	((h)->io_port+7)	/*Basic Status (1 byte, read only) */
 
 /* basic I/O-port of first adapter */
 #define IM_IO_PORT	0x3540
@@ -266,30 +273,36 @@ static int global_adapter_speed = 0;	/* 
     if ((display_mode & LED_ACTIVITY)||(!display_mode)) \
     outb(inb(PS2_SYS_CTR) & 0x3f, PS2_SYS_CTR); }
 
-/*list of supported subsystems */
-struct subsys_list_struct {
-	unsigned short mca_id;
-	char *description;
-};
-
 /* types of different supported hardware that goes to hostdata special */
 #define IBM_SCSI2_FW     0
 #define IBM_7568_WCACHE  1
 #define IBM_EXP_UNIT     2
 #define IBM_SCSI_WCACHE  3
 #define IBM_SCSI         4
+#define IBM_INTEGSCSI	 5
 
 /* other special flags for hostdata structure */
 #define FORCED_DETECTION         100
 #define INTEGRATED_SCSI          101
 
 /* List of possible IBM-SCSI-adapters */
-static struct subsys_list_struct subsys_list[] = {
-	{0x8efc, "IBM SCSI-2 F/W Adapter"},	/* special = 0 */
-	{0x8efd, "IBM 7568 Industrial Computer SCSI Adapter w/Cache"},	/* special = 1 */
-	{0x8ef8, "IBM Expansion Unit SCSI Controller"},	/* special = 2 */
-	{0x8eff, "IBM SCSI Adapter w/Cache"},	/* special = 3 */
-	{0x8efe, "IBM SCSI Adapter"},	/* special = 4 */
+static short ibmmca_id_table[] = {
+	0x8efc,
+	0x8efd,
+	0x8ef8,
+	0x8eff,
+	0x8efe,
+	/* No entry for integrated SCSI, that's part of the register */
+	0
+};
+
+static const char *ibmmca_description[] = {
+	"IBM SCSI-2 F/W Adapter",	/* special = 0 */
+	"IBM 7568 Industrial Computer SCSI Adapter w/Cache",	/* special = 1 */
+	"IBM Expansion Unit SCSI Controller",	/* special = 2 */
+	"IBM SCSI Adapter w/Cache",	/* special = 3 */
+	"IBM SCSI Adapter",	/* special = 4 */
+	"IBM Integrated SCSI Controller", /* special = 5 */
 };
 
 /* Max number of logical devices (can be up from 0 to 14).  15 is the address
@@ -375,30 +388,30 @@ struct ibmmca_hostdata {
 };
 
 /* macros to access host data structure */
-#define subsystem_pun(hi) (hosts[(hi)]->this_id)
-#define subsystem_maxid(hi) (hosts[(hi)]->max_id)
-#define ld(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_ld)
-#define get_ldn(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_get_ldn)
-#define get_scsi(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_get_scsi)
-#define local_checking_phase_flag(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_local_checking_phase_flag)
-#define got_interrupt(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_got_interrupt)
-#define stat_result(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_stat_result)
-#define reset_status(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_reset_status)
-#define last_scsi_command(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_last_scsi_command)
-#define last_scsi_type(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_last_scsi_type)
-#define last_scsi_blockcount(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_last_scsi_blockcount)
-#define last_scsi_logical_block(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_last_scsi_logical_block)
-#define last_scsi_type(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_last_scsi_type)
-#define next_ldn(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_next_ldn)
-#define IBM_DS(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_IBM_DS)
-#define special(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_special)
-#define subsystem_connector_size(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_connector_size)
-#define adapter_speed(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_adapter_speed)
-#define pos2(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_pos[2])
-#define pos3(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_pos[3])
-#define pos4(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_pos[4])
-#define pos5(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_pos[5])
-#define pos6(hi) (((struct ibmmca_hostdata *) hosts[(hi)]->hostdata)->_pos[6])
+#define subsystem_pun(h) ((h)->this_id)
+#define subsystem_maxid(h) ((h)->max_id)
+#define ld(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_ld)
+#define get_ldn(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_get_ldn)
+#define get_scsi(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_get_scsi)
+#define local_checking_phase_flag(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_local_checking_phase_flag)
+#define got_interrupt(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_got_interrupt)
+#define stat_result(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_stat_result)
+#define reset_status(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_reset_status)
+#define last_scsi_command(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_last_scsi_command)
+#define last_scsi_type(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_last_scsi_type)
+#define last_scsi_blockcount(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_last_scsi_blockcount)
+#define last_scsi_logical_block(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_last_scsi_logical_block)
+#define last_scsi_type(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_last_scsi_type)
+#define next_ldn(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_next_ldn)
+#define IBM_DS(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_IBM_DS)
+#define special(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_special)
+#define subsystem_connector_size(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_connector_size)
+#define adapter_speed(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_adapter_speed)
+#define pos2(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_pos[2])
+#define pos3(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_pos[3])
+#define pos4(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_pos[4])
+#define pos5(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_pos[5])
+#define pos6(h) (((struct ibmmca_hostdata *) (h)->hostdata)->_pos[6])
 
 /* Define a arbitrary number as subsystem-marker-type. This number is, as
    described in the ANSI-SCSI-standard, not occupied by other device-types. */
@@ -459,11 +472,6 @@ MODULE_LICENSE("GPL");
 /*counter of concurrent disk read/writes, to turn on/off disk led */
 static int disk_rw_in_progress = 0;
 
-/* host information */
-static int found = 0;
-static struct Scsi_Host *hosts[IM_MAX_HOSTS + 1] = {
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
-};
 static unsigned int pos[8];	/* whole pos register-line for diagnosis */
 /* Taking into account the additions, made by ZP Gu.
  * This selects now the preset value from the configfile and
@@ -474,70 +482,68 @@ static char ibm_ansi_order = 1;
 static char ibm_ansi_order = 0;
 #endif
 
-static void issue_cmd(int, unsigned long, unsigned char);
+static void issue_cmd(struct Scsi_Host *, unsigned long, unsigned char);
 static void internal_done(Scsi_Cmnd * cmd);
-static void check_devices(int, int);
-static int immediate_assign(int, unsigned int, unsigned int, unsigned int, unsigned int);
-static int immediate_feature(int, unsigned int, unsigned int);
+static void check_devices(struct Scsi_Host *, int);
+static int immediate_assign(struct Scsi_Host *, unsigned int, unsigned int, unsigned int, unsigned int);
+static int immediate_feature(struct Scsi_Host *, unsigned int, unsigned int);
 #ifdef CONFIG_IBMMCA_SCSI_DEV_RESET
-static int immediate_reset(int, unsigned int);
+static int immediate_reset(struct Scsi_Host *, unsigned int);
 #endif
-static int device_inquiry(int, int);
-static int read_capacity(int, int);
-static int get_pos_info(int);
+static int device_inquiry(struct Scsi_Host *, int);
+static int read_capacity(struct Scsi_Host *, int);
+static int get_pos_info(struct Scsi_Host *);
 static char *ti_p(int);
 static char *ti_l(int);
 static char *ibmrate(unsigned int, int);
 static int probe_display(int);
-static int probe_bus_mode(int);
-static int device_exists(int, int, int *, int *);
-static struct Scsi_Host *ibmmca_register(struct scsi_host_template *, int, int, int, char *);
+static int probe_bus_mode(struct Scsi_Host *);
+static int device_exists(struct Scsi_Host *, int, int *, int *);
 static int option_setup(char *);
 /* local functions needed for proc_info */
-static int ldn_access_load(int, int);
-static int ldn_access_total_read_write(int);
+static int ldn_access_load(struct Scsi_Host *, int);
+static int ldn_access_total_read_write(struct Scsi_Host *);
 
 static irqreturn_t interrupt_handler(int irq, void *dev_id)
 {
-	int host_index, ihost_index;
 	unsigned int intr_reg;
 	unsigned int cmd_result;
 	unsigned int ldn;
+	unsigned long flags;
 	Scsi_Cmnd *cmd;
 	int lastSCSI;
-	struct Scsi_Host *dev = dev_id;
+	struct device *dev = dev_id;
+	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
 
-	spin_lock(dev->host_lock);
-	    /* search for one adapter-response on shared interrupt */
-	    for (host_index = 0; hosts[host_index] && !(inb(IM_STAT_REG(host_index)) & IM_INTR_REQUEST); host_index++);
-	/* return if some other device on this IRQ caused the interrupt */
-	if (!hosts[host_index]) {
-		spin_unlock(dev->host_lock);
+	spin_lock_irqsave(shpnt->host_lock, flags);
+
+	if(!(inb(IM_STAT_REG(shpnt)) & IM_INTR_REQUEST)) {
+		spin_unlock_irqrestore(shpnt->host_lock, flags);
 		return IRQ_NONE;
 	}
 
 	/* the reset-function already did all the job, even ints got
 	   renabled on the subsystem, so just return */
-	if ((reset_status(host_index) == IM_RESET_NOT_IN_PROGRESS_NO_INT) || (reset_status(host_index) == IM_RESET_FINISHED_OK_NO_INT)) {
-		reset_status(host_index) = IM_RESET_NOT_IN_PROGRESS;
-		spin_unlock(dev->host_lock);
+	if ((reset_status(shpnt) == IM_RESET_NOT_IN_PROGRESS_NO_INT) || (reset_status(shpnt) == IM_RESET_FINISHED_OK_NO_INT)) {
+		reset_status(shpnt) = IM_RESET_NOT_IN_PROGRESS;
+		spin_unlock_irqrestore(shpnt->host_lock, flags);
 		return IRQ_HANDLED;
 	}
 
 	/*must wait for attention reg not busy, then send EOI to subsystem */
 	while (1) {
-		if (!(inb(IM_STAT_REG(host_index)) & IM_BUSY))
+		if (!(inb(IM_STAT_REG(shpnt)) & IM_BUSY))
 			break;
 		cpu_relax();
 	}
-	ihost_index = host_index;
+
 	/*get command result and logical device */
-	intr_reg = (unsigned char) (inb(IM_INTR_REG(ihost_index)));
+	intr_reg = (unsigned char) (inb(IM_INTR_REG(shpnt)));
 	cmd_result = intr_reg & 0xf0;
 	ldn = intr_reg & 0x0f;
 	/* get the last_scsi_command here */
-	lastSCSI = last_scsi_command(ihost_index)[ldn];
-	outb(IM_EOI | ldn, IM_ATTN_REG(ihost_index));
+	lastSCSI = last_scsi_command(shpnt)[ldn];
+	outb(IM_EOI | ldn, IM_ATTN_REG(shpnt));
 	
 	/*these should never happen (hw fails, or a local programming bug) */
 	if (!global_command_error_excuse) {
@@ -547,38 +553,38 @@ static irqreturn_t interrupt_handler(int
 		case IM_SOFTWARE_SEQUENCING_ERROR:
 		case IM_CMD_ERROR:
 			printk(KERN_ERR "IBM MCA SCSI: Fatal Subsystem ERROR!\n");
-			printk(KERN_ERR "              Last cmd=0x%x, ena=%x, len=", lastSCSI, ld(ihost_index)[ldn].scb.enable);
-			if (ld(ihost_index)[ldn].cmd)
-				printk("%ld/%ld,", (long) (ld(ihost_index)[ldn].cmd->request_bufflen), (long) (ld(ihost_index)[ldn].scb.sys_buf_length));
+			printk(KERN_ERR "              Last cmd=0x%x, ena=%x, len=", lastSCSI, ld(shpnt)[ldn].scb.enable);
+			if (ld(shpnt)[ldn].cmd)
+				printk("%ld/%ld,", (long) (ld(shpnt)[ldn].cmd->request_bufflen), (long) (ld(shpnt)[ldn].scb.sys_buf_length));
 			else
 				printk("none,");
-			if (ld(ihost_index)[ldn].cmd)
-				printk("Blocksize=%d", ld(ihost_index)[ldn].scb.u2.blk.length);
+			if (ld(shpnt)[ldn].cmd)
+				printk("Blocksize=%d", ld(shpnt)[ldn].scb.u2.blk.length);
 			else
 				printk("Blocksize=none");
-			printk(", host=0x%x, ldn=0x%x\n", ihost_index, ldn);
-			if (ld(ihost_index)[ldn].cmd) {
-				printk(KERN_ERR "Blockcount=%d/%d\n", last_scsi_blockcount(ihost_index)[ldn], ld(ihost_index)[ldn].scb.u2.blk.count);
-				printk(KERN_ERR "Logical block=%lx/%lx\n", last_scsi_logical_block(ihost_index)[ldn], ld(ihost_index)[ldn].scb.u1.log_blk_adr);
+			printk(", host=%p, ldn=0x%x\n", shpnt, ldn);
+			if (ld(shpnt)[ldn].cmd) {
+				printk(KERN_ERR "Blockcount=%d/%d\n", last_scsi_blockcount(shpnt)[ldn], ld(shpnt)[ldn].scb.u2.blk.count);
+				printk(KERN_ERR "Logical block=%lx/%lx\n", last_scsi_logical_block(shpnt)[ldn], ld(shpnt)[ldn].scb.u1.log_blk_adr);
 			}
 			printk(KERN_ERR "Reason given: %s\n", (cmd_result == IM_ADAPTER_HW_FAILURE) ? "HARDWARE FAILURE" : (cmd_result == IM_SOFTWARE_SEQUENCING_ERROR) ? "SOFTWARE SEQUENCING ERROR" : (cmd_result == IM_CMD_ERROR) ? "COMMAND ERROR" : "UNKNOWN");
 			/* if errors appear, enter this section to give detailed info */
 			printk(KERN_ERR "IBM MCA SCSI: Subsystem Error-Status follows:\n");
-			printk(KERN_ERR "              Command Type................: %x\n", last_scsi_type(ihost_index)[ldn]);
-			printk(KERN_ERR "              Attention Register..........: %x\n", inb(IM_ATTN_REG(ihost_index)));
-			printk(KERN_ERR "              Basic Control Register......: %x\n", inb(IM_CTR_REG(ihost_index)));
+			printk(KERN_ERR "              Command Type................: %x\n", last_scsi_type(shpnt)[ldn]);
+			printk(KERN_ERR "              Attention Register..........: %x\n", inb(IM_ATTN_REG(shpnt)));
+			printk(KERN_ERR "              Basic Control Register......: %x\n", inb(IM_CTR_REG(shpnt)));
 			printk(KERN_ERR "              Interrupt Status Register...: %x\n", intr_reg);
-			printk(KERN_ERR "              Basic Status Register.......: %x\n", inb(IM_STAT_REG(ihost_index)));
-			if ((last_scsi_type(ihost_index)[ldn] == IM_SCB) || (last_scsi_type(ihost_index)[ldn] == IM_LONG_SCB)) {
-				printk(KERN_ERR "              SCB-Command.................: %x\n", ld(ihost_index)[ldn].scb.command);
-				printk(KERN_ERR "              SCB-Enable..................: %x\n", ld(ihost_index)[ldn].scb.enable);
-				printk(KERN_ERR "              SCB-logical block address...: %lx\n", ld(ihost_index)[ldn].scb.u1.log_blk_adr);
-				printk(KERN_ERR "              SCB-system buffer address...: %lx\n", ld(ihost_index)[ldn].scb.sys_buf_adr);
-				printk(KERN_ERR "              SCB-system buffer length....: %lx\n", ld(ihost_index)[ldn].scb.sys_buf_length);
-				printk(KERN_ERR "              SCB-tsb address.............: %lx\n", ld(ihost_index)[ldn].scb.tsb_adr);
-				printk(KERN_ERR "              SCB-Chain address...........: %lx\n", ld(ihost_index)[ldn].scb.scb_chain_adr);
-				printk(KERN_ERR "              SCB-block count.............: %x\n", ld(ihost_index)[ldn].scb.u2.blk.count);
-				printk(KERN_ERR "              SCB-block length............: %x\n", ld(ihost_index)[ldn].scb.u2.blk.length);
+			printk(KERN_ERR "              Basic Status Register.......: %x\n", inb(IM_STAT_REG(shpnt)));
+			if ((last_scsi_type(shpnt)[ldn] == IM_SCB) || (last_scsi_type(shpnt)[ldn] == IM_LONG_SCB)) {
+				printk(KERN_ERR "              SCB-Command.................: %x\n", ld(shpnt)[ldn].scb.command);
+				printk(KERN_ERR "              SCB-Enable..................: %x\n", ld(shpnt)[ldn].scb.enable);
+				printk(KERN_ERR "              SCB-logical block address...: %lx\n", ld(shpnt)[ldn].scb.u1.log_blk_adr);
+				printk(KERN_ERR "              SCB-system buffer address...: %lx\n", ld(shpnt)[ldn].scb.sys_buf_adr);
+				printk(KERN_ERR "              SCB-system buffer length....: %lx\n", ld(shpnt)[ldn].scb.sys_buf_length);
+				printk(KERN_ERR "              SCB-tsb address.............: %lx\n", ld(shpnt)[ldn].scb.tsb_adr);
+				printk(KERN_ERR "              SCB-Chain address...........: %lx\n", ld(shpnt)[ldn].scb.scb_chain_adr);
+				printk(KERN_ERR "              SCB-block count.............: %x\n", ld(shpnt)[ldn].scb.u2.blk.count);
+				printk(KERN_ERR "              SCB-block length............: %x\n", ld(shpnt)[ldn].scb.u2.blk.length);
 			}
 			printk(KERN_ERR "              Send this report to the maintainer.\n");
 			panic("IBM MCA SCSI: Fatal error message from the subsystem (0x%X,0x%X)!\n", lastSCSI, cmd_result);
@@ -600,72 +606,73 @@ static irqreturn_t interrupt_handler(int
 		}
 	}
 	/* if no panic appeared, increase the interrupt-counter */
-	IBM_DS(ihost_index).total_interrupts++;
+	IBM_DS(shpnt).total_interrupts++;
 	/*only for local checking phase */
-	if (local_checking_phase_flag(ihost_index)) {
-		stat_result(ihost_index) = cmd_result;
-		got_interrupt(ihost_index) = 1;
-		reset_status(ihost_index) = IM_RESET_FINISHED_OK;
-		last_scsi_command(ihost_index)[ldn] = NO_SCSI;
-		spin_unlock(dev->host_lock);
+	if (local_checking_phase_flag(shpnt)) {
+		stat_result(shpnt) = cmd_result;
+		got_interrupt(shpnt) = 1;
+		reset_status(shpnt) = IM_RESET_FINISHED_OK;
+		last_scsi_command(shpnt)[ldn] = NO_SCSI;
+		spin_unlock_irqrestore(shpnt->host_lock, flags);
 		return IRQ_HANDLED;
 	}
 	/* handling of commands coming from upper level of scsi driver */
-	if (last_scsi_type(ihost_index)[ldn] == IM_IMM_CMD) {
+	if (last_scsi_type(shpnt)[ldn] == IM_IMM_CMD) {
 		/* verify ldn, and may handle rare reset immediate command */
-		if ((reset_status(ihost_index) == IM_RESET_IN_PROGRESS) && (last_scsi_command(ihost_index)[ldn] == IM_RESET_IMM_CMD)) {
+		if ((reset_status(shpnt) == IM_RESET_IN_PROGRESS) && (last_scsi_command(shpnt)[ldn] == IM_RESET_IMM_CMD)) {
 			if (cmd_result == IM_CMD_COMPLETED_WITH_FAILURE) {
 				disk_rw_in_progress = 0;
 				PS2_DISK_LED_OFF();
-				reset_status(ihost_index) = IM_RESET_FINISHED_FAIL;
+				reset_status(shpnt) = IM_RESET_FINISHED_FAIL;
 			} else {
 				/*reset disk led counter, turn off disk led */
 				disk_rw_in_progress = 0;
 				PS2_DISK_LED_OFF();
-				reset_status(ihost_index) = IM_RESET_FINISHED_OK;
+				reset_status(shpnt) = IM_RESET_FINISHED_OK;
 			}
-			stat_result(ihost_index) = cmd_result;
-			last_scsi_command(ihost_index)[ldn] = NO_SCSI;
-			last_scsi_type(ihost_index)[ldn] = 0;
-			spin_unlock(dev->host_lock);
+			stat_result(shpnt) = cmd_result;
+			last_scsi_command(shpnt)[ldn] = NO_SCSI;
+			last_scsi_type(shpnt)[ldn] = 0;
+			spin_unlock_irqrestore(shpnt->host_lock, flags);
 			return IRQ_HANDLED;
-		} else if (last_scsi_command(ihost_index)[ldn] == IM_ABORT_IMM_CMD) {
+		} else if (last_scsi_command(shpnt)[ldn] == IM_ABORT_IMM_CMD) {
 			/* react on SCSI abort command */
 #ifdef IM_DEBUG_PROBE
 			printk("IBM MCA SCSI: Interrupt from SCSI-abort.\n");
 #endif
 			disk_rw_in_progress = 0;
 			PS2_DISK_LED_OFF();
-			cmd = ld(ihost_index)[ldn].cmd;
-			ld(ihost_index)[ldn].cmd = NULL;
+			cmd = ld(shpnt)[ldn].cmd;
+			ld(shpnt)[ldn].cmd = NULL;
 			if (cmd_result == IM_CMD_COMPLETED_WITH_FAILURE)
 				cmd->result = DID_NO_CONNECT << 16;
 			else
 				cmd->result = DID_ABORT << 16;
-			stat_result(ihost_index) = cmd_result;
-			last_scsi_command(ihost_index)[ldn] = NO_SCSI;
-			last_scsi_type(ihost_index)[ldn] = 0;
+			stat_result(shpnt) = cmd_result;
+			last_scsi_command(shpnt)[ldn] = NO_SCSI;
+			last_scsi_type(shpnt)[ldn] = 0;
 			if (cmd->scsi_done)
 				(cmd->scsi_done) (cmd);	/* should be the internal_done */
-			spin_unlock(dev->host_lock);
+			spin_unlock_irqrestore(shpnt->host_lock, flags);
 			return IRQ_HANDLED;
 		} else {
 			disk_rw_in_progress = 0;
 			PS2_DISK_LED_OFF();
-			reset_status(ihost_index) = IM_RESET_FINISHED_OK;
-			stat_result(ihost_index) = cmd_result;
-			last_scsi_command(ihost_index)[ldn] = NO_SCSI;
-			spin_unlock(dev->host_lock);
+			reset_status(shpnt) = IM_RESET_FINISHED_OK;
+			stat_result(shpnt) = cmd_result;
+			last_scsi_command(shpnt)[ldn] = NO_SCSI;
+			spin_unlock_irqrestore(shpnt->host_lock, flags);
 			return IRQ_HANDLED;
 		}
 	}
-	last_scsi_command(ihost_index)[ldn] = NO_SCSI;
-	last_scsi_type(ihost_index)[ldn] = 0;
-	cmd = ld(ihost_index)[ldn].cmd;
-	ld(ihost_index)[ldn].cmd = NULL;
+	last_scsi_command(shpnt)[ldn] = NO_SCSI;
+	last_scsi_type(shpnt)[ldn] = 0;
+	cmd = ld(shpnt)[ldn].cmd;
+	ld(shpnt)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_TIMEOUT
 	if (cmd) {
 		if ((cmd->target == TIMEOUT_PUN) && (cmd->device->lun == TIMEOUT_LUN)) {
+			spin_unlock_irqsave(shpnt->host_lock, flags);
 			printk("IBM MCA SCSI: Ignoring interrupt from pun=%x, lun=%x.\n", cmd->target, cmd->device->lun);
 			return IRQ_HANDLED;
 		}
@@ -674,15 +681,15 @@ static irqreturn_t interrupt_handler(int
 	/*if no command structure, just return, else clear cmd */
 	if (!cmd)
 	{
-		spin_unlock(dev->host_lock);
+		spin_unlock_irqrestore(shpnt->host_lock, flags);
 		return IRQ_HANDLED;
 	}
 
 #ifdef IM_DEBUG_INT
-	printk("cmd=%02x ireg=%02x ds=%02x cs=%02x de=%02x ce=%02x\n", cmd->cmnd[0], intr_reg, ld(ihost_index)[ldn].tsb.dev_status, ld(ihost_index)[ldn].tsb.cmd_status, ld(ihost_index)[ldn].tsb.dev_error, ld(ihost_index)[ldn].tsb.cmd_error);
+	printk("cmd=%02x ireg=%02x ds=%02x cs=%02x de=%02x ce=%02x\n", cmd->cmnd[0], intr_reg, ld(shpnt)[ldn].tsb.dev_status, ld(shpnt)[ldn].tsb.cmd_status, ld(shpnt)[ldn].tsb.dev_error, ld(shpnt)[ldn].tsb.cmd_error);
 #endif
 	/*if this is end of media read/write, may turn off PS/2 disk led */
-	if ((ld(ihost_index)[ldn].device_type != TYPE_NO_LUN) && (ld(ihost_index)[ldn].device_type != TYPE_NO_DEVICE)) {
+	if ((ld(shpnt)[ldn].device_type != TYPE_NO_LUN) && (ld(shpnt)[ldn].device_type != TYPE_NO_DEVICE)) {
 		/* only access this, if there was a valid device addressed */
 		if (--disk_rw_in_progress == 0)
 			PS2_DISK_LED_OFF();
@@ -693,8 +700,8 @@ static irqreturn_t interrupt_handler(int
 	 * adapters do not support CMD_TERMINATED, TASK_SET_FULL and
 	 * ACA_ACTIVE as returning statusbyte information. (ML) */
 	if (cmd_result == IM_CMD_COMPLETED_WITH_FAILURE) {
-		cmd->result = (unsigned char) (ld(ihost_index)[ldn].tsb.dev_status & 0x1e);
-		IBM_DS(ihost_index).total_errors++;
+		cmd->result = (unsigned char) (ld(shpnt)[ldn].tsb.dev_status & 0x1e);
+		IBM_DS(shpnt).total_errors++;
 	} else
 		cmd->result = 0;
 	/* write device status into cmd->result, and call done function */
@@ -705,24 +712,25 @@ static irqreturn_t interrupt_handler(int
 		cmd->result |= DID_OK << 16;
 	if (cmd->scsi_done)
 		(cmd->scsi_done) (cmd);
-	spin_unlock(dev->host_lock);
+	spin_unlock_irqrestore(shpnt->host_lock, flags);
 	return IRQ_HANDLED;
 }
 
-static void issue_cmd(int host_index, unsigned long cmd_reg, unsigned char attn_reg)
+static void issue_cmd(struct Scsi_Host *shpnt, unsigned long cmd_reg,
+		      unsigned char attn_reg)
 {
 	unsigned long flags;
 	/* must wait for attention reg not busy */
 	while (1) {
-		spin_lock_irqsave(hosts[host_index]->host_lock, flags);
-		if (!(inb(IM_STAT_REG(host_index)) & IM_BUSY))
+		spin_lock_irqsave(shpnt->host_lock, flags);
+		if (!(inb(IM_STAT_REG(shpnt)) & IM_BUSY))
 			break;
-		spin_unlock_irqrestore(hosts[host_index]->host_lock, flags);
+		spin_unlock_irqrestore(shpnt->host_lock, flags);
 	}
 	/* write registers and enable system interrupts */
-	outl(cmd_reg, IM_CMD_REG(host_index));
-	outb(attn_reg, IM_ATTN_REG(host_index));
-	spin_unlock_irqrestore(hosts[host_index]->host_lock, flags);
+	outl(cmd_reg, IM_CMD_REG(shpnt));
+	outb(attn_reg, IM_ATTN_REG(shpnt));
+	spin_unlock_irqrestore(shpnt->host_lock, flags);
 }
 
 static void internal_done(Scsi_Cmnd * cmd)
@@ -732,34 +740,34 @@ static void internal_done(Scsi_Cmnd * cm
 }
 
 /* SCSI-SCB-command for device_inquiry */
-static int device_inquiry(int host_index, int ldn)
+static int device_inquiry(struct Scsi_Host *shpnt, int ldn)
 {
 	int retr;
 	struct im_scb *scb;
 	struct im_tsb *tsb;
 	unsigned char *buf;
 
-	scb = &(ld(host_index)[ldn].scb);
-	tsb = &(ld(host_index)[ldn].tsb);
-	buf = (unsigned char *) (&(ld(host_index)[ldn].buf));
-	ld(host_index)[ldn].tsb.dev_status = 0;	/* prepare statusblock */
+	scb = &(ld(shpnt)[ldn].scb);
+	tsb = &(ld(shpnt)[ldn].tsb);
+	buf = (unsigned char *) (&(ld(shpnt)[ldn].buf));
+	ld(shpnt)[ldn].tsb.dev_status = 0;	/* prepare statusblock */
 	for (retr = 0; retr < 3; retr++) {
 		/* fill scb with inquiry command */
 		scb->command = IM_DEVICE_INQUIRY_CMD | IM_NO_DISCONNECT;
 		scb->enable = IM_REPORT_TSB_ONLY_ON_ERROR | IM_READ_CONTROL | IM_SUPRESS_EXCEPTION_SHORT | IM_RETRY_ENABLE | IM_BYPASS_BUFFER;
-		last_scsi_command(host_index)[ldn] = IM_DEVICE_INQUIRY_CMD;
-		last_scsi_type(host_index)[ldn] = IM_SCB;
+		last_scsi_command(shpnt)[ldn] = IM_DEVICE_INQUIRY_CMD;
+		last_scsi_type(shpnt)[ldn] = IM_SCB;
 		scb->sys_buf_adr = isa_virt_to_bus(buf);
 		scb->sys_buf_length = 255;	/* maximum bufferlength gives max info */
 		scb->tsb_adr = isa_virt_to_bus(tsb);
 		/* issue scb to passed ldn, and busy wait for interrupt */
-		got_interrupt(host_index) = 0;
-		issue_cmd(host_index, isa_virt_to_bus(scb), IM_SCB | ldn);
-		while (!got_interrupt(host_index))
+		got_interrupt(shpnt) = 0;
+		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | ldn);
+		while (!got_interrupt(shpnt))
 			barrier();
 
 		/*if command successful, break */
-		if ((stat_result(host_index) == IM_SCB_CMD_COMPLETED) || (stat_result(host_index) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
+		if ((stat_result(shpnt) == IM_SCB_CMD_COMPLETED) || (stat_result(shpnt) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
 			return 1;
 	}
 	/*if all three retries failed, return "no device at this ldn" */
@@ -769,34 +777,34 @@ static int device_inquiry(int host_index
 		return 1;
 }
 
-static int read_capacity(int host_index, int ldn)
+static int read_capacity(struct Scsi_Host *shpnt, int ldn)
 {
 	int retr;
 	struct im_scb *scb;
 	struct im_tsb *tsb;
 	unsigned char *buf;
 
-	scb = &(ld(host_index)[ldn].scb);
-	tsb = &(ld(host_index)[ldn].tsb);
-	buf = (unsigned char *) (&(ld(host_index)[ldn].buf));
-	ld(host_index)[ldn].tsb.dev_status = 0;
+	scb = &(ld(shpnt)[ldn].scb);
+	tsb = &(ld(shpnt)[ldn].tsb);
+	buf = (unsigned char *) (&(ld(shpnt)[ldn].buf));
+	ld(shpnt)[ldn].tsb.dev_status = 0;
 	for (retr = 0; retr < 3; retr++) {
 		/*fill scb with read capacity command */
 		scb->command = IM_READ_CAPACITY_CMD;
 		scb->enable = IM_REPORT_TSB_ONLY_ON_ERROR | IM_READ_CONTROL | IM_RETRY_ENABLE | IM_BYPASS_BUFFER;
-		last_scsi_command(host_index)[ldn] = IM_READ_CAPACITY_CMD;
-		last_scsi_type(host_index)[ldn] = IM_SCB;
+		last_scsi_command(shpnt)[ldn] = IM_READ_CAPACITY_CMD;
+		last_scsi_type(shpnt)[ldn] = IM_SCB;
 		scb->sys_buf_adr = isa_virt_to_bus(buf);
 		scb->sys_buf_length = 8;
 		scb->tsb_adr = isa_virt_to_bus(tsb);
 		/*issue scb to passed ldn, and busy wait for interrupt */
-		got_interrupt(host_index) = 0;
-		issue_cmd(host_index, isa_virt_to_bus(scb), IM_SCB | ldn);
-		while (!got_interrupt(host_index))
+		got_interrupt(shpnt) = 0;
+		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | ldn);
+		while (!got_interrupt(shpnt))
 			barrier();
 
 		/*if got capacity, get block length and return one device found */
-		if ((stat_result(host_index) == IM_SCB_CMD_COMPLETED) || (stat_result(host_index) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
+		if ((stat_result(shpnt) == IM_SCB_CMD_COMPLETED) || (stat_result(shpnt) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
 			return 1;
 	}
 	/*if all three retries failed, return "no device at this ldn" */
@@ -806,39 +814,39 @@ static int read_capacity(int host_index,
 		return 1;
 }
 
-static int get_pos_info(int host_index)
+static int get_pos_info(struct Scsi_Host *shpnt)
 {
 	int retr;
 	struct im_scb *scb;
 	struct im_tsb *tsb;
 	unsigned char *buf;
 
-	scb = &(ld(host_index)[MAX_LOG_DEV].scb);
-	tsb = &(ld(host_index)[MAX_LOG_DEV].tsb);
-	buf = (unsigned char *) (&(ld(host_index)[MAX_LOG_DEV].buf));
-	ld(host_index)[MAX_LOG_DEV].tsb.dev_status = 0;
+	scb = &(ld(shpnt)[MAX_LOG_DEV].scb);
+	tsb = &(ld(shpnt)[MAX_LOG_DEV].tsb);
+	buf = (unsigned char *) (&(ld(shpnt)[MAX_LOG_DEV].buf));
+	ld(shpnt)[MAX_LOG_DEV].tsb.dev_status = 0;
 	for (retr = 0; retr < 3; retr++) {
 		/*fill scb with get_pos_info command */
 		scb->command = IM_GET_POS_INFO_CMD;
 		scb->enable = IM_READ_CONTROL | IM_REPORT_TSB_ONLY_ON_ERROR | IM_RETRY_ENABLE | IM_BYPASS_BUFFER;
-		last_scsi_command(host_index)[MAX_LOG_DEV] = IM_GET_POS_INFO_CMD;
-		last_scsi_type(host_index)[MAX_LOG_DEV] = IM_SCB;
+		last_scsi_command(shpnt)[MAX_LOG_DEV] = IM_GET_POS_INFO_CMD;
+		last_scsi_type(shpnt)[MAX_LOG_DEV] = IM_SCB;
 		scb->sys_buf_adr = isa_virt_to_bus(buf);
-		if (special(host_index) == IBM_SCSI2_FW)
+		if (special(shpnt) == IBM_SCSI2_FW)
 			scb->sys_buf_length = 256;	/* get all info from F/W adapter */
 		else
 			scb->sys_buf_length = 18;	/* get exactly 18 bytes for other SCSI */
 		scb->tsb_adr = isa_virt_to_bus(tsb);
 		/*issue scb to ldn=15, and busy wait for interrupt */
-		got_interrupt(host_index) = 0;
-		issue_cmd(host_index, isa_virt_to_bus(scb), IM_SCB | MAX_LOG_DEV);
+		got_interrupt(shpnt) = 0;
+		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | MAX_LOG_DEV);
 		
 		/* FIXME: timeout */
-		while (!got_interrupt(host_index))
+		while (!got_interrupt(shpnt))
 			barrier();
 
 		/*if got POS-stuff, get block length and return one device found */
-		if ((stat_result(host_index) == IM_SCB_CMD_COMPLETED) || (stat_result(host_index) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
+		if ((stat_result(shpnt) == IM_SCB_CMD_COMPLETED) || (stat_result(shpnt) == IM_SCB_CMD_COMPLETED_WITH_RETRIES))
 			return 1;
 	}
 	/* if all three retries failed, return "no device at this ldn" */
@@ -851,14 +859,16 @@ static int get_pos_info(int host_index)
 /* SCSI-immediate-command for assign. This functions maps/unmaps specific
  ldn-numbers on SCSI (PUN,LUN). It is needed for presetting of the
  subsystem and for dynamical remapping od ldns. */
-static int immediate_assign(int host_index, unsigned int pun, unsigned int lun, unsigned int ldn, unsigned int operation)
+static int immediate_assign(struct Scsi_Host *shpnt, unsigned int pun,
+			    unsigned int lun, unsigned int ldn,
+			    unsigned int operation)
 {
 	int retr;
 	unsigned long imm_cmd;
 
 	for (retr = 0; retr < 3; retr++) {
 		/* select mutation level of the SCSI-adapter */
-		switch (special(host_index)) {
+		switch (special(shpnt)) {
 		case IBM_SCSI2_FW:
 			imm_cmd = (unsigned long) (IM_ASSIGN_IMM_CMD);
 			imm_cmd |= (unsigned long) ((lun & 7) << 24);
@@ -867,7 +877,7 @@ static int immediate_assign(int host_ind
 			imm_cmd |= (unsigned long) ((ldn & 15) << 16);
 			break;
 		default:
-			imm_cmd = inl(IM_CMD_REG(host_index));
+			imm_cmd = inl(IM_CMD_REG(shpnt));
 			imm_cmd &= (unsigned long) (0xF8000000);	/* keep reserved bits */
 			imm_cmd |= (unsigned long) (IM_ASSIGN_IMM_CMD);
 			imm_cmd |= (unsigned long) ((lun & 7) << 24);
@@ -876,15 +886,15 @@ static int immediate_assign(int host_ind
 			imm_cmd |= (unsigned long) ((ldn & 15) << 16);
 			break;
 		}
-		last_scsi_command(host_index)[MAX_LOG_DEV] = IM_ASSIGN_IMM_CMD;
-		last_scsi_type(host_index)[MAX_LOG_DEV] = IM_IMM_CMD;
-		got_interrupt(host_index) = 0;
-		issue_cmd(host_index, (unsigned long) (imm_cmd), IM_IMM_CMD | MAX_LOG_DEV);
-		while (!got_interrupt(host_index))
+		last_scsi_command(shpnt)[MAX_LOG_DEV] = IM_ASSIGN_IMM_CMD;
+		last_scsi_type(shpnt)[MAX_LOG_DEV] = IM_IMM_CMD;
+		got_interrupt(shpnt) = 0;
+		issue_cmd(shpnt, (unsigned long) (imm_cmd), IM_IMM_CMD | MAX_LOG_DEV);
+		while (!got_interrupt(shpnt))
 			barrier();
 
 		/*if command successful, break */
-		if (stat_result(host_index) == IM_IMMEDIATE_CMD_COMPLETED)
+		if (stat_result(shpnt) == IM_IMMEDIATE_CMD_COMPLETED)
 			return 1;
 	}
 	if (retr >= 3)
@@ -893,7 +903,7 @@ static int immediate_assign(int host_ind
 		return 1;
 }
 
-static int immediate_feature(int host_index, unsigned int speed, unsigned int timeout)
+static int immediate_feature(struct Scsi_Host *shpnt, unsigned int speed, unsigned int timeout)
 {
 	int retr;
 	unsigned long imm_cmd;
@@ -903,16 +913,16 @@ static int immediate_feature(int host_in
 		imm_cmd = IM_FEATURE_CTR_IMM_CMD;
 		imm_cmd |= (unsigned long) ((speed & 0x7) << 29);
 		imm_cmd |= (unsigned long) ((timeout & 0x1fff) << 16);
-		last_scsi_command(host_index)[MAX_LOG_DEV] = IM_FEATURE_CTR_IMM_CMD;
-		last_scsi_type(host_index)[MAX_LOG_DEV] = IM_IMM_CMD;
-		got_interrupt(host_index) = 0;
+		last_scsi_command(shpnt)[MAX_LOG_DEV] = IM_FEATURE_CTR_IMM_CMD;
+		last_scsi_type(shpnt)[MAX_LOG_DEV] = IM_IMM_CMD;
+		got_interrupt(shpnt) = 0;
 		/* we need to run into command errors in order to probe for the
 		 * right speed! */
 		global_command_error_excuse = 1;
-		issue_cmd(host_index, (unsigned long) (imm_cmd), IM_IMM_CMD | MAX_LOG_DEV);
+		issue_cmd(shpnt, (unsigned long) (imm_cmd), IM_IMM_CMD | MAX_LOG_DEV);
 		
 		/* FIXME: timeout */
-		while (!got_interrupt(host_index))
+		while (!got_interrupt(shpnt))
 			barrier();
 		if (global_command_error_excuse == CMD_FAIL) {
 			global_command_error_excuse = 0;
@@ -920,7 +930,7 @@ static int immediate_feature(int host_in
 		} else
 			global_command_error_excuse = 0;
 		/*if command successful, break */
-		if (stat_result(host_index) == IM_IMMEDIATE_CMD_COMPLETED)
+		if (stat_result(shpnt) == IM_IMMEDIATE_CMD_COMPLETED)
 			return 1;
 	}
 	if (retr >= 3)
@@ -930,35 +940,35 @@ static int immediate_feature(int host_in
 }
 
 #ifdef CONFIG_IBMMCA_SCSI_DEV_RESET
-static int immediate_reset(int host_index, unsigned int ldn)
+static int immediate_reset(struct Scsi_Host *shpnt, unsigned int ldn)
 {
 	int retries;
 	int ticks;
 	unsigned long imm_command;
 
 	for (retries = 0; retries < 3; retries++) {
-		imm_command = inl(IM_CMD_REG(host_index));
+		imm_command = inl(IM_CMD_REG(shpnt));
 		imm_command &= (unsigned long) (0xFFFF0000);	/* keep reserved bits */
 		imm_command |= (unsigned long) (IM_RESET_IMM_CMD);
-		last_scsi_command(host_index)[ldn] = IM_RESET_IMM_CMD;
-		last_scsi_type(host_index)[ldn] = IM_IMM_CMD;
-		got_interrupt(host_index) = 0;
-		reset_status(host_index) = IM_RESET_IN_PROGRESS;
-		issue_cmd(host_index, (unsigned long) (imm_command), IM_IMM_CMD | ldn);
+		last_scsi_command(shpnt)[ldn] = IM_RESET_IMM_CMD;
+		last_scsi_type(shpnt)[ldn] = IM_IMM_CMD;
+		got_interrupt(shpnt) = 0;
+		reset_status(shpnt) = IM_RESET_IN_PROGRESS;
+		issue_cmd(shpnt, (unsigned long) (imm_command), IM_IMM_CMD | ldn);
 		ticks = IM_RESET_DELAY * HZ;
-		while (reset_status(host_index) == IM_RESET_IN_PROGRESS && --ticks) {
+		while (reset_status(shpnt) == IM_RESET_IN_PROGRESS && --ticks) {
 			udelay((1 + 999 / HZ) * 1000);
 			barrier();
 		}
 		/* if reset did not complete, just complain */
 		if (!ticks) {
 			printk(KERN_ERR "IBM MCA SCSI: reset did not complete within %d seconds.\n", IM_RESET_DELAY);
-			reset_status(host_index) = IM_RESET_FINISHED_OK;
+			reset_status(shpnt) = IM_RESET_FINISHED_OK;
 			/* did not work, finish */
 			return 1;
 		}
 		/*if command successful, break */
-		if (stat_result(host_index) == IM_IMMEDIATE_CMD_COMPLETED)
+		if (stat_result(shpnt) == IM_IMMEDIATE_CMD_COMPLETED)
 			return 1;
 	}
 	if (retries >= 3)
@@ -1060,35 +1070,35 @@ static int probe_display(int what)
 	return 0;
 }
 
-static int probe_bus_mode(int host_index)
+static int probe_bus_mode(struct Scsi_Host *shpnt)
 {
 	struct im_pos_info *info;
 	int num_bus = 0;
 	int ldn;
 
-	info = (struct im_pos_info *) (&(ld(host_index)[MAX_LOG_DEV].buf));
-	if (get_pos_info(host_index)) {
+	info = (struct im_pos_info *) (&(ld(shpnt)[MAX_LOG_DEV].buf));
+	if (get_pos_info(shpnt)) {
 		if (info->connector_size & 0xf000)
-			subsystem_connector_size(host_index) = 16;
+			subsystem_connector_size(shpnt) = 16;
 		else
-			subsystem_connector_size(host_index) = 32;
+			subsystem_connector_size(shpnt) = 32;
 		num_bus |= (info->pos_4b & 8) >> 3;
 		for (ldn = 0; ldn <= MAX_LOG_DEV; ldn++) {
-			if ((special(host_index) == IBM_SCSI_WCACHE) || (special(host_index) == IBM_7568_WCACHE)) {
+			if ((special(shpnt) == IBM_SCSI_WCACHE) || (special(shpnt) == IBM_7568_WCACHE)) {
 				if (!((info->cache_stat >> ldn) & 1))
-					ld(host_index)[ldn].cache_flag = 0;
+					ld(shpnt)[ldn].cache_flag = 0;
 			}
 			if (!((info->retry_stat >> ldn) & 1))
-				ld(host_index)[ldn].retry_flag = 0;
+				ld(shpnt)[ldn].retry_flag = 0;
 		}
 #ifdef IM_DEBUG_PROBE
 		printk("IBM MCA SCSI: SCSI-Cache bits: ");
 		for (ldn = 0; ldn <= MAX_LOG_DEV; ldn++) {
-			printk("%d", ld(host_index)[ldn].cache_flag);
+			printk("%d", ld(shpnt)[ldn].cache_flag);
 		}
 		printk("\nIBM MCA SCSI: SCSI-Retry bits: ");
 		for (ldn = 0; ldn <= MAX_LOG_DEV; ldn++) {
-			printk("%d", ld(host_index)[ldn].retry_flag);
+			printk("%d", ld(shpnt)[ldn].retry_flag);
 		}
 		printk("\n");
 #endif
@@ -1097,7 +1107,7 @@ static int probe_bus_mode(int host_index
 }
 
 /* probing scsi devices */
-static void check_devices(int host_index, int adaptertype)
+static void check_devices(struct Scsi_Host *shpnt, int adaptertype)
 {
 	int id, lun, ldn, ticks;
 	int count_devices;	/* local counter for connected device */
@@ -1108,24 +1118,24 @@ static void check_devices(int host_index
 	/* assign default values to certain variables */
 	ticks = 0;
 	count_devices = 0;
-	IBM_DS(host_index).dyn_flag = 0;	/* normally no need for dynamical ldn management */
-	IBM_DS(host_index).total_errors = 0;	/* set errorcounter to 0 */
-	next_ldn(host_index) = 7;	/* next ldn to be assigned is 7, because 0-6 is 'hardwired' */
+	IBM_DS(shpnt).dyn_flag = 0;	/* normally no need for dynamical ldn management */
+	IBM_DS(shpnt).total_errors = 0;	/* set errorcounter to 0 */
+	next_ldn(shpnt) = 7;	/* next ldn to be assigned is 7, because 0-6 is 'hardwired' */
 
 	/* initialize the very important driver-informational arrays/structs */
-	memset(ld(host_index), 0, sizeof(ld(host_index)));
+	memset(ld(shpnt), 0, sizeof(ld(shpnt)));
 	for (ldn = 0; ldn <= MAX_LOG_DEV; ldn++) {
-		last_scsi_command(host_index)[ldn] = NO_SCSI;	/* emptify last SCSI-command storage */
-		last_scsi_type(host_index)[ldn] = 0;
-		ld(host_index)[ldn].cache_flag = 1;
-		ld(host_index)[ldn].retry_flag = 1;
+		last_scsi_command(shpnt)[ldn] = NO_SCSI;	/* emptify last SCSI-command storage */
+		last_scsi_type(shpnt)[ldn] = 0;
+		ld(shpnt)[ldn].cache_flag = 1;
+		ld(shpnt)[ldn].retry_flag = 1;
 	}
-	memset(get_ldn(host_index), TYPE_NO_DEVICE, sizeof(get_ldn(host_index)));	/* this is essential ! */
-	memset(get_scsi(host_index), TYPE_NO_DEVICE, sizeof(get_scsi(host_index)));	/* this is essential ! */
+	memset(get_ldn(shpnt), TYPE_NO_DEVICE, sizeof(get_ldn(shpnt)));	/* this is essential ! */
+	memset(get_scsi(shpnt), TYPE_NO_DEVICE, sizeof(get_scsi(shpnt)));	/* this is essential ! */
 	for (lun = 0; lun < 8; lun++) {
 		/* mark the adapter at its pun on all luns */
-		get_scsi(host_index)[subsystem_pun(host_index)][lun] = TYPE_IBM_SCSI_ADAPTER;
-		get_ldn(host_index)[subsystem_pun(host_index)][lun] = MAX_LOG_DEV;	/* make sure, the subsystem
+		get_scsi(shpnt)[subsystem_pun(shpnt)][lun] = TYPE_IBM_SCSI_ADAPTER;
+		get_ldn(shpnt)[subsystem_pun(shpnt)][lun] = MAX_LOG_DEV;	/* make sure, the subsystem
 											   ldn is active for all
 											   luns. */
 	}
@@ -1134,9 +1144,9 @@ static void check_devices(int host_index
 	/* monitor connected on model XX95. */
 
 	/* STEP 1: */
-	adapter_speed(host_index) = global_adapter_speed;
-	speedrun = adapter_speed(host_index);
-	while (immediate_feature(host_index, speedrun, adapter_timeout) == 2) {
+	adapter_speed(shpnt) = global_adapter_speed;
+	speedrun = adapter_speed(shpnt);
+	while (immediate_feature(shpnt, speedrun, adapter_timeout) == 2) {
 		probe_display(1);
 		if (speedrun == 7)
 			panic("IBM MCA SCSI: Cannot set Synchronous-Transfer-Rate!\n");
@@ -1144,30 +1154,30 @@ static void check_devices(int host_index
 		if (speedrun > 7)
 			speedrun = 7;
 	}
-	adapter_speed(host_index) = speedrun;
+	adapter_speed(shpnt) = speedrun;
 	/* Get detailed information about the current adapter, necessary for
 	 * device operations: */
-	num_bus = probe_bus_mode(host_index);
+	num_bus = probe_bus_mode(shpnt);
 
 	/* num_bus contains only valid data for the F/W adapter! */
 	if (adaptertype == IBM_SCSI2_FW) {	/* F/W SCSI adapter: */
 		/* F/W adapter PUN-space extension evaluation: */
 		if (num_bus) {
 			printk(KERN_INFO "IBM MCA SCSI: Separate bus mode (wide-addressing enabled)\n");
-			subsystem_maxid(host_index) = 16;
+			subsystem_maxid(shpnt) = 16;
 		} else {
 			printk(KERN_INFO "IBM MCA SCSI: Combined bus mode (wide-addressing disabled)\n");
-			subsystem_maxid(host_index) = 8;
+			subsystem_maxid(shpnt) = 8;
 		}
 		printk(KERN_INFO "IBM MCA SCSI: Sync.-Rate (F/W: 20, Int.: 10, Ext.: %s) MBytes/s\n", ibmrate(speedrun, adaptertype));
 	} else			/* all other IBM SCSI adapters: */
 		printk(KERN_INFO "IBM MCA SCSI: Synchronous-SCSI-Transfer-Rate: %s MBytes/s\n", ibmrate(speedrun, adaptertype));
 
 	/* assign correct PUN device space */
-	max_pun = subsystem_maxid(host_index);
+	max_pun = subsystem_maxid(shpnt);
 
 #ifdef IM_DEBUG_PROBE
-	printk("IBM MCA SCSI: Current SCSI-host index: %d\n", host_index);
+	printk("IBM MCA SCSI: Current SCSI-host index: %d\n", shpnt);
 	printk("IBM MCA SCSI: Removing default logical SCSI-device mapping.");
 #else
 	printk(KERN_INFO "IBM MCA SCSI: Dev. Order: %s, Mapping (takes <2min): ", (ibm_ansi_order) ? "ANSI" : "New");
@@ -1177,7 +1187,7 @@ static void check_devices(int host_index
 #ifdef IM_DEBUG_PROBE
 		printk(".");
 #endif
-		immediate_assign(host_index, 0, 0, ldn, REMOVE_LDN);	/* remove ldn (wherever) */
+		immediate_assign(shpnt, 0, 0, ldn, REMOVE_LDN);	/* remove ldn (wherever) */
 	}
 	lun = 0;		/* default lun is 0 */
 #ifndef IM_DEBUG_PROBE
@@ -1196,18 +1206,18 @@ static void check_devices(int host_index
 #ifdef IM_DEBUG_PROBE
 			printk(".");
 #endif
-			if (id != subsystem_pun(host_index)) {
+			if (id != subsystem_pun(shpnt)) {
 				/* if pun is not the adapter: */
 				/* set ldn=0 to pun,lun */
-				immediate_assign(host_index, id, lun, PROBE_LDN, SET_LDN);
-				if (device_inquiry(host_index, PROBE_LDN)) {	/* probe device */
-					get_scsi(host_index)[id][lun] = (unsigned char) (ld(host_index)[PROBE_LDN].buf[0]);
+				immediate_assign(shpnt, id, lun, PROBE_LDN, SET_LDN);
+				if (device_inquiry(shpnt, PROBE_LDN)) {	/* probe device */
+					get_scsi(shpnt)[id][lun] = (unsigned char) (ld(shpnt)[PROBE_LDN].buf[0]);
 					/* entry, even for NO_LUN */
-					if (ld(host_index)[PROBE_LDN].buf[0] != TYPE_NO_LUN)
+					if (ld(shpnt)[PROBE_LDN].buf[0] != TYPE_NO_LUN)
 						count_devices++;	/* a existing device is found */
 				}
 				/* remove ldn */
-				immediate_assign(host_index, id, lun, PROBE_LDN, REMOVE_LDN);
+				immediate_assign(shpnt, id, lun, PROBE_LDN, REMOVE_LDN);
 			}
 		}
 #ifndef IM_DEBUG_PROBE
@@ -1227,16 +1237,16 @@ static void check_devices(int host_index
 #ifdef IM_DEBUG_PROBE
 			printk(".");
 #endif
-			if (id != subsystem_pun(host_index)) {
-				if (get_scsi(host_index)[id][lun] != TYPE_NO_LUN && get_scsi(host_index)[id][lun] != TYPE_NO_DEVICE) {
+			if (id != subsystem_pun(shpnt)) {
+				if (get_scsi(shpnt)[id][lun] != TYPE_NO_LUN && get_scsi(shpnt)[id][lun] != TYPE_NO_DEVICE) {
 					/* Only map if accepted type. Always enter for
 					   lun == 0 to get no gaps into ldn-mapping for ldn<7. */
-					immediate_assign(host_index, id, lun, ldn, SET_LDN);
-					get_ldn(host_index)[id][lun] = ldn;	/* map ldn */
-					if (device_exists(host_index, ldn, &ld(host_index)[ldn].block_length, &ld(host_index)[ldn].device_type)) {
+					immediate_assign(shpnt, id, lun, ldn, SET_LDN);
+					get_ldn(shpnt)[id][lun] = ldn;	/* map ldn */
+					if (device_exists(shpnt, ldn, &ld(shpnt)[ldn].block_length, &ld(shpnt)[ldn].device_type)) {
 #ifdef CONFIG_IBMMCA_SCSI_DEV_RESET
 						printk("resetting device at ldn=%x ... ", ldn);
-						immediate_reset(host_index, ldn);
+						immediate_reset(shpnt, ldn);
 #endif
 						ldn++;
 					} else {
@@ -1244,15 +1254,15 @@ static void check_devices(int host_index
 						 * handle it or because it has problems */
 						if (lun > 0) {
 							/* remove mapping */
-							get_ldn(host_index)[id][lun] = TYPE_NO_DEVICE;
-							immediate_assign(host_index, 0, 0, ldn, REMOVE_LDN);
+							get_ldn(shpnt)[id][lun] = TYPE_NO_DEVICE;
+							immediate_assign(shpnt, 0, 0, ldn, REMOVE_LDN);
 						} else
 							ldn++;
 					}
 				} else if (lun == 0) {
 					/* map lun == 0, even if no device exists */
-					immediate_assign(host_index, id, lun, ldn, SET_LDN);
-					get_ldn(host_index)[id][lun] = ldn;	/* map ldn */
+					immediate_assign(shpnt, id, lun, ldn, SET_LDN);
+					get_ldn(shpnt)[id][lun] = ldn;	/* map ldn */
 					ldn++;
 				}
 			}
@@ -1262,14 +1272,14 @@ static void check_devices(int host_index
 	/* map remaining ldns to non-existing devices */
 	for (lun = 1; lun < 8 && ldn < MAX_LOG_DEV; lun++)
 		for (id = 0; id < max_pun && ldn < MAX_LOG_DEV; id++) {
-			if (get_scsi(host_index)[id][lun] == TYPE_NO_LUN || get_scsi(host_index)[id][lun] == TYPE_NO_DEVICE) {
+			if (get_scsi(shpnt)[id][lun] == TYPE_NO_LUN || get_scsi(shpnt)[id][lun] == TYPE_NO_DEVICE) {
 				probe_display(1);
 				/* Map remaining ldns only to NON-existing pun,lun
 				   combinations to make sure an inquiry will fail.
 				   For MULTI_LUN, it is needed to avoid adapter autonome
 				   SCSI-remapping. */
-				immediate_assign(host_index, id, lun, ldn, SET_LDN);
-				get_ldn(host_index)[id][lun] = ldn;
+				immediate_assign(shpnt, id, lun, ldn, SET_LDN);
+				get_ldn(shpnt)[id][lun] = ldn;
 				ldn++;
 			}
 		}
@@ -1292,51 +1302,51 @@ static void check_devices(int host_index
 	for (id = 0; id < max_pun; id++) {
 		printk("%2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			printk("%2s ", ti_p(get_scsi(host_index)[id][lun]));
+			printk("%2s ", ti_p(get_scsi(shpnt)[id][lun]));
 		printk("      %2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			printk("%2s ", ti_l(get_ldn(host_index)[id][lun]));
+			printk("%2s ", ti_l(get_ldn(shpnt)[id][lun]));
 		printk("\n");
 	}
 #endif
 
 	/* assign total number of found SCSI-devices to the statistics struct */
-	IBM_DS(host_index).total_scsi_devices = count_devices;
+	IBM_DS(shpnt).total_scsi_devices = count_devices;
 
 	/* decide for output in /proc-filesystem, if the configuration of
 	   SCSI-devices makes dynamical reassignment of devices necessary */
 	if (count_devices >= MAX_LOG_DEV)
-		IBM_DS(host_index).dyn_flag = 1;	/* dynamical assignment is necessary */
+		IBM_DS(shpnt).dyn_flag = 1;	/* dynamical assignment is necessary */
 	else
-		IBM_DS(host_index).dyn_flag = 0;	/* dynamical assignment is not necessary */
+		IBM_DS(shpnt).dyn_flag = 0;	/* dynamical assignment is not necessary */
 
 	/* If no SCSI-devices are assigned, return 1 in order to cause message. */
 	if (ldn == 0)
 		printk("IBM MCA SCSI: Warning: No SCSI-devices found/assigned!\n");
 
 	/* reset the counters for statistics on the current adapter */
-	IBM_DS(host_index).scbs = 0;
-	IBM_DS(host_index).long_scbs = 0;
-	IBM_DS(host_index).total_accesses = 0;
-	IBM_DS(host_index).total_interrupts = 0;
-	IBM_DS(host_index).dynamical_assignments = 0;
-	memset(IBM_DS(host_index).ldn_access, 0x0, sizeof(IBM_DS(host_index).ldn_access));
-	memset(IBM_DS(host_index).ldn_read_access, 0x0, sizeof(IBM_DS(host_index).ldn_read_access));
-	memset(IBM_DS(host_index).ldn_write_access, 0x0, sizeof(IBM_DS(host_index).ldn_write_access));
-	memset(IBM_DS(host_index).ldn_inquiry_access, 0x0, sizeof(IBM_DS(host_index).ldn_inquiry_access));
-	memset(IBM_DS(host_index).ldn_modeselect_access, 0x0, sizeof(IBM_DS(host_index).ldn_modeselect_access));
-	memset(IBM_DS(host_index).ldn_assignments, 0x0, sizeof(IBM_DS(host_index).ldn_assignments));
+	IBM_DS(shpnt).scbs = 0;
+	IBM_DS(shpnt).long_scbs = 0;
+	IBM_DS(shpnt).total_accesses = 0;
+	IBM_DS(shpnt).total_interrupts = 0;
+	IBM_DS(shpnt).dynamical_assignments = 0;
+	memset(IBM_DS(shpnt).ldn_access, 0x0, sizeof(IBM_DS(shpnt).ldn_access));
+	memset(IBM_DS(shpnt).ldn_read_access, 0x0, sizeof(IBM_DS(shpnt).ldn_read_access));
+	memset(IBM_DS(shpnt).ldn_write_access, 0x0, sizeof(IBM_DS(shpnt).ldn_write_access));
+	memset(IBM_DS(shpnt).ldn_inquiry_access, 0x0, sizeof(IBM_DS(shpnt).ldn_inquiry_access));
+	memset(IBM_DS(shpnt).ldn_modeselect_access, 0x0, sizeof(IBM_DS(shpnt).ldn_modeselect_access));
+	memset(IBM_DS(shpnt).ldn_assignments, 0x0, sizeof(IBM_DS(shpnt).ldn_assignments));
 	probe_display(0);
 	return;
 }
 
-static int device_exists(int host_index, int ldn, int *block_length, int *device_type)
+static int device_exists(struct Scsi_Host *shpnt, int ldn, int *block_length, int *device_type)
 {
 	unsigned char *buf;
 	/* if no valid device found, return immediately with 0 */
-	if (!(device_inquiry(host_index, ldn)))
+	if (!(device_inquiry(shpnt, ldn)))
 		return 0;
-	buf = (unsigned char *) (&(ld(host_index)[ldn].buf));
+	buf = (unsigned char *) (&(ld(shpnt)[ldn].buf));
 	if (*buf == TYPE_ROM) {
 		*device_type = TYPE_ROM;
 		*block_length = 2048;	/* (standard blocksize for yellow-/red-book) */
@@ -1349,7 +1359,7 @@ static int device_exists(int host_index,
 	}
 	if (*buf == TYPE_DISK) {
 		*device_type = TYPE_DISK;
-		if (read_capacity(host_index, ldn)) {
+		if (read_capacity(shpnt, ldn)) {
 			*block_length = *(buf + 7) + (*(buf + 6) << 8) + (*(buf + 5) << 16) + (*(buf + 4) << 24);
 			return 1;
 		} else
@@ -1357,7 +1367,7 @@ static int device_exists(int host_index,
 	}
 	if (*buf == TYPE_MOD) {
 		*device_type = TYPE_MOD;
-		if (read_capacity(host_index, ldn)) {
+		if (read_capacity(shpnt, ldn)) {
 			*block_length = *(buf + 7) + (*(buf + 6) << 8) + (*(buf + 5) << 16) + (*(buf + 4) << 24);
 			return 1;
 		} else
@@ -1430,6 +1440,9 @@ static void internal_ibmmca_scsi_setup(c
 	return;
 }
 
+#if 0
+ FIXME NEED TO MOVE TO SYSFS
+
 static int ibmmca_getinfo(char *buf, int slot, void *dev_id)
 {
 	struct Scsi_Host *shpnt;
@@ -1480,58 +1493,34 @@ static int ibmmca_getinfo(char *buf, int
 
 	return len;
 }
+#endif
 
-int ibmmca_detect(struct scsi_host_template * scsi_template)
+static struct scsi_host_template ibmmca_driver_template = {
+          .proc_name      = "ibmmca",
+	  .proc_info	  = ibmmca_proc_info,
+          .name           = "IBM SCSI-Subsystem",
+          .queuecommand   = ibmmca_queuecommand,
+	  .eh_abort_handler = ibmmca_abort,
+	  .eh_host_reset_handler = ibmmca_host_reset,
+          .bios_param     = ibmmca_biosparam,
+          .can_queue      = 16,
+          .this_id        = 7,
+          .sg_tablesize   = 16,
+          .cmd_per_lun    = 1,
+          .use_clustering = ENABLE_CLUSTERING,
+};
+
+static int ibmmca_probe(struct device *dev)
 {
 	struct Scsi_Host *shpnt;
-	int port, id, i, j, k, slot;
-	int devices_on_irq_11 = 0;
-	int devices_on_irq_14 = 0;
-	int IRQ14_registered = 0;
-	int IRQ11_registered = 0;
-
-	found = 0;		/* make absolutely sure, that found is set to 0 */
+	int port, id, i, j, k, irq, enabled, ret = -EINVAL;
+	struct mca_device *mca_dev = to_mca_device(dev);
+	const char *description = ibmmca_description[mca_dev->index];
 
 	/* First of all, print the version number of the driver. This is
 	 * important to allow better user bugreports in case of already
 	 * having problems with the MCA_bus probing. */
 	printk(KERN_INFO "IBM MCA SCSI: Version %s\n", IBMMCA_SCSI_DRIVER_VERSION);
-	/* if this is not MCA machine, return "nothing found" */
-	if (!MCA_bus) {
-		printk(KERN_INFO "IBM MCA SCSI:  No Microchannel-bus present --> Aborting.\n" "      	     This machine does not have any IBM MCA-bus\n" "    	     or the MCA-Kernel-support is not enabled!\n");
-		return 0;
-	}
-
-#ifdef MODULE
-	/* If the driver is run as module, read from conf.modules or cmd-line */
-	if (boot_options)
-		option_setup(boot_options);
-#endif
-
-	/* get interrupt request level */
-	if (request_irq(IM_IRQ, interrupt_handler, IRQF_SHARED, "ibmmcascsi", hosts)) {
-		printk(KERN_ERR "IBM MCA SCSI: Unable to get shared IRQ %d.\n", IM_IRQ);
-		return 0;
-	} else
-		IRQ14_registered++;
-
-	/* if ibmmcascsi setup option was passed to kernel, return "found" */
-	for (i = 0; i < IM_MAX_HOSTS; i++)
-		if (io_port[i] > 0 && scsi_id[i] >= 0 && scsi_id[i] < 8) {
-			printk("IBM MCA SCSI: forced detected SCSI Adapter, io=0x%x, scsi id=%d.\n", io_port[i], scsi_id[i]);
-			if ((shpnt = ibmmca_register(scsi_template, io_port[i], scsi_id[i], FORCED_DETECTION, "forced detected SCSI Adapter"))) {
-				for (k = 2; k < 7; k++)
-					((struct ibmmca_hostdata *) shpnt->hostdata)->_pos[k] = 0;
-				((struct ibmmca_hostdata *) shpnt->hostdata)->_special = FORCED_DETECTION;
-				mca_set_adapter_name(MCA_INTEGSCSI, "forced detected SCSI Adapter");
-				mca_set_adapter_procfn(MCA_INTEGSCSI, (MCA_ProcFn) ibmmca_getinfo, shpnt);
-				mca_mark_as_used(MCA_INTEGSCSI);
-				devices_on_irq_14++;
-			}
-		}
-	if (found)
-		return found;
-
 	/* The POS2-register of all PS/2 model SCSI-subsystems has the following
 	 * interpretation of bits:
 	 *                             Bit 7 - 4 : Chip Revision ID (Release)
@@ -1558,7 +1547,14 @@ int ibmmca_detect(struct scsi_host_templ
 
 	/* first look for the IBM SCSI integrated subsystem on the motherboard */
 	for (j = 0; j < 8; j++)	/* read the pos-information */
-		pos[j] = mca_read_stored_pos(MCA_INTEGSCSI, j);
+		pos[j] = mca_device_read_pos(mca_dev, j);
+	id = (pos[3] & 0xe0) >> 5; /* this is correct and represents the PUN */
+	enabled = (pos[2] &0x01);
+	if (!enabled) {
+		printk(KERN_WARNING "IBM MCA SCSI: WARNING - Your SCSI-subsystem is disabled!\n");
+		printk(KERN_WARNING "              SCSI-operations may not work.\n");
+	}
+
 	/* pos2 = pos3 = 0xff if there is no integrated SCSI-subsystem present, but
 	 * if we ignore the settings of all surrounding pos registers, it is not
 	 * completely sufficient to only check pos2 and pos3. */
@@ -1566,232 +1562,137 @@ int ibmmca_detect(struct scsi_host_templ
 	 * make sure, we see a real integrated onboard SCSI-interface and no
 	 * internal system information, which gets mapped to some pos registers
 	 * on models 95xx. */
-	if ((!pos[0] && !pos[1] && pos[2] > 0 && pos[3] > 0 && !pos[4] && !pos[5] && !pos[6] && !pos[7]) || (pos[0] == 0xff && pos[1] == 0xff && pos[2] < 0xff && pos[3] < 0xff && pos[4] == 0xff && pos[5] == 0xff && pos[6] == 0xff && pos[7] == 0xff)) {
-		if ((pos[2] & 1) == 1)	/* is the subsystem chip enabled ? */
-			port = IM_IO_PORT;
-		else {		/* if disabled, no IRQs will be generated, as the chip won't
-				 * listen to the incoming commands and will do really nothing,
-				 * except for listening to the pos-register settings. If this
-				 * happens, I need to hugely think about it, as one has to
-				 * write something to the MCA-Bus pos register in order to
-				 * enable the chip. Normally, IBM-SCSI won't pass the POST,
-				 * when the chip is disabled (see IBM tech. ref.). */
-			port = IM_IO_PORT;	/* anyway, set the portnumber and warn */
-			printk("IBM MCA SCSI: WARNING - Your SCSI-subsystem is disabled!\n" "              SCSI-operations may not work.\n");
-		}
-		id = (pos[3] & 0xe0) >> 5;	/* this is correct and represents the PUN */
-		/* give detailed information on the subsystem. This helps me
-		 * additionally during debugging and analyzing bug-reports. */
-		printk(KERN_INFO "IBM MCA SCSI: IBM Integrated SCSI Controller ffound, io=0x%x, scsi id=%d,\n", port, id);
-		printk(KERN_INFO "              chip rev.=%d, 8K NVRAM=%s, subsystem=%s\n", ((pos[2] & 0xf0) >> 4), (pos[2] & 2) ? "locked" : "accessible", (pos[2] & 1) ? "enabled." : "disabled.");
-
-		/* register the found integrated SCSI-subsystem */
-		if ((shpnt = ibmmca_register(scsi_template, port, id, INTEGRATED_SCSI, "IBM Integrated SCSI Controller"))) 
-		{
-			for (k = 2; k < 7; k++)
-				((struct ibmmca_hostdata *) shpnt->hostdata)->_pos[k] = pos[k];
-			((struct ibmmca_hostdata *) shpnt->hostdata)->_special = INTEGRATED_SCSI;
-			mca_set_adapter_name(MCA_INTEGSCSI, "IBM Integrated SCSI Controller");
-			mca_set_adapter_procfn(MCA_INTEGSCSI, (MCA_ProcFn) ibmmca_getinfo, shpnt);
-			mca_mark_as_used(MCA_INTEGSCSI);
-			devices_on_irq_14++;
+	if (mca_dev->slot == MCA_INTEGSCSI &&
+	    ((!pos[0] && !pos[1] && pos[2] > 0 &&
+	      pos[3] > 0 && !pos[4] && !pos[5] &&
+	      !pos[6] && !pos[7]) ||
+	     (pos[0] == 0xff && pos[1] == 0xff &&
+	      pos[2] < 0xff && pos[3] < 0xff &&
+	      pos[4] == 0xff && pos[5] == 0xff &&
+	      pos[6] == 0xff && pos[7] == 0xff))) {
+		irq = IM_IRQ;
+		port = IM_IO_PORT;
+	} else {
+		irq = IM_IRQ;
+		port = IM_IO_PORT + ((pos[2] &0x0e) << 2);
+		if ((mca_dev->index == IBM_SCSI2_FW) && (pos[6] != 0)) {
+			printk(KERN_ERR "IBM MCA SCSI: ERROR - Wrong POS(6)-register setting!\n");
+			printk(KERN_ERR "              Impossible to determine adapter PUN!\n");
+			printk(KERN_ERR "              Guessing adapter PUN = 7.\n");
+			id = 7;
+		} else {
+			id = (pos[3] & 0xe0) >> 5;	/* get subsystem PUN */
+			if (mca_dev->index == IBM_SCSI2_FW) {
+				id |= (pos[3] & 0x10) >> 1;	/* get subsystem PUN high-bit
+								 * for F/W adapters */
+			}
+		}
+		if ((mca_dev->index == IBM_SCSI2_FW) &&
+		    (pos[4] & 0x01) && (pos[6] == 0)) {
+			/* IRQ11 is used by SCSI-2 F/W Adapter/A */
+			printk(KERN_DEBUG "IBM MCA SCSI: SCSI-2 F/W adapter needs IRQ 11.\n");
+			irq = IM_IRQ_FW;
 		}
 	}
 
-	/* now look for other adapters in MCA slots, */
-	/* determine the number of known IBM-SCSI-subsystem types */
-	/* see the pos[2] dependence to get the adapter port-offset. */
-	for (i = 0; i < ARRAY_SIZE(subsys_list); i++) {
-		/* scan each slot for a fitting adapter id */
-		slot = 0;	/* start at slot 0 */
-		while ((slot = mca_find_adapter(subsys_list[i].mca_id, slot))
-		       != MCA_NOTFOUND) {	/* scan through all slots */
-			for (j = 0; j < 8; j++)	/* read the pos-information */
-				pos[j] = mca_read_stored_pos(slot, j);
-			if ((pos[2] & 1) == 1)
-				/* is the subsystem chip enabled ? */
-				/* (explanations see above) */
-				port = IM_IO_PORT + ((pos[2] & 0x0e) << 2);
-			else {
-				/* anyway, set the portnumber and warn */
-				port = IM_IO_PORT + ((pos[2] & 0x0e) << 2);
-				printk(KERN_WARNING "IBM MCA SCSI: WARNING - Your SCSI-subsystem is disabled!\n");
-				printk(KERN_WARNING "              SCSI-operations may not work.\n");
-			}
-			if ((i == IBM_SCSI2_FW) && (pos[6] != 0)) {
-				printk(KERN_ERR "IBM MCA SCSI: ERROR - Wrong POS(6)-register setting!\n");
-				printk(KERN_ERR "              Impossible to determine adapter PUN!\n");
-				printk(KERN_ERR "              Guessing adapter PUN = 7.\n");
-				id = 7;
-			} else {
-				id = (pos[3] & 0xe0) >> 5;	/* get subsystem PUN */
-				if (i == IBM_SCSI2_FW) {
-					id |= (pos[3] & 0x10) >> 1;	/* get subsystem PUN high-bit
-									 * for F/W adapters */
-				}
-			}
-			if ((i == IBM_SCSI2_FW) && (pos[4] & 0x01) && (pos[6] == 0)) {
-				/* IRQ11 is used by SCSI-2 F/W Adapter/A */
-				printk(KERN_DEBUG "IBM MCA SCSI: SCSI-2 F/W adapter needs IRQ 11.\n");
-				/* get interrupt request level */
-				if (request_irq(IM_IRQ_FW, interrupt_handler, IRQF_SHARED, "ibmmcascsi", hosts)) {
-					printk(KERN_ERR "IBM MCA SCSI: Unable to get shared IRQ %d.\n", IM_IRQ_FW);
-				} else
-					IRQ11_registered++;
-			}
-			printk(KERN_INFO "IBM MCA SCSI: %s found in slot %d, io=0x%x, scsi id=%d,\n", subsys_list[i].description, slot + 1, port, id);
-			if ((pos[2] & 0xf0) == 0xf0)
-				printk(KERN_DEBUG"              ROM Addr.=off,");
-			else
-				printk(KERN_DEBUG "              ROM Addr.=0x%x,", ((pos[2] & 0xf0) << 13) + 0xc0000);
-			printk(KERN_DEBUG " port-offset=0x%x, subsystem=%s\n", ((pos[2] & 0x0e) << 2), (pos[2] & 1) ? "enabled." : "disabled.");
 
-			/* register the hostadapter */
-			if ((shpnt = ibmmca_register(scsi_template, port, id, i, subsys_list[i].description))) {
-				for (k = 2; k < 8; k++)
-					((struct ibmmca_hostdata *) shpnt->hostdata)->_pos[k] = pos[k];
-				((struct ibmmca_hostdata *) shpnt->hostdata)->_special = i;
-				mca_set_adapter_name(slot, subsys_list[i].description);
-				mca_set_adapter_procfn(slot, (MCA_ProcFn) ibmmca_getinfo, shpnt);
-				mca_mark_as_used(slot);
-				if ((i == IBM_SCSI2_FW) && (pos[4] & 0x01) && (pos[6] == 0))
-					devices_on_irq_11++;
-				else
-					devices_on_irq_14++;
-			}
-			slot++;	/* advance to next slot */
-		}		/* advance to next adapter id in the list of IBM-SCSI-subsystems */
-	}
 
-	/* now check for SCSI-adapters, mapped to the integrated SCSI
-	 * area. E.g. a W/Cache in MCA-slot 9(!). Do the check correct here,
-	 * as this is a known effect on some models 95xx. */
-	for (i = 0; i < ARRAY_SIZE(subsys_list); i++) {
-		/* scan each slot for a fitting adapter id */
-		slot = mca_find_adapter(subsys_list[i].mca_id, MCA_INTEGSCSI);
-		if (slot != MCA_NOTFOUND) {	/* scan through all slots */
-			for (j = 0; j < 8; j++)	/* read the pos-information */
-				pos[j] = mca_read_stored_pos(slot, j);
-			if ((pos[2] & 1) == 1) {	/* is the subsystem chip enabled ? */
-				/* (explanations see above) */
-				port = IM_IO_PORT + ((pos[2] & 0x0e) << 2);
-			} else {	/* anyway, set the portnumber and warn */
-				port = IM_IO_PORT + ((pos[2] & 0x0e) << 2);
-				printk(KERN_WARNING "IBM MCA SCSI: WARNING - Your SCSI-subsystem is disabled!\n");
-				printk(KERN_WARNING "              SCSI-operations may not work.\n");
-			}
-			if ((i == IBM_SCSI2_FW) && (pos[6] != 0)) {
-				printk(KERN_ERR "IBM MCA SCSI: ERROR - Wrong POS(6)-register setting!\n");
-				printk(KERN_ERR  "              Impossible to determine adapter PUN!\n");
-				printk(KERN_ERR "              Guessing adapter PUN = 7.\n");
-				id = 7;
-			} else {
-				id = (pos[3] & 0xe0) >> 5;	/* get subsystem PUN */
-				if (i == IBM_SCSI2_FW)
-					id |= (pos[3] & 0x10) >> 1;	/* get subsystem PUN high-bit
-									 * for F/W adapters */
-			}
-			if ((i == IBM_SCSI2_FW) && (pos[4] & 0x01) && (pos[6] == 0)) {
-				/* IRQ11 is used by SCSI-2 F/W Adapter/A */
-				printk(KERN_DEBUG  "IBM MCA SCSI: SCSI-2 F/W adapter needs IRQ 11.\n");
-				/* get interrupt request level */
-				if (request_irq(IM_IRQ_FW, interrupt_handler, IRQF_SHARED, "ibmmcascsi", hosts))
-					printk(KERN_ERR "IBM MCA SCSI: Unable to get shared IRQ %d.\n", IM_IRQ_FW);
-				else
-					IRQ11_registered++;
-			}
-			printk(KERN_INFO "IBM MCA SCSI: %s found in slot %d, io=0x%x, scsi id=%d,\n", subsys_list[i].description, slot + 1, port, id);
-			if ((pos[2] & 0xf0) == 0xf0)
-				printk(KERN_DEBUG "              ROM Addr.=off,");
-			else
-				printk(KERN_DEBUG "              ROM Addr.=0x%x,", ((pos[2] & 0xf0) << 13) + 0xc0000);
-			printk(KERN_DEBUG " port-offset=0x%x, subsystem=%s\n", ((pos[2] & 0x0e) << 2), (pos[2] & 1) ? "enabled." : "disabled.");
+	/* give detailed information on the subsystem. This helps me
+	 * additionally during debugging and analyzing bug-reports. */
+	printk(KERN_INFO "IBM MCA SCSI: %s found, io=0x%x, scsi id=%d,\n",
+	       description, port, id);
+	if (mca_dev->slot == MCA_INTEGSCSI)
+		printk(KERN_INFO "              chip rev.=%d, 8K NVRAM=%s, subsystem=%s\n", ((pos[2] & 0xf0) >> 4), (pos[2] & 2) ? "locked" : "accessible", (pos[2] & 1) ? "enabled." : "disabled.");
+	else {
+		if ((pos[2] & 0xf0) == 0xf0)
+			printk(KERN_DEBUG "              ROM Addr.=off,");
+		else
+			printk(KERN_DEBUG "              ROM Addr.=0x%x,", ((pos[2] & 0xf0) << 13) + 0xc0000);
 
-			/* register the hostadapter */
-			if ((shpnt = ibmmca_register(scsi_template, port, id, i, subsys_list[i].description))) {
-				for (k = 2; k < 7; k++)
-					((struct ibmmca_hostdata *) shpnt->hostdata)->_pos[k] = pos[k];
-				((struct ibmmca_hostdata *) shpnt->hostdata)->_special = i;
-				mca_set_adapter_name(slot, subsys_list[i].description);
-				mca_set_adapter_procfn(slot, (MCA_ProcFn) ibmmca_getinfo, shpnt);
-				mca_mark_as_used(slot);
-				if ((i == IBM_SCSI2_FW) && (pos[4] & 0x01) && (pos[6] == 0))
-					devices_on_irq_11++;
-				else
-					devices_on_irq_14++;
-			}
-			slot++;	/* advance to next slot */
-		}		/* advance to next adapter id in the list of IBM-SCSI-subsystems */
+		printk(KERN_DEBUG " port-offset=0x%x, subsystem=%s\n", ((pos[2] & 0x0e) << 2), (pos[2] & 1) ? "enabled." : "disabled.");
 	}
-	if (IRQ11_registered && !devices_on_irq_11)
-		free_irq(IM_IRQ_FW, hosts);	/* no devices on IRQ 11 */
-	if (IRQ14_registered && !devices_on_irq_14)
-		free_irq(IM_IRQ, hosts);	/* no devices on IRQ 14 */
-	if (!devices_on_irq_11 && !devices_on_irq_14)
-		printk(KERN_WARNING "IBM MCA SCSI: No IBM SCSI-subsystem adapter attached.\n");
-	return found;		/* return the number of found SCSI hosts. Should be 1 or 0. */
-}
-
-static struct Scsi_Host *ibmmca_register(struct scsi_host_template * scsi_template, int port, int id, int adaptertype, char *hostname)
-{
-	struct Scsi_Host *shpnt;
-	int i, j;
-	unsigned int ctrl;
 
 	/* check I/O region */
-	if (!request_region(port, IM_N_IO_PORT, hostname)) {
+	if (!request_region(port, IM_N_IO_PORT, description)) {
 		printk(KERN_ERR "IBM MCA SCSI: Unable to get I/O region 0x%x-0x%x (%d ports).\n", port, port + IM_N_IO_PORT - 1, IM_N_IO_PORT);
-		return NULL;
+		goto out_fail;
 	}
 
 	/* register host */
-	shpnt = scsi_register(scsi_template, sizeof(struct ibmmca_hostdata));
+	shpnt = scsi_host_alloc(&ibmmca_driver_template,
+				sizeof(struct ibmmca_hostdata));
 	if (!shpnt) {
 		printk(KERN_ERR "IBM MCA SCSI: Unable to register host.\n");
-		release_region(port, IM_N_IO_PORT);
-		return NULL;
+		goto out_release;
+	}
+
+	dev_set_drvdata(dev, shpnt);
+	if(request_irq(irq, interrupt_handler, IRQF_SHARED, description, dev)) {
+		printk(KERN_ERR "IBM MCA SCSI: failed to request interrupt %d\n", irq);
+		goto out_free_host;
 	}
 
 	/* request I/O region */
-	hosts[found] = shpnt;	/* add new found hostadapter to the list */
-	special(found) = adaptertype;	/* important assignment or else crash! */
-	subsystem_connector_size(found) = 0;	/* preset slot-size */
-	shpnt->irq = IM_IRQ;	/* assign necessary stuff for the adapter */
+	special(shpnt) = mca_dev->index;	/* important assignment or else crash! */
+	subsystem_connector_size(shpnt) = 0;	/* preset slot-size */
+	shpnt->irq = irq;	/* assign necessary stuff for the adapter */
 	shpnt->io_port = port;
 	shpnt->n_io_port = IM_N_IO_PORT;
 	shpnt->this_id = id;
 	shpnt->max_id = 8;	/* 8 PUNs are default */
 	/* now, the SCSI-subsystem is connected to Linux */
 
-	ctrl = (unsigned int) (inb(IM_CTR_REG(found)));	/* get control-register status */
 #ifdef IM_DEBUG_PROBE
+	ctrl = (unsigned int) (inb(IM_CTR_REG(found)));	/* get control-register status */
 	printk("IBM MCA SCSI: Control Register contents: %x, status: %x\n", ctrl, inb(IM_STAT_REG(found)));
 	printk("IBM MCA SCSI: This adapters' POS-registers: ");
 	for (i = 0; i < 8; i++)
 		printk("%x ", pos[i]);
 	printk("\n");
 #endif
-	reset_status(found) = IM_RESET_NOT_IN_PROGRESS;
+	reset_status(shpnt) = IM_RESET_NOT_IN_PROGRESS;
 
 	for (i = 0; i < 16; i++)	/* reset the tables */
 		for (j = 0; j < 8; j++)
-			get_ldn(found)[i][j] = MAX_LOG_DEV;
+			get_ldn(shpnt)[i][j] = MAX_LOG_DEV;
 
 	/* check which logical devices exist */
 	/* after this line, local interrupting is possible: */
-	local_checking_phase_flag(found) = 1;
-	check_devices(found, adaptertype);	/* call by value, using the global variable hosts */
-	local_checking_phase_flag(found) = 0;
-	found++;		/* now increase index to be prepared for next found subsystem */
+	local_checking_phase_flag(shpnt) = 1;
+	check_devices(shpnt, mca_dev->index);	/* call by value, using the global variable hosts */
+	local_checking_phase_flag(shpnt) = 0;
+
 	/* an ibm mca subsystem has been detected */
-	return shpnt;
+
+	for (k = 2; k < 7; k++)
+		((struct ibmmca_hostdata *) shpnt->hostdata)->_pos[k] = pos[k];
+	((struct ibmmca_hostdata *) shpnt->hostdata)->_special = INTEGRATED_SCSI;
+	mca_device_set_name(mca_dev, description);
+	/* FIXME: NEED TO REPLUMB TO SYSFS
+	   mca_set_adapter_procfn(MCA_INTEGSCSI, (MCA_ProcFn) ibmmca_getinfo, shpnt);
+	*/
+	mca_device_set_claim(mca_dev, 1);
+	if (scsi_add_host(shpnt, dev)) {
+		dev_printk(KERN_ERR, dev, "IBM MCA SCSI: scsi_add_host failed\n");
+		goto out_free_host;
+	}
+	scsi_scan_host(shpnt);
+
+	return 0;
+ out_free_host:
+	scsi_host_put(shpnt);
+ out_release:
+	release_region(port, IM_N_IO_PORT);
+ out_fail:
+	return ret;
 }
 
-static int ibmmca_release(struct Scsi_Host *shpnt)
+static int __devexit ibmmca_remove(struct device *dev)
 {
+	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
+	scsi_remove_host(shpnt);
 	release_region(shpnt->io_port, shpnt->n_io_port);
-	if (!(--found))
-		free_irq(shpnt->irq, hosts);
+	free_irq(shpnt->irq, dev);
 	return 0;
 }
 
@@ -1805,33 +1706,24 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	int current_ldn;
 	int id, lun;
 	int target;
-	int host_index;
 	int max_pun;
 	int i;
 	struct scatterlist *sl;
 
 	shpnt = cmd->device->host;
-	/* search for the right hostadapter */
-	for (host_index = 0; hosts[host_index] && hosts[host_index]->host_no != shpnt->host_no; host_index++);
 
-	if (!hosts[host_index]) {	/* invalid hostadapter descriptor address */
-		cmd->result = DID_NO_CONNECT << 16;
-		if (done)
-			done(cmd);
-		return 0;
-	}
-	max_pun = subsystem_maxid(host_index);
+	max_pun = subsystem_maxid(shpnt);
 	if (ibm_ansi_order) {
 		target = max_pun - 1 - cmd->device->id;
-		if ((target <= subsystem_pun(host_index)) && (cmd->device->id <= subsystem_pun(host_index)))
+		if ((target <= subsystem_pun(shpnt)) && (cmd->device->id <= subsystem_pun(shpnt)))
 			target--;
-		else if ((target >= subsystem_pun(host_index)) && (cmd->device->id >= subsystem_pun(host_index)))
+		else if ((target >= subsystem_pun(shpnt)) && (cmd->device->id >= subsystem_pun(shpnt)))
 			target++;
 	} else
 		target = cmd->device->id;
 
 	/* if (target,lun) is NO LUN or not existing at all, return error */
-	if ((get_scsi(host_index)[target][cmd->device->lun] == TYPE_NO_LUN) || (get_scsi(host_index)[target][cmd->device->lun] == TYPE_NO_DEVICE)) {
+	if ((get_scsi(shpnt)[target][cmd->device->lun] == TYPE_NO_LUN) || (get_scsi(shpnt)[target][cmd->device->lun] == TYPE_NO_DEVICE)) {
 		cmd->result = DID_NO_CONNECT << 16;
 		if (done)
 			done(cmd);
@@ -1839,16 +1731,16 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	}
 
 	/*if (target,lun) unassigned, do further checks... */
-	ldn = get_ldn(host_index)[target][cmd->device->lun];
+	ldn = get_ldn(shpnt)[target][cmd->device->lun];
 	if (ldn >= MAX_LOG_DEV) {	/* on invalid ldn do special stuff */
 		if (ldn > MAX_LOG_DEV) {	/* dynamical remapping if ldn unassigned */
-			current_ldn = next_ldn(host_index);	/* stop-value for one circle */
-			while (ld(host_index)[next_ldn(host_index)].cmd) {	/* search for a occupied, but not in */
+			current_ldn = next_ldn(shpnt);	/* stop-value for one circle */
+			while (ld(shpnt)[next_ldn(shpnt)].cmd) {	/* search for a occupied, but not in */
 				/* command-processing ldn. */
-				next_ldn(host_index)++;
-				if (next_ldn(host_index) >= MAX_LOG_DEV)
-					next_ldn(host_index) = 7;
-				if (current_ldn == next_ldn(host_index)) {	/* One circle done ? */
+				next_ldn(shpnt)++;
+				if (next_ldn(shpnt) >= MAX_LOG_DEV)
+					next_ldn(shpnt) = 7;
+				if (current_ldn == next_ldn(shpnt)) {	/* One circle done ? */
 					/* no non-processing ldn found */
 					scmd_printk(KERN_WARNING, cmd,
 	"IBM MCA SCSI: Cannot assign SCSI-device dynamically!\n"
@@ -1864,56 +1756,56 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 			/* unmap non-processing ldn */
 			for (id = 0; id < max_pun; id++)
 				for (lun = 0; lun < 8; lun++) {
-					if (get_ldn(host_index)[id][lun] == next_ldn(host_index)) {
-						get_ldn(host_index)[id][lun] = TYPE_NO_DEVICE;
-						get_scsi(host_index)[id][lun] = TYPE_NO_DEVICE;
+					if (get_ldn(shpnt)[id][lun] == next_ldn(shpnt)) {
+						get_ldn(shpnt)[id][lun] = TYPE_NO_DEVICE;
+						get_scsi(shpnt)[id][lun] = TYPE_NO_DEVICE;
 						/* unmap entry */
 					}
 				}
 			/* set reduced interrupt_handler-mode for checking */
-			local_checking_phase_flag(host_index) = 1;
+			local_checking_phase_flag(shpnt) = 1;
 			/* map found ldn to pun,lun */
-			get_ldn(host_index)[target][cmd->device->lun] = next_ldn(host_index);
+			get_ldn(shpnt)[target][cmd->device->lun] = next_ldn(shpnt);
 			/* change ldn to the right value, that is now next_ldn */
-			ldn = next_ldn(host_index);
+			ldn = next_ldn(shpnt);
 			/* unassign all ldns (pun,lun,ldn does not matter for remove) */
-			immediate_assign(host_index, 0, 0, 0, REMOVE_LDN);
+			immediate_assign(shpnt, 0, 0, 0, REMOVE_LDN);
 			/* set only LDN for remapped device */
-			immediate_assign(host_index, target, cmd->device->lun, ldn, SET_LDN);
+			immediate_assign(shpnt, target, cmd->device->lun, ldn, SET_LDN);
 			/* get device information for ld[ldn] */
-			if (device_exists(host_index, ldn, &ld(host_index)[ldn].block_length, &ld(host_index)[ldn].device_type)) {
-				ld(host_index)[ldn].cmd = NULL;	/* To prevent panic set 0, because
+			if (device_exists(shpnt, ldn, &ld(shpnt)[ldn].block_length, &ld(shpnt)[ldn].device_type)) {
+				ld(shpnt)[ldn].cmd = NULL;	/* To prevent panic set 0, because
 								   devices that were not assigned,
 								   should have nothing in progress. */
-				get_scsi(host_index)[target][cmd->device->lun] = ld(host_index)[ldn].device_type;
+				get_scsi(shpnt)[target][cmd->device->lun] = ld(shpnt)[ldn].device_type;
 				/* increase assignment counters for statistics in /proc */
-				IBM_DS(host_index).dynamical_assignments++;
-				IBM_DS(host_index).ldn_assignments[ldn]++;
+				IBM_DS(shpnt).dynamical_assignments++;
+				IBM_DS(shpnt).ldn_assignments[ldn]++;
 			} else
 				/* panic here, because a device, found at boottime has
 				   vanished */
 				panic("IBM MCA SCSI: ldn=0x%x, SCSI-device on (%d,%d) vanished!\n", ldn, target, cmd->device->lun);
 			/* unassign again all ldns (pun,lun,ldn does not matter for remove) */
-			immediate_assign(host_index, 0, 0, 0, REMOVE_LDN);
+			immediate_assign(shpnt, 0, 0, 0, REMOVE_LDN);
 			/* remap all ldns, as written in the pun/lun table */
 			lun = 0;
 #ifdef CONFIG_SCSI_MULTI_LUN
 			for (lun = 0; lun < 8; lun++)
 #endif
 				for (id = 0; id < max_pun; id++) {
-					if (get_ldn(host_index)[id][lun] <= MAX_LOG_DEV)
-						immediate_assign(host_index, id, lun, get_ldn(host_index)[id][lun], SET_LDN);
+					if (get_ldn(shpnt)[id][lun] <= MAX_LOG_DEV)
+						immediate_assign(shpnt, id, lun, get_ldn(shpnt)[id][lun], SET_LDN);
 				}
 			/* set back to normal interrupt_handling */
-			local_checking_phase_flag(host_index) = 0;
+			local_checking_phase_flag(shpnt) = 0;
 #ifdef IM_DEBUG_PROBE
 			/* Information on syslog terminal */
 			printk("IBM MCA SCSI: ldn=0x%x dynamically reassigned to (%d,%d).\n", ldn, target, cmd->device->lun);
 #endif
 			/* increase next_ldn for next dynamical assignment */
-			next_ldn(host_index)++;
-			if (next_ldn(host_index) >= MAX_LOG_DEV)
-				next_ldn(host_index) = 7;
+			next_ldn(shpnt)++;
+			if (next_ldn(shpnt) >= MAX_LOG_DEV)
+				next_ldn(shpnt) = 7;
 		} else {	/* wall against Linux accesses to the subsystem adapter */
 			cmd->result = DID_BAD_TARGET << 16;
 			if (done)
@@ -1923,18 +1815,18 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	}
 
 	/*verify there is no command already in progress for this log dev */
-	if (ld(host_index)[ldn].cmd)
+	if (ld(shpnt)[ldn].cmd)
 		panic("IBM MCA SCSI: cmd already in progress for this ldn.\n");
 
 	/*save done in cmd, and save cmd for the interrupt handler */
 	cmd->scsi_done = done;
-	ld(host_index)[ldn].cmd = cmd;
+	ld(shpnt)[ldn].cmd = cmd;
 
 	/*fill scb information independent of the scsi command */
-	scb = &(ld(host_index)[ldn].scb);
-	ld(host_index)[ldn].tsb.dev_status = 0;
+	scb = &(ld(shpnt)[ldn].scb);
+	ld(shpnt)[ldn].tsb.dev_status = 0;
 	scb->enable = IM_REPORT_TSB_ONLY_ON_ERROR | IM_RETRY_ENABLE;
-	scb->tsb_adr = isa_virt_to_bus(&(ld(host_index)[ldn].tsb));
+	scb->tsb_adr = isa_virt_to_bus(&(ld(shpnt)[ldn].tsb));
 	scsi_cmd = cmd->cmnd[0];
 
 	if (cmd->use_sg) {
@@ -1943,11 +1835,11 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 		if (i > 16)
 			panic("IBM MCA SCSI: scatter-gather list too long.\n");
 		while (--i >= 0) {
-			ld(host_index)[ldn].sge[i].address = (void *) (isa_page_to_bus(sl[i].page) + sl[i].offset);
-			ld(host_index)[ldn].sge[i].byte_length = sl[i].length;
+			ld(shpnt)[ldn].sge[i].address = (void *) (isa_page_to_bus(sl[i].page) + sl[i].offset);
+			ld(shpnt)[ldn].sge[i].byte_length = sl[i].length;
 		}
 		scb->enable |= IM_POINTER_TO_LIST;
-		scb->sys_buf_adr = isa_virt_to_bus(&(ld(host_index)[ldn].sge[0]));
+		scb->sys_buf_adr = isa_virt_to_bus(&(ld(shpnt)[ldn].sge[0]));
 		scb->sys_buf_length = cmd->use_sg * sizeof(struct im_sge);
 	} else {
 		scb->sys_buf_adr = isa_virt_to_bus(cmd->request_buffer);
@@ -1982,16 +1874,16 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 
 	/* for specific device-type debugging: */
 #ifdef IM_DEBUG_CMD_SPEC_DEV
-	if (ld(host_index)[ldn].device_type == IM_DEBUG_CMD_DEVICE)
-		printk("(SCSI-device-type=0x%x) issue scsi cmd=%02x to ldn=%d\n", ld(host_index)[ldn].device_type, scsi_cmd, ldn);
+	if (ld(shpnt)[ldn].device_type == IM_DEBUG_CMD_DEVICE)
+		printk("(SCSI-device-type=0x%x) issue scsi cmd=%02x to ldn=%d\n", ld(shpnt)[ldn].device_type, scsi_cmd, ldn);
 #endif
 
 	/* for possible panics store current command */
-	last_scsi_command(host_index)[ldn] = scsi_cmd;
-	last_scsi_type(host_index)[ldn] = IM_SCB;
+	last_scsi_command(shpnt)[ldn] = scsi_cmd;
+	last_scsi_type(shpnt)[ldn] = IM_SCB;
 	/* update statistical info */
-	IBM_DS(host_index).total_accesses++;
-	IBM_DS(host_index).ldn_access[ldn]++;
+	IBM_DS(shpnt).total_accesses++;
+	IBM_DS(shpnt).ldn_access[ldn]++;
 
 	switch (scsi_cmd) {
 	case READ_6:
@@ -2003,17 +1895,17 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 		/* Distinguish between disk and other devices. Only disks (that are the
 		   most frequently accessed devices) should be supported by the
 		   IBM-SCSI-Subsystem commands. */
-		switch (ld(host_index)[ldn].device_type) {
+		switch (ld(shpnt)[ldn].device_type) {
 		case TYPE_DISK:	/* for harddisks enter here ... */
 		case TYPE_MOD:	/* ... try it also for MO-drives (send flames as */
 			/*     you like, if this won't work.) */
 			if (scsi_cmd == READ_6 || scsi_cmd == READ_10 || scsi_cmd == READ_12) {
 				/* read command preparations */
 				scb->enable |= IM_READ_CONTROL;
-				IBM_DS(host_index).ldn_read_access[ldn]++;	/* increase READ-access on ldn stat. */
+				IBM_DS(shpnt).ldn_read_access[ldn]++;	/* increase READ-access on ldn stat. */
 				scb->command = IM_READ_DATA_CMD | IM_NO_DISCONNECT;
 			} else {	/* write command preparations */
-				IBM_DS(host_index).ldn_write_access[ldn]++;	/* increase write-count on ldn stat. */
+				IBM_DS(shpnt).ldn_write_access[ldn]++;	/* increase write-count on ldn stat. */
 				scb->command = IM_WRITE_DATA_CMD | IM_NO_DISCONNECT;
 			}
 			if (scsi_cmd == READ_6 || scsi_cmd == WRITE_6) {
@@ -2023,9 +1915,9 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 				scb->u1.log_blk_adr = (((unsigned) cmd->cmnd[5]) << 0) | (((unsigned) cmd->cmnd[4]) << 8) | (((unsigned) cmd->cmnd[3]) << 16) | (((unsigned) cmd->cmnd[2]) << 24);
 				scb->u2.blk.count = (((unsigned) cmd->cmnd[8]) << 0) | (((unsigned) cmd->cmnd[7]) << 8);
 			}
-			last_scsi_logical_block(host_index)[ldn] = scb->u1.log_blk_adr;
-			last_scsi_blockcount(host_index)[ldn] = scb->u2.blk.count;
-			scb->u2.blk.length = ld(host_index)[ldn].block_length;
+			last_scsi_logical_block(shpnt)[ldn] = scb->u1.log_blk_adr;
+			last_scsi_blockcount(shpnt)[ldn] = scb->u2.blk.count;
+			scb->u2.blk.length = ld(shpnt)[ldn].block_length;
 			break;
 			/* for other devices, enter here. Other types are not known by
 			   Linux! TYPE_NO_LUN is forbidden as valid device. */
@@ -2046,14 +1938,14 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 			scb->enable |= IM_BYPASS_BUFFER;
 			scb->u1.scsi_cmd_length = cmd->cmd_len;
 			memcpy(scb->u2.scsi_command, cmd->cmnd, cmd->cmd_len);
-			last_scsi_type(host_index)[ldn] = IM_LONG_SCB;
+			last_scsi_type(shpnt)[ldn] = IM_LONG_SCB;
 			/* Read/write on this non-disk devices is also displayworthy,
 			   so flash-up the LED/display. */
 			break;
 		}
 		break;
 	case INQUIRY:
-		IBM_DS(host_index).ldn_inquiry_access[ldn]++;
+		IBM_DS(shpnt).ldn_inquiry_access[ldn]++;
 		scb->command = IM_DEVICE_INQUIRY_CMD;
 		scb->enable |= IM_READ_CONTROL | IM_SUPRESS_EXCEPTION_SHORT | IM_BYPASS_BUFFER;
 		scb->u1.log_blk_adr = 0;
@@ -2064,7 +1956,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 		scb->u1.log_blk_adr = 0;
 		scb->u1.scsi_cmd_length = 6;
 		memcpy(scb->u2.scsi_command, cmd->cmnd, 6);
-		last_scsi_type(host_index)[ldn] = IM_LONG_SCB;
+		last_scsi_type(shpnt)[ldn] = IM_LONG_SCB;
 		break;
 	case READ_CAPACITY:
 		/* the length of system memory buffer must be exactly 8 bytes */
@@ -2081,12 +1973,12 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 		/* Commands that need write-only-mode (system -> device): */
 	case MODE_SELECT:
 	case MODE_SELECT_10:
-		IBM_DS(host_index).ldn_modeselect_access[ldn]++;
+		IBM_DS(shpnt).ldn_modeselect_access[ldn]++;
 		scb->command = IM_OTHER_SCSI_CMD_CMD;
 		scb->enable |= IM_SUPRESS_EXCEPTION_SHORT | IM_BYPASS_BUFFER;	/*Select needs WRITE-enabled */
 		scb->u1.scsi_cmd_length = cmd->cmd_len;
 		memcpy(scb->u2.scsi_command, cmd->cmnd, cmd->cmd_len);
-		last_scsi_type(host_index)[ldn] = IM_LONG_SCB;
+		last_scsi_type(shpnt)[ldn] = IM_LONG_SCB;
 		break;
 		/* For other commands, read-only is useful. Most other commands are
 		   running without an input-data-block. */
@@ -2095,19 +1987,19 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 		scb->enable |= IM_READ_CONTROL | IM_SUPRESS_EXCEPTION_SHORT | IM_BYPASS_BUFFER;
 		scb->u1.scsi_cmd_length = cmd->cmd_len;
 		memcpy(scb->u2.scsi_command, cmd->cmnd, cmd->cmd_len);
-		last_scsi_type(host_index)[ldn] = IM_LONG_SCB;
+		last_scsi_type(shpnt)[ldn] = IM_LONG_SCB;
 		break;
 	}
 	/*issue scb command, and return */
 	if (++disk_rw_in_progress == 1)
 		PS2_DISK_LED_ON(shpnt->host_no, target);
 
-	if (last_scsi_type(host_index)[ldn] == IM_LONG_SCB) {
-		issue_cmd(host_index, isa_virt_to_bus(scb), IM_LONG_SCB | ldn);
-		IBM_DS(host_index).long_scbs++;
+	if (last_scsi_type(shpnt)[ldn] == IM_LONG_SCB) {
+		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_LONG_SCB | ldn);
+		IBM_DS(shpnt).long_scbs++;
 	} else {
-		issue_cmd(host_index, isa_virt_to_bus(scb), IM_SCB | ldn);
-		IBM_DS(host_index).scbs++;
+		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | ldn);
+		IBM_DS(shpnt).scbs++;
 	}
 	return 0;
 }
@@ -2122,7 +2014,6 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 	unsigned int ldn;
 	void (*saved_done) (Scsi_Cmnd *);
 	int target;
-	int host_index;
 	int max_pun;
 	unsigned long imm_command;
 
@@ -2131,35 +2022,23 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 #endif
 
 	shpnt = cmd->device->host;
-	/* search for the right hostadapter */
-	for (host_index = 0; hosts[host_index] && hosts[host_index]->host_no != shpnt->host_no; host_index++);
 
-	if (!hosts[host_index]) {	/* invalid hostadapter descriptor address */
-		cmd->result = DID_NO_CONNECT << 16;
-		if (cmd->scsi_done)
-			(cmd->scsi_done) (cmd);
-		shpnt = cmd->device->host;
-#ifdef IM_DEBUG_PROBE
-		printk(KERN_DEBUG "IBM MCA SCSI: Abort adapter selection failed!\n");
-#endif
-		return SUCCESS;
-	}
-	max_pun = subsystem_maxid(host_index);
+	max_pun = subsystem_maxid(shpnt);
 	if (ibm_ansi_order) {
 		target = max_pun - 1 - cmd->device->id;
-		if ((target <= subsystem_pun(host_index)) && (cmd->device->id <= subsystem_pun(host_index)))
+		if ((target <= subsystem_pun(shpnt)) && (cmd->device->id <= subsystem_pun(shpnt)))
 			target--;
-		else if ((target >= subsystem_pun(host_index)) && (cmd->device->id >= subsystem_pun(host_index)))
+		else if ((target >= subsystem_pun(shpnt)) && (cmd->device->id >= subsystem_pun(shpnt)))
 			target++;
 	} else
 		target = cmd->device->id;
 
 	/* get logical device number, and disable system interrupts */
 	printk(KERN_WARNING "IBM MCA SCSI: Sending abort to device pun=%d, lun=%d.\n", target, cmd->device->lun);
-	ldn = get_ldn(host_index)[target][cmd->device->lun];
+	ldn = get_ldn(shpnt)[target][cmd->device->lun];
 
 	/*if cmd for this ldn has already finished, no need to abort */
-	if (!ld(host_index)[ldn].cmd) {
+	if (!ld(shpnt)[ldn].cmd) {
 		    return SUCCESS;
 	}
 
@@ -2170,20 +2049,20 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 	saved_done = cmd->scsi_done;
 	cmd->scsi_done = internal_done;
 	cmd->SCp.Status = 0;
-	last_scsi_command(host_index)[ldn] = IM_ABORT_IMM_CMD;
-	last_scsi_type(host_index)[ldn] = IM_IMM_CMD;
-	imm_command = inl(IM_CMD_REG(host_index));
+	last_scsi_command(shpnt)[ldn] = IM_ABORT_IMM_CMD;
+	last_scsi_type(shpnt)[ldn] = IM_IMM_CMD;
+	imm_command = inl(IM_CMD_REG(shpnt));
 	imm_command &= (unsigned long) (0xffff0000);	/* mask reserved stuff */
 	imm_command |= (unsigned long) (IM_ABORT_IMM_CMD);
 	/* must wait for attention reg not busy */
 	/* FIXME - timeout, politeness */
 	while (1) {
-		if (!(inb(IM_STAT_REG(host_index)) & IM_BUSY))
+		if (!(inb(IM_STAT_REG(shpnt)) & IM_BUSY))
 			break;
 	}
 	/* write registers and enable system interrupts */
-	outl(imm_command, IM_CMD_REG(host_index));
-	outb(IM_IMM_CMD | ldn, IM_ATTN_REG(host_index));
+	outl(imm_command, IM_CMD_REG(shpnt));
+	outb(IM_IMM_CMD | ldn, IM_ATTN_REG(shpnt));
 #ifdef IM_DEBUG_PROBE
 	printk("IBM MCA SCSI: Abort queued to adapter...\n");
 #endif
@@ -2202,7 +2081,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 		cmd->result |= DID_ABORT << 16;
 		if (cmd->scsi_done)
 			(cmd->scsi_done) (cmd);
-		ld(host_index)[ldn].cmd = NULL;
+		ld(shpnt)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_PROBE
 		printk("IBM MCA SCSI: Abort finished with success.\n");
 #endif
@@ -2211,7 +2090,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cm
 		cmd->result |= DID_NO_CONNECT << 16;
 		if (cmd->scsi_done)
 			(cmd->scsi_done) (cmd);
-		ld(host_index)[ldn].cmd = NULL;
+		ld(shpnt)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_PROBE
 		printk("IBM MCA SCSI: Abort failed.\n");
 #endif
@@ -2236,71 +2115,65 @@ static int __ibmmca_host_reset(Scsi_Cmnd
 	struct Scsi_Host *shpnt;
 	Scsi_Cmnd *cmd_aid;
 	int ticks, i;
-	int host_index;
 	unsigned long imm_command;
 
 	BUG_ON(cmd == NULL);
 
 	ticks = IM_RESET_DELAY * HZ;
 	shpnt = cmd->device->host;
-	/* search for the right hostadapter */
-	for (host_index = 0; hosts[host_index] && hosts[host_index]->host_no != shpnt->host_no; host_index++);
-
-	if (!hosts[host_index])	/* invalid hostadapter descriptor address */
-		return FAILED;
 
-	if (local_checking_phase_flag(host_index)) {
+	if (local_checking_phase_flag(shpnt)) {
 		printk(KERN_WARNING "IBM MCA SCSI: unable to reset while checking devices.\n");
 		return FAILED;
 	}
 
 	/* issue reset immediate command to subsystem, and wait for interrupt */
 	printk("IBM MCA SCSI: resetting all devices.\n");
-	reset_status(host_index) = IM_RESET_IN_PROGRESS;
-	last_scsi_command(host_index)[0xf] = IM_RESET_IMM_CMD;
-	last_scsi_type(host_index)[0xf] = IM_IMM_CMD;
-	imm_command = inl(IM_CMD_REG(host_index));
+	reset_status(shpnt) = IM_RESET_IN_PROGRESS;
+	last_scsi_command(shpnt)[0xf] = IM_RESET_IMM_CMD;
+	last_scsi_type(shpnt)[0xf] = IM_IMM_CMD;
+	imm_command = inl(IM_CMD_REG(shpnt));
 	imm_command &= (unsigned long) (0xffff0000);	/* mask reserved stuff */
 	imm_command |= (unsigned long) (IM_RESET_IMM_CMD);
 	/* must wait for attention reg not busy */
 	while (1) {
-		if (!(inb(IM_STAT_REG(host_index)) & IM_BUSY))
+		if (!(inb(IM_STAT_REG(shpnt)) & IM_BUSY))
 			break;
 		spin_unlock_irq(shpnt->host_lock);
 		yield();
 		spin_lock_irq(shpnt->host_lock);
 	}
 	/*write registers and enable system interrupts */
-	outl(imm_command, IM_CMD_REG(host_index));
-	outb(IM_IMM_CMD | 0xf, IM_ATTN_REG(host_index));
+	outl(imm_command, IM_CMD_REG(shpnt));
+	outb(IM_IMM_CMD | 0xf, IM_ATTN_REG(shpnt));
 	/* wait for interrupt finished or intr_stat register to be set, as the
 	 * interrupt will not be executed, while we are in here! */
 	 
 	/* FIXME: This is really really icky we so want a sleeping version of this ! */
-	while (reset_status(host_index) == IM_RESET_IN_PROGRESS && --ticks && ((inb(IM_INTR_REG(host_index)) & 0x8f) != 0x8f)) {
+	while (reset_status(shpnt) == IM_RESET_IN_PROGRESS && --ticks && ((inb(IM_INTR_REG(shpnt)) & 0x8f) != 0x8f)) {
 		udelay((1 + 999 / HZ) * 1000);
 		barrier();
 	}
 	/* if reset did not complete, just return an error */
 	if (!ticks) {
 		printk(KERN_ERR "IBM MCA SCSI: reset did not complete within %d seconds.\n", IM_RESET_DELAY);
-		reset_status(host_index) = IM_RESET_FINISHED_FAIL;
+		reset_status(shpnt) = IM_RESET_FINISHED_FAIL;
 		return FAILED;
 	}
 
-	if ((inb(IM_INTR_REG(host_index)) & 0x8f) == 0x8f) {
+	if ((inb(IM_INTR_REG(shpnt)) & 0x8f) == 0x8f) {
 		/* analysis done by this routine and not by the intr-routine */
-		if (inb(IM_INTR_REG(host_index)) == 0xaf)
-			reset_status(host_index) = IM_RESET_FINISHED_OK_NO_INT;
-		else if (inb(IM_INTR_REG(host_index)) == 0xcf)
-			reset_status(host_index) = IM_RESET_FINISHED_FAIL;
+		if (inb(IM_INTR_REG(shpnt)) == 0xaf)
+			reset_status(shpnt) = IM_RESET_FINISHED_OK_NO_INT;
+		else if (inb(IM_INTR_REG(shpnt)) == 0xcf)
+			reset_status(shpnt) = IM_RESET_FINISHED_FAIL;
 		else		/* failed, 4get it */
-			reset_status(host_index) = IM_RESET_NOT_IN_PROGRESS_NO_INT;
-		outb(IM_EOI | 0xf, IM_ATTN_REG(host_index));
+			reset_status(shpnt) = IM_RESET_NOT_IN_PROGRESS_NO_INT;
+		outb(IM_EOI | 0xf, IM_ATTN_REG(shpnt));
 	}
 
 	/* if reset failed, just return an error */
-	if (reset_status(host_index) == IM_RESET_FINISHED_FAIL) {
+	if (reset_status(shpnt) == IM_RESET_FINISHED_FAIL) {
 		printk(KERN_ERR "IBM MCA SCSI: reset failed.\n");
 		return FAILED;
 	}
@@ -2308,9 +2181,9 @@ static int __ibmmca_host_reset(Scsi_Cmnd
 	/* so reset finished ok - call outstanding done's, and return success */
 	printk(KERN_INFO "IBM MCA SCSI: Reset successfully completed.\n");
 	for (i = 0; i < MAX_LOG_DEV; i++) {
-		cmd_aid = ld(host_index)[i].cmd;
+		cmd_aid = ld(shpnt)[i].cmd;
 		if (cmd_aid && cmd_aid->scsi_done) {
-			ld(host_index)[i].cmd = NULL;
+			ld(shpnt)[i].cmd = NULL;
 			cmd_aid->result = DID_RESET << 16;
 		}
 	}
@@ -2351,46 +2224,46 @@ static int ibmmca_biosparam(struct scsi_
 }
 
 /* calculate percentage of total accesses on a ldn */
-static int ldn_access_load(int host_index, int ldn)
+static int ldn_access_load(struct Scsi_Host *shpnt, int ldn)
 {
-	if (IBM_DS(host_index).total_accesses == 0)
+	if (IBM_DS(shpnt).total_accesses == 0)
 		return (0);
-	if (IBM_DS(host_index).ldn_access[ldn] == 0)
+	if (IBM_DS(shpnt).ldn_access[ldn] == 0)
 		return (0);
-	return (IBM_DS(host_index).ldn_access[ldn] * 100) / IBM_DS(host_index).total_accesses;
+	return (IBM_DS(shpnt).ldn_access[ldn] * 100) / IBM_DS(shpnt).total_accesses;
 }
 
 /* calculate total amount of r/w-accesses */
-static int ldn_access_total_read_write(int host_index)
+static int ldn_access_total_read_write(struct Scsi_Host *shpnt)
 {
 	int a;
 	int i;
 
 	a = 0;
 	for (i = 0; i <= MAX_LOG_DEV; i++)
-		a += IBM_DS(host_index).ldn_read_access[i] + IBM_DS(host_index).ldn_write_access[i];
+		a += IBM_DS(shpnt).ldn_read_access[i] + IBM_DS(shpnt).ldn_write_access[i];
 	return (a);
 }
 
-static int ldn_access_total_inquiry(int host_index)
+static int ldn_access_total_inquiry(struct Scsi_Host *shpnt)
 {
 	int a;
 	int i;
 
 	a = 0;
 	for (i = 0; i <= MAX_LOG_DEV; i++)
-		a += IBM_DS(host_index).ldn_inquiry_access[i];
+		a += IBM_DS(shpnt).ldn_inquiry_access[i];
 	return (a);
 }
 
-static int ldn_access_total_modeselect(int host_index)
+static int ldn_access_total_modeselect(struct Scsi_Host *shpnt)
 {
 	int a;
 	int i;
 
 	a = 0;
 	for (i = 0; i <= MAX_LOG_DEV; i++)
-		a += IBM_DS(host_index).ldn_modeselect_access[i];
+		a += IBM_DS(shpnt).ldn_modeselect_access[i];
 	return (a);
 }
 
@@ -2398,19 +2271,14 @@ static int ldn_access_total_modeselect(i
 static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
 {
 	int len = 0;
-	int i, id, lun, host_index;
+	int i, id, lun;
 	unsigned long flags;
 	int max_pun;
 
-	for (i = 0; hosts[i] && hosts[i] != shpnt; i++);
 	
-	spin_lock_irqsave(hosts[i]->host_lock, flags);	/* Check it */
-	host_index = i;
-	if (!shpnt) {
-		len += sprintf(buffer + len, "\nIBM MCA SCSI: Can't find adapter");
-		return len;
-	}
-	max_pun = subsystem_maxid(host_index);
+	spin_lock_irqsave(shpnt->host_lock, flags);	/* Check it */
+
+	max_pun = subsystem_maxid(shpnt);
 
 	len += sprintf(buffer + len, "\n             IBM-SCSI-Subsystem-Linux-Driver, Version %s\n\n\n", IBMMCA_SCSI_DRIVER_VERSION);
 	len += sprintf(buffer + len, " SCSI Access-Statistics:\n");
@@ -2421,40 +2289,40 @@ static int ibmmca_proc_info(struct Scsi_
 	len += sprintf(buffer + len, "               Multiple LUN probing.....: No\n");
 #endif
 	len += sprintf(buffer + len, "               This Hostnumber..........: %d\n", shpnt->host_no);
-	len += sprintf(buffer + len, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(host_index)));
+	len += sprintf(buffer + len, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(shpnt)));
 	len += sprintf(buffer + len, "               (Shared) IRQ.............: %d\n", IM_IRQ);
-	len += sprintf(buffer + len, "               Total Interrupts.........: %d\n", IBM_DS(host_index).total_interrupts);
-	len += sprintf(buffer + len, "               Total SCSI Accesses......: %d\n", IBM_DS(host_index).total_accesses);
-	len += sprintf(buffer + len, "               Total short SCBs.........: %d\n", IBM_DS(host_index).scbs);
-	len += sprintf(buffer + len, "               Total long SCBs..........: %d\n", IBM_DS(host_index).long_scbs);
-	len += sprintf(buffer + len, "                 Total SCSI READ/WRITE..: %d\n", ldn_access_total_read_write(host_index));
-	len += sprintf(buffer + len, "                 Total SCSI Inquiries...: %d\n", ldn_access_total_inquiry(host_index));
-	len += sprintf(buffer + len, "                 Total SCSI Modeselects.: %d\n", ldn_access_total_modeselect(host_index));
-	len += sprintf(buffer + len, "                 Total SCSI other cmds..: %d\n", IBM_DS(host_index).total_accesses - ldn_access_total_read_write(host_index)
-		       - ldn_access_total_modeselect(host_index)
-		       - ldn_access_total_inquiry(host_index));
-	len += sprintf(buffer + len, "               Total SCSI command fails.: %d\n\n", IBM_DS(host_index).total_errors);
+	len += sprintf(buffer + len, "               Total Interrupts.........: %d\n", IBM_DS(shpnt).total_interrupts);
+	len += sprintf(buffer + len, "               Total SCSI Accesses......: %d\n", IBM_DS(shpnt).total_accesses);
+	len += sprintf(buffer + len, "               Total short SCBs.........: %d\n", IBM_DS(shpnt).scbs);
+	len += sprintf(buffer + len, "               Total long SCBs..........: %d\n", IBM_DS(shpnt).long_scbs);
+	len += sprintf(buffer + len, "                 Total SCSI READ/WRITE..: %d\n", ldn_access_total_read_write(shpnt));
+	len += sprintf(buffer + len, "                 Total SCSI Inquiries...: %d\n", ldn_access_total_inquiry(shpnt));
+	len += sprintf(buffer + len, "                 Total SCSI Modeselects.: %d\n", ldn_access_total_modeselect(shpnt));
+	len += sprintf(buffer + len, "                 Total SCSI other cmds..: %d\n", IBM_DS(shpnt).total_accesses - ldn_access_total_read_write(shpnt)
+		       - ldn_access_total_modeselect(shpnt)
+		       - ldn_access_total_inquiry(shpnt));
+	len += sprintf(buffer + len, "               Total SCSI command fails.: %d\n\n", IBM_DS(shpnt).total_errors);
 	len += sprintf(buffer + len, " Logical-Device-Number (LDN) Access-Statistics:\n");
 	len += sprintf(buffer + len, "         LDN | Accesses [%%] |   READ    |   WRITE   | ASSIGNMENTS\n");
 	len += sprintf(buffer + len, "        -----|--------------|-----------|-----------|--------------\n");
 	for (i = 0; i <= MAX_LOG_DEV; i++)
-		len += sprintf(buffer + len, "         %2X  |    %3d       |  %8d |  %8d | %8d\n", i, ldn_access_load(host_index, i), IBM_DS(host_index).ldn_read_access[i], IBM_DS(host_index).ldn_write_access[i], IBM_DS(host_index).ldn_assignments[i]);
+		len += sprintf(buffer + len, "         %2X  |    %3d       |  %8d |  %8d | %8d\n", i, ldn_access_load(shpnt, i), IBM_DS(shpnt).ldn_read_access[i], IBM_DS(shpnt).ldn_write_access[i], IBM_DS(shpnt).ldn_assignments[i]);
 	len += sprintf(buffer + len, "        -----------------------------------------------------------\n\n");
 	len += sprintf(buffer + len, " Dynamical-LDN-Assignment-Statistics:\n");
-	len += sprintf(buffer + len, "               Number of physical SCSI-devices..: %d (+ Adapter)\n", IBM_DS(host_index).total_scsi_devices);
-	len += sprintf(buffer + len, "               Dynamical Assignment necessary...: %s\n", IBM_DS(host_index).dyn_flag ? "Yes" : "No ");
-	len += sprintf(buffer + len, "               Next LDN to be assigned..........: 0x%x\n", next_ldn(host_index));
-	len += sprintf(buffer + len, "               Dynamical assignments done yet...: %d\n", IBM_DS(host_index).dynamical_assignments);
+	len += sprintf(buffer + len, "               Number of physical SCSI-devices..: %d (+ Adapter)\n", IBM_DS(shpnt).total_scsi_devices);
+	len += sprintf(buffer + len, "               Dynamical Assignment necessary...: %s\n", IBM_DS(shpnt).dyn_flag ? "Yes" : "No ");
+	len += sprintf(buffer + len, "               Next LDN to be assigned..........: 0x%x\n", next_ldn(shpnt));
+	len += sprintf(buffer + len, "               Dynamical assignments done yet...: %d\n", IBM_DS(shpnt).dynamical_assignments);
 	len += sprintf(buffer + len, "\n Current SCSI-Device-Mapping:\n");
 	len += sprintf(buffer + len, "        Physical SCSI-Device Map               Logical SCSI-Device Map\n");
 	len += sprintf(buffer + len, "    ID\\LUN  0  1  2  3  4  5  6  7       ID\\LUN  0  1  2  3  4  5  6  7\n");
 	for (id = 0; id < max_pun; id++) {
 		len += sprintf(buffer + len, "    %2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			len += sprintf(buffer + len, "%2s ", ti_p(get_scsi(host_index)[id][lun]));
+			len += sprintf(buffer + len, "%2s ", ti_p(get_scsi(shpnt)[id][lun]));
 		len += sprintf(buffer + len, "      %2d     ", id);
 		for (lun = 0; lun < 8; lun++)
-			len += sprintf(buffer + len, "%2s ", ti_l(get_ldn(host_index)[id][lun]));
+			len += sprintf(buffer + len, "%2s ", ti_l(get_ldn(shpnt)[id][lun]));
 		len += sprintf(buffer + len, "\n");
 	}
 
@@ -2488,20 +2356,31 @@ static int option_setup(char *str)
 
 __setup("ibmmcascsi=", option_setup);
 
-static struct scsi_host_template driver_template = {
-          .proc_name      = "ibmmca",
-	  .proc_info	  = ibmmca_proc_info,
-          .name           = "IBM SCSI-Subsystem",
-          .detect         = ibmmca_detect,
-          .release        = ibmmca_release,
-          .queuecommand   = ibmmca_queuecommand,
-	  .eh_abort_handler = ibmmca_abort,
-	  .eh_host_reset_handler = ibmmca_host_reset,
-          .bios_param     = ibmmca_biosparam,
-          .can_queue      = 16,
-          .this_id        = 7,
-          .sg_tablesize   = 16,
-          .cmd_per_lun    = 1,
-          .use_clustering = ENABLE_CLUSTERING,
+static struct mca_driver ibmmca_driver = {
+	.id_table = ibmmca_id_table,
+	.driver = {
+		.name	= "ibmmca",
+		.bus	= &mca_bus_type,
+		.probe	= ibmmca_probe,
+		.remove	= __devexit_p(ibmmca_remove),
+	},
 };
-#include "scsi_module.c"
+
+static int __init ibmmca_init(void)
+{
+#ifdef MODULE
+	/* If the driver is run as module, read from conf.modules or cmd-line */
+	if (boot_options)
+		option_setup(boot_options);
+#endif
+
+	return mca_register_driver_integrated(&ibmmca_driver, MCA_INTEGSCSI);
+}
+
+static void __exit ibmmca_exit(void)
+{
+	mca_unregister_driver(&ibmmca_driver);
+}
+
+module_init(ibmmca_init);
+module_exit(ibmmca_exit);
Index: BUILD-voyager/drivers/scsi/ibmmca.h
===================================================================
--- BUILD-voyager.orig/drivers/scsi/ibmmca.h	2007-05-03 08:44:53.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,21 +0,0 @@
-/*
- * Low Level Driver for the IBM Microchannel SCSI Subsystem
- * (Headerfile, see Documentation/scsi/ibmmca.txt for description of the
- * IBM MCA SCSI-driver.
- * For use under the GNU General Public License within the Linux-kernel project.
- * This include file works only correctly with kernel 2.4.0 or higher!!! */
-
-#ifndef _IBMMCA_H
-#define _IBMMCA_H
-
-/* Common forward declarations for all Linux-versions: */
-
-/* Interfaces to the midlevel Linux SCSI driver */
-static int ibmmca_detect (struct scsi_host_template *);
-static int ibmmca_release (struct Scsi_Host *);
-static int ibmmca_queuecommand (Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int ibmmca_abort (Scsi_Cmnd *);
-static int ibmmca_host_reset (Scsi_Cmnd *);
-static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
-
-#endif /* _IBMMCA_H */


