From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 5/5] aic94xx: fix TMF ascb handling to prevent sequencer
	panic
Date: Sat, 23 Feb 2008 23:44:19 -0600
Message-ID: <1203831859.3139.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40178 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYBXFoZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:44:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id A5E7781E9
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:44:22 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6NEnDjyLLAIk for <linux-scsi@vger.kernel.org>;
	Sat, 23 Feb 2008 23:44:21 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id BAEE18112
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:44:20 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a particularly nasty bug.  The problem is that if any internal
ascb times out, currently we free it even though it's pending at the
sequencer.  This results in the sequencer getting terminally confused
and the error message:

BUG:sequencer:dl:no ascb

Being returned when it comes back.  The way to fix this is to manage
freeing the ascb from the tasklet completion routine, so that we only
free it when the sequencer actually returns it.  The code is also
altered to use on stack completions and transfer variables.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/aic94xx/aic94xx_hwi.h  |    3 +-
 drivers/scsi/aic94xx/aic94xx_task.c |    4 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |  246 +++++++++++++++++++----------------
 3 files changed, 139 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 150f670..abc7575 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -140,7 +140,7 @@ struct asd_ascb {
 
 	/* internally generated command */
 	struct timer_list timer;
-	struct completion completion;
+	struct completion *completion;
 	u8        tag_valid:1;
 	__be16    tag;		  /* error recovery only */
 
@@ -294,7 +294,6 @@ static inline void asd_init_ascb(struct asd_ha_struct *asd_ha,
 	ascb->timer.function = NULL;
 	init_timer(&ascb->timer);
 	ascb->tc_index = -1;
-	init_completion(&ascb->completion);
 }
 
 /* Must be called with the tc_index_lock held!
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 965d4bb..008df9a 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -343,11 +343,13 @@ Again:
 	task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	if (unlikely((task->task_state_flags & SAS_TASK_STATE_ABORTED))) {
+		struct completion *completion = ascb->completion;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		ASD_DPRINTK("task 0x%p done with opcode 0x%x resp 0x%x "
 			    "stat 0x%x but aborted by upper layer!\n",
 			    task, opcode, ts->resp, ts->stat);
-		complete(&ascb->completion);
+		if (completion)
+			complete(completion);
 	} else {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		task->lldd_task = NULL;
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index d684c74..b9ac8f7 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -53,50 +53,64 @@ static int asd_enqueue_internal(struct asd_ascb *ascb,
 	return res;
 }
 
-static inline void asd_timedout_common(unsigned long data)
-{
-	struct asd_ascb *ascb = (void *) data;
-	struct asd_seq_data *seq = &ascb->ha->seq;
-        unsigned long flags;
+/* ---------- CLEAR NEXUS ---------- */
 
-	spin_lock_irqsave(&seq->pend_q_lock, flags);
-        seq->pending--;
-        list_del_init(&ascb->list);
-        spin_unlock_irqrestore(&seq->pend_q_lock, flags);
-}
+struct tasklet_completion_status {
+	int	dl_opcode;
+	int	tmf_state;
+	u8	tag_valid:1;
+	__be16	tag;
+};
+
+#define DECLARE_TCS(tcs) \
+	struct tasklet_completion_status tcs = { \
+		.dl_opcode = 0, \
+		.tmf_state = 0, \
+		.tag_valid = 0, \
+		.tag = 0, \
+	}
 
-/* ---------- CLEAR NEXUS ---------- */
 
 static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
 					     struct done_list_struct *dl)
 {
+	struct tasklet_completion_status *tcs = ascb->uldd_task;
 	ASD_DPRINTK("%s: here\n", __FUNCTION__);
 	if (!del_timer(&ascb->timer)) {
 		ASD_DPRINTK("%s: couldn't delete timer\n", __FUNCTION__);
 		return;
 	}
 	ASD_DPRINTK("%s: opcode: 0x%x\n", __FUNCTION__, dl->opcode);
-	ascb->uldd_task = (void *) (unsigned long) dl->opcode;
-	complete(&ascb->completion);
+	tcs->dl_opcode = dl->opcode;
+	complete(ascb->completion);
+	asd_ascb_free(ascb);
 }
 
 static void asd_clear_nexus_timedout(unsigned long data)
 {
-	struct asd_ascb *ascb = (void *) data;
+	struct asd_ascb *ascb = (void *)data;
+	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("%s: here\n", __FUNCTION__);
-	asd_timedout_common(data);
-	ascb->uldd_task = (void *) TMF_RESP_FUNC_FAILED;
-	complete(&ascb->completion);
+	tcs->dl_opcode = TMF_RESP_FUNC_FAILED;
+	complete(ascb->completion);
 }
 
 #define CLEAR_NEXUS_PRE         \
+	struct asd_ascb *ascb; \
+	struct scb *scb; \
+	int res; \
+	DECLARE_COMPLETION_ONSTACK(completion); \
+	DECLARE_TCS(tcs); \
+		\
 	ASD_DPRINTK("%s: PRE\n", __FUNCTION__); \
         res = 1;                \
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL); \
 	if (!ascb)              \
 		return -ENOMEM; \
                                 \
+	ascb->completion = &completion; \
+	ascb->uldd_task = &tcs; \
 	scb = ascb->scb;        \
 	scb->header.opcode = CLEAR_NEXUS
 
@@ -107,10 +121,11 @@ static void asd_clear_nexus_timedout(unsigned long data)
 	if (res)                \
 		goto out_err;   \
 	ASD_DPRINTK("%s: clear nexus posted, waiting...\n", __FUNCTION__); \
-	wait_for_completion(&ascb->completion); \
-	res = (int) (unsigned long) ascb->uldd_task; \
+	wait_for_completion(&completion); \
+	res = tcs.dl_opcode; \
 	if (res == TC_NO_ERROR) \
 		res = TMF_RESP_FUNC_COMPLETE;   \
+	return res; \
 out_err:                        \
 	asd_ascb_free(ascb);    \
 	return res
@@ -118,9 +133,6 @@ out_err:                        \
 int asd_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 {
 	struct asd_ha_struct *asd_ha = sas_ha->lldd_ha;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_ADAPTER;
@@ -130,9 +142,6 @@ int asd_clear_nexus_ha(struct sas_ha_struct *sas_ha)
 int asd_clear_nexus_port(struct asd_sas_port *port)
 {
 	struct asd_ha_struct *asd_ha = port->ha->lldd_ha;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_PORT;
@@ -150,9 +159,6 @@ static int asd_clear_nexus_I_T(struct domain_device *dev,
 			       enum clear_nexus_phase phase)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_I_T;
@@ -210,9 +216,6 @@ int asd_I_T_nexus_reset(struct domain_device *dev)
 static int asd_clear_nexus_I_T_L(struct domain_device *dev, u8 *lun)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_I_T_L;
@@ -227,9 +230,6 @@ static int asd_clear_nexus_tag(struct sas_task *task)
 {
 	struct asd_ha_struct *asd_ha = task->dev->port->ha->lldd_ha;
 	struct asd_ascb *tascb = task->lldd_task;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_TAG;
@@ -245,9 +245,6 @@ static int asd_clear_nexus_index(struct sas_task *task)
 {
 	struct asd_ha_struct *asd_ha = task->dev->port->ha->lldd_ha;
 	struct asd_ascb *tascb = task->lldd_task;
-	struct asd_ascb *ascb;
-	struct scb *scb;
-	int res;
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_TRANS_CX;
@@ -263,11 +260,11 @@ static int asd_clear_nexus_index(struct sas_task *task)
 static void asd_tmf_timedout(unsigned long data)
 {
 	struct asd_ascb *ascb = (void *) data;
+	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("tmf timed out\n");
-	asd_timedout_common(data);
-	ascb->uldd_task = (void *) TMF_RESP_FUNC_FAILED;
-	complete(&ascb->completion);
+	tcs->tmf_state = TMF_RESP_FUNC_FAILED;
+	complete(ascb->completion);
 }
 
 static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
@@ -319,18 +316,24 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 static void asd_tmf_tasklet_complete(struct asd_ascb *ascb,
 				     struct done_list_struct *dl)
 {
+	struct tasklet_completion_status *tcs;
+
 	if (!del_timer(&ascb->timer))
 		return;
 
+	tcs = ascb->uldd_task;
 	ASD_DPRINTK("tmf tasklet complete\n");
 
-	if (dl->opcode == TC_SSP_RESP)
-		ascb->uldd_task = (void *) (unsigned long)
-			asd_get_tmf_resp_tasklet(ascb, dl);
-	else
-		ascb->uldd_task = (void *) 0xFF00 + (unsigned long) dl->opcode;
+	tcs->dl_opcode = dl->opcode;
 
-	complete(&ascb->completion);
+	if (dl->opcode == TC_SSP_RESP) {
+		tcs->tmf_state = asd_get_tmf_resp_tasklet(ascb, dl);
+		tcs->tag_valid = ascb->tag_valid;
+		tcs->tag = ascb->tag;
+	}
+
+	complete(ascb->completion);
+	asd_ascb_free(ascb);
 }
 
 static inline int asd_clear_nexus(struct sas_task *task)
@@ -338,15 +341,19 @@ static inline int asd_clear_nexus(struct sas_task *task)
 	int res = TMF_RESP_FUNC_FAILED;
 	int leftover;
 	struct asd_ascb *tascb = task->lldd_task;
+	DECLARE_COMPLETION_ONSTACK(completion);
 	unsigned long flags;
 
+	tascb->completion = &completion;
+
 	ASD_DPRINTK("task not done, clearing nexus\n");
 	if (tascb->tag_valid)
 		res = asd_clear_nexus_tag(task);
 	else
 		res = asd_clear_nexus_index(task);
-	leftover = wait_for_completion_timeout(&tascb->completion,
+	leftover = wait_for_completion_timeout(&completion,
 					       AIC94XX_SCB_TIMEOUT);
+	tascb->completion = NULL;
 	ASD_DPRINTK("came back from clear nexus\n");
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (leftover < 1)
@@ -400,6 +407,11 @@ int asd_abort_task(struct sas_task *task)
 	struct asd_ascb *ascb = NULL;
 	struct scb *scb;
 	int leftover;
+	DECLARE_TCS(tcs);
+	DECLARE_COMPLETION_ONSTACK(completion);
+	DECLARE_COMPLETION_ONSTACK(tascb_completion);
+
+	tascb->completion = &tascb_completion;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -413,8 +425,10 @@ int asd_abort_task(struct sas_task *task)
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL);
 	if (!ascb)
 		return -ENOMEM;
-	scb = ascb->scb;
 
+	ascb->uldd_task = &tcs;
+	ascb->completion = &completion;
+	scb = ascb->scb;
 	scb->header.opcode = SCB_ABORT_TASK;
 
 	switch (task->task_proto) {
@@ -456,13 +470,12 @@ int asd_abort_task(struct sas_task *task)
 	res = asd_enqueue_internal(ascb, asd_tmf_tasklet_complete,
 				   asd_tmf_timedout);
 	if (res)
-		goto out;
-	wait_for_completion(&ascb->completion);
+		goto out_free;
+	wait_for_completion(&completion);
 	ASD_DPRINTK("tmf came back\n");
 
-	res = (int) (unsigned long) ascb->uldd_task;
-	tascb->tag = ascb->tag;
-	tascb->tag_valid = ascb->tag_valid;
+	tascb->tag = tcs.tag;
+	tascb->tag_valid = tcs.tag_valid;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -473,63 +486,68 @@ int asd_abort_task(struct sas_task *task)
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	switch (res) {
-	/* The task to be aborted has been sent to the device.
-	 * We got a Response IU for the ABORT TASK TMF. */
-	case TC_NO_ERROR + 0xFF00:
-	case TMF_RESP_FUNC_COMPLETE:
-	case TMF_RESP_FUNC_FAILED:
-		res = asd_clear_nexus(task);
-		break;
-	case TMF_RESP_INVALID_FRAME:
-	case TMF_RESP_OVERLAPPED_TAG:
-	case TMF_RESP_FUNC_ESUPP:
-	case TMF_RESP_NO_LUN:
-		goto out_done; break;
-	}
-	/* In the following we assume that the managing layer
-	 * will _never_ make a mistake, when issuing ABORT TASK.
-	 */
-	switch (res) {
-	default:
-		res = asd_clear_nexus(task);
-		/* fallthrough */
-	case TC_NO_ERROR + 0xFF00:
-	case TMF_RESP_FUNC_COMPLETE:
-		break;
-	/* The task hasn't been sent to the device xor we never got
-	 * a (sane) Response IU for the ABORT TASK TMF.
-	 */
-	case TF_NAK_RECV + 0xFF00:
-		res = TMF_RESP_INVALID_FRAME;
-		break;
-	case TF_TMF_TASK_DONE + 0xFF00:	/* done but not reported yet */
+	if (tcs.dl_opcode == TC_SSP_RESP) {
+		/* The task to be aborted has been sent to the device.
+		 * We got a Response IU for the ABORT TASK TMF. */
+		if (tcs.tmf_state == TMF_RESP_FUNC_COMPLETE)
+			res = asd_clear_nexus(task);
+		else
+			res = tcs.tmf_state;
+	} else if (tcs.dl_opcode == TC_NO_ERROR &&
+		   tcs.tmf_state == TMF_RESP_FUNC_FAILED) {
+		/* timeout */
 		res = TMF_RESP_FUNC_FAILED;
-		leftover = wait_for_completion_timeout(&tascb->completion,
-						       AIC94XX_SCB_TIMEOUT);
-		spin_lock_irqsave(&task->task_state_lock, flags);
-		if (leftover < 1)
+	} else {
+		/* In the following we assume that the managing layer
+		 * will _never_ make a mistake, when issuing ABORT
+		 * TASK.
+		 */
+		switch (tcs.dl_opcode) {
+		default:
+			res = asd_clear_nexus(task);
+			/* fallthrough */
+		case TC_NO_ERROR:
+			break;
+			/* The task hasn't been sent to the device xor
+			 * we never got a (sane) Response IU for the
+			 * ABORT TASK TMF.
+			 */
+		case TF_NAK_RECV:
+			res = TMF_RESP_INVALID_FRAME;
+			break;
+		case TF_TMF_TASK_DONE:	/* done but not reported yet */
 			res = TMF_RESP_FUNC_FAILED;
-		if (task->task_state_flags & SAS_TASK_STATE_DONE)
+			leftover =
+				wait_for_completion_timeout(&tascb_completion,
+							  AIC94XX_SCB_TIMEOUT);
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			if (leftover < 1)
+				res = TMF_RESP_FUNC_FAILED;
+			if (task->task_state_flags & SAS_TASK_STATE_DONE)
+				res = TMF_RESP_FUNC_COMPLETE;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+			break;
+		case TF_TMF_NO_TAG:
+		case TF_TMF_TAG_FREE: /* the tag is in the free list */
+		case TF_TMF_NO_CONN_HANDLE: /* no such device */
 			res = TMF_RESP_FUNC_COMPLETE;
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		goto out_done;
-	case TF_TMF_NO_TAG + 0xFF00:
-	case TF_TMF_TAG_FREE + 0xFF00: /* the tag is in the free list */
-	case TF_TMF_NO_CONN_HANDLE + 0xFF00: /* no such device */
-		res = TMF_RESP_FUNC_COMPLETE;
-		goto out_done;
-	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
-		res = TMF_RESP_FUNC_ESUPP;
-		goto out;
+			break;
+		case TF_TMF_NO_CTX: /* not in seq, or proto != SSP */
+			res = TMF_RESP_FUNC_ESUPP;
+			break;
+		}
 	}
-out_done:
+ out_done:
+	tascb->completion = NULL;
 	if (res == TMF_RESP_FUNC_COMPLETE) {
 		task->lldd_task = NULL;
 		mb();
 		asd_ascb_free(tascb);
 	}
-out:
+	ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
+	return res;
+
+ out_free:
 	asd_ascb_free(ascb);
 	ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
 	return res;
@@ -557,6 +575,8 @@ static int asd_initiate_ssp_tmf(struct domain_device *dev, u8 *lun,
 	struct asd_ascb *ascb;
 	int res = 1;
 	struct scb *scb;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	DECLARE_TCS(tcs);
 
 	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
@@ -564,6 +584,9 @@ static int asd_initiate_ssp_tmf(struct domain_device *dev, u8 *lun,
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL);
 	if (!ascb)
 		return -ENOMEM;
+
+	ascb->completion = &completion;
+	ascb->uldd_task = &tcs;
 	scb = ascb->scb;
 
 	if (tmf == TMF_QUERY_TASK)
@@ -596,31 +619,32 @@ static int asd_initiate_ssp_tmf(struct domain_device *dev, u8 *lun,
 				   asd_tmf_timedout);
 	if (res)
 		goto out_err;
-	wait_for_completion(&ascb->completion);
-	res = (int) (unsigned long) ascb->uldd_task;
+	wait_for_completion(&completion);
 
-	switch (res) {
-	case TC_NO_ERROR + 0xFF00:
+	switch (tcs.dl_opcode) {
+	case TC_NO_ERROR:
 		res = TMF_RESP_FUNC_COMPLETE;
 		break;
-	case TF_NAK_RECV + 0xFF00:
+	case TF_NAK_RECV:
 		res = TMF_RESP_INVALID_FRAME;
 		break;
-	case TF_TMF_TASK_DONE + 0xFF00:
+	case TF_TMF_TASK_DONE:
 		res = TMF_RESP_FUNC_FAILED;
 		break;
-	case TF_TMF_NO_TAG + 0xFF00:
-	case TF_TMF_TAG_FREE + 0xFF00: /* the tag is in the free list */
-	case TF_TMF_NO_CONN_HANDLE + 0xFF00: /* no such device */
+	case TF_TMF_NO_TAG:
+	case TF_TMF_TAG_FREE: /* the tag is in the free list */
+	case TF_TMF_NO_CONN_HANDLE: /* no such device */
 		res = TMF_RESP_FUNC_COMPLETE;
 		break;
-	case TF_TMF_NO_CTX + 0xFF00: /* not in seq, or proto != SSP */
+	case TF_TMF_NO_CTX: /* not in seq, or proto != SSP */
 		res = TMF_RESP_FUNC_ESUPP;
 		break;
 	default:
 		/* Allow TMF response codes to propagate upwards */
+		res = tcs.dl_opcode;
 		break;
 	}
+	return res;
 out_err:
 	asd_ascb_free(ascb);
 	return res;
-- 
1.5.4.1



