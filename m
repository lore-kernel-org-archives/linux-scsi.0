From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 14/16] gdth: Setup proper per-command private data
Date: Tue, 02 Oct 2007 23:14:39 +0200
Message-ID: <4702B4BF.9060702@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11630 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753977AbXJBVPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:15:00 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kern>


  - scsi_cmnd and specifically ->SCp of, where heavily abused
    with internal meaning members and flags. So introduce a new
    struct gdth_cmndinfo, put it on ->host_scribble and define a
    gdth_cmnd_priv() accessor to retrieve it from a scsi_cmnd.

  - The structure now holds two members:
    internal_command - replaces the IS_GDTH_INTERNAL_CMD() croft.
    sense_paddr - which was a 64-bit spanning on 2 32-bit members of SCp.
    More overloaded members from SCp and scsi_cmnd will be moved in a later
    patch (For easy review).

  - Split up gdth_queuecommand to an additional internal_function. The later
    is the one called by gdth_execute(). This will be more evident later in
    the scsi accessors patch, but it also facilitates in the differentiation
    between internal_command and external. And the setup of gdth_cmndinfo of
    each command.

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c      |  111 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/gdth.h      |   10 ++++
 drivers/scsi/gdth_proc.c |    6 ++-
 3 files changed, 91 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 62b1bb7..966f632 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -86,8 +86,8 @@
 /* The meaning of the Scsi_Pointer members in this driver is as follows:
  * ptr:                     Chaining
  * this_residual:           Command priority
- * buffer:                  phys. DMA sense buffer 
- * dma_handle:              phys. DMA buffer (kernel >= 2.4.0)
+ * buffer:                  unused
+ * dma_handle:              will drop in !use_sg patch.
  * buffers_residual:        Timeout value
  * Status:                  Command status (gdth_do_cmd()), DMA mem. mappings
  * Message:                 Additional info (gdth_do_cmd()), DMA direction
@@ -184,6 +184,8 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
 static void gdth_flush(gdth_ha_str *ha);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
+static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
+				struct gdth_cmndinfo *cmndinfo);
 static void gdth_scsi_done(struct scsi_cmnd *scp);
 
 #ifdef DEBUG_GDTH
@@ -371,9 +373,6 @@ static const struct file_operations gdth_fops = {
     .release = gdth_close,
 };
 
-#define GDTH_MAGIC	0xc2e7c389	/* I got it from /dev/urandom */
-#define IS_GDTH_INTERNAL_CMD(scp)	(scp->underflow == GDTH_MAGIC)
-
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -394,6 +393,34 @@ static gdth_ha_str *gdth_find_ha(int hanum)
 	return NULL;
 }
 
+static struct gdth_cmndinfo *gdth_get_cmndinfo(gdth_ha_str *ha)
+{
+	struct gdth_cmndinfo *priv = NULL;
+	ulong flags;
+	int i;
+
+	spin_lock_irqsave(&ha->smp_lock, flags);
+
+	for (i=0; i<GDTH_MAXCMDS; ++i) {
+		if (ha->cmndinfo[i].index == 0) {
+			priv = &ha->cmndinfo[i];
+			priv->index = i;
+			memset(priv, 0, sizeof(*priv));
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&ha->smp_lock, flags);
+
+	return priv;
+}
+
+static void gdth_put_cmndinfo(struct gdth_cmndinfo *priv)
+{
+	BUG_ON(!priv);
+	priv->index = 0;
+}
+
 static void gdth_delay(int milliseconds)
 {
     if (milliseconds == 0) {
@@ -405,9 +432,15 @@ static void gdth_delay(int milliseconds)
 
 static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
+	struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
+	int internal_command = cmndinfo->internal_command;
+
 	TRACE2(("gdth_scsi_done()\n"));
 
-	if (IS_GDTH_INTERNAL_CMD(scp))
+	gdth_put_cmndinfo(cmndinfo);
+	scp->host_scribble = NULL;
+
+	if (internal_command)
 		complete((struct completion *)scp->request);
 	else
 		scp->scsi_done(scp);
@@ -416,7 +449,9 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
+    gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
+    struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
@@ -425,6 +460,8 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
         return -ENOMEM;
 
     scp->device = sdev;
+    memset(&cmndinfo, 0, sizeof(cmndinfo));
+
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
@@ -432,8 +469,11 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->underflow = GDTH_MAGIC;
-    gdth_queuecommand(scp, NULL);
+    cmndinfo.internal_command = 1;
+
+    TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
+    __gdth_queuecommand(ha, scp, &cmndinfo);
+
     wait_for_completion(&wait);
 
     rval = scp->SCp.Status;
@@ -1966,6 +2006,7 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
 
 static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
 {
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     ulong flags;
@@ -1974,7 +2015,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
     TRACE(("gdth_putq() priority %d\n",priority));
     spin_lock_irqsave(&ha->smp_lock, flags);
 
-    if (!IS_GDTH_INTERNAL_CMD(scp)) {
+    if (!cmndinfo->internal_command) {
         scp->SCp.this_residual = (int)priority;
         b = scp->device->channel;
         t = scp->device->id;
@@ -2035,7 +2076,7 @@ static void gdth_next(gdth_ha_str *ha)
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
+        if (!gdth_cmnd_priv(nscp)->internal_command) {
             b = nscp->device->channel;
             t = nscp->device->id;
             l = nscp->device->lun;
@@ -2060,7 +2101,7 @@ static void gdth_next(gdth_ha_str *ha)
             firsttime = FALSE;
         }
 
-        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
+        if (!gdth_cmnd_priv(nscp)->internal_command) {
         if (nscp->SCp.phase == -1) {
             nscp->SCp.phase = CACHESERVICE;           /* default: cache svc. */ 
             if (nscp->cmnd[0] == TEST_UNIT_READY) {
@@ -2123,7 +2164,7 @@ static void gdth_next(gdth_ha_str *ha)
                 else
                     gdth_scsi_done(nscp);
             }
-        } else if (IS_GDTH_INTERNAL_CMD(nscp)) {
+        } else if (gdth_cmnd_priv(nscp)->internal_command) {
             if (!(cmd_index=gdth_special_cmd(ha, nscp)))
                 this_cmd = FALSE;
             next_cmd = FALSE;
@@ -2622,6 +2663,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
     unchar t,l;
     struct page *page;
     ulong offset;
+    struct gdth_cmndinfo *cmndinfo;
 
     t = scp->device->id;
     l = scp->device->lun;
@@ -2645,6 +2687,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
     if (ha->cmd_cnt == 0)
         gdth_set_sema0(ha);
 
+    cmndinfo = gdth_cmnd_priv(scp);
     /* fill command */  
     if (scp->SCp.sent_command != -1) {
         cmdp->OpCode           = scp->SCp.sent_command; /* special raw cmd. */
@@ -2668,9 +2711,8 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
         offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
-        *(ulong32 *)&scp->SCp.buffer = (ulong32)sense_paddr;
-        /* high part, if 64bit */
-        *(ulong32 *)&scp->host_scribble = (ulong32)((ulong64)sense_paddr >> 32);
+
+	cmndinfo->sense_paddr  = sense_paddr;
         cmdp->OpCode           = GDT_WRITE;             /* always */
         cmdp->BoardNode        = LOCALBOARD;
         if (mode64) { 
@@ -3271,6 +3313,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
     unchar b, t;
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
 
     cmdp = ha->pccb;
     TRACE(("gdth_sync_event() serv %d status %d\n",
@@ -3364,14 +3407,9 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
         else if (scp->SCp.Status == GDTH_MAP_SINGLE) 
             pci_unmap_page(ha->pdev,scp->SCp.dma_handle,
                            scp->request_bufflen,scp->SCp.Message);
-        if (scp->SCp.buffer) {
-            dma_addr_t addr;
-            addr = (dma_addr_t)*(ulong32 *)&scp->SCp.buffer;
-            if (scp->host_scribble)
-                addr += (dma_addr_t)
-                    ((ulong64)(*(ulong32 *)&scp->host_scribble) << 32);
-            pci_unmap_page(ha->pdev,addr,16,PCI_DMA_FROMDEVICE);
-        }
+        if (cmndinfo->sense_paddr)
+            pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
+                                                           PCI_DMA_FROMDEVICE);
 
         if (ha->status == S_OK) {
             scp->SCp.Status = S_OK;
@@ -3450,7 +3488,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                     scp->sense_buffer[2] = NOT_READY;
                     scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                 }
-                if (!IS_GDTH_INTERNAL_CMD(scp)) {
+                if (!cmndinfo->internal_command) {
                     ha->dvr.size = sizeof(ha->dvr.eu.sync);
                     ha->dvr.eu.sync.ionode  = ha->hanum;
                     ha->dvr.eu.sync.service = service;
@@ -3995,28 +4033,33 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
 				void (*done)(struct scsi_cmnd *))
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
-    int priority;
+    struct gdth_cmndinfo *cmndinfo;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
-    
+
+    cmndinfo = gdth_get_cmndinfo(ha);
+    BUG_ON(!cmndinfo);
+
     scp->scsi_done = done;
+    gdth_update_timeout(scp, scp->timeout_per_command * 6);
+    scp->SCp.this_residual = DEFAULT_PRI;
+    return __gdth_queuecommand(ha, scp, cmndinfo);
+}
+
+static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
+				struct gdth_cmndinfo *cmndinfo)
+{
+    scp->host_scribble = (unsigned char *)cmndinfo;
     scp->SCp.have_data_in = 1;
     scp->SCp.phase = -1;
     scp->SCp.sent_command = -1;
     scp->SCp.Status = GDTH_MAP_NONE;
-    scp->SCp.buffer = (struct scatterlist *)NULL;
 
 #ifdef GDTH_STATISTICS
     ++act_ios;
 #endif
 
-    priority = DEFAULT_PRI;
-    if (IS_GDTH_INTERNAL_CMD(scp))
-        priority = scp->SCp.this_residual;
-    else
-        gdth_update_timeout(scp, scp->timeout_per_command * 6);
-
-    gdth_putq(ha, scp, priority);
+    gdth_putq(ha, scp, scp->SCp.this_residual);
     gdth_next(ha);
     return 0;
 }
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index e6178c4..be4ae5a 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -919,6 +919,11 @@ typedef struct {
         Scsi_Cmnd       *cmnd;                  /* pending request */
         ushort          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
+    struct gdth_cmndinfo {                      /* per-command private info */
+        int index;
+        int internal_command;                   /* don't call scsi_done */
+        dma_addr_t sense_paddr;                 /* sense dma-addr */
+    } cmndinfo[GDTH_MAXCMDS];                   /* index==0 is free */
     unchar              bus_cnt;                /* SCSI bus count */
     unchar              tid_cnt;                /* Target ID count */
     unchar              bus_id[MAXBUS];         /* IOP IDs */
@@ -941,6 +946,11 @@ typedef struct {
     struct scsi_device         *sdev;
 } gdth_ha_str;
 
+static inline struct gdth_cmndinfo *gdth_cmnd_priv(struct scsi_cmnd* cmd)
+{
+	return (struct gdth_cmndinfo *)cmd->host_scribble;
+}
+
 /* INQUIRY data format */
 typedef struct {
     unchar      type_qual;
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 6391e6a..ad1b60d 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -758,7 +758,8 @@ static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id)
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        if (IS_GDTH_INTERNAL_CMD(scp)) {
+        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
+        if (!cmndinfo->internal_command) {
             b = scp->device->channel;
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
@@ -779,7 +780,8 @@ static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id)
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        if (!IS_GDTH_INTERNAL_CMD(scp)) {
+        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
+        if (!cmndinfo->internal_command) {
             b = scp->device->channel;
             t = scp->device->id;
             if (t == (unchar)id && b == (unchar)busnum) {
-- 
1.5.3.1


