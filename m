From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] isci: filter broadcast change notifications during SMP
 phy resets
Date: Fri, 24 Jun 2011 12:48:49 -0700
Message-ID: <20110624194109.26706.58553.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab1FXTsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 15:48:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, hare@suse.de, yuxiangl@marvell.com, hch@lst.de

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

When resetting a sata device in the domain we have seen occasions where
libsas prematurely marks a device gone in the time it takes for the
device to re-establish the link.  This plays badly with software raid
arrays.  Other libsas drivers have non-uniform delays in their reset
handlers to try to cover this condition, but not sufficient to close the
hole.  Given that a sata device can take many seconds to recover we
filter bcns and poll for the device reattach state before notifying
libsas that the port needs the domain to be rediscovered.  Once this has
been proven out at the lldd level we can think about uplevelling this
feature to a common implementation in libsas.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
[ use kzalloc instead of kmem_cache ]
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ use eventq and time macros ]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

This patch will be included in the upcoming update of the isci git tree.  It
is being sent as its own message to get thoughts on up-levelling this to a
libsas responsibility, creating a common helper routine for lldd's to perform
this filtering, or exploring other ideas on how to not prematurely kick slow
to recover devices from the domain.

 drivers/scsi/isci/port.c |  115 +++++++++++++-------
 drivers/scsi/isci/port.h |    5 +
 drivers/scsi/isci/task.c |  259 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 338 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 74f06f3..2946eee 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -152,6 +152,71 @@ static enum sci_status scic_port_get_properties(struct scic_sds_port *port,
 	return SCI_SUCCESS;
 }
 
+static void scic_port_bcn_enable(struct scic_sds_port *sci_port)
+{
+	struct scic_sds_phy *sci_phy;
+	u32 val;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sci_port->phy_table); i++) {
+		sci_phy = sci_port->phy_table[i];
+		if (!sci_phy)
+			continue;
+		val = readl(&sci_phy->link_layer_registers->link_layer_control);
+		/* clear the bit by writing 1. */
+		writel(val, &sci_phy->link_layer_registers->link_layer_control);
+	}
+}
+
+/* called under scic_lock to stabilize phy:port associations */
+void isci_port_bcn_enable(struct isci_host *ihost, struct isci_port *iport)
+{
+	int i;
+
+	clear_bit(IPORT_BCN_BLOCKED, &iport->flags);
+	wake_up(&ihost->eventq);
+
+	if (!test_and_clear_bit(IPORT_BCN_PENDING, &iport->flags))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(iport->sci.phy_table); i++) {
+		struct scic_sds_phy *sci_phy = iport->sci.phy_table[i];
+		struct isci_phy *iphy = sci_phy_to_iphy(sci_phy);
+
+		if (!sci_phy)
+			continue;
+
+		ihost->sas_ha.notify_port_event(&iphy->sas_phy,
+						PORTE_BROADCAST_RCVD);
+		break;
+	}
+}
+
+void isci_port_bc_change_received(struct isci_host *ihost,
+				  struct scic_sds_port *sci_port,
+				  struct scic_sds_phy *sci_phy)
+{
+	struct isci_phy *iphy = sci_phy_to_iphy(sci_phy);
+	struct isci_port *iport = iphy->isci_port;
+
+	if (iport && test_bit(IPORT_BCN_BLOCKED, &iport->flags)) {
+		dev_dbg(&ihost->pdev->dev,
+			"%s: disabled BCN; isci_phy = %p, sas_phy = %p\n",
+			__func__, iphy, &iphy->sas_phy);
+		set_bit(IPORT_BCN_PENDING, &iport->flags);
+		atomic_inc(&iport->event);
+		wake_up(&ihost->eventq);
+	} else {
+		dev_dbg(&ihost->pdev->dev,
+			"%s: isci_phy = %p, sas_phy = %p\n",
+			__func__, iphy, &iphy->sas_phy);
+
+		ihost->sas_ha.notify_port_event(&iphy->sas_phy,
+						PORTE_BROADCAST_RCVD);
+	}
+	scic_port_bcn_enable(sci_port);
+}
+
 static void isci_port_link_up(struct isci_host *isci_host,
 			      struct scic_sds_port *port,
 			      struct scic_sds_phy *phy)
@@ -240,13 +305,15 @@ static void isci_port_link_down(struct isci_host *isci_host,
 	if (isci_port) {
 
 		/* check to see if this is the last phy on this port. */
-		if (isci_phy->sas_phy.port
-		    && isci_phy->sas_phy.port->num_phys == 1) {
-
-			/* change the state for all devices on this port.
-			 * The next task sent to this device will be returned
-			 * as SAS_TASK_UNDELIVERED, and the scsi mid layer
-			 * will remove the target
+		if (isci_phy->sas_phy.port &&
+		    isci_phy->sas_phy.port->num_phys == 1) {
+			atomic_inc(&isci_port->event);
+			isci_port_bcn_enable(isci_host, isci_port);
+
+			/* change the state for all devices on this port.  The
+			 * next task sent to this device will be returned as
+			 * SAS_TASK_UNDELIVERED, and the scsi mid layer will
+			 * remove the target
 			 */
 			list_for_each_entry(isci_device,
 					    &isci_port->remote_dev_list,
@@ -1033,26 +1100,6 @@ enum sas_linkrate scic_sds_port_get_max_allowed_speed(
 	return max_allowed_speed;
 }
 
-static void scic_port_enable_broadcast_change_notification(struct scic_sds_port *port)
-{
-	struct scic_sds_phy *phy;
-	u32 register_value;
-	u8 index;
-
-	/* Loop through all of the phys to enable BCN. */
-	for (index = 0; index < SCI_MAX_PHYS; index++) {
-		phy = port->phy_table[index];
-		if (phy != NULL) {
-			register_value =
-				readl(&phy->link_layer_registers->link_layer_control);
-
-			/* clear the bit by writing 1. */
-			writel(register_value,
-				&phy->link_layer_registers->link_layer_control);
-		}
-	}
-}
-
 /**
  *
  * @sci_port: This is the struct scic_sds_port object to suspend.
@@ -1838,6 +1885,7 @@ void isci_port_init(struct isci_port *iport, struct isci_host *ihost, int index)
 	init_completion(&iport->start_complete);
 	iport->isci_host = ihost;
 	isci_port_change_state(iport, isci_freed);
+	atomic_set(&iport->event, 0);
 }
 
 /**
@@ -1852,19 +1900,6 @@ enum isci_status isci_port_get_state(
 	return isci_port->status;
 }
 
-static void isci_port_bc_change_received(struct isci_host *ihost,
-					 struct scic_sds_port *sci_port,
-					 struct scic_sds_phy *sci_phy)
-{
-	struct isci_phy *iphy = sci_phy_to_iphy(sci_phy);
-
-	dev_dbg(&ihost->pdev->dev, "%s: iphy = %p, sas_phy = %p\n",
-		__func__, iphy, &iphy->sas_phy);
-
-	ihost->sas_ha.notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
-	scic_port_enable_broadcast_change_notification(sci_port);
-}
-
 void scic_sds_port_broadcast_change_received(
 	struct scic_sds_port *sci_port,
 	struct scic_sds_phy *sci_phy)
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index fee6d80..45c01f8 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -173,6 +173,10 @@ struct scic_sds_port {
  */
 struct isci_port {
 	enum isci_status status;
+	#define IPORT_BCN_BLOCKED 0
+	#define IPORT_BCN_PENDING 1
+	unsigned long flags;
+	atomic_t event;
 	struct isci_host *isci_host;
 	struct asd_sas_port sas_port;
 	struct list_head remote_dev_list;
@@ -334,6 +338,7 @@ void scic_sds_port_setup_transports(
 	struct scic_sds_port *sci_port,
 	u32 device_id);
 
+void isci_port_bcn_enable(struct isci_host *, struct isci_port *);
 
 void scic_sds_port_deactivate_phy(
 	struct scic_sds_port *sci_port,
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 69f17b9..709c081 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -56,6 +56,7 @@
 #include <linux/completion.h>
 #include <linux/irqflags.h>
 #include "sas.h"
+#include <scsi/libsas.h>
 #include "remote_device.h"
 #include "remote_node_context.h"
 #include "isci.h"
@@ -1397,11 +1398,250 @@ isci_task_request_complete(struct isci_host *ihost,
 	complete(tmf_complete);
 }
 
+static void isci_smp_task_timedout(unsigned long _task)
+{
+	struct sas_task *task = (void *) _task;
+	unsigned long flags;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	complete(&task->completion);
+}
+
+static void isci_smp_task_done(struct sas_task *task)
+{
+	if (!del_timer(&task->timer))
+		return;
+	complete(&task->completion);
+}
+
+static struct sas_task *isci_alloc_task(void)
+{
+	struct sas_task *task = kzalloc(sizeof(*task), GFP_KERNEL);
+
+	if (task) {
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+
+	return task;
+}
+
+static void isci_free_task(struct isci_host *ihost, struct sas_task  *task)
+{
+	if (task) {
+		BUG_ON(!list_empty(&task->list));
+		kfree(task);
+	}
+}
+
+static int isci_smp_execute_task(struct isci_host *ihost,
+				 struct domain_device *dev, void *req,
+				 int req_size, void *resp, int resp_size)
+{
+	int res, retry;
+	struct sas_task *task = NULL;
+
+	for (retry = 0; retry < 3; retry++) {
+		task = isci_alloc_task();
+		if (!task)
+			return -ENOMEM;
+
+		task->dev = dev;
+		task->task_proto = dev->tproto;
+		sg_init_one(&task->smp_task.smp_req, req, req_size);
+		sg_init_one(&task->smp_task.smp_resp, resp, resp_size);
+
+		task->task_done = isci_smp_task_done;
+
+		task->timer.data = (unsigned long) task;
+		task->timer.function = isci_smp_task_timedout;
+		task->timer.expires = jiffies + 10*HZ;
+		add_timer(&task->timer);
+
+		res = isci_task_execute_task(task, 1, GFP_KERNEL);
+
+		if (res) {
+			del_timer(&task->timer);
+			dev_err(&ihost->pdev->dev,
+				"%s: executing SMP task failed:%d\n",
+				__func__, res);
+			goto ex_err;
+		}
+
+		wait_for_completion(&task->completion);
+		res = -ECOMM;
+		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+			dev_err(&ihost->pdev->dev,
+				"%s: smp task timed out or aborted\n",
+				__func__);
+			isci_task_abort_task(task);
+			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+				dev_err(&ihost->pdev->dev,
+					"%s: SMP task aborted and not done\n",
+					__func__);
+				goto ex_err;
+			}
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		    task->task_status.stat == SAM_STAT_GOOD) {
+			res = 0;
+			break;
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_UNDERRUN) {
+			/* no error, but return the number of bytes of
+			* underrun */
+			res = task->task_status.residual;
+			break;
+		}
+		if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		      task->task_status.stat == SAS_DATA_OVERRUN) {
+			res = -EMSGSIZE;
+			break;
+		} else {
+			dev_err(&ihost->pdev->dev,
+				"%s: task to dev %016llx response: 0x%x "
+				"status 0x%x\n", __func__,
+				SAS_ADDR(dev->sas_addr),
+				task->task_status.resp,
+				task->task_status.stat);
+			isci_free_task(ihost, task);
+			task = NULL;
+		}
+	}
+ex_err:
+	BUG_ON(retry == 3 && task != NULL);
+	isci_free_task(ihost, task);
+	return res;
+}
+
+#define DISCOVER_REQ_SIZE  16
+#define DISCOVER_RESP_SIZE 56
+
+int isci_smp_get_phy_attached_dev_type(struct isci_host *ihost,
+				       struct domain_device *dev,
+				       int phy_id, int *adt)
+{
+	struct smp_resp *disc_resp;
+	u8 *disc_req;
+	int res;
+
+	disc_resp = kzalloc(DISCOVER_RESP_SIZE, GFP_KERNEL);
+	if (!disc_resp)
+		return -ENOMEM;
+
+	disc_req = kzalloc(DISCOVER_REQ_SIZE, GFP_KERNEL);
+	if (disc_req) {
+		disc_req[0] = SMP_REQUEST;
+		disc_req[1] = SMP_DISCOVER;
+		disc_req[9] = phy_id;
+	} else {
+		kfree(disc_resp);
+		return -ENOMEM;
+	}
+	res = isci_smp_execute_task(ihost, dev, disc_req, DISCOVER_REQ_SIZE,
+				    disc_resp, DISCOVER_RESP_SIZE);
+	if (!res) {
+		if (disc_resp->result != SMP_RESP_FUNC_ACC)
+			res = disc_resp->result;
+		else
+			*adt = disc_resp->disc.attached_dev_type;
+	}
+	kfree(disc_req);
+	kfree(disc_resp);
+
+	return res;
+}
+
+static void isci_wait_for_smp_phy_reset(struct isci_remote_device *idev, int phy_num)
+{
+	struct domain_device *dev = idev->domain_dev;
+	struct isci_port *iport = idev->isci_port;
+	struct isci_host *ihost = iport->isci_host;
+	int res, iteration = 0, attached_device_type;
+	#define STP_WAIT_MSECS 25000
+	unsigned long tmo = msecs_to_jiffies(STP_WAIT_MSECS);
+	unsigned long deadline = jiffies + tmo;
+	enum {
+		SMP_PHYWAIT_PHYDOWN,
+		SMP_PHYWAIT_PHYUP,
+		SMP_PHYWAIT_DONE
+	} phy_state = SMP_PHYWAIT_PHYDOWN;
+
+	/* While there is time, wait for the phy to go away and come back */
+	while (time_is_after_jiffies(deadline) && phy_state != SMP_PHYWAIT_DONE) {
+		int event = atomic_read(&iport->event);
+
+		++iteration;
+
+		tmo = wait_event_timeout(ihost->eventq,
+					 event != atomic_read(&iport->event) ||
+					 !test_bit(IPORT_BCN_BLOCKED, &iport->flags),
+					 tmo);
+		/* link down, stop polling */
+		if (!test_bit(IPORT_BCN_BLOCKED, &iport->flags))
+			break;
+
+		dev_dbg(&ihost->pdev->dev,
+			"%s: iport %p, iteration %d,"
+			" phase %d: time_remaining %lu, bcns = %d\n",
+			__func__, iport, iteration, phy_state,
+			tmo, test_bit(IPORT_BCN_PENDING, &iport->flags));
+
+		res = isci_smp_get_phy_attached_dev_type(ihost, dev, phy_num,
+							 &attached_device_type);
+		tmo = deadline - jiffies;
+
+		if (res) {
+			dev_warn(&ihost->pdev->dev,
+				 "%s: iteration %d, phase %d:"
+				 " SMP error=%d, time_remaining=%lu\n",
+				 __func__, iteration, phy_state, res, tmo);
+			break;
+		}
+		dev_dbg(&ihost->pdev->dev,
+			"%s: iport %p, iteration %d,"
+			" phase %d: time_remaining %lu, bcns = %d, "
+			"attdevtype = %x\n",
+			__func__, iport, iteration, phy_state,
+			tmo, test_bit(IPORT_BCN_PENDING, &iport->flags),
+			attached_device_type);
+
+		switch (phy_state) {
+		case SMP_PHYWAIT_PHYDOWN:
+			/* Has the device gone away? */
+			if (!attached_device_type)
+				phy_state = SMP_PHYWAIT_PHYUP;
+
+			break;
+
+		case SMP_PHYWAIT_PHYUP:
+			/* Has the device come back? */
+			if (attached_device_type)
+				phy_state = SMP_PHYWAIT_DONE;
+			break;
+
+		case SMP_PHYWAIT_DONE:
+			break;
+		}
+
+	}
+	dev_dbg(&ihost->pdev->dev, "%s: done\n",  __func__);
+}
+
 static int isci_reset_device(struct domain_device *dev, int hard_reset)
 {
 	struct isci_remote_device *idev = dev->lldd_dev;
 	struct sas_phy *phy = sas_find_local_phy(dev);
 	struct isci_host *ihost = dev_to_ihost(dev);
+	struct isci_port *iport = idev->isci_port;
 	enum sci_status status;
 	unsigned long flags;
 	int rc;
@@ -1432,6 +1672,10 @@ static int isci_reset_device(struct domain_device *dev, int hard_reset)
 	/* Make sure all pending requests are able to be fully terminated. */
 	isci_device_clear_reset_pending(ihost, idev);
 
+	/* If this is a device on an expander, disable BCN processing. */
+	if (!scsi_is_sas_phy_local(phy))
+		set_bit(IPORT_BCN_BLOCKED, &iport->flags);
+
 	rc = sas_phy_reset(phy, hard_reset);
 
 	/* Terminate in-progress I/O now. */
@@ -1442,7 +1686,20 @@ static int isci_reset_device(struct domain_device *dev, int hard_reset)
 	status = scic_remote_device_reset_complete(&idev->sci);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
-	msleep(2000); /* just like mvsas */
+	/* If this is a device on an expander, bring the phy back up. */
+	if (!scsi_is_sas_phy_local(phy)) {
+		/* A phy reset will cause the device to go away then reappear.
+		 * Since libsas will take action on incoming BCNs (eg. remove
+		 * a device going through an SMP phy-control driven reset),
+		 * we need to wait until the phy comes back up before letting
+		 * discovery proceed in libsas.
+		 */
+		isci_wait_for_smp_phy_reset(idev, phy->number);
+
+		spin_lock_irqsave(&ihost->scic_lock, flags);
+		isci_port_bcn_enable(ihost, idev->isci_port);
+		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+	}
 
 	if (status != SCI_SUCCESS) {
 		dev_warn(&ihost->pdev->dev,

