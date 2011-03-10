From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 05/10] isci/core: remote node context
Date: Thu, 10 Mar 2011 02:54:45 -0800
Message-ID: <20110310105445.6485.12486.stgit@localhost6.localdomain6>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1CJKx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:29 -0500
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

A remote node context is a descriptor that represents an end device.  An
SSP device consumes 1 descriptor while an STP target consumes 3.  There
are 256 remote node context descriptor that can be active at any given
point in time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .../scsi/isci/core/scic_sds_remote_node_context.c  | 1247 ++++++++++++++++++++
 .../scsi/isci/core/scic_sds_remote_node_context.h  |  323 +++++
 .../scsi/isci/core/scic_sds_remote_node_table.c    |  600 ++++++++++
 .../scsi/isci/core/scic_sds_remote_node_table.h    |  195 +++
 drivers/scsi/isci/core/scu_remote_node_context.h   |  229 ++++
 5 files changed, 2594 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_context.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_context.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_table.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_table.h
 create mode 100644 drivers/scsi/isci/core/scu_remote_node_context.h

diff --git a/drivers/scsi/isci/core/scic_sds_remote_node_context.c b/drivers/scsi/isci/core/scic_sds_remote_node_context.c
new file mode 100644
index 0000000..253b2d8
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_node_context.c
@@ -0,0 +1,1247 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include "sci_base_state_machine.h"
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_port.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_remote_node_context.h"
+#include "sci_environment.h"
+#include "sci_util.h"
+#include "scu_event_codes.h"
+#include "scu_task_context.h"
+
+void scic_sds_remote_node_context_construct(
+	struct scic_sds_remote_device *device,
+	struct scic_sds_remote_node_context *rnc,
+	u16 remote_node_index)
+{
+	memset(rnc, 0, sizeof(struct scic_sds_remote_node_context));
+
+	rnc->remote_node_index = remote_node_index;
+	rnc->device            = device;
+	rnc->destination_state = SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_UNSPECIFIED;
+
+	sci_base_state_machine_construct(
+		&rnc->state_machine,
+		&rnc->parent,
+		scic_sds_remote_node_context_state_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE
+		);
+
+	sci_base_state_machine_start(&rnc->state_machine);
+}
+
+/**
+ *
+ * @this_rnc: The RNC for which the is posted request is being made.
+ *
+ * This method will return true if the RNC is not in the initial state.  In all
+ * other states the RNC is considered active and this will return true. The
+ * destroy request of the state machine drives the RNC back to the initial
+ * state.  If the state machine changes then this routine will also have to be
+ * changed. bool true if the state machine is not in the initial state false if
+ * the state machine is in the initial state
+ */
+
+/**
+ *
+ * @this_rnc: The state of the remote node context object to check.
+ *
+ * This method will return true if the remote node context is in a READY state
+ * otherwise it will return false bool true if the remote node context is in
+ * the ready state. false if the remote node context is not in the ready state.
+ */
+bool scic_sds_remote_node_context_is_ready(
+	struct scic_sds_remote_node_context *this_rnc)
+{
+	u32 current_state = sci_base_state_machine_get_state(&this_rnc->state_machine);
+
+	if (current_state == SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE) {
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ *
+ * @this_device: The remote device to use to construct the RNC buffer.
+ * @rnc: The buffer into which the remote device data will be copied.
+ *
+ * This method will construct the RNC buffer for this remote device object. none
+ */
+void scic_sds_remote_node_context_construct_buffer(
+	struct scic_sds_remote_node_context *this_rnc)
+{
+	union scu_remote_node_context *rnc;
+	struct scic_sds_controller *the_controller;
+
+	the_controller = scic_sds_remote_device_get_controller(this_rnc->device);
+
+	rnc = scic_sds_controller_get_remote_node_context_buffer(
+		the_controller, this_rnc->remote_node_index);
+
+	memset(
+		rnc,
+		0x00,
+		sizeof(union scu_remote_node_context)
+		* scic_sds_remote_device_node_count(this_rnc->device)
+		);
+
+	rnc->ssp.remote_node_index = this_rnc->remote_node_index;
+	rnc->ssp.remote_node_port_width = this_rnc->device->device_port_width;
+	rnc->ssp.logical_port_index =
+		scic_sds_remote_device_get_port_index(this_rnc->device);
+
+	rnc->ssp.remote_sas_address_hi = SCIC_SWAP_DWORD(this_rnc->device->device_address.high);
+	rnc->ssp.remote_sas_address_lo = SCIC_SWAP_DWORD(this_rnc->device->device_address.low);
+
+	rnc->ssp.nexus_loss_timer_enable = true;
+	rnc->ssp.check_bit               = false;
+	rnc->ssp.is_valid                = false;
+	rnc->ssp.is_remote_node_context  = true;
+	rnc->ssp.function_number         = 0;
+
+	rnc->ssp.arbitration_wait_time = 0;
+
+
+	if (
+		this_rnc->device->target_protocols.u.bits.attached_sata_device
+		|| this_rnc->device->target_protocols.u.bits.attached_stp_target
+		) {
+		rnc->ssp.connection_occupancy_timeout =
+			the_controller->user_parameters.sds1.stp_max_occupancy_timeout;
+		rnc->ssp.connection_inactivity_timeout =
+			the_controller->user_parameters.sds1.stp_inactivity_timeout;
+	} else {
+		rnc->ssp.connection_occupancy_timeout  =
+			the_controller->user_parameters.sds1.ssp_max_occupancy_timeout;
+		rnc->ssp.connection_inactivity_timeout =
+			the_controller->user_parameters.sds1.ssp_inactivity_timeout;
+	}
+
+	rnc->ssp.initial_arbitration_wait_time = 0;
+
+	/* Open Address Frame Parameters */
+	rnc->ssp.oaf_connection_rate = this_rnc->device->connection_rate;
+	rnc->ssp.oaf_features = 0;
+	rnc->ssp.oaf_source_zone_group = 0;
+	rnc->ssp.oaf_more_compatibility_features = 0;
+}
+
+/**
+ *
+ * @this_rnc:
+ * @the_callback:
+ * @callback_parameter:
+ *
+ * This method will setup the remote node context object so it will transition
+ * to its ready state.  If the remote node context is already setup to
+ * transition to its final state then this function does nothing. none
+ */
+static void scic_sds_remote_node_context_setup_to_resume(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	if (this_rnc->destination_state != SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_FINAL) {
+		this_rnc->destination_state = SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_READY;
+		this_rnc->user_callback     = the_callback;
+		this_rnc->user_cookie       = callback_parameter;
+	}
+}
+
+/**
+ *
+ * @this_rnc:
+ * @the_callback:
+ * @callback_parameter:
+ *
+ * This method will setup the remote node context object so it will transistion
+ * to its final state. none
+ */
+static void scic_sds_remote_node_context_setup_to_destory(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	this_rnc->destination_state = SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_FINAL;
+	this_rnc->user_callback     = the_callback;
+	this_rnc->user_cookie       = callback_parameter;
+}
+
+/**
+ *
+ * @this_rnc:
+ * @the_callback:
+ *
+ * This method will continue to resume a remote node context.  This is used in
+ * the states where a resume is requested while a resume is in progress.
+ */
+static enum sci_status scic_sds_remote_node_context_continue_to_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	if (this_rnc->destination_state == SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_READY) {
+		this_rnc->user_callback = the_callback;
+		this_rnc->user_cookie   = callback_parameter;
+
+		return SCI_SUCCESS;
+	}
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_default_destruct_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to stop while "
+		 "in unexpected state %d\n",
+		 __func__,
+		 this_rnc,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	/*
+	 * We have decided that the destruct request on the remote node context can not fail
+	 * since it is either in the initial/destroyed state or is can be destroyed. */
+	return SCI_SUCCESS;
+}
+
+static enum sci_status scic_sds_remote_node_context_default_suspend_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 suspend_type,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to suspend "
+		 "while in wrong state %d\n",
+		 __func__,
+		 this_rnc,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+static enum sci_status scic_sds_remote_node_context_default_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to resume "
+		 "while in wrong state %d\n",
+		 __func__,
+		 this_rnc,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+static enum sci_status scic_sds_remote_node_context_default_start_io_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to start io "
+		 "0x%p while in wrong state %d\n",
+		 __func__,
+		 this_rnc,
+		 the_request,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	return SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED;
+}
+
+static enum sci_status scic_sds_remote_node_context_default_start_task_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to start "
+		 "task 0x%p while in wrong state %d\n",
+		 __func__,
+		 this_rnc,
+		 the_request,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	return SCI_FAILURE;
+}
+
+static enum sci_status scic_sds_remote_node_context_default_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	dev_warn(scirdev_to_dev(this_rnc->device),
+		 "%s: SCIC Remote Node Context 0x%p requested to process "
+		 "event 0x%x while in wrong state %d\n",
+		 __func__,
+		 this_rnc,
+		 event_code,
+		 sci_base_state_machine_get_state(&this_rnc->state_machine));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @this_rnc: The rnc for which the task request is targeted.
+ * @the_request: The request which is going to be started.
+ *
+ * This method determines if the task request can be started by the SCU
+ * hardware. When the RNC is in the ready state any task can be started.
+ * enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_node_context_success_start_task_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_rnc:
+ * @the_callback:
+ * @callback_parameter:
+ *
+ * This method handles destruct calls from the various state handlers.  The
+ * remote node context can be requested to destroy from any state. If there was
+ * a user callback it is always replaced with the request to destroy user
+ * callback. enum sci_status
+ */
+static enum sci_status scic_sds_remote_node_context_general_destruct_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	scic_sds_remote_node_context_setup_to_destory(
+		this_rnc, the_callback, callback_parameter
+		);
+
+	sci_base_state_machine_change_state(
+		&this_rnc->state_machine,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_initial_state_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	if (this_rnc->remote_node_index != SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX) {
+		scic_sds_remote_node_context_setup_to_resume(
+			this_rnc, the_callback, callback_parameter
+			);
+
+		scic_sds_remote_node_context_construct_buffer(this_rnc);
+
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE
+			);
+
+		return SCI_SUCCESS;
+	}
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_posting_state_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	switch (scu_get_event_code(event_code)) {
+	case SCU_EVENT_POST_RNC_COMPLETE:
+		status = SCI_SUCCESS;
+
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE
+			);
+		break;
+
+	default:
+		status = SCI_FAILURE;
+		dev_warn(scirdev_to_dev(this_rnc->device),
+			 "%s: SCIC Remote Node Context 0x%p requested to "
+			 "process unexpected event 0x%x while in posting "
+			 "state\n",
+			 __func__,
+			 this_rnc,
+			 event_code);
+		break;
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_invalidating_state_destruct_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	scic_sds_remote_node_context_setup_to_destory(
+		this_rnc, the_callback, callback_parameter
+		);
+
+	return SCI_SUCCESS;
+}
+
+static enum sci_status scic_sds_remote_node_context_invalidating_state_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	if (scu_get_event_code(event_code) == SCU_EVENT_POST_RNC_INVALIDATE_COMPLETE) {
+		status = SCI_SUCCESS;
+
+		if (this_rnc->destination_state == SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_FINAL) {
+			sci_base_state_machine_change_state(
+				&this_rnc->state_machine,
+				SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE
+				);
+		} else {
+			sci_base_state_machine_change_state(
+				&this_rnc->state_machine,
+				SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE
+				);
+		}
+	} else {
+		switch (scu_get_event_type(event_code)) {
+		case SCU_EVENT_TYPE_RNC_SUSPEND_TX:
+		case SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX:
+			/*
+			 * We really dont care if the hardware is going to suspend
+			 * the device since it's being invalidated anyway */
+			dev_dbg(scirdev_to_dev(this_rnc->device),
+				"%s: SCIC Remote Node Context 0x%p was "
+				"suspeneded by hardware while being "
+				"invalidated.\n",
+				__func__,
+				this_rnc);
+			status = SCI_SUCCESS;
+			break;
+
+		default:
+			dev_warn(scirdev_to_dev(this_rnc->device),
+				 "%s: SCIC Remote Node Context 0x%p "
+				 "requested to process event 0x%x while "
+				 "in state %d.\n",
+				 __func__,
+				 this_rnc,
+				 event_code,
+				 sci_base_state_machine_get_state(
+					 &this_rnc->state_machine));
+			status = SCI_FAILURE;
+			break;
+		}
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+
+static enum sci_status scic_sds_remote_node_context_resuming_state_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	if (scu_get_event_code(event_code) == SCU_EVENT_POST_RCN_RELEASE) {
+		status = SCI_SUCCESS;
+
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE
+			);
+	} else {
+		switch (scu_get_event_type(event_code)) {
+		case SCU_EVENT_TYPE_RNC_SUSPEND_TX:
+		case SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX:
+			/*
+			 * We really dont care if the hardware is going to suspend
+			 * the device since it's being resumed anyway */
+			dev_dbg(scirdev_to_dev(this_rnc->device),
+				"%s: SCIC Remote Node Context 0x%p was "
+				"suspeneded by hardware while being resumed.\n",
+				__func__,
+				this_rnc);
+			status = SCI_SUCCESS;
+			break;
+
+		default:
+			dev_warn(scirdev_to_dev(this_rnc->device),
+				 "%s: SCIC Remote Node Context 0x%p requested "
+				 "to process event 0x%x while in state %d.\n",
+				 __func__,
+				 this_rnc,
+				 event_code,
+				 sci_base_state_machine_get_state(
+					 &this_rnc->state_machine));
+			status = SCI_FAILURE;
+			break;
+		}
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+/**
+ *
+ * @this_rnc: The remote node context object being suspended.
+ * @the_callback: The callback when the suspension is complete.
+ * @callback_parameter: The parameter that is to be passed into the callback.
+ *
+ * This method will handle the suspend requests from the ready state.
+ * SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_node_context_ready_state_suspend_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 suspend_type,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	this_rnc->user_callback   = the_callback;
+	this_rnc->user_cookie     = callback_parameter;
+	this_rnc->suspension_code = suspend_type;
+
+	if (suspend_type == SCI_SOFTWARE_SUSPENSION) {
+		scic_sds_remote_device_post_request(
+			this_rnc->device,
+			SCU_CONTEXT_COMMAND_POST_RNC_SUSPEND_TX
+			);
+	}
+
+	sci_base_state_machine_change_state(
+		&this_rnc->state_machine,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_AWAIT_SUSPENSION_STATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_rnc: The rnc for which the io request is targeted.
+ * @the_request: The request which is going to be started.
+ *
+ * This method determines if the io request can be started by the SCU hardware.
+ * When the RNC is in the ready state any io request can be started. enum sci_status
+ * SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_node_context_ready_state_start_io_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	return SCI_SUCCESS;
+}
+
+
+static enum sci_status scic_sds_remote_node_context_ready_state_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	switch (scu_get_event_type(event_code)) {
+	case SCU_EVENT_TL_RNC_SUSPEND_TX:
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE
+			);
+
+		this_rnc->suspension_code = scu_get_event_specifier(event_code);
+		status = SCI_SUCCESS;
+		break;
+
+	case SCU_EVENT_TL_RNC_SUSPEND_TX_RX:
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE
+			);
+
+		this_rnc->suspension_code = scu_get_event_specifier(event_code);
+		status = SCI_SUCCESS;
+		break;
+
+	default:
+		dev_warn(scirdev_to_dev(this_rnc->device),
+			"%s: SCIC Remote Node Context 0x%p requested to "
+			"process event 0x%x while in state %d.\n",
+			__func__,
+			this_rnc,
+			event_code,
+			sci_base_state_machine_get_state(
+				&this_rnc->state_machine));
+
+		status = SCI_FAILURE;
+		break;
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_tx_suspended_state_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	enum sci_status status;
+	struct smp_discover_response_protocols protocols;
+
+	scic_sds_remote_node_context_setup_to_resume(
+		this_rnc, the_callback, callback_parameter
+		);
+
+	/* TODO: consider adding a resume action of NONE, INVALIDATE, WRITE_TLCR */
+
+	scic_remote_device_get_protocols(this_rnc->device, &protocols);
+
+	if (
+		(protocols.u.bits.attached_ssp_target == 1)
+		|| (protocols.u.bits.attached_smp_target == 1)
+		) {
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
+			);
+
+		status = SCI_SUCCESS;
+	} else if (protocols.u.bits.attached_stp_target == 1) {
+		if (this_rnc->device->is_direct_attached) {
+			/* @todo Fix this since I am being silly in writing to the STPTLDARNI register. */
+			sci_base_state_machine_change_state(
+				&this_rnc->state_machine,
+				SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
+				);
+		} else {
+			sci_base_state_machine_change_state(
+				&this_rnc->state_machine,
+				SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE
+				);
+		}
+
+		status = SCI_SUCCESS;
+	} else {
+		status = SCI_FAILURE;
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @this_rnc: The remote node context which is to receive the task request.
+ * @the_request: The task request to be transmitted to to the remote target
+ *    device.
+ *
+ * This method will report a success or failure attempt to start a new task
+ * request to the hardware.  Since all task requests are sent on the high
+ * priority queue they can be sent when the RCN is in a TX suspend state.
+ * enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_node_context_suspended_start_task_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	scic_sds_remote_node_context_resume(this_rnc, NULL, NULL);
+
+	return SCI_SUCCESS;
+}
+
+/* --------------------------------------------------------------------------- */
+
+static enum sci_status scic_sds_remote_node_context_tx_rx_suspended_state_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	scic_sds_remote_node_context_setup_to_resume(
+		this_rnc, the_callback, callback_parameter
+		);
+
+	sci_base_state_machine_change_state(
+		&this_rnc->state_machine,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
+		);
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/* --------------------------------------------------------------------------- */
+
+/**
+ *
+ *
+ *
+ */
+static enum sci_status scic_sds_remote_node_context_await_suspension_state_resume_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter)
+{
+	scic_sds_remote_node_context_setup_to_resume(
+		this_rnc, the_callback, callback_parameter
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_rnc: The remote node context which is to receive the task request.
+ * @the_request: The task request to be transmitted to to the remote target
+ *    device.
+ *
+ * This method will report a success or failure attempt to start a new task
+ * request to the hardware.  Since all task requests are sent on the high
+ * priority queue they can be sent when the RCN is in a TX suspend state.
+ * enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_node_context_await_suspension_state_start_task_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request)
+{
+	return SCI_SUCCESS;
+}
+
+static enum sci_status scic_sds_remote_node_context_await_suspension_state_event_handler(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	switch (scu_get_event_type(event_code)) {
+	case SCU_EVENT_TL_RNC_SUSPEND_TX:
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE
+			);
+
+		this_rnc->suspension_code = scu_get_event_specifier(event_code);
+		status = SCI_SUCCESS;
+		break;
+
+	case SCU_EVENT_TL_RNC_SUSPEND_TX_RX:
+		sci_base_state_machine_change_state(
+			&this_rnc->state_machine,
+			SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE
+			);
+
+		this_rnc->suspension_code = scu_get_event_specifier(event_code);
+		status = SCI_SUCCESS;
+		break;
+
+	default:
+		dev_warn(scirdev_to_dev(this_rnc->device),
+			 "%s: SCIC Remote Node Context 0x%p requested to "
+			 "process event 0x%x while in state %d.\n",
+			 __func__,
+			 this_rnc,
+			 event_code,
+			 sci_base_state_machine_get_state(
+				 &this_rnc->state_machine));
+
+		status = SCI_FAILURE;
+		break;
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+struct scic_sds_remote_node_context_handlers
+scic_sds_remote_node_context_state_handler_table[
+	SCIC_SDS_REMOTE_NODE_CONTEXT_MAX_STATES] =
+{
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE */
+	{
+		scic_sds_remote_node_context_default_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_initial_state_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_default_start_task_handler,
+		scic_sds_remote_node_context_default_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_continue_to_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_default_start_task_handler,
+		scic_sds_remote_node_context_posting_state_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE */
+	{
+		scic_sds_remote_node_context_invalidating_state_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_continue_to_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_default_start_task_handler,
+		scic_sds_remote_node_context_invalidating_state_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_continue_to_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_success_start_task_handler,
+		scic_sds_remote_node_context_resuming_state_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_ready_state_suspend_handler,
+		scic_sds_remote_node_context_default_resume_handler,
+		scic_sds_remote_node_context_ready_state_start_io_handler,
+		scic_sds_remote_node_context_success_start_task_handler,
+		scic_sds_remote_node_context_ready_state_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_tx_suspended_state_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_suspended_start_task_handler,
+		scic_sds_remote_node_context_default_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_tx_rx_suspended_state_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_suspended_start_task_handler,
+		scic_sds_remote_node_context_default_event_handler
+	},
+	/* SCIC_SDS_REMOTE_NODE_CONTEXT_AWAIT_SUSPENSION_STATE */
+	{
+		scic_sds_remote_node_context_general_destruct_handler,
+		scic_sds_remote_node_context_default_suspend_handler,
+		scic_sds_remote_node_context_await_suspension_state_resume_handler,
+		scic_sds_remote_node_context_default_start_io_handler,
+		scic_sds_remote_node_context_await_suspension_state_start_task_handler,
+		scic_sds_remote_node_context_await_suspension_state_event_handler
+	}
+};
+
+/*
+ * *****************************************************************************
+ * * REMOTE NODE CONTEXT PRIVATE METHODS
+ * ***************************************************************************** */
+
+/**
+ *
+ *
+ * This method just calls the user callback function and then resets the
+ * callback.
+ */
+static void scic_sds_remote_node_context_notify_user(
+	struct scic_sds_remote_node_context *rnc)
+{
+	if (rnc->user_callback != NULL) {
+		(*rnc->user_callback)(rnc->user_cookie);
+
+		rnc->user_callback = NULL;
+		rnc->user_cookie = NULL;
+	}
+}
+
+/**
+ *
+ *
+ * This method will continue the remote node context state machine by
+ * requesting to resume the remote node context state machine from its current
+ * state.
+ */
+static void scic_sds_remote_node_context_continue_state_transitions(
+	struct scic_sds_remote_node_context *rnc)
+{
+	if (rnc->destination_state == SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_READY) {
+		rnc->state_handlers->resume_handler(
+			rnc, rnc->user_callback, rnc->user_cookie
+			);
+	}
+}
+
+/**
+ *
+ * @this_rnc: The remote node context object that is to be validated.
+ *
+ * This method will mark the rnc buffer as being valid and post the request to
+ * the hardware. none
+ */
+static void scic_sds_remote_node_context_validate_context_buffer(
+	struct scic_sds_remote_node_context *this_rnc)
+{
+	union scu_remote_node_context *rnc_buffer;
+
+	rnc_buffer = scic_sds_controller_get_remote_node_context_buffer(
+		scic_sds_remote_device_get_controller(this_rnc->device),
+		this_rnc->remote_node_index
+		);
+
+	rnc_buffer->ssp.is_valid = true;
+
+	if (
+		!this_rnc->device->is_direct_attached
+		&& this_rnc->device->target_protocols.u.bits.attached_stp_target
+		) {
+		scic_sds_remote_device_post_request(
+			this_rnc->device,
+			SCU_CONTEXT_COMMAND_POST_RNC_96
+			);
+	} else {
+		scic_sds_remote_device_post_request(
+			this_rnc->device,
+			SCU_CONTEXT_COMMAND_POST_RNC_32
+			);
+
+		if (this_rnc->device->is_direct_attached) {
+			scic_sds_port_setup_transports(
+				this_rnc->device->owning_port,
+				this_rnc->remote_node_index
+				);
+		}
+	}
+}
+
+/**
+ *
+ * @this_rnc: The remote node context object that is to be invalidated.
+ *
+ * This method will update the RNC buffer and post the invalidate request. none
+ */
+static void scic_sds_remote_node_context_invalidate_context_buffer(
+	struct scic_sds_remote_node_context *this_rnc)
+{
+	union scu_remote_node_context *rnc_buffer;
+
+	rnc_buffer = scic_sds_controller_get_remote_node_context_buffer(
+		scic_sds_remote_device_get_controller(this_rnc->device),
+		this_rnc->remote_node_index
+		);
+
+	rnc_buffer->ssp.is_valid = false;
+
+	scic_sds_remote_device_post_request(
+		this_rnc->device,
+		SCU_CONTEXT_COMMAND_POST_RNC_INVALIDATE
+		);
+}
+
+/*
+ * *****************************************************************************
+ * * REMOTE NODE CONTEXT STATE ENTER AND EXIT METHODS
+ * ***************************************************************************** */
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_initial_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE
+		);
+
+	/*
+	 * Check to see if we have gotten back to the initial state because someone
+	 * requested to destroy the remote node context object. */
+	if (
+		rnc->state_machine.previous_state_id
+		== SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE
+		) {
+		rnc->destination_state = SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_UNSPECIFIED;
+
+		scic_sds_remote_node_context_notify_user(rnc);
+	}
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_posting_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *this_rnc;
+
+	this_rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		this_rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE
+		);
+
+	scic_sds_remote_node_context_validate_context_buffer(this_rnc);
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_invalidating_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE
+		);
+
+	scic_sds_remote_node_context_invalidate_context_buffer(rnc);
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_resuming_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+	struct smp_discover_response_protocols protocols;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
+		);
+
+	/*
+	 * For direct attached SATA devices we need to clear the TLCR
+	 * NCQ to TCi tag mapping on the phy and in cases where we
+	 * resume because of a target reset we also need to update
+	 * the STPTLDARNI register with the RNi of the device
+	 */
+	scic_remote_device_get_protocols(rnc->device, &protocols);
+
+	if ((protocols.u.bits.attached_stp_target == 1) &&
+	    (rnc->device->is_direct_attached)) {
+		scic_sds_port_setup_transports(
+			rnc->device->owning_port, rnc->remote_node_index);
+	}
+
+	scic_sds_remote_device_post_request(
+		rnc->device,
+		SCU_CONTEXT_COMMAND_POST_RNC_RESUME
+		);
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_ready_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE
+		);
+
+	rnc->destination_state = SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_UNSPECIFIED;
+
+	if (rnc->user_callback != NULL) {
+		scic_sds_remote_node_context_notify_user(rnc);
+	}
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_tx_suspended_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE
+		);
+
+	scic_sds_remote_node_context_continue_state_transitions(rnc);
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_tx_rx_suspended_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE
+		);
+
+	scic_sds_remote_node_context_continue_state_transitions(rnc);
+}
+
+/**
+ *
+ *
+ *
+ */
+static void scic_sds_remote_node_context_await_suspension_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_node_context *rnc;
+
+	rnc = (struct scic_sds_remote_node_context *)object;
+
+	SET_STATE_HANDLER(
+		rnc,
+		scic_sds_remote_node_context_state_handler_table,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_AWAIT_SUSPENSION_STATE
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_remote_node_context_state_table[] = {
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE] = {
+		.enter_state = scic_sds_remote_node_context_initial_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE] = {
+		.enter_state = scic_sds_remote_node_context_posting_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE] = {
+		.enter_state = scic_sds_remote_node_context_invalidating_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE] = {
+		.enter_state = scic_sds_remote_node_context_resuming_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE] = {
+		.enter_state = scic_sds_remote_node_context_ready_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE] = {
+		.enter_state = scic_sds_remote_node_context_tx_suspended_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE] = {
+		.enter_state = scic_sds_remote_node_context_tx_rx_suspended_state_enter,
+	},
+	[SCIC_SDS_REMOTE_NODE_CONTEXT_AWAIT_SUSPENSION_STATE] = {
+		.enter_state = scic_sds_remote_node_context_await_suspension_state_enter,
+	},
+};
+
diff --git a/drivers/scsi/isci/core/scic_sds_remote_node_context.h b/drivers/scsi/isci/core/scic_sds_remote_node_context.h
new file mode 100644
index 0000000..86c6d75
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_node_context.h
@@ -0,0 +1,323 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCIC_SDS_REMOTE_NODE_CONTEXT_H_
+#define _SCIC_SDS_REMOTE_NODE_CONTEXT_H_
+
+/**
+ * This file contains the structures, constants, and prototypes associated with
+ *    the remote node context in the silicon.  It exists to model and manage
+ *    the remote node context in the silicon.
+ *
+ *
+ */
+
+#include "sci_base_state.h"
+#include "sci_base_state_machine.h"
+
+/**
+ *
+ *
+ * This constant represents an invalid remote device id, it is used to program
+ * the STPDARNI register so the driver knows when it has received a SIGNATURE
+ * FIS from the SCU.
+ */
+#define SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX    0x0FFF
+
+#define SCU_HARDWARE_SUSPENSION  (0)
+#define SCI_SOFTWARE_SUSPENSION  (1)
+
+struct scic_sds_request;
+struct scic_sds_remote_device;
+struct scic_sds_remote_node_context;
+
+typedef void (*scics_sds_remote_node_context_callback)(void *);
+
+typedef enum sci_status (*scic_sds_remote_node_context_operation)(
+	struct scic_sds_remote_node_context *this_rnc,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter
+	);
+
+typedef enum sci_status (*scic_sds_remote_node_context_suspend_operation)(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 suspension_type,
+	scics_sds_remote_node_context_callback the_callback,
+	void *callback_parameter
+	);
+
+typedef enum sci_status (*scic_sds_remote_node_context_io_request)(
+	struct scic_sds_remote_node_context *this_rnc,
+	struct scic_sds_request *the_request
+	);
+
+typedef enum sci_status (*scic_sds_remote_node_context_event_handler)(
+	struct scic_sds_remote_node_context *this_rnc,
+	u32 event_code
+	);
+
+struct scic_sds_remote_node_context_handlers {
+	/**
+	 * This handle is invoked to stop the RNC.  The callback is invoked when after
+	 * the hardware notification that the RNC has been invalidated.
+	 */
+	scic_sds_remote_node_context_operation destruct_handler;
+
+	/**
+	 * This handler is invoked when there is a request to suspend  the RNC.  The
+	 * callback is invoked after the hardware notification that the remote node is
+	 * suspended.
+	 */
+	scic_sds_remote_node_context_suspend_operation suspend_handler;
+
+	/**
+	 * This handler is invoked when there is a request to resume the RNC.  The
+	 * callback is invoked when after the RNC has reached the ready state.
+	 */
+	scic_sds_remote_node_context_operation resume_handler;
+
+	/**
+	 * This handler is invoked when there is a request to start an io request
+	 * operation.
+	 */
+	scic_sds_remote_node_context_io_request start_io_handler;
+
+	/**
+	 * This handler is invoked when there is a request to start a task request
+	 * operation.
+	 */
+	scic_sds_remote_node_context_io_request start_task_handler;
+
+	/**
+	 * This handler is invoked where there is an RNC event that must be processed.
+	 */
+	scic_sds_remote_node_context_event_handler event_handler;
+
+};
+
+/**
+ * This is the enumeration of the remote node context states.
+ */
+enum scis_sds_remote_node_context_states {
+	/**
+	 * This state is the initial state for a remote node context.  On a resume
+	 * request the remote node context will transition to the posting state.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_INITIAL_STATE,
+
+	/**
+	 * This is a transition state that posts the RNi to the hardware. Once the RNC
+	 * is posted the remote node context will be made ready.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_POSTING_STATE,
+
+	/**
+	 * This is a transition state that will post an RNC invalidate to the
+	 * hardware.  Once the invalidate is complete the remote node context will
+	 * transition to the posting state.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE,
+
+	/**
+	 * This is a transition state that will post an RNC resume to the hardare.
+	 * Once the event notification of resume complete is received the remote node
+	 * context will transition to the ready state.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE,
+
+	/**
+	 * This is the state that the remote node context must be in to accept io
+	 * request operations.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_READY_STATE,
+
+	/**
+	 * This is the state that the remote node context transitions to when it gets
+	 * a TX suspend notification from the hardware.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_TX_SUSPENDED_STATE,
+
+	/**
+	 * This is the state that the remote node context transitions to when it gets
+	 * a TX RX suspend notification from the hardware.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_TX_RX_SUSPENDED_STATE,
+
+	/**
+	 * This state is a wait state for the remote node context that waits for a
+	 * suspend notification from the hardware.  This state is entered when either
+	 * there is a request to supend the remote node context or when there is a TC
+	 * completion where the remote node will be suspended by the hardware.
+	 */
+	SCIC_SDS_REMOTE_NODE_CONTEXT_AWAIT_SUSPENSION_STATE,
+
+	SCIC_SDS_REMOTE_NODE_CONTEXT_MAX_STATES
+
+};
+
+/**
+ *
+ *
+ * This enumeration is used to define the end destination state for the remote
+ * node context.
+ */
+enum SCIC_SDS_REMOTE_NODE_CONTEXT_DESTINATION_STATE {
+	SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_UNSPECIFIED,
+	SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_READY,
+	SCIC_SDS_REMOTE_NODE_DESTINATION_STATE_FINAL
+};
+
+/**
+ * struct scic_sds_remote_node_context - This structure contains the data
+ *    associated with the remote node context object.  The remote node context
+ *    (RNC) object models the the remote device information necessary to manage
+ *    the silicon RNC.
+ */
+struct scic_sds_remote_node_context {
+	/*
+	 * parent object
+	 */
+	struct sci_base_object parent;
+
+	/**
+	 * This pointer simply points to the remote device object containing
+	 * this RNC.
+	 *
+	 * @todo Consider making the device pointer the associated object of the
+	 *       the parent object.
+	 */
+	struct scic_sds_remote_device *device;
+
+	/**
+	 * This field indicates the remote node index (RNI) associated with
+	 * this RNC.
+	 */
+	u16 remote_node_index;
+
+	/**
+	 * This field is the recored suspension code or the reason for the remote node
+	 * context suspension.
+	 */
+	u32 suspension_code;
+
+	/**
+	 * This field is true if the remote node context is resuming from its current
+	 * state.  This can cause an automatic resume on receiving a suspension
+	 * notification.
+	 */
+	enum SCIC_SDS_REMOTE_NODE_CONTEXT_DESTINATION_STATE destination_state;
+
+	/**
+	 * This field contains the callback function that the user requested to be
+	 * called when the requested state transition is complete.
+	 */
+	scics_sds_remote_node_context_callback user_callback;
+
+	/**
+	 * This field contains the parameter that is called when the user requested
+	 * state transition is completed.
+	 */
+	void *user_cookie;
+
+	/**
+	 * This field contains the data for the object's state machine.
+	 */
+	struct sci_base_state_machine state_machine;
+
+	struct scic_sds_remote_node_context_handlers *state_handlers;
+};
+
+extern const struct sci_base_state scic_sds_remote_node_context_state_table[];
+
+extern struct scic_sds_remote_node_context_handlers
+	scic_sds_remote_node_context_state_handler_table[
+	SCIC_SDS_REMOTE_NODE_CONTEXT_MAX_STATES];
+
+void scic_sds_remote_node_context_construct(
+	struct scic_sds_remote_device *device,
+	struct scic_sds_remote_node_context *rnc,
+	u16 remote_node_index);
+
+void scic_sds_remote_node_context_construct_buffer(
+	struct scic_sds_remote_node_context *rnc);
+
+bool scic_sds_remote_node_context_is_ready(
+	struct scic_sds_remote_node_context *this_rnc);
+
+#define scic_sds_remote_node_context_set_remote_node_index(rnc, rni) \
+	((rnc)->remote_node_index = (rni))
+
+#define scic_sds_remote_node_context_get_remote_node_index(rcn)	\
+	((rnc)->remote_node_index)
+
+#define scic_sds_remote_node_context_event_handler(rnc, event_code) \
+	((rnc)->state_handlers->event_handler(rnc, event_code))
+
+#define scic_sds_remote_node_context_resume(rnc, callback, parameter) \
+	((rnc)->state_handlers->resume_handler(rnc, callback, parameter))
+
+#define scic_sds_remote_node_context_suspend(rnc, suspend_type, callback, parameter) \
+	((rnc)->state_handlers->suspend_handler(rnc, suspend_type, callback, parameter))
+
+#define scic_sds_remote_node_context_destruct(rnc, callback, parameter)	\
+	((rnc)->state_handlers->destruct_handler(rnc, callback, parameter))
+
+#define scic_sds_remote_node_context_start_io(rnc, request) \
+	((rnc)->state_handlers->start_io_handler(rnc, request))
+
+#define scic_sds_remote_node_context_start_task(rnc, task) \
+	((rnc)->state_handlers->start_task_handler(rnc, task))
+
+#endif  /* _SCIC_SDS_REMOTE_NODE_CONTEXT_H_ */
diff --git a/drivers/scsi/isci/core/scic_sds_remote_node_table.c b/drivers/scsi/isci/core/scic_sds_remote_node_table.c
new file mode 100644
index 0000000..77919a2
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_node_table.c
@@ -0,0 +1,600 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/**
+ * This file contains the implementation of the SCIC_SDS_REMOTE_NODE_TABLE
+ *    public, protected, and private methods.
+ *
+ *
+ */
+#include "sci_util.h"
+#include "sci_environment.h"
+#include "scic_sds_remote_node_table.h"
+#include "scic_sds_remote_node_context.h"
+
+/**
+ *
+ * @remote_node_table: This is the remote node index table from which the
+ *    selection will be made.
+ * @group_table_index: This is the index to the group table from which to
+ *    search for an available selection.
+ *
+ * This routine will find the bit position in absolute bit terms of the next 32
+ * + bit position.  If there are available bits in the first u32 then it is
+ * just bit position. u32 This is the absolute bit position for an available
+ * group.
+ */
+static u32 scic_sds_remote_node_table_get_group_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_table_index)
+{
+	u32 dword_index;
+	u32 *group_table;
+	u32 bit_index;
+
+	group_table = remote_node_table->remote_node_groups[group_table_index];
+
+	for (dword_index = 0; dword_index < remote_node_table->group_array_size; dword_index++) {
+		if (group_table[dword_index] != 0) {
+			for (bit_index = 0; bit_index < 32; bit_index++) {
+				if ((group_table[dword_index] & (1 << bit_index)) != 0) {
+					return (dword_index * 32) + bit_index;
+				}
+			}
+		}
+	}
+
+	return SCIC_SDS_REMOTE_NODE_TABLE_INVALID_INDEX;
+}
+
+/**
+ *
+ * @out]: remote_node_table This the remote node table in which to clear the
+ *    selector.
+ * @set_index: This is the remote node selector in which the change will be
+ *    made.
+ * @group_index: This is the bit index in the table to be modified.
+ *
+ * This method will clear the group index entry in the specified group index
+ * table. none
+ */
+static void scic_sds_remote_node_table_clear_group_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_table_index,
+	u32 group_index)
+{
+	u32 dword_index;
+	u32 bit_index;
+	u32 *group_table;
+
+	BUG_ON(group_table_index >= SCU_STP_REMOTE_NODE_COUNT);
+	BUG_ON(group_index >= (u32)(remote_node_table->group_array_size * 32));
+
+	dword_index = group_index / 32;
+	bit_index   = group_index % 32;
+	group_table = remote_node_table->remote_node_groups[group_table_index];
+
+	group_table[dword_index] = group_table[dword_index] & ~(1 << bit_index);
+}
+
+/**
+ *
+ * @out]: remote_node_table This the remote node table in which to set the
+ *    selector.
+ * @group_table_index: This is the remote node selector in which the change
+ *    will be made.
+ * @group_index: This is the bit position in the table to be modified.
+ *
+ * This method will set the group index bit entry in the specified gropu index
+ * table. none
+ */
+static void scic_sds_remote_node_table_set_group_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_table_index,
+	u32 group_index)
+{
+	u32 dword_index;
+	u32 bit_index;
+	u32 *group_table;
+
+	BUG_ON(group_table_index >= SCU_STP_REMOTE_NODE_COUNT);
+	BUG_ON(group_index >= (u32)(remote_node_table->group_array_size * 32));
+
+	dword_index = group_index / 32;
+	bit_index   = group_index % 32;
+	group_table = remote_node_table->remote_node_groups[group_table_index];
+
+	group_table[dword_index] = group_table[dword_index] | (1 << bit_index);
+}
+
+/**
+ *
+ * @out]: remote_node_table This is the remote node table in which to modify
+ *    the remote node availability.
+ * @remote_node_index: This is the remote node index that is being returned to
+ *    the table.
+ *
+ * This method will set the remote to available in the remote node allocation
+ * table. none
+ */
+static void scic_sds_remote_node_table_set_node_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_index)
+{
+	u32 dword_location;
+	u32 dword_remainder;
+	u32 slot_normalized;
+	u32 slot_position;
+
+	BUG_ON(
+		(remote_node_table->available_nodes_array_size * SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD)
+		<= (remote_node_index / SCU_STP_REMOTE_NODE_COUNT)
+		);
+
+	dword_location  = remote_node_index / SCIC_SDS_REMOTE_NODES_PER_DWORD;
+	dword_remainder = remote_node_index % SCIC_SDS_REMOTE_NODES_PER_DWORD;
+	slot_normalized = (dword_remainder / SCU_STP_REMOTE_NODE_COUNT) * sizeof(u32);
+	slot_position   = remote_node_index % SCU_STP_REMOTE_NODE_COUNT;
+
+	remote_node_table->available_remote_nodes[dword_location] |=
+		1 << (slot_normalized + slot_position);
+}
+
+/**
+ *
+ * @out]: remote_node_table This is the remote node table from which to clear
+ *    the available remote node bit.
+ * @remote_node_index: This is the remote node index which is to be cleared
+ *    from the table.
+ *
+ * This method clears the remote node index from the table of available remote
+ * nodes. none
+ */
+static void scic_sds_remote_node_table_clear_node_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_index)
+{
+	u32 dword_location;
+	u32 dword_remainder;
+	u32 slot_position;
+	u32 slot_normalized;
+
+	BUG_ON(
+		(remote_node_table->available_nodes_array_size * SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD)
+		<= (remote_node_index / SCU_STP_REMOTE_NODE_COUNT)
+		);
+
+	dword_location  = remote_node_index / SCIC_SDS_REMOTE_NODES_PER_DWORD;
+	dword_remainder = remote_node_index % SCIC_SDS_REMOTE_NODES_PER_DWORD;
+	slot_normalized = (dword_remainder / SCU_STP_REMOTE_NODE_COUNT) * sizeof(u32);
+	slot_position   = remote_node_index % SCU_STP_REMOTE_NODE_COUNT;
+
+	remote_node_table->available_remote_nodes[dword_location] &=
+		~(1 << (slot_normalized + slot_position));
+}
+
+/**
+ *
+ * @out]: remote_node_table The remote node table from which the slot will be
+ *    cleared.
+ * @group_index: The index for the slot that is to be cleared.
+ *
+ * This method clears the entire table slot at the specified slot index. none
+ */
+static void scic_sds_remote_node_table_clear_group(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_index)
+{
+	u32 dword_location;
+	u32 dword_remainder;
+	u32 dword_value;
+
+	BUG_ON(
+		(remote_node_table->available_nodes_array_size * SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD)
+		<= (group_index / SCU_STP_REMOTE_NODE_COUNT)
+		);
+
+	dword_location  = group_index / SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+	dword_remainder = group_index % SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+
+	dword_value = remote_node_table->available_remote_nodes[dword_location];
+	dword_value &= ~(SCIC_SDS_REMOTE_NODE_TABLE_FULL_SLOT_VALUE << (dword_remainder * 4));
+	remote_node_table->available_remote_nodes[dword_location] = dword_value;
+}
+
+/**
+ *
+ * @remote_node_table:
+ *
+ * THis method sets an entire remote node group in the remote node table.
+ */
+static void scic_sds_remote_node_table_set_group(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_index)
+{
+	u32 dword_location;
+	u32 dword_remainder;
+	u32 dword_value;
+
+	BUG_ON(
+		(remote_node_table->available_nodes_array_size * SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD)
+		<= (group_index / SCU_STP_REMOTE_NODE_COUNT)
+		);
+
+	dword_location  = group_index / SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+	dword_remainder = group_index % SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+
+	dword_value = remote_node_table->available_remote_nodes[dword_location];
+	dword_value |= (SCIC_SDS_REMOTE_NODE_TABLE_FULL_SLOT_VALUE << (dword_remainder * 4));
+	remote_node_table->available_remote_nodes[dword_location] = dword_value;
+}
+
+/**
+ *
+ * @remote_node_table: This is the remote node table that for which the group
+ *    value is to be returned.
+ * @group_index: This is the group index to use to find the group value.
+ *
+ * This method will return the group value for the specified group index. The
+ * bit values at the specified remote node group index.
+ */
+static u8 scic_sds_remote_node_table_get_group_value(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_index)
+{
+	u32 dword_location;
+	u32 dword_remainder;
+	u32 dword_value;
+
+	dword_location  = group_index / SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+	dword_remainder = group_index % SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD;
+
+	dword_value = remote_node_table->available_remote_nodes[dword_location];
+	dword_value &= (SCIC_SDS_REMOTE_NODE_TABLE_FULL_SLOT_VALUE << (dword_remainder * 4));
+	dword_value = dword_value >> (dword_remainder * 4);
+
+	return (u8)dword_value;
+}
+
+/**
+ *
+ * @out]: remote_node_table The remote that which is to be initialized.
+ * @remote_node_entries: The number of entries to put in the table.
+ *
+ * This method will initialize the remote node table for use. none
+ */
+void scic_sds_remote_node_table_initialize(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_entries)
+{
+	u32 index;
+
+	/*
+	 * Initialize the raw data we could improve the speed by only initializing
+	 * those entries that we are actually going to be used */
+	memset(
+		remote_node_table->available_remote_nodes,
+		0x00,
+		sizeof(remote_node_table->available_remote_nodes)
+		);
+
+	memset(
+		remote_node_table->remote_node_groups,
+		0x00,
+		sizeof(remote_node_table->remote_node_groups)
+		);
+
+	/* Initialize the available remote node sets */
+	remote_node_table->available_nodes_array_size = (u16)
+							(remote_node_entries / SCIC_SDS_REMOTE_NODES_PER_DWORD)
+							+ ((remote_node_entries % SCIC_SDS_REMOTE_NODES_PER_DWORD) != 0);
+
+
+	/* Initialize each full DWORD to a FULL SET of remote nodes */
+	for (index = 0; index < remote_node_entries; index++) {
+		scic_sds_remote_node_table_set_node_index(remote_node_table, index);
+	}
+
+	remote_node_table->group_array_size = (u16)
+					      (remote_node_entries / (SCU_STP_REMOTE_NODE_COUNT * 32))
+					      + ((remote_node_entries % (SCU_STP_REMOTE_NODE_COUNT * 32)) != 0);
+
+	for (index = 0; index < (remote_node_entries / SCU_STP_REMOTE_NODE_COUNT); index++) {
+		/*
+		 * These are all guaranteed to be full slot values so fill them in the
+		 * available sets of 3 remote nodes */
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 2, index);
+	}
+
+	/* Now fill in any remainders that we may find */
+	if ((remote_node_entries % SCU_STP_REMOTE_NODE_COUNT) == 2) {
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 1, index);
+	} else if ((remote_node_entries % SCU_STP_REMOTE_NODE_COUNT) == 1) {
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 0, index);
+	}
+}
+
+/**
+ *
+ * @out]: remote_node_table The remote node table from which to allocate a
+ *    remote node.
+ * @table_index: The group index that is to be used for the search.
+ *
+ * This method will allocate a single RNi from the remote node table.  The
+ * table index will determine from which remote node group table to search.
+ * This search may fail and another group node table can be specified.  The
+ * function is designed to allow a serach of the available single remote node
+ * group up to the triple remote node group.  If an entry is found in the
+ * specified table the remote node is removed and the remote node groups are
+ * updated. The RNi value or an invalid remote node context if an RNi can not
+ * be found.
+ */
+static u16 scic_sds_remote_node_table_allocate_single_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_table_index)
+{
+	u8 index;
+	u8 group_value;
+	u32 group_index;
+	u16 remote_node_index = SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX;
+
+	group_index = scic_sds_remote_node_table_get_group_index(
+		remote_node_table, group_table_index);
+
+	/* We could not find an available slot in the table selector 0 */
+	if (group_index != SCIC_SDS_REMOTE_NODE_TABLE_INVALID_INDEX) {
+		group_value = scic_sds_remote_node_table_get_group_value(
+			remote_node_table, group_index);
+
+		for (index = 0; index < SCU_STP_REMOTE_NODE_COUNT; index++) {
+			if (((1 << index) & group_value) != 0) {
+				/* We have selected a bit now clear it */
+				remote_node_index = (u16)(group_index * SCU_STP_REMOTE_NODE_COUNT
+							  + index);
+
+				scic_sds_remote_node_table_clear_group_index(
+					remote_node_table, group_table_index, group_index
+					);
+
+				scic_sds_remote_node_table_clear_node_index(
+					remote_node_table, remote_node_index
+					);
+
+				if (group_table_index > 0) {
+					scic_sds_remote_node_table_set_group_index(
+						remote_node_table, group_table_index - 1, group_index
+						);
+				}
+
+				break;
+			}
+		}
+	}
+
+	return remote_node_index;
+}
+
+/**
+ *
+ * @remote_node_table: This is the remote node table from which to allocate the
+ *    remote node entries.
+ * @group_table_index: THis is the group table index which must equal two (2)
+ *    for this operation.
+ *
+ * This method will allocate three consecutive remote node context entries. If
+ * there are no remaining triple entries the function will return a failure.
+ * The remote node index that represents three consecutive remote node entries
+ * or an invalid remote node context if none can be found.
+ */
+static u16 scic_sds_remote_node_table_allocate_triple_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u32 group_table_index)
+{
+	u32 group_index;
+	u16 remote_node_index = SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX;
+
+	group_index = scic_sds_remote_node_table_get_group_index(
+		remote_node_table, group_table_index);
+
+	if (group_index != SCIC_SDS_REMOTE_NODE_TABLE_INVALID_INDEX) {
+		remote_node_index = (u16)group_index * SCU_STP_REMOTE_NODE_COUNT;
+
+		scic_sds_remote_node_table_clear_group_index(
+			remote_node_table, group_table_index, group_index
+			);
+
+		scic_sds_remote_node_table_clear_group(
+			remote_node_table, group_index
+			);
+	}
+
+	return remote_node_index;
+}
+
+/**
+ *
+ * @remote_node_table: This is the remote node table from which the remote node
+ *    allocation is to take place.
+ * @remote_node_count: This is ther remote node count which is one of
+ *    SCU_SSP_REMOTE_NODE_COUNT(1) or SCU_STP_REMOTE_NODE_COUNT(3).
+ *
+ * This method will allocate a remote node that mataches the remote node count
+ * specified by the caller.  Valid values for remote node count is
+ * SCU_SSP_REMOTE_NODE_COUNT(1) or SCU_STP_REMOTE_NODE_COUNT(3). u16 This is
+ * the remote node index that is returned or an invalid remote node context.
+ */
+u16 scic_sds_remote_node_table_allocate_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_count)
+{
+	u16 remote_node_index = SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX;
+
+	if (remote_node_count == SCU_SSP_REMOTE_NODE_COUNT) {
+		remote_node_index =
+			scic_sds_remote_node_table_allocate_single_remote_node(
+				remote_node_table, 0);
+
+		if (remote_node_index == SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX) {
+			remote_node_index =
+				scic_sds_remote_node_table_allocate_single_remote_node(
+					remote_node_table, 1);
+		}
+
+		if (remote_node_index == SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX) {
+			remote_node_index =
+				scic_sds_remote_node_table_allocate_single_remote_node(
+					remote_node_table, 2);
+		}
+	} else if (remote_node_count == SCU_STP_REMOTE_NODE_COUNT) {
+		remote_node_index =
+			scic_sds_remote_node_table_allocate_triple_remote_node(
+				remote_node_table, 2);
+	}
+
+	return remote_node_index;
+}
+
+/**
+ *
+ * @remote_node_table:
+ *
+ * This method will free a single remote node index back to the remote node
+ * table.  This routine will update the remote node groups
+ */
+static void scic_sds_remote_node_table_release_single_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u16 remote_node_index)
+{
+	u32 group_index;
+	u8 group_value;
+
+	group_index = remote_node_index / SCU_STP_REMOTE_NODE_COUNT;
+
+	group_value = scic_sds_remote_node_table_get_group_value(remote_node_table, group_index);
+
+	/*
+	 * Assert that we are not trying to add an entry to a slot that is already
+	 * full. */
+	BUG_ON(group_value == SCIC_SDS_REMOTE_NODE_TABLE_FULL_SLOT_VALUE);
+
+	if (group_value == 0x00) {
+		/*
+		 * There are no entries in this slot so it must be added to the single
+		 * slot table. */
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 0, group_index);
+	} else if ((group_value & (group_value - 1)) == 0) {
+		/*
+		 * There is only one entry in this slot so it must be moved from the
+		 * single slot table to the dual slot table */
+		scic_sds_remote_node_table_clear_group_index(remote_node_table, 0, group_index);
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 1, group_index);
+	} else {
+		/*
+		 * There are two entries in the slot so it must be moved from the dual
+		 * slot table to the tripple slot table. */
+		scic_sds_remote_node_table_clear_group_index(remote_node_table, 1, group_index);
+		scic_sds_remote_node_table_set_group_index(remote_node_table, 2, group_index);
+	}
+
+	scic_sds_remote_node_table_set_node_index(remote_node_table, remote_node_index);
+}
+
+/**
+ *
+ * @remote_node_table: This is the remote node table to which the remote node
+ *    index is to be freed.
+ *
+ * This method will release a group of three consecutive remote nodes back to
+ * the free remote nodes.
+ */
+static void scic_sds_remote_node_table_release_triple_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u16 remote_node_index)
+{
+	u32 group_index;
+
+	group_index = remote_node_index / SCU_STP_REMOTE_NODE_COUNT;
+
+	scic_sds_remote_node_table_set_group_index(
+		remote_node_table, 2, group_index
+		);
+
+	scic_sds_remote_node_table_set_group(remote_node_table, group_index);
+}
+
+/**
+ *
+ * @remote_node_table: The remote node table to which the remote node index is
+ *    to be freed.
+ * @remote_node_count: This is the count of consecutive remote nodes that are
+ *    to be freed.
+ *
+ * This method will release the remote node index back into the remote node
+ * table free pool.
+ */
+void scic_sds_remote_node_table_release_remote_node_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_count,
+	u16 remote_node_index)
+{
+	if (remote_node_count == SCU_SSP_REMOTE_NODE_COUNT) {
+		scic_sds_remote_node_table_release_single_remote_node(
+			remote_node_table, remote_node_index);
+	} else if (remote_node_count == SCU_STP_REMOTE_NODE_COUNT) {
+		scic_sds_remote_node_table_release_triple_remote_node(
+			remote_node_table, remote_node_index);
+	}
+}
+
diff --git a/drivers/scsi/isci/core/scic_sds_remote_node_table.h b/drivers/scsi/isci/core/scic_sds_remote_node_table.h
new file mode 100644
index 0000000..9c02a6c
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_node_table.h
@@ -0,0 +1,195 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCIC_SDS_REMOTE_NODE_TABLE_H_
+#define _SCIC_SDS_REMOTE_NODE_TABLE_H_
+
+/**
+ * This file contains the structures, constants and prototypes used for the
+ *    remote node table.
+ *
+ *
+ */
+
+#include "sci_controller_constants.h"
+
+/**
+ *
+ *
+ * Remote node sets are sets of remote node index in the remtoe node table The
+ * SCU hardware requires that STP remote node entries take three consecutive
+ * remote node index so the table is arranged in sets of three. The bits are
+ * used as 0111 0111 to make a byte and the bits define the set of three remote
+ * nodes to use as a sequence.
+ */
+#define SCIC_SDS_REMOTE_NODE_SETS_PER_BYTE 2
+
+/**
+ *
+ *
+ * Since the remote node table is organized as DWORDS take the remote node sets
+ * in bytes and represent them in DWORDs. The lowest ordered bits are the ones
+ * used in case full DWORD is not being used. i.e. 0000 0000 0000 0000 0111
+ * 0111 0111 0111 // if only a single WORD is in use in the DWORD.
+ */
+#define SCIC_SDS_REMOTE_NODE_SETS_PER_DWORD \
+	(sizeof(u32) * SCIC_SDS_REMOTE_NODE_SETS_PER_BYTE)
+/**
+ *
+ *
+ * This is a count of the numeber of remote nodes that can be represented in a
+ * byte
+ */
+#define SCIC_SDS_REMOTE_NODES_PER_BYTE	\
+	(SCU_STP_REMOTE_NODE_COUNT * SCIC_SDS_REMOTE_NODE_SETS_PER_BYTE)
+
+/**
+ *
+ *
+ * This is a count of the number of remote nodes that can be represented in a
+ * DWROD
+ */
+#define SCIC_SDS_REMOTE_NODES_PER_DWORD	\
+	(sizeof(u32) * SCIC_SDS_REMOTE_NODES_PER_BYTE)
+
+/**
+ *
+ *
+ * This is the number of bits in a remote node group
+ */
+#define SCIC_SDS_REMOTE_NODES_BITS_PER_GROUP   4
+
+#define SCIC_SDS_REMOTE_NODE_TABLE_INVALID_INDEX      (0xFFFFFFFF)
+#define SCIC_SDS_REMOTE_NODE_TABLE_FULL_SLOT_VALUE    (0x07)
+#define SCIC_SDS_REMOTE_NODE_TABLE_EMPTY_SLOT_VALUE   (0x00)
+
+/**
+ *
+ *
+ * Expander attached sata remote node count
+ */
+#define SCU_STP_REMOTE_NODE_COUNT        3
+
+/**
+ *
+ *
+ * Expander or direct attached ssp remote node count
+ */
+#define SCU_SSP_REMOTE_NODE_COUNT        1
+
+/**
+ *
+ *
+ * Direct attached STP remote node count
+ */
+#define SCU_SATA_REMOTE_NODE_COUNT       1
+
+/**
+ * struct scic_remote_node_table -
+ *
+ *
+ */
+struct scic_remote_node_table {
+	/**
+	 * This field contains the array size in dwords
+	 */
+	u16 available_nodes_array_size;
+
+	/**
+	 * This field contains the array size of the
+	 */
+	u16 group_array_size;
+
+	/**
+	 * This field is the array of available remote node entries in bits.
+	 * Because of the way STP remote node data is allocated on the SCU hardware
+	 * the remote nodes must occupy three consecutive remote node context
+	 * entries.  For ease of allocation and de-allocation we have broken the
+	 * sets of three into a single nibble.  When the STP RNi is allocated all
+	 * of the bits in the nibble are cleared.  This math results in a table size
+	 * of MAX_REMOTE_NODES / CONSECUTIVE RNi ENTRIES for STP / 2 entries per byte.
+	 */
+	u32 available_remote_nodes[
+		(SCI_MAX_REMOTE_DEVICES / SCIC_SDS_REMOTE_NODES_PER_DWORD)
+		+ ((SCI_MAX_REMOTE_DEVICES % SCIC_SDS_REMOTE_NODES_PER_DWORD) != 0)];
+
+	/**
+	 * This field is the nibble selector for the above table.  There are three
+	 * possible selectors each for fast lookup when trying to find one, two or
+	 * three remote node entries.
+	 */
+	u32 remote_node_groups[
+		SCU_STP_REMOTE_NODE_COUNT][
+		(SCI_MAX_REMOTE_DEVICES / (32 * SCU_STP_REMOTE_NODE_COUNT))
+		+ ((SCI_MAX_REMOTE_DEVICES % (32 * SCU_STP_REMOTE_NODE_COUNT)) != 0)];
+
+};
+
+/* --------------------------------------------------------------------------- */
+
+void scic_sds_remote_node_table_initialize(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_entries);
+
+u16 scic_sds_remote_node_table_allocate_remote_node(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_count);
+
+void scic_sds_remote_node_table_release_remote_node_index(
+	struct scic_remote_node_table *remote_node_table,
+	u32 remote_node_count,
+	u16 remote_node_index);
+
+#endif /* _SCIC_SDS_REMOTE_NODE_TABLE_H_ */
diff --git a/drivers/scsi/isci/core/scu_remote_node_context.h b/drivers/scsi/isci/core/scu_remote_node_context.h
new file mode 100644
index 0000000..33745ad
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_remote_node_context.h
@@ -0,0 +1,229 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __SCU_REMOTE_NODE_CONTEXT_HEADER__
+#define __SCU_REMOTE_NODE_CONTEXT_HEADER__
+
+/**
+ * This file contains the structures and constatns used by the SCU hardware to
+ *    describe a remote node context.
+ *
+ *
+ */
+
+/**
+ * struct ssp_remote_node_context - This structure contains the SCU hardware
+ *    definition for an SSP remote node.
+ *
+ *
+ */
+struct ssp_remote_node_context {
+	/* WORD 0 */
+
+	/**
+	 * This field is the remote node index assigned for this remote node. All
+	 * remote nodes must have a unique remote node index. The value of the remote
+	 * node index can not exceed the maximum number of remote nodes reported in
+	 * the SCU device context capacity register.
+	 */
+	u32 remote_node_index:12;
+	u32 reserved0_1:4;
+
+	/**
+	 * This field tells the SCU hardware how many simultaneous connections that
+	 * this remote node will support.
+	 */
+	u32 remote_node_port_width:4;
+
+	/**
+	 * This field tells the SCU hardware which logical port to associate with this
+	 * remote node.
+	 */
+	u32 logical_port_index:3;
+	u32 reserved0_2:5;
+
+	/**
+	 * This field will enable the I_T nexus loss timer for this remote node.
+	 */
+	u32 nexus_loss_timer_enable:1;
+
+	/**
+	 * This field is the for driver debug only and is not used.
+	 */
+	u32 check_bit:1;
+
+	/**
+	 * This field must be set to true when the hardware DMAs the remote node
+	 * context to the hardware SRAM.  When the remote node is being invalidated
+	 * this field must be set to false.
+	 */
+	u32 is_valid:1;
+
+	/**
+	 * This field must be set to true.
+	 */
+	u32 is_remote_node_context:1;
+
+	/* WORD 1 - 2 */
+
+	/**
+	 * This is the low word of the remote device SAS Address
+	 */
+	u32 remote_sas_address_lo;
+
+	/**
+	 * This field is the high word of the remote device SAS Address
+	 */
+	u32 remote_sas_address_hi;
+
+	/* WORD 3 */
+	/**
+	 * This field reprensets the function number assigned to this remote device.
+	 * This value must match the virtual function number that is being used to
+	 * communicate to the device.
+	 */
+	u32 function_number:8;
+	u32 reserved3_1:8;
+
+	/**
+	 * This field provides the driver a way to cheat on the arbitration wait time
+	 * for this remote node.
+	 */
+	u32 arbitration_wait_time:16;
+
+	/* WORD 4 */
+	/**
+	 * This field tells the SCU hardware how long this device may occupy the
+	 * connection before it must be closed.
+	 */
+	u32 connection_occupancy_timeout:16;
+
+	/**
+	 * This field tells the SCU hardware how long to maintain a connection when
+	 * there are no frames being transmitted on the link.
+	 */
+	u32 connection_inactivity_timeout:16;
+
+	/* WORD  5 */
+	/**
+	 * This field allows the driver to cheat on the arbitration wait time for this
+	 * remote node.
+	 */
+	u32 initial_arbitration_wait_time:16;
+
+	/**
+	 * This field is tells the hardware what to program for the connection rate in
+	 * the open address frame.  See the SAS spec for valid values.
+	 */
+	u32 oaf_connection_rate:4;
+
+	/**
+	 * This field tells the SCU hardware what to program for the features in the
+	 * open address frame.  See the SAS spec for valid values.
+	 */
+	u32 oaf_features:4;
+
+	/**
+	 * This field tells the SCU hardware what to use for the source zone group in
+	 * the open address frame.  See the SAS spec for more details on zoning.
+	 */
+	u32 oaf_source_zone_group:8;
+
+	/* WORD 6 */
+	/**
+	 * This field tells the SCU hardware what to use as the more capibilities in
+	 * the open address frame. See the SAS Spec for details.
+	 */
+	u32 oaf_more_compatibility_features;
+
+	/* WORD 7 */
+	u32 reserved7;
+
+};
+
+/**
+ * struct stp_remote_node_context - This structure contains the SCU hardware
+ *    definition for a STP remote node.
+ *
+ * STP Targets are not yet supported so this definition is a placeholder until
+ * we do support them.
+ */
+struct stp_remote_node_context {
+	/**
+	 * Placeholder data for the STP remote node.
+	 */
+	u32 data[8];
+
+};
+
+/**
+ * This union combines the SAS and SATA remote node definitions.
+ *
+ * union scu_remote_node_context
+ */
+union scu_remote_node_context {
+	/**
+	 * SSP Remote Node
+	 */
+	struct ssp_remote_node_context ssp;
+
+	/**
+	 * STP Remote Node
+	 */
+	struct stp_remote_node_context stp;
+
+};
+
+#endif /* __SCU_REMOTE_NODE_CONTEXT_HEADER__ */

