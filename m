From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 11/20] scsi/gdth: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:18 -0300
Message-ID: <1257711438.4759.117.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [190.108.161.231] ([190.108.161.231]:46576 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755120AbZKHUV6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Nov 2009 15:21:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, achim_leubner@adaptec.com

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/gdth.c |   66 +++++++++++++++++++++++++-------------------------
 drivers/scsi/gdth.h |   10 ++++----
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 185e6bc..a7b594e 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -145,14 +145,14 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id);
 static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
-                                                               Scsi_Cmnd *scp);
+                                                               struct scsi_cmnd *scp);
 static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority);
+static void gdth_putq(gdth_ha_str *ha, struct scsi_cmnd *scp, unchar priority);
 static void gdth_next(gdth_ha_str *ha);
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b);
-static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, unchar b);
+static int gdth_special_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp);
 static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, ushort source,
                                       ushort idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
@@ -160,10 +160,10 @@ static void gdth_readapp_event(gdth_ha_str *ha, unchar application,
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, ushort count);
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, ushort hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
 static int gdth_test_busy(gdth_ha_str *ha);
@@ -183,7 +183,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                       unsigned int cmd, unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
-static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
+static int gdth_queuecommand(struct scsi_cmnd *scp,void (*done)(struct scsi_cmnd *));
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 				struct gdth_cmndinfo *cmndinfo);
 static void gdth_scsi_done(struct scsi_cmnd *scp);
@@ -444,7 +444,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
     gdth_ha_str *ha = shost_priv(sdev->host);
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
@@ -1988,11 +1988,11 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, ushort hdrive)
 
 /* command queueing/sending functions */
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
+static void gdth_putq(gdth_ha_str *ha, struct scsi_cmnd *scp, unchar priority)
 {
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    register Scsi_Cmnd *pscp;
-    register Scsi_Cmnd *nscp;
+    register struct scsi_cmnd *pscp;
+    register struct scsi_cmnd *nscp;
     ulong flags;
 
     TRACE(("gdth_putq() priority %d\n",priority));
@@ -2006,11 +2006,11 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
         scp->SCp.ptr = NULL;
     } else {                                    /* queue not empty */
         pscp = ha->req_first;
-        nscp = (Scsi_Cmnd *)pscp->SCp.ptr;
+        nscp = (struct scsi_cmnd *)pscp->SCp.ptr;
         /* priority: 0-highest,..,0xff-lowest */
         while (nscp && gdth_cmnd_priv(nscp)->priority <= priority) {
             pscp = nscp;
-            nscp = (Scsi_Cmnd *)pscp->SCp.ptr;
+            nscp = (struct scsi_cmnd *)pscp->SCp.ptr;
         }
         pscp->SCp.ptr = (char *)scp;
         scp->SCp.ptr  = (char *)nscp;
@@ -2019,7 +2019,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
 
 #ifdef GDTH_STATISTICS
     flags = 0;
-    for (nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++flags;
     if (max_rq < flags) {
         max_rq = flags;
@@ -2030,8 +2030,8 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
 
 static void gdth_next(gdth_ha_str *ha)
 {
-    register Scsi_Cmnd *pscp;
-    register Scsi_Cmnd *nscp;
+    register struct scsi_cmnd *pscp;
+    register struct scsi_cmnd *nscp;
     unchar b, t, l, firsttime;
     unchar this_cmd, next_cmd;
     ulong flags = 0;
@@ -2046,10 +2046,10 @@ static void gdth_next(gdth_ha_str *ha)
     next_cmd = gdth_polling ? FALSE:TRUE;
     cmd_index = 0;
 
-    for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
+    for (nscp = pscp = ha->req_first; nscp; nscp = (struct scsi_cmnd *)nscp->SCp.ptr) {
         struct gdth_cmndinfo *nscp_cmndinfo = gdth_cmnd_priv(nscp);
-        if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
-            pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
+        if (nscp != pscp && nscp != (struct scsi_cmnd *)pscp->SCp.ptr)
+            pscp = (struct scsi_cmnd *)pscp->SCp.ptr;
         if (!nscp_cmndinfo->internal_command) {
             b = nscp->device->channel;
             t = nscp->device->id;
@@ -2256,7 +2256,7 @@ static void gdth_next(gdth_ha_str *ha)
         if (!this_cmd)
             break;
         if (nscp == ha->req_first)
-            ha->req_first = pscp = (Scsi_Cmnd *)nscp->SCp.ptr;
+            ha->req_first = pscp = (struct scsi_cmnd *)nscp->SCp.ptr;
         else
             pscp->SCp.ptr = nscp->SCp.ptr;
         if (!next_cmd)
@@ -2281,7 +2281,7 @@ static void gdth_next(gdth_ha_str *ha)
  * gdth_copy_internal_data() - copy to/from a buffer onto a scsi_cmnd's
  * buffers, kmap_atomic() as needed.
  */
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, ushort count)
 {
     ushort cpcount,i, max_sg = scsi_sg_count(scp);
@@ -2323,7 +2323,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
     }
 }
 
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     unchar t;
     gdth_inq_data inq;
@@ -2425,7 +2425,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     return 0;
 }
 
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, ushort hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2600,7 +2600,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, unchar b)
 {
     register gdth_cmd_str *cmdp;
     ushort i;
@@ -2773,7 +2773,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
     return cmd_index;
 }
 
-static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_special_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2967,7 +2967,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     int rval, i;
     unchar IStatus;
     ushort Service;
@@ -3226,7 +3226,7 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
-                                                              Scsi_Cmnd *scp)
+                                                              struct scsi_cmnd *scp)
 {
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
@@ -3717,7 +3717,7 @@ static unchar	gdth_timer_running;
 static void gdth_timeout(ulong data)
 {
     ulong32 i;
-    Scsi_Cmnd *nscp;
+    struct scsi_cmnd *nscp;
     gdth_ha_str *ha;
     ulong flags;
 
@@ -3733,7 +3733,7 @@ static void gdth_timeout(ulong data)
         if (ha->cmd_tab[i].cmnd != UNUSED_CMND)
             ++act_stats;
 
-    for (act_rq=0,nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (act_rq=0,nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++act_rq;
 
     TRACE2(("gdth_to(): ints %d, ios %d, act_stats %d, act_rq %d\n",
@@ -3920,12 +3920,12 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
 }
 

-static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
+static int gdth_eh_bus_reset(struct scsi_cmnd *scp)
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     int i;
     ulong flags;
-    Scsi_Cmnd *cmnd;
+    struct scsi_cmnd *cmnd;
     unchar b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
@@ -4465,7 +4465,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
                       unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     ulong flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1646444..6f5f410 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -170,9 +170,9 @@
 #define BIGSECS         63                      /* mapping 255*63 */
 
 /* special command ptr. */
-#define UNUSED_CMND     ((Scsi_Cmnd *)-1)
-#define INTERNAL_CMND   ((Scsi_Cmnd *)-2)
-#define SCREEN_CMND     ((Scsi_Cmnd *)-3)
+#define UNUSED_CMND     ((struct scsi_cmnd *)-1)
+#define INTERNAL_CMND   ((struct scsi_cmnd *)-2)
+#define SCREEN_CMND     ((struct scsi_cmnd *)-3)
 #define SPECIAL_SCP(p)  (p==UNUSED_CMND || p==INTERNAL_CMND || p==SCREEN_CMND)
 
 /* controller services */
@@ -878,7 +878,7 @@ typedef struct {
     ushort              service;                /* service/firmware ver./.. */
     ulong32             info;
     ulong32             info2;                  /* additional info */
-    Scsi_Cmnd           *req_first;             /* top of request queue */
+    struct scsi_cmnd           *req_first;             /* top of request queue */
     struct {
         unchar          present;                /* Flag: host drive present? */
         unchar          is_logdrv;              /* Flag: log. drive (master)? */
@@ -907,7 +907,7 @@ typedef struct {
         ulong32         id_list[MAXID];         /* IDs of the phys. devices */
     } raw[MAXBUS];                              /* SCSI channels */
     struct {
-        Scsi_Cmnd       *cmnd;                  /* pending request */
+        struct scsi_cmnd       *cmnd;                  /* pending request */
         ushort          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
     struct gdth_cmndinfo {                      /* per-command private info */



