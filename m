From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 04/16] SCSI: gdth: Remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:19:52 -0400
Message-ID: <1310710792.3184.55.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Chage this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/gdth.c      |   64 +++++++++++++++++++++++-----------------------
 drivers/scsi/gdth.h      |   10 +++---
 drivers/scsi/gdth_proc.c |    2 +-
 3 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..9685880 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -147,14 +147,14 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id);
 static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
-                                                               Scsi_Cmnd *scp);
+                                                               struct scsi_cmnd *scp);
 static int gdth_async_event(gdth_ha_str *ha);
 static void gdth_log_event(gdth_evt_data *dvr, char *buffer);
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority);
+static void gdth_putq(gdth_ha_str *ha, struct scsi_cmnd *scp, u8 priority);
 static void gdth_next(gdth_ha_str *ha);
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b);
-static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, u8 b);
+static int gdth_special_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp);
 static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source,
                                       u16 idx, gdth_evt_data *evt);
 static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr);
@@ -162,10 +162,10 @@ static void gdth_readapp_event(gdth_ha_str *ha, u8 application,
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, u16 count);
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive);
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, u16 hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
 static int gdth_test_busy(gdth_ha_str *ha);
@@ -447,7 +447,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
     gdth_ha_str *ha = shost_priv(sdev->host);
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
@@ -1991,11 +1991,11 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, u16 hdrive)
 
 /* command queueing/sending functions */
 
-static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
+static void gdth_putq(gdth_ha_str *ha, struct scsi_cmnd *scp, u8 priority)
 {
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    register Scsi_Cmnd *pscp;
-    register Scsi_Cmnd *nscp;
+    register struct scsi_cmnd *pscp;
+    register struct scsi_cmnd *nscp;
     unsigned long flags;
 
     TRACE(("gdth_putq() priority %d\n",priority));
@@ -2009,11 +2009,11 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
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
@@ -2022,7 +2022,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
 
 #ifdef GDTH_STATISTICS
     flags = 0;
-    for (nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++flags;
     if (max_rq < flags) {
         max_rq = flags;
@@ -2033,8 +2033,8 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
 
 static void gdth_next(gdth_ha_str *ha)
 {
-    register Scsi_Cmnd *pscp;
-    register Scsi_Cmnd *nscp;
+    register struct scsi_cmnd *pscp;
+    register struct scsi_cmnd *nscp;
     u8 b, t, l, firsttime;
     u8 this_cmd, next_cmd;
     unsigned long flags = 0;
@@ -2049,10 +2049,10 @@ static void gdth_next(gdth_ha_str *ha)
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
@@ -2259,7 +2259,7 @@ static void gdth_next(gdth_ha_str *ha)
         if (!this_cmd)
             break;
         if (nscp == ha->req_first)
-            ha->req_first = pscp = (Scsi_Cmnd *)nscp->SCp.ptr;
+            ha->req_first = pscp = (struct scsi_cmnd *)nscp->SCp.ptr;
         else
             pscp->SCp.ptr = nscp->SCp.ptr;
         if (!next_cmd)
@@ -2284,7 +2284,7 @@ static void gdth_next(gdth_ha_str *ha)
  * gdth_copy_internal_data() - copy to/from a buffer onto a scsi_cmnd's
  * buffers, kmap_atomic() as needed.
  */
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, u16 count)
 {
     u16 cpcount,i, max_sg = scsi_sg_count(scp);
@@ -2326,7 +2326,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
     }
 }
 
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     u8 t;
     gdth_inq_data inq;
@@ -2428,7 +2428,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     return 0;
 }
 
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive)
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, u16 hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2603,7 +2603,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive)
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, u8 b)
 {
     register gdth_cmd_str *cmdp;
     u16 i;
@@ -2776,7 +2776,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
     return cmd_index;
 }
 
-static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_special_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2970,7 +2970,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     int rval, i;
     u8 IStatus;
     u16 Service;
@@ -3229,7 +3229,7 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
-                                                              Scsi_Cmnd *scp)
+                                                              struct scsi_cmnd *scp)
 {
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
@@ -3720,7 +3720,7 @@ static u8	gdth_timer_running;
 static void gdth_timeout(unsigned long data)
 {
     u32 i;
-    Scsi_Cmnd *nscp;
+    struct scsi_cmnd *nscp;
     gdth_ha_str *ha;
     unsigned long flags;
 
@@ -3736,7 +3736,7 @@ static void gdth_timeout(unsigned long data)
         if (ha->cmd_tab[i].cmnd != UNUSED_CMND)
             ++act_stats;
 
-    for (act_rq=0,nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (act_rq=0,nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++act_rq;
 
     TRACE2(("gdth_to(): ints %d, ios %d, act_stats %d, act_rq %d\n",
@@ -3923,12 +3923,12 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
 }
 

-static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
+static int gdth_eh_bus_reset(struct scsi_cmnd *scp)
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     int i;
     unsigned long flags;
-    Scsi_Cmnd *cmnd;
+    struct scsi_cmnd *cmnd;
     u8 b;
 
     TRACE2(("gdth_eh_bus_reset()\n"));
@@ -4479,7 +4479,7 @@ free_fail:
 static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     unsigned long flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index d969855..7634362 100644
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
     u16              service;                /* service/firmware ver./.. */
     u32             info;
     u32             info2;                  /* additional info */
-    Scsi_Cmnd           *req_first;             /* top of request queue */
+    struct scsi_cmnd           *req_first;             /* top of request queue */
     struct {
         u8          present;                /* Flag: host drive present? */
         u8          is_logdrv;              /* Flag: log. drive (master)? */
@@ -907,7 +907,7 @@ typedef struct {
         u32         id_list[MAXID];         /* IDs of the phys. devices */
     } raw[MAXBUS];                              /* SCSI channels */
     struct {
-        Scsi_Cmnd       *cmnd;                  /* pending request */
+        struct scsi_cmnd       *cmnd;                  /* pending request */
         u16          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
     struct gdth_cmndinfo {                      /* per-command private info */
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 6527543..054e1d2 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -735,7 +735,7 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     unsigned long flags;
     int i;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo *cmndinfo;
     u8 b, t;
 
-- 
1.7.4.1
