From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 5/6] isci: phy, port, and remote device
Date: Sun, 06 Feb 2011 16:35:00 -0800
Message-ID: <20110207003500.27040.70595.stgit@localhost6.localdomain6>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33624 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab1BGARM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2011 19:17:12 -0500
In-Reply-To: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Infrastructure for phy initialization, port creation / destruction, and
remote device arrival / departure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c           |  179 +++++++++
 drivers/scsi/isci/phy.h           |  104 ++++++
 drivers/scsi/isci/port.c          |  484 ++++++++++++++++++++++++++
 drivers/scsi/isci/port.h          |  153 ++++++++
 drivers/scsi/isci/remote_device.c |  698 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/isci/remote_device.h |  154 ++++++++
 6 files changed, 1772 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/phy.c
 create mode 100644 drivers/scsi/isci/phy.h
 create mode 100644 drivers/scsi/isci/port.c
 create mode 100644 drivers/scsi/isci/port.h
 create mode 100644 drivers/scsi/isci/remote_device.c
 create mode 100644 drivers/scsi/isci/remote_device.h

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
new file mode 100644
index 0000000..fbda570
--- /dev/null
+++ b/drivers/scsi/isci/phy.c
@@ -0,0 +1,179 @@
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
+#include "phy.h"
+#include "scic_port.h"
+#include "scic_config_parameters.h"
+
+
+/**
+ * isci_phy_init() - This function is called by the probe function to
+ *    initialize the phy objects. This func assumes that the isci_port objects
+ *    associated with the SCU have been initialized.
+ * @isci_phy: This parameter specifies the isci_phy object to initialize
+ * @isci_host: This parameter specifies the parent SCU host object for this
+ *    isci_phy
+ * @index: This parameter specifies which SCU phy associates with this
+ *    isci_phy. Generally, SCU phy 0 relates isci_phy 0, etc.
+ *
+ */
+void isci_phy_init(
+	struct isci_phy *phy,
+	struct isci_host *isci_host,
+	int index)
+{
+	struct scic_sds_controller *controller = isci_host->core_controller;
+	struct scic_sds_phy *scic_phy;
+	union scic_oem_parameters oem_parameters;
+	enum sci_status status = SCI_SUCCESS;
+
+	/*--------------- SCU_Phy Initialization Stuff -----------------------*/
+
+	status = scic_controller_get_phy_handle(controller, index, &scic_phy);
+	if (status == SCI_SUCCESS) {
+		sci_object_set_association(scic_phy, (void *)phy);
+		phy->sci_phy_handle = scic_phy;
+	} else
+		dev_err(&isci_host->pdev->dev,
+			"failed scic_controller_get_phy_handle\n");
+
+	scic_oem_parameters_get(controller, &oem_parameters);
+
+	phy->sas_addr[0] =  oem_parameters.sds1.phys[index].sas_address.low
+			   & 0xFF;
+	phy->sas_addr[1] = (oem_parameters.sds1.phys[index].sas_address.low
+			    >> 8)   & 0xFF;
+	phy->sas_addr[2] = (oem_parameters.sds1.phys[index].sas_address.low
+			    >> 16)  & 0xFF;
+	phy->sas_addr[3] = (oem_parameters.sds1.phys[index].sas_address.low
+			    >> 24)  & 0xFF;
+	phy->sas_addr[4] =  oem_parameters.sds1.phys[index].sas_address.high
+			   & 0xFF;
+	phy->sas_addr[5] = (oem_parameters.sds1.phys[index].sas_address.high
+			    >> 8)  & 0xFF;
+	phy->sas_addr[6] = (oem_parameters.sds1.phys[index].sas_address.high
+			    >> 16) & 0xFF;
+	phy->sas_addr[7] = (oem_parameters.sds1.phys[index].sas_address.high
+			    >> 24) & 0xFF;
+
+	phy->isci_port = NULL;
+	phy->sas_phy.enabled = 0;
+	phy->sas_phy.id = index;
+	phy->sas_phy.sas_addr = &phy->sas_addr[0];
+	phy->sas_phy.frame_rcvd = (u8 *)&phy->frame_rcvd;
+	phy->sas_phy.ha = &isci_host->sas_ha;
+	phy->sas_phy.lldd_phy = phy;
+	phy->sas_phy.enabled = 1;
+	phy->sas_phy.class = SAS;
+	phy->sas_phy.iproto = SAS_PROTOCOL_ALL;
+	phy->sas_phy.tproto = 0;
+	phy->sas_phy.type = PHY_TYPE_PHYSICAL;
+	phy->sas_phy.role = PHY_ROLE_INITIATOR;
+	phy->sas_phy.oob_mode = OOB_NOT_CONNECTED;
+	phy->sas_phy.linkrate = SAS_LINK_RATE_UNKNOWN;
+	memset((u8 *)&phy->frame_rcvd, 0, sizeof(phy->frame_rcvd));
+}
+
+
+/**
+ * isci_phy_control() - This function is one of the SAS Domain Template
+ *    functions. This is a phy management function.
+ * @phy: This parameter specifies the sphy being controlled.
+ * @func: This parameter specifies the phy control function being invoked.
+ * @buf: This parameter is specific to the phy function being invoked.
+ *
+ * status, zero indicates success.
+ */
+int isci_phy_control(
+	struct asd_sas_phy *phy,
+	enum phy_func func,
+	void *buf)
+{
+	int ret            = TMF_RESP_FUNC_COMPLETE;
+	struct isci_phy *isci_phy_ptr  = (struct isci_phy *)phy->lldd_phy;
+	struct isci_port *isci_port_ptr = NULL;
+
+	if (isci_phy_ptr != NULL)
+		isci_port_ptr = isci_phy_ptr->isci_port;
+
+	if ((isci_phy_ptr == NULL) || (isci_port_ptr == NULL)) {
+		pr_err("%s: asd_sas_phy %p: lldd_phy %p or "
+		       "isci_port %p == NULL!\n",
+		       __func__, phy, isci_phy_ptr, isci_port_ptr);
+		return TMF_RESP_FUNC_FAILED;
+	}
+
+	pr_debug("%s: phy %p; func %d; buf %p; isci phy %p, port %p\n",
+		 __func__, phy, func, buf, isci_phy_ptr, isci_port_ptr);
+
+	switch (func) {
+	case PHY_FUNC_HARD_RESET:
+	case PHY_FUNC_LINK_RESET:
+
+		/* Perform the port reset. */
+		ret = isci_port_perform_hard_reset(isci_port_ptr, isci_phy_ptr);
+
+		break;
+
+	case PHY_FUNC_DISABLE:
+	default:
+		pr_debug("%s: phy %p; func %d NOT IMPLEMENTED!\n",
+			 __func__, phy, func);
+		ret = TMF_RESP_FUNC_FAILED;
+		break;
+	}
+	return ret;
+}
diff --git a/drivers/scsi/isci/phy.h b/drivers/scsi/isci/phy.h
new file mode 100644
index 0000000..44b727f
--- /dev/null
+++ b/drivers/scsi/isci/phy.h
@@ -0,0 +1,104 @@
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
+#if !defined(_ISCI_PHY_H_)
+#define _ISCI_PHY_H_
+
+#include "port.h"
+#include "host.h"
+#include <scsi/libsas.h>
+
+
+/**
+ * struct isci_phy - This class implements the ISCI specific representation of
+ *    the phy object.
+ *
+ *
+ */
+
+struct isci_phy {
+
+	struct scic_sds_phy *sci_phy_handle;
+
+	struct asd_sas_phy sas_phy;
+	struct sas_identify_frame *frame;
+	struct isci_port *isci_port;
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	union {
+
+		u8 aif[sizeof(struct sci_sas_identify_address_frame)];
+		u8 fis[sizeof(struct sata_fis_reg_d2h)];
+
+	} frame_rcvd;
+};
+
+#define to_isci_phy(p)	\
+	container_of(p, struct isci_phy, sas_phy);
+
+struct isci_host;
+
+void isci_phy_init(
+	struct isci_phy *phy,
+	struct isci_host *isci_host,
+	int index);
+
+int isci_phy_control(
+	struct asd_sas_phy *phy,
+	enum phy_func func,
+	void *buf);
+
+#endif /* !defined(_ISCI_PHY_H_) */
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
new file mode 100644
index 0000000..2343f65
--- /dev/null
+++ b/drivers/scsi/isci/port.c
@@ -0,0 +1,484 @@
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
+ * This file contains the isci port implementation.
+ *
+ *
+ */
+
+
+#include <linux/workqueue.h>
+#include "isci.h"
+#include "scic_io_request.h"
+#include "scic_remote_device.h"
+#include "scic_phy.h"
+#include "scic_sds_phy.h"
+#include "scic_port.h"
+#include "port.h"
+#include "request.h"
+
+static void isci_port_change_state(
+	struct isci_port *isci_port,
+	enum isci_status status);
+
+
+
+/**
+ * isci_port_init() - This function initializes the given isci_port object.
+ * @isci_port: This parameter specifies the port object to be initialized.
+ * @isci_host: This parameter specifies parent controller object for the port.
+ * @index: This parameter specifies which SCU port the isci_port associates
+ *    with. Generally, SCU port 0 relates to isci_port 0, etc.
+ *
+ */
+void isci_port_init(
+	struct isci_port *isci_port,
+	struct isci_host *isci_host,
+	int index)
+{
+	struct scic_sds_port *scic_port;
+	struct scic_sds_controller *controller = isci_host->core_controller;
+
+	INIT_LIST_HEAD(&isci_port->remote_dev_list);
+	INIT_LIST_HEAD(&isci_port->domain_dev_list);
+	spin_lock_init(&isci_port->remote_device_lock);
+	spin_lock_init(&isci_port->state_lock);
+	init_completion(&isci_port->start_complete);
+	isci_port->isci_host = isci_host;
+	isci_port_change_state(isci_port, isci_freed);
+
+	(void)scic_controller_get_port_handle(controller, index, &scic_port);
+	sci_object_set_association(scic_port, isci_port);
+	isci_port->sci_port_handle = scic_port;
+}
+
+
+/**
+ * isci_port_get_state() - This function gets the status of the port object.
+ * @isci_port: This parameter points to the isci_port object
+ *
+ * status of the object as a isci_status enum.
+ */
+enum isci_status isci_port_get_state(
+	struct isci_port *isci_port)
+{
+	return isci_port->status;
+}
+
+static void isci_port_change_state(
+	struct isci_port *isci_port,
+	enum isci_status status)
+{
+	unsigned long flags;
+
+	dev_dbg(&isci_port->isci_host->pdev->dev,
+		"%s: isci_port = %p, state = 0x%x\n",
+		__func__, isci_port, status);
+
+	spin_lock_irqsave(&isci_port->state_lock, flags);
+	isci_port->status = status;
+	spin_unlock_irqrestore(&isci_port->state_lock, flags);
+}
+
+void isci_port_bc_change_received(
+	struct isci_host *isci_host,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy)
+{
+	struct isci_phy *isci_phy =
+		(struct isci_phy *)sci_object_get_association(phy);
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_phy = %p, sas_phy = %p\n",
+		__func__,
+		isci_phy,
+		&isci_phy->sas_phy);
+
+	isci_host->sas_ha.notify_port_event(
+		&isci_phy->sas_phy,
+		PORTE_BROADCAST_RCVD
+		);
+
+	scic_port_enable_broadcast_change_notification(port);
+}
+
+/**
+ * isci_port_link_up() - This function is called by the sci core when a link
+ *    becomes active. the identify address frame is retrieved from the core and
+ *    a notify port event is sent to libsas.
+ * @isci_host: This parameter specifies the isci host object.
+ * @port: This parameter specifies the sci port with the active link.
+ * @phy: This parameter specifies the sci phy with the active link.
+ *
+ */
+void isci_port_link_up(
+	struct isci_host *isci_host,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy)
+{
+	unsigned long flags;
+	struct scic_port_properties properties;
+	struct isci_phy *isci_phy
+		= (struct isci_phy *)sci_object_get_association(phy);
+	struct isci_port *isci_port
+		= (struct isci_port *)sci_object_get_association(port);
+	enum sci_status call_status;
+	unsigned long success = true;
+
+	BUG_ON(isci_phy->isci_port != NULL);
+	isci_phy->isci_port = isci_port;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_port = %p\n",
+		__func__, isci_port);
+
+	spin_lock_irqsave(&isci_phy->sas_phy.frame_rcvd_lock, flags);
+
+	isci_port_change_state(isci_phy->isci_port, isci_starting);
+
+	scic_port_get_properties(port, &properties);
+
+	if (properties.remote.protocols.u.bits.stp_target) {
+
+		struct scic_sata_phy_properties sata_phy_properties;
+
+		isci_phy->sas_phy.oob_mode = SATA_OOB_MODE;
+
+		/* Get a copy of the signature fis for libsas */
+		call_status = scic_sata_phy_get_properties(phy,
+							   &sata_phy_properties);
+
+		/* 
+		 * XXX I am concerned about this "assert". shouldn't we
+		 * handle the return appropriately?
+		 */
+		BUG_ON(call_status != SCI_SUCCESS);
+
+		memcpy(isci_phy->frame_rcvd.fis,
+		       &sata_phy_properties.signature_fis,
+		       sizeof(struct sata_fis_reg_d2h));
+
+		isci_phy->sas_phy.frame_rcvd_size = sizeof(struct sata_fis_reg_d2h);
+
+		/*
+		 * For direct-attached SATA devices, the SCI core will
+		 * automagically assign a SAS address to the end device
+		 * for the purpose of creating a port. This SAS address
+		 * will not be the same as assigned to the PHY and needs
+		 * to be obtained from struct scic_port_properties properties.
+		 */
+
+		BUG_ON(((size_t)SAS_ADDR_SIZE / 2)
+		       != sizeof(properties.remote.sas_address.low));
+
+		memcpy(&isci_phy->sas_phy.attached_sas_addr[0],
+		       &properties.remote.sas_address.low,
+		       SAS_ADDR_SIZE / 2);
+
+		memcpy(&isci_phy->sas_phy.attached_sas_addr[4],
+		       &properties.remote.sas_address.high,
+		       SAS_ADDR_SIZE / 2);
+
+	} else if (properties.remote.protocols.u.bits.ssp_target ||
+		   properties.remote.protocols.u.bits.smp_target) {
+
+		struct scic_sas_phy_properties sas_phy_properties;
+
+		isci_phy->sas_phy.oob_mode = SAS_OOB_MODE;
+
+		/* Get a copy of the identify address frame for libsas */
+		call_status = scic_sas_phy_get_properties(phy,
+							  &sas_phy_properties);
+
+		BUG_ON(call_status != SCI_SUCCESS);
+
+		memcpy(isci_phy->frame_rcvd.aif,
+		       &(sas_phy_properties.received_iaf),
+		       sizeof(struct sci_sas_identify_address_frame));
+
+		isci_phy->sas_phy.frame_rcvd_size
+			= sizeof(struct sci_sas_identify_address_frame);
+
+		/* Copy the attached SAS address from the IAF */
+		memcpy(isci_phy->sas_phy.attached_sas_addr,
+		       ((struct sas_identify_frame *)
+			(&isci_phy->frame_rcvd.aif))->sas_addr,
+		       SAS_ADDR_SIZE);
+
+	} else {
+		dev_err(&isci_host->pdev->dev, "%s: unkown target\n", __func__);
+		success = false;
+	}
+
+	spin_unlock_irqrestore(&isci_phy->sas_phy.frame_rcvd_lock, flags);
+
+	/* Notify libsas that we have an address frame, if indeed
+	 * we've found an SSP, SMP, or STP target */
+	if (success)
+		isci_host->sas_ha.notify_port_event(&isci_phy->sas_phy,
+						    PORTE_BYTES_DMAED);
+}
+
+
+/**
+ * isci_port_link_down() - This function is called by the sci core when a link
+ *    becomes inactive.
+ * @isci_host: This parameter specifies the isci host object.
+ * @phy: This parameter specifies the isci phy with the active link.
+ * @port: This parameter specifies the isci port with the active link.
+ *
+ */
+void isci_port_link_down(
+	struct isci_host *isci_host,
+	struct isci_phy *isci_phy,
+	struct isci_port *isci_port)
+{
+	struct isci_remote_device *isci_device;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_port = %p\n", __func__, isci_port);
+
+	if (isci_port) {
+
+		/* check to see if this is the last phy on this port. */
+		if (isci_phy->sas_phy.port
+		    && isci_phy->sas_phy.port->num_phys == 1) {
+
+			/* change the state for all devices on this port.
+			 * The next task sent to this device will be returned
+			 * as SAS_TASK_UNDELIVERED, and the scsi mid layer
+			 * will remove the target
+			 */
+			list_for_each_entry(isci_device,
+					    &isci_port->remote_dev_list,
+					    node) {
+				dev_dbg(&isci_host->pdev->dev,
+					"%s: isci_device = %p\n",
+					__func__, isci_device);
+				isci_remote_device_change_state(isci_device,
+								isci_stopping);
+			}
+		}
+		isci_port_change_state(isci_port, isci_stopping);
+	}
+
+	/* Notify libsas of the borken link, this will trigger calls to our
+	 * isci_port_deformed and isci_dev_gone functions.
+	 */
+	sas_phy_disconnected(&isci_phy->sas_phy);
+	isci_host->sas_ha.notify_phy_event(&isci_phy->sas_phy,
+					   PHYE_LOSS_OF_SIGNAL);
+
+	isci_phy->isci_port = NULL;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_port = %p - Done\n", __func__, isci_port);
+}
+
+
+/**
+ * isci_port_deformed() - This function is called by libsas when a port becomes
+ *    inactive.
+ * @phy: This parameter specifies the libsas phy with the inactive port.
+ *
+ */
+void isci_port_deformed(
+	struct asd_sas_phy *phy)
+{
+	pr_debug("%s: sas_phy = %p\n", __func__, phy);
+}
+
+/**
+ * isci_port_formed() - This function is called by libsas when a port becomes
+ *    active.
+ * @phy: This parameter specifies the libsas phy with the active port.
+ *
+ */
+void isci_port_formed(
+	struct asd_sas_phy *phy)
+{
+	pr_debug("%s: sas_phy = %p, sas_port = %p\n", __func__, phy, phy->port);
+}
+
+/**
+ * isci_port_ready() - This function is called by the sci core when a link
+ *    becomes ready.
+ * @isci_host: This parameter specifies the isci host object.
+ * @port: This parameter specifies the sci port with the active link.
+ *
+ */
+void isci_port_ready(
+	struct isci_host *isci_host,
+	struct isci_port *isci_port)
+{
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_port = %p\n", __func__, isci_port);
+
+	complete_all(&isci_port->start_complete);
+	isci_port_change_state(isci_port, isci_ready);
+	return;
+}
+
+/**
+ * isci_port_not_ready() - This function is called by the sci core when a link
+ *    is not ready. All remote devices on this link will be removed if they are
+ *    in the stopping state.
+ * @isci_host: This parameter specifies the isci host object.
+ * @port: This parameter specifies the sci port with the active link.
+ *
+ */
+void isci_port_not_ready(
+	struct isci_host *isci_host,
+	struct isci_port *isci_port)
+{
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_port = %p\n", __func__, isci_port);
+}
+
+/**
+ * isci_port_hard_reset_complete() - This function is called by the sci core
+ *    when the hard reset complete notification has been received.
+ * @port: This parameter specifies the sci port with the active link.
+ * @completion_status: This parameter specifies the core status for the reset
+ *    process.
+ *
+ */
+void isci_port_hard_reset_complete(
+	struct isci_port *isci_port,
+	enum sci_status completion_status)
+{
+	dev_dbg(&isci_port->isci_host->pdev->dev,
+		"%s: isci_port = %p, completion_status=%x\n",
+		     __func__, isci_port, completion_status);
+
+	/* Save the status of the hard reset from the port. */
+	isci_port->hard_reset_status = completion_status;
+
+	complete_all(&isci_port->hard_reset_complete);
+}
+/**
+ * isci_port_perform_hard_reset() - This function is one of the SAS Domain
+ *    Template functions. This is a phy management function.
+ * @isci_port:
+ * @isci_phy:
+ *
+ * status, TMF_RESP_FUNC_COMPLETE indicates success.
+ */
+int isci_port_perform_hard_reset(
+	struct isci_port *isci_port,
+	struct isci_phy *isci_phy)
+{
+	enum sci_status status;
+	int ret = TMF_RESP_FUNC_COMPLETE;
+	unsigned long flags;
+
+
+	dev_dbg(&isci_port->isci_host->pdev->dev,
+		"%s: isci_port = %p\n",
+		__func__, isci_port);
+
+	BUG_ON(isci_port == NULL);
+
+	init_completion(&isci_port->hard_reset_complete);
+
+	spin_lock_irqsave(&isci_port->isci_host->scic_lock, flags);
+
+	#define ISCI_PORT_RESET_TIMEOUT SCIC_SDS_SIGNATURE_FIS_TIMEOUT
+	status = scic_port_hard_reset(isci_port->sci_port_handle,
+				      ISCI_PORT_RESET_TIMEOUT);
+
+	spin_unlock_irqrestore(&isci_port->isci_host->scic_lock, flags);
+
+	if (status == SCI_SUCCESS) {
+		wait_for_completion(&isci_port->hard_reset_complete);
+
+		dev_dbg(&isci_port->isci_host->pdev->dev,
+			"%s: isci_port = %p; hard reset completion\n",
+			__func__, isci_port);
+
+		if (isci_port->hard_reset_status != SCI_SUCCESS)
+			ret = TMF_RESP_FUNC_FAILED;
+	} else {
+		ret = TMF_RESP_FUNC_FAILED;
+
+		dev_err(&isci_port->isci_host->pdev->dev,
+			"%s: isci_port = %p; scic_port_hard_reset call"
+			" failed 0x%x\n",
+			__func__, isci_port, status);
+
+	}
+
+	/* If the hard reset for the port has failed, consider this
+	 * the same as link failures on all phys in the port.
+	 */
+	if (ret != TMF_RESP_FUNC_COMPLETE) {
+		BUG_ON(isci_port->isci_host == NULL);
+
+		dev_err(&isci_port->isci_host->pdev->dev,
+			"%s: isci_port = %p; hard reset failed "
+			"(0x%x) - sending link down to libsas for phy %p\n",
+			__func__,
+			isci_port,
+			isci_port->hard_reset_status,
+			isci_phy);
+
+		isci_port_link_down(isci_port->isci_host,
+				    isci_phy,
+				    isci_port);
+	}
+
+	return ret;
+}
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
new file mode 100644
index 0000000..b01b0c6
--- /dev/null
+++ b/drivers/scsi/isci/port.h
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
+
+/**
+ * This file contains the isci_port object definition.
+ *
+ * port.h
+ */
+
+#if !defined(_ISCI_PORT_H_)
+#define _ISCI_PORT_H_
+
+struct isci_phy;
+struct isci_host;
+
+
+enum isci_status {
+	isci_freed        = 0x00,
+	isci_starting     = 0x01,
+	isci_ready        = 0x02,
+	isci_ready_for_io = 0x03,
+	isci_stopping     = 0x04,
+	isci_stopped      = 0x05,
+	isci_host_quiesce = 0x06
+};
+
+/**
+ * struct isci_port - This class represents the port object used to internally
+ *    represent libsas port objects. It also keeps a list of remote device
+ *    objects.
+ *
+ *
+ */
+struct isci_port {
+
+	struct scic_sds_port *sci_port_handle;
+
+	enum isci_status status;
+	struct isci_host *isci_host;
+	struct asd_sas_port sas_port;
+	struct list_head remote_dev_list;
+	spinlock_t remote_device_lock;
+	spinlock_t state_lock;
+	struct list_head domain_dev_list;
+	struct completion start_complete;
+	struct completion hard_reset_complete;
+	enum sci_status hard_reset_status;
+};
+
+#define to_isci_port(p)	\
+	container_of(p, struct isci_port, sas_port);
+
+enum isci_status isci_port_get_state(
+	struct isci_port *isci_port);
+
+
+
+void isci_port_formed(
+	struct asd_sas_phy *);
+
+void isci_port_deformed(
+	struct asd_sas_phy *);
+
+void isci_port_bc_change_received(
+	struct isci_host *isci_host,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+void isci_port_link_up(
+	struct isci_host *isci_host,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+void isci_port_link_down(
+	struct isci_host *isci_host,
+	struct isci_phy *isci_phy,
+	struct isci_port *port);
+
+void isci_port_ready(
+	struct isci_host *isci_host,
+	struct isci_port *isci_port);
+
+void isci_port_not_ready(
+	struct isci_host *isci_host,
+	struct isci_port *port);
+
+void isci_port_init(
+	struct isci_port *port,
+	struct isci_host *host,
+	int index);
+
+void isci_port_hard_reset_complete(
+	struct isci_port *isci_port,
+	enum sci_status completion_status);
+
+int isci_port_perform_hard_reset(
+	struct isci_port *isci_port_ptr,
+	struct isci_phy *isci_phy_ptr);
+
+#endif /* !defined(_ISCI_PORT_H_) */
+
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
new file mode 100644
index 0000000..dbf3c82
--- /dev/null
+++ b/drivers/scsi/isci/remote_device.c
@@ -0,0 +1,698 @@
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
+#include "scic_phy.h"
+#include "scic_port.h"
+#include "port.h"
+#include "remote_device.h"
+#include "request.h"
+#include "task.h"
+
+
+
+/**
+ * isci_remote_device_deconstruct() - This function frees an isci_remote_device.
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device to be freed.
+ *
+ */
+static void isci_remote_device_deconstruct(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device)
+{
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	/* There should not be any outstanding io's. All paths to
+	 * here should go through isci_remote_device_nuke_requests.
+	 * If we hit this condition, we will need a way to complete
+	 * io requests in process */
+	while (!list_empty(&isci_device->reqs_in_process)) {
+
+		dev_err(&isci_host->pdev->dev,
+			"%s: ** request list not empty! **\n", __func__);
+		BUG();
+	}
+
+	/* Remove all related references to this device and free
+	 * the cache object.
+	 */
+	scic_remote_device_destruct(isci_device->sci_device_handle);
+	isci_device->domain_dev->lldd_dev = NULL;
+	list_del(&isci_device->node);
+	kmem_cache_free(isci_kmem_cache, isci_device);
+}
+
+
+/**
+ * isci_remote_device_construct() - This function calls the scic remote device
+ *    construct and start functions, it waits on the remote device start
+ *    completion.
+ * @port: This parameter specifies the isci port with the remote device.
+ * @isci_device: This parameter specifies the isci remote device
+ *
+ * status from the scic calls, the caller to this function should clean up
+ * resources as appropriate.
+ */
+static enum sci_status isci_remote_device_construct(
+	struct isci_port *port,
+	struct isci_remote_device *isci_device)
+{
+	enum sci_status status = SCI_SUCCESS;
+
+	/* let the core do it's common constuction. */
+	scic_remote_device_construct(port->sci_port_handle,
+				     isci_device->sci_device_handle);
+
+	/* let the core do it's device specific constuction. */
+	if (isci_device->domain_dev->parent &&
+	    (isci_device->domain_dev->parent->dev_type == EDGE_DEV)) {
+		int i;
+
+		/* struct smp_response_discover discover_response; */
+		struct discover_resp discover_response;
+		struct domain_device *parent =
+			isci_device->domain_dev->parent;
+
+		struct expander_device *parent_ex = &parent->ex_dev;
+
+		for (i = 0; i < parent_ex->num_phys; i++) {
+
+			struct ex_phy *phy = &parent_ex->ex_phy[i];
+
+			if ((phy->phy_state == PHY_VACANT) ||
+			    (phy->phy_state == PHY_NOT_PRESENT))
+				continue;
+
+			if (SAS_ADDR(phy->attached_sas_addr)
+			    == SAS_ADDR(isci_device->domain_dev->sas_addr)) {
+
+				discover_response.attached_dev_type
+					= phy->attached_dev_type;
+				discover_response.linkrate
+					= phy->linkrate;
+				discover_response.attached_sata_host
+					= phy->attached_sata_host;
+				discover_response.attached_sata_dev
+					= phy->attached_sata_dev;
+				discover_response.attached_sata_ps
+					= phy->attached_sata_ps;
+				discover_response.iproto
+					= phy->attached_iproto >> 1;
+				discover_response.tproto
+					= phy->attached_tproto >> 1;
+				memcpy(
+					discover_response.attached_sas_addr,
+					phy->attached_sas_addr,
+					SAS_ADDR_SIZE
+					);
+				discover_response.attached_phy_id
+					= phy->attached_phy_id;
+				discover_response.change_count
+					= phy->phy_change_count;
+				discover_response.routing_attr
+					= phy->routing_attr;
+				discover_response.hmin_linkrate
+					= phy->phy->minimum_linkrate_hw;
+				discover_response.hmax_linkrate
+					= phy->phy->maximum_linkrate_hw;
+				discover_response.pmin_linkrate
+					= phy->phy->minimum_linkrate;
+				discover_response.pmax_linkrate
+					= phy->phy->maximum_linkrate;
+			}
+		}
+
+
+		dev_dbg(&port->isci_host->pdev->dev,
+			"%s: parent->dev_type = EDGE_DEV\n",
+			__func__);
+
+		status = scic_remote_device_ea_construct(
+			isci_device->sci_device_handle,
+			(struct smp_response_discover *)&discover_response
+			);
+
+	} else
+		status = scic_remote_device_da_construct(
+			isci_device->sci_device_handle
+			);
+
+
+	if (status != SCI_SUCCESS) {
+		dev_dbg(&port->isci_host->pdev->dev,
+			"%s: scic_remote_device_da_construct failed - "
+			"isci_device = %p\n",
+			__func__,
+			isci_device);
+
+		return status;
+	}
+
+	sci_object_set_association(
+		isci_device->sci_device_handle,
+		isci_device
+		);
+
+	BUG_ON(port->isci_host == NULL);
+
+	/* start the device. */
+	status = scic_remote_device_start(
+		isci_device->sci_device_handle,
+		ISCI_REMOTE_DEVICE_START_TIMEOUT
+		);
+
+	if (status != SCI_SUCCESS) {
+		dev_warn(&port->isci_host->pdev->dev,
+			 "%s: scic_remote_device_start failed\n",
+			 __func__);
+		return status;
+	}
+
+	return status;
+}
+
+
+/**
+ * isci_remote_device_nuke_requests() - This function terminates all requests
+ *    for a given remote device.
+ * @isci_device: This parameter specifies the remote device
+ *
+ */
+void isci_remote_device_nuke_requests(
+	struct isci_remote_device *isci_device)
+{
+	DECLARE_COMPLETION_ONSTACK(aborted_task_completion);
+	struct isci_host *isci_host;
+
+	isci_host = isci_device->isci_port->isci_host;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	/* Cleanup all requests pending for this device. */
+	isci_terminate_pending_requests(isci_host, isci_device, terminating);
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p, done\n", __func__, isci_device);
+}
+
+
+
+/**
+ * This function builds the isci_remote_device when a libsas dev_found message
+ *    is received.
+ * @isci_host: This parameter specifies the isci host object.
+ * @port: This parameter specifies the isci_port conected to this device.
+ *
+ * pointer to new isci_remote_device.
+ */
+static struct isci_remote_device *
+isci_remote_device_alloc(struct isci_host *isci_host, struct isci_port *port)
+{
+	struct isci_remote_device *isci_device;
+	struct scic_sds_remote_device *sci_dev;
+
+	isci_device = kmem_cache_zalloc(isci_kmem_cache, GFP_KERNEL);
+
+	if (!isci_device) {
+		dev_warn(&isci_host->pdev->dev, "%s: failed\n", __func__);
+		return NULL;
+	}
+
+	sci_dev = (struct scic_sds_remote_device *) &isci_device[1];
+	isci_device->sci_device_handle = sci_dev;
+	INIT_LIST_HEAD(&isci_device->reqs_in_process);
+	INIT_LIST_HEAD(&isci_device->node);
+	isci_device->host_quiesce          = false;
+
+	spin_lock_init(&isci_device->state_lock);
+	spin_lock_init(&isci_device->host_quiesce_lock);
+	isci_remote_device_change_state(isci_device, isci_freed);
+
+	return isci_device;
+
+}
+/**
+ * isci_device_set_host_quiesce_lock_state() - This function sets the host I/O
+ *    quiesce lock state for the remote_device object.
+ * @isci_device,: This parameter points to the isci_remote_device object
+ * @isci_device: This parameter specifies the new quiesce state.
+ *
+ */
+void isci_device_set_host_quiesce_lock_state(
+	struct isci_remote_device *isci_device,
+	bool lock_state)
+{
+	unsigned long flags;
+
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device=%p, lock_state=%d\n",
+		__func__, isci_device, lock_state);
+
+	spin_lock_irqsave(&isci_device->host_quiesce_lock, flags);
+	isci_device->host_quiesce = lock_state;
+	spin_unlock_irqrestore(&isci_device->host_quiesce_lock, flags);
+}
+
+/**
+ * isci_remote_device_ready() - This function is called by the scic when the
+ *    remote device is ready. We mark the isci device as ready and signal the
+ *    waiting proccess.
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device
+ *
+ */
+void isci_remote_device_ready(struct isci_remote_device *isci_device)
+{
+	unsigned long flags;
+
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	/* device ready is actually a "ready for io" state. */
+	if ((isci_starting == isci_remote_device_get_state(isci_device)) ||
+	    (isci_ready == isci_remote_device_get_state(isci_device))) {
+		spin_lock_irqsave(&isci_device->isci_port->remote_device_lock,
+				  flags);
+		isci_remote_device_change_state(isci_device, isci_ready_for_io);
+		if (isci_device->completion)
+			complete(isci_device->completion);
+		spin_unlock_irqrestore(
+				&isci_device->isci_port->remote_device_lock,
+				flags);
+	}
+
+}
+
+/**
+ * isci_remote_device_not_ready() - This function is called by the scic when
+ *    the remote device is not ready. We mark the isci device as ready (not
+ *    "ready_for_io") and signal the waiting proccess.
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device
+ *
+ */
+void isci_remote_device_not_ready(
+	struct isci_remote_device *isci_device,
+	u32 reason_code)
+{
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	if (reason_code == SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED)
+		isci_remote_device_change_state(isci_device, isci_stopping);
+	else
+		/* device ready is actually a "not ready for io" state. */
+		isci_remote_device_change_state(isci_device, isci_ready);
+}
+
+/**
+ * isci_remote_device_stop_complete() - This function is called by the scic
+ *    when the remote device stop has completed. We mark the isci device as not
+ *    ready and remove the isci remote device.
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device.
+ * @status: This parameter specifies status of the completion.
+ *
+ */
+void isci_remote_device_stop_complete(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device,
+	enum sci_status status)
+{
+	struct completion *completion = isci_device->completion;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: complete isci_device = %p, status = 0x%x\n",
+		__func__,
+		isci_device,
+		status);
+
+	isci_remote_device_change_state(isci_device, isci_stopped);
+
+	/* after stop, we can tear down resources. */
+	isci_remote_device_deconstruct(isci_host, isci_device);
+
+	/* notify interested parties. */
+	if (completion)
+		complete(completion);
+}
+
+/**
+ * isci_remote_device_start_complete() - This function is called by the scic
+ *    when the remote device start has completed
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device.
+ * @status: This parameter specifies status of the completion.
+ *
+ */
+void isci_remote_device_start_complete(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device,
+	enum sci_status status)
+{
+
+
+}
+
+
+/**
+ * isci_remote_device_stop() - This function is called internally to stop the
+ *    remote device.
+ * @isci_host: This parameter specifies the isci host object.
+ * @isci_device: This parameter specifies the remote device.
+ *
+ * The status of the scic request to stop.
+ */
+enum sci_status isci_remote_device_stop(
+	struct isci_remote_device *isci_device)
+{
+	enum sci_status status;
+	unsigned long flags;
+
+	DECLARE_COMPLETION_ONSTACK(completion);
+
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	isci_remote_device_change_state(isci_device, isci_stopping);
+
+	/* We need comfirmation that stop completed. */
+	isci_device->completion = &completion;
+
+	BUG_ON(isci_device->isci_port == NULL);
+	BUG_ON(isci_device->isci_port->isci_host == NULL);
+
+	spin_lock_irqsave(&isci_device->isci_port->isci_host->scic_lock, flags);
+
+	status = scic_remote_device_stop(
+		isci_device->sci_device_handle,
+		50
+		);
+
+	spin_unlock_irqrestore(&isci_device->isci_port->isci_host->scic_lock, flags);
+
+	/* Wait for the stop complete callback. */
+	if (status == SCI_SUCCESS)
+		wait_for_completion(&completion);
+
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device = %p - after completion wait\n",
+		__func__, isci_device);
+
+	isci_device->completion = NULL;
+	return status;
+}
+
+/**
+ * isci_remote_device_gone() - This function is called by libsas when a domain
+ *    device is removed.
+ * @domain_device: This parameter specifies the libsas domain device.
+ *
+ */
+void isci_remote_device_gone(
+	struct domain_device *domain_dev)
+{
+	struct isci_remote_device *isci_device = isci_dev_from_domain_dev(
+		domain_dev);
+
+	dev_err(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: domain_device = %p, isci_device = %p, isci_port = %p\n",
+		__func__, domain_dev, isci_device, isci_device->isci_port);
+
+	if (isci_device != NULL)
+		isci_remote_device_stop(isci_device);
+}
+
+
+/**
+ * isci_remote_device_found() - This function is called by libsas when a remote
+ *    device is discovered. A remote device object is created and started. the
+ *    function then sleeps until the sci core device started message is
+ *    received.
+ * @domain_device: This parameter specifies the libsas domain device.
+ *
+ * status, zero indicates success.
+ */
+int isci_remote_device_found(struct domain_device *domain_dev)
+{
+	unsigned long flags;
+	struct isci_host *isci_host;
+	struct isci_port *isci_port;
+	struct isci_phy *isci_phy;
+	struct asd_sas_port *sas_port;
+	struct asd_sas_phy *sas_phy;
+	struct isci_remote_device *isci_device;
+	enum sci_status status;
+	DECLARE_COMPLETION_ONSTACK(completion);
+
+	isci_host = isci_host_from_sas_ha(domain_dev->port->ha);
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: domain_device = %p\n", __func__, domain_dev);
+
+	sas_port = domain_dev->port;
+	sas_phy = list_first_entry(&sas_port->phy_list, struct asd_sas_phy,
+				   port_phy_el);
+	isci_phy = to_isci_phy(sas_phy);
+	isci_port = isci_phy->isci_port;
+
+	/* we are being called for a device on this port,
+	 * so it has to come up eventually
+	 */
+	wait_for_completion(&isci_port->start_complete);
+
+	if ((isci_stopping == isci_port_get_state(isci_port)) ||
+	    (isci_stopped == isci_port_get_state(isci_port)))
+		return -ENODEV;
+
+	isci_device = isci_remote_device_alloc(isci_host, isci_port);
+
+	INIT_LIST_HEAD(&isci_device->node);
+	domain_dev->lldd_dev = isci_device;
+	isci_device->domain_dev = domain_dev;
+	isci_device->isci_port = isci_port;
+	isci_remote_device_change_state(isci_device, isci_starting);
+
+
+	spin_lock_irqsave(&isci_port->remote_device_lock, flags);
+	list_add_tail(&isci_device->node, &isci_port->remote_dev_list);
+
+	/* for the device ready event. */
+	isci_device->completion = &completion;
+
+	status = isci_remote_device_construct(isci_port, isci_device);
+
+	spin_unlock_irqrestore(&isci_port->remote_device_lock, flags);
+
+	/* wait for the device ready callback. */
+	wait_for_completion(isci_device->completion);
+	isci_device->completion = NULL;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p\n",
+		__func__, isci_device);
+
+	if (status != SCI_SUCCESS) {
+
+		spin_lock_irqsave(&isci_port->remote_device_lock, flags);
+		isci_remote_device_deconstruct(
+			isci_host,
+			isci_device
+			);
+		spin_unlock_irqrestore(&isci_port->remote_device_lock, flags);
+		return -ENODEV;
+	}
+
+	wait_for_completion(&isci_host->start_complete);
+
+	return 0;
+}
+/**
+ * isci_device_is_reset_pending() - This function will check if there is any
+ *    pending reset condition on the device.
+ * @request: This parameter is the isci_device object.
+ *
+ * true if there is a reset pending for the device.
+ */
+bool isci_device_is_reset_pending(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device)
+{
+	struct isci_request *isci_request;
+	struct isci_request *tmp_req;
+	bool reset_is_pending = false;
+	unsigned long flags;
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p\n", __func__, isci_device);
+
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
+
+	/* Check for reset on all pending requests. */
+	list_for_each_entry_safe(isci_request, tmp_req,
+				 &isci_device->reqs_in_process, dev_node) {
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: isci_device = %p request = %p\n",
+			__func__, isci_device, isci_request);
+
+		if (isci_request->ttype == io_task) {
+
+			unsigned long flags;
+			struct sas_task *task = isci_request_access_task(
+				isci_request);
+
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET)
+				reset_is_pending = true;
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+		}
+	}
+
+	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+
+	dev_dbg(&isci_host->pdev->dev,
+		"%s: isci_device = %p reset_is_pending = %d\n",
+		__func__, isci_device, reset_is_pending);
+
+	return reset_is_pending;
+}
+
+/**
+ * isci_device_clear_reset_pending() - This function will clear if any pending
+ *    reset condition flags on the device.
+ * @request: This parameter is the isci_device object.
+ *
+ * true if there is a reset pending for the device.
+ */
+void isci_device_clear_reset_pending(struct isci_remote_device *isci_device)
+{
+	struct isci_request *isci_request;
+	struct isci_request *tmp_req;
+	struct isci_host *isci_host = NULL;
+	unsigned long flags = 0;
+
+	/* FIXME more port gone confusion, and this time it makes the
+	 * locking "fun"
+	 */
+	if (isci_device->isci_port != NULL)
+		isci_host = isci_device->isci_port->isci_host;
+
+	/*
+	 * FIXME when the isci_host gets sorted out
+	 * use dev_dbg()
+	 */
+	pr_debug("%s: isci_device=%p, isci_host=%p\n",
+		 __func__, isci_device, isci_host);
+
+	if (isci_host != NULL)
+		spin_lock_irqsave(&isci_host->scic_lock, flags);
+	else
+		pr_err("%s: isci_device %p; isci_host == NULL!\n",
+		       __func__, isci_device);
+
+	/* Clear reset pending on all pending requests. */
+	list_for_each_entry_safe(isci_request, tmp_req,
+				 &isci_device->reqs_in_process, dev_node) {
+		/*
+		 * FIXME when the conditional spinlock is gone
+		 * change to dev_dbg()
+		 */
+		pr_debug("%s: isci_device = %p request = %p\n",
+			 __func__, isci_device, isci_request);
+
+		if (isci_request->ttype == io_task) {
+
+			unsigned long flags2;
+			struct sas_task *task = isci_request_access_task(
+				isci_request);
+
+			spin_lock_irqsave(&task->task_state_lock, flags2);
+			task->task_state_flags &= ~SAS_TASK_NEED_DEV_RESET;
+			spin_unlock_irqrestore(&task->task_state_lock, flags2);
+		}
+	}
+
+	if (isci_host != NULL)
+		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+}
+
+/**
+ * isci_remote_device_change_state() - This function gets the status of the
+ *    remote_device object.
+ * @isci_device: This parameter points to the isci_remote_device object
+ *
+ * status of the object as a isci_status enum.
+ */
+void isci_remote_device_change_state(
+	struct isci_remote_device *isci_device,
+	enum isci_status status)
+{
+	unsigned long flags;
+
+	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
+		"%s: isci_device = %p, state = 0x%x",
+		__func__,
+		isci_device,
+		status);
+
+	spin_lock_irqsave(&isci_device->state_lock, flags);
+	isci_device->status = status;
+	spin_unlock_irqrestore(&isci_device->state_lock, flags);
+}
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
new file mode 100644
index 0000000..a208f81
--- /dev/null
+++ b/drivers/scsi/isci/remote_device.h
@@ -0,0 +1,154 @@
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
+#if !defined(_ISCI_REMOTE_DEVICE_H_)
+#define _ISCI_REMOTE_DEVICE_H_
+#include "scic_user_callback.h"
+
+struct isci_host;
+struct scic_sds_remote_device;
+
+struct isci_remote_device {
+	struct scic_sds_remote_device *sci_device_handle;
+	enum isci_status status;
+	struct isci_port *isci_port;
+	struct domain_device *domain_dev;
+	struct completion *completion;
+	struct list_head node;
+	struct list_head reqs_in_process;
+	struct work_struct stop_work;
+	spinlock_t state_lock;
+	spinlock_t host_quiesce_lock;
+	bool host_quiesce;
+};
+
+#define to_isci_remote_device(p)	\
+	container_of(p, struct isci_remote_device, sci_remote_device);
+
+#define ISCI_REMOTE_DEVICE_START_TIMEOUT 5000
+
+
+/**
+ * This function gets the status of the remote_device object.
+ * @isci_device: This parameter points to the isci_remote_device object
+ *
+ * status of the object as a isci_status enum.
+ */
+static inline
+enum isci_status isci_remote_device_get_state(
+	struct isci_remote_device *isci_device)
+{
+	return (isci_device->host_quiesce)
+	       ? isci_host_quiesce
+	       : isci_device->status;
+}
+
+
+/**
+ * isci_dev_from_domain_dev() - This accessor retrieves the remote_device
+ *    object reference from the Linux domain_device reference.
+ * @domdev,: This parameter points to the Linux domain_device object .
+ *
+ * A reference to the associated isci remote device.
+ */
+#define isci_dev_from_domain_dev(domdev) \
+	((struct isci_remote_device *)(domdev)->lldd_dev)
+
+void isci_remote_device_start_complete(
+	struct isci_host *,
+	struct isci_remote_device *,
+	enum sci_status);
+
+void isci_remote_device_stop_complete(
+	struct isci_host *,
+	struct isci_remote_device *,
+	enum sci_status);
+
+enum sci_status isci_remote_device_stop(
+	struct isci_remote_device *isci_device);
+
+void isci_remote_device_nuke_requests(
+	struct isci_remote_device *isci_device);
+
+void isci_remote_device_ready(
+	struct isci_remote_device *);
+
+void isci_remote_device_not_ready(
+	struct isci_remote_device *,
+	u32);
+
+void isci_remote_device_gone(
+	struct domain_device *domain_dev);
+
+int isci_remote_device_found(
+	struct domain_device *domain_dev);
+
+bool isci_device_is_reset_pending(
+	struct isci_host *isci_host,
+	struct isci_remote_device *isci_device);
+
+void isci_device_clear_reset_pending(
+	struct isci_remote_device *isci_device);
+
+void isci_device_set_host_quiesce_lock_state(
+	struct isci_remote_device *isci_device,
+	bool lock_state);
+
+void isci_remote_device_change_state(
+	struct isci_remote_device *isci_device,
+	enum isci_status status);
+
+#endif /* !defined(_ISCI_REMOTE_DEVICE_H_) */
+

