From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 17/34] scsi proc_ops: convert drivers/scsi/aic7xxx_old.c
Date: Wed, 22 Feb 2012 22:46:08 +0300
Message-ID: <1329939985-26793-17-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab2BVTrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:04 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:03 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/aic7xxx_old.c              |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |  240 +++++++++----------------------
 2 files changed, 72 insertions(+), 170 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..aab11d1 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -11108,7 +11108,7 @@ MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
 static struct scsi_host_template driver_template = {
-	.proc_info		= aic7xxx_proc_info,
+	.proc_ops		= &aic7xxx_proc_ops,
 	.detect			= aic7xxx_detect,
 	.release		= aic7xxx_release,
 	.info			= aic7xxx_info,	
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
index b07e4f0..05d4d66 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -28,64 +28,17 @@
  *
  *  $Id: aic7xxx_proc.c,v 4.1 1997/06/97 08:23:42 deang Exp $
  *-M*************************************************************************/
+#include <linux/seq_file.h>
 
-
-#define	BLS	(&aic7xxx_buffer[size])
 #define HDRB \
 "               0 - 4K   4 - 16K   16 - 64K  64 - 256K  256K - 1M        1M+"
 
-#ifdef PROC_DEBUG
-extern int vsprintf(char *, const char *, va_list);
-
-static void
-proc_debug(const char *fmt, ...)
-{
-  va_list ap;
-  char buf[256];
-
-  va_start(ap, fmt);
-  vsprintf(buf, fmt, ap);
-  printk(buf);
-  va_end(ap);
-}
-#else /* PROC_DEBUG */
-#  define proc_debug(fmt, args...)
-#endif /* PROC_DEBUG */
-
-static int aic7xxx_buffer_size = 0;
-static char *aic7xxx_buffer = NULL;
-
-
-/*+F*************************************************************************
- * Function:
- *   aic7xxx_set_info
- *
- * Description:
- *   Set parameters for the driver from the /proc filesystem.
- *-F*************************************************************************/
-static int
-aic7xxx_set_info(char *buffer, int length, struct Scsi_Host *HBAptr)
-{
-  proc_debug("aic7xxx_set_info(): %s\n", buffer);
-  return (-ENOSYS);  /* Currently this is a no-op */
-}
-
-
-/*+F*************************************************************************
- * Function:
- *   aic7xxx_proc_info
- *
- * Description:
- *   Return information to handle /proc support for the driver.
- *-F*************************************************************************/
-int
-aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t offset, int length, 
-                    int inout)
+static int aic7xxx_proc_show(struct seq_file *m, void *v)
 {
+  struct Scsi_Host *HBAptr = m->private;
   struct aic7xxx_host *p;
   struct aic_dev_data *aic_dev;
   struct scsi_device *sdptr;
-  int    size = 0;
   unsigned char i;
   unsigned char tindex;
 
@@ -94,66 +47,21 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
 
   if (!p)
   {
-    size += sprintf(buffer, "Can't find adapter for host number %d\n", HBAptr->host_no);
-    if (size > length)
-    {
-      return (size);
-    }
-    else
-    {
-      return (length);
-    }
-  }
-
-  if (inout == TRUE) /* Has data been written to the file? */ 
-  {
-    return (aic7xxx_set_info(buffer, length, HBAptr));
+    seq_printf(m, "Can't find adapter for host number %d\n", HBAptr->host_no);
+    return 0;
   }
 
   p = (struct aic7xxx_host *) HBAptr->hostdata;
 
-  /*
-   * It takes roughly 1K of space to hold all relevant card info, not
-   * counting any proc stats, so we start out with a 1.5k buffer size and
-   * if proc_stats is defined, then we sweep the stats structure to see
-   * how many drives we will be printing out for and add 384 bytes per
-   * device with active stats.
-   *
-   * Hmmmm...that 1.5k seems to keep growing as items get added so they
-   * can be easily viewed for debugging purposes.  So, we bumped that
-   * 1.5k to 4k so we can quit having to bump it all the time.
-   */
-
-  size = 4096;
-  list_for_each_entry(aic_dev, &p->aic_devs, list)
-    size += 512;
-  if (aic7xxx_buffer_size != size)
-  {
-    if (aic7xxx_buffer != NULL) 
-    {
-      kfree(aic7xxx_buffer);
-      aic7xxx_buffer_size = 0;
-    }
-    aic7xxx_buffer = kmalloc(size, GFP_KERNEL);
-  }
-  if (aic7xxx_buffer == NULL)
-  {
-    size = sprintf(buffer, "AIC7xxx - kmalloc error at line %d\n",
-        __LINE__);
-    return size;
-  }
-  aic7xxx_buffer_size = size;
-
-  size = 0;
-  size += sprintf(BLS, "Adaptec AIC7xxx driver version: ");
-  size += sprintf(BLS, "%s/", AIC7XXX_C_VERSION);
-  size += sprintf(BLS, "%s", AIC7XXX_H_VERSION);
-  size += sprintf(BLS, "\n");
-  size += sprintf(BLS, "Adapter Configuration:\n");
-  size += sprintf(BLS, "           SCSI Adapter: %s\n",
+  seq_printf(m, "Adaptec AIC7xxx driver version: ");
+  seq_printf(m, "%s/", AIC7XXX_C_VERSION);
+  seq_printf(m, "%s", AIC7XXX_H_VERSION);
+  seq_printf(m, "\n");
+  seq_printf(m, "Adapter Configuration:\n");
+  seq_printf(m, "           SCSI Adapter: %s\n",
       board_names[p->board_name_index]);
   if (p->flags & AHC_TWIN)
-    size += sprintf(BLS, "                         Twin Channel Controller ");
+    seq_printf(m, "                         Twin Channel Controller ");
   else
   {
     char *channel = "";
@@ -184,86 +92,86 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
       ultra = "Ultra-2 LVD/SE ";
     else if (p->features & AHC_ULTRA)
       ultra = "Ultra ";
-    size += sprintf(BLS, "                           %s%sController%s ",
+    seq_printf(m, "                           %s%sController%s ",
       ultra, wide, channel);
   }
   switch(p->chip & ~AHC_CHIPID_MASK)
   {
     case AHC_VL:
-      size += sprintf(BLS, "at VLB slot %d\n", p->pci_device_fn);
+      seq_printf(m, "at VLB slot %d\n", p->pci_device_fn);
       break;
     case AHC_EISA:
-      size += sprintf(BLS, "at EISA slot %d\n", p->pci_device_fn);
+      seq_printf(m, "at EISA slot %d\n", p->pci_device_fn);
       break;
     default:
-      size += sprintf(BLS, "at PCI %d/%d/%d\n", p->pci_bus,
+      seq_printf(m, "at PCI %d/%d/%d\n", p->pci_bus,
         PCI_SLOT(p->pci_device_fn), PCI_FUNC(p->pci_device_fn));
       break;
   }
   if( !(p->maddr) )
   {
-    size += sprintf(BLS, "    Programmed I/O Base: %lx\n", p->base);
+    seq_printf(m, "    Programmed I/O Base: %lx\n", p->base);
   }
   else
   {
-    size += sprintf(BLS, "    PCI MMAPed I/O Base: 0x%lx\n", p->mbase);
+    seq_printf(m, "    PCI MMAPed I/O Base: 0x%lx\n", p->mbase);
   }
   if( (p->chip & (AHC_VL | AHC_EISA)) )
   {
-    size += sprintf(BLS, "    BIOS Memory Address: 0x%08x\n", p->bios_address);
+    seq_printf(m, "    BIOS Memory Address: 0x%08x\n", p->bios_address);
   }
-  size += sprintf(BLS, " Adapter SEEPROM Config: %s\n",
+  seq_printf(m, " Adapter SEEPROM Config: %s\n",
           (p->flags & AHC_SEEPROM_FOUND) ? "SEEPROM found and used." :
          ((p->flags & AHC_USEDEFAULTS) ? "SEEPROM not found, using defaults." :
            "SEEPROM not found, using leftover BIOS values.") );
-  size += sprintf(BLS, "      Adaptec SCSI BIOS: %s\n",
+  seq_printf(m, "      Adaptec SCSI BIOS: %s\n",
           (p->flags & AHC_BIOS_ENABLED) ? "Enabled" : "Disabled");
-  size += sprintf(BLS, "                    IRQ: %d\n", HBAptr->irq);
-  size += sprintf(BLS, "                   SCBs: Active %d, Max Active %d,\n",
+  seq_printf(m, "                    IRQ: %d\n", HBAptr->irq);
+  seq_printf(m, "                   SCBs: Active %d, Max Active %d,\n",
             p->activescbs, p->max_activescbs);
-  size += sprintf(BLS, "                         Allocated %d, HW %d, "
+  seq_printf(m, "                         Allocated %d, HW %d, "
             "Page %d\n", p->scb_data->numscbs, p->scb_data->maxhscbs,
             p->scb_data->maxscbs);
   if (p->flags & AHC_EXTERNAL_SRAM)
-    size += sprintf(BLS, "                         Using External SCB SRAM\n");
-  size += sprintf(BLS, "             Interrupts: %ld", p->isr_count);
+    seq_printf(m, "                         Using External SCB SRAM\n");
+  seq_printf(m, "             Interrupts: %ld", p->isr_count);
   if (p->chip & AHC_EISA)
   {
-    size += sprintf(BLS, " %s\n",
+    seq_printf(m, " %s\n",
         (p->pause & IRQMS) ? "(Level Sensitive)" : "(Edge Triggered)");
   }
   else
   {
-    size += sprintf(BLS, "\n");
+    seq_printf(m, "\n");
   }
-  size += sprintf(BLS, "      BIOS Control Word: 0x%04x\n",
+  seq_printf(m, "      BIOS Control Word: 0x%04x\n",
             p->bios_control);
-  size += sprintf(BLS, "   Adapter Control Word: 0x%04x\n",
+  seq_printf(m, "   Adapter Control Word: 0x%04x\n",
             p->adapter_control);
-  size += sprintf(BLS, "   Extended Translation: %sabled\n",
+  seq_printf(m, "   Extended Translation: %sabled\n",
       (p->flags & AHC_EXTEND_TRANS_A) ? "En" : "Dis");
-  size += sprintf(BLS, "Disconnect Enable Flags: 0x%04x\n", p->discenable);
+  seq_printf(m, "Disconnect Enable Flags: 0x%04x\n", p->discenable);
   if (p->features & (AHC_ULTRA | AHC_ULTRA2))
   {
-    size += sprintf(BLS, "     Ultra Enable Flags: 0x%04x\n", p->ultraenb);
+    seq_printf(m, "     Ultra Enable Flags: 0x%04x\n", p->ultraenb);
   }
-  size += sprintf(BLS, "Default Tag Queue Depth: %d\n", aic7xxx_default_queue_depth);
-  size += sprintf(BLS, "    Tagged Queue By Device array for aic7xxx host "
+  seq_printf(m, "Default Tag Queue Depth: %d\n", aic7xxx_default_queue_depth);
+  seq_printf(m, "    Tagged Queue By Device array for aic7xxx host "
                        "instance %d:\n", p->instance);
-  size += sprintf(BLS, "      {");
+  seq_printf(m, "      {");
   for(i=0; i < (MAX_TARGETS - 1); i++)
-    size += sprintf(BLS, "%d,",aic7xxx_tag_info[p->instance].tag_commands[i]);
-  size += sprintf(BLS, "%d}\n",aic7xxx_tag_info[p->instance].tag_commands[i]);
+    seq_printf(m, "%d,",aic7xxx_tag_info[p->instance].tag_commands[i]);
+  seq_printf(m, "%d}\n",aic7xxx_tag_info[p->instance].tag_commands[i]);
 
-  size += sprintf(BLS, "\n");
-  size += sprintf(BLS, "Statistics:\n\n");
+  seq_printf(m, "\n");
+  seq_printf(m, "Statistics:\n\n");
   list_for_each_entry(aic_dev, &p->aic_devs, list)
   {
     sdptr = aic_dev->SDptr;
     tindex = sdptr->channel << 3 | sdptr->id;
-    size += sprintf(BLS, "(scsi%d:%d:%d:%d)\n",
+    seq_printf(m, "(scsi%d:%d:%d:%d)\n",
         p->host_no, sdptr->channel, sdptr->id, sdptr->lun);
-    size += sprintf(BLS, "  Device using %s/%s",
+    seq_printf(m, "  Device using %s/%s",
           (aic_dev->cur.width == MSG_EXT_WDTR_BUS_16_BIT) ?
           "Wide" : "Narrow",
           (aic_dev->cur.offset != 0) ?
@@ -279,80 +187,74 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
       sync_rate = aic7xxx_find_syncrate(p, &period, 0, &options);
       if (sync_rate != NULL)
       {
-        size += sprintf(BLS, "%s MByte/sec, offset %d\n",
+        seq_printf(m, "%s MByte/sec, offset %d\n",
                         sync_rate->rate[rate],
                         aic_dev->cur.offset );
       }
       else
       {
-        size += sprintf(BLS, "3.3 MByte/sec, offset %d\n",
+        seq_printf(m, "3.3 MByte/sec, offset %d\n",
                         aic_dev->cur.offset );
       }
     }
-    size += sprintf(BLS, "  Transinfo settings: ");
-    size += sprintf(BLS, "current(%d/%d/%d/%d), ",
+    seq_printf(m, "  Transinfo settings: ");
+    seq_printf(m, "current(%d/%d/%d/%d), ",
                     aic_dev->cur.period,
                     aic_dev->cur.offset,
                     aic_dev->cur.width,
                     aic_dev->cur.options);
-    size += sprintf(BLS, "goal(%d/%d/%d/%d), ",
+    seq_printf(m, "goal(%d/%d/%d/%d), ",
                     aic_dev->goal.period,
                     aic_dev->goal.offset,
                     aic_dev->goal.width,
                     aic_dev->goal.options);
-    size += sprintf(BLS, "user(%d/%d/%d/%d)\n",
+    seq_printf(m, "user(%d/%d/%d/%d)\n",
                     p->user[tindex].period,
                     p->user[tindex].offset,
                     p->user[tindex].width,
                     p->user[tindex].options);
     if(sdptr->simple_tags)
     {
-      size += sprintf(BLS, "  Tagged Command Queueing Enabled, Ordered Tags %s, Depth %d/%d\n", sdptr->ordered_tags ? "Enabled" : "Disabled", sdptr->queue_depth, aic_dev->max_q_depth);
+      seq_printf(m, "  Tagged Command Queueing Enabled, Ordered Tags %s, Depth %d/%d\n", sdptr->ordered_tags ? "Enabled" : "Disabled", sdptr->queue_depth, aic_dev->max_q_depth);
     }
     if(aic_dev->barrier_total)
-      size += sprintf(BLS, "  Total transfers %ld:\n    (%ld/%ld/%ld/%ld reads/writes/REQ_BARRIER/Ordered Tags)\n",
+      seq_printf(m, "  Total transfers %ld:\n    (%ld/%ld/%ld/%ld reads/writes/REQ_BARRIER/Ordered Tags)\n",
         aic_dev->r_total+aic_dev->w_total, aic_dev->r_total, aic_dev->w_total,
         aic_dev->barrier_total, aic_dev->ordered_total);
     else
-      size += sprintf(BLS, "  Total transfers %ld:\n    (%ld/%ld reads/writes)\n",
+      seq_printf(m, "  Total transfers %ld:\n    (%ld/%ld reads/writes)\n",
         aic_dev->r_total+aic_dev->w_total, aic_dev->r_total, aic_dev->w_total);
-    size += sprintf(BLS, "%s\n", HDRB);
-    size += sprintf(BLS, "   Reads:");
+    seq_printf(m, "%s\n", HDRB);
+    seq_printf(m, "   Reads:");
     for (i = 0; i < ARRAY_SIZE(aic_dev->r_bins); i++)
     {
-      size += sprintf(BLS, " %10ld", aic_dev->r_bins[i]);
+      seq_printf(m, " %10ld", aic_dev->r_bins[i]);
     }
-    size += sprintf(BLS, "\n");
-    size += sprintf(BLS, "  Writes:");
+    seq_printf(m, "\n");
+    seq_printf(m, "  Writes:");
     for (i = 0; i < ARRAY_SIZE(aic_dev->w_bins); i++)
     {
-      size += sprintf(BLS, " %10ld", aic_dev->w_bins[i]);
+      seq_printf(m, " %10ld", aic_dev->w_bins[i]);
     }
-    size += sprintf(BLS, "\n");
-    size += sprintf(BLS, "\n\n");
-  }
-  if (size >= aic7xxx_buffer_size)
-  {
-    printk(KERN_WARNING "aic7xxx: Overflow in aic7xxx_proc.c\n");
+    seq_printf(m, "\n");
+    seq_printf(m, "\n\n");
   }
 
-  if (offset > size - 1)
-  {
-    kfree(aic7xxx_buffer);
-    aic7xxx_buffer = NULL;
-    aic7xxx_buffer_size = length = 0;
-    *start = NULL;
-  }
-  else
-  {
-    *start = buffer;
-    length = min_t(int, length, size - offset);
-    memcpy(buffer, &aic7xxx_buffer[offset], length);
-  }
+  return 0;
+}
 
-  return (length);
+static int aic7xxx_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aic7xxx_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations aic7xxx_proc_ops = {
+	.open		= aic7xxx_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
  * Emacs will notice this stuff at the end of the file and automatically
-- 
1.7.3.4

