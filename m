From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: PATCH [14/18] qla2xxx: Use proper include files
Date: Tue, 22 Jun 2004 09:50:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD027D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:1878 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264278AbUFVQwx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 12:52:53 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>


On Tuesday, June 22, 2004 1:57 AM, Christoph Hellwig wrote:
> >  #include <scsi/scsi_ioctl.h>
> > +#include <scsi/scsicam.h>
> >  #include <scsi/scsi_transport.h>
> >  #include <scsi/scsi_transport_fc.h>
> 
> Umm, no.  I moved them away from qla_os.h precisly because I want to
> get rid of that file in the next steps.

Ugg.  Ok, how about this as an alternative - add the necessary
#includes to qla_def.h in order to support its own structure
definitions.  Then add any specifically needed #includes in each of
the supporting .c modules.

This effectively removes qla_os.h from the distribution.  Patch 
inlined.

Regards,
Andrew Vasquez

===== drivers/scsi/qla2xxx/Makefile 1.5 vs edited =====
--- 1.5/drivers/scsi/qla2xxx/Makefile	2004-06-22 09:25:24 -07:00
+++ edited/drivers/scsi/qla2xxx/Makefile	2004-06-22 09:42:28 -07:00
@@ -1,4 +1,4 @@
-EXTRA_CFLAGS += -Idrivers/scsi -DUNIQUE_FW_NAME
+EXTRA_CFLAGS += -DUNIQUE_FW_NAME
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_rscn.o
===== drivers/scsi/qla2xxx/ql2100.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/ql2100.c	2004-03-12 09:06:10 -08:00
+++ edited/drivers/scsi/qla2xxx/ql2100.c	2004-06-22 09:42:29 -07:00
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla2100";
===== drivers/scsi/qla2xxx/ql2200.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/ql2200.c	2004-03-12 09:06:09 -08:00
+++ edited/drivers/scsi/qla2xxx/ql2200.c	2004-06-22 09:42:29 -07:00
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla2200";
===== drivers/scsi/qla2xxx/ql2300.c 1.4 vs edited =====
--- 1.4/drivers/scsi/qla2xxx/ql2300.c	2004-03-12 09:06:10 -08:00
+++ edited/drivers/scsi/qla2xxx/ql2300.c	2004-06-22 09:42:29 -07:00
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla2300";
===== drivers/scsi/qla2xxx/ql6312.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/ql6312.c	2004-03-12 09:06:10 -08:00
+++ edited/drivers/scsi/qla2xxx/ql6312.c	2004-06-22 09:42:29 -07:00
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla6312";
===== drivers/scsi/qla2xxx/ql6322.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/ql6322.c	2004-03-12 09:06:10 -08:00
+++ edited/drivers/scsi/qla2xxx/ql6322.c	2004-06-22 09:42:30 -07:00
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla6322";
===== drivers/scsi/qla2xxx/qla_dbg.c 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_dbg.c	2004-06-16 14:27:58 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_dbg.c	2004-06-22 09:42:30 -07:00
@@ -16,9 +16,9 @@
  * General Public License for more details.
  *
  */
-#include "qla_os.h"
-
 #include "qla_def.h"
+
+#include <linux/delay.h>
 
 static int qla_uprintf(char **, char *, ...);
 
===== drivers/scsi/qla2xxx/qla_def.h 1.19 vs edited =====
--- 1.19/drivers/scsi/qla2xxx/qla_def.h	2004-06-18 10:01:18 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_def.h	2004-06-22 09:42:30 -07:00
@@ -20,6 +20,24 @@
 #ifndef __QLA_DEF_H
 #define __QLA_DEF_H
 
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/spinlock.h>
+#include <linux/completion.h>
+#include <asm/semaphore.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+
 /* XXX(hch): move to pci_ids.h */
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP2300
 #define PCI_DEVICE_ID_QLOGIC_ISP2300	0x2300
@@ -2419,5 +2437,18 @@
 #include "qla_dbg.h"
 #include "qla_inline.h"
 #include "qla_listops.h"
+
+/*
+* String arrays
+*/
+#define LINESIZE    256
+#define MAXARGS      26
+
+#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
+#define CMD_COMPL_STATUS(Cmnd)  ((Cmnd)->SCp.this_residual)
+#define CMD_RESID_LEN(Cmnd)	((Cmnd)->SCp.buffers_residual)
+#define CMD_SCSI_STATUS(Cmnd)	((Cmnd)->SCp.Status)
+#define CMD_ACTUAL_SNSLEN(Cmnd)	((Cmnd)->SCp.Message)
+#define CMD_ENTRY_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
 
 #endif
===== drivers/scsi/qla2xxx/qla_gbl.h 1.12 vs edited =====
--- 1.12/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-16 14:27:58 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_gbl.h	2004-06-22 09:42:30 -07:00
@@ -23,6 +23,8 @@
 #ifndef __QLA_GBL_H
 #define	__QLA_GBL_H
 
+#include <linux/interrupt.h>
+
 extern void qla2x00_remove_one(struct pci_dev *);
 extern int qla2x00_probe_one(struct pci_dev *, struct qla_board_info *);
 
===== drivers/scsi/qla2xxx/qla_gs.c 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_gs.c	2004-05-10 15:29:10 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_gs.c	2004-06-22 09:42:31 -07:00
@@ -16,8 +16,6 @@
  * General Public License for more details.
  *
  */
-#include "qla_os.h"
-
 #include "qla_def.h"
 
 static inline ms_iocb_entry_t *
===== drivers/scsi/qla2xxx/qla_init.c 1.27 vs edited =====
--- 1.27/drivers/scsi/qla2xxx/qla_init.c	2004-06-17 10:04:50 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_init.c	2004-06-22 09:42:31 -07:00
@@ -16,8 +16,10 @@
  * General Public License for more details.
  *
  */
-#include "qla_os.h"
 #include "qla_def.h"
+
+#include <linux/delay.h>
+
 #include "qla_devtbl.h"
 
 /* XXX(hch): this is ugly, but we don't want to pull in exioctl.h */
===== drivers/scsi/qla2xxx/qla_iocb.c 1.9 vs edited =====
--- 1.9/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-03 15:44:16 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-22 09:42:31 -07:00
@@ -17,8 +17,10 @@
  *
  ******************************************************************************/
 
-#include "qla_os.h"
 #include "qla_def.h"
+
+#include <linux/blkdev.h>
+#include <linux/delay.h>
 
 static inline uint16_t qla2x00_get_cmd_direction(struct scsi_cmnd *cmd);
 static inline cont_entry_t *qla2x00_prep_cont_type0_iocb(scsi_qla_host_t *);
===== drivers/scsi/qla2xxx/qla_isr.c 1.13 vs edited =====
--- 1.13/drivers/scsi/qla2xxx/qla_isr.c	2004-06-17 10:04:50 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	2004-06-22 09:42:31 -07:00
@@ -16,9 +16,6 @@
  * General Public License for more details.
  *
  */
-
-#include "qla_os.h"
-
 #include "qla_def.h"
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
===== drivers/scsi/qla2xxx/qla_mbx.c 1.12 vs edited =====
--- 1.12/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-17 10:04:50 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_mbx.c	2004-06-22 09:42:32 -07:00
@@ -16,11 +16,9 @@
  * General Public License for more details.
  *
  */
-
-#include "qla_os.h"
-
 #include "qla_def.h"
 
+#include <linux/delay.h>
 
 static void
 qla2x00_mbx_sem_timeout(unsigned long data)
===== drivers/scsi/qla2xxx/qla_os.c 1.36 vs edited =====
--- 1.36/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:34:28 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-06-22 09:42:32 -07:00
@@ -16,9 +16,15 @@
  * General Public License for more details.
  *
  */
-
-#include "qla_os.h"
 #include "qla_def.h"
+
+#include <linux/vmalloc.h>
+#include <linux/smp_lock.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 
 /*
  * Driver version
===== drivers/scsi/qla2xxx/qla_os.h 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_os.h	2004-06-22 09:25:24 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_os.h	2004-06-22 09:42:48 -07:00
@@ -1,94 +0,0 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
- * (www.qlogic.com)
- *
- * Portions (C) Arjan van de Ven <arjanv@redhat.com> for Red Hat, Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- ******************************************************************************/
-
-#ifndef __QLA_OS_H
-#define __QLA_OS_H
-
-#include <linux/config.h>
-#include <linux/module.h>
-#include <linux/version.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/sched.h>
-#include <linux/pci.h>
-#include <linux/proc_fs.h>
-#include <linux/blkdev.h>
-#include <linux/interrupt.h>
-#include <linux/stat.h>
-#include <linux/slab.h>
-#include <linux/mempool.h>
-#include <linux/vmalloc.h>
-#include <linux/smp_lock.h>
-#include <linux/bio.h>
-#include <linux/moduleparam.h>
-#include <linux/capability.h>
-#include <linux/list.h>
-
-#include <asm/system.h>
-
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/segment.h>
-#include <asm/byteorder.h>
-#include <asm/pgtable.h>
-
-#include <linux/ioctl.h>
-#include <asm/uaccess.h>
-
-#include "scsi.h"
-#include "hosts.h"
-
-#include <scsi/scsicam.h>
-#include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
-
-//TODO Fix this!!!
-/*
-* String arrays
-*/
-#define LINESIZE    256
-#define MAXARGS      26
-
-/***********************************************************************
-* We use the struct scsi_pointer structure that's included with each 
-* command SCSI_Cmnd as a scratchpad. 
-*
-* SCp is defined as follows:
-*  - SCp.ptr  -- > pointer to the SRB
-*  - SCp.this_residual  -- > HBA completion status for ioctl code. 
-*
-* Cmnd->host_scribble --> Used to hold the hba actived handle (1..255).
-***********************************************************************/
-#define	CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
-#define CMD_COMPL_STATUS(Cmnd)  ((Cmnd)->SCp.this_residual)
-/* Additional fields used by ioctl passthru */
-#define CMD_RESID_LEN(Cmnd)	((Cmnd)->SCp.buffers_residual)
-#define CMD_SCSI_STATUS(Cmnd)	((Cmnd)->SCp.Status)
-#define CMD_ACTUAL_SNSLEN(Cmnd)	((Cmnd)->SCp.Message)
-#define CMD_ENTRY_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
-
-#endif
===== drivers/scsi/qla2xxx/qla_rscn.c 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_rscn.c	2004-06-03 15:00:39 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_rscn.c	2004-06-22 09:42:32 -07:00
@@ -16,8 +16,6 @@
  * General Public License for more details.
  *
  */
-#include "qla_os.h"
-
 #include "qla_def.h"
 
 /**
===== drivers/scsi/qla2xxx/qla_sup.c 1.4 vs edited =====
--- 1.4/drivers/scsi/qla2xxx/qla_sup.c	2004-05-03 08:13:09 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_sup.c	2004-06-22 09:42:33 -07:00
@@ -17,8 +17,10 @@
  *
  ******************************************************************************/
 
-#include "qla_os.h"
 #include "qla_def.h"
+
+#include <linux/delay.h>
+#include <asm/uaccess.h>
 
 static uint16_t qla2x00_nvram_request(scsi_qla_host_t *, uint32_t);
 static void qla2x00_nv_deselect(scsi_qla_host_t *);
