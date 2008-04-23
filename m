From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC PATCH 4/5] block: Use new blk_init_rq
Date: Wed, 23 Apr 2008 18:09:04 +0300
Message-ID: <480F5110.30202@panasas.com>
References: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <480F4CC2.7070804@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Places that allocate struct request on the stack or in private area
can use blk_init_rq, to zero everything out.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/block/nbd.c        |    2 ++
 drivers/block/paride/pd.c  |    2 +-
 drivers/ide/ide-io.c       |    4 +---
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |    3 +--
 drivers/ide/ide.c          |    4 ++--
 drivers/scsi/scsi_error.c  |    1 +
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 60cc543..dce9ffe 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -534,6 +534,8 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
+	blk_init_rq(NULL, &sreq, 0);
+
 	switch (cmd) {
 	case NBD_DISCONNECT:
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index df819f8..2cd0cc4 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -716,7 +716,7 @@ static int pd_special_command(struct pd_unit *disk,
 	struct request rq;
 	int err = 0;
 
-	memset(&rq, 0, sizeof(rq));
+	blk_init_rq(NULL, &rq, 0);
 	rq.errors = 0;
 	rq.rq_disk = disk->gd;
 	rq.ref_count = 1;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 31e5afa..5661950 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1601,10 +1601,8 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 
 void ide_init_drive_cmd (struct request *rq)
 {
-	memset(rq, 0, sizeof(*rq));
-	rq->ref_count = 1;
+	blk_init_rq(NULL, rq, 0);
 }
-
 EXPORT_SYMBOL(ide_init_drive_cmd);
 
 /**
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f43fd07..be61b86 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -899,7 +899,7 @@ static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 
 static void idetape_init_rq(struct request *rq, u8 cmd)
 {
-	memset(rq, 0, sizeof(*rq));
+	blk_init_rq(NULL, rq, 0);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[0] = cmd;
 }
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 155cc90..56ee99a 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -532,8 +532,7 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
 	struct request rq;
 
-	memset(&rq, 0, sizeof(rq));
-	rq.ref_count = 1;
+	ide_init_drive_cmd(&rq);
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq.buffer = buf;
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 917c72d..b812b7d 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -689,7 +689,7 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	if (!(drive->dn % 2))
 		ide_acpi_get_timing(hwif);
 
-	memset(&rq, 0, sizeof(rq));
+	blk_init_rq(NULL, &rq, 0);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_SUSPEND;
@@ -727,7 +727,7 @@ static int generic_ide_resume(struct device *dev)
 
 	ide_acpi_exec_tfs(drive);
 
-	memset(&rq, 0, sizeof(rq));
+	blk_init_rq(NULL, &rq, 0);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_RESUME;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 221f31e..ff14386 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1771,6 +1771,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	unsigned long flags;
 	int rtn;
 
+	blk_init_rq(dev->request_queue, &req, 0);
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
-- 
1.5.3.3

