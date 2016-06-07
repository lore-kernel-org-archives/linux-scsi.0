From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v4 1/2] scsi: fix race between simultaneous decrements of ->host_failed
Date: Tue, 7 Jun 2016 14:53:56 +0800
Message-ID: <1465282437-10653-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

sas_ata_strategy_handler() adds the works of the ata error handler
to system_unbound_wq. This workqueue asynchronously runs work items,
so the ata error handler will be performed concurrently on different
CPUs. In this case, ->host_failed will be decreased simultaneously in
scsi_eh_finish_cmd() on different CPUs, and become abnormal.

It will lead to permanently inequal between ->host_failed and
 ->host_busy, and scsi error handler thread won't become running.
IO errors after that won't be handled forever.

Since all scmds must have been handled in the strategy handle, just
remove the decrement in scsi_eh_finish_cmd() and zero ->host_busy
after the strategy handle to fix this race.

This fixes the problem introduced in
commit 50824d6c5657 ("[SCSI] libsas: async ata-eh").

Reviewed-by: James Bottomley <jejb@linux.vnet.ibm.com>
Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
Changes v1->v2:
- update Documentation/scsi/scsi_eh.txt about ->host_failed
Changes v2->v3:
- don't use atomic type, just zero ->host_failed after the strategy handle
Changes v3->v4:
- add new concurrency rules of ->host_failed in scsi_eh.txt

 drivers/ata/libata-eh.c   |    2 +-
 drivers/scsi/scsi_error.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 961acc7..91a9e6a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -606,7 +606,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	ata_scsi_port_error_handler(host, ap);
 
 	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
+	WARN_ON(!list_empty(&eh_work_q));
 
 	DPRINTK("EXIT\n");
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 984ddcb..1b9c049 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1127,7 +1127,6 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
  */
 void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
-	scmd->device->host->host_failed--;
 	scmd->eh_eflags = 0;
 	list_move_tail(&scmd->eh_entry, done_q);
 }
@@ -2226,6 +2225,9 @@ int scsi_error_handler(void *data)
 		else
 			scsi_unjam_host(shost);
 
+		/* All scmds have been handled */
+		shost->host_failed = 0;
+
 		/*
 		 * Note - if the above fails completely, the action is to take
 		 * individual devices offline and flush the queue of any
-- 
1.7.1

