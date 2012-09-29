From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH 7/20][SCSI] mpt3sas: Common API layer interface for
 access to MPT firmware.This patch is part 1 of mpt3sas_base.c
Date: Sat, 29 Sep 2012 19:50:08 +0530
Message-ID: <20120929142007.GA20807@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55368 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2I2Uc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:32:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This Patch contains the Fusion MPT base driver providing common API layer interface
for access to MPT (Message Passing Technology) firmware.
This patch is part 1 of mpt3sas_base.c

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
new file mode 100644
index 0000000..1164d38
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -0,0 +1,2404 @@
+/*
+ * This is the Fusion MPT base driver providing common API layer interface
+ * for access to MPT (Message Passing Technology) firmware.
+ *
+ * This code is based on drivers/scsi/mpt3sas/mpt3sas_base.c
+ * Copyright (C) 2012  LSI Corporation
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/kdev_t.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/time.h>
+#include <linux/kthread.h>
+#include <linux/aer.h>
+
+
+#include "mpt3sas_base.h"
+
+static MPT_CALLBACK	mpt_callbacks[MPT_MAX_CALLBACKS];
+
+
+#define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
+
+ /* maximum controller queue depth */
+#define MAX_HBA_QUEUE_DEPTH	30000
+#define MAX_CHAIN_DEPTH		100000
+static int max_queue_depth = -1;
+module_param(max_queue_depth, int, 0);
+MODULE_PARM_DESC(max_queue_depth, " max controller queue depth ");
+
+static int max_sgl_entries = -1;
+module_param(max_sgl_entries, int, 0);
+MODULE_PARM_DESC(max_sgl_entries, " max sg entries ");
+
+static int msix_disable = -1;
+module_param(msix_disable, int, 0);
+MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
+
+
+static int mpt3sas_fwfault_debug;
+MODULE_PARM_DESC(mpt3sas_fwfault_debug,
+	" enable detection of firmware fault and halt firmware - (default=0)");
+
+
+/**
+ * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
+ *
+ */
+static int
+_scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	struct MPT3SAS_ADAPTER *ioc;
+
+	if (ret)
+		return ret;
+
+	pr_info("setting fwfault_debug(%d)\n", mpt3sas_fwfault_debug);
+	list_for_each_entry(ioc, &mpt3sas_ioc_list, list)
+		ioc->fwfault_debug = mpt3sas_fwfault_debug;
+	return 0;
+}
+module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
+	param_get_int, &mpt3sas_fwfault_debug, 0644);
+
+/**
+ *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
+ * @arg: input argument, used to derive ioc
+ *
+ * Return 0 if controller is removed from pci subsystem.
+ * Return -1 for other case.
+ */
+static int mpt3sas_remove_dead_ioc_func(void *arg)
+{
+	struct MPT3SAS_ADAPTER *ioc = (struct MPT3SAS_ADAPTER *)arg;
+	struct pci_dev *pdev;
+
+	if ((ioc == NULL))
+		return -1;
+
+	pdev = ioc->pdev;
+	if ((pdev == NULL))
+		return -1;
+	pci_stop_and_remove_bus_device(pdev);
+	return 0;
+}
+
+/**
+ * _base_fault_reset_work - workq handling ioc fault conditions
+ * @work: input argument, used to derive ioc
+ * Context: sleep.
+ *
+ * Return nothing.
+ */
+static void
+_base_fault_reset_work(struct work_struct *work)
+{
+	struct MPT3SAS_ADAPTER *ioc =
+	    container_of(work, struct MPT3SAS_ADAPTER, fault_reset_work.work);
+	unsigned long	 flags;
+	u32 doorbell;
+	int rc;
+	struct task_struct *p;
+
+
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->shost_recovery)
+		goto rearm_timer;
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+
+	doorbell = mpt3sas_base_get_iocstate(ioc, 0);
+	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_MASK) {
+		pr_err(MPT3SAS_FMT "SAS host is non-operational !!!!\n",
+		    ioc->name);
+
+		/*
+		 * Call _scsih_flush_pending_cmds callback so that we flush all
+		 * pending commands back to OS. This call is required to aovid
+		 * deadlock at block layer. Dead IOC will fail to do diag reset,
+		 * and this call is safe since dead ioc will never return any
+		 * command back from HW.
+		 */
+		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
+		/*
+		 * Set remove_host flag early since kernel thread will
+		 * take some time to execute.
+		 */
+		ioc->remove_host = 1;
+		/*Remove the Dead Host */
+		p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
+		    "mpt3sas_dead_ioc_%d", ioc->id);
+		if (IS_ERR(p))
+			pr_err(MPT3SAS_FMT
+			"%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
+			ioc->name, __func__);
+		else
+			pr_err(MPT3SAS_FMT
+			"%s: Running mpt3sas_dead_ioc thread success !!!!\n",
+			ioc->name, __func__);
+		return; /* don't rearm timer */
+	}
+
+	if ((doorbell & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL) {
+		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+		pr_warn(MPT3SAS_FMT "%s: hard reset: %s\n", ioc->name,
+		    __func__, (rc == 0) ? "success" : "failed");
+		doorbell = mpt3sas_base_get_iocstate(ioc, 0);
+		if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
+			mpt3sas_base_fault_info(ioc, doorbell &
+			    MPI2_DOORBELL_DATA_MASK);
+		if (rc && (doorbell & MPI2_IOC_STATE_MASK) !=
+		    MPI2_IOC_STATE_OPERATIONAL)
+			return; /* don't rearm timer */
+	}
+
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+ rearm_timer:
+	if (ioc->fault_reset_work_q)
+		queue_delayed_work(ioc->fault_reset_work_q,
+		    &ioc->fault_reset_work,
+		    msecs_to_jiffies(FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+}
+
+/**
+ * mpt3sas_base_start_watchdog - start the fault_reset_work_q
+ * @ioc: per adapter object
+ * Context: sleep.
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
+{
+	unsigned long	 flags;
+
+	if (ioc->fault_reset_work_q)
+		return;
+
+	/* initialize fault polling */
+
+	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
+	snprintf(ioc->fault_reset_work_q_name,
+	    sizeof(ioc->fault_reset_work_q_name), "poll_%d_status", ioc->id);
+	ioc->fault_reset_work_q =
+		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
+	if (!ioc->fault_reset_work_q) {
+		pr_err(MPT3SAS_FMT "%s: failed (line=%d)\n",
+		    ioc->name, __func__, __LINE__);
+			return;
+	}
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	if (ioc->fault_reset_work_q)
+		queue_delayed_work(ioc->fault_reset_work_q,
+		    &ioc->fault_reset_work,
+		    msecs_to_jiffies(FAULT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+}
+
+/**
+ * mpt3sas_base_stop_watchdog - stop the fault_reset_work_q
+ * @ioc: per adapter object
+ * Context: sleep.
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc)
+{
+	unsigned long flags;
+	struct workqueue_struct *wq;
+
+	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
+	wq = ioc->fault_reset_work_q;
+	ioc->fault_reset_work_q = NULL;
+	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
+	if (wq) {
+		if (!cancel_delayed_work(&ioc->fault_reset_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
+/**
+ * mpt3sas_base_fault_info - verbose translation of firmware FAULT code
+ * @ioc: per adapter object
+ * @fault_code: fault code
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc , u16 fault_code)
+{
+	pr_err(MPT3SAS_FMT "fault_state(0x%04x)!\n",
+	    ioc->name, fault_code);
+}
+
+/**
+ * mpt3sas_halt_firmware - halt's mpt controller firmware
+ * @ioc: per adapter object
+ *
+ * For debugging timeout related issues.  Writing 0xCOFFEE00
+ * to the doorbell register will halt controller firmware. With
+ * the purpose to stop both driver and firmware, the enduser can
+ * obtain a ring buffer from controller UART.
+ */
+void
+mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
+{
+	u32 doorbell;
+
+	if (!ioc->fwfault_debug)
+		return;
+
+	dump_stack();
+
+	doorbell = readl(&ioc->chip->Doorbell);
+	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
+		mpt3sas_base_fault_info(ioc , doorbell);
+	else {
+		writel(0xC0FFEE00, &ioc->chip->Doorbell);
+		pr_err(MPT3SAS_FMT "Firmware is halted due to command timeout\n",
+			ioc->name);
+	}
+
+	if (ioc->fwfault_debug == 2)
+		for (;;)
+			;
+	else
+		panic("panic in %s\n", __func__);
+}
+
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+/**
+ * _base_sas_ioc_info - verbose translation of the ioc status
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @request_hdr: request mf
+ *
+ * Return nothing.
+ */
+static void
+_base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
+	MPI2RequestHeader_t *request_hdr)
+{
+	u16 ioc_status = le16_to_cpu(mpi_reply->IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	char *desc = NULL;
+	u16 frame_sz;
+	char *func_str = NULL;
+
+	/* SCSI_IO, RAID_PASS are handled from _scsih_scsi_ioc_info */
+	if (request_hdr->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
+	    request_hdr->Function == MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
+	    request_hdr->Function == MPI2_FUNCTION_EVENT_NOTIFICATION)
+		return;
+
+	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		return;
+
+	switch (ioc_status) {
+
+/****************************************************************************
+*  Common IOCStatus values for all replies
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_INVALID_FUNCTION:
+		desc = "invalid function";
+		break;
+	case MPI2_IOCSTATUS_BUSY:
+		desc = "busy";
+		break;
+	case MPI2_IOCSTATUS_INVALID_SGL:
+		desc = "invalid sgl";
+		break;
+	case MPI2_IOCSTATUS_INTERNAL_ERROR:
+		desc = "internal error";
+		break;
+	case MPI2_IOCSTATUS_INVALID_VPID:
+		desc = "invalid vpid";
+		break;
+	case MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES:
+		desc = "insufficient resources";
+		break;
+	case MPI2_IOCSTATUS_INVALID_FIELD:
+		desc = "invalid field";
+		break;
+	case MPI2_IOCSTATUS_INVALID_STATE:
+		desc = "invalid state";
+		break;
+	case MPI2_IOCSTATUS_OP_STATE_NOT_SUPPORTED:
+		desc = "op state not supported";
+		break;
+
+/****************************************************************************
+*  Config IOCStatus values
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_CONFIG_INVALID_ACTION:
+		desc = "config invalid action";
+		break;
+	case MPI2_IOCSTATUS_CONFIG_INVALID_TYPE:
+		desc = "config invalid type";
+		break;
+	case MPI2_IOCSTATUS_CONFIG_INVALID_PAGE:
+		desc = "config invalid page";
+		break;
+	case MPI2_IOCSTATUS_CONFIG_INVALID_DATA:
+		desc = "config invalid data";
+		break;
+	case MPI2_IOCSTATUS_CONFIG_NO_DEFAULTS:
+		desc = "config no defaults";
+		break;
+	case MPI2_IOCSTATUS_CONFIG_CANT_COMMIT:
+		desc = "config cant commit";
+		break;
+
+/****************************************************************************
+*  SCSI IO Reply
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
+	case MPI2_IOCSTATUS_SCSI_INVALID_DEVHANDLE:
+	case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
+	case MPI2_IOCSTATUS_SCSI_DATA_OVERRUN:
+	case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
+	case MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR:
+	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
+	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
+	case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
+	case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
+	case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
+	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
+		break;
+
+/****************************************************************************
+*  For use by SCSI Initiator and SCSI Target end-to-end data protection
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
+		desc = "eedp guard error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
+		desc = "eedp ref tag error";
+		break;
+	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+		desc = "eedp app tag error";
+		break;
+
+/****************************************************************************
+*  SCSI Target values
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_TARGET_INVALID_IO_INDEX:
+		desc = "target invalid io index";
+		break;
+	case MPI2_IOCSTATUS_TARGET_ABORTED:
+		desc = "target aborted";
+		break;
+	case MPI2_IOCSTATUS_TARGET_NO_CONN_RETRYABLE:
+		desc = "target no conn retryable";
+		break;
+	case MPI2_IOCSTATUS_TARGET_NO_CONNECTION:
+		desc = "target no connection";
+		break;
+	case MPI2_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH:
+		desc = "target xfer count mismatch";
+		break;
+	case MPI2_IOCSTATUS_TARGET_DATA_OFFSET_ERROR:
+		desc = "target data offset error";
+		break;
+	case MPI2_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA:
+		desc = "target too much write data";
+		break;
+	case MPI2_IOCSTATUS_TARGET_IU_TOO_SHORT:
+		desc = "target iu too short";
+		break;
+	case MPI2_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT:
+		desc = "target ack nak timeout";
+		break;
+	case MPI2_IOCSTATUS_TARGET_NAK_RECEIVED:
+		desc = "target nak received";
+		break;
+
+/****************************************************************************
+*  Serial Attached SCSI values
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_SAS_SMP_REQUEST_FAILED:
+		desc = "smp request failed";
+		break;
+	case MPI2_IOCSTATUS_SAS_SMP_DATA_OVERRUN:
+		desc = "smp data overrun";
+		break;
+
+/****************************************************************************
+*  Diagnostic Buffer Post / Diagnostic Release values
+****************************************************************************/
+
+	case MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED:
+		desc = "diagnostic released";
+		break;
+	default:
+		break;
+	}
+
+	if (!desc)
+		return;
+
+	switch (request_hdr->Function) {
+	case MPI2_FUNCTION_CONFIG:
+		frame_sz = sizeof(Mpi2ConfigRequest_t) + ioc->sge_size;
+		func_str = "config_page";
+		break;
+	case MPI2_FUNCTION_SCSI_TASK_MGMT:
+		frame_sz = sizeof(Mpi2SCSITaskManagementRequest_t);
+		func_str = "task_mgmt";
+		break;
+	case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
+		frame_sz = sizeof(Mpi2SasIoUnitControlRequest_t);
+		func_str = "sas_iounit_ctl";
+		break;
+	case MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR:
+		frame_sz = sizeof(Mpi2SepRequest_t);
+		func_str = "enclosure";
+		break;
+	case MPI2_FUNCTION_IOC_INIT:
+		frame_sz = sizeof(Mpi2IOCInitRequest_t);
+		func_str = "ioc_init";
+		break;
+	case MPI2_FUNCTION_PORT_ENABLE:
+		frame_sz = sizeof(Mpi2PortEnableRequest_t);
+		func_str = "port_enable";
+		break;
+	case MPI2_FUNCTION_SMP_PASSTHROUGH:
+		frame_sz = sizeof(Mpi2SmpPassthroughRequest_t) + ioc->sge_size;
+		func_str = "smp_passthru";
+		break;
+	default:
+		frame_sz = 32;
+		func_str = "unknown";
+		break;
+	}
+
+	pr_warn(MPT3SAS_FMT "ioc_status: %s(0x%04x), request(0x%p),(%s)\n",
+		ioc->name, desc, ioc_status, request_hdr, func_str);
+
+	_debug_dump_mf(request_hdr, frame_sz/4);
+}
+
+/**
+ * _base_display_event_data - verbose translation of firmware asyn events
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ *
+ * Return nothing.
+ */
+static void
+_base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventNotificationReply_t *mpi_reply)
+{
+	char *desc = NULL;
+	u16 event;
+
+	if (!(ioc->logging_level & MPT_DEBUG_EVENTS))
+		return;
+
+	event = le16_to_cpu(mpi_reply->Event);
+
+	switch (event) {
+	case MPI2_EVENT_LOG_DATA:
+		desc = "Log Data";
+		break;
+	case MPI2_EVENT_STATE_CHANGE:
+		desc = "Status Change";
+		break;
+	case MPI2_EVENT_HARD_RESET_RECEIVED:
+		desc = "Hard Reset Received";
+		break;
+	case MPI2_EVENT_EVENT_CHANGE:
+		desc = "Event Change";
+		break;
+	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
+		desc = "Device Status Change";
+		break;
+	case MPI2_EVENT_IR_OPERATION_STATUS:
+		desc = "IR Operation Status";
+		break;
+	case MPI2_EVENT_SAS_DISCOVERY:
+	{
+		Mpi2EventDataSasDiscovery_t *event_data =
+		    (Mpi2EventDataSasDiscovery_t *)mpi_reply->EventData;
+		pr_info(MPT3SAS_FMT "Discovery: (%s)", ioc->name,
+		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
+		    "start" : "stop");
+		if (event_data->DiscoveryStatus)
+			pr_info("discovery_status(0x%08x)",
+			    le32_to_cpu(event_data->DiscoveryStatus));
+			pr_info("\n");
+		return;
+	}
+	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
+		desc = "SAS Broadcast Primitive";
+		break;
+	case MPI2_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
+		desc = "SAS Init Device Status Change";
+		break;
+	case MPI2_EVENT_SAS_INIT_TABLE_OVERFLOW:
+		desc = "SAS Init Table Overflow";
+		break;
+	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+		desc = "SAS Topology Change List";
+		break;
+	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
+		desc = "SAS Enclosure Device Status Change";
+		break;
+	case MPI2_EVENT_IR_VOLUME:
+		desc = "IR Volume";
+		break;
+	case MPI2_EVENT_IR_PHYSICAL_DISK:
+		desc = "IR Physical Disk";
+		break;
+	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
+		desc = "IR Configuration Change List";
+		break;
+	case MPI2_EVENT_LOG_ENTRY_ADDED:
+		desc = "Log Entry Added";
+		break;
+	}
+
+	if (!desc)
+		return;
+
+	pr_info(MPT3SAS_FMT "%s\n", ioc->name, desc);
+}
+#endif
+
+/**
+ * _base_sas_log_info - verbose translation of firmware log info
+ * @ioc: per adapter object
+ * @log_info: log info
+ *
+ * Return nothing.
+ */
+static void
+_base_sas_log_info(struct MPT3SAS_ADAPTER *ioc , u32 log_info)
+{
+	union loginfo_type {
+		u32	loginfo;
+		struct {
+			u32	subcode:16;
+			u32	code:8;
+			u32	originator:4;
+			u32	bus_type:4;
+		} dw;
+	};
+	union loginfo_type sas_loginfo;
+	char *originator_str = NULL;
+
+	sas_loginfo.loginfo = log_info;
+	if (sas_loginfo.dw.bus_type != 3 /*SAS*/)
+		return;
+
+	/* each nexus loss loginfo */
+	if (log_info == 0x31170000)
+		return;
+
+	/* eat the loginfos associated with task aborts */
+	if (ioc->ignore_loginfos && (log_info == 0x30050000 || log_info ==
+	    0x31140000 || log_info == 0x31130000))
+		return;
+
+	switch (sas_loginfo.dw.originator) {
+	case 0:
+		originator_str = "IOP";
+		break;
+	case 1:
+		originator_str = "PL";
+		break;
+	case 2:
+		originator_str = "IR";
+		break;
+	}
+
+	pr_warn(MPT3SAS_FMT
+		"log_info(0x%08x): originator(%s), code(0x%02x), sub_code(0x%04x)\n",
+		ioc->name, log_info,
+	     originator_str, sas_loginfo.dw.code,
+	     sas_loginfo.dw.subcode);
+}
+
+/**
+ * _base_display_reply_info -
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ *
+ * Return nothing.
+ */
+static void
+_base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+	u32 reply)
+{
+	MPI2DefaultReply_t *mpi_reply;
+	u16 ioc_status;
+	u32 loginfo = 0;
+
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	if (unlikely(!mpi_reply)) {
+		pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
+	    (ioc->logging_level & MPT_DEBUG_REPLY)) {
+		_base_sas_ioc_info(ioc , mpi_reply,
+		   mpt3sas_base_get_msg_frame(ioc, smid));
+	}
+#endif
+	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
+		loginfo = le32_to_cpu(mpi_reply->IOCLogInfo);
+		_base_sas_log_info(ioc, loginfo);
+	}
+
+	if (ioc_status || loginfo) {
+		ioc_status &= MPI2_IOCSTATUS_MASK;
+		mpt3sas_trigger_mpi(ioc, ioc_status, loginfo);
+	}
+}
+
+/**
+ * mpt3sas_base_done - base internal command completion routine
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+u8
+mpt3sas_base_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
+	u32 reply)
+{
+	MPI2DefaultReply_t *mpi_reply;
+
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	if (mpi_reply && mpi_reply->Function == MPI2_FUNCTION_EVENT_ACK)
+		return 1;
+
+	if (ioc->base_cmds.status == MPT3_CMD_NOT_USED)
+		return 1;
+
+	ioc->base_cmds.status |= MPT3_CMD_COMPLETE;
+	if (mpi_reply) {
+		ioc->base_cmds.status |= MPT3_CMD_REPLY_VALID;
+		memcpy(ioc->base_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+	}
+	ioc->base_cmds.status &= ~MPT3_CMD_PENDING;
+
+	complete(&ioc->base_cmds.done);
+	return 1;
+}
+
+/**
+ * _base_async_event - main callback handler for firmware asyn events
+ * @ioc: per adapter object
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
+{
+	Mpi2EventNotificationReply_t *mpi_reply;
+	Mpi2EventAckRequest_t *ack_request;
+	u16 smid;
+
+	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	if (!mpi_reply)
+		return 1;
+	if (mpi_reply->Function != MPI2_FUNCTION_EVENT_NOTIFICATION)
+		return 1;
+#ifdef CONFIG_SCSI_MPT3SAS_LOGGING
+	_base_display_event_data(ioc, mpi_reply);
+#endif
+	if (!(mpi_reply->AckRequired & MPI2_EVENT_NOTIFICATION_ACK_REQUIRED))
+		goto out;
+	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		goto out;
+	}
+
+	ack_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	memset(ack_request, 0, sizeof(Mpi2EventAckRequest_t));
+	ack_request->Function = MPI2_FUNCTION_EVENT_ACK;
+	ack_request->Event = mpi_reply->Event;
+	ack_request->EventContext = mpi_reply->EventContext;
+	ack_request->VF_ID = 0;  /* TODO */
+	ack_request->VP_ID = 0;
+	mpt3sas_base_put_smid_default(ioc, smid);
+
+ out:
+
+	/* scsih callback handler */
+	mpt3sas_scsih_event_callback(ioc, msix_index, reply);
+
+	/* ctl callback handler */
+	mpt3sas_ctl_event_callback(ioc, msix_index, reply);
+
+	return 1;
+}
+
+/**
+ * _base_get_cb_idx - obtain the callback index
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return callback index.
+ */
+static u8
+_base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	int i;
+	u8 cb_idx;
+
+	if (smid < ioc->hi_priority_smid) {
+		i = smid - 1;
+		cb_idx = ioc->scsi_lookup[i].cb_idx;
+	} else if (smid < ioc->internal_smid) {
+		i = smid - ioc->hi_priority_smid;
+		cb_idx = ioc->hpr_lookup[i].cb_idx;
+	} else if (smid <= ioc->hba_queue_depth) {
+		i = smid - ioc->internal_smid;
+		cb_idx = ioc->internal_lookup[i].cb_idx;
+	} else
+		cb_idx = 0xFF;
+	return cb_idx;
+}
+
+/**
+ * _base_mask_interrupts - disable interrupts
+ * @ioc: per adapter object
+ *
+ * Disabling ResetIRQ, Reply and Doorbell Interrupts
+ *
+ * Return nothing.
+ */
+static void
+_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
+{
+	u32 him_register;
+
+	ioc->mask_interrupts = 1;
+	him_register = readl(&ioc->chip->HostInterruptMask);
+	him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + MPI2_HIM_RESET_IRQ_MASK;
+	writel(him_register, &ioc->chip->HostInterruptMask);
+	readl(&ioc->chip->HostInterruptMask);
+}
+
+/**
+ * _base_unmask_interrupts - enable interrupts
+ * @ioc: per adapter object
+ *
+ * Enabling only Reply Interrupts
+ *
+ * Return nothing.
+ */
+static void
+_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
+{
+	u32 him_register;
+
+	him_register = readl(&ioc->chip->HostInterruptMask);
+	him_register &= ~MPI2_HIM_RIM;
+	writel(him_register, &ioc->chip->HostInterruptMask);
+	ioc->mask_interrupts = 0;
+}
+
+union reply_descriptor {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
+/**
+ * _base_interrupt - MPT adapter (IOC) specific interrupt handler.
+ * @irq: irq number (not used)
+ * @bus_id: bus identifier cookie == pointer to MPT_ADAPTER structure
+ * @r: pt_regs pointer (not used)
+ *
+ * Return IRQ_HANDLE if processed, else IRQ_NONE.
+ */
+static irqreturn_t
+_base_interrupt(int irq, void *bus_id)
+{
+	struct adapter_reply_queue *reply_q = bus_id;
+	union reply_descriptor rd;
+	u32 completed_cmds;
+	u8 request_desript_type;
+	u16 smid;
+	u8 cb_idx;
+	u32 reply;
+	u8 msix_index = reply_q->msix_index;
+	struct MPT3SAS_ADAPTER *ioc = reply_q->ioc;
+	Mpi2ReplyDescriptorsUnion_t *rpf;
+	u8 rc;
+
+	if (ioc->mask_interrupts)
+		return IRQ_NONE;
+
+	if (!atomic_add_unless(&reply_q->busy, 1, 1))
+		return IRQ_NONE;
+
+	rpf = &reply_q->reply_post_free[reply_q->reply_post_host_index];
+	request_desript_type = rpf->Default.ReplyFlags
+	     & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+	if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
+		atomic_dec(&reply_q->busy);
+		return IRQ_NONE;
+	}
+
+	completed_cmds = 0;
+	cb_idx = 0xFF;
+	do {
+		rd.word = le64_to_cpu(rpf->Words);
+		if (rd.u.low == UINT_MAX || rd.u.high == UINT_MAX)
+			goto out;
+		reply = 0;
+		smid = le16_to_cpu(rpf->Default.DescriptorTypeDependent1);
+		if (request_desript_type ==
+		    MPI25_RPY_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO_SUCCESS ||
+		    request_desript_type ==
+		    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
+			cb_idx = _base_get_cb_idx(ioc, smid);
+			if ((likely(cb_idx < MPT_MAX_CALLBACKS)) &&
+			    (likely(mpt_callbacks[cb_idx] != NULL))) {
+				rc = mpt_callbacks[cb_idx](ioc, smid,
+				    msix_index, 0);
+				if (rc)
+					mpt3sas_base_free_smid(ioc, smid);
+			}
+		} else if (request_desript_type ==
+		    MPI2_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
+			reply = le32_to_cpu(
+			    rpf->AddressReply.ReplyFrameAddress);
+			if (reply > ioc->reply_dma_max_address ||
+			    reply < ioc->reply_dma_min_address)
+				reply = 0;
+			if (smid) {
+				cb_idx = _base_get_cb_idx(ioc, smid);
+				if ((likely(cb_idx < MPT_MAX_CALLBACKS)) &&
+				    (likely(mpt_callbacks[cb_idx] != NULL))) {
+					rc = mpt_callbacks[cb_idx](ioc, smid,
+					    msix_index, reply);
+					if (reply)
+						_base_display_reply_info(ioc,
+						    smid, msix_index, reply);
+					if (rc)
+						mpt3sas_base_free_smid(ioc,
+						    smid);
+				}
+			} else {
+				_base_async_event(ioc, msix_index, reply);
+			}
+
+			/* reply free queue handling */
+			if (reply) {
+				ioc->reply_free_host_index =
+				    (ioc->reply_free_host_index ==
+				    (ioc->reply_free_queue_depth - 1)) ?
+				    0 : ioc->reply_free_host_index + 1;
+				ioc->reply_free[ioc->reply_free_host_index] =
+				    cpu_to_le32(reply);
+				wmb();
+				writel(ioc->reply_free_host_index,
+				    &ioc->chip->ReplyFreeHostIndex);
+			}
+		}
+
+		rpf->Words = cpu_to_le64(ULLONG_MAX);
+		reply_q->reply_post_host_index =
+		    (reply_q->reply_post_host_index ==
+		    (ioc->reply_post_queue_depth - 1)) ? 0 :
+		    reply_q->reply_post_host_index + 1;
+		request_desript_type =
+		    reply_q->reply_post_free[reply_q->reply_post_host_index].
+		    Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+		completed_cmds++;
+		if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+			goto out;
+		if (!reply_q->reply_post_host_index)
+			rpf = reply_q->reply_post_free;
+		else
+			rpf++;
+	} while (1);
+
+ out:
+
+	if (!completed_cmds) {
+		atomic_dec(&reply_q->busy);
+		return IRQ_NONE;
+	}
+
+	wmb();
+	writel(reply_q->reply_post_host_index | (msix_index <<
+	    MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostIndex);
+	atomic_dec(&reply_q->busy);
+	return IRQ_HANDLED;
+}
+
+/**
+ * _base_is_controller_msix_enabled - is controller support muli-reply queues
+ * @ioc: per adapter object
+ *
+ */
+static inline int
+_base_is_controller_msix_enabled(struct MPT3SAS_ADAPTER *ioc)
+{
+	return (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_MSI_X_INDEX) && ioc->msix_enable;
+}
+
+/**
+ * mpt3sas_base_flush_reply_queues - flushing the MSIX reply queues
+ * @ioc: per adapter object
+ * Context: ISR conext
+ *
+ * Called when a Task Management request has completed. We want
+ * to flush the other reply queues so all the outstanding IO has been
+ * completed back to OS before we process the TM completetion.
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_flush_reply_queues(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct adapter_reply_queue *reply_q;
+
+	/* If MSIX capability is turned off
+	 * then multi-queues are not enabled
+	 */
+	if (!_base_is_controller_msix_enabled(ioc))
+		return;
+
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+		if (ioc->shost_recovery)
+			return;
+		/* TMs are on msix_index == 0 */
+		if (reply_q->msix_index == 0)
+			continue;
+		_base_interrupt(reply_q->vector, (void *)reply_q);
+	}
+}
+
+/**
+ * mpt3sas_base_release_callback_handler - clear interrupt callback handler
+ * @cb_idx: callback index
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_release_callback_handler(u8 cb_idx)
+{
+	mpt_callbacks[cb_idx] = NULL;
+}
+
+/**
+ * mpt3sas_base_register_callback_handler - obtain index for the interrupt callback handler
+ * @cb_func: callback function
+ *
+ * Returns cb_func.
+ */
+u8
+mpt3sas_base_register_callback_handler(MPT_CALLBACK cb_func)
+{
+	u8 cb_idx;
+
+	for (cb_idx = MPT_MAX_CALLBACKS-1; cb_idx; cb_idx--)
+		if (mpt_callbacks[cb_idx] == NULL)
+			break;
+
+	mpt_callbacks[cb_idx] = cb_func;
+	return cb_idx;
+}
+
+/**
+ * mpt3sas_base_initialize_callback_handler - initialize the interrupt callback handler
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_initialize_callback_handler(void)
+{
+	u8 cb_idx;
+
+	for (cb_idx = 0; cb_idx < MPT_MAX_CALLBACKS; cb_idx++)
+		mpt3sas_base_release_callback_handler(cb_idx);
+}
+
+
+/**
+ * _base_build_zero_len_sge - build zero length sg entry
+ * @ioc: per adapter object
+ * @paddr: virtual address for SGE
+ *
+ * Create a zero length scatter gather entry to insure the IOCs hardware has
+ * something to use if the target device goes brain dead and tries
+ * to send data even when none is asked for.
+ *
+ * Return nothing.
+ */
+static void
+_base_build_zero_len_sge(struct MPT3SAS_ADAPTER *ioc, void *paddr)
+{
+	u32 flags_length = (u32)((MPI2_SGE_FLAGS_LAST_ELEMENT |
+	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_END_OF_LIST |
+	    MPI2_SGE_FLAGS_SIMPLE_ELEMENT) <<
+	    MPI2_SGE_FLAGS_SHIFT);
+	ioc->base_add_sg_single(paddr, flags_length, -1);
+}
+
+/**
+ * _base_add_sg_single_32 - Place a simple 32 bit SGE at address pAddr.
+ * @paddr: virtual address for SGE
+ * @flags_length: SGE flags and data transfer length
+ * @dma_addr: Physical address
+ *
+ * Return nothing.
+ */
+static void
+_base_add_sg_single_32(void *paddr, u32 flags_length, dma_addr_t dma_addr)
+{
+	Mpi2SGESimple32_t *sgel = paddr;
+
+	flags_length |= (MPI2_SGE_FLAGS_32_BIT_ADDRESSING |
+	    MPI2_SGE_FLAGS_SYSTEM_ADDRESS) << MPI2_SGE_FLAGS_SHIFT;
+	sgel->FlagsLength = cpu_to_le32(flags_length);
+	sgel->Address = cpu_to_le32(dma_addr);
+}
+
+
+/**
+ * _base_add_sg_single_64 - Place a simple 64 bit SGE at address pAddr.
+ * @paddr: virtual address for SGE
+ * @flags_length: SGE flags and data transfer length
+ * @dma_addr: Physical address
+ *
+ * Return nothing.
+ */
+static void
+_base_add_sg_single_64(void *paddr, u32 flags_length, dma_addr_t dma_addr)
+{
+	Mpi2SGESimple64_t *sgel = paddr;
+
+	flags_length |= (MPI2_SGE_FLAGS_64_BIT_ADDRESSING |
+	    MPI2_SGE_FLAGS_SYSTEM_ADDRESS) << MPI2_SGE_FLAGS_SHIFT;
+	sgel->FlagsLength = cpu_to_le32(flags_length);
+	sgel->Address = cpu_to_le64(dma_addr);
+}
+
+/**
+ * _base_get_chain_buffer_tracker - obtain chain tracker
+ * @ioc: per adapter object
+ * @smid: smid associated to an IO request
+ *
+ * Returns chain tracker(from ioc->free_chain_list)
+ */
+static struct chain_tracker *
+_base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	struct chain_tracker *chain_req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->free_chain_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+			"chain buffers not available\n", ioc->name));
+		return NULL;
+	}
+	chain_req = list_entry(ioc->free_chain_list.next,
+	    struct chain_tracker, tracker_list);
+	list_del_init(&chain_req->tracker_list);
+	list_add_tail(&chain_req->tracker_list,
+	    &ioc->scsi_lookup[smid - 1].chain_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return chain_req;
+}
+
+
+/**
+ * _base_build_sg - build generic sg
+ * @ioc: per adapter object
+ * @psge: virtual address for SGE
+ * @data_out_dma: physical address for WRITES
+ * @data_out_sz: data xfer size for WRITES
+ * @data_in_dma: physical address for READS
+ * @data_in_sz: data xfer size for READS
+ *
+ * Return nothing.
+ */
+static void
+_base_build_sg(struct MPT3SAS_ADAPTER *ioc, void *psge,
+	dma_addr_t data_out_dma, size_t data_out_sz, dma_addr_t data_in_dma,
+	size_t data_in_sz)
+{
+	u32 sgl_flags;
+
+	if (!data_out_sz && !data_in_sz) {
+		_base_build_zero_len_sge(ioc, psge);
+		return;
+	}
+
+	if (data_out_sz && data_in_sz) {
+		/* WRITE sgel first */
+		sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
+		sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    data_out_sz, data_out_dma);
+
+		/* incr sgel */
+		psge += ioc->sge_size;
+
+		/* READ sgel last */
+		sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
+		    MPI2_SGE_FLAGS_END_OF_LIST);
+		sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    data_in_sz, data_in_dma);
+	} else if (data_out_sz) /* WRITE */ {
+		sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
+		    MPI2_SGE_FLAGS_END_OF_LIST | MPI2_SGE_FLAGS_HOST_TO_IOC);
+		sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    data_out_sz, data_out_dma);
+	} else if (data_in_sz) /* READ */ {
+		sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
+		    MPI2_SGE_FLAGS_END_OF_LIST);
+		sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    data_in_sz, data_in_dma);
+	}
+}
+
+/* IEEE format sgls */
+
+/**
+ * _base_add_sg_single_ieee - add sg element for IEEE format
+ * @paddr: virtual address for SGE
+ * @flags: SGE flags
+ * @chain_offset: number of 128 byte elements from start of segment
+ * @length: data transfer length
+ * @dma_addr: Physical address
+ *
+ * Return nothing.
+ */
+static void
+_base_add_sg_single_ieee(void *paddr, u8 flags, u8 chain_offset, u32 length,
+	dma_addr_t dma_addr)
+{
+	Mpi25IeeeSgeChain64_t *sgel = paddr;
+
+	sgel->Flags = flags;
+	sgel->NextChainOffset = chain_offset;
+	sgel->Length = cpu_to_le32(length);
+	sgel->Address = cpu_to_le64(dma_addr);
+}
+
+/**
+ * _base_build_zero_len_sge_ieee - build zero length sg entry for IEEE format
+ * @ioc: per adapter object
+ * @paddr: virtual address for SGE
+ *
+ * Create a zero length scatter gather entry to insure the IOCs hardware has
+ * something to use if the target device goes brain dead and tries
+ * to send data even when none is asked for.
+ *
+ * Return nothing.
+ */
+static void
+_base_build_zero_len_sge_ieee(struct MPT3SAS_ADAPTER *ioc, void *paddr)
+{
+	u8 sgl_flags = (MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
+		MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR |
+		MPI25_IEEE_SGE_FLAGS_END_OF_LIST);
+	_base_add_sg_single_ieee(paddr, sgl_flags, 0, 0, -1);
+}
+
+/**
+ * _base_build_sg_scmd_ieee - main sg creation routine for IEEE format
+ * @ioc: per adapter object
+ * @scmd: scsi command
+ * @smid: system request message index
+ * Context: none.
+ *
+ * The main routine that builds scatter gather table from a given
+ * scsi request sent via the .queuecommand main handler.
+ *
+ * Returns 0 success, anything else error
+ */
+static int
+_base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
+	struct scsi_cmnd *scmd, u16 smid)
+{
+	Mpi2SCSIIORequest_t *mpi_request;
+	dma_addr_t chain_dma;
+	struct scatterlist *sg_scmd;
+	void *sg_local, *chain;
+	u32 chain_offset;
+	u32 chain_length;
+	u32 chain_flags;
+	int sges_left;
+	u32 sges_in_segment;
+	u8 simple_sgl_flags;
+	u8 simple_sgl_flags_last;
+	u8 chain_sgl_flags;
+	struct chain_tracker *chain_req;
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+	/* init scatter gather flags */
+	simple_sgl_flags = MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
+	    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
+	simple_sgl_flags_last = simple_sgl_flags |
+	    MPI25_IEEE_SGE_FLAGS_END_OF_LIST;
+	chain_sgl_flags = MPI2_IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+	    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
+
+	sg_scmd = scsi_sglist(scmd);
+	sges_left = scsi_dma_map(scmd);
+	if (!sges_left) {
+		sdev_printk(KERN_ERR, scmd->device,
+			"pci_map_sg failed: request for %d bytes!\n",
+			scsi_bufflen(scmd));
+		return -ENOMEM;
+	}
+
+	sg_local = &mpi_request->SGL;
+	sges_in_segment = (ioc->request_sz -
+	    offsetof(Mpi2SCSIIORequest_t, SGL))/ioc->sge_size_ieee;
+	if (sges_left <= sges_in_segment)
+		goto fill_in_last_segment;
+
+	mpi_request->ChainOffset = (sges_in_segment - 1 /* chain element */) +
+	    (offsetof(Mpi2SCSIIORequest_t, SGL)/ioc->sge_size_ieee);
+
+	/* fill in main message segment when there is a chain following */
+	while (sges_in_segment > 1) {
+		_base_add_sg_single_ieee(sg_local, simple_sgl_flags, 0,
+		    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+		sg_scmd = sg_next(sg_scmd);
+		sg_local += ioc->sge_size_ieee;
+		sges_left--;
+		sges_in_segment--;
+	}
+
+	/* initializing the chain flags and pointers */
+	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
+	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+	if (!chain_req)
+		return -1;
+	chain = chain_req->chain_buffer;
+	chain_dma = chain_req->chain_buffer_dma;
+	do {
+		sges_in_segment = (sges_left <=
+		    ioc->max_sges_in_chain_message) ? sges_left :
+		    ioc->max_sges_in_chain_message;
+		chain_offset = (sges_left == sges_in_segment) ?
+		    0 : sges_in_segment;
+		chain_length = sges_in_segment * ioc->sge_size_ieee;
+		if (chain_offset)
+			chain_length += ioc->sge_size_ieee;
+		_base_add_sg_single_ieee(sg_local, chain_sgl_flags,
+		    chain_offset, chain_length, chain_dma);
+
+		sg_local = chain;
+		if (!chain_offset)
+			goto fill_in_last_segment;
+
+		/* fill in chain segments */
+		while (sges_in_segment) {
+			_base_add_sg_single_ieee(sg_local, simple_sgl_flags, 0,
+			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+			sg_scmd = sg_next(sg_scmd);
+			sg_local += ioc->sge_size_ieee;
+			sges_left--;
+			sges_in_segment--;
+		}
+
+		chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+		if (!chain_req)
+			return -1;
+		chain = chain_req->chain_buffer;
+		chain_dma = chain_req->chain_buffer_dma;
+	} while (1);
+
+
+ fill_in_last_segment:
+
+	/* fill the last segment */
+	while (sges_left) {
+		if (sges_left == 1)
+			_base_add_sg_single_ieee(sg_local,
+			    simple_sgl_flags_last, 0, sg_dma_len(sg_scmd),
+			    sg_dma_address(sg_scmd));
+		else
+			_base_add_sg_single_ieee(sg_local, simple_sgl_flags, 0,
+			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+		sg_scmd = sg_next(sg_scmd);
+		sg_local += ioc->sge_size_ieee;
+		sges_left--;
+	}
+
+	return 0;
+}
+
+/**
+ * _base_build_sg_ieee - build generic sg for IEEE format
+ * @ioc: per adapter object
+ * @psge: virtual address for SGE
+ * @data_out_dma: physical address for WRITES
+ * @data_out_sz: data xfer size for WRITES
+ * @data_in_dma: physical address for READS
+ * @data_in_sz: data xfer size for READS
+ *
+ * Return nothing.
+ */
+static void
+_base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
+	dma_addr_t data_out_dma, size_t data_out_sz, dma_addr_t data_in_dma,
+	size_t data_in_sz)
+{
+	u8 sgl_flags;
+
+	if (!data_out_sz && !data_in_sz) {
+		_base_build_zero_len_sge_ieee(ioc, psge);
+		return;
+	}
+
+	if (data_out_sz && data_in_sz) {
+		/* WRITE sgel first */
+		sgl_flags = MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
+		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_out_sz,
+		    data_out_dma);
+
+		/* incr sgel */
+		psge += ioc->sge_size_ieee;
+
+		/* READ sgel last */
+		sgl_flags |= MPI25_IEEE_SGE_FLAGS_END_OF_LIST;
+		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_in_sz,
+		    data_in_dma);
+	} else if (data_out_sz) /* WRITE */ {
+		sgl_flags = MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI25_IEEE_SGE_FLAGS_END_OF_LIST |
+		    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
+		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_out_sz,
+		    data_out_dma);
+	} else if (data_in_sz) /* READ */ {
+		sgl_flags = MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
+		    MPI25_IEEE_SGE_FLAGS_END_OF_LIST |
+		    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
+		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_in_sz,
+		    data_in_dma);
+	}
+}
+
+#define convert_to_kb(x) ((x) << (PAGE_SHIFT - 10))
+
+/**
+ * _base_config_dma_addressing - set dma addressing
+ * @ioc: per adapter object
+ * @pdev: PCI device struct
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
+{
+	struct sysinfo s;
+	char *desc = NULL;
+
+	if (sizeof(dma_addr_t) > 4) {
+		const uint64_t required_mask =
+		    dma_get_required_mask(&pdev->dev);
+		if ((required_mask > DMA_BIT_MASK(32)) &&
+		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+		    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+			ioc->base_add_sg_single = &_base_add_sg_single_64;
+			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+			desc = "64";
+			goto out;
+		}
+	}
+
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+		ioc->base_add_sg_single = &_base_add_sg_single_32;
+		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
+		desc = "32";
+	} else
+		return -ENODEV;
+
+ out:
+	si_meminfo(&s);
+	pr_info(MPT3SAS_FMT
+		"%s BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
+		ioc->name, desc, convert_to_kb(s.totalram));
+
+	return 0;
+}
+
+/**
+ * _base_check_enable_msix - checks MSIX capabable.
+ * @ioc: per adapter object
+ *
+ * Check to see if card is capable of MSIX, and set number
+ * of available msix vectors
+ */
+static int
+_base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
+{
+	int base;
+	u16 message_control;
+
+	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
+	if (!base) {
+		dfailprintk(ioc, pr_info(MPT3SAS_FMT "msix not supported\n",
+			ioc->name));
+		return -EINVAL;
+	}
+
+	/* get msix vector count */
+
+	pci_read_config_word(ioc->pdev, base + 2, &message_control);
+	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
+	if (ioc->msix_vector_count > 8)
+		ioc->msix_vector_count = 8;
+	dinitprintk(ioc, pr_info(MPT3SAS_FMT
+		"msix is supported, vector_count(%d)\n",
+		ioc->name, ioc->msix_vector_count));
+	return 0;
+}
+
+/**
+ * _base_free_irq - free irq
+ * @ioc: per adapter object
+ *
+ * Freeing respective reply_queue from the list.
+ */
+static void
+_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct adapter_reply_queue *reply_q, *next;
+
+	if (list_empty(&ioc->reply_queue_list))
+		return;
+
+	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
+		list_del(&reply_q->list);
+		synchronize_irq(reply_q->vector);
+		free_irq(reply_q->vector, reply_q);
+		kfree(reply_q);
+	}
+}
+
+/**
+ * _base_request_irq - request irq
+ * @ioc: per adapter object
+ * @index: msix index into vector table
+ * @vector: irq vector
+ *
+ * Inserting respective reply_queue into the list.
+ */
+static int
+_base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
+{
+	struct adapter_reply_queue *reply_q;
+	int r;
+
+	reply_q =  kzalloc(sizeof(struct adapter_reply_queue), GFP_KERNEL);
+	if (!reply_q) {
+		pr_err(MPT3SAS_FMT "unable to allocate memory %d!\n",
+		    ioc->name, (int)sizeof(struct adapter_reply_queue));
+		return -ENOMEM;
+	}
+	reply_q->ioc = ioc;
+	reply_q->msix_index = index;
+	reply_q->vector = vector;
+	atomic_set(&reply_q->busy, 0);
+	if (ioc->msix_enable)
+		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
+		    MPT3SAS_DRIVER_NAME, ioc->id, index);
+	else
+		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
+		    MPT3SAS_DRIVER_NAME, ioc->id);
+	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
+	    reply_q);
+	if (r) {
+		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
+		    reply_q->name, vector);
+		kfree(reply_q);
+		return -EBUSY;
+	}
+
+	INIT_LIST_HEAD(&reply_q->list);
+	list_add_tail(&reply_q->list, &ioc->reply_queue_list);
+	return 0;
+}
+
+/**
+ * _base_assign_reply_queues - assigning msix index for each cpu
+ * @ioc: per adapter object
+ *
+ * The enduser would need to set the affinity via /proc/irq/#/smp_affinity
+ *
+ * It would nice if we could call irq_set_affinity, however it is not
+ * an exported symbol
+ */
+static void
+_base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct adapter_reply_queue *reply_q;
+	int cpu_id;
+	int cpu_grouping, loop, grouping, grouping_mod;
+	int reply_queue;
+
+	if (!_base_is_controller_msix_enabled(ioc))
+		return;
+
+	memset(ioc->cpu_msix_table, 0, ioc->cpu_msix_table_sz);
+
+	/* NUMA Hardware bug workaround - drop to less reply queues */
+	if (ioc->reply_queue_count > ioc->facts.MaxMSIxVectors) {
+		ioc->reply_queue_count = ioc->facts.MaxMSIxVectors;
+		reply_queue = 0;
+		list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+			reply_q->msix_index = reply_queue;
+			if (++reply_queue == ioc->reply_queue_count)
+				reply_queue = 0;
+		}
+	}
+
+	/* when there are more cpus than available msix vectors,
+	 * then group cpus togeather on same irq
+	 */
+	if (ioc->cpu_count > ioc->msix_vector_count) {
+		grouping = ioc->cpu_count / ioc->msix_vector_count;
+		grouping_mod = ioc->cpu_count % ioc->msix_vector_count;
+		if (grouping < 2 || (grouping == 2 && !grouping_mod))
+			cpu_grouping = 2;
+		else if (grouping < 4 || (grouping == 4 && !grouping_mod))
+			cpu_grouping = 4;
+		else if (grouping < 8 || (grouping == 8 && !grouping_mod))
+			cpu_grouping = 8;
+		else
+			cpu_grouping = 16;
+	} else
+		cpu_grouping = 0;
+
+	loop = 0;
+	reply_q = list_entry(ioc->reply_queue_list.next,
+	     struct adapter_reply_queue, list);
+	for_each_online_cpu(cpu_id) {
+		if (!cpu_grouping) {
+			ioc->cpu_msix_table[cpu_id] = reply_q->msix_index;
+			reply_q = list_entry(reply_q->list.next,
+			    struct adapter_reply_queue, list);
+		} else {
+			if (loop < cpu_grouping) {
+				ioc->cpu_msix_table[cpu_id] =
+				    reply_q->msix_index;
+				loop++;
+			} else {
+				reply_q = list_entry(reply_q->list.next,
+				    struct adapter_reply_queue, list);
+				ioc->cpu_msix_table[cpu_id] =
+				    reply_q->msix_index;
+				loop = 1;
+			}
+		}
+	}
+}
+
+/**
+ * _base_disable_msix - disables msix
+ * @ioc: per adapter object
+ *
+ */
+static void
+_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
+{
+	if (!ioc->msix_enable)
+		return;
+	pci_disable_msix(ioc->pdev);
+	ioc->msix_enable = 0;
+}
+
+/**
+ * _base_enable_msix - enables msix, failback to io_apic
+ * @ioc: per adapter object
+ *
+ */
+static int
+_base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct msix_entry *entries, *a;
+	int r;
+	int i;
+	u8 try_msix = 0;
+
+	INIT_LIST_HEAD(&ioc->reply_queue_list);
+
+	if (msix_disable == -1 || msix_disable == 0)
+		try_msix = 1;
+
+	if (!try_msix)
+		goto try_ioapic;
+
+	if (_base_check_enable_msix(ioc) != 0)
+		goto try_ioapic;
+
+	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
+	    ioc->msix_vector_count);
+
+	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
+	    GFP_KERNEL);
+	if (!entries) {
+		dfailprintk(ioc, pr_info(MPT3SAS_FMT
+			"kcalloc failed @ at %s:%d/%s() !!!\n",
+			ioc->name, __FILE__, __LINE__, __func__));
+		goto try_ioapic;
+	}
+
+	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
+		a->entry = i;
+
+	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
+	if (r) {
+		dfailprintk(ioc, pr_info(MPT3SAS_FMT
+			"pci_enable_msix failed (r=%d) !!!\n",
+			ioc->name, r));
+		kfree(entries);
+		goto try_ioapic;
+	}
+
+	ioc->msix_enable = 1;
+	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++) {
+		r = _base_request_irq(ioc, i, a->vector);
+		if (r) {
+			_base_free_irq(ioc);
+			_base_disable_msix(ioc);
+			kfree(entries);
+			goto try_ioapic;
+		}
+	}
+
+	kfree(entries);
+	return 0;
+
+/* failback to io_apic interrupt routing */
+ try_ioapic:
+
+	r = _base_request_irq(ioc, 0, ioc->pdev->irq);
+
+	return r;
+}
+
+/**
+ * mpt3sas_base_map_resources - map in controller resources (io/irq/memap)
+ * @ioc: per adapter object
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct pci_dev *pdev = ioc->pdev;
+	u32 memap_sz;
+	u32 pio_sz;
+	int i, r = 0;
+	u64 pio_chip = 0;
+	u64 chip_phys = 0;
+	struct adapter_reply_queue *reply_q;
+
+	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n",
+	    ioc->name, __func__));
+
+	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	if (pci_enable_device_mem(pdev)) {
+		pr_warn(MPT3SAS_FMT "pci_enable_device_mem: failed\n",
+			ioc->name);
+		return -ENODEV;
+	}
+
+
+	if (pci_request_selected_regions(pdev, ioc->bars,
+	    MPT3SAS_DRIVER_NAME)) {
+		pr_warn(MPT3SAS_FMT "pci_request_selected_regions: failed\n",
+			ioc->name);
+		r = -ENODEV;
+		goto out_fail;
+	}
+
+/* AER (Advanced Error Reporting) hooks */
+	pci_enable_pcie_error_reporting(pdev);
+
+	pci_set_master(pdev);
+
+
+	if (_base_config_dma_addressing(ioc, pdev) != 0) {
+		pr_warn(MPT3SAS_FMT "no suitable DMA mask for %s\n",
+		    ioc->name, pci_name(pdev));
+		r = -ENODEV;
+		goto out_fail;
+	}
+
+	for (i = 0, memap_sz = 0, pio_sz = 0 ; i < DEVICE_COUNT_RESOURCE; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
+			if (pio_sz)
+				continue;
+			pio_chip = (u64)pci_resource_start(pdev, i);
+			pio_sz = pci_resource_len(pdev, i);
+		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			if (memap_sz)
+				continue;
+			ioc->chip_phys = pci_resource_start(pdev, i);
+			chip_phys = (u64)ioc->chip_phys;
+			memap_sz = pci_resource_len(pdev, i);
+			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
+			if (ioc->chip == NULL) {
+				pr_err(MPT3SAS_FMT "unable to map adapter memory!\n",
+					ioc->name);
+				r = -EINVAL;
+				goto out_fail;
+			}
+		}
+	}
+
+	_base_mask_interrupts(ioc);
+	r = _base_enable_msix(ioc);
+	if (r)
+		goto out_fail;
+
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
+		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
+		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
+		    "IO-APIC enabled"), reply_q->vector);
+
+	pr_info(MPT3SAS_FMT "iomem(0x%016llx), mapped(0x%p), size(%d)\n",
+	    ioc->name, (unsigned long long)chip_phys, ioc->chip, memap_sz);
+	pr_info(MPT3SAS_FMT "ioport(0x%016llx), size(%d)\n",
+	    ioc->name, (unsigned long long)pio_chip, pio_sz);
+
+	/* Save PCI configuration state for recovery from PCI AER/EEH errors */
+	pci_save_state(pdev);
+	return 0;
+
+ out_fail:
+	if (ioc->chip_phys)
+		iounmap(ioc->chip);
+	ioc->chip_phys = 0;
+	pci_release_selected_regions(ioc->pdev, ioc->bars);
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+	return r;
+}
+
+/**
+ * mpt3sas_base_get_msg_frame - obtain request mf pointer
+ * @ioc: per adapter object
+ * @smid: system request message index(smid zero is invalid)
+ *
+ * Returns virt pointer to message frame.
+ */
+void *
+mpt3sas_base_get_msg_frame(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return (void *)(ioc->request + (smid * ioc->request_sz));
+}
+
+/**
+ * mpt3sas_base_get_sense_buffer - obtain a sense buffer virt addr
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns virt pointer to sense buffer.
+ */
+void *
+mpt3sas_base_get_sense_buffer(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return (void *)(ioc->sense + ((smid - 1) * SCSI_SENSE_BUFFERSIZE));
+}
+
+/**
+ * mpt3sas_base_get_sense_buffer_dma - obtain a sense buffer dma addr
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns phys pointer to the low 32bit address of the sense buffer.
+ */
+__le32
+mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return cpu_to_le32(ioc->sense_dma + ((smid - 1) *
+	    SCSI_SENSE_BUFFERSIZE));
+}
+
+/**
+ * mpt3sas_base_get_reply_virt_addr - obtain reply frames virt address
+ * @ioc: per adapter object
+ * @phys_addr: lower 32 physical addr of the reply
+ *
+ * Converts 32bit lower physical addr into a virt address.
+ */
+void *
+mpt3sas_base_get_reply_virt_addr(struct MPT3SAS_ADAPTER *ioc, u32 phys_addr)
+{
+	if (!phys_addr)
+		return NULL;
+	return ioc->reply + (phys_addr - (u32)ioc->reply_dma);
+}
+
+/**
+ * mpt3sas_base_get_smid - obtain a free smid from internal queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->internal_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		pr_err(MPT3SAS_FMT "%s: smid not available\n",
+		    ioc->name, __func__);
+		return 0;
+	}
+
+	request = list_entry(ioc->internal_free_list.next,
+	    struct request_tracker, tracker_list);
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt3sas_base_get_smid_scsiio - obtain a free smid from scsiio queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ * @scmd: pointer to scsi command object
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
+	struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct scsiio_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		pr_err(MPT3SAS_FMT "%s: smid not available\n",
+		    ioc->name, __func__);
+		return 0;
+	}
+
+	request = list_entry(ioc->free_list.next,
+	    struct scsiio_tracker, tracker_list);
+	request->scmd = scmd;
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt3sas_base_get_smid_hpr - obtain a free smid from hi-priority queue
+ * @ioc: per adapter object
+ * @cb_idx: callback index
+ *
+ * Returns smid (zero is invalid)
+ */
+u16
+mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
+{
+	unsigned long flags;
+	struct request_tracker *request;
+	u16 smid;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (list_empty(&ioc->hpr_free_list)) {
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		return 0;
+	}
+
+	request = list_entry(ioc->hpr_free_list.next,
+	    struct request_tracker, tracker_list);
+	request->cb_idx = cb_idx;
+	smid = request->smid;
+	list_del(&request->tracker_list);
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * mpt3sas_base_free_smid - put smid back on free_list
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	unsigned long flags;
+	int i;
+	struct chain_tracker *chain_req, *next;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	if (smid < ioc->hi_priority_smid) {
+		/* scsiio queue */
+		i = smid - 1;
+		if (!list_empty(&ioc->scsi_lookup[i].chain_list)) {
+			list_for_each_entry_safe(chain_req, next,
+			    &ioc->scsi_lookup[i].chain_list, tracker_list) {
+				list_del_init(&chain_req->tracker_list);
+				list_add(&chain_req->tracker_list,
+				    &ioc->free_chain_list);
+			}
+		}
+		ioc->scsi_lookup[i].cb_idx = 0xFF;
+		ioc->scsi_lookup[i].scmd = NULL;
+		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+		/*
+		 * See _wait_for_commands_to_complete() call with regards
+		 * to this code.
+		 */
+		if (ioc->shost_recovery && ioc->pending_io_count) {
+			if (ioc->pending_io_count == 1)
+				wake_up(&ioc->reset_wq);
+			ioc->pending_io_count--;
+		}
+		return;
+	} else if (smid < ioc->internal_smid) {
+		/* hi-priority */
+		i = smid - ioc->hi_priority_smid;
+		ioc->hpr_lookup[i].cb_idx = 0xFF;
+		list_add(&ioc->hpr_lookup[i].tracker_list, &ioc->hpr_free_list);
+	} else if (smid <= ioc->hba_queue_depth) {
+		/* internal queue */
+		i = smid - ioc->internal_smid;
+		ioc->internal_lookup[i].cb_idx = 0xFF;
+		list_add(&ioc->internal_lookup[i].tracker_list,
+		    &ioc->internal_free_list);
+	}
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+}
+
+/**
+ * _base_writeq - 64 bit write to MMIO
+ * @ioc: per adapter object
+ * @b: data payload
+ * @addr: address in MMIO space
+ * @writeq_lock: spin lock
+ *
+ * Glue for handling an atomic 64 bit word to MMIO. This special handling takes
+ * care of 32 bit environment where its not quarenteed to send the entire word
+ * in one transfer.
+ */
+#if defined(writeq) && defined(CONFIG_64BIT)
+static inline void
+_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
+{
+	writeq(cpu_to_le64(b), addr);
+}
+#else
+static inline void
+_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
+{
+	unsigned long flags;
+	__u64 data_out = cpu_to_le64(b);
+
+	spin_lock_irqsave(writeq_lock, flags);
+	writel((u32)(data_out), addr);
+	writel((u32)(data_out >> 32), (addr + 4));
+	spin_unlock_irqrestore(writeq_lock, flags);
+}
+#endif
+
+static inline u8
+_base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
+{
+	return ioc->cpu_msix_table[raw_smp_processor_id()];
+}
+
+/**
+ * mpt3sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @handle: device handle
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_put_smid_scsi_io(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 handle)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+
+
+	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
+	descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
+	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
+	descriptor.SCSIIO.LMID = 0;
+	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+/**
+ * mpt3sas_base_put_smid_fast_path - send fast path request to firmware
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @handle: device handle
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	u16 handle)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+
+	descriptor.SCSIIO.RequestFlags =
+	    MPI25_REQ_DESCRIPT_FLAGS_FAST_PATH_SCSI_IO;
+	descriptor.SCSIIO.MSIxIndex = _base_get_msix_index(ioc);
+	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
+	descriptor.SCSIIO.DevHandle = cpu_to_le16(handle);
+	descriptor.SCSIIO.LMID = 0;
+	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+/**
+ * mpt3sas_base_put_smid_hi_priority - send Task Managment request to firmware
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_put_smid_hi_priority(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+
+	descriptor.HighPriority.RequestFlags =
+	    MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY;
+	descriptor.HighPriority.MSIxIndex =  0;
+	descriptor.HighPriority.SMID = cpu_to_le16(smid);
+	descriptor.HighPriority.LMID = 0;
+	descriptor.HighPriority.Reserved1 = 0;
+	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+/**
+ * mpt3sas_base_put_smid_default - Default, primarily used for config pages
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	Mpi2RequestDescriptorUnion_t descriptor;
+	u64 *request = (u64 *)&descriptor;
+
+	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
+	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
+	descriptor.Default.SMID = cpu_to_le16(smid);
+	descriptor.Default.LMID = 0;
+	descriptor.Default.DescriptorTypeDependent = 0;
+	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
+	    &ioc->scsi_lookup_lock);
+}
+
+
+
+/**
+ * _base_display_ioc_capabilities - Disply IOC's capabilities.
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
+{
+	int i = 0;
+	char desc[16];
+	u32 iounit_pg1_flags;
+	u32 bios_version;
+
+	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
+	strncpy(desc, ioc->manu_pg0.ChipName, 16);
+	pr_info(MPT3SAS_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "\
+	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
+	    ioc->name, desc,
+	   (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
+	   (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
+	   (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
+	   ioc->facts.FWVersion.Word & 0x000000FF,
+	   ioc->pdev->revision,
+	   (bios_version & 0xFF000000) >> 24,
+	   (bios_version & 0x00FF0000) >> 16,
+	   (bios_version & 0x0000FF00) >> 8,
+	    bios_version & 0x000000FF);
+
+	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
+
+	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
+		pr_info("Initiator");
+		i++;
+	}
+
+	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_TARGET) {
+		pr_info("%sTarget", i ? "," : "");
+		i++;
+	}
+
+	i = 0;
+	pr_info("), ");
+	pr_info("Capabilities=(");
+
+	if (ioc->facts.IOCCapabilities &
+		    MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
+			pr_info("Raid");
+			i++;
+	}
+
+	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR) {
+		pr_info("%sTLR", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_MULTICAST) {
+		pr_info("%sMulticast", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_BIDIRECTIONAL_TARGET) {
+		pr_info("%sBIDI Target", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_EEDP) {
+		pr_info("%sEEDP", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_SNAPSHOT_BUFFER) {
+		pr_info("%sSnapshot Buffer", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_DIAG_TRACE_BUFFER) {
+		pr_info("%sDiag Trace Buffer", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER) {
+		pr_info("%sDiag Extended Buffer", i ? "," : "");
+		i++;
+	}
+
+	if (ioc->facts.IOCCapabilities &
+	    MPI2_IOCFACTS_CAPABILITY_TASK_SET_FULL_HANDLING) {
+		pr_info("%sTask Set Full", i ? "," : "");
+		i++;
+	}
+
+	iounit_pg1_flags = le32_to_cpu(ioc->iounit_pg1.Flags);
+	if (!(iounit_pg1_flags & MPI2_IOUNITPAGE1_NATIVE_COMMAND_Q_DISABLE)) {
+		pr_info("%sNCQ", i ? "," : "");
+		i++;
+	}
+
+	pr_info(")\n");
+}
+
+/**
+ * mpt3sas_base_update_missing_delay - change the missing delay timers
+ * @ioc: per adapter object
+ * @device_missing_delay: amount of time till device is reported missing
+ * @io_missing_delay: interval IO is returned when there is a missing device
+ *
+ * Return nothing.
+ *
+ * Passed on the command line, this function will modify the device missing
+ * delay, as well as the io missing delay. This should be called at driver
+ * load time.
+ */
+void
+mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay)
+{
+	u16 dmd, dmd_new, dmd_orignal;
+	u8 io_missing_delay_original;
+	u16 sz;
+	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi2ConfigReply_t mpi_reply;
+	u8 num_phys = 0;
+	u16 ioc_status;
+
+	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys)
+		return;
+
+	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (num_phys *
+	    sizeof(Mpi2SasIOUnit1PhyData_t));
+	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg1) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	/* device missing delay */
+	dmd = sas_iounit_pg1->ReportDeviceMissingDelay;
+	if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+		dmd = (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+	else
+		dmd = dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+	dmd_orignal = dmd;
+	if (device_missing_delay > 0x7F) {
+		dmd = (device_missing_delay > 0x7F0) ? 0x7F0 :
+		    device_missing_delay;
+		dmd = dmd / 16;
+		dmd |= MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16;
+	} else
+		dmd = device_missing_delay;
+	sas_iounit_pg1->ReportDeviceMissingDelay = dmd;
+
+	/* io missing delay */
+	io_missing_delay_original = sas_iounit_pg1->IODeviceMissingDelay;
+	sas_iounit_pg1->IODeviceMissingDelay = io_missing_delay;
+
+	if (!mpt3sas_config_set_sas_iounit_pg1(ioc, &mpi_reply, sas_iounit_pg1,
+	    sz)) {
+		if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+			dmd_new = (dmd &
+			    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+		else
+			dmd_new =
+		    dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+		pr_info(MPT3SAS_FMT "device_missing_delay: old(%d), new(%d)\n",
+			ioc->name, dmd_orignal, dmd_new);
+		pr_info(MPT3SAS_FMT "ioc_missing_delay: old(%d), new(%d)\n",
+			ioc->name, io_missing_delay_original,
+		    io_missing_delay);
+		ioc->device_missing_delay = dmd_new;
+		ioc->io_missing_delay = io_missing_delay;
+	}
+
+out:
+	kfree(sas_iounit_pg1);
+}
