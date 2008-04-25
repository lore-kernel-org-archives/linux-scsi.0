From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/6] ide: use blk_rq_init() to initialize the request
Date: Sat, 26 Apr 2008 01:23:18 +0900
Message-ID: <1209140607-28654-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1209140607-28654-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1209140607-28654-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org, bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This converts ide to use blk_rq_init to initialize the request.

This is a preparation for large command support, which needs to
initialize the request in a proper way (that is, just doing a memset()
will not work).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |    3 +--
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |    3 +--
 drivers/ide/ide.c          |    4 ++--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 31e5afa..7a3d605 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1601,8 +1601,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 
 void ide_init_drive_cmd (struct request *rq)
 {
-	memset(rq, 0, sizeof(*rq));
-	rq->ref_count = 1;
+	blk_rq_init(NULL, rq);
 }
 
 EXPORT_SYMBOL(ide_init_drive_cmd);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f43fd07..f1227e5 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -899,7 +899,7 @@ static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
 
 static void idetape_init_rq(struct request *rq, u8 cmd)
 {
-	memset(rq, 0, sizeof(*rq));
+	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[0] = cmd;
 }
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 155cc90..997b99c 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -532,8 +532,7 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
 	struct request rq;
 
-	memset(&rq, 0, sizeof(rq));
-	rq.ref_count = 1;
+	blk_rq_init(NULL, &rq);
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq.buffer = buf;
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 917c72d..dfe3ba5 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -689,7 +689,7 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	if (!(drive->dn % 2))
 		ide_acpi_get_timing(hwif);
 
-	memset(&rq, 0, sizeof(rq));
+	blk_rq_init(NULL, &rq);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_SUSPEND;
@@ -727,7 +727,7 @@ static int generic_ide_resume(struct device *dev)
 
 	ide_acpi_exec_tfs(drive);
 
-	memset(&rq, 0, sizeof(rq));
+	blk_rq_init(NULL, &rq);
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_RESUME;
-- 
1.5.4.2

