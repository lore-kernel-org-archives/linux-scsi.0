From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 03/20] scsi/aha152x: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:03 -0300
Message-ID: <1257711423.4759.109.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [190.108.161.231] ([190.108.161.231]:40539 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755454AbZKHU1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Nov 2009 15:27:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fischer@norbit.de

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

--- 
drivers/scsi/aha152x.c |   68 ++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 1e5478a..98b07c6 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -461,16 +461,16 @@ enum aha152x_state {
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
@@ -557,7 +557,7 @@ struct aha152x_hostdata {
  *
  */
 struct aha152x_scdata {
-	Scsi_Cmnd *next;	/* next sc in queue */
+	struct scsi_cmnd *next;	/* next sc in queue */
 	struct completion *done;/* semaphore to block on */
 	struct scsi_eh_save ses;
 };
@@ -681,7 +681,7 @@ static void done(struct Scsi_Host *shpnt, int error);
 
 /* diagnostics */
 static void disp_ports(struct Scsi_Host *shpnt);
-static void show_command(Scsi_Cmnd * ptr);
+static void show_command(struct scsi_cmnd * ptr);
 static void show_queues(struct Scsi_Host *shpnt);
 static void disp_enintr(struct Scsi_Host *shpnt);
 
@@ -690,9 +690,9 @@ static void disp_enintr(struct Scsi_Host *shpnt);
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
@@ -704,9 +704,9 @@ static inline void append_SC(Scsi_Cmnd **SC, Scsi_Cmnd *new_SC)
 	}
 }
 
-static inline Scsi_Cmnd *remove_first_SC(Scsi_Cmnd ** SC)
+static inline struct scsi_cmnd *remove_first_SC(struct scsi_cmnd ** SC)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	ptr = *SC;
 	if (ptr) {
@@ -716,9 +716,9 @@ static inline Scsi_Cmnd *remove_first_SC(Scsi_Cmnd ** SC)
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_lun_SC(Scsi_Cmnd ** SC, int target, int lun)
+static inline struct scsi_cmnd *remove_lun_SC(struct scsi_cmnd ** SC, int target, int lun)
 {
-	Scsi_Cmnd *ptr, *prev;
+	struct scsi_cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
 	     ptr && ((ptr->device->id != target) || (ptr->device->lun != lun));
@@ -737,9 +737,9 @@ static inline Scsi_Cmnd *remove_lun_SC(Scsi_Cmnd ** SC, int target, int lun)
 	return ptr;
 }
 
-static inline Scsi_Cmnd *remove_SC(Scsi_Cmnd **SC, Scsi_Cmnd *SCp)
+static inline struct scsi_cmnd *remove_SC(struct scsi_cmnd **SC, struct scsi_cmnd *SCp)
 {
-	Scsi_Cmnd *ptr, *prev;
+	struct scsi_cmnd *ptr, *prev;
 
 	for (ptr = *SC, prev = NULL;
 	     ptr && SCp!=ptr;
@@ -971,8 +971,8 @@ static int setup_expected_interrupts(struct Scsi_Host *shpnt)
 /* 
  *  Queue a command and setup interrupts for a free bus.
  */
-static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
-		int phase, void (*done)(Scsi_Cmnd *))
+static int aha152x_internal_queue(struct scsi_cmnd *SCpnt, struct completion *complete,
+		int phase, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -1055,7 +1055,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  *  queue a command
  *
  */
-static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha152x_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 #if 0
 	if(*SCpnt->cmnd == REQUEST_SENSE) {
@@ -1074,7 +1074,7 @@ static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
  *  
  *
  */
-static void reset_done(Scsi_Cmnd *SCpnt)
+static void reset_done(struct scsi_cmnd *SCpnt)
 {
 #if 0
 	struct Scsi_Host *shpnt = SCpnt->host;
@@ -1091,10 +1091,10 @@ static void reset_done(Scsi_Cmnd *SCpnt)
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
 
 #if defined(AHA152X_DEBUG)
@@ -1140,7 +1140,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
  * Reset a device
  *
  */
-static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
+static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	DECLARE_COMPLETION(done);
@@ -1205,13 +1205,13 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	return ret;
 }
 
-static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
+static void free_hard_reset_SCs(struct Scsi_Host *shpnt, struct scsi_cmnd **SCs)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	ptr=*SCs;
 	while(ptr) {
-		Scsi_Cmnd *next;
+		struct scsi_cmnd *next;
 
 		if(SCDATA(ptr)) {
 			next = SCNEXT(ptr);
@@ -1274,7 +1274,7 @@ static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
  * Reset the bus
  *
  */
-static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
+static int aha152x_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	return aha152x_bus_reset_host(SCpnt->device->host);
 }
@@ -1336,7 +1336,7 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
  * Reset the host (bus and controller)
  * 
  */
-static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
+static int aha152x_host_reset(struct scsi_cmnd *SCpnt)
 {
 	return aha152x_host_reset_host(SCpnt->device->host);
 }
@@ -1566,7 +1566,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 
 			if(!(DONE_SC->SCp.phase & not_issued)) {
 				struct aha152x_scdata *sc;
-				Scsi_Cmnd *ptr = DONE_SC;
+				struct scsi_cmnd *ptr = DONE_SC;
 				DONE_SC=NULL;
 #if 0
 				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
@@ -1593,7 +1593,7 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			int id=DONE_SC->device->id & 0xf;
 			int lun=DONE_SC->device->lun & 0x7;
 #endif
-			Scsi_Cmnd *ptr = DONE_SC;
+			struct scsi_cmnd *ptr = DONE_SC;
 			DONE_SC=NULL;
 
 			/* turn led off, when no commands are in the driver */
@@ -2463,13 +2463,13 @@ static void parerr_run(struct Scsi_Host *shpnt)
  */
 static void rsti_run(struct Scsi_Host *shpnt)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 
 	printk(KERN_NOTICE "aha152x%d: scsi reset in\n", HOSTNO);
 	
 	ptr=DISCONNECTED_SC;
 	while(ptr) {
-		Scsi_Cmnd *next = SCNEXT(ptr);
+		struct scsi_cmnd *next = SCNEXT(ptr);
 
 		if (!ptr->device->soft_reset) {
 			remove_SC(&DISCONNECTED_SC, ptr);
@@ -2903,7 +2903,7 @@ static void disp_enintr(struct Scsi_Host *shpnt)
 /*
  * Show the command data of a command
  */
-static void show_command(Scsi_Cmnd *ptr)
+static void show_command(struct scsi_cmnd *ptr)
 {
 	scmd_printk(KERN_DEBUG, ptr, "%p: cmnd=(", ptr);
 
@@ -2942,7 +2942,7 @@ static void show_command(Scsi_Cmnd *ptr)
  */
 static void show_queues(struct Scsi_Host *shpnt)
 {
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 
 	DO_LOCK(flags);
@@ -2968,7 +2968,7 @@ static void show_queues(struct Scsi_Host *shpnt)
 #undef SPRINTF
 #define SPRINTF(args...) pos += sprintf(pos, ## args)
 
-static int get_command(char *pos, Scsi_Cmnd * ptr)
+static int get_command(char *pos, struct scsi_cmnd * ptr)
 {
 	char *start = pos;
 	int i;
@@ -3318,7 +3318,7 @@ static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start
 {
 	int i;
 	char *pos = buffer;
-	Scsi_Cmnd *ptr;
+	struct scsi_cmnd *ptr;
 	unsigned long flags;
 	int thislength;
 





