From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix unaligned-access kernel panic under heavy
 disk testing
Date: Tue, 23 Jul 2013 15:33:11 -0700
Message-ID: <1374618791.2290.53.camel@dabdike>
References: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>
	 <1374613204.2290.49.camel@dabdike> <51EEF2DA.3070903@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51EEF2DA.3070903@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jianpeng Ma <majianpeng@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-07-23 at 17:17 -0400, Chris Metcalf wrote:
> On 7/23/2013 5:00 PM, James Bottomley wrote:
> > On Tue, 2013-07-23 at 16:50 -0400, Chris Metcalf wrote:
> >> > The slot->response value may not be aligned, so should be read
> >> > using the appropriate kernel "unaligned" accessor.
> > Hm, institutional memory re-presenting the wrong patch?  However, I am
> > reminded to push the right one in spite of no ack from marvell.
> 
> You may be right; the original author of that patch is not me, but someone else here at Tilera.
> 
> That said, the version I pushed is effectively the version we have in the tip of our tree, so if we've ended up carrying the wrong patch, that's bad!  Let me know what the right patch is that you have - thanks.

This is what I have.

James

---
>From 53a983c4f8b4246f5ff00567411be55967b0350a Mon Sep 17 00:00:00 2001
From: James Bottomley <JBottomley@Parallels.com>
Date: Sun, 9 Jun 2013 09:23:16 -0700
Subject: [PATCH] [SCSI] mvsas: Fix kernel panic on tile due to unaligned data
 access

slot->response is a 64 bit quantity (and accessed as such), but its alignment
is only 32 bits.  This doesn't cause a problem on x86, but apparently causes a
kernel panic on Tile:

Stack dump complete Kernel panic - not syncing:
 Kernel unalign fault running the idle task!
 Starting stack dump of tid 0, pid 0 (swapper) on cpu 1 at cycle 341586172541
   frame 0: 0xfffffff700140ee0 dump_stack+0x0/0x20 (sp 0xfffffe43ffedf420)
   frame 1: 0xfffffff700283270 panic+0x150/0x3a0 (sp 0xfffffe43ffedf420)
   frame 2: 0xfffffff70012bff8 jit_bundle_gen+0xfd8/0x27e0 (sp 0xfffffe43ffedf4c8)
   frame 3: 0xfffffff7003b5b68 do_unaligned+0xc0/0x5a0 (sp 0xfffffe43ffedf710)
   frame 4: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffffe43ffedf840)
   <interrupt 17 while in kernel mode>
   frame 5: 0xfffffff7002ac370 mvs_slot_complete+0x5f0/0x12a0 (sp 0xfffffe43ffedfa90)
   frame 6: 0xfffffff7002abec0 mvs_slot_complete+0x140/0x12a0 (sp 0xfffffe43ffedfa90)
   frame 7: 0xfffffff7005cc840 mvs_int_rx+0x140/0x2a0 (sp 0xfffffe43ffedfb00)
   frame 8: 0xfffffff7005bbaf0 mvs_94xx_isr+0xd8/0x2b8 (sp 0xfffffe43ffedfb68)
   frame 9: 0xfffffff700658ba0 mvs_tasklet+0x128/0x1f8 (sp 0xfffffe43ffedfba8)
   frame 10: 0xfffffff7003e8230 tasklet_action+0x178/0x2c8 (sp 0xfffffe43ffedfbe0)
   frame 11: 0xfffffff700103850 __do_softirq+0x210/0x398 (sp 0xfffffe43ffedfc40)
   frame 12: 0xfffffff700180308 do_softirq+0xc8/0x140 (sp 0xfffffe43ffedfcd8)
   frame 13: 0xfffffff7000bd7f0 irq_exit+0xb0/0x158 (sp 0xfffffe43ffedfcf0)
   frame 14: 0xfffffff70013fa58 tile_dev_intr+0x1d8/0x2f0 (sp 0xfffffe43ffedfd00)
   frame 15: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffffe43ffedfd40)
   <interrupt 30 while in kernel mode>
   frame 16: 0xfffffff700143e68 _cpu_idle_nap+0x0/0x18 (sp 0xfffffe43ffedffb0)
   frame 17: 0xfffffff700482480 cpu_idle+0x310/0x428 (sp 0xfffffe43ffedffb0)

Since the check is just for non-zero, split it to be two 32 bit accesses
(preserving speed in the fast path) and do a get_unaligned() in the slow path.

This is a modification of a wholly get_unaligned patch submitted by Paul Guo

Reported-by: Paul Guo <ggang@tilera.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f14665a..6b1b4e9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1857,11 +1857,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		goto out;
 	}
 
-	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	/*
+	 * error info record present; slot->response is 32 bit aligned but may
+	 * not be 64 bit aligned, so check for zero in two 32 bit reads
+	 */
+	if (unlikely((rx_desc & RXQ_ERR)
+		     && (*((u32 *)slot->response)
+			 || *(((u32 *)slot->response) + 1)))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			 rx_desc, get_unaligned_le64(slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 60e2fb7..d6b19dc 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/unaligned.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
