From: Andrew Morton <akpm@digeo.com>
Subject: [patch 5/12] irqs: scsi
Date: Thu, 24 Apr 2003 05:40:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424054045.20b7179e.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [12.47.58.68] ([12.47.58.68]:51997 "EHLO pao-ex01.pao.digeo.com")
	by vger.kernel.org with ESMTP id S263548AbTDXM1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 08:27:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org


Update SCSI drivers for the new IRQ API.  Also fix warnings and compilation
errors as encountered.

 drivers/scsi/3w-xxxx.c        |    9 ++++--
 drivers/scsi/53c700.c         |    5 ++-
 drivers/scsi/53c700.h         |    4 ++
 drivers/scsi/BusLogic.c       |    5 ++-
 drivers/scsi/BusLogic.h       |    2 -
 drivers/scsi/NCR5380.c        |   11 +++++--
 drivers/scsi/NCR5380.h        |    4 ++
 drivers/scsi/NCR53C9x.c       |    9 ++++--
 drivers/scsi/NCR53C9x.h       |    3 +-
 drivers/scsi/NCR53c406a.c     |   10 ++++---
 drivers/scsi/aacraid/linit.c  |    1 
 drivers/scsi/aacraid/rx.c     |    5 ++-
 drivers/scsi/aacraid/sa.c     |    5 ++-
 drivers/scsi/advansys.c       |    7 ++---
 drivers/scsi/aha152x.c        |   12 +++++---
 drivers/scsi/aha1542.c        |    7 +++--
 drivers/scsi/aha1740.c        |    6 +++-
 drivers/scsi/atp870u.c        |   32 ++++++++++++-----------
 drivers/scsi/cpqfcTSinit.c    |    8 +++--
 drivers/scsi/cpqfcTSstructs.h |    3 +-
 drivers/scsi/eata.c           |    9 ++++--
 drivers/scsi/eata_pio.c       |    4 ++
 drivers/scsi/fd_mcs.c         |   16 +++++------
 drivers/scsi/fdomain.c        |   21 +++++++--------
 drivers/scsi/g_NCR5380.c      |    1 
 drivers/scsi/gdth.c           |   31 +++++++---------------
 drivers/scsi/ibmmca.c         |   22 +++++++--------
 drivers/scsi/in2000.c         |   12 ++++----
 drivers/scsi/ini9100u.c       |   58 +++++++++++++++++++++++-------------------
 drivers/scsi/inia100.c        |    5 ++-
 drivers/scsi/ips.c            |   11 ++++---
 drivers/scsi/megaraid.c       |   11 +++++--
 drivers/scsi/nsp32.c          |   16 ++++++-----
 drivers/scsi/nsp32.h          |    2 -
 drivers/scsi/nsp32_io.h       |    2 -
 drivers/scsi/pci2000.c        |    8 +++--
 drivers/scsi/pci2220i.c       |   10 +++++--
 drivers/scsi/psi240i.c        |    9 ++++--
 drivers/scsi/qlogicfas.c      |    3 +-
 drivers/scsi/seagate.c        |    6 ++--
 drivers/scsi/sym53c416.c      |   19 +++++++------
 drivers/scsi/u14-34f.c        |    7 +++--
 drivers/scsi/ultrastor.c      |    6 ++--
 drivers/scsi/wd7000.c         |    4 ++
 44 files changed, 258 insertions(+), 183 deletions(-)

diff -puN drivers/scsi/3w-xxxx.c~irqreturn-drivers-scsi drivers/scsi/3w-xxxx.c
--- 25/drivers/scsi/3w-xxxx.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/3w-xxxx.c	2003-04-24 05:17:32.000000000 -0700
@@ -213,7 +213,6 @@ static int tw_chrdev_open(struct inode *
 static int tw_chrdev_release(struct inode *inode, struct file *file);
 static int tw_copy_info(TW_Info *info, char *fmt, ...);
 static void tw_copy_mem_info(TW_Info *info, char *data, int len);
-static void tw_interrupt(int irq, void *dev_instance, struct pt_regs *regs);
 static int tw_halt(struct notifier_block *nb, ulong event, void *buf);
 static int tw_map_scsi_sg_data(struct pci_dev *pdev, Scsi_Cmnd *cmd);
 static u32 tw_map_scsi_single_data(struct pci_dev *pdev, Scsi_Cmnd *cmd);
@@ -1471,7 +1470,8 @@ int tw_initialize_units(TW_Device_Extens
 } /* End tw_initialize_units() */
 
 /* This function is the interrupt service routine */
-static void tw_interrupt(int irq, void *dev_instance, struct pt_regs *regs) 
+static irqreturn_t tw_interrupt(int irq, void *dev_instance,
+					struct pt_regs *regs) 
 {
 	int request_id;
 	u32 status_reg_addr, status_reg_value;
@@ -1481,12 +1481,13 @@ static void tw_interrupt(int irq, void *
 	int error = 0, retval = 0;
 	unsigned long flags = 0;
 	TW_Command *command_packet;
+	int handled = 0;
 
 	dprintk(KERN_WARNING "3w-xxxx: tw_interrupt()\n");
 
 	/* See if we are already running on another processor */
 	if (test_and_set_bit(TW_IN_INTR, &tw_dev->flags))
-		return;
+		return IRQ_NONE;
 
 	/* Get the host lock for io completions */
 	spin_lock_irqsave(tw_dev->host->host_lock, flags);
@@ -1494,6 +1495,7 @@ static void tw_interrupt(int irq, void *
 	/* See if the interrupt matches this instance */
 	if (tw_dev->tw_pci_dev->irq == irq) {
 
+		handled = 1;
 		/* Make sure io isn't queueing */
 		spin_lock(&tw_dev->tw_lock);
 
@@ -1683,6 +1685,7 @@ tw_interrupt_bail:
 
 	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
 	clear_bit(TW_IN_INTR, &tw_dev->flags);
+	return IRQ_RETVAL(handled);
 } /* End tw_interrupt() */
 
 /* This function handles ioctls from userspace to the driver */
diff -puN drivers/scsi/53c700.c~irqreturn-drivers-scsi drivers/scsi/53c700.c
--- 25/drivers/scsi/53c700.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/53c700.c	2003-04-24 05:17:33.000000000 -0700
@@ -1432,7 +1432,7 @@ NCR_700_start_command(Scsi_Cmnd *SCp)
 	return 1;
 }
 
-void
+irqreturn_t
 NCR_700_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
@@ -1442,6 +1442,7 @@ NCR_700_intr(int irq, void *dev_id, stru
 	__u32 resume_offset = 0;
 	__u8 pun = 0xff, lun = 0xff;
 	unsigned long flags;
+	int handled = 0;
 
 	/* Use the host lock to serialise acess to the 53c700
 	 * hardware.  Note: In future, we may need to take the queue
@@ -1457,6 +1458,7 @@ NCR_700_intr(int irq, void *dev_id, stru
 		Scsi_Cmnd *SCp = hostdata->cmd;
 		enum NCR_700_Host_State state;
 
+		handled = 1;
 		state = hostdata->state;
 		SCp = hostdata->cmd;
 
@@ -1697,6 +1699,7 @@ NCR_700_intr(int irq, void *dev_id, stru
 	}
  out_unlock:
 	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_RETVAL(handled);
 }
 
 /* FIXME: Need to put some proc information in and plumb it
diff -puN drivers/scsi/53c700.h~irqreturn-drivers-scsi drivers/scsi/53c700.h
--- 25/drivers/scsi/53c700.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/53c700.h	2003-04-24 05:17:33.000000000 -0700
@@ -8,6 +8,8 @@
 #ifndef _53C700_H
 #define _53C700_H
 
+#include <linux/interrupt.h>
+
 #include <asm/io.h>
 
 /* Turn on for general debugging---too verbose for normal use */
@@ -52,7 +54,7 @@ struct NCR_700_Host_Parameters;
 /* These are the externally used routines */
 struct Scsi_Host *NCR_700_detect(Scsi_Host_Template *, struct NCR_700_Host_Parameters *);
 int NCR_700_release(struct Scsi_Host *host);
-void NCR_700_intr(int, void *, struct pt_regs *);
+irqreturn_t NCR_700_intr(int, void *, struct pt_regs *);
 
 
 enum NCR_700_Host_State {
diff -puN drivers/scsi/aacraid/linit.c~irqreturn-drivers-scsi drivers/scsi/aacraid/linit.c
--- 25/drivers/scsi/aacraid/linit.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aacraid/linit.c	2003-04-24 05:17:33.000000000 -0700
@@ -48,6 +48,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 #include <asm/semaphore.h>
 #include <linux/blk.h>
 #include "scsi.h"
diff -puN drivers/scsi/aacraid/rx.c~irqreturn-drivers-scsi drivers/scsi/aacraid/rx.c
--- 25/drivers/scsi/aacraid/rx.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aacraid/rx.c	2003-04-24 05:17:32.000000000 -0700
@@ -39,13 +39,14 @@
 #include <linux/blk.h>
 #include <linux/delay.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 #include <asm/semaphore.h>
 #include "scsi.h"
 #include "hosts.h"
 
 #include "aacraid.h"
 
-static void aac_rx_intr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t aac_rx_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct aac_dev *dev = dev_id;
 	unsigned long bellbits;
@@ -81,7 +82,9 @@ static void aac_rx_intr(int irq, void *d
 			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormCmdNotFull);
 			rx_writel(dev, MUnit.ODR, DoorBellAdapterNormRespNotFull);
 		}
+		return IRQ_HANDLED;
 	}
+	return IRQ_NONE;
 }
 
 /**
diff -puN drivers/scsi/aacraid/sa.c~irqreturn-drivers-scsi drivers/scsi/aacraid/sa.c
--- 25/drivers/scsi/aacraid/sa.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aacraid/sa.c	2003-04-24 05:17:32.000000000 -0700
@@ -39,13 +39,14 @@
 #include <linux/blk.h>
 #include <linux/delay.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 #include <asm/semaphore.h>
 #include "scsi.h"
 #include "hosts.h"
 
 #include "aacraid.h"
 
-static void aac_sa_intr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t aac_sa_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	struct aac_dev *dev = dev_id;
 	unsigned short intstat, mask;
@@ -75,7 +76,9 @@ static void aac_sa_intr(int irq, void *d
 		} else if (intstat & DOORBELL_4) {	// dev -> Host Normal Response Not Full
 			sa_writew(dev, DoorbellClrReg_p, DOORBELL_4);
 		}
+		return IRQ_HANDLED;
 	}
+	return IRQ_NONE;
 }
 
 /**
diff -puN drivers/scsi/advansys.c~irqreturn-drivers-scsi drivers/scsi/advansys.c
--- 25/drivers/scsi/advansys.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/advansys.c	2003-04-24 05:17:33.000000000 -0700
@@ -4208,7 +4208,7 @@ STATIC PortAddr     _asc_def_iop_base[];
  * advansys.h contains function prototypes for functions global to Linux.
  */
 
-STATIC void       advansys_interrupt(int, void *, struct pt_regs *);
+STATIC irqreturn_t advansys_interrupt(int, void *, struct pt_regs *);
 STATIC int	  advansys_slave_configure(Scsi_Device *);
 STATIC void       asc_scsi_done_list(Scsi_Cmnd *, int from_isr);
 STATIC int        asc_execute_scsi_cmnd(Scsi_Cmnd *);
@@ -6246,7 +6246,7 @@ Scsi_Host_Template driver_template = ADV
  * to the AdvanSys driver which is for a device sharing an interrupt with
  * an AdvanSys adapter.
  */
-STATIC void
+STATIC irqreturn_t
 advansys_interrupt(int irq, void *dev_id, struct pt_regs *regs)
 {
     ulong           flags;
@@ -6336,7 +6336,7 @@ advansys_interrupt(int irq, void *dev_id
     asc_scsi_done_list(done_scp, 1);
 
     ASC_DBG(1, "advansys_interrupt: end\n");
-    return;
+    return IRQ_HANDLED;
 }
 
 /*
@@ -8370,7 +8370,6 @@ asc_prt_driver_conf(struct Scsi_Host *sh
     int                    totlen;
     int                    len;
     int                    chip_scsi_id;
-    int                    i;
 
     boardp = ASC_BOARDP(shp);
 
diff -puN drivers/scsi/aha152x.c~irqreturn-drivers-scsi drivers/scsi/aha152x.c
--- 25/drivers/scsi/aha152x.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aha152x.c	2003-04-24 05:17:33.000000000 -0700
@@ -646,7 +646,7 @@ static struct {
 };
 
 /* setup & interrupt */
-static void intr(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t intr(int irq, void *dev_id, struct pt_regs *);
 static void reset_ports(struct Scsi_Host *shpnt);
 static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, int error);
@@ -936,18 +936,19 @@ static inline struct Scsi_Host *lookup_i
 	return 0;
 }
 
-static void swintr(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t swintr(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
 
 	if (!shpnt) {
         	printk(KERN_ERR "aha152x%d: catched software interrupt %d for unknown controller.\n", HOSTNO, irqno);
-		return;
+		return IRQ_NONE;
 	}
 
 	HOSTDATA(shpnt)->swint++;
 
 	SETPORT(DMACNTRL0, INTEN);
+	return IRQ_HANDLED;
 }
 
 #ifdef __ISAPNP__
@@ -1873,13 +1874,13 @@ static void run(void)
  *
  */
 
-static void intr(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t intr(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
 
 	if (!shpnt) {
 		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
-		return;
+		return IRQ_NONE;
 	}
 
 	/* no more interrupts from the controller, while we're busy.
@@ -1899,6 +1900,7 @@ static void intr(int irqno, void *dev_id
 	HOSTDATA(shpnt)->service++;
 	INIT_WORK(&aha152x_tq, (void *) run, NULL);
 	schedule_work(&aha152x_tq);
+	return IRQ_HANDLED;
 }
 
 /*
diff -puN drivers/scsi/aha1542.c~irqreturn-drivers-scsi drivers/scsi/aha1542.c
--- 25/drivers/scsi/aha1542.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aha1542.c	2003-04-24 05:17:33.000000000 -0700
@@ -176,7 +176,8 @@ static spinlock_t aha1542_lock = SPIN_LO
 static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
 static int aha1542_restart(struct Scsi_Host *shost);
 static void aha1542_intr_handle(struct Scsi_Host *shost, void *dev_id, struct pt_regs *regs);
-static void do_aha1542_intr_handle(int irq, void *dev_id, struct pt_regs *regs);
+static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs);
 
 #define aha1542_intr_reset(base)  outb(IRST, CONTROL(base))
 
@@ -416,7 +417,8 @@ fail:
 }
 
 /* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
-static void do_aha1542_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_aha1542_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *shost;
@@ -428,6 +430,7 @@ static void do_aha1542_intr_handle(int i
 	spin_lock_irqsave(shost->host_lock, flags);
 	aha1542_intr_handle(shost, dev_id, regs);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 /* A "high" level interrupt handler */
diff -puN drivers/scsi/aha1740.c~irqreturn-drivers-scsi drivers/scsi/aha1740.c
--- 25/drivers/scsi/aha1740.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/aha1740.c	2003-04-24 05:17:33.000000000 -0700
@@ -220,7 +220,8 @@ static int aha1740_test_port(unsigned in
 }
 
 /* A "high" level interrupt handler */
-static void aha1740_intr_handle(int irq, void *dev_id, struct pt_regs * regs)
+static irqreturn_t aha1740_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
     struct Scsi_Host *host = aha_host[irq - 9];
     void (*my_done)(Scsi_Cmnd *);
@@ -230,6 +231,7 @@ static void aha1740_intr_handle(int irq,
     Scsi_Cmnd *SCtmp;
     unsigned int base;
     unsigned long flags;
+    int handled = 0;
 
     if (!host)
 	panic("aha1740.c: Irq from unknown host!\n");
@@ -239,6 +241,7 @@ static void aha1740_intr_handle(int irq,
 
     while(inb(G2STAT(base)) & G2STAT_INTPEND)
     {
+	handled = 1;
 	DEB(printk("aha1740_intr top of loop.\n"));
 	adapstat = inb(G2INTST(base));
 	ecbptr = (struct ecb *) isa_bus_to_virt(inl(MBOXIN0(base)));
@@ -309,6 +312,7 @@ static void aha1740_intr_handle(int irq,
     }
 
     spin_unlock_irqrestore(host->host_lock, flags);
+    return IRQ_RETVAL(handled);
 }
 
 static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
diff -puN drivers/scsi/atp870u.c~irqreturn-drivers-scsi drivers/scsi/atp870u.c
--- 25/drivers/scsi/atp870u.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/atp870u.c	2003-04-24 05:17:33.000000000 -0700
@@ -86,7 +86,8 @@ static struct Scsi_Host *atp_host[MAX_AT
 
 static void send_s870(struct Scsi_Host *);
 
-static void atp870u_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t atp870u_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	unsigned long flags;
 	unsigned short int tmpcip, id;
@@ -108,7 +109,7 @@ static void atp870u_intr_handle(int irq,
 		j = inb(tmport);
 		if ((j & 0x80) == 0) {
 			dev->in_int = 0;
-			return;
+			return IRQ_NONE;
 		}
 
 		tmpcip = dev->pciport;
@@ -175,13 +176,13 @@ stop_dma:
 			 *      Done
 			 */
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 
 		if (i == 0x40) {
 			dev->last_cmd |= 0x40;
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 
 		if (i == 0x21) {
@@ -202,7 +203,7 @@ stop_dma:
 			tmport += 0x08;
 			outb(0x08, tmport);
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 		if ((i == 0x80) || (i == 0x8f)) {
 			lun = 0;
@@ -228,7 +229,7 @@ stop_dma:
 					tmport += 0x04;
 					outb(0x08, tmport);
 					dev->in_int = 0;
-					return;
+					goto out;
 				} else {
 					outb(0x46, tmport);
 					dev->id[target_id].dirctu = 0x00;
@@ -239,7 +240,7 @@ stop_dma:
 					tmport += 0x03;
 					outb(0x08, tmport);
 					dev->in_int = 0;
-					return;
+					goto out;
 				}
 			}
 			if (dev->last_cmd != 0xff) {
@@ -313,7 +314,7 @@ stop_dma:
 				tmport = workportu + 0x18;
 				outb(0x08, tmport);
 				dev->in_int = 0;
-				return;
+				goto out;
 			}
 			prd = dev->id[target_id].prd_posu;
 			while (adrcntu != 0) {
@@ -352,12 +353,12 @@ stop_dma:
 				outb(0x08, tmport);
 				outb(0x01, tmpcip);
 				dev->in_int = 0;
-				return;
+				goto out;
 			}
 			outb(0x08, tmport);
 			outb(0x09, tmpcip);
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 
 		/*
@@ -417,7 +418,7 @@ go_42:
 				send_s870(host);
 			}
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 		if ((dev->last_cmd & 0xf0) != 0x40) {
 			dev->last_cmd = 0xff;
@@ -440,7 +441,7 @@ go_42:
 			outb(0x08, tmport);
 			outb(0x09, tmpcip);
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 		if (i == 0x08) {
 			tmpcip = tmpcip + 4;
@@ -458,7 +459,7 @@ go_42:
 			outb(0x08, tmport);
 			outb(0x01, tmpcip);
 			dev->in_int = 0;
-			return;
+			goto out;
 		}
 		tmport -= 0x07;
 		if (i == 0x0a) {
@@ -474,14 +475,15 @@ go_42:
 		tmport += 0x03;
 		outb(0x08, tmport);
 		dev->in_int = 0;
-		return;
+		goto out;
 	} else {
 //              tmport = workportu + 0x17;
 //              inb(tmport);
 //              dev->working = 0;
 		dev->in_int = 0;
-		return;
 	}
+out:
+	return IRQ_HANDLED;
 }
 
 static int atp870u_queuecommand(Scsi_Cmnd * req_p, void (*done) (Scsi_Cmnd *))
diff -puN drivers/scsi/BusLogic.c~irqreturn-drivers-scsi drivers/scsi/BusLogic.c
--- 25/drivers/scsi/BusLogic.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/BusLogic.c	2003-04-24 05:17:33.000000000 -0700
@@ -3339,7 +3339,7 @@ static void BusLogic_ProcessCompletedCCB
   Adapters.
 */
 
-static void BusLogic_InterruptHandler(int IRQ_Channel,
+static irqreturn_t BusLogic_InterruptHandler(int IRQ_Channel,
 				      void *DeviceIdentifier,
 				      Registers_T *InterruptRegisters)
 {
@@ -3420,6 +3420,7 @@ static void BusLogic_InterruptHandler(in
     Release exclusive access to Host Adapter.
   */
   BusLogic_ReleaseHostAdapterLockIH(HostAdapter, &ProcessorFlags);
+  return IRQ_HANDLED;
 }
 
 
@@ -4261,7 +4262,7 @@ int BusLogic_BIOSDiskParameters(struct s
       PartitionTable_T *FirstPartitionEntry = (PartitionTable_T *) buf;
       PartitionTable_T *PartitionEntry = FirstPartitionEntry;
       int SavedCylinders = DiskParameters->Cylinders, PartitionNumber;
-      unsigned char PartitionEntryEndHead, PartitionEntryEndSector;
+      unsigned char PartitionEntryEndHead=0, PartitionEntryEndSector=0;
       for (PartitionNumber = 0; PartitionNumber < 4; PartitionNumber++)
 	{
 	  PartitionEntryEndHead = PartitionEntry->end_head;
diff -puN drivers/scsi/BusLogic.h~irqreturn-drivers-scsi drivers/scsi/BusLogic.h
--- 25/drivers/scsi/BusLogic.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/BusLogic.h	2003-04-24 05:17:33.000000000 -0700
@@ -1763,7 +1763,7 @@ static inline void BusLogic_IncrementSiz
 */
 
 static void BusLogic_QueueCompletedCCB(BusLogic_CCB_T *);
-static void BusLogic_InterruptHandler(int, void *, Registers_T *);
+static irqreturn_t BusLogic_InterruptHandler(int, void *, Registers_T *);
 static int BusLogic_ResetHostAdapter(BusLogic_HostAdapter_T *,
 				     SCSI_Command_T *, unsigned int);
 static void BusLogic_Message(BusLogic_MessageLevel_T, char *,
diff -puN drivers/scsi/cpqfcTSinit.c~irqreturn-drivers-scsi drivers/scsi/cpqfcTSinit.c
--- 25/drivers/scsi/cpqfcTSinit.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/cpqfcTSinit.c	2003-04-24 05:17:33.000000000 -0700
@@ -1716,7 +1716,7 @@ int cpqfcTS_biosparam(struct scsi_device
 
 
 
-void cpqfcTS_intr_handler( int irq, 
+irqreturn_t cpqfcTS_intr_handler( int irq, 
 		void *dev_id, 
 		struct pt_regs *regs)
 {
@@ -1726,7 +1726,8 @@ void cpqfcTS_intr_handler( int irq, 
   CPQFCHBA *cpqfcHBA = (CPQFCHBA *)HostAdapter->hostdata;
   int MoreMessages = 1; // assume we have something to do
   UCHAR IntPending;
-  
+  int handled = 0;
+
   ENTER("intr_handler");
   spin_lock_irqsave( HostAdapter->host_lock, flags);
   // is this our INT?
@@ -1737,7 +1738,7 @@ void cpqfcTS_intr_handler( int irq, 
 #define INFINITE_IMQ_BREAK 10000
   if( IntPending )
   {
-    
+    handled = 1;
     // mask our HBA interrupts until we handle it...
     writeb( 0, cpqfcHBA->fcChip.Registers.INTEN.address);
 
@@ -1791,6 +1792,7 @@ void cpqfcTS_intr_handler( int irq, 
   }
   spin_unlock_irqrestore( HostAdapter->host_lock, flags);
   LEAVE("intr_handler");
+  return IRQ_RETVAL(handled);
 }
 
 
diff -puN drivers/scsi/cpqfcTSstructs.h~irqreturn-drivers-scsi drivers/scsi/cpqfcTSstructs.h
--- 25/drivers/scsi/cpqfcTSstructs.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/cpqfcTSstructs.h	2003-04-24 05:17:33.000000000 -0700
@@ -21,6 +21,7 @@
 #define CPQFCTSSTRUCTS_H
 
 #include <linux/timer.h>  // timer declaration in our host data
+#include <linux/interrupt.h>
 #include <asm/atomic.h>
 #include "cpqfcTSioctl.h"
 
@@ -861,7 +862,7 @@ void BigEndianSwap(  UCHAR *source, UCHA
                   
 
 // Linux interrupt handler
-void cpqfcTS_intr_handler( int irq,void *dev_id,struct pt_regs *regs);
+irqreturn_t cpqfcTS_intr_handler( int irq,void *dev_id,struct pt_regs *regs);
 void cpqfcTSheartbeat( unsigned long ptr );
 
 
diff -puN drivers/scsi/eata.c~irqreturn-drivers-scsi drivers/scsi/eata.c
--- 25/drivers/scsi/eata.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/eata.c	2003-04-24 05:17:33.000000000 -0700
@@ -815,7 +815,7 @@ static unsigned long io_port[] = {
 /* But transfer orientation from the 16 bit data register is Little Endian */
 #define REG2H(x)   le16_to_cpu(x)
 
-static void do_interrupt_handler(int, void *, struct pt_regs *);
+static irqreturn_t do_interrupt_handler(int, void *, struct pt_regs *);
 static void flush_dev(Scsi_Device *, unsigned long, unsigned int, unsigned int);
 static int do_trace = FALSE;
 static int setup_done = FALSE;
@@ -2332,16 +2332,19 @@ static void ihdlr(int irq, unsigned int 
    return;
 }
 
-static void do_interrupt_handler(int irq, void *shap, struct pt_regs *regs) {
+static irqreturn_t do_interrupt_handler(int irq, void *shap,
+					struct pt_regs *regs) {
    unsigned int j;
    unsigned long spin_flags;
 
    /* Check if the interrupt must be processed by this handler */
-   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards) return;
+   if ((j = (unsigned int)((char *)shap - sha)) >= num_boards)
+	return IRQ_NONE;
 
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
    ihdlr(irq, j);
    spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
+   return IRQ_HANDLED;
 }
 
 static int eata2x_release(struct Scsi_Host *shpnt) {
diff -puN drivers/scsi/eata_pio.c~irqreturn-drivers-scsi drivers/scsi/eata_pio.c
--- 25/drivers/scsi/eata_pio.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/eata_pio.c	2003-04-24 05:17:33.000000000 -0700
@@ -213,7 +213,8 @@ static void IncStat(Scsi_Pointer * SCp, 
 
 static void eata_pio_int_handler(int irq, void *dev_id, struct pt_regs *regs);
 
-static void do_eata_pio_int_handler(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_eata_pio_int_handler(int irq, void *dev_id,
+						struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
@@ -221,6 +222,7 @@ static void do_eata_pio_int_handler(int 
 	spin_lock_irqsave(dev->host_lock, flags);
 	eata_pio_int_handler(irq, dev_id, regs);
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static void eata_pio_int_handler(int irq, void *dev_id, struct pt_regs *regs)
diff -puN drivers/scsi/fd_mcs.c~irqreturn-drivers-scsi drivers/scsi/fd_mcs.c
--- 25/drivers/scsi/fd_mcs.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/fd_mcs.c	2003-04-24 05:17:33.000000000 -0700
@@ -283,7 +283,7 @@ static struct fd_mcs_adapters_struct fd_
 
 #define FD_BRDS sizeof(fd_mcs_adapters)/sizeof(struct fd_mcs_adapters_struct)
 
-static void fd_mcs_intr(int irq, void *dev_id, struct pt_regs *regs);
+static irqreturn_t fd_mcs_intr(int irq, void *dev_id, struct pt_regs *regs);
 
 static unsigned long addresses[] = { 0xc8000, 0xca000, 0xce000, 0xde000 };
 static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
@@ -679,7 +679,7 @@ static void my_done(struct Scsi_Host *sh
 }
 
 /* only my_done needs to be protected  */
-static void fd_mcs_intr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t fd_mcs_intr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	int status;
@@ -699,7 +699,7 @@ static void fd_mcs_intr(int irq, void *d
 
 	/* return if some other device on this IRQ caused the interrupt */
 	if (!shpnt) {
-		return;
+		return IRQ_NONE;
 	}
 
 	INTR_Processed++;
@@ -711,7 +711,7 @@ static void fd_mcs_intr(int irq, void *d
 #if DEBUG_ABORT
 		printk("Interrupt after abort, ignoring\n");
 #endif
-		/* return; */
+		/* return IRQ_HANDLED; */
 	}
 #if DEBUG_RACE
 	++in_interrupt_flag;
@@ -726,7 +726,7 @@ static void fd_mcs_intr(int irq, void *d
 			spin_lock_irqsave(shpnt->host_lock, flags);
 			my_done(shpnt, DID_BUS_BUSY << 16);
 			spin_unlock_irqrestore(shpnt->host_lock, flags);
-			return;
+			return IRQ_HANDLED;
 		}
 		current_SC->SCp.phase = in_selection;
 
@@ -752,7 +752,7 @@ static void fd_mcs_intr(int irq, void *d
 				spin_lock_irqsave(shpnt->host_lock, flags);
 				my_done(shpnt, DID_NO_CONNECT << 16);
 				spin_unlock_irqrestore(shpnt->host_lock, flags);
-				return;
+				return IRQ_HANDLED;
 			} else {
 #if EVERY_ACCESS
 				printk(" AltSel ");
@@ -767,7 +767,7 @@ static void fd_mcs_intr(int irq, void *d
 #if DEBUG_RACE
 		in_interrupt_flag = 0;
 #endif
-		return;
+		return IRQ_HANDLED;
 	}
 
 	/* current_SC->SCp.phase == in_other: this is the body of the routine */
@@ -1117,7 +1117,7 @@ static void fd_mcs_intr(int irq, void *d
 #if DEBUG_RACE
 	in_interrupt_flag = 0;
 #endif
-	return;
+	return IRQ_HANDLED;
 }
 
 static int fd_mcs_release(struct Scsi_Host *shpnt)
diff -puN drivers/scsi/fdomain.c~irqreturn-drivers-scsi drivers/scsi/fdomain.c
--- 25/drivers/scsi/fdomain.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/fdomain.c	2003-04-24 05:17:33.000000000 -0700
@@ -418,7 +418,7 @@ static int               Write_SCSI_Data
 static int               FIFO_Size = 0x2000; /* 8k FIFO for
 						pre-tmc18c30 chips */
 
-static void              do_fdomain_16x0_intr( int irq, void *dev_id,
+static irqreturn_t       do_fdomain_16x0_intr( int irq, void *dev_id,
 					    struct pt_regs * regs );
 int		 	fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
 
@@ -1201,7 +1201,8 @@ static void my_done(int error)
 #endif
 }
 
-static void do_fdomain_16x0_intr( int irq, void *dev_id, struct pt_regs * regs )
+static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id,
+					struct pt_regs * regs )
 {
    unsigned long flags;
    int      status;
@@ -1216,7 +1217,7 @@ static void do_fdomain_16x0_intr( int ir
 
    /* Check for other IRQ sources */
    if((inb(TMC_Status_port)&0x01)==0)   
-   	return;
+   	return IRQ_NONE;
 
    /* It is our IRQ */   	
    outb( 0x00, Interrupt_Cntl_port );
@@ -1227,7 +1228,7 @@ static void do_fdomain_16x0_intr( int ir
       printk( "Spurious interrupt, in_command = %d, current_SC = %x\n",
 	      in_command, current_SC );
 #endif
-      return;
+      return IRQ_NONE;
    }
 
    /* Abort calls my_done, so we do nothing here. */
@@ -1236,7 +1237,7 @@ static void do_fdomain_16x0_intr( int ir
       printk( "scsi: <fdomain> Interrupt after abort, ignoring\n" );
 #endif
       /*
-      return; */
+      return IRQ_HANDLED; */
    }
 
 #if DEBUG_RACE
@@ -1252,7 +1253,7 @@ static void do_fdomain_16x0_intr( int ir
          spin_lock_irqsave(current_SC->device->host->host_lock, flags);
 	 my_done( DID_BUS_BUSY << 16 );
          spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
-	 return;
+	 return IRQ_HANDLED;
       }
       current_SC->SCp.phase = in_selection;
       
@@ -1266,7 +1267,7 @@ static void do_fdomain_16x0_intr( int ir
 #if DEBUG_RACE
       in_interrupt_flag = 0;
 #endif
-      return;
+      return IRQ_HANDLED;
    } else if (current_SC->SCp.phase & in_selection) {
       status = inb( SCSI_Status_port );
       if (!(status & 0x01)) {
@@ -1278,7 +1279,7 @@ static void do_fdomain_16x0_intr( int ir
             spin_lock_irqsave(current_SC->device->host->host_lock, flags);
 	    my_done( DID_NO_CONNECT << 16 );
             spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
-	    return;
+	    return IRQ_HANDLED;
 	 } else {
 #if EVERY_ACCESS
 	    printk( " AltSel " );
@@ -1293,7 +1294,7 @@ static void do_fdomain_16x0_intr( int ir
 #if DEBUG_RACE
       in_interrupt_flag = 0;
 #endif
-      return;
+      return IRQ_HANDLED;
    }
    
    /* current_SC->SCp.phase == in_other: this is the body of the routine */
@@ -1492,7 +1493,7 @@ static void do_fdomain_16x0_intr( int ir
 #if DEBUG_RACE
    in_interrupt_flag = 0;
 #endif
-   return;
+   return IRQ_HANDLED;
 }
 
 static int fdomain_16x0_queue( Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
diff -puN drivers/scsi/gdth.c~irqreturn-drivers-scsi drivers/scsi/gdth.c
--- 25/drivers/scsi/gdth.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/gdth.c	2003-04-24 05:17:33.000000000 -0700
@@ -372,11 +372,7 @@
 
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, int *cyls, int *heads, int *secs);
-#if LINUX_VERSION_CODE >= 0x010346
-static void gdth_interrupt(int irq,void *dev_id,struct pt_regs *regs);
-#else
-static void gdth_interrupt(int irq,struct pt_regs *regs);
-#endif
+static irqreturn_t gdth_interrupt(int irq, void *dev_id, struct pt_regs *regs);
 static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp);
 static int gdth_async_event(int hanum);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
@@ -1925,11 +1921,7 @@ static int gdth_wait(int hanum,int index
 
     gdth_from_wait = TRUE;
     do {
-#if LINUX_VERSION_CODE >= 0x010346
         gdth_interrupt((int)ha->irq,ha,NULL);
-#else
-        gdth_interrupt((int)ha->irq,NULL);
-#endif
         if (wait_hanum==hanum && wait_index==index) {
             answer_found = TRUE;
             break;
@@ -3362,11 +3354,7 @@ static void gdth_clear_events()
 
 /* SCSI interface functions */
 
-#if LINUX_VERSION_CODE >= 0x010346
-static void gdth_interrupt(int irq,void *dev_id,struct pt_regs *regs)
-#else
-static void gdth_interrupt(int irq,struct pt_regs *regs)
-#endif
+static irqreturn_t gdth_interrupt(int irq,void *dev_id,struct pt_regs *regs)
 {
     register gdth_ha_str *ha;
     gdt6m_dpram_str *dp6m_ptr;
@@ -3383,7 +3371,7 @@ static void gdth_interrupt(int irq,struc
     /* if polling and not from gdth_wait() -> return */
     if (gdth_polling) {
         if (!gdth_from_wait) {
-            return;
+            return IRQ_HANDLED;
         }
     }
 
@@ -3396,7 +3384,7 @@ static void gdth_interrupt(int irq,struc
         /* spurious interrupt */
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-        return;
+        return IRQ_HANDLED;
     }
 
 #ifdef GDTH_STATISTICS
@@ -3492,7 +3480,7 @@ static void gdth_interrupt(int irq,struc
         TRACE2(("gdth_interrupt() unknown controller type\n"));
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-        return;
+        return IRQ_HANDLED;
     }
 
     TRACE(("gdth_interrupt() index %d stat %d info %d\n",
@@ -3509,7 +3497,7 @@ static void gdth_interrupt(int irq,struc
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
         gdth_next(hanum);
-        return;
+        return IRQ_HANDLED;
     } 
 
     if (IStatus == SPEZINDEX) {
@@ -3519,7 +3507,7 @@ static void gdth_interrupt(int irq,struc
         gdth_store_event(ha, ES_DRIVER, 4, &ha->dvr);
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-        return;
+        return IRQ_HANDLED;
     }
     scp     = ha->cmd_tab[IStatus-2].cmnd;
     Service = ha->cmd_tab[IStatus-2].service;
@@ -3532,13 +3520,13 @@ static void gdth_interrupt(int irq,struc
         gdth_store_event(ha, ES_DRIVER, 1, &ha->dvr);
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-        return;
+        return IRQ_HANDLED;
     }
     if (scp == INTERNAL_CMND) {
         TRACE(("gdth_interrupt() answer to internal command\n"));
         if (!gdth_polling)
             GDTH_UNLOCK_HA((gdth_ha_str *)dev_id,flags);
-        return;
+        return IRQ_HANDLED;
     }
 
     TRACE(("gdth_interrupt() sync. status\n"));
@@ -3563,6 +3551,7 @@ static void gdth_interrupt(int irq,struc
 #endif
     }
     gdth_next(hanum);
+    return IRQ_HANDLED;
 }
 
 static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
diff -puN drivers/scsi/g_NCR5380.c~irqreturn-drivers-scsi drivers/scsi/g_NCR5380.c
--- 25/drivers/scsi/g_NCR5380.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/g_NCR5380.c	2003-04-24 05:17:33.000000000 -0700
@@ -115,6 +115,7 @@
 #include <linux/ioport.h>
 #include <linux/isapnp.h>
 #include <linux/delay.h>
+#include <linux/interrupt.h>
 
 #define NCR_NOT_SET 0
 static int ncr_irq = NCR_NOT_SET;
diff -puN drivers/scsi/ibmmca.c~irqreturn-drivers-scsi drivers/scsi/ibmmca.c
--- 25/drivers/scsi/ibmmca.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/ibmmca.c	2003-04-24 05:17:33.000000000 -0700
@@ -477,7 +477,6 @@ static char ibm_ansi_order = 1;
 static char ibm_ansi_order = 0;
 #endif
 
-static void interrupt_handler(int, void *, struct pt_regs *);
 static void issue_cmd(int, unsigned long, unsigned char);
 static void internal_done(Scsi_Cmnd * cmd);
 static void check_devices(int, int);
@@ -501,7 +500,8 @@ static int option_setup(char *);
 static int ldn_access_load(int, int);
 static int ldn_access_total_read_write(int);
 
-static void interrupt_handler(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t interrupt_handler(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	int host_index, ihost_index;
 	unsigned int intr_reg;
@@ -517,7 +517,7 @@ static void interrupt_handler(int irq, v
 	/* return if some other device on this IRQ caused the interrupt */
 	if (!hosts[host_index]) {
 		spin_unlock(dev->host_lock);
-		return;
+		return IRQ_NONE;
 	}
 
 	/* the reset-function already did all the job, even ints got
@@ -525,7 +525,7 @@ static void interrupt_handler(int irq, v
 	if ((reset_status(host_index) == IM_RESET_NOT_IN_PROGRESS_NO_INT) || (reset_status(host_index) == IM_RESET_FINISHED_OK_NO_INT)) {
 		reset_status(host_index) = IM_RESET_NOT_IN_PROGRESS;
 		spin_unlock(dev->host_lock);
-		return;
+		return IRQ_HANDLED;
 	}
 
 	/*must wait for attention reg not busy, then send EOI to subsystem */
@@ -612,7 +612,7 @@ static void interrupt_handler(int irq, v
 		reset_status(ihost_index) = IM_RESET_FINISHED_OK;
 		last_scsi_command(ihost_index)[ldn] = NO_SCSI;
 		spin_unlock(dev->host_lock);
-		return;
+		return IRQ_HANDLED;
 	}
 	/* handling of commands coming from upper level of scsi driver */
 	if (last_scsi_type(ihost_index)[ldn] == IM_IMM_CMD) {
@@ -632,7 +632,7 @@ static void interrupt_handler(int irq, v
 			last_scsi_command(ihost_index)[ldn] = NO_SCSI;
 			last_scsi_type(ihost_index)[ldn] = 0;
 			spin_unlock(dev->host_lock);
-			return;
+			return IRQ_HANDLED;
 		} else if (last_scsi_command(ihost_index)[ldn] == IM_ABORT_IMM_CMD) {
 			/* react on SCSI abort command */
 #ifdef IM_DEBUG_PROBE
@@ -652,7 +652,7 @@ static void interrupt_handler(int irq, v
 			if (cmd->scsi_done)
 				(cmd->scsi_done) (cmd);	/* should be the internal_done */
 			spin_unlock(dev->host_lock);
-			return;
+			return IRQ_HANDLED;
 		} else {
 			disk_rw_in_progress = 0;
 			PS2_DISK_LED_OFF();
@@ -660,7 +660,7 @@ static void interrupt_handler(int irq, v
 			stat_result(ihost_index) = cmd_result;
 			last_scsi_command(ihost_index)[ldn] = NO_SCSI;
 			spin_unlock(dev->host_lock);
-			return;
+			return IRQ_HANDLED;
 		}
 	}
 	last_scsi_command(ihost_index)[ldn] = NO_SCSI;
@@ -671,7 +671,7 @@ static void interrupt_handler(int irq, v
 	if (cmd) {
 		if ((cmd->target == TIMEOUT_PUN) && (cmd->device->lun == TIMEOUT_LUN)) {
 			printk("IBM MCA SCSI: Ignoring interrupt from pun=%x, lun=%x.\n", cmd->target, cmd->device->lun);
-			return;
+			return IRQ_HANDLED;
 		}
 	}
 #endif
@@ -679,7 +679,7 @@ static void interrupt_handler(int irq, v
 	if (!cmd)
 	{
 		spin_unlock(dev->host_lock);
-		return;
+		return IRQ_HANDLED;
 	}
 
 #ifdef IM_DEBUG_INT
@@ -710,7 +710,7 @@ static void interrupt_handler(int irq, v
 	if (cmd->scsi_done)
 		(cmd->scsi_done) (cmd);
 	spin_unlock(dev->host_lock);
-	return;
+	return IRQ_HANDLED;
 }
 
 static void issue_cmd(int host_index, unsigned long cmd_reg, unsigned char attn_reg)
diff -puN drivers/scsi/in2000.c~irqreturn-drivers-scsi drivers/scsi/in2000.c
--- 25/drivers/scsi/in2000.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/in2000.c	2003-04-24 05:17:33.000000000 -0700
@@ -832,7 +832,7 @@ static void transfer_bytes(Scsi_Cmnd * c
  * but it _does_ need to be able to compile and run in an SMP kernel.)
  */
 
-static void in2000_intr(int irqnum, void *dev_id, struct pt_regs *ptregs)
+static irqreturn_t in2000_intr(int irqnum, void *dev_id, struct pt_regs *ptregs)
 {
 	struct Scsi_Host *instance = dev_id;
 	struct IN2000_hostdata *hostdata;
@@ -986,7 +986,7 @@ static void in2000_intr(int irqnum, void
 
 /* release the SMP spin_lock and restore irq state */
 		spin_unlock_irqrestore(instance->host_lock, flags);
-		return;
+		return IRQ_HANDLED;
 	}
 
 /* This interrupt was triggered by the WD33c93 chip. The fifo interrupt
@@ -1004,7 +1004,7 @@ static void in2000_intr(int irqnum, void
 
 /* release the SMP spin_lock and restore irq state */
 		spin_unlock_irqrestore(instance->host_lock, flags);
-		return;
+		return IRQ_HANDLED;
 	}
 
 	DB(DB_INTR, printk("{%02x:%02x-", asr, sr))
@@ -1416,7 +1416,7 @@ static void in2000_intr(int irqnum, void
 
 /* release the SMP spin_lock and restore irq state */
 			spin_unlock_irqrestore(instance->host_lock, flags);
-			return;
+			return IRQ_HANDLED;
 		}
 		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->pid))
 		    hostdata->connected = NULL;
@@ -1589,7 +1589,7 @@ static void in2000_intr(int irqnum, void
 
 /* release the SMP spin_lock and restore irq state */
 	    spin_unlock_irqrestore(instance->host_lock, flags);
-
+	return IRQ_HANDLED;
 }
 
 
@@ -1910,7 +1910,7 @@ static int __init in2000_detect(Scsi_Hos
 	unsigned short base;
 	uchar switches;
 	uchar hrev;
-	int flags;
+	unsigned long flags;
 	int val;
 	char buf[32];
 
diff -puN drivers/scsi/ini9100u.c~irqreturn-drivers-scsi drivers/scsi/ini9100u.c
--- 25/drivers/scsi/ini9100u.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/ini9100u.c	2003-04-24 05:17:33.000000000 -0700
@@ -166,14 +166,14 @@ static int setup_debug = 0;
 
 static char *setup_str = (char *) NULL;
 
-static void i91u_intr0(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr1(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr2(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr3(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr4(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr5(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr6(int irq, void *dev_id, struct pt_regs *);
-static void i91u_intr7(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr0(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr1(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr2(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr3(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr4(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr5(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr6(int irq, void *dev_id, struct pt_regs *);
+static irqreturn_t i91u_intr7(int irq, void *dev_id, struct pt_regs *);
 
 static void i91u_panic(char *msg);
 
@@ -697,124 +697,132 @@ static void i91uSCBPost(BYTE * pHcb, BYT
 /*
  * Interrupts handler (main routine of the driver)
  */
-static void i91u_intr0(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr0(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[0].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[0]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr1(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr1(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[1].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[1]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr2(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr2(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[2].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[2]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr3(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr3(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[3].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[3]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr4(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr4(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[4].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[4]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr5(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr5(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[5].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[5]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
-
-static void i91u_intr6(int irqno, void *dev_id, struct pt_regs *regs)
+	
+static irqreturn_t i91u_intr6(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[6].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[6]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
-static void i91u_intr7(int irqno, void *dev_id, struct pt_regs *regs)
+static irqreturn_t i91u_intr7(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	if (tul_hcs[7].HCS_Intr != irqno)
-		return;
+		return IRQ_NONE;
 
 	spin_lock_irqsave(dev->host_lock, flags);
 
 	tul_isr(&tul_hcs[7]);
 
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 /* 
diff -puN drivers/scsi/inia100.c~irqreturn-drivers-scsi drivers/scsi/inia100.c
--- 25/drivers/scsi/inia100.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/inia100.c	2003-04-24 05:17:33.000000000 -0700
@@ -108,7 +108,7 @@ static int setup_called = 0;
 #define NUMBER(arr)     (sizeof(arr) / sizeof(arr[0]))
 static char *setup_str = (char *) NULL;
 
-static void inia100_intr(int, void *, struct pt_regs *);
+static irqreturn_t inia100_intr(int, void *, struct pt_regs *);
 static void inia100_panic(char *msg);
 
 /* ---- EXTERNAL FUNCTIONS ---- */
@@ -659,7 +659,7 @@ void inia100SCBPost(BYTE * pHcb, BYTE * 
 /*
  * Interrupt handler (main routine of the driver)
  */
-static void inia100_intr(int irqno, void *devid, struct pt_regs *regs)
+static irqreturn_t inia100_intr(int irqno, void *devid, struct pt_regs *regs)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *)devid;
 	ORC_HCS *pHcb;
@@ -669,6 +669,7 @@ static void inia100_intr(int irqno, void
 	spin_lock_irqsave(host->host_lock, flags);
 	orc_interrupt(pHcb);
 	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 /* 
diff -puN drivers/scsi/ips.c~irqreturn-drivers-scsi drivers/scsi/ips.c
--- 25/drivers/scsi/ips.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/ips.c	2003-04-24 05:17:33.000000000 -0700
@@ -375,7 +375,7 @@ int ips_eh_abort(Scsi_Cmnd *);
 int ips_eh_reset(Scsi_Cmnd *);
 int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));
 const char * ips_info(struct Scsi_Host *);
-void do_ipsintr(int, void *, struct pt_regs *);
+irqreturn_t do_ipsintr(int, void *, struct pt_regs *);
 static int ips_hainit(ips_ha_t *);
 static int ips_map_status(ips_ha_t *, ips_scb_t *, ips_stat_t *);
 static int ips_send_wait(ips_ha_t *, ips_scb_t *, int, int);
@@ -1264,7 +1264,7 @@ ips_slave_configure(Scsi_Device *SDptr)
 /*   Wrapper for the interrupt handler                                      */
 /*                                                                          */
 /****************************************************************************/
-void
+irqreturn_t
 do_ipsintr(int irq, void *dev_id, struct pt_regs *regs) {
    ips_ha_t         *ha;
    unsigned long     cpu_flags;
@@ -1274,19 +1274,19 @@ do_ipsintr(int irq, void *dev_id, struct
 
    ha = (ips_ha_t *) dev_id;
    if (!ha) 
-      return;
+      return IRQ_NONE;
    host = ips_sh[ha->host_num];
    /* interrupt during initialization */
    if(!host){
       (*ha->func.intr)(ha);
-      return;
+      return IRQ_HANDLED;
    }
 
    IPS_LOCK_SAVE(host->host_lock, cpu_flags);
 
    if (!ha->active) {
       IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
-      return;
+      return IRQ_HANDLED;
    }
 
    (*ha->func.intr)(ha);
@@ -1295,6 +1295,7 @@ do_ipsintr(int irq, void *dev_id, struct
 
    /* start the next command */
    ips_next(ha, IPS_INTR_ON);
+   return IRQ_HANDLED;
 }
 
 /****************************************************************************/
diff -puN drivers/scsi/megaraid.c~irqreturn-drivers-scsi drivers/scsi/megaraid.c
--- 25/drivers/scsi/megaraid.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/megaraid.c	2003-04-24 05:17:33.000000000 -0700
@@ -2056,7 +2056,7 @@ static void showMbox (mega_scb * pScb)
 /*--------------------------------------------------------------------
  * Interrupt service routine
  *--------------------------------------------------------------------*/
-static void megaraid_isr (int irq, void *devp, struct pt_regs *regs)
+static irqreturn_t megaraid_isr (int irq, void *devp, struct pt_regs *regs)
 {
 	IO_LOCK_T;
 	mega_host_config * megaCfg;
@@ -2067,11 +2067,13 @@ static void megaraid_isr (int irq, void 
 	u_char qCnt, qStatus;
 	u_char completed[MAX_FIRMWARE_STATUS];
 	Scsi_Cmnd *SCpnt;
+	int handled = 0;
 
 	megaCfg = (mega_host_config *) devp;
 	mbox = (mega_mailbox *) tmpBox;
 
 	if (megaCfg->host->irq == irq) {
+		handled = 1;
 		if (megaCfg->flag & IN_ISR) {
 			TRACE (("ISR called reentrantly!!\n"));
 			printk ("ISR called reentrantly!!\n");
@@ -2088,14 +2090,14 @@ static void megaraid_isr (int irq, void 
 			if (dword != 0x10001234) {
 				/* Spurious interrupt */
 				megaCfg->flag &= ~IN_ISR;
-				return;
+				goto out;
 			}
 		} else {
 			byte = READ_PORT (megaCfg->host->io_port, INTR_PORT);
 			if ((byte & VALID_INTR_BYTE) == 0) {
 				/* Spurious interrupt */
 				megaCfg->flag &= ~IN_ISR;
-				return;
+				goto out;
 			}
 			WRITE_PORT (megaCfg->host->io_port, INTR_PORT, byte);
 		}
@@ -2225,7 +2227,8 @@ static void megaraid_isr (int irq, void 
 		IO_UNLOCK(megaCfg->host);
 
 	}
-
+out:
+	return IRQ_RETVAL(handled);
 }
 
 /*==================================================*/
diff -puN drivers/scsi/NCR5380.c~irqreturn-drivers-scsi drivers/scsi/NCR5380.c
--- 25/drivers/scsi/NCR5380.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/NCR5380.c	2003-04-24 05:17:33.000000000 -0700
@@ -677,9 +677,11 @@ static int probe_irq __initdata = 0;
  *	used by the IRQ probe code.
  */
  
-static void __init probe_intr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t __init probe_intr(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	probe_irq = irq;
+	return IRQ_HANDLED;
 }
 
 /**
@@ -1191,7 +1193,7 @@ static void NCR5380_main(void *p)
 	Scsi_Cmnd *tmp, *prev;
 	struct Scsi_Host *instance;
 	int done;
-	unsigned long flags;
+	unsigned long flags = 0;
 	
 	/*
 	 * We run (with interrupts disabled) until we're sure that none of 
@@ -1327,13 +1329,14 @@ static void NCR5380_main(void *p)
  *	Locks: takes the needed instance locks
  */
 
-static void NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs) 
+static irqreturn_t NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs) 
 {
 	NCR5380_local_declare();
 	struct Scsi_Host *instance;
 	int done;
 	unsigned char basr;
 	struct NCR5380_hostdata *hostdata;
+	int handled = 0;
 
 	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
 
@@ -1345,6 +1348,7 @@ static void NCR5380_intr(int irq, void *
 		{
 			instance = hostdata->host;
 			if (instance->irq == irq) {
+				handled = 1;
 				spin_lock_irq(instance->host_lock);
 				/* Look for pending interrupts */
 				NCR5380_setup(instance);
@@ -1402,6 +1406,7 @@ static void NCR5380_intr(int irq, void *
 			}	/* if (instance->irq == irq) */
 		}
 	} while (!done);
+	return IRQ_RETVAL(handled);
 }
 
 #endif 
diff -puN drivers/scsi/NCR5380.h~irqreturn-drivers-scsi drivers/scsi/NCR5380.h
--- 25/drivers/scsi/NCR5380.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/NCR5380.h	2003-04-24 05:17:33.000000000 -0700
@@ -28,6 +28,8 @@
 #ifndef NCR5380_H
 #define NCR5380_H
 
+#include <linux/interrupt.h>
+
 #define NCR5380_PUBLIC_RELEASE 7
 #define NCR53C400_PUBLIC_RELEASE 2
 
@@ -295,7 +297,7 @@ static int NCR5380_probe_irq(struct Scsi
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
 static void NCR5380_information_transfer(struct Scsi_Host *instance);
 #ifndef DONT_USE_INTR
-static void NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs);
+static irqreturn_t NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs);
 #endif
 static void NCR5380_main(void *ptr);
 static void NCR5380_print_options(struct Scsi_Host *instance);
diff -puN drivers/scsi/NCR53c406a.c~irqreturn-drivers-scsi drivers/scsi/NCR53c406a.c
--- 25/drivers/scsi/NCR53c406a.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/NCR53c406a.c	2003-04-24 05:17:33.000000000 -0700
@@ -169,7 +169,7 @@ enum Phase {
 
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
-static void do_NCR53c406a_intr(int, void *, struct pt_regs *);
+static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
 static void internal_done(Scsi_Cmnd *);
 static void wait_intr(void);
 static void chip_init(void);
@@ -658,7 +658,7 @@ static void internal_done(Scsi_Cmnd * SC
 
 static void wait_intr(void)
 {
-	int i = jiffies + WATCHDOG;
+	unsigned long i = jiffies + WATCHDOG;
 
 	while (time_after(i, jiffies) && !(inb(STAT_REG) & 0xe0)) {	/* wait for a pseudo-interrupt */
 		cpu_relax();
@@ -773,7 +773,8 @@ static int NCR53c406a_biosparm(struct sc
 	return 0;
 }
 
-static void do_NCR53c406a_intr(int unused, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_NCR53c406a_intr(int unused, void *dev_id,
+					struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
@@ -781,6 +782,7 @@ static void do_NCR53c406a_intr(int unuse
 	spin_lock_irqsave(dev->host_lock, flags);
 	NCR53c406a_intr(0, dev_id, regs);
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static void NCR53c406a_intr(int unused, void *dev_id, struct pt_regs *regs)
@@ -970,7 +972,7 @@ static void NCR53c406a_intr(int unused, 
 static int irq_probe(void)
 {
 	int irqs, irq;
-	int i;
+	unsigned long i;
 
 	inb(INT_REG);		/* clear the interrupt register */
 	irqs = probe_irq_on();
diff -puN drivers/scsi/NCR53C9x.c~irqreturn-drivers-scsi drivers/scsi/NCR53C9x.c
--- 25/drivers/scsi/NCR53C9x.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/NCR53C9x.c	2003-04-24 05:17:33.000000000 -0700
@@ -30,6 +30,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/blk.h>
+#include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
@@ -96,7 +97,7 @@ enum {
 struct NCR_ESP *espchain = 0;
 int nesps = 0, esps_in_use = 0, esps_running = 0;
 
-void esp_intr(int irq, void *dev_id, struct pt_regs *pregs);
+irqreturn_t esp_intr(int irq, void *dev_id, struct pt_regs *pregs);
 
 /* Debugging routines */
 struct esp_cmdstrings {
@@ -3559,7 +3560,7 @@ state_machine:
 }
 
 #ifndef CONFIG_SMP
-void esp_intr(int irq, void *dev_id, struct pt_regs *pregs)
+irqreturn_t esp_intr(int irq, void *dev_id, struct pt_regs *pregs)
 {
 	struct NCR_ESP *esp;
 	unsigned long flags;
@@ -3592,10 +3593,11 @@ repeat:
 	if(again)
 		goto repeat;
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 #else
 /* For SMP we only service one ESP on the list list at our IRQ level! */
-void esp_intr(int irq, void *dev_id, struct pt_regs *pregs)
+irqreturn_t esp_intr(int irq, void *dev_id, struct pt_regs *pregs)
 {
 	struct NCR_ESP *esp;
 	unsigned long flags;
@@ -3620,6 +3622,7 @@ void esp_intr(int irq, void *dev_id, str
 	}
 out:
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 #endif
 
diff -puN drivers/scsi/NCR53C9x.h~irqreturn-drivers-scsi drivers/scsi/NCR53C9x.h
--- 25/drivers/scsi/NCR53C9x.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/NCR53C9x.h	2003-04-24 05:17:33.000000000 -0700
@@ -14,6 +14,7 @@
 #define NCR53C9X_H
 
 #include <linux/config.h>
+#include <linux/interrupt.h>
 
 /* djweis for mac driver */
 #if defined(CONFIG_MAC)
@@ -657,7 +658,7 @@ extern struct NCR_ESP *esp_allocate(Scsi
 extern void esp_deallocate(struct NCR_ESP *);
 extern void esp_release(void);
 extern void esp_initialize(struct NCR_ESP *);
-extern void esp_intr(int, void *, struct pt_regs *);
+extern irqreturn_t esp_intr(int, void *, struct pt_regs *);
 extern const char *esp_info(struct Scsi_Host *);
 extern int esp_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 extern int esp_command(Scsi_Cmnd *);
diff -puN drivers/scsi/nsp32.c~irqreturn-drivers-scsi drivers/scsi/nsp32.c
--- 25/drivers/scsi/nsp32.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/nsp32.c	2003-04-24 05:17:33.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/major.h>
 #include <linux/blk.h>
+#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
@@ -291,8 +292,8 @@ static void __devexit nsp32_remove(struc
 static int __init init_nsp32(void);
 static void __exit exit_nsp32(void);
 
-static void nsp32_message(char *, int, char *, char *, ...);
-static void nsp32_dmessage(char *, int, int, char *, ...);
+static void nsp32_message(const char *, int, char *, char *, ...);
+static void nsp32_dmessage(const char *, int, int, char *, ...);
 static void nsp32_build_identify(nsp32_hw_data *, Scsi_Cmnd *);
 static void nsp32_build_sdtr(nsp32_hw_data *, unsigned char, unsigned char);
 static void nsp32_build_nop(nsp32_hw_data *);
@@ -318,7 +319,6 @@ static void nsp32_wait_sack(nsp32_hw_dat
 static void nsp32_sack_assert(nsp32_hw_data *);
 static void nsp32_sack_negate(nsp32_hw_data *);
 static void nsp32_do_bus_reset(nsp32_hw_data *);
-static void do_nsp32_isr(int, void *, struct pt_regs *);
 
 static int nsp32_getprom_param(nsp32_hw_data *);
 static int nsp32_getprom_new(nsp32_hw_data *);
@@ -398,7 +398,7 @@ static Scsi_Host_Template driver_templat
 
 #define NSP32_DEBUG_BUF_LEN		100
 
-static void nsp32_message(char *func, int line, char *type, char *fmt, ...)
+static void nsp32_message(const char *func, int line, char *type, char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP32_DEBUG_BUF_LEN];
@@ -414,7 +414,7 @@ static void nsp32_message(char *func, in
 #endif
 }
 
-static void nsp32_dmessage(char *func, int line, int mask, char *fmt, ...)
+static void nsp32_dmessage(const char *func, int line, int mask, char *fmt, ...)
 {
 	va_list args;
 	char buf[NSP32_DEBUG_BUF_LEN];
@@ -1263,7 +1263,7 @@ static int nsp32hw_init(struct Scsi_Host
 
 
 /* interrupt routine */
-static void do_nsp32_isr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_nsp32_isr(int irq, void *dev_id, struct pt_regs *regs)
 {
 	nsp32_hw_data *data = dev_id;
 	unsigned int base = data->BaseAddress;
@@ -1272,6 +1272,7 @@ static void do_nsp32_isr(int irq, void *
 	unsigned char busmon, busphase;
 	unsigned long flags;
 	int ret;
+	int handled = 0;
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	struct Scsi_Host *host = data->Host;
@@ -1291,6 +1292,7 @@ static void do_nsp32_isr(int irq, void *
 		nsp32_msg(KERN_INFO, "spurious interrupt: irq other 0x%x", irq_stat);
 		goto out2;
 	}
+	handled = 1;
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
 
 	busmon = nsp32_read1(base, SCSI_BUS_MONITOR);
@@ -1547,7 +1549,7 @@ static void do_nsp32_isr(int irq, void *
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
-	return;
+	return IRQ_RETVAL(handled);
 }
 
 #undef SPRINTF
diff -puN drivers/scsi/nsp32.h~irqreturn-drivers-scsi drivers/scsi/nsp32.h
--- 25/drivers/scsi/nsp32.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/nsp32.h	2003-04-24 05:17:33.000000000 -0700
@@ -425,5 +425,5 @@ static char * nsp32_model[] = {
 #define BUSPHASE_STATUS      ( BUSMON_STATUS      & BUSMON_PHASE_MASK )
 #define BUSPHASE_SELECT      ( BUSMON_SEL | BUSMON_IO )
 
-#endif _NSP32_H
+#endif	/* _NSP32_H */
 /* end */
diff -puN drivers/scsi/nsp32_io.h~irqreturn-drivers-scsi drivers/scsi/nsp32_io.h
--- 25/drivers/scsi/nsp32_io.h~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/nsp32_io.h	2003-04-24 05:17:33.000000000 -0700
@@ -265,5 +265,5 @@ static inline void nsp32_fifo_write(unsi
 	nsp32_multi_write4(base, FIFO_DATA_LOW, buf, count);
 }
 
-#endif _NSP32_IO_H
+#endif	/* _NSP32_IO_H */
 /* end */
diff -puN drivers/scsi/pci2000.c~irqreturn-drivers-scsi drivers/scsi/pci2000.c
--- 25/drivers/scsi/pci2000.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/pci2000.c	2003-04-24 05:17:33.000000000 -0700
@@ -262,7 +262,7 @@ static int PsiRaidCmd (PADAPTER2000 pada
  *	Returns:		TRUE if drive is not ready in time.
  *
  ****************************************************************/
-static void Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
 	{
 	struct Scsi_Host   *shost = NULL;	// Pointer to host data block
 	PADAPTER2000		padapter;		// Pointer to adapter control structure
@@ -275,7 +275,7 @@ static void Irq_Handler (int irq, void *
 	int					bus;
 	int					z;
     unsigned long		flags;
-
+    int handled = 0;
 
 	DEB(printk ("\npci2000 received interrupt "));
 	for ( z = 0; z < NumAdapters;  z++ )										// scan for interrupt to process
@@ -297,6 +297,7 @@ static void Irq_Handler (int irq, void *
 		goto out;
 		}
 
+    handled = 1;
 	spin_lock_irqsave(shost->host_lock, flags);
 	padapter = HOSTDATA(shost);
 
@@ -391,7 +392,8 @@ irqProceed:;
 
 irq_return:
     spin_unlock_irqrestore(shost->host_lock, flags);
-out:;
+out:
+    return IRQ_RETVAL(handled);
 }
 /****************************************************************
  *	Name:	Pci2000_QueueCommand
diff -puN drivers/scsi/pci2220i.c~irqreturn-drivers-scsi drivers/scsi/pci2220i.c
--- 25/drivers/scsi/pci2220i.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/pci2220i.c	2003-04-24 05:17:33.000000000 -0700
@@ -1586,7 +1586,7 @@ reconTimerExpiry:;
  *	Returns:		TRUE if drive is not ready in time.
  *
  ****************************************************************/
-static void Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
 	{
 	struct Scsi_Host   *shost = NULL;	// Pointer to host data block
 	PADAPTER2220I		padapter;		// Pointer to adapter control structure
@@ -1600,6 +1600,7 @@ static void Irq_Handler (int irq, void *
 	int					z;
 	ULONG				zl;
     unsigned long		flags;
+    int handled = 0;
 
 //	DEB (printk ("\npci2220i received interrupt\n"));
 
@@ -1621,6 +1622,7 @@ static void Irq_Handler (int irq, void *
 		goto out;
 		}
 
+	handled = 1;
 	spin_lock_irqsave(shost->host_lock, flags);
 	padapter = HOSTDATA(shost);
 	pdev = padapter->pdev;
@@ -2025,8 +2027,10 @@ static void Irq_Handler (int irq, void *
 	OpDone (padapter, zl);
 irq_return:
     spin_unlock_irqrestore(shost->host_lock, flags);
-out:;
-	}
+out:
+	return IRQ_RETVAL(handled);
+}
+
 /****************************************************************
  *	Name:	Pci2220i_QueueCommand
  *
diff -puN drivers/scsi/psi240i.c~irqreturn-drivers-scsi drivers/scsi/psi240i.c
--- 25/drivers/scsi/psi240i.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/psi240i.c	2003-04-24 05:17:33.000000000 -0700
@@ -367,15 +367,18 @@ irqerror:;
 	SCpnt->result = DecodeError (shost, status);
 	SCpnt->scsi_done (SCpnt);
 	}
-static void do_Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
-	{
+
+static irqreturn_t do_Irq_Handler (int irq, void *dev_id, struct pt_regs *regs)
+{
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
 	Irq_Handler(irq, dev_id, regs);
 	spin_unlock_irqrestore(dev->host_lock, flags);
-	}
+	return IRQ_HANDLED;
+}
+
 /****************************************************************
  *	Name:	Psi240i_QueueCommand
  *
diff -puN drivers/scsi/qlogicfas.c~irqreturn-drivers-scsi drivers/scsi/qlogicfas.c
--- 25/drivers/scsi/qlogicfas.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/qlogicfas.c	2003-04-24 05:17:33.000000000 -0700
@@ -526,7 +526,7 @@ static void ql_ihandl(int irq, void *dev
 	(icmd->scsi_done) (icmd);
 }
 
-static void do_ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *host = dev_id;
@@ -534,6 +534,7 @@ static void do_ql_ihandl(int irq, void *
 	spin_lock_irqsave(host->host_lock, flags);
 	ql_ihandl(irq, dev_id, regs);
 	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 #endif
diff -puN drivers/scsi/seagate.c~irqreturn-drivers-scsi drivers/scsi/seagate.c
--- 25/drivers/scsi/seagate.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/seagate.c	2003-04-24 05:17:33.000000000 -0700
@@ -333,7 +333,7 @@ static Signature __initdata signatures[]
 
 static int hostno = -1;
 static void seagate_reconnect_intr (int, void *, struct pt_regs *);
-static void do_seagate_reconnect_intr (int, void *, struct pt_regs *);
+static irqreturn_t do_seagate_reconnect_intr (int, void *, struct pt_regs *);
 
 #ifdef FAST
 static int fast = 1;
@@ -621,7 +621,8 @@ static int should_reconnect = 0;
  * asserting SEL.
  */
 
-static void do_seagate_reconnect_intr (int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_seagate_reconnect_intr(int irq, void *dev_id,
+						struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *dev = dev_id;
@@ -629,6 +630,7 @@ static void do_seagate_reconnect_intr (i
 	spin_lock_irqsave (dev->host_lock, flags);
 	seagate_reconnect_intr (irq, dev_id, regs);
 	spin_unlock_irqrestore (dev->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static void seagate_reconnect_intr (int irq, void *dev_id, struct pt_regs *regs)
diff -puN drivers/scsi/sym53c416.c~irqreturn-drivers-scsi drivers/scsi/sym53c416.c
--- 25/drivers/scsi/sym53c416.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/sym53c416.c	2003-04-24 05:17:33.000000000 -0700
@@ -327,7 +327,8 @@ static __inline__ unsigned int sym53c416
 	return orig_len - len;
 }
 
-static void sym53c416_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	struct Scsi_Host *dev = dev_id;
 	int base = 0;
@@ -348,7 +349,7 @@ static void sym53c416_intr_handle(int ir
 	if(!base)
 	{
 		printk(KERN_ERR "sym53c416: No host adapter defined for interrupt %d\n", irq);
-		return;
+		return IRQ_NONE;
 	}
 	/* Now we have the base address and we can start handling the interrupt */
 
@@ -367,7 +368,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	if(int_reg & ILCMD)       /* Illegal Command */
 	{
@@ -377,7 +378,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	if(status_reg & GE)         /* Gross Error */
 	{
@@ -387,7 +388,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	if(status_reg & PE)         /* Parity Error */
 	{
@@ -397,7 +398,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	if(pio_int_reg & (CE | OUE))
 	{
@@ -407,7 +408,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	if(int_reg & DIS)           /* Disconnect */
 	{
@@ -419,7 +420,7 @@ static void sym53c416_intr_handle(int ir
 		spin_lock_irqsave(dev->host_lock, flags);
 		current_command->scsi_done(current_command);
 		spin_unlock_irqrestore(dev->host_lock, flags);
-		return;
+		goto out;
 	}
 	/* Now we handle SCSI phases         */
 
@@ -518,6 +519,8 @@ static void sym53c416_intr_handle(int ir
 			break;
 		}
 	}
+out:
+	return IRQ_HANDLED;
 }
 
 static void sym53c416_init(int base, int scsi_id)
diff -puN drivers/scsi/u14-34f.c~irqreturn-drivers-scsi drivers/scsi/u14-34f.c
--- 25/drivers/scsi/u14-34f.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/u14-34f.c	2003-04-24 05:17:33.000000000 -0700
@@ -604,7 +604,7 @@ static unsigned long io_port[] = {
 #define H2DEV(x) cpu_to_le32(x)
 #define DEV2H(x) le32_to_cpu(x)
 
-static void do_interrupt_handler(int, void *, struct pt_regs *);
+static irqreturn_t do_interrupt_handler(int, void *, struct pt_regs *);
 static void flush_dev(Scsi_Device *, unsigned long, unsigned int, unsigned int);
 static int do_trace = FALSE;
 static int setup_done = FALSE;
@@ -1890,7 +1890,9 @@ static void ihdlr(int irq, unsigned int 
    return;
 }
 
-static void do_interrupt_handler(int irq, void *shap, struct pt_regs *regs) {
+static irqreturn_t do_interrupt_handler(int irq, void *shap,
+					struct pt_regs *regs)
+{
    unsigned int j;
    unsigned long spin_flags;
 
@@ -1900,6 +1902,7 @@ static void do_interrupt_handler(int irq
    spin_lock_irqsave(sh[j]->host_lock, spin_flags);
    ihdlr(irq, j);
    spin_unlock_irqrestore(sh[j]->host_lock, spin_flags);
+   return IRQ_HANDLED;
 }
 
 static int u14_34f_release(struct Scsi_Host *shpnt) {
diff -puN drivers/scsi/ultrastor.c~irqreturn-drivers-scsi drivers/scsi/ultrastor.c
--- 25/drivers/scsi/ultrastor.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/ultrastor.c	2003-04-24 05:17:33.000000000 -0700
@@ -288,7 +288,7 @@ static const unsigned short ultrastor_po
 #endif
 
 static void ultrastor_interrupt(int, void *, struct pt_regs *);
-static void do_ultrastor_interrupt(int, void *, struct pt_regs *);
+static irqreturn_t do_ultrastor_interrupt(int, void *, struct pt_regs *);
 static inline void build_sg_list(struct mscp *, Scsi_Cmnd *SCpnt);
 
 
@@ -1160,7 +1160,8 @@ static void ultrastor_interrupt(int irq,
 #endif
 }
 
-static void do_ultrastor_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_ultrastor_interrupt(int irq, void *dev_id,
+						struct pt_regs *regs)
 {
     unsigned long flags;
     struct Scsi_Host *dev = dev_id;
@@ -1168,6 +1169,7 @@ static void do_ultrastor_interrupt(int i
     spin_lock_irqsave(dev->host_lock, flags);
     ultrastor_interrupt(irq, dev_id, regs);
     spin_unlock_irqrestore(dev->host_lock, flags);
+    return IRQ_HANDLED;
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/scsi/wd7000.c~irqreturn-drivers-scsi drivers/scsi/wd7000.c
--- 25/drivers/scsi/wd7000.c~irqreturn-drivers-scsi	2003-04-24 05:17:32.000000000 -0700
+++ 25-akpm/drivers/scsi/wd7000.c	2003-04-24 05:17:33.000000000 -0700
@@ -1121,7 +1121,8 @@ static void wd7000_intr_handle(int irq, 
 	dprintk("wd7000_intr_handle: return from interrupt handler\n");
 }
 
-static void do_wd7000_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t do_wd7000_intr_handle(int irq, void *dev_id,
+					struct pt_regs *regs)
 {
 	unsigned long flags;
 	struct Scsi_Host *host = dev_id;
@@ -1129,6 +1130,7 @@ static void do_wd7000_intr_handle(int ir
 	spin_lock_irqsave(host->host_lock, flags);
 	wd7000_intr_handle(irq, dev_id, regs);
 	spin_unlock_irqrestore(host->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 

_

