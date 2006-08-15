From: akpm@osdl.org
Subject: [patch 11/24] drivers/scsi/advansys.c: cleanups
Date: Mon, 14 Aug 2006 23:09:25 -0700
Message-ID: <200608150609.k7F69Pp9013232@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:64150 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965200AbWHOGMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:12:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

- remove the unneeded advansys.h
- remove the unused advansys_setup()
- make needlessly global functions static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |  101 +++-----------------------------------
 drivers/scsi/advansys.h |   36 -------------
 2 files changed, 8 insertions(+), 129 deletions(-)

diff -puN drivers/scsi/advansys.c~drivers-scsi-advansysc-cleanups drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~drivers-scsi-advansysc-cleanups
+++ a/drivers/scsi/advansys.c
@@ -798,7 +798,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-#include "advansys.h"
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
 #endif /* CONFIG_PCI */
@@ -2014,7 +2013,7 @@ STATIC int       AscSgListToQueue(int);
 STATIC void      AscEnableIsaDma(uchar);
 #endif /* CONFIG_ISA */
 STATIC ASC_DCNT  AscGetMaxDmaCount(ushort);
-
+static const char *advansys_info(struct Scsi_Host *shp);
 
 /*
  * --- Adv Library Constants and Macros
@@ -3970,10 +3969,6 @@ STATIC ushort asc_bus[ASC_NUM_BUS] __ini
     ASC_IS_PCI,
 };
 
-/*
- * Used with the LILO 'advansys' option to eliminate or
- * limit I/O port probing at boot time, cf. advansys_setup().
- */
 STATIC int asc_iopflag = ASC_FALSE;
 STATIC int asc_ioport[ASC_NUM_IOPORT_PROBE] = { 0, 0, 0, 0 };
 
@@ -4055,10 +4050,6 @@ STATIC void         asc_prt_hex(char *f,
 #endif /* ADVANSYS_DEBUG */
 
 
-/*
- * --- Linux 'struct scsi_host_template' and advansys_setup() Functions
- */
-
 #ifdef CONFIG_PROC_FS
 /*
  * advansys_proc_info() - /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
@@ -4080,7 +4071,7 @@ STATIC void         asc_prt_hex(char *f,
  * if 'prtbuf' is too small it will not be overwritten. Instead the
  * user just won't get all the available statistics.
  */
-int
+static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		off_t offset, int length, int inout)
 {
@@ -4296,7 +4287,7 @@ advansys_proc_info(struct Scsi_Host *sho
  * it must not call SCSI mid-level functions including scsi_malloc()
  * and scsi_free().
  */
-int __init
+static int __init
 advansys_detect(struct scsi_host_template *tpnt)
 {
     static int          detect_called = ASC_FALSE;
@@ -5428,7 +5419,7 @@ advansys_detect(struct scsi_host_templat
  *
  * Release resources allocated for a single AdvanSys adapter.
  */
-int
+static int
 advansys_release(struct Scsi_Host *shp)
 {
     asc_board_t    *boardp;
@@ -5475,7 +5466,7 @@ advansys_release(struct Scsi_Host *shp)
  * Note: The information line should not exceed ASC_INFO_SIZE bytes,
  * otherwise the static 'info' array will be overrun.
  */
-const char *
+static const char *
 advansys_info(struct Scsi_Host *shp)
 {
     static char     info[ASC_INFO_SIZE];
@@ -5568,7 +5559,7 @@ advansys_info(struct Scsi_Host *shp)
  * This function always returns 0. Command return status is saved
  * in the 'scp' result field.
  */
-int
+static int
 advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
     struct Scsi_Host    *shp;
@@ -5656,7 +5647,7 @@ advansys_queuecommand(struct scsi_cmnd *
  * sleeping is allowed and no locking other than for host structures is
  * required. Returns SUCCESS or FAILED.
  */
-int
+static int
 advansys_reset(struct scsi_cmnd *scp)
 {
     struct Scsi_Host     *shp;
@@ -5841,7 +5832,7 @@ advansys_reset(struct scsi_cmnd *scp)
  * ip[1]: sectors
  * ip[2]: cylinders
  */
-int
+static int
 advansys_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int ip[])
 {
@@ -5875,82 +5866,6 @@ advansys_biosparam(struct scsi_device *s
 }
 
 /*
- * advansys_setup()
- *
- * This function is called from init/main.c at boot time.
- * It it passed LILO parameters that can be set from the
- * LILO command line or in /etc/lilo.conf.
- *
- * It is used by the AdvanSys driver to either disable I/O
- * port scanning or to limit scanning to 1 - 4 I/O ports.
- * Regardless of the option setting EISA and PCI boards
- * will still be searched for and detected. This option
- * only affects searching for ISA and VL boards.
- *
- * If ADVANSYS_DEBUG is defined the driver debug level may
- * be set using the 5th (ASC_NUM_IOPORT_PROBE + 1) I/O Port.
- *
- * Examples:
- * 1. Eliminate I/O port scanning:
- *         boot: linux advansys=
- *       or
- *         boot: linux advansys=0x0
- * 2. Limit I/O port scanning to one I/O port:
- *        boot: linux advansys=0x110
- * 3. Limit I/O port scanning to four I/O ports:
- *        boot: linux advansys=0x110,0x210,0x230,0x330
- * 4. If ADVANSYS_DEBUG, limit I/O port scanning to four I/O ports and
- *    set the driver debug level to 2.
- *        boot: linux advansys=0x110,0x210,0x230,0x330,0xdeb2
- *
- * ints[0] - number of arguments
- * ints[1] - first argument
- * ints[2] - second argument
- * ...
- */
-void __init
-advansys_setup(char *str, int *ints)
-{
-    int    i;
-
-    if (asc_iopflag == ASC_TRUE) {
-        printk("AdvanSys SCSI: 'advansys' LILO option may appear only once\n");
-        return;
-    }
-
-    asc_iopflag = ASC_TRUE;
-
-    if (ints[0] > ASC_NUM_IOPORT_PROBE) {
-#ifdef ADVANSYS_DEBUG
-        if ((ints[0] == ASC_NUM_IOPORT_PROBE + 1) &&
-            (ints[ASC_NUM_IOPORT_PROBE + 1] >> 4 == 0xdeb)) {
-            asc_dbglvl = ints[ASC_NUM_IOPORT_PROBE + 1] & 0xf;
-        } else {
-#endif /* ADVANSYS_DEBUG */
-            printk("AdvanSys SCSI: only %d I/O ports accepted\n",
-                ASC_NUM_IOPORT_PROBE);
-#ifdef ADVANSYS_DEBUG
-        }
-#endif /* ADVANSYS_DEBUG */
-    }
-
-#ifdef ADVANSYS_DEBUG
-    ASC_DBG1(1, "advansys_setup: ints[0] %d\n", ints[0]);
-    for (i = 1; i < ints[0]; i++) {
-        ASC_DBG2(1, " ints[%d] 0x%x", i, ints[i]);
-    }
-    ASC_DBG(1, "\n");
-#endif /* ADVANSYS_DEBUG */
-
-    for (i = 1; i <= ints[0] && i <= ASC_NUM_IOPORT_PROBE; i++) {
-        asc_ioport[i-1] = ints[i];
-        ASC_DBG2(1, "advansys_setup: asc_ioport[%d] 0x%x\n",
-            i - 1, asc_ioport[i-1]);
-    }
-}
-
-
-/*
  * --- Loadable Driver Support
  */
 
diff -puN drivers/scsi/advansys.h~drivers-scsi-advansysc-cleanups /dev/null
--- a/drivers/scsi/advansys.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * advansys.h - Linux Host Driver for AdvanSys SCSI Adapters
- * 
- * Copyright (c) 1995-2000 Advanced System Products, Inc.
- * Copyright (c) 2000-2001 ConnectCom Solutions, Inc.
- * All Rights Reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that redistributions of source
- * code retain the above copyright notice and this comment without
- * modification.
- *
- * As of March 8, 2000 Advanced System Products, Inc. (AdvanSys)
- * changed its name to ConnectCom Solutions, Inc.
- *
- */
-
-#ifndef _ADVANSYS_H
-#define _ADVANSYS_H
-
-/*
- * struct scsi_host_template function prototypes.
- */
-int advansys_detect(struct scsi_host_template *);
-int advansys_release(struct Scsi_Host *);
-const char *advansys_info(struct Scsi_Host *);
-int advansys_queuecommand(struct scsi_cmnd *, void (* done)(struct scsi_cmnd *));
-int advansys_reset(struct scsi_cmnd *);
-int advansys_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int[]);
-static int advansys_slave_configure(struct scsi_device *);
-
-/* init/main.c setup function */
-void advansys_setup(char *, int *);
-
-#endif /* _ADVANSYS_H */
_
