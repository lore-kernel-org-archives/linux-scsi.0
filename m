From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/5] ibmvfc: Fix dropped interrupts
Date: Fri, 20 Mar 2009 15:44:35 -0500
Message-ID: <200903202044.n2KKiURT017464@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:38830 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZCTUod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2009 16:44:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2KKgNOI005206
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:42:23 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2KKiV7H164148
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:31 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2KKiV77017483
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This patch fixes a problem of possible dropped interrupts. Currently, the ibmvfc
driver has a race condition where after ibmvfc_interrupt gets run, the platform
code clears the interrupt. This can result in lost interrupts and, in worst case
scenarios, result in command timeouts. Fix this by implementing a tasklet
similar to what the ibmvscsi driver does so that interrupt processing is no longer
done in the actual interrupt handler, which eliminates the race.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   25 +++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_tasklet drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_tasklet	2009-02-05 11:06:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-02-05 11:07:03.000000000 -0600
@@ -684,6 +684,7 @@ struct ibmvfc_host {
 	char partition_name[97];
 	void (*job_step) (struct ibmvfc_host *);
 	struct task_struct *work_thread;
+	struct tasklet_struct tasklet;
 	wait_queue_head_t init_wait_q;
 	wait_queue_head_t work_wait_q;
 };
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tasklet drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tasklet	2009-02-05 11:06:10.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-02-05 11:23:12.000000000 -0600
@@ -640,6 +640,7 @@ static void ibmvfc_release_crq_queue(str
 
 	ibmvfc_dbg(vhost, "Releasing CRQ\n");
 	free_irq(vdev->irq, vhost);
+	tasklet_kill(&vhost->tasklet);
 	do {
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
@@ -2699,6 +2700,25 @@ static struct ibmvfc_crq *ibmvfc_next_cr
 static irqreturn_t ibmvfc_interrupt(int irq, void *dev_instance)
 {
 	struct ibmvfc_host *vhost = (struct ibmvfc_host *)dev_instance;
+	unsigned long flags;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	vio_disable_interrupts(to_vio_dev(vhost->dev));
+	tasklet_schedule(&vhost->tasklet);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	return IRQ_HANDLED;
+}
+
+/**
+ * ibmvfc_tasklet - Interrupt handler tasklet
+ * @data:		ibmvfc host struct
+ *
+ * Returns:
+ *	Nothing
+ **/
+static void ibmvfc_tasklet(void *data)
+{
+	struct ibmvfc_host *vhost = data;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_crq *crq;
 	struct ibmvfc_async_crq *async;
@@ -2706,7 +2726,6 @@ static irqreturn_t ibmvfc_interrupt(int 
 	int done = 0;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	vio_disable_interrupts(to_vio_dev(vhost->dev));
 	while (!done) {
 		/* Pull all the valid messages off the CRQ */
 		while ((crq = ibmvfc_next_crq(vhost)) != NULL) {
@@ -2734,7 +2753,6 @@ static irqreturn_t ibmvfc_interrupt(int 
 	}
 
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	return IRQ_HANDLED;
 }
 
 /**
@@ -3859,6 +3877,8 @@ static int ibmvfc_init_crq(struct ibmvfc
 
 	retrc = 0;
 
+	tasklet_init(&vhost->tasklet, (void *)ibmvfc_tasklet, (unsigned long)vhost);
+
 	if ((rc = request_irq(vdev->irq, ibmvfc_interrupt, 0, IBMVFC_NAME, vhost))) {
 		dev_err(dev, "Couldn't register irq 0x%x. rc=%d\n", vdev->irq, rc);
 		goto req_irq_failed;
@@ -3874,6 +3894,7 @@ static int ibmvfc_init_crq(struct ibmvfc
 	return retrc;
 
 req_irq_failed:
+	tasklet_kill(&vhost->tasklet);
 	do {
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
_
