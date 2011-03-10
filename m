From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 04/10] isci/core: remote device
Date: Thu, 10 Mar 2011 02:54:40 -0800
Message-ID: <20110310105439.6485.94426.stgit@localhost6.localdomain6>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1CJKx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:27 -0500
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Software representation of SSP, SMP, STP and direct attached SATA
devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/core/sci_base_remote_device.h    |  274 +++
 drivers/scsi/isci/core/scic_remote_device.h        |  294 +++
 drivers/scsi/isci/core/scic_sds_remote_device.c    | 2079 ++++++++++++++++++++
 drivers/scsi/isci/core/scic_sds_remote_device.h    |  570 +++++
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |  325 +++
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |  908 +++++++++
 6 files changed, 4450 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/sci_base_remote_device.h
 create mode 100644 drivers/scsi/isci/core/scic_remote_device.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_smp_remote_device.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_remote_device.c

diff --git a/drivers/scsi/isci/core/sci_base_remote_device.h b/drivers/scsi/isci/core/sci_base_remote_device.h
new file mode 100644
index 0000000..45414ce
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_remote_device.h
@@ -0,0 +1,274 @@
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
+#ifndef _SCI_BASE_REMOTE_DEVICE_H_
+#define _SCI_BASE_REMOTE_DEVICE_H_
+
+/**
+ * This file contains all of the structures, constants, and methods common to
+ *    all remote device object definitions.
+ *
+ *
+ */
+
+#include "sci_base_state_machine.h"
+
+struct sci_base_request;
+
+/**
+ * enum sci_base_remote_device_states - This enumeration depicts all the states
+ *    for the common remote device state machine.
+ *
+ *
+ */
+enum sci_base_remote_device_states {
+	/**
+	 * Simply the initial state for the base remote device state machine.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_INITIAL,
+
+	/**
+	 * This state indicates that the remote device has successfully been
+	 * stopped.  In this state no new IO operations are permitted.
+	 * This state is entered from the INITIAL state.
+	 * This state is entered from the STOPPING state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_STOPPED,
+
+	/**
+	 * This state indicates the the remote device is in the process of
+	 * becoming ready (i.e. starting).  In this state no new IO operations
+	 * are permitted.
+	 * This state is entered from the STOPPED state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_STARTING,
+
+	/**
+	 * This state indicates the remote device is now ready.  Thus, the user
+	 * is able to perform IO operations on the remote device.
+	 * This state is entered from the STARTING state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_READY,
+
+	/**
+	 * This state indicates that the remote device is in the process of
+	 * stopping.  In this state no new IO operations are permitted, but
+	 * existing IO operations are allowed to complete.
+	 * This state is entered from the READY state.
+	 * This state is entered from the FAILED state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_STOPPING,
+
+	/**
+	 * This state indicates that the remote device has failed.
+	 * In this state no new IO operations are permitted.
+	 * This state is entered from the INITIALIZING state.
+	 * This state is entered from the READY state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_FAILED,
+
+	/**
+	 * This state indicates the device is being reset.
+	 * In this state no new IO operations are permitted.
+	 * This state is entered from the READY state.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_RESETTING,
+
+	/**
+	 * Simply the final state for the base remote device state machine.
+	 */
+	SCI_BASE_REMOTE_DEVICE_STATE_FINAL,
+};
+
+/**
+ * struct sci_base_remote_device - The base remote device object abstracts the
+ *    fields common to all SCI remote device objects.
+ *
+ *
+ */
+struct sci_base_remote_device {
+	/**
+	 * The field specifies that the parent object for the base remote
+	 * device is the base object itself.
+	 */
+	struct sci_base_object parent;
+
+	/**
+	 * This field contains the information for the base remote device state
+	 * machine.
+	 */
+	struct sci_base_state_machine state_machine;
+};
+
+
+typedef enum sci_status (*sci_base_remote_device_handler_t)(
+	struct sci_base_remote_device *
+	);
+
+typedef enum sci_status (*sci_base_remote_device_request_handler_t)(
+	struct sci_base_remote_device *,
+	struct sci_base_request *
+	);
+
+typedef enum sci_status (*sci_base_remote_device_high_priority_request_complete_handler_t)(
+	struct sci_base_remote_device *,
+	struct sci_base_request *,
+	void *,
+	enum sci_io_status
+	);
+
+/**
+ * struct sci_base_remote_device_state_handler - This structure contains all of
+ *    the state handler methods common to base remote device state machines.
+ *    Handler methods provide the ability to change the behavior for user
+ *    requests or transitions depending on the state the machine is in.
+ *
+ *
+ */
+struct sci_base_remote_device_state_handler {
+	/**
+	 * The start_handler specifies the method invoked when a user attempts to
+	 * start a remote device.
+	 */
+	sci_base_remote_device_handler_t start_handler;
+
+	/**
+	 * The stop_handler specifies the method invoked when a user attempts to
+	 * stop a remote device.
+	 */
+	sci_base_remote_device_handler_t stop_handler;
+
+	/**
+	 * The fail_handler specifies the method invoked when a remote device
+	 * failure has occurred.  A failure may be due to an inability to
+	 * initialize/configure the device.
+	 */
+	sci_base_remote_device_handler_t fail_handler;
+
+	/**
+	 * The destruct_handler specifies the method invoked when attempting to
+	 * destruct a remote device.
+	 */
+	sci_base_remote_device_handler_t destruct_handler;
+
+	/**
+	 * The reset handler specifies the method invloked when requesting to reset a
+	 * remote device.
+	 */
+	sci_base_remote_device_handler_t reset_handler;
+
+	/**
+	 * The reset complete handler specifies the method invloked when reporting
+	 * that a reset has completed to the remote device.
+	 */
+	sci_base_remote_device_handler_t reset_complete_handler;
+
+	/**
+	 * The start_io_handler specifies the method invoked when a user
+	 * attempts to start an IO request for a remote device.
+	 */
+	sci_base_remote_device_request_handler_t start_io_handler;
+
+	/**
+	 * The complete_io_handler specifies the method invoked when a user
+	 * attempts to complete an IO request for a remote device.
+	 */
+	sci_base_remote_device_request_handler_t complete_io_handler;
+
+	/**
+	 * The continue_io_handler specifies the method invoked when a user
+	 * attempts to continue an IO request for a remote device.
+	 */
+	sci_base_remote_device_request_handler_t continue_io_handler;
+
+	/**
+	 * The start_task_handler specifies the method invoked when a user
+	 * attempts to start a task management request for a remote device.
+	 */
+	sci_base_remote_device_request_handler_t start_task_handler;
+
+	/**
+	 * The complete_task_handler specifies the method invoked when a user
+	 * attempts to complete a task management request for a remote device.
+	 */
+	sci_base_remote_device_request_handler_t complete_task_handler;
+
+};
+
+/**
+ * sci_base_remote_device_construct() - Construct the base remote device
+ * @this_remote_device: This parameter specifies the base remote device to be
+ *    constructed.
+ * @state_table: This parameter specifies the table of state definitions to be
+ *    utilized for the remote device state machine.
+ *
+ */
+static inline void sci_base_remote_device_construct(
+	struct sci_base_remote_device *base_dev,
+	const struct sci_base_state *state_table)
+{
+	base_dev->parent.private = NULL;
+	sci_base_state_machine_construct(
+		&base_dev->state_machine,
+		&base_dev->parent,
+		state_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_INITIAL
+		);
+
+	sci_base_state_machine_start(
+		&base_dev->state_machine
+		);
+}
+#endif /* _SCI_BASE_REMOTE_DEVICE_H_ */
diff --git a/drivers/scsi/isci/core/scic_remote_device.h b/drivers/scsi/isci/core/scic_remote_device.h
new file mode 100644
index 0000000..1401844
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_remote_device.h
@@ -0,0 +1,294 @@
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
+#ifndef _SCIC_REMOTE_DEVICE_H_
+#define _SCIC_REMOTE_DEVICE_H_
+
+/**
+ * This file contains all of the interface methods that can be called by an
+ *    SCIC user on the device object.
+ *
+ *
+ */
+
+
+#include "sci_status.h"
+#include "intel_sas.h"
+
+struct scic_sds_port;
+struct scic_sds_remote_device;
+
+/**
+ *
+ *
+ *
+ */
+enum scic_remote_device_not_ready_reason_code {
+	SCIC_REMOTE_DEVICE_NOT_READY_START_REQUESTED,
+	SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED,
+	SCIC_REMOTE_DEVICE_NOT_READY_SATA_REQUEST_STARTED,
+	SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED,
+	SCIC_REMOTE_DEVICE_NOT_READY_SMP_REQUEST_STARTED,
+
+	SCIC_REMOTE_DEVICE_NOT_READY_REASON_CODE_MAX
+
+};
+
+/**
+ * scic_remote_device_get_object_size() - This method simply returns the
+ *    maximum memory space needed to store a remote device object.
+ *
+ * a positive integer value indicating the size (in bytes) of the remote device
+ * object.
+ */
+u32 scic_remote_device_get_object_size(
+	void);
+
+struct scic_sds_port;
+struct scic_sds_remote_device;
+/**
+ * scic_remote_device_construct() - This method will perform the construction
+ *    common to all remote device objects.
+ * @sci_port: SAS/SATA port through which this device is accessed.
+ * @sci_dev: remote device to construct
+ *
+ * It isn't necessary to call scic_remote_device_destruct() for device objects
+ * that have only called this method for construction. Once subsequent
+ * construction methods have been invoked (e.g.
+ * scic_remote_device_da_construct()), then destruction should occur. none
+ */
+void scic_remote_device_construct(struct scic_sds_port *sci_port,
+				  struct scic_sds_remote_device *sci_dev);
+
+/**
+ * scic_remote_device_da_construct() - This method will construct a
+ *    SCIC_REMOTE_DEVICE object for a direct attached (da) device.  The
+ *    information (e.g. IAF, Signature FIS, etc.) necessary to build the device
+ *    is known to the SCI Core since it is contained in the scic_phy object.
+ * @remote_device: This parameter specifies the remote device to be destructed.
+ *
+ * The user must have previously called scic_remote_device_construct() Remote
+ * device objects are a limited resource.  As such, they must be protected.
+ * Thus calls to construct and destruct are mutually exclusive and
+ * non-reentrant. Indicate if the remote device was successfully constructed.
+ * SCI_SUCCESS Returned if the device was successfully constructed.
+ * SCI_FAILURE_DEVICE_EXISTS Returned if the device has already been
+ * constructed.  If it's an additional phy for the target, then call
+ * scic_remote_device_da_add_phy(). SCI_FAILURE_UNSUPPORTED_PROTOCOL Returned
+ * if the supplied parameters necessitate creation of a remote device for which
+ * the protocol is not supported by the underlying controller hardware.
+ * SCI_FAILURE_INSUFFICIENT_RESOURCES This value is returned if the core
+ * controller associated with the supplied parameters is unable to support
+ * additional remote devices.
+ */
+enum sci_status scic_remote_device_da_construct(
+	struct scic_sds_remote_device *remote_device);
+
+/**
+ * scic_remote_device_ea_construct() - This method will construct an
+ *    SCIC_REMOTE_DEVICE object for an expander attached (ea) device from an
+ *    SMP Discover Response.
+ * @remote_device: This parameter specifies the remote device to be destructed.
+ * @discover_response: This parameter specifies the SMP Discovery Response to
+ *    be used in device creation.
+ *
+ * The user must have previously called scic_remote_device_construct() Remote
+ * device objects are a limited resource.  As such, they must be protected.
+ * Thus calls to construct and destruct are mutually exclusive and
+ * non-reentrant. Indicate if the remote device was successfully constructed.
+ * SCI_SUCCESS Returned if the device was successfully constructed.
+ * SCI_FAILURE_DEVICE_EXISTS Returned if the device has already been
+ * constructed.  If it's an additional phy for the target, then call
+ * scic_ea_remote_device_add_phy(). SCI_FAILURE_UNSUPPORTED_PROTOCOL Returned
+ * if the supplied parameters necessitate creation of a remote device for which
+ * the protocol is not supported by the underlying controller hardware.
+ * SCI_FAILURE_INSUFFICIENT_RESOURCES This value is returned if the core
+ * controller associated with the supplied parameters is unable to support
+ * additional remote devices.
+ */
+enum sci_status scic_remote_device_ea_construct(
+	struct scic_sds_remote_device *remote_device,
+	struct smp_response_discover *discover_response);
+
+/**
+ * scic_remote_device_destruct() - This method is utilized to free up a core's
+ *    remote device object.
+ * @remote_device: This parameter specifies the remote device to be destructed.
+ *
+ * Remote device objects are a limited resource.  As such, they must be
+ * protected.  Thus calls to construct and destruct are mutually exclusive and
+ * non-reentrant. The return value shall indicate if the device was
+ * successfully destructed or if some failure occurred. enum sci_status This value
+ * is returned if the device is successfully destructed.
+ * SCI_FAILURE_INVALID_REMOTE_DEVICE This value is returned if the supplied
+ * device isn't valid (e.g. it's already been destoryed, the handle isn't
+ * valid, etc.).
+ */
+enum sci_status scic_remote_device_destruct(
+	struct scic_sds_remote_device *remote_device);
+
+
+
+
+
+/**
+ * scic_remote_device_start() - This method will start the supplied remote
+ *    device.  This method enables normal IO requests to flow through to the
+ *    remote device.
+ * @remote_device: This parameter specifies the device to be started.
+ * @timeout: This parameter specifies the number of milliseconds in which the
+ *    start operation should complete.
+ *
+ * An indication of whether the device was successfully started. SCI_SUCCESS
+ * This value is returned if the device was successfully started.
+ * SCI_FAILURE_INVALID_PHY This value is returned if the user attempts to start
+ * the device when there have been no phys added to it.
+ */
+enum sci_status scic_remote_device_start(
+	struct scic_sds_remote_device *remote_device,
+	u32 timeout);
+
+/**
+ * scic_remote_device_stop() - This method will stop both transmission and
+ *    reception of link activity for the supplied remote device.  This method
+ *    disables normal IO requests from flowing through to the remote device.
+ * @remote_device: This parameter specifies the device to be stopped.
+ * @timeout: This parameter specifies the number of milliseconds in which the
+ *    stop operation should complete.
+ *
+ * An indication of whether the device was successfully stopped. SCI_SUCCESS
+ * This value is returned if the transmission and reception for the device was
+ * successfully stopped.
+ */
+enum sci_status scic_remote_device_stop(
+	struct scic_sds_remote_device *remote_device,
+	u32 timeout);
+
+/**
+ * scic_remote_device_reset() - This method will reset the device making it
+ *    ready for operation. This method must be called anytime the device is
+ *    reset either through a SMP phy control or a port hard reset request.
+ * @remote_device: This parameter specifies the device to be reset.
+ *
+ * This method does not actually cause the device hardware to be reset. This
+ * method resets the software object so that it will be operational after a
+ * device hardware reset completes. An indication of whether the device reset
+ * was accepted. SCI_SUCCESS This value is returned if the device reset is
+ * started.
+ */
+enum sci_status scic_remote_device_reset(
+	struct scic_sds_remote_device *remote_device);
+
+/**
+ * scic_remote_device_reset_complete() - This method informs the device object
+ *    that the reset operation is complete and the device can resume operation
+ *    again.
+ * @remote_device: This parameter specifies the device which is to be informed
+ *    of the reset complete operation.
+ *
+ * An indication that the device is resuming operation. SCI_SUCCESS the device
+ * is resuming operation.
+ */
+enum sci_status scic_remote_device_reset_complete(
+	struct scic_sds_remote_device *remote_device);
+
+
+
+/**
+ * scic_remote_device_get_connection_rate() - This method simply returns the
+ *    link rate at which communications to the remote device occur.
+ * @remote_device: This parameter specifies the device for which to get the
+ *    connection rate.
+ *
+ * Return the link rate at which we transfer for the supplied remote device.
+ */
+enum sci_sas_link_rate scic_remote_device_get_connection_rate(
+	struct scic_sds_remote_device *remote_device);
+
+/**
+ * scic_remote_device_get_protocols() - This method will indicate which
+ *    protocols are supported by this remote device.
+ * @remote_device: This parameter specifies the device for which to return the
+ *    protocol.
+ * @protocols: This parameter specifies the output values, from the remote
+ *    device object, which indicate the protocols supported by the supplied
+ *    remote_device.
+ *
+ * The type of protocols supported by this device.  The values are returned as
+ * part of a bit mask in order to allow for multi-protocol support.
+ */
+void scic_remote_device_get_protocols(
+	struct scic_sds_remote_device *remote_device,
+	struct smp_discover_response_protocols *protocols);
+
+
+#if !defined(DISABLE_ATAPI)
+/**
+ * scic_remote_device_is_atapi() -
+ * @this_device: The device whose type is to be decided.
+ *
+ * This method first decide whether a device is a stp target, then decode the
+ * signature fis of a DA STP device to tell whether it is a standard end disk
+ * or an ATAPI device. bool Indicate a device is ATAPI device or not.
+ */
+bool scic_remote_device_is_atapi(
+	struct scic_sds_remote_device *device_handle);
+#else /* !defined(DISABLE_ATAPI) */
+#define scic_remote_device_is_atapi(device_handle) false
+#endif /* !defined(DISABLE_ATAPI) */
+
+
+#endif  /* _SCIC_REMOTE_DEVICE_H_ */
+
diff --git a/drivers/scsi/isci/core/scic_sds_remote_device.c b/drivers/scsi/isci/core/scic_sds_remote_device.c
new file mode 100644
index 0000000..0ac6ca0
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_device.c
@@ -0,0 +1,2079 @@
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
+#include "intel_sas.h"
+#include "scic_controller.h"
+#include "scic_phy.h"
+#include "scic_port.h"
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_phy.h"
+#include "scic_sds_port.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_remote_node_context.h"
+#include "scic_sds_request.h"
+#include "sci_environment.h"
+#include "sci_util.h"
+#include "scu_event_codes.h"
+
+
+#define SCIC_SDS_REMOTE_DEVICE_RESET_TIMEOUT  (1000)
+
+/*
+ * *****************************************************************************
+ * *  CORE REMOTE DEVICE PRIVATE METHODS
+ * ***************************************************************************** */
+
+/*
+ * *****************************************************************************
+ * *  CORE REMOTE DEVICE PUBLIC METHODS
+ * ***************************************************************************** */
+
+u32 scic_remote_device_get_object_size(void)
+{
+	return sizeof(struct scic_sds_remote_device)
+	       + sizeof(struct scic_sds_remote_node_context);
+}
+
+/* --------------------------------------------------------------------------- */
+
+void scic_remote_device_construct(struct scic_sds_port *sci_port,
+				  struct scic_sds_remote_device *sci_dev)
+{
+	sci_dev->owning_port = sci_port;
+	sci_dev->started_request_count = 0;
+	sci_dev->rnc = (struct scic_sds_remote_node_context *) &sci_dev[1];
+
+	sci_base_remote_device_construct(
+		&sci_dev->parent,
+		scic_sds_remote_device_state_table
+		);
+
+	scic_sds_remote_node_context_construct(
+		sci_dev,
+		sci_dev->rnc,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX
+		);
+
+	sci_object_set_association(sci_dev->rnc, sci_dev);
+}
+
+
+enum sci_status scic_remote_device_da_construct(
+	struct scic_sds_remote_device *sci_dev)
+{
+	enum sci_status status;
+	u16 remote_node_index;
+	struct sci_sas_identify_address_frame_protocols protocols;
+
+	/*
+	 * This information is request to determine how many remote node context
+	 * entries will be needed to store the remote node.
+	 */
+	scic_sds_port_get_attached_protocols(sci_dev->owning_port, &protocols);
+	sci_dev->target_protocols.u.all = protocols.u.all;
+	sci_dev->is_direct_attached = true;
+#if !defined(DISABLE_ATAPI)
+	sci_dev->is_atapi = scic_sds_remote_device_is_atapi(sci_dev);
+#endif
+
+	status = scic_sds_controller_allocate_remote_node_context(
+		sci_dev->owning_port->owning_controller,
+		sci_dev,
+		&remote_node_index);
+
+	if (status == SCI_SUCCESS) {
+		scic_sds_remote_node_context_set_remote_node_index(
+			sci_dev->rnc, remote_node_index);
+
+		scic_sds_port_get_attached_sas_address(
+			sci_dev->owning_port, &sci_dev->device_address);
+
+		if (sci_dev->target_protocols.u.bits.attached_ssp_target) {
+			sci_dev->has_ready_substate_machine = false;
+		} else if (sci_dev->target_protocols.u.bits.attached_stp_target) {
+			sci_dev->has_ready_substate_machine = true;
+
+			sci_base_state_machine_construct(
+				&sci_dev->ready_substate_machine,
+				&sci_dev->parent.parent,
+				scic_sds_stp_remote_device_ready_substate_table,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
+		} else if (sci_dev->target_protocols.u.bits.attached_smp_target) {
+			sci_dev->has_ready_substate_machine = true;
+
+			/* add the SMP ready substate machine construction here */
+			sci_base_state_machine_construct(
+				&sci_dev->ready_substate_machine,
+				&sci_dev->parent.parent,
+				scic_sds_smp_remote_device_ready_substate_table,
+				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
+		}
+
+		sci_dev->connection_rate = scic_sds_port_get_max_allowed_speed(
+			sci_dev->owning_port);
+
+		/* / @todo Should I assign the port width by reading all of the phys on the port? */
+		sci_dev->device_port_width = 1;
+	}
+
+	return status;
+}
+
+
+static void scic_sds_remote_device_get_info_from_smp_discover_response(
+	struct scic_sds_remote_device *this_device,
+	struct smp_response_discover *discover_response)
+{
+	/* decode discover_response to set sas_address to this_device. */
+	this_device->device_address.high =
+		discover_response->attached_sas_address.high;
+
+	this_device->device_address.low =
+		discover_response->attached_sas_address.low;
+
+	this_device->target_protocols.u.all = discover_response->protocols.u.all;
+}
+
+
+enum sci_status scic_remote_device_ea_construct(
+	struct scic_sds_remote_device *sci_dev,
+	struct smp_response_discover *discover_response)
+{
+	enum sci_status status;
+	struct scic_sds_controller *the_controller;
+
+	the_controller = scic_sds_port_get_controller(sci_dev->owning_port);
+
+	scic_sds_remote_device_get_info_from_smp_discover_response(
+		sci_dev, discover_response);
+
+	status = scic_sds_controller_allocate_remote_node_context(
+		the_controller, sci_dev, &sci_dev->rnc->remote_node_index);
+
+	if (status == SCI_SUCCESS) {
+		if (sci_dev->target_protocols.u.bits.attached_ssp_target) {
+			sci_dev->has_ready_substate_machine = false;
+		} else if (sci_dev->target_protocols.u.bits.attached_smp_target) {
+			sci_dev->has_ready_substate_machine = true;
+
+			/* add the SMP ready substate machine construction here */
+			sci_base_state_machine_construct(
+				&sci_dev->ready_substate_machine,
+				&sci_dev->parent.parent,
+				scic_sds_smp_remote_device_ready_substate_table,
+				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
+		} else if (sci_dev->target_protocols.u.bits.attached_stp_target) {
+			sci_dev->has_ready_substate_machine = true;
+
+			sci_base_state_machine_construct(
+				&sci_dev->ready_substate_machine,
+				&sci_dev->parent.parent,
+				scic_sds_stp_remote_device_ready_substate_table,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
+		}
+
+		/*
+		 * For SAS-2 the physical link rate is actually a logical link
+		 * rate that incorporates multiplexing.  The SCU doesn't
+		 * incorporate multiplexing and for the purposes of the
+		 * connection the logical link rate is that same as the
+		 * physical.  Furthermore, the SAS-2 and SAS-1.1 fields overlay
+		 * one another, so this code works for both situations. */
+		sci_dev->connection_rate = min_t(u16,
+			scic_sds_port_get_max_allowed_speed(sci_dev->owning_port),
+			discover_response->u2.sas1_1.negotiated_physical_link_rate
+			);
+
+		/* / @todo Should I assign the port width by reading all of the phys on the port? */
+		sci_dev->device_port_width = 1;
+	}
+
+	return status;
+}
+
+enum sci_status scic_remote_device_destruct(
+	struct scic_sds_remote_device *sci_dev)
+{
+	return sci_dev->state_handlers->parent.destruct_handler(&sci_dev->parent);
+}
+
+
+enum sci_status scic_remote_device_start(
+	struct scic_sds_remote_device *sci_dev,
+	u32 timeout)
+{
+	return sci_dev->state_handlers->parent.start_handler(&sci_dev->parent);
+}
+
+
+enum sci_status scic_remote_device_stop(
+	struct scic_sds_remote_device *sci_dev,
+	u32 timeout)
+{
+	return sci_dev->state_handlers->parent.stop_handler(&sci_dev->parent);
+}
+
+
+enum sci_status scic_remote_device_reset(
+	struct scic_sds_remote_device *sci_dev)
+{
+	return sci_dev->state_handlers->parent.reset_handler(&sci_dev->parent);
+}
+
+
+enum sci_status scic_remote_device_reset_complete(
+	struct scic_sds_remote_device *sci_dev)
+{
+	return sci_dev->state_handlers->parent.reset_complete_handler(&sci_dev->parent);
+}
+
+
+enum sci_sas_link_rate scic_remote_device_get_connection_rate(
+	struct scic_sds_remote_device *sci_dev)
+{
+	return sci_dev->connection_rate;
+}
+
+
+void scic_remote_device_get_protocols(
+	struct scic_sds_remote_device *sci_dev,
+	struct smp_discover_response_protocols *pr)
+{
+	pr->u.all = sci_dev->target_protocols.u.all;
+}
+
+#if !defined(DISABLE_ATAPI)
+bool scic_remote_device_is_atapi(struct scic_sds_remote_device *sci_dev)
+{
+	return sci_dev->is_atapi;
+}
+#endif
+
+
+/*
+ * *****************************************************************************
+ * *  SCU DRIVER STANDARD (SDS) REMOTE DEVICE IMPLEMENTATIONS
+ * ***************************************************************************** */
+
+/**
+ *
+ *
+ * Remote device timer requirements
+ */
+#define SCIC_SDS_REMOTE_DEVICE_MINIMUM_TIMER_COUNT (0)
+#define SCIC_SDS_REMOTE_DEVICE_MAXIMUM_TIMER_COUNT (SCI_MAX_REMOTE_DEVICES)
+
+
+/**
+ *
+ * @this_device: The remote device for which the suspend is being requested.
+ *
+ * This method invokes the remote device suspend state handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_suspend(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type)
+{
+	return this_device->state_handlers->suspend_handler(this_device, suspend_type);
+}
+
+/**
+ *
+ * @this_device: The remote device for which the resume is being requested.
+ *
+ * This method invokes the remote device resume state handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_resume(
+	struct scic_sds_remote_device *this_device)
+{
+	return this_device->state_handlers->resume_handler(this_device);
+}
+
+/**
+ *
+ * @this_device: The remote device for which the event handling is being
+ *    requested.
+ * @frame_index: This is the frame index that is being processed.
+ *
+ * This method invokes the frame handler for the remote device state machine
+ * enum sci_status
+ */
+enum sci_status scic_sds_remote_device_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	return this_device->state_handlers->frame_handler(this_device, frame_index);
+}
+
+/**
+ *
+ * @this_device: The remote device for which the event handling is being
+ *    requested.
+ * @event_code: This is the event code that is to be processed.
+ *
+ * This method invokes the remote device event handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code)
+{
+	return this_device->state_handlers->event_handler(this_device, event_code);
+}
+
+/**
+ *
+ * @controller: The controller that is starting the io request.
+ * @this_device: The remote device for which the start io handling is being
+ *    requested.
+ * @io_request: The io request that is being started.
+ *
+ * This method invokes the remote device start io handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_start_io(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request)
+{
+	return this_device->state_handlers->parent.start_io_handler(
+		       &this_device->parent, &io_request->parent);
+}
+
+/**
+ *
+ * @controller: The controller that is completing the io request.
+ * @this_device: The remote device for which the complete io handling is being
+ *    requested.
+ * @io_request: The io request that is being completed.
+ *
+ * This method invokes the remote device complete io handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_complete_io(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request)
+{
+	return this_device->state_handlers->parent.complete_io_handler(
+		       &this_device->parent, &io_request->parent);
+}
+
+/**
+ *
+ * @controller: The controller that is starting the task request.
+ * @this_device: The remote device for which the start task handling is being
+ *    requested.
+ * @io_request: The task request that is being started.
+ *
+ * This method invokes the remote device start task handler. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_start_task(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request)
+{
+	return this_device->state_handlers->parent.start_task_handler(
+		       &this_device->parent, &io_request->parent);
+}
+
+/**
+ *
+ * @controller: The controller that is completing the task request.
+ * @this_device: The remote device for which the complete task handling is
+ *    being requested.
+ * @io_request: The task request that is being completed.
+ *
+ * This method invokes the remote device complete task handler. enum sci_status
+ */
+
+/**
+ *
+ * @this_device:
+ * @request:
+ *
+ * This method takes the request and bulids an appropriate SCU context for the
+ * request and then requests the controller to post the request. none
+ */
+void scic_sds_remote_device_post_request(
+	struct scic_sds_remote_device *this_device,
+	u32 request)
+{
+	u32 context;
+
+	context = scic_sds_remote_device_build_command_context(this_device, request);
+
+	scic_sds_controller_post_request(
+		scic_sds_remote_device_get_controller(this_device),
+		context
+		);
+}
+
+#if !defined(DISABLE_ATAPI)
+/**
+ *
+ * @this_device: The device to be checked.
+ *
+ * This method check the signature fis of a stp device to decide whether a
+ * device is atapi or not. true if a device is atapi device. False if a device
+ * is not atapi.
+ */
+bool scic_sds_remote_device_is_atapi(
+	struct scic_sds_remote_device *this_device)
+{
+	if (!this_device->target_protocols.u.bits.attached_stp_target)
+		return false;
+	else if (this_device->is_direct_attached) {
+		struct scic_sds_phy *phy;
+		struct scic_sata_phy_properties properties;
+		struct sata_fis_reg_d2h *signature_fis;
+		phy = scic_sds_port_get_a_connected_phy(this_device->owning_port);
+		scic_sata_phy_get_properties(phy, &properties);
+
+		/* decode the signature fis. */
+		signature_fis = &(properties.signature_fis);
+
+		if ((signature_fis->sector_count  == 0x01)
+		    && (signature_fis->lba_low       == 0x01)
+		    && (signature_fis->lba_mid       == 0x14)
+		    && (signature_fis->lba_high      == 0xEB)
+		    && ((signature_fis->device & 0x5F) == 0x00)
+		    ) {
+			/* An ATA device supporting the PACKET command set. */
+			return true;
+		} else
+			return false;
+	} else {
+		/* Expander supported ATAPI device is not currently supported. */
+		return false;
+	}
+}
+#endif
+
+/**
+ *
+ * @user_parameter: This is cast to a remote device object.
+ *
+ * This method is called once the remote node context is ready to be freed.
+ * The remote device can now report that its stop operation is complete. none
+ */
+static void scic_sds_cb_remote_device_rnc_destruct_complete(
+	void *user_parameter)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)user_parameter;
+
+	BUG_ON(this_device->started_request_count != 0);
+
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPED
+		);
+}
+
+/**
+ *
+ * @user_parameter: This is cast to a remote device object.
+ *
+ * This method is called once the remote node context has transisitioned to a
+ * ready state.  This is the indication that the remote device object can also
+ * transition to ready. none
+ */
+static void scic_sds_remote_device_resume_complete_handler(
+	void *user_parameter)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)user_parameter;
+
+	if (
+		sci_base_state_machine_get_state(&this_device->parent.state_machine)
+		!= SCI_BASE_REMOTE_DEVICE_STATE_READY
+		) {
+		sci_base_state_machine_change_state(
+			&this_device->parent.state_machine,
+			SCI_BASE_REMOTE_DEVICE_STATE_READY
+			);
+	}
+}
+
+/**
+ *
+ * @device: This parameter specifies the device for which the request is being
+ *    started.
+ * @request: This parameter specifies the request being started.
+ * @status: This parameter specifies the current start operation status.
+ *
+ * This method will perform the STP request start processing common to IO
+ * requests and task requests of all types. none
+ */
+void scic_sds_remote_device_start_request(
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *the_request,
+	enum sci_status status)
+{
+	/* We still have a fault in starting the io complete it on the port */
+	if (status == SCI_SUCCESS)
+		scic_sds_remote_device_increment_request_count(this_device);
+	else{
+		this_device->owning_port->state_handlers->complete_io_handler(
+			this_device->owning_port, this_device, the_request
+			);
+	}
+}
+
+
+/**
+ *
+ * @request: This parameter specifies the request being continued.
+ *
+ * This method will continue to post tc for a STP request. This method usually
+ * serves as a callback when RNC gets resumed during a task management
+ * sequence. none
+ */
+void scic_sds_remote_device_continue_request(void *dev)
+{
+	struct scic_sds_remote_device *sci_dev = dev;
+	struct scic_sds_request *sci_req = sci_dev->working_request;
+
+	/* we need to check if this request is still valid to continue. */
+	if (sci_req) {
+		struct scic_sds_controller *scic = sci_req->owning_controller;
+		u32 state = scic->parent.state_machine.current_state_id;
+		sci_base_controller_request_handler_t continue_io;
+
+		continue_io = scic_sds_controller_state_handler_table[state].base.continue_io;
+		continue_io(&scic->parent, &sci_req->target_device->parent,
+			    &sci_req->parent);
+	}
+}
+
+/**
+ *
+ * @user_parameter: This is cast to a remote device object.
+ *
+ * This method is called once the remote node context has reached a suspended
+ * state. The remote device can now report that its suspend operation is
+ * complete. none
+ */
+
+/**
+ * This method will terminate all of the IO requests in the controllers IO
+ *    request table that were targeted for this device.
+ * @this_device: This parameter specifies the remote device for which to
+ *    attempt to terminate all requests.
+ *
+ * This method returns an indication as to whether all requests were
+ * successfully terminated.  If a single request fails to be terminated, then
+ * this method will return the failure.
+ */
+static enum sci_status scic_sds_remote_device_terminate_requests(
+	struct scic_sds_remote_device *this_device)
+{
+	enum sci_status status           = SCI_SUCCESS;
+	enum sci_status terminate_status = SCI_SUCCESS;
+	struct scic_sds_request *the_request;
+	u32 index;
+	u32 request_count    = this_device->started_request_count;
+
+	for (index = 0;
+	     (index < SCI_MAX_IO_REQUESTS) && (request_count > 0);
+	     index++) {
+		the_request = this_device->owning_port->owning_controller->io_request_table[index];
+
+		if ((the_request != NULL) && (the_request->target_device == this_device)) {
+			terminate_status = scic_controller_terminate_request(
+				this_device->owning_port->owning_controller,
+				this_device,
+				the_request
+				);
+
+			if (terminate_status != SCI_SUCCESS)
+				status = terminate_status;
+
+			request_count--;
+		}
+	}
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  DEFAULT STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default start handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_start_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to start while in wrong "
+		 "state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default stop handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+static enum sci_status scic_sds_remote_device_default_stop_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to stop while in wrong "
+		 "state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default fail handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_fail_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to fail while in wrong "
+		 "state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default destruct handler.  It logs a warning and returns
+ * a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_destruct_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to destroy while in "
+		 "wrong state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default reset handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_reset_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to reset while in wrong "
+		 "state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default reset complete handler.  It logs a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_reset_complete_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to complete reset while "
+		 "in wrong state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default suspend handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_suspend_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type)
+{
+	dev_warn(scirdev_to_dev(this_device),
+		 "%s: SCIC Remote Device 0x%p requested to suspend %d while "
+		 "in wrong state %d\n",
+		 __func__,
+		 this_device,
+		 suspend_type,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 this_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method is the default resume handler.  It logs a warning and returns a
+ * failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_resume_handler(
+	struct scic_sds_remote_device *this_device)
+{
+	dev_warn(scirdev_to_dev(this_device),
+		 "%s: SCIC Remote Device requested to resume while in "
+		 "wrong state %d\n",
+		 __func__,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 this_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @event_code: The event code that the struct scic_sds_controller wants the device
+ *    object to process.
+ *
+ * This method is the default event handler.  It will call the RNC state
+ * machine handler for any RNC events otherwise it will log a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+static enum sci_status  scic_sds_remote_device_core_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code,
+	bool is_ready_state)
+{
+	enum sci_status status;
+
+	switch (scu_get_event_type(event_code)) {
+	case SCU_EVENT_TYPE_RNC_OPS_MISC:
+	case SCU_EVENT_TYPE_RNC_SUSPEND_TX:
+	case SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX:
+		status = scic_sds_remote_node_context_event_handler(this_device->rnc, event_code);
+		break;
+	case SCU_EVENT_TYPE_PTX_SCHEDULE_EVENT:
+
+		if (scu_get_event_code(event_code) == SCU_EVENT_IT_NEXUS_TIMEOUT) {
+			status = SCI_SUCCESS;
+
+			/* Suspend the associated RNC */
+			scic_sds_remote_node_context_suspend(this_device->rnc,
+							      SCI_SOFTWARE_SUSPENSION,
+							      NULL, NULL);
+
+			dev_dbg(scirdev_to_dev(this_device),
+				"%s: device: %p event code: %x: %s\n",
+				__func__, this_device, event_code,
+				(is_ready_state)
+				? "I_T_Nexus_Timeout event"
+				: "I_T_Nexus_Timeout event in wrong state");
+
+			break;
+		}
+	/* Else, fall through and treat as unhandled... */
+
+	default:
+		dev_dbg(scirdev_to_dev(this_device),
+			"%s: device: %p event code: %x: %s\n",
+			__func__, this_device, event_code,
+			(is_ready_state)
+			? "unexpected event"
+			: "unexpected event in wrong state");
+		status = SCI_FAILURE_INVALID_STATE;
+		break;
+	}
+
+	return status;
+}
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @event_code: The event code that the struct scic_sds_controller wants the device
+ *    object to process.
+ *
+ * This method is the default event handler.  It will call the RNC state
+ * machine handler for any RNC events otherwise it will log a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+static enum sci_status  scic_sds_remote_device_default_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code)
+{
+	return scic_sds_remote_device_core_event_handler(this_device,
+							  event_code,
+							  false);
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @frame_index: The frame index for which the struct scic_sds_controller wants this
+ *    device object to process.
+ *
+ * This method is the default unsolicited frame handler.  It logs a warning,
+ * releases the frame and returns a failure. enum sci_status
+ * SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	dev_warn(scirdev_to_dev(this_device),
+		 "%s: SCIC Remote Device requested to handle frame %x "
+		 "while in wrong state %d\n",
+		 __func__,
+		 frame_index,
+		 sci_base_state_machine_get_state(
+			 &this_device->parent.state_machine));
+
+	/* Return the frame back to the controller */
+	scic_sds_controller_release_frame(
+		scic_sds_remote_device_get_controller(this_device), frame_index
+		);
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @request: The struct sci_base_request which is then cast into a SCIC_SDS_IO_REQUEST
+ *    to start.
+ *
+ * This method is the default start io handler.  It logs a warning and returns
+ * a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_start_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to start io request %p "
+		 "while in wrong state %d\n",
+		 __func__,
+		 request,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 (struct scic_sds_remote_device *)device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @request: The struct sci_base_request which is then cast into a SCIC_SDS_IO_REQUEST
+ *    to complete.
+ *
+ * This method is the default complete io handler.  It logs a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to complete io_request %p "
+		 "while in wrong state %d\n",
+		 __func__,
+		 request,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+				 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @request: The struct sci_base_request which is then cast into a SCIC_SDS_IO_REQUEST
+ *    to continue.
+ *
+ * This method is the default continue io handler.  It logs a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_default_continue_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	struct scic_sds_remote_device *sds_device =
+		(struct scic_sds_remote_device *)device;
+
+	dev_warn(scirdev_to_dev(sds_device),
+		 "%s: SCIC Remote Device requested to continue io request %p "
+		 "while in wrong state %d\n",
+		 __func__,
+		 request,
+		 sci_base_state_machine_get_state(
+			 scic_sds_remote_device_get_base_state_machine(
+			 sds_device)));
+
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @request: The struct sci_base_request which is then cast into a SCIC_SDS_IO_REQUEST
+ *    to complete.
+ *
+ * This method is the default complete task handler.  It logs a warning and
+ * returns a failure. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+
+/*
+ * *****************************************************************************
+ * *  NORMAL STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is then cast into a
+ *    struct scic_sds_remote_device.
+ * @frame_index: The frame index for which the struct scic_sds_controller wants this
+ *    device object to process.
+ *
+ * This method is a general ssp frame handler.  In most cases the device object
+ * needs to route the unsolicited frame processing to the io request object.
+ * This method decodes the tag for the io request object and routes the
+ * unsolicited frame to that object. enum sci_status SCI_FAILURE_INVALID_STATE
+ */
+enum sci_status scic_sds_remote_device_general_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	enum sci_status result;
+	struct sci_ssp_frame_header *frame_header;
+	struct scic_sds_request *io_request;
+
+	result = scic_sds_unsolicited_frame_control_get_header(
+		&(scic_sds_remote_device_get_controller(this_device)->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (SCI_SUCCESS == result) {
+		io_request = scic_sds_controller_get_io_request_from_tag(
+			scic_sds_remote_device_get_controller(this_device), frame_header->tag);
+
+		if ((io_request == NULL)
+		    || (io_request->target_device != this_device)) {
+			/*
+			 * We could not map this tag to a valid IO request
+			 * Just toss the frame and continue */
+			scic_sds_controller_release_frame(
+				scic_sds_remote_device_get_controller(this_device), frame_index
+				);
+		} else {
+			/* The IO request is now in charge of releasing the frame */
+			result = io_request->state_handlers->frame_handler(
+				io_request, frame_index);
+		}
+	}
+
+	return result;
+}
+
+/**
+ *
+ * @[in]: this_device This is the device object that is receiving the event.
+ * @[in]: event_code The event code to process.
+ *
+ * This is a common method for handling events reported to the remote device
+ * from the controller object. enum sci_status
+ */
+enum sci_status scic_sds_remote_device_general_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code)
+{
+	return scic_sds_remote_device_core_event_handler(this_device,
+							  event_code,
+							  true);
+}
+
+/*
+ * *****************************************************************************
+ * *  STOPPED STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device:
+ *
+ * This method takes the struct scic_sds_remote_device from a stopped state and
+ * attempts to start it.   The RNC buffer for the device is constructed and the
+ * device state machine is transitioned to the
+ * SCIC_BASE_REMOTE_DEVICE_STATE_STARTING. enum sci_status SCI_SUCCESS if there is
+ * an RNC buffer available to construct the remote device.
+ * SCI_FAILURE_INSUFFICIENT_RESOURCES if there is no RNC buffer available in
+ * which to construct the remote device.
+ */
+static enum sci_status scic_sds_remote_device_stopped_state_start_handler(
+	struct sci_base_remote_device *device)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	status = scic_sds_remote_node_context_resume(
+		this_device->rnc,
+		scic_sds_remote_device_resume_complete_handler,
+		this_device
+		);
+
+	if (status == SCI_SUCCESS) {
+		sci_base_state_machine_change_state(
+			scic_sds_remote_device_get_base_state_machine(this_device),
+			SCI_BASE_REMOTE_DEVICE_STATE_STARTING
+			);
+	}
+
+	return status;
+}
+
+/**
+ *
+ * @this_device: The struct sci_base_remote_device which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method will stop a struct scic_sds_remote_device that is already in a stopped
+ * state.  This is not considered an error since the device is already stopped.
+ * enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_device_stopped_state_stop_handler(
+	struct sci_base_remote_device *this_device)
+{
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @this_device: The struct sci_base_remote_device which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method will destruct a struct scic_sds_remote_device that is in a stopped
+ * state.  This is the only state from which a destruct request will succeed.
+ * The RNi for this struct scic_sds_remote_device is returned to the free pool and the
+ * device object transitions to the SCI_BASE_REMOTE_DEVICE_STATE_FINAL.
+ * enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_device_stopped_state_destruct_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	scic_sds_controller_free_remote_node_context(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device,
+		this_device->rnc->remote_node_index
+		);
+
+	scic_sds_remote_node_context_set_remote_node_index(
+		this_device->rnc,
+		SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX
+		);
+
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_FINAL
+		);
+
+	return SCI_SUCCESS;
+}
+
+/*
+ * *****************************************************************************
+ * *  STARTING STATE HANDLERS
+ * ***************************************************************************** */
+
+static enum sci_status scic_sds_remote_device_starting_state_stop_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	/*
+	 * This device has not yet started so there had better be no IO requests
+	 */
+	BUG_ON(this_device->started_request_count != 0);
+
+	/*
+	 * Destroy the remote node context
+	 */
+	scic_sds_remote_node_context_destruct(
+		this_device->rnc,
+		scic_sds_cb_remote_device_rnc_destruct_complete,
+		this_device
+		);
+
+	/*
+	 * Transition to the stopping state and wait for the remote node to
+	 * complete being posted and invalidated.
+	 */
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPING
+		);
+
+	return SCI_SUCCESS;
+}
+
+/*
+ * *****************************************************************************
+ * *  INITIALIZING STATE HANDLERS
+ * ***************************************************************************** */
+
+/* There is nothing to do here for SSP devices */
+
+/*
+ * *****************************************************************************
+ * *  READY STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @this_device: The struct scic_sds_remote_device object to be suspended.
+ *
+ * This method is the resume handler for the struct scic_sds_remote_device object. It
+ * will post an RNC resume to the SCU hardware. enum sci_status SCI_SUCCESS
+ */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device object which is cast to a
+ *    struct scic_sds_remote_device object.
+ *
+ * This method is the default stop handler for the struct scic_sds_remote_device ready
+ * substate machine. It will stop the current substate machine and transition
+ * the base state machine to SCI_BASE_REMOTE_DEVICE_STATE_STOPPING. enum sci_status
+ * SCI_SUCCESS
+ */
+enum sci_status scic_sds_remote_device_ready_state_stop_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	enum sci_status status      = SCI_SUCCESS;
+
+	/* Request the parent state machine to transition to the stopping state */
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPING
+		);
+
+	if (this_device->started_request_count == 0) {
+		scic_sds_remote_node_context_destruct(
+			this_device->rnc,
+			scic_sds_cb_remote_device_rnc_destruct_complete,
+			this_device
+			);
+	} else
+		status = scic_sds_remote_device_terminate_requests(this_device);
+
+	return status;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device object which is cast to a
+ *    struct scic_sds_remote_device object.
+ *
+ * This is the ready state device reset handler enum sci_status
+ */
+enum sci_status scic_sds_remote_device_ready_state_reset_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	/* Request the parent state machine to transition to the stopping state */
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_RESETTING
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device object which is cast to a
+ *    struct scic_sds_remote_device object.
+ *
+ * This is the default fail handler for the struct scic_sds_remote_device ready
+ * substate machine.  It will stop the current ready substate and transition
+ * the remote device object to the SCI_BASE_REMOTE_DEVICE_STATE_FAILED.
+ * enum sci_status SCI_SUCCESS
+ */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is cast to a
+ *    struct scic_sds_remote_device for which the request is to be started.
+ * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
+ *    is to be started.
+ *
+ * This method will attempt to start a task request for this device object. The
+ * remote device object will issue the start request for the task and if
+ * successful it will start the request for the port object then increment its
+ * own requet count. enum sci_status SCI_SUCCESS if the task request is started for
+ * this device object. SCI_FAILURE_INSUFFICIENT_RESOURCES if the io request
+ * object could not get the resources to start.
+ */
+static enum sci_status scic_sds_remote_device_ready_state_start_task_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status result;
+	struct scic_sds_remote_device *this_device  = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *task_request = (struct scic_sds_request *)request;
+
+	/* See if the port is in a state where we can start the IO request */
+	result = scic_sds_port_start_io(
+		scic_sds_remote_device_get_port(this_device), this_device, task_request);
+
+	if (result == SCI_SUCCESS) {
+		result = scic_sds_remote_node_context_start_task(
+			this_device->rnc, task_request
+			);
+
+		if (result == SCI_SUCCESS) {
+			result = scic_sds_request_start(task_request);
+		}
+
+		scic_sds_remote_device_start_request(this_device, task_request, result);
+	}
+
+	return result;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is cast to a
+ *    struct scic_sds_remote_device for which the request is to be started.
+ * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
+ *    is to be started.
+ *
+ * This method will attempt to start an io request for this device object. The
+ * remote device object will issue the start request for the io and if
+ * successful it will start the request for the port object then increment its
+ * own requet count. enum sci_status SCI_SUCCESS if the io request is started for
+ * this device object. SCI_FAILURE_INSUFFICIENT_RESOURCES if the io request
+ * object could not get the resources to start.
+ */
+static enum sci_status scic_sds_remote_device_ready_state_start_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status result;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *io_request  = (struct scic_sds_request *)request;
+
+	/* See if the port is in a state where we can start the IO request */
+	result = scic_sds_port_start_io(
+		scic_sds_remote_device_get_port(this_device), this_device, io_request);
+
+	if (result == SCI_SUCCESS) {
+		result = scic_sds_remote_node_context_start_io(
+			this_device->rnc, io_request
+			);
+
+		if (result == SCI_SUCCESS) {
+			result = scic_sds_request_start(io_request);
+		}
+
+		scic_sds_remote_device_start_request(this_device, io_request, result);
+	}
+
+	return result;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is cast to a
+ *    struct scic_sds_remote_device for which the request is to be completed.
+ * @request: The struct sci_base_request which is cast to a SCIC_SDS_IO_REQUEST that
+ *    is to be completed.
+ *
+ * This method will complete the request for the remote device object.  The
+ * method will call the completion handler for the request object and if
+ * successful it will complete the request on the port object then decrement
+ * its own started_request_count. enum sci_status
+ */
+static enum sci_status scic_sds_remote_device_ready_state_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status result;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
+
+	result = scic_sds_request_complete(the_request);
+
+	if (result == SCI_SUCCESS) {
+		/* See if the port is in a state where we can start the IO request */
+		result = scic_sds_port_complete_io(
+			scic_sds_remote_device_get_port(this_device), this_device, the_request);
+
+		if (result == SCI_SUCCESS) {
+			scic_sds_remote_device_decrement_request_count(this_device);
+		}
+	}
+
+	return result;
+}
+
+/*
+ * *****************************************************************************
+ * *  STOPPING STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @this_device: The struct sci_base_remote_device which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This method will stop a struct scic_sds_remote_device that is already in the
+ * SCI_BASE_REMOTE_DEVICE_STATE_STOPPING state. This is not considered an error
+ * since we allow a stop request on a device that is alreay stopping or
+ * stopped. enum sci_status SCI_SUCCESS
+ */
+static enum sci_status scic_sds_remote_device_stopping_state_stop_handler(
+	struct sci_base_remote_device *device)
+{
+	/*
+	 * All requests should have been terminated, but if there is an
+	 * attempt to stop a device already in the stopping state, then
+	 * try again to terminate. */
+	return scic_sds_remote_device_terminate_requests(
+		       (struct scic_sds_remote_device *)device);
+}
+
+
+/**
+ *
+ * @device: The device object for which the request is completing.
+ * @request: The task request that is being completed.
+ *
+ * This method completes requests for this struct scic_sds_remote_device while it is
+ * in the SCI_BASE_REMOTE_DEVICE_STATE_STOPPING state. This method calls the
+ * complete method for the request object and if that is successful the port
+ * object is called to complete the task request. Then the device object itself
+ * completes the task request. If struct scic_sds_remote_device started_request_count
+ * goes to 0 and the invalidate RNC request has completed the device object can
+ * transition to the SCI_BASE_REMOTE_DEVICE_STATE_STOPPED. enum sci_status
+ */
+static enum sci_status scic_sds_remote_device_stopping_state_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status status = SCI_SUCCESS;
+	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	status = scic_sds_request_complete(this_request);
+	if (status == SCI_SUCCESS) {
+		status = scic_sds_port_complete_io(
+			scic_sds_remote_device_get_port(this_device),
+			this_device,
+			this_request
+			);
+
+		if (status == SCI_SUCCESS) {
+			scic_sds_remote_device_decrement_request_count(this_device);
+
+			if (scic_sds_remote_device_get_request_count(this_device) == 0) {
+				scic_sds_remote_node_context_destruct(
+					this_device->rnc,
+					scic_sds_cb_remote_device_rnc_destruct_complete,
+					this_device
+					);
+			}
+		}
+	}
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  RESETTING STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is to be cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ * This method will complete the reset operation when the device is in the
+ * resetting state. enum sci_status
+ */
+static enum sci_status scic_sds_remote_device_resetting_state_reset_complete_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	sci_base_state_machine_change_state(
+		&this_device->parent.state_machine,
+		SCI_BASE_REMOTE_DEVICE_STATE_READY
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is to be cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ * This method will stop the remote device while in the resetting state.
+ * enum sci_status
+ */
+static enum sci_status scic_sds_remote_device_resetting_state_stop_handler(
+	struct sci_base_remote_device *device)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	sci_base_state_machine_change_state(
+		&this_device->parent.state_machine,
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPING
+		);
+
+	return SCI_SUCCESS;
+}
+
+/**
+ *
+ * @device: The device object for which the request is completing.
+ * @request: The task request that is being completed.
+ *
+ * This method completes requests for this struct scic_sds_remote_device while it is
+ * in the SCI_BASE_REMOTE_DEVICE_STATE_RESETTING state. This method calls the
+ * complete method for the request object and if that is successful the port
+ * object is called to complete the task request. Then the device object itself
+ * completes the task request. enum sci_status
+ */
+static enum sci_status scic_sds_remote_device_resetting_state_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status status = SCI_SUCCESS;
+	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+
+	status = scic_sds_request_complete(this_request);
+
+	if (status == SCI_SUCCESS) {
+		status = scic_sds_port_complete_io(
+			scic_sds_remote_device_get_port(this_device), this_device, this_request);
+
+		if (status == SCI_SUCCESS) {
+			scic_sds_remote_device_decrement_request_count(this_device);
+		}
+	}
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  FAILED STATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: The struct sci_base_remote_device which is to be cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ * This method handles the remove request for a failed struct scic_sds_remote_device
+ * object. The method will transition the device object to the
+ * SCIC_BASE_REMOTE_DEVICE_STATE_STOPPING. enum sci_status SCI_SUCCESS
+ */
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_remote_device_state_handler scic_sds_remote_device_state_handler_table[] = {
+	[SCI_BASE_REMOTE_DEVICE_STATE_INITIAL] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_default_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_default_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STOPPED] = {
+		.parent.start_handler		= scic_sds_remote_device_stopped_state_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_stopped_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_stopped_state_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_default_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STARTING] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_starting_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_READY] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_ready_state_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_ready_state_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_ready_state_start_task_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_ready_state_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler,
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STOPPING] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_stopping_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_stopping_state_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_stopping_state_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_FAILED] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_default_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_default_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_RESETTING] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_resetting_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_resetting_state_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_resetting_state_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_resetting_state_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_default_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_FINAL] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_default_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_default_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	}
+};
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_INITIAL it
+ * immediatly transitions the remote device object to the stopped state. none
+ */
+static void scic_sds_remote_device_initial_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_INITIAL
+		);
+
+	/* Initial state is a transitional state to the stopped state */
+	sci_base_state_machine_change_state(
+		scic_sds_remote_device_get_base_state_machine(this_device),
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPED
+		);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_INITIAL it
+ * sets the stopped state handlers and if this state is entered from the
+ * SCI_BASE_REMOTE_DEVICE_STATE_STOPPING then the SCI User is informed that the
+ * device stop is complete. none
+ */
+static void scic_sds_remote_device_stopped_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPED
+		);
+
+	/*
+	 * If we are entering from the stopping state let the SCI User know that
+	 * the stop operation has completed. */
+	if (this_device->parent.state_machine.previous_state_id
+	    == SCI_BASE_REMOTE_DEVICE_STATE_STOPPING) {
+		isci_event_remote_device_stop_complete(
+			scic_sds_remote_device_get_controller(this_device),
+			this_device,
+			SCI_SUCCESS
+			);
+	}
+
+	scic_sds_controller_remote_device_stopped(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device
+	);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_STARTING it
+ * sets the starting state handlers, sets the device not ready, and posts the
+ * remote node context to the hardware. none
+ */
+static void scic_sds_remote_device_starting_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_controller *the_controller;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	the_controller = scic_sds_remote_device_get_controller(this_device);
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_STARTING
+		);
+
+	isci_event_remote_device_not_ready(
+		the_controller,
+		this_device,
+		SCIC_REMOTE_DEVICE_NOT_READY_START_REQUESTED
+		);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the exit method for the SCI_BASE_REMOTE_DEVICE_STATE_STARTING it
+ * reports that the device start is complete. none
+ */
+static void scic_sds_remote_device_starting_state_exit(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	/*
+	 * / @todo Check the device object for the proper return code for this
+	 * /       callback */
+	isci_event_remote_device_start_complete(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device,
+		SCI_SUCCESS
+		);
+
+	scic_sds_controller_remote_device_started(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device
+	);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_READY it sets
+ * the ready state handlers, and starts the ready substate machine. none
+ */
+static void scic_sds_remote_device_ready_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_controller *the_controller;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	the_controller = scic_sds_remote_device_get_controller(this_device);
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_READY
+		);
+
+	the_controller->remote_device_sequence[this_device->rnc->remote_node_index]++;
+
+	if (this_device->has_ready_substate_machine) {
+		sci_base_state_machine_start(&this_device->ready_substate_machine);
+	} else {
+		isci_event_remote_device_ready(the_controller, this_device);
+	}
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the exit method for the SCI_BASE_REMOTE_DEVICE_STATE_READY it does
+ * nothing. none
+ */
+static void scic_sds_remote_device_ready_state_exit(
+	struct sci_base_object *object)
+{
+	struct scic_sds_controller *the_controller;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	the_controller = scic_sds_remote_device_get_controller(this_device);
+
+	if (this_device->has_ready_substate_machine) {
+		sci_base_state_machine_stop(&this_device->ready_substate_machine);
+	} else {
+		isci_event_remote_device_not_ready(
+			the_controller,
+			this_device,
+			SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED
+			);
+	}
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_STOPPING it
+ * sets the stopping state handlers and posts an RNC invalidate request to the
+ * SCU hardware. none
+ */
+static void scic_sds_remote_device_stopping_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_STOPPING
+		);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_FAILED it sets
+ * the stopping state handlers. none
+ */
+static void scic_sds_remote_device_failed_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_FAILED
+		);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_RESETTING it
+ * sets the resetting state handlers. none
+ */
+static void scic_sds_remote_device_resetting_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_RESETTING
+		);
+
+	scic_sds_remote_node_context_suspend(
+		this_device->rnc, SCI_SOFTWARE_SUSPENSION, NULL, NULL);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the exit method for the SCI_BASE_REMOTE_DEVICE_STATE_RESETTING it
+ * does nothing. none
+ */
+static void scic_sds_remote_device_resetting_state_exit(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	scic_sds_remote_node_context_resume(this_device->rnc, NULL, NULL);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object that is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the enter method for the SCI_BASE_REMOTE_DEVICE_STATE_FINAL it sets
+ * the final state handlers. none
+ */
+static void scic_sds_remote_device_final_state_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_remote_device_state_handler_table,
+		SCI_BASE_REMOTE_DEVICE_STATE_FINAL
+		);
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_remote_device_state_table[] = {
+	[SCI_BASE_REMOTE_DEVICE_STATE_INITIAL] = {
+		.enter_state = scic_sds_remote_device_initial_state_enter,
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STOPPED] = {
+		.enter_state = scic_sds_remote_device_stopped_state_enter,
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STARTING] = {
+		.enter_state = scic_sds_remote_device_starting_state_enter,
+		.exit_state  = scic_sds_remote_device_starting_state_exit
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_READY] = {
+		.enter_state = scic_sds_remote_device_ready_state_enter,
+		.exit_state  = scic_sds_remote_device_ready_state_exit
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_STOPPING] = {
+		.enter_state = scic_sds_remote_device_stopping_state_enter,
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_FAILED] = {
+		.enter_state = scic_sds_remote_device_failed_state_enter,
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_RESETTING] = {
+		.enter_state = scic_sds_remote_device_resetting_state_enter,
+		.exit_state  = scic_sds_remote_device_resetting_state_exit
+	},
+	[SCI_BASE_REMOTE_DEVICE_STATE_FINAL] = {
+		.enter_state = scic_sds_remote_device_final_state_enter,
+	},
+};
+
diff --git a/drivers/scsi/isci/core/scic_sds_remote_device.h b/drivers/scsi/isci/core/scic_sds_remote_device.h
new file mode 100644
index 0000000..4841e45
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_remote_device.h
@@ -0,0 +1,570 @@
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
+#ifndef _SCIC_SDS_REMOTE_DEVICE_H_
+#define _SCIC_SDS_REMOTE_DEVICE_H_
+
+/**
+ * This file contains the structures, constants, and prototypes for the
+ *    struct scic_sds_remote_device object.
+ *
+ *
+ */
+
+#include "intel_sas.h"
+#include "sci_base_remote_device.h"
+#include "sci_base_request.h"
+#include "scu_remote_node_context.h"
+#include "scic_sds_remote_node_context.h"
+
+struct scic_sds_controller;
+struct scic_sds_port;
+struct scic_sds_request;
+struct scic_sds_remote_device_state_handler;
+
+/**
+ * enum scic_sds_ssp_remote_device_ready_substates -
+ *
+ * This is the enumeration of the ready substates for the
+ * struct scic_sds_remote_device.
+ */
+enum scic_sds_ssp_remote_device_ready_substates {
+	/**
+	 * This is the initial state for the remote device ready substate.
+	 */
+	SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_INITIAL,
+
+	/**
+	 * This is the ready operational substate for the remote device.
+	 * This is the normal operational state for a remote device.
+	 */
+	SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_OPERATIONAL,
+
+	/**
+	 * This is the suspended state for the remote device. This is the state
+	 * that the device is placed in when a RNC suspend is received by
+	 * the SCU hardware.
+	 */
+	SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_SUSPENDED,
+
+	/**
+	 * This is the final state that the device is placed in before a change
+	 * to the base state machine.
+	 */
+	SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_FINAL,
+
+	SCIC_SDS_SSP_REMOTE_DEVICE_READY_MAX_SUBSTATES
+};
+
+/**
+ * enum scic_sds_stp_remote_device_ready_substates -
+ *
+ * This is the enumeration for the struct scic_sds_remote_device ready substates
+ * for the STP remote device.
+ */
+enum scic_sds_stp_remote_device_ready_substates {
+	/**
+	 * This is the idle substate for the stp remote device.  When there are no
+	 * active IO for the device it is is in this state.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE,
+
+	/**
+	 * This is the command state for for the STP remote device.  This state is
+	 * entered when the device is processing a non-NCQ command.  The device object
+	 * will fail any new start IO requests until this command is complete.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD,
+
+	/**
+	 * This is the NCQ state for the STP remote device.  This state is entered
+	 * when the device is processing an NCQ reuqest.  It will remain in this state
+	 * so long as there is one or more NCQ requests being processed.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ,
+
+	/**
+	 * This is the NCQ error state for the STP remote device.  This state is
+	 * entered when an SDB error FIS is received by the device object while in the
+	 * NCQ state.  The device object will only accept a READ LOG command while in
+	 * this state.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR,
+
+#if !defined(DISABLE_ATAPI)
+	/**
+	 * This is the ATAPI error state for the STP ATAPI remote device.  This state is
+	 * entered when ATAPI device sends error status FIS without data while the device
+	 * object is in CMD state. A suspension event is expected in this state. The device
+	 * object will resume right away.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_ATAPI_ERROR,
+#endif
+
+	/**
+	 * This is the READY substate indicates the device is waiting for the RESET task
+	 * coming to be recovered from certain hardware specific error.
+	 */
+	SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_AWAIT_RESET,
+};
+
+/**
+ * enum scic_sds_smp_remote_device_ready_substates -
+ *
+ * This is the enumeration of the ready substates for the SMP REMOTE DEVICE.
+ */
+enum scic_sds_smp_remote_device_ready_substates {
+	/**
+	 * This is the ready operational substate for the remote device.  This is the
+	 * normal operational state for a remote device.
+	 */
+	SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE,
+
+	/**
+	 * This is the suspended state for the remote device.  This is the state that
+	 * the device is placed in when a RNC suspend is received by the SCU hardware.
+	 */
+	SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD,
+};
+
+/**
+ * struct scic_sds_remote_device - This structure contains the data for an SCU
+ *    implementation of the SCU Core device data.
+ *
+ *
+ */
+struct scic_sds_remote_device {
+	/**
+	 * This field is the common base for all remote device objects.
+	 */
+	struct sci_base_remote_device parent;
+
+	/**
+	 * This field is the programmed device port width.  This value is written to
+	 * the RCN data structure to tell the SCU how many open connections this
+	 * device can have.
+	 */
+	u32 device_port_width;
+
+	/**
+	 * This field is the programmed connection rate for this remote device.  It is
+	 * used to program the TC with the maximum allowed connection rate.
+	 */
+	enum sci_sas_link_rate connection_rate;
+
+	/**
+	 * This field contains the allowed target protocols for this remote device.
+	 */
+	struct smp_discover_response_protocols target_protocols;
+
+	/**
+	 * This field contains the device SAS address.
+	 */
+	struct sci_sas_address device_address;
+
+	/**
+	 * This filed is assinged the value of true if the device is directly
+	 * attached to the port.
+	 */
+	bool is_direct_attached;
+
+#if !defined(DISABLE_ATAPI)
+	/**
+	 * This filed is assinged the value of true if the device is an ATAPI
+	 * device.
+	 */
+	bool is_atapi;
+#endif
+
+	/**
+	 * This filed contains a pointer back to the port to which this device
+	 * is assigned.
+	 */
+	struct scic_sds_port *owning_port;
+
+	/**
+	 * This field contains the SCU silicon remote node context specific
+	 * information.
+	 */
+	struct scic_sds_remote_node_context *rnc;
+
+	/**
+	 * This field contains the stated request count for the remote device.  The
+	 * device can not reach the SCI_BASE_REMOTE_DEVICE_STATE_STOPPED until all
+	 * requests are complete and the rnc_posted value is false.
+	 */
+	u32 started_request_count;
+
+	/**
+	 * This field contains a pointer to the working request object.  It is only
+	 * used only for SATA requests since the unsolicited frames we get from the
+	 * hardware have no Tag value to look up the io request object.
+	 */
+	struct scic_sds_request *working_request;
+
+	/**
+	 * This field contains the reason for the remote device going not_ready.  It is
+	 * assigned in the state handlers and used in the state transition.
+	 */
+	u32 not_ready_reason;
+
+	/**
+	 * This field is true if this remote device has an initialzied ready substate
+	 * machine. SSP devices do not have a ready substate machine and STP devices
+	 * have a ready substate machine.
+	 */
+	bool has_ready_substate_machine;
+
+	/**
+	 * This field contains the state machine for the ready substate machine for
+	 * this struct scic_sds_remote_device object.
+	 */
+	struct sci_base_state_machine ready_substate_machine;
+
+	/**
+	 * This field maintains the set of state handlers for the remote device
+	 * object.  These are changed each time the remote device enters a new state.
+	 */
+	const struct scic_sds_remote_device_state_handler *state_handlers;
+};
+
+typedef enum sci_status (*scic_sds_remote_device_handler_t)(
+	struct scic_sds_remote_device *this_device);
+
+typedef enum sci_status (*scic_sds_remote_device_suspend_handler_t)(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type);
+
+typedef enum sci_status (*scic_sds_remote_device_resume_handler_t)(
+	struct scic_sds_remote_device *this_device);
+
+typedef enum sci_status (*scic_sds_remote_device_frame_handler_t)(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index);
+
+typedef enum sci_status (*scic_sds_remote_device_event_handler_t)(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code);
+
+typedef void (*scic_sds_remote_device_ready_not_ready_handler_t)(
+	struct scic_sds_remote_device *this_device);
+
+/**
+ * struct scic_sds_remote_device_state_handler - This structure conains the
+ *    state handlers that are needed to process requests for the SCU remote
+ *    device objects.
+ *
+ *
+ */
+struct scic_sds_remote_device_state_handler {
+	struct sci_base_remote_device_state_handler parent;
+	scic_sds_remote_device_suspend_handler_t suspend_handler;
+	scic_sds_remote_device_resume_handler_t resume_handler;
+	scic_sds_remote_device_event_handler_t event_handler;
+	scic_sds_remote_device_frame_handler_t frame_handler;
+};
+
+extern const struct sci_base_state scic_sds_remote_device_state_table[];
+extern const struct sci_base_state scic_sds_ssp_remote_device_ready_substate_table[];
+extern const struct sci_base_state scic_sds_stp_remote_device_ready_substate_table[];
+extern const struct sci_base_state scic_sds_smp_remote_device_ready_substate_table[];
+
+extern const struct scic_sds_remote_device_state_handler scic_sds_remote_device_state_handler_table[];
+extern const struct scic_sds_remote_device_state_handler scic_sds_stp_remote_device_ready_substate_handler_table[];
+extern const struct scic_sds_remote_device_state_handler scic_sds_smp_remote_device_ready_substate_handler_table[];
+
+/**
+ * scic_sds_remote_device_increment_request_count() -
+ *
+ * This macro incrments the request count for this device
+ */
+#define scic_sds_remote_device_increment_request_count(this_device) \
+	((this_device)->started_request_count++)
+
+/**
+ * scic_sds_remote_device_decrement_request_count() -
+ *
+ * This macro decrements the request count for this device.  This count will
+ * never decrment past 0.
+ */
+#define scic_sds_remote_device_decrement_request_count(this_device) \
+	((this_device)->started_request_count > 0 ? \
+	 (this_device)->started_request_count-- : 0)
+
+/**
+ * scic_sds_remote_device_get_request_count() -
+ *
+ * This is a helper macro to return the current device request count.
+ */
+#define scic_sds_remote_device_get_request_count(this_device) \
+	((this_device)->started_request_count)
+
+/**
+ * scic_sds_remote_device_get_port() -
+ *
+ * This macro returns the owning port of this remote device obejct.
+ */
+#define scic_sds_remote_device_get_port(this_device) \
+	((this_device)->owning_port)
+
+/**
+ * scic_sds_remote_device_get_controller() -
+ *
+ * This macro returns the controller object that contains this device object
+ */
+#define scic_sds_remote_device_get_controller(this_device) \
+	scic_sds_port_get_controller(scic_sds_remote_device_get_port(this_device))
+
+/**
+ * scic_sds_remote_device_set_state_handlers() -
+ *
+ * This macro sets the remote device state handlers pointer and is set on entry
+ * to each device state.
+ */
+#define scic_sds_remote_device_set_state_handlers(this_device, handlers) \
+	((this_device)->state_handlers = (handlers))
+
+/**
+ * scic_sds_remote_device_get_base_state_machine() -
+ *
+ * This macro returns the base sate machine object for the remote device.
+ */
+#define scic_sds_remote_device_get_base_state_machine(this_device) \
+	(&(this_device)->parent.state_machine)
+
+/**
+ * scic_sds_remote_device_get_ready_substate_machine() -
+ *
+ * This macro returns the remote device ready substate machine
+ */
+#define scic_sds_remote_device_get_ready_substate_machine(this_device) \
+	(&(this_device)->ready_substate_machine)
+
+/**
+ * scic_sds_remote_device_get_port() -
+ *
+ * This macro returns the owning port of this device
+ */
+#define scic_sds_remote_device_get_port(this_device) \
+	((this_device)->owning_port)
+
+/**
+ * scic_sds_remote_device_get_sequence() -
+ *
+ * This macro returns the remote device sequence value
+ */
+#define scic_sds_remote_device_get_sequence(this_device) \
+	(\
+		scic_sds_remote_device_get_controller(this_device)-> \
+		remote_device_sequence[(this_device)->rnc->remote_node_index] \
+	)
+
+/**
+ * scic_sds_remote_device_get_controller_peg() -
+ *
+ * This macro returns the controllers protocol engine group
+ */
+#define scic_sds_remote_device_get_controller_peg(this_device) \
+	(\
+		scic_sds_controller_get_protocol_engine_group(\
+			scic_sds_port_get_controller(\
+				scic_sds_remote_device_get_port(this_device) \
+				) \
+			) \
+	)
+
+/**
+ * scic_sds_remote_device_get_port_index() -
+ *
+ * This macro returns the port index for the devices owning port
+ */
+#define scic_sds_remote_device_get_port_index(this_device) \
+	(scic_sds_port_get_index(scic_sds_remote_device_get_port(this_device)))
+
+/**
+ * scic_sds_remote_device_get_index() -
+ *
+ * This macro returns the remote node index for this device object
+ */
+#define scic_sds_remote_device_get_index(this_device) \
+	((this_device)->rnc->remote_node_index)
+
+/**
+ * scic_sds_remote_device_build_command_context() -
+ *
+ * This macro builds a remote device context for the SCU post request operation
+ */
+#define scic_sds_remote_device_build_command_context(device, command) \
+	((command) \
+	 | (scic_sds_remote_device_get_controller_peg((device)) << SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_SHIFT) \
+	 | (scic_sds_remote_device_get_port_index((device)) << SCU_CONTEXT_COMMAND_LOGICAL_PORT_SHIFT) \
+	 | (scic_sds_remote_device_get_index((device)))	\
+	)
+
+/**
+ * scic_sds_remote_device_set_working_request() -
+ *
+ * This macro makes the working request assingment for the remote device
+ * object. To clear the working request use this macro with a NULL request
+ * object.
+ */
+#define scic_sds_remote_device_set_working_request(device, request) \
+	((device)->working_request = (request))
+
+enum sci_status scic_sds_remote_device_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index);
+
+enum sci_status scic_sds_remote_device_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code);
+
+enum sci_status scic_sds_remote_device_start_io(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request);
+
+enum sci_status scic_sds_remote_device_complete_io(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request);
+
+enum sci_status scic_sds_remote_device_resume(
+	struct scic_sds_remote_device *this_device);
+
+enum sci_status scic_sds_remote_device_suspend(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type);
+
+enum sci_status scic_sds_remote_device_start_task(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *io_request);
+
+void scic_sds_remote_device_post_request(
+	struct scic_sds_remote_device *this_device,
+	u32 request);
+
+#if !defined(DISABLE_ATAPI)
+bool scic_sds_remote_device_is_atapi(
+	struct scic_sds_remote_device *this_device);
+#else /* !defined(DISABLE_ATAPI) */
+#define scic_sds_remote_device_is_atapi(this_device) false
+#endif /* !defined(DISABLE_ATAPI) */
+
+void scic_sds_remote_device_start_request(
+	struct scic_sds_remote_device *this_device,
+	struct scic_sds_request *the_request,
+	enum sci_status status);
+
+void scic_sds_remote_device_continue_request(void *sci_dev);
+
+enum sci_status scic_sds_remote_device_default_start_handler(
+	struct sci_base_remote_device *this_device);
+
+enum sci_status scic_sds_remote_device_default_fail_handler(
+	struct sci_base_remote_device *this_device);
+
+enum sci_status scic_sds_remote_device_default_destruct_handler(
+	struct sci_base_remote_device *this_device);
+
+enum sci_status scic_sds_remote_device_default_reset_handler(
+	struct sci_base_remote_device *device);
+
+enum sci_status scic_sds_remote_device_default_reset_complete_handler(
+	struct sci_base_remote_device *device);
+
+enum sci_status scic_sds_remote_device_default_start_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request);
+
+enum sci_status scic_sds_remote_device_default_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request);
+
+enum sci_status scic_sds_remote_device_default_continue_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request);
+
+enum sci_status scic_sds_remote_device_default_suspend_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type);
+
+enum sci_status scic_sds_remote_device_default_resume_handler(
+	struct scic_sds_remote_device *this_device);
+
+
+enum sci_status scic_sds_remote_device_default_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index);
+
+enum sci_status scic_sds_remote_device_ready_state_stop_handler(
+	struct sci_base_remote_device *device);
+
+enum sci_status scic_sds_remote_device_ready_state_reset_handler(
+	struct sci_base_remote_device *device);
+
+enum sci_status scic_sds_remote_device_general_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index);
+
+enum sci_status scic_sds_remote_device_general_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code);
+
+enum sci_status scic_sds_ssp_remote_device_ready_suspended_substate_resume_handler(
+	struct scic_sds_remote_device *this_device);
+
+#endif /* _SCIC_SDS_REMOTE_DEVICE_H_ */
diff --git a/drivers/scsi/isci/core/scic_sds_smp_remote_device.c b/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
new file mode 100644
index 0000000..93e6ab8
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_smp_remote_device.c
@@ -0,0 +1,325 @@
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
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_port.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_request.h"
+#include "sci_environment.h"
+#include "sci_util.h"
+#include "scu_event_codes.h"
+#include "scu_task_context.h"
+
+/*
+ * *****************************************************************************
+ * *  SMP REMOTE DEVICE READY IDLE SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @[in]: device The device the io is sent to.
+ * @[in]: request The io to start.
+ *
+ * This method will handle the start io operation for a SMP device that is in
+ * the idle state. enum sci_status
+ */
+static enum sci_status scic_sds_smp_remote_device_ready_idle_substate_start_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *io_request  = (struct scic_sds_request *)request;
+
+	/* Will the port allow the io request to start? */
+	status = this_device->owning_port->state_handlers->start_io_handler(
+		this_device->owning_port,
+		this_device,
+		io_request
+		);
+
+	if (status == SCI_SUCCESS) {
+		status =
+			scic_sds_remote_node_context_start_io(this_device->rnc, io_request);
+
+		if (status == SCI_SUCCESS) {
+			status = scic_sds_request_start(io_request);
+		}
+
+		if (status == SCI_SUCCESS) {
+			this_device->working_request = io_request;
+
+			sci_base_state_machine_change_state(
+				&this_device->ready_substate_machine,
+				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD
+				);
+		}
+
+		scic_sds_remote_device_start_request(this_device, io_request, status);
+	}
+
+	return status;
+}
+
+
+/*
+ * ******************************************************************************
+ * * SMP REMOTE DEVICE READY SUBSTATE CMD HANDLERS
+ * ****************************************************************************** */
+/**
+ *
+ * @device: This is the device object that is receiving the IO.
+ * @request: The io to start.
+ *
+ * This device is already handling a command it can not accept new commands
+ * until this one is complete. enum sci_status
+ */
+static enum sci_status scic_sds_smp_remote_device_ready_cmd_substate_start_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+
+/**
+ * this is the complete_io_handler for smp device at ready cmd substate.
+ * @device: This is the device object that is receiving the IO.
+ * @request: The io to start.
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_smp_remote_device_ready_cmd_substate_complete_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *this_device;
+	struct scic_sds_request *the_request;
+
+	this_device = (struct scic_sds_remote_device *)device;
+	the_request = (struct scic_sds_request *)request;
+
+	status = scic_sds_io_request_complete(the_request);
+
+	if (status == SCI_SUCCESS) {
+		status = scic_sds_port_complete_io(
+			this_device->owning_port, this_device, the_request);
+
+		if (status == SCI_SUCCESS) {
+			scic_sds_remote_device_decrement_request_count(this_device);
+			sci_base_state_machine_change_state(
+				&this_device->ready_substate_machine,
+				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE
+				);
+		} else
+			dev_err(scirdev_to_dev(this_device),
+				"%s: SCIC SDS Remote Device 0x%p io request "
+				"0x%p could not be completd on the port 0x%p "
+				"failed with status %d.\n",
+				__func__,
+				this_device,
+				the_request,
+				this_device->owning_port,
+				status);
+	}
+
+	return status;
+}
+
+/**
+ * This is frame handler for smp device ready cmd substate.
+ * @this_device: This is the device object that is receiving the frame.
+ * @frame_index: The index for the frame received.
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_smp_remote_device_ready_cmd_substate_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	enum sci_status status;
+
+	/*
+	 * / The device does not process any UF received from the hardware while
+	 * / in this state.  All unsolicited frames are forwarded to the io request
+	 * / object. */
+	status = scic_sds_io_request_frame_handler(
+		this_device->working_request,
+		frame_index
+		);
+
+	return status;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_remote_device_state_handler scic_sds_smp_remote_device_ready_substate_handler_table[] = {
+	[SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_smp_remote_device_ready_idle_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	},
+	[SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_default_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_smp_remote_device_ready_cmd_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_smp_remote_device_ready_cmd_substate_complete_io_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_smp_remote_device_ready_cmd_substate_frame_handler
+	}
+};
+
+/**
+ *
+ * @object: This is the struct sci_base_object which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE enter method.
+ * This method sets the ready cmd substate handlers and reports the device as
+ * ready. none
+ */
+static void scic_sds_smp_remote_device_ready_idle_substate_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_smp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE
+		);
+
+	isci_event_remote_device_ready(
+		scic_sds_remote_device_get_controller(this_device), this_device);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD enter method. This
+ * method sets the remote device objects ready cmd substate handlers, and
+ * notify core user that the device is not ready. none
+ */
+static void scic_sds_smp_remote_device_ready_cmd_substate_enter(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	BUG_ON(this_device->working_request == NULL);
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_smp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD
+		);
+
+	isci_event_remote_device_not_ready(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device,
+		SCIC_REMOTE_DEVICE_NOT_READY_SMP_REQUEST_STARTED
+		);
+}
+
+/**
+ *
+ * @object: This is the struct sci_base_object which is cast into a
+ *    struct scic_sds_remote_device.
+ *
+ * This is the SCIC_SDS_SSP_REMOTE_DEVICE_READY_SUBSTATE_CMD exit method. none
+ */
+static void scic_sds_smp_remote_device_ready_cmd_substate_exit(
+	struct sci_base_object *object)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)object;
+
+	this_device->working_request = NULL;
+}
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_smp_remote_device_ready_substate_table[] = {
+	[SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE] = {
+		.enter_state = scic_sds_smp_remote_device_ready_idle_substate_enter,
+	},
+	[SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_CMD] = {
+		.enter_state = scic_sds_smp_remote_device_ready_cmd_substate_enter,
+		.exit_state  = scic_sds_smp_remote_device_ready_cmd_substate_exit,
+	},
+};
diff --git a/drivers/scsi/isci/core/scic_sds_stp_remote_device.c b/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
new file mode 100644
index 0000000..9a615f0
--- /dev/null
+++ b/drivers/scsi/isci/core/scic_sds_stp_remote_device.c
@@ -0,0 +1,908 @@
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
+#include "intel_ata.h"
+#include "intel_sata.h"
+#include "intel_sat.h"
+#include "sci_base_state.h"
+#include "scic_remote_device.h"
+#include "scic_sds_controller.h"
+#include "scic_sds_port.h"
+#include "scic_sds_remote_device.h"
+#include "scic_sds_request.h"
+#include "sci_environment.h"
+#include "sci_util.h"
+#include "scu_event_codes.h"
+
+/**
+ * This method will perform the STP request completion processing common to IO
+ *    requests and task requests of all types
+ * @device: This parameter specifies the device for which the request is being
+ *    completed.
+ * @request: This parameter specifies the request being completed.
+ *
+ * This method returns an indication as to whether the request processing
+ * completed successfully.
+ */
+static enum sci_status scic_sds_stp_remote_device_complete_request(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
+	enum sci_status status;
+
+	status = scic_sds_io_request_complete(the_request);
+
+	if (status == SCI_SUCCESS) {
+		status = scic_sds_port_complete_io(
+			this_device->owning_port, this_device, the_request
+			);
+
+		if (status == SCI_SUCCESS) {
+			scic_sds_remote_device_decrement_request_count(this_device);
+			if (the_request->sci_status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {
+				/*
+				 * This request causes hardware error, device needs to be Lun Reset.
+				 * So here we force the state machine to IDLE state so the rest IOs
+				 * can reach RNC state handler, these IOs will be completed by RNC with
+				 * status of "DEVICE_RESET_REQUIRED", instead of "INVALID STATE". */
+				sci_base_state_machine_change_state(
+					&this_device->ready_substate_machine,
+					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_AWAIT_RESET
+					);
+			} else if (scic_sds_remote_device_get_request_count(this_device) == 0) {
+				sci_base_state_machine_change_state(
+					&this_device->ready_substate_machine,
+					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE
+					);
+			}
+		}
+	}
+
+	if (status != SCI_SUCCESS)
+		dev_err(scirdev_to_dev(this_device),
+			"%s: Port:0x%p Device:0x%p Request:0x%p Status:0x%x "
+			"could not complete\n",
+			__func__,
+			this_device->owning_port,
+			this_device,
+			the_request,
+			status);
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY COMMON SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ * This is the READY NCQ substate handler to start task management request. In
+ *    this routine, we suspend and resume the RNC.
+ * @device: The target device a task management request towards to.
+ * @request: The task request.
+ *
+ * enum sci_status Always return SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS status to
+ * let controller_start_task_handler know that the controller can't post TC for
+ * task request yet, instead, when RNC gets resumed, a controller_continue_task
+ * callback will be called.
+ */
+static enum sci_status scic_sds_stp_remote_device_ready_substate_start_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *this_device  = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *this_request = (struct scic_sds_request *)request;
+
+	/* Will the port allow the io request to start? */
+	status = this_device->owning_port->state_handlers->start_io_handler(
+		this_device->owning_port,
+		this_device,
+		this_request
+		);
+
+	if (SCI_SUCCESS == status) {
+		status =
+			scic_sds_remote_node_context_start_task(this_device->rnc, this_request);
+
+		if (SCI_SUCCESS == status) {
+			status = this_request->state_handlers->parent.start_handler(request);
+		}
+
+		if (status == SCI_SUCCESS) {
+			/*
+			 * / @note If the remote device state is not IDLE this will replace
+			 * /       the request that probably resulted in the task management
+			 * /       request. */
+			this_device->working_request = this_request;
+
+			sci_base_state_machine_change_state(
+				&this_device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD
+				);
+
+			/*
+			 * The remote node context must cleanup the TCi to NCQ mapping table.
+			 * The only way to do this correctly is to either write to the TLCR
+			 * register or to invalidate and repost the RNC. In either case the
+			 * remote node context state machine will take the correct action when
+			 * the remote node context is suspended and later resumed. */
+			scic_sds_remote_node_context_suspend(
+				this_device->rnc, SCI_SOFTWARE_SUSPENSION, NULL, NULL);
+
+			scic_sds_remote_node_context_resume(
+				this_device->rnc,
+				scic_sds_remote_device_continue_request,
+				this_device);
+		}
+
+		scic_sds_remote_device_start_request(this_device, this_request, status);
+
+		/*
+		 * We need to let the controller start request handler know that it can't
+		 * post TC yet. We will provide a callback function to post TC when RNC gets
+		 * resumed. */
+		return SCI_FAILURE_RESET_DEVICE_PARTIAL_SUCCESS;
+	}
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY IDLE SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ * This method will handle the start io operation for a sata device that is in
+ *    the command idle state. - Evalute the type of IO request to be started -
+ *    If its an NCQ request change to NCQ substate - If its any other command
+ *    change to the CMD substate
+ * @device:
+ * @request:
+ *
+ * If this is a softreset we may want to have a different substate.
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_remote_device_ready_idle_substate_start_io_handler(
+	struct sci_base_remote_device *base_device,
+	struct sci_base_request *base_request)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *device =
+		(struct scic_sds_remote_device *)&base_device->parent;
+	struct scic_sds_request *sds_request  =
+		(struct scic_sds_request *)&base_request->parent;
+	struct isci_request *isci_request =
+		(struct isci_request *)sci_object_get_association(sds_request);
+
+
+	/* Will the port allow the io request to start? */
+	status = device->owning_port->state_handlers->start_io_handler(
+			device->owning_port,
+			device,
+			sds_request);
+
+	if (status == SCI_SUCCESS) {
+		status =
+			scic_sds_remote_node_context_start_io(device->rnc,
+							      sds_request);
+
+		if (status == SCI_SUCCESS)
+			status =
+				sds_request->state_handlers->
+					parent.start_handler(base_request);
+
+		if (status == SCI_SUCCESS) {
+			if (isci_sata_get_sat_protocol(isci_request) ==
+					SAT_PROTOCOL_FPDMA)
+				sci_base_state_machine_change_state(
+					&device->ready_substate_machine,
+					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ);
+			else {
+				device->working_request = sds_request;
+
+				sci_base_state_machine_change_state(
+					&device->ready_substate_machine,
+					SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD);
+			}
+		}
+
+		scic_sds_remote_device_start_request(device,
+						     sds_request,
+						     status);
+	}
+
+	return status;
+}
+
+
+/**
+ *
+ * @[in]: device The device received event.
+ * @[in]: event_code The event code.
+ *
+ * This method will handle the event for a sata device that is in the idle
+ * state. We pick up suspension events to handle specifically to this state. We
+ * resume the RNC right away. enum sci_status
+ */
+static enum sci_status scic_sds_stp_remote_device_ready_idle_substate_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	status = scic_sds_remote_device_general_event_handler(this_device, event_code);
+
+	if (status == SCI_SUCCESS) {
+		if (scu_get_event_type(event_code) == SCU_EVENT_TYPE_RNC_SUSPEND_TX
+		    || scu_get_event_type(event_code) == SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX) {
+			status = scic_sds_remote_node_context_resume(
+				this_device->rnc, NULL, NULL);
+		}
+	}
+
+	return status;
+}
+
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY NCQ SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+static enum sci_status scic_sds_stp_remote_device_ready_ncq_substate_start_io_handler(
+	struct sci_base_remote_device *base_device,
+	struct sci_base_request *base_request)
+{
+	enum sci_status status;
+	struct scic_sds_remote_device *device =
+		(struct scic_sds_remote_device *)&base_device->parent;
+	struct scic_sds_request *sds_request  =
+		(struct scic_sds_request *)&base_request->parent;
+	struct isci_request *isci_request =
+		(struct isci_request *)sci_object_get_association(sds_request);
+
+	if (isci_sata_get_sat_protocol(isci_request) == SAT_PROTOCOL_FPDMA) {
+		status = device->owning_port->state_handlers->start_io_handler(
+				device->owning_port,
+				device,
+				sds_request);
+
+		if (status == SCI_SUCCESS) {
+			status = scic_sds_remote_node_context_start_io(
+					device->rnc,
+					sds_request);
+
+			if (status == SCI_SUCCESS)
+				status = sds_request->state_handlers->
+					parent.start_handler(base_request);
+
+			scic_sds_remote_device_start_request(device,
+							     sds_request,
+							     status);
+		}
+	} else
+		status = SCI_FAILURE_INVALID_STATE;
+
+	return status;
+}
+
+
+/**
+ * This method will handle events received while the STP device is in the ready
+ *    command substate.
+ * @this_device: This is the device object that is receiving the event.
+ * @event_code: The event code to process.
+ *
+ * enum sci_status
+ */
+
+static enum sci_status scic_sds_stp_remote_device_ready_ncq_substate_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	enum sci_status status;
+	struct sata_fis_header *frame_header;
+
+	status = scic_sds_unsolicited_frame_control_get_header(
+		&(scic_sds_remote_device_get_controller(this_device)->uf_control),
+		frame_index,
+		(void **)&frame_header
+		);
+
+	if (status == SCI_SUCCESS) {
+		if (frame_header->fis_type == SATA_FIS_TYPE_SETDEVBITS &&
+		    (frame_header->status & ATA_STATUS_REG_ERROR_BIT)) {
+			this_device->not_ready_reason =
+				SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED;
+
+			/*
+			 * / @todo Check sactive and complete associated IO
+			 * if any.
+			 */
+
+			sci_base_state_machine_change_state(
+				&this_device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR
+				);
+		} else if (frame_header->fis_type == SATA_FIS_TYPE_REGD2H &&
+			   (frame_header->status & ATA_STATUS_REG_ERROR_BIT)) {
+
+			/*
+			 * Some devices return D2H FIS when an NCQ error is detected.
+			 * Treat this like an SDB error FIS ready reason.
+			 */
+			this_device->not_ready_reason =
+				SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED;
+
+			sci_base_state_machine_change_state(
+				&this_device->ready_substate_machine,
+				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR
+				);
+		} else {
+			status = SCI_FAILURE;
+		}
+
+		scic_sds_controller_release_frame(
+			scic_sds_remote_device_get_controller(this_device), frame_index
+			);
+	}
+
+	return status;
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY CMD SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ * This device is already handling a command it can not accept new commands
+ *    until this one is complete.
+ * @device:
+ * @request:
+ *
+ * enum sci_status
+ */
+static enum sci_status scic_sds_stp_remote_device_ready_cmd_substate_start_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	return SCI_FAILURE_INVALID_STATE;
+}
+
+static enum sci_status scic_sds_stp_remote_device_ready_cmd_substate_suspend_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 suspend_type)
+{
+	enum sci_status status;
+
+	status = scic_sds_remote_node_context_suspend(
+		this_device->rnc, suspend_type, NULL, NULL
+		);
+
+	return status;
+}
+
+static enum sci_status scic_sds_stp_remote_device_ready_cmd_substate_frame_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 frame_index)
+{
+	enum sci_status status;
+
+	/*
+	 * / The device doe not process any UF received from the hardware while
+	 * / in this state.  All unsolicited frames are forwarded to the io request
+	 * / object. */
+	status = scic_sds_io_request_frame_handler(
+		this_device->working_request,
+		frame_index
+		);
+
+	return status;
+}
+
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY NCQ SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY NCQ ERROR SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY AWAIT RESET SUBSTATE HANDLERS
+ * ***************************************************************************** */
+static enum sci_status scic_sds_stp_remote_device_ready_await_reset_substate_start_io_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	return SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED;
+}
+
+
+
+/**
+ * This method will perform the STP request (both io or task) completion
+ *    processing for await reset state.
+ * @device: This parameter specifies the device for which the request is being
+ *    completed.
+ * @request: This parameter specifies the request being completed.
+ *
+ * This method returns an indication as to whether the request processing
+ * completed successfully.
+ */
+static enum sci_status scic_sds_stp_remote_device_ready_await_reset_substate_complete_request_handler(
+	struct sci_base_remote_device *device,
+	struct sci_base_request *request)
+{
+	struct scic_sds_remote_device *this_device = (struct scic_sds_remote_device *)device;
+	struct scic_sds_request *the_request = (struct scic_sds_request *)request;
+	enum sci_status status;
+
+	status = scic_sds_io_request_complete(the_request);
+
+	if (status == SCI_SUCCESS) {
+		status = scic_sds_port_complete_io(
+			this_device->owning_port, this_device, the_request
+			);
+
+		if (status == SCI_SUCCESS)
+			scic_sds_remote_device_decrement_request_count(this_device);
+	}
+
+	if (status != SCI_SUCCESS)
+		dev_err(scirdev_to_dev(this_device),
+			"%s: Port:0x%p Device:0x%p Request:0x%p Status:0x%x "
+			"could not complete\n",
+			__func__,
+			this_device->owning_port,
+			this_device,
+			the_request,
+			status);
+
+	return status;
+}
+
+#if !defined(DISABLE_ATAPI)
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY ATAPI ERROR SUBSTATE HANDLERS
+ * ***************************************************************************** */
+
+/**
+ *
+ * @[in]: device The device received event.
+ * @[in]: event_code The event code.
+ *
+ * This method will handle the event for a ATAPI device that is in the ATAPI
+ * ERROR state. We pick up suspension events to handle specifically to this
+ * state. We resume the RNC right away. We then complete the outstanding IO to
+ * this device. enum sci_status
+ */
+enum sci_status scic_sds_stp_remote_device_ready_atapi_error_substate_event_handler(
+	struct scic_sds_remote_device *this_device,
+	u32 event_code)
+{
+	enum sci_status status;
+
+	status = scic_sds_remote_device_general_event_handler(this_device, event_code);
+
+	if (status == SCI_SUCCESS) {
+		if (scu_get_event_type(event_code) == SCU_EVENT_TYPE_RNC_SUSPEND_TX
+		    || scu_get_event_type(event_code) == SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX) {
+			status = scic_sds_remote_node_context_resume(
+				this_device->rnc,
+				this_device->working_request->state_handlers->parent.complete_handler,
+				(void *)this_device->working_request
+				);
+		}
+	}
+
+	return status;
+}
+#endif /* !defined(DISABLE_ATAPI) */
+
+/* --------------------------------------------------------------------------- */
+
+const struct scic_sds_remote_device_state_handler scic_sds_stp_remote_device_ready_substate_handler_table[] = {
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_stp_remote_device_ready_idle_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_remote_device_default_complete_request_handler,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_stp_remote_device_ready_idle_substate_event_handler,
+		.frame_handler			= scic_sds_remote_device_default_frame_handler
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_stp_remote_device_ready_cmd_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_stp_remote_device_complete_request,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_stp_remote_device_complete_request,
+		.suspend_handler		= scic_sds_stp_remote_device_ready_cmd_substate_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_stp_remote_device_ready_cmd_substate_frame_handler
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_stp_remote_device_ready_ncq_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_stp_remote_device_complete_request,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_stp_remote_device_complete_request,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_stp_remote_device_ready_ncq_substate_frame_handler
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_stp_remote_device_complete_request,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_stp_remote_device_complete_request,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	},
+#if !defined(DISABLE_ATAPI)
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_ATAPI_ERROR] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_remote_device_default_start_request_handler,
+		.parent.complete_io_handler	= scic_sds_stp_remote_device_complete_request,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_stp_remote_device_complete_request,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_stp_remote_device_ready_atapi_error_substate_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	},
+#endif
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_AWAIT_RESET] = {
+		.parent.start_handler		= scic_sds_remote_device_default_start_handler,
+		.parent.stop_handler		= scic_sds_remote_device_ready_state_stop_handler,
+		.parent.fail_handler		= scic_sds_remote_device_default_fail_handler,
+		.parent.destruct_handler	= scic_sds_remote_device_default_destruct_handler,
+		.parent.reset_handler		= scic_sds_remote_device_ready_state_reset_handler,
+		.parent.reset_complete_handler	= scic_sds_remote_device_default_reset_complete_handler,
+		.parent.start_io_handler	= scic_sds_stp_remote_device_ready_await_reset_substate_start_io_handler,
+		.parent.complete_io_handler	= scic_sds_stp_remote_device_ready_await_reset_substate_complete_request_handler,
+		.parent.continue_io_handler	= scic_sds_remote_device_default_continue_request_handler,
+		.parent.start_task_handler	= scic_sds_stp_remote_device_ready_substate_start_request_handler,
+		.parent.complete_task_handler	= scic_sds_stp_remote_device_complete_request,
+		.suspend_handler		= scic_sds_remote_device_default_suspend_handler,
+		.resume_handler			= scic_sds_remote_device_default_resume_handler,
+		.event_handler			= scic_sds_remote_device_general_event_handler,
+		.frame_handler			= scic_sds_remote_device_general_frame_handler
+	}
+};
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY SUBSTATE PRIVATE METHODS
+ * ***************************************************************************** */
+
+static void scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler(
+	void *user_cookie)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)user_cookie;
+
+	/*
+	 * For NCQ operation we do not issue a
+	 * scic_cb_remote_device_not_ready().  As a result, avoid sending
+	 * the ready notification. */
+	if (this_device->ready_substate_machine.previous_state_id
+	    != SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ) {
+		isci_event_remote_device_ready(
+			scic_sds_remote_device_get_controller(this_device), this_device
+			);
+	}
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY IDLE SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+static void scic_sds_stp_remote_device_ready_idle_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE
+		);
+
+	this_device->working_request = NULL;
+
+	if (scic_sds_remote_node_context_is_ready(this_device->rnc)) {
+		/*
+		 * Since the RNC is ready, it's alright to finish completion
+		 * processing (e.g. signal the remote device is ready). */
+		scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler(
+			this_device
+			);
+	} else {
+		scic_sds_remote_node_context_resume(
+			this_device->rnc,
+			scic_sds_stp_remote_device_ready_idle_substate_resume_complete_handler,
+			this_device
+			);
+	}
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY CMD SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+static void scic_sds_stp_remote_device_ready_cmd_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	BUG_ON(this_device->working_request == NULL);
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD
+		);
+
+	isci_event_remote_device_not_ready(
+		scic_sds_remote_device_get_controller(this_device),
+		this_device,
+		SCIC_REMOTE_DEVICE_NOT_READY_SATA_REQUEST_STARTED
+		);
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY NCQ SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+static void scic_sds_stp_remote_device_ready_ncq_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ
+		);
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY NCQ ERROR SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ *
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+static void scic_sds_stp_remote_device_ready_ncq_error_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR
+		);
+
+	if (this_device->not_ready_reason ==
+	    SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED) {
+		isci_event_remote_device_not_ready(
+			scic_sds_remote_device_get_controller(this_device),
+			this_device,
+			this_device->not_ready_reason
+			);
+	}
+}
+
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY AWAIT RESET SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ * The enter routine to READY AWAIT RESET substate.
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+static void scic_sds_stp_remote_device_ready_await_reset_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_AWAIT_RESET
+		);
+}
+
+#if !defined(DISABLE_ATAPI)
+/*
+ * *****************************************************************************
+ * *  STP REMOTE DEVICE READY ATAPI ERROR SUBSTATE
+ * ***************************************************************************** */
+
+/**
+ * The enter routine to READY ATAPI ERROR substate.
+ * @device: This is the SCI base object which is cast into a
+ *    struct scic_sds_remote_device object.
+ *
+ */
+void scic_sds_stp_remote_device_ready_atapi_error_substate_enter(
+	struct sci_base_object *device)
+{
+	struct scic_sds_remote_device *this_device;
+
+	this_device = (struct scic_sds_remote_device *)device;
+
+	SET_STATE_HANDLER(
+		this_device,
+		scic_sds_stp_remote_device_ready_substate_handler_table,
+		SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_ATAPI_ERROR
+		);
+}
+#endif /* !defined(DISABLE_ATAPI) */
+
+/* --------------------------------------------------------------------------- */
+
+const struct sci_base_state scic_sds_stp_remote_device_ready_substate_table[] = {
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE] = {
+		.enter_state = scic_sds_stp_remote_device_ready_idle_substate_enter,
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_CMD] = {
+		.enter_state = scic_sds_stp_remote_device_ready_cmd_substate_enter,
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ] = {
+		.enter_state = scic_sds_stp_remote_device_ready_ncq_substate_enter,
+	},
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_NCQ_ERROR] = {
+		.enter_state = scic_sds_stp_remote_device_ready_ncq_error_substate_enter,
+	},
+#if !defined(DISABLE_ATAPI)
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_ATAPI_ERROR] = {
+		.enter_state = scic_sds_stp_remote_device_ready_atapi_error_substate_enter,
+	},
+#endif
+	[SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_AWAIT_RESET] = {
+		.enter_state = scic_sds_stp_remote_device_ready_await_reset_substate_enter,
+	},
+};

