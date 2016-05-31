From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v2 2/2] Documentation/scsi: update scsi_eh.txt about ->host_failed
Date: Tue, 31 May 2016 16:38:18 +0800
Message-ID: <1464683898-9877-2-git-send-email-fangwei1@huawei.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Update the new concurrency rules of ->host_failed.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 Documentation/scsi/scsi_eh.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 8638f61..e6d0de2 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -252,7 +252,7 @@ scmd->allowed.
 	- set scmd->eh_eflags
 	- add scmd to shost->eh_cmd_q
 	- set SHOST_RECOVERY
-	- shost->host_failed++
+	- atomic_inc(&shost->host_failed)
     LOCKING: shost->host_lock
 
  2. EH starts
@@ -263,7 +263,7 @@ scmd->allowed.
 
  3. scmd recovered
     ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
-	- shost->host_failed--
+	- atomic_dec(&shost->host_failed)
 	- clear scmd->eh_eflags
 	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
-- 
1.7.1

