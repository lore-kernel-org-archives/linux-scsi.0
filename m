From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Mon, 30 Jul 2012 11:32:26 +1000
Message-ID: <1343611946.21647.23.camel@pasglop>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:51511 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2G3Bcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2012 21:32:45 -0400
In-Reply-To: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian J King <bjking1@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, olaf@aepfle.de

On Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> The driver is named ibmvscsic, at runtime it its name is advertised as
> ibmvscsi. For this reason mkinitrd wont pickup the driver properly.
> Reported by IBM during SLES11 beta testing:
> 
> https://bugzilla.novell.com/show_bug.cgi?id=459933
> LTC50724

So while this would work, I do wonder however whether we could instead
fix it by simplifying the whole thing as follow since iSeries is now
gone and so we don't need split backends anymore:

scsi/ibmvscsi: Remove backend abstraction

Now that the iSeries code is gone the backend abstraction
in this driver is no longer necessary, which allows us to
consolidate the driver in one file.

The side effect is that the module name is now ibmvscsi.ko
which matches the driver hotplug name and fixes auto-load
issues.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
---
 drivers/scsi/ibmvscsi/Makefile    |    6 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c  |  348 +++++++++++++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvscsi.h  |   22 ---
 drivers/scsi/ibmvscsi/rpa_vscsi.c |  368 -------------------------------------
 4 files changed, 330 insertions(+), 414 deletions(-)
 delete mode 100644 drivers/scsi/ibmvscsi/rpa_vscsi.c

diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index ff5b5c5..cb150d1 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,7 +1,3 @@
-obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsic.o
-
-ibmvscsic-y			+= ibmvscsi.o
-ibmvscsic-$(CONFIG_PPC_PSERIES)	+= rpa_vscsi.o 
-
+obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvstgt.o
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3a6c474..d2bd2c0 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -93,13 +93,13 @@ static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
 static int fast_fail = 1;
 static int client_reserve = 1;
+static char partition_name[97] = "UNKNOWN";
+static unsigned int partition_number = -1;
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
 #define IBMVSCSI_VERSION "1.5.9"
 
-static struct ibmvscsi_ops *ibmvscsi_ops;
-
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
 MODULE_LICENSE("GPL");
@@ -118,6 +118,315 @@ MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
 module_param_named(client_reserve, client_reserve, int, S_IRUGO );
 MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
 
+static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
+				struct ibmvscsi_host_data *hostdata);
+
+/* ------------------------------------------------------------
+ * Routines for managing the command/response queue
+ */
+/**
+ * ibmvscsi_handle_event: - Interrupt handler for crq events
+ * @irq:	number of irq to handle, not used
+ * @dev_instance: ibmvscsi_host_data of host that received interrupt
+ *
+ * Disables interrupts and schedules srp_task
+ * Always returns IRQ_HANDLED
+ */
+static irqreturn_t ibmvscsi_handle_event(int irq, void *dev_instance)
+{
+	struct ibmvscsi_host_data *hostdata =
+	    (struct ibmvscsi_host_data *)dev_instance;
+	vio_disable_interrupts(to_vio_dev(hostdata->dev));
+	tasklet_schedule(&hostdata->srp_task);
+	return IRQ_HANDLED;
+}
+
+/**
+ * release_crq_queue: - Deallocates data and unregisters CRQ
+ * @queue:	crq_queue to initialize and register
+ * @host_data:	ibmvscsi_host_data of host
+ *
+ * Frees irq, deallocates a page for messages, unmaps dma, and unregisters
+ * the crq with the hypervisor.
+ */
+static void ibmvscsi_release_crq_queue(struct crq_queue *queue,
+				       struct ibmvscsi_host_data *hostdata,
+				       int max_requests)
+{
+	long rc = 0;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	free_irq(vdev->irq, (void *)hostdata);
+	tasklet_kill(&hostdata->srp_task);
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
+	dma_unmap_single(hostdata->dev,
+			 queue->msg_token,
+			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
+	free_page((unsigned long)queue->msgs);
+}
+
+/**
+ * crq_queue_next_crq: - Returns the next entry in message queue
+ * @queue:	crq_queue to use
+ *
+ * Returns pointer to next entry in queue, or NULL if there are no new 
+ * entried in the CRQ.
+ */
+static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
+{
+	struct viosrp_crq *crq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	crq = &queue->msgs[queue->cur];
+	if (crq->valid & 0x80) {
+		if (++queue->cur == queue->size)
+			queue->cur = 0;
+	} else
+		crq = NULL;
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	return crq;
+}
+
+/**
+ * ibmvscsi_send_crq: - Send a CRQ
+ * @hostdata:	the adapter
+ * @word1:	the first 64 bits of the data
+ * @word2:	the second 64 bits of the data
+ */
+static int ibmvscsi_send_crq(struct ibmvscsi_host_data *hostdata,
+			     u64 word1, u64 word2)
+{
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
+}
+
+/**
+ * ibmvscsi_task: - Process srps asynchronously
+ * @data:	ibmvscsi_host_data of host
+ */
+static void ibmvscsi_task(void *data)
+{
+	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+	struct viosrp_crq *crq;
+	int done = 0;
+
+	while (!done) {
+		/* Pull all the valid messages off the CRQ */
+		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
+			ibmvscsi_handle_crq(crq, hostdata);
+			crq->valid = 0x00;
+		}
+
+		vio_enable_interrupts(vdev);
+		if ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
+			vio_disable_interrupts(vdev);
+			ibmvscsi_handle_crq(crq, hostdata);
+			crq->valid = 0x00;
+		} else {
+			done = 1;
+		}
+	}
+}
+
+static void gather_partition_info(void)
+{
+	struct device_node *rootdn;
+
+	const char *ppartition_name;
+	const unsigned int *p_number_ptr;
+
+	/* Retrieve information about this partition */
+	rootdn = of_find_node_by_path("/");
+	if (!rootdn) {
+		return;
+	}
+
+	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
+	if (ppartition_name)
+		strncpy(partition_name, ppartition_name,
+				sizeof(partition_name));
+	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
+	if (p_number_ptr)
+		partition_number = *p_number_ptr;
+	of_node_put(rootdn);
+}
+
+static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
+{
+	memset(&hostdata->madapter_info, 0x00,
+			sizeof(hostdata->madapter_info));
+
+	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
+	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);
+
+	strncpy(hostdata->madapter_info.partition_name, partition_name,
+			sizeof(hostdata->madapter_info.partition_name));
+
+	hostdata->madapter_info.partition_number = partition_number;
+
+	hostdata->madapter_info.mad_version = 1;
+	hostdata->madapter_info.os_type = 2;
+}
+
+/**
+ * reset_crq_queue: - resets a crq after a failure
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ */
+static int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+				    struct ibmvscsi_host_data *hostdata)
+{
+	int rc = 0;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	/* Close the CRQ */
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
+
+	/* Clean out the queue */
+	memset(queue->msgs, 0x00, PAGE_SIZE);
+	queue->cur = 0;
+
+	set_adapter_info(hostdata);
+
+	/* And re-open it again */
+	rc = plpar_hcall_norets(H_REG_CRQ,
+				vdev->unit_address,
+				queue->msg_token, PAGE_SIZE);
+	if (rc == 2) {
+		/* Adapter is good, but other end is not ready */
+		dev_warn(hostdata->dev, "Partner adapter not ready\n");
+	} else if (rc != 0) {
+		dev_warn(hostdata->dev, "couldn't register crq--rc 0x%x\n", rc);
+	}
+	return rc;
+}
+
+/**
+ * initialize_crq_queue: - Initializes and registers CRQ with hypervisor
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ * Allocates a page for messages, maps it for dma, and registers
+ * the crq with the hypervisor.
+ * Returns zero on success.
+ */
+static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
+				   struct ibmvscsi_host_data *hostdata,
+				   int max_requests)
+{
+	int rc;
+	int retrc;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+
+	if (!queue->msgs)
+		goto malloc_failed;
+	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
+
+	queue->msg_token = dma_map_single(hostdata->dev, queue->msgs,
+					  queue->size * sizeof(*queue->msgs),
+					  DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(hostdata->dev, queue->msg_token))
+		goto map_failed;
+
+	gather_partition_info();
+	set_adapter_info(hostdata);
+
+	retrc = rc = plpar_hcall_norets(H_REG_CRQ,
+				vdev->unit_address,
+				queue->msg_token, PAGE_SIZE);
+	if (rc == H_RESOURCE)
+		/* maybe kexecing and resource is busy. try a reset */
+		rc = ibmvscsi_reset_crq_queue(queue,
+					      hostdata);
+
+	if (rc == 2) {
+		/* Adapter is good, but other end is not ready */
+		dev_warn(hostdata->dev, "Partner adapter not ready\n");
+		retrc = 0;
+	} else if (rc != 0) {
+		dev_warn(hostdata->dev, "Error %d opening adapter\n", rc);
+		goto reg_crq_failed;
+	}
+
+	queue->cur = 0;
+	spin_lock_init(&queue->lock);
+
+	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
+		     (unsigned long)hostdata);
+
+	if (request_irq(vdev->irq,
+			ibmvscsi_handle_event,
+			0, "ibmvscsi", (void *)hostdata) != 0) {
+		dev_err(hostdata->dev, "couldn't register irq 0x%x\n",
+			vdev->irq);
+		goto req_irq_failed;
+	}
+
+	rc = vio_enable_interrupts(vdev);
+	if (rc != 0) {
+		dev_err(hostdata->dev, "Error %d enabling interrupts!!!\n", rc);
+		goto req_irq_failed;
+	}
+
+	return retrc;
+
+      req_irq_failed:
+	tasklet_kill(&hostdata->srp_task);
+	rc = 0;
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
+	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
+      reg_crq_failed:
+	dma_unmap_single(hostdata->dev,
+			 queue->msg_token,
+			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
+      map_failed:
+	free_page((unsigned long)queue->msgs);
+      malloc_failed:
+	return -1;
+}
+
+/**
+ * reenable_crq_queue: - reenables a crq after
+ * @queue:	crq_queue to initialize and register
+ * @hostdata:	ibmvscsi_host_data of host
+ *
+ */
+static int ibmvscsi_reenable_crq_queue(struct crq_queue *queue,
+				       struct ibmvscsi_host_data *hostdata)
+{
+	int rc = 0;
+	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
+
+	/* Re-enable the CRQ */
+	do {
+		if (rc)
+			msleep(100);
+		rc = plpar_hcall_norets(H_ENABLE_CRQ, vdev->unit_address);
+	} while ((rc == H_IN_PROGRESS) || (rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
+
+	if (rc)
+		dev_err(hostdata->dev, "Error %d enabling adapter\n", rc);
+	return rc;
+}
+
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs
  */
@@ -611,7 +920,7 @@ static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 	}
 
 	if ((rc =
-	     ibmvscsi_ops->send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
+	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
 		list_del(&evt_struct->list);
 		del_timer(&evt_struct->timer);
 
@@ -1420,8 +1729,8 @@ static int ibmvscsi_eh_host_reset_handler(struct scsi_cmnd *cmd)
  * @hostdata:	ibmvscsi_host_data of host
  *
 */
-void ibmvscsi_handle_crq(struct viosrp_crq *crq,
-			 struct ibmvscsi_host_data *hostdata)
+static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
+				struct ibmvscsi_host_data *hostdata)
 {
 	long rc;
 	unsigned long flags;
@@ -1433,8 +1742,8 @@ void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 		case 0x01:	/* Initialization message */
 			dev_info(hostdata->dev, "partner initialized\n");
 			/* Send back a response */
-			if ((rc = ibmvscsi_ops->send_crq(hostdata,
-							 0xC002000000000000LL, 0)) == 0) {
+			if ((rc = ibmvscsi_send_crq(hostdata,
+						    0xC002000000000000LL, 0)) == 0) {
 				/* Now login */
 				init_adapter(hostdata);
 			} else {
@@ -1840,17 +2149,17 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 		smp_rmb();
 		hostdata->reset_crq = 0;
 
-		rc = ibmvscsi_ops->reset_crq_queue(&hostdata->queue, hostdata);
+		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
 		if (!rc)
-			rc = ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0);
+			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 		vio_enable_interrupts(to_vio_dev(hostdata->dev));
 	} else if (hostdata->reenable_crq) {
 		smp_rmb();
 		action = "enable";
-		rc = ibmvscsi_ops->reenable_crq_queue(&hostdata->queue, hostdata);
+		rc = ibmvscsi_reenable_crq_queue(&hostdata->queue, hostdata);
 		hostdata->reenable_crq = 0;
 		if (!rc)
-			rc = ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0);
+			rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
 	} else
 		return;
 
@@ -1944,7 +2253,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto init_crq_failed;
 	}
 
-	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_events);
+	rc = ibmvscsi_init_crq_queue(&hostdata->queue, hostdata, max_events);
 	if (rc != 0 && rc != H_RESOURCE) {
 		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
 		goto kill_kthread;
@@ -1974,7 +2283,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	 * to fail if the other end is not acive.  In that case we don't
 	 * want to scan
 	 */
-	if (ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0) == 0
+	if (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0) == 0
 	    || rc == H_RESOURCE) {
 		/*
 		 * Wait around max init_timeout secs for the adapter to finish
@@ -2002,7 +2311,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
       add_host_failed:
 	release_event_pool(&hostdata->pool, hostdata);
       init_pool_failed:
-	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_events);
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata, max_events);
       kill_kthread:
       kthread_stop(hostdata->work_thread);
       init_crq_failed:
@@ -2018,7 +2327,7 @@ static int ibmvscsi_remove(struct vio_dev *vdev)
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
 	unmap_persist_bufs(hostdata);
 	release_event_pool(&hostdata->pool, hostdata);
-	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
+	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
 
 	kthread_stop(hostdata->work_thread);
@@ -2039,7 +2348,10 @@ static int ibmvscsi_remove(struct vio_dev *vdev)
 static int ibmvscsi_resume(struct device *dev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(dev);
-	return ibmvscsi_ops->resume(hostdata);
+	vio_disable_interrupts(to_vio_dev(hostdata->dev));
+	tasklet_schedule(&hostdata->srp_task);
+
+	return 0;
 }
 
 /**
@@ -2076,9 +2388,7 @@ int __init ibmvscsi_module_init(void)
 	driver_template.can_queue = max_requests;
 	max_events = max_requests + 2;
 
-	if (firmware_has_feature(FW_FEATURE_VIO))
-		ibmvscsi_ops = &rpavscsi_ops;
-	else
+	if (!firmware_has_feature(FW_FEATURE_VIO))
 		return -ENODEV;
 
 	ibmvscsi_transport_template =
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
index c503e17..7d64867 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -107,26 +107,4 @@ struct ibmvscsi_host_data {
 	dma_addr_t adapter_info_addr;
 };
 
-/* routines for managing a command/response queue */
-void ibmvscsi_handle_crq(struct viosrp_crq *crq,
-			 struct ibmvscsi_host_data *hostdata);
-
-struct ibmvscsi_ops {
-	int (*init_crq_queue)(struct crq_queue *queue,
-			      struct ibmvscsi_host_data *hostdata,
-			      int max_requests);
-	void (*release_crq_queue)(struct crq_queue *queue,
-				  struct ibmvscsi_host_data *hostdata,
-				  int max_requests);
-	int (*reset_crq_queue)(struct crq_queue *queue,
-			       struct ibmvscsi_host_data *hostdata);
-	int (*reenable_crq_queue)(struct crq_queue *queue,
-				  struct ibmvscsi_host_data *hostdata);
-	int (*send_crq)(struct ibmvscsi_host_data *hostdata,
-		       u64 word1, u64 word2);
-	int (*resume) (struct ibmvscsi_host_data *hostdata);
-};
-
-extern struct ibmvscsi_ops rpavscsi_ops;
-
 #endif				/* IBMVSCSI_H */
diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
deleted file mode 100644
index f48ae01..0000000
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ /dev/null
@@ -1,368 +0,0 @@
-/* ------------------------------------------------------------
- * rpa_vscsi.c
- * (C) Copyright IBM Corporation 1994, 2003
- * Authors: Colin DeVilbiss (devilbis@us.ibm.com)
- *          Santiago Leon (santil@us.ibm.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
- *
- * ------------------------------------------------------------
- * RPA-specific functions of the SCSI host adapter for Virtual I/O devices
- *
- * This driver allows the Linux SCSI peripheral drivers to directly
- * access devices in the hosting partition, either on an iSeries
- * hypervisor system or a converged hypervisor system.
- */
-
-#include <asm/vio.h>
-#include <asm/prom.h>
-#include <asm/iommu.h>
-#include <asm/hvcall.h>
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
-#include <linux/gfp.h>
-#include <linux/interrupt.h>
-#include "ibmvscsi.h"
-
-static char partition_name[97] = "UNKNOWN";
-static unsigned int partition_number = -1;
-
-/* ------------------------------------------------------------
- * Routines for managing the command/response queue
- */
-/**
- * rpavscsi_handle_event: - Interrupt handler for crq events
- * @irq:	number of irq to handle, not used
- * @dev_instance: ibmvscsi_host_data of host that received interrupt
- *
- * Disables interrupts and schedules srp_task
- * Always returns IRQ_HANDLED
- */
-static irqreturn_t rpavscsi_handle_event(int irq, void *dev_instance)
-{
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)dev_instance;
-	vio_disable_interrupts(to_vio_dev(hostdata->dev));
-	tasklet_schedule(&hostdata->srp_task);
-	return IRQ_HANDLED;
-}
-
-/**
- * release_crq_queue: - Deallocates data and unregisters CRQ
- * @queue:	crq_queue to initialize and register
- * @host_data:	ibmvscsi_host_data of host
- *
- * Frees irq, deallocates a page for messages, unmaps dma, and unregisters
- * the crq with the hypervisor.
- */
-static void rpavscsi_release_crq_queue(struct crq_queue *queue,
-				       struct ibmvscsi_host_data *hostdata,
-				       int max_requests)
-{
-	long rc = 0;
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-	free_irq(vdev->irq, (void *)hostdata);
-	tasklet_kill(&hostdata->srp_task);
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
-	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
-}
-
-/**
- * crq_queue_next_crq: - Returns the next entry in message queue
- * @queue:	crq_queue to use
- *
- * Returns pointer to next entry in queue, or NULL if there are no new 
- * entried in the CRQ.
- */
-static struct viosrp_crq *crq_queue_next_crq(struct crq_queue *queue)
-{
-	struct viosrp_crq *crq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&queue->lock, flags);
-	crq = &queue->msgs[queue->cur];
-	if (crq->valid & 0x80) {
-		if (++queue->cur == queue->size)
-			queue->cur = 0;
-	} else
-		crq = NULL;
-	spin_unlock_irqrestore(&queue->lock, flags);
-
-	return crq;
-}
-
-/**
- * rpavscsi_send_crq: - Send a CRQ
- * @hostdata:	the adapter
- * @word1:	the first 64 bits of the data
- * @word2:	the second 64 bits of the data
- */
-static int rpavscsi_send_crq(struct ibmvscsi_host_data *hostdata,
-			     u64 word1, u64 word2)
-{
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-
-	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
-}
-
-/**
- * rpavscsi_task: - Process srps asynchronously
- * @data:	ibmvscsi_host_data of host
- */
-static void rpavscsi_task(void *data)
-{
-	struct ibmvscsi_host_data *hostdata = (struct ibmvscsi_host_data *)data;
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-	struct viosrp_crq *crq;
-	int done = 0;
-
-	while (!done) {
-		/* Pull all the valid messages off the CRQ */
-		while ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
-			ibmvscsi_handle_crq(crq, hostdata);
-			crq->valid = 0x00;
-		}
-
-		vio_enable_interrupts(vdev);
-		if ((crq = crq_queue_next_crq(&hostdata->queue)) != NULL) {
-			vio_disable_interrupts(vdev);
-			ibmvscsi_handle_crq(crq, hostdata);
-			crq->valid = 0x00;
-		} else {
-			done = 1;
-		}
-	}
-}
-
-static void gather_partition_info(void)
-{
-	struct device_node *rootdn;
-
-	const char *ppartition_name;
-	const unsigned int *p_number_ptr;
-
-	/* Retrieve information about this partition */
-	rootdn = of_find_node_by_path("/");
-	if (!rootdn) {
-		return;
-	}
-
-	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
-	if (ppartition_name)
-		strncpy(partition_name, ppartition_name,
-				sizeof(partition_name));
-	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
-	if (p_number_ptr)
-		partition_number = *p_number_ptr;
-	of_node_put(rootdn);
-}
-
-static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
-{
-	memset(&hostdata->madapter_info, 0x00,
-			sizeof(hostdata->madapter_info));
-
-	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
-	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);
-
-	strncpy(hostdata->madapter_info.partition_name, partition_name,
-			sizeof(hostdata->madapter_info.partition_name));
-
-	hostdata->madapter_info.partition_number = partition_number;
-
-	hostdata->madapter_info.mad_version = 1;
-	hostdata->madapter_info.os_type = 2;
-}
-
-/**
- * reset_crq_queue: - resets a crq after a failure
- * @queue:	crq_queue to initialize and register
- * @hostdata:	ibmvscsi_host_data of host
- *
- */
-static int rpavscsi_reset_crq_queue(struct crq_queue *queue,
-				    struct ibmvscsi_host_data *hostdata)
-{
-	int rc = 0;
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-
-	/* Close the CRQ */
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
-	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-
-	/* Clean out the queue */
-	memset(queue->msgs, 0x00, PAGE_SIZE);
-	queue->cur = 0;
-
-	set_adapter_info(hostdata);
-
-	/* And re-open it again */
-	rc = plpar_hcall_norets(H_REG_CRQ,
-				vdev->unit_address,
-				queue->msg_token, PAGE_SIZE);
-	if (rc == 2) {
-		/* Adapter is good, but other end is not ready */
-		dev_warn(hostdata->dev, "Partner adapter not ready\n");
-	} else if (rc != 0) {
-		dev_warn(hostdata->dev, "couldn't register crq--rc 0x%x\n", rc);
-	}
-	return rc;
-}
-
-/**
- * initialize_crq_queue: - Initializes and registers CRQ with hypervisor
- * @queue:	crq_queue to initialize and register
- * @hostdata:	ibmvscsi_host_data of host
- *
- * Allocates a page for messages, maps it for dma, and registers
- * the crq with the hypervisor.
- * Returns zero on success.
- */
-static int rpavscsi_init_crq_queue(struct crq_queue *queue,
-				   struct ibmvscsi_host_data *hostdata,
-				   int max_requests)
-{
-	int rc;
-	int retrc;
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-
-	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
-
-	if (!queue->msgs)
-		goto malloc_failed;
-	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
-
-	queue->msg_token = dma_map_single(hostdata->dev, queue->msgs,
-					  queue->size * sizeof(*queue->msgs),
-					  DMA_BIDIRECTIONAL);
-
-	if (dma_mapping_error(hostdata->dev, queue->msg_token))
-		goto map_failed;
-
-	gather_partition_info();
-	set_adapter_info(hostdata);
-
-	retrc = rc = plpar_hcall_norets(H_REG_CRQ,
-				vdev->unit_address,
-				queue->msg_token, PAGE_SIZE);
-	if (rc == H_RESOURCE)
-		/* maybe kexecing and resource is busy. try a reset */
-		rc = rpavscsi_reset_crq_queue(queue,
-					      hostdata);
-
-	if (rc == 2) {
-		/* Adapter is good, but other end is not ready */
-		dev_warn(hostdata->dev, "Partner adapter not ready\n");
-		retrc = 0;
-	} else if (rc != 0) {
-		dev_warn(hostdata->dev, "Error %d opening adapter\n", rc);
-		goto reg_crq_failed;
-	}
-
-	queue->cur = 0;
-	spin_lock_init(&queue->lock);
-
-	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
-		     (unsigned long)hostdata);
-
-	if (request_irq(vdev->irq,
-			rpavscsi_handle_event,
-			0, "ibmvscsi", (void *)hostdata) != 0) {
-		dev_err(hostdata->dev, "couldn't register irq 0x%x\n",
-			vdev->irq);
-		goto req_irq_failed;
-	}
-
-	rc = vio_enable_interrupts(vdev);
-	if (rc != 0) {
-		dev_err(hostdata->dev, "Error %d enabling interrupts!!!\n", rc);
-		goto req_irq_failed;
-	}
-
-	return retrc;
-
-      req_irq_failed:
-	tasklet_kill(&hostdata->srp_task);
-	rc = 0;
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
-	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-      reg_crq_failed:
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-      map_failed:
-	free_page((unsigned long)queue->msgs);
-      malloc_failed:
-	return -1;
-}
-
-/**
- * reenable_crq_queue: - reenables a crq after
- * @queue:	crq_queue to initialize and register
- * @hostdata:	ibmvscsi_host_data of host
- *
- */
-static int rpavscsi_reenable_crq_queue(struct crq_queue *queue,
-				       struct ibmvscsi_host_data *hostdata)
-{
-	int rc = 0;
-	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
-
-	/* Re-enable the CRQ */
-	do {
-		if (rc)
-			msleep(100);
-		rc = plpar_hcall_norets(H_ENABLE_CRQ, vdev->unit_address);
-	} while ((rc == H_IN_PROGRESS) || (rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-
-	if (rc)
-		dev_err(hostdata->dev, "Error %d enabling adapter\n", rc);
-	return rc;
-}
-
-/**
- * rpavscsi_resume: - resume after suspend
- * @hostdata:	ibmvscsi_host_data of host
- *
- */
-static int rpavscsi_resume(struct ibmvscsi_host_data *hostdata)
-{
-	vio_disable_interrupts(to_vio_dev(hostdata->dev));
-	tasklet_schedule(&hostdata->srp_task);
-	return 0;
-}
-
-struct ibmvscsi_ops rpavscsi_ops = {
-	.init_crq_queue = rpavscsi_init_crq_queue,
-	.release_crq_queue = rpavscsi_release_crq_queue,
-	.reset_crq_queue = rpavscsi_reset_crq_queue,
-	.reenable_crq_queue = rpavscsi_reenable_crq_queue,
-	.send_crq = rpavscsi_send_crq,
-	.resume = rpavscsi_resume,
-};


