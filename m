From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 09/16] gdth: Remove virt hosts
Date: Tue, 02 Oct 2007 22:59:53 +0200
Message-ID: <4702B149.7060005@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15762 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbXJBVAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:00:09 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kerne>

From: Christoph Hellwig <hch@lst.de>

The virt_ctr option allows to register a new scsi_host for each bus
on the raid controller.  This non-default option makes no sense with
the current scsi code and prevents cleaning up the host registration,
so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c      |   88 ++++++---------------------------------------
 drivers/scsi/gdth_proc.c |   28 ++++++---------
 drivers/scsi/gdth_proc.h |    4 +-
 3 files changed, 25 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 24e6fd9..ea2c8f2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -56,8 +56,6 @@
  * max_ids:x                    x - target ID count per channel (1..MAXID)
  * rescan:Y                     rescan all channels/IDs 
  * rescan:N                     use all devices found until now
- * virt_ctr:Y                   map every channel to a virtual controller 
- * virt_ctr:N                   use multi channel support 
  * hdr_channel:x                x - number of virtual bus for host drives
  * shared_access:Y              disable driver reserve/release protocol to 
  *                              access a shared resource from several nodes, 
@@ -69,7 +67,7 @@
  * force_dma32:N                use 64 bit DMA mode, if supported
  *
  * The default values are: "gdth=disable:N,reserve_mode:1,reverse_scan:N,
- *                          max_ids:127,rescan:N,virt_ctr:N,hdr_channel:0,
+ *                          max_ids:127,rescan:N,hdr_channel:0,
  *                          shared_access:Y,probe_eisa_isa:N,force_dma32:N".
  * Here is another example: "gdth=reserve_list:0,1,2,0,0,1,3,0,rescan:Y".
  * 
@@ -80,7 +78,7 @@
  * '1' in place of 'Y' and '0' in place of 'N'.
  * 
  * Default: "modprobe gdth disable=0 reserve_mode=1 reverse_scan=0
- *           max_ids=127 rescan=0 virt_ctr=0 hdr_channel=0 shared_access=0 
+ *           max_ids=127 rescan=0 hdr_channel=0 shared_access=0
  *           probe_eisa_isa=0 force_dma32=0"
  * The other example: "modprobe gdth reserve_list=0,1,2,0,0,1,3,0 rescan=1".
  */
@@ -303,10 +301,8 @@ static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
 static int      wait_index,wait_hanum;                  /* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
-static int      gdth_ctr_vcount = 0;                    /* virt. ctr. count */
 static int      gdth_ctr_released = 0;                  /* gdth_release() */
 static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
-static struct Scsi_Host *gdth_ctr_vtab[MAXHA*MAXBUS];   /* virt. ctr. table */
 static unchar   gdth_write_through = FALSE;             /* write through */
 static gdth_evt_str ebuffer[MAX_EVENTS];                /* event buffer */
 static int elastidx;
@@ -358,8 +354,6 @@ static int hdr_channel = 0;
 static int max_ids = MAXID;
 /* rescan all IDs */
 static int rescan = 0;
-/* map channels to virtual controllers */
-static int virt_ctr = 0;
 /* shared access */
 static int shared_access = 1;
 /* enable support for EISA and ISA controllers */
@@ -376,7 +370,6 @@ module_param(reverse_scan, int, 0);
 module_param(hdr_channel, int, 0);
 module_param(max_ids, int, 0);
 module_param(rescan, int, 0);
-module_param(virt_ctr, int, 0);
 module_param(shared_access, int, 0);
 module_param(probe_eisa_isa, int, 0);
 module_param(force_dma32, int, 0);
@@ -2018,7 +2011,7 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
 
     if (!IS_GDTH_INTERNAL_CMD(scp)) {
         scp->SCp.this_residual = (int)priority;
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum:scp->device->channel;
+        b = scp->device->channel;
         t = scp->device->id;
         if (priority >= DEFAULT_PRI) {
             if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
@@ -2080,8 +2073,7 @@ static void gdth_next(int hanum)
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
         if (!IS_GDTH_INTERNAL_CMD(nscp)) {
-            b = virt_ctr ?
-                NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
+            b = nscp->device->channel;
             t = nscp->device->id;
             l = nscp->device->lun;
             if (nscp->SCp.this_residual >= DEFAULT_PRI) {
@@ -3397,7 +3389,7 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
         printk("\n");
 
     } else {
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
+        b = scp->device->channel;
         t = scp->device->id;
         if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
             ha->raw[BUS_L2P(ha,b)].io_cnt[t]--;
@@ -3883,8 +3875,6 @@ static void __init internal_setup(char *str,int *ints)
             max_ids = val;
         else if (!strncmp(argv, "rescan:", 7))
             rescan = val;
-        else if (!strncmp(argv, "virt_ctr:", 9))
-            virt_ctr = val;
         else if (!strncmp(argv, "shared_access:", 14))
             shared_access = val;
         else if (!strncmp(argv, "probe_eisa_isa:", 15))
@@ -3931,7 +3921,6 @@ int __init option_setup(char *str)
     return 1;
 }
 
-
 static int __init gdth_detect(struct scsi_host_template *shtp)
 {
 #ifdef DEBUG_GDTH
@@ -4018,7 +4007,7 @@ static int __init gdth_detect(struct scsi_host_template *shtp)
         register_reboot_notifier(&gdth_notifier);
     }
     gdth_polling = FALSE;
-    return gdth_ctr_vcount;
+    return gdth_ctr_count;
 }
 
 static int gdth_release(struct Scsi_Host *shp)
@@ -4027,7 +4016,6 @@ static int gdth_release(struct Scsi_Host *shp)
     gdth_ha_str *ha;
 
     TRACE2(("gdth_release()\n"));
-    if (NUMDATA(shp)->busnum == 0) {
         hanum = NUMDATA(shp)->hanum;
         ha    = HADATA(gdth_ctr_tab[hanum]);
         if (ha->sdev) {
@@ -4069,7 +4057,6 @@ static int gdth_release(struct Scsi_Host *shp)
             unregister_chrdev(major,"gdth");
             unregister_reboot_notifier(&gdth_notifier);
         }
-    }
 
     scsi_unregister(shp);
     return 0;
@@ -4131,7 +4118,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
     TRACE2(("gdth_eh_bus_reset()\n"));
 
     hanum = NUMDATA(scp->device->host)->hanum;
-    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
+    b = scp->device->channel;
     ha    = HADATA(gdth_ctr_tab[hanum]);
 
     /* clear command tab */
@@ -4185,7 +4172,7 @@ static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,se
     sd = sdev;
     capacity = cap;
     hanum = NUMDATA(sd->host)->hanum;
-    b = virt_ctr ? NUMDATA(sd->host)->busnum : sd->channel;
+    b = sd->channel;
     t = sd->id;
     TRACE2(("gdth_bios_param() ha %d bus %d target %d\n", hanum, b, t)); 
     ha = HADATA(gdth_ctr_tab[hanum]);
@@ -4805,7 +4792,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         scp->device = ha->sdev;
         scp->cmd_len = 12;
         scp->use_sg = 0;
-        scp->device->channel = virt_ctr ? 0 : res.number;
+        scp->device->channel = res.number;
         rval = gdth_eh_bus_reset(scp);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
         kfree(scp);
@@ -4932,7 +4919,6 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
-	u8 b;
 
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
@@ -4969,10 +4955,8 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	shp->dma_channel = ha->drq;
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
-	NUMDATA(shp)->busnum= 0;
 
 	ha->pccb = CMDDATA(shp);
 	ha->ccb_phys = 0L;
@@ -5025,20 +5009,7 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
-	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 1;
-			shp->irq = ha->irq;
-			shp->dma_channel = ha->drq;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5058,7 +5029,6 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 				ha->pscratch, ha->scratch_phys);
  out_dec_counters:
 	gdth_ctr_count--;
-	gdth_ctr_vcount--;
  out_free_irq:
 	free_irq(ha->irq, ha);
  out_host_put:
@@ -5075,7 +5045,6 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
-	u8 b;
 
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
@@ -5104,10 +5073,8 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	shp->dma_channel = 0xff;
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
-	NUMDATA(shp)->busnum= 0;
 	TRACE2(("EISA detect Bus 0: hanum %d\n",
 		NUMDATA(shp)->hanum));
 
@@ -5167,20 +5134,7 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
-	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5203,7 +5157,6 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
  out_free_irq:
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
-	gdth_ctr_vcount--;
  out_host_put:
 	scsi_unregister(shp);
 	return error;
@@ -5218,7 +5171,6 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
-	u8 b;
 
 	shp = scsi_register(shtp,sizeof(gdth_ext_str));
 	if (!shp)
@@ -5247,10 +5199,8 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	shp->dma_channel = 0xff;
 	hanum = gdth_ctr_count;
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
-	gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
 
 	NUMDATA(shp)->hanum = (ushort)hanum;
-	NUMDATA(shp)->busnum= 0;
 
 	ha->pccb = CMDDATA(shp);
 	ha->ccb_phys = 0L;
@@ -5318,20 +5268,7 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
-	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	shp->max_channel = ha->bus_cnt;
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5351,7 +5288,6 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
  out_free_irq:
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
-	gdth_ctr_vcount--;
  out_host_put:
 	scsi_unregister(shp);
 	return error;
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index c9364bc..2c31b64 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -7,26 +7,25 @@
 int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
                    int inout)
 {
-    int hanum,busnum;
+    int hanum;
 
     TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
             length,(int)offset,inout));
 
     hanum = NUMDATA(host)->hanum;
-    busnum= NUMDATA(host)->busnum;
 
     if (inout)
-        return(gdth_set_info(buffer,length,host,hanum,busnum));
+        return(gdth_set_info(buffer,length,host,hanum));
     else
-        return(gdth_get_info(buffer,start,offset,length,host,hanum,busnum));
+        return(gdth_get_info(buffer,start,offset,length,host,hanum));
 }
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
-                         int hanum,int busnum)
+                         int hanum)
 {
     int ret_val = -EINVAL;
 
-    TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
+    TRACE2(("gdth_set_info() ha %d\n",hanum,));
 
     if (length >= 4) {
         if (strncmp(buffer,"gdth",4) == 0) {
@@ -154,7 +153,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
 }
 
 static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host,int hanum,int busnum)
+                         struct Scsi_Host *host,int hanum)
 {
     int size = 0,len = 0;
     off_t begin = 0,pos = 0;
@@ -187,7 +186,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     memset(cmnd, 0xff, 12);
     memset(gdtcmd, 0, sizeof(gdth_cmd_str));
 
-    TRACE2(("gdth_get_info() ha %d bus %d\n",hanum,busnum));
+    TRACE2(("gdth_get_info() ha %d\n",hanum));
     ha = HADATA(gdth_ctr_tab[hanum]);
 
     
@@ -218,10 +217,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     /* controller information */
     size = sprintf(buffer+len,"\nDisk Array Controller Information:\n");
     len += size;  pos = begin + len;
-    if (virt_ctr)
-        sprintf(hrec, "%s (Bus %d)", ha->binfo.type_string, busnum);
-    else
-        strcpy(hrec, ha->binfo.type_string);
+    strcpy(hrec, ha->binfo.type_string);
     size = sprintf(buffer+len,
                    " Number:       \t%d         \tName:          \t%s\n",
                    hanum, hrec);
@@ -753,7 +749,7 @@ static void gdth_wait_completion(int hanum, int busnum, int id)
     for (i = 0; i < GDTH_MAXCMDS; ++i) {
         scp = ha->cmd_tab[i].cmnd;
 
-        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
+        b = scp->device->channel;
         t = scp->device->id;
         if (!SPECIAL_SCP(scp) && t == (unchar)id && 
             b == (unchar)busnum) {
@@ -779,8 +775,7 @@ static void gdth_stop_timeout(int hanum, int busnum, int id)
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
         if (IS_GDTH_INTERNAL_CMD(scp)) {
-            b = virt_ctr ?
-                NUMDATA(scp->device->host)->busnum : scp->device->channel;
+            b = scp->device->channel;
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
@@ -803,8 +798,7 @@ static void gdth_start_timeout(int hanum, int busnum, int id)
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
         if (!IS_GDTH_INTERNAL_CMD(scp)) {
-            b = virt_ctr ?
-                NUMDATA(scp->device->host)->busnum : scp->device->channel;
+            b = scp->device->channel;
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
                 TRACE2(("gdth_start_timeout(): update_timeout()\n"));
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index a679eeb..dd71777 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -9,9 +9,9 @@ int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info);
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
-                         int hanum,int busnum);
+                         int hanum);
 static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host,int hanum,int busnum);
+                         struct Scsi_Host *host,int hanum);
 
 static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
                              int length, int hanum);
-- 
1.5.3.1


