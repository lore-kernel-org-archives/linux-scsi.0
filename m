From: James Nelson <james4765@gmail.com>
Subject: [KJ] [PATCH] gdth: Remove kernel version-specific preprocessor
	directives
Date: Sun, 27 Aug 2006 17:09:43 -0400
Message-ID: <20060827210943.15524.20271.sendpatchset@david.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-bounces@lists.osdl.org>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Kernel Janitors <kernel-janitors@lists.osdl.org>
Cc: James Nelson <james4765@gmail.com>, achim_leubner@adaptec.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch removes a lot of version-specific preprocessor directives and as=
sociated code.

 gdth.c      |  131 -------------------------------------------------------=
-----
 gdth.h      |   10 ----
 gdth_proc.c |   27 ------------
 3 files changed, 168 deletions(-)

Signed-off-by: James Nelson <james4765@gmail.com>
---
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 43afd47..ec615e1 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -393,12 +393,7 @@ #include <linux/in.h>
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
-#else
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#endif
 =

 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
@@ -410,12 +405,7 @@ #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 #include <linux/blkdev.h>
-#else
-#include <linux/blk.h>
-#include "sd.h"
-#endif
 =

 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -656,7 +646,6 @@ static int probe_eisa_isa =3D 0;
 static int force_dma32 =3D 0;
 =

 /* parameters for modprobe/insmod */
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,11)
 module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
@@ -669,20 +658,6 @@ module_param(virt_ctr, int, 0);
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
 =

@@ -711,7 +686,6 @@ static void gdth_delay(int milliseconds)
     }
 }
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
     TRACE2(("gdth_scsi_done()\n"));
@@ -749,42 +723,6 @@ int __gdth_execute(struct scsi_device *s
     kfree(scp);
     return rval;
 }
-#else
-static void gdth_scsi_done(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_scsi_done()\n"));
-
-    scp->request.rq_status =3D RQ_SCSI_DONE;
-    if (scp->request.waiting)
-        complete(scp->request.waiting);
-}
-
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *c=
mnd,
-                   int timeout, u32 *info)
-{
-    Scsi_Cmnd *scp =3D scsi_allocate_device(sdev, 1, FALSE);
-    unsigned bufflen =3D gdtcmd ? sizeof(gdth_cmd_str) : 0;
-    DECLARE_COMPLETION(wait);
-    int rval;
-
-    if (!scp)
-        return -ENOMEM;
-    scp->cmd_len =3D 12;
-    scp->use_sg =3D 0;
-    scp->SCp.this_residual =3D IOCTL_PRI;   /* priority */
-    scp->request.rq_status =3D RQ_SCSI_BUSY;
-    scp->request.waiting =3D &wait;
-    scsi_do_cmd(scp, cmnd, gdtcmd, bufflen, gdth_scsi_done, timeout*HZ, 1);
-    wait_for_completion(&wait);
-
-    rval =3D scp->SCp.Status;
-    if (info)
-        *info =3D scp->SCp.Message;
-
-    scsi_release_command(scp);
-    return rval;
-}
-#endif
 =

 int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info)
@@ -2249,29 +2187,17 @@ #endif
         printk("GDT-HA %d: Vendor: %s Name: %s\n",
                hanum,oemstr->text.oem_company_name,ha->binfo.type_string);
         /* Save the Host Drive inquiry data */
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
         strlcpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_i=
d,
                 sizeof(ha->oem_name));
-#else
-        strncpy(ha->oem_name,oemstr->text.scsi_host_drive_inquiry_vendor_i=
d,7);
-        ha->oem_name[7] =3D '\0';
-#endif
     } else {
         /* Old method, based on PCI ID */
         TRACE2(("gdth_search_drives(): CACHE_READ_OEM_STRING_RECORD failed=
\n"));
         printk("GDT-HA %d: Name: %s\n",
                hanum,ha->binfo.type_string);
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
         if (ha->oem_id =3D=3D OEM_ID_INTEL)
             strlcpy(ha->oem_name,"Intel  ", sizeof(ha->oem_name));
         else
             strlcpy(ha->oem_name,"ICP    ", sizeof(ha->oem_name));
-#else =

-        if (ha->oem_id =3D=3D OEM_ID_INTEL)
-            strcpy(ha->oem_name,"Intel  ");
-        else
-            strcpy(ha->oem_name,"ICP    ");
-#endif
     }
 =

     /* scanning for host drives */
@@ -2680,17 +2606,10 @@ static void gdth_copy_internal_data(int =

                 return;
             }
             local_irq_save(flags);
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
             address =3D kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
             memcpy(address,buffer,cpnow);
             flush_dcache_page(sl->page);
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
-#else
-            address =3D kmap_atomic(sl->page, KM_BH_IRQ) + sl->offset;
-            memcpy(address,buffer,cpnow);
-            flush_dcache_page(sl->page);
-            kunmap_atomic(address, KM_BH_IRQ);
-#endif
             local_irq_restore(flags);
             if (cpsum =3D=3D cpcount)
                 break;
@@ -4281,11 +4200,7 @@ int __init option_setup(char *str)
     return 1;
 }
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 static int __init gdth_detect(struct scsi_host_template *shtp)
-#else
-static int __init gdth_detect(Scsi_Host_Template *shtp)
-#endif
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -4425,10 +4340,6 @@ #endif
                     hdr_channel =3D ha->bus_cnt;
                 ha->virt_bus =3D hdr_channel;
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  =3D 0;
-#endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_=
64BIT) =

                     shp->max_cmd_len =3D 16;
 =

@@ -4549,10 +4460,6 @@ #endif
                     hdr_channel =3D ha->bus_cnt;
                 ha->virt_bus =3D hdr_channel;
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20) && \
-    LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-                shp->highmem_io  =3D 0;
-#endif
                 if (ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_=
64BIT) =

                     shp->max_cmd_len =3D 16;
 =

@@ -4653,9 +4560,6 @@ #endif
             ha->virt_bus =3D hdr_channel;
 =

 =

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-            scsi_set_pci_device(shp, pcistr[ctr].pdev);
-#endif
             if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &GDT_64B=
IT)||
                 /* 64-bit DMA only supported from FW >=3D x.43 */
                 (!ha->dma64_support)) {
@@ -4887,11 +4791,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
     return SUCCESS;
 }
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *b=
dev,sector_t cap,int *ip)
-#else
-static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
-#endif
 {
     unchar b, t;
     int hanum;
@@ -4899,13 +4799,8 @@ #endif
     struct scsi_device *sd;
     unsigned capacity;
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     sd =3D sdev;
     capacity =3D cap;
-#else
-    sd =3D disk->device;
-    capacity =3D disk->capacity;
-#endif
     hanum =3D NUMDATA(sd->host)->hanum;
     b =3D virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
     t =3D sd->id;
@@ -5520,7 +5415,6 @@ static int gdth_ioctl(struct inode *inod
         hanum =3D res.ionode; =

         ha =3D HADATA(gdth_ctr_tab[hanum]);
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
         scp  =3D kmalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
             return -ENOMEM;
@@ -5532,17 +5426,6 @@ #if LINUX_VERSION_CODE >=3D KERNEL_VERSION
         rval =3D gdth_eh_bus_reset(scp);
         res.status =3D (rval =3D=3D SUCCESS ? S_OK : S_GENERR);
         kfree(scp);
-#else
-        scp  =3D scsi_allocate_device(ha->sdev, 1, FALSE);
-        if (!scp)
-            return -ENOMEM;
-        scp->cmd_len =3D 12;
-        scp->use_sg =3D 0;
-        scp->channel =3D virt_ctr ? 0 : res.number;
-        rval =3D gdth_eh_bus_reset(scp);
-        res.status =3D (rval =3D=3D SUCCESS ? S_OK : S_GENERR);
-        scsi_release_command(scp);
-#endif
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
             return -EFAULT;
         break;
@@ -5630,7 +5513,6 @@ #endif
     return NOTIFY_OK;
 }
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 /* configure lun */
 static int gdth_slave_configure(struct scsi_device *sdev)
 {
@@ -5639,13 +5521,8 @@ static int gdth_slave_configure(struct s
     sdev->skip_ms_page_8 =3D 1;
     return 0;
 }
-#endif
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 static struct scsi_host_template driver_template =3D {
-#else
-static Scsi_Host_Template driver_template =3D {
-#endif
         .proc_name              =3D "gdth", =

         .proc_info              =3D gdth_proc_info,
         .name                   =3D "GDT SCSI Disk Array Controller",
@@ -5656,20 +5533,12 @@ #endif
         .eh_bus_reset_handler   =3D gdth_eh_bus_reset,
         .bios_param             =3D gdth_bios_param,
         .can_queue              =3D GDTH_MAXCMDS,
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
         .slave_configure        =3D gdth_slave_configure,
-#endif
         .this_id                =3D -1,
         .sg_tablesize           =3D GDTH_MAXSG,
         .cmd_per_lun            =3D GDTH_MAXC_P_L,
         .unchecked_isa_dma      =3D 1,
         .use_clustering         =3D ENABLE_CLUSTERING,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-        .use_new_eh_code        =3D 1,
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20)
-        .highmem_io             =3D 1,
-#endif
-#endif
 };
 =

 #include "scsi_module.c"
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 47eae02..8c29eaf 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -936,18 +936,12 @@ #endif
     gdth_binfo_str      binfo;                  /* controller info */
     gdth_evt_data       dvr;                    /* event structure */
     spinlock_t          smp_lock;
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,0)
     struct pci_dev      *pdev;
-#endif
     char                oem_name[8];
 #ifdef GDTH_DMA_STATISTICS
     ulong               dma32_cnt, dma64_cnt;   /* statistics: DMA buffer =
*/
 #endif
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,0)
     struct scsi_device         *sdev;
-#else
-    struct scsi_device         sdev;
-#endif
 } gdth_ha_str;
 =

 /* structure for scsi_register(), SCSI bus !=3D 0 */
@@ -1029,10 +1023,6 @@ typedef struct {
 =

 /* function prototyping */
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *, char *,char **,off_t,int,int);
-#else
-int gdth_proc_info(char *,char **,off_t,int,int,int);
-#endif
 =

 #endif
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 32982eb..5fccb15 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -4,7 +4,6 @@
 =

 #include <linux/completion.h>
 =

-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t=
 offset,int length,   =

                    int inout)
 {
@@ -21,32 +20,6 @@ int gdth_proc_info(struct Scsi_Host *hos
     else
         return(gdth_get_info(buffer,start,offset,length,host,hanum,busnum)=
);
 }
-#else
-int gdth_proc_info(char *buffer,char **start,off_t offset,int length,int h=
ostno,   =

-                   int inout)
-{
-    int hanum,busnum,i;
-
-    TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
-            length,(int)offset,inout));
-
-    for (i =3D 0; i < gdth_ctr_vcount; ++i) {
-        if (gdth_ctr_vtab[i]->host_no =3D=3D hostno)
-            break;
-    }
-    if (i =3D=3D gdth_ctr_vcount)
-        return(-EINVAL);
-
-    hanum =3D NUMDATA(gdth_ctr_vtab[i])->hanum;
-    busnum=3D NUMDATA(gdth_ctr_vtab[i])->busnum;
-
-    if (inout)
-        return(gdth_set_info(buffer,length,gdth_ctr_vtab[i],hanum,busnum));
-    else
-        return(gdth_get_info(buffer,start,offset,length,
-                             gdth_ctr_vtab[i],hanum,busnum));
-}
-#endif
 =

 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          int hanum,int busnum)
