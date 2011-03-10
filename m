From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 06/10] isci/core: stp
Date: Thu, 10 Mar 2011 02:54:50 -0800
Message-ID: <20110310105450.6485.64487.stgit@localhost6.localdomain6>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32328 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1CJKxe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:34 -0500
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

stp request support and state machines.  pio and exceptions handled in
software, fpdma and udma handled in hardware.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |  834 +++++++++
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |  153 ++
 drivers/scsi/isci/core/scic_sds_stp_pio_request.h  |  116 +
 drivers/scsi/isci/core/scic_sds_stp_request.c      | 1941 ++++++++++++++++++++
 drivers/scsi/isci/core/scic_sds_stp_request.h      |  221 ++
 5 files changed, 3265 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_pio_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.h

diff --git a/drivers/scsi/isci/core/scic_sds_stp_packet_request.c b/drivers/scsi/isci/core/scic_sds_stp_packet_request.c
new file mode 100644
index 0000000..97dc9bf
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_packet_request.c
@@ -0,0 +1,834 @@
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
+#if !defined(DISABLE_ATAPI)
+
+#include "intel_ata.h"
+#include "intel_sas.h"
+#include "intel_sata.h"
+#include "intel_sat.h"
+#include "sati_translator_sequence.h"
+#include "sci_base_state.h"
+#include "scic_controller.h"
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_request.h"
+#include "scic_sds_stp_packet_request.h"
+#include "scic_user_callback.h"
+#include "sci_util.h"
+#include "scu_completion_codes.h"
+#include "scu_task_context.h"
+
+
+/**
+ * This method will fill in the SCU Task Context for a PACKET fis. And
+ *    construct the request STARTED sub-state machine for Packet Protocol IO.
+ * @this_request: This parameter specifies the stp packet request object being
+ *    constructed.
+ *
+ */
+enum sci_status scic_sds_stp_packet_request_construct(
+	struct scic_sds_request *this_request)
+{
+	struct sata_fis_reg_h2d *h2d_fis =
+		scic_stp_io_request_get_h2d_reg_address(
+			this_request
+			);
+
+	/*
+	 * Work around, we currently only support PACKET DMA protocol, so we
+	 * need to make change to Packet Fis features field. */
+	h2d_fis->features = h2d_fis->features | ATA_PACKET_FEATURE_DMA;
+
+	scic_sds_stp_non_ncq_request_construct(this_request);
+
+	/* Build the Packet Fis task context structure */
+	scu_stp_raw_request_construct_task_context(
+		(struct scic_sds_stp_request *)this_request,
+		this_request->task_context_buffer
+		);
+
+	sci_base_state_machine_construct(
+		&this_request->started_substate_machine,
+		&this_request->parent.parent,
+		scic_sds_stp_packet_request_started_substate_table,
+		SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+
+/**
+ * This method will fill in the SCU Task Context for a Packet request command
+ *    phase in PACKET DMA DATA (IN/OUT) type. The following important settings
+ *    are utilized: -# task_type == SCU_TASK_TYPE_PACKET_DMA.  This simply
+ *    indicates that a normal request type (i.e. non-raw frame) is being
+ *    utilized to perform task management. -# control_frame == 1.  This ensures
+ *    that the proper endianess is set so that the bytes are transmitted in the
+ *    right order for a smp request frame.
+ * @this_request: This parameter specifies the smp request object being
+ *    constructed.
+ * @task_context: The task_context to be reconstruct for packet request command
+ *    phase.
+ *
+ */
+void scu_stp_packet_request_command_phase_construct_task_context(
+	struct scic_sds_request *this_request,
+	struct scu_task_context *task_context)
+{
+	void *atapi_cdb;
+	u32 atapi_cdb_length;
+	struct scic_sds_stp_request *stp_request = (struct scic_sds_stp_request *)this_request;
+
+	/*
+	 * reference: SSTL 1.13.4.2
+	 * task_type, sata_direction */
+	if (scic_cb_io_request_get_data_direction(this_request->user_request)
+	     == SCI_IO_REQUEST_DATA_OUT) {
+		task_context->task_type = SCU_TASK_TYPE_PACKET_DMA_OUT;
+		task_context->sata_direction = 0;
+	} else {  /* todo: for NO_DATA command, we need to send out raw frame. */
+		task_context->task_type = SCU_TASK_TYPE_PACKET_DMA_IN;
+		task_context->sata_direction = 1;
+	}
+
+	/* sata header */
+	memset(&(task_context->type.stp), 0, sizeof(struct STP_TASK_CONTEXT));
+	task_context->type.stp.fis_type = SATA_FIS_TYPE_DATA;
+
+	/*
+	 * Copy in the command IU with CDB so that the commandIU address doesn't
+	 * change. */
+	memset(this_request->command_buffer, 0, sizeof(struct sata_fis_reg_h2d));
+
+	atapi_cdb =
+		scic_cb_stp_packet_io_request_get_cdb_address(this_request->user_request);
+
+	atapi_cdb_length =
+		scic_cb_stp_packet_io_request_get_cdb_length(this_request->user_request);
+
+	memcpy(((u8 *)this_request->command_buffer + sizeof(u32)), atapi_cdb, atapi_cdb_length);
+
+	atapi_cdb_length =
+		max(atapi_cdb_length, stp_request->type.packet.device_preferred_cdb_length);
+
+	task_context->ssp_command_iu_length =
+		((atapi_cdb_length % 4) == 0) ?
+		(atapi_cdb_length / 4) : ((atapi_cdb_length / 4) + 1);
+
+	/* task phase is set to TX_CMD */
+	task_context->task_phase = 0x1;
+
+	/* retry counter */
+	task_context->stp_retry_count = 0;
+
+	if (scic_cb_request_is_initial_construction(this_request->user_request)) {
+		/* data transfer size. */
+		task_context->transfer_length_bytes =
+			scic_cb_io_request_get_transfer_length(this_request->user_request);
+
+		/* setup sgl */
+		scic_sds_request_build_sgl(this_request);
+	} else {
+		/* data transfer size, need to be 4 bytes aligned. */
+		task_context->transfer_length_bytes = (SCSI_FIXED_SENSE_DATA_BASE_LENGTH + 2);
+
+		scic_sds_stp_packet_internal_request_sense_build_sgl(this_request);
+	}
+}
+
+/**
+ * This method will fill in the SCU Task Context for a DATA fis containing CDB
+ *    in Raw Frame type. The TC for previous Packet fis was already there, we
+ *    only need to change the H2D fis content.
+ * @this_request: This parameter specifies the smp request object being
+ *    constructed.
+ * @task_context: The task_context to be reconstruct for packet request command
+ *    phase.
+ *
+ */
+void scu_stp_packet_request_command_phase_reconstruct_raw_frame_task_context(
+	struct scic_sds_request *this_request,
+	struct scu_task_context *task_context)
+{
+	void *atapi_cdb =
+		scic_cb_stp_packet_io_request_get_cdb_address(this_request->user_request);
+
+	u32 atapi_cdb_length =
+		scic_cb_stp_packet_io_request_get_cdb_length(this_request->user_request);
+
+	memset(this_request->command_buffer, 0, sizeof(struct sata_fis_reg_h2d));
+	memcpy(((u8 *)this_request->command_buffer + sizeof(u32)), atapi_cdb, atapi_cdb_length);
+
+	memset(&(task_context->type.stp), 0, sizeof(struct STP_TASK_CONTEXT));
+	task_context->type.stp.fis_type = SATA_FIS_TYPE_DATA;
+
+	/*
+	 * Note the data send out has to be 4 bytes aligned. Or else out hardware will
+	 * patch non-zero bytes and cause the target device unhappy. */
+	task_context->transfer_length_bytes = 12;
+}
+
+
+/*
+ * *@brief This methods decode the D2H status FIS and retrieve the sense data,
+ *          then pass the sense data to user request.
+ *
+ ***@param[in] this_request The request receive D2H status FIS.
+ ***@param[in] status_fis The D2H status fis to be processed.
+ *
+ */
+enum sci_status scic_sds_stp_packet_request_process_status_fis(
+	struct scic_sds_request *this_request,
+	struct sata_fis_reg_d2h *status_fis)
+{
+	enum sci_status status = SCI_SUCCESS;
+
+	/* TODO: Process the error status fis, retrieve sense data. */
+	if (status_fis->status & ATA_STATUS_REG_ERROR_BIT)
+		status = SCI_FAILURE_IO_RESPONSE_VALID;
+
+	return status;
+}
+
+/*
+ * *@brief This methods builds sgl for internal REQUEST SENSE stp packet
+ *          command using this request response buffer, only one sge is
+ *          needed.
+ *
+ ***@param[in] this_request The request receive request sense data.
+ *
+ */
+void scic_sds_stp_packet_internal_request_sense_build_sgl(
+	struct scic_sds_request *sds_request)
+{
+	void *sge;
+	struct scu_sgl_element_pair *scu_sgl_list   = NULL;
+	struct scu_task_context *task_context;
+	dma_addr_t dma_addr;
+
+	struct sci_ssp_response_iu *rsp_iu =
+		(struct sci_ssp_response_iu *)sds_request->response_buffer;
+
+	sge =  (void *)&rsp_iu->data[0];
+
+	task_context =
+		(struct scu_task_context *)sds_request->task_context_buffer;
+	scu_sgl_list = &task_context->sgl_pair_ab;
+
+	dma_addr = scic_io_request_get_dma_addr(sds_request, sge);
+
+	scu_sgl_list->A.address_upper = upper_32_bits(dma_addr);
+	scu_sgl_list->A.address_lower = lower_32_bits(dma_addr);
+	scu_sgl_list->A.length = task_context->transfer_length_bytes;
+	scu_sgl_list->A.address_modifier = 0;
+
+	SCU_SGL_ZERO(scu_sgl_list->B);
+}
+
+/**
+ * This method processes the completions transport layer (TL) status to
+ *    determine if the Packet FIS was sent successfully. If the Packet FIS was
+ *    sent successfully, then the state for the Packet request transits to
+ *    waiting for a PIO SETUP frame.
+ * @this_request: This parameter specifies the request for which the TC
+ *    completion was received.
+ * @completion_code: This parameter indicates the completion status information
+ *    for the TC.
+ *
+ * Indicate if the tc completion handler was successful. SCI_SUCCESS currently
+ * this method always returns success.
+ */
+enum sci_status scic_sds_stp_packet_request_packet_phase_await_tc_completion_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	enum sci_status status = SCI_SUCCESS;
+
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->started_substate_machine,
+			SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE
+			);
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return status;
+}
+
+
+/**
+ * This method processes an unsolicited frame while the Packet request is
+ *    waiting for a PIO SETUP FIS.  It will release the unsolicited frame, and
+ *    transition the request to the COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
+ *    state.
+ * @this_request: This parameter specifies the request for which the
+ *    unsolicited frame was received.
+ * @frame_index: This parameter indicates the unsolicited frame index that
+ *    should contain the response.
+ *
+ * This method returns an indication of whether the pio setup frame was handled
+ * successfully or not. SCI_SUCCESS Currently this value is always returned and
+ * indicates successful processing of the TC response.
+ */
+enum sci_status scic_sds_stp_packet_request_packet_phase_await_pio_setup_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+	struct scic_sds_stp_request *this_request;
+
+	this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		BUG_ON(frame_header->fis_type != SATA_FIS_TYPE_PIO_SETUP);
+
+		/*
+		 * Get from the frame buffer the PIO Setup Data, although we don't need
+		 * any info from this pio setup fis. */
+		scic_sds_unsolicited_frame_control_get_buffer(
+			&(this_request->parent.owning_controller->uf_control),
+			frame_index,
+			(void **)&frame_buffer
+			);
+
+		/*
+		 * Get the data from the PIO Setup
+		 * The SCU Hardware returns first word in the frame_header and the rest
+		 * of the data is in the frame buffer so we need to back up one dword */
+		this_request->type.packet.device_preferred_cdb_length =
+			(u16)((struct sata_fis_pio_setup *)(&frame_buffer[-1]))->transfter_count;
+
+		/* Frame has been decoded return it to the controller */
+		scic_sds_controller_release_frame(
+			this_request->parent.owning_controller, frame_index
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.started_substate_machine,
+			SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
+			);
+	} else
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC IO Request 0x%p could not get frame header "
+			"for frame index %d, status %x\n",
+			__func__, this_request, frame_index, status);
+
+	return status;
+}
+
+
+/**
+ * This method processes the completions transport layer (TL) status to
+ *    determine if the PACKET command data FIS was sent successfully. If
+ *    successfully, then the state for the packet request transits to COMPLETE
+ *    state. If not successfuly, the request transits to
+ *    COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE.
+ * @this_request: This parameter specifies the request for which the TC
+ *    completion was received.
+ * @completion_code: This parameter indicates the completion status information
+ *    for the TC.
+ *
+ * Indicate if the tc completion handler was successful. SCI_SUCCESS currently
+ * this method always returns success.
+ */
+enum sci_status scic_sds_stp_packet_request_command_phase_await_tc_completion_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	enum sci_status status = SCI_SUCCESS;
+	u8 sat_packet_protocol =
+		scic_cb_request_get_sat_protocol(this_request->user_request);
+
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case (SCU_TASK_DONE_GOOD << SCU_COMPLETION_TL_STATUS_SHIFT):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		if (sat_packet_protocol == SAT_PROTOCOL_PACKET_DMA_DATA_IN
+		     || sat_packet_protocol == SAT_PROTOCOL_PACKET_DMA_DATA_OUT
+		     )
+			sci_base_state_machine_change_state(
+				&this_request->parent.state_machine,
+				SCI_BASE_REQUEST_STATE_COMPLETED
+				);
+		else
+			sci_base_state_machine_change_state(
+				&this_request->started_substate_machine,
+				SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE
+				);
+		break;
+
+	case (SCU_TASK_DONE_UNEXP_FIS << SCU_COMPLETION_TL_STATUS_SHIFT):
+		if (scic_io_request_get_number_of_bytes_transferred(this_request) <
+		    scic_cb_io_request_get_transfer_length(this_request->user_request)) {
+			scic_sds_request_set_status(
+				this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS_IO_DONE_EARLY
+				);
+
+			sci_base_state_machine_change_state(
+				&this_request->parent.state_machine,
+				SCI_BASE_REQUEST_STATE_COMPLETED
+				);
+
+			status = this_request->sci_status;
+		}
+		break;
+
+	case (SCU_TASK_DONE_EXCESS_DATA << SCU_COMPLETION_TL_STATUS_SHIFT):
+		/* In this case, there is no UF coming after. compelte the IO now. */
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+
+		break;
+
+	default:
+		if (this_request->sci_status != SCI_SUCCESS) {  /* The io status was set already. This means an UF for the status
+								 * fis was received already.
+								 */
+
+			/*
+			 * A device suspension event is expected, we need to have the device
+			 * coming out of suspension, then complete the IO. */
+			sci_base_state_machine_change_state(
+				&this_request->started_substate_machine,
+				SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE
+				);
+
+			/* change the device state to ATAPI_ERROR. */
+			sci_base_state_machine_change_state(
+				&this_request->target_device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_ATAPI_ERROR
+				);
+
+			status = this_request->sci_status;
+		} else {  /* If receiving any non-sucess TC status, no UF received yet, then an UF for
+			   * the status fis is coming after.
+			   */
+			scic_sds_request_set_status(
+				this_request,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				SCI_FAILURE_IO_RESPONSE_VALID
+				);
+
+			sci_base_state_machine_change_state(
+				&this_request->started_substate_machine,
+				SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE
+				);
+		}
+		break;
+	}
+
+	return status;
+}
+
+
+/**
+ * This method processes an unsolicited frame.
+ * @this_request: This parameter specifies the request for which the
+ *    unsolicited frame was received.
+ * @frame_index: This parameter indicates the unsolicited frame index that
+ *    should contain the response.
+ *
+ * This method returns an indication of whether the UF frame was handled
+ * successfully or not. SCI_SUCCESS Currently this value is always returned and
+ * indicates successful processing of the TC response.
+ */
+enum sci_status scic_sds_stp_packet_request_command_phase_common_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+	struct scic_sds_stp_request *this_request;
+
+	this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		BUG_ON(frame_header->fis_type != SATA_FIS_TYPE_REGD2H);
+
+		/*
+		 * Get from the frame buffer the PIO Setup Data, although we don't need
+		 * any info from this pio setup fis. */
+		scic_sds_unsolicited_frame_control_get_buffer(
+			&(this_request->parent.owning_controller->uf_control),
+			frame_index,
+			(void **)&frame_buffer
+			);
+
+		scic_sds_controller_copy_sata_response(
+			&this_request->d2h_reg_fis, (u32 *)frame_header, frame_buffer
+			);
+
+		/* Frame has been decoded return it to the controller */
+		scic_sds_controller_release_frame(
+			this_request->parent.owning_controller, frame_index
+			);
+	}
+
+	return status;
+}
+
+/**
+ * This method processes an unsolicited frame while the packet request is
+ *    expecting TC completion. It will process the FIS and construct sense data.
+ * @this_request: This parameter specifies the request for which the
+ *    unsolicited frame was received.
+ * @frame_index: This parameter indicates the unsolicited frame index that
+ *    should contain the response.
+ *
+ * This method returns an indication of whether the UF frame was handled
+ * successfully or not. SCI_SUCCESS Currently this value is always returned and
+ * indicates successful processing of the TC response.
+ */
+enum sci_status scic_sds_stp_packet_request_command_phase_await_tc_completion_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
+
+	enum sci_status status =
+		scic_sds_stp_packet_request_command_phase_common_frame_handler(
+			request, frame_index);
+
+	if (status == SCI_SUCCESS) {
+		/* The command has completed with error status from target device. */
+		status = scic_sds_stp_packet_request_process_status_fis(
+			request, &this_request->d2h_reg_fis);
+
+		if (status != SCI_SUCCESS) {
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				status
+				);
+		} else
+			scic_sds_request_set_status(
+				&this_request->parent, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+				);
+	}
+
+	return status;
+}
+
+
+/**
+ * This method processes an unsolicited frame while the packet request is
+ *    expecting TC completion. It will process the FIS and construct sense data.
+ * @this_request: This parameter specifies the request for which the
+ *    unsolicited frame was received.
+ * @frame_index: This parameter indicates the unsolicited frame index that
+ *    should contain the response.
+ *
+ * This method returns an indication of whether the UF frame was handled
+ * successfully or not. SCI_SUCCESS Currently this value is always returned and
+ * indicates successful processing of the TC response.
+ */
+enum sci_status scic_sds_stp_packet_request_command_phase_await_d2h_fis_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status =
+		scic_sds_stp_packet_request_command_phase_common_frame_handler(
+			request, frame_index);
+
+	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
+
+	if (status == SCI_SUCCESS) {
+		/* The command has completed with error status from target device. */
+		status = scic_sds_stp_packet_request_process_status_fis(
+			request, &this_request->d2h_reg_fis);
+
+		if (status != SCI_SUCCESS) {
+			scic_sds_request_set_status(
+				request,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				status
+				);
+		} else
+			scic_sds_request_set_status(
+				request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+				);
+
+		/*
+		 * Always complete the NON_DATA command right away, no need to delay completion
+		 * even an error status fis came from target device. */
+		sci_base_state_machine_change_state(
+			&request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+	}
+
+	return status;
+}
+
+enum sci_status scic_sds_stp_packet_request_started_completion_delay_complete_handler(
+	struct sci_base_request *request)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
+
+	sci_base_state_machine_change_state(
+		&this_request->parent.state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED
+		);
+
+	return this_request->sci_status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_io_request_state_handler scic_sds_stp_packet_request_started_substate_handler_table[] = {
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler
+		.tc_completion_handler   = scic_sds_stp_packet_request_packet_phase_await_tc_completion_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_packet_request_packet_phase_await_pio_setup_frame_handler
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler
+		.tc_completion_handler   = scic_sds_stp_packet_request_command_phase_await_tc_completion_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_packet_request_command_phase_await_tc_completion_frame_handler
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_packet_request_command_phase_await_d2h_fis_frame_handler
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_stp_packet_request_started_completion_delay_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler
+	},
+};
+
+void scic_sds_stp_packet_request_started_packet_phase_await_tc_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_packet_request_started_substate_handler_table,
+		SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
+		);
+
+	scic_sds_remote_device_set_working_request(
+		this_request->target_device, this_request
+		);
+}
+
+void scic_sds_stp_packet_request_started_packet_phase_await_pio_setup_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_packet_request_started_substate_handler_table,
+		SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE
+		);
+}
+
+void scic_sds_stp_packet_request_started_command_phase_await_tc_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+	u8 sat_packet_protocol =
+		scic_cb_request_get_sat_protocol(this_request->user_request);
+
+	struct scu_task_context *task_context;
+	enum sci_status status;
+
+	/*
+	 * Recycle the TC and reconstruct it for sending out data fis containing
+	 * CDB. */
+	task_context = scic_sds_controller_get_task_context_buffer(
+		this_request->owning_controller, this_request->io_tag);
+
+	if (sat_packet_protocol == SAT_PROTOCOL_PACKET_NON_DATA)
+		scu_stp_packet_request_command_phase_reconstruct_raw_frame_task_context(
+			this_request, task_context);
+	else
+		scu_stp_packet_request_command_phase_construct_task_context(
+			this_request, task_context);
+
+	/* send the new TC out. */
+	status = this_request->owning_controller->state_handlers->parent.continue_io_handler(
+		&this_request->owning_controller->parent,
+		&this_request->target_device->parent,
+		&this_request->parent
+		);
+
+	if (status == SCI_SUCCESS)
+		SET_STATE_HANDLER(
+			this_request,
+			scic_sds_stp_packet_request_started_substate_handler_table,
+			SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE
+			);
+}
+
+void scic_sds_stp_packet_request_started_command_phase_await_d2h_fis_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_packet_request_started_substate_handler_table,
+		SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE
+		);
+}
+
+void scic_sds_stp_packet_request_started_completion_delay_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_packet_request_started_substate_handler_table,
+		SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE
+		);
+}
+
+
+/* --------------------------------------------------------------------------- */
+const struct sci_base_state scic_sds_stp_packet_request_started_substate_table[] = {
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_packet_request_started_packet_phase_await_tc_completion_enter,
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE] = {
+		.enter_state = scic_sds_stp_packet_request_started_packet_phase_await_pio_setup_enter,
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_packet_request_started_command_phase_await_tc_completion_enter,
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE] = {
+		.enter_state = scic_sds_stp_packet_request_started_command_phase_await_d2h_fis_enter,
+	},
+	[SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE] = {
+		.enter_state scic_sds_stp_packet_request_started_completion_delay_enter,
+	}
+};
+
+#endif /* !defined(DISABLE_ATAPI) */
diff --git a/drivers/scsi/isci/core/scic_sds_stp_packet_request.h b/drivers/scsi/isci/core/scic_sds_stp_packet_request.h
new file mode 100644
index 0000000..2a7aec9
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_packet_request.h
@@ -0,0 +1,153 @@
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
+#ifndef _SCIC_SDS_STP_PACKET_REQUEST_H_
+#define _SCIC_SDS_STP_PACKET_REQUEST_H_
+
+#include "intel_sas.h"
+#include "scic_sds_stp_request.h"
+
+/**
+ * This file contains the structures and constants for PACKET protocol requests.
+ *
+ *
+ */
+
+
+/**
+ *
+ *
+ * This is the enumeration of the SATA PIO DATA IN started substate machine.
+ */
+enum _SCIC_SDS_STP_PACKET_REQUEST_STARTED_SUBSTATES {
+	/**
+	 * While in this state the IO request object is waiting for the TC completion
+	 * notification for the H2D Register FIS
+	 */
+	SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_SUBSTATE,
+
+	/**
+	 * While in this state the IO request object is waiting for either a PIO Setup.
+	 */
+	SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_PIO_SETUP_SUBSTATE,
+
+	/**
+	 * While in this state the IO request object is waiting for TC completion for
+	 * the Packet DMA DATA fis or Raw Frame.
+	 */
+	SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_TC_COMPLETION_SUBSTATE,
+
+	/**
+	 * The non-data IO transit to this state in this state after receiving TC
+	 * completion. While in this state IO request object is waiting for D2H status
+	 * frame as UF.
+	 */
+	SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMMAND_PHASE_AWAIT_D2H_FIS_SUBSTATE,
+
+	/**
+	 * The IO transit to this state in this state if the previous TC completion status
+	 * is not success and the atapi device is suspended due to target device failed the IO.
+	 * While in this state IO request object is waiting for device coming out of the
+	 * suspension state then complete the IO.
+	 */
+	SCIC_SDS_STP_PACKET_REQUEST_STARTED_COMPLETION_DELAY_SUBSTATE,
+};
+
+
+
+#if !defined(DISABLE_ATAPI)
+extern const struct sci_base_state scic_sds_stp_packet_request_started_substate_table[];
+extern const struct scic_sds_io_request_state_handler scic_sds_stp_packet_request_started_substate_handler_table[];
+#endif /* !defined(DISABLE_ATAPI) */
+
+#if !defined(DISABLE_ATAPI)
+enum sci_status scic_sds_stp_packet_request_construct(
+	struct scic_sds_request *this_request);
+#else  /* !defined(DISABLE_ATAPI) */
+#define scic_sds_stp_packet_request_construct(request) SCI_FAILURE
+#endif /* !defined(DISABLE_ATAPI) */
+
+#if !defined(DISABLE_ATAPI)
+void scu_stp_packet_request_command_phase_construct_task_context(
+	struct scic_sds_request *this_request,
+	struct scu_task_context *task_context);
+#else  /* !defined(DISABLE_ATAPI) */
+#define scu_stp_packet_request_command_phase_construct_task_context(reqeust, tc)
+#endif /* !defined(DISABLE_ATAPI) */
+
+#if !defined(DISABLE_ATAPI)
+void scu_stp_packet_request_command_phase_reconstruct_raw_frame_task_context(
+	struct scic_sds_request *this_request,
+	struct scu_task_context *task_context);
+#else  /* !defined(DISABLE_ATAPI) */
+#define scu_stp_packet_request_command_phase_reconstruct_raw_frame_task_context(reqeust, tc)
+#endif /* !defined(DISABLE_ATAPI) */
+
+#if !defined(DISABLE_ATAPI)
+enum sci_status scic_sds_stp_packet_request_process_status_fis(
+	struct scic_sds_request *this_request,
+	struct sata_fis_reg_d2h *status_fis);
+#else  /* !defined(DISABLE_ATAPI) */
+#define scic_sds_stp_packet_request_process_status_fis(reqeust, fis) SCI_FAILURE
+#endif /* !defined(DISABLE_ATAPI) */
+
+#if !defined(DISABLE_ATAPI)
+void scic_sds_stp_packet_internal_request_sense_build_sgl(
+	struct scic_sds_request *this_request);
+#else  /* !defined(DISABLE_ATAPI) */
+#define scic_sds_stp_packet_internal_request_sense_build_sgl(request)
+#endif /* !defined(DISABLE_ATAPI) */
+
+#endif /* _SCIC_SDS_STP_PACKET_REQUEST_H_ */
+
diff --git a/drivers/scsi/isci/core/scic_sds_stp_pio_request.h b/drivers/scsi/isci/core/scic_sds_stp_pio_request.h
new file mode 100644
index 0000000..64bf40a
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_pio_request.h
@@ -0,0 +1,116 @@
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
+#ifndef _SCIC_SDS_SATA_PIO_REQUEST_H_
+#define _SCIC_SDS_SATA_PIO_REQUEST_H_
+
+#include "sci_base_state.h"
+#include "scic_sds_request.h"
+#include "scu_task_context.h"
+
+/**
+ * This file contains the structures and constants for SATA PIO requests.
+ *
+ *
+ */
+
+
+/**
+ *
+ *
+ * This is the enumeration of the SATA PIO DATA IN started substate machine.
+ */
+enum _SCIC_SDS_STP_REQUEST_STARTED_PIO_SUBSTATES {
+	/**
+	 * While in this state the IO request object is waiting for the TC completion
+	 * notification for the H2D Register FIS
+	 */
+	SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE,
+
+	/**
+	 * While in this state the IO request object is waiting for either a PIO Setup
+	 * FIS or a D2H register FIS.  The type of frame received is based on the
+	 * result of the prior frame and line conditions.
+	 */
+	SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE,
+
+	/**
+	 * While in this state the IO request object is waiting for a DATA frame from
+	 * the device.
+	 */
+	SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE,
+
+	/**
+	 * While in this state the IO request object is waiting to transmit the next data
+	 * frame to the device.
+	 */
+	SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE,
+};
+
+
+/* --------------------------------------------------------------------------- */
+
+extern const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_pio_substate_handler_table[];
+
+extern const struct sci_base_state scic_sds_stp_request_started_pio_substate_table[];
+
+/* --------------------------------------------------------------------------- */
+
+struct scic_sds_stp_request;
+
+struct scu_sgl_element *scic_sds_stp_request_pio_get_next_sgl(
+	struct scic_sds_stp_request *this_request);
+
+#endif   /* _SCIC_SDS_SATA_PIO_REQUEST_H_ */
diff --git a/drivers/scsi/isci/core/scic_sds_stp_request.c b/drivers/scsi/isci/core/scic_sds_stp_request.c
new file mode 100644
index 0000000..8da309f
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_request.c
@@ -0,0 +1,1941 @@
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
+
+#include "intel_ata.h"
+#include "intel_sata.h"
+#include "intel_sat.h"
+#include "sci_base_state.h"
+#include "sci_base_state_machine.h"
+#include "scic_io_request.h"
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_request.h"
+#include "scic_sds_stp_pio_request.h"
+#include "scic_sds_stp_request.h"
+#include "scic_sds_unsolicited_frame_control.h"
+#include "sci_environment.h"
+#include "sci_util.h"
+#include "scu_completion_codes.h"
+#include "scu_event_codes.h"
+#include "scu_task_context.h"
+
+/**
+ * scic_sds_stp_request_get_h2d_reg_buffer() -
+ *
+ * This macro returns the address of the stp h2d reg fis buffer in the io
+ * request memory
+ */
+#define scic_sds_stp_request_get_h2d_reg_buffer(memory)	\
+	((struct sata_fis_reg_h2d *)(\
+		 ((char *)(memory)) + sizeof(struct scic_sds_stp_request) \
+		 ))
+
+/**
+ * scic_sds_stp_request_get_response_buffer() -
+ *
+ * This macro returns the address of the ssp response iu buffer in the io
+ * request memory
+ */
+#define scic_sds_stp_request_get_response_buffer(memory) \
+	((struct sata_fis_reg_d2h *)(\
+		 ((char *)(scic_sds_stp_request_get_h2d_reg_buffer(memory))) \
+		 + sizeof(struct sata_fis_reg_h2d) \
+		 ))
+
+/**
+ * scic_sds_stp_request_get_task_context_buffer() -
+ *
+ * This macro returns the address of the task context buffer in the io request
+ * memory
+ */
+#define scic_sds_stp_request_get_task_context_buffer(memory) \
+	((struct scu_task_context *)(\
+		 ((char *)(scic_sds_stp_request_get_response_buffer(memory))) \
+		 + sizeof(struct sci_ssp_response_iu) \
+		 ))
+
+/**
+ * scic_sds_stp_request_get_sgl_element_buffer() -
+ *
+ * This macro returns the address of the sgl elment pairs in the io request
+ * memory buffer
+ */
+#define scic_sds_stp_request_get_sgl_element_buffer(memory) \
+	((struct scu_sgl_element_pair *)(\
+		 ((char *)(scic_sds_stp_request_get_task_context_buffer(memory))) \
+		 + sizeof(struct scu_task_context) \
+		 ))
+
+/**
+ *
+ *
+ * This method return the memory space required for STP PIO requests. u32
+ */
+u32 scic_sds_stp_request_get_object_size(void)
+{
+	return sizeof(struct scic_sds_stp_request)
+	       + sizeof(struct sata_fis_reg_h2d)
+	       + sizeof(struct sata_fis_reg_d2h)
+	       + sizeof(struct scu_task_context)
+	       + SMP_CACHE_BYTES
+	       + sizeof(struct scu_sgl_element_pair) * SCU_MAX_SGL_ELEMENT_PAIRS;
+}
+
+void scic_sds_stp_request_assign_buffers(struct scic_sds_request *sci_req)
+{
+	struct scic_sds_stp_request *stp_req = container_of(sci_req, typeof(*stp_req), parent);
+
+	sci_req->command_buffer = scic_sds_stp_request_get_h2d_reg_buffer(stp_req);
+	sci_req->response_buffer = scic_sds_stp_request_get_response_buffer(stp_req);
+	sci_req->sgl_element_pair_buffer = scic_sds_stp_request_get_sgl_element_buffer(stp_req);
+	sci_req->sgl_element_pair_buffer = PTR_ALIGN(sci_req->sgl_element_pair_buffer,
+						     sizeof(struct scu_sgl_element_pair));
+
+	if (sci_req->was_tag_assigned_by_user == false) {
+		sci_req->task_context_buffer =
+			scic_sds_stp_request_get_task_context_buffer(stp_req);
+		sci_req->task_context_buffer = PTR_ALIGN(sci_req->task_context_buffer,
+							 SMP_CACHE_BYTES);
+	}
+}
+
+/**
+ * This method is will fill in the SCU Task Context for any type of SATA
+ *    request.  This is called from the various SATA constructors.
+ * @this_request: The general IO request object which is to be used in
+ *    constructing the SCU task context.
+ * @task_context: The buffer pointer for the SCU task context which is being
+ *    constructed.
+ *
+ * The general io request construction is complete. The buffer assignment for
+ * the command buffer is complete. none Revisit task context construction to
+ * determine what is common for SSP/SMP/STP task context structures.
+ */
+static void scu_sata_reqeust_construct_task_context(
+	struct scic_sds_request *sds_request,
+	struct scu_task_context *task_context)
+{
+	dma_addr_t dma_addr;
+	struct scic_sds_controller *controller;
+	struct scic_sds_remote_device *target_device;
+	struct scic_sds_port *target_port;
+
+	controller = scic_sds_request_get_controller(sds_request);
+	target_device = scic_sds_request_get_device(sds_request);
+	target_port = scic_sds_request_get_port(sds_request);
+
+	/* Fill in the TC with the its required data */
+	task_context->abort = 0;
+	task_context->priority = SCU_TASK_PRIORITY_NORMAL;
+	task_context->initiator_request = 1;
+	task_context->connection_rate =
+		scic_remote_device_get_connection_rate(target_device);
+	task_context->protocol_engine_index =
+		scic_sds_controller_get_protocol_engine_group(controller);
+	task_context->logical_port_index =
+		scic_sds_port_get_index(target_port);
+	task_context->protocol_type = SCU_TASK_CONTEXT_PROTOCOL_STP;
+	task_context->valid = SCU_TASK_CONTEXT_VALID;
+	task_context->context_type = SCU_TASK_CONTEXT_TYPE;
+
+	task_context->remote_node_index =
+		scic_sds_remote_device_get_index(sds_request->target_device);
+	task_context->command_code = 0;
+
+	task_context->link_layer_control = 0;
+	task_context->do_not_dma_ssp_good_response = 1;
+	task_context->strict_ordering = 0;
+	task_context->control_frame = 0;
+	task_context->timeout_enable = 0;
+	task_context->block_guard_enable = 0;
+
+	task_context->address_modifier = 0;
+	task_context->task_phase = 0x01;
+
+	task_context->ssp_command_iu_length =
+		(sizeof(struct sata_fis_reg_h2d) - sizeof(u32)) / sizeof(u32);
+
+	/* Set the first word of the H2D REG FIS */
+	task_context->type.words[0] = *(u32 *)sds_request->command_buffer;
+
+	if (sds_request->was_tag_assigned_by_user) {
+		/*
+		 * Build the task context now since we have already read
+		 * the data
+		 */
+		sds_request->post_context =
+			(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_TC |
+			 (scic_sds_controller_get_protocol_engine_group(
+							controller) <<
+			  SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_SHIFT) |
+			 (scic_sds_port_get_index(target_port) <<
+			  SCU_CONTEXT_COMMAND_LOGICAL_PORT_SHIFT) |
+			 scic_sds_io_tag_get_index(sds_request->io_tag));
+	} else {
+		/*
+		 * Build the task context now since we have already read
+		 * the data.
+		 * I/O tag index is not assigned because we have to wait
+		 * until we get a TCi.
+		 */
+		sds_request->post_context =
+			(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_TC |
+			 (scic_sds_controller_get_protocol_engine_group(
+							controller) <<
+			  SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_SHIFT) |
+			 (scic_sds_port_get_index(target_port) <<
+			  SCU_CONTEXT_COMMAND_LOGICAL_PORT_SHIFT));
+	}
+
+	/*
+	 * Copy the physical address for the command buffer to the SCU Task
+	 * Context. We must offset the command buffer by 4 bytes because the
+	 * first 4 bytes are transfered in the body of the TC.
+	 */
+	dma_addr =
+		scic_io_request_get_dma_addr(sds_request,
+						(char *)sds_request->
+							command_buffer +
+							sizeof(u32));
+
+	task_context->command_iu_upper = upper_32_bits(dma_addr);
+	task_context->command_iu_lower = lower_32_bits(dma_addr);
+
+	/* SATA Requests do not have a response buffer */
+	task_context->response_iu_upper = 0;
+	task_context->response_iu_lower = 0;
+}
+
+/**
+ *
+ * @this_request:
+ *
+ * This method will perform any general sata request construction. What part of
+ * SATA IO request construction is general? none
+ */
+void scic_sds_stp_non_ncq_request_construct(
+	struct scic_sds_request *this_request)
+{
+	this_request->has_started_substate_machine = true;
+}
+
+/**
+ *
+ * @sci_req: This parameter specifies the request to be constructed as an
+ *    optimized request.
+ * @optimized_task_type: This parameter specifies whether the request is to be
+ *    an UDMA request or a NCQ request. - A value of 0 indicates UDMA. - A
+ *    value of 1 indicates NCQ.
+ *
+ * This method will perform request construction common to all types of STP
+ * requests that are optimized by the silicon (i.e. UDMA, NCQ). This method
+ * returns an indication as to whether the construction was successful.
+ */
+static void scic_sds_stp_optimized_request_construct(struct scic_sds_request *sci_req,
+						     u8 optimized_task_type,
+						     u32 len,
+						     enum dma_data_direction dir)
+{
+	struct scu_task_context *task_context = sci_req->task_context_buffer;
+
+	/* Build the STP task context structure */
+	scu_sata_reqeust_construct_task_context(sci_req, task_context);
+
+	/* Copy over the SGL elements */
+	scic_sds_request_build_sgl(sci_req);
+
+	/* Copy over the number of bytes to be transfered */
+	task_context->transfer_length_bytes = len;
+
+	if (dir == DMA_TO_DEVICE) {
+		/*
+		 * The difference between the DMA IN and DMA OUT request task type
+		 * values are consistent with the difference between FPDMA READ
+		 * and FPDMA WRITE values.  Add the supplied task type parameter
+		 * to this difference to set the task type properly for this
+		 * DATA OUT (WRITE) case. */
+		task_context->task_type = optimized_task_type + (SCU_TASK_TYPE_DMA_OUT
+								 - SCU_TASK_TYPE_DMA_IN);
+	} else {
+		/*
+		 * For the DATA IN (READ) case, simply save the supplied
+		 * optimized task type. */
+		task_context->task_type = optimized_task_type;
+	}
+}
+
+/**
+ *
+ * @sci_req: This parameter specifies the request to be constructed.
+ *
+ * This method will construct the STP UDMA request and its associated TC data.
+ * This method returns an indication as to whether the construction was
+ * successful. SCI_SUCCESS Currently this method always returns this value.
+ */
+enum sci_status scic_sds_stp_udma_request_construct(struct scic_sds_request *sci_req,
+						    u32 len,
+						    enum dma_data_direction dir)
+{
+	scic_sds_stp_non_ncq_request_construct(sci_req);
+
+	scic_sds_stp_optimized_request_construct(sci_req, SCU_TASK_TYPE_DMA_IN,
+						 len, dir);
+
+	sci_base_state_machine_construct(
+		&sci_req->started_substate_machine,
+		&sci_req->parent.parent,
+		scic_sds_stp_request_started_udma_substate_table,
+		SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @sci_req: This parameter specifies the request to be constructed.
+ *
+ * This method will construct the STP UDMA request and its associated TC data.
+ * This method returns an indication as to whether the construction was
+ * successful. SCI_SUCCESS Currently this method always returns this value.
+ */
+enum sci_status scic_sds_stp_ncq_request_construct(struct scic_sds_request *sci_req,
+						   u32 len,
+						   enum dma_data_direction dir)
+{
+	scic_sds_stp_optimized_request_construct(sci_req,
+						 SCU_TASK_TYPE_FPDMAQ_READ,
+						 len, dir);
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_request: This parameter specifies the STP request object for which to
+ *    construct a RAW command frame task context.
+ * @task_context: This parameter specifies the SCU specific task context buffer
+ *    to construct.
+ *
+ * This method performs the operations common to all SATA/STP requests
+ * utilizing the raw frame method. none
+ */
+void scu_stp_raw_request_construct_task_context(
+	struct scic_sds_stp_request *this_request,
+	struct scu_task_context *task_context)
+{
+	scu_sata_reqeust_construct_task_context(&this_request->parent, task_context);
+
+	task_context->control_frame         = 0;
+	task_context->priority              = SCU_TASK_PRIORITY_NORMAL;
+	task_context->task_type             = SCU_TASK_TYPE_SATA_RAW_FRAME;
+	task_context->type.stp.fis_type     = SATA_FIS_TYPE_REGH2D;
+	task_context->transfer_length_bytes = sizeof(struct sata_fis_reg_h2d) - sizeof(u32);
+}
+
+/**
+ *
+ * @this_request: This parameter specifies the core request object to
+ *    construction into an STP/SATA non-data request.
+ *
+ * This method will construct the STP Non-data request and its associated TC
+ * data.  A non-data request essentially behaves like a 0 length read request
+ * in the SCU. This method currently always returns SCI_SUCCESS
+ */
+enum sci_status scic_sds_stp_non_data_request_construct(
+	struct scic_sds_request *this_request)
+{
+	scic_sds_stp_non_ncq_request_construct(this_request);
+
+	/* Build the STP task context structure */
+	scu_stp_raw_request_construct_task_context(
+		(struct scic_sds_stp_request *)this_request,
+		this_request->task_context_buffer
+		);
+
+	sci_base_state_machine_construct(
+		&this_request->started_substate_machine,
+		&this_request->parent.parent,
+		scic_sds_stp_request_started_non_data_substate_table,
+		SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+
+enum sci_status scic_sds_stp_soft_reset_request_construct(
+	struct scic_sds_request *this_request)
+{
+	scic_sds_stp_non_ncq_request_construct(this_request);
+
+	/* Build the STP task context structure */
+	scu_stp_raw_request_construct_task_context(
+		(struct scic_sds_stp_request *)this_request,
+		this_request->task_context_buffer
+		);
+
+	sci_base_state_machine_construct(
+		&this_request->started_substate_machine,
+		&this_request->parent.parent,
+		scic_sds_stp_request_started_soft_reset_substate_table,
+		SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+
+void scic_stp_io_request_set_ncq_tag(
+	struct scic_sds_request *req,
+	u16 ncq_tag)
+{
+	/**
+	 * @note This could be made to return an error to the user if the user
+	 *       attempts to set the NCQ tag in the wrong state.
+	 */
+	req->task_context_buffer->type.stp.ncq_tag = ncq_tag;
+}
+
+
+void *scic_stp_io_request_get_h2d_reg_address(
+	struct scic_sds_request *req)
+{
+	return req->command_buffer;
+}
+
+
+void *scic_stp_io_request_get_d2h_reg_address(
+	struct scic_sds_request *req)
+{
+	return &((struct scic_sds_stp_request *)req)->d2h_reg_fis;
+}
+
+/**
+ *
+ * @this_request:
+ *
+ * Get the next SGL element from the request. - Check on which SGL element pair
+ * we are working - if working on SLG pair element A - advance to element B -
+ * else - check to see if there are more SGL element pairs for this IO request
+ * - if there are more SGL element pairs - advance to the next pair and return
+ * element A struct scu_sgl_element*
+ */
+struct scu_sgl_element *scic_sds_stp_request_pio_get_next_sgl(struct scic_sds_stp_request *stp_req)
+{
+	struct scu_sgl_element *current_sgl;
+	struct scic_sds_request *sci_req = &stp_req->parent;
+	struct scic_sds_request_pio_sgl *pio_sgl = &stp_req->type.pio.request_current;
+
+	if (pio_sgl->sgl_set == SCU_SGL_ELEMENT_PAIR_A) {
+		if (pio_sgl->sgl_pair->B.address_lower == 0 &&
+		    pio_sgl->sgl_pair->B.address_upper == 0) {
+			current_sgl = NULL;
+		} else {
+			pio_sgl->sgl_set = SCU_SGL_ELEMENT_PAIR_B;
+			current_sgl = &pio_sgl->sgl_pair->B;
+		}
+	} else {
+		if (pio_sgl->sgl_pair->next_pair_lower == 0 &&
+		    pio_sgl->sgl_pair->next_pair_upper == 0) {
+			current_sgl = NULL;
+		} else {
+			u64 phys_addr;
+
+			phys_addr = pio_sgl->sgl_pair->next_pair_upper;
+			phys_addr <<= 32;
+			phys_addr |= pio_sgl->sgl_pair->next_pair_lower;
+
+			pio_sgl->sgl_pair = scic_request_get_virt_addr(sci_req, phys_addr);
+			pio_sgl->sgl_set = SCU_SGL_ELEMENT_PAIR_A;
+			current_sgl = &pio_sgl->sgl_pair->A;
+		}
+	}
+
+	return current_sgl;
+}
+
+/**
+ *
+ * @scic_io_request: The core request object which is cast to a SATA PIO
+ *    request object.
+ *
+ * This method will construct the SATA PIO request. This method returns an
+ * indication as to whether the construction was successful. SCI_SUCCESS
+ * Currently this method always returns this value.
+ */
+enum sci_status scic_sds_stp_pio_request_construct(
+	struct scic_sds_request *scic_io_request,
+	u8 sat_protocol,
+	bool copy_rx_frame)
+{
+	struct scic_sds_stp_request *this_request;
+
+	this_request = (struct scic_sds_stp_request *)scic_io_request;
+
+	scic_sds_stp_non_ncq_request_construct(&this_request->parent);
+
+	scu_stp_raw_request_construct_task_context(
+		this_request, this_request->parent.task_context_buffer
+		);
+
+	this_request->type.pio.current_transfer_bytes = 0;
+	this_request->type.pio.ending_error = 0;
+	this_request->type.pio.ending_status = 0;
+
+	this_request->type.pio.request_current.sgl_offset = 0;
+	this_request->type.pio.request_current.sgl_set = SCU_SGL_ELEMENT_PAIR_A;
+	this_request->type.pio.sat_protocol = sat_protocol;
+
+	if (copy_rx_frame) {
+		scic_sds_request_build_sgl(&this_request->parent);
+		/*
+		 * Since the IO request copy of the TC contains the same data as
+		 * the actual TC this pointer is vaild for either. */
+		this_request->type.pio.request_current.sgl_pair =
+			&this_request->parent.task_context_buffer->sgl_pair_ab;
+	} else {
+		/* The user does not want the data copied to the SGL buffer location */
+		this_request->type.pio.request_current.sgl_pair = NULL;
+	}
+
+	sci_base_state_machine_construct(
+		&this_request->parent.started_substate_machine,
+		&this_request->parent.parent.parent,
+		scic_sds_stp_request_started_pio_substate_table,
+		SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_request:
+ * @completion_code:
+ *
+ * This method processes a TC completion.  The expected TC completion is for
+ * the transmission of the H2D register FIS containing the SATA/STP non-data
+ * request. This method always successfully processes the TC completion.
+ * SCI_SUCCESS This value is always returned.
+ */
+static enum sci_status scic_sds_stp_request_non_data_await_h2d_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->started_substate_machine,
+			SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE
+			);
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @request: This parameter specifies the request for which a frame has been
+ *    received.
+ * @frame_index: This parameter specifies the index of the frame that has been
+ *    received.
+ *
+ * This method processes frames received from the target while waiting for a
+ * device to host register FIS.  If a non-register FIS is received during this
+ * time, it is treated as a protocol violation from an IO perspective. Indicate
+ * if the received frame was processed successfully.
+ */
+static enum sci_status scic_sds_stp_request_non_data_await_d2h_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		switch (frame_header->fis_type) {
+		case SATA_FIS_TYPE_REGD2H:
+			scic_sds_unsolicited_frame_control_get_buffer(
+				&(this_request->parent.owning_controller->uf_control),
+				frame_index,
+				(void **)&frame_buffer
+				);
+
+			scic_sds_controller_copy_sata_response(
+				&this_request->d2h_reg_fis, (u32 *)frame_header, frame_buffer
+				);
+
+			/* The command has completed with error */
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				SCI_FAILURE_IO_RESPONSE_VALID
+				);
+			break;
+
+		default:
+			dev_warn(scic_to_dev(request->owning_controller),
+				 "%s: IO Request:0x%p Frame Id:%d protocol "
+				 "violation occurred\n",
+				 __func__, this_request, frame_index);
+
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_UNEXP_FIS,
+				SCI_FAILURE_PROTOCOL_VIOLATION
+				);
+			break;
+		}
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+
+		/* Frame has been decoded return it to the controller */
+		scic_sds_controller_release_frame(
+			this_request->parent.owning_controller, frame_index
+			);
+	} else
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC IO Request 0x%p could not get frame header "
+			"for frame index %d, status %x\n",
+			__func__, this_request, frame_index, status);
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_non_data_substate_handler_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_non_data_await_h2d_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_request_non_data_await_d2h_frame_handler,
+	}
+};
+
+static void scic_sds_stp_request_started_non_data_await_h2d_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_non_data_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE
+		);
+
+	scic_sds_remote_device_set_working_request(
+		this_request->target_device, this_request
+		);
+}
+
+static void scic_sds_stp_request_started_non_data_await_d2h_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_non_data_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_stp_request_started_non_data_substate_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_non_data_await_h2d_completion_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_non_data_await_d2h_enter,
+	},
+};
+
+#define SCU_MAX_FRAME_BUFFER_SIZE  0x400  /* 1K is the maximum SCU frame data payload */
+
+/**
+ *
+ * @this_request:
+ * @length:
+ *
+ * This function will transmit DATA_FIS from (current sgl + offset) for input
+ * parameter length. current sgl and offset is alreay stored in the IO request
+ * enum sci_status
+ */
+
+static enum sci_status scic_sds_stp_request_pio_data_out_trasmit_data_frame(
+	struct scic_sds_request *this_request,
+	u32 length)
+{
+	struct scic_sds_stp_request *this_sds_stp_request = (struct scic_sds_stp_request *)this_request;
+	sci_base_controller_request_handler_t continue_io;
+	struct scu_sgl_element *current_sgl;
+	struct scic_sds_controller *scic;
+	u32 state;
+
+	/*
+	 * Recycle the TC and reconstruct it for sending out DATA FIS containing
+	 * for the data from current_sgl+offset for the input length */
+	struct scu_task_context *task_context = scic_sds_controller_get_task_context_buffer(
+		this_request->owning_controller,
+		this_request->io_tag
+		);
+
+	if (this_sds_stp_request->type.pio.request_current.sgl_set == SCU_SGL_ELEMENT_PAIR_A)
+		current_sgl = &(this_sds_stp_request->type.pio.request_current.sgl_pair->A);
+	else
+		current_sgl = &(this_sds_stp_request->type.pio.request_current.sgl_pair->B);
+
+	/* update the TC */
+	task_context->command_iu_upper = current_sgl->address_upper;
+	task_context->command_iu_lower = current_sgl->address_lower;
+	task_context->transfer_length_bytes = length;
+	task_context->type.stp.fis_type = SATA_FIS_TYPE_DATA;
+
+	/* send the new TC out. */
+	scic = this_request->owning_controller;
+	state = scic->parent.state_machine.current_state_id;
+	continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
+	return continue_io(&scic->parent, &this_request->target_device->parent,
+			   &this_request->parent);
+}
+
+/**
+ *
+ * @this_request:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_data_out_transmit_data(
+	struct scic_sds_request *this_sds_request)
+{
+
+	struct scu_sgl_element *current_sgl;
+	u32 sgl_offset;
+	u32 remaining_bytes_in_current_sgl = 0;
+	enum sci_status status = SCI_SUCCESS;
+
+	struct scic_sds_stp_request *this_sds_stp_request = (struct scic_sds_stp_request *)this_sds_request;
+
+	sgl_offset = this_sds_stp_request->type.pio.request_current.sgl_offset;
+
+	if (this_sds_stp_request->type.pio.request_current.sgl_set == SCU_SGL_ELEMENT_PAIR_A) {
+		current_sgl = &(this_sds_stp_request->type.pio.request_current.sgl_pair->A);
+		remaining_bytes_in_current_sgl = this_sds_stp_request->type.pio.request_current.sgl_pair->A.length - sgl_offset;
+	} else {
+		current_sgl = &(this_sds_stp_request->type.pio.request_current.sgl_pair->B);
+		remaining_bytes_in_current_sgl = this_sds_stp_request->type.pio.request_current.sgl_pair->B.length - sgl_offset;
+	}
+
+
+	if (this_sds_stp_request->type.pio.pio_transfer_bytes > 0) {
+		if (this_sds_stp_request->type.pio.pio_transfer_bytes >= remaining_bytes_in_current_sgl) {
+			/* recycle the TC and send the H2D Data FIS from (current sgl + sgl_offset) and length = remaining_bytes_in_current_sgl */
+			status = scic_sds_stp_request_pio_data_out_trasmit_data_frame(this_sds_request, remaining_bytes_in_current_sgl);
+			if (status == SCI_SUCCESS) {
+				this_sds_stp_request->type.pio.pio_transfer_bytes -= remaining_bytes_in_current_sgl;
+
+				/* update the current sgl, sgl_offset and save for future */
+				current_sgl = scic_sds_stp_request_pio_get_next_sgl(this_sds_stp_request);
+				sgl_offset = 0;
+			}
+		} else if (this_sds_stp_request->type.pio.pio_transfer_bytes < remaining_bytes_in_current_sgl) {
+			/* recycle the TC and send the H2D Data FIS from (current sgl + sgl_offset) and length = type.pio.pio_transfer_bytes */
+			scic_sds_stp_request_pio_data_out_trasmit_data_frame(this_sds_request, this_sds_stp_request->type.pio.pio_transfer_bytes);
+
+			if (status == SCI_SUCCESS) {
+				/* Sgl offset will be adjusted and saved for future */
+				sgl_offset += this_sds_stp_request->type.pio.pio_transfer_bytes;
+				current_sgl->address_lower += this_sds_stp_request->type.pio.pio_transfer_bytes;
+				this_sds_stp_request->type.pio.pio_transfer_bytes = 0;
+			}
+		}
+	}
+
+	if (status == SCI_SUCCESS) {
+		this_sds_stp_request->type.pio.request_current.sgl_offset = sgl_offset;
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @stp_request: The request that is used for the SGL processing.
+ * @data_buffer: The buffer of data to be copied.
+ * @length: The length of the data transfer.
+ *
+ * Copy the data from the buffer for the length specified to the IO reqeust SGL
+ * specified data region. enum sci_status
+ */
+static enum sci_status
+scic_sds_stp_request_pio_data_in_copy_data_buffer(struct scic_sds_stp_request *stp_req,
+						  u8 *data_buf, u32 len)
+{
+	struct scic_sds_request *sci_req;
+	struct isci_request *ireq;
+	u8 *src_addr;
+	int copy_len;
+	struct sas_task *task;
+	struct scatterlist *sg;
+	void *kaddr;
+	int total_len = len;
+
+	sci_req = &stp_req->parent;
+	ireq = scic_sds_request_get_user_request(sci_req);
+	task = isci_request_access_task(ireq);
+	src_addr = data_buf;
+
+	if (task->num_scatter > 0) {
+		sg = task->scatter;
+
+		while (total_len > 0) {
+			struct page *page = sg_page(sg);
+
+			copy_len = min_t(int, total_len, sg_dma_len(sg));
+			kaddr = kmap_atomic(page, KM_IRQ0);
+			memcpy(kaddr + sg->offset, src_addr, copy_len);
+			kunmap_atomic(kaddr, KM_IRQ0);
+			total_len -= copy_len;
+			src_addr += copy_len;
+			sg = sg_next(sg);
+		}
+	} else {
+		BUG_ON(task->total_xfer_len < total_len);
+		memcpy(task->scatter, src_addr, total_len);
+	}
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_request: The PIO DATA IN request that is to receive the data.
+ * @data_buffer: The buffer to copy from.
+ *
+ * Copy the data buffer to the io request data region. enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_data_in_copy_data(
+	struct scic_sds_stp_request *this_request,
+	u8 *data_buffer)
+{
+	enum sci_status status;
+
+	/*
+	 * If there is less than 1K remaining in the transfer request
+	 * copy just the data for the transfer */
+	if (this_request->type.pio.pio_transfer_bytes < SCU_MAX_FRAME_BUFFER_SIZE) {
+		status = scic_sds_stp_request_pio_data_in_copy_data_buffer(
+			this_request, data_buffer, this_request->type.pio.pio_transfer_bytes);
+
+		if (status == SCI_SUCCESS)
+			this_request->type.pio.pio_transfer_bytes = 0;
+	} else {
+		/* We are transfering the whole frame so copy */
+		status = scic_sds_stp_request_pio_data_in_copy_data_buffer(
+			this_request, data_buffer, SCU_MAX_FRAME_BUFFER_SIZE);
+
+		if (status == SCI_SUCCESS)
+			this_request->type.pio.pio_transfer_bytes -= SCU_MAX_FRAME_BUFFER_SIZE;
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @this_request:
+ * @completion_code:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_await_h2d_completion_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	enum sci_status status = SCI_SUCCESS;
+
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->started_substate_machine,
+			SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+			);
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @this_request:
+ * @frame_index:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_await_frame_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+	struct scic_sds_stp_request *this_request;
+
+	this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		switch (frame_header->fis_type) {
+		case SATA_FIS_TYPE_PIO_SETUP:
+			/* Get from the frame buffer the PIO Setup Data */
+			scic_sds_unsolicited_frame_control_get_buffer(
+				&(this_request->parent.owning_controller->uf_control),
+				frame_index,
+				(void **)&frame_buffer
+				);
+
+			/*
+			 * Get the data from the PIO Setup
+			 * The SCU Hardware returns first word in the frame_header and the rest
+			 * of the data is in the frame buffer so we need to back up one dword */
+			this_request->type.pio.pio_transfer_bytes =
+				(u16)((struct sata_fis_pio_setup *)(&frame_buffer[-1]))->transfter_count;
+			this_request->type.pio.ending_status =
+				(u8)((struct sata_fis_pio_setup *)(&frame_buffer[-1]))->ending_status;
+
+			scic_sds_controller_copy_sata_response(
+				&this_request->d2h_reg_fis, (u32 *)frame_header, frame_buffer
+				);
+
+			this_request->d2h_reg_fis.status =
+				this_request->type.pio.ending_status;
+
+			/* The next state is dependent on whether the request was PIO Data-in or Data out */
+			if (this_request->type.pio.sat_protocol == SAT_PROTOCOL_PIO_DATA_IN) {
+				sci_base_state_machine_change_state(
+					&this_request->parent.started_substate_machine,
+					SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE
+					);
+			} else if (this_request->type.pio.sat_protocol == SAT_PROTOCOL_PIO_DATA_OUT) {
+				/* Transmit data */
+				status = scic_sds_stp_request_pio_data_out_transmit_data(request);
+				if (status == SCI_SUCCESS) {
+					sci_base_state_machine_change_state(
+						&this_request->parent.started_substate_machine,
+						SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE
+						);
+				}
+			}
+			break;
+
+		case SATA_FIS_TYPE_SETDEVBITS:
+			sci_base_state_machine_change_state(
+				&this_request->parent.started_substate_machine,
+				SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+				);
+			break;
+
+		case SATA_FIS_TYPE_REGD2H:
+			if ((frame_header->status & ATA_STATUS_REG_BSY_BIT) == 0) {
+				scic_sds_unsolicited_frame_control_get_buffer(
+					&(this_request->parent.owning_controller->uf_control),
+					frame_index,
+					(void **)&frame_buffer
+					);
+
+				scic_sds_controller_copy_sata_response(
+					&this_request->d2h_reg_fis, (u32 *)frame_header, frame_buffer);
+
+				scic_sds_request_set_status(
+					&this_request->parent,
+					SCU_TASK_DONE_CHECK_RESPONSE,
+					SCI_FAILURE_IO_RESPONSE_VALID
+					);
+
+				sci_base_state_machine_change_state(
+					&this_request->parent.parent.state_machine,
+					SCI_BASE_REQUEST_STATE_COMPLETED
+					);
+			} else {
+				/*
+				 * Now why is the drive sending a D2H Register FIS when it is still busy?
+				 * Do nothing since we are still in the right state. */
+				dev_dbg(scic_to_dev(request->owning_controller),
+					"%s: SCIC PIO Request 0x%p received "
+					"D2H Register FIS with BSY status "
+					"0x%x\n",
+					__func__,
+					this_request,
+					frame_header->status);
+			}
+			break;
+
+		default:
+			break;
+		}
+
+		/* Frame is decoded return it to the controller */
+		scic_sds_controller_release_frame(
+			this_request->parent.owning_controller,
+			frame_index
+			);
+	} else
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC IO Request 0x%p could not get frame header "
+			"for frame index %d, status %x\n",
+			__func__, this_request, frame_index, status);
+
+	return status;
+}
+
+/**
+ *
+ * @this_request:
+ * @frame_index:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_data_in_await_data_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	struct sata_fis_data *frame_buffer;
+	struct scic_sds_stp_request *this_request;
+
+	this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		if (frame_header->fis_type == SATA_FIS_TYPE_DATA) {
+			if (this_request->type.pio.request_current.sgl_pair == NULL) {
+				this_request->parent.saved_rx_frame_index = frame_index;
+				this_request->type.pio.pio_transfer_bytes = 0;
+			} else {
+				status = scic_sds_unsolicited_frame_control_get_buffer(
+					&(this_request->parent.owning_controller->uf_control),
+					frame_index,
+					(void **)&frame_buffer
+					);
+
+				status = scic_sds_stp_request_pio_data_in_copy_data(this_request, (u8 *)frame_buffer);
+
+				/* Frame is decoded return it to the controller */
+				scic_sds_controller_release_frame(
+					this_request->parent.owning_controller,
+					frame_index
+					);
+			}
+
+			/*
+			 * Check for the end of the transfer, are there more bytes remaining
+			 * for this data transfer */
+			if (
+				(status == SCI_SUCCESS)
+				&& (this_request->type.pio.pio_transfer_bytes == 0)
+				) {
+				if ((this_request->type.pio.ending_status & ATA_STATUS_REG_BSY_BIT) == 0) {
+					scic_sds_request_set_status(
+						&this_request->parent,
+						SCU_TASK_DONE_CHECK_RESPONSE,
+						SCI_FAILURE_IO_RESPONSE_VALID
+						);
+
+					sci_base_state_machine_change_state(
+						&this_request->parent.parent.state_machine,
+						SCI_BASE_REQUEST_STATE_COMPLETED
+						);
+				} else {
+					sci_base_state_machine_change_state(
+						&this_request->parent.started_substate_machine,
+						SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+						);
+				}
+			}
+		} else {
+			dev_err(scic_to_dev(request->owning_controller),
+				"%s: SCIC PIO Request 0x%p received frame %d "
+				"with fis type 0x%02x when expecting a data "
+				"fis.\n",
+				__func__,
+				this_request,
+				frame_index,
+				frame_header->fis_type);
+
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_GOOD,
+				SCI_FAILURE_IO_REQUIRES_SCSI_ABORT
+				);
+
+			sci_base_state_machine_change_state(
+				&this_request->parent.parent.state_machine,
+				SCI_BASE_REQUEST_STATE_COMPLETED
+				);
+
+			/* Frame is decoded return it to the controller */
+			scic_sds_controller_release_frame(
+				this_request->parent.owning_controller,
+				frame_index
+				);
+		}
+	} else
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC IO Request 0x%p could not get frame header "
+			"for frame index %d, status %x\n",
+			__func__, this_request, frame_index, status);
+
+	return status;
+}
+
+
+/**
+ *
+ * @this_request:
+ * @completion_code:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_pio_data_out_await_data_transmit_completion_tc_completion_handler(
+
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	enum sci_status status                     = SCI_SUCCESS;
+	bool all_frames_transferred     = false;
+
+	struct scic_sds_stp_request *this_scic_sds_stp_request = (struct scic_sds_stp_request *)this_request;
+
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		/* Transmit data */
+		if (this_scic_sds_stp_request->type.pio.pio_transfer_bytes != 0) {
+			status = scic_sds_stp_request_pio_data_out_transmit_data(this_request);
+			if (status == SCI_SUCCESS) {
+				if (this_scic_sds_stp_request->type.pio.pio_transfer_bytes == 0)
+					all_frames_transferred = true;
+			}
+		} else if (this_scic_sds_stp_request->type.pio.pio_transfer_bytes == 0) {
+			/*
+			 * this will happen if the all data is written at the
+			 * first time after the pio setup fis is received
+			 */
+			all_frames_transferred  = true;
+		}
+
+		/* all data transferred. */
+		if (all_frames_transferred) {
+			/*
+			 * Change the state to SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_FRAME_SUBSTATE
+			 * and wait for PIO_SETUP fis / or D2H REg fis. */
+			sci_base_state_machine_change_state(
+				&this_request->started_substate_machine,
+				SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+				);
+		}
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @request: This is the request which is receiving the event.
+ * @event_code: This is the event code that the request on which the request is
+ *    expected to take action.
+ *
+ * This method will handle any link layer events while waiting for the data
+ * frame. enum sci_status SCI_SUCCESS SCI_FAILURE
+ */
+static enum sci_status scic_sds_stp_request_pio_data_in_await_data_event_handler(
+	struct scic_sds_request *request,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	switch (scu_get_event_specifier(event_code)) {
+	case SCU_TASK_DONE_CRC_ERR << SCU_EVENT_SPECIFIC_CODE_SHIFT:
+		/*
+		 * We are waiting for data and the SCU has R_ERR the data frame.
+		 * Go back to waiting for the D2H Register FIS */
+		sci_base_state_machine_change_state(
+			&request->started_substate_machine,
+			SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+			);
+
+		status = SCI_SUCCESS;
+		break;
+
+	default:
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC PIO Request 0x%p received unexpected "
+			"event 0x%08x\n",
+			__func__, request, event_code);
+
+		/* / @todo Should we fail the PIO request when we get an unexpected event? */
+		status = SCI_FAILURE;
+		break;
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_pio_substate_handler_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_pio_await_h2d_completion_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_request_pio_await_frame_frame_handler
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_stp_request_pio_data_in_await_data_event_handler,
+		.frame_handler           = scic_sds_stp_request_pio_data_in_await_data_frame_handler
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_pio_data_out_await_data_transmit_completion_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler,
+	}
+};
+
+static void scic_sds_stp_request_started_pio_await_h2d_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_pio_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE
+		);
+
+	scic_sds_remote_device_set_working_request(
+		this_request->target_device, this_request);
+}
+
+static void scic_sds_stp_request_started_pio_await_frame_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_pio_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE
+		);
+}
+
+static void scic_sds_stp_request_started_pio_data_in_await_data_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_pio_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE
+		);
+}
+
+static void scic_sds_stp_request_started_pio_data_out_transmit_data_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_pio_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_stp_request_started_pio_substate_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_H2D_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_pio_await_h2d_completion_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_AWAIT_FRAME_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_pio_await_frame_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_IN_AWAIT_DATA_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_pio_data_in_await_data_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_PIO_DATA_OUT_TRANSMIT_DATA_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_pio_data_out_transmit_data_enter,
+	}
+};
+
+static void scic_sds_stp_request_udma_complete_request(
+	struct scic_sds_request *this_request,
+	u32 scu_status,
+	enum sci_status sci_status)
+{
+	scic_sds_request_set_status(
+		this_request, scu_status, sci_status
+		);
+
+	sci_base_state_machine_change_state(
+		&this_request->parent.state_machine,
+		SCI_BASE_REQUEST_STATE_COMPLETED
+		);
+}
+
+/**
+ *
+ * @this_request:
+ * @frame_index:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_udma_general_frame_handler(
+	struct scic_sds_request *this_request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&this_request->owning_controller->uf_control,
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (
+		(status == SCI_SUCCESS)
+		&& (frame_header->fis_type == SATA_FIS_TYPE_REGD2H)
+		) {
+		scic_sds_unsolicited_frame_control_get_buffer(
+			&this_request->owning_controller->uf_control,
+			frame_index,
+			(void **)&frame_buffer
+			);
+
+		scic_sds_controller_copy_sata_response(
+			&((struct scic_sds_stp_request *)this_request)->d2h_reg_fis,
+			(u32 *)frame_header,
+			frame_buffer
+			);
+	}
+
+	scic_sds_controller_release_frame(
+		this_request->owning_controller, frame_index);
+
+	return status;
+}
+
+/**
+ * This method process TC completions while in the state where we are waiting
+ *    for TC completions.
+ * @this_request:
+ * @completion_code:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_request_udma_await_tc_completion_tc_completion_handler(
+	struct scic_sds_request *request,
+	u32 completion_code)
+{
+	enum sci_status status = SCI_SUCCESS;
+	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
+
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_stp_request_udma_complete_request(
+			&this_request->parent, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+		break;
+
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_UNEXP_FIS):
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_REG_ERR):
+		/*
+		 * We must check ther response buffer to see if the D2H Register FIS was
+		 * received before we got the TC completion. */
+		if (this_request->d2h_reg_fis.fis_type == SATA_FIS_TYPE_REGD2H) {
+			scic_sds_remote_device_suspend(
+				this_request->parent.target_device,
+				SCU_EVENT_SPECIFIC(SCU_NORMALIZE_COMPLETION_STATUS(completion_code))
+				);
+
+			scic_sds_stp_request_udma_complete_request(
+				&this_request->parent,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				SCI_FAILURE_IO_RESPONSE_VALID
+				);
+		} else {
+			/*
+			 * If we have an error completion status for the TC then we can expect a
+			 * D2H register FIS from the device so we must change state to wait for it */
+			sci_base_state_machine_change_state(
+				&this_request->parent.started_substate_machine,
+				SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE
+				);
+		}
+		break;
+
+	/*
+	 * / @todo Check to see if any of these completion status need to wait for
+	 * /       the device to host register fis. */
+	/* / @todo We can retry the command for SCU_TASK_DONE_CMD_LL_R_ERR - this comes only for B0 */
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_INV_FIS_LEN):
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_MAX_PLD_ERR):
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_LL_R_ERR):
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_CMD_LL_R_ERR):
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_CRC_ERR):
+		scic_sds_remote_device_suspend(
+			this_request->parent.target_device,
+			SCU_EVENT_SPECIFIC(SCU_NORMALIZE_COMPLETION_STATUS(completion_code))
+			);
+	/* Fall through to the default case */
+	default:
+		/* All other completion status cause the IO to be complete. */
+		scic_sds_stp_request_udma_complete_request(
+			&this_request->parent,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+		break;
+	}
+
+	return status;
+}
+
+static enum sci_status scic_sds_stp_request_udma_await_d2h_reg_fis_frame_handler(
+	struct scic_sds_request *this_request,
+	u32 frame_index)
+{
+	enum sci_status status;
+
+	/* Use the general frame handler to copy the resposne data */
+	status = scic_sds_stp_request_udma_general_frame_handler(this_request, frame_index);
+
+	if (status == SCI_SUCCESS) {
+		scic_sds_stp_request_udma_complete_request(
+			this_request,
+			SCU_TASK_DONE_CHECK_RESPONSE,
+			SCI_FAILURE_IO_RESPONSE_VALID
+			);
+	}
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_udma_substate_handler_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_udma_await_tc_completion_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_request_udma_general_frame_handler,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_request_udma_await_d2h_reg_fis_frame_handler,
+	},
+};
+
+static void scic_sds_stp_request_started_udma_await_tc_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_udma_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE
+		);
+}
+
+/**
+ *
+ *
+ * This state is entered when there is an TC completion failure.  The hardware
+ * received an unexpected condition while processing the IO request and now
+ * will UF the D2H register FIS to complete the IO.
+ */
+static void scic_sds_stp_request_started_udma_await_d2h_reg_fis_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_udma_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_stp_request_started_udma_substate_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_udma_await_tc_completion_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_udma_await_d2h_reg_fis_enter,
+	},
+};
+
+/**
+ *
+ * @this_request:
+ * @completion_code:
+ *
+ * This method processes a TC completion.  The expected TC completion is for
+ * the transmission of the H2D register FIS containing the SATA/STP non-data
+ * request. This method always successfully processes the TC completion.
+ * SCI_SUCCESS This value is always returned.
+ */
+static enum sci_status scic_sds_stp_request_soft_reset_await_h2d_asserted_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->started_substate_machine,
+			SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE
+			);
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_request:
+ * @completion_code:
+ *
+ * This method processes a TC completion.  The expected TC completion is for
+ * the transmission of the H2D register FIS containing the SATA/STP non-data
+ * request. This method always successfully processes the TC completion.
+ * SCI_SUCCESS This value is always returned.
+ */
+static enum sci_status scic_sds_stp_request_soft_reset_await_h2d_diagnostic_tc_completion_handler(
+	struct scic_sds_request *this_request,
+	u32 completion_code)
+{
+	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
+	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
+		scic_sds_request_set_status(
+			this_request, SCU_TASK_DONE_GOOD, SCI_SUCCESS
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->started_substate_machine,
+			SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE
+			);
+		break;
+
+	default:
+		/*
+		 * All other completion status cause the IO to be complete.  If a NAK
+		 * was received, then it is up to the user to retry the request. */
+		scic_sds_request_set_status(
+			this_request,
+			SCU_NORMALIZE_COMPLETION_STATUS(completion_code),
+			SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR
+			);
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.state_machine, SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+		break;
+	}
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @request: This parameter specifies the request for which a frame has been
+ *    received.
+ * @frame_index: This parameter specifies the index of the frame that has been
+ *    received.
+ *
+ * This method processes frames received from the target while waiting for a
+ * device to host register FIS.  If a non-register FIS is received during this
+ * time, it is treated as a protocol violation from an IO perspective. Indicate
+ * if the received frame was processed successfully.
+ */
+static enum sci_status scic_sds_stp_request_soft_reset_await_d2h_frame_handler(
+	struct scic_sds_request *request,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+	u32 *frame_buffer;
+	struct scic_sds_stp_request *this_request = (struct scic_sds_stp_request *)request;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(this_request->parent.owning_controller->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		switch (frame_header->fis_type) {
+		case SATA_FIS_TYPE_REGD2H:
+			scic_sds_unsolicited_frame_control_get_buffer(
+				&(this_request->parent.owning_controller->uf_control),
+				frame_index,
+				(void **)&frame_buffer
+				);
+
+			scic_sds_controller_copy_sata_response(
+				&this_request->d2h_reg_fis, (u32 *)frame_header, frame_buffer
+				);
+
+			/* The command has completed with error */
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_CHECK_RESPONSE,
+				SCI_FAILURE_IO_RESPONSE_VALID
+				);
+			break;
+
+		default:
+			dev_warn(scic_to_dev(request->owning_controller),
+				 "%s: IO Request:0x%p Frame Id:%d protocol "
+				 "violation occurred\n",
+				 __func__,
+				 this_request,
+				 frame_index);
+
+			scic_sds_request_set_status(
+				&this_request->parent,
+				SCU_TASK_DONE_UNEXP_FIS,
+				SCI_FAILURE_PROTOCOL_VIOLATION
+				);
+			break;
+		}
+
+		sci_base_state_machine_change_state(
+			&this_request->parent.parent.state_machine,
+			SCI_BASE_REQUEST_STATE_COMPLETED
+			);
+
+		/* Frame has been decoded return it to the controller */
+		scic_sds_controller_release_frame(
+			this_request->parent.owning_controller, frame_index
+			);
+	} else
+		dev_err(scic_to_dev(request->owning_controller),
+			"%s: SCIC IO Request 0x%p could not get frame header "
+			"for frame index %d, status %x\n",
+			__func__, this_request, frame_index, status);
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_soft_reset_substate_handler_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_soft_reset_await_h2d_asserted_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_stp_request_soft_reset_await_h2d_diagnostic_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_request_default_frame_handler,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE] = {
+		.parent.start_handler    = scic_sds_request_default_start_handler,
+		.parent.abort_handler    = scic_sds_request_started_state_abort_handler,
+		.parent.complete_handler = scic_sds_request_default_complete_handler,
+		.parent.destruct_handler = scic_sds_request_default_destruct_handler,
+		.tc_completion_handler   = scic_sds_request_default_tc_completion_handler,
+		.event_handler           = scic_sds_request_default_event_handler,
+		.frame_handler           = scic_sds_stp_request_soft_reset_await_d2h_frame_handler,
+	},
+};
+
+static void scic_sds_stp_request_started_soft_reset_await_h2d_asserted_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_soft_reset_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE
+		);
+
+	scic_sds_remote_device_set_working_request(
+		this_request->target_device, this_request
+		);
+}
+
+static void scic_sds_stp_request_started_soft_reset_await_h2d_diagnostic_completion_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+	sci_base_controller_request_handler_t continue_io;
+	struct scu_task_context *task_context;
+	struct sata_fis_reg_h2d *h2d_fis;
+	struct scic_sds_controller *scic;
+	enum sci_status status;
+	u32 state;
+
+	/* Clear the SRST bit */
+	h2d_fis = scic_stp_io_request_get_h2d_reg_address(this_request);
+	h2d_fis->control = 0;
+
+	/* Clear the TC control bit */
+	task_context = scic_sds_controller_get_task_context_buffer(
+		this_request->owning_controller, this_request->io_tag);
+	task_context->control_frame = 0;
+
+	scic = this_request->owning_controller;
+	state = scic->parent.state_machine.current_state_id;
+	continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
+
+	status = continue_io(&scic->parent, &this_request->target_device->parent,
+			     &this_request->parent);
+
+	if (status == SCI_SUCCESS) {
+		SET_STATE_HANDLER(
+			this_request,
+			scic_sds_stp_request_started_soft_reset_substate_handler_table,
+			SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE
+			);
+	}
+}
+
+static void scic_sds_stp_request_started_soft_reset_await_d2h_response_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_request *this_request = (struct scic_sds_request *)object;
+
+	SET_STATE_HANDLER(
+		this_request,
+		scic_sds_stp_request_started_soft_reset_substate_handler_table,
+		SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_stp_request_started_soft_reset_substate_table[] = {
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_soft_reset_await_h2d_asserted_completion_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_soft_reset_await_h2d_diagnostic_completion_enter,
+	},
+	[SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE] = {
+		.enter_state = scic_sds_stp_request_started_soft_reset_await_d2h_response_enter,
+	},
+};
+
diff --git a/drivers/scsi/isci/core/scic_sds_stp_request.h b/drivers/scsi/isci/core/scic_sds_stp_request.h
new file mode 100644
index 0000000..c950bb3
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_request.h
@@ -0,0 +1,221 @@
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
+#ifndef _SCIC_SDS_STP_REQUEST_T_
+#define _SCIC_SDS_STP_REQUEST_T_
+
+#include <linux/dma-mapping.h>
+#include "intel_sata.h"
+#include "scic_sds_request.h"
+
+/**
+ * This structure represents the additional information that is required to
+ *    handle SATA PIO requests.
+ *
+ *
+ */
+struct scic_sds_stp_request {
+	struct scic_sds_request parent;
+
+	struct sata_fis_reg_d2h d2h_reg_fis;
+
+	union {
+		u32 ncq;
+
+		u32 udma;
+
+		struct {
+			/**
+			 * Total transfer for the entire PIO request recorded at request constuction
+			 * time.
+			 *
+			 * @todo Should we just decrement this value for each byte of data transitted
+			 *       or received to elemenate the current_transfer_bytes field?
+			 */
+			u32 total_transfer_bytes;
+
+			/**
+			 * Total number of bytes received/transmitted in data frames since the start
+			 * of the IO request.  At the end of the IO request this should equal the
+			 * total_transfer_bytes.
+			 */
+			u32 current_transfer_bytes;
+
+			/**
+			 * The number of bytes requested in the in the PIO setup.
+			 */
+			u32 pio_transfer_bytes;
+
+			/**
+			 * PIO Setup ending status value to tell us if we need to wait for another FIS
+			 * or if the transfer is complete. On the receipt of a D2H FIS this will be
+			 * the status field of that FIS.
+			 */
+			u8 ending_status;
+
+			/**
+			 * On receipt of a D2H FIS this will be the ending error field if the
+			 * ending_status has the SATA_STATUS_ERR bit set.
+			 */
+			u8 ending_error;
+
+			/**
+			 * Protocol Type. This is filled in by core during IO Request construction type.
+			 */
+			u8 sat_protocol;
+
+			struct scic_sds_request_pio_sgl {
+				struct scu_sgl_element_pair *sgl_pair;
+				u8 sgl_set;
+				u32 sgl_offset;
+			} request_current;
+		} pio;
+
+		struct {
+			/**
+			 * The number of bytes requested in the PIO setup before CDB data frame.
+			 */
+			u32 device_preferred_cdb_length;
+		} packet;
+	} type;
+
+};
+
+/**
+ * enum SCIC_SDS_STP_REQUEST_STARTED_UDMA_SUBSTATES - This enumeration depicts
+ *    the various sub-states associated with a SATA/STP UDMA protocol operation.
+ *
+ *
+ */
+enum SCIC_SDS_STP_REQUEST_STARTED_UDMA_SUBSTATES {
+	SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_TC_COMPLETION_SUBSTATE,
+	SCIC_SDS_STP_REQUEST_STARTED_UDMA_AWAIT_D2H_REG_FIS_SUBSTATE,
+};
+
+/**
+ * enum SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_SUBSTATES - This enumeration
+ *    depicts the various sub-states associated with a SATA/STP non-data
+ *    protocol operation.
+ *
+ *
+ */
+enum SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_SUBSTATES {
+	SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_H2D_COMPLETION_SUBSTATE,
+	SCIC_SDS_STP_REQUEST_STARTED_NON_DATA_AWAIT_D2H_SUBSTATE,
+};
+
+/**
+ * enum SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_SUBSTATES - THis enumeration
+ *    depicts the various sub-states associated with a SATA/STP soft reset
+ *    operation.
+ *
+ *
+ */
+enum SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_SUBSTATES {
+	SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_ASSERTED_COMPLETION_SUBSTATE,
+	SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_H2D_DIAGNOSTIC_COMPLETION_SUBSTATE,
+	SCIC_SDS_STP_REQUEST_STARTED_SOFT_RESET_AWAIT_D2H_RESPONSE_FRAME_SUBSTATE,
+};
+
+extern const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_udma_substate_handler_table[];
+
+extern const struct sci_base_state scic_sds_stp_request_started_udma_substate_table[];
+
+extern const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_non_data_substate_handler_table[];
+
+extern const struct sci_base_state scic_sds_stp_request_started_non_data_substate_table[];
+
+extern const struct scic_sds_io_request_state_handler scic_sds_stp_request_started_soft_reset_substate_handler_table[];
+
+extern const struct sci_base_state scic_sds_stp_request_started_soft_reset_substate_table[];
+
+/* --------------------------------------------------------------------------- */
+
+u32 scic_sds_stp_request_get_object_size(void);
+
+
+void scic_sds_stp_non_ncq_request_construct(
+	struct scic_sds_request *this_request);
+
+enum sci_status scic_sds_stp_pio_request_construct(
+	struct scic_sds_request *scic_io_request,
+	u8 sat_protocol,
+	bool copy_rx_frame);
+
+enum sci_status scic_sds_stp_pio_request_construct_pass_through(
+	struct scic_sds_request *scic_io_request,
+	struct scic_stp_passthru_request_callbacks *passthru_cb);
+
+enum sci_status scic_sds_stp_udma_request_construct(
+	struct scic_sds_request *this_request,
+	u32 transfer_length,
+	enum dma_data_direction dir);
+
+enum sci_status scic_sds_stp_non_data_request_construct(
+	struct scic_sds_request *this_request);
+
+enum sci_status scic_sds_stp_soft_reset_request_construct(
+	struct scic_sds_request *this_request);
+
+enum sci_status scic_sds_stp_ncq_request_construct(
+	struct scic_sds_request *this_request,
+	u32 transfer_length,
+	enum dma_data_direction dir);
+
+void scu_stp_raw_request_construct_task_context(
+	struct scic_sds_stp_request *this_request,
+	struct scu_task_context *task_context);
+
+#endif /* _SCIC_SDS_STP_REQUEST_T_ */

