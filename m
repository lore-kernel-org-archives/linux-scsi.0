From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 01/17] cxlflash: Combine the send queue locks
Date: Wed, 21 Jun 2017 21:13:32 -0500
Message-ID: <1498097612-8717-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38701 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751140AbdFVCNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:13:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M29qB4138657
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:13:45 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7v80pfj7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:13:44 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:13:44 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Currently there are separate spin locks for the two supported I/O queueing
models. This makes it difficult to serialize with paths outside the enqueue
path.

As a design simplification and to support serialization with enqueue
operations, move to only a single lock that is used for enqueueing
regardless of the queueing model.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 3 +--
 drivers/scsi/cxlflash/main.c   | 9 +++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 256af81..6fc32cfc 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -193,7 +193,7 @@ struct hwq {
 	u32 index;		/* Index of this hwq */
 
 	atomic_t hsq_credits;
-	spinlock_t hsq_slock;
+	spinlock_t hsq_slock;	/* Hardware send queue lock */
 	struct sisl_ioarcb *hsq_start;
 	struct sisl_ioarcb *hsq_end;
 	struct sisl_ioarcb *hsq_curr;
@@ -204,7 +204,6 @@ struct hwq {
 	bool toggle;
 
 	s64 room;
-	spinlock_t rrin_slock; /* Lock to rrin queuing and cmd_room updates */
 
 	struct irq_poll irqpoll;
 } __aligned(cache_line_size());
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index a7d57c3..64ea597ca 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -261,7 +261,7 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 	 * To avoid the performance penalty of MMIO, spread the update of
 	 * 'room' over multiple commands.
 	 */
-	spin_lock_irqsave(&hwq->rrin_slock, lock_flags);
+	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
 	if (--hwq->room < 0) {
 		room = readq_be(&hwq->host_map->cmd_room);
 		if (room <= 0) {
@@ -277,7 +277,7 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 
 	writeq_be((u64)&cmd->rcb, &hwq->host_map->ioarrin);
 out:
-	spin_unlock_irqrestore(&hwq->rrin_slock, lock_flags);
+	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
 	dev_dbg(dev, "%s: cmd=%p len=%u ea=%016llx rc=%d\n", __func__,
 		cmd, cmd->rcb.data_len, cmd->rcb.data_ea, rc);
 	return rc;
@@ -1722,7 +1722,10 @@ static int start_afu(struct cxlflash_cfg *cfg)
 		hwq->hrrq_end = &hwq->rrq_entry[NUM_RRQ_ENTRY - 1];
 		hwq->hrrq_curr = hwq->hrrq_start;
 		hwq->toggle = 1;
+
+		/* Initialize spin locks */
 		spin_lock_init(&hwq->hrrq_slock);
+		spin_lock_init(&hwq->hsq_slock);
 
 		/* Initialize SQ */
 		if (afu_is_sq_cmd_mode(afu)) {
@@ -1731,7 +1734,6 @@ static int start_afu(struct cxlflash_cfg *cfg)
 			hwq->hsq_end = &hwq->sq[NUM_SQ_ENTRY - 1];
 			hwq->hsq_curr = hwq->hsq_start;
 
-			spin_lock_init(&hwq->hsq_slock);
 			atomic_set(&hwq->hsq_credits, NUM_SQ_ENTRY - 1);
 		}
 
@@ -1984,7 +1986,6 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	for (i = 0; i < afu->num_hwqs; i++) {
 		hwq = get_hwq(afu, i);
 
-		spin_lock_init(&hwq->rrin_slock);
 		hwq->room = readq_be(&hwq->host_map->cmd_room);
 	}
 
-- 
2.1.0
