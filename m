From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] isci: remove base_request abstraction
Date: Mon, 28 Mar 2011 09:21:14 -0400
Message-ID: <20110328132114.GB11684@infradead.org>
References: <20110328000754.GA28347@infradead.org>
 <20110328132046.GA497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1C1NVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 09:21:15 -0400
Content-Disposition: inline
In-Reply-To: <20110328132046.GA497@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Merge struct sci_base_request into scic_sds_request, and also factor the two
types of state machine handlers into one function.  While we're at it also
remove lots of duplicate incorrect kerneldoc comments for the state machine
handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/sci_base_remote_device.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_base_remote_device.h	2011-03-28 11:21:32.845838101 +0200
+++ linux-2.6/drivers/scsi/isci/core/sci_base_remote_device.h	2011-03-28 11:40:42.229838870 +0200
@@ -65,7 +65,7 @@
 
 #include "sci_base_state_machine.h"
 
-struct sci_base_request;
+struct scic_sds_request;
 
 /**
  * enum sci_base_remote_device_states - This enumeration depicts all the states
@@ -159,12 +159,12 @@ typedef enum sci_status (*sci_base_remot
 
 typedef enum sci_status (*sci_base_remote_device_request_handler_t)(
 	struct sci_base_remote_device *,
-	struct sci_base_request *
+	struct scic_sds_request *
 	);
 
 typedef enum sci_status (*sci_base_remote_device_high_priority_request_complete_handler_t)(
 	struct sci_base_remote_device *,
-	struct sci_base_request *,
+	struct scic_sds_request *,
 	void *,
 	enum sci_io_status
 	);
Index: linux-2.6/drivers/scsi/isci/core/sci_base_request.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_base_request.h	2011-03-28 11:19:07.474839171 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,195 +0,0 @@
-/*
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of Intel Corporation nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#ifndef _SCI_BASE_REQUST_H_
-#define _SCI_BASE_REQUST_H_
-
-/**
- * This file contains all of the constants, types, and method declarations for
- *    the SCI base IO and task request objects.
- *
- *
- */
-
-#include "sci_base_state_machine.h"
-
-/**
- * enum sci_base_request_states - This enumeration depicts all the states for
- *    the common request state machine.
- *
- *
- */
-enum sci_base_request_states {
-	/**
-	 * Simply the initial state for the base request state machine.
-	 */
-	SCI_BASE_REQUEST_STATE_INITIAL,
-
-	/**
-	 * This state indicates that the request has been constructed. This state
-	 * is entered from the INITIAL state.
-	 */
-	SCI_BASE_REQUEST_STATE_CONSTRUCTED,
-
-	/**
-	 * This state indicates that the request has been started. This state is
-	 * entered from the CONSTRUCTED state.
-	 */
-	SCI_BASE_REQUEST_STATE_STARTED,
-
-	/**
-	 * This state indicates that the request has completed.
-	 * This state is entered from the STARTED state. This state is entered from
-	 * the ABORTING state.
-	 */
-	SCI_BASE_REQUEST_STATE_COMPLETED,
-
-	/**
-	 * This state indicates that the request is in the process of being
-	 * terminated/aborted.
-	 * This state is entered from the CONSTRUCTED state.
-	 * This state is entered from the STARTED state.
-	 */
-	SCI_BASE_REQUEST_STATE_ABORTING,
-
-	/**
-	 * Simply the final state for the base request state machine.
-	 */
-	SCI_BASE_REQUEST_STATE_FINAL,
-};
-
-/**
- * struct sci_base_request - The base request object abstracts the fields
- *    common to all SCI IO and task request objects.
- *
- *
- */
-struct sci_base_request {
-	/**
-	 * The field specifies that the parent object for the base request is the
-	 * base object itself.
-	 */
-	struct sci_base_object parent;
-
-	/**
-	 * This field contains the information for the base request state machine.
-	 */
-	struct sci_base_state_machine state_machine;
-};
-
-typedef enum sci_status (*sci_base_request_handler_t)(
-	struct sci_base_request *this_request
-	);
-
-/**
- * struct sci_base_request_state_handler - This structure contains all of the
- *    state handler methods common to base IO and task request state machines.
- *    Handler methods provide the ability to change the behavior for user
- *    requests or transitions depending on the state the machine is in.
- *
- *
- */
-struct sci_base_request_state_handler {
-	/**
-	 * The start_handler specifies the method invoked when a user attempts to
-	 * start a request.
-	 */
-	sci_base_request_handler_t start_handler;
-
-	/**
-	 * The abort_handler specifies the method invoked when a user attempts to
-	 * abort a request.
-	 */
-	sci_base_request_handler_t abort_handler;
-
-	/**
-	 * The complete_handler specifies the method invoked when a user attempts to
-	 * complete a request.
-	 */
-	sci_base_request_handler_t complete_handler;
-
-	/**
-	 * The destruct_handler specifies the method invoked when a user attempts to
-	 * destruct a request.
-	 */
-	sci_base_request_handler_t destruct_handler;
-
-};
-
-/**
- * sci_base_request_construct() - Construct the base request.
- * @this_request: This parameter specifies the base request to be constructed.
- * @state_table: This parameter specifies the table of state definitions to be
- *    utilized for the request state machine.
- *
- */
-static inline void sci_base_request_construct(
-	struct sci_base_request *base_req,
-	const struct sci_base_state *my_state_table)
-{
-	base_req->parent.private = NULL;
-	sci_base_state_machine_construct(
-		&base_req->state_machine,
-		&base_req->parent,
-		my_state_table,
-		SCI_BASE_REQUEST_STATE_INITIAL
-		);
-
-	sci_base_state_machine_start(
-		&base_req->state_machine
-		);
-}
-
-#endif /* _SCI_BASE_REQUST_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 11:21:32.865841675 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 11:24:41.181837740 +0200
@@ -2161,7 +2161,7 @@ enum sci_status scic_controller_reset(
 enum sci_io_status scic_controller_start_io(
 	struct scic_sds_controller *scic,
 	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *io_request,
+	struct scic_sds_request *request,
 	u16 io_tag)
 {
 	u32 state;
@@ -2172,7 +2172,7 @@ enum sci_io_status scic_controller_start
 
 	return start_io(scic,
 			(struct sci_base_remote_device *) remote_device,
-			(struct sci_base_request *)io_request, io_tag);
+			request, io_tag);
 }
 
 /**
@@ -2204,7 +2204,7 @@ enum sci_status scic_controller_terminat
 
 	return terminate_request(scic,
 				 (struct sci_base_remote_device *)remote_device,
-				 (struct sci_base_request *)request);
+				 request);
 }
 
 /**
@@ -2232,7 +2232,7 @@ enum sci_status scic_controller_terminat
 enum sci_status scic_controller_complete_io(
 	struct scic_sds_controller *scic,
 	struct scic_sds_remote_device *remote_device,
-	struct scic_sds_request *io_request)
+	struct scic_sds_request *request)
 {
 	u32 state;
 	scic_sds_controller_request_handler_t complete_io;
@@ -2242,7 +2242,7 @@ enum sci_status scic_controller_complete
 
 	return complete_io(scic,
 			   (struct sci_base_remote_device *)remote_device,
-			   (struct sci_base_request *)io_request);
+			   request);
 }
 
 /**
@@ -2289,7 +2289,7 @@ enum sci_task_status scic_controller_sta
 	if (start_task)
 		status = start_task(scic,
 				    (struct sci_base_remote_device *)remote_device,
-				    (struct sci_base_request *)task_request,
+				    task_request,
 				    task_tag);
 	else
 		dev_warn(scic_to_dev(scic),
@@ -2329,7 +2329,7 @@ enum sci_status scic_controller_complete
 	if (complete_task)
 		status = complete_task(scic,
 				       (struct sci_base_remote_device *)remote_device,
-				       (struct sci_base_request *)task_request);
+				       task_request);
 	else
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller completing task from invalid "
@@ -2825,7 +2825,7 @@ default_controller_handler(struct scic_s
 static enum sci_status scic_sds_controller_default_start_operation_handler(
 	struct scic_sds_controller *scic,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request,
+	struct scic_sds_request *request,
 	u16 io_tag)
 {
 	return default_controller_handler(scic, __func__);
@@ -2834,7 +2834,7 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_default_request_handler(
 	struct scic_sds_controller *scic,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request)
+	struct scic_sds_request *request)
 {
 	return default_controller_handler(scic, __func__);
 }
@@ -3186,26 +3186,24 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_ready_state_start_io_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request,
+	struct scic_sds_request *request,
 	u16 io_tag)
 {
 	enum sci_status status;
 
-	struct scic_sds_request *the_request;
 	struct scic_sds_remote_device *the_device;
 
-	the_request = (struct scic_sds_request *)io_request;
 	the_device = (struct scic_sds_remote_device *)remote_device;
 
-	status = scic_sds_remote_device_start_io(controller, the_device, the_request);
+	status = scic_sds_remote_device_start_io(controller, the_device, request);
 
 	if (status != SCI_SUCCESS)
 		return status;
 
 	controller->io_request_table[
-		scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+		scic_sds_io_tag_get_index(request->io_tag)] = request;
 	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(the_request));
+		scic_sds_request_get_post_context(request));
 	return SCI_SUCCESS;
 }
 
@@ -3220,22 +3218,20 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_ready_state_complete_io_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request)
+	struct scic_sds_request *request)
 {
 	u16 index;
 	enum sci_status status;
-	struct scic_sds_request *the_request;
 	struct scic_sds_remote_device *the_device;
 
-	the_request = (struct scic_sds_request *)io_request;
 	the_device = (struct scic_sds_remote_device *)remote_device;
 
 	status = scic_sds_remote_device_complete_io(controller, the_device,
-			the_request);
+			request);
 	if (status != SCI_SUCCESS)
 		return status;
 
-	index = scic_sds_io_tag_get_index(the_request->io_tag);
+	index = scic_sds_io_tag_get_index(request->io_tag);
 	controller->io_request_table[index] = NULL;
 	return SCI_SUCCESS;
 }
@@ -3247,16 +3243,12 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_ready_state_continue_io_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *the_request;
-
-	the_request     = (struct scic_sds_request *)io_request;
-
 	controller->io_request_table[
-		scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+		scic_sds_io_tag_get_index(request->io_tag)] = request;
 	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(the_request));
+		scic_sds_request_get_post_context(request));
 	return SCI_SUCCESS;
 }
 
@@ -3273,27 +3265,25 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_ready_state_start_task_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request,
+	struct scic_sds_request *request,
 	u16 task_tag)
 {
-	struct scic_sds_request *the_request     = (struct scic_sds_request *)
-					      io_request;
 	struct scic_sds_remote_device *the_device      = (struct scic_sds_remote_device *)
 						    remote_device;
 	enum sci_status status;
 
 	status = scic_sds_remote_device_start_task(controller, the_device,
-			the_request);
+			request);
 
 	if (status == SCI_SUCCESS) {
 		controller->io_request_table[
-			scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+			scic_sds_io_tag_get_index(request->io_tag)] = request;
 
 		scic_sds_controller_post_request(controller,
-			scic_sds_request_get_post_context(the_request));
+			scic_sds_request_get_post_context(request));
 	} else if (status == SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS) {
 		controller->io_request_table[
-			scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+			scic_sds_io_tag_get_index(request->io_tag)] = request;
 
 		/*
 		 * We will let framework know this task request started successfully,
@@ -3315,13 +3305,11 @@ static enum sci_status scic_sds_controll
 static enum sci_status scic_sds_controller_ready_state_terminate_request_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *the_request     = (struct scic_sds_request *)
-					      io_request;
 	enum sci_status status;
 
-	status = scic_sds_io_request_terminate(the_request);
+	status = scic_sds_io_request_terminate(request);
 	if (status != SCI_SUCCESS)
 		return status;
 
@@ -3330,7 +3318,7 @@ static enum sci_status scic_sds_controll
 	 * request sub-type.
 	 */
 	scic_sds_controller_post_request(controller,
-		scic_sds_request_get_post_context(the_request) |
+		scic_sds_request_get_post_context(request) |
 		SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT);
 	return SCI_SUCCESS;
 }
@@ -3391,7 +3379,7 @@ static void scic_sds_controller_ready_st
 static enum sci_status scic_sds_controller_stopping_state_complete_io_handler(
 	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
-	struct sci_base_request *io_request)
+	struct scic_sds_request *request)
 {
 	/* XXX: Implement this function */
 	return SCI_FAILURE;
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 11:21:32.885840675 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 11:40:36.973838334 +0200
@@ -86,7 +86,6 @@
 
 struct sci_base_remote_device;
 struct scic_sds_remote_device;
-struct sci_base_request;
 struct scic_sds_request;
 struct scic_sds_controller;
 
@@ -487,11 +486,11 @@ typedef enum sci_status (*scic_sds_contr
 typedef enum sci_status (*scic_sds_controller_request_handler_t)
 				(struct scic_sds_controller *,
 				 struct sci_base_remote_device *,
-				 struct sci_base_request *);
+				 struct scic_sds_request *);
 typedef enum sci_status (*scic_sds_controller_start_request_handler_t)
 				(struct scic_sds_controller *,
 				 struct sci_base_remote_device *,
-				 struct sci_base_request *, u16);
+				 struct scic_sds_request *, u16);
 typedef void (*scic_sds_controller_phy_handler_t)
 				(struct scic_sds_controller *,
 				 struct scic_sds_port *,
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_port.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_port.c	2011-03-28 11:21:32.901837516 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_port.c	2011-03-28 11:25:05.641338436 +0200
@@ -1090,15 +1090,7 @@ static enum sci_status scic_sds_port_rea
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @port: This is the struct sci_base_port object which is cast into a struct scic_sds_port
- *    object.
- * @device: This is the struct sci_base_remote_device object which is not used in this
- *    function.
- * @io_request: This is the struct sci_base_request object which is not used in this
- *    function.
- *
+/*
  * This method is the general ready substate complete io handler for the
  * struct scic_sds_port object.  This function decrments the outstanding request count
  * for this port object. enum sci_status SCI_SUCCESS
@@ -1194,15 +1186,7 @@ static void scic_sds_port_ready_waiting_
 		);
 }
 
-/**
- *
- * @port: This is the struct sci_base_port object which is cast into a struct scic_sds_port
- *    object.
- * @device: This is the struct sci_base_remote_device object which is not used in this
- *    request.
- * @io_request: This is the struct sci_base_request object which is not used in this
- *    function.
- *
+/*
  * This method is the ready waiting substate start io handler for the
  * struct scic_sds_port object. The port object can not accept new requests so the
  * request is failed. enum sci_status SCI_FAILURE_INVALID_STATE
@@ -1316,15 +1300,7 @@ static void scic_sds_port_ready_operatio
 						    SCIC_SDS_PORT_READY_SUBSTATE_WAITING);
 }
 
-/**
- *
- * @port: This is the struct sci_base_port object which is cast into a struct scic_sds_port
- *    object.
- * @device: This is the struct sci_base_remote_device object which is not used in this
- *    function.
- * @io_request: This is the struct sci_base_request object which is not used in this
- *    function.
- *
+/*
  * This method is the ready operational substate start io handler for the
  * struct scic_sds_port object.  This function incremetns the outstanding request
  * count for this port object. enum sci_status SCI_SUCCESS
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-03-28 11:21:32.913838684 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-03-28 12:16:36.469839797 +0200
@@ -363,7 +363,7 @@ enum sci_status scic_sds_remote_device_s
 	struct scic_sds_request *io_request)
 {
 	return this_device->state_handlers->parent.start_io_handler(
-		       &this_device->parent, &io_request->parent);
+		       &this_device->parent, io_request);
 }
 
 /**
@@ -381,7 +381,7 @@ enum sci_status scic_sds_remote_device_c
 	struct scic_sds_request *io_request)
 {
 	return this_device->state_handlers->parent.complete_io_handler(
-		       &this_device->parent, &io_request->parent);
+		       &this_device->parent, io_request);
 }
 
 /**
@@ -399,7 +399,7 @@ enum sci_status scic_sds_remote_device_s
 	struct scic_sds_request *io_request)
 {
 	return this_device->state_handlers->parent.start_task_handler(
-		       &this_device->parent, &io_request->parent);
+		       &this_device->parent, io_request);
 }
 
 /**
@@ -567,7 +567,7 @@ void scic_sds_remote_device_continue_req
 		scic_sds_controller_request_handler_t continue_io;
 
 		continue_io = scic_sds_controller_state_handler_table[state].continue_io;
-		continue_io(scic, &sci_req->target_device->parent, &sci_req->parent);
+		continue_io(scic, &sci_req->target_device->parent, sci_req);
 	}
 }
 
@@ -792,21 +792,21 @@ enum sci_status scic_sds_remote_device_d
 
 enum sci_status scic_sds_remote_device_default_start_request_handler(
 	struct sci_base_remote_device *base_dev,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return default_device_handler(base_dev, __func__);
 }
 
 enum sci_status scic_sds_remote_device_default_complete_request_handler(
 	struct sci_base_remote_device *base_dev,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return default_device_handler(base_dev, __func__);
 }
 
 enum sci_status scic_sds_remote_device_default_continue_request_handler(
 	struct sci_base_remote_device *base_dev,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return default_device_handler(base_dev, __func__);
 }
@@ -1019,13 +1019,7 @@ enum sci_status scic_sds_remote_device_r
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @device: The struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device for which the request is to be started.
- * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
- *    is to be started.
- *
+/*
  * This method will attempt to start a task request for this device object. The
  * remote device object will issue the start request for the task and if
  * successful it will start the request for the port object then increment its
@@ -1035,38 +1029,28 @@ enum sci_status scic_sds_remote_device_r
  */
 static enum sci_status scic_sds_remote_device_ready_state_start_task_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status result;
 	struct scic_sds_remote_device *this_device  = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *task_request = (struct scic_sds_request *)request;
 
 	/* See if the port is in a state where we can start the IO request */
 	result = scic_sds_port_start_io(
-		scic_sds_remote_device_get_port(this_device), this_device, task_request);
+		scic_sds_remote_device_get_port(this_device), this_device, request);
 
 	if (result == SCI_SUCCESS) {
 		result = scic_sds_remote_node_context_start_task(
-			this_device->rnc, task_request
-			);
-
-		if (result == SCI_SUCCESS) {
-			result = scic_sds_request_start(task_request);
-		}
+			this_device->rnc, request);
+		if (result == SCI_SUCCESS)
+			result = scic_sds_request_start(request);
 
-		scic_sds_remote_device_start_request(this_device, task_request, result);
+		scic_sds_remote_device_start_request(this_device, request, result);
 	}
 
 	return result;
 }
 
-/**
- *
- * @device: The struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device for which the request is to be started.
- * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
- *    is to be started.
- *
+/*
  * This method will attempt to start an io request for this device object. The
  * remote device object will issue the start request for the io and if
  * successful it will start the request for the port object then increment its
@@ -1076,38 +1060,28 @@ static enum sci_status scic_sds_remote_d
  */
 static enum sci_status scic_sds_remote_device_ready_state_start_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status result;
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *io_request  = (struct scic_sds_request *)request;
 
 	/* See if the port is in a state where we can start the IO request */
 	result = scic_sds_port_start_io(
-		scic_sds_remote_device_get_port(this_device), this_device, io_request);
+		scic_sds_remote_device_get_port(this_device), this_device, request);
 
 	if (result == SCI_SUCCESS) {
 		result = scic_sds_remote_node_context_start_io(
-			this_device->rnc, io_request
-			);
+			this_device->rnc, request);
+		if (result == SCI_SUCCESS)
+			result = scic_sds_request_start(request);
 
-		if (result == SCI_SUCCESS) {
-			result = scic_sds_request_start(io_request);
-		}
-
-		scic_sds_remote_device_start_request(this_device, io_request, result);
+		scic_sds_remote_device_start_request(this_device, request, result);
 	}
 
 	return result;
 }
 
-/**
- *
- * @device: The struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device for which the request is to be completed.
- * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
- *    is to be completed.
- *
+/*
  * This method will complete the request for the remote device object.  The
  * method will call the completion handler for the request object and if
  * successful it will complete the request on the port object then decrement
@@ -1115,18 +1089,17 @@ static enum sci_status scic_sds_remote_d
  */
 static enum sci_status scic_sds_remote_device_ready_state_complete_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status result;
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
 
-	result = scic_sds_request_complete(the_request);
+	result = scic_sds_request_complete(request);
 
 	if (result == SCI_SUCCESS) {
 		/* See if the port is in a state where we can start the IO request */
 		result = scic_sds_port_complete_io(
-			scic_sds_remote_device_get_port(this_device), this_device, the_request);
+			scic_sds_remote_device_get_port(this_device), this_device, request);
 
 		if (result == SCI_SUCCESS) {
 			scic_sds_remote_device_decrement_request_count(this_device);
@@ -1178,19 +1151,16 @@ static enum sci_status scic_sds_remote_d
  */
 static enum sci_status scic_sds_remote_device_stopping_state_complete_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status = SCI_SUCCESS;
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
 
-	status = scic_sds_request_complete(this_request);
+	status = scic_sds_request_complete(request);
 	if (status == SCI_SUCCESS) {
 		status = scic_sds_port_complete_io(
 			scic_sds_remote_device_get_port(this_device),
-			this_device,
-			this_request
-			);
+			this_device, request);
 
 		if (status == SCI_SUCCESS) {
 			scic_sds_remote_device_decrement_request_count(this_device);
@@ -1255,11 +1225,7 @@ static enum sci_status scic_sds_remote_d
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @device: The device object for which the request is completing.
- * @request: The task request that is being completed.
- *
+/*
  * This method completes requests for this struct scic_sds_remote_device while it is
  * in the SCI_BASE_REMOTE_DEVICE_STATE_RESETTING state. This method calls the
  * complete method for the request object and if that is successful the port
@@ -1268,17 +1234,16 @@ static enum sci_status scic_sds_remote_d
  */
 static enum sci_status scic_sds_remote_device_resetting_state_complete_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status = SCI_SUCCESS;
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
 
-	status = scic_sds_request_complete(this_request);
+	status = scic_sds_request_complete(request);
 
 	if (status == SCI_SUCCESS) {
 		status = scic_sds_port_complete_io(
-			scic_sds_remote_device_get_port(this_device), this_device, this_request);
+			scic_sds_remote_device_get_port(this_device), this_device, request);
 
 		if (status == SCI_SUCCESS) {
 			scic_sds_remote_device_decrement_request_count(this_device);
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_remote_device.h	2011-03-28 11:21:32.929838543 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.h	2011-03-28 12:08:01.793838917 +0200
@@ -65,7 +65,6 @@
 
 #include "intel_sas.h"
 #include "sci_base_remote_device.h"
-#include "sci_base_request.h"
 #include "scu_remote_node_context.h"
 #include "scic_sds_remote_node_context.h"
 
@@ -507,15 +506,15 @@ enum sci_status scic_sds_remote_device_d
 
 enum sci_status scic_sds_remote_device_default_start_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_remote_device_default_complete_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_remote_device_default_continue_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_remote_device_default_suspend_handler(
 	struct scic_sds_remote_device *this_device,
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_request.c	2011-03-28 11:19:52.374837312 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_request.c	2011-03-28 12:11:15.433838915 +0200
@@ -57,7 +57,6 @@
 #include "intel_sas.h"
 #include "intel_sata.h"
 #include "intel_sat.h"
-#include "sci_base_request.h"
 #include "scic_controller.h"
 #include "scic_io_request.h"
 #include "scic_remote_device.h"
@@ -728,10 +727,8 @@ enum sci_status scic_io_request_construc
 
 	scic_sds_io_request_build_ssp_command_iu(sci_req);
 
-	sci_base_state_machine_change_state(
-		&sci_req->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_CONSTRUCTED
-		);
+	sci_base_state_machine_change_state(&sci_req->state_machine,
+		SCI_BASE_REQUEST_STATE_CONSTRUCTED);
 
 	return SCI_SUCCESS;
 }
@@ -746,10 +743,8 @@ enum sci_status scic_task_request_constr
 	/* Fill in the SSP Task IU */
 	scic_sds_task_request_build_ssp_task_iu(sci_req);
 
-	sci_base_state_machine_change_state(
-		&sci_req->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_CONSTRUCTED
-		);
+	sci_base_state_machine_change_state(&sci_req->state_machine,
+		SCI_BASE_REQUEST_STATE_CONSTRUCTED);
 
 	return SCI_SUCCESS;
 }
@@ -780,10 +775,8 @@ enum sci_status scic_io_request_construc
 	status = scic_io_request_construct_sata(sci_req, proto, len, dir, copy);
 
 	if (status == SCI_SUCCESS)
-		sci_base_state_machine_change_state(
-			&sci_req->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_CONSTRUCTED
-			);
+		sci_base_state_machine_change_state(&sci_req->state_machine,
+			SCI_BASE_REQUEST_STATE_CONSTRUCTED);
 
 	return status;
 }
@@ -818,10 +811,8 @@ enum sci_status scic_task_request_constr
 	}
 
 	if (status == SCI_SUCCESS)
-		sci_base_state_machine_change_state(
-			&sci_req->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_CONSTRUCTED
-			);
+		sci_base_state_machine_change_state(&sci_req->state_machine,
+			SCI_BASE_REQUEST_STATE_CONSTRUCTED);
 
 	return status;
 }
@@ -891,18 +882,12 @@ u32 scic_io_request_get_number_of_bytes_
  * This method invokes the base state start request handler for the
  * SCIC_SDS_IO_REQUEST_T object. enum sci_status
  */
-enum sci_status scic_sds_request_start(
-	struct scic_sds_request *this_request)
+enum sci_status
+scic_sds_request_start(struct scic_sds_request *request)
 {
-	if (
-		this_request->device_sequence
-		== scic_sds_remote_device_get_sequence(this_request->target_device)
-		) {
-		return this_request->state_handlers->parent.start_handler(
-			       &this_request->parent
-			       );
-	}
-
+	if (request->device_sequence ==
+	    scic_sds_remote_device_get_sequence(request->target_device))
+		return request->state_handlers->start_handler(request);
 	return SCI_FAILURE;
 }
 
@@ -914,11 +899,10 @@ enum sci_status scic_sds_request_start(
  * This method invokes the base state terminate request handber for the
  * SCIC_SDS_IO_REQUEST_T object. enum sci_status
  */
-enum sci_status scic_sds_io_request_terminate(
-	struct scic_sds_request *this_request)
+enum sci_status
+scic_sds_io_request_terminate(struct scic_sds_request *request)
 {
-	return this_request->state_handlers->parent.abort_handler(
-		       &this_request->parent);
+	return request->state_handlers->abort_handler(request);
 }
 
 /**
@@ -929,11 +913,10 @@ enum sci_status scic_sds_io_request_term
  * This method invokes the base state request completion handler for the
  * SCIC_SDS_IO_REQUEST_T object. enum sci_status
  */
-enum sci_status scic_sds_io_request_complete(
-	struct scic_sds_request *this_request)
+enum sci_status
+scic_sds_io_request_complete(struct scic_sds_request *request)
 {
-	return this_request->state_handlers->parent.complete_handler(
-		       &this_request->parent);
+	return request->state_handlers->complete_handler(request);
 }
 
 /**
@@ -1023,175 +1006,132 @@ void scic_sds_io_request_copy_response(s
  * *  DEFAULT STATE HANDLERS
  * ***************************************************************************** */
 
-/**
- * scic_sds_request_default_start_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_start() request.  The default action is
  * to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_start_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *scic_request =
-		(struct scic_sds_request *)request;
-
-	dev_warn(scic_to_dev(scic_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		 "%s: SCIC IO Request requested to start while in wrong "
 		 "state %d\n",
 		 __func__,
-		 sci_base_state_machine_get_state(
-			 &((struct scic_sds_request *)request)->parent.state_machine));
+		 sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
 static enum sci_status scic_sds_request_default_abort_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *scic_request =
-		(struct scic_sds_request *)request;
-
-	dev_warn(scic_to_dev(scic_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		"%s: SCIC IO Request requested to abort while in wrong "
 		"state %d\n",
 		__func__,
-		sci_base_state_machine_get_state(
-			&((struct scic_sds_request *)request)->parent.state_machine));
+		sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- * scic_sds_request_default_complete_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_complete() request.  The default action
  * is to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_complete_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *scic_request =
-		(struct scic_sds_request *)request;
-
-	dev_warn(scic_to_dev(scic_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		"%s: SCIC IO Request requested to complete while in wrong "
 		"state %d\n",
 		__func__,
-		sci_base_state_machine_get_state(
-			&((struct scic_sds_request *)request)->parent.state_machine));
+		sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- * scic_sds_request_default_destruct_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_complete() request.  The default action
  * is to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_destruct_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *scic_request =
-		(struct scic_sds_request *)request;
-
-	dev_warn(scic_to_dev(scic_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		 "%s: SCIC IO Request requested to destroy while in wrong "
 		 "state %d\n",
 		 __func__,
-		 sci_base_state_machine_get_state(
-			 &((struct scic_sds_request *)request)->parent.state_machine));
+		 sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
 /**
- * scic_sds_request_default_tc_completion_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_task_request_complete() request.  The default
  * action is to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_tc_completion_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 completion_code)
 {
-	dev_warn(scic_to_dev(this_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		"%s: SCIC IO Request given task completion notification %x "
 		"while in wrong state %d\n",
 		__func__,
 		completion_code,
-		sci_base_state_machine_get_state(
-			&this_request->parent.state_machine));
+		sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 
 }
 
-/**
- * scic_sds_request_default_event_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_event_handler() request.  The default
  * action is to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_event_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 event_code)
 {
-	dev_warn(scic_to_dev(this_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		 "%s: SCIC IO Request given event code notification %x while "
 		 "in wrong state %d\n",
 		 __func__,
 		 event_code,
-		 sci_base_state_machine_get_state(
-			 &this_request->parent.state_machine));
+		 sci_base_state_machine_get_state(&request->state_machine));
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
-/**
- * scic_sds_request_default_frame_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method is the default action to take when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_event_handler() request.  The default
  * action is to log a warning and return a failure status. enum sci_status
  * SCI_FAILURE_INVALID_STATE
  */
 enum sci_status scic_sds_request_default_frame_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 frame_index)
 {
-	dev_warn(scic_to_dev(this_request->owning_controller),
+	dev_warn(scic_to_dev(request->owning_controller),
 		 "%s: SCIC IO Request given unexpected frame %x while in "
 		 "state %d\n",
 		 __func__,
 		 frame_index,
-		 sci_base_state_machine_get_state(
-			 &this_request->parent.state_machine));
+		 sci_base_state_machine_get_state(&request->state_machine));
 
 	scic_sds_controller_release_frame(
-		this_request->owning_controller, frame_index);
+		request->owning_controller, frame_index);
 
 	return SCI_FAILURE_INVALID_STATE;
 }
@@ -1201,11 +1141,7 @@ enum sci_status scic_sds_request_default
  * *  CONSTRUCTED STATE HANDLERS
  * ***************************************************************************** */
 
-/**
- * scic_sds_request_constructed_state_start_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action taken when a constructed
  * SCIC_SDS_IO_REQUEST_T object receives a scic_sds_request_start() request.
  * This method will, if necessary, allocate a TCi for the io request object and
@@ -1215,34 +1151,33 @@ enum sci_status scic_sds_request_default
  * SCI_SUCCESS SCI_FAILURE_INSUFFICIENT_RESOURCES
  */
 static enum sci_status scic_sds_request_constructed_state_start_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	struct scu_task_context *task_context;
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
 
-	if (this_request->io_tag == SCI_CONTROLLER_INVALID_IO_TAG) {
-		this_request->io_tag =
-			scic_controller_allocate_io_tag(this_request->owning_controller);
+	if (request->io_tag == SCI_CONTROLLER_INVALID_IO_TAG) {
+		request->io_tag =
+			scic_controller_allocate_io_tag(request->owning_controller);
 	}
 
 	/* Record the IO Tag in the request */
-	if (this_request->io_tag != SCI_CONTROLLER_INVALID_IO_TAG) {
-		task_context = this_request->task_context_buffer;
+	if (request->io_tag != SCI_CONTROLLER_INVALID_IO_TAG) {
+		task_context = request->task_context_buffer;
 
-		task_context->task_index = scic_sds_io_tag_get_index(this_request->io_tag);
+		task_context->task_index = scic_sds_io_tag_get_index(request->io_tag);
 
 		switch (task_context->protocol_type) {
 		case SCU_TASK_CONTEXT_PROTOCOL_SMP:
 		case SCU_TASK_CONTEXT_PROTOCOL_SSP:
 			/* SSP/SMP Frame */
-			task_context->type.ssp.tag = this_request->io_tag;
+			task_context->type.ssp.tag = request->io_tag;
 			task_context->type.ssp.target_port_transfer_tag = 0xFFFF;
 			break;
 
 		case SCU_TASK_CONTEXT_PROTOCOL_STP:
 			/*
 			 * STP/SATA Frame
-			 * task_context->type.stp.ncq_tag = this_request->ncq_tag; */
+			 * task_context->type.stp.ncq_tag = request->ncq_tag; */
 			break;
 
 		case SCU_TASK_CONTEXT_PROTOCOL_NONE:
@@ -1257,20 +1192,17 @@ static enum sci_status scic_sds_request_
 		/*
 		 * Check to see if we need to copy the task context buffer
 		 * or have been building into the task context buffer */
-		if (this_request->was_tag_assigned_by_user == false) {
+		if (request->was_tag_assigned_by_user == false) {
 			scic_sds_controller_copy_task_context(
-				this_request->owning_controller, this_request
-				);
+				request->owning_controller, request);
 		}
 
 		/* Add to the post_context the io tag value */
-		this_request->post_context |= scic_sds_io_tag_get_index(this_request->io_tag);
+		request->post_context |= scic_sds_io_tag_get_index(request->io_tag);
 
 		/* Everything is good go ahead and change state */
-		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_STARTED
-			);
+		sci_base_state_machine_change_state(&request->state_machine,
+			SCI_BASE_REQUEST_STATE_STARTED);
 
 		return SCI_SUCCESS;
 	}
@@ -1278,35 +1210,24 @@ static enum sci_status scic_sds_request_
 	return SCI_FAILURE_INSUFFICIENT_RESOURCES;
 }
 
-/**
- * scic_sds_request_constructed_state_abort_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_terminate() request. Since the request
  * has not yet been posted to the hardware the request transitions to the
  * completed state. enum sci_status SCI_SUCCESS
  */
 static enum sci_status scic_sds_request_constructed_state_abort_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
-
 	/*
 	 * This request has been terminated by the user make sure that the correct
 	 * status code is returned */
-	scic_sds_request_set_status(
-		this_request,
+	scic_sds_request_set_status(request,
 		SCU_TASK_DONE_TASK_ABORT,
-		SCI_FAILURE_IO_TERMINATED
-		);
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
+		SCI_FAILURE_IO_TERMINATED);
 
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
 	return SCI_SUCCESS;
 }
 
@@ -1315,30 +1236,20 @@ static enum sci_status scic_sds_request_
  * *  STARTED STATE HANDLERS
  * ***************************************************************************** */
 
-/**
- * scic_sds_request_started_state_abort_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_terminate() request. Since the request
  * has been posted to the hardware the io request state is changed to the
  * aborting state. enum sci_status SCI_SUCCESS
  */
 enum sci_status scic_sds_request_started_state_abort_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
-
-	if (this_request->has_started_substate_machine) {
-		sci_base_state_machine_stop(&this_request->started_substate_machine);
-	}
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_ABORTING
-		);
+	if (request->has_started_substate_machine)
+		sci_base_state_machine_stop(&request->started_substate_machine);
 
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_ABORTING);
 	return SCI_SUCCESS;
 }
 
@@ -1512,20 +1423,12 @@ enum sci_status scic_sds_request_started
 	 */
 
 	/* In all cases we will treat this as the completion of the IO request. */
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
-
+	sci_base_state_machine_change_state(&this_request->state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
 	return SCI_SUCCESS;
 }
 
-/**
- * scic_sds_request_started_state_frame_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- * @frame_index: This is the index of the unsolicited frame to be processed.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_frame_handler() request. This method
  * first determines the frame type received.  If this is a response frame then
@@ -1601,11 +1504,7 @@ static enum sci_status scic_sds_request_
  * ***************************************************************************** */
 
 
-/**
- * scic_sds_request_completed_state_complete_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_complete() request. This method frees up
  * any io request resources that have been allocated and transitions the
@@ -1613,26 +1512,20 @@ static enum sci_status scic_sds_request_
  * transitioning to the final state? enum sci_status SCI_SUCCESS
  */
 static enum sci_status scic_sds_request_completed_state_complete_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
-
-	if (this_request->was_tag_assigned_by_user != true) {
+	if (request->was_tag_assigned_by_user != true) {
 		scic_controller_free_io_tag(
-			this_request->owning_controller, this_request->io_tag
-			);
+			request->owning_controller, request->io_tag);
 	}
 
-	if (this_request->saved_rx_frame_index != SCU_INVALID_FRAME_INDEX) {
+	if (request->saved_rx_frame_index != SCU_INVALID_FRAME_INDEX) {
 		scic_sds_controller_release_frame(
-			this_request->owning_controller, this_request->saved_rx_frame_index);
+			request->owning_controller, request->saved_rx_frame_index);
 	}
 
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_FINAL
-		);
-
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_FINAL);
 	return SCI_SUCCESS;
 }
 
@@ -1641,11 +1534,7 @@ static enum sci_status scic_sds_request_
  * *  ABORTING STATE HANDLERS
  * ***************************************************************************** */
 
-/**
- * scic_sds_request_aborting_state_abort_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_terminate() request. This method is the
  * io request aborting state abort handlers.  On receipt of a multiple
@@ -1653,23 +1542,14 @@ static enum sci_status scic_sds_request_
  * This should not happen in normal operation. enum sci_status SCI_SUCCESS
  */
 static enum sci_status scic_sds_request_aborting_state_abort_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
-
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
 	return SCI_SUCCESS;
 }
 
-/**
- * scic_sds_request_aborting_state_tc_completion_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_task_completion() request. This method
  * decodes the completion type waiting for the abort task complete
@@ -1687,10 +1567,8 @@ static enum sci_status scic_sds_request_
 			this_request, SCU_TASK_DONE_TASK_ABORT, SCI_FAILURE_IO_TERMINATED
 			);
 
-		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+		sci_base_state_machine_change_state(&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 
 	default:
@@ -1703,11 +1581,7 @@ static enum sci_status scic_sds_request_
 	return SCI_SUCCESS;
 }
 
-/**
- * scic_sds_request_aborting_state_frame_handler() -
- * @request: This is the struct sci_base_request object that is cast to the
- *    SCIC_SDS_IO_REQUEST_T object for which the start operation is requested.
- *
+/*
  * This method implements the action to be taken when an SCIC_SDS_IO_REQUEST_T
  * object receives a scic_sds_request_frame_handler() request. This method
  * discards the unsolicited frame since we are waiting for the abort task
@@ -1727,58 +1601,58 @@ static enum sci_status scic_sds_request_
 
 static const struct scic_sds_io_request_state_handler scic_sds_request_state_handler_table[] = {
 	[SCI_BASE_REQUEST_STATE_INITIAL] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_default_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_default_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_CONSTRUCTED] = {
-		.parent.start_handler    = scic_sds_request_constructed_state_start_handler,
-		.parent.abort_handler    = scic_sds_request_constructed_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_constructed_state_start_handler,
+		.abort_handler		= scic_sds_request_constructed_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_STARTED] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_started_state_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_started_state_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_started_state_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_started_state_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_COMPLETED] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_default_abort_handler,
-		.parent.complete_handler = scic_sds_request_completed_state_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_default_abort_handler,
+		.complete_handler	= scic_sds_request_completed_state_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_ABORTING] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_aborting_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_aborting_state_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_aborting_state_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_aborting_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_aborting_state_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_aborting_state_frame_handler,
 	},
 	[SCI_BASE_REQUEST_STATE_FINAL] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_default_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_default_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 };
 
@@ -1978,7 +1852,11 @@ static void scic_sds_general_request_con
 					       void *user_io_request_object,
 					       struct scic_sds_request *sci_req)
 {
-	sci_base_request_construct(&sci_req->parent, scic_sds_request_state_table);
+	sci_req->parent.private = NULL;
+	sci_base_state_machine_construct(&sci_req->state_machine, &sci_req->parent,
+			scic_sds_request_state_table, SCI_BASE_REQUEST_STATE_INITIAL);
+	sci_base_state_machine_start(&sci_req->state_machine);
+
 	sci_req->io_tag = io_tag;
 	sci_req->user_request = user_io_request_object;
 	sci_req->owning_controller = scic;
@@ -2070,7 +1948,7 @@ enum sci_status scic_task_request_constr
 		/* Construct the started sub-state machine. */
 		sci_base_state_machine_construct(
 			&sci_req->started_substate_machine,
-			&sci_req->parent.parent,
+			&sci_req->parent,
 			scic_sds_io_request_started_task_mgmt_substate_table,
 			SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_COMPLETION
 			);
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_request.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_request.h	2011-03-28 11:21:32.953838657 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_request.h	2011-03-28 12:08:17.102838333 +0200
@@ -64,8 +64,7 @@
  */
 
 #include "scic_io_request.h"
-
-#include "sci_base_request.h"
+#include "sci_base_state_machine.h"
 #include "scu_task_context.h"
 #include "intel_sas.h"
 
@@ -127,9 +126,15 @@ enum scic_sds_smp_request_started_substa
  */
 struct scic_sds_request {
 	/**
-	 * This field indictes the parent object of the request.
+	 * The field specifies that the parent object for the base request is the
+	 * base object itself.
 	 */
-	struct sci_base_request parent;
+	struct sci_base_object parent;
+
+	/**
+	 * This field contains the information for the base request state machine.
+	 */
+	struct sci_base_state_machine state_machine;
 
 	void *user_request;
 
@@ -231,15 +236,59 @@ struct scic_sds_request {
 
 };
 
+/**
+ * enum sci_base_request_states - This enumeration depicts all the states for
+ *    the common request state machine.
+ *
+ *
+ */
+enum sci_base_request_states {
+	/**
+	 * Simply the initial state for the base request state machine.
+	 */
+	SCI_BASE_REQUEST_STATE_INITIAL,
+
+	/**
+	 * This state indicates that the request has been constructed. This state
+	 * is entered from the INITIAL state.
+	 */
+	SCI_BASE_REQUEST_STATE_CONSTRUCTED,
+
+	/**
+	 * This state indicates that the request has been started. This state is
+	 * entered from the CONSTRUCTED state.
+	 */
+	SCI_BASE_REQUEST_STATE_STARTED,
+
+	/**
+	 * This state indicates that the request has completed.
+	 * This state is entered from the STARTED state. This state is entered from
+	 * the ABORTING state.
+	 */
+	SCI_BASE_REQUEST_STATE_COMPLETED,
 
-typedef enum sci_status
-(*scic_sds_io_request_frame_handler_t)(struct scic_sds_request *req, u32 frame);
+	/**
+	 * This state indicates that the request is in the process of being
+	 * terminated/aborted.
+	 * This state is entered from the CONSTRUCTED state.
+	 * This state is entered from the STARTED state.
+	 */
+	SCI_BASE_REQUEST_STATE_ABORTING,
 
-typedef enum sci_status
-(*scic_sds_io_request_event_handler_t)(struct scic_sds_request *req, u32 event);
+	/**
+	 * Simply the final state for the base request state machine.
+	 */
+	SCI_BASE_REQUEST_STATE_FINAL,
+};
 
-typedef enum sci_status
-(*scic_sds_io_request_task_completion_handler_t)(struct scic_sds_request *req, u32 completion_code);
+typedef enum sci_status (*scic_sds_io_request_handler_t)
+				(struct scic_sds_request *request);
+typedef enum sci_status (*scic_sds_io_request_frame_handler_t)
+				(struct scic_sds_request *req, u32 frame);
+typedef enum sci_status (*scic_sds_io_request_event_handler_t)
+				(struct scic_sds_request *req, u32 event);
+typedef enum sci_status (*scic_sds_io_request_task_completion_handler_t)
+				(struct scic_sds_request *req, u32 completion_code);
 
 /**
  * struct scic_sds_io_request_state_handler - This is the SDS core definition
@@ -248,7 +297,30 @@ typedef enum sci_status
  *
  */
 struct scic_sds_io_request_state_handler {
-	struct sci_base_request_state_handler parent;
+	/**
+	 * The start_handler specifies the method invoked when a user attempts to
+	 * start a request.
+	 */
+	scic_sds_io_request_handler_t start_handler;
+
+	/**
+	 * The abort_handler specifies the method invoked when a user attempts to
+	 * abort a request.
+	 */
+	scic_sds_io_request_handler_t abort_handler;
+
+	/**
+	 * The complete_handler specifies the method invoked when a user attempts to
+	 * complete a request.
+	 */
+	scic_sds_io_request_handler_t complete_handler;
+
+	/**
+	 * The destruct_handler specifies the method invoked when a user attempts to
+	 * destruct a request.
+	 */
+	scic_sds_io_request_handler_t destruct_handler;
+
 
 	scic_sds_io_request_task_completion_handler_t tc_completion_handler;
 	scic_sds_io_request_event_handler_t event_handler;
@@ -319,7 +391,7 @@ extern const struct sci_base_state scic_
 	}
 
 #define scic_sds_request_complete(a_request) \
-	((a_request)->state_handlers->parent.complete_handler(&(a_request)->parent))
+	((a_request)->state_handlers->complete_handler(a_request))
 
 
 
@@ -331,15 +403,15 @@ extern const struct sci_base_state scic_
  * struct scic_sds_io_request object.
  */
 #define scic_sds_io_request_tc_completion(this_request, completion_code) \
-	{ \
-		if (this_request->parent.state_machine.current_state_id	 \
-		    == SCI_BASE_REQUEST_STATE_STARTED \
-		    && this_request->has_started_substate_machine \
-		    == false) \
-			scic_sds_request_started_state_tc_completion_handler(this_request, completion_code); \
-		else \
-			this_request->state_handlers->tc_completion_handler(this_request, completion_code); \
-	}
+{ \
+	if (this_request->state_machine.current_state_id	 \
+	    == SCI_BASE_REQUEST_STATE_STARTED \
+	    && this_request->has_started_substate_machine \
+	    == false) \
+		scic_sds_request_started_state_tc_completion_handler(this_request, completion_code); \
+	else \
+		this_request->state_handlers->tc_completion_handler(this_request, completion_code); \
+}
 
 /**
  * SCU_SGL_ZERO() -
@@ -426,14 +498,14 @@ enum sci_status scic_sds_task_request_te
  * ***************************************************************************** */
 
 enum sci_status scic_sds_request_default_start_handler(
-	struct sci_base_request *this_request);
+	struct scic_sds_request *request);
 
 
 enum sci_status scic_sds_request_default_complete_handler(
-	struct sci_base_request *this_request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_request_default_destruct_handler(
-	struct sci_base_request *this_request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_request_default_tc_completion_handler(
 	struct scic_sds_request *this_request,
@@ -453,7 +525,7 @@ enum sci_status scic_sds_request_default
  * ***************************************************************************** */
 
 enum sci_status scic_sds_request_started_state_abort_handler(
-	struct sci_base_request *this_request);
+	struct scic_sds_request *request);
 
 enum sci_status scic_sds_request_started_state_tc_completion_handler(
 	struct scic_sds_request *this_request,
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_smp_remote_device.c	2011-03-28 11:21:32.969838392 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_smp_remote_device.c	2011-03-28 11:35:46.181338558 +0200
@@ -78,29 +78,24 @@
  */
 static enum sci_status scic_sds_smp_remote_device_ready_idle_substate_start_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status;
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *io_request  = (struct scic_sds_request *)request;
 
 	/* Will the port allow the io request to start? */
 	status = this_device->owning_port->state_handlers->start_io_handler(
-		this_device->owning_port,
-		this_device,
-		io_request
-		);
+		this_device->owning_port, this_device, request);
 
 	if (status == SCI_SUCCESS) {
 		status =
-			scic_sds_remote_node_context_start_io(this_device->rnc, io_request);
+			scic_sds_remote_node_context_start_io(this_device->rnc, request);
 
-		if (status == SCI_SUCCESS) {
-			status = scic_sds_request_start(io_request);
-		}
+		if (status == SCI_SUCCESS)
+			status = scic_sds_request_start(request);
 
 		if (status == SCI_SUCCESS) {
-			this_device->working_request = io_request;
+			this_device->working_request = request;
 
 			sci_base_state_machine_change_state(
 				&this_device->ready_substate_machine,
@@ -108,7 +103,7 @@ static enum sci_status scic_sds_smp_remo
 				);
 		}
 
-		scic_sds_remote_device_start_request(this_device, io_request, status);
+		scic_sds_remote_device_start_request(this_device, request, status);
 	}
 
 	return status;
@@ -129,7 +124,7 @@ static enum sci_status scic_sds_smp_remo
  */
 static enum sci_status scic_sds_smp_remote_device_ready_cmd_substate_start_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return SCI_FAILURE_INVALID_STATE;
 }
@@ -144,7 +139,7 @@ static enum sci_status scic_sds_smp_remo
  */
 static enum sci_status scic_sds_smp_remote_device_ready_cmd_substate_complete_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status;
 	struct scic_sds_remote_device *this_device;
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_ssp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_ssp_request.c	2011-03-28 11:21:32.989839000 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_ssp_request.c	2011-03-28 12:22:22.045838340 +0200
@@ -120,10 +120,8 @@ static enum sci_status scic_sds_ssp_task
 			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
 			);
 
-		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+		sci_base_state_machine_change_state(&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -143,20 +141,12 @@ static enum sci_status scic_sds_ssp_task
  * pattern for this particular device).
  */
 static enum sci_status scic_sds_ssp_task_request_await_tc_response_abort_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_ABORTING
-		);
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
-
+	sci_base_state_machine_change_state(&request->state_machine,
+			SCI_BASE_REQUEST_STATE_ABORTING);
+	sci_base_state_machine_change_state(&request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 	return SCI_SUCCESS;
 }
 
@@ -176,41 +166,36 @@ static enum sci_status scic_sds_ssp_task
  * probably update to check frame type and make sure it is a response frame.
  */
 static enum sci_status scic_sds_ssp_task_request_await_tc_response_frame_handler(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 frame_index)
 {
-	scic_sds_io_request_copy_response(this_request);
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
-
-	scic_sds_controller_release_frame(
-		this_request->owning_controller, frame_index
-		);
+	scic_sds_io_request_copy_response(request);
 
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
+	scic_sds_controller_release_frame(request->owning_controller,
+			frame_index);
 	return SCI_SUCCESS;
 }
 
 static const struct scic_sds_io_request_state_handler scic_sds_ssp_task_request_started_substate_handler_table[] = {
 	[SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_COMPLETION] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_ssp_task_request_await_tc_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_ssp_task_request_await_tc_completion_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_RESPONSE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_ssp_task_request_await_tc_response_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_ssp_task_request_await_tc_response_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_ssp_task_request_await_tc_response_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_ssp_task_request_await_tc_response_frame_handler,
 	}
 };
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_packet_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_packet_request.c	2011-03-28 11:21:33.009844742 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_packet_request.c	2011-03-28 11:36:39.425839493 +0200
@@ -659,16 +659,12 @@ enum sci_status scic_sds_stp_packet_requ
 }
 
 enum sci_status scic_sds_stp_packet_request_started_completion_delay_complete_handler(
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
+	sci_base_state_machine_change_state(&request->parent.state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
 
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
-
-	return this_request->sci_status;
+	return request->sci_status;
 }
 
 /* --------------------------------------------------------------------------- */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_remote_device.c	2011-03-28 11:21:33.029840702 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_remote_device.c	2011-03-28 12:21:27.245402648 +0200
@@ -78,22 +78,20 @@
  */
 static enum sci_status scic_sds_stp_remote_device_complete_request(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
 	enum sci_status status;
 
-	status = scic_sds_io_request_complete(the_request);
+	status = scic_sds_io_request_complete(request);
 
 	if (status == SCI_SUCCESS) {
 		status = scic_sds_port_complete_io(
-			this_device->owning_port, this_device, the_request
-			);
+			this_device->owning_port, this_device, request);
 
 		if (status == SCI_SUCCESS) {
 			scic_sds_remote_device_decrement_request_count(this_device);
-			if (the_request->sci_status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
+			if (request->sci_status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
 				/*
 				 * This request causes hardware error, device needs to be Lun Reset.
 				 * So here we force the state machine to IDLE state so the rest IOs
@@ -119,7 +117,7 @@ static enum sci_status scic_sds_stp_remo
 			__func__,
 			this_device->owning_port,
 			this_device,
-			the_request,
+			request,
 			status);
 
 	return status;
@@ -143,64 +141,54 @@ static enum sci_status scic_sds_stp_remo
  */
 static enum sci_status scic_sds_stp_remote_device_ready_substate_start_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status;
 	struct scic_sds_remote_device *this_device  = (struct scic_sds_remote_device *)device;
-	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
 
 	/* Will the port allow the io request to start? */
 	status = this_device->owning_port->state_handlers->start_io_handler(
-		this_device->owning_port,
-		this_device,
-		this_request
-		);
-
-	if (SCI_SUCCESS == status) {
-		status =
-			scic_sds_remote_node_context_start_task(this_device->rnc, this_request);
-
-		if (SCI_SUCCESS == status) {
-			status = this_request->state_handlers->parent.start_handler(request);
-		}
-
-		if (status == SCI_SUCCESS) {
-			/*
-			 * / @note If the remote device state is not IDLE this will replace
-			 * /       the request that probably resulted in the task management
-			 * /       request. */
-			this_device->working_request = this_request;
+		this_device->owning_port, this_device, request);
+	if (status != SCI_SUCCESS)
+		return status;
 
-			sci_base_state_machine_change_state(
-				&this_device->ready_substate_machine,
-				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD
-				);
+	status = scic_sds_remote_node_context_start_task(this_device->rnc, request);
+	if (status != SCI_SUCCESS)
+		goto out;
 
-			/*
-			 * The remote node context must cleanup the TCi to NCQ mapping table.
-			 * The only way to do this correctly is to either write to the TLCR
-			 * register or to invalidate and repost the RNC. In either case the
-			 * remote node context state machine will take the correct action when
-			 * the remote node context is suspended and later resumed. */
-			scic_sds_remote_node_context_suspend(
-				this_device->rnc, SCI_SOFTWARE_SUSPENSION, NULL, NULL);
-
-			scic_sds_remote_node_context_resume(
-				this_device->rnc,
-				scic_sds_remote_device_continue_request,
-				this_device);
-		}
+	status = request->state_handlers->start_handler(request);
+	if (status != SCI_SUCCESS)
+		goto out;
 
-		scic_sds_remote_device_start_request(this_device, this_request, status);
+	/*
+	 * Note: If the remote device state is not IDLE this will replace
+	 * the request that probably resulted in the task management request.
+	 */
+	this_device->working_request = request;
+	sci_base_state_machine_change_state(&this_device->ready_substate_machine,
+			SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
 
-		/*
-		 * We need to let the controller start request handler know that it can't
-		 * post TC yet. We will provide a callback function to post TC when RNC gets
-		 * resumed. */
-		return SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS;
-	}
+	/*
+	 * The remote node context must cleanup the TCi to NCQ mapping table.
+	 * The only way to do this correctly is to either write to the TLCR
+	 * register or to invalidate and repost the RNC. In either case the
+	 * remote node context state machine will take the correct action when
+	 * the remote node context is suspended and later resumed.
+	 */
+	scic_sds_remote_node_context_suspend(this_device->rnc,
+			SCI_SOFTWARE_SUSPENSION, NULL, NULL);
+	scic_sds_remote_node_context_resume(this_device->rnc,
+			scic_sds_remote_device_continue_request,
+			this_device);
 
-	return status;
+out:
+	scic_sds_remote_device_start_request(this_device, request, status);
+	/*
+	 * We need to let the controller start request handler know that it can't
+	 * post TC yet. We will provide a callback function to post TC when RNC gets
+	 * resumed.
+	 */
+	return SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS;
 }
 
 /*
@@ -221,53 +209,39 @@ static enum sci_status scic_sds_stp_remo
  */
 static enum sci_status scic_sds_stp_remote_device_ready_idle_substate_start_io_handler(
 	struct sci_base_remote_device *base_device,
-	struct sci_base_request *base_request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status;
 	struct scic_sds_remote_device *device =
 		(struct scic_sds_remote_device *)&base_device->parent;
-	struct scic_sds_request *sds_request  =
-		(struct scic_sds_request *)&base_request->parent;
 	struct isci_request *isci_request =
-		(struct isci_request *)sci_object_get_association(sds_request);
+		(struct isci_request *)sci_object_get_association(request);
 
 
 	/* Will the port allow the io request to start? */
 	status = device->owning_port->state_handlers->start_io_handler(
-			device->owning_port,
-			device,
-			sds_request);
-
-	if (status == SCI_SUCCESS) {
-		status =
-			scic_sds_remote_node_context_start_io(device->rnc,
-							      sds_request);
-
-		if (status == SCI_SUCCESS)
-			status =
-				sds_request->state_handlers->
-					parent.start_handler(base_request);
+			device->owning_port, device, request);
+	if (status != SCI_SUCCESS)
+		return status;
 
-		if (status == SCI_SUCCESS) {
-			if (isci_sata_get_sat_protocol(isci_request) ==
-					SAT_PROTOCOL_FPDMA)
-				sci_base_state_machine_change_state(
-					&device->ready_substate_machine,
-					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ);
-			else {
-				device->working_request = sds_request;
+	status = scic_sds_remote_node_context_start_io(device->rnc, request);
+	if (status != SCI_SUCCESS)
+		goto out;
 
-				sci_base_state_machine_change_state(
-					&device->ready_substate_machine,
-					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
-			}
-		}
+	status = request->state_handlers->start_handler(request);
+	if (status != SCI_SUCCESS)
+		goto out;
 
-		scic_sds_remote_device_start_request(device,
-						     sds_request,
-						     status);
+	if (isci_sata_get_sat_protocol(isci_request) == SAT_PROTOCOL_FPDMA) {
+		sci_base_state_machine_change_state(&device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ);
+	} else {
+		device->working_request = request;
+		sci_base_state_machine_change_state(&device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
 	}
-
+out:
+	scic_sds_remote_device_start_request(device, request, status);
 	return status;
 }
 
@@ -308,33 +282,30 @@ static enum sci_status scic_sds_stp_remo
 
 static enum sci_status scic_sds_stp_remote_device_ready_ncq_substate_start_io_handler(
 	struct sci_base_remote_device *base_device,
-	struct sci_base_request *base_request)
+	struct scic_sds_request *request)
 {
 	enum sci_status status;
 	struct scic_sds_remote_device *device =
 		(struct scic_sds_remote_device *)&base_device->parent;
-	struct scic_sds_request *sds_request  =
-		(struct scic_sds_request *)&base_request->parent;
 	struct isci_request *isci_request =
-		(struct isci_request *)sci_object_get_association(sds_request);
+		(struct isci_request *)sci_object_get_association(request);
 
 	if (isci_sata_get_sat_protocol(isci_request) == SAT_PROTOCOL_FPDMA) {
 		status = device->owning_port->state_handlers->start_io_handler(
 				device->owning_port,
 				device,
-				sds_request);
+				request);
 
 		if (status == SCI_SUCCESS) {
 			status = scic_sds_remote_node_context_start_io(
 					device->rnc,
-					sds_request);
+					request);
 
 			if (status == SCI_SUCCESS)
-				status = sds_request->state_handlers->
-					parent.start_handler(base_request);
+				status = request->state_handlers->start_handler(request);
 
 			scic_sds_remote_device_start_request(device,
-							     sds_request,
+							     request,
 							     status);
 		}
 	} else
@@ -422,7 +393,7 @@ static enum sci_status scic_sds_stp_remo
  */
 static enum sci_status scic_sds_stp_remote_device_ready_cmd_substate_start_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return SCI_FAILURE_INVALID_STATE;
 }
@@ -475,7 +446,7 @@ static enum sci_status scic_sds_stp_remo
  * ***************************************************************************** */
 static enum sci_status scic_sds_stp_remote_device_ready_await_reset_substate_start_io_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	return SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED;
 }
@@ -494,7 +465,7 @@ static enum sci_status scic_sds_stp_remo
  */
 static enum sci_status scic_sds_stp_remote_device_ready_await_reset_substate_complete_request_handler(
 	struct sci_base_remote_device *device,
-	struct sci_base_request *request)
+	struct scic_sds_request *request)
 {
 	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
 	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_smp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_smp_request.c	2011-03-28 12:02:45.578837563 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_smp_request.c	2011-03-28 12:23:16.189838474 +0200
@@ -394,7 +394,7 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
+			&this_request->state_machine,
 			SCI_BASE_REQUEST_STATE_COMPLETED
 			);
 	}
@@ -433,9 +433,8 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_SMP_RESP_TO_ERR):
@@ -452,9 +451,8 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 
 	default:
@@ -468,9 +466,8 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -502,9 +499,8 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 
 	default:
@@ -518,9 +514,8 @@ static enum sci_status scic_sds_smp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -530,22 +525,22 @@ static enum sci_status scic_sds_smp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_smp_request_started_substate_handler_table[] = {
 	[SCIC_SDS_SMP_REQUEST_STARTED_SUBSTATE_AWAIT_RESPONSE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_smp_request_await_response_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_smp_request_await_response_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_smp_request_await_response_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_smp_request_await_response_frame_handler,
 	},
 	[SCIC_SDS_SMP_REQUEST_STARTED_SUBSTATE_AWAIT_TC_COMPLETION] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   =  scic_sds_smp_request_await_tc_completion_tc_completion_handler,
-		.event_handler           =  scic_sds_request_default_event_handler,
-		.frame_handler           =  scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	=  scic_sds_smp_request_await_tc_completion_tc_completion_handler,
+		.event_handler		=  scic_sds_request_default_event_handler,
+		.frame_handler		=  scic_sds_request_default_frame_handler,
 	}
 };
 
@@ -626,7 +621,7 @@ enum sci_status scic_io_request_construc
 	/* Construct the started sub-state machine. */
 	sci_base_state_machine_construct(
 		&sci_req->started_substate_machine,
-		&sci_req->parent.parent,
+		&sci_req->parent,
 		scic_sds_smp_request_started_substate_table,
 		SCIC_SDS_SMP_REQUEST_STARTED_SUBSTATE_AWAIT_RESPONSE
 		);
@@ -657,10 +652,8 @@ enum sci_status scic_io_request_construc
 
 	scu_smp_request_construct_task_context(sci_req, smp_req);
 
-	sci_base_state_machine_change_state(
-		&sci_req->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_CONSTRUCTED
-		);
+	sci_base_state_machine_change_state(&sci_req->state_machine,
+		SCI_BASE_REQUEST_STATE_CONSTRUCTED);
 
 	kfree(smp_req);
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-28 11:53:12.190837117 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-28 12:16:18.761839304 +0200
@@ -465,8 +465,7 @@ static enum sci_status scic_sds_stp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine, SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -495,7 +494,7 @@ static enum sci_status scic_sds_stp_requ
 	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
 
 	status = scic_sds_unsolicited_frame_control_get_header(
-		&(this_request->parent.owning_controller->uf_control),
+		&this_request->parent.owning_controller->uf_control,
 		frame_index,
 		(void **)&frame_header
 		);
@@ -504,7 +503,7 @@ static enum sci_status scic_sds_stp_requ
 		switch (frame_header->fis_type) {
 		case SATA_FIS_TYPE_REGD2H:
 			scic_sds_unsolicited_frame_control_get_buffer(
-				&(this_request->parent.owning_controller->uf_control),
+				&this_request->parent.owning_controller->uf_control,
 				frame_index,
 				(void **)&frame_buffer
 				);
@@ -536,14 +535,13 @@ static enum sci_status scic_sds_stp_requ
 		}
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.parent.state_machine,
+			&this_request->parent.state_machine,
 			SCI_BASE_REQUEST_STATE_COMPLETED
 			);
 
 		/* Frame has been decoded return it to the controller */
 		scic_sds_controller_release_frame(
-			this_request->parent.owning_controller, frame_index
-			);
+			this_request->parent.owning_controller, frame_index);
 	} else
 		dev_err(scic_to_dev(request->owning_controller),
 			"%s: SCIC IO Request 0x%p could not get frame header "
@@ -557,22 +555,22 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_non_data_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_non_data_await_h2d_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_non_data_await_h2d_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_stp_request_non_data_await_d2h_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_stp_request_non_data_await_d2h_frame_handler,
 	}
 };
 
@@ -625,7 +623,7 @@ enum sci_status scic_sds_stp_non_data_re
 	scu_stp_raw_request_construct_task_context(stp_req, sci_req->task_context_buffer);
 
 	sci_base_state_machine_construct(&sci_req->started_substate_machine,
-					 &sci_req->parent.parent,
+					 &sci_req->parent,
 					 scic_sds_stp_request_started_non_data_substate_table,
 					 SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE);
 
@@ -677,8 +675,7 @@ static enum sci_status scic_sds_stp_requ
 	scic = this_request->owning_controller;
 	state = scic->state_machine.current_state_id;
 	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
-	return continue_io(scic, &this_request->target_device->parent,
-			   &this_request->parent);
+	return continue_io(scic, &this_request->target_device->parent, this_request);
 }
 
 /**
@@ -859,7 +856,7 @@ static enum sci_status scic_sds_stp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
+			&this_request->state_machine,
 			SCI_BASE_REQUEST_STATE_COMPLETED
 			);
 		break;
@@ -961,7 +958,7 @@ static enum sci_status scic_sds_stp_requ
 					);
 
 				sci_base_state_machine_change_state(
-					&this_request->parent.parent.state_machine,
+					&this_request->parent.state_machine,
 					SCI_BASE_REQUEST_STATE_COMPLETED
 					);
 			} else {
@@ -1056,12 +1053,12 @@ static enum sci_status scic_sds_stp_requ
 						);
 
 					sci_base_state_machine_change_state(
-						&this_request->parent.parent.state_machine,
+						&this_request->parent.state_machine,
 						SCI_BASE_REQUEST_STATE_COMPLETED
 						);
 				} else {
 					sci_base_state_machine_change_state(
-						&this_request->parent.started_substate_machine,
+						&request->started_substate_machine,
 						SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
 						);
 				}
@@ -1083,7 +1080,7 @@ static enum sci_status scic_sds_stp_requ
 				);
 
 			sci_base_state_machine_change_state(
-				&this_request->parent.parent.state_machine,
+				&this_request->parent.state_machine,
 				SCI_BASE_REQUEST_STATE_COMPLETED
 				);
 
@@ -1160,7 +1157,7 @@ static enum sci_status scic_sds_stp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine,
+			&this_request->state_machine,
 			SCI_BASE_REQUEST_STATE_COMPLETED
 			);
 		break;
@@ -1215,40 +1212,40 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_pio_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_pio_await_h2d_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_pio_await_h2d_completion_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_stp_request_pio_await_frame_frame_handler
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_stp_request_pio_await_frame_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_stp_request_pio_data_in_await_data_event_handler,
-		.frame_handler           = scic_sds_stp_request_pio_data_in_await_data_frame_handler
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_stp_request_pio_data_in_await_data_event_handler,
+		.frame_handler		= scic_sds_stp_request_pio_data_in_await_data_frame_handler
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_pio_data_out_await_data_transmit_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_pio_data_out_await_data_transmit_completion_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	}
 };
 
@@ -1352,7 +1349,7 @@ enum sci_status scic_sds_stp_pio_request
 	}
 
 	sci_base_state_machine_construct(&sci_req->started_substate_machine,
-					 &sci_req->parent.parent,
+					 &sci_req->parent,
 					 scic_sds_stp_request_started_pio_substate_table,
 					 SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE);
 
@@ -1360,18 +1357,13 @@ enum sci_status scic_sds_stp_pio_request
 }
 
 static void scic_sds_stp_request_udma_complete_request(
-	struct scic_sds_request *this_request,
+	struct scic_sds_request *request,
 	u32 scu_status,
 	enum sci_status sci_status)
 {
-	scic_sds_request_set_status(
-		this_request, scu_status, sci_status
-		);
-
-	sci_base_state_machine_change_state(
-		&this_request->parent.state_machine,
-		SCI_BASE_REQUEST_STATE_COMPLETED
-		);
+	scic_sds_request_set_status(request, scu_status, sci_status);
+	sci_base_state_machine_change_state(&request->state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED);
 }
 
 /**
@@ -1518,22 +1510,22 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_udma_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_udma_await_tc_completion_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_stp_request_udma_general_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_udma_await_tc_completion_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_stp_request_udma_general_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_stp_request_udma_await_d2h_reg_fis_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_stp_request_udma_await_d2h_reg_fis_frame_handler,
 	},
 };
 
@@ -1590,7 +1582,7 @@ enum sci_status scic_sds_stp_udma_reques
 
 	sci_base_state_machine_construct(
 		&sci_req->started_substate_machine,
-		&sci_req->parent.parent,
+		&sci_req->parent,
 		scic_sds_stp_request_started_udma_substate_table,
 		SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE
 		);
@@ -1635,8 +1627,7 @@ static enum sci_status scic_sds_stp_requ
 			);
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->state_machine, SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -1679,9 +1670,8 @@ static enum sci_status scic_sds_stp_requ
 			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
 			);
 
-		sci_base_state_machine_change_state(
-			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+		sci_base_state_machine_change_state(&this_request->state_machine,
+				SCI_BASE_REQUEST_STATE_COMPLETED);
 		break;
 	}
 
@@ -1753,9 +1743,8 @@ static enum sci_status scic_sds_stp_requ
 		}
 
 		sci_base_state_machine_change_state(
-			&this_request->parent.parent.state_machine,
-			SCI_BASE_REQUEST_STATE_COMPLETED
-			);
+			&this_request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED);
 
 		/* Frame has been decoded return it to the controller */
 		scic_sds_controller_release_frame(
@@ -1774,31 +1763,31 @@ static enum sci_status scic_sds_stp_requ
 
 static const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_soft_reset_substate_handler_table[] = {
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_soft_reset_await_h2d_asserted_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_soft_reset_await_h2d_asserted_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_stp_request_soft_reset_await_h2d_diagnostic_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_request_default_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_stp_request_soft_reset_await_h2d_diagnostic_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_request_default_frame_handler,
 	},
 	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE] = {
-		.parent.start_handler    = scic_sds_request_default_start_handler,
-		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
-		.parent.complete_handler = scic_sds_request_default_complete_handler,
-		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
-		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
-		.event_handler           = scic_sds_request_default_event_handler,
-		.frame_handler           = scic_sds_stp_request_soft_reset_await_d2h_frame_handler,
+		.start_handler		= scic_sds_request_default_start_handler,
+		.abort_handler		= scic_sds_request_started_state_abort_handler,
+		.complete_handler	= scic_sds_request_default_complete_handler,
+		.destruct_handler	= scic_sds_request_default_destruct_handler,
+		.tc_completion_handler	= scic_sds_request_default_tc_completion_handler,
+		.event_handler		= scic_sds_request_default_event_handler,
+		.frame_handler		= scic_sds_stp_request_soft_reset_await_d2h_frame_handler,
 	},
 };
 
@@ -1842,8 +1831,7 @@ static void scic_sds_stp_request_started
 	state = scic->state_machine.current_state_id;
 	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
 
-	status = continue_io(scic, &this_request->target_device->parent,
-			     &this_request->parent);
+	status = continue_io(scic, &this_request->target_device->parent, this_request);
 
 	if (status == SCI_SUCCESS) {
 		SET_STATE_HANDLER(
@@ -1888,7 +1876,7 @@ enum sci_status scic_sds_stp_soft_reset_
 	scu_stp_raw_request_construct_task_context(stp_req, sci_req->task_context_buffer);
 
 	sci_base_state_machine_construct(&sci_req->started_substate_machine,
-					 &sci_req->parent.parent,
+					 &sci_req->parent,
 					 scic_sds_stp_request_started_soft_reset_substate_table,
 					 SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE);
 
