From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ibmvscsi: Fix softlockup on resume
Date: Thu, 17 Jun 2010 13:56:00 -0500
Message-ID: <201006171856.o5HIu1oW012845@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53199 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQS4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:56:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HImuKt009294
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:48:56 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o5HIu2N7198196
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIu2DE012950
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This fixes a softlockup seen on resume. During resume, the CRQ
must be reenabled. However, the H_ENABLE_CRQ hcall used to do
this may return H_BUSY or H_LONG_BUSY. When this happens, the
caller is expected to retry later. This patch changes a simple
loop, which was causing the softlockup, to a loop at task level
which sleeps between retries rather than simply spinning.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c  |  117 ++++++++++++++++++++++++++++----------
 drivers/scsi/ibmvscsi/ibmvscsi.h  |    4 +
 drivers/scsi/ibmvscsi/rpa_vscsi.c |   16 ++++-
 3 files changed, 106 insertions(+), 31 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_reenable_sleep drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_reenable_sleep	2010-06-10 12:08:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h	2010-06-10 12:08:44.000000000 -0500
@@ -91,12 +91,16 @@ struct event_pool {
 struct ibmvscsi_host_data {
 	atomic_t request_limit;
 	int client_migrated;
+	int reset_crq;
+	int reenable_crq;
 	struct device *dev;
 	struct event_pool pool;
 	struct crq_queue queue;
 	struct tasklet_struct srp_task;
 	struct list_head sent;
 	struct Scsi_Host *host;
+	struct task_struct *work_thread;
+	wait_queue_head_t work_wait_q;
 	struct mad_adapter_info_data madapter_info;
 	struct capabilities caps;
 	dma_addr_t caps_addr;
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_reenable_sleep drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_reenable_sleep	2010-06-10 12:08:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2010-06-10 12:17:02.000000000 -0500
@@ -73,6 +73,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/pm.h>
+#include <linux/kthread.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
@@ -504,14 +505,8 @@ static void ibmvscsi_reset_host(struct i
 	atomic_set(&hostdata->request_limit, 0);
 
 	purge_requests(hostdata, DID_ERROR);
-	if ((ibmvscsi_ops->reset_crq_queue(&hostdata->queue, hostdata)) ||
-	    (ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0)) ||
-	    (vio_enable_interrupts(to_vio_dev(hostdata->dev)))) {
-		atomic_set(&hostdata->request_limit, -1);
-		dev_err(hostdata->dev, "error after reset\n");
-	}
-
-	scsi_unblock_requests(hostdata->host);
+	hostdata->reset_crq = 1;
+	wake_up(&hostdata->work_wait_q);
 }
 
 /**
@@ -1462,30 +1457,14 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			/* We need to re-setup the interpartition connection */
 			dev_info(hostdata->dev, "Re-enabling adapter!\n");
 			hostdata->client_migrated = 1;
+			hostdata->reenable_crq = 1;
 			purge_requests(hostdata, DID_REQUEUE);
-			if ((ibmvscsi_ops->reenable_crq_queue(&hostdata->queue,
-							      hostdata)) ||
-			    (ibmvscsi_ops->send_crq(hostdata,
-						    0xC001000000000000LL, 0))) {
-					atomic_set(&hostdata->request_limit,
-						   -1);
-					dev_err(hostdata->dev, "error after enable\n");
-			}
+			wake_up(&hostdata->work_wait_q);
 		} else {
 			dev_err(hostdata->dev, "Virtual adapter failed rc %d!\n",
 				crq->format);
-
-			purge_requests(hostdata, DID_ERROR);
-			if ((ibmvscsi_ops->reset_crq_queue(&hostdata->queue,
-							   hostdata)) ||
-			    (ibmvscsi_ops->send_crq(hostdata,
-						    0xC001000000000000LL, 0))) {
-					atomic_set(&hostdata->request_limit,
-						   -1);
-					dev_err(hostdata->dev, "error after reset\n");
-			}
+			ibmvscsi_reset_host(hostdata);
 		}
-		scsi_unblock_requests(hostdata->host);
 		return;
 	case 0x80:		/* real payload */
 		break;
@@ -1850,6 +1829,75 @@ static unsigned long ibmvscsi_get_desire
 	return desired_io;
 }
 
+static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
+{
+	int rc;
+	char *action = "reset";
+
+	if (hostdata->reset_crq) {
+		smp_rmb();
+		hostdata->reset_crq = 0;
+
+		rc = ibmvscsi_ops->reset_crq_queue(&hostdata->queue, hostdata);
+		if (!rc)
+			rc = ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0);
+		if (!rc)
+			rc = vio_enable_interrupts(to_vio_dev(hostdata->dev));
+	} else if (hostdata->reenable_crq) {
+		smp_rmb();
+		action = "enable";
+		rc = ibmvscsi_ops->reenable_crq_queue(&hostdata->queue, hostdata);
+		hostdata->reenable_crq = 0;
+		if (!rc)
+			rc = ibmvscsi_ops->send_crq(hostdata, 0xC001000000000000LL, 0);
+	} else
+		return;
+
+	if (rc) {
+		atomic_set(&hostdata->request_limit, -1);
+		dev_err(hostdata->dev, "error after %s\n", action);
+	}
+
+	scsi_unblock_requests(hostdata->host);
+}
+
+static int ibmvscsi_work_to_do(struct ibmvscsi_host_data *hostdata)
+{
+	if (kthread_should_stop())
+		return 1;
+	else if (hostdata->reset_crq) {
+		smp_rmb();
+		return 1;
+	} else if (hostdata->reenable_crq) {
+		smp_rmb();
+		return 1;
+	}
+
+	return 0;
+}
+
+static int ibmvscsi_work(void *data)
+{
+	struct ibmvscsi_host_data *hostdata = data;
+	int rc;
+
+	set_user_nice(current, -20);
+
+	while (1) {
+		rc = wait_event_interruptible(hostdata->work_wait_q,
+					      ibmvscsi_work_to_do(hostdata));
+
+		BUG_ON(rc);
+
+		if (kthread_should_stop())
+			break;
+
+		ibmvscsi_do_work(hostdata);
+	}
+
+	return 0;
+}
+
 /**
  * Called by bus code for each adapter
  */
@@ -1875,6 +1923,7 @@ static int ibmvscsi_probe(struct vio_dev
 	hostdata = shost_priv(host);
 	memset(hostdata, 0x00, sizeof(*hostdata));
 	INIT_LIST_HEAD(&hostdata->sent);
+	init_waitqueue_head(&hostdata->work_wait_q);
 	hostdata->host = host;
 	hostdata->dev = dev;
 	atomic_set(&hostdata->request_limit, -1);
@@ -1885,10 +1934,19 @@ static int ibmvscsi_probe(struct vio_dev
 		goto persist_bufs_failed;
 	}
 
+	hostdata->work_thread = kthread_run(ibmvscsi_work, hostdata, "%s_%d",
+					    "ibmvscsi", host->host_no);
+
+	if (IS_ERR(hostdata->work_thread)) {
+		dev_err(&vdev->dev, "couldn't initialize kthread. rc=%ld\n",
+			PTR_ERR(hostdata->work_thread));
+		goto init_crq_failed;
+	}
+
 	rc = ibmvscsi_ops->init_crq_queue(&hostdata->queue, hostdata, max_events);
 	if (rc != 0 && rc != H_RESOURCE) {
 		dev_err(&vdev->dev, "couldn't initialize crq. rc=%d\n", rc);
-		goto init_crq_failed;
+		goto kill_kthread;
 	}
 	if (initialize_event_pool(&hostdata->pool, max_events, hostdata) != 0) {
 		dev_err(&vdev->dev, "couldn't initialize event pool\n");
@@ -1944,6 +2002,8 @@ static int ibmvscsi_probe(struct vio_dev
 	release_event_pool(&hostdata->pool, hostdata);
       init_pool_failed:
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata, max_events);
+      kill_kthread:
+      kthread_stop(hostdata->work_thread);
       init_crq_failed:
 	unmap_persist_bufs(hostdata);
       persist_bufs_failed:
@@ -1960,6 +2020,7 @@ static int ibmvscsi_remove(struct vio_de
 	ibmvscsi_ops->release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
 
+	kthread_stop(hostdata->work_thread);
 	srp_remove_host(hostdata->host);
 	scsi_remove_host(hostdata->host);
 	scsi_host_put(hostdata->host);
diff -puN drivers/scsi/ibmvscsi/rpa_vscsi.c~ibmvscsi_reenable_sleep drivers/scsi/ibmvscsi/rpa_vscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/rpa_vscsi.c~ibmvscsi_reenable_sleep	2010-06-10 12:08:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/rpa_vscsi.c	2010-06-10 12:08:44.000000000 -0500
@@ -31,6 +31,7 @@
 #include <asm/prom.h>
 #include <asm/iommu.h>
 #include <asm/hvcall.h>
+#include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/interrupt.h>
@@ -71,11 +72,13 @@ static void rpavscsi_release_crq_queue(s
 				       struct ibmvscsi_host_data *hostdata,
 				       int max_requests)
 {
-	long rc;
+	long rc = 0;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 	free_irq(vdev->irq, (void *)hostdata);
 	tasklet_kill(&hostdata->srp_task);
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
 	dma_unmap_single(hostdata->dev,
@@ -200,11 +203,13 @@ static void set_adapter_info(struct ibmv
 static int rpavscsi_reset_crq_queue(struct crq_queue *queue,
 				    struct ibmvscsi_host_data *hostdata)
 {
-	int rc;
+	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
 	/* Close the CRQ */
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
 
@@ -300,7 +305,10 @@ static int rpavscsi_init_crq_queue(struc
 	return retrc;
 
       req_irq_failed:
+	rc = 0;
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
       reg_crq_failed:
@@ -322,11 +330,13 @@ static int rpavscsi_init_crq_queue(struc
 static int rpavscsi_reenable_crq_queue(struct crq_queue *queue,
 				       struct ibmvscsi_host_data *hostdata)
 {
-	int rc;
+	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
 	/* Re-enable the CRQ */
 	do {
+		if (rc)
+			msleep(100);
 		rc = plpar_hcall_norets(H_ENABLE_CRQ, vdev->unit_address);
 	} while ((rc == H_IN_PROGRESS) || (rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
 
_
