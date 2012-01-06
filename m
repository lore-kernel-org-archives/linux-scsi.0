From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 09/14] isci: kill isci_port->status
Date: Thu, 05 Jan 2012 16:59:46 -0800
Message-ID: <20120106005946.11464.58853.stgit@localhost6.localdomain6>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It only tracks whether the port is stopping in order to gate new devices
being discovered while the port is stopping.  However, since the check
and subsequent handling is unlocked there is nothing to stop the port
from going down immediately after the check.

Driver is already prepared to handle devices arriving on stale ports,
and those will be cleaned up by an eventual ->lldd_dev_gone()
notification.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c          |   89 +++++--------------------------------
 drivers/scsi/isci/port.h          |    5 --
 drivers/scsi/isci/remote_device.c |    4 --
 3 files changed, 11 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 773ff34..255c52f 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -75,20 +75,6 @@ static struct device *sciport_to_dev(struct isci_port *iport)
 	return &ihost->pdev->dev;
 }
 
-static void isci_port_change_state(struct isci_port *iport, enum isci_status status)
-{
-	unsigned long flags;
-
-	dev_dbg(&iport->isci_host->pdev->dev,
-		"%s: iport = %p, state = 0x%x\n",
-		__func__, iport, status);
-
-	/* XXX pointless lock */
-	spin_lock_irqsave(&iport->state_lock, flags);
-	iport->status = status;
-	spin_unlock_irqrestore(&iport->state_lock, flags);
-}
-
 static void sci_port_get_protocols(struct isci_port *iport, struct sci_phy_proto *proto)
 {
 	u8 index;
@@ -186,8 +172,6 @@ static void isci_port_link_up(struct isci_host *isci_host,
 
 	spin_lock_irqsave(&iphy->sas_phy.frame_rcvd_lock, flags);
 
-	isci_port_change_state(iport, isci_starting);
-
 	sci_port_get_properties(iport, &properties);
 
 	if (iphy->protocol == SCIC_SDS_PHY_PROTOCOL_SATA) {
@@ -269,7 +253,6 @@ static void isci_port_link_down(struct isci_host *isci_host,
 					__func__, isci_device);
 				set_bit(IDEV_GONE, &isci_device->flags);
 			}
-			isci_port_change_state(isci_port, isci_stopping);
 		}
 	}
 
@@ -284,45 +267,6 @@ static void isci_port_link_down(struct isci_host *isci_host,
 		"%s: isci_port = %p - Done\n", __func__, isci_port);
 }
 
-
-/**
- * isci_port_ready() - This function is called by the sci core when a link
- *    becomes ready.
- * @isci_host: This parameter specifies the isci host object.
- * @port: This parameter specifies the sci port with the active link.
- *
- */
-static void isci_port_ready(struct isci_host *isci_host, struct isci_port *isci_port)
-{
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_port = %p\n", __func__, isci_port);
-
-	isci_port_change_state(isci_port, isci_ready);
-	return;
-}
-
-/**
- * isci_port_not_ready() - This function is called by the sci core when a link
- *    is not ready. All remote devices on this link will be removed if they are
- *    in the stopping state.
- * @isci_host: This parameter specifies the isci host object.
- * @port: This parameter specifies the sci port with the active link.
- *
- */
-static void isci_port_not_ready(struct isci_host *isci_host, struct isci_port *isci_port)
-{
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_port = %p\n", __func__, isci_port);
-}
-
-static void isci_port_stop_complete(struct isci_host *ihost,
-				    struct isci_port *iport,
-				    enum sci_status completion_status)
-{
-	dev_dbg(&ihost->pdev->dev, "Port stop complete\n");
-}
-
-
 static bool is_port_ready_state(enum sci_port_states state)
 {
 	switch (state) {
@@ -828,10 +772,9 @@ static void port_timeout(unsigned long data)
 			__func__,
 			iport);
 	} else if (current_state == SCI_PORT_STOPPING) {
-		/* if the port is still stopping then the stop has not completed */
-		isci_port_stop_complete(iport->owning_controller,
-					iport,
-					SCI_FAILURE_TIMEOUT);
+		dev_dbg(sciport_to_dev(iport),
+			"%s: port%d: stop complete timeout\n",
+			__func__, iport->physical_port_index);
 	} else {
 		/* The port is in the ready state and we have a timer
 		 * reporting a timeout this should not happen.
@@ -989,7 +932,8 @@ static void sci_port_ready_substate_operational_enter(struct sci_base_state_mach
 	struct isci_port *iport = container_of(sm, typeof(*iport), sm);
 	struct isci_host *ihost = iport->owning_controller;
 
-	isci_port_ready(ihost, iport);
+	dev_dbg(&ihost->pdev->dev, "%s: port%d ready\n",
+		__func__, iport->physical_port_index);
 
 	for (index = 0; index < SCI_MAX_PHYS; index++) {
 		if (iport->phy_table[index]) {
@@ -1055,7 +999,8 @@ static void sci_port_ready_substate_operational_exit(struct sci_base_state_machi
 	 */
 	sci_port_abort_dummy_request(iport);
 
-	isci_port_not_ready(ihost, iport);
+	dev_dbg(&ihost->pdev->dev, "%s: port%d !ready\n",
+		__func__, iport->physical_port_index);
 
 	if (iport->ready_exit)
 		sci_port_invalidate_dummy_remote_node(iport);
@@ -1067,7 +1012,8 @@ static void sci_port_ready_substate_configuring_enter(struct sci_base_state_mach
 	struct isci_host *ihost = iport->owning_controller;
 
 	if (iport->active_phy_mask == 0) {
-		isci_port_not_ready(ihost, iport);
+		dev_dbg(&ihost->pdev->dev, "%s: port%d !ready\n",
+			__func__, iport->physical_port_index);
 
 		port_state_machine_change(iport,
 					  SCI_PORT_SUB_WAITING);
@@ -1544,7 +1490,8 @@ static void sci_port_ready_state_enter(struct sci_base_state_machine *sm)
 	if (prev_state  == SCI_PORT_RESETTING)
 		isci_port_hard_reset_complete(iport, SCI_SUCCESS);
 	else
-		isci_port_not_ready(ihost, iport);
+		dev_dbg(&ihost->pdev->dev, "%s: port%d !ready\n",
+			__func__, iport->physical_port_index);
 
 	/* Post and suspend the dummy remote node context for this port. */
 	sci_port_post_dummy_remote_node(iport);
@@ -1640,21 +1587,7 @@ void isci_port_init(struct isci_port *iport, struct isci_host *ihost, int index)
 {
 	INIT_LIST_HEAD(&iport->remote_dev_list);
 	INIT_LIST_HEAD(&iport->domain_dev_list);
-	spin_lock_init(&iport->state_lock);
 	iport->isci_host = ihost;
-	isci_port_change_state(iport, isci_freed);
-}
-
-/**
- * isci_port_get_state() - This function gets the status of the port object.
- * @isci_port: This parameter points to the isci_port object
- *
- * status of the object as a isci_status enum.
- */
-enum isci_status isci_port_get_state(
-	struct isci_port *isci_port)
-{
-	return isci_port->status;
 }
 
 void sci_port_broadcast_change_received(struct isci_port *iport, struct isci_phy *iphy)
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index 83de4b4..b0b7cc1 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -90,10 +90,8 @@ enum isci_status {
  * @timer: timeout start/stop operations
  */
 struct isci_port {
-	enum isci_status status;
 	struct isci_host *isci_host;
 	struct list_head remote_dev_list;
-	spinlock_t state_lock;
 	struct list_head domain_dev_list;
 	struct completion hard_reset_complete;
 	enum sci_status hard_reset_status;
@@ -284,9 +282,6 @@ void sci_port_get_attached_sas_address(
 	struct isci_port *iport,
 	struct sci_sas_address *sas_address);
 
-enum isci_status isci_port_get_state(
-	struct isci_port *isci_port);
-
 void isci_port_formed(struct asd_sas_phy *);
 void isci_port_deformed(struct asd_sas_phy *);
 
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 49259e0..967394d 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1390,10 +1390,6 @@ int isci_remote_device_found(struct domain_device *dev)
 	if (!isci_port)
 		return -ENODEV;
 
-	if ((isci_stopping == isci_port_get_state(isci_port)) ||
-	    (isci_stopped == isci_port_get_state(isci_port)))
-		return -ENODEV;
-
 	isci_device = isci_remote_device_alloc(isci_host, isci_port);
 	if (!isci_device)
 		return -ENODEV;

