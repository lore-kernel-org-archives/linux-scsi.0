From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 1/6] isci: initialization
Date: Sun, 06 Feb 2011 16:34:40 -0800
Message-ID: <20110207003440.27040.22825.stgit@localhost6.localdomain6>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab1BGAQs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2011 19:16:48 -0500
In-Reply-To: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Driver and controller initialization.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/Makefile |   30 ++
 drivers/scsi/isci/host.c   |  781 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/isci/host.h   |  283 ++++++++++++++++
 drivers/scsi/isci/init.c   |  613 +++++++++++++++++++++++++++++++++++
 drivers/scsi/isci/isci.h   |  138 ++++++++
 5 files changed, 1845 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/Makefile
 create mode 100644 drivers/scsi/isci/host.c
 create mode 100644 drivers/scsi/isci/host.h
 create mode 100644 drivers/scsi/isci/init.c
 create mode 100644 drivers/scsi/isci/isci.h

diff --git a/drivers/scsi/isci/Makefile b/drivers/scsi/isci/Makefile
new file mode 100644
index 0000000..34f7af3
--- /dev/null
+++ b/drivers/scsi/isci/Makefile
@@ -0,0 +1,30 @@
+#TODO kill SCIC_SDS_4_ENABLED it is always true for this
+#generation of silicon
+EXTRA_CFLAGS += -DSCIC_SDS_4_ENABLED
+
+#temporary until atapi support ready
+EXTRA_CFLAGS += -DDISABLE_ATAPI
+
+EXTRA_CFLAGS += -Idrivers/scsi/isci/core/ -Idrivers/scsi/isci/
+obj-$(CONFIG_SCSI_ISCI) += isci.o
+isci-objs := init.o phy.o request.o sata.o \
+	     remote_device.o port.o timers.o deprecated.o \
+	     host.o task.o events.o \
+	     core/scic_sds_controller.o  \
+	     core/scic_sds_remote_device.o    \
+	     core/scic_sds_request.o \
+	     core/scic_sds_stp_request.o \
+	     core/scic_sds_stp_packet_request.o \
+	     core/scic_sds_stp_remote_device.o \
+	     core/scic_sds_port.o \
+	     core/scic_sds_port_configuration_agent.o \
+	     core/scic_sds_phy.o \
+	     core/scic_sds_ssp_request.o \
+	     core/scic_sds_remote_node_context.o \
+	     core/scic_sds_smp_request.o \
+	     core/scic_sds_smp_remote_device.o \
+	     core/scic_sds_remote_node_table.o \
+	     core/scic_sds_unsolicited_frame_control.o \
+	     core/sci_base_memory_descriptor_list.o \
+	     core/sci_base_state_machine.o \
+	     core/sci_util.o
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
new file mode 100644
index 0000000..6f16f4d
--- /dev/null
+++ b/drivers/scsi/isci/host.c
@@ -0,0 +1,781 @@
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
+#include "isci.h"
+#include "scic_io_request.h"
+#include "scic_remote_device.h"
+#include "scic_port.h"
+
+#include "port.h"
+#include "request.h"
+#include "host.h"
+
+/**
+ * isci_isr() - This function is the interrupt service routine for the
+ *    controller. It schedules the tasklet and returns.
+ * @vec: This parameter specifies the interrupt vector.
+ * @data: This parameter specifies the ISCI host object.
+ *
+ * IRQ_HANDLED if out interrupt otherwise, IRQ_NONE
+ */
+irqreturn_t isci_isr(int vec, void *data)
+{
+	struct isci_host *isci_host
+		= (struct isci_host *)data;
+	struct scic_controller_handler_methods *handlers
+		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
+	irqreturn_t ret = IRQ_NONE;
+
+	if (isci_host_get_state(isci_host) != isci_starting
+	    && handlers->interrupt_handler) {
+
+		if (handlers->interrupt_handler(isci_host->core_controller)) {
+			if (isci_host_get_state(isci_host) != isci_stopped) {
+				tasklet_schedule(
+					&isci_host->completion_tasklet);
+			} else
+				dev_dbg(&isci_host->pdev->dev,
+					"%s: controller stopped\n",
+					__func__);
+			ret = IRQ_HANDLED;
+		}
+	} else
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: get_handler_methods failed, "
+			 "isci_host->status = 0x%x\n",
+			 __func__,
+			 isci_host_get_state(isci_host));
+
+	return ret;
+}
+
+irqreturn_t isci_legacy_isr(int vec, void *data)
+{
+	struct pci_dev *pdev = data;
+	struct isci_host *isci_host;
+	struct scic_controller_handler_methods *handlers;
+	irqreturn_t ret = IRQ_NONE;
+
+	/*
+	 *  Since this is a legacy interrupt, either or both
+	 *  controllers could have triggered it.  Thus, we have to call
+	 *  the legacy interrupt handler for all controllers on the
+	 *  PCI function.
+	 */
+	for_each_isci_host(isci_host, pdev) {
+		handlers = &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
+
+		if (isci_host_get_state(isci_host) != isci_starting
+		    && handlers->interrupt_handler) {
+
+			if (handlers->interrupt_handler(isci_host->core_controller)) {
+				if (isci_host_get_state(isci_host) != isci_stopped) {
+					tasklet_schedule(
+						&isci_host->completion_tasklet);
+				} else
+					dev_dbg(&isci_host->pdev->dev,
+						"%s: controller stopped\n",
+						__func__);
+				ret = IRQ_HANDLED;
+			}
+		} else
+			dev_warn(&isci_host->pdev->dev,
+				 "%s: get_handler_methods failed, "
+				 "isci_host->status = 0x%x\n",
+				 __func__,
+				 isci_host_get_state(isci_host));
+	}
+	return ret;
+}
+
+
+/**
+ * isci_host_start_complete() - This function is called by the core library,
+ *    through the ISCI Module, to indicate controller start status.
+ * @isci_host: This parameter specifies the ISCI host object
+ * @completion_status: This parameter specifies the completion status from the
+ *    core library.
+ *
+ */
+void isci_host_start_complete(
+	struct isci_host *isci_host,
+	enum sci_status completion_status)
+{
+	if (completion_status == SCI_SUCCESS) {
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: completion_status: SCI_SUCCESS\n", __func__);
+		isci_host_change_state(isci_host, isci_ready);
+		complete_all(&isci_host->start_complete);
+	} else
+		dev_err(&isci_host->pdev->dev,
+			"controller start failed with "
+			"completion_status = 0x%x;",
+			completion_status);
+
+}
+
+
+
+/**
+ * isci_host_scan_finished() - This function is one of the SCSI Host Template
+ *    functions. The SCSI midlayer calls this function during a target scan,
+ *    approx. once every 10 millisecs.
+ * @shost: This parameter specifies the SCSI host being scanned
+ * @time: This parameter specifies the number of ticks since the scan started.
+ *
+ * scan status, zero indicates the SCSI midlayer should continue to poll,
+ * otherwise assume controller is ready.
+ */
+int isci_host_scan_finished(
+	struct Scsi_Host *shost,
+	unsigned long time)
+{
+	struct isci_host *isci_host
+		= isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+
+	struct scic_controller_handler_methods *handlers
+		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
+
+	if (handlers->interrupt_handler == NULL) {
+		dev_err(&isci_host->pdev->dev,
+			"%s: scic_controller_get_handler_methods failed\n",
+			__func__);
+		return 1;
+	}
+
+	/**
+	 * check interrupt_handler's status and call completion_handler if true,
+	 * link_up events should be coming from the scu core lib, as phy's come
+	 * online. for each link_up from the core, call
+	 * get_received_identify_address_frame, copy the frame into the
+	 * sas_phy object and call libsas notify_port_event(PORTE_BYTES_DMAED).
+	 * continue to return zero from thee scan_finished routine until
+	 * the scic_cb_controller_start_complete() call comes from the core.
+	 **/
+	if (handlers->interrupt_handler(isci_host->core_controller))
+		handlers->completion_handler(isci_host->core_controller);
+
+	if (isci_starting == isci_host_get_state(isci_host)
+	    && time < (HZ * 10)) {
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: isci_host->status = %d, time = %ld\n",
+			     __func__, isci_host_get_state(isci_host), time);
+		return 0;
+	}
+
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_host->status = %d, time = %ld\n",
+		 __func__, isci_host_get_state(isci_host), time);
+
+	scic_controller_enable_interrupts(isci_host->core_controller);
+
+	return 1;
+
+}
+
+
+/**
+ * isci_host_scan_start() - This function is one of the SCSI Host Template
+ *    function, called by the SCSI mid layer berfore a target scan begins. The
+ *    core library controller start routine is called from here.
+ * @shost: This parameter specifies the SCSI host to be scanned
+ *
+ */
+void isci_host_scan_start(struct Scsi_Host *shost)
+{
+	struct isci_host *isci_host;
+
+	isci_host = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+	isci_host_change_state(isci_host, isci_starting);
+
+	scic_controller_disable_interrupts(isci_host->core_controller);
+	init_completion(&isci_host->start_complete);
+	scic_controller_start(
+		isci_host->core_controller,
+		scic_controller_get_suggested_start_timeout(
+			isci_host->core_controller)
+		);
+}
+
+void isci_host_stop_complete(
+	struct isci_host *isci_host,
+	enum sci_status completion_status)
+{
+	isci_host_change_state(isci_host, isci_stopped);
+	scic_controller_disable_interrupts(
+		isci_host->core_controller
+		);
+	complete(&isci_host->stop_complete);
+}
+
+static struct coherent_memory_info *isci_host_alloc_mdl_struct(
+	struct isci_host *isci_host,
+	u32 size)
+{
+	struct coherent_memory_info *mdl_struct;
+	void *uncached_address = NULL;
+
+
+	mdl_struct = devm_kzalloc(&isci_host->pdev->dev,
+				  sizeof(*mdl_struct),
+				  GFP_KERNEL);
+	if (!mdl_struct)
+		return NULL;
+
+	INIT_LIST_HEAD(&mdl_struct->node);
+
+	uncached_address = dmam_alloc_coherent(&isci_host->pdev->dev,
+					       size,
+					       &mdl_struct->dma_handle,
+					       GFP_KERNEL);
+	if (!uncached_address)
+		return NULL;
+
+	/* memset the whole memory area. */
+	memset((char *)uncached_address, 0, size);
+	mdl_struct->vaddr = uncached_address;
+	mdl_struct->size = (size_t)size;
+
+	return mdl_struct;
+}
+
+static void isci_host_build_mde(
+	struct sci_physical_memory_descriptor *mde_struct,
+	struct coherent_memory_info *mdl_struct)
+{
+	unsigned long address = 0;
+	dma_addr_t dma_addr = 0;
+
+	address = (unsigned long)mdl_struct->vaddr;
+	dma_addr = mdl_struct->dma_handle;
+
+	/* to satisfy the alignment. */
+	if ((address % mde_struct->constant_memory_alignment) != 0) {
+		int align_offset
+			= (mde_struct->constant_memory_alignment
+			   - (address % mde_struct->constant_memory_alignment));
+		address += align_offset;
+		dma_addr += align_offset;
+	}
+
+	mde_struct->virtual_address = (void *)address;
+	mde_struct->physical_address = dma_addr;
+	mdl_struct->mde = mde_struct;
+}
+
+static int isci_host_mdl_allocate_coherent(
+	struct isci_host *isci_host)
+{
+	struct sci_physical_memory_descriptor *current_mde;
+	struct coherent_memory_info *mdl_struct;
+	u32 size = 0;
+
+	struct sci_base_memory_descriptor_list *mdl_handle
+		= sci_controller_get_memory_descriptor_list_handle(
+		isci_host->core_controller);
+
+	sci_mdl_first_entry(mdl_handle);
+
+	current_mde = sci_mdl_get_current_entry(mdl_handle);
+
+	while (current_mde != NULL) {
+
+		size = (current_mde->constant_memory_size
+			+ current_mde->constant_memory_alignment);
+
+		mdl_struct = isci_host_alloc_mdl_struct(isci_host, size);
+		if (!mdl_struct)
+			return -ENOMEM;
+
+		list_add_tail(&mdl_struct->node, &isci_host->mdl_struct_list);
+
+		isci_host_build_mde(current_mde, mdl_struct);
+
+		sci_mdl_next_entry(mdl_handle);
+		current_mde = sci_mdl_get_current_entry(mdl_handle);
+	}
+
+	return 0;
+}
+
+
+/**
+ * isci_host_completion_routine() - This function is the delayed service
+ *    routine that calls the sci core library's completion handler. It's
+ *    scheduled as a tasklet from the interrupt service routine when interrupts
+ *    in use, or set as the timeout function in polled mode.
+ * @data: This parameter specifies the ISCI host object
+ *
+ */
+static void isci_host_completion_routine(unsigned long data)
+{
+	struct isci_host *isci_host = (struct isci_host *)data;
+	struct scic_controller_handler_methods *handlers
+		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
+	struct list_head completed_request_list;
+	struct list_head aborted_request_list;
+	struct list_head *current_position;
+	struct list_head *next_position;
+	struct isci_request *request;
+	struct isci_request *next_request;
+	struct sas_task *task;
+
+	INIT_LIST_HEAD(&completed_request_list);
+	INIT_LIST_HEAD(&aborted_request_list);
+
+	spin_lock_irq(&isci_host->scic_lock);
+
+	if (handlers->completion_handler) {
+		handlers->completion_handler(
+			isci_host->core_controller
+			);
+	}
+	/* Take the lists of completed I/Os from the host. */
+	list_splice_init(&isci_host->requests_to_complete,
+			 &completed_request_list);
+
+	list_splice_init(&isci_host->requests_to_abort,
+			 &aborted_request_list);
+
+	spin_unlock_irq(&isci_host->scic_lock);
+
+	/* Process any completions in the lists. */
+	list_for_each_safe(current_position, next_position,
+			   &completed_request_list) {
+
+		request = list_entry(current_position, struct isci_request,
+				     completed_node);
+		task = isci_request_access_task(request);
+
+		/* Normal notification (task_done) */
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: Normal - request/task = %p/%p\n",
+			__func__,
+			request,
+			task);
+
+		task->task_done(task);
+		task->lldd_task = NULL;
+
+		/* Free the request object. */
+		isci_request_free(isci_host, request);
+	}
+	list_for_each_entry_safe(request, next_request, &aborted_request_list,
+				 completed_node) {
+
+		task = isci_request_access_task(request);
+
+		/* Use sas_task_abort */
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: Error - request/task = %p/%p\n",
+			 __func__,
+			 request,
+			 task);
+
+		/* Put the task into the abort path. */
+		sas_task_abort(task);
+	}
+
+}
+
+void isci_host_deinit(
+	struct isci_host *isci_host)
+{
+	int i;
+
+	isci_host_change_state(isci_host, isci_stopping);
+	for (i = 0; i < SCI_MAX_PORTS; i++) {
+		struct isci_port *port = &isci_host->isci_ports[i];
+		struct isci_remote_device *device, *tmpdev;
+		list_for_each_entry_safe(device, tmpdev,
+					 &port->remote_dev_list, node) {
+			isci_remote_device_change_state(device, isci_stopping);
+			isci_remote_device_stop(device);
+		}
+	}
+
+	/* stop the comtroller and wait for completion.  */
+	init_completion(&isci_host->stop_complete);
+	scic_controller_stop(
+		isci_host->core_controller,
+		SCIC_CONTROLLER_STOP_TIMEOUT
+		);
+	wait_for_completion(&isci_host->stop_complete);
+	/* next, reset the controller.           */
+	scic_controller_reset(isci_host->core_controller);
+}
+
+static int isci_verify_firmware(const struct firmware *fw,
+				struct isci_firmware *isci_fw)
+{
+	const u8 *tmp;
+
+	if (fw->size < ISCI_FIRMWARE_MIN_SIZE)
+		return -EINVAL;
+
+	tmp = fw->data;
+
+	/* 12th char should be the NULL terminate for the ID string */
+	if (tmp[11] != '\0')
+		return -EINVAL;
+
+	if (strncmp("#SCU MAGIC#", tmp, 11) != 0)
+		return -EINVAL;
+
+	isci_fw->id = tmp;
+	isci_fw->version = fw->data[ISCI_FW_VER_OFS];
+	isci_fw->subversion = fw->data[ISCI_FW_SUBVER_OFS];
+
+	tmp = fw->data + ISCI_FW_DATA_OFS;
+
+	while (*tmp != ISCI_FW_HDR_EOF) {
+		switch (*tmp) {
+		case ISCI_FW_HDR_PHYMASK:
+			tmp++;
+			isci_fw->phy_masks_size = *tmp;
+			tmp++;
+			isci_fw->phy_masks = (const u32 *)tmp;
+			tmp += sizeof(u32) * isci_fw->phy_masks_size;
+			break;
+
+		case ISCI_FW_HDR_PHYGEN:
+			tmp++;
+			isci_fw->phy_gens_size = *tmp;
+			tmp++;
+			isci_fw->phy_gens = (const u32 *)tmp;
+			tmp += sizeof(u32) * isci_fw->phy_gens_size;
+			break;
+
+		case ISCI_FW_HDR_SASADDR:
+			tmp++;
+			isci_fw->sas_addrs_size = *tmp;
+			tmp++;
+			isci_fw->sas_addrs = (const u64 *)tmp;
+			tmp += sizeof(u64) * isci_fw->sas_addrs_size;
+			break;
+
+		default:
+			pr_err("bad field in firmware binary blob\n");
+			return -EINVAL;
+		}
+	}
+
+	pr_info("isci firmware v%u.%u loaded.\n",
+	       isci_fw->version, isci_fw->subversion);
+
+	return SCI_SUCCESS;
+}
+
+static void __iomem *scu_base(struct isci_host *isci_host)
+{
+	struct pci_dev *pdev = isci_host->pdev;
+	int id = isci_host->id;
+
+	return pcim_iomap_table(pdev)[SCI_SCU_BAR * 2] + SCI_SCU_BAR_SIZE * id;
+}
+
+static void __iomem *smu_base(struct isci_host *isci_host)
+{
+	struct pci_dev *pdev = isci_host->pdev;
+	int id = isci_host->id;
+
+	return pcim_iomap_table(pdev)[SCI_SMU_BAR * 2] + SCI_SMU_BAR_SIZE * id;
+}
+
+#define SCI_MAX_TIMER_COUNT 25
+
+int isci_host_init(struct isci_host *isci_host)
+{
+	int err = 0;
+	int index = 0;
+	enum sci_status status;
+	struct scic_sds_controller *controller;
+	struct scic_sds_port *scic_port;
+	struct scic_controller_handler_methods *handlers
+		= &isci_host->scic_irq_handlers[0];
+	union scic_oem_parameters scic_oem_params;
+	union scic_user_parameters scic_user_params;
+	const struct firmware *fw = NULL;
+	struct isci_firmware *isci_fw = NULL;
+
+	INIT_LIST_HEAD(&isci_host->timer_list_struct.timers);
+	isci_timer_list_construct(
+		&isci_host->timer_list_struct,
+		SCI_MAX_TIMER_COUNT
+		);
+
+	controller = scic_controller_alloc(&isci_host->pdev->dev);
+
+	if (!controller) {
+		err = -ENOMEM;
+		dev_err(&isci_host->pdev->dev, "%s: failed (%d)\n", __func__, err);
+		goto out;
+	}
+
+	isci_host->core_controller = controller;
+	spin_lock_init(&isci_host->state_lock);
+	spin_lock_init(&isci_host->scic_lock);
+	spin_lock_init(&isci_host->queue_lock);
+
+	isci_host_change_state(isci_host, isci_starting);
+	isci_host->can_queue = ISCI_CAN_QUEUE_VAL;
+
+	status = scic_controller_construct(controller, scu_base(isci_host),
+					   smu_base(isci_host));
+
+	if (status != SCI_SUCCESS) {
+		dev_err(&isci_host->pdev->dev,
+			"%s: scic_controller_construct failed - status = %x\n",
+			__func__,
+			status);
+		err = -ENODEV;
+		goto out;
+	}
+
+	isci_host->sas_ha.dev = &isci_host->pdev->dev;
+	isci_host->sas_ha.lldd_ha = isci_host;
+
+	/*----------- SCIC controller Initialization Stuff ------------------
+	 * set association host adapter struct in core controller.
+	 */
+	sci_object_set_association(isci_host->core_controller,
+				   (void *)isci_host
+				   );
+
+	/* grab initial values stored in the controller object for OEM and USER
+	 * parameters */
+	scic_oem_parameters_get(controller, &scic_oem_params);
+	scic_user_parameters_get(controller, &scic_user_params);
+
+	isci_fw = devm_kzalloc(&isci_host->pdev->dev,
+			       sizeof(struct isci_firmware),
+			       GFP_KERNEL);
+	if (!isci_fw) {
+		dev_warn(&isci_host->pdev->dev,
+			 "allocating firmware struct failed\n");
+		dev_warn(&isci_host->pdev->dev,
+			 "Default OEM configuration being used:"
+			 " 4 narrow ports, and default SAS Addresses\n");
+		goto set_default_params;
+	}
+
+	status = request_firmware(&fw, ISCI_FW_NAME, &isci_host->pdev->dev);
+	if (status) {
+		dev_warn(&isci_host->pdev->dev,
+			 "Loading firmware failed, using default values\n");
+		dev_warn(&isci_host->pdev->dev,
+			 "Default OEM configuration being used:"
+			 " 4 narrow ports, and default SAS Addresses\n");
+		goto set_default_params;
+	}
+	else {
+		status = isci_verify_firmware(fw, isci_fw);
+		if (status != SCI_SUCCESS) {
+			dev_warn(&isci_host->pdev->dev,
+				 "firmware verification failed\n");
+			dev_warn(&isci_host->pdev->dev,
+				 "Default OEM configuration being used:"
+				 " 4 narrow ports, and default SAS "
+				 "Addresses\n");
+			goto set_default_params;
+		}
+
+		/* grab any OEM and USER parameters specified at module load */
+		status = isci_parse_oem_parameters(&scic_oem_params,
+						   isci_host->id, isci_fw);
+		if (status != SCI_SUCCESS) {
+			dev_warn(&isci_host->pdev->dev,
+				 "parsing firmware oem parameters failed\n");
+			err = -EINVAL;
+			goto out;
+		}
+
+		status = isci_parse_user_parameters(&scic_user_params,
+						    isci_host->id, isci_fw);
+		if (status != SCI_SUCCESS) {
+			dev_warn(&isci_host->pdev->dev,
+				 "%s: isci_parse_user_parameters"
+				 " failed\n", __func__);
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+ set_default_params:
+
+	status = scic_oem_parameters_set(isci_host->core_controller,
+					 &scic_oem_params
+					 );
+
+	if (status != SCI_SUCCESS) {
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: scic_oem_parameters_set failed\n",
+			 __func__);
+		err = -ENODEV;
+		goto out;
+	}
+
+
+	status = scic_user_parameters_set(isci_host->core_controller,
+					  &scic_user_params
+					  );
+
+	if (status != SCI_SUCCESS) {
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: scic_user_parameters_set failed\n",
+			 __func__);
+		err = -ENODEV;
+		goto out;
+	}
+
+	status = scic_controller_initialize(isci_host->core_controller);
+	if (status != SCI_SUCCESS) {
+		dev_warn(&isci_host->pdev->dev,
+			 "%s: scic_controller_initialize failed -"
+			 " status = 0x%x\n",
+			 __func__, status);
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* @todo: use both MSI-X interrupts, and don't do indirect
+	 * calls to the handlers just register direct calls
+	 */
+	if (isci_host->pdev->msix_enabled) {
+		status = scic_controller_get_handler_methods(
+			SCIC_MSIX_INTERRUPT_TYPE,
+			SCI_MSIX_DOUBLE_VECTOR,
+			handlers
+			);
+	} else {
+		status = scic_controller_get_handler_methods(
+			SCIC_LEGACY_LINE_INTERRUPT_TYPE,
+			0,
+			handlers
+			);
+	}
+
+	if (status != SCI_SUCCESS) {
+		handlers->interrupt_handler = NULL;
+		handlers->completion_handler = NULL;
+		dev_err(&isci_host->pdev->dev,
+			"%s: scic_controller_get_handler_methods failed\n",
+			__func__);
+	}
+
+	tasklet_init(&isci_host->completion_tasklet,
+		     isci_host_completion_routine,
+		     (unsigned long)isci_host
+		     );
+
+	INIT_LIST_HEAD(&(isci_host->mdl_struct_list));
+
+	INIT_LIST_HEAD(&isci_host->requests_to_complete);
+	INIT_LIST_HEAD(&isci_host->requests_to_abort);
+
+	/* populate mdl with dma memory. scu_mdl_allocate_coherent() */
+	err = isci_host_mdl_allocate_coherent(isci_host);
+
+	if (err)
+		goto err_out;
+
+	/*
+	 * keep the pool alloc size around, will use it for a bounds checking
+	 * when trying to convert virtual addresses to physical addresses
+	 */
+	isci_host->dma_pool_alloc_size = sizeof(struct isci_request) +
+					 scic_io_request_get_object_size();
+	isci_host->dma_pool = dmam_pool_create(DRV_NAME, &isci_host->pdev->dev,
+					       isci_host->dma_pool_alloc_size,
+					       SLAB_HWCACHE_ALIGN, 0);
+
+	if (!isci_host->dma_pool) {
+		err = -ENOMEM;
+		goto req_obj_err_out;
+	}
+
+	for (index = 0; index < SCI_MAX_PORTS; index++) {
+		isci_port_init(&isci_host->isci_ports[index],
+			       isci_host, index);
+	}
+
+	for (index = 0; index < SCI_MAX_PHYS; index++)
+		isci_phy_init(&isci_host->phys[index], isci_host, index);
+
+	/* Why are we doing this? Is this even necessary? */
+	memcpy(&isci_host->sas_addr[0], &isci_host->phys[0].sas_addr[0],
+	       SAS_ADDR_SIZE);
+
+	/* Start the ports */
+	for (index = 0; index < SCI_MAX_PORTS; index++) {
+
+		scic_controller_get_port_handle(controller, index, &scic_port);
+		scic_port_start(scic_port);
+	}
+
+	goto out;
+
+/* SPB_Debug: destroy request object cache */
+ req_obj_err_out:
+/* SPB_Debug: destroy remote object cache */
+ err_out:
+/* SPB_Debug: undo controller init, construct and alloc, remove from parent
+ * controller list. */
+ out:
+	if (fw)
+		release_firmware(fw);
+	return err;
+}
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
new file mode 100644
index 0000000..3530076
--- /dev/null
+++ b/drivers/scsi/isci/host.h
@@ -0,0 +1,283 @@
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
+ * This file contains the isci_module initialization routines.
+ *
+ * host.h
+ */
+
+
+
+#if !defined(_SCI_HOST_H_)
+#define _SCI_HOST_H_
+
+#include "phy.h"
+/*#include "task.h"*/
+#include "timers.h"
+#include "remote_device.h"
+#include "scic_user_callback.h"
+
+#define DRV_NAME "isci"
+#define SCI_PCI_BAR_COUNT 2
+#define SCI_NUM_MSI_X_INT 2
+#define SCI_SMU_BAR       0
+#define SCI_SMU_BAR_SIZE  (16*1024)
+#define SCI_SCU_BAR       1
+#define SCI_SCU_BAR_SIZE  (4*1024*1024)
+#define SCI_IO_SPACE_BAR0 2
+#define SCI_IO_SPACE_BAR1 3
+#define SCI_MSIX_NORMAL_VECTOR 0
+#define SCI_MSIX_ERROR_VECTOR 1
+#define SCI_MSIX_SINGLE_VECTOR 1
+#define SCI_MSIX_DOUBLE_VECTOR 2
+#define ISCI_CAN_QUEUE_VAL 250 /* < SCI_MAX_IO_REQUESTS ? */
+#define SCIC_CONTROLLER_STOP_TIMEOUT 5000
+
+struct coherent_memory_info {
+	struct list_head node;
+	dma_addr_t dma_handle;
+	void *vaddr;
+	size_t size;
+	struct sci_physical_memory_descriptor *mde;
+};
+
+struct isci_host {
+	struct scic_sds_controller *core_controller;
+	struct scic_controller_handler_methods scic_irq_handlers[SCI_NUM_MSI_X_INT];
+	union scic_oem_parameters oem_parameters;
+
+	int id; /* unique within a given pci device */
+	struct isci_timer_list timer_list_struct;
+	void *core_ctrl_memory;
+	struct dma_pool *dma_pool;
+	unsigned int dma_pool_alloc_size;
+	struct isci_phy phys[SCI_MAX_PHYS];
+
+	/* isci_ports and sas_ports are implicitly parallel to the
+	 * ports maintained by the core
+	 */
+	struct isci_port isci_ports[SCI_MAX_PORTS];
+	struct asd_sas_port sas_ports[SCI_MAX_PORTS];
+	struct sas_ha_struct sas_ha;
+
+	int can_queue;
+	spinlock_t queue_lock;
+	spinlock_t state_lock;
+
+	struct pci_dev *pdev;
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	enum isci_status status;
+	struct Scsi_Host *shost;
+	struct tasklet_struct completion_tasklet;
+	struct list_head mdl_struct_list;
+	struct list_head requests_to_complete;
+	struct list_head requests_to_abort;
+	struct completion stop_complete;
+	struct completion start_complete;
+	spinlock_t scic_lock;
+	struct isci_host *next;
+};
+
+
+/**
+ * struct isci_pci_info - This class represents the pci function containing the
+ *    controllers. Depending on PCI SKU, there could be up to 2 controllers in
+ *    the PCI function.
+ */
+#define SCI_MAX_MSIX_INT (SCI_NUM_MSI_X_INT*SCI_MAX_CONTROLLERS)
+
+struct isci_pci_info {
+	struct msix_entry msix_entries[SCI_MAX_MSIX_INT];
+	int core_lib_array_index;
+	SCI_LIBRARY_HANDLE_T core_lib_handle;
+	struct isci_host *hosts;
+};
+
+static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev)
+{
+	return pci_get_drvdata(pdev);
+}
+
+#define for_each_isci_host(isci_host, pdev) \
+	for (isci_host = to_pci_info(pdev)->hosts;\
+	     isci_host; isci_host = isci_host->next)
+
+static inline
+enum isci_status isci_host_get_state(
+	struct isci_host *isci_host)
+{
+	return isci_host->status;
+}
+
+
+static inline void isci_host_change_state(
+	struct isci_host *isci_host,
+	enum isci_status status)
+{
+	unsigned long flags;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_host = %p, state = 0x%x",
+		__func__,
+		isci_host,
+		status);
+	spin_lock_irqsave(&isci_host->state_lock, flags);
+	isci_host->status = status;
+	spin_unlock_irqrestore(&isci_host->state_lock, flags);
+
+}
+
+static inline int isci_host_can_queue(
+	struct isci_host *isci_host,
+	int num)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&isci_host->queue_lock, flags);
+	if ((isci_host->can_queue - num) < 0) {
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: isci_host->can_queue = %d\n",
+			__func__,
+			isci_host->can_queue);
+		ret = -SAS_QUEUE_FULL;
+
+	} else
+		isci_host->can_queue -= num;
+
+	spin_unlock_irqrestore(&isci_host->queue_lock, flags);
+
+	return ret;
+}
+
+static inline void isci_host_can_dequeue(
+	struct isci_host *isci_host,
+	int num)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&isci_host->queue_lock, flags);
+	isci_host->can_queue += num;
+	spin_unlock_irqrestore(&isci_host->queue_lock, flags);
+}
+
+/**
+ * isci_host_from_sas_ha() - This accessor retrieves the isci_host object
+ *    reference from the Linux sas_ha_struct reference.
+ * @ha_struct,: This parameter points to the Linux sas_ha_struct object
+ *
+ * A reference to the associated isci_host structure.
+ */
+#define isci_host_from_sas_ha(ha_struct) \
+	((struct isci_host *)(ha_struct)->lldd_ha)
+
+/**
+ * isci_host_scan_finished() -
+ *
+ * This function is one of the SCSI Host Template functions. The SCSI midlayer
+ * calls this function during a target scan, approx. once every 10 millisecs.
+ */
+int isci_host_scan_finished(
+	struct Scsi_Host *,
+	unsigned long);
+
+
+/**
+ * isci_host_scan_start() -
+ *
+ * This function is one of the SCSI Host Template function, called by the SCSI
+ * mid layer berfore a target scan begins. The core library controller start
+ * routine is called from here.
+ */
+void isci_host_scan_start(
+	struct Scsi_Host *);
+
+/**
+ * isci_host_start_complete() -
+ *
+ * This function is called by the core library, through the ISCI Module, to
+ * indicate controller start status.
+ */
+void isci_host_start_complete(
+	struct isci_host *,
+	enum sci_status);
+
+void isci_host_stop_complete(
+	struct isci_host *isci_host,
+	enum sci_status completion_status);
+
+int isci_host_init(struct isci_host *);
+
+void isci_host_init_controller_names(
+	struct isci_host *isci_host,
+	unsigned int controller_idx);
+
+void isci_host_deinit(
+	struct isci_host *);
+
+void isci_host_port_link_up(
+	struct isci_host *,
+	struct scic_sds_port *,
+	struct scic_sds_phy *);
+int isci_host_dev_found(struct domain_device *);
+
+void isci_host_remote_device_start_complete(
+	struct isci_host *,
+	struct isci_remote_device *,
+	enum sci_status);
+
+#endif /* !defined(_SCI_HOST_H_) */
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
new file mode 100644
index 0000000..07b072f
--- /dev/null
+++ b/drivers/scsi/isci/init.c
@@ -0,0 +1,613 @@
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <asm/string.h>
+#include "isci.h"
+#include "task.h"
+#include "sci_controller_constants.h"
+#include "scic_remote_device.h"
+#include "sci_environment.h"
+
+static struct scsi_transport_template *isci_transport_template;
+struct kmem_cache *isci_kmem_cache;
+
+static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
+	{ PCI_VDEVICE(INTEL, 0x1D61),},
+	{ PCI_VDEVICE(INTEL, 0x1D63),},
+	{ PCI_VDEVICE(INTEL, 0x1D65),},
+	{ PCI_VDEVICE(INTEL, 0x1D67),},
+	{ PCI_VDEVICE(INTEL, 0x1D69),},
+	{ PCI_VDEVICE(INTEL, 0x1D6B),},
+	{ PCI_VDEVICE(INTEL, 0x1D60),},
+	{ PCI_VDEVICE(INTEL, 0x1D62),},
+	{ PCI_VDEVICE(INTEL, 0x1D64),},
+	{ PCI_VDEVICE(INTEL, 0x1D66),},
+	{ PCI_VDEVICE(INTEL, 0x1D68),},
+	{ PCI_VDEVICE(INTEL, 0x1D6A),},
+	{}
+};
+
+static int __devinit isci_pci_probe(
+	struct pci_dev *pdev,
+	const struct pci_device_id *device_id_p);
+
+static void __devexit isci_pci_remove(struct pci_dev *pdev);
+
+MODULE_DEVICE_TABLE(pci, isci_id_table);
+
+static struct pci_driver isci_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table	= isci_id_table,
+	.probe		= isci_pci_probe,
+	.remove		= __devexit_p(isci_pci_remove),
+};
+
+/* linux isci specific settings */
+int loglevel = 3;
+module_param(loglevel, int, S_IRUGO | S_IWUSR);
+
+#if defined(CONFIG_PBG_HBA_A0)
+int isci_si_rev = ISCI_SI_REVA0;
+#elif defined(CONFIG_PBG_HBA_A2)
+int isci_si_rev = ISCI_SI_REVA2;
+#else
+int isci_si_rev = ISCI_SI_REVB0;
+#endif
+module_param(isci_si_rev, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(isci_si_rev, "override default si rev (0: A0 1: A2 2: B0)");
+
+static struct scsi_host_template isci_sht = {
+
+	.module				= THIS_MODULE,
+	.name				= DRV_NAME,
+	.queuecommand			= sas_queuecommand,
+	.target_alloc			= sas_target_alloc,
+	.slave_configure		= sas_slave_configure,
+	.slave_destroy			= sas_slave_destroy,
+	.scan_finished			= isci_host_scan_finished,
+	.scan_start			= isci_host_scan_start,
+	.change_queue_depth		= sas_change_queue_depth,
+	.change_queue_type		= sas_change_queue_type,
+	.bios_param			= sas_bios_param,
+	.can_queue			= ISCI_CAN_QUEUE_VAL,
+	.cmd_per_lun			= 1,
+	.this_id			= -1,
+	.sg_tablesize			= SG_ALL,
+	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.eh_device_reset_handler	= sas_eh_device_reset_handler,
+	.eh_bus_reset_handler		= isci_bus_reset_handler,
+	.slave_alloc			= sas_slave_alloc,
+	.target_destroy			= sas_target_destroy,
+	.ioctl				= sas_ioctl,
+};
+
+static struct sas_domain_function_template isci_transport_ops  = {
+
+	/* The class calls these to notify the LLDD of an event. */
+	.lldd_port_formed	= isci_port_formed,
+	.lldd_port_deformed	= isci_port_deformed,
+
+	/* The class calls these when a device is found or gone. */
+	.lldd_dev_found		= isci_remote_device_found,
+	.lldd_dev_gone		= isci_remote_device_gone,
+
+	.lldd_execute_task	= isci_task_execute_task,
+	/* Task Management Functions. Must be called from process context. */
+	.lldd_abort_task	= isci_task_abort_task,
+	.lldd_abort_task_set	= isci_task_abort_task_set,
+	.lldd_clear_aca		= isci_task_clear_aca,
+	.lldd_clear_task_set	= isci_task_clear_task_set,
+	.lldd_I_T_nexus_reset	= isci_task_I_T_nexus_reset,
+	.lldd_lu_reset		= isci_task_lu_reset,
+	.lldd_query_task	= isci_task_query_task,
+
+	/* Port and Adapter management */
+	.lldd_clear_nexus_port	= isci_task_clear_nexus_port,
+	.lldd_clear_nexus_ha	= isci_task_clear_nexus_ha,
+
+	/* Phy management */
+	.lldd_control_phy	= isci_phy_control,
+};
+
+
+/******************************************************************************
+* P R O T E C T E D  M E T H O D S
+******************************************************************************/
+
+
+
+/**
+ * isci_register_sas_ha() - This method initializes various lldd
+ *    specific members of the sas_ha struct and calls the libsas
+ *    sas_register_ha() function.
+ * @isci_host: This parameter specifies the lldd specific wrapper for the
+ *    libsas sas_ha struct.
+ *
+ * This method returns an error code indicating sucess or failure. The user
+ * should check for possible memory allocation error return otherwise, a zero
+ * indicates success.
+ */
+static int isci_register_sas_ha(struct isci_host *isci_host)
+{
+	int i;
+	struct sas_ha_struct *sas_ha = &(isci_host->sas_ha);
+	struct asd_sas_phy **sas_phys;
+	struct asd_sas_port **sas_ports;
+
+	sas_phys = devm_kzalloc(&isci_host->pdev->dev,
+				SCI_MAX_PHYS * sizeof(void *),
+				GFP_KERNEL);
+	if (!sas_phys)
+		return -ENOMEM;
+
+	sas_ports = devm_kzalloc(&isci_host->pdev->dev,
+				 SCI_MAX_PORTS * sizeof(void *),
+				 GFP_KERNEL);
+	if (!sas_ports)
+		return -ENOMEM;
+
+	/*----------------- Libsas Initialization Stuff----------------------
+	 * Set various fields in the sas_ha struct:
+	 */
+
+	sas_ha->sas_ha_name = DRV_NAME;
+	sas_ha->lldd_module = THIS_MODULE;
+	sas_ha->sas_addr    = &(isci_host->sas_addr[0]);
+
+	/* set the array of phy and port structs.  */
+	for (i = 0; i < SCI_MAX_PHYS; i++) {
+		sas_phys[i] = &(isci_host->phys[i].sas_phy);
+		sas_ports[i] = &(isci_host->sas_ports[i]);
+	}
+
+	sas_ha->sas_phy  = sas_phys;
+	sas_ha->sas_port = sas_ports;
+	sas_ha->num_phys = SCI_MAX_PHYS;
+
+	sas_ha->lldd_queue_size = ISCI_CAN_QUEUE_VAL;
+	sas_ha->lldd_max_execute_num = 1;
+	sas_ha->strict_wide_ports = 1;
+
+	sas_register_ha(sas_ha);
+
+	return 0;
+}
+
+static void isci_unregister_sas_ha(struct isci_host *isci_host)
+{
+	if (!isci_host)
+		return;
+
+	sas_unregister_ha(&(isci_host->sas_ha));
+
+	sas_remove_host(isci_host->shost);
+	scsi_remove_host(isci_host->shost);
+	scsi_host_put(isci_host->shost);
+}
+
+static int __devinit isci_pci_init(struct pci_dev *pdev)
+{
+	int err, bar_num, bar_mask;
+	void __iomem * const *iomap;
+
+	err = pcim_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev,
+			"failed enable PCI device %s!\n",
+			pci_name(pdev));
+		return err;
+	}
+
+	for (bar_num = 0; bar_num < SCI_PCI_BAR_COUNT; bar_num++)
+		bar_mask |= 1 << (bar_num * 2);
+
+	err = pcim_iomap_regions(pdev, bar_mask, DRV_NAME);
+	if (err)
+		return err;
+
+	iomap = pcim_iomap_table(pdev);
+	if (!iomap)
+		return -ENOMEM;
+
+	pci_set_master(pdev);
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err)
+			return err;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (err) {
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct isci_host *isci_host_by_id(struct pci_dev *pdev, int id)
+{
+	struct isci_host *h;
+
+	for_each_isci_host(h, pdev)
+		if (h->id == id)
+			return h;
+	return NULL;
+}
+
+static int num_controllers(struct pci_dev *pdev)
+{
+	/* bar size alone can tell us if we are running with a dual controller
+	 * part, no need to trust revision ids that might be under broken firmware
+	 * control
+	 */
+	resource_size_t scu_bar_size = pci_resource_len(pdev, SCI_SCU_BAR*2);
+	resource_size_t smu_bar_size = pci_resource_len(pdev, SCI_SMU_BAR*2);
+	
+	if (scu_bar_size >= SCI_SCU_BAR_SIZE*SCI_MAX_CONTROLLERS &&
+	    smu_bar_size >= SCI_SMU_BAR_SIZE*SCI_MAX_CONTROLLERS)
+		return SCI_MAX_CONTROLLERS;
+	else
+		return 1;
+}
+
+static int isci_setup_interrupts(struct pci_dev *pdev)
+{
+	int err, i, num_msix;
+	struct isci_pci_info *pci_info = to_pci_info(pdev);
+
+	/*
+	 *  Determine the number of vectors associated with this
+	 *  PCI function.
+	 */
+	num_msix = num_controllers(pdev) * SCI_NUM_MSI_X_INT;
+
+	for (i = 0; i < num_msix; i++)
+		pci_info->msix_entries[i].entry = i;
+
+	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
+	if (err)
+		goto intx;
+
+	for (i = 0; i < num_msix; i++) {
+		int id = i / SCI_NUM_MSI_X_INT;
+		struct msix_entry *msix = &pci_info->msix_entries[i];
+		struct isci_host *isci_host = isci_host_by_id(pdev, id);
+
+		BUG_ON(!isci_host);
+
+		/* @todo: need to handle error case. */
+		err = devm_request_irq(&pdev->dev, msix->vector, isci_isr, 0,
+				       DRV_NAME"-msix", isci_host);
+		if (!err)
+			continue;
+
+		dev_info(&pdev->dev, "msix setup failed falling back to intx\n");
+		while (i--) {
+			id = i / SCI_NUM_MSI_X_INT;
+			isci_host = isci_host_by_id(pdev, id);
+			msix = &pci_info->msix_entries[i];
+			devm_free_irq(&pdev->dev, msix->vector, isci_host);
+		}
+		pci_disable_msix(pdev);
+		goto intx;
+	}
+
+	return 0;
+
+ intx:
+	err = devm_request_irq(&pdev->dev, pdev->irq, isci_legacy_isr,
+			       IRQF_SHARED, DRV_NAME"-intx", pdev);
+
+	return err;
+}
+
+/**
+ * isci_parse_oem_parameters() - This method will take OEM parameters
+ *    from the module init parameters and copy them to oem_params. This will
+ *    only copy values that are not set to the module parameter default values
+ * @oem_parameters: This parameter specifies the controller default OEM
+ *    parameters. It is expected that this has been initialized to the default
+ *    parameters for the controller
+ *
+ *
+ */
+enum sci_status isci_parse_oem_parameters(union scic_oem_parameters *oem_params,
+					  int scu_index,
+					  struct isci_firmware *fw)
+{
+	int i;
+
+	/* check for valid inputs */
+	if (!(scu_index >= 0
+	      && scu_index < SCI_MAX_CONTROLLERS
+	      && oem_params != NULL)) {
+		return SCI_FAILURE;
+	}
+
+	for (i = 0; i < SCI_MAX_PHYS; i++) {
+		int array_idx = i + (SCI_MAX_PHYS * scu_index);
+		u64 sas_addr = fw->sas_addrs[array_idx];
+
+		if (sas_addr != 0) {
+			oem_params->sds1.phys[i].sas_address.low =
+				(u32)(sas_addr & 0xffffffff);
+			oem_params->sds1.phys[i].sas_address.high =
+				(u32)((sas_addr >> 32) & 0xffffffff);
+		}
+	}
+
+	for (i = 0; i < SCI_MAX_PORTS; i++) {
+		int array_idx = i + (SCI_MAX_PORTS * scu_index);
+		u32 pmask = fw->phy_masks[array_idx];
+
+		oem_params->sds1.ports[i].phy_mask = pmask;
+	}
+
+	return SCI_SUCCESS;
+}
+
+/**
+ * isci_parse_user_parameters() - This method will take user parameters
+ *    from the module init parameters and copy them to user_params. This will
+ *    only copy values that are not set to the module parameter default values
+ * @user_parameters: This parameter specifies the controller default user
+ *    parameters. It is expected that this has been initialized to the default
+ *    parameters for the controller
+ *
+ *
+ */
+enum sci_status isci_parse_user_parameters(
+	union scic_user_parameters *user_params,
+	int scu_index,
+	struct isci_firmware *fw)
+{
+	int i;
+
+	if (!(scu_index >= 0
+	      && scu_index < SCI_MAX_CONTROLLERS
+	      && user_params != NULL)) {
+		return SCI_FAILURE;
+	}
+
+	for (i = 0; i < SCI_MAX_PORTS; i++) {
+		int array_idx = i + (SCI_MAX_PORTS * scu_index);
+		u32 gen = fw->phy_gens[array_idx];
+
+		user_params->sds1.phys[i].max_speed_generation = gen;
+
+	}
+
+	return SCI_SUCCESS;
+}
+
+static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
+{
+	struct isci_host *isci_host;
+	struct Scsi_Host *shost;
+	int err;
+
+	isci_host = devm_kzalloc(&pdev->dev, sizeof(*isci_host), GFP_KERNEL);
+	if (!isci_host)
+		return NULL;
+
+	isci_host->pdev = pdev;
+	isci_host->id = id;
+
+	shost = scsi_host_alloc(&isci_sht, sizeof(void *));
+	if (!shost)
+		return NULL;
+	isci_host->shost = shost;
+
+	err = isci_host_init(isci_host);
+	if (err)
+		goto err_shost;
+
+	SHOST_TO_SAS_HA(shost) = &isci_host->sas_ha;
+	isci_host->sas_ha.core.shost = shost;
+	shost->transportt = isci_transport_template;
+
+	shost->max_id = ~0;
+	shost->max_lun = ~0;
+	shost->max_cmd_len = MAX_COMMAND_SIZE;
+
+	err = scsi_add_host(shost, &pdev->dev);
+	if (err)
+		goto err_shost;
+
+	err = isci_register_sas_ha(isci_host);
+	if (err)
+		goto err_shost_remove;
+
+	return isci_host;
+
+ err_shost_remove:
+	scsi_remove_host(shost);
+ err_shost:
+	scsi_host_put(shost);
+
+	return NULL;
+}
+
+static void check_si_rev(struct pci_dev *pdev)
+{
+	if (num_controllers(pdev) > 1)
+		isci_si_rev = ISCI_SI_REVB0;
+	else {
+		switch (pdev->revision) {
+		case 0:
+		case 1:
+			/* if the id is ambiguous don't update isci_si_rev */
+			break;
+		case 3:
+			isci_si_rev = ISCI_SI_REVA2;
+			break;
+		default:
+		case 4:
+			isci_si_rev = ISCI_SI_REVB0;
+			break;
+		}
+	}
+
+	dev_info(&pdev->dev, "driver configured for %s silicon (rev: %d)\n",
+		 isci_si_rev == ISCI_SI_REVA0 ? "A0" :
+		 isci_si_rev == ISCI_SI_REVA2 ? "A2" : "B0", pdev->revision);
+		
+}
+
+static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct isci_pci_info *pci_info;
+	int err, i;
+	struct isci_host *isci_host;
+
+	check_si_rev(pdev);
+
+	pci_info = devm_kzalloc(&pdev->dev, sizeof(*pci_info), GFP_KERNEL);
+	if (!pci_info)
+		return -ENOMEM;
+	pci_set_drvdata(pdev, pci_info);
+
+	err = isci_pci_init(pdev);
+	if (err)
+		return err;
+
+	for (i = 0; i < num_controllers(pdev); i++) {
+		struct isci_host *h = isci_host_alloc(pdev, i);
+
+		if (!h) {
+			err = -ENOMEM;
+			goto err_host_alloc;
+		}
+
+		h->next = pci_info->hosts;
+		pci_info->hosts = h;
+	}
+
+	err = isci_setup_interrupts(pdev);
+	if (err)
+		goto err_host_alloc;
+
+	for_each_isci_host(isci_host, pdev)
+		scsi_scan_host(isci_host->shost);
+
+	return 0;
+
+ err_host_alloc:
+	for_each_isci_host(isci_host, pdev)
+		isci_unregister_sas_ha(isci_host);
+	return err;
+}
+
+static void __devexit isci_pci_remove(struct pci_dev *pdev)
+{
+	struct isci_host *isci_host;
+
+	for_each_isci_host(isci_host, pdev) {
+		isci_unregister_sas_ha(isci_host);
+		isci_host_deinit(isci_host);
+		scic_controller_disable_interrupts(isci_host->core_controller);
+	}
+}
+
+static __init int isci_init(void)
+{
+	int err = -ENOMEM;
+
+	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
+
+	isci_kmem_cache = kmem_cache_create(DRV_NAME,
+					    sizeof(struct isci_remote_device) +
+					    scic_remote_device_get_object_size(),
+					    0, 0, NULL);
+	if (!isci_kmem_cache)
+		return err;
+
+	isci_transport_template = sas_domain_attach_transport(&isci_transport_ops);
+	if (!isci_transport_template)
+		goto err_kmem;
+
+	err = pci_register_driver(&isci_pci_driver);
+	if (err)
+		goto err_sas;
+
+	return 0;
+
+ err_sas:
+	sas_release_transport(isci_transport_template);
+ err_kmem:
+	kmem_cache_destroy(isci_kmem_cache);
+
+	return err;
+}
+
+static __exit void isci_exit(void)
+{
+	pci_unregister_driver(&isci_pci_driver);
+	sas_release_transport(isci_transport_template);
+	kmem_cache_destroy(isci_kmem_cache);
+}
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_FIRMWARE(ISCI_FW_NAME);
+module_init(isci_init);
+module_exit(isci_exit);
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
new file mode 100644
index 0000000..7d984f4
--- /dev/null
+++ b/drivers/scsi/isci/isci.h
@@ -0,0 +1,138 @@
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
+ * This file contains the isci_module object definition.
+ *
+ * isci.h
+ */
+
+#if !defined(_SCI_MODULE_H_)
+#define _SCI_MODULE_H_
+
+/**
+ * This file contains the SCI low level driver interface to the SCI and Libsas
+ *    Libraries.
+ *
+ * isci.h
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/bug.h>
+#include <scsi/libsas.h>
+#include <scsi/scsi.h>
+
+#include "sci_types.h"
+#include "sci_base_controller.h"
+#include "scic_controller.h"
+#include "host.h"
+#include "timers.h"
+#include "sci_status.h"
+
+extern int loglevel;
+extern struct kmem_cache *isci_kmem_cache;
+
+#define ISCI_FW_NAME		"isci/isci_firmware.bin"
+
+#define ISCI_FIRMWARE_MIN_SIZE	149
+
+#define ISCI_FW_IDSIZE		12
+#define ISCI_FW_VER_OFS		ISCI_FW_IDSIZE
+#define ISCI_FW_SUBVER_OFS	ISCI_FW_VER_OFS + 1
+#define ISCI_FW_DATA_OFS	ISCI_FW_SUBVER_OFS + 1
+
+#define ISCI_FW_HDR_PHYMASK	0x1
+#define ISCI_FW_HDR_PHYGEN	0x2
+#define ISCI_FW_HDR_SASADDR	0x3
+#define ISCI_FW_HDR_EOF		0xff
+
+struct isci_firmware {
+	const u8 *id;
+	u8 version;
+	u8 subversion;
+	const u32 *phy_masks;
+	u8 phy_masks_size;
+	const u32 *phy_gens;
+	u8 phy_gens_size;
+	const u64 *sas_addrs;
+	u8 sas_addrs_size;
+};
+
+irqreturn_t isci_isr(int vec, void *data);
+irqreturn_t isci_legacy_isr(int vec, void *data);
+
+enum sci_status isci_parse_oem_parameters(
+	union scic_oem_parameters *oem_params,
+	int scu_index,
+	struct isci_firmware *fw);
+
+enum sci_status isci_parse_user_parameters(
+	union scic_user_parameters *user_params,
+	int scu_index,
+	struct isci_firmware *fw);
+
+#ifdef ISCI_SLAVE_ALLOC
+extern int ISCI_SLAVE_ALLOC(struct scsi_device *scsi_dev);
+#endif /* ISCI_SLAVE_ALLOC */
+
+#ifdef ISCI_SLAVE_DESTROY
+extern void ISCI_SLAVE_DESTROY(struct scsi_device *scsi_dev);
+#endif  /* ISCI_SLAVE_DESTROY */
+#endif  /* !defined(_SCI_MODULE_H_) */

