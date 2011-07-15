From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 15/16] SCSI: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:39 -0400
Message-ID: <1310710839.3184.66.camel@offbook>
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

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/dtc.h         |    4 ++--
 drivers/scsi/fd_mcs.c      |   10 +++++-----
 drivers/scsi/nsp32_debug.c |    2 +-
 drivers/scsi/pas16.h       |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
index cdc6212..1fbddca 100644
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -32,12 +32,12 @@
 #define DTCDEBUG_INIT	0x1
 #define DTCDEBUG_TRANSFER 0x2
 
-static int dtc_abort(Scsi_Cmnd *);
+static int dtc_abort(struct scsi_cmnd *);
 static int dtc_biosparam(struct scsi_device *, struct block_device *,
 		         sector_t, int*);
 static int dtc_detect(struct scsi_host_template *);
 static int dtc_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int dtc_bus_reset(Scsi_Cmnd *);
+static int dtc_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index a2c6135..b598665 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -185,7 +185,7 @@ struct fd_hostdata {
 	int _bios_major;
 	int _bios_minor;
 	volatile int _in_command;
-	Scsi_Cmnd *_current_SC;
+	struct scsi_cmnd *_current_SC;
 	enum chip_type _chip;
 	int _adapter_mask;
 	int _fifo_count;	/* Number of 512 byte blocks before INTR */
@@ -1072,7 +1072,7 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
 	return 0;
 }
 
-static int fd_mcs_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int fd_mcs_queue_lck(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1125,7 +1125,7 @@ static int fd_mcs_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 static DEF_SCSI_QCMD(fd_mcs_queue)
 
 #if DEBUG_ABORT || DEBUG_RESET
-static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
+static void fd_mcs_print_info(struct scsi_cmnd * SCpnt)
 {
 	unsigned int imr;
 	unsigned int irr;
@@ -1196,7 +1196,7 @@ static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 }
 #endif
 
-static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
+static int fd_mcs_abort(struct scsi_cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1232,7 +1232,7 @@ static int fd_mcs_abort(Scsi_Cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
+static int fd_mcs_bus_reset(struct scsi_cmnd * SCpnt) {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 
diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index 58806f4..4f1d4bf 100644
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
diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index a04281c..6a61c62 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -114,12 +114,12 @@
 

 #ifndef ASM
-static int pas16_abort(Scsi_Cmnd *);
+static int pas16_abort(struct scsi_cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
 static int pas16_detect(struct scsi_host_template *);
 static int pas16_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int pas16_bus_reset(Scsi_Cmnd *);
+static int pas16_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
-- 
1.7.4.1
