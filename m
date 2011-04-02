From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] isci: remove scic_controller state handlers
Date: Sat, 2 Apr 2011 08:15:20 -0400
Message-ID: <20110402121520.GB30913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1DBMPV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 08:15:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Remove the state handler indirections for the scic_controller, and replace
them with procedural calls that check for the correct state first.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/scic_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_controller.h	2011-04-02 04:58:56.190737787 -0700
+++ linux-2.6/drivers/scsi/isci/core/scic_controller.h	2011-04-02 05:03:52.600235824 -0700
@@ -110,11 +110,6 @@ enum sci_task_status scic_controller_sta
 	struct scic_sds_request *task_request,
 	u16 io_tag);
 
-enum sci_status scic_controller_complete_task(
-	struct scic_sds_controller *controller,
-	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *task_request);
-
 enum sci_status scic_controller_terminate_request(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device,
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.c	2011-04-02 05:00:05.268264085 -0700
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c	2011-04-02 05:03:52.604236996 -0700
@@ -1454,46 +1454,45 @@ void scic_sds_controller_error_handler(s
 
 
 
-void scic_sds_controller_link_up(
-	struct scic_sds_controller *scic,
-	struct scic_sds_port *sci_port,
-	struct scic_sds_phy *sci_phy)
+void scic_sds_controller_link_up(struct scic_sds_controller *scic,
+		struct scic_sds_port *port, struct scic_sds_phy *phy)
 {
-	scic_sds_controller_phy_handler_t link_up;
-	u32 state;
-
-	state = scic->state_machine.current_state_id;
-	link_up = scic_sds_controller_state_handler_table[state].link_up;
-
-	if (link_up)
-		link_up(scic, sci_port, sci_phy);
-	else
+	switch (scic->state_machine.current_state_id) {
+	case SCI_BASE_CONTROLLER_STATE_STARTING:
+		scic_sds_controller_phy_timer_stop(scic);
+		scic->port_agent.link_up_handler(scic, &scic->port_agent,
+						 port, phy);
+		scic_sds_controller_start_next_phy(scic);
+		break;
+	case SCI_BASE_CONTROLLER_STATE_READY:
+		scic->port_agent.link_up_handler(scic, &scic->port_agent,
+						 port, phy);
+		break;
+	default:
 		dev_dbg(scic_to_dev(scic),
 			"%s: SCIC Controller linkup event from phy %d in "
-			"unexpected state %d\n", __func__, sci_phy->phy_index,
-			state);
+			"unexpected state %d\n", __func__, phy->phy_index,
+			scic->state_machine.current_state_id);
+	}
 }
 
-
-void scic_sds_controller_link_down(
-	struct scic_sds_controller *scic,
-	struct scic_sds_port *sci_port,
-	struct scic_sds_phy *sci_phy)
+void scic_sds_controller_link_down(struct scic_sds_controller *scic,
+		struct scic_sds_port *port, struct scic_sds_phy *phy)
 {
-	u32 state;
-	scic_sds_controller_phy_handler_t link_down;
-
-	state = scic->state_machine.current_state_id;
-	link_down = scic_sds_controller_state_handler_table[state].link_down;
-
-	if (link_down)
-		link_down(scic, sci_port, sci_phy);
-	else
+	switch (scic->state_machine.current_state_id) {
+	case SCI_BASE_CONTROLLER_STATE_STARTING:
+	case SCI_BASE_CONTROLLER_STATE_READY:
+		scic->port_agent.link_down_handler(scic, &scic->port_agent,
+						   port, phy);
+		break;
+	default:
 		dev_dbg(scic_to_dev(scic),
 			"%s: SCIC Controller linkdown event from phy %d in "
 			"unexpected state %d\n",
 			__func__,
-			sci_phy->phy_index, state);
+			phy->phy_index,
+			scic->state_machine.current_state_id);
+	}
 }
 
 /**
@@ -1519,30 +1518,25 @@ static bool scic_sds_controller_has_remo
 /**
  * This method is called by the remote device to inform the controller
  * object that the remote device has stopped.
- *
  */
-
 void scic_sds_controller_remote_device_stopped(struct scic_sds_controller *scic,
 					       struct scic_sds_remote_device *sci_dev)
 {
-
-	u32 state;
-	scic_sds_controller_device_handler_t stopped;
-
-	state = scic->state_machine.current_state_id;
-	stopped = scic_sds_controller_state_handler_table[state].device_stopped;
-
-	if (stopped)
-		stopped(scic, sci_dev);
-	else {
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_STOPPING) {
 		dev_dbg(scic_to_dev(scic),
-			"%s: SCIC Controller 0x%p remote device stopped event "
-			"from device 0x%p in unexpected state  %d\n",
-			__func__, scic, sci_dev, state);
+			"SCIC Controller 0x%p remote device stopped event "
+			"from device 0x%p in unexpected state %d\n",
+			scic, sci_dev,
+			scic->state_machine.current_state_id);
+		return;
 	}
-}
-
 
+	if (!scic_sds_controller_has_remote_devices_stopping(scic)) {
+		sci_base_state_machine_change_state(&scic->state_machine,
+				SCI_BASE_CONTROLLER_STATE_STOPPED);
+	}
+}
 
 /**
  * This method will write to the SCU PCP register the request value. The method
@@ -1842,40 +1836,6 @@ static void scic_sds_controller_set_defa
 }
 
 /**
- * scic_controller_initialize() - This method will initialize the controller
- *    hardware managed by the supplied core controller object.  This method
- *    will bring the physical controller hardware out of reset and enable the
- *    core to determine the capabilities of the hardware being managed.  Thus,
- *    the core controller can determine it's exact physical (DMA capable)
- *    memory requirements.
- * @controller: This parameter specifies the controller to be initialized.
- *
- * The SCI Core user must have called scic_controller_construct() on the
- * supplied controller object previously. Indicate if the controller was
- * successfully initialized or if it failed in some way. SCI_SUCCESS This value
- * is returned if the controller hardware was successfully initialized.
- */
-enum sci_status scic_controller_initialize(
-	struct scic_sds_controller *scic)
-{
-	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	scic_sds_controller_handler_t initialize;
-	u32 state;
-
-	state = scic->state_machine.current_state_id;
-	initialize = scic_sds_controller_state_handler_table[state].initialize;
-
-	if (initialize)
-		status = initialize(scic);
-	else
-		dev_warn(scic_to_dev(scic),
-			 "%s: SCIC Controller initialize operation requested "
-			 "in invalid state %d\n",  __func__, state);
-
-	return status;
-}
-
-/**
  * scic_controller_get_suggested_start_timeout() - This method returns the
  *    suggested scic_controller_start() timeout amount.  The user is free to
  *    use any timeout value, but this method provides the suggested minimum
@@ -1914,49 +1874,6 @@ u32 scic_controller_get_suggested_start_
 }
 
 /**
- * scic_controller_start() - This method will start the supplied core
- *    controller.  This method will start the staggered spin up operation.  The
- *    SCI User completion callback is called when the following conditions are
- *    met: -# the return status of this method is SCI_SUCCESS. -# after all of
- *    the phys have successfully started or been given the opportunity to start.
- * @controller: the handle to the controller object to start.
- * @timeout: This parameter specifies the number of milliseconds in which the
- *    start operation should complete.
- *
- * The SCI Core user must have filled in the physical memory descriptor
- * structure via the sci_controller_get_memory_descriptor_list() method. The
- * SCI Core user must have invoked the scic_controller_initialize() method
- * prior to invoking this method. The controller must be in the INITIALIZED or
- * STARTED state. Indicate if the controller start method succeeded or failed
- * in some way. SCI_SUCCESS if the start operation succeeded.
- * SCI_WARNING_ALREADY_IN_STATE if the controller is already in the STARTED
- * state. SCI_FAILURE_INVALID_STATE if the controller is not either in the
- * INITIALIZED or STARTED states. SCI_FAILURE_INVALID_MEMORY_DESCRIPTOR if
- * there are inconsistent or invalid values in the supplied
- * struct sci_physical_memory_descriptor array.
- */
-enum sci_status scic_controller_start(
-	struct scic_sds_controller *scic,
-	u32 timeout)
-{
-	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	scic_sds_controller_timed_handler_t start;
-	u32 state;
-
-	state = scic->state_machine.current_state_id;
-	start = scic_sds_controller_state_handler_table[state].start;
-
-	if (start)
-		status = start(scic, timeout);
-	else
-		dev_warn(scic_to_dev(scic),
-			 "%s: SCIC Controller start operation requested in "
-			 "invalid state %d\n", __func__, state);
-
-	return status;
-}
-
-/**
  * scic_controller_stop() - This method will stop an individual controller
  *    object.This method will invoke the associated user callback upon
  *    completion.  The completion callback is called when the following
@@ -1978,21 +1895,18 @@ enum sci_status scic_controller_stop(
 	struct scic_sds_controller *scic,
 	u32 timeout)
 {
-	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	scic_sds_controller_timed_handler_t stop;
-	u32 state;
-
-	state = scic->state_machine.current_state_id;
-	stop = scic_sds_controller_state_handler_table[state].stop;
-
-	if (stop)
-		status = stop(scic, timeout);
-	else
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_READY) {
 		dev_warn(scic_to_dev(scic),
-			 "%s: SCIC Controller stop operation requested in "
-			 "invalid state %d\n", __func__, state);
+			 "SCIC Controller stop operation requested in "
+			 "invalid state\n");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 
-	return status;
+	isci_timer_start(scic->timeout_timer, timeout);
+	sci_base_state_machine_change_state(&scic->state_machine,
+					    SCI_BASE_CONTROLLER_STATE_STOPPING);
+	return SCI_SUCCESS;
 }
 
 /**
@@ -2010,21 +1924,24 @@ enum sci_status scic_controller_stop(
 enum sci_status scic_controller_reset(
 	struct scic_sds_controller *scic)
 {
-	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	scic_sds_controller_handler_t reset;
-	u32 state;
-
-	state = scic->state_machine.current_state_id;
-	reset = scic_sds_controller_state_handler_table[state].reset;
-
-	if (reset)
-		status = reset(scic);
-	else
+	switch (scic->state_machine.current_state_id) {
+	case SCI_BASE_CONTROLLER_STATE_RESET:
+	case SCI_BASE_CONTROLLER_STATE_READY:
+	case SCI_BASE_CONTROLLER_STATE_STOPPED:
+	case SCI_BASE_CONTROLLER_STATE_FAILED:
+		/*
+		 * The reset operation is not a graceful cleanup, just
+		 * perform the state transition.
+		 */
+		sci_base_state_machine_change_state(&scic->state_machine,
+				SCI_BASE_CONTROLLER_STATE_RESETTING);
+		return SCI_SUCCESS;
+	default:
 		dev_warn(scic_to_dev(scic),
-			 "%s: SCIC Controller reset operation requested in "
-			 "invalid state %d\n",  __func__, state);
-
-	return status;
+			 "SCIC Controller reset operation requested in "
+			 "invalid state\n");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 }
 
 /**
@@ -2056,19 +1973,25 @@ enum sci_status scic_controller_reset(
  */
 enum sci_io_status scic_controller_start_io(
 	struct scic_sds_controller *scic,
-	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *request,
+	struct scic_sds_remote_device *rdev,
+	struct scic_sds_request *req,
 	u16 io_tag)
 {
-	u32 state;
-	scic_sds_controller_start_request_handler_t start_io;
+	enum sci_status status;
 
-	state = scic->state_machine.current_state_id;
-	start_io = scic_sds_controller_state_handler_table[state].start_io;
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_READY) {
+		dev_warn(scic_to_dev(scic), "invalid state to start I/O");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 
-	return start_io(scic,
-			(struct sci_base_remote_device *) remote_device,
-			request, io_tag);
+	status = scic_sds_remote_device_start_io(scic, rdev, req);
+	if (status != SCI_SUCCESS)
+		return status;
+
+	scic->io_request_table[scic_sds_io_tag_get_index(req->io_tag)] = req;
+	scic_sds_controller_post_request(scic, scic_sds_request_get_post_context(req));
+	return SCI_SUCCESS;
 }
 
 /**
@@ -2089,18 +2012,30 @@ enum sci_io_status scic_controller_start
  */
 enum sci_status scic_controller_terminate_request(
 	struct scic_sds_controller *scic,
-	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *request)
+	struct scic_sds_remote_device *rdev,
+	struct scic_sds_request *req)
 {
-	scic_sds_controller_request_handler_t terminate_request;
-	u32 state;
+	enum sci_status status;
 
-	state = scic->state_machine.current_state_id;
-	terminate_request = scic_sds_controller_state_handler_table[state].terminate_request;
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_READY) {
+		dev_warn(scic_to_dev(scic),
+			 "invalid state to terminate request\n");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 
-	return terminate_request(scic,
-				 (struct sci_base_remote_device *)remote_device,
-				 request);
+	status = scic_sds_io_request_terminate(req);
+	if (status != SCI_SUCCESS)
+		return status;
+
+	/*
+	 * Utilize the original post context command and or in the POST_TC_ABORT
+	 * request sub-type.
+	 */
+	scic_sds_controller_post_request(scic,
+		scic_sds_request_get_post_context(req) |
+		SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT);
+	return SCI_SUCCESS;
 }
 
 /**
@@ -2127,18 +2062,44 @@ enum sci_status scic_controller_terminat
  */
 enum sci_status scic_controller_complete_io(
 	struct scic_sds_controller *scic,
-	struct scic_sds_remote_device *remote_device,
+	struct scic_sds_remote_device *rdev,
 	struct scic_sds_request *request)
 {
-	u32 state;
-	scic_sds_controller_request_handler_t complete_io;
+	enum sci_status status;
+	u16 index;
+
+	switch (scic->state_machine.current_state_id) {
+	case SCI_BASE_CONTROLLER_STATE_STOPPING:
+		/* XXX: Implement this function */
+		return SCI_FAILURE;
+	case SCI_BASE_CONTROLLER_STATE_READY:
+		status = scic_sds_remote_device_complete_io(scic, rdev, request);
+		if (status != SCI_SUCCESS)
+			return status;
+
+		index = scic_sds_io_tag_get_index(request->io_tag);
+		scic->io_request_table[index] = NULL;
+		return SCI_SUCCESS;
+	default:
+		dev_warn(scic_to_dev(scic), "invalid state to complete I/O");
+		return SCI_FAILURE_INVALID_STATE;
+	}
+
+}
+
+enum sci_status scic_controller_continue_io(struct scic_sds_request *sci_req)
+{
+	struct scic_sds_controller *scic = sci_req->owning_controller;
 
-	state = scic->state_machine.current_state_id;
-	complete_io = scic_sds_controller_state_handler_table[state].complete_io;
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_READY) {
+		dev_warn(scic_to_dev(scic), "invalid state to continue I/O");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 
-	return complete_io(scic,
-			   (struct sci_base_remote_device *)remote_device,
-			   request);
+	scic->io_request_table[scic_sds_io_tag_get_index(sci_req->io_tag)] = sci_req;
+	scic_sds_controller_post_request(scic, scic_sds_request_get_post_context(sci_req));
+	return SCI_SUCCESS;
 }
 
 /**
@@ -2171,71 +2132,45 @@ enum sci_status scic_controller_complete
  */
 enum sci_task_status scic_controller_start_task(
 	struct scic_sds_controller *scic,
-	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *task_request,
+	struct scic_sds_remote_device *rdev,
+	struct scic_sds_request *req,
 	u16 task_tag)
 {
-	u32 state;
-	scic_sds_controller_start_request_handler_t start_task;
-	enum sci_task_status status = SCI_TASK_FAILURE_INVALID_STATE;
-
-	state = scic->state_machine.current_state_id;
-	start_task = scic_sds_controller_state_handler_table[state].start_task;
-
-	if (start_task)
-		status = start_task(scic,
-				    (struct sci_base_remote_device *)remote_device,
-				    task_request,
-				    task_tag);
-	else
+	enum sci_status status;
+
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_READY) {
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller starting task from invalid "
 			 "state\n",
 			 __func__);
+		return SCI_TASK_FAILURE_INVALID_STATE;
+	}
 
-	return status;
-}
+	status = scic_sds_remote_device_start_task(scic, rdev, req);
+	switch (status) {
+	case SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS:
+		scic->io_request_table[scic_sds_io_tag_get_index(req->io_tag)] = req;
 
-/**
- * scic_controller_complete_task() - This method will perform core specific
- *    completion operations for task management request. After this method is
- *    invoked, the user should consider the task request as invalid until it is
- *    properly reused (i.e. re-constructed).
- * @controller: The handle to the controller object for which to complete the
- *    task management request.
- * @remote_device: The handle to the remote device object for which to complete
- *    the task management request.
- * @task_request: the handle to the task management request object to complete.
- *
- * Indicate if the controller successfully completed the task management
- * request. SCI_SUCCESS if the completion process was successful.
- */
-enum sci_status scic_controller_complete_task(
-	struct scic_sds_controller *scic,
-	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *task_request)
-{
-	u32 state;
-	scic_sds_controller_request_handler_t complete_task;
-	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-
-	state = scic->state_machine.current_state_id;
-	complete_task = scic_sds_controller_state_handler_table[state].complete_task;
-
-	if (complete_task)
-		status = complete_task(scic,
-				       (struct sci_base_remote_device *)remote_device,
-				       task_request);
-	else
-		dev_warn(scic_to_dev(scic),
-			 "%s: SCIC Controller completing task from invalid "
-			 "state\n",
-			 __func__);
+		/*
+		 * We will let framework know this task request started successfully,
+		 * although core is still woring on starting the request (to post tc when
+		 * RNC is resumed.)
+		 */
+		return SCI_SUCCESS;
+	case SCI_SUCCESS:
+		scic->io_request_table[scic_sds_io_tag_get_index(req->io_tag)] = req;
+
+		scic_sds_controller_post_request(scic,
+			scic_sds_request_get_post_context(req));
+		break;
+	default:
+		break;
+	}
 
 	return status;
 }
 
-
 /**
  * scic_controller_get_port_handle() - This method simply provides the user
  *    with a unique handle for a given SAS/SATA core port index.
@@ -2707,52 +2642,23 @@ struct scic_sds_controller *scic_control
 	return devm_kzalloc(dev, sizeof(struct scic_sds_controller), GFP_KERNEL);
 }
 
-static enum sci_status
-default_controller_handler(struct scic_sds_controller *scic, const char *func)
-{
-	dev_warn(scic_to_dev(scic), "%s: invalid state %d\n", func,
-		 scic->state_machine.current_state_id);
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-static enum sci_status scic_sds_controller_default_start_operation_handler(
-	struct scic_sds_controller *scic,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request,
-	u16 io_tag)
-{
-	return default_controller_handler(scic, __func__);
-}
-
-static enum sci_status scic_sds_controller_default_request_handler(
-	struct scic_sds_controller *scic,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request)
-{
-	return default_controller_handler(scic, __func__);
-}
-
-static enum sci_status
-scic_sds_controller_general_reset_handler(struct scic_sds_controller *scic)
-{
-	/* The reset operation is not a graceful cleanup just perform the state
-	 * transition.
-	 */
-	sci_base_state_machine_change_state(&scic->state_machine,
-					    SCI_BASE_CONTROLLER_STATE_RESETTING);
-
-	return SCI_SUCCESS;
-}
-
-static enum sci_status
-scic_sds_controller_reset_state_initialize_handler(struct scic_sds_controller *scic)
+enum sci_status scic_controller_initialize(
+	struct scic_sds_controller *scic)
 {
 	struct sci_base_state_machine *sm = &scic->state_machine;
 	enum sci_status result = SCI_SUCCESS;
 	struct isci_host *ihost;
 	u32 index, state;
 
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_RESET) {
+		dev_warn(scic_to_dev(scic),
+			 "SCIC Controller initialize operation requested "
+			 "in invalid state\n");
+		return SCI_FAILURE_INVALID_STATE;
+	}
+
+
 	ihost = sci_object_get_association(scic);
 
 	sci_base_state_machine_change_state(sm, SCI_BASE_CONTROLLER_STATE_INITIALIZING);
@@ -2909,30 +2815,19 @@ scic_sds_controller_reset_state_initiali
 	return result;
 }
 
-/*
- * *****************************************************************************
- * * INITIALIZED STATE HANDLERS
- * ***************************************************************************** */
-
-/*
- * This function is the struct scic_sds_controller start handler for the
- * initialized state.
- * - Validate we have a good memory descriptor table - Initialze the
- * physical memory before programming the hardware - Program the SCU hardware
- * with the physical memory addresses passed in the memory descriptor table. -
- * Initialzie the TCi pool - Initialize the RNi pool - Initialize the
- * completion queue - Initialize the unsolicited frame data - Take the SCU port
- * task scheduler out of reset - Start the first phy object. - Transition to
- * SCI_BASE_CONTROLLER_STATE_STARTING. enum sci_status SCI_SUCCESS if all of the
- * controller start operations complete
- * SCI_FAILURE_UNSUPPORTED_INFORMATION_FIELD if one or more of the memory
- * descriptor fields is invalid.
- */
-static enum sci_status scic_sds_controller_initialized_state_start_handler(
-	struct scic_sds_controller *scic, u32 timeout)
+enum sci_status scic_controller_start(struct scic_sds_controller *scic,
+		u32 timeout)
 {
-	u16 index;
 	enum sci_status result;
+	u16 index;
+
+	if (scic->state_machine.current_state_id !=
+	    SCI_BASE_CONTROLLER_STATE_INITIALIZED) {
+		dev_warn(scic_to_dev(scic),
+			 "SCIC Controller start operation requested in "
+			 "invalid state\n");
+		return SCI_FAILURE_INVALID_STATE;
+	}
 
 	result = scic_sds_controller_ram_initialization(scic);
 	if (result)
@@ -2986,376 +2881,6 @@ static enum sci_status scic_sds_controll
 	return SCI_SUCCESS;
 }
 
-/*
- * *****************************************************************************
- * * INITIALIZED STATE HANDLERS
- * ***************************************************************************** */
-
-/**
- *
- * @controller: This is struct scic_sds_controller which receives the link up
- *    notification.
- * @port: This is struct scic_sds_port with which the phy is associated.
- * @phy: This is the struct scic_sds_phy which has gone link up.
- *
- * This method is called when the struct scic_sds_controller is in the starting state
- * link up handler is called.  This method will perform the following: - Stop
- * the phy timer - Start the next phy - Report the link up condition to the
- * port object none
- */
-static void scic_sds_controller_starting_state_link_up_handler(
-	struct scic_sds_controller *this_controller,
-	struct scic_sds_port *port,
-	struct scic_sds_phy *phy)
-{
-	scic_sds_controller_phy_timer_stop(this_controller);
-
-	this_controller->port_agent.link_up_handler(
-		this_controller, &this_controller->port_agent, port, phy
-		);
-	/* scic_sds_port_link_up(port, phy); */
-
-	scic_sds_controller_start_next_phy(this_controller);
-}
-
-/**
- *
- * @controller: This is struct scic_sds_controller which receives the link down
- *    notification.
- * @port: This is struct scic_sds_port with which the phy is associated.
- * @phy: This is the struct scic_sds_phy which has gone link down.
- *
- * This method is called when the struct scic_sds_controller is in the starting state
- * link down handler is called. - Report the link down condition to the port
- * object none
- */
-static void scic_sds_controller_starting_state_link_down_handler(
-	struct scic_sds_controller *this_controller,
-	struct scic_sds_port *port,
-	struct scic_sds_phy *phy)
-{
-	this_controller->port_agent.link_down_handler(
-		this_controller, &this_controller->port_agent, port, phy
-		);
-	/* scic_sds_port_link_down(port, phy); */
-}
-
-static enum sci_status scic_sds_controller_ready_state_stop_handler(
-		struct scic_sds_controller *scic,
-		u32 timeout)
-{
-	isci_timer_start(scic->timeout_timer, timeout);
-	sci_base_state_machine_change_state(&scic->state_machine,
-					    SCI_BASE_CONTROLLER_STATE_STOPPING);
-	return SCI_SUCCESS;
-}
-
-/*
- * This method is called when the struct scic_sds_controller is in the ready state and
- * the start io handler is called. - Start the io request on the remote device
- * - if successful - assign the io_request to the io_request_table - post the
- * request to the hardware enum sci_status SCI_SUCCESS if the start io operation
- * succeeds SCI_FAILURE_INSUFFICIENT_RESOURCES if the IO tag could not be
- * allocated for the io request. SCI_FAILURE_INVALID_STATE if one or more
- * objects are not in a valid state to accept io requests.
- *
- * XXX: How does the io_tag parameter get assigned to the io request?
- */
-static enum sci_status scic_sds_controller_ready_state_start_io_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request,
-	u16 io_tag)
-{
-	enum sci_status status;
-
-	struct scic_sds_remote_device *the_device;
-
-	the_device = (struct scic_sds_remote_device *)remote_device;
-
-	status = scic_sds_remote_device_start_io(controller, the_device, request);
-
-	if (status != SCI_SUCCESS)
-		return status;
-
-	controller->io_request_table[
-		scic_sds_io_tag_get_index(request->io_tag)] = request;
-	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(request));
-	return SCI_SUCCESS;
-}
-
-/*
- * This method is called when the struct scic_sds_controller is in the ready state and
- * the complete io handler is called. - Complete the io request on the remote
- * device - if successful - remove the io_request to the io_request_table
- * enum sci_status SCI_SUCCESS if the start io operation succeeds
- * SCI_FAILURE_INVALID_STATE if one or more objects are not in a valid state to
- * accept io requests.
- */
-static enum sci_status scic_sds_controller_ready_state_complete_io_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request)
-{
-	u16 index;
-	enum sci_status status;
-	struct scic_sds_remote_device *the_device;
-
-	the_device = (struct scic_sds_remote_device *)remote_device;
-
-	status = scic_sds_remote_device_complete_io(controller, the_device,
-			request);
-	if (status != SCI_SUCCESS)
-		return status;
-
-	index = scic_sds_io_tag_get_index(request->io_tag);
-	controller->io_request_table[index] = NULL;
-	return SCI_SUCCESS;
-}
-
-/*
- * This method is called when the struct scic_sds_controller is in the ready state and
- * the continue io handler is called. enum sci_status
- */
-static enum sci_status scic_sds_controller_ready_state_continue_io_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request)
-{
-	controller->io_request_table[
-		scic_sds_io_tag_get_index(request->io_tag)] = request;
-	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(request));
-	return SCI_SUCCESS;
-}
-
-/*
- * This method is called when the struct scic_sds_controller is in the ready state and
- * the start task handler is called. - The remote device is requested to start
- * the task request - if successful - assign the task to the io_request_table -
- * post the request to the SCU hardware enum sci_status SCI_SUCCESS if the start io
- * operation succeeds SCI_FAILURE_INSUFFICIENT_RESOURCES if the IO tag could
- * not be allocated for the io request. SCI_FAILURE_INVALID_STATE if one or
- * more objects are not in a valid state to accept io requests. How does the io
- * tag get assigned in this code path?
- */
-static enum sci_status scic_sds_controller_ready_state_start_task_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request,
-	u16 task_tag)
-{
-	struct scic_sds_remote_device *the_device      = (struct scic_sds_remote_device *)
-						    remote_device;
-	enum sci_status status;
-
-	status = scic_sds_remote_device_start_task(controller, the_device,
-			request);
-
-	if (status == SCI_SUCCESS) {
-		controller->io_request_table[
-			scic_sds_io_tag_get_index(request->io_tag)] = request;
-
-		scic_sds_controller_post_request(controller,
-			scic_sds_request_get_post_context(request));
-	} else if (status == SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS) {
-		controller->io_request_table[
-			scic_sds_io_tag_get_index(request->io_tag)] = request;
-
-		/*
-		 * We will let framework know this task request started successfully,
-		 * although core is still woring on starting the request (to post tc when
-		 * RNC is resumed.) */
-		status = SCI_SUCCESS;
-	}
-	return status;
-}
-
-/*
- * This method is called when the struct scic_sds_controller is in the ready state and
- * the terminate request handler is called. - call the io request terminate
- * function - if successful - post the terminate request to the SCU hardware
- * enum sci_status SCI_SUCCESS if the start io operation succeeds
- * SCI_FAILURE_INVALID_STATE if one or more objects are not in a valid state to
- * accept io requests.
- */
-static enum sci_status scic_sds_controller_ready_state_terminate_request_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request)
-{
-	enum sci_status status;
-
-	status = scic_sds_io_request_terminate(request);
-	if (status != SCI_SUCCESS)
-		return status;
-
-	/*
-	 * Utilize the original post context command and or in the POST_TC_ABORT
-	 * request sub-type.
-	 */
-	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(request) |
-		SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT);
-	return SCI_SUCCESS;
-}
-
-/**
- *
- * @controller: This is struct scic_sds_controller which receives the link up
- *    notification.
- * @port: This is struct scic_sds_port with which the phy is associated.
- * @phy: This is the struct scic_sds_phy which has gone link up.
- *
- * This method is called when the struct scic_sds_controller is in the starting state
- * link up handler is called.  This method will perform the following: - Stop
- * the phy timer - Start the next phy - Report the link up condition to the
- * port object none
- */
-static void scic_sds_controller_ready_state_link_up_handler(
-	struct scic_sds_controller *this_controller,
-	struct scic_sds_port *port,
-	struct scic_sds_phy *phy)
-{
-	this_controller->port_agent.link_up_handler(
-		this_controller, &this_controller->port_agent, port, phy
-		);
-}
-
-/**
- *
- * @controller: This is struct scic_sds_controller which receives the link down
- *    notification.
- * @port: This is struct scic_sds_port with which the phy is associated.
- * @phy: This is the struct scic_sds_phy which has gone link down.
- *
- * This method is called when the struct scic_sds_controller is in the starting state
- * link down handler is called. - Report the link down condition to the port
- * object none
- */
-static void scic_sds_controller_ready_state_link_down_handler(
-	struct scic_sds_controller *this_controller,
-	struct scic_sds_port *port,
-	struct scic_sds_phy *phy)
-{
-	this_controller->port_agent.link_down_handler(
-		this_controller, &this_controller->port_agent, port, phy
-		);
-}
-
-/*
- * *****************************************************************************
- * * STOPPING STATE HANDLERS
- * ***************************************************************************** */
-
-/**
- * This method is called when the struct scic_sds_controller is in a stopping state
- * and the complete io handler is called. - This function is not yet
- * implemented enum sci_status SCI_FAILURE
- */
-static enum sci_status scic_sds_controller_stopping_state_complete_io_handler(
-	struct scic_sds_controller *controller,
-	struct sci_base_remote_device *remote_device,
-	struct scic_sds_request *request)
-{
-	/* XXX: Implement this function */
-	return SCI_FAILURE;
-}
-
-/**
- * This method is called when the struct scic_sds_controller is in a stopping state
- * and the remote device has stopped.
- **/
-static void scic_sds_controller_stopping_state_device_stopped_handler(
-	struct scic_sds_controller *controller,
-	struct scic_sds_remote_device *remote_device
-)
-{
-	if (!scic_sds_controller_has_remote_devices_stopping(controller)) {
-		sci_base_state_machine_change_state(&controller->state_machine,
-			SCI_BASE_CONTROLLER_STATE_STOPPED
-		);
-	}
-}
-
-const struct scic_sds_controller_state_handler scic_sds_controller_state_handler_table[] = {
-	[SCI_BASE_CONTROLLER_STATE_INITIAL] = {
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_RESET] = {
-		.reset        = scic_sds_controller_general_reset_handler,
-		.initialize   = scic_sds_controller_reset_state_initialize_handler,
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_INITIALIZING] = {
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_INITIALIZED] = {
-		.start        = scic_sds_controller_initialized_state_start_handler,
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_STARTING] = {
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-		.link_up           = scic_sds_controller_starting_state_link_up_handler,
-		.link_down	   = scic_sds_controller_starting_state_link_down_handler
-	},
-	[SCI_BASE_CONTROLLER_STATE_READY] = {
-		.stop         = scic_sds_controller_ready_state_stop_handler,
-		.reset        = scic_sds_controller_general_reset_handler,
-		.start_io     = scic_sds_controller_ready_state_start_io_handler,
-		.complete_io  = scic_sds_controller_ready_state_complete_io_handler,
-		.continue_io  = scic_sds_controller_ready_state_continue_io_handler,
-		.start_task   = scic_sds_controller_ready_state_start_task_handler,
-		.complete_task = scic_sds_controller_ready_state_complete_io_handler,
-		.terminate_request = scic_sds_controller_ready_state_terminate_request_handler,
-		.link_up           = scic_sds_controller_ready_state_link_up_handler,
-		.link_down	   = scic_sds_controller_ready_state_link_down_handler
-	},
-	[SCI_BASE_CONTROLLER_STATE_RESETTING] = {
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_STOPPING] = {
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_stopping_state_complete_io_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-		.device_stopped    = scic_sds_controller_stopping_state_device_stopped_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_STOPPED] = {
-		.reset        = scic_sds_controller_general_reset_handler,
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-	[SCI_BASE_CONTROLLER_STATE_FAILED] = {
-		.reset        = scic_sds_controller_general_reset_handler,
-		.start_io     = scic_sds_controller_default_start_operation_handler,
-		.complete_io  = scic_sds_controller_default_request_handler,
-		.continue_io  = scic_sds_controller_default_request_handler,
-		.terminate_request = scic_sds_controller_default_request_handler,
-	},
-};
-
 /**
  *
  * @object: This is the struct sci_base_object which is cast to a struct scic_sds_controller
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.h	2011-04-02 05:00:05.276235985 -0700
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h	2011-04-02 05:03:52.608268533 -0700
@@ -430,90 +430,6 @@ enum scic_sds_controller_states {
 
 };
 
-typedef enum sci_status (*scic_sds_controller_handler_t)
-				(struct scic_sds_controller *);
-typedef enum sci_status (*scic_sds_controller_timed_handler_t)
-				(struct scic_sds_controller *, u32);
-typedef enum sci_status (*scic_sds_controller_request_handler_t)
-				(struct scic_sds_controller *,
-				 struct sci_base_remote_device *,
-				 struct scic_sds_request *);
-typedef enum sci_status (*scic_sds_controller_start_request_handler_t)
-				(struct scic_sds_controller *,
-				 struct sci_base_remote_device *,
-				 struct scic_sds_request *, u16);
-typedef void (*scic_sds_controller_phy_handler_t)
-				(struct scic_sds_controller *,
-				 struct scic_sds_port *,
-				 struct scic_sds_phy *);
-typedef void (*scic_sds_controller_device_handler_t)
-				(struct scic_sds_controller *,
-				 struct scic_sds_remote_device *);
-
-struct scic_sds_controller_state_handler {
-	/**
-	 * The start_handler specifies the method invoked when a user attempts to
-	 * start a controller.
-	 */
-	scic_sds_controller_timed_handler_t start;
-
-	/**
-	 * The stop_handler specifies the method invoked when a user attempts to
-	 * stop a controller.
-	 */
-	scic_sds_controller_timed_handler_t stop;
-
-	/**
-	 * The reset_handler specifies the method invoked when a user attempts to
-	 * reset a controller.
-	 */
-	scic_sds_controller_handler_t reset;
-
-	/**
-	 * The initialize_handler specifies the method invoked when a user
-	 * attempts to initialize a controller.
-	 */
-	scic_sds_controller_handler_t initialize;
-
-	/**
-	 * The start_io_handler specifies the method invoked when a user
-	 * attempts to start an IO request for a controller.
-	 */
-	scic_sds_controller_start_request_handler_t start_io;
-
-	/**
-	 * The complete_io_handler specifies the method invoked when a user
-	 * attempts to complete an IO request for a controller.
-	 */
-	scic_sds_controller_request_handler_t complete_io;
-
-	/**
-	 * The continue_io_handler specifies the method invoked when a user
-	 * attempts to continue an IO request for a controller.
-	 */
-	scic_sds_controller_request_handler_t continue_io;
-
-	/**
-	 * The start_task_handler specifies the method invoked when a user
-	 * attempts to start a task management request for a controller.
-	 */
-	scic_sds_controller_start_request_handler_t start_task;
-
-	/**
-	 * The complete_task_handler specifies the method invoked when a user
-	 * attempts to complete a task management request for a controller.
-	 */
-	scic_sds_controller_request_handler_t complete_task;
-
-	scic_sds_controller_request_handler_t terminate_request;
-	scic_sds_controller_phy_handler_t link_up;
-	scic_sds_controller_phy_handler_t link_down;
-	scic_sds_controller_device_handler_t device_stopped;
-};
-
-extern const struct scic_sds_controller_state_handler
-	scic_sds_controller_state_handler_table[];
-
 /**
  * INCREMENT_QUEUE_GET() -
  *
@@ -676,4 +592,6 @@ void scic_sds_controller_copy_task_conte
 void scic_sds_controller_register_setup(
 	struct scic_sds_controller *this_controller);
 
+enum sci_status scic_controller_continue_io(struct scic_sds_request *sci_req);
+
 #endif /* _SCIC_SDS_CONTROLLER_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-04-02 04:58:56.000000000 -0700
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-04-02 05:03:52.612262578 -0700
@@ -558,17 +558,10 @@ void scic_sds_remote_device_start_reques
 void scic_sds_remote_device_continue_request(void *dev)
 {
 	struct scic_sds_remote_device *sci_dev = dev;
-	struct scic_sds_request *sci_req = sci_dev->working_request;
 
 	/* we need to check if this request is still valid to continue. */
-	if (sci_req) {
-		struct scic_sds_controller *scic = sci_req->owning_controller;
-		u32 state = scic->state_machine.current_state_id;
-		scic_sds_controller_request_handler_t continue_io;
-
-		continue_io = scic_sds_controller_state_handler_table[state].continue_io;
-		continue_io(scic, &sci_req->target_device->parent, sci_req);
-	}
+	if (sci_dev->working_request)
+		scic_controller_continue_io(sci_dev->working_request);
 }
 
 /**
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-04-02 04:58:56.000000000 -0700
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-04-02 05:03:52.620238248 -0700
@@ -637,10 +637,7 @@ static enum sci_status scic_sds_stp_requ
 	u32 length)
 {
 	struct scic_sds_stp_request *this_sds_stp_request = (struct scic_sds_stp_request *)this_request;
-	scic_sds_controller_request_handler_t continue_io;
 	struct scu_sgl_element *current_sgl;
-	struct scic_sds_controller *scic;
-	u32 state;
 
 	/*
 	 * Recycle the TC and reconstruct it for sending out DATA FIS containing
@@ -662,10 +659,7 @@ static enum sci_status scic_sds_stp_requ
 	task_context->type.stp.fis_type = SATA_FIS_TYPE_DATA;
 
 	/* send the new TC out. */
-	scic = this_request->owning_controller;
-	state = scic->state_machine.current_state_id;
-	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
-	return continue_io(scic, &this_request->target_device->parent, this_request);
+	return scic_controller_continue_io(this_request);
 }
 
 /**
@@ -1758,12 +1752,9 @@ static void scic_sds_stp_request_started
 	struct sci_base_object *object)
 {
 	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
-	scic_sds_controller_request_handler_t continue_io;
 	struct scu_task_context *task_context;
 	struct sata_fis_reg_h2d *h2d_fis;
-	struct scic_sds_controller *scic;
 	enum sci_status status;
-	u32 state;
 
 	/* Clear the SRST bit */
 	h2d_fis = scic_stp_io_request_get_h2d_reg_address(this_request);
@@ -1774,12 +1765,7 @@ static void scic_sds_stp_request_started
 		this_request->owning_controller, this_request->io_tag);
 	task_context->control_frame = 0;
 
-	scic = this_request->owning_controller;
-	state = scic->state_machine.current_state_id;
-	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
-
-	status = continue_io(scic, &this_request->target_device->parent, this_request);
-
+	status = scic_controller_continue_io(this_request);
 	if (status == SCI_SUCCESS) {
 		SET_STATE_HANDLER(
 			this_request,
Index: linux-2.6/drivers/scsi/isci/task.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/task.c	2011-04-02 04:58:56.202735448 -0700
+++ linux-2.6/drivers/scsi/isci/task.c	2011-04-02 05:03:52.624236114 -0700
@@ -1480,7 +1480,7 @@ void isci_task_request_complete(
 	/* PRINT_TMF( ((struct isci_tmf *)request->task)); */
 	tmf_complete = tmf->complete;
 
-	scic_controller_complete_task(
+	scic_controller_complete_io(
 		isci_host->core_controller,
 		to_sci_dev(isci_device),
 		request->sci_request_handle
