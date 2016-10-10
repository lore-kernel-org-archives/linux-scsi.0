From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 04/12] scsi/ncr5380: Simplify register polling limit
Date: Mon, 10 Oct 2016 00:46:52 -0400 (EDT)
Message-ID: <cce234c2ede9046ad1b73b1853120d868694eae5.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When polling a device register under irq lock the polling loop terminates
after a given number of jiffies. Make this timeout independent of the HZ
setting.

All 5380 drivers benefit from this patch, which optimizes the PIO fast
path, because they all use PIO transfers (for phases other than DATA IN
and DATA OUT). Some cards support only PIO transfers (even for DATA
phases). CPU cycles are scarce on some of these systems, so a small
improvement here makes a big difference.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
This patch eliminates a call to jiffies_to_usecs from the fast path.
For g_NCR5380 it also eliminates a mul instruction and an imul instruction.
For ARM drivers like oak, this change eliminates an __aeabi_uidiv call.
---
 drivers/scsi/NCR5380.c | 10 ++++------
 drivers/scsi/NCR5380.h |  5 ++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index db27390..25ee5be 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -200,13 +200,9 @@ static int NCR5380_poll_politely2(struct Scsi_Host *instance,
                                   int reg2, int bit2, int val2, int wait)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long n = hostdata->poll_loops;
 	unsigned long deadline = jiffies + wait;
-	unsigned long n;
 
-	/* Busy-wait for up to 10 ms */
-	n = min(10000U, jiffies_to_usecs(wait));
-	n *= hostdata->accesses_per_ms;
-	n /= 2000;
 	do {
 		if ((NCR5380_read(reg1) & bit1) == val1)
 			return 0;
@@ -482,6 +478,7 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 	unsigned long deadline;
+	unsigned long accesses_per_ms;
 
 	instance->max_lun = 7;
 
@@ -530,7 +527,8 @@ static int NCR5380_init(struct Scsi_Host *instance, int flags)
 		++i;
 		cpu_relax();
 	} while (time_is_after_jiffies(deadline));
-	hostdata->accesses_per_ms = i / 256;
+	accesses_per_ms = i / 256;
+	hostdata->poll_loops = NCR5380_REG_POLL_TIME * accesses_per_ms / 2;
 
 	return 0;
 }
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 965d923..cbb29d6 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -239,7 +239,7 @@ struct NCR5380_hostdata {
 	                                   * transfer to handle chip overruns */
 	struct work_struct main_task;
 	struct workqueue_struct *work_q;
-	unsigned long accesses_per_ms;	/* chip register accesses per ms */
+	unsigned long poll_loops;		/* register polling limit */
 };
 
 #ifdef __KERNEL__
@@ -252,6 +252,9 @@ struct NCR5380_cmd {
 
 #define NCR5380_PIO_CHUNK_SIZE		256
 
+/* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
+#define NCR5380_REG_POLL_TIME		10
+
 static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr)
 {
 	return ((struct scsi_cmnd *)ncmd_ptr) - 1;
-- 
2.7.3
