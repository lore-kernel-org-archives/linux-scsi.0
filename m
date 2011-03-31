From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] isci: simplify request state handlers
Date: Thu, 31 Mar 2011 11:06:16 -0400
Message-ID: <20110331150616.GB8497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1CaPGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 11:06:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Instead of filling up tables with default handlers call the default
handler in the only caller.

IMHO the whole state handlers concept is not very suitable for the
isci request.  For example there is a single real instance of the
start handler, and we'd be much better off just having a check for
the right state in the only caller, than all this mess.  It's
quite similar for the abort handler as well.

Even the actual state machine has a lot of states that are rather
pointless.  The initial and constructed states are not needed at all
as the request is not reachable for calls before it's fully set up and
started.  And the abort state should be replaced with an abort actions
and a state transition to the completed state.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/scic_sds_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_request.c	2011-03-30 23:26:08.024660204 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_request.c	2011-03-31 00:10:51.991415307 +0200
@@ -874,67 +874,93 @@ u32 scic_io_request_get_number_of_bytes_
  * * SCIC SDS Interface Implementation
  * **************************************************************************** */
 
-/**
- *
- * @this_request: The SCIC_SDS_IO_REQUEST_T object for which the start
- *    operation is to be executed.
- *
- * This method invokes the base state start request handler for the
- * SCIC_SDS_IO_REQUEST_T object. enum sci_status
- */
 enum sci_status
 scic_sds_request_start(struct scic_sds_request *request)
 {
-	if (request->device_sequence ==
+	if (request->device_sequence !=
 	    scic_sds_remote_device_get_sequence(request->target_device))
+		return SCI_FAILURE;
+
+    	if (request->state_handlers->start_handler)
 		return request->state_handlers->start_handler(request);
-	return SCI_FAILURE;
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		 "%s: SCIC IO Request requested to start while in wrong "
+		 "state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(&request->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- *
- * @this_request: The SCIC_SDS_IO_REQUEST_T object for which the start
- *    operation is to be executed.
- *
- * This method invokes the base state terminate request handber for the
- * SCIC_SDS_IO_REQUEST_T object. enum sci_status
- */
 enum sci_status
 scic_sds_io_request_terminate(struct scic_sds_request *request)
 {
-	return request->state_handlers->abort_handler(request);
+	if (request->state_handlers->abort_handler)
+		return request->state_handlers->abort_handler(request);
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		"%s: SCIC IO Request requested to abort while in wrong "
+		"state %d\n",
+		__func__,
+		sci_base_state_machine_get_state(&request->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- *
- * @this_request: The SCIC_SDS_IO_REQUEST_T object for which the start
- *    operation is to be executed.
- *
- * This method invokes the base state request completion handler for the
- * SCIC_SDS_IO_REQUEST_T object. enum sci_status
- */
 enum sci_status
 scic_sds_io_request_complete(struct scic_sds_request *request)
 {
-	return request->state_handlers->complete_handler(request);
+	if (request->state_handlers->complete_handler)
+		return request->state_handlers->complete_handler(request);
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		"%s: SCIC IO Request requested to complete while in wrong "
+		"state %d\n",
+		__func__,
+		sci_base_state_machine_get_state(&request->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- *
- * @this_request: The SCIC_SDS_IO_REQUEST_T object for which the start
- *    operation is to be executed.
- * @event_code: The event code returned by the hardware for the task reqeust.
- *
- * This method invokes the core state handler for the SCIC_SDS_IO_REQUEST_T
- * object. enum sci_status
- */
 enum sci_status scic_sds_io_request_event_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 event_code)
 {
-	return this_request->state_handlers->event_handler(this_request, event_code);
+	if (request->state_handlers->event_handler)
+		return request->state_handlers->event_handler(request, event_code);
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		 "%s: SCIC IO Request given event code notification %x while "
+		 "in wrong state %d\n",
+		 __func__,
+		 event_code,
+		 sci_base_state_machine_get_state(&request->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
 }
 
+enum sci_status
+scic_sds_io_request_tc_completion(struct scic_sds_request *request, u32 completion_code)
+{
+	if (request->state_machine.current_state_id == SCI_BASE_REQUEST_STATE_STARTED &&
+	    request->has_started_substate_machine == false)
+		return scic_sds_request_started_state_tc_completion_handler(request, completion_code);
+	else if (request->state_handlers->tc_completion_handler)
+		return request->state_handlers->tc_completion_handler(request, completion_code);
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		"%s: SCIC IO Request given task completion notification %x "
+		"while in wrong state %d\n",
+		__func__,
+		completion_code,
+		sci_base_state_machine_get_state(&request->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
+
+}
+
+
 /**
  *
  * @this_request: The SCIC_SDS_IO_REQUEST_T object for which the start
@@ -946,10 +972,21 @@ enum sci_status scic_sds_io_request_even
  * SCIC_SDS_IO_REQUEST_T object. enum sci_status
  */
 enum sci_status scic_sds_io_request_frame_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 frame_index)
 {
-	return this_request->state_handlers->frame_handler(this_request, frame_index);
+	if (request->state_handlers->frame_handler)
+		return request->state_handlers->frame_handler(request, frame_index);
+
+	dev_warn(scic_to_dev(request->owning_controller),
+		 "%s: SCIC IO Request given unexpected frame %x while in "
+		 "state %d\n",
+		 __func__,
+		 frame_index,
+		 sci_base_state_machine_get_state(&request->state_machine));
+
+	scic_sds_controller_release_frame(request->owning_controller, frame_index);
+	return SCI_FAILURE_INVALID_STATE;
 }
 
 /**
@@ -1003,141 +1040,6 @@ void scic_sds_io_request_copy_response(s
 
 /*
  * *****************************************************************************
- * *  DEFAULT STATE HANDLERS
- * ***************************************************************************** */
-
-/*
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_request_start() request.  The default action is
- * to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_start_handler(
-	struct scic_sds_request *request)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		 "%s: SCIC IO Request requested to start while in wrong "
-		 "state %d\n",
-		 __func__,
-		 sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-static enum sci_status scic_sds_request_default_abort_handler(
-	struct scic_sds_request *request)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		"%s: SCIC IO Request requested to abort while in wrong "
-		"state %d\n",
-		__func__,
-		sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-/*
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_request_complete() request.  The default action
- * is to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_complete_handler(
-	struct scic_sds_request *request)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		"%s: SCIC IO Request requested to complete while in wrong "
-		"state %d\n",
-		__func__,
-		sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-/*
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_request_complete() request.  The default action
- * is to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_destruct_handler(
-	struct scic_sds_request *request)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		 "%s: SCIC IO Request requested to destroy while in wrong "
-		 "state %d\n",
-		 __func__,
-		 sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-/**
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_task_request_complete() request.  The default
- * action is to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_tc_completion_handler(
-	struct scic_sds_request *request,
-	u32 completion_code)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		"%s: SCIC IO Request given task completion notification %x "
-		"while in wrong state %d\n",
-		__func__,
-		completion_code,
-		sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-
-}
-
-/*
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_request_event_handler() request.  The default
- * action is to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_event_handler(
-	struct scic_sds_request *request,
-	u32 event_code)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		 "%s: SCIC IO Request given event code notification %x while "
-		 "in wrong state %d\n",
-		 __func__,
-		 event_code,
-		 sci_base_state_machine_get_state(&request->state_machine));
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-/*
- * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
- * object receives a scic_sds_request_event_handler() request.  The default
- * action is to log a warning and return a failure status. enum sci_status
- * SCI_FAILURE_INVALID_STATE
- */
-enum sci_status scic_sds_request_default_frame_handler(
-	struct scic_sds_request *request,
-	u32 frame_index)
-{
-	dev_warn(scic_to_dev(request->owning_controller),
-		 "%s: SCIC IO Request given unexpected frame %x while in "
-		 "state %d\n",
-		 __func__,
-		 frame_index,
-		 sci_base_state_machine_get_state(&request->state_machine));
-
-	scic_sds_controller_release_frame(
-		request->owning_controller, frame_index);
-
-	return SCI_FAILURE_INVALID_STATE;
-}
-
-/*
- * *****************************************************************************
  * *  CONSTRUCTED STATE HANDLERS
  * ***************************************************************************** */
 
@@ -1601,58 +1503,25 @@ static enum sci_status scic_sds_request_
 
 static const struct scic_sds_io_request_state_handler scic_sds_request_state_handler_table[] = {
 	[SCI_BASE_REQUEST_STATE_INITIAL] = {
-		.start_handler		= scic_sds_request_default_start_handler,
-		.abort_handler		= scic_sds_request_default_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_CONSTRUCTED] = {
 		.start_handler		= scic_sds_request_constructed_state_start_handler,
 		.abort_handler		= scic_sds_request_constructed_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_STARTED] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_request_started_state_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_request_started_state_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_COMPLETED] = {
-		.start_handler		= scic_sds_request_default_start_handler,
-		.abort_handler		= scic_sds_request_default_abort_handler,
 		.complete_handler	= scic_sds_request_completed_state_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_ABORTING] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_aborting_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_request_aborting_state_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_request_aborting_state_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_FINAL] = {
-		.start_handler		= scic_sds_request_default_start_handler,
-		.abort_handler		= scic_sds_request_default_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 };
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_request.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_request.h	2011-03-30 23:26:08.044659394 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_request.h	2011-03-30 23:58:33.567159101 +0200
@@ -315,13 +315,6 @@ struct scic_sds_io_request_state_handler
 	 */
 	scic_sds_io_request_handler_t complete_handler;
 
-	/**
-	 * The destruct_handler specifies the method invoked when a user attempts to
-	 * destruct a request.
-	 */
-	scic_sds_io_request_handler_t destruct_handler;
-
-
 	scic_sds_io_request_task_completion_handler_t tc_completion_handler;
 	scic_sds_io_request_event_handler_t event_handler;
 	scic_sds_io_request_frame_handler_t frame_handler;
@@ -394,24 +387,8 @@ extern const struct sci_base_state scic_
 	((a_request)->state_handlers->complete_handler(a_request))
 
 
-
-
-/**
- * scic_sds_io_request_tc_completion() -
- *
- * This macro invokes the core state task completion handler for the
- * struct scic_sds_io_request object.
- */
-#define scic_sds_io_request_tc_completion(this_request, completion_code) \
-{ \
-	if (this_request->state_machine.current_state_id	 \
-	    == SCI_BASE_REQUEST_STATE_STARTED \
-	    && this_request->has_started_substate_machine \
-	    == false) \
-		scic_sds_request_started_state_tc_completion_handler(this_request, completion_code); \
-	else \
-		this_request->state_handlers->tc_completion_handler(this_request, completion_code); \
-}
+extern enum sci_status
+scic_sds_io_request_tc_completion(struct scic_sds_request *request, u32 completion_code);
 
 /**
  * SCU_SGL_ZERO() -
@@ -494,33 +471,6 @@ enum sci_status scic_sds_task_request_te
 
 /*
  * *****************************************************************************
- * * DEFAULT STATE HANDLERS
- * ***************************************************************************** */
-
-enum sci_status scic_sds_request_default_start_handler(
-	struct scic_sds_request *request);
-
-
-enum sci_status scic_sds_request_default_complete_handler(
-	struct scic_sds_request *request);
-
-enum sci_status scic_sds_request_default_destruct_handler(
-	struct scic_sds_request *request);
-
-enum sci_status scic_sds_request_default_tc_completion_handler(
-	struct scic_sds_request *this_request,
-	u32 completion_code);
-
-enum sci_status scic_sds_request_default_event_handler(
-	struct scic_sds_request *this_request,
-	u32 event_code);
-
-enum sci_status scic_sds_request_default_frame_handler(
-	struct scic_sds_request *this_request,
-	u32 frame_index);
-
-/*
- * *****************************************************************************
  * * STARTED STATE HANDLERS
  * ***************************************************************************** */
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_smp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_smp_request.c	2011-03-30 23:26:08.064661527 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_smp_request.c	2011-03-30 23:58:38.343525388 +0200
@@ -525,22 +525,13 @@ static enum sci_status scic_sds_smp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_smp_request_started_substate_handler_table[] = {
 	[SCIC_SDS_SMP_REQUEST_STARTED_SUBSTATE_AWAIT_RESPONSE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_smp_request_await_response_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_smp_request_await_response_frame_handler,
 	},
 	[SCIC_SDS_SMP_REQUEST_STARTED_SUBSTATE_AWAIT_TC_COMPLETION] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	=  scic_sds_smp_request_await_tc_completion_tc_completion_handler,
-		.event_handler		=  scic_sds_request_default_event_handler,
-		.frame_handler		=  scic_sds_request_default_frame_handler,
 	}
 };
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_ssp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_ssp_request.c	2011-03-30 23:34:35.568659696 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_ssp_request.c	2011-03-30 23:58:43.851658791 +0200
@@ -180,21 +180,11 @@ static enum sci_status scic_sds_ssp_task
 
 static const struct scic_sds_io_request_state_handler scic_sds_ssp_task_request_started_substate_handler_table[] = {
 	[SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_COMPLETION] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_ssp_task_request_await_tc_completion_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_RESPONSE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_ssp_task_request_await_tc_response_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_ssp_task_request_await_tc_response_frame_handler,
 	}
 };
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_packet_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_packet_request.c	2011-03-30 23:34:35.592662279 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_packet_request.c	2011-03-30 23:58:53.075159698 +0200
@@ -671,49 +671,25 @@ enum sci_status scic_sds_stp_packet_requ
 
 const struct scic_sds_io_request_state_handler scic_sds_stp_packet_request_started_substate_handler_table[] = {
 	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
 		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler
 		.tc_completion_handler   = scic_sds_stp_packet_request_packet_phase_await_tc_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler
 	},
 	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
 		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
 		.frame_handler           = scic_sds_stp_packet_request_packet_phase_await_pio_setup_frame_handler
 	},
 	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
 		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler
 		.tc_completion_handler   = scic_sds_stp_packet_request_command_phase_await_tc_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
 		.frame_handler           = scic_sds_stp_packet_request_command_phase_await_tc_completion_frame_handler
 	},
 	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
 		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
 		.frame_handler           = scic_sds_stp_packet_request_command_phase_await_d2h_fis_frame_handler
 	},
 	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
 		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
 		.parent.complete_handler = scic_sds_stp_packet_request_started_completion_delay_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler
 	},
 };
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-30 23:34:35.632659667 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-30 23:59:14.611159993 +0200
@@ -555,21 +555,11 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_non_data_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_non_data_await_h2d_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_stp_request_non_data_await_d2h_frame_handler,
 	}
 };
@@ -1212,40 +1202,21 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_pio_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_pio_await_h2d_completion_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_stp_request_pio_await_frame_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
 		.event_handler		= scic_sds_stp_request_pio_data_in_await_data_event_handler,
 		.frame_handler		= scic_sds_stp_request_pio_data_in_await_data_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_pio_data_out_await_data_transmit_completion_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	}
 };
 
@@ -1510,21 +1481,12 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_udma_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_udma_await_tc_completion_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_stp_request_udma_general_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_stp_request_udma_await_d2h_reg_fis_frame_handler,
 	},
 };
@@ -1763,30 +1725,15 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_soft_reset_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_soft_reset_await_h2d_asserted_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
 		.tc_completion_handler	= scic_sds_stp_request_soft_reset_await_h2d_diagnostic_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
-		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE] = {
-		.start_handler		= scic_sds_request_default_start_handler,
 		.abort_handler		= scic_sds_request_started_state_abort_handler,
-		.complete_handler	= scic_sds_request_default_complete_handler,
-		.destruct_handler	= scic_sds_request_default_destruct_handler,
-		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
-		.event_handler		= scic_sds_request_default_event_handler,
 		.frame_handler		= scic_sds_stp_request_soft_reset_await_d2h_frame_handler,
 	},
 };
