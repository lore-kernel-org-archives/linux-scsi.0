From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 02/17] cxlflash: Serialize RRQ access and support offlevel processing
Date: Wed, 12 Apr 2017 14:12:55 -0500
Message-ID: <1492024375-55698-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755362AbdDLTNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:13:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98Qq079704
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:13:13 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29snvj56nn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:13:13 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:13:12 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As further staging to support processing the HRRQ by other means, access
to the HRRQ needs to be serialized by a disabled lock. This will allow
safe access in other non-hardware interrupt contexts. In an effort to
minimize the period where interrupts are disabled, support is added to
queue up commands harvested from the RRQ such that they can be processed
with hardware interrupts enabled. While this doesn't offer any improvement
with processing on a hardware interrupt it will help when IRQ polling is
supported and the command completions can execute on softirq context.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 ++
 drivers/scsi/cxlflash/main.c   | 42 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index d11dcc5..9d56b8c 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -134,6 +134,7 @@ struct afu_cmd {
 	struct afu *parent;
 	struct scsi_cmnd *scp;
 	struct completion cevent;
+	struct list_head queue;
 
 	u8 cmd_tmf:1;
 
@@ -181,6 +182,7 @@ struct afu {
 	struct sisl_ioarcb *hsq_start;
 	struct sisl_ioarcb *hsq_end;
 	struct sisl_ioarcb *hsq_curr;
+	spinlock_t hrrq_slock;
 	u64 *hrrq_start;
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 30c09593c..8c207ba 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1157,10 +1157,13 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 /**
  * process_hrrq() - process the read-response queue
  * @afu:	AFU associated with the host.
+ * @doneq:	Queue of commands harvested from the RRQ.
+ *
+ * This routine must be called holding the disabled RRQ spin lock.
  *
  * Return: The number of entries processed.
  */
-static int process_hrrq(struct afu *afu)
+static int process_hrrq(struct afu *afu, struct list_head *doneq)
 {
 	struct afu_cmd *cmd;
 	struct sisl_ioasa *ioasa;
@@ -1189,7 +1192,7 @@ static int process_hrrq(struct afu *afu)
 			cmd = container_of(ioarcb, struct afu_cmd, rcb);
 		}
 
-		cmd_complete(cmd);
+		list_add_tail(&cmd->queue, doneq);
 
 		/* Advance to next entry or wrap and flip the toggle bit */
 		if (hrrq_curr < hrrq_end)
@@ -1210,17 +1213,43 @@ static int process_hrrq(struct afu *afu)
 }
 
 /**
+ * process_cmd_doneq() - process a queue of harvested RRQ commands
+ * @doneq:	Queue of completed commands.
+ *
+ * Note that upon return the queue can no longer be trusted.
+ */
+static void process_cmd_doneq(struct list_head *doneq)
+{
+	struct afu_cmd *cmd, *tmp;
+
+	WARN_ON(list_empty(doneq));
+
+	list_for_each_entry_safe(cmd, tmp, doneq, queue)
+		cmd_complete(cmd);
+}
+
+/**
  * cxlflash_rrq_irq() - interrupt handler for read-response queue (normal path)
  * @irq:	Interrupt number.
  * @data:	Private data provided at interrupt registration, the AFU.
  *
- * Return: Always return IRQ_HANDLED.
+ * Return: IRQ_HANDLED or IRQ_NONE when no ready entries found.
  */
 static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
+	unsigned long hrrq_flags;
+	LIST_HEAD(doneq);
+	int num_entries = 0;
 
-	process_hrrq(afu);
+	spin_lock_irqsave(&afu->hrrq_slock, hrrq_flags);
+	num_entries = process_hrrq(afu, &doneq);
+	spin_unlock_irqrestore(&afu->hrrq_slock, hrrq_flags);
+
+	if (num_entries == 0)
+		return IRQ_NONE;
+
+	process_cmd_doneq(&doneq);
 	return IRQ_HANDLED;
 }
 
@@ -1540,14 +1569,13 @@ static int start_afu(struct cxlflash_cfg *cfg)
 
 	init_pcr(cfg);
 
-	/* After an AFU reset, RRQ entries are stale, clear them */
+	/* Initialize RRQ */
 	memset(&afu->rrq_entry, 0, sizeof(afu->rrq_entry));
-
-	/* Initialize RRQ pointers */
 	afu->hrrq_start = &afu->rrq_entry[0];
 	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
 	afu->hrrq_curr = afu->hrrq_start;
 	afu->toggle = 1;
+	spin_lock_init(&afu->hrrq_slock);
 
 	/* Initialize SQ */
 	if (afu_is_sq_cmd_mode(afu)) {
-- 
2.1.0
