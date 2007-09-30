From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/16] gdth: Remove 2.4.x support, in-kernel changelog
Date: Sun, 30 Sep 2007 21:57:07 +0200
Message-ID: <46FFFF93.4010200@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa15.bezeqint.net ([192.115.104.30]:39825 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXI3T5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 15:57:15 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  * Remove in-source changelog.  It's archived permanently in git and
    various kernel archives, and changelogs should exist purely in git.

  * Remove 2.4.x kernel support.  It is an active obstacle to
    modernizing this driver, at this point.  This includes killing
    gdth_kcompat.h which is 100% redundant in modern kernels.

  Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/scsi/gdth.c         |  396 +------------------------------------------
 drivers/scsi/gdth.h         |    1 -
 drivers/scsi/gdth_kcompat.h |   31 ----
 drivers/scsi/gdth_proc.c    |   27 ---
 4 files changed, 2 insertions(+), 453 deletions(-)
 delete mode 100644 drivers/scsi/gdth_kcompat.h

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 882479b..d0b2530 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -27,280 +27,8 @@
  * along with this kernel; if not, write to the Free Software           *
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            *
  *                                                                      *
- * Linux kernel 2.4.x, 2.6.x supported                                  *
+ * Linux kernel 2.6.x supported						*
  *                                                                      *
- * $Log: gdth.c,v $
- * Revision 1.74  2006/04/10 13:44:47  achim
- * Community changes for 2.6.x
- * Kernel 2.2.x no longer supported
- * scsi_request interface removed, thanks to Christoph Hellwig
- *
- * Revision 1.73  2004/03/31 13:33:03  achim
- * Special command 0xfd implemented to detect 64-bit DMA support
- *
- * Revision 1.72  2004/03/17 08:56:04  achim
- * 64-bit DMA only enabled if FW >= x.43
- *
- * Revision 1.71  2004/03/05 15:51:29  achim
- * Screen service: separate message buffer, bugfixes
- *
- * Revision 1.70  2004/02/27 12:19:07  achim
- * Bugfix: Reset bit in config (0xfe) call removed
- *
- * Revision 1.69  2004/02/20 09:50:24  achim
- * Compatibility changes for kernels < 2.4.20
- * Bugfix screen service command size
- * pci_set_dma_mask() error handling added
- *
- * Revision 1.68  2004/02/19 15:46:54  achim
- * 64-bit DMA bugfixes
- * Drive size bugfix for drives > 1TB
- *
- * Revision 1.67  2004/01/14 13:11:57  achim
- * Tool access over /proc no longer supported
- * Bugfixes IOCTLs
- *
- * Revision 1.66  2003/12/19 15:04:06  achim
- * Bugfixes support for drives > 2TB
- *
- * Revision 1.65  2003/12/15 11:21:56  achim
- * 64-bit DMA support added
- * Support for drives > 2 TB implemented
- * Kernels 2.2.x, 2.4.x, 2.6.x supported
- *
- * Revision 1.64  2003/09/17 08:30:26  achim
- * EISA/ISA controller scan disabled
- * Command line switch probe_eisa_isa added
- *
- * Revision 1.63  2003/07/12 14:01:00  Daniele Bellucci <bellucda@tiscali.it>
- * Minor cleanups in gdth_ioctl.
- *
- * Revision 1.62  2003/02/27 15:01:59  achim
- * Dynamic DMA mapping implemented
- * New (character device) IOCTL interface added
- * Other controller related changes made
- *
- * Revision 1.61  2002/11/08 13:09:52  boji
- * Added support for XSCALE based RAID Controllers
- * Fixed SCREENSERVICE initialization in SMP cases
- * Added checks for gdth_polling before GDTH_HA_LOCK
- *
- * Revision 1.60  2002/02/05 09:35:22  achim
- * MODULE_LICENSE only if kernel >= 2.4.11
- *
- * Revision 1.59  2002/01/30 09:46:33  achim
- * Small changes
- *
- * Revision 1.58  2002/01/29 15:30:02  achim
- * Set default value of shared_access to Y
- * New status S_CACHE_RESERV for clustering added
- *
- * Revision 1.57  2001/08/21 11:16:35  achim
- * Bugfix free_irq()
- *
- * Revision 1.56  2001/08/09 11:19:39  achim
- * Scsi_Host_Template changes
- *
- * Revision 1.55  2001/08/09 10:11:28  achim
- * Command HOST_UNFREEZE_IO before cache service init.
- *
- * Revision 1.54  2001/07/20 13:48:12  achim
- * Expand: gdth_analyse_hdrive() removed
- *
- * Revision 1.53  2001/07/17 09:52:49  achim
- * Small OEM related change
- *
- * Revision 1.52  2001/06/19 15:06:20  achim
- * New host command GDT_UNFREEZE_IO added
- *
- * Revision 1.51  2001/05/22 06:42:37  achim
- * PCI: Subdevice ID added
- *
- * Revision 1.50  2001/05/17 13:42:16  achim
- * Support for Intel Storage RAID Controllers added
- *
- * Revision 1.50  2001/05/17 12:12:34  achim
- * Support for Intel Storage RAID Controllers added
- *
- * Revision 1.49  2001/03/15 15:07:17  achim
- * New __setup interface for boot command line options added
- *
- * Revision 1.48  2001/02/06 12:36:28  achim
- * Bugfix Cluster protocol
- *
- * Revision 1.47  2001/01/10 14:42:06  achim
- * New switch shared_access added
- *
- * Revision 1.46  2001/01/09 08:11:35  achim
- * gdth_command() removed
- * meaning of Scsi_Pointer members changed
- *
- * Revision 1.45  2000/11/16 12:02:24  achim
- * Changes for kernel 2.4
- *
- * Revision 1.44  2000/10/11 08:44:10  achim
- * Clustering changes: New flag media_changed added
- *
- * Revision 1.43  2000/09/20 12:59:01  achim
- * DPMEM remap functions for all PCI controller types implemented
- * Small changes for ia64 platform
- *
- * Revision 1.42  2000/07/20 09:04:50  achim
- * Small changes for kernel 2.4
- *
- * Revision 1.41  2000/07/04 14:11:11  achim
- * gdth_analyse_hdrive() added to rescan drives after online expansion
- *
- * Revision 1.40  2000/06/27 11:24:16  achim
- * Changes Clustering, Screenservice
- *
- * Revision 1.39  2000/06/15 13:09:04  achim
- * Changes for gdth_do_cmd()
- *
- * Revision 1.38  2000/06/15 12:08:43  achim
- * Bugfix gdth_sync_event(), service SCREENSERVICE
- * Data direction for command 0xc2 changed to DOU
- *
- * Revision 1.37  2000/05/25 13:50:10  achim
- * New driver parameter virt_ctr added
- *
- * Revision 1.36  2000/05/04 08:50:46  achim
- * Event buffer now in gdth_ha_str
- *
- * Revision 1.35  2000/03/03 10:44:08  achim
- * New event_string only valid for the RP controller family
- *
- * Revision 1.34  2000/03/02 14:55:29  achim
- * New mechanism for async. event handling implemented
- *
- * Revision 1.33  2000/02/21 15:37:37  achim
- * Bugfix Alpha platform + DPMEM above 4GB
- *
- * Revision 1.32  2000/02/14 16:17:37  achim
- * Bugfix sense_buffer[] + raw devices
- *
- * Revision 1.31  2000/02/10 10:29:00  achim
- * Delete sense_buffer[0], if command OK
- *
- * Revision 1.30  1999/11/02 13:42:39  achim
- * ARRAY_DRV_LIST2 implemented
- * Now 255 log. and 100 host drives supported
- *
- * Revision 1.29  1999/10/05 13:28:47  achim
- * GDT_CLUST_RESET added
- *
- * Revision 1.28  1999/08/12 13:44:54  achim
- * MOUNTALL removed
- * Cluster drives -> removeable drives
- *
- * Revision 1.27  1999/06/22 07:22:38  achim
- * Small changes
- *
- * Revision 1.26  1999/06/10 16:09:12  achim
- * Cluster Host Drive support: Bugfixes
- *
- * Revision 1.25  1999/06/01 16:03:56  achim
- * gdth_init_pci(): Manipulate config. space to start RP controller
- *
- * Revision 1.24  1999/05/26 11:53:06  achim
- * Cluster Host Drive support added
- *
- * Revision 1.23  1999/03/26 09:12:31  achim
- * Default value for hdr_channel set to 0
- *
- * Revision 1.22  1999/03/22 16:27:16  achim
- * Bugfix: gdth_store_event() must not be locked with GDTH_LOCK_HA()
- *
- * Revision 1.21  1999/03/16 13:40:34  achim
- * Problems with reserved drives solved
- * gdth_eh_bus_reset() implemented
- *
- * Revision 1.20  1999/03/10 09:08:13  achim
- * Bugfix: Corrections in gdth_direction_tab[] made
- * Bugfix: Increase command timeout (gdth_update_timeout()) NOT in gdth_putq()
- *
- * Revision 1.19  1999/03/05 14:38:16  achim
- * Bugfix: Heads/Sectors mapping for reserved devices possibly wrong
- * -> gdth_eval_mapping() implemented, changes in gdth_bios_param()
- * INIT_RETRIES set to 100s to avoid DEINIT-Timeout for controllers
- * with BIOS disabled and memory test set to Intensive
- * Enhanced /proc support
- *
- * Revision 1.18  1999/02/24 09:54:33  achim
- * Command line parameter hdr_channel implemented
- * Bugfix for EISA controllers + Linux 2.2.x
- *
- * Revision 1.17  1998/12/17 15:58:11  achim
- * Command line parameters implemented
- * Changes for Alpha platforms
- * PCI controller scan changed
- * SMP support improved (spin_lock_irqsave(),...)
- * New async. events, new scan/reserve commands included
- *
- * Revision 1.16  1998/09/28 16:08:46  achim
- * GDT_PCIMPR: DPMEM remapping, if required
- * mdelay() added
- *
- * Revision 1.15  1998/06/03 14:54:06  achim
- * gdth_delay(), gdth_flush() implemented
- * Bugfix: gdth_release() changed
- *
- * Revision 1.14  1998/05/22 10:01:17  achim
- * mj: pcibios_strerror() removed
- * Improved SMP support (if version >= 2.1.95)
- * gdth_halt(): halt_called flag added (if version < 2.1)
- *
- * Revision 1.13  1998/04/16 09:14:57  achim
- * Reserve drives (for raw service) implemented
- * New error handling code enabled
- * Get controller name from board_info() IOCTL
- * Final round of PCI device driver patches by Martin Mares
- *
- * Revision 1.12  1998/03/03 09:32:37  achim
- * Fibre channel controller support added
- *
- * Revision 1.11  1998/01/27 16:19:14  achim
- * SA_SHIRQ added
- * add_timer()/del_timer() instead of GDTH_TIMER
- * scsi_add_timer()/scsi_del_timer() instead of SCSI_TIMER
- * New error handling included
- *
- * Revision 1.10  1997/10/31 12:29:57  achim
- * Read heads/sectors from host drive
- *
- * Revision 1.9  1997/09/04 10:07:25  achim
- * IO-mapping with virt_to_bus(), gdth_readb(), gdth_writeb(), ...
- * register_reboot_notifier() to get a notify on shutown used
- *
- * Revision 1.8  1997/04/02 12:14:30  achim
- * Version 1.00 (see gdth.h), tested with kernel 2.0.29
- *
- * Revision 1.7  1997/03/12 13:33:37  achim
- * gdth_reset() changed, new async. events
- *
- * Revision 1.6  1997/03/04 14:01:11  achim
- * Shutdown routine gdth_halt() implemented
- *
- * Revision 1.5  1997/02/21 09:08:36  achim
- * New controller included (RP, RP1, RP2 series)
- * IOCTL interface implemented
- *
- * Revision 1.4  1996/07/05 12:48:55  achim
- * Function gdth_bios_param() implemented
- * New constant GDTH_MAXC_P_L inserted
- * GDT_WRITE_THR, GDT_EXT_INFO implemented
- * Function gdth_reset() changed
- *
- * Revision 1.3  1996/05/10 09:04:41  achim
- * Small changes for Linux 1.2.13
- *
- * Revision 1.2  1996/05/09 12:45:27  achim
- * Loadable module support implemented
- * /proc support corrections made
- *
- * Revision 1.1  1996/04/11 07:35:57  achim
- * Initial revision
- *
  ************************************************************************/
 
 /* All GDT Disk Array Controllers are fully supported by this driver.
@@ -392,12 +120,7 @@
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
-#else
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#endif
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
@@ -409,16 +132,10 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 #include <linux/blkdev.h>
-#else
-#include <linux/blk.h>
-#include "sd.h"
-#endif
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
-#include "gdth_kcompat.h"
 #include "gdth.h"
 
 static void gdth_delay(int milliseconds);
@@ -664,7 +381,6 @@ static int probe_eisa_isa = 0;
 static int force_dma32 = 0;
 
 /* parameters for modprobe/insmod */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
@@ -677,20 +393,6 @@ module_param(virt_ctr, int, 0);
 module_param(shared_access, int, 0);
 module_param(probe_eisa_isa, int, 0);
 module_param(force_dma32, int, 0);
-#else
-MODULE_PARM(irq, "i");
-MODULE_PARM(disable, "i");
-MODULE_PARM(reserve_mode, "i");
-MODULE_PARM(reserve_list, "4-" __MODULE_STRING(MAX_RES_ARGS) "i");
-MODULE_PARM(reverse_scan, "i");
-MODULE_PARM(hdr_channel, "i");
-MODULE_PARM(max_ids, "i");
-MODULE_PARM(rescan, "i");
-MODULE_PARM(virt_ctr, "i");
-MODULE_PARM(shared_access, "i");
-MODULE_PARM(probe_eisa_isa, "i");
-MODULE_PARM(force_dma32, "i");
-#endif
 MODULE_AUTHOR("Achim Leubner");
 MODULE_LICENSE("GPL");
 
@@ -719,7 +421,6 @@ static void gdth_delay(int milliseconds)
     }
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
     TRACE2(("gdth_scsi_done()\n"));
@@ -757,42 +458,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     kfree(scp);
     return rval;
 }
-#else
-static void gdth_scsi_done(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_scsi_done()\n"));
-
-    scp->request.rq_status = RQ_SCSI_DONE;
-    if (scp->request.waiting)
-        complete(scp->request.waiting);
-}
-
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-                   int timeout, u32 *info)
-{
-    Scsi_Cmnd *scp = scsi_allocate_device(sdev, 1, FALSE);
-    unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
-    DECLARE_COMPLETION_ONSTACK(wait);
-    int rval;
-
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len = 12;
-    scp->use_sg = 0;
-    scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->request.rq_status = RQ_SCSI_BUSY;
-    scp->request.waiting = &wait;
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-
-    rval = scp->SCp.Status;
-    if (info)
-        *info = scp->SCp.Message;
-
-    scsi_release_command(scp);
-    return rval;
-}
-#endif
 
 int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info)
@@ -2252,29 +1917,17 @@ static int __init gdth_search_drives(int hanum)
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
                hanum,oemstr->text.oem_company_name,ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,
                 sizeof(ha->oem_name));
-#else
-        strncpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_id,7);
-        ha->oem_name[7] = '\0';
-#endif
     } else {
         /* Old method, based on PCI ID */
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD failed\n"));
         printk("GDT-HA %d: Name: %s\n",
                hanum,ha->binfo.type_string);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         if (ha->oem_id == OEM_ID_INTEL)
             strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
         else
             strlcpy(ha->oem_name,"ICP    ", sizeof(ha->oem_name));
-#else 
-        if (ha->oem_id == OEM_ID_INTEL)
-            strcpy(ha->oem_name,"Intel  ");
-        else
-            strcpy(ha->oem_name,"ICP    ");
-#endif
     }
 
     /* scanning for host drives */
@@ -2683,17 +2336,10 @@ static void gdth_copy_internal_data(int hanum,Scsi_Cmnd *scp,
                 return;
             }
             local_irq_save(flags);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
             address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
             memcpy(address,buffer,cpnow);
             flush_dcache_page(sl->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
-#else
-            address = kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
-            memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
-            kunmap_atomic(address, KM_BH_IRQ);
-#endif
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
@@ -4287,11 +3933,7 @@ int __init option_setup(char *str)
 }
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
-#else
-static int __init gdth_detect(Scsi_Host_Template *shtp)
-#endif
 {
     gdth_pci_str pcistr[MAXHA];
     ulong32 isa_bios;
@@ -4531,11 +4173,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
     return SUCCESS;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
-#else
-static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
-#endif
 {
     unchar b, t;
     int hanum;
@@ -4543,13 +4181,8 @@ static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
     struct scsi_device *sd;
     unsigned capacity;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     sd = sdev;
     capacity = cap;
-#else
-    sd = disk->device;
-    capacity = disk->capacity;
-#endif
     hanum = NUMDATA(sd->host)->hanum;
     b = virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
     t = sd->id;
@@ -5164,7 +4797,6 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         hanum = res.ionode; 
         ha = HADATA(gdth_ctr_tab[hanum]);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
@@ -5175,17 +4807,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         kfree(scp);
-#else
-        scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
-        if (!scp)
-            return -ENOMEM;
-        scp->cmd_len = 12;
-        scp->use_sg = 0;
-        scp->channel = virt_ctr ? 0 : res.number;
-        rval = gdth_eh_bus_reset(scp);
-        res.status = (rval == SUCCESS ? S_OK : S_GENERR);
-        scsi_release_command(scp);
-#endif
+
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
             return -EFAULT;
         break;
@@ -5273,7 +4895,6 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
     return NOTIFY_OK;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5282,13 +4903,8 @@ static int gdth_slave_configure(struct scsi_device *sdev)
     sdev->skip_ms_page_8 = 1;
     return 0;
 }
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static struct scsi_host_template driver_template = {
-#else
-static Scsi_Host_Template driver_template = {
-#endif
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
@@ -5299,20 +4915,12 @@ static Scsi_Host_Template driver_template = {
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .bios_param             = gdth_bios_param,
         .can_queue              = GDTH_MAXCMDS,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         .slave_configure        = gdth_slave_configure,
-#endif
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
         .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-        .use_new_eh_code        = 1,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)
-        .highmem_io             = 1,
-#endif
-#endif
 };
 
 #ifdef CONFIG_ISA
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 3742330..6884587 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -13,7 +13,6 @@
  * $Id: gdth.h,v 1.58 2006/01/11 16:14:09 achim Exp $
  */
 
-#include <linux/version.h>
 #include <linux/types.h>
 
 #ifndef TRUE
diff --git a/drivers/scsi/gdth_kcompat.h b/drivers/scsi/gdth_kcompat.h
deleted file mode 100644
index 2a302ee..0000000
--- a/drivers/scsi/gdth_kcompat.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef IRQ_HANDLED
-typedef void irqreturn_t;
-#define IRQ_NONE
-#define IRQ_HANDLED
-#endif
-
-#ifndef MODULE_LICENSE
-#define MODULE_LICENSE(x)
-#endif
-
-#ifndef __iomem
-#define __iomem
-#endif
-
-#ifndef __attribute_used__
-#define __attribute_used__	__devinitdata
-#endif
-
-#ifndef __user
-#define __user
-#endif
-
-#ifndef SERVICE_ACTION_IN
-#define SERVICE_ACTION_IN	0x9e
-#endif
-#ifndef READ_16
-#define READ_16			0x88
-#endif
-#ifndef WRITE_16
-#define WRITE_16		0x8a
-#endif
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 32982eb..5fccb15 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -4,7 +4,6 @@
 
 #include <linux/completion.h>
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
                    int inout)
 {
@@ -21,32 +20,6 @@ int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offse
     else
         return(gdth_get_info(buffer,start,offset,length,host,hanum,busnum));
 }
-#else
-int gdth_proc_info(char *buffer,char **start,off_t offset,int length,int hostno,   
-                   int inout)
-{
-    int hanum,busnum,i;
-
-    TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
-            length,(int)offset,inout));
-
-    for (i = 0; i < gdth_ctr_vcount; ++i) {
-        if (gdth_ctr_vtab[i]->host_no == hostno)
-            break;
-    }
-    if (i == gdth_ctr_vcount)
-        return(-EINVAL);
-
-    hanum = NUMDATA(gdth_ctr_vtab[i])->hanum;
-    busnum= NUMDATA(gdth_ctr_vtab[i])->busnum;
-
-    if (inout)
-        return(gdth_set_info(buffer,length,gdth_ctr_vtab[i],hanum,busnum));
-    else
-        return(gdth_get_info(buffer,start,offset,length,
-                             gdth_ctr_vtab[i],hanum,busnum));
-}
-#endif
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum)
-- 
1.5.3.1


