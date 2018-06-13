From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/3] scsi: remove Scsi_Cmnd typedef
Date: Wed, 13 Jun 2018 09:53:47 +0200
Message-ID: <20180613075349.7509-2-jthumshirn@suse.de>
References: <20180613075349.7509-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613075349.7509-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This will make subsequent refactoring easier to handle.

Note: this patch is nowhere checkpatch clean.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

---
Changes to v1:
- Removed duplicated "struct" in comment (Bart)
---
 drivers/scsi/3w-xxxx.c           |  2 +-
 drivers/scsi/advansys.c          |  2 +-
 drivers/scsi/aha152x.c           | 71 +++++++++++++++++++++-------------------
 drivers/scsi/aha1740.c           |  9 ++---
 drivers/scsi/aha1740.h           |  4 +--
 drivers/scsi/gdth.c              | 67 +++++++++++++++++++------------------
 drivers/scsi/gdth.h              | 10 +++---
 drivers/scsi/gdth_proc.c         |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c   |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c |  2 +-
 drivers/scsi/libiscsi_tcp.c      |  2 +-
 drivers/scsi/megaraid.c          | 29 ++++++++--------
 drivers/scsi/megaraid.h          | 14 ++++----
 drivers/scsi/nsp32_debug.c       |  2 +-
 drivers/scsi/scsi.h              |  3 --
 drivers/scsi/scsi_typedefs.h     |  2 --
 16 files changed, 114 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/scsi/scsi_typedefs.h

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index f6179e3d6953..a40d353bd8b3 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1925,7 +1925,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 	if (test_bit(TW_IN_RESET, &tw_dev->flags))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/* Save done function into Scsi_Cmnd struct */
+	/* Save done function into struct scsi_cmnd */
 	SCpnt->scsi_done = done;
 		 
 	/* Queue the command and get a request id */
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 24e57e770432..c9a52905070e 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8466,7 +8466,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, adv_req_t *reqp)
 }
 
 /*
- * Execute a single 'Scsi_Cmnd'.
+ * Execute a single 'struct scsi_cmnd'.
  */
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index bc0058df31c6..4d7b0e0adbf7 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -422,16 +422,16 @@ enum aha152x_state {
  *
  */
 struct aha152x_hostdata {
-	Scsi_Cmnd *issue_SC;
+	struct scsi_cmnd *issue_SC;
 		/* pending commands to issue */
 
-	Scsi_Cmnd *current_SC;
+	struct scsi_cmnd *current_SC;
 		/* current command on the bus */
 
-	Scsi_Cmnd *disconnected_SC;
+	struct scsi_cmnd *disconnected_SC;
 		/* commands that disconnected */
 
-	Scsi_Cmnd *done_SC;
+	struct scsi_cmnd *done_SC;
 		/* command that was completed */
 
 	spinlock_t lock;
@@ -510,7 +510,7 @@ struct aha152x_hostdata {
  *
  */
 struct aha152x_scdata {
-	Scsi_Cmnd *next;	/* next sc in queue */
+	struct scsi_cmnd *next;	/* next sc in queue */
 	struct completion *done;/* semaphore to block on */
 	struct scsi_eh_save ses;
 };
@@ -633,7 +633,7 @@ static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, int error);
 
 /* diagnostics */
-static void show_command(Scsi_Cmnd * ptr);
+static void show_command(struct scsi_cmnd * ptr);
 static void show_queues(struct Scsi_Host *shpnt);
 static void disp_enintr(struct Scsi_Host *shpnt);
 
@@ -642,9 +642,9 @@ static void disp_enintr(struct Scsi_Host *shpnt);
  *  queue services:
  *
  */
-static inline void append_SC(Scsi_Cmnd **SC, Scsi_Cmnd *new_SC)
+static inline void append_SC(struct scsi_cmnd **SC, struct scsi_cmnd *new_SC)
 {
-	Scsi_Cmnd *end;
+	struct scsi_cmnd *end;
 
 	SCNEXT(new_SC) = NULL;
 	if (!*SC)
@@ -656,9 +656,9 @@ static inline void append_SC(Scsi_Cmnd **SC, Scsi_Cmnd *new_SC)
 	}
 }
 
-static inline Scsi_Cmnd *remove_first_SC(Scsi_Cmnd ** SC)
+static inline struct scsi_cmnd *remove_first_SC(struct scsi_cmnd ** SC)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	ptr = *SC;
 	if (ptr) {
@@ -668,9 +668,10 @@ static inline Scsi_Cmnd *remove_first_SC(Scsi_Cmnd ** SC)
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_lun_SC(Scsi_Cmnd ** SC, int target, int lun)
+static inline struct scsi_cmnd *remove_lun_SC(struct scsi_cmnd ** SC,
+					      int target, int lun)
 {
-	Scsi_Cmnd *ptr, *prev;
+	struct scsi_cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
 	     ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
@@ -689,9 +690,10 @@ static inline Scsi_Cmnd *remove_lun_SC(Scsi_Cmnd ** SC, int target, int lun)
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, Scsi_Cmnd *SCp)
+static inline struct scsi_cmnd *remove_SC(struct scsi_cmnd **SC,
+					  struct scsi_cmnd *SCp)
 {
-	Scsi_Cmnd *ptr, *prev;
+	struct scsi_cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
 	     ptr && SCp!=ptr;
@@ -912,8 +914,9 @@ static int setup_expected_interrupts(struct Scsi_Host *shpnt)
 /*
  *  Queue a command and setup interrupts for a free bus.
  */
-static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
-		int phase, void (*done)(Scsi_Cmnd *))
+static int aha152x_internal_queue(struct scsi_cmnd *SCpnt,
+				  struct completion *complete,
+				  int phase, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -987,7 +990,8 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  *  queue a command
  *
  */
-static int aha152x_queue_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha152x_queue_lck(struct scsi_cmnd *SCpnt,
+			     void (*done)(struct scsi_cmnd *))
 {
 	return aha152x_internal_queue(SCpnt, NULL, 0, done);
 }
@@ -998,7 +1002,7 @@ static DEF_SCSI_QCMD(aha152x_queue)
 /*
  *
  */
-static void reset_done(Scsi_Cmnd *SCpnt)
+static void reset_done(struct scsi_cmnd *SCpnt)
 {
 	if(SCSEM(SCpnt)) {
 		complete(SCSEM(SCpnt));
@@ -1011,10 +1015,10 @@ static void reset_done(Scsi_Cmnd *SCpnt)
  *  Abort a command
  *
  */
-static int aha152x_abort(Scsi_Cmnd *SCpnt)
+static int aha152x_abort(struct scsi_cmnd *SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	DO_LOCK(flags);
@@ -1052,7 +1056,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
  * Reset a device
  *
  */
-static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
+static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	DECLARE_COMPLETION(done);
@@ -1110,13 +1114,14 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	return ret;
 }
 
-static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
+static void free_hard_reset_SCs(struct Scsi_Host *shpnt,
+				struct scsi_cmnd **SCs)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	ptr=*SCs;
 	while(ptr) {
-		Scsi_Cmnd *next;
+		struct scsi_cmnd *next;
 
 		if(SCDATA(ptr)) {
 			next = SCNEXT(ptr);
@@ -1171,7 +1176,7 @@ static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
  * Reset the bus
  *
  */
-static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
+static int aha152x_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	return aha152x_bus_reset_host(SCpnt->device->host);
 }
@@ -1436,7 +1441,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 
 			if(!(DONE_SC->SCp.phase & not_issued)) {
 				struct aha152x_scdata *sc;
-				Scsi_Cmnd *ptr = DONE_SC;
+				struct scsi_cmnd *ptr = DONE_SC;
 				DONE_SC=NULL;
 
 				sc = SCDATA(ptr);
@@ -1451,7 +1456,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 		}
 
 		if(DONE_SC && DONE_SC->scsi_done) {
-			Scsi_Cmnd *ptr = DONE_SC;
+			struct scsi_cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
 
 			/* turn led off, when no commands are in the driver */
@@ -2247,13 +2252,13 @@ static void parerr_run(struct Scsi_Host *shpnt)
  */
 static void rsti_run(struct Scsi_Host *shpnt)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	shost_printk(KERN_NOTICE, shpnt, "scsi reset in\n");
 
 	ptr=DISCONNECTED_SC;
 	while(ptr) {
-		Scsi_Cmnd *next = SCNEXT(ptr);
+		struct scsi_cmnd *next = SCNEXT(ptr);
 
 		if (!ptr->device->soft_reset) {
 			remove_SC(&DISCONNECTED_SC, ptr);
@@ -2438,7 +2443,7 @@ static void disp_enintr(struct Scsi_Host *shpnt)
 /*
  * Show the command data of a command
  */
-static void show_command(Scsi_Cmnd *ptr)
+static void show_command(struct scsi_cmnd *ptr)
 {
 	scsi_print_command(ptr);
 	scmd_printk(KERN_DEBUG, ptr,
@@ -2462,7 +2467,7 @@ static void show_command(Scsi_Cmnd *ptr)
  */
 static void show_queues(struct Scsi_Host *shpnt)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	DO_LOCK(flags);
@@ -2484,7 +2489,7 @@ static void show_queues(struct Scsi_Host *shpnt)
 	disp_enintr(shpnt);
 }
 
-static void get_command(struct seq_file *m, Scsi_Cmnd * ptr)
+static void get_command(struct seq_file *m, struct scsi_cmnd * ptr)
 {
 	int i;
 
@@ -2813,7 +2818,7 @@ static int aha152x_set_info(struct Scsi_Host *shpnt, char *buffer, int length)
 static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 {
 	int i;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	seq_puts(m, AHA152X_REVID "\n");
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index b48d5436f094..786bf7f32c64 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -207,11 +207,11 @@ static int aha1740_test_port(unsigned int base)
 static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *) dev_id;
-        void (*my_done)(Scsi_Cmnd *);
+        void (*my_done)(struct scsi_cmnd *);
 	int errstatus, adapstat;
 	int number_serviced;
 	struct ecb *ecbptr;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 	unsigned int base;
 	unsigned long flags;
 	int handled = 0;
@@ -311,7 +311,8 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-static int aha1740_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha1740_queuecommand_lck(struct scsi_cmnd * SCpnt,
+				    void (*done)(struct scsi_cmnd *))
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
@@ -520,7 +521,7 @@ static int aha1740_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
+static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 {
 /*
  * From Alan Cox :
diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
index dfdaa4d3ea4e..6eeed6da0b54 100644
--- a/drivers/scsi/aha1740.h
+++ b/drivers/scsi/aha1740.h
@@ -135,8 +135,8 @@ struct ecb {			/* Enhanced Control Block 6.1 */
 /* Hardware defined portion ends here, rest is driver defined */
 	u8 sense[MAX_SENSE];	/* Sense area */
 	u8 status[MAX_STATUS];	/* Status area */
-	Scsi_Cmnd *SCpnt;	/* Link to the SCSI Command Block */
-	void (*done) (Scsi_Cmnd *);	/* Completion Function */
+	struct scsi_cmnd *SCpnt;	/* Link to the SCSI Command Block */
+	void (*done) (struct scsi_cmnd *);	/* Completion Function */
 };
 
 #define	AHA1740CMD_NOP	 0x00	/* No OP */
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 85604795d8ee..16709735b546 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -146,14 +146,14 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id);
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
@@ -161,10 +161,11 @@ static void gdth_readapp_event(gdth_ha_str *ha, u8 application,
                                gdth_evt_str *estr);
 static void gdth_clear_events(void);
 
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, u16 count);
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive);
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp);
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp,
+			       u16 hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
 static int gdth_test_busy(gdth_ha_str *ha);
@@ -446,7 +447,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
     gdth_ha_str *ha = shost_priv(sdev->host);
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
@@ -1982,11 +1983,11 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, u16 hdrive)
 
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
@@ -2000,11 +2001,11 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
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
@@ -2013,7 +2014,7 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
 
 #ifdef GDTH_STATISTICS
     flags = 0;
-    for (nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++flags;
     if (max_rq < flags) {
         max_rq = flags;
@@ -2024,8 +2025,8 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 priority)
 
 static void gdth_next(gdth_ha_str *ha)
 {
-    register Scsi_Cmnd *pscp;
-    register Scsi_Cmnd *nscp;
+    register struct scsi_cmnd *pscp;
+    register struct scsi_cmnd *nscp;
     u8 b, t, l, firsttime;
     u8 this_cmd, next_cmd;
     unsigned long flags = 0;
@@ -2040,10 +2041,10 @@ static void gdth_next(gdth_ha_str *ha)
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
@@ -2250,7 +2251,7 @@ static void gdth_next(gdth_ha_str *ha)
         if (!this_cmd)
             break;
         if (nscp == ha->req_first)
-            ha->req_first = pscp = (Scsi_Cmnd *)nscp->SCp.ptr;
+            ha->req_first = pscp = (struct scsi_cmnd *)nscp->SCp.ptr;
         else
             pscp->SCp.ptr = nscp->SCp.ptr;
         if (!next_cmd)
@@ -2275,7 +2276,7 @@ static void gdth_next(gdth_ha_str *ha)
  * gdth_copy_internal_data() - copy to/from a buffer onto a scsi_cmnd's
  * buffers, kmap_atomic() as needed.
  */
-static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
+static void gdth_copy_internal_data(gdth_ha_str *ha, struct scsi_cmnd *scp,
                                     char *buffer, u16 count)
 {
     u16 cpcount,i, max_sg = scsi_sg_count(scp);
@@ -2317,7 +2318,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
     }
 }
 
-static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_internal_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     u8 t;
     gdth_inq_data inq;
@@ -2419,7 +2420,8 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     return 0;
 }
 
-static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive)
+static int gdth_fill_cache_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp,
+                               u16 hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2594,7 +2596,7 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u16 hdrive)
     return cmd_index;
 }
 
-static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
+static int gdth_fill_raw_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp, u8 b)
 {
     register gdth_cmd_str *cmdp;
     u16 i;
@@ -2767,7 +2769,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, u8 b)
     return cmd_index;
 }
 
-static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
+static int gdth_special_cmd(gdth_ha_str *ha, struct scsi_cmnd *scp)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
@@ -2958,7 +2960,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     int rval, i;
     u8 IStatus;
     u16 Service;
@@ -3217,7 +3219,7 @@ static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
-                                                              Scsi_Cmnd *scp)
+                                                              struct scsi_cmnd *scp)
 {
     gdth_msg_str *msg;
     gdth_cmd_str *cmdp;
@@ -3708,7 +3710,7 @@ static u8	gdth_timer_running;
 static void gdth_timeout(struct timer_list *unused)
 {
     u32 i;
-    Scsi_Cmnd *nscp;
+    struct scsi_cmnd *nscp;
     gdth_ha_str *ha;
     unsigned long flags;
 
@@ -3724,7 +3726,8 @@ static void gdth_timeout(struct timer_list *unused)
         if (ha->cmd_tab[i].cmnd != UNUSED_CMND)
             ++act_stats;
 
-    for (act_rq=0,nscp=ha->req_first; nscp; nscp=(Scsi_Cmnd*)nscp->SCp.ptr)
+    for (act_rq=0,
+         nscp=ha->req_first; nscp; nscp=(struct scsi_cmnd*)nscp->SCp.ptr)
         ++act_rq;
 
     TRACE2(("gdth_to(): ints %d, ios %d, act_stats %d, act_rq %d\n",
@@ -3909,12 +3912,12 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
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
@@ -4465,7 +4468,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     unsigned long flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index e6e5ccb1e0f3..ee6ffcf388e8 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -162,9 +162,9 @@
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
@@ -867,7 +867,7 @@ typedef struct {
     u16              service;                /* service/firmware ver./.. */
     u32             info;
     u32             info2;                  /* additional info */
-    Scsi_Cmnd           *req_first;             /* top of request queue */
+    struct scsi_cmnd           *req_first;             /* top of request queue */
     struct {
         u8          present;                /* Flag: host drive present? */
         u8          is_logdrv;              /* Flag: log. drive (master)? */
@@ -896,7 +896,7 @@ typedef struct {
         u32         id_list[MAXID];         /* IDs of the phys. devices */
     } raw[MAXBUS];                              /* SCSI channels */
     struct {
-        Scsi_Cmnd       *cmnd;                  /* pending request */
+        struct scsi_cmnd       *cmnd;                  /* pending request */
         u16          service;                /* service */
     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. requests */
     struct gdth_cmndinfo {                      /* per-command private info */
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 20add49cdd32..3a9751a80225 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -626,7 +626,7 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     unsigned long flags;
     int i;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo *cmndinfo;
     u8 b, t;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index daefe8172b04..b64ca977825d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1322,7 +1322,7 @@ static void ibmvfc_map_sg_list(struct scsi_cmnd *scmd, int nseg,
 
 /**
  * ibmvfc_map_sg_data - Maps dma for a scatterlist and initializes decriptor fields
- * @scmd:		Scsi_Cmnd with the scatterlist
+ * @scmd:		struct scsi_cmnd with the scatterlist
  * @evt:		ibmvfc event struct
  * @vfc_cmd:	vfc_cmd that contains the memory descriptor
  * @dev:		device for which to map dma memory
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 17df76f0be3c..44916282ebd4 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -681,7 +681,7 @@ static int map_sg_list(struct scsi_cmnd *cmd, int nseg,
 
 /**
  * map_sg_data: - Maps dma for a scatterlist and initializes decriptor fields
- * @cmd:	Scsi_Cmnd with the scatterlist
+ * @cmd:	struct scsi_cmnd with the scatterlist
  * @srp_cmd:	srp_cmd that contains the memory descriptor
  * @dev:	device for which to map dma memory
  *
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 369ef8f23b24..4fcb9e65be57 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -695,7 +695,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			struct scsi_data_buffer *sdb = scsi_in(task->sc);
 
 			/*
-			 * Setup copy of Data-In into the Scsi_Cmnd
+			 * Setup copy of Data-In into the struct scsi_cmnd
 			 * Scatterlist case:
 			 * We set up the iscsi_segment to point to the next
 			 * scatterlist entry to copy to. As we go along,
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 3b3767e240d8..2865e442c7ff 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -371,7 +371,7 @@ mega_runpendq(adapter_t *adapter)
  * The command queuing entry point for the mid-layer.
  */
 static int
-megaraid_queue_lck(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
+megaraid_queue_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
 	adapter_t	*adapter;
 	scb_t	*scb;
@@ -425,7 +425,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
  * commands.
  */
 static inline scb_t *
-mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
+mega_allocate_scb(adapter_t *adapter, struct scsi_cmnd *cmd)
 {
 	struct list_head *head = &adapter->free_list;
 	scb_t	*scb;
@@ -457,7 +457,7 @@ mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
  * and the channel number.
  */
 static inline int
-mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
+mega_get_ldrv_num(adapter_t *adapter, struct scsi_cmnd *cmd, int channel)
 {
 	int		tgt;
 	int		ldrv_num;
@@ -520,7 +520,7 @@ mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
  * boot settings.
  */
 static scb_t *
-mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
+mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 {
 	mega_ext_passthru	*epthru;
 	mega_passthru	*pthru;
@@ -951,8 +951,8 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
  * prepare a command for the scsi physical devices.
  */
 static mega_passthru *
-mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
-		int channel, int target)
+mega_prepare_passthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
+		      int channel, int target)
 {
 	mega_passthru *pthru;
 
@@ -1015,8 +1015,9 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
  * commands for devices which can take extended CDBs (>10 bytes)
  */
 static mega_ext_passthru *
-mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
-		int channel, int target)
+mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb,
+			 struct scsi_cmnd *cmd,
+			 int channel, int target)
 {
 	mega_ext_passthru	*epthru;
 
@@ -1417,7 +1418,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 {
 	mega_ext_passthru	*epthru = NULL;
 	struct scatterlist	*sgl;
-	Scsi_Cmnd	*cmd = NULL;
+	struct scsi_cmnd	*cmd = NULL;
 	mega_passthru	*pthru = NULL;
 	mbox_t	*mbox = NULL;
 	u8	c;
@@ -1652,14 +1653,14 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 static void
 mega_rundoneq (adapter_t *adapter)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	struct list_head *pos;
 
 	list_for_each(pos, &adapter->completed_list) {
 
 		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
 
-		cmd = list_entry(spos, Scsi_Cmnd, SCp);
+		cmd = list_entry(spos, struct scsi_cmnd, SCp);
 		cmd->scsi_done(cmd);
 	}
 
@@ -1722,7 +1723,7 @@ static int
 mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 {
 	struct scatterlist *sg;
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	int	sgcnt;
 	int	idx;
 
@@ -1869,7 +1870,7 @@ megaraid_info(struct Scsi_Host *host)
  * aborted. All the commands issued to the F/W must complete.
  */
 static int
-megaraid_abort(Scsi_Cmnd *cmd)
+megaraid_abort(struct scsi_cmnd *cmd)
 {
 	adapter_t	*adapter;
 	int		rval;
@@ -1933,7 +1934,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
  * issued to the controller, abort/reset it. Otherwise return failure
  */
 static int
-megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
+megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 {
 	struct list_head	*pos, *next;
 	scb_t			*scb;
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 18e85d9267ff..cce23a086fbe 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -191,7 +191,7 @@ typedef struct {
 	u32	dma_type;
 	u32	dma_direction;
 
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	dma_addr_t	dma_h_bulkdata;
 	dma_addr_t	dma_h_sgdata;
 
@@ -942,7 +942,7 @@ static int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
 
 static int megaraid_queue (struct Scsi_Host *, struct scsi_cmnd *);
-static scb_t * mega_build_cmd(adapter_t *, Scsi_Cmnd *, int *);
+static scb_t * mega_build_cmd(adapter_t *, struct scsi_cmnd *, int *);
 static void __mega_runpendq(adapter_t *);
 static int issue_scb_block(adapter_t *, u_char *);
 
@@ -951,9 +951,9 @@ static irqreturn_t megaraid_isr_iomapped(int, void *);
 
 static void mega_free_scb(adapter_t *, scb_t *);
 
-static int megaraid_abort(Scsi_Cmnd *);
-static int megaraid_reset(Scsi_Cmnd *);
-static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
+static int megaraid_abort(struct scsi_cmnd *);
+static int megaraid_reset(struct scsi_cmnd *);
+static int megaraid_abort_and_reset(adapter_t *, struct scsi_cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
 
@@ -983,9 +983,9 @@ static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
-		Scsi_Cmnd *, int, int);
+		struct scsi_cmnd *, int, int);
 static mega_ext_passthru* mega_prepare_extpassthru(adapter_t *,
-		scb_t *, Scsi_Cmnd *, int, int);
+		scb_t *, struct scsi_cmnd *, int, int);
 static void mega_enum_raid_scsi(adapter_t *);
 static void mega_get_boot_drv(adapter_t *);
 static int mega_support_random_del(adapter_t *);
diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index 58806f432a16..4f1d4bf9c775 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -137,7 +137,7 @@ static void print_commandk (unsigned char *command)
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
index 6dcc4c685d1d..4fd75a3aff66 100644
--- a/drivers/scsi/scsi.h
+++ b/drivers/scsi/scsi.h
@@ -43,7 +43,4 @@ struct scsi_device;
 struct scsi_target;
 struct scatterlist;
 
-/* obsolete typedef junk. */
-#include "scsi_typedefs.h"
-
 #endif /* _SCSI_H */
diff --git a/drivers/scsi/scsi_typedefs.h b/drivers/scsi/scsi_typedefs.h
deleted file mode 100644
index 2ed4c5cb7088..000000000000
--- a/drivers/scsi/scsi_typedefs.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-typedef struct scsi_cmnd Scsi_Cmnd;
-- 
2.16.4
