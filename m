From: malahal@us.ibm.com
Subject: [PATCH 2/2] aic94xx SCSI timeout fix: SMP retry fix.
Date: Wed, 4 Oct 2006 17:34:03 -0700
Message-ID: <20061005003403.GB21898@us.ibm.com>
References: <20061005002837.GA21898@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:27024 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751266AbWJEAeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2006 20:34:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k950Y5bC029314
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:34:05 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k950Y5O4276750
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:34:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k950Y5ov005933
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:34:05 -0400
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k950Y4rm005913
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 20:34:05 -0400
Content-Disposition: inline
In-Reply-To: <20061005002837.GA21898@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Updating DDB0 inside aic94xx driver itself caused SMP command timeout. I
hit this SMP timeout problem twice but I am not able to reproduce it since
then. Here is a fix that retries an SMP command.

igned-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 42e5e02e2d2d drivers/scsi/libsas/sas_expander.c
--- a/drivers/scsi/libsas/sas_expander.c	Wed Oct 04 10:04:48 2006 -0700
+++ b/drivers/scsi/libsas/sas_expander.c	Wed Oct 04 13:43:34 2006 -0700
@@ -71,55 +71,65 @@ static int smp_execute_task(struct domai
 static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			    void *resp, int resp_size)
 {
-	int res;
-	struct sas_task *task = sas_alloc_task(GFP_KERNEL);
+	int res, retry;
+	struct sas_task *task = NULL;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 
-	if (!task)
-		return -ENOMEM;
-
-	task->dev = dev;
-	task->task_proto = dev->tproto;
-	sg_init_one(&task->smp_task.smp_req, req, req_size);
-	sg_init_one(&task->smp_task.smp_resp, resp, resp_size);
-
-	task->task_done = smp_task_done;
-
-	task->timer.data = (unsigned long) task;
-	task->timer.function = smp_task_timedout;
-	task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
-	add_timer(&task->timer);
-
-	res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
-
-	if (res) {
-		del_timer(&task->timer);
-		SAS_DPRINTK("executing SMP task failed:%d\n", res);
-		goto ex_err;
-	}
-
-	wait_for_completion(&task->completion);
-	res = -ETASK;
-	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-		SAS_DPRINTK("smp task timed out or aborted\n");
-		i->dft->lldd_abort_task(task);
-		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-			SAS_DPRINTK("SMP task aborted and not done\n");
+	for (retry = 0; retry < 3; retry++) {
+		task = sas_alloc_task(GFP_KERNEL);
+		if (!task)
+			return -ENOMEM;
+
+		task->dev = dev;
+		task->task_proto = dev->tproto;
+		sg_init_one(&task->smp_task.smp_req, req, req_size);
+		sg_init_one(&task->smp_task.smp_resp, resp, resp_size);
+
+		task->task_done = smp_task_done;
+
+		task->timer.data = (unsigned long) task;
+		task->timer.function = smp_task_timedout;
+		task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
+		add_timer(&task->timer);
+
+		res = i->dft->lldd_execute_task(task, 1, GFP_KERNEL);
+
+		if (res) {
+			del_timer(&task->timer);
+			SAS_DPRINTK("executing SMP task failed:%d\n", res);
 			goto ex_err;
 		}
-	}
-	if (task->task_status.resp == SAS_TASK_COMPLETE &&
-	    task->task_status.stat == SAM_GOOD)
-		res = 0;
-	else
-		SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
-			    "status 0x%x\n", __FUNCTION__,
-			    SAS_ADDR(dev->sas_addr),
-			    task->task_status.resp,
-			    task->task_status.stat);
+
+		wait_for_completion(&task->completion);
+		res = -ETASK;
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+			SAS_DPRINTK("smp task timed out or aborted\n");
+			i->dft->lldd_abort_task(task);
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				SAS_DPRINTK("SMP task aborted and not done\n");
+				goto ex_err;
+			}
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAM_GOOD) {
+			res = 0;
+			break;
+		} else {
+			SAS_DPRINTK("%s: task to dev %016llx response: 0x%x "
+				    "status 0x%x\n", __FUNCTION__,
+				    SAS_ADDR(dev->sas_addr),
+				    task->task_status.resp,
+				    task->task_status.stat);
+			sas_free_task(task);
+			task = NULL;
+		}
+	}
 ex_err:
-	sas_free_task(task);
+	BUG_ON(retry == 3 && task != NULL);
+	if (task != NULL) {
+		sas_free_task(task);
+	}
 	return res;
 }
 
