From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/16] gdth: Remove gdth_ctr_tab[]
Date: Sun, 30 Sep 2007 22:12:19 +0200
Message-ID: <47000323.7010601@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa7.bezeqint.net ([192.115.104.21]:51719 "EHLO sa7.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXI3UMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Sep 2007 16:12:24 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  - Places like Initialization and Reset that Just loop on all devices can
    use the link list with the list_for_each_entry macro.
    But the io_ctrl from user mode now suffers performance-wise because
    code has to do a sequential search for the requested host number.
    I have isolated this search in a gdth_find_ha(int hanum) member
    for future enhancement if needed.

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |  109 ++++++++++++++++++++++++---------------------------
 1 files changed, 51 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 986bfaf..0ae330d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -296,8 +296,7 @@ static unchar   gdth_polling;                           /* polling if TRUE */
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
 static int      wait_index,wait_hanum;                  /* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
-static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
-static LIST_HEAD(gdth_instances);
+static LIST_HEAD(gdth_instances);                       /* controller list */
 static unchar   gdth_write_through = FALSE;             /* write through */
 static gdth_evt_str ebuffer[MAX_EVENTS];                /* event buffer */
 static int elastidx;
@@ -387,6 +386,17 @@ static struct notifier_block gdth_notifier = {
 };
 static int notifier_disabled = 0;
 
+static gdth_ha_str *gdth_find_ha(int hanum)
+{
+	gdth_ha_str *ha;
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		if (hanum == ha->hanum)
+			return ha;
+
+	return NULL;
+}
+
 static void gdth_delay(int milliseconds)
 {
     if (milliseconds == 0) {
@@ -3752,7 +3762,7 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
-    ha = shost_priv(gdth_ctr_tab[0]);
+    ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (act_stats=0,i=0; i<GDTH_MAXCMDS; ++i) 
@@ -4011,12 +4021,10 @@ static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 static int gdth_open(struct inode *inode, struct file *filep)
 {
     gdth_ha_str *ha;
-    int i;
 
-    for (i = 0; i < gdth_ctr_count; i++) {
-        ha = shost_priv(gdth_ctr_tab[i]);
+    list_for_each_entry(ha, &gdth_instances, list) {
         if (!ha->sdev)
-            ha->sdev = scsi_get_host_dev(gdth_ctr_tab[i]);
+            ha->sdev = scsi_get_host_dev(ha->shost);
     }
 
     TRACE(("gdth_open()\n"));
@@ -4035,10 +4043,11 @@ static int ioc_event(void __user *arg)
     gdth_ha_str *ha;
     ulong flags;
 
-    if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)) ||
-        evt.ionode >= gdth_ctr_count)
+    if (copy_from_user(&evt, arg, sizeof(gdth_ioctl_event)))
+        return -EFAULT;
+    ha = gdth_find_ha(evt.ionode);
+    if (!ha)
         return -EFAULT;
-    ha = shost_priv(gdth_ctr_tab[evt.ionode]);
 
     if (evt.erase == 0xff) {
         if (evt.event.event_source == ES_TEST)
@@ -4072,11 +4081,12 @@ static int ioc_lockdrv(void __user *arg)
     ulong flags;
     gdth_ha_str *ha;
 
-    if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)) ||
-        ldrv.ionode >= gdth_ctr_count)
+    if (copy_from_user(&ldrv, arg, sizeof(gdth_ioctl_lockdrv)))
         return -EFAULT;
-    ha = shost_priv(gdth_ctr_tab[ldrv.ionode]);
- 
+    ha = gdth_find_ha(ldrv.ionode);
+    if (!ha)
+        return -EFAULT;
+
     for (i = 0; i < ldrv.drive_cnt && i < MAX_HDRIVES; ++i) {
         j = ldrv.drives[i];
         if (j >= MAX_HDRIVES || !ha->hdr[j].present)
@@ -4106,9 +4116,11 @@ static int ioc_resetdrv(void __user *arg, char *cmnd)
     int rval;
 
     if (copy_from_user(&res, arg, sizeof(gdth_ioctl_reset)) ||
-        res.ionode >= gdth_ctr_count || res.number >= MAX_HDRIVES)
+        res.number >= MAX_HDRIVES)
+        return -EFAULT;
+    ha = gdth_find_ha(res.ionode);
+    if (!ha)
         return -EFAULT;
-    ha = shost_priv(gdth_ctr_tab[res.ionode]);
 
     if (!ha->hdr[res.number].present)
         return 0;
@@ -4137,11 +4149,12 @@ static int ioc_general(void __user *arg, char *cmnd)
     ulong64 paddr; 
     gdth_ha_str *ha;
     int rval;
-        
-    if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)) ||
-        gen.ionode >= gdth_ctr_count)
+
+    if (copy_from_user(&gen, arg, sizeof(gdth_ioctl_general)))
+        return -EFAULT;
+    ha = gdth_find_ha(gen.ionode);
+    if (!ha)
         return -EFAULT;
-    ha = shost_priv(gdth_ctr_tab[gen.ionode]);
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))
@@ -4261,11 +4274,10 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
         goto free_fail;
 
     if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
-        rsc->ionode >= gdth_ctr_count) {
+        (NULL == (ha = gdth_find_ha(rsc->ionode)))) {
         rc = -EFAULT;
         goto free_fail;
     }
-    ha = shost_priv(gdth_ctr_tab[rsc->ionode]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
    
     for (i = 0; i < MAX_HDRIVES; ++i) { 
@@ -4317,11 +4329,10 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         goto free_fail;
 
     if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
-        rsc->ionode >= gdth_ctr_count) {
+        (NULL == (ha = gdth_find_ha(rsc->ionode)))) {
         rc = -EFAULT;
         goto free_fail;
     }
-    ha = shost_priv(gdth_ctr_tab[rsc->ionode]);
     memset(cmd, 0, sizeof(gdth_cmd_str));
 
     if (rsc->flag == 0) {
@@ -4478,9 +4489,9 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         gdth_ioctl_ctrtype ctrt;
         
         if (copy_from_user(&ctrt, argp, sizeof(gdth_ioctl_ctrtype)) ||
-            ctrt.ionode >= gdth_ctr_count)
+            (NULL == (ha = gdth_find_ha(ctrt.ionode))))
             return -EFAULT;
-        ha = shost_priv(gdth_ctr_tab[ctrt.ionode]);
+
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
             ctrt.type = (unchar)((ha->stype>>20) - 0x10);
         } else {
@@ -4519,10 +4530,9 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         unchar i, j;
 
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
-            lchn.ionode >= gdth_ctr_count)
+            (NULL == (ha = gdth_find_ha(lchn.ionode))))
             return -EFAULT;
-        ha = shost_priv(gdth_ctr_tab[lchn.ionode]);
-        
+
         i = lchn.channel;
         if (i < ha->bus_cnt) {
             if (lchn.lock) {
@@ -4558,9 +4568,8 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         int rval;
 
         if (copy_from_user(&res, argp, sizeof(gdth_ioctl_reset)) ||
-            res.ionode >= gdth_ctr_count)
+            (NULL == (ha = gdth_find_ha(res.ionode))))
             return -EFAULT;
-        ha = shost_priv(gdth_ctr_tab[res.ionode]);
 
         scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
         if (!scp)
@@ -4622,7 +4631,7 @@ static void gdth_flush(gdth_ha_str *ha)
 /* shutdown routine */
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
 {
-    int             hanum;
+    gdth_ha_str *ha;
 #ifndef __alpha__
     gdth_cmd_str    gdtcmd;
     char            cmnd[MAX_COMMAND_SIZE];   
@@ -4637,8 +4646,7 @@ static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
 
     notifier_disabled = 1;
     printk("GDT-HA: Flushing all host drives .. ");
-    for (hanum = 0; hanum < gdth_ctr_count; ++hanum) {
-        gdth_ha_str *ha = shost_priv(gdth_ctr_tab[hanum]);
+    list_for_each_entry(ha, &gdth_instances, list) {
         gdth_flush(ha);
 
 #ifndef __alpha__
@@ -4691,7 +4699,7 @@ static int gdth_isa_probe_one(ulong32 isa_bios)
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
-	int error, hanum, i;
+	int error, i;
 
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
@@ -4726,10 +4734,8 @@ static int gdth_isa_probe_one(ulong32 isa_bios)
 	shp->unchecked_isa_dma = 1;
 	shp->irq = ha->irq;
 	shp->dma_channel = ha->drq;
-	hanum = gdth_ctr_count;
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	ha->hanum = (ushort)hanum;
+	ha->hanum = gdth_ctr_count++;
 	ha->shost = shp;
 
 	ha->pccb = &ha->cmdext;
@@ -4821,7 +4827,7 @@ static int gdth_eisa_probe_one(ushort eisa_slot)
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
-	int error, hanum, i;
+	int error, i;
 
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
@@ -4848,10 +4854,8 @@ static int gdth_eisa_probe_one(ushort eisa_slot)
 	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
-	hanum = gdth_ctr_count;
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	ha->hanum = (ushort)hanum;
+	ha->hanum = gdth_ctr_count++;
 	ha->shost = shp;
 
 	TRACE2(("EISA detect Bus 0: hanum %d\n", ha->hanum));
@@ -4952,7 +4956,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
-	int error, hanum, i;
+	int error, i;
 
 	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
@@ -4979,10 +4983,8 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
-	hanum = gdth_ctr_count;
-	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
-	ha->hanum = (ushort)hanum;
+	ha->hanum = gdth_ctr_count++;
 	ha->shost = shp;
 
 	ha->pccb = &ha->cmdext;
@@ -5147,18 +5149,12 @@ static int __init gdth_init(void)
 		/* scanning for controllers, at first: ISA controller */
 #ifdef CONFIG_ISA
 		for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
-			     isa_bios += 0x8000UL) {
-			if (gdth_ctr_count >= MAXHA)
-				break;
+			     isa_bios += 0x8000UL)
 			gdth_isa_probe_one(isa_bios);
-		}
 #endif
 #ifdef CONFIG_EISA
-		for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
-			if (gdth_ctr_count >= MAXHA)
-				break;
+		for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000)
 			gdth_eisa_probe_one(eisa_slot);
-		}
 	}
 #endif
 #ifdef CONFIG_PCI
@@ -5166,11 +5162,8 @@ static int __init gdth_init(void)
 	cnt = gdth_search_pci(pcistr);
 	printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
 	gdth_sort_pci(pcistr,cnt);
-	for (ctr = 0; ctr < cnt; ++ctr) {
-		if (gdth_ctr_count >= MAXHA)
-			break;
+	for (ctr = 0; ctr < cnt; ++ctr)
 		gdth_pci_probe_one(pcistr, ctr);
-	}
 #endif
 
 	TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
