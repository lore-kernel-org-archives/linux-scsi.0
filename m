From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v4 2/2] Documentation/scsi: update scsi_eh.txt about ->host_failed
Date: Tue, 7 Jun 2016 14:53:57 +0800
Message-ID: <1465282437-10653-2-git-send-email-fangwei1@huawei.com>
References: <1465282437-10653-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1465282437-10653-1-git-send-email-fangwei1@huawei.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Update the new concurrency rules of ->host_failed.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 Documentation/scsi/scsi_eh.txt |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 8638f61..37eca00 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -263,19 +263,23 @@ scmd->allowed.
 
  3. scmd recovered
     ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
-	- shost->host_failed--
 	- clear scmd->eh_eflags
 	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
     LOCKING: none
+    CONCURRENCY: at most one thread per separate eh_work_q to
+		 keep queue manipulation lockless
 
  4. EH completes
     ACTION: scsi_eh_flush_done_q() retries scmds or notifies upper
-	    layer of failure.
+	    layer of failure. May be called concurrently but must have
+	    a no more than one thread per separate eh_work_q to
+	    manipulate the queue locklessly
 	- scmd is removed from eh_done_q and scmd->eh_entry is cleared
 	- if retry is necessary, scmd is requeued using
           scsi_queue_insert()
 	- otherwise, scsi_finish_command() is invoked for scmd
+	- zero shost->host_failed
     LOCKING: queue or finish function performs appropriate locking
 
 
-- 
1.7.1

