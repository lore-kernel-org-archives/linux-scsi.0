From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] isci: remove base_controller abstraction
Date: Mon, 28 Mar 2011 09:21:04 -0400
Message-ID: <20110328132103.GA11684@infradead.org>
References: <20110328000754.GA28347@infradead.org>
 <20110328132046.GA497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1C1NVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 09:21:04 -0400
Content-Disposition: inline
In-Reply-To: <20110328132046.GA497@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Merge struct sci_base_controller into scic_sds_controller, and also factor
the two types of state machine handlers into one function.  While we're at
it also remove lots of duplicate incorrect kerneldoc comments for the state
machine handlers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/isci/core/sci_base_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_base_controller.h	2011-03-28 10:47:51.502837983 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,304 +0,0 @@
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
-#ifndef _SCI_BASE_CONTROLLER_H_
-#define _SCI_BASE_CONTROLLER_H_
-
-#include "intel_sas.h"
-#include "sci_controller_constants.h"
-#include "sci_base_state.h"
-#include "sci_base_memory_descriptor_list.h"
-#include "sci_base_state_machine.h"
-#include "sci_object.h"
-
-struct sci_base_memory_descriptor_list;
-
-/**
- * enum sci_base_controller_states - This enumeration depicts all the states
- *    for the common controller state machine.
- *
- *
- */
-enum sci_base_controller_states {
-	/**
-	 * Simply the initial state for the base controller state machine.
-	 */
-	SCI_BASE_CONTROLLER_STATE_INITIAL = 0,
-
-	/**
-	 * This state indicates that the controller is reset.  The memory for
-	 * the controller is in it's initial state, but the controller requires
-	 * initialization.
-	 * This state is entered from the INITIAL state.
-	 * This state is entered from the RESETTING state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_RESET,
-
-	/**
-	 * This state is typically an action state that indicates the controller
-	 * is in the process of initialization.  In this state no new IO operations
-	 * are permitted.
-	 * This state is entered from the RESET state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_INITIALIZING,
-
-	/**
-	 * This state indicates that the controller has been successfully
-	 * initialized.  In this state no new IO operations are permitted.
-	 * This state is entered from the INITIALIZING state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_INITIALIZED,
-
-	/**
-	 * This state indicates the the controller is in the process of becoming
-	 * ready (i.e. starting).  In this state no new IO operations are permitted.
-	 * This state is entered from the INITIALIZED state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_STARTING,
-
-	/**
-	 * This state indicates the controller is now ready.  Thus, the user
-	 * is able to perform IO operations on the controller.
-	 * This state is entered from the STARTING state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_READY,
-
-	/**
-	 * This state is typically an action state that indicates the controller
-	 * is in the process of resetting.  Thus, the user is unable to perform
-	 * IO operations on the controller.  A reset is considered destructive in
-	 * most cases.
-	 * This state is entered from the READY state.
-	 * This state is entered from the FAILED state.
-	 * This state is entered from the STOPPED state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_RESETTING,
-
-	/**
-	 * This state indicates that the controller is in the process of stopping.
-	 * In this state no new IO operations are permitted, but existing IO
-	 * operations are allowed to complete.
-	 * This state is entered from the READY state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_STOPPING,
-
-	/**
-	 * This state indicates that the controller has successfully been stopped.
-	 * In this state no new IO operations are permitted.
-	 * This state is entered from the STOPPING state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_STOPPED,
-
-	/**
-	 * This state indicates that the controller could not successfully be
-	 * initialized.  In this state no new IO operations are permitted.
-	 * This state is entered from the INITIALIZING state.
-	 * This state is entered from the STARTING state.
-	 * This state is entered from the STOPPING state.
-	 * This state is entered from the RESETTING state.
-	 */
-	SCI_BASE_CONTROLLER_STATE_FAILED,
-
-	SCI_BASE_CONTROLLER_MAX_STATES
-
-};
-
-/**
- * struct sci_base_controller - The base controller object abstracts the fields
- *    common to all SCI controller objects.
- *
- *
- */
-struct sci_base_controller {
-	/**
-	 * The field specifies that the parent object for the base controller
-	 * is the base object itself.
-	 */
-	struct sci_base_object parent;
-
-	/**
-	 * This field points to the memory descriptor list associated with this
-	 * controller.  The MDL indicates the memory requirements necessary for
-	 * this controller object.
-	 */
-	struct sci_base_memory_descriptor_list mdl;
-
-	/**
-	 * This field contains the information for the base controller state
-	 * machine.
-	 */
-	struct sci_base_state_machine state_machine;
-};
-
-/* Forward declarations */
-struct sci_base_remote_device;
-struct sci_base_request;
-
-typedef enum sci_status
-(*sci_base_controller_handler_t)(struct sci_base_controller *);
-
-typedef enum sci_status
-(*sci_base_controller_timed_handler_t)(struct sci_base_controller *, u32);
-
-typedef enum sci_status
-(*sci_base_controller_request_handler_t)(struct sci_base_controller *,
-					 struct sci_base_remote_device *,
-					 struct sci_base_request *);
-
-typedef enum sci_status
-(*sci_base_controller_start_request_handler_t)(struct sci_base_controller *,
-					       struct sci_base_remote_device *,
-					       struct sci_base_request *, u16);
-
-/**
- * struct sci_base_controller_state_handler - This structure contains all of
- *    the state handler methods common to base controller state machines.
- *    Handler methods provide the ability to change the behavior for user
- *    requests or transitions depending on the state the machine is in.
- *
- *
- */
-struct sci_base_controller_state_handler {
-	/**
-	 * The start_handler specifies the method invoked when a user attempts to
-	 * start a controller.
-	 */
-	sci_base_controller_timed_handler_t start;
-
-	/**
-	 * The stop_handler specifies the method invoked when a user attempts to
-	 * stop a controller.
-	 */
-	sci_base_controller_timed_handler_t stop;
-
-	/**
-	 * The reset_handler specifies the method invoked when a user attempts to
-	 * reset a controller.
-	 */
-	sci_base_controller_handler_t reset;
-
-	/**
-	 * The initialize_handler specifies the method invoked when a user
-	 * attempts to initialize a controller.
-	 */
-	sci_base_controller_handler_t initialize;
-
-	/**
-	 * The start_io_handler specifies the method invoked when a user
-	 * attempts to start an IO request for a controller.
-	 */
-	sci_base_controller_start_request_handler_t start_io;
-
-	/**
-	 * The complete_io_handler specifies the method invoked when a user
-	 * attempts to complete an IO request for a controller.
-	 */
-	sci_base_controller_request_handler_t complete_io;
-
-	/**
-	 * The continue_io_handler specifies the method invoked when a user
-	 * attempts to continue an IO request for a controller.
-	 */
-	sci_base_controller_request_handler_t continue_io;
-
-	/**
-	 * The start_task_handler specifies the method invoked when a user
-	 * attempts to start a task management request for a controller.
-	 */
-	sci_base_controller_start_request_handler_t start_task;
-
-	/**
-	 * The complete_task_handler specifies the method invoked when a user
-	 * attempts to complete a task management request for a controller.
-	 */
-	sci_base_controller_request_handler_t complete_task;
-
-};
-
-/**
- * sci_base_controller_construct() - Construct the base controller
- * @this_controller: This parameter specifies the base controller to be
- *    constructed.
- * @state_table: This parameter specifies the table of state definitions to be
- *    utilized for the controller state machine.
- * @mde_array: This parameter specifies the array of memory descriptor entries
- *    to be managed by this list.
- * @mde_array_length: This parameter specifies the size of the array of entries.
- * @next_mdl: This parameter specifies a subsequent MDL object to be managed by
- *    this MDL object.
- * @oem_parameters: This parameter specifies the original equipment
- *    manufacturer parameters to be utilized by this controller object.
- *
- */
-static inline void sci_base_controller_construct(
-	struct sci_base_controller *scic_base,
-	const struct sci_base_state *state_table,
-	struct sci_physical_memory_descriptor *mdes,
-	u32 mde_count,
-	struct sci_base_memory_descriptor_list *next_mdl)
-{
-	sci_base_state_machine_construct(
-		&scic_base->state_machine,
-		&scic_base->parent,
-		state_table,
-		SCI_BASE_CONTROLLER_STATE_INITIAL
-		);
-
-	sci_base_mdl_construct(&scic_base->mdl, mdes, mde_count, next_mdl);
-
-	sci_base_state_machine_start(&scic_base->state_machine);
-}
-
-#endif /* _SCI_BASE_CONTROLLER_H_ */
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 10:47:51.518838336 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.c	2011-03-28 11:17:28.785838750 +0200
@@ -212,12 +212,6 @@ static void scic_sds_controller_power_co
 		SMU_CQGR_EVENT_CYCLE_BIT \
 		)
 
-struct sci_base_memory_descriptor_list *
-sci_controller_get_memory_descriptor_list_handle(struct scic_sds_controller *scic)
-{
-       return &scic->parent.mdl;
-}
-
 static void scic_sds_controller_initialize_power_control(struct scic_sds_controller *scic)
 {
 	struct isci_host *ihost = sci_object_get_association(scic);
@@ -688,13 +682,13 @@ static void scic_sds_controller_transiti
 {
 	struct isci_host *ihost = sci_object_get_association(scic);
 
-	if (scic->parent.state_machine.current_state_id ==
-			SCI_BASE_CONTROLLER_STATE_STARTING) {
+	if (scic->state_machine.current_state_id ==
+	    SCI_BASE_CONTROLLER_STATE_STARTING) {
 		/*
 		 * We move into the ready state, because some of the phys/ports
 		 * may be up and operational.
 		 */
-		sci_base_state_machine_change_state(&scic->parent.state_machine,
+		sci_base_state_machine_change_state(&scic->state_machine,
 						    SCI_BASE_CONTROLLER_STATE_READY);
 
 		isci_host_start_complete(ihost, status);
@@ -705,7 +699,7 @@ static void scic_sds_controller_timeout_
 {
 	struct scic_sds_controller *scic = _scic;
 	struct isci_host *ihost = sci_object_get_association(scic);
-	struct sci_base_state_machine *sm = &scic->parent.state_machine;
+	struct sci_base_state_machine *sm = &scic->state_machine;
 
 	if (sm->current_state_id == SCI_BASE_CONTROLLER_STATE_STARTING)
 		scic_sds_controller_transition_to_ready(scic, SCI_FAILURE_TIMEOUT);
@@ -1549,7 +1543,7 @@ void scic_sds_controller_error_handler(s
 		dev_err(scic_to_dev(scic), "%s: status: %#x\n", __func__,
 			interrupt_status);
 
-		sci_base_state_machine_change_state(&scic->parent.state_machine,
+		sci_base_state_machine_change_state(&scic->state_machine,
 						    SCI_BASE_CONTROLLER_STATE_FAILED);
 
 		return;
@@ -1572,7 +1566,7 @@ void scic_sds_controller_link_up(
 	scic_sds_controller_phy_handler_t link_up;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
+	state = scic->state_machine.current_state_id;
 	link_up = scic_sds_controller_state_handler_table[state].link_up;
 
 	if (link_up)
@@ -1593,7 +1587,7 @@ void scic_sds_controller_link_down(
 	u32 state;
 	scic_sds_controller_phy_handler_t link_down;
 
-	state = scic->parent.state_machine.current_state_id;
+	state = scic->state_machine.current_state_id;
 	link_down = scic_sds_controller_state_handler_table[state].link_down;
 
 	if (link_down)
@@ -1639,7 +1633,7 @@ void scic_sds_controller_remote_device_s
 	u32 state;
 	scic_sds_controller_device_handler_t stopped;
 
-	state = scic->parent.state_machine.current_state_id;
+	state = scic->state_machine.current_state_id;
 	stopped = scic_sds_controller_state_handler_table[state].device_stopped;
 
 	if (stopped)
@@ -1969,14 +1963,14 @@ enum sci_status scic_controller_initiali
 	struct scic_sds_controller *scic)
 {
 	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	sci_base_controller_handler_t initialize;
+	scic_sds_controller_handler_t initialize;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
-	initialize = scic_sds_controller_state_handler_table[state].base.initialize;
+	state = scic->state_machine.current_state_id;
+	initialize = scic_sds_controller_state_handler_table[state].initialize;
 
 	if (initialize)
-		status = initialize(&scic->parent);
+		status = initialize(scic);
 	else
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller initialize operation requested "
@@ -2050,14 +2044,14 @@ enum sci_status scic_controller_start(
 	u32 timeout)
 {
 	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	sci_base_controller_timed_handler_t start;
+	scic_sds_controller_timed_handler_t start;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
-	start = scic_sds_controller_state_handler_table[state].base.start;
+	state = scic->state_machine.current_state_id;
+	start = scic_sds_controller_state_handler_table[state].start;
 
 	if (start)
-		status = start(&scic->parent, timeout);
+		status = start(scic, timeout);
 	else
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller start operation requested in "
@@ -2089,14 +2083,14 @@ enum sci_status scic_controller_stop(
 	u32 timeout)
 {
 	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	sci_base_controller_timed_handler_t stop;
+	scic_sds_controller_timed_handler_t stop;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
-	stop = scic_sds_controller_state_handler_table[state].base.stop;
+	state = scic->state_machine.current_state_id;
+	stop = scic_sds_controller_state_handler_table[state].stop;
 
 	if (stop)
-		status = stop(&scic->parent, timeout);
+		status = stop(scic, timeout);
 	else
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller stop operation requested in "
@@ -2121,14 +2115,14 @@ enum sci_status scic_controller_reset(
 	struct scic_sds_controller *scic)
 {
 	enum sci_status status = SCI_FAILURE_INVALID_STATE;
-	sci_base_controller_handler_t reset;
+	scic_sds_controller_handler_t reset;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
-	reset = scic_sds_controller_state_handler_table[state].base.reset;
+	state = scic->state_machine.current_state_id;
+	reset = scic_sds_controller_state_handler_table[state].reset;
 
 	if (reset)
-		status = reset(&scic->parent);
+		status = reset(scic);
 	else
 		dev_warn(scic_to_dev(scic),
 			 "%s: SCIC Controller reset operation requested in "
@@ -2171,12 +2165,12 @@ enum sci_io_status scic_controller_start
 	u16 io_tag)
 {
 	u32 state;
-	sci_base_controller_start_request_handler_t start_io;
+	scic_sds_controller_start_request_handler_t start_io;
 
-	state = scic->parent.state_machine.current_state_id;
-	start_io = scic_sds_controller_state_handler_table[state].base.start_io;
+	state = scic->state_machine.current_state_id;
+	start_io = scic_sds_controller_state_handler_table[state].start_io;
 
-	return start_io(&scic->parent,
+	return start_io(scic,
 			(struct sci_base_remote_device *) remote_device,
 			(struct sci_base_request *)io_request, io_tag);
 }
@@ -2202,13 +2196,13 @@ enum sci_status scic_controller_terminat
 	struct scic_sds_remote_device *remote_device,
 	struct scic_sds_request *request)
 {
-	sci_base_controller_request_handler_t terminate_request;
+	scic_sds_controller_request_handler_t terminate_request;
 	u32 state;
 
-	state = scic->parent.state_machine.current_state_id;
+	state = scic->state_machine.current_state_id;
 	terminate_request = scic_sds_controller_state_handler_table[state].terminate_request;
 
-	return terminate_request(&scic->parent,
+	return terminate_request(scic,
 				 (struct sci_base_remote_device *)remote_device,
 				 (struct sci_base_request *)request);
 }
@@ -2241,12 +2235,12 @@ enum sci_status scic_controller_complete
 	struct scic_sds_request *io_request)
 {
 	u32 state;
-	sci_base_controller_request_handler_t complete_io;
+	scic_sds_controller_request_handler_t complete_io;
 
-	state = scic->parent.state_machine.current_state_id;
-	complete_io = scic_sds_controller_state_handler_table[state].base.complete_io;
+	state = scic->state_machine.current_state_id;
+	complete_io = scic_sds_controller_state_handler_table[state].complete_io;
 
-	return complete_io(&scic->parent,
+	return complete_io(scic,
 			   (struct sci_base_remote_device *)remote_device,
 			   (struct sci_base_request *)io_request);
 }
@@ -2286,14 +2280,14 @@ enum sci_task_status scic_controller_sta
 	u16 task_tag)
 {
 	u32 state;
-	sci_base_controller_start_request_handler_t start_task;
+	scic_sds_controller_start_request_handler_t start_task;
 	enum sci_task_status status = SCI_TASK_FAILURE_INVALID_STATE;
 
-	state = scic->parent.state_machine.current_state_id;
-	start_task = scic_sds_controller_state_handler_table[state].base.start_task;
+	state = scic->state_machine.current_state_id;
+	start_task = scic_sds_controller_state_handler_table[state].start_task;
 
 	if (start_task)
-		status = start_task(&scic->parent,
+		status = start_task(scic,
 				    (struct sci_base_remote_device *)remote_device,
 				    (struct sci_base_request *)task_request,
 				    task_tag);
@@ -2326,14 +2320,14 @@ enum sci_status scic_controller_complete
 	struct scic_sds_request *task_request)
 {
 	u32 state;
-	sci_base_controller_request_handler_t complete_task;
+	scic_sds_controller_request_handler_t complete_task;
 	enum sci_status status = SCI_FAILURE_INVALID_STATE;
 
-	state = scic->parent.state_machine.current_state_id;
-	complete_task = scic_sds_controller_state_handler_table[state].base.complete_task;
+	state = scic->state_machine.current_state_id;
+	complete_task = scic_sds_controller_state_handler_table[state].complete_task;
 
 	if (complete_task)
-		status = complete_task(&scic->parent,
+		status = complete_task(scic,
 				       (struct sci_base_remote_device *)remote_device,
 				       (struct sci_base_request *)task_request);
 	else
@@ -2518,9 +2512,9 @@ static enum sci_status scic_controller_s
 {
 	enum sci_status status          = SCI_SUCCESS;
 
-	if ((scic->parent.state_machine.current_state_id ==
+	if ((scic->state_machine.current_state_id ==
 				SCI_BASE_CONTROLLER_STATE_INITIALIZING) ||
-	    (scic->parent.state_machine.current_state_id ==
+	    (scic->state_machine.current_state_id ==
 				SCI_BASE_CONTROLLER_STATE_INITIALIZED)) {
 		switch (operating_mode) {
 		case SCI_MODE_SPEED:
@@ -2583,7 +2577,7 @@ enum sci_status scic_user_parameters_set
 	struct scic_sds_controller *scic,
 	union scic_user_parameters *scic_parms)
 {
-	u32 state = scic->parent.state_machine.current_state_id;
+	u32 state = scic->state_machine.current_state_id;
 
 	if (state == SCI_BASE_CONTROLLER_STATE_RESET ||
 	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZING ||
@@ -2637,7 +2631,7 @@ enum sci_status scic_oem_parameters_set(
 	struct scic_sds_controller *scic,
 	union scic_oem_parameters *scic_parms)
 {
-	u32 state = scic->parent.state_machine.current_state_id;
+	u32 state = scic->state_machine.current_state_id;
 
 	if (state == SCI_BASE_CONTROLLER_STATE_RESET ||
 	    state == SCI_BASE_CONTROLLER_STATE_INITIALIZING ||
@@ -2819,54 +2813,52 @@ struct scic_sds_controller *scic_control
 	return devm_kzalloc(dev, sizeof(struct scic_sds_controller), GFP_KERNEL);
 }
 
-static enum sci_status default_controller_handler(struct sci_base_controller *base_scic,
-						  const char *func)
+static enum sci_status
+default_controller_handler(struct scic_sds_controller *scic, const char *func)
 {
-	struct scic_sds_controller *scic = container_of(base_scic, typeof(*scic), parent);
-	u32 state = base_scic->state_machine.current_state_id;
-
-	dev_warn(scic_to_dev(scic), "%s: invalid state %d\n", func, state);
+	dev_warn(scic_to_dev(scic), "%s: invalid state %d\n", func,
+		 scic->state_machine.current_state_id);
 
 	return SCI_FAILURE_INVALID_STATE;
 }
 
 static enum sci_status scic_sds_controller_default_start_operation_handler(
-	struct sci_base_controller *base_scic,
+	struct scic_sds_controller *scic,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request,
 	u16 io_tag)
 {
-	return default_controller_handler(base_scic, __func__);
+	return default_controller_handler(scic, __func__);
 }
 
 static enum sci_status scic_sds_controller_default_request_handler(
-	struct sci_base_controller *base_scic,
+	struct scic_sds_controller *scic,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request)
 {
-	return default_controller_handler(base_scic, __func__);
+	return default_controller_handler(scic, __func__);
 }
 
-static enum sci_status scic_sds_controller_general_reset_handler(struct sci_base_controller *base_scic)
+static enum sci_status
+scic_sds_controller_general_reset_handler(struct scic_sds_controller *scic)
 {
 	/* The reset operation is not a graceful cleanup just perform the state
 	 * transition.
 	 */
-	sci_base_state_machine_change_state(&base_scic->state_machine,
+	sci_base_state_machine_change_state(&scic->state_machine,
 					    SCI_BASE_CONTROLLER_STATE_RESETTING);
 
 	return SCI_SUCCESS;
 }
 
-static enum sci_status scic_sds_controller_reset_state_initialize_handler(struct sci_base_controller *base_scic)
+static enum sci_status
+scic_sds_controller_reset_state_initialize_handler(struct scic_sds_controller *scic)
 {
-	struct sci_base_state_machine *sm = &base_scic->state_machine;
+	struct sci_base_state_machine *sm = &scic->state_machine;
 	enum sci_status result = SCI_SUCCESS;
-	struct scic_sds_controller *scic;
 	struct isci_host *ihost;
 	u32 index, state;
 
-	scic = container_of(base_scic, typeof(*scic), parent);
 	ihost = sci_object_get_association(scic);
 
 	sci_base_state_machine_change_state(sm, SCI_BASE_CONTROLLER_STATE_INITIALIZING);
@@ -3028,13 +3020,7 @@ static enum sci_status scic_sds_controll
  * * INITIALIZED STATE HANDLERS
  * ***************************************************************************** */
 
-/**
- *
- * @controller: This is the struct sci_base_controller object which is cast
- * into a struct scic_sds_controller object.
- * @timeout: This is the allowed time for the controller object to reach the
- *    started state.
- *
+/*
  * This function is the struct scic_sds_controller start handler for the
  * initialized state.
  * - Validate we have a good memory descriptor table - Initialze the
@@ -3049,14 +3035,10 @@ static enum sci_status scic_sds_controll
  * descriptor fields is invalid.
  */
 static enum sci_status scic_sds_controller_initialized_state_start_handler(
-	struct sci_base_controller *base_scic,
-	u32 timeout)
+	struct scic_sds_controller *scic, u32 timeout)
 {
 	u16 index;
 	enum sci_status result;
-	struct scic_sds_controller *scic;
-
-	scic = container_of(base_scic, typeof(*scic), parent);
 
 	/*
 	 * Make sure that the SCI User filled in the memory descriptor
@@ -3119,7 +3101,7 @@ static enum sci_status scic_sds_controll
 
 		isci_timer_start(scic->timeout_timer, timeout);
 
-		sci_base_state_machine_change_state(&base_scic->state_machine,
+		sci_base_state_machine_change_state(&scic->state_machine,
 						    SCI_BASE_CONTROLLER_STATE_STARTING);
 	}
 
@@ -3180,79 +3162,54 @@ static void scic_sds_controller_starting
 	/* scic_sds_port_link_down(port, phy); */
 }
 
-static enum sci_status scic_sds_controller_ready_state_stop_handler(struct sci_base_controller *base_scic,
-								    u32 timeout)
+static enum sci_status scic_sds_controller_ready_state_stop_handler(
+		struct scic_sds_controller *scic,
+		u32 timeout)
 {
-	struct scic_sds_controller *scic;
-
-	scic = container_of(base_scic, typeof(*scic), parent);
 	isci_timer_start(scic->timeout_timer, timeout);
-	sci_base_state_machine_change_state(&base_scic->state_machine,
+	sci_base_state_machine_change_state(&scic->state_machine,
 					    SCI_BASE_CONTROLLER_STATE_STOPPING);
-
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- * @io_tag: This is the IO tag to be assigned to the IO request or
- *    SCI_CONTROLLER_INVALID_IO_TAG.
- *
+/*
  * This method is called when the struct scic_sds_controller is in the ready state and
  * the start io handler is called. - Start the io request on the remote device
  * - if successful - assign the io_request to the io_request_table - post the
  * request to the hardware enum sci_status SCI_SUCCESS if the start io operation
  * succeeds SCI_FAILURE_INSUFFICIENT_RESOURCES if the IO tag could not be
  * allocated for the io request. SCI_FAILURE_INVALID_STATE if one or more
- * objects are not in a valid state to accept io requests. How does the io_tag
- * parameter get assigned to the io request?
+ * objects are not in a valid state to accept io requests.
+ *
+ * XXX: How does the io_tag parameter get assigned to the io request?
  */
 static enum sci_status scic_sds_controller_ready_state_start_io_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request,
 	u16 io_tag)
 {
 	enum sci_status status;
 
-	struct scic_sds_controller *this_controller;
 	struct scic_sds_request *the_request;
 	struct scic_sds_remote_device *the_device;
 
-	this_controller = (struct scic_sds_controller *)controller;
 	the_request = (struct scic_sds_request *)io_request;
 	the_device = (struct scic_sds_remote_device *)remote_device;
 
-	status = scic_sds_remote_device_start_io(this_controller, the_device, the_request);
-
-	if (status == SCI_SUCCESS) {
-		this_controller->io_request_table[
-			scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+	status = scic_sds_remote_device_start_io(controller, the_device, the_request);
 
-		scic_sds_controller_post_request(
-			this_controller,
-			scic_sds_request_get_post_context(the_request)
-			);
-	}
+	if (status != SCI_SUCCESS)
+		return status;
 
-	return status;
+	controller->io_request_table[
+		scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
+	scic_sds_controller_post_request(controller,
+		scic_sds_request_get_post_context(the_request));
+	return SCI_SUCCESS;
 }
 
-/**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- *
+/*
  * This method is called when the struct scic_sds_controller is in the ready state and
  * the complete io handler is called. - Complete the io request on the remote
  * device - if successful - remove the io_request to the io_request_table
@@ -3261,76 +3218,49 @@ static enum sci_status scic_sds_controll
  * accept io requests.
  */
 static enum sci_status scic_sds_controller_ready_state_complete_io_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request)
 {
 	u16 index;
 	enum sci_status status;
-	struct scic_sds_controller *this_controller;
 	struct scic_sds_request *the_request;
 	struct scic_sds_remote_device *the_device;
 
-	this_controller = (struct scic_sds_controller *)controller;
 	the_request = (struct scic_sds_request *)io_request;
 	the_device = (struct scic_sds_remote_device *)remote_device;
 
-	status = scic_sds_remote_device_complete_io(
-		this_controller, the_device, the_request);
-
-	if (status == SCI_SUCCESS) {
-		index = scic_sds_io_tag_get_index(the_request->io_tag);
-		this_controller->io_request_table[index] = NULL;
-	}
+	status = scic_sds_remote_device_complete_io(controller, the_device,
+			the_request);
+	if (status != SCI_SUCCESS)
+		return status;
 
-	return status;
+	index = scic_sds_io_tag_get_index(the_request->io_tag);
+	controller->io_request_table[index] = NULL;
+	return SCI_SUCCESS;
 }
 
-/**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- *
+/*
  * This method is called when the struct scic_sds_controller is in the ready state and
  * the continue io handler is called. enum sci_status
  */
 static enum sci_status scic_sds_controller_ready_state_continue_io_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request)
 {
-	struct scic_sds_controller *this_controller;
 	struct scic_sds_request *the_request;
 
 	the_request     = (struct scic_sds_request *)io_request;
-	this_controller = (struct scic_sds_controller *)controller;
 
-	this_controller->io_request_table[
+	controller->io_request_table[
 		scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
-
-	scic_sds_controller_post_request(
-		this_controller,
-		scic_sds_request_get_post_context(the_request)
-		);
-
+	scic_sds_controller_post_request(controller,
+		scic_sds_request_get_post_context(the_request));
 	return SCI_SUCCESS;
 }
 
-/**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- * @task_tag: This is the task tag to be assigned to the task request or
- *    SCI_CONTROLLER_INVALID_IO_TAG.
- *
+/*
  * This method is called when the struct scic_sds_controller is in the ready state and
  * the start task handler is called. - The remote device is requested to start
  * the task request - if successful - assign the task to the io_request_table -
@@ -3341,33 +3271,28 @@ static enum sci_status scic_sds_controll
  * tag get assigned in this code path?
  */
 static enum sci_status scic_sds_controller_ready_state_start_task_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request,
 	u16 task_tag)
 {
-	struct scic_sds_controller *this_controller = (struct scic_sds_controller *)
-						 controller;
 	struct scic_sds_request *the_request     = (struct scic_sds_request *)
 					      io_request;
 	struct scic_sds_remote_device *the_device      = (struct scic_sds_remote_device *)
 						    remote_device;
 	enum sci_status status;
 
-	status = scic_sds_remote_device_start_task(
-		this_controller, the_device, the_request
-		);
+	status = scic_sds_remote_device_start_task(controller, the_device,
+			the_request);
 
 	if (status == SCI_SUCCESS) {
-		this_controller->io_request_table[
+		controller->io_request_table[
 			scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
 
-		scic_sds_controller_post_request(
-			this_controller,
-			scic_sds_request_get_post_context(the_request)
-			);
+		scic_sds_controller_post_request(controller,
+			scic_sds_request_get_post_context(the_request));
 	} else if (status == SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS) {
-		this_controller->io_request_table[
+		controller->io_request_table[
 			scic_sds_io_tag_get_index(the_request->io_tag)] = the_request;
 
 		/*
@@ -3379,15 +3304,7 @@ static enum sci_status scic_sds_controll
 	return status;
 }
 
-/**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- *
+/*
  * This method is called when the struct scic_sds_controller is in the ready state and
  * the terminate request handler is called. - call the io request terminate
  * function - if successful - post the terminate request to the SCU hardware
@@ -3396,29 +3313,26 @@ static enum sci_status scic_sds_controll
  * accept io requests.
  */
 static enum sci_status scic_sds_controller_ready_state_terminate_request_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request)
 {
-	struct scic_sds_controller *this_controller = (struct scic_sds_controller *)
-						 controller;
 	struct scic_sds_request *the_request     = (struct scic_sds_request *)
 					      io_request;
 	enum sci_status status;
 
 	status = scic_sds_io_request_terminate(the_request);
-	if (status == SCI_SUCCESS) {
-		/*
-		 * Utilize the original post context command and or in the POST_TC_ABORT
-		 * request sub-type. */
-		scic_sds_controller_post_request(
-			this_controller,
-			scic_sds_request_get_post_context(the_request)
-			| SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT
-			);
-	}
+	if (status != SCI_SUCCESS)
+		return status;
 
-	return status;
+	/*
+	 * Utilize the original post context command and or in the POST_TC_ABORT
+	 * request sub-type.
+	 */
+	scic_sds_controller_post_request(controller,
+		scic_sds_request_get_post_context(the_request) |
+		SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT);
+	return SCI_SUCCESS;
 }
 
 /**
@@ -3470,38 +3384,20 @@ static void scic_sds_controller_ready_st
  * ***************************************************************************** */
 
 /**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- * @io_request: This is the struct sci_base_request which is cast to a
- *    SCIC_SDS_IO_REQUEST object.
- *
  * This method is called when the struct scic_sds_controller is in a stopping state
  * and the complete io handler is called. - This function is not yet
  * implemented enum sci_status SCI_FAILURE
  */
 static enum sci_status scic_sds_controller_stopping_state_complete_io_handler(
-	struct sci_base_controller *controller,
+	struct scic_sds_controller *controller,
 	struct sci_base_remote_device *remote_device,
 	struct sci_base_request *io_request)
 {
-	struct scic_sds_controller *this_controller;
-
-	this_controller = (struct scic_sds_controller *)controller;
-
-	/* / @todo Implement this function */
+	/* XXX: Implement this function */
 	return SCI_FAILURE;
 }
 
 /**
- *
- * @controller: This is struct sci_base_controller object which is cast into a
- *    struct scic_sds_controller object.
- * @remote_device: This is struct sci_base_remote_device which is cast to a
- *    struct scic_sds_remote_device object.
- *
  * This method is called when the struct scic_sds_controller is in a stopping state
  * and the remote device has stopped.
  **/
@@ -3511,8 +3407,7 @@ static void scic_sds_controller_stopping
 )
 {
 	if (!scic_sds_controller_has_remote_devices_stopping(controller)) {
-		sci_base_state_machine_change_state(
-			&controller->parent.state_machine,
+		sci_base_state_machine_change_state(&controller->state_machine,
 			SCI_BASE_CONTROLLER_STATE_STOPPED
 		);
 	}
@@ -3520,77 +3415,77 @@ static void scic_sds_controller_stopping
 
 const struct scic_sds_controller_state_handler scic_sds_controller_state_handler_table[] = {
 	[SCI_BASE_CONTROLLER_STATE_INITIAL] = {
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_RESET] = {
-		.base.reset        = scic_sds_controller_general_reset_handler,
-		.base.initialize   = scic_sds_controller_reset_state_initialize_handler,
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.reset        = scic_sds_controller_general_reset_handler,
+		.initialize   = scic_sds_controller_reset_state_initialize_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_INITIALIZING] = {
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_INITIALIZED] = {
-		.base.start        = scic_sds_controller_initialized_state_start_handler,
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start        = scic_sds_controller_initialized_state_start_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_STARTING] = {
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 		.link_up           = scic_sds_controller_starting_state_link_up_handler,
 		.link_down	   = scic_sds_controller_starting_state_link_down_handler
 	},
 	[SCI_BASE_CONTROLLER_STATE_READY] = {
-		.base.stop         = scic_sds_controller_ready_state_stop_handler,
-		.base.reset        = scic_sds_controller_general_reset_handler,
-		.base.start_io     = scic_sds_controller_ready_state_start_io_handler,
-		.base.complete_io  = scic_sds_controller_ready_state_complete_io_handler,
-		.base.continue_io  = scic_sds_controller_ready_state_continue_io_handler,
-		.base.start_task   = scic_sds_controller_ready_state_start_task_handler,
-		.base.complete_task = scic_sds_controller_ready_state_complete_io_handler,
+		.stop         = scic_sds_controller_ready_state_stop_handler,
+		.reset        = scic_sds_controller_general_reset_handler,
+		.start_io     = scic_sds_controller_ready_state_start_io_handler,
+		.complete_io  = scic_sds_controller_ready_state_complete_io_handler,
+		.continue_io  = scic_sds_controller_ready_state_continue_io_handler,
+		.start_task   = scic_sds_controller_ready_state_start_task_handler,
+		.complete_task = scic_sds_controller_ready_state_complete_io_handler,
 		.terminate_request = scic_sds_controller_ready_state_terminate_request_handler,
 		.link_up           = scic_sds_controller_ready_state_link_up_handler,
 		.link_down	   = scic_sds_controller_ready_state_link_down_handler
 	},
 	[SCI_BASE_CONTROLLER_STATE_RESETTING] = {
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_STOPPING] = {
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_stopping_state_complete_io_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_stopping_state_complete_io_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 		.device_stopped    = scic_sds_controller_stopping_state_device_stopped_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_STOPPED] = {
-		.base.reset        = scic_sds_controller_general_reset_handler,
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.reset        = scic_sds_controller_general_reset_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 	[SCI_BASE_CONTROLLER_STATE_FAILED] = {
-		.base.reset        = scic_sds_controller_general_reset_handler,
-		.base.start_io     = scic_sds_controller_default_start_operation_handler,
-		.base.complete_io  = scic_sds_controller_default_request_handler,
-		.base.continue_io  = scic_sds_controller_default_request_handler,
+		.reset        = scic_sds_controller_general_reset_handler,
+		.start_io     = scic_sds_controller_default_start_operation_handler,
+		.complete_io  = scic_sds_controller_default_request_handler,
+		.continue_io  = scic_sds_controller_default_request_handler,
 		.terminate_request = scic_sds_controller_default_request_handler,
 	},
 };
@@ -3612,8 +3507,8 @@ static void scic_sds_controller_initial_
 
 	this_controller = (struct scic_sds_controller *)object;
 
-	sci_base_state_machine_change_state(
-		&this_controller->parent.state_machine, SCI_BASE_CONTROLLER_STATE_RESET);
+	sci_base_state_machine_change_state(&this_controller->state_machine,
+			SCI_BASE_CONTROLLER_STATE_RESET);
 }
 
 /**
@@ -3718,9 +3613,9 @@ static void scic_sds_controller_resettin
 {
 	struct scic_sds_controller *scic;
 
-	scic = container_of(object, typeof(*scic), parent.parent);
+	scic = container_of(object, typeof(*scic), parent);
 	scic_sds_controller_reset_hardware(scic);
-	sci_base_state_machine_change_state(&scic->parent.state_machine,
+	sci_base_state_machine_change_state(&scic->state_machine,
 					    SCI_BASE_CONTROLLER_STATE_RESET);
 }
 
@@ -3771,10 +3666,13 @@ enum sci_status scic_controller_construc
 {
 	u8 i;
 
-	sci_base_controller_construct(&scic->parent,
-				      scic_sds_controller_state_table,
-				      scic->memory_descriptors,
-				      ARRAY_SIZE(scic->memory_descriptors), NULL);
+	sci_base_state_machine_construct(&scic->state_machine,
+		&scic->parent, scic_sds_controller_state_table,
+		SCI_BASE_CONTROLLER_STATE_INITIAL);
+
+	sci_base_mdl_construct(&scic->mdl, scic->memory_descriptors,
+				ARRAY_SIZE(scic->memory_descriptors), NULL);
+	sci_base_state_machine_start(&scic->state_machine);
 
 	scic->scu_registers = scu_base;
 	scic->smu_registers = smu_base;
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 10:47:51.534838954 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_controller.h	2011-03-28 11:16:43.589338840 +0200
@@ -69,7 +69,9 @@
 #include "sci_pool.h"
 #include "sci_controller_constants.h"
 #include "sci_memory_descriptor_list.h"
-#include "sci_base_controller.h"
+#include "sci_base_state.h"
+#include "sci_base_state_machine.h"
+#include "sci_base_memory_descriptor_list.h"
 #include "scic_config_parameters.h"
 #include "scic_sds_port.h"
 #include "scic_sds_phy.h"
@@ -82,11 +84,12 @@
 #include "scic_sds_unsolicited_frame_control.h"
 #include "scic_sds_port_configuration_agent.h"
 
+struct sci_base_remote_device;
 struct scic_sds_remote_device;
+struct sci_base_request;
 struct scic_sds_request;
 struct scic_sds_controller;
 
-
 #define SCU_COMPLETION_RAM_ALIGNMENT            (64)
 
 /**
@@ -166,10 +169,23 @@ struct scic_power_control {
  */
 struct scic_sds_controller {
 	/**
-	 * The struct sci_base_controller is the parent object for the struct scic_sds_controller
-	 * object.
+	 * The field specifies that the parent object for the base controller
+	 * is the base object itself.
+	 */
+	struct sci_base_object parent;
+
+	/**
+	 * This field points to the memory descriptor list associated with this
+	 * controller.  The MDL indicates the memory requirements necessary for
+	 * this controller object.
+	 */
+	struct sci_base_memory_descriptor_list mdl;
+
+	/**
+	 * This field contains the information for the base controller state
+	 * machine.
 	 */
-	struct sci_base_controller parent;
+	struct sci_base_state_machine state_machine;
 
 	/**
 	 * This field is the driver timer object handler used to time the controller
@@ -376,24 +392,170 @@ struct scic_sds_controller {
 
 };
 
-typedef void (*scic_sds_controller_phy_handler_t)(struct scic_sds_controller *,
-						  struct scic_sds_port *,
-						  struct scic_sds_phy *);
+/**
+ * enum scic_sds_controller_states - This enumeration depicts all the states
+ *    for the common controller state machine.
+ */
+enum scic_sds_controller_states {
+	/**
+	 * Simply the initial state for the base controller state machine.
+	 */
+	SCI_BASE_CONTROLLER_STATE_INITIAL = 0,
 
-typedef void (*scic_sds_controller_device_handler_t)(struct scic_sds_controller *,
-						  struct scic_sds_remote_device *);
+	/**
+	 * This state indicates that the controller is reset.  The memory for
+	 * the controller is in it's initial state, but the controller requires
+	 * initialization.
+	 * This state is entered from the INITIAL state.
+	 * This state is entered from the RESETTING state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_RESET,
 
+	/**
+	 * This state is typically an action state that indicates the controller
+	 * is in the process of initialization.  In this state no new IO operations
+	 * are permitted.
+	 * This state is entered from the RESET state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_INITIALIZING,
+
+	/**
+	 * This state indicates that the controller has been successfully
+	 * initialized.  In this state no new IO operations are permitted.
+	 * This state is entered from the INITIALIZING state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_INITIALIZED,
+
+	/**
+	 * This state indicates the the controller is in the process of becoming
+	 * ready (i.e. starting).  In this state no new IO operations are permitted.
+	 * This state is entered from the INITIALIZED state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_STARTING,
+
+	/**
+	 * This state indicates the controller is now ready.  Thus, the user
+	 * is able to perform IO operations on the controller.
+	 * This state is entered from the STARTING state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_READY,
+
+	/**
+	 * This state is typically an action state that indicates the controller
+	 * is in the process of resetting.  Thus, the user is unable to perform
+	 * IO operations on the controller.  A reset is considered destructive in
+	 * most cases.
+	 * This state is entered from the READY state.
+	 * This state is entered from the FAILED state.
+	 * This state is entered from the STOPPED state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_RESETTING,
+
+	/**
+	 * This state indicates that the controller is in the process of stopping.
+	 * In this state no new IO operations are permitted, but existing IO
+	 * operations are allowed to complete.
+	 * This state is entered from the READY state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_STOPPING,
+
+	/**
+	 * This state indicates that the controller has successfully been stopped.
+	 * In this state no new IO operations are permitted.
+	 * This state is entered from the STOPPING state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_STOPPED,
+
+	/**
+	 * This state indicates that the controller could not successfully be
+	 * initialized.  In this state no new IO operations are permitted.
+	 * This state is entered from the INITIALIZING state.
+	 * This state is entered from the STARTING state.
+	 * This state is entered from the STOPPING state.
+	 * This state is entered from the RESETTING state.
+	 */
+	SCI_BASE_CONTROLLER_STATE_FAILED,
+
+	SCI_BASE_CONTROLLER_MAX_STATES
+
+};
+
+typedef enum sci_status (*scic_sds_controller_handler_t)
+				(struct scic_sds_controller *);
+typedef enum sci_status (*scic_sds_controller_timed_handler_t)
+				(struct scic_sds_controller *, u32);
+typedef enum sci_status (*scic_sds_controller_request_handler_t)
+				(struct scic_sds_controller *,
+				 struct sci_base_remote_device *,
+				 struct sci_base_request *);
+typedef enum sci_status (*scic_sds_controller_start_request_handler_t)
+				(struct scic_sds_controller *,
+				 struct sci_base_remote_device *,
+				 struct sci_base_request *, u16);
+typedef void (*scic_sds_controller_phy_handler_t)
+				(struct scic_sds_controller *,
+				 struct scic_sds_port *,
+				 struct scic_sds_phy *);
+typedef void (*scic_sds_controller_device_handler_t)
+				(struct scic_sds_controller *,
+				 struct scic_sds_remote_device *);
 
-/**
- * struct scic_sds_controller_state_handler -
- *
- * This structure contains the SDS core specific definition for the state
- * handlers.
- */
 struct scic_sds_controller_state_handler {
-	struct sci_base_controller_state_handler base;
+	/**
+	 * The start_handler specifies the method invoked when a user attempts to
+	 * start a controller.
+	 */
+	scic_sds_controller_timed_handler_t start;
+
+	/**
+	 * The stop_handler specifies the method invoked when a user attempts to
+	 * stop a controller.
+	 */
+	scic_sds_controller_timed_handler_t stop;
+
+	/**
+	 * The reset_handler specifies the method invoked when a user attempts to
+	 * reset a controller.
+	 */
+	scic_sds_controller_handler_t reset;
+
+	/**
+	 * The initialize_handler specifies the method invoked when a user
+	 * attempts to initialize a controller.
+	 */
+	scic_sds_controller_handler_t initialize;
+
+	/**
+	 * The start_io_handler specifies the method invoked when a user
+	 * attempts to start an IO request for a controller.
+	 */
+	scic_sds_controller_start_request_handler_t start_io;
+
+	/**
+	 * The complete_io_handler specifies the method invoked when a user
+	 * attempts to complete an IO request for a controller.
+	 */
+	scic_sds_controller_request_handler_t complete_io;
+
+	/**
+	 * The continue_io_handler specifies the method invoked when a user
+	 * attempts to continue an IO request for a controller.
+	 */
+	scic_sds_controller_request_handler_t continue_io;
+
+	/**
+	 * The start_task_handler specifies the method invoked when a user
+	 * attempts to start a task management request for a controller.
+	 */
+	scic_sds_controller_start_request_handler_t start_task;
+
+	/**
+	 * The complete_task_handler specifies the method invoked when a user
+	 * attempts to complete a task management request for a controller.
+	 */
+	scic_sds_controller_request_handler_t complete_task;
 
-	sci_base_controller_request_handler_t terminate_request;
+	scic_sds_controller_request_handler_t terminate_request;
 	scic_sds_controller_phy_handler_t link_up;
 	scic_sds_controller_phy_handler_t link_down;
 	scic_sds_controller_device_handler_t device_stopped;
Index: linux-2.6/drivers/scsi/isci/core/sci_controller.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/sci_controller.h	2011-03-28 10:51:18.373839042 +0200
+++ linux-2.6/drivers/scsi/isci/core/sci_controller.h	2011-03-28 10:51:57.169340947 +0200
@@ -63,36 +63,7 @@
  *
  */
 
-
-struct sci_base_memory_descriptor_list;
-struct scic_sds_controller;
-
 #define SCI_CONTROLLER_INVALID_IO_TAG 0xFFFF
 
-/**
- * sci_controller_get_memory_descriptor_list_handle() - This method simply
- *    returns a handle for the memory descriptor list associated with the
- *    supplied controller.  The descriptor list provides DMA safe/capable
- *    memory requirements for this controller.
- * @controller: This parameter specifies the controller for which to retrieve
- *    the DMA safe memory descriptor list.
- *
- * The user must adhere to the alignment requirements specified in memory
- * descriptor.  In situations where the operating environment does not offer
- * memory allocation utilities supporting alignment, then it is the
- * responsibility of the user to manually align the memory buffer for SCI.
- * Thus, the user may have to allocate a larger buffer to meet the alignment.
- * Additionally, the user will need to remember the actual memory allocation
- * addresses in order to ensure the memory can be properly freed when necessary
- * to do so. This method will return a valid handle, but the MDL may not be
- * accurate until after the user has invoked the associated
- * sci_controller_initialize() routine. A pointer to a physical memory
- * descriptor array.
- */
-struct sci_base_memory_descriptor_list *
-	sci_controller_get_memory_descriptor_list_handle(
-	struct scic_sds_controller *controller);
-
-
 #endif  /* _SCI_CONTROLLER_H_ */
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-03-28 11:00:58.162838072 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_remote_device.c	2011-03-28 11:14:57.437839475 +0200
@@ -563,12 +563,11 @@ void scic_sds_remote_device_continue_req
 	/* we need to check if this request is still valid to continue. */
 	if (sci_req) {
 		struct scic_sds_controller *scic = sci_req->owning_controller;
-		u32 state = scic->parent.state_machine.current_state_id;
-		sci_base_controller_request_handler_t continue_io;
+		u32 state = scic->state_machine.current_state_id;
+		scic_sds_controller_request_handler_t continue_io;
 
-		continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
-		continue_io(&scic->parent, &sci_req->target_device->parent,
-			    &sci_req->parent);
+		continue_io = scic_sds_controller_state_handler_table[state].continue_io;
+		continue_io(scic, &sci_req->target_device->parent, &sci_req->parent);
 	}
 }
 
Index: linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-28 11:01:29.481838605 +0200
+++ linux-2.6/drivers/scsi/isci/core/scic_sds_stp_request.c	2011-03-28 11:14:59.897907145 +0200
@@ -649,7 +649,7 @@ static enum sci_status scic_sds_stp_requ
 	u32 length)
 {
 	struct scic_sds_stp_request *this_sds_stp_request = (struct scic_sds_stp_request *)this_request;
-	sci_base_controller_request_handler_t continue_io;
+	scic_sds_controller_request_handler_t continue_io;
 	struct scu_sgl_element *current_sgl;
 	struct scic_sds_controller *scic;
 	u32 state;
@@ -675,9 +675,9 @@ static enum sci_status scic_sds_stp_requ
 
 	/* send the new TC out. */
 	scic = this_request->owning_controller;
-	state = scic->parent.state_machine.current_state_id;
-	continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
-	return continue_io(&scic->parent, &this_request->target_device->parent,
+	state = scic->state_machine.current_state_id;
+	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
+	return continue_io(scic, &this_request->target_device->parent,
 			   &this_request->parent);
 }
 
@@ -1822,7 +1822,7 @@ static void scic_sds_stp_request_started
 	struct sci_base_object *object)
 {
 	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
-	sci_base_controller_request_handler_t continue_io;
+	scic_sds_controller_request_handler_t continue_io;
 	struct scu_task_context *task_context;
 	struct sata_fis_reg_h2d *h2d_fis;
 	struct scic_sds_controller *scic;
@@ -1839,10 +1839,10 @@ static void scic_sds_stp_request_started
 	task_context->control_frame = 0;
 
 	scic = this_request->owning_controller;
-	state = scic->parent.state_machine.current_state_id;
-	continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
+	state = scic->state_machine.current_state_id;
+	continue_io = scic_sds_controller_state_handler_table[state].continue_io;
 
-	status = continue_io(&scic->parent, &this_request->target_device->parent,
+	status = continue_io(scic, &this_request->target_device->parent,
 			     &this_request->parent);
 
 	if (status == SCI_SUCCESS) {
Index: linux-2.6/drivers/scsi/isci/host.c
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/host.c	2011-03-28 10:51:18.393839193 +0200
+++ linux-2.6/drivers/scsi/isci/host.c	2011-03-28 10:54:35.953897776 +0200
@@ -62,6 +62,7 @@
 #include "request.h"
 #include "host.h"
 #include "probe_roms.h"
+#include "core/scic_sds_controller.h"
 
 irqreturn_t isci_msix_isr(int vec, void *data)
 {
@@ -231,9 +232,8 @@ static int isci_host_mdl_allocate_cohere
 	struct coherent_memory_info *mdl_struct;
 	u32 size = 0;
 
-	struct sci_base_memory_descriptor_list *mdl_handle
-		= sci_controller_get_memory_descriptor_list_handle(
-		isci_host->core_controller);
+	struct sci_base_memory_descriptor_list *mdl_handle =
+		&isci_host->core_controller->mdl;
 
 	sci_mdl_first_entry(mdl_handle);
 
Index: linux-2.6/drivers/scsi/isci/isci.h
===================================================================
--- linux-2.6.orig/drivers/scsi/isci/isci.h	2011-03-28 11:05:31.970896757 +0200
+++ linux-2.6/drivers/scsi/isci/isci.h	2011-03-28 11:06:01.485461661 +0200
@@ -65,7 +65,7 @@
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 
-#include "sci_base_controller.h"
+#include "core/sci_object.h"
 #include "scic_controller.h"
 #include "host.h"
 #include "timers.h"
