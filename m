From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/4] drivers/scsi/u14-34f.c: Use time_before, time_before_eq,
 etc.
Date: Wed, 26 Dec 2007 16:23:53 +0100 (MET)
Message-ID: <Pine.LNX.4.58.0712261623060.1185@pc-041.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752758AbXLZPYh@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ballabio_dario@emc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p linux-2.6/drivers/scsi/u14-34f.c linuxcopy/drivers/scsi/u14-34f.c
--- linux-2.6/drivers/scsi/u14-34f.c	2007-10-22 11:25:24.000000000 +0200
+++ linuxcopy/drivers/scsi/u14-34f.c	2007-12-26 16:09:12.000000000 +0100
@@ -420,6 +420,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 #include <asm/dma.h>
 #include <asm/irq.h>

@@ -745,7 +746,8 @@ static int wait_on_busy(unsigned long io
 static int board_inquiry(unsigned int j) {
    struct mscp *cpp;
    dma_addr_t id_dma_addr;
-   unsigned int time, limit = 0;
+   unsigned long time;
+   unsigned int limit = 0;

    id_dma_addr = pci_map_single(HD(j)->pdev, HD(j)->board_id,
                     sizeof(HD(j)->board_id), PCI_DMA_BIDIRECTIONAL);
@@ -778,7 +780,7 @@ static int board_inquiry(unsigned int j)

    spin_unlock_irq(&driver_lock);
    time = jiffies;
-   while ((jiffies - time) < HZ && limit++ < 20000) udelay(100L);
+   while (time_before(jiffies, time + HZ) && limit++ < 20000) udelay(100L);
    spin_lock_irq(&driver_lock);

    if (cpp->adapter_status || HD(j)->cp_stat[0] != FREE) {
@@ -1393,7 +1395,8 @@ static int u14_34f_eh_abort(struct scsi_
 }

 static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
-   unsigned int i, j, time, k, c, limit = 0;
+   unsigned long time;
+   unsigned int i, j, k, c, limit = 0;
    int arg_done = FALSE;
    struct scsi_cmnd *SCpnt;

@@ -1479,7 +1482,8 @@ static int u14_34f_eh_host_reset(struct

    spin_unlock_irq(sh[j]->host_lock);
    time = jiffies;
-   while ((jiffies - time) < (10 * HZ) && limit++ < 200000) udelay(100L);
+   while (time_before(jiffies, time + 10 * HZ) && limit++ < 200000)
+	udelay(100L);
    spin_lock_irq(sh[j]->host_lock);

    printk("%s: reset, interrupts disabled, loops %d.\n", BN(j), limit);
