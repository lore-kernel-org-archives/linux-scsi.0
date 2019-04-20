From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH] fdomain: Resurrect driver
Date: Sat, 20 Apr 2019 22:11:26 +0200
Message-ID: <20190420201126.827-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Resurrect previously removed fdomain driver, in modern style.
Initialization is rewritten completely, with support for multiple cards,
no more global state variables.
Most of the code from interrupt handler is moved to a workqueue.

Tested on Adaptec AHA-2920A PCI card. ISA and PCMCIA code is untested as
I don't have the hardware.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/Kconfig               |  18 +
 drivers/scsi/Makefile              |   1 +
 drivers/scsi/fdomain.c             | 992 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/fdomain.h             |   7 +
 drivers/scsi/pcmcia/Kconfig        |   9 +
 drivers/scsi/pcmcia/Makefile       |   2 +
 drivers/scsi/pcmcia/fdomain_core.c |   2 +
 drivers/scsi/pcmcia/fdomain_stub.c |  89 ++++
 8 files changed, 1120 insertions(+)
 create mode 100644 drivers/scsi/fdomain.c
 create mode 100644 drivers/scsi/fdomain.h
 create mode 100644 drivers/scsi/pcmcia/fdomain_core.c
 create mode 100644 drivers/scsi/pcmcia/fdomain_stub.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d528018e6fa8..90950d875f2d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -663,6 +663,24 @@ config SCSI_DMX3191D
 	  To compile this driver as a module, choose M here: the
 	  module will be called dmx3191d.
 
+config SCSI_FUTURE_DOMAIN
+	tristate "Future Domain 16xx SCSI/AHA-2920A support"
+	depends on (ISA || PCI) && SCSI
+	select CHECK_SIGNATURE
+	help
+	  This is support for Future Domain's 16-bit SCSI host adapters
+	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
+	  other adapters based on the Future Domain chipsets (Quantum
+	  ISA-200S, ISA-250MG; Adaptec AHA-2920A; and at least one IBM board).
+
+	  NOTE: Newer Adaptec AHA-2920C boards use the Adaptec AIC-7850 chip
+	  and should use the aic7xxx driver ("Adaptec AIC7xxx chipset SCSI
+	  controller support"). This Future Domain driver works with the older
+	  Adaptec AHA-2920A boards with a Future Domain chip on them.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain.
+
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 8826111fdf4a..a9f80770d989 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_SCSI_AIC94XX)	+= aic94xx/
 obj-$(CONFIG_SCSI_PM8001)	+= pm8001/
 obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
+obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+= fdomain.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
 obj-$(CONFIG_SCSI_QLOGIC_FAS)	+= qlogicfas408.o	qlogicfas.o
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogicfas408.o
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
new file mode 100644
index 000000000000..814fd1b94797
--- /dev/null
+++ b/drivers/scsi/fdomain.c
@@ -0,0 +1,992 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver for Future Domain TMC-16x0 and TMC-3260 SCSI host adapters
+ * Copyright 2019 Ondrej Zary
+ *
+ * Original driver by
+ * Rickard E. Faith, faith@cs.unc.edu
+ *
+ * Future Domain BIOS versions supported for autodetect:
+ *    2.0, 3.0, 3.2, 3.4 (1.0), 3.5 (2.0), 3.6, 3.61
+ * Chips supported:
+ *    TMC-1800, TMC-18C50, TMC-18C30, TMC-36C70
+ * Boards supported:
+ *    Future Domain TMC-1650, TMC-1660, TMC-1670, TMC-1680, TMC-1610M/MER/MEX
+ *    Future Domain TMC-3260 (PCI)
+ *    Quantum ISA-200S, ISA-250MG
+ *    Adaptec AHA-2920A (PCI) [BUT *NOT* AHA-2920C -- use aic7xxx instead]
+ *    IBM ?
+ *
+ * NOTE:
+ *
+ * The Adaptec AHA-2920C has an Adaptec AIC-7850 chip on it.
+ * Use the aic7xxx driver for this board.
+ *
+ * The Adaptec AHA-2920A has a Future Domain chip on it, so this is the right
+ * driver for that card.  Unfortunately, the boxes will probably just say
+ * "2920", so you'll have to look on the card for a Future Domain logo, or a
+ * letter after the 2920.
+ *
+ * If you have a TMC-8xx or TMC-9xx board, then this is not the driver for
+ * your board.
+ *
+ * DESCRIPTION:
+ *
+ * This is the Linux low-level SCSI driver for Future Domain TMC-1660/1680
+ * TMC-1650/1670, and TMC-3260 SCSI host adapters.  The 1650 and 1670 have a
+ * 25-pin external connector, whereas the 1660 and 1680 have a SCSI-2 50-pin
+ * high-density external connector.  The 1670 and 1680 have floppy disk
+ * controllers built in.  The TMC-3260 is a PCI bus card.
+ *
+ * Future Domain's older boards are based on the TMC-1800 chip, and this
+ * driver was originally written for a TMC-1680 board with the TMC-1800 chip.
+ * More recently, boards are being produced with the TMC-18C50 and TMC-18C30
+ * chips.
+ *
+ * Please note that the drive ordering that Future Domain implemented in BIOS
+ * versions 3.4 and 3.5 is the opposite of the order (currently) used by the
+ * rest of the SCSI industry.
+ *
+ *
+ * REFERENCES USED:
+ *
+ * "TMC-1800 SCSI Chip Specification (FDC-1800T)", Future Domain Corporation,
+ * 1990.
+ *
+ * "Technical Reference Manual: 18C50 SCSI Host Adapter Chip", Future Domain
+ * Corporation, January 1992.
+ *
+ * "LXT SCSI Products: Specifications and OEM Technical Manual (Revision
+ * B/September 1991)", Maxtor Corporation, 1991.
+ *
+ * "7213S product Manual (Revision P3)", Maxtor Corporation, 1992.
+ *
+ * "Draft Proposed American National Standard: Small Computer System
+ * Interface - 2 (SCSI-2)", Global Engineering Documents. (X3T9.2/86-109,
+ * revision 10h, October 17, 1991)
+ *
+ * Private communications, Drew Eckhardt (drew@cs.colorado.edu) and Eric
+ * Youngdale (ericy@cais.com), 1992.
+ *
+ * Private communication, Tuong Le (Future Domain Engineering department),
+ * 1994. (Disk geometry computations for Future Domain BIOS version 3.4, and
+ * TMC-18C30 detection.)
+ *
+ * Hogan, Thom. The Programmer's PC Sourcebook. Microsoft Press, 1988. Page
+ * 60 (2.39: Disk Partition Table Layout).
+ *
+ * "18C30 Technical Reference Manual", Future Domain Corporation, 1993, page
+ * 6-1.
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/isa.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <scsi/scsicam.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+/* FIFO_COUNT: The host adapter has an 8K cache (host adapters based on the
+ * 18C30 chip have a 2k cache).  When this many 512 byte blocks are filled by
+ * the SCSI device, an interrupt will be raised.  Therefore, this could be as
+ * low as 0, or as high as 16.  Note, however, that values which are too high
+ * or too low seem to prevent any interrupts from occurring, and thereby lock
+ * up the machine.
+ */
+#define FIFO_COUNT	2	/* Number of 512 byte blocks before INTR */
+#define PARITY_MASK	0x08	/* Parity enabled, 0x00 = disabled */
+#define FDOMAIN_REGION_SIZE	0x10
+#define FDOMAIN_BIOS_SIZE	0x2000
+
+enum chip_type {
+	unknown		= 0x00,
+	tmc1800		= 0x01,
+	tmc18c50	= 0x02,
+	tmc18c30	= 0x03,
+};
+
+enum {
+	in_arbitration	= 0x02,
+	in_selection	= 0x04,
+	in_other	= 0x08,
+	disconnect	= 0x10,
+	aborted		= 0x20,
+	sent_ident	= 0x40,
+};
+
+enum in_port_type {
+	Read_SCSI_Data	 =  0,
+	SCSI_Status	 =  1,
+	TMC_Status	 =  2,
+	FIFO_Status	 =  3,	/* tmc18c50/tmc18c30 only */
+	Interrupt_Cond	 =  4,	/* tmc18c50/tmc18c30 only */
+	LSB_ID_Code	 =  5,
+	MSB_ID_Code	 =  6,
+	Read_Loopback	 =  7,
+	SCSI_Data_NoACK	 =  8,
+	Interrupt_Status =  9,
+	Configuration1	 = 10,
+	Configuration2	 = 11,	/* tmc18c50/tmc18c30 only */
+	Read_FIFO	 = 12,
+	FIFO_Data_Count	 = 14
+};
+
+enum out_port_type {
+	Write_SCSI_Data	=  0,
+	SCSI_Cntl	=  1,
+	Interrupt_Cntl	=  2,
+	SCSI_Mode_Cntl	=  3,
+	TMC_Cntl	=  4,
+	Memory_Cntl	=  5,	/* tmc18c50/tmc18c30 only */
+	Write_Loopback	=  7,
+	IO_Control	= 11,	/* tmc18c30 only */
+	Write_FIFO	= 12
+};
+
+struct fdomain {
+	int base;
+	struct scsi_cmnd *cur_cmd;
+	enum chip_type chip;
+	struct work_struct work;
+};
+
+#ifndef PCMCIA
+
+#ifdef CONFIG_ISA
+#define MAXBOARDS_PARAM 4
+static int io[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(io, int, ioport, NULL, 0);
+MODULE_PARM_DESC(io, "base I/O address of controller (0x140, 0x150, 0x160, 0x170)");
+
+static int irq[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(irq, int, irq, NULL, 0);
+MODULE_PARM_DESC(irq, "IRQ of controller (0=auto [default])");
+
+static int scsi_id[MAXBOARDS_PARAM] = { 0, 0, 0, 0 };
+module_param_hw_array(scsi_id, int, other, NULL, 0);
+MODULE_PARM_DESC(scsi_id, "SCSI ID of controller (default = 6)");
+
+static unsigned long addresses[] = {
+	0xc8000,
+	0xca000,
+	0xce000,
+	0xde000,
+};
+#define ADDRESS_COUNT ARRAY_SIZE(addresses)
+
+static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
+#define PORT_COUNT ARRAY_SIZE(ports)
+
+static unsigned short irqs[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
+#endif /* CONFIG_ISA */
+#endif /* !PCMCIA */
+
+/* This driver works *ONLY* for Future Domain cards using the TMC-1800,
+ * TMC-18C50, or TMC-18C30 chip.  This includes models TMC-1650, 1660, 1670,
+ * and 1680. These are all 16-bit cards.
+ *
+ * The following BIOS signature signatures are for boards which do *NOT*
+ * work with this driver (these TMC-8xx and TMC-9xx boards may work with the
+ * Seagate driver):
+ *
+ * FUTURE DOMAIN CORP. (C) 1986-1988 V4.0I 03/16/88
+ * FUTURE DOMAIN CORP. (C) 1986-1989 V5.0C2/14/89
+ * FUTURE DOMAIN CORP. (C) 1986-1989 V6.0A7/28/89
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V6.0105/31/90
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V6.0209/18/90
+ * FUTURE DOMAIN CORP. (C) 1986-1990 V7.009/18/90
+ * FUTURE DOMAIN CORP. (C) 1992 V8.00.004/02/92
+ *
+ * (The cards which do *NOT* work are all 8-bit cards -- although some of
+ * them have a 16-bit form-factor, the upper 8-bits are used only for IRQs
+ * and are *NOT* used for data. You can tell the difference by following
+ * the tracings on the circuit board -- if only the IRQ lines are involved,
+ * you have a "8-bit" card, and should *NOT* use this driver.)
+ */
+
+struct signature {
+	const char *signature;
+	int offset;
+	int length;
+	int bios_major;
+	int bios_minor;
+	int flag; /* 1 = PCI_bus, 2 = ISA_200S, 3 = ISA_250MG, 4 = ISA_200S */
+};
+#ifndef PCMCIA
+#ifdef CONFIG_ISA
+static struct signature signatures[] = {
+/*          1         2         3         4         5         6 */
+/* 123456789012345678901234567890123456789012345678901234567890 */
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.07/28/89",	 5, 50,  2,  0, 0 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V1.07/28/89",	 5, 50,  2,  0, 0 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.07/28/89", 72, 50,  2,  0, 2 },
+{ "FUTURE DOMAIN CORP. (C) 1986-1990 1800-V2.0",	73, 43,  2,  0, 3 },
+{ "FUTURE DOMAIN CORP. (C) 1991 1800-V2.0.",		72, 39,  2,  0, 4 },
+{ "FUTURE DOMAIN CORP. (C) 1992 V3.00.004/02/92",	 5, 44,  3,  0, 0 },
+{ "FUTURE DOMAIN TMC-18XX (C) 1993 V3.203/12/93",	 5, 44,  3,  2, 0 },
+{ "IBM F1 P2 BIOS v1.0104/29/93",			 5, 28,  3, -1, 0 },
+{ "Future Domain Corp. V1.0008/18/93",			 5, 33,  3,  4, 0 },
+{ "Future Domain Corp. V1.0008/18/93",			26, 33,  3,  4, 1 },
+{ "Adaptec AHA-2920 PCI-SCSI Card",			42, 31,  3, -1, 1 },
+{ "IBM F1 P264/32",					 5, 14,  3, -1, 1 },
+/* This next signature may not be a 3.5 bios */
+{ "Future Domain Corp. V2.0108/18/93",			 5, 33,  3,  5, 0 },
+{ "FUTURE DOMAIN CORP.  V3.5008/18/93",			 5, 34,  3,  5, 0 },
+{ "FUTURE DOMAIN 18c30/18c50/1800 (C) 1994 V3.5",	 5, 44,  3,  5, 0 },
+{ "FUTURE DOMAIN CORP.  V3.6008/18/93",			 5, 34,  3,  6, 0 },
+{ "FUTURE DOMAIN CORP.  V3.6108/18/93",			 5, 34,  3,  6, 0 },
+{ "FUTURE DOMAIN TMC-18XX",				 5, 22, -1, -1, 0 },
+/* Note that the last line will match a "generic" 18XX bios.  Because
+ * Future Domain has changed the host SCSI ID and/or the location of the
+ * geometry information in the on-board RAM area for each of the first
+ * three BIOS's, it is still important to enter a fully qualified
+ * signature in the table for any new BIOS's (after the host SCSI ID and
+ * geometry location are verified).
+ */
+};
+#define SIGNATURE_COUNT ARRAY_SIZE(signatures)
+#endif /* CONFIG_ISA */
+#endif /* !PCMCIA */
+
+static inline void fdomain_make_bus_idle(struct fdomain *fd)
+{
+	outb(0, fd->base + SCSI_Cntl);
+	outb(0, fd->base + SCSI_Mode_Cntl);
+	if (fd->chip == tmc18c50 || fd->chip == tmc18c30)
+		/* Clear forced intr. */
+		outb(0x21 | PARITY_MASK, fd->base + TMC_Cntl);
+	else
+		outb(0x01 | PARITY_MASK, fd->base + TMC_Cntl);
+}
+
+static enum chip_type fdomain_identify(int port)
+{
+	u16 id = inb(port + LSB_ID_Code) | inb(port + MSB_ID_Code) << 8;
+
+	switch (id) {
+	case 0x6127:
+		return tmc1800;
+	case 0x60e9: /* 18c50 or 18c30 */
+		break;
+	default:
+		return unknown;
+	}
+
+	/* Try to toggle 32-bit mode.  This only works on an 18c30 chip.
+	 * (User reports say this works, so we should switch to it.)
+	 */
+	outb(0x80, port + IO_Control);
+	if ((inb(port + Configuration2) & 0x80) == 0x80) {
+		outb(0x00, port + IO_Control);
+		if ((inb(port + Configuration2) & 0x80) == 0x00)
+			return tmc18c30;
+	}
+	/* If that failed, we are an 18c50. */
+	return tmc18c50;
+}
+
+static int fdomain_test_loopback(int base)
+{
+	int i;
+
+	for (i = 0; i < 255; i++) {
+		outb(i, base + Write_Loopback);
+		if (inb(base + Read_Loopback) != i)
+			return 1;
+	}
+
+	return 0;
+}
+
+void fdomain_reset(int base)
+{
+	outb(1, base + SCSI_Cntl);
+	mdelay(20);
+	outb(0, base + SCSI_Cntl);
+	mdelay(1150);
+	outb(0, base + SCSI_Mode_Cntl);
+	outb(PARITY_MASK, base + TMC_Cntl);
+}
+
+static int fdomain_select(struct Scsi_Host *sh, int target)
+{
+	int status;
+	unsigned long timeout;
+	struct fdomain *fd = shost_priv(sh);
+
+	outb(0x82, fd->base + SCSI_Cntl); /* Bus Enable + Select */
+	outb(BIT(sh->this_id) | BIT(target), fd->base + SCSI_Data_NoACK);
+
+	/* Stop arbitration and enable parity */
+	outb(PARITY_MASK, fd->base + TMC_Cntl);
+
+	timeout = 350;	/* 350 msec */
+
+	do {
+		status = inb(fd->base + SCSI_Status); /* Read adapter status */
+		if (status & 1) {	/* Busy asserted */
+			/* Enable SCSI Bus */
+			/* (on error, should make bus idle with 0) */
+			outb(0x80, fd->base + SCSI_Cntl);
+			return 0;
+		}
+		mdelay(1);
+	} while (--timeout);
+	fdomain_make_bus_idle(fd);
+	return 1;
+}
+
+static void fdomain_finish_cmd(struct fdomain *fd, int result)
+{
+	outb(0x00, fd->base + Interrupt_Cntl);
+	fdomain_make_bus_idle(fd);
+	fd->cur_cmd->result = result;
+	fd->cur_cmd->scsi_done(fd->cur_cmd);
+	fd->cur_cmd = NULL;
+}
+
+static void fdomain_read_data(struct scsi_cmnd *cmd)
+{
+	struct fdomain *fd = shost_priv(cmd->device->host);
+	unsigned int len;
+
+	while ((len = inw(fd->base + FIFO_Data_Count)) > 0) {
+		if (len > cmd->SCp.this_residual)
+			len = cmd->SCp.this_residual;
+		if (len == 1)
+			*cmd->SCp.ptr = inb(fd->base + Read_FIFO);
+		if (len > 1) {
+			insw(fd->base + Read_FIFO, cmd->SCp.ptr, len >> 1);
+			len = round_down(len, 2);
+		}
+		cmd->SCp.ptr += len;
+		cmd->SCp.this_residual -= len;
+		if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
+			--cmd->SCp.buffers_residual;
+			++cmd->SCp.buffer;
+			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+			cmd->SCp.this_residual = cmd->SCp.buffer->length;
+		}
+	}
+}
+
+static void fdomain_write_data(struct scsi_cmnd *cmd)
+{
+	struct fdomain *fd = shost_priv(cmd->device->host);
+	/* 8k FIFO for pre-tmc18c30 chips, 2k FIFO for tmc18c30 */
+	int FIFO_Size = fd->chip == tmc18c30 ? 0x800 : 0x2000;
+	unsigned int len;
+
+	while ((len = FIFO_Size - inw(fd->base + FIFO_Data_Count)) > 512) {
+		if (len > cmd->SCp.this_residual)
+			len = cmd->SCp.this_residual;
+		if (len == 1)
+			outb(*cmd->SCp.ptr, fd->base + Write_FIFO);
+		if (len > 1) {
+			outsw(fd->base + Write_FIFO, cmd->SCp.ptr, len >> 1);
+			len = round_down(len, 2);
+		}
+		cmd->SCp.ptr += len;
+		cmd->SCp.this_residual -= len;
+		if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
+			--cmd->SCp.buffers_residual;
+			++cmd->SCp.buffer;
+			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+			cmd->SCp.this_residual = cmd->SCp.buffer->length;
+		} else if (!cmd->SCp.this_residual &&
+			   !cmd->SCp.buffers_residual)
+			break;
+	}
+}
+
+static void fdomain_work(struct work_struct *work)
+{
+	struct fdomain *fd = container_of(work, struct fdomain, work);
+	struct Scsi_Host *sh = container_of((void *)fd, struct Scsi_Host,
+					    hostdata);
+	struct scsi_cmnd *cmd = fd->cur_cmd;
+	unsigned long flags;
+	int status;
+	int done = 0;
+
+	/* Abort calls fdomain_finish_cmd, so we do nothing here. */
+	if (cmd->SCp.phase & aborted)
+		;
+
+	spin_lock_irqsave(sh->host_lock, flags);
+
+	if (cmd->SCp.phase & in_arbitration) {
+		status = inb(fd->base + TMC_Status);
+		if (!(status & 0x02)) {
+			fdomain_finish_cmd(fd, DID_BUS_BUSY << 16);
+			goto out;
+		}
+		cmd->SCp.phase = in_selection;
+
+		outb(0x40 | FIFO_COUNT, fd->base + Interrupt_Cntl);
+		outb(0x82, fd->base + SCSI_Cntl); /* Bus Enable + Select */
+		outb(BIT(cmd->device->host->this_id) |
+		     BIT(scmd_id(cmd)), fd->base + SCSI_Data_NoACK);
+		/* Stop arbitration and enable parity */
+		outb(0x10 | PARITY_MASK, fd->base + TMC_Cntl);
+		goto out;
+	} else if (cmd->SCp.phase & in_selection) {
+		status = inb(fd->base + SCSI_Status);
+		if (!(status & 0x01)) {
+			/* Try again, for slow devices */
+			if (fdomain_select(cmd->device->host, scmd_id(cmd))) {
+				fdomain_finish_cmd(fd, DID_NO_CONNECT << 16);
+				goto out;
+			}
+			/* Stop arbitration and enable parity */
+			outb(0x10 | PARITY_MASK, fd->base + TMC_Cntl);
+		}
+		cmd->SCp.phase = in_other;
+		outb(0x90 | FIFO_COUNT, fd->base + Interrupt_Cntl);
+		outb(0x80, fd->base + SCSI_Cntl);
+		goto out;
+	}
+
+	/* cur_cmd->SCp.phase == in_other: this is the body of the routine */
+	status = inb(fd->base + SCSI_Status);
+
+	if (status & 0x10) {	/* REQ */
+		switch (status & 0x0e) {
+		case 0x08:	/* COMMAND OUT */
+			outb(cmd->cmnd[cmd->SCp.sent_command++],
+			     fd->base + Write_SCSI_Data);
+			break;
+		case 0x00:	/* DATA OUT -- tmc18c50/tmc18c30 only */
+			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
+				cmd->SCp.have_data_in = -1;
+				outb(0xd0 | PARITY_MASK, fd->base + TMC_Cntl);
+			}
+			break;
+		case 0x04:	/* DATA IN -- tmc18c50/tmc18c30 only */
+			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
+				cmd->SCp.have_data_in = 1;
+				outb(0x90 | PARITY_MASK, fd->base + TMC_Cntl);
+			}
+			break;
+		case 0x0c:	/* STATUS IN */
+			cmd->SCp.Status = inb(fd->base + Read_SCSI_Data);
+			break;
+		case 0x0a:	/* MESSAGE OUT */
+			outb(MESSAGE_REJECT, fd->base + Write_SCSI_Data);
+			break;
+		case 0x0e:	/* MESSAGE IN */
+			cmd->SCp.Message = inb(fd->base + Read_SCSI_Data);
+			if (!cmd->SCp.Message)
+				++done;
+			break;
+		}
+	}
+
+	if (fd->chip == tmc1800 && !cmd->SCp.have_data_in
+	    && (cmd->SCp.sent_command >= cmd->cmd_len)) {
+		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+			cmd->SCp.have_data_in = -1;
+			outb(0xd0 | PARITY_MASK, fd->base + TMC_Cntl);
+		} else {
+			cmd->SCp.have_data_in = 1;
+			outb(0x90 | PARITY_MASK, fd->base + TMC_Cntl);
+		}
+	}
+
+	if (cmd->SCp.have_data_in == -1) /* DATA OUT */
+		fdomain_write_data(cmd);
+
+	if (cmd->SCp.have_data_in == 1) /* DATA IN */
+		fdomain_read_data(cmd);
+
+	if (done) {
+		fdomain_finish_cmd(fd, (cmd->SCp.Status & 0xff) |
+				   ((cmd->SCp.Message & 0xff) << 8) |
+				   (DID_OK << 16));
+	} else {
+		if (cmd->SCp.phase & disconnect) {
+			outb(0xd0 | FIFO_COUNT, fd->base + Interrupt_Cntl);
+			outb(0x00, fd->base + SCSI_Cntl);
+		} else
+			outb(0x90 | FIFO_COUNT, fd->base + Interrupt_Cntl);
+	}
+out:
+	spin_unlock_irqrestore(sh->host_lock, flags);
+}
+
+static irqreturn_t fdomain_irq(int irq, void *dev_id)
+{
+	struct fdomain *fd = dev_id;
+
+	/* Is it our IRQ? */
+	if ((inb(fd->base + TMC_Status) & 0x01) == 0)
+		return IRQ_NONE;
+
+	outb(0x00, fd->base + Interrupt_Cntl);
+
+	/* We usually have one spurious interrupt after each command. */
+	if (!fd->cur_cmd)	/* Spurious interrupt */
+		return IRQ_NONE;
+
+	schedule_work(&fd->work);
+
+	return IRQ_HANDLED;
+}
+
+static int fdomain_queue(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
+{
+	struct fdomain *fd = shost_priv(cmd->device->host);
+	unsigned long flags;
+
+	/* Initialize static data */
+	if (scsi_sg_count(cmd)) {
+		cmd->SCp.buffer = scsi_sglist(cmd);
+		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+		cmd->SCp.this_residual = cmd->SCp.buffer->length;
+		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
+	} else {
+		cmd->SCp.ptr = NULL;
+		cmd->SCp.this_residual = 0;
+		cmd->SCp.buffer	= NULL;
+		cmd->SCp.buffers_residual = 0;
+	}
+	cmd->SCp.Status		= 0;
+	cmd->SCp.Message	= 0;
+	cmd->SCp.have_data_in	= 0;
+	cmd->SCp.sent_command	= 0;
+	cmd->SCp.phase		= in_arbitration;
+
+	spin_lock_irqsave(sh->host_lock, flags);
+
+	fd->cur_cmd = cmd;
+
+	fdomain_make_bus_idle(fd);
+
+	/* Start arbitration */
+	outb(0x00, fd->base + Interrupt_Cntl);
+	outb(0x00, fd->base + SCSI_Cntl);	/* Disable data drivers */
+	outb(BIT(cmd->device->host->this_id),
+	     fd->base + SCSI_Data_NoACK);	/* Set our id bit */
+	outb(0x20, fd->base + Interrupt_Cntl);
+	outb(0x14 | PARITY_MASK, fd->base + TMC_Cntl);	/* Start arbitration */
+
+	spin_unlock_irqrestore(sh->host_lock, flags);
+
+	return 0;
+}
+
+static int fdomain_abort(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *sh = cmd->device->host;
+	struct fdomain *fd = shost_priv(sh);
+	unsigned long flags;
+
+	if (!fd->cur_cmd)
+		return FAILED;
+
+	spin_lock_irqsave(sh->host_lock, flags);
+
+	fdomain_make_bus_idle(fd);
+	fd->cur_cmd->SCp.phase |= aborted;
+	fd->cur_cmd->result = DID_ABORT << 16;
+
+	/* Aborts are not done well. . . */
+	fdomain_finish_cmd(fd, DID_ABORT << 16);
+	spin_unlock_irqrestore(sh->host_lock, flags);
+	return SUCCESS;
+}
+
+int fdomain_host_reset(struct scsi_cmnd *cmd)
+{
+	struct Scsi_Host *sh = cmd->device->host;
+	struct fdomain *fd = shost_priv(sh);
+	unsigned long flags;
+
+	spin_lock_irqsave(sh->host_lock, flags);
+	fdomain_reset(fd->base);
+	spin_lock_irqsave(sh->host_lock, flags);
+	return SUCCESS;
+}
+
+static int fdomain_biosparam(struct scsi_device *sdev,
+			     struct block_device *bdev,	sector_t capacity,
+			     int geom[])
+{
+	unsigned char *p = scsi_bios_ptable(bdev);
+
+	if (p && p[65] == 0xaa && p[64] == 0x55 /* Partition table valid */
+	    && p[4]) {	 /* Partition type */
+		geom[0] = p[5] + 1;	/* heads */
+		geom[1] = p[6] & 0x3f;	/* sectors */
+	} else {
+		if (capacity >= 0x7e0000) {
+			geom[0] = 255;	/* heads */
+			geom[1] = 63;	/* sectors */
+		} else if (capacity >= 0x200000) {
+			geom[0] = 128;	/* heads */
+			geom[1] = 63;	/* sectors */
+		} else {
+			geom[0] = 64;	/* heads */
+			geom[1] = 32;	/* sectors */
+		}
+	}
+	geom[2] = sector_div(capacity, geom[0] * geom[1]);
+	kfree(p);
+
+	return 0;
+}
+
+struct scsi_host_template fdomain_template = {
+	.module			= THIS_MODULE,
+	.name			= "Future Domain TMC-16x0",
+	.proc_name		= "fdomain",
+	.queuecommand		= fdomain_queue,
+	.eh_abort_handler	= fdomain_abort,
+	.eh_host_reset_handler	= fdomain_host_reset,
+	.bios_param		= fdomain_biosparam,
+	.can_queue		= 1,
+	.this_id		= 7,
+	.sg_tablesize		= 64,
+	.dma_boundary		= PAGE_SIZE - 1,
+};
+
+struct Scsi_Host *fdomain_create(int base, int irq, int this_id,
+				 unsigned long bios_base, struct signature *sig,
+				 struct device *dev)
+{
+	struct Scsi_Host *sh;
+	struct fdomain *fd;
+	enum chip_type chip;
+	static const char * const chip_names[] = {
+		"Unknown", "TMC-1800", "TMC-18C50", "TMC-18C30"
+	};
+
+	chip = fdomain_identify(base);
+	if (!chip)
+		return NULL;
+
+	fdomain_reset(base);
+
+	if (fdomain_test_loopback(base))
+		return NULL;
+#ifndef PCMCIA
+	if (!irq) {
+		if (dev_is_pci(dev)) {
+			dev_err(dev, "PCI card has no IRQ assigned");
+			return NULL;
+		}
+#ifdef CONFIG_ISA
+		irq = irqs[(inb(base + Configuration1) & 0x0e) >> 1];
+#endif /* CONFIG_ISA */
+	}
+#endif /* !PCMCIA */
+	sh = scsi_host_alloc(&fdomain_template, sizeof(struct fdomain));
+	if (!sh)
+		return NULL;
+
+	if (this_id)
+		sh->this_id = this_id & 0x07;
+	else if (sig && (sig->bios_major > 0) &&
+		(sig->bios_major < 3 || sig->bios_minor < 2))
+		sh->this_id = 6;
+
+	sh->irq = irq;
+	sh->io_port = base;
+	sh->n_io_port = FDOMAIN_REGION_SIZE;
+
+	fd = shost_priv(sh);
+	fd->base = base;
+	fd->chip = chip;
+	INIT_WORK(&fd->work, fdomain_work);
+
+	if (request_irq(irq, fdomain_irq, dev_is_pci(dev) ? IRQF_SHARED : 0,
+			  "fdomain", fd))
+		goto fail_put;
+
+	if (!sig || (sig->bios_major < 0 && sig->bios_minor < 0))
+		shost_printk(KERN_INFO, sh, "No BIOS; using SCSI ID %d\n",
+			     sh->this_id);
+	else {
+		char v1 = (sig->bios_major >= 0) ? '0' + sig->bios_major : '?';
+		char v2 = (sig->bios_minor >= 0) ? '0' + sig->bios_minor : '?';
+
+		shost_printk(KERN_INFO, sh, "BIOS version %c.%c at 0x%lx using SCSI ID %d\n",
+			     v1, v2, bios_base, sh->this_id);
+	}
+	shost_printk(KERN_INFO, sh, "%s chip at 0x%x irq %d\n",
+		     dev_is_pci(dev) ? "TMC-36C70 (PCI bus)" : chip_names[chip],
+		     base, irq);
+
+	if (scsi_add_host(sh, dev))
+		goto fail_free_irq;
+
+	scsi_scan_host(sh);
+
+	return sh;
+
+fail_free_irq:
+	free_irq(irq, fd);
+fail_put:
+	scsi_host_put(sh);
+	return NULL;
+}
+
+int fdomain_destroy(struct Scsi_Host *sh)
+{
+	struct fdomain *fd = shost_priv(sh);
+
+	cancel_work_sync(&fd->work);
+	scsi_remove_host(sh);
+	if (sh->irq)
+		free_irq(sh->irq, fd);
+	scsi_host_put(sh);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int fdomain_resume(struct device *dev)
+{
+	struct fdomain *fd = shost_priv(dev_get_drvdata(dev));
+
+	fdomain_reset(fd->base);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(fdomain_pm_ops, NULL, fdomain_resume);
+#define FDOMAIN_PM_OPS	(&fdomain_pm_ops)
+#else
+#define FDOMAIN_PM_OPS	NULL
+#endif /* CONFIG_PM_SLEEP */
+
+#ifndef PCMCIA
+static int fdomain_pci_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *d)
+{
+	int err;
+	struct Scsi_Host *sh;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto fail;
+
+	err = pci_request_regions(pdev, "fdomain");
+	if (err)
+		goto disable_device;
+
+	err = -ENODEV;
+	if (pci_resource_len(pdev, 0) == 0)
+		goto release_region;
+
+	sh = fdomain_create(pci_resource_start(pdev, 0), pdev->irq, 7, 0, NULL,
+			    &pdev->dev);
+	if (!sh)
+		goto release_region;
+
+	pci_set_drvdata(pdev, sh);
+	return 0;
+
+release_region:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+fail:
+	return err;
+}
+
+static void fdomain_pci_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *sh = pci_get_drvdata(pdev);
+
+	fdomain_destroy(sh);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id fdomain_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, fdomain_pci_table);
+
+static struct pci_driver fdomain_pci_driver = {
+	.name		= "fdomain",
+	.id_table	= fdomain_pci_table,
+	.probe		= fdomain_pci_probe,
+	.remove		= fdomain_pci_remove,
+	.driver.pm	= FDOMAIN_PM_OPS,
+};
+
+#ifdef CONFIG_ISA
+static int fdomain_isa_match(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh;
+	int i, base = 0, irq = 0, bios_base = 0;
+	struct signature *sig = NULL;
+	void __iomem *p;
+	static int saved_bios_base;
+	static struct signature *saved_sig;
+
+	if (ndev < ADDRESS_COUNT) {	/* scan supported ISA BIOS addresses */
+		p = ioremap(addresses[ndev], FDOMAIN_BIOS_SIZE);
+		if (!p)
+			return 0;
+		for (i = 0; i < SIGNATURE_COUNT; i++)
+			if (check_signature(p + signatures[i].offset,
+					    signatures[i].signature,
+					    signatures[i].length))
+				break;
+		if (i == SIGNATURE_COUNT)	/* no signature found */
+			goto fail_unmap;
+		if (signatures[i].flag == 1)	/* ignore PCI devices */
+			goto fail_unmap;
+		sig = &signatures[i];
+		bios_base = addresses[ndev];
+		/* read I/O base from BIOS area */
+		if (sig->bios_major == 2) {
+			switch (sig->flag) {
+			case 2:	/* ISA_200S */
+			case 3:	/* ISA_250MG */
+				base = readb(p + 0x1fa2) +
+				      (readb(p + 0x1fa3) << 8);
+				break;
+			case 4:	/* ISA_200S (another one) */
+				base = readb(p + 0x1fa3) +
+				      (readb(p + 0x1fa4) << 8);
+				break;
+			default:
+				base = readb(p + 0x1fcc) +
+				      (readb(p + 0x1fcd) << 8);
+				break;
+			}
+		}
+		iounmap(p);
+		if (!base) {	/* no I/O base in BIOS area */
+			/* save BIOS info for later use in port probing */
+			saved_bios_base = bios_base;
+			saved_sig = sig;
+			return 0;
+		}
+	} else	/* scan supported I/O ports */
+		base = ports[ndev - ADDRESS_COUNT];
+
+	/* use saved BIOS details if present */
+	if (!bios_base && saved_bios_base) {
+		bios_base = saved_bios_base;
+		sig = saved_sig;
+	}
+
+	if (!request_region(base, FDOMAIN_REGION_SIZE, "fdomain"))
+		return 0;
+
+	sh = fdomain_create(base, irq, 0, bios_base, sig, dev);
+	if (!sh) {
+		release_region(base, FDOMAIN_REGION_SIZE);
+		return 0;
+	}
+
+	dev_set_drvdata(dev, sh);
+	return 1;
+fail_unmap:
+	iounmap(p);
+	return 0;
+}
+
+static int fdomain_isa_param_match(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh;
+
+	if (!io[ndev])
+		return 0;
+
+	if (!request_region(io[ndev], FDOMAIN_REGION_SIZE, "fdomain")) {
+		dev_err(dev, "base 0x%x already in use", io[ndev]);
+		return 0;
+	}
+
+	sh = fdomain_create(io[ndev], irq[ndev], scsi_id[ndev], 0, NULL, dev);
+	if (!sh) {
+		dev_err(dev, "controller not found at base 0x%x", io[ndev]);
+		release_region(io[ndev], FDOMAIN_REGION_SIZE);
+		return 0;
+	}
+
+	dev_set_drvdata(dev, sh);
+	return 1;
+}
+
+static int fdomain_isa_remove(struct device *dev, unsigned int ndev)
+{
+	struct Scsi_Host *sh = dev_get_drvdata(dev);
+	int base = sh->io_port;
+
+	fdomain_destroy(sh);
+	release_region(base, FDOMAIN_REGION_SIZE);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct isa_driver fdomain_isa_driver = {
+	.match		= fdomain_isa_match,
+	.remove		= fdomain_isa_remove,
+	.driver = {
+		.name	= "fdomain",
+		.pm	= FDOMAIN_PM_OPS,
+	},
+};
+#endif /* CONFIG_ISA */
+
+static bool pci_registered, isa_registered;
+
+static int __init fdomain_init(void)
+{
+	int ret;
+#ifdef CONFIG_ISA
+	struct pci_dev *pdev;
+	int isa_probe_count = ADDRESS_COUNT + PORT_COUNT;
+#endif /* CONFIG_ISA */
+
+	ret = pci_register_driver(&fdomain_pci_driver);
+	if (!ret)
+		pci_registered = 1;
+#ifdef CONFIG_ISA
+	/* don't autoprobe ISA if a PCI card is present */
+	pdev = pci_get_device(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70, NULL);
+	if (pdev && !io[0]) {
+		pci_dev_put(pdev);
+		return 0;
+	}
+
+	if (io[0]) {	/* use module parameters if present */
+		fdomain_isa_driver.match = fdomain_isa_param_match;
+		isa_probe_count = MAXBOARDS_PARAM;
+	}
+
+	ret = isa_register_driver(&fdomain_isa_driver, isa_probe_count);
+	if (!ret)
+		isa_registered = 1;
+#endif /* CONFIG_ISA */
+
+	return !(pci_registered || isa_registered);
+}
+
+static void __exit fdomain_exit(void)
+{
+	if (pci_registered)
+		pci_unregister_driver(&fdomain_pci_driver);
+#ifdef CONFIG_ISA
+	if (isa_registered)
+		isa_unregister_driver(&fdomain_isa_driver);
+#endif /* CONFIG_ISA */
+}
+
+module_init(fdomain_init);
+module_exit(fdomain_exit);
+
+MODULE_AUTHOR("Ondrej Zary, Rickard E. Faith");
+MODULE_DESCRIPTION("Future Domain TMC-16x0/TMC-3260 SCSI driver");
+MODULE_LICENSE("GPL");
+#endif /* !PCMCIA */
diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
new file mode 100644
index 000000000000..7370b836cbc1
--- /dev/null
+++ b/drivers/scsi/fdomain.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+extern struct Scsi_Host *fdomain_create(int port_base, int irq, int this_id,
+					int bios_base, void *sig,
+					struct device *dev);
+extern void fdomain_reset(int port_base);
+extern int fdomain_destroy(struct Scsi_Host *sh);
diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 2d435f105b16..ecc855c550aa 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -19,6 +19,15 @@ config PCMCIA_AHA152X
 	  To compile this driver as a module, choose M here: the
 	  module will be called aha152x_cs.
 
+config PCMCIA_FDOMAIN
+	tristate "Future Domain PCMCIA support"
+	help
+	  Say Y here if you intend to attach this type of PCMCIA SCSI host
+	  adapter to your computer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain_cs.
+
 config PCMCIA_NINJA_SCSI
 	tristate "NinjaSCSI-3 / NinjaSCSI-32Bi (16bit) PCMCIA support"
 	depends on !64BIT
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index a5a24dd44e7e..ba1f126f9b17 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -4,9 +4,11 @@ ccflags-y		:= -I $(srctree)/drivers/scsi
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
+obj-$(CONFIG_PCMCIA_FDOMAIN)	+= fdomain_cs.o
 obj-$(CONFIG_PCMCIA_AHA152X)	+= aha152x_cs.o
 obj-$(CONFIG_PCMCIA_NINJA_SCSI)	+= nsp_cs.o
 obj-$(CONFIG_PCMCIA_SYM53C500)	+= sym53c500_cs.o
 
 aha152x_cs-objs	:= aha152x_stub.o aha152x_core.o
+fdomain_cs-objs	:= fdomain_stub.o fdomain_core.o
 qlogic_cs-objs	:= qlogic_stub.o
diff --git a/drivers/scsi/pcmcia/fdomain_core.c b/drivers/scsi/pcmcia/fdomain_core.c
new file mode 100644
index 000000000000..a48913791868
--- /dev/null
+++ b/drivers/scsi/pcmcia/fdomain_core.c
@@ -0,0 +1,2 @@
+#define PCMCIA 1
+#include "fdomain.c"
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
new file mode 100644
index 000000000000..eee1379ad67b
--- /dev/null
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MPL-1.1)
+/*
+ * Driver for Future Domain-compatible PCMCIA SCSI cards
+ * Copyright 2019 Ondrej Zary
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <scsi/scsi_host.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+#include "fdomain.h"
+
+MODULE_AUTHOR("Ondrej Zary, David Hinds");
+MODULE_DESCRIPTION("Future Domain PCMCIA SCSI driver");
+MODULE_LICENSE("Dual MPL/GPL");
+
+static int fdomain_config_check(struct pcmcia_device *p_dev, void *priv_data)
+{
+	p_dev->io_lines = 10;
+	p_dev->resource[0]->end = 0x10;
+	p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
+	p_dev->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
+	return pcmcia_request_io(p_dev);
+}
+
+static int fdomain_probe(struct pcmcia_device *link)
+{
+	int ret;
+	struct Scsi_Host *sh;
+
+	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
+	link->config_regs = PRESENT_OPTION;
+
+	ret = pcmcia_loop_config(link, fdomain_config_check, NULL);
+	if (ret)
+		return ret;
+
+	ret = pcmcia_enable_device(link);
+	if (ret)
+		goto fail;
+
+	sh = fdomain_create(link->resource[0]->start, link->irq, 7, 0, NULL,
+			    &link->dev);
+	if (!sh) {
+		dev_err(&link->dev, "Controller initialization failed");
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	link->priv = sh;
+
+	return 0;
+
+fail:
+	pcmcia_disable_device(link);
+	return ret;
+}
+
+static void fdomain_remove(struct pcmcia_device *link)
+{
+	fdomain_destroy(link->priv);
+	pcmcia_disable_device(link);
+}
+
+static const struct pcmcia_device_id fdomain_ids[] = {
+	PCMCIA_DEVICE_PROD_ID12("IBM Corp.", "SCSI PCMCIA Card", 0xe3736c88,
+				0x859cad20),
+	PCMCIA_DEVICE_PROD_ID1("SCSI PCMCIA Adapter Card", 0x8dacb57e),
+	PCMCIA_DEVICE_PROD_ID12(" SIMPLE TECHNOLOGY Corporation",
+				"SCSI PCMCIA Credit Card Controller",
+				0x182bdafe, 0xc80d106f),
+	PCMCIA_DEVICE_NULL,
+};
+MODULE_DEVICE_TABLE(pcmcia, fdomain_ids);
+
+static struct pcmcia_driver fdomain_cs_driver = {
+	.owner		= THIS_MODULE,
+	.name		= "fdomain_cs",
+	.probe		= fdomain_probe,
+	.remove		= fdomain_remove,
+	.id_table       = fdomain_ids,
+};
+
+module_pcmcia_driver(fdomain_cs_driver);
-- 
Ondrej Zary
