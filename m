From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 33/37] isci: Remove obviated host callback list.
Date: Thu, 22 Mar 2012 17:30:54 -0700
Message-ID: <20120323003054.18065.2073.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAP0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:15:26 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Since the callbacks to libsas now occur under scic_lock, there is no
longer any reason to save the completed requests in a separate list
for completion to libsas.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c    |   78 ++++++++++++++-----------------------------
 drivers/scsi/isci/host.h    |    2 +
 drivers/scsi/isci/init.c    |    1 -
 drivers/scsi/isci/request.c |   14 ++------
 drivers/scsi/isci/request.h |    2 -
 5 files changed, 31 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7061c98..f26ff0f 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1066,6 +1066,32 @@ static void sci_controller_completion_handler(struct isci_host *ihost)
 	writel(0, &ihost->smu_registers->interrupt_mask);
 }
 
+void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task)
+{
+	task->lldd_task = NULL;
+	if (!test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags) &&
+	    !(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+		if (test_bit(IREQ_COMPLETE_IN_TARGET, &ireq->flags)) {
+			/* Normal notification (task_done) */
+			dev_dbg(&ihost->pdev->dev,
+				"%s: Normal - ireq/task = %p/%p\n",
+				__func__, ireq, task);
+
+			task->task_done(task);
+		} else {
+			dev_dbg(&ihost->pdev->dev,
+				"%s: Error - ireq/task = %p/%p\n",
+				__func__, ireq, task);
+
+			sas_task_abort(task);
+		}
+	}
+	if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
+		wake_up_all(&ihost->eventq);
+
+	if (!test_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags))
+		isci_free_tag(ihost, ireq->io_tag);
+}
 /**
  * isci_host_completion_routine() - This function is the delayed service
  *    routine that calls the sci core library's completion handler. It's
@@ -1077,62 +1103,10 @@ static void sci_controller_completion_handler(struct isci_host *ihost)
 void isci_host_completion_routine(unsigned long data)
 {
 	struct isci_host *ihost = (struct isci_host *)data;
-	struct list_head    completed_request_list;
-	struct list_head    *current_position;
-	struct list_head    *next_position;
-	struct isci_request *request;
-	struct sas_task     *task;
 	u16 active;
 
-	INIT_LIST_HEAD(&completed_request_list);
-
 	spin_lock_irq(&ihost->scic_lock);
-
 	sci_controller_completion_handler(ihost);
-
-	/* Take the lists of completed I/Os from the host. */
-	list_splice_init(&ihost->requests_to_complete,
-			 &completed_request_list);
-
-	/* Process any completions in the list. */
-	list_for_each_safe(current_position, next_position,
-			   &completed_request_list) {
-
-		request = list_entry(current_position, struct isci_request,
-				     completed_node);
-		task = isci_request_access_task(request);
-
-		/* Return the task to libsas */
-		if (task != NULL) {
-
-			task->lldd_task = NULL;
-			if (!test_bit(IREQ_ABORT_PATH_ACTIVE, &request->flags) &&
-			    !(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-				if (test_bit(IREQ_COMPLETE_IN_TARGET,
-					     &request->flags)) {
-
-					/* Normal notification (task_done) */
-					dev_dbg(&ihost->pdev->dev, "%s: Normal"
-						" - request/task = %p/%p\n",
-						__func__, request, task);
-
-					task->task_done(task);
-				} else {
-					dev_warn(&ihost->pdev->dev,
-						 "%s: Error - request/task"
-						 " = %p/%p\n",
-						 __func__, request, task);
-
-					sas_task_abort(task);
-				}
-			}
-		}
-		if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &request->flags))
-			wake_up_all(&ihost->eventq);
-
-		if (!test_bit(IREQ_NO_AUTO_FREE_TAG, &request->flags))
-			isci_free_tag(ihost, request->io_tag);
-	}
 	spin_unlock_irq(&ihost->scic_lock);
 
 	/* the coalesence timeout doubles at each encoding step, so
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index f8f2c9c..81d96f3 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -202,7 +202,6 @@ struct isci_host {
 	wait_queue_head_t eventq;
 	struct Scsi_Host *shost;
 	struct tasklet_struct completion_tasklet;
-	struct list_head requests_to_complete;
 	spinlock_t scic_lock;
 	struct isci_request *reqs[SCI_MAX_IO_REQUESTS];
 	struct isci_remote_device devices[SCI_MAX_REMOTE_DEVICES];
@@ -466,6 +465,7 @@ void isci_host_scan_start(struct Scsi_Host *);
 u16 isci_alloc_tag(struct isci_host *ihost);
 enum sci_status isci_free_tag(struct isci_host *ihost, u16 io_tag);
 void isci_tci_free(struct isci_host *ihost, u16 tci);
+void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task);
 
 int isci_host_init(struct isci_host *);
 void isci_host_completion_routine(unsigned long data);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 2a781c2..5ae27fb 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -559,7 +559,6 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 		return NULL;
 	}
 
-	INIT_LIST_HEAD(&ihost->requests_to_complete);
 	for (i = 0; i < SCI_MAX_PORTS; i++) {
 		struct isci_port *iport = &ihost->ports[i];
 
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 6584ef0..d5c80ad 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2748,13 +2748,9 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 	enum exec_status status = SAS_ABORTED_TASK;
 
 	dev_dbg(&ihost->pdev->dev,
-		"%s: request = %p, task = %p,\n"
+		"%s: request = %p, task = %p, "
 		"task->data_dir = %d completion_status = 0x%x\n",
-		__func__,
-		request,
-		task,
-		task->data_dir,
-		completion_status);
+		__func__, request, task, task->data_dir, completion_status);
 
 	/* The request is done from an SCU HW perspective. */
 
@@ -2955,9 +2951,6 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, task_flags);
 
-	/* Add to the completed list. */
-	list_add(&request->completed_node, &ihost->requests_to_complete);
-
 	/* complete the io request to the core. */
 	sci_controller_complete_io(ihost, request->target_device, request);
 
@@ -2966,6 +2959,8 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 	 * task to recognize the already completed case.
 	 */
 	set_bit(IREQ_TERMINATED, &request->flags);
+
+	ireq_done(ihost, request, task);
 }
 
 static void sci_request_started_state_enter(struct sci_base_state_machine *sm)
@@ -3416,7 +3411,6 @@ static struct isci_request *isci_request_from_tag(struct isci_host *ihost, u16 t
 	ireq->io_request_completion = NULL;
 	ireq->flags = 0;
 	ireq->num_sg_entries = 0;
-	INIT_LIST_HEAD(&ireq->completed_node);
 
 	return ireq;
 }
diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index 1a65157..aff9531 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -95,8 +95,6 @@ struct isci_request {
 		struct isci_tmf *tmf_task_ptr;  /* When ttype==tmf_task */
 	} ttype_ptr;
 	struct isci_host *isci_host;
-	/* For use in the requests_to_{complete|abort} lists: */
-	struct list_head completed_node;
 	dma_addr_t request_daddr;
 	dma_addr_t zero_scatter_daddr;
 	unsigned int num_sg_entries;

