From: "Jing Huang" <huangj@Brocade.COM>
Subject: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 20:56:14 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx20.brocade.com ([66.243.153.19]:40345 "EHLO mx20.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYIYEG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 00:06:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

From: Jing Huang <huangj@brocade.com>

This patch contains code that interfaces to upper layer linux kernel,
such as PCI, SCSI mid-layer and sysfs etc. It is created using
2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c           | 1339 ++++++++++++++++++
 drivers/scsi/bfa/bfad_attr.c      |  660 +++++++++
 drivers/scsi/bfa/bfad_attr.h      |   75 +
 drivers/scsi/bfa/bfad_drv.h       |  340 ++++
 drivers/scsi/bfa/bfad_fwimg.c     |   86 +
 drivers/scsi/bfa/bfad_im.c        | 1244 +++++++++++++++++
 drivers/scsi/bfa/bfad_im.h        |  197 ++
 drivers/scsi/bfa/bfad_im_compat.h |   36 
 drivers/scsi/bfa/bfad_intr.c      |  338 ++++
 drivers/scsi/bfa/bfad_ipfc.h      |   36 
 drivers/scsi/bfa/bfad_os.c        |   58 
 drivers/scsi/bfa/bfad_sysfs.c     | 2721
++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_sysfs.h     |   30 
 drivers/scsi/bfa/bfad_tm.h        |   59 
 drivers/scsi/bfa/bfad_trcmod.h    |   52 
 15 files changed, 7271 insertions(+)

diff -urpN orig/drivers/scsi/bfa/bfad_attr.c
patch/drivers/scsi/bfa/bfad_attr.c
--- orig/drivers/scsi/bfa/bfad_attr.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_attr.c	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,660 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfa_attr.c Linux driver configuration interface module.
+ */
+
+#include "bfad_drv.h"
+#include "bfad_im.h"
+#include "bfad_trcmod.h"
+#include <scsi/scsi_transport.h>
+#include "bfad_attr.h"
+
+/**
+ * @dg FC_transport_template FC transport template
+ * @{
+ */
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target port ID.
+ */
+void
+bfad_im_get_starget_port_id(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost;
+	struct bfad_im_port_s *im_port;
+	struct bfad_s         *bfad;
+	struct bfad_itnim_s   *itnim = NULL;
+	u32        fc_id = -1;
+	unsigned long   flags;
+
+	shost = bfad_os_starget_to_shost(starget);
+	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
+	bfad = im_port->bfad;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	itnim = bfad_os_get_itnim(im_port, starget->id);
+	if (itnim)
+		fc_id = bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim);
+
+	fc_starget_port_id(starget) = fc_id;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target nwwn.
+ */
+void
+bfad_im_get_starget_node_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost;
+	struct bfad_im_port_s *im_port;
+	struct bfad_s         *bfad;
+	struct bfad_itnim_s   *itnim = NULL;
+	u64             node_name = 0;
+	unsigned long   flags;
+
+	shost = bfad_os_starget_to_shost(starget);
+	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
+	bfad = im_port->bfad;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	itnim = bfad_os_get_itnim(im_port, starget->id);
+	if (itnim)
+		node_name = bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim);
+
+	fc_starget_node_name(starget) = bfa_os_htonll(node_name);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target pwwn.
+ */
+void
+bfad_im_get_starget_port_name(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost;
+	struct bfad_im_port_s *im_port;
+	struct bfad_s         *bfad;
+	struct bfad_itnim_s   *itnim = NULL;
+	u64             port_name = 0;
+	unsigned long   flags;
+
+	shost = bfad_os_starget_to_shost(starget);
+	im_port = (struct bfad_im_port_s *) shost->hostdata[0];
+	bfad = im_port->bfad;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	itnim = bfad_os_get_itnim(im_port, starget->id);
+	if (itnim)
+		port_name = bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim);
+
+	fc_starget_port_name(starget) = bfa_os_htonll(port_name);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host port ID.
+ */
+void
+bfad_im_get_host_port_id(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_port_s    *port = im_port->port;
+
+	fc_host_port_id(shost) =
+
bfa_os_hton3b(bfa_fcs_port_get_fcid(port->fcs_port));
+}
+
+/**
+ * @brief
+ * FC transport template entry, issue a LIP.
+ */
+int
+bfad_im_issue_fc_host_lip(struct Scsi_Host *shost)
+{
+	return 0;
+}
+
+/**
+ * @}
+ */
+
+
+
+struct Scsi_Host *
+bfad_os_starget_to_shost(struct scsi_target *starget)
+{
+	return dev_to_shost(starget->dev.parent);
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host port type.
+ */
+static void
+bfad_im_get_host_port_type(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_pport_attr_s attr;
+
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+
+	switch (attr.port_type) {
+	case BFA_PPORT_TYPE_NPORT:
+		fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+		break;
+	case BFA_PPORT_TYPE_NLPORT:
+		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		break;
+	case BFA_PPORT_TYPE_P2P:
+		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
+		break;
+	case BFA_PPORT_TYPE_LPORT:
+		fc_host_port_type(shost) = FC_PORTTYPE_LPORT;
+		break;
+	default:
+		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
+		break;
+	}
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host port state.
+ */
+static void
+bfad_im_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_pport_attr_s attr;
+
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+
+	switch (attr.port_state) {
+	case BFA_PPORT_ST_LINKDOWN:
+		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		break;
+	case BFA_PPORT_ST_LINKUP:
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+		break;
+	case BFA_PPORT_ST_UNINIT:
+	case BFA_PPORT_ST_ENABLING_QWAIT:
+	case BFA_PPORT_ST_ENABLING:
+	case BFA_PPORT_ST_DISABLING_QWAIT:
+	case BFA_PPORT_ST_DISABLING:
+	case BFA_PPORT_ST_DISABLED:
+	case BFA_PPORT_ST_STOPPED:
+	case BFA_PPORT_ST_IOCDOWN:
+	default:
+		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
+		break;
+	}
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host active fc4s.
+ */
+static void
+bfad_im_get_host_active_fc4s(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_port_s    *port = im_port->port;
+
+	memset(fc_host_active_fc4s(shost), 0,
+	       sizeof(fc_host_active_fc4s(shost)));
+
+	if (port->
+	    supported_fc4s & (BFA_PORT_ROLE_FCP_IM |
BFA_PORT_ROLE_FCP_TM))
+		fc_host_active_fc4s(shost)[2] = 1;
+
+	if (port->supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
+		fc_host_active_fc4s(shost)[3] = 0x20;
+
+	fc_host_active_fc4s(shost)[7] = 1;
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host link speed.
+ */
+static void
+bfad_im_get_host_speed(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_pport_attr_s attr;
+
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+	switch (attr.speed) {
+	case BFA_PPORT_SPEED_8GBPS:
+		fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
+		break;
+	case BFA_PPORT_SPEED_4GBPS:
+		fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
+		break;
+	case BFA_PPORT_SPEED_2GBPS:
+		fc_host_speed(shost) = FC_PORTSPEED_2GBIT;
+		break;
+	case BFA_PPORT_SPEED_1GBPS:
+		fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
+		break;
+	default:
+		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
+		break;
+	}
+}
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host port type.
+ */
+static void
+bfad_im_get_host_fabric_name(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_port_s    *port = im_port->port;
+	wwn_t           fabric_nwwn = 0;
+
+	fabric_nwwn = bfa_fcs_port_get_fabric_name(port->fcs_port);
+
+	fc_host_fabric_name(shost) = fabric_nwwn;
+
+}
+
+/**
+ * @brief
+ * FC transport template entry, get BFAD statistics.
+ */
+static struct fc_host_statistics *
+bfad_im_get_stats(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_hal_comp fcomp;
+	struct fc_host_statistics *hstats;
+	bfa_status_t    rc;
+	unsigned long   flags;
+
+	hstats = &bfad->link_stats;
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	memset(hstats, 0, sizeof(struct fc_host_statistics));
+	rc = bfa_pport_get_stats(&bfad->bfa,
+				     (struct bfa_pport_stats_s *)
hstats,
+				     bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (rc != BFA_STATUS_OK)
+		return NULL;
+
+	wait_for_completion(&fcomp.comp);
+
+	return hstats;
+}
+
+/**
+ * @brief
+ * FC transport template entry, reset BFAD statistics.
+ */
+static void
+bfad_im_reset_stats(struct Scsi_Host *shost)
+{
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_hal_comp fcomp;
+	unsigned long   flags;
+	bfa_status_t    rc;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_pport_clear_stats(&bfad->bfa, bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (rc != BFA_STATUS_OK)
+		return;
+
+	wait_for_completion(&fcomp.comp);
+
+	return;
+}
+
+/**
+ * @brief
+ * FC transport template entry, get rport loss timeout.
+ */
+static void
+bfad_im_get_rport_loss_tmo(struct fc_rport *rport)
+{
+	struct bfad_itnim_data_s *itnim_data = rport->dd_data;
+	struct bfad_itnim_s   *itnim = itnim_data->itnim;
+	struct bfad_s         *bfad = itnim->im->bfad;
+
+	rport->dev_loss_tmo = bfad->cfg_data.rport_del_timeout;
+}
+
+/**
+ * @brief
+ * FC transport template entry, set rport loss timeout.
+ */
+static void
+bfad_im_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
+{
+	if (timeout > 0)
+		rport->dev_loss_tmo = timeout;
+	else {
+		struct bfad_itnim_data_s *itnim_data = rport->dd_data;
+		struct bfad_itnim_s   *itnim = itnim_data->itnim;
+		struct bfad_s         *bfad = itnim->im->bfad;
+		rport->dev_loss_tmo = bfad->cfg_data.rport_del_timeout;
+	}
+
+}
+
+struct fc_function_template bfad_im_fc_function_template = {
+
+	/* Target dynamic attributes */
+	.get_starget_port_id = bfad_im_get_starget_port_id,
+	.show_starget_port_id = 1,
+	.get_starget_node_name = bfad_im_get_starget_node_name,
+	.show_starget_node_name = 1,
+	.get_starget_port_name = bfad_im_get_starget_port_name,
+	.show_starget_port_name = 1,
+
+	/* Host dynamic attribute */
+	.get_host_port_id = bfad_im_get_host_port_id,
+	.show_host_port_id = 1,
+
+	.issue_fc_host_lip = bfad_im_issue_fc_host_lip,
+
+	/* Host fixed attributes */
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+
+	/* More host dynamic attributes */
+	.show_host_port_type = 1,
+	.get_host_port_type = bfad_im_get_host_port_type,
+	.show_host_port_state = 1,
+	.get_host_port_state = bfad_im_get_host_port_state,
+	.show_host_active_fc4s = 1,
+	.get_host_active_fc4s = bfad_im_get_host_active_fc4s,
+	.show_host_speed = 1,
+	.get_host_speed = bfad_im_get_host_speed,
+	.show_host_fabric_name = 1,
+	.get_host_fabric_name = bfad_im_get_host_fabric_name,
+
+	.show_host_symbolic_name = 1,
+
+	/* Statistics */
+	.get_fc_host_stats = bfad_im_get_stats,
+	.reset_fc_host_stats = bfad_im_reset_stats,
+
+	/* Allocation length for host specific data */
+	.dd_fcrport_size = sizeof(struct bfad_itnim_data_s *),
+
+	/* Remote port fixed attributes */
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+	.show_rport_dev_loss_tmo = 1,
+	.get_rport_dev_loss_tmo = bfad_im_get_rport_loss_tmo,
+	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
+};
+
+/**
+ * @}
+ * @dg Scsi_Host_attrs SCSI host attributes
+ * @{
+ */
+static ssize_t
+bfad_im_serial_num_show(struct device *dev, struct device_attribute
*attr,
+			 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			ioc_attr.adapter_attr.serial_num);
+}
+
+static ssize_t
+bfad_im_model_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
ioc_attr.adapter_attr.model);
+}
+
+static ssize_t
+bfad_im_model_desc_show(struct device *dev, struct device_attribute
*attr,
+				 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			ioc_attr.adapter_attr.model_descr);
+}
+
+static ssize_t
+bfad_im_node_name_show(struct device *dev, struct device_attribute
*attr,
+				 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_port_s    *port = im_port->port;
+	u64        nwwn;
+
+	nwwn = bfa_fcs_port_get_nwwn(port->fcs_port);
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
bfa_os_htonll(nwwn));
+}
+
+static ssize_t
+bfad_im_symbolic_name_show(struct device *dev, struct device_attribute
*attr,
+				 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+
+	return snprintf(buf, PAGE_SIZE, "Brocade %s FV%s DV%s\n",
+			ioc_attr.adapter_attr.model,
+			ioc_attr.adapter_attr.fw_ver,
BFAD_DRIVER_VERSION);
+}
+
+static ssize_t
+bfad_im_hw_version_show(struct device *dev, struct device_attribute
*attr,
+				char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
ioc_attr.adapter_attr.hw_ver);
+}
+
+static ssize_t
+bfad_im_drv_version_show(struct device *dev, struct device_attribute
*attr,
+				char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+}
+
+static ssize_t
+bfad_im_optionrom_version_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			ioc_attr.adapter_attr.optrom_ver);
+}
+
+static ssize_t
+bfad_im_fw_version_show(struct device *dev, struct device_attribute
*attr,
+				 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
ioc_attr.adapter_attr.fw_ver);
+}
+
+static ssize_t
+bfad_im_num_of_ports_show(struct device *dev, struct device_attribute
*attr,
+				char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioc_attr_s  ioc_attr;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+	return snprintf(buf, PAGE_SIZE, "%d\n",
ioc_attr.adapter_attr.nports);
+}
+
+static ssize_t
+bfad_im_drv_name_show(struct device *dev, struct device_attribute
*attr,
+				char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+}
+
+static ssize_t
+bfad_im_num_of_discovered_ports_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_port_s    *port = im_port->port;
+	struct bfad_s         *bfad = im_port->bfad;
+	int        nrports = 2048;
+	wwn_t          *rports = NULL;
+	unsigned long   flags;
+
+	rports = kzalloc(sizeof(wwn_t) * nrports , GFP_ATOMIC);
+	if (rports == NULL)
+		return snprintf(buf, PAGE_SIZE, "Failed\n");
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_port_get_rports(port->fcs_port, rports, &nrports);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	kfree(rports);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
+}
+
+static          DEVICE_ATTR(serial_number, S_IRUGO,
+				bfad_im_serial_num_show, NULL);
+static          DEVICE_ATTR(model, S_IRUGO, bfad_im_model_show, NULL);
+static          DEVICE_ATTR(model_description, S_IRUGO,
+				bfad_im_model_desc_show, NULL);
+static          DEVICE_ATTR(node_name, S_IRUGO, bfad_im_node_name_show,
NULL);
+static          DEVICE_ATTR(symbolic_name, S_IRUGO,
+				bfad_im_symbolic_name_show, NULL);
+static          DEVICE_ATTR(hardware_version, S_IRUGO,
+				bfad_im_hw_version_show, NULL);
+static          DEVICE_ATTR(driver_version, S_IRUGO,
+				bfad_im_drv_version_show, NULL);
+static          DEVICE_ATTR(option_rom_version, S_IRUGO,
+				bfad_im_optionrom_version_show, NULL);
+static          DEVICE_ATTR(firmware_version, S_IRUGO,
+				bfad_im_fw_version_show, NULL);
+static          DEVICE_ATTR(number_of_ports, S_IRUGO,
+				bfad_im_num_of_ports_show, NULL);
+static          DEVICE_ATTR(driver_name, S_IRUGO,
bfad_im_drv_name_show, NULL);
+static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
+				bfad_im_num_of_discovered_ports_show,
NULL);
+
+struct device_attribute *bfad_im_host_attrs[] = {
+	&dev_attr_serial_number,
+	&dev_attr_model,
+	&dev_attr_model_description,
+	&dev_attr_node_name,
+	&dev_attr_symbolic_name,
+	&dev_attr_hardware_version,
+	&dev_attr_driver_version,
+	&dev_attr_option_rom_version,
+	&dev_attr_firmware_version,
+	&dev_attr_number_of_ports,
+	&dev_attr_driver_name,
+	&dev_attr_number_of_discovered_ports,
+	NULL,
+};
+
+/**
+ * @}
+ */
diff -urpN orig/drivers/scsi/bfa/bfad_attr.h
patch/drivers/scsi/bfa/bfad_attr.h
--- orig/drivers/scsi/bfa/bfad_attr.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_attr.h	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFAD_ATTR_H__
+#define __BFAD_ATTR_H__
+/**
+ * @file bfad_attr.h VMware driver configuration interface module.
+ */
+
+extern int supported_fc4s;
+
+/**
+ * @dg FC_transport_template FC transport template
+ * @{
+ */
+
+struct Scsi_Host*
+bfad_os_dev_to_shost(struct scsi_target *starget);
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target port ID.
+ */
+void
+bfad_im_get_starget_port_id(struct scsi_target *starget);
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target nwwn.
+ */
+void
+bfad_im_get_starget_node_name(struct scsi_target *starget);
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI target pwwn.
+ */
+void
+bfad_im_get_starget_port_name(struct scsi_target *starget);
+
+/**
+ * @brief
+ * FC transport template entry, get SCSI host port ID.
+ */
+void
+bfad_im_get_host_port_id(struct Scsi_Host *shost);
+
+/**
+ * @brief
+ * FC transport template entry, issue a LIP.
+ */
+int
+bfad_im_issue_fc_host_lip(struct Scsi_Host *shost);
+
+struct Scsi_Host*
+bfad_os_starget_to_shost(struct scsi_target *starget);
+
+/**
+ * @}
+ */
+#endif /*  __BFAD_ATTR_H__ */
diff -urpN orig/drivers/scsi/bfa/bfad.c patch/drivers/scsi/bfa/bfad.c
--- orig/drivers/scsi/bfa/bfad.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad.c	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,1339 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad.c Linux driver PCI interface module.
+ */
+
+#include "bfad_drv.h"
+#include "bfad_im.h"
+#include "bfad_tm.h"
+#include "bfad_ipfc.h"
+#include "bfad_trcmod.h"
+#include <linux/module.h>
+#include <fcb/bfa_fcb_vf.h>
+#include <fcb/bfa_fcb_rport.h>
+#include <fcb/bfa_fcb_port.h>
+#include <fcb/bfa_fcb.h>
+
+BFA_TRC_FILE(LDRV, BFAD);
+
+static bfa_status_t bfad_fc4_port_new(struct bfad_s *bfad,
+				struct bfad_port_s *port, int roles);
+static void bfad_fc4_port_delete(struct bfad_s *bfad,
+				struct bfad_port_s *port, int roles);
+
+struct semaphore bfad_sem;
+
+LIST_HEAD(bfad_list);
+
+static	int	bfad_inst;
+int             supported_fc4s;
+
+char 		*host_name;
+char 		*os_name;
+char 		*os_patch;
+int		num_rports;
+int		num_ios;
+int		num_tms;
+int		num_fcxps;
+int		num_ufbufs;
+int		reqq_size;
+int		rspq_size;
+int		num_sgpgs;
+int		rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
+int             bfa_ioc_queue_depth = BFAD_IOC_QUEUE_DEPTH;
+int             bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
+int             bfa_io_max_sge = BFAD_IO_MAX_SGE;
+int		log_level = BFA_LOG_ERROR;
+int		ioc_auto_recover = BFA_TRUE;
+
+void
+bfad_flags_set(struct bfad_s *bfad, u32 flags)
+{
+	if (bfad)
+		bfad->bfad_flags |= flags;
+}
+
+/**
+ * @dg BFA_HAL callbacks
+ * @{
+ */
+void
+bfad_hcb_comp(void *arg, bfa_status_t status)
+{
+	struct bfad_hal_comp *fcomp = (struct bfad_hal_comp *)arg;
+
+	fcomp->status = status;
+	complete(&fcomp->comp);
+}
+
+/**
+ * @brief
+ * bfa_init callback
+ */
+void
+bfa_cb_init(void *drv, bfa_status_t init_status)
+{
+	struct bfad_s         *bfad = drv;
+
+	if (init_status == BFA_STATUS_OK)
+		bfad->bfad_flags |= BFAD_HAL_INIT_DONE;
+
+	complete(&bfad->comp);
+}
+
+/**
+ * @brief
+ * bfa_stop callback
+ */
+void
+bfa_cb_stop(void *drv, bfa_status_t stop_status)
+{
+	struct bfad_s         *bfad = drv;
+
+	/* Signal the BFAD stop waiting thread */
+	complete(&bfad->comp);
+}
+
+/**
+ * @brief
+ * bfa_ioc_diable() callback.
+ */
+void
+bfa_cb_ioc_disable(void *drv)
+{
+	struct bfad_s         *bfad = drv;
+
+	complete(&bfad->disable_comp);
+}
+
+void
+bfa_fcb_exit(struct bfad_s *drv)
+{
+	complete(&drv->comp);
+}
+
+/**
+ * @}
+ */
+
+/**
+ * @dg BFA_FCS callbacks
+ * @{
+ */
+static struct bfad_port_s *
+bfad_get_drv_port(struct bfad_s *bfad, struct bfad_vf_s *vf_drv,
+			struct bfad_vport_s *vp_drv)
+{
+	return ((vp_drv) ? (&(vp_drv)->drv_port)
+		: ((vf_drv) ? (&(vf_drv)->base_port) :
(&(bfad)->pport)));
+}
+
+struct bfad_port_s *
+bfa_fcb_port_new(struct bfad_s *bfad, struct bfa_fcs_port_s *port,
+			enum bfa_port_role roles, struct bfad_vf_s
*vf_drv,
+			struct bfad_vport_s *vp_drv)
+{
+	bfa_status_t    rc;
+	struct bfad_port_s    *port_drv;
+
+	if (!vp_drv && !vf_drv) {
+		port_drv = &bfad->pport;
+		port_drv->pvb_type = BFAD_PORT_PHYS_BASE;
+	} else if (!vp_drv && vf_drv) {
+		port_drv = &vf_drv->base_port;
+		port_drv->pvb_type = BFAD_PORT_VF_BASE;
+	} else if (vp_drv && !vf_drv) {
+		port_drv = &vp_drv->drv_port;
+		port_drv->pvb_type = BFAD_PORT_PHYS_VPORT;
+	} else {
+		port_drv = &vp_drv->drv_port;
+		port_drv->pvb_type = BFAD_PORT_VF_VPORT;
+	}
+
+	port_drv->fcs_port = port;
+	port_drv->roles = roles;
+	rc = bfad_fc4_port_new(bfad, port_drv, roles);
+	if (rc != BFA_STATUS_OK) {
+		bfad_fc4_port_delete(bfad, port_drv, roles);
+		port_drv = NULL;
+	}
+
+	return port_drv;
+}
+
+void
+bfa_fcb_port_delete(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s
*vp_drv)
+{
+	struct bfad_port_s    *port_drv;
+
+	/* this will be only called from rmmod context */
+	if (vp_drv && !vp_drv->comp_del) {
+		port_drv = bfad_get_drv_port(bfad, vf_drv, vp_drv);
+		bfa_trc(bfad, roles);
+		bfad_fc4_port_delete(bfad, port_drv, roles);
+	}
+}
+
+void
+bfa_fcb_port_online(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s
*vp_drv)
+{
+	struct bfad_port_s *port_drv = bfad_get_drv_port(bfad, vf_drv,
vp_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_IM)
+		bfad_im_port_online(bfad, port_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_TM)
+		bfad_tm_port_online(bfad, port_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_IPFC)
+		bfad_ipfc_port_online(bfad, port_drv);
+
+	bfad_flags_set(bfad, BFAD_PORT_ONLINE);
+}
+
+void
+bfa_fcb_port_offline(struct bfad_s *bfad, enum bfa_port_role roles,
+			struct bfad_vf_s *vf_drv, struct bfad_vport_s
*vp_drv)
+{
+	struct bfad_port_s *port_drv = bfad_get_drv_port(bfad, vf_drv,
vp_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_IM)
+		bfad_im_port_offline(bfad, port_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_TM)
+		bfad_tm_port_offline(bfad, port_drv);
+
+	if (roles & BFA_PORT_ROLE_FCP_IPFC)
+		bfad_ipfc_port_offline(bfad, port_drv);
+}
+
+void
+bfa_fcb_vf_stop(struct bfad_vf_s *vf_drv)
+{
+}
+
+void
+bfa_fcb_vport_delete(struct bfad_vport_s *vport_drv)
+{
+	if (vport_drv->comp_del) {
+		complete(vport_drv->comp_del);
+		return;
+	}
+
+	kfree(vport_drv);
+}
+
+/**
+ * @brief
+ * FCS RPORT alloc callback, after successful PLOGI by FCS
+ */
+bfa_status_t
+bfa_fcb_rport_alloc(struct bfad_s *bfad, struct bfa_fcs_rport_s
**rport,
+		    struct bfad_rport_s **rport_drv)
+{
+	bfa_status_t    rc = BFA_STATUS_OK;
+
+	*rport_drv = kzalloc(sizeof(struct bfad_rport_s), GFP_ATOMIC);
+	if (*rport_drv == NULL) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+
+	*rport = &(*rport_drv)->fcs_rport;
+
+ext:
+	return rc;
+}
+
+/**
+ * @brief
+ * FCS RPORT free callback.
+ */
+void
+bfa_fcb_rport_free(struct bfad_s *bfad, struct bfad_rport_s
**rport_drv)
+{
+	kfree(*rport_drv);
+}
+
+/**
+ * @}
+ */
+
+void
+bfad_hal_mem_release(struct bfad_s *bfad)
+{
+	int             i;
+	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
+	struct bfa_mem_elem_s *meminfo_elem;
+
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		meminfo_elem = &hal_meminfo->meminfo[i];
+		if (meminfo_elem->kva != NULL) {
+			switch (meminfo_elem->mem_type) {
+			case BFA_MEM_TYPE_KVA:
+				vfree(meminfo_elem->kva);
+				break;
+			case BFA_MEM_TYPE_DMA:
+				dma_free_coherent(&bfad->pcidev->dev,
+					meminfo_elem->mem_len,
+					meminfo_elem->kva,
+					(dma_addr_t) meminfo_elem->dma);
+				break;
+			default:
+				bfa_assert(0);
+				break;
+			}
+		}
+	}
+
+	memset(hal_meminfo, 0, sizeof(struct bfa_meminfo_s));
+}
+
+void
+bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg)
+{
+	if (num_rports > 0)
+		bfa_cfg->fwcfg.num_rports = num_rports;
+	if (num_ios > 0)
+		bfa_cfg->fwcfg.num_ioim_reqs = num_ios;
+	if (num_tms > 0)
+		bfa_cfg->fwcfg.num_tskim_reqs = num_tms;
+	if (num_fcxps > 0)
+		bfa_cfg->fwcfg.num_fcxp_reqs = num_fcxps;
+	if (num_ufbufs > 0)
+		bfa_cfg->fwcfg.num_uf_bufs = num_ufbufs;
+	if (reqq_size > 0)
+		bfa_cfg->drvcfg.num_reqq_elems = reqq_size;
+	if (rspq_size > 0)
+		bfa_cfg->drvcfg.num_rspq_elems = rspq_size;
+	if (num_sgpgs > 0)
+		bfa_cfg->drvcfg.num_sgpgs = num_sgpgs;
+}
+
+bfa_status_t
+bfad_hal_mem_alloc(struct bfad_s *bfad)
+{
+	int             i;
+	struct bfa_meminfo_s *hal_meminfo = &bfad->meminfo;
+	struct bfa_mem_elem_s *meminfo_elem;
+	dma_addr_t      phys_addr;
+	void           *kva;
+	bfa_status_t    rc = BFA_STATUS_OK;
+
+	bfa_cfg_get_default(&bfad->ioc_cfg);
+	bfad_update_hal_cfg(&bfad->ioc_cfg);
+	bfa_cfg_get_meminfo(&bfad->ioc_cfg, hal_meminfo);
+
+	for (i = 0; i < BFA_MEM_TYPE_MAX; i++) {
+		meminfo_elem = &hal_meminfo->meminfo[i];
+		switch (meminfo_elem->mem_type) {
+		case BFA_MEM_TYPE_KVA:
+			kva = vmalloc(meminfo_elem->mem_len);
+			if (kva == NULL) {
+				bfad_hal_mem_release(bfad);
+				rc = BFA_STATUS_ENOMEM;
+				goto ext;
+			}
+			memset(kva, 0, meminfo_elem->mem_len);
+			meminfo_elem->kva = kva;
+			break;
+		case BFA_MEM_TYPE_DMA:
+			kva = dma_alloc_coherent(&bfad->pcidev->dev,
+				meminfo_elem->mem_len, &phys_addr,
GFP_KERNEL);
+			if (kva == NULL) {
+				bfad_hal_mem_release(bfad);
+				rc = BFA_STATUS_ENOMEM;
+				goto ext;
+			}
+			memset(kva, 0, meminfo_elem->mem_len);
+			meminfo_elem->kva = kva;
+			meminfo_elem->dma = phys_addr;
+			break;
+		default:
+			break;
+
+		}
+	}
+ext:
+	return rc;
+}
+
+struct bfad_s *
+bfad_find_bfad_by_inst_no(int inst_no)
+{
+	struct bfad_s         *bfad = NULL, *rc = NULL;
+
+	down(&bfad_sem);
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		if (bfad->inst_no == inst_no) {
+			rc = bfad;
+			break;
+		}
+	}
+	up(&bfad_sem);
+	return rc;
+}
+
+bfa_status_t
+bfad_fc4_probe(struct bfad_s *bfad)
+{
+	int             rc;
+
+	rc = bfad_im_probe(bfad);
+	if (rc != BFA_STATUS_OK)
+		goto ext;
+
+	bfad_tm_probe(bfad);
+
+	bfad_ipfc_probe(bfad);
+ext:
+	return rc;
+}
+
+void
+bfad_fc4_probe_undo(struct bfad_s *bfad)
+{
+	bfad_im_probe_undo(bfad);
+	bfad_tm_probe_undo(bfad);
+	bfad_ipfc_probe_undo(bfad);
+}
+
+static void
+bfad_fc4_probe_post(struct bfad_s *bfad)
+{
+	if (bfad->im)
+		bfad_im_probe_post(bfad->im);
+
+	bfad_tm_probe_post(bfad);
+	bfad_ipfc_probe_post(bfad);
+}
+
+static bfa_status_t
+bfad_fc4_port_new(struct bfad_s *bfad, struct bfad_port_s *port, int
roles)
+{
+	int             rc = BFA_STATUS_FAILED;
+
+	if (roles & BFA_PORT_ROLE_FCP_IM)
+		rc = bfad_im_port_new(bfad, port);
+	if (rc != BFA_STATUS_OK)
+		goto ext;
+
+	if (roles & BFA_PORT_ROLE_FCP_TM)
+		rc = bfad_tm_port_new(bfad, port);
+	if (rc != BFA_STATUS_OK)
+		goto ext;
+
+	if (roles & BFA_PORT_ROLE_FCP_IPFC)
+		rc = bfad_ipfc_port_new(bfad, port, port->pvb_type);
+ext:
+	return rc;
+}
+
+static void
+bfad_fc4_port_delete(struct bfad_s *bfad, struct bfad_port_s *port, int
roles)
+{
+	if (roles & BFA_PORT_ROLE_FCP_IM)
+		bfad_im_port_delete(bfad, port);
+
+	if (roles & BFA_PORT_ROLE_FCP_TM)
+		bfad_tm_port_delete(bfad, port);
+
+	if (roles & BFA_PORT_ROLE_FCP_IPFC)
+		bfad_ipfc_port_delete(bfad, port);
+}
+
+/**
+ * @brief
+ * Create a vport under a vf.
+ */
+bfa_status_t
+bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
+			struct bfa_port_cfg_s *port_cfg)
+{
+	struct bfad_vport_s   *vport;
+	int             rc = BFA_STATUS_OK;
+	unsigned long   flags;
+
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	if (!vport) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+
+	vport->drv_port.bfad = bfad;
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_fcs_vport_create(&vport->fcs_vport, &bfad->bfa_fcs,
vf_id,
+				  port_cfg, vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (rc != BFA_STATUS_OK)
+		goto ext_free_vport;
+
+	if (port_cfg->roles & BFA_PORT_ROLE_FCP_IM) {
+		rc = bfad_im_scsi_host_alloc(bfad,
vport->drv_port.im_port);
+		if (rc != BFA_STATUS_OK)
+			goto ext_free_fcs_vport;
+	}
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_vport_start(&vport->fcs_vport);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return BFA_STATUS_OK;
+
+ext_free_fcs_vport:
+ext_free_vport:
+	kfree(vport);
+ext:
+	return rc;
+}
+
+/**
+ * @brief
+ * Create a vf and its base vport implicitely.
+ */
+bfa_status_t
+bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
+			struct bfa_port_cfg_s *port_cfg)
+{
+	struct bfad_vf_s      *vf;
+	int             rc = BFA_STATUS_OK;
+
+	vf = kzalloc(sizeof(struct bfad_vf_s), GFP_KERNEL);
+	if (!vf) {
+		rc = BFA_STATUS_FAILED;
+		goto ext;
+	}
+
+	rc = bfa_fcs_vf_create(&vf->fcs_vf, &bfad->bfa_fcs, vf_id,
port_cfg,
+			       vf);
+	if (rc != BFA_STATUS_OK)
+		kfree(vf);
+ext:
+	return rc;
+}
+
+void
+bfad_bfa_tmo(unsigned long data)
+{
+	struct bfad_s         *bfad = (struct bfad_s *) data;
+	unsigned long   flags;
+	struct bfa_q_s         doneq;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_timer_tick(&bfad->bfa);
+	bfa_comp_deq(&bfad->bfa, &doneq);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (!bfa_q_is_empty(&doneq)) {
+		bfa_comp_process(&bfad->bfa, &doneq);
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_comp_free(&bfad->bfa, &doneq);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	}
+
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+}
+
+void
+bfad_init_timer(struct bfad_s *bfad)
+{
+	init_timer(&bfad->hal_tmo);
+	bfad->hal_tmo.function = bfad_bfa_tmo;
+	bfad->hal_tmo.data = (unsigned long)bfad;
+
+	mod_timer(&bfad->hal_tmo,
+		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
+}
+
+int
+bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
+{
+	unsigned long   bar0_len;
+	int             rc = -ENODEV;
+
+	if (pci_enable_device(pdev)) {
+		BFA_PRINTF(BFA_ERR, "pci_enable_device fail %p\n",
pdev);
+		goto out;
+	}
+
+	if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
+		goto out_disable_device;
+
+	pci_set_master(pdev);
+
+
+	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) != 0)
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) {
+			BFA_PRINTF(BFA_ERR, "pci_set_dma_mask fail
%p\n", pdev);
+			goto out_release_region;
+		}
+#ifdef SUPPORT_PCI_AER
+	/*
+	 * Enable PCIE Advanced Error Recovery (AER) if the kernel
version
+	 * supports.
+	 */
+	BFAD_ENABLE_PCIE_AER(pdev);
+#endif
+
+	bfad->pci_bar0_map = pci_resource_start(pdev, 0);
+	bar0_len = pci_resource_len(pdev, 0);
+	bfad->pci_bar0_kva = ioremap(bfad->pci_bar0_map, bar0_len);
+
+	if (bfad->pci_bar0_kva == NULL) {
+		BFA_DEV_PRINTF(bfad, BFA_ERR, "Fail to map bar0\n");
+		goto out_release_region;
+	}
+
+	bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
+	bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
+	bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
+	bfad->hal_pcidev.device_id = pdev->device;
+	bfad->pci_name = pci_name(pdev);
+
+	bfad->pci_attr.vendor_id = pdev->vendor;
+	bfad->pci_attr.device_id = pdev->device;
+	bfad->pci_attr.ssid = pdev->subsystem_device;
+	bfad->pci_attr.ssvid = pdev->subsystem_vendor;
+	bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);
+
+	bfad->pcidev = pdev;
+	return 0;
+
+out_release_region:
+	pci_release_regions(pdev);
+out_disable_device:
+	pci_disable_device(pdev);
+out:
+	return rc;
+}
+
+void
+bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
+{
+	iounmap(bfad->pci_bar0_kva);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+void
+bfad_fcs_port_cfg(struct bfad_s *bfad)
+{
+	struct bfa_port_cfg_s  port_cfg;
+	struct bfa_pport_attr_s attr;
+	char            symname[BFA_SYMNAME_MAXLEN];
+
+	sprintf(symname, "%s-%d", BFAD_DRIVER_NAME, bfad->inst_no);
+	memcpy(port_cfg.sym_name.symname, symname, strlen(symname));
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+	port_cfg.nwwn = attr.nwwn;
+	port_cfg.pwwn = attr.pwwn;
+
+	bfa_fcs_cfg_base_port(&bfad->bfa_fcs, &port_cfg);
+}
+
+bfa_status_t
+bfad_drv_init(struct bfad_s *bfad)
+{
+	bfa_status_t    rc;
+	unsigned long   flags;
+	struct bfa_fcs_driver_info_s driver_info;
+
+	bfad->cfg_data.rport_del_timeout = rport_del_timeout;
+	bfad->cfg_data.ioc_queue_depth = bfa_ioc_queue_depth;
+	bfad->cfg_data.lun_queue_depth = bfa_lun_queue_depth;
+	bfad->cfg_data.io_max_sge = bfa_io_max_sge;
+	bfad->cfg_data.binding_method = FCP_PWWN_BINDING;
+
+	rc = bfad_hal_mem_alloc(bfad);
+	if (rc != BFA_STATUS_OK) {
+		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc
failure\n",
+				bfad->inst_no);
+		goto out_hal_mem_alloc_failure;
+	}
+
+	bfa_init_log(&bfad->bfa, bfad->logmod);
+	bfa_init_trc(&bfad->bfa, bfad->trcmod);
+	bfa_init_aen(&bfad->bfa, bfad->aen);
+	bfa_init_plog(&bfad->bfa, &bfad->plog_buf);
+	bfa_plog_str(&bfad->plog_buf, BFA_PL_MID_DRVR,
BFA_PL_EID_DRIVER_START,
+		     0, "Driver Attach");
+
+	bfa_attach(&bfad->bfa, bfad, &bfad->ioc_cfg, &bfad->meminfo,
+		       &bfad->hal_pcidev);
+
+	init_completion(&bfad->comp);
+	bfa_init(&bfad->bfa);
+
+	bfad_init_timer(bfad);
+	bfa_isr_enable(&bfad->bfa);
+
+	/* Enable Interrupt and wait bfa_init completion */
+	if (bfad_setup_intr(bfad)) {
+		printk(KERN_WARNING "bfad%d: bfad_setup_intr failed\n",
+			bfad->inst_no);
+		goto out_setup_intr_failure;
+	}
+	wait_for_completion(&bfad->comp);
+
+	memset(&driver_info, 0, sizeof(driver_info));
+	strncpy(driver_info.version, BFAD_DRIVER_VERSION,
+				sizeof(driver_info.version) - 1);
+	if (host_name)
+		strncpy(driver_info.host_machine_name, host_name,
+				sizeof(driver_info.host_machine_name) -
1);
+	if (os_name)
+		strncpy(driver_info.host_os_name, os_name,
+				sizeof(driver_info.host_os_name) - 1);
+	if (os_patch)
+		strncpy(driver_info.host_os_patch, os_patch,
+				sizeof(driver_info.host_os_patch) - 1);
+
+	strncpy(driver_info.os_device_name, bfad->pci_name,
+				sizeof(driver_info.os_device_name - 1));
+
+	/* FCS INIT */
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_log_init(&bfad->bfa_fcs, bfad->logmod);
+	bfa_fcs_trc_init(&bfad->bfa_fcs, bfad->trcmod);
+	bfa_fcs_aen_init(&bfad->bfa_fcs, bfad->aen);
+	bfa_fcs_init(&bfad->bfa_fcs, &bfad->bfa, bfad);
+	bfa_fcs_driver_info_init(&bfad->bfa_fcs, &driver_info);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	bfad->bfad_flags |= BFAD_DRV_INIT_DONE;
+	return BFA_STATUS_OK;
+
+out_setup_intr_failure:
+	del_timer_sync(&bfad->hal_tmo);
+	bfa_detach(&bfad->bfa);
+	bfad_hal_mem_release(bfad);
+out_hal_mem_alloc_failure:
+	return BFA_STATUS_FAILED;
+}
+
+void
+bfad_drv_uninit(struct bfad_s *bfad)
+{
+	bfad_remove_intr(bfad);
+	del_timer_sync(&bfad->hal_tmo);
+	bfa_detach(&bfad->bfa);
+	bfad_hal_mem_release(bfad);
+}
+
+void
+bfad_drv_start(struct bfad_s *bfad)
+{
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_start(&bfad->bfa);
+	bfad->bfad_flags |= BFAD_HAL_START_DONE;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	bfad_fc4_probe_post(bfad);
+}
+
+void
+bfad_drv_stop(struct bfad_s *bfad)
+{
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfad->pport.flags |= BFAD_PORT_DELETE;
+	bfa_fcs_exit(&bfad->bfa_fcs);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	init_completion(&bfad->comp);
+	bfa_stop(&bfad->bfa);
+	bfad->bfad_flags &= ~BFAD_HAL_START_DONE;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	wait_for_completion(&bfad->comp);
+}
+
+bfa_status_t
+bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role role)
+{
+	int             rc = BFA_STATUS_OK;
+
+	/* Allocate scsi_host for the physical port */
+	if ((supported_fc4s & BFA_PORT_ROLE_FCP_IM)
+	    && (role & BFA_PORT_ROLE_FCP_IM)) {
+		if (bfad->pport.im_port == NULL) {
+			rc = BFA_STATUS_FAILED;
+			goto out;
+		}
+
+		rc = bfad_im_scsi_host_alloc(bfad, bfad->pport.im_port);
+		if (rc != BFA_STATUS_OK)
+			goto out;
+
+		bfad->pport.roles |= BFA_PORT_ROLE_FCP_IM;
+	}
+
+	bfad->bfad_flags |= BFAD_CFG_PPORT_DONE;
+
+out:
+	return rc;
+}
+
+void
+bfad_uncfg_pport(struct bfad_s *bfad)
+{
+
+	if (bfad->pport.roles & BFA_PORT_ROLE_FCP_IPFC) {
+		bfad_ipfc_port_delete(bfad, &bfad->pport);
+		bfad->pport.roles &= ~BFA_PORT_ROLE_FCP_IPFC;
+	}
+
+	if ((supported_fc4s & BFA_PORT_ROLE_FCP_IM)
+	    && (bfad->pport.roles & BFA_PORT_ROLE_FCP_IM)) {
+		bfad_im_scsi_host_free(bfad, bfad->pport.im_port);
+		bfad_im_port_clean(bfad->pport.im_port);
+		kfree(bfad->pport.im_port);
+		bfad->pport.roles &= ~BFA_PORT_ROLE_FCP_IM;
+	}
+
+	bfad->bfad_flags &= ~BFAD_CFG_PPORT_DONE;
+}
+
+void
+bfad_drv_log_level_set(struct bfad_s *bfad)
+{
+	if (log_level > 0 && log_level <= BFA_LOG_LEVEL_MAX)
+		bfa_log_set_level_all(&bfad->log_data, log_level);
+}
+
+ /*
+  * @dg PCI_entry PCI driver entries *@{
+  */
+
+/**
+ * @brief
+ * PCI probe entry.
+ */
+int
+bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
+{
+	struct bfad_s   *bfad;
+	int             error = -ENODEV, retval;
+	char            buf[16];
+
+	/* For single port cards - only claim function 0 */
+	if ((pdev->device == BFA_PCI_DEVICE_ID_FC_8G1P)
+	    && (PCI_FUNC(pdev->devfn) != 0))
+		return -ENODEV;
+
+	BFA_TRACE(BFA_INFO, "bfad_pci_probe entry");
+
+	bfad = kzalloc(sizeof(struct bfad_s), GFP_KERNEL);
+	if (!bfad) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	bfad->trcmod = kzalloc(sizeof(struct bfa_trc_mod_s),
GFP_KERNEL);
+	if (!bfad->trcmod) {
+		printk(KERN_WARNING "Error alloc trace buffer!\n");
+		error = -ENOMEM;
+		goto out_alloc_trace_failure;
+	}
+
+	/* LOG/TRACE INIT */
+	bfa_trc_init(bfad->trcmod);
+	bfa_trc(bfad, bfad_inst);
+
+	bfad->logmod = &bfad->log_data;
+	sprintf(buf, "%d", bfad_inst);
+	bfa_log_init(bfad->logmod, buf, bfa_os_printf);
+
+	bfad_drv_log_level_set(bfad);
+
+	bfad->aen = &bfad->aen_buf;
+
+	bfad_load_fwimg(pdev);
+
+	retval = bfad_pci_init(pdev, bfad);
+	if (retval) {
+		printk(KERN_WARNING "bfad_pci_init failure!\n");
+		error = retval;
+		goto out_pci_init_failure;
+	}
+
+	down(&bfad_sem);
+	bfad->inst_no = bfad_inst++;
+	list_add_tail(&bfad->list_entry, &bfad_list);
+	up(&bfad_sem);
+
+	spin_lock_init(&bfad->bfad_lock);
+	pci_set_drvdata(pdev, bfad);
+
+	bfad->ref_count = 0;
+	bfad->pport.bfad = bfad;
+
+	/* Create the base sysfs attributes for BFAD control */
+	bfad_os_device_sysfs_create(bfad);
+
+	retval = bfad_drv_init(bfad);
+	if (retval != BFA_STATUS_OK)
+		goto out_drv_init_failure;
+	if (!(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+		printk(KERN_WARNING "bfad%d: hal init failed\n",
bfad->inst_no);
+		goto ok;
+	}
+
+	/* PPORT FCS config */
+	bfad_fcs_port_cfg(bfad);
+
+	retval = bfad_cfg_pport(bfad, BFA_PORT_ROLE_FCP_IM);
+	if (retval != BFA_STATUS_OK)
+		goto out_cfg_pport_failure;
+
+	/* BFAD level FC4 (IM/TM/IPFC) specific resource allocation */
+	retval = bfad_fc4_probe(bfad);
+	if (retval != BFA_STATUS_OK) {
+		printk(KERN_WARNING "bfad_fc4_probe failed\n");
+		goto out_fc4_probe_failure;
+	}
+
+	bfad_drv_start(bfad);
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_DEVICE_CLAIMED,
bfad->pci_name);
+ok:
+	return 0;
+
+out_fc4_probe_failure:
+	bfad_fc4_probe_undo(bfad);
+	bfad_uncfg_pport(bfad);
+out_cfg_pport_failure:
+	bfad_drv_uninit(bfad);
+out_drv_init_failure:
+	bfad_os_device_sysfs_remove(bfad);
+	down(&bfad_sem);
+	bfad_inst--;
+	list_del(&bfad->list_entry);
+	up(&bfad_sem);
+	bfad_pci_uninit(pdev, bfad);
+out_pci_init_failure:
+	kfree(bfad->trcmod);
+out_alloc_trace_failure:
+	kfree(bfad);
+out:
+	return error;
+}
+
+/**
+ * @brief
+ * PCI remove entry.
+ */
+void
+bfad_pci_remove(struct pci_dev *pdev)
+{
+	struct bfad_s         *bfad = pci_get_drvdata(pdev);
+	unsigned long   flags;
+
+	bfa_trc(bfad, bfad->inst_no);
+
+	if ((bfad->bfad_flags & BFAD_DRV_INIT_DONE)
+	    && !(bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
+		bfad_remove_intr(bfad);
+		del_timer_sync(&bfad->hal_tmo);
+		goto hal_detach;
+	} else if (!(bfad->bfad_flags & BFAD_DRV_INIT_DONE)) {
+		goto remove_sysfs;
+	}
+
+	if (bfad->bfad_flags & BFAD_HAL_START_DONE)
+		bfad_drv_stop(bfad);
+
+	bfad_remove_intr(bfad);
+
+	del_timer_sync(&bfad->hal_tmo);
+	bfad_fc4_probe_undo(bfad);
+
+	if (bfad->bfad_flags & BFAD_CFG_PPORT_DONE)
+		bfad_uncfg_pport(bfad);
+
+hal_detach:
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_detach(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	bfad_hal_mem_release(bfad);
+remove_sysfs:
+	bfad_os_device_sysfs_remove(bfad);
+
+	down(&bfad_sem);
+	bfad_inst--;
+	list_del(&bfad->list_entry);
+	up(&bfad_sem);
+	bfad_pci_uninit(pdev, bfad);
+
+	kfree(bfad->trcmod);
+	kfree(bfad);
+}
+
+#define BFAD_MAX_PCIIDS	4
+struct pci_device_id bfad_id_table[BFAD_MAX_PCIIDS] = {
+	{
+	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
+	 .device = BFA_PCI_DEVICE_ID_FC_8G2P,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 },
+	{
+	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
+	 .device = BFA_PCI_DEVICE_ID_FC_8G1P,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 },
+	{
+	 .vendor = BFA_PCI_VENDOR_ID_BROCADE,
+	 .device = BFA_PCI_DEVICE_ID_CT,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 .class = (PCI_CLASS_SERIAL_FIBER << 8),
+	 .class_mask = ~0,
+	 },
+
+	{0, 0},
+};
+
+MODULE_DEVICE_TABLE(pci, bfad_id_table);
+
+/**
+ * @}
+ * @dg Linux driver module functions
+ * @{
+ */
+
+bfa_status_t
+bfad_fc4_module_init(void)
+{
+	int             rc;
+
+	rc = bfad_im_module_init();
+	if (rc != BFA_STATUS_OK)
+		goto ext;
+
+	bfad_tm_module_init();
+	bfad_ipfc_module_init();
+ext:
+	return rc;
+}
+
+void
+bfad_fc4_module_exit(void)
+{
+	bfad_ipfc_module_exit();
+	bfad_tm_module_exit();
+	bfad_im_module_exit();
+}
+
+/**
+ * @brief
+ * Driver module init.
+ */
+static int __init
+bfad_init(void)
+{
+	int             error = 0;
+
+	error = bfad_fc4_module_init();
+	if (error) {
+		error = -ENOMEM;
+		printk(KERN_WARNING "bfad_fc4_module_init failure\n");
+		goto ext;
+	}
+
+	sema_init(&bfad_sem, 1);
+
+	if (!strcmp(FCPI_NAME, " fcpim"))
+		supported_fc4s |= BFA_PORT_ROLE_FCP_IM;
+	if (!strcmp(FCPT_NAME, " fcptm"))
+		supported_fc4s |= BFA_PORT_ROLE_FCP_TM;
+	if (!strcmp(IPFC_NAME, " ipfc"))
+		supported_fc4s |= BFA_PORT_ROLE_FCP_IPFC;
+
+	bfa_ioc_auto_recover(ioc_auto_recover);
+	bfa_fcs_rport_set_del_timeout(rport_del_timeout);
+	error = pci_register_driver(bfad_pci_driver_p);
+	if (error) {
+		printk(KERN_WARNING "pci_register_driver failure\n");
+		goto ext;
+	}
+	return 0;
+
+ext:
+	bfad_fc4_module_exit();
+	return error;
+}
+
+/**
+ * @brief
+ * Driver module exit.
+ */
+static void __exit
+bfad_exit(void)
+{
+	pci_unregister_driver(bfad_pci_driver_p);
+	bfad_fc4_module_exit();
+}
+
+#define BFAD_PROTO_NAME FCPI_NAME FCPT_NAME IPFC_NAME
+
+module_init(bfad_init);
+module_exit(bfad_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Brocade Fibre Channel HBA Driver" BFAD_PROTO_NAME);
+MODULE_AUTHOR("Brocade Communications Systems, Inc.");
+MODULE_VERSION(BFAD_DRIVER_VERSION);
+
+/*
+ * @}
+ */
+
+#include "bfad_sysfs.h"
+
+
+module_param(os_name, charp, S_IRUGO | S_IWUSR);
+module_param(os_patch, charp, S_IRUGO | S_IWUSR);
+module_param(host_name, charp, S_IRUGO | S_IWUSR);
+module_param(num_rports, int, S_IRUGO | S_IWUSR);
+module_param(num_ios, int, S_IRUGO | S_IWUSR);
+module_param(num_tms, int, S_IRUGO | S_IWUSR);
+module_param(num_fcxps, int, S_IRUGO | S_IWUSR);
+module_param(num_ufbufs, int, S_IRUGO | S_IWUSR);
+module_param(reqq_size, int, S_IRUGO | S_IWUSR);
+module_param(rspq_size, int, S_IRUGO | S_IWUSR);
+module_param(num_sgpgs, int, S_IRUGO | S_IWUSR);
+module_param(rport_del_timeout, int, S_IRUGO | S_IWUSR);
+module_param(msix_disable, int, S_IRUGO | S_IWUSR);
+module_param(bfa_ioc_queue_depth, int, S_IRUGO | S_IWUSR);
+module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
+module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
+module_param(log_level, int, S_IRUGO | S_IWUSR);
+module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
+
+#ifdef CONFIG_PM
+int             pci_save_state(struct pci_dev *pdev);
+int             pci_restore_state(struct pci_dev *pdev);
+#endif
+
+struct bfad_s         *
+bfad_os_find_bfad_by_path(char *path)
+{
+	struct bfad_s         *bfad = NULL, *rc = NULL;
+	char           *ioc_path;
+
+	down(&bfad_sem);
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		ioc_path = bfad_os_sysfs_get_ioc_path(bfad);
+		if (strstr(path, ioc_path)) {
+			rc = bfad;
+			kfree(ioc_path);
+			break;
+		}
+		kfree(ioc_path);
+	}
+	up(&bfad_sem);
+	return rc;
+}
+
+#ifdef CONFIG_PM
+/**
+ * @brief
+ * PCI suspend entry.
+ */
+static int
+bfad_os_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct bfad_s         *bfad = pci_get_drvdata(pdev);
+	pci_power_t     device_state;
+
+	device_state = pci_choose_state(pdev, state);
+
+	pci_save_state(pdev);
+	init_completion(&bfad->suspend);
+	wait_for_completion(&bfad->suspend);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, device_state);
+
+	return 0;
+}
+
+/**
+ * @brief
+ * PCI resume entry.
+ */
+static int
+bfad_os_resume(struct pci_dev *pdev)
+{
+
+	/* Resume the device power state to D0 */
+	pci_set_power_state(pdev, 0);
+
+	/* Restore all device PCI configuation space to its original
state. */
+	pci_restore_state(pdev);
+
+	if (pci_enable_device(pdev))
+		goto out;
+
+	return 0;
+
+out:
+	return 1;
+
+}
+#endif
+
+#ifdef SUPPORT_PCI_AER
+/*
+ * PCI error recovery support, this fearure is only availbe for kernel
+ * .6.16 or later.
+ */
+/**
+ * @brief
+ * PCI Error Recovery entry, error detected.
+ */
+static          pci_ers_result_t
+bfad_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t
state)
+{
+	struct bfad_s         *bfad = pci_get_drvdata(pdev);
+
+	switch (state) {
+	case pci_channel_io_perm_failure:
+		/*
+		 * PCI bus has permanently failed. This is
+		 * unrecoveralbe, Do we need to do the cleanup like PCI
+		 * remove? or kernel will automatically do it?
+		 */
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	case pci_channel_io_frozen:
+
+	default:
+
+		init_completion(&bfad->comp);
+		bfa_fcs_exit(&bfad->bfa_fcs);
+		bfa_stop(&bfad->bfa);
+		wait_for_completion_timeout(&bfad->comp,
BFAD_STOP_TIMEOUT);
+
+		pci_disable_device(pdev);
+
+		break;
+	}
+
+	/*
+	 * Request a slot reset
+	 */
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * @brief
+ * PCI Error Recovery entry, re-initialize the chip.
+ */
+static          pci_ers_result_t
+bfad_pci_slot_reset(struct pci_dev *pdev)
+{
+	struct bfad_s         *bfad = pci_get_drvdata(pdev);
+	int             retval;
+
+	if (pci_enable_device(pdev))
+		goto out;
+
+	pci_set_master(pdev);
+
+	retval = pci_set_mwi(pdev);
+
+	if (retval)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "Warning: pci_set_mwi returned %d\n",
retval);
+
+	if (pci_set_dma_mask(bfad->pcidev, DMA_64BIT_MASK) != 0)
+		if (pci_set_dma_mask(bfad->pcidev, DMA_32BIT_MASK) != 0)
+			goto out_disable_device;
+
+	BFAD_ENABLE_PCIE_AER(pdev);
+
+	/* bfa should still keep all the BFAD and port config info */
+	bfa_start(&bfad->bfa);
+
+	return PCI_ERS_RESULT_RECOVERED;
+
+out_disable_device:
+	pci_disable_device(pdev);
+out:
+	return PCI_ERS_RESULT_DISCONNECT;
+
+}
+
+/*
+ * PCI error recovery support, this fearure is only available for
kernel
+ * 2.6.16 or later. At this point, we only define error_detected and
+ * slot_reset.
+ */
+static struct pci_error_handlers bfad_err_handler = {
+	.error_detected = bfad_pci_error_detected,
+	.slot_reset = bfad_pci_slot_reset,
+};
+#endif
+
+static int      __devinit
+bfad_os_pci_probe(struct pci_dev *pdev, const struct pci_device_id
*pid)
+{
+	return (bfad_pci_probe(pdev, pid));
+}
+
+static void
+bfad_os_pci_remove(struct pci_dev *pdev)
+{
+	bfad_pci_remove(pdev);
+}
+
+static struct pci_driver bfad_pci_driver = {
+	.name = BFAD_DRIVER_NAME,
+	.id_table = bfad_id_table,
+	.probe = bfad_os_pci_probe,
+	.remove = __devexit_p(bfad_os_pci_remove),
+#ifdef CONFIG_PM
+	.suspend = bfad_os_suspend,
+	.resume = bfad_os_resume,
+#endif
+
+#ifdef SUPPORT_PCI_AER
+	/*
+	 * PCI error recovery support, this fearure is only available
for
+	 * kernel 2.6.16 or later.
+	 */
+	.err_handler = &bfad_err_handler,
+#endif
+};
+
+struct pci_driver *bfad_pci_driver_p = &bfad_pci_driver;
+
+/*
+ * @}
+ */
diff -urpN orig/drivers/scsi/bfa/bfad_drv.h
patch/drivers/scsi/bfa/bfad_drv.h
--- orig/drivers/scsi/bfa/bfad_drv.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_drv.h	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,340 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @brief
+ * Contains base driver definitions.
+ */
+
+/**
+ * @file bfa_drv.h Linux driver data structures.
+ */
+
+#ifndef __BFAD_DRV_H__
+#define __BFAD_DRV_H__
+
+#include "bfa_os_inc.h"
+
+#include <bfa.h>
+#include <bfa_svc.h>
+#include <fcs/bfa_fcs.h>
+#include <defs/bfa_defs_pci.h>
+#include <defs/bfa_defs_port.h>
+#include <defs/bfa_defs_rport.h>
+#include <fcs/bfa_fcs_rport.h>
+#include <defs/bfa_defs_vport.h>
+#include <fcs/bfa_fcs_vport.h>
+
+#include <cs/bfa_plog.h>
+#include "aen/bfa_aen.h"
+#include <log/bfa_log_linux.h>
+
+#define BFAD_DRIVER_NAME        "bfa"
+#ifdef BFA_DRIVER_VERSION
+#define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
+#else
+#define BFAD_DRIVER_VERSION    "1.0.0"
+#endif
+
+#if defined(CONFIG_PCIEPORTBUS) && defined(CONFIG_PCIEAER)
+#define BFAD_ENABLE_PCIE_AER(x) pci_enable_pcie_error_reporting(x)
+#else
+#define BFAD_ENABLE_PCIE_AER(x) {}
+#endif
+
+
+#define BFAD_IRQ_FLAGS IRQF_SHARED
+
+#ifndef FC_PORTSPEED_8GBIT
+#define FC_PORTSPEED_8GBIT 0x10
+#endif
+
+/*
+ * BFAD flags
+ */
+#define BFAD_MSIX_ON				0x00000001
+#define BFAD_HAL_INIT_DONE			0x00000002
+#define BFAD_DRV_INIT_DONE			0x00000004
+#define BFAD_CFG_PPORT_DONE			0x00000008
+#define BFAD_HAL_START_DONE			0x00000010
+#define BFAD_PORT_ONLINE			0x00000020
+#define BFAD_RPORT_ONLINE			0x00000040
+
+#define BFAD_PORT_DELETE			0x00000001
+
+/*
+ * BFAD related definition
+ */
+#define SCSI_SCAN_DELAY		HZ
+#define BFAD_STOP_TIMEOUT	30
+#define BFAD_SUSPEND_TIMEOUT	BFAD_STOP_TIMEOUT
+
+/*
+ * BFAD configuration parameter default values
+ */
+#define BFAD_IOC_QUEUE_DEPTH 		2048
+#define BFAD_LUN_QUEUE_DEPTH 		32
+#define BFAD_IO_MAX_SGE 		SG_ALL
+
+#define bfad_isr_t irq_handler_t
+
+#ifdef CONFIG_PCI_MSI
+#define MAX_MSIX_ENTRY 24
+
+struct bfad_msix {
+	bfad_isr_t      handler;
+	struct msix_entry msix;
+};
+#endif
+
+enum bfad_port_pvb_type {
+	BFAD_PORT_PHYS_BASE = 0,
+	BFAD_PORT_PHYS_VPORT = 1,
+	BFAD_PORT_VF_BASE = 2,
+	BFAD_PORT_VF_VPORT = 3,
+};
+
+/*
+ * PORT data structure
+ */
+struct bfad_port_s {
+	struct list_head list_entry;
+	struct bfad_s         *bfad;
+	struct bfa_fcs_port_s *fcs_port;
+	u32        roles;
+	s32         flags;
+	u32        supported_fc4s;
+	enum bfad_port_pvb_type pvb_type;
+	struct bfad_im_port_s *im_port;	/* IM specific data */
+	struct bfad_tm_port_s *tm_port;	/* TM specific data */
+	struct bfad_ipfc_port_s *ipfc_port;	/* IPFC specific data */
+};
+
+/*
+ * VPORT data structure
+ */
+struct bfad_vport_s {
+	struct bfad_port_s     drv_port;
+	struct bfa_fcs_vport_s fcs_vport;
+	struct completion *comp_del;
+};
+
+/*
+ * VF data structure
+ */
+struct bfad_vf_s {
+	bfa_fcs_vf_t    fcs_vf;
+	struct bfad_port_s    base_port;	/* base port for vf */
+	struct bfad_s   *bfad;
+};
+
+struct bfad_cfg_param_s {
+	u32        rport_del_timeout;
+	u32        ioc_queue_depth;
+	u32        lun_queue_depth;
+	u32        io_max_sge;
+	u32        binding_method;
+};
+
+/*
+ * BFAD (PCI function) data structure
+ */
+struct bfad_s {
+	struct list_head list_entry;
+	struct bfa_s       bfa;
+	struct bfa_fcs_s       bfa_fcs;
+	struct pci_dev *pcidev;
+	const char *pci_name;
+	struct bfa_pcidev_s hal_pcidev;
+	struct bfa_ioc_pci_attr_s pci_attr;
+	unsigned long   pci_bar0_map;
+	void __iomem   *pci_bar0_kva;
+	struct completion comp;
+	struct completion suspend;
+	struct completion disable_comp;
+	bfa_boolean_t   disable_active;
+	struct bfad_port_s     pport;	/* physical port of the BFAD */
+	struct bfa_meminfo_s meminfo;
+	struct bfa_iocfc_cfg_s   ioc_cfg;
+	u32        inst_no;	/* BFAD instance number */
+	u32        bfad_flags;
+	spinlock_t      bfad_lock;
+	struct bfad_cfg_param_s cfg_data;
+#ifdef CONFIG_PCI_MSI
+	struct bfad_msix msix_tab[MAX_MSIX_ENTRY];
+	int             nvec;
+#endif
+
+	char            adapter_name[BFA_ADAPTER_SYM_NAME_LEN];
+	char            port_name[BFA_ADAPTER_SYM_NAME_LEN];
+	struct timer_list hal_tmo;
+	unsigned long   hs_start;
+	struct bfad_im_s *im;		/* IM specific data */
+	struct bfad_tm_s *tm;		/* TM specific data */
+	struct bfad_ipfc_s *ipfc;	/* IPFC specific data */
+	struct bfa_log_mod_s   log_data;
+	struct bfa_trc_mod_s  *trcmod;
+	struct bfa_log_mod_s  *logmod;
+	struct bfa_aen_s      *aen;
+	struct bfa_aen_s       aen_buf;
+	struct bfa_plog_s      plog_buf;
+	int             ref_count;
+	struct fc_host_statistics link_stats;
+
+	struct kobject *bfa_kobj;
+	struct kobject *ioc_kobj;
+	struct kobject *pport_kobj;
+	struct kobject *lport_kobj;
+};
+
+/*
+ * RPORT data structure
+ */
+struct bfad_rport_s {
+	struct bfa_fcs_rport_s fcs_rport;
+};
+
+struct bfad_buf_info {
+	void           *virt;
+	dma_addr_t      phys;
+	u32        size;
+};
+
+struct bfad_fcxp {
+	struct bfad_port_s    *port;
+	struct bfa_rport_s *bfa_rport;
+	bfa_status_t    req_status;
+	u16        tag;
+	u16        rsp_len;
+	u16        rsp_maxlen;
+	u8         use_ireqbuf;
+	u8         use_irspbuf;
+	u32        num_req_sgles;
+	u32        num_rsp_sgles;
+	fchs_t          fchs;
+	void           *reqbuf_info;
+	void           *rspbuf_info;
+	struct bfa_sge_s  *req_sge;
+	struct bfa_sge_s  *rsp_sge;
+	fcxp_send_cb_t  send_cbfn;
+	void           *send_cbarg;
+	void           *bfa_fcxp;
+	struct completion comp;
+};
+
+struct bfad_hal_comp {
+	bfa_status_t    status;
+	struct completion comp;
+};
+
+
+#define BFAD_WORK_HANDLER(name) void name(struct work_struct *work)
+#define BFAD_INIT_WORK(x, work, func) INIT_WORK(&(x)->work, func)
+
+#define list_remove_head(list, entry, type, member)       	\
+do {                                                    	\
+	entry = NULL;                                           \
+	if (!list_empty(list)) {                                \
+		entry = list_entry((list)->next, type, member);
\
+		list_del_init(&entry->member);
\
+	}
\
+} while (0)
+
+#define list_get_first(list, type, member)
\
+((list_empty(list)) ? NULL :
\
+	list_entry((list)->next, type, member))
+
+bfa_status_t    bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
+				  struct bfa_port_cfg_s *port_cfg);
+bfa_status_t    bfad_vf_create(struct bfad_s *bfad, u16 vf_id,
+			       struct bfa_port_cfg_s *port_cfg);
+bfa_status_t    bfad_cfg_pport(struct bfad_s *bfad, enum bfa_port_role
role);
+bfa_status_t    bfad_fc4_probe(struct bfad_s *bfad);
+bfa_status_t    bfad_drv_init(struct bfad_s *bfad);
+struct bfad_s         *bfad_find_bfad_by_inst_no(int inst_no);
+void            bfad_drv_start(struct bfad_s *bfad);
+void            bfad_uncfg_pport(struct bfad_s *bfad);
+void            bfad_drv_stop(struct bfad_s *bfad);
+void            bfad_remove_intr(struct bfad_s *bfad);
+void            bfad_fc4_probe_undo(struct bfad_s *bfad);
+void            bfad_hal_mem_release(struct bfad_s *bfad);
+void            bfad_hcb_comp(void *arg, bfa_status_t status);
+
+int             bfad_os_ioctl_init(void);
+int             bfad_os_ioctl_exit(void);
+int             bfad_setup_intr(struct bfad_s *bfad);
+void            bfad_remove_intr(struct bfad_s *bfad);
+int             bfad_os_pci_register_driver(struct pci_driver *drv);
+void            bfad_os_pci_unregister_driver(struct pci_driver *drv);
+void            bfad_os_device_sysfs_create(struct bfad_s *);
+void            bfad_os_device_sysfs_remove(struct bfad_s *);
+void            bfad_os_pci_set_mwi(struct pci_dev *pdev);
+void            bfad_os_idr_init(struct idr *idr);
+void            bfad_os_idr_destroy(struct idr *idr);
+void 		*bfad_os_dma_alloc(struct bfad_s *bfad, struct
bfa_mem_elem_s
+				*meminfo_elem, dma_addr_t *phys_addr);
+void 		bfad_os_dma_free(struct bfad_s *bfad, struct
bfa_mem_elem_s
+					*meminfo_elem);
+void 		bfad_os_idr_remove(struct idr *idp, int id);
+int 		bfad_os_idr_pre_get(struct idr *idp, gfp_t gfp_mask);
+
+void		bfad_update_hal_cfg(struct bfa_iocfc_cfg_s *bfa_cfg);
+bfa_status_t	bfad_hal_mem_alloc(struct bfad_s *bfad);
+void		bfad_bfa_tmo(unsigned long data);
+void		bfad_init_timer(struct bfad_s *bfad);
+int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s
*bfad);
+void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s
*bfad);
+void		bfad_fcs_port_cfg(struct bfad_s *bfad);
+void		bfad_drv_uninit(struct bfad_s *bfad);
+void		bfad_drv_log_level_set(struct bfad_s *bfad);
+bfa_status_t	bfad_fc4_module_init(void);
+void		bfad_fc4_module_exit(void);
+
+void bfad_pci_remove(struct pci_dev *pdev);
+int bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id
*pid);
+void bfad_os_rport_online_wait(struct bfad_s *bfad);
+u32 bfa_os_get_instance_id(struct bfad_s *bfad);
+
+
+extern struct idr bfad_im_port_index;
+extern struct pci_driver *bfad_pci_driver_p;
+
+extern struct pci_device_id bfad_id_table[];
+extern struct semaphore bfad_sem;
+extern struct list_head bfad_list;
+extern char	*os_name;
+extern char	*os_patch;
+extern char	*host_name;
+extern int	num_rports;
+extern int	num_ios;
+extern int	num_tms;
+extern int	num_fcxps;
+extern int	num_ufbufs;
+extern int	reqq_size;
+extern int	rspq_size;
+extern int	num_sgpgs;
+extern int      rport_del_timeout;
+extern int      msix_disable;
+extern int      bfa_ioc_queue_depth;
+extern int      bfa_lun_queue_depth;
+extern int      bfa_io_max_sge;
+extern int      log_level;
+extern int      ioc_auto_recover;
+
+extern int      supported_fc4s;
+
+#endif /* __BFAD_DRV_H__ */
diff -urpN orig/drivers/scsi/bfa/bfad_fwimg.c
patch/drivers/scsi/bfa/bfad_fwimg.c
--- orig/drivers/scsi/bfa/bfad_fwimg.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_fwimg.c	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad_fwimg.c Linux driver PCI interface module.
+ */
+#include <bfa_os_inc.h>
+#include <defs/bfa_defs_version.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <asm/fcntl.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <bfa_fwimg_priv.h>
+#include "bfad_im_compat.h"
+#include <bfa.h>
+
+#define FW_IMG_PATH "/lib/firmware/cbfw.bin"
+
+u32 *bfad_fwimg_buf;
+u32 bfi_image_size;
+u32 *bfi_image;
+
+
+#define	BFAD_FW_FILE	"cbfw.bin"
+
+u32 *
+bfad_read_firmware(struct pci_dev *pdev)
+{
+	const struct firmware *fw;
+	const char *fw_file_name = BFAD_FW_FILE;
+	int bfad_fw_buf_size = 0;
+
+	if (request_firmware(&fw, fw_file_name, &pdev->dev))
+		goto error;
+
+	bfad_fw_buf_size = fw->size;
+
+	bfad_fwimg_buf = kzalloc(bfad_fw_buf_size, GFP_KERNEL);
+	if (NULL == bfad_fwimg_buf)
+		goto error;
+
+	memcpy(bfad_fwimg_buf, fw->data, bfad_fw_buf_size);
+
+	bfi_image_size = bfad_fw_buf_size/sizeof(u32);
+
+	return(bfad_fwimg_buf);
+
+error:
+	if (NULL != bfad_fwimg_buf) {
+		kfree(bfad_fwimg_buf);
+		bfad_fwimg_buf = NULL;
+	}
+
+	return(NULL);
+}
+
+u32 *
+bfad_get_firmware_buf(struct pci_dev *pdev)
+{
+	if (bfi_image_size == 0)
+		return(bfad_read_firmware(pdev));
+	else
+		return(bfad_fwimg_buf);
+}
+
+char __bfa_ident[BFA_VERSION_LEN] =
+	  "@(#) BFA build version huangj_pvt_bld 09/24/2008 10.16.39";
+char bfa_version[BFA_VERSION_LEN] = "huangj_pvt_bld 09/24/2008
10.16.39";
diff -urpN orig/drivers/scsi/bfa/bfad_im.c
patch/drivers/scsi/bfa/bfad_im.c
--- orig/drivers/scsi/bfa/bfad_im.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_im.c	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,1244 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad_im.c Linux driver IM module.
+ */
+
+#include "bfad_drv.h"
+#include "bfad_im.h"
+#include "bfad_trcmod.h"
+#include "bfa_cb_ioim_macros.h"
+#include <fcb/bfa_fcb_fcpim.h>
+#include <linux/spinlock.h>
+
+BFA_TRC_FILE(LDRV, IM);
+
+DEFINE_IDR(bfad_im_port_index);
+struct scsi_transport_template *bfad_im_scsi_transport_template;
+BFAD_WORK_HANDLER(bfad_im_port_delete_handler);
+
+void
+bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
+			enum bfi_ioim_status io_status, u8 scsi_status,
+			int sns_len, u8 *sns_info, s32 residue)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct bfad_s         *bfad = drv;
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfad_itnim_s *itnim;
+	u8         host_status = DID_OK;
+
+	switch (io_status) {
+	case BFI_IOIM_STS_OK:
+		bfa_trc(bfad, scsi_status);
+		cmnd->result = ScsiResult(host_status, scsi_status);
+		scsi_set_resid(cmnd, 0);
+
+		if (sns_len > 0) {
+			bfa_trc(bfad, sns_len);
+			if (sns_len > SCSI_SENSE_BUFFERSIZE)
+				sns_len = SCSI_SENSE_BUFFERSIZE;
+			memcpy(cmnd->sense_buffer, sns_info, sns_len);
+		}
+		if (residue > 0)
+			scsi_set_resid(cmnd, residue);
+		break;
+
+	case BFI_IOIM_STS_ABORTED:
+	case BFI_IOIM_STS_TIMEDOUT:
+	default:
+		host_status = DID_ERROR;
+		cmnd->result = ScsiResult(host_status, 0);
+	}
+
+	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
+	if (cmnd->device->host != NULL)
+		bfad_os_im_dma_unmap(bfad, cmnd);
+
+	cmnd->host_scribble = NULL;
+	bfa_trc(bfad, cmnd->result);
+
+	itnim_data = cmnd->device->hostdata;
+	if (itnim_data) {
+		itnim = itnim_data->itnim;
+		if (!cmnd->result && itnim &&
+			 (bfa_lun_queue_depth >
cmnd->device->queue_depth)) {
+			/* Queue depth adjustment for good status
completion */
+			bfad_os_ramp_up_qdepth(itnim, cmnd->device);
+		} else if (cmnd->result == SAM_STAT_TASK_SET_FULL &&
itnim) {
+			/* qfull handling */
+			bfad_os_handle_qfull(itnim, cmnd->device);
+		}
+	}
+
+	cmnd->scsi_done(cmnd);
+}
+
+void
+bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfad_itnim_s *itnim;
+	struct bfad_s         *bfad = drv;
+	u8         host_status = DID_OK;
+
+	cmnd->result = ScsiResult(host_status, SCSI_STATUS_GOOD);
+
+	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
+	if (cmnd->device->host != NULL)
+		bfad_os_im_dma_unmap(bfad, cmnd);
+
+	cmnd->host_scribble = NULL;
+
+	bfa_trc_fp(bfad, cmnd->result);
+
+	/* Queue depth adjustment */
+	if (bfa_lun_queue_depth > cmnd->device->queue_depth) {
+		itnim_data = cmnd->device->hostdata;
+		if (itnim_data) {
+			itnim = itnim_data->itnim;
+			if (itnim)
+				bfad_os_ramp_up_qdepth(itnim,
cmnd->device);
+		}
+	}
+
+	cmnd->scsi_done(cmnd);
+}
+
+void
+bfa_cb_ioim_abort(void *drv, struct bfad_ioim_s *dio)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
+	struct bfad_s         *bfad = drv;
+
+	cmnd->result = ScsiResult(DID_ERROR, 0);
+
+	/* Unmap DMA, if host is NULL, it means a scsi passthru cmd */
+	if (cmnd->device->host != NULL)
+		bfad_os_im_dma_unmap(bfad, cmnd);
+
+	bfa_trc(bfad, cmnd->result);
+	cmnd->host_scribble = NULL;
+}
+
+void
+bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
+		   enum bfi_tskim_status tsk_status)
+{
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
+	wait_queue_head_t *wq;
+
+	cmnd->SCp.Status |= tsk_status << 1;
+	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
+	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
+	cmnd->SCp.ptr = NULL;
+
+	if (wq)
+		wake_up(wq);
+}
+
+/**
+ * @dg Scsi_Host_template SCSI host template
+ * @{
+ */
+/**
+ * @brief
+ * Scsi_Host template entry, returns BFAD PCI info.
+ */
+const char *
+bfad_im_info(struct Scsi_Host *shost)
+{
+	static char     bfa_buf[256];
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfa_ioc_attr_s  ioc_attr;
+	struct bfad_s         *bfad = im_port->bfad;
+
+	memset(&ioc_attr, 0, sizeof(ioc_attr));
+	bfa_get_attr(&bfad->bfa, &ioc_attr);
+
+	memset(bfa_buf, 0, sizeof(bfa_buf));
+	snprintf(bfa_buf, sizeof(bfa_buf),
+		 "Brocade FC Adapter, " "model: %s hwpath: %s driver:
%s",
+		 ioc_attr.adapter_attr.model, bfad->pci_name,
+		 BFAD_DRIVER_VERSION);
+	return bfa_buf;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry, aborts the specified SCSI command.
+ *
+ * Returns: SUCCESS or FAILED.
+ */
+int
+bfad_im_abort_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_ioim_s *hal_io;
+	unsigned long   flags;
+	u32        timeout;
+	int             rc = FAILED;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	hal_io = (struct bfa_ioim_s *) cmnd->host_scribble;
+	if (!hal_io) {
+		/* IO has been completed, retrun success */
+		rc = SUCCESS;
+		goto out;
+	}
+	if (hal_io->dio != (struct bfad_ioim_s *) cmnd) {
+		rc = FAILED;
+		goto out;
+	}
+
+	bfa_trc(bfad, hal_io->iotag);
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_ABORT,
+		im_port->shost->host_no, cmnd, hal_io->iotag);
+	bfa_ioim_abort(hal_io);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	/* Need to wait until the command get aborted */
+	timeout = 10;
+	while ((struct bfa_ioim_s *) cmnd->host_scribble == hal_io) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(timeout);
+		if (timeout < 4 * HZ)
+			timeout *= 2;
+	}
+
+	cmnd->scsi_done(cmnd);
+	bfa_trc(bfad, hal_io->iotag);
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_ABORT_COMP,
+		im_port->shost->host_no, cmnd, hal_io->iotag);
+	return SUCCESS;
+out:
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	return rc;
+}
+
+static bfa_status_t
+bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
+		     struct bfad_itnim_s *itnim)
+{
+	struct bfa_tskim_s *tskim;
+	struct bfa_itnim_s *bfa_itnim;
+	bfa_status_t    rc = BFA_STATUS_OK;
+
+	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
+	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *)
cmnd);
+	if (!tskim) {
+		BFA_DEV_PRINTF(bfad, BFA_ERR,
+			       "target reset, fail to allocate
tskim\n");
+		rc = BFA_STATUS_FAILED;
+		goto out;
+	}
+
+	/*
+	 * Set host_scribble to NULL to avoid aborting a task command if
+	 * happens.
+	 */
+	cmnd->host_scribble = NULL;
+	cmnd->SCp.Status = 0;
+	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
+	bfa_tskim_start(tskim, bfa_itnim, (lun_t)0,
+			    FCP_TM_TARGET_RESET, BFAD_TARGET_RESET_TMO);
+out:
+	return rc;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry, resets a LUN and abort its all commands.
+ *
+ * Returns: SUCCESS or FAILED.
+ *
+ */
+int
+bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *) shost->hostdata[0];
+	struct bfad_itnim_data_s *itnim_data = cmnd->device->hostdata;
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfa_tskim_s *tskim;
+	struct bfad_itnim_s   *itnim;
+	struct bfa_itnim_s *bfa_itnim;
+	DECLARE_WAIT_QUEUE_HEAD(wq);
+	int             rc = SUCCESS;
+	unsigned long   flags;
+	enum bfi_tskim_status task_status;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	itnim = itnim_data->itnim;
+	if (!itnim) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		rc = FAILED;
+		goto out;
+	}
+
+	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *)
cmnd);
+	if (!tskim) {
+		BFA_DEV_PRINTF(bfad, BFA_ERR,
+				"LUN reset, fail to allocate tskim");
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		rc = FAILED;
+		goto out;
+	}
+
+	/**
+	 * Set host_scribble to NULL to avoid aborting a task command
+	 * if happens.
+	 */
+	cmnd->host_scribble = NULL;
+	cmnd->SCp.ptr = (char *)&wq;
+	cmnd->SCp.Status = 0;
+	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
+	bfa_tskim_start(tskim, bfa_itnim,
+			    bfad_int_to_lun(cmnd->device->lun),
+			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	wait_event(wq, test_bit(IO_DONE_BIT,
+			(unsigned long *)&cmnd->SCp.Status));
+
+	task_status = cmnd->SCp.Status >> 1;
+	if (task_status != BFI_TSKIM_STS_OK) {
+		BFA_DEV_PRINTF(bfad, BFA_ERR, "LUN reset failure,
status: %d\n",
+			       task_status);
+		rc = FAILED;
+	}
+
+out:
+	return rc;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry, resets the bus and abort all commands.
+ */
+int
+bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct bfad_im_port_s *im_port =
+				(struct bfad_im_port_s *)
shost->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_itnim_s   *itnim;
+	unsigned long   flags;
+	u32        i, rc, err_cnt = 0;
+	DECLARE_WAIT_QUEUE_HEAD(wq);
+	enum bfi_tskim_status task_status;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	for (i = 0; i < MAX_FCP_TARGET; i++) {
+		itnim = bfad_os_get_itnim(im_port, i);
+		if (itnim) {
+			cmnd->SCp.ptr = (char *)&wq;
+			rc = bfad_im_target_reset_send(bfad, cmnd,
itnim);
+			if (rc != BFA_STATUS_OK) {
+				err_cnt++;
+				continue;
+			}
+
+			/* wait target reset to complete */
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			wait_event(wq, test_bit(IO_DONE_BIT,
+					(unsigned long
*)&cmnd->SCp.Status));
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+			task_status = cmnd->SCp.Status >> 1;
+			if (task_status != BFI_TSKIM_STS_OK) {
+				BFA_DEV_PRINTF(bfad, BFA_ERR,
+					"target reset failure,"
+					" status: %d\n", task_status);
+				err_cnt++;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (err_cnt)
+		return FAILED;
+
+	return SUCCESS;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry slave_destroy.
+ */
+void
+bfad_im_slave_destroy(struct scsi_device *sdev)
+{
+	sdev->hostdata = NULL;
+	return;
+}
+
+/**
+ * @dg BFA FCS itnim callbacks
+ * @{
+ */
+
+/**
+ * @brief
+ * BFA FCS itnim alloc callback, after successful PRLI
+ * Context: Interrupt
+ */
+void
+bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s
**itnim,
+		    struct bfad_itnim_s **itnim_drv)
+{
+	*itnim_drv = kzalloc(sizeof(struct bfad_itnim_s), GFP_ATOMIC);
+	if (*itnim_drv == NULL)
+		return;
+
+	(*itnim_drv)->im = bfad->im;
+	*itnim = &(*itnim_drv)->fcs_itnim;
+	(*itnim_drv)->state = ITNIM_STATE_NONE;
+
+	/*
+	 * Initiaze the itnim_work
+	 */
+	bfad_os_itnim_alloc(*itnim_drv);
+	bfad_flags_set(bfad, BFAD_RPORT_ONLINE);
+}
+
+void
+bfad_wwn_to_str(wwn_t wwn, char *str)
+{
+	sprintf(str, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+		*((u8 *)&wwn),
+		*(((u8 *)&wwn) + 1),
+		*(((u8 *)&wwn) + 2),
+		*(((u8 *)&wwn) + 3),
+		*(((u8 *)&wwn) + 4),
+		*(((u8 *)&wwn) + 5),
+		*(((u8 *)&wwn) + 6),
+		*(((u8 *)&wwn) + 7));
+}
+
+void
+bfad_fcid_to_str(u32 fcid, char *str)
+{
+	sprintf(str, "%02x%02x%02x",
+		*((u8 *)&fcid),
+		*(((u8 *)&fcid) + 1),
+		*(((u8 *)&fcid) + 2));
+}
+
+/**
+ * @brief
+ * BFA FCS itnim free callback.
+ * Context: Interrupt. bfad_lock is held
+ */
+void
+bfa_fcb_itnim_free(struct bfad_s *bfad, struct bfad_itnim_s *itnim_drv)
+{
+	struct bfad_port_s    *port;
+	wwn_t wwpn;
+	u32 fcid;
+	char wwpn_str[32], fcid_str[16];
+
+	/* online to free state transtion should not happen */
+	bfa_assert(itnim_drv->state != ITNIM_STATE_ONLINE);
+
+	itnim_drv->queue_work = 1;
+	/* offline request is not yet done, use the same request to free
*/
+	if (itnim_drv->state == ITNIM_STATE_OFFLINE_PENDING)
+		itnim_drv->queue_work = 0;
+
+	itnim_drv->state = ITNIM_STATE_FREE;
+	port = bfa_fcs_itnim_get_drvport(&itnim_drv->fcs_itnim);
+	itnim_drv->im_port = port->im_port;
+	wwpn = bfa_fcs_itnim_get_pwwn(&itnim_drv->fcs_itnim);
+	fcid = bfa_fcs_itnim_get_fcid(&itnim_drv->fcs_itnim);
+	bfad_wwn_to_str(wwpn, wwpn_str);
+	bfad_fcid_to_str(fcid, fcid_str);
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_ITNIM_FREE,
+		port->im_port->shost->host_no,
+		fcid_str, wwpn_str);
+	bfad_os_itnim_process(itnim_drv);
+}
+
+/**
+ * @brief
+ * BFA FCS itnim online callback.
+ * Context: Interrupt. bfad_lock is held
+ */
+void
+bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv)
+{
+	struct bfad_port_s    *port;
+
+	itnim_drv->bfa_itnim =
bfa_fcs_itnim_get_halitn(&itnim_drv->fcs_itnim);
+	port = bfa_fcs_itnim_get_drvport(&itnim_drv->fcs_itnim);
+	itnim_drv->state = ITNIM_STATE_ONLINE;
+	itnim_drv->queue_work = 1;
+	itnim_drv->im_port = port->im_port;
+	bfad_os_itnim_process(itnim_drv);
+}
+
+/**
+ * @brief
+ * BFA FCS itnim offline callback.
+ * Context: Interrupt. bfad_lock is held
+*/
+void
+bfa_fcb_itnim_offline(struct bfad_itnim_s *itnim_drv)
+{
+	struct bfad_port_s    *port;
+	struct bfad_s *bfad;
+
+	port = bfa_fcs_itnim_get_drvport(&itnim_drv->fcs_itnim);
+	bfad = port->bfad;
+	if ((bfad->pport.flags & BFAD_PORT_DELETE) ||
+		 (port->flags & BFAD_PORT_DELETE)) {
+		itnim_drv->state = ITNIM_STATE_OFFLINE;
+		return;
+	}
+	itnim_drv->im_port = port->im_port;
+	itnim_drv->state = ITNIM_STATE_OFFLINE_PENDING;
+	itnim_drv->queue_work = 1;
+	bfad_os_itnim_process(itnim_drv);
+}
+
+/**
+ * @}
+ */
+
+/**
+ * @brief
+ * Allocate a Scsi_Host for a port.
+ */
+int
+bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s
*im_port)
+{
+	int             error = 1;
+
+	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
+		printk(KERN_WARNING "idr_pre_get failure\n");
+		goto out;
+	}
+
+	error = idr_get_new(&bfad_im_port_index, im_port,
+					 &im_port->idr_id);
+	if (error) {
+		printk(KERN_WARNING "idr_get_new failure\n");
+		goto out;
+	}
+
+	im_port->shost =
+		bfad_os_scsi_host_alloc(&bfad_im_scsi_host_template,
im_port,
+					bfad);
+	if (!im_port->shost) {
+		error = 1;
+		goto out_free_idr;
+	}
+
+	im_port->shost->hostdata[0] = (unsigned long)im_port;
+	im_port->shost->unique_id = im_port->idr_id;
+	im_port->shost->this_id = -1;
+	im_port->shost->max_id = MAX_FCP_TARGET;
+	im_port->shost->max_lun = MAX_FCP_LUN;
+	im_port->shost->max_cmd_len = 16;
+	im_port->shost->can_queue = bfad->cfg_data.ioc_queue_depth;
+	bfad_os_transp_templ(im_port->shost,
bfad_im_scsi_transport_template);
+
+	error = scsi_add_host(im_port->shost,
+				(struct device *)&bfad->pcidev->dev);
+	if (error) {
+		printk(KERN_WARNING "scsi_add_host failure\n");
+		goto out_fc_rel;
+	}
+
+	/* setup host fixed attribute if the lk supports */
+	bfad_os_fc_host_init(im_port);
+
+	return 0;
+
+out_fc_rel:
+	scsi_host_put(im_port->shost);
+
+out_free_idr:
+	idr_remove(&bfad_im_port_index, im_port->idr_id);
+out:
+	return error;
+}
+
+void
+bfad_im_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s
*im_port)
+{
+	unsigned long flags;
+
+	bfa_trc(bfad, bfad->inst_no);
+	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_HOST_FREE,
+			im_port->shost->host_no);
+
+	fc_remove_host(im_port->shost);
+
+	scsi_remove_host(im_port->shost);
+	scsi_host_put(im_port->shost);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	idr_remove(&bfad_im_port_index, im_port->idr_id);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+bfa_status_t
+bfad_im_port_new(struct bfad_s *bfad, struct bfad_port_s *port)
+{
+	int             rc = BFA_STATUS_OK;
+	struct bfad_im_port_s *im_port;
+
+	im_port = kzalloc(sizeof(struct bfad_im_port_s), GFP_ATOMIC);
+	if (im_port == NULL) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+	port->im_port = im_port;
+	im_port->port = port;
+	im_port->bfad = bfad;
+
+	bfad_os_init_work(im_port);
+	INIT_LIST_HEAD(&im_port->itnim_mapped_list);
+	INIT_LIST_HEAD(&im_port->binding_list);
+
+ext:
+	return rc;
+}
+
+void
+bfad_im_port_delete(struct bfad_s *bfad, struct bfad_port_s *port)
+{
+	struct bfad_im_port_s *im_port = port->im_port;
+
+	queue_work(bfad->im->drv_workq,
+				&im_port->port_delete_work);
+}
+
+BFAD_WORK_HANDLER(bfad_im_port_delete_handler)
+{	/* work struct is the function arg */
+	struct bfad_im_port_s *im_port =
+		container_of(work, struct bfad_im_port_s,
port_delete_work);
+
+	bfad_im_scsi_host_free(im_port->bfad, im_port);
+	bfad_im_port_clean(im_port);
+	kfree(im_port);
+}
+
+void
+bfad_im_port_clean(struct bfad_im_port_s *im_port)
+{
+	struct bfad_fcp_binding *bp, *bp_new;
+	unsigned long flags;
+	struct bfad_s *bfad =  im_port->bfad;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	list_for_each_entry_safe(bp, bp_new, &im_port->binding_list,
+					list_entry) {
+		list_del(&bp->list_entry);
+		kfree(bp);
+	}
+
+	/* the itnim_mapped_list must be empty at this time */
+	bfa_assert(list_empty(&im_port->itnim_mapped_list));
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+void
+bfad_im_port_online(struct bfad_s *bfad, struct bfad_port_s *port)
+{
+}
+
+void
+bfad_im_port_offline(struct bfad_s *bfad, struct bfad_port_s *port)
+{
+}
+
+bfa_status_t
+bfad_im_probe(struct bfad_s *bfad)
+{
+	struct bfad_im_s      *im;
+	bfa_status_t    rc = BFA_STATUS_OK;
+
+	im = kzalloc(sizeof(struct bfad_im_s), GFP_KERNEL);
+	if (im == NULL) {
+		rc = BFA_STATUS_ENOMEM;
+		goto ext;
+	}
+
+	bfad->im = im;
+	im->bfad = bfad;
+
+	if (bfad_os_thread_workq(bfad) != BFA_STATUS_OK) {
+		kfree(im);
+		rc = BFA_STATUS_FAILED;
+	}
+
+ext:
+	return rc;
+}
+
+void
+bfad_im_probe_undo(struct bfad_s *bfad)
+{
+	if (bfad->im) {
+		bfad_os_destroy_workq(bfad->im);
+		kfree(bfad->im);
+		bfad->im = NULL;
+	}
+}
+
+
+
+
+BFAD_WORK_HANDLER(bfad_im_itnim_work_handler);
+
+struct Scsi_Host *
+bfad_os_scsi_host_alloc(struct scsi_host_template *sht,
+			struct bfad_im_port_s *im_port, struct bfad_s
*bfad)
+{
+	sht->sg_tablesize = bfad->cfg_data.io_max_sge;
+	return scsi_host_alloc(sht, sizeof(unsigned long));
+}
+
+void
+bfad_os_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s
*im_port)
+{
+	flush_workqueue(bfad->im->drv_workq);
+	bfad_im_scsi_host_free(im_port->bfad, im_port);
+	bfad_im_port_clean(im_port);
+	kfree(im_port);
+}
+
+void
+bfad_os_destroy_workq(struct bfad_im_s *im)
+{
+	if (im && im->drv_workq) {
+		destroy_workqueue(im->drv_workq);
+		im->drv_workq = NULL;
+	}
+}
+
+bfa_status_t
+bfad_os_thread_workq(struct bfad_s *bfad)
+{
+	struct bfad_im_s      *im = bfad->im;
+
+	bfa_trc(bfad, 0);
+	snprintf(im->drv_workq_name, KOBJ_NAME_LEN, "bfad_wq_%d",
+		 bfad->inst_no);
+	im->drv_workq =
create_singlethread_workqueue(im->drv_workq_name);
+	if (!im->drv_workq)
+		return BFA_STATUS_FAILED;
+
+	return BFA_STATUS_OK;
+}
+
+struct bfad_itnim_data_s *
+bfad_os_itnim_data(struct bfad_im_port_s *im_port, struct scsi_cmnd
*cmnd)
+{
+	if (!cmnd || !cmnd->device)
+		return NULL;
+	return cmnd->device->hostdata;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry.
+ *
+ * Description:
+ * OS entry point to adjust the queue_depths on a per-device basis.
+ * Called once per device during the bus scan.
+ * Return non-zero if fails.
+ */
+static int
+bfad_im_slave_configure(struct scsi_device *sdev)
+{
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, bfa_lun_queue_depth);
+	else
+		scsi_deactivate_tcq(sdev, bfa_lun_queue_depth);
+
+	bfad_os_set_dev_loss_tmo(sdev);
+
+	return 0;
+}
+
+struct scsi_host_template bfad_im_scsi_host_template = {
+	.module = THIS_MODULE,
+	.name = BFAD_DRIVER_NAME,
+	.info = bfad_im_info,
+	.queuecommand = bfad_im_queuecommand,
+	.eh_abort_handler = bfad_im_abort_handler,
+	.eh_device_reset_handler = bfad_im_reset_lun_handler,
+	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+
+	.slave_alloc = bfad_im_slave_alloc,
+	.slave_configure = bfad_im_slave_configure,
+	.slave_destroy = bfad_im_slave_destroy,
+
+	.this_id = -1,
+	.sg_tablesize = BFAD_IO_MAX_SGE,
+	.cmd_per_lun = 3,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = bfad_im_host_attrs,
+	.max_sectors = 0xFFFF,
+};
+
+void
+bfad_im_probe_post(struct bfad_im_s *im)
+{
+	flush_workqueue(im->drv_workq);
+}
+
+bfa_status_t
+bfad_im_module_init(void)
+{
+	bfad_im_scsi_transport_template =
+		fc_attach_transport(&bfad_im_fc_function_template);
+	if (!bfad_im_scsi_transport_template)
+		return BFA_STATUS_ENOMEM;
+
+	return BFA_STATUS_OK;
+}
+
+void
+bfad_im_module_exit(void)
+{
+	if (bfad_im_scsi_transport_template)
+		fc_release_transport(bfad_im_scsi_transport_template);
+}
+
+void
+bfad_os_transp_templ(struct Scsi_Host *sh, struct
scsi_transport_template *stt)
+{
+	sh->transportt = stt;
+}
+
+int
+bfad_os_im_dma_map(struct bfad_s *bfad, struct scsi_cmnd *cmnd)
+{
+	int             sg_cnt, rc = 0;
+
+	if (scsi_sg_count(cmnd)) {
+		sg_cnt = dma_map_sg((struct device *)&bfad->pcidev->dev,
+					(struct scatterlist
*)scsi_sglist(cmnd),
+					scsi_sg_count(cmnd),
+					cmnd->sc_data_direction);
+		if (sg_cnt == 0 || sg_cnt > bfad->cfg_data.io_max_sge) {
+			printk(KERN_WARNING "dma_map_sg failure\n");
+			rc = 1;
+		}
+
+	} else if (scsi_bufflen(cmnd)) {
+		cmnd->SCp.dma_handle =
+			dma_map_single((struct device *)&bfad->pcidev->
+					       dev, scsi_sglist(cmnd),
+					       scsi_bufflen(cmnd),
+					       cmnd->sc_data_direction);
+	}
+
+	return rc;
+}
+
+void
+bfad_os_im_dma_unmap(struct bfad_s *bfad, struct scsi_cmnd *cmnd)
+{
+	if (scsi_sg_count(cmnd))
+		dma_unmap_sg((struct device *)&bfad->pcidev->dev,
+				     scsi_sglist(cmnd),
scsi_sg_count(cmnd),
+				     cmnd->sc_data_direction);
+	else if (scsi_bufflen(cmnd))
+		dma_unmap_single((struct device *)&bfad->pcidev->dev,
+					 cmnd->SCp.dma_handle,
+					 scsi_bufflen(cmnd),
+					 cmnd->sc_data_direction);
+}
+
+void
+bfad_os_itnim_alloc(struct bfad_itnim_s *itnim_drv)
+{
+	BFAD_INIT_WORK(itnim_drv, itnim_work,
bfad_im_itnim_work_handler);
+}
+
+void
+bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv)
+{
+	struct bfad_im_s      *im = itnim_drv->im;
+
+	if (itnim_drv->queue_work)
+		queue_work(im->drv_workq, &itnim_drv->itnim_work);
+}
+
+void
+bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device
*sdev)
+{
+	struct scsi_device *tmp_sdev;
+
+	if (((jiffies - itnim->last_ramp_up_time) >
+		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ) &&
+		((jiffies - itnim->last_queue_full_time) >
+		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ)) {
+		shost_for_each_device(tmp_sdev, sdev->host) {
+			if (bfa_lun_queue_depth > tmp_sdev->queue_depth)
{
+				if (tmp_sdev->id != sdev->id)
+					continue;
+				if (tmp_sdev->ordered_tags)
+
scsi_adjust_queue_depth(tmp_sdev,
+						MSG_ORDERED_TAG,
+						tmp_sdev->queue_depth +
1);
+				else
+
scsi_adjust_queue_depth(tmp_sdev,
+						MSG_SIMPLE_TAG,
+						tmp_sdev->queue_depth +
1);
+
+				itnim->last_ramp_up_time = jiffies;
+			}
+		}
+	}
+}
+
+void
+bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device
*sdev)
+{
+	struct scsi_device *tmp_sdev;
+
+	itnim->last_queue_full_time = jiffies;
+
+	shost_for_each_device(tmp_sdev, sdev->host) {
+		if (tmp_sdev->id != sdev->id)
+			continue;
+		scsi_track_queue_full(tmp_sdev, tmp_sdev->queue_depth -
1);
+	}
+}
+
+
+
+
+BFAD_WORK_HANDLER(bfad_im_port_delete_handler);
+BFAD_WORK_HANDLER(bfad_im_itnim_work_handler);
+static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
+					struct bfad_itnim_s *itnim);
+
+struct bfad_itnim_s *
+bfad_os_get_itnim(struct bfad_im_port_s *im_port, int id)
+{
+	struct bfad_itnim_s   *itnim = NULL;
+
+	/* Search the mapped list for this target ID */
+	list_for_each_entry(itnim, &im_port->itnim_mapped_list,
list_entry) {
+		if (id == itnim->scsi_tgt_id)
+			return itnim;
+	}
+
+	return NULL;
+}
+
+void
+bfad_os_init_work(struct bfad_im_port_s *im_port)
+{
+	BFAD_INIT_WORK(im_port, port_delete_work,
bfad_im_port_delete_handler);
+
+	return;
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry slave_alloc
+ */
+int
+bfad_im_slave_alloc(struct scsi_device *sdev)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+
+	if (!rport || fc_remote_port_chkready(rport))
+		return -ENXIO;
+
+	sdev->hostdata = rport->dd_data;
+
+	return 0;
+}
+
+void
+bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
+{
+	struct Scsi_Host *host = im_port->shost;
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_port_s    *port = im_port->port;
+	union attr {
+		struct bfa_pport_attr_s pattr;
+		struct bfa_ioc_attr_s  ioc_attr;
+	} attr;
+
+	fc_host_node_name(host) =
+		bfa_os_htonll((bfa_fcs_port_get_nwwn(port->fcs_port)));
+	fc_host_port_name(host) =
+		bfa_os_htonll((bfa_fcs_port_get_pwwn(port->fcs_port)));
+
+	fc_host_supported_classes(host) = FC_COS_CLASS3;
+
+	memset(fc_host_supported_fc4s(host), 0,
+	       sizeof(fc_host_supported_fc4s(host)));
+	if (supported_fc4s & (BFA_PORT_ROLE_FCP_IM |
BFA_PORT_ROLE_FCP_TM))
+		/* For FCP type 0x08 */
+		fc_host_supported_fc4s(host)[2] = 1;
+	if (supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
+		/* For LLC/SNAP type 0x05 */
+		fc_host_supported_fc4s(host)[3] = 0x20;
+	/* For fibre channel services type 0x20 */
+	fc_host_supported_fc4s(host)[7] = 1;
+
+	memset(&attr.ioc_attr, 0, sizeof(attr.ioc_attr));
+	bfa_get_attr(&bfad->bfa, &attr.ioc_attr);
+	sprintf(fc_host_symbolic_name(host), "Brocade %s FV%s DV%s",
+		attr.ioc_attr.adapter_attr.model,
+		attr.ioc_attr.adapter_attr.fw_ver, BFAD_DRIVER_VERSION);
+
+	fc_host_supported_speeds(host) = 0;
+	fc_host_supported_speeds(host) |=
+		FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
FC_PORTSPEED_2GBIT |
+		FC_PORTSPEED_1GBIT;
+
+	memset(&attr.pattr, 0, sizeof(attr.pattr));
+	bfa_pport_get_attr(&bfad->bfa, &attr.pattr);
+	fc_host_maxframe_size(host) = attr.pattr.pport_cfg.maxfrsize;
+}
+
+void
+bfad_os_set_dev_loss_tmo(struct scsi_device *sdev)
+{
+	struct fc_rport   *rport = starget_to_rport(sdev->sdev_target);
+
+	rport->dev_loss_tmo = rport_del_timeout + 5;
+}
+
+static void
+bfad_im_fc_rport_add(struct bfad_im_port_s *im_port, struct
bfad_itnim_s *itnim)
+{
+	struct fc_rport_identifiers rport_ids;
+	struct fc_rport *fc_rport;
+	struct bfad_itnim_data_s *itnim_data;
+
+	rport_ids.node_name =
+
bfa_os_htonll(bfa_fcs_itnim_get_nwwn(&itnim->fcs_itnim));
+	rport_ids.port_name =
+
bfa_os_htonll(bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
+	rport_ids.port_id =
+
bfa_os_hton3b(bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim));
+	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
+
+	itnim->fc_rport = fc_rport =
+		fc_remote_port_add(im_port->shost, 0, &rport_ids);
+
+	if (!fc_rport)
+		return;
+
+	fc_rport->maxframe_size =
+		bfa_fcs_itnim_get_maxfrsize(&itnim->fcs_itnim);
+	fc_rport->supported_classes =
bfa_fcs_itnim_get_cos(&itnim->fcs_itnim);
+
+	itnim_data = fc_rport->dd_data;
+	itnim_data->itnim = itnim;
+
+	rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
+
+	if (rport_ids.roles != FC_RPORT_ROLE_UNKNOWN)
+		fc_remote_port_rolechg(fc_rport, rport_ids.roles);
+
+	if ((fc_rport->scsi_target_id != -1)
+	    && (fc_rport->scsi_target_id < MAX_FCP_TARGET))
+		itnim->scsi_tgt_id = fc_rport->scsi_target_id;
+
+	return;
+}
+
+/**
+ * @brief
+ * Work queue handler using FC transport service
+* Context: kernel
+ */
+BFAD_WORK_HANDLER(bfad_im_itnim_work_handler)
+{	/* work struct is the function arg */
+	struct bfad_itnim_s   *itnim = container_of(work, struct
bfad_itnim_s,
+							itnim_work);
+	struct bfad_im_s      *im = itnim->im;
+	struct bfad_s         *bfad = im->bfad;
+	struct bfad_im_port_s *im_port;
+	unsigned long   flags;
+	struct fc_rport *fc_rport;
+	wwn_t wwpn;
+	u32 fcid;
+	char wwpn_str[32], fcid_str[16];
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	im_port = itnim->im_port;
+	bfa_trc(bfad, itnim->state);
+	switch (itnim->state) {
+	case ITNIM_STATE_ONLINE:
+		if (!itnim->fc_rport) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			bfad_im_fc_rport_add(im_port, itnim);
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
+			wwpn =
bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim);
+			fcid =
bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim);
+			bfad_wwn_to_str(wwpn, wwpn_str);
+			bfad_fcid_to_str(fcid, fcid_str);
+			list_add_tail(&itnim->list_entry,
+				&im_port->itnim_mapped_list);
+			bfa_log(bfad->logmod,
BFA_LOG_LINUX_ITNIM_ONLINE,
+				im_port->shost->host_no,
+				itnim->scsi_tgt_id,
+				fcid_str, wwpn_str);
+		} else {
+			printk(KERN_WARNING
+				"%s: itnim %llx is already in online
state\n",
+				__FUNCTION__,
+
bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
+		}
+
+		break;
+	case ITNIM_STATE_OFFLINE_PENDING:
+		itnim->state = ITNIM_STATE_OFFLINE;
+		if (itnim->fc_rport) {
+			fc_rport = itnim->fc_rport;
+			((struct bfad_itnim_data_s *)
+				fc_rport->dd_data)->itnim = NULL;
+			itnim->fc_rport = NULL;
+			if (!(im_port->port->flags & BFAD_PORT_DELETE))
{
+				spin_unlock_irqrestore(&bfad->bfad_lock,
flags);
+				fc_remote_port_delete(fc_rport);
+				spin_lock_irqsave(&bfad->bfad_lock,
flags);
+			}
+			wwpn =
bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim);
+			fcid =
bfa_fcs_itnim_get_fcid(&itnim->fcs_itnim);
+			bfad_wwn_to_str(wwpn, wwpn_str);
+			bfad_fcid_to_str(fcid, fcid_str);
+			list_del(&itnim->list_entry);
+			bfa_log(bfad->logmod,
BFA_LOG_LINUX_ITNIM_OFFLINE,
+				im_port->shost->host_no,
+				itnim->scsi_tgt_id,
+				fcid_str, wwpn_str);
+		}
+		break;
+	case ITNIM_STATE_FREE:
+		if (itnim->fc_rport) {
+			fc_rport = itnim->fc_rport;
+			((struct bfad_itnim_data_s *)
+				fc_rport->dd_data)->itnim = NULL;
+			itnim->fc_rport = NULL;
+			if (!(im_port->port->flags & BFAD_PORT_DELETE))
{
+				spin_unlock_irqrestore(&bfad->bfad_lock,
flags);
+				fc_remote_port_delete(fc_rport);
+				spin_lock_irqsave(&bfad->bfad_lock,
flags);
+			}
+			list_del(&itnim->list_entry);
+		}
+
+		kfree(itnim);
+		break;
+	default:
+		bfa_assert(0);
+		break;
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
+/**
+ * @brief
+ * Scsi_Host template entry, queue a SCSI command to the BFAD.
+ */
+int
+bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct
scsi_cmnd *))
+{
+	struct bfad_im_port_s *im_port =
+		(struct bfad_im_port_s *)
cmnd->device->host->hostdata[0];
+	struct bfad_s         *bfad = im_port->bfad;
+	struct bfad_itnim_data_s *itnim_data = cmnd->device->hostdata;
+	struct bfad_itnim_s   *itnim;
+	struct bfa_ioim_s *hal_io;
+	unsigned long   flags;
+	int             rc;
+	u16        sg_cnt = 0;
+	struct fc_rport *rport =
starget_to_rport(scsi_target(cmnd->device));
+
+	rc = fc_remote_port_chkready(rport);
+	if (rc) {
+		cmnd->result = rc;
+		done(cmnd);
+		return 0;
+	}
+
+	rc = bfad_os_im_dma_map(bfad, cmnd);
+	if (rc)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	cmnd->scsi_done = done;
+	if (scsi_sg_count(cmnd))
+		sg_cnt = scsi_sg_count(cmnd);
+	else if (scsi_bufflen(cmnd))
+		sg_cnt = 1;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (!(bfad->bfad_flags & BFAD_HAL_START_DONE)) {
+		printk(KERN_WARNING
+			"bfad%d, queuecommand %p %x failed, HAL
stopped\n",
+		       bfad->inst_no, cmnd, cmnd->cmnd[0]);
+		cmnd->result = ScsiResult(DID_NO_CONNECT, 0);
+		goto out_fail_cmd;
+	}
+
+
+	itnim = itnim_data->itnim;
+	if (!itnim) {
+		cmnd->result = ScsiResult(DID_IMM_RETRY, 0);
+		goto out_fail_cmd;
+	}
+
+	hal_io = bfa_ioim_alloc(&bfad->bfa, (struct bfad_ioim_s *) cmnd,
+				    itnim->bfa_itnim, sg_cnt);
+	if (!hal_io) {
+		printk(KERN_WARNING "hal_io failure\n");
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		bfad_os_im_dma_unmap(bfad, cmnd);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	cmnd->host_scribble = (char *)hal_io;
+	bfa_trc_fp(bfad, hal_io->iotag);
+	bfa_ioim_start(hal_io);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return 0;
+
+out_fail_cmd:
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	bfad_os_im_dma_unmap(bfad, cmnd);
+	if (done)
+		done(cmnd);
+
+	return 0;
+}
diff -urpN orig/drivers/scsi/bfa/bfad_im_compat.h
patch/drivers/scsi/bfa/bfad_im_compat.h
--- orig/drivers/scsi/bfa/bfad_im_compat.h	1969-12-31
16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/bfad_im_compat.h	2008-09-24
12:08:23.000000000 -0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFAD_IM_COMPAT_H__
+#define __BFAD_IM_COMPAT_H__
+
+extern u32 *bfi_image_buf;
+extern u32 bfi_image_size;
+
+extern struct device_attribute *bfad_im_host_attrs[];
+
+u32 *bfad_get_firmware_buf(struct pci_dev *pdev);
+u32 *bfad_read_firmware(struct pci_dev *pdev);
+
+static inline void
+bfad_load_fwimg(struct pci_dev *pdev)
+{
+	bfi_image = bfad_get_firmware_buf(pdev);
+	return;
+}
+
+#endif
diff -urpN orig/drivers/scsi/bfa/bfad_im.h
patch/drivers/scsi/bfa/bfad_im.h
--- orig/drivers/scsi/bfa/bfad_im.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_im.h	2008-09-24 12:08:23.000000000
-0700
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFAD_IM_H__
+#define __BFAD_IM_H__
+
+#include "fcs/bfa_fcs_fcpim.h"
+#include "bfad_im_compat.h"
+
+#define FCPI_NAME " fcpim"
+
+#ifndef KOBJ_NAME_LEN
+#define KOBJ_NAME_LEN           20
+#endif
+
+void bfad_flags_set(struct bfad_s *bfad, u32 flags);
+bfa_status_t bfad_im_module_init(void);
+void bfad_im_module_exit(void);
+bfa_status_t bfad_im_probe(struct bfad_s *bfad);
+void bfad_im_probe_undo(struct bfad_s *bfad);
+void bfad_im_probe_post(struct bfad_im_s *im);
+bfa_status_t bfad_im_port_new(struct bfad_s *bfad, struct bfad_port_s
*port);
+void bfad_im_port_delete(struct bfad_s *bfad, struct bfad_port_s
*port);
+void bfad_im_port_online(struct bfad_s *bfad, struct bfad_port_s
*port);
+void bfad_im_port_offline(struct bfad_s *bfad, struct bfad_port_s
*port);
+void bfad_im_port_clean(struct bfad_im_port_s *im_port);
+int  bfad_im_scsi_host_alloc(struct bfad_s *bfad,
+				struct bfad_im_port_s *im_port);
+void bfad_im_scsi_host_free(struct bfad_s *bfad,
+				struct bfad_im_port_s *im_port);
+
+#define MAX_FCP_TARGET 1024
+#define MAX_FCP_LUN 512
+#define BFAD_TARGET_RESET_TMO 60
+#define BFAD_LUN_RESET_TMO 60
+#define ScsiResult(host_code, scsi_code) (((host_code) << 16) |
scsi_code)
+#define BFA_QUEUE_FULL_RAMP_UP_TIME 120
+
+/*
+ * itnim flags
+ */
+#define ITNIM_MAPPED		0x00000001
+
+#define SCSI_TASK_MGMT		0x00000001
+#define IO_DONE_BIT			0
+
+struct bfad_itnim_data_s {
+	struct bfad_itnim_s *itnim;
+};
+
+struct bfad_im_port_s {
+	struct bfad_s         *bfad;
+	struct bfad_port_s    *port;
+	struct work_struct port_delete_work;
+	int             idr_id;
+	u16        cur_scsi_id;
+	struct list_head binding_list;
+	struct Scsi_Host *shost;
+	struct list_head itnim_mapped_list;
+};
+
+enum bfad_itnim_state {
+	ITNIM_STATE_NONE,
+	ITNIM_STATE_ONLINE,
+	ITNIM_STATE_OFFLINE_PENDING,
+	ITNIM_STATE_OFFLINE,
+	ITNIM_STATE_FREE,
+};
+
+/*
+ * Per itnim data structure
+ */
+struct bfad_itnim_s {
+	struct list_head list_entry;
+	struct bfa_fcs_itnim_s fcs_itnim;
+	struct work_struct itnim_work;
+	u32        flags;
+	enum bfad_itnim_state state;
+	struct bfad_im_s *im;
+	struct bfad_im_port_s *im_port;
+	struct bfad_rport_s *drv_rport;
+	struct fc_rport *fc_rport;
+	struct bfa_itnim_s *bfa_itnim;
+	u16        scsi_tgt_id;
+	u16        queue_work;
+	unsigned long	last_ramp_up_time;
+	unsigned long	last_queue_full_time;
+};
+
+enum bfad_binding_type {
+	FCP_PWWN_BINDING = 0x1,
+	FCP_NWWN_BINDING = 0x2,
+	FCP_FCID_BINDING = 0x3,
+};
+
+struct bfad_fcp_binding {
+	struct list_head list_entry;
+	enum bfad_binding_type binding_type;
+	u16        scsi_target_id;
+	u32        fc_id;
+	wwn_t           nwwn;
+	wwn_t           pwwn;
+};
+
+struct bfad_im_s {
+	struct bfad_s         *bfad;
+	struct workqueue_struct *drv_workq;
+	char            drv_workq_name[KOBJ_NAME_LEN];
+};
+
+void bfad_os_spin_os_lock_irq(struct Scsi_Host *);
+void bfad_os_spin_os_unlock_irq(struct Scsi_Host *);
+void bfad_os_fc_release_transp(struct Scsi_Host *shost);
+struct Scsi_Host *bfad_os_scsi_host_alloc(struct scsi_host_template *,
+			struct bfad_im_port_s *im_port, struct bfad_s
*);
+int bfad_os_scsi_register(struct Scsi_Host *shost,
+				struct bfad_im_port_s *im_port, void
*key);
+int bfad_os_fc_attach(struct Scsi_Host *shost,
+				struct fc_function_template *fct);
+int bfad_os_reset_tgt(struct scsi_cmnd *cmnd);
+void bfad_os_scsi_set_pci_device(struct Scsi_Host *shost,
+				struct pci_dev *pcidev);
+void bfad_os_select_queue_depths(struct bfad_im_port_s *im_port);
+bfa_status_t bfad_os_thread_workq(struct bfad_s *bfad);
+void bfad_os_destroy_workq(struct bfad_im_s *im);
+void bfad_os_queue_work(void *workq, void *work);
+void bfad_os_itnim_alloc(struct bfad_itnim_s *itnim_drv);
+void bfad_os_itnim_process(struct bfad_itnim_s *itnim_drv);
+void bfad_os_scsi_unregister(struct Scsi_Host *shost);
+void bfad_os_scsi_remove_host(struct Scsi_Host *shost);
+void bfad_os_scsi_put_host(struct Scsi_Host *shost);
+int  bfad_os_scsi_add_host(struct Scsi_Host *shost, struct device
*dev);
+int bfad_os_fc_attach(struct Scsi_Host *shost,
+			struct fc_function_template *fct);
+
+struct bfad_itnim_data_s *bfad_os_itnim_data(struct bfad_im_port_s
*im_port,
+				struct scsi_cmnd *cmnd);
+void bfad_os_fc_host_init(struct bfad_im_port_s *im_port);
+void bfad_os_fc_remove_host(struct Scsi_Host *shost);
+void bfad_os_init_work(struct bfad_im_port_s *im_port);
+int  bfad_os_dev_init(struct Scsi_Host *shost);
+void bfad_os_transp_templ(struct Scsi_Host *sh,
+				struct scsi_transport_template *stt);
+dma_addr_t bfad_os_dma_map_single(struct device *dev, void *cpu_addr,
+			size_t size, enum dma_data_direction direction);
+void bfad_os_dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+			size_t size, enum dma_data_direction direction);
+int bfad_os_dma_map_sg(struct device *dev, struct scatterlist *sg, int
nents,
+			enum dma_data_direction direction);
+void bfad_os_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+			int nhwentries, enum dma_data_direction
direction);
+int bfad_os_im_dma_map(struct bfad_s *bfad, struct scsi_cmnd *cmnd);
+void bfad_os_im_dma_unmap(struct bfad_s *bfad, struct scsi_cmnd *cmnd);
+int bfad_os_idr_get_new(struct idr *idp, void *ptr, int *id);
+void bfad_os_scsi_state_changed(struct Scsi_Host *shost);
+void bfad_os_scsi_scan(struct bfad_im_port_s *im_port);
+void bfad_os_scsi_host_free(struct bfad_s *bfad,
+				 struct bfad_im_port_s *im_port);
+void bfad_wwn_to_str(wwn_t wwn, char *str);
+void bfad_fcid_to_str(u32 fcid, char *str);
+void bfad_os_ramp_up_qdepth(struct bfad_itnim_s *itnim,
+				 struct scsi_device *sdev);
+void bfad_os_handle_qfull(struct bfad_itnim_s *itnim, struct
scsi_device *sdev);
+void bfad_os_set_dev_loss_tmo(struct scsi_device *sdev);
+struct bfad_itnim_s *bfad_os_get_itnim(struct bfad_im_port_s *im_port,
int id);
+
+/*
+ * scsi_host_template entries
+ */
+int bfad_im_queuecommand(struct scsi_cmnd *cmnd,
+					void (*done)(struct scsi_cmnd
*));
+const char *bfad_im_info(struct Scsi_Host *host);
+int bfad_im_slave_alloc(struct scsi_device *sdev);
+void bfad_im_slave_destroy(struct scsi_device *sdev);
+int bfad_im_abort_handler(struct scsi_cmnd *cmnd);
+int bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd);
+int bfad_im_reset_bus_handler(struct scsi_cmnd *cmnd);
+
+extern struct scsi_host_template bfad_im_scsi_host_template;
+extern struct fc_function_template bfad_im_fc_function_template;
+extern struct scsi_transport_template *bfad_im_scsi_transport_template;
+
+#endif
diff -urpN orig/drivers/scsi/bfa/bfad_intr.c
patch/drivers/scsi/bfa/bfad_intr.c
--- orig/drivers/scsi/bfa/bfad_intr.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_intr.c	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,338 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include "bfad_drv.h"
+#include "bfad_trcmod.h"
+
+BFA_TRC_FILE(LDRV, INTR);
+
+int             msix_disable = 1;
+
+/**
+ * @dg bfa_isr BFA driver interrupt functions
+ * @{
+ */
+irqreturn_t bfad_intx(int irq, void *dev_id);
+
+/**
+ * @brief
+ * Line based interrupt handler.
+ */
+irqreturn_t
+bfad_intx(int irq, void *dev_id)
+{
+	struct bfad_s         *bfad = dev_id;
+	struct bfa_q_s         doneq;
+	unsigned long   flags;
+	enum bfa_isr_status rc;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	rc = bfa_intx(&bfad->bfa);
+	if (rc == BFA_ISR_NOTCLAIMED) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return IRQ_NONE;
+	}
+
+	bfa_comp_deq(&bfad->bfa, &doneq);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (!bfa_q_is_empty(&doneq)) {
+		bfa_comp_process(&bfad->bfa, &doneq);
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_comp_free(&bfad->bfa, &doneq);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		bfa_trc_fp(bfad, irq);
+	}
+
+	return IRQ_HANDLED;
+
+}
+
+#ifdef CONFIG_PCI_MSI
+#define BFAD_MSIX_REQQ(id)
\
+static irqreturn_t bfad_msix_reqq##id(int irq, void *dev_id)
\
+{
\
+	struct bfad_s *bfad = dev_id;
\
+
\
+	bfa_trc(bfad, irq);
\
+	spin_lock(&bfad->bfad_lock);
\
+	bfa_msix_reqq(&bfad->bfa, id);
\
+	spin_unlock(&bfad->bfad_lock);
\
+
\
+	return IRQ_HANDLED;
\
+}
+
+BFAD_MSIX_REQQ(0)
+BFAD_MSIX_REQQ(1)
+BFAD_MSIX_REQQ(2)
+BFAD_MSIX_REQQ(3)
+BFAD_MSIX_REQQ(4)
+BFAD_MSIX_REQQ(5)
+BFAD_MSIX_REQQ(6)
+BFAD_MSIX_REQQ(7)
+
+#define BFAD_MSIX_RSPQ(id)
\
+static irqreturn_t bfad_msix_rspq##id(int irq, void *dev_id)
\
+{
\
+	struct bfad_s *bfad = dev_id;
\
+	struct bfa_q_s doneq;
\
+	enum bfa_isr_status rc;
\
+
\
+	bfa_trc(bfad, irq);
\
+	spin_lock(&bfad->bfad_lock);
\
+	rc = bfa_msix_rspq(&bfad->bfa, id);
\
+	bfa_comp_deq(&bfad->bfa, &doneq);
\
+
\
+	if (!bfa_q_is_empty(&doneq)) {
\
+		spin_unlock(&bfad->bfad_lock);
\
+		bfa_comp_process(&bfad->bfa, &doneq);
\
+		spin_lock(&bfad->bfad_lock);
\
+		bfa_comp_free(&bfad->bfa, &doneq);
\
+	}
\
+	spin_unlock(&bfad->bfad_lock);
\
+
\
+	return IRQ_HANDLED;
\
+}
+
+BFAD_MSIX_RSPQ(0)
+BFAD_MSIX_RSPQ(1)
+BFAD_MSIX_RSPQ(2)
+BFAD_MSIX_RSPQ(3)
+BFAD_MSIX_RSPQ(4)
+BFAD_MSIX_RSPQ(5)
+BFAD_MSIX_RSPQ(6)
+BFAD_MSIX_RSPQ(7)
+
+static irqreturn_t
+bfad_msix_lpu(int irq, void *dev_id)
+{
+	struct bfad_s         *bfad = dev_id;
+
+	bfa_trc(bfad, bfad->inst_no);
+	bfa_trc(bfad, irq);
+	spin_lock(&bfad->bfad_lock);
+	bfa_msix_lpu(&bfad->bfa);
+	spin_unlock(&bfad->bfad_lock);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
+bfad_msix_errint(int irq, void *dev_id)
+{
+	struct bfad_s         *bfad = dev_id;
+
+	bfa_trc(bfad, irq);
+	spin_lock(&bfad->bfad_lock);
+	bfa_msix_errint(&bfad->bfa);
+	spin_unlock(&bfad->bfad_lock);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Global interrupt handler table, one to one map to each bit of the
chip
+ * interrupt register.
+ */
+static irq_handler_t      bfad_msix_isr[] = {
+	(irq_handler_t) bfad_msix_reqq0,
+	(irq_handler_t) bfad_msix_reqq1,
+	(irq_handler_t) bfad_msix_reqq2,
+	(irq_handler_t) bfad_msix_reqq3,
+	(irq_handler_t) bfad_msix_reqq4,
+	(irq_handler_t) bfad_msix_reqq5,
+	(irq_handler_t) bfad_msix_reqq6,
+	(irq_handler_t) bfad_msix_reqq7,
+	(irq_handler_t) bfad_msix_rspq0,
+	(irq_handler_t) bfad_msix_rspq1,
+	(irq_handler_t) bfad_msix_rspq2,
+	(irq_handler_t) bfad_msix_rspq3,
+	(irq_handler_t) bfad_msix_rspq4,
+	(irq_handler_t) bfad_msix_rspq5,
+	(irq_handler_t) bfad_msix_rspq6,
+	(irq_handler_t) bfad_msix_rspq7,
+	(irq_handler_t) bfad_msix_errint,
+	(irq_handler_t) bfad_msix_errint,
+	(irq_handler_t) bfad_msix_errint,
+	(irq_handler_t) bfad_msix_errint,
+	(irq_handler_t) bfad_msix_lpu,
+	(irq_handler_t) bfad_msix_lpu,
+	(irq_handler_t) bfad_msix_lpu,
+	(irq_handler_t) bfad_msix_lpu,
+};
+
+/**
+ * @brief
+ * Initialize the MSIX entry table.
+ */
+static void
+bfad_init_msix_entry(struct bfad_s *bfad, struct msix_entry
*msix_entries,
+			 int mask, int max_bit)
+{
+	int             i;
+	int             match = 0x00000001;
+
+	for (i = 0, bfad->nvec = 0; i < MAX_MSIX_ENTRY; i++) {
+		if (mask & match) {
+			bfad->msix_tab[bfad->nvec].msix.entry = i;
+			msix_entries[bfad->nvec].entry = i;
+			bfad->msix_tab[bfad->nvec++].handler =
bfad_msix_isr[i];
+		}
+
+		match <<= 1;
+	}
+
+}
+
+static int
+bfad_install_msix_handler(struct bfad_s *bfad)
+{
+	int             i, error = 0;
+
+	for (i = 0; i < bfad->nvec; i++) {
+		error = request_irq(bfad->msix_tab[i].msix.vector,
+				    bfad->msix_tab[i].handler, 0,
+				    BFAD_DRIVER_NAME, bfad);
+		printk(KERN_WARNING "%s: bfad%d irq %d\n", __FUNCTION__,
+			 bfad->inst_no, bfad->msix_tab[i].msix.vector);
+
+		if (error) {
+			int             j;
+
+			for (j = 0; j < i; j++)
+				free_irq(bfad->msix_tab[j].msix.vector,
bfad);
+
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * @brief
+ * Setup MSIX based interrupt.
+ */
+int
+bfad_setup_intr(struct bfad_s *bfad)
+{
+	int             error = 0;
+
+	if (!msix_disable) {
+		u32 mask = 0, i, num_bit = 0, max_bit = 0;
+		struct msix_entry msix_entries[MAX_MSIX_ENTRY];
+
+		/* Call BFA to get the msix map for this PCI function.
*/
+		bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
+
+		/* Set up the msix entry table */
+		bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
+
+		error = pci_enable_msix(bfad->pcidev, msix_entries,
bfad->nvec);
+		if (error) {
+			/*
+			 * Only error number of vector is available.
+			 * We don't have a mechanism to map multiple
+			 * interrupts into one vector, so even if we
+			 * can try to request less vectors, we don't
+			 * know how to associate interrupt events to
+			 *  vectors. Linux doesn't dupicate vectors
+			 * in the MSIX table for this case.
+			 */
+
+			printk(KERN_WARNING
+				"%s: enable_msix failed, %d bfad%d\n",
+			       __FUNCTION__, error, bfad->inst_no);
+
+			goto line_based;
+		}
+
+		/* Save the vectors */
+		for (i = 0; i < bfad->nvec; i++)
+			bfad->msix_tab[i].msix.vector =
msix_entries[i].vector;
+
+		/* Set up interrupt handler for each vectors */
+		if (bfad_install_msix_handler(bfad)) {
+			printk(KERN_WARNING "%s: install_msix failed,
bfad%d\n",
+			       __FUNCTION__, bfad->inst_no);
+			goto line_based;
+		}
+
+		bfad->bfad_flags |= BFAD_MSIX_ON;
+
+		goto success;
+	}
+
+line_based:
+	error = 0;
+	if (request_irq
+	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx,
BFAD_IRQ_FLAGS,
+	     BFAD_DRIVER_NAME, bfad) != 0) {
+		/* Enable interrupt handler failed */
+		return 1;
+	}
+success:
+	return error;
+}
+
+void
+bfad_remove_intr(struct bfad_s *bfad)
+{
+	int             i;
+
+	if (bfad->bfad_flags & BFAD_MSIX_ON) {
+		for (i = 0; i < bfad->nvec; i++)
+			free_irq(bfad->msix_tab[i].msix.vector, bfad);
+
+		pci_disable_msix(bfad->pcidev);
+		bfad->bfad_flags &= ~BFAD_MSIX_ON;
+	} else {
+		free_irq(bfad->pcidev->irq, bfad);
+	}
+}
+
+#else /* CONFIG_PCI_MSI */
+/**
+ * @brief
+ * Setup line-based interrupt.
+ */
+int
+bfad_setup_intr(struct bfad_s *bfad)
+{
+	if (request_irq
+	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, SA_SHIRQ,
+	     BFAD_DRIVER_NAME, bfad) != 0) {
+		/* Enable interrupt handler failed */
+		return 1;
+	}
+
+	return 0;
+}
+
+void
+bfad_remove_intr(struct bfad_s *bfad)
+{
+	bfa_trc(bfad, bfad->pcidev->irq);
+	free_irq(bfad->pcidev->irq, bfad);
+}
+
+#endif /* CONFIG_PCI_MSI */
+
+/**
+ * @}
+ */
diff -urpN orig/drivers/scsi/bfa/bfad_ipfc.h
patch/drivers/scsi/bfa/bfad_ipfc.h
--- orig/drivers/scsi/bfa/bfad_ipfc.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_ipfc.h	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DRV_IPFC_H__
+#define __BFA_DRV_IPFC_H__
+
+
+#define IPFC_NAME ""
+
+#define bfad_ipfc_module_init() do {} while (0)
+#define bfad_ipfc_module_exit() do {} while (0)
+#define bfad_ipfc_probe(x) do {} while (0)
+#define bfad_ipfc_probe_undo(x) do {} while (0)
+#define bfad_ipfc_port_config(x, y) BFA_STATUS_OK
+#define bfad_ipfc_port_unconfig(x, y) do {} while (0)
+#define bfad_ipfc_probe_post(x) do {} while (0)
+
+#define bfad_ipfc_port_new(x, y, z) BFA_STATUS_OK
+#define bfad_ipfc_port_delete(x, y) do {} while (0)
+#define bfad_ipfc_port_online(x, y) do {} while (0)
+#define bfad_ipfc_port_offline(x, y) do {} while (0)
+
+#endif
diff -urpN orig/drivers/scsi/bfa/bfad_os.c
patch/drivers/scsi/bfa/bfad_os.c
--- orig/drivers/scsi/bfa/bfad_os.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_os.c	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad_os.c Linux driver OS specific calls.
+ */
+
+#include "bfa_os_inc.h"
+#include "bfad_drv.h"
+
+void
+bfa_os_gettimeofday(struct bfa_timeval_s *tv)
+{
+	struct timeval  tmp_tv;
+
+	do_gettimeofday(&tmp_tv);
+	tv->tv_sec = (u32) tmp_tv.tv_sec;
+	tv->tv_usec = (u32) tmp_tv.tv_usec;
+}
+
+void
+bfa_os_printf(struct bfa_log_mod_s *log_mod, u32 msg_id,
+			const char *fmt, ...)
+{
+	va_list ap;
+	#define BFA_STRING_256	256
+	char tmp[BFA_STRING_256];
+
+	va_start(ap, fmt);
+	vsprintf(tmp, fmt, ap);
+	va_end(ap);
+
+	printk(tmp);
+}
+
+u32
+bfa_os_get_instance_id(struct bfad_s *bfad)
+{
+	return (bfad->inst_no);
+}
+
+/**
+ * @}
+ */
diff -urpN orig/drivers/scsi/bfa/bfad_sysfs.c
patch/drivers/scsi/bfa/bfad_sysfs.c
--- orig/drivers/scsi/bfa/bfad_sysfs.c	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_sysfs.c	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,2721 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad_sysfs.c Linux driver sysfs interface functionality.
+ */
+
+/*
+*  SYSFS Directory Structure for Brocade HBAs:
+ *
+ *  The ROOT_DIR is automatically created by the OS when a HBA is
present.
+*  Eg: ROOT_DIR for HBA in slot 6 :
+*      /sys/devices/pci0000:00/0000:00:06.0/0000:10:00.0/    //
instance .0
+*      /sys/devices/pci0000:00/0000:00:06.0/0000:10:00.1/    //
instance .1
+ *
+*  The following sub-directory structure will be created by the driver:
+ *
+ *  <ROOT_DIR>/bfa/ioc/
+ *                 |   /stats
+ *                 /pport/
+ *                 |    /stats
+ *                 /lport-0/
+ *                 |       /stats
+ *                 |       /refresh_rports
+ *                 |       /rp-00000000000001/
+ *                 |                         /stats
+ *
+ */
+
+#include "bfad_drv.h"
+#include "bfad_trcmod.h"
+#include "bfad_sysfs.h"
+#include "fcs/bfa_fcs_fcpim.h"
+#include <log/bfa_log_linux.h>
+#include <linux/module.h>
+
+#define SYSFS_MAX_RPORTS	(2 * 1024)
+#define MAX_VAL -1
+
+struct bfa_state {
+	int             code;
+	char           *str;
+};
+
+static char    *bfad_sysfs_private_kobject_get_path(struct kobject
*kobj,
+						    gfp_t gfp_mask);
+static void     bfad_sysfs_hcb_comp(void *arg, bfa_status_t status);
+static char    *bfad_sysfs_state_to_string(int state, struct bfa_state
*table);
+static int      my_strcspn(char *path, const char *sub);
+static int      bfad_sysfs_snprint_pwwn(wwn_t w, char *buf, int len);
+static int      bfad_sysfs_print_pwwn(wwn_t w, char *buf);
+static bfa_boolean_t bfad_sysfs_get_port_wwn_no_col(char *pid, wwn_t
*pn);
+static struct bfad_s *bfad_sysfs_get_param(struct kobject *kobj, int
*ioc_inst,
+					   int *vf_id, u64 *vport_id,
+					   u64 *rport_id);
+static struct bfad_s *bfad_find_bfad_by_kobj(struct kobject *kobj);
+
+static struct bfa_state port_state_table[] = {
+	{0, "Unknown"},
+	{BFA_PPORT_ST_UNINIT, "Uninit"},
+	{BFA_PPORT_ST_ENABLING_QWAIT, "Enabling (qwait)"},
+	{BFA_PPORT_ST_ENABLING, "Enabling"},
+	{BFA_PPORT_ST_LINKDOWN, "Linkdown"},
+	{BFA_PPORT_ST_LINKUP, "Linkup"},
+	{BFA_PPORT_ST_DISABLING_QWAIT, "Disabling (qwait)"},
+	{BFA_PPORT_ST_DISABLING, "Disabling"},
+	{BFA_PPORT_ST_DISABLED, "Disabled"},
+	{BFA_PPORT_ST_STOPPED, "Stopped"},
+	{BFA_PPORT_ST_IOCDOWN, "IOC down"},
+	{BFA_PPORT_ST_MAX_STATE, "Invalid"},
+	{MAX_VAL, "--"}
+};
+
+static struct bfa_state vport_state_table[] = {
+	{BFA_FCS_VPORT_UNINIT, "Uninit"},
+	{BFA_FCS_VPORT_CREATED, "Created"},
+	{BFA_FCS_VPORT_OFFLINE, "Offline"},
+	{BFA_FCS_VPORT_FDISC_SEND, "Fdisc Send"},
+	{BFA_FCS_VPORT_FDISC, "Fdisc"},
+	{BFA_FCS_VPORT_FDISC_RETRY, "Fdisc Retry"},
+	{BFA_FCS_VPORT_ONLINE, "Online"},
+	{BFA_FCS_VPORT_DELETING, "Deleting"},
+	{BFA_FCS_VPORT_CLEANUP, "Cleanup"},
+	{BFA_FCS_VPORT_LOGO_SEND, "Logo Send"},
+	{BFA_FCS_VPORT_LOGO, "Logo"},
+	{MAX_VAL, "--"},
+};
+
+/*
+ * rport state
+ */
+static struct bfa_state rport_state_table[] = {
+	{BFA_RPORT_UNINIT, "uninit"},
+	{BFA_RPORT_OFFLINE, "offline"},
+	{BFA_RPORT_PLOGI, "plogi"},
+	{BFA_RPORT_ONLINE, "online"},
+	{BFA_RPORT_PLOGI_RETRY, "retry"},
+	{BFA_RPORT_NSQUERY, "nsquery"},
+	{BFA_RPORT_ADISC, "adisc"},
+	{BFA_RPORT_LOGO, "logo"},
+	{BFA_RPORT_LOGORCV, "logorecv"},
+	{BFA_RPORT_NSDISC, "nsdisc"},
+	{MAX_VAL, "--"}
+};
+
+/*
+ * fcpim state
+ */
+static struct bfa_state fcpim_state_table[] = {
+	{BFA_ITNIM_OFFLINE, "offline"},
+	{BFA_ITNIM_PRLI_SEND, "prli send"},
+	{BFA_ITNIM_PRLI_SENT, "prli sent"},
+	{BFA_ITNIM_PRLI_RETRY, "prli retry"},
+	{BFA_ITNIM_HCB_ONLINE, "online callback"},
+	{BFA_ITNIM_ONLINE, "online"},
+	{BFA_ITNIM_HCB_OFFLINE, "offline callback"},
+	{BFA_ITNIM_INITIATIOR, "initiator"},
+	{MAX_VAL, "--"}
+};
+
+static char    *
+bfad_sysfs_state_to_string(int state, struct bfa_state *table)
+{
+	int             j = 0;
+	while (table[j].code <= BFA_RPORT_NSDISC) {
+		if (table[j].code == state)
+			return table[j].str;
+		j++;
+	}
+	return "unknown";
+}
+
+/*
+ * strcspn() is not found in certain Linux falvors.
+ * So, implementing our own.
+ */
+static int
+my_strcspn(char *path, const char *sub)
+{
+	int             i;
+
+	for (i = 0; i <= strlen(path) - strlen(sub); i++) {
+		if (strncmp((path + i), sub, strlen(sub)) == 0)
+			return i;
+	}
+
+	return 0;
+}
+
+static          LIST_HEAD(bfad_kobj_base_list);
+
+enum bfad_kobj_type {
+	KOBJ_TYPE_NONE = 0,
+	KOBJ_TYPE_IOC,
+	KOBJ_TYPE_PPORT,
+	KOBJ_TYPE_VF,
+	KOBJ_TYPE_VPORT,
+	KOBJ_TYPE_RPORT,
+	KOBJ_TYPE_LPORT,
+	KOBJ_TYPE_ITNIM
+};
+
+/**
+ * @brief Node which is the directory that has information about the
node.
+ *  If the directory is a VF node, then it has a list of Vports created
+ *  under it.
+ */
+struct bfad_kobj_s {
+	struct list_head kobj_list_entry;
+	enum bfad_kobj_type type;	/* Type of the node */
+	u8         inst;	/* Instance = 0 or 1 */
+	u16        vf_id;	/* VF ID */
+	u64        vport_id;	/* VPORT ID */
+	u64        rport_id;	/* RPORT ID */
+	u64        pwwn;	/* PWWN */
+	struct kobject *kobj;	/* kobj of the node itself */
+	struct list_head kobj_vport_list;	/* List of all vports of
a
+						 *VF */
+};
+
+static void
+fill_kobj_path(struct kobject *kobj, char *path, int length)
+{
+	struct kobject *parent;
+
+	--length;
+	for (parent = kobj; parent; parent = parent->parent) {
+		int             cur = strlen(kobject_name(parent));
+		/*
+		 * back up enough to print this name with '/'
+		 */
+		length -= cur;
+		strncpy(path + length, kobject_name(parent), cur);
+		*(path + --length) = '/';
+	}
+
+	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
+}
+
+static int
+get_kobj_path_length(struct kobject *kobj)
+{
+	int             length = 1;
+	struct kobject *parent = kobj;
+
+	/*
+	 * walk up the ancestors until we hit the one pointing to the
root.
+	 * Add 1 to strlen for leading '/' of each level.
+	 */
+	do {
+		if (kobject_name(parent) == NULL)
+			return 0;
+		length += strlen(kobject_name(parent)) + 1;
+		parent = parent->parent;
+	} while (parent);
+
+	return length;
+}
+
+/**
+ * kobject_get_path - generate and return the path associated with a
given
+ * kobj and kset pair.
+ *
+*  @kobj:	kobject in question, with which to build the path
+*  @gfp_mask:	the allocation type used to allocate the path
+ *
+ * The result must be freed by the caller with kfree().
+ */
+static char    *
+bfad_sysfs_private_kobject_get_path(struct kobject *kobj, gfp_t
gfp_mask)
+{
+	char           *path;
+	int             len;
+
+	len = get_kobj_path_length(kobj);
+	if (len == 0)
+		return NULL;
+	path = kzalloc(len, gfp_mask);
+	if (!path)
+		return NULL;
+	fill_kobj_path(kobj, path, len);
+
+	return path;
+}
+
+char           *
+bfad_os_sysfs_get_ioc_path(struct bfad_s *bfad)
+{
+	return
bfad_sysfs_private_kobject_get_path(&bfad->pcidev->dev.kobj,
+						   GFP_ATOMIC);
+
+}
+
+union PWWN{
+	unsigned char   p[8];
+	wwn_t           pn;
+};
+
+static int
+bfad_sysfs_snprint_pwwn(wwn_t w, char *buf, int len)
+{
+	union PWWN      p;
+	int             i = 0;
+
+	p.pn = w;
+	while (i < 8) {
+		len += snprintf(buf + len, PAGE_SIZE - len, "%02x",
p.p[i]);
+		if (i == 7)
+			break;
+		len += snprintf(buf + len, PAGE_SIZE - len, ":");
+		i++;
+	}
+
+	return len;
+}
+
+static int
+bfad_sysfs_print_pwwn(wwn_t w, char *buf)
+{
+	union PWWN      p;
+	int             i = 0, len = 0;
+
+	p.pn = w;
+	while (i < 8) {
+		len += snprintf(buf + len, PAGE_SIZE - len, "%02x",
p.p[i]);
+		if (i == 7)
+			break;
+		i++;
+	}
+
+	return len;
+}
+
+static          bfa_boolean_t
+bfad_sysfs_get_port_wwn_no_col(char *pid, wwn_t *pn)
+{
+	union PWWN      pp;
+	int             i = 0;
+	u8         x;
+	char            str[100];
+	strcpy(str, "");
+	while (i < 8) {
+		strncpy(str, &pid[i * 2], 2);
+		str[2] = '\0';
+		sscanf(str, "%hhx", &x);
+		pp.p[i] = x;
+		i++;
+	}
+	memcpy(pn, &pp.pn, 8);
+	return BFA_TRUE;
+}
+
+/**
+ * @brief Function to parse the directory path to get ioc instance
+ *  VF ID (if applicable) and VPORT ID (if applicable)
+ * @param[in]  kobj - kobject of the directory to parse
+ * @param[out] ioc_inst - IOC instance
+ * @param[out] vf_id - VF ID
+ * @param[out] vport_id - PWWN of the VPORT
+ * @param[out] rport_id - PWWN of the RPORT
+ * @retval struct bfad_s - if the instance if found and if there is not
+ * 			 	parsing error
+ */
+static struct bfad_s *
+bfad_sysfs_get_param(struct kobject *kobj, int *ioc_inst, int *vf_id,
+		     u64 *vport_id, u64 *rport_id)
+{
+	char           *path, *str, wwn_str[100], tmp_str[100];
+	struct bfad_s  *bfad;
+	u8         idx;
+
+	path = bfad_sysfs_private_kobject_get_path(kobj, GFP_ATOMIC);
+
+	/*
+	 * extract the instance from the path
+	 */
+	strcpy(tmp_str, path);
+	idx = my_strcspn(tmp_str, "bfa");
+	if (idx == 0) {
+		kfree(path);
+		return NULL;
+	}
+
+	tmp_str[idx - 1] = '\0';
+	idx = strlen(tmp_str);
+	while (tmp_str[idx] != '.')
+		idx--;
+	sscanf((tmp_str + idx + 1), "%d", ioc_inst);
+
+	bfad = bfad_os_find_bfad_by_path(path);
+	if (bfad == NULL) {
+		kfree(path);
+		return NULL;
+	}
+
+	/*
+	 * Check if we are at the vf level, if so get the VF ID
+	 */
+	*vf_id = 0;
+	str = strstr(path, "/vf/");
+	if (str)
+		sscanf(str, "/vf/vf-%X", vf_id);
+
+	*vport_id = 0;
+	*rport_id = 0;
+
+	/*
+	 * Check if we are at the rport level, if so get the RPORT ID
+	 */
+	str = strstr(path, "/rp-");
+	if (str) {
+		sscanf(str, "/rp-%s", wwn_str);
+		bfad_sysfs_get_port_wwn_no_col(wwn_str, rport_id);
+	}
+	/*
+	 * Check if we are at the vport level, if so get the VPORT ID
+	 */
+	str = strstr(path, "/vp-");
+	if (str) {
+		sscanf(str, "/vp-%s", wwn_str);
+		bfad_sysfs_get_port_wwn_no_col(wwn_str, vport_id);
+	}
+
+	kfree(path);
+	return bfad;
+}
+
+static struct bfad_s *
+bfad_find_bfad_by_kobj(struct kobject *kobj)
+{
+	struct bfad_s  *bfad = NULL, *rc = NULL;
+
+	down(&bfad_sem);
+	list_for_each_entry(bfad, &bfad_list, list_entry) {
+		if (bfad->ioc_kobj == kobj || bfad->pport_kobj == kobj
+		    || bfad->lport_kobj == kobj) {
+			rc = bfad;
+			break;
+		}
+	}
+	up(&bfad_sem);
+	return rc;
+}
+
+/*
+ * ITNIM Commands
+ */
+static          ssize_t
+bfad_itnim_show_attr(struct bfad_s *bfad, int vf_id, wwn_t pwwn, wwn_t
rpwwn,
+		     char *buf, struct kobj_attribute *sys_attr)
+{
+	struct bfa_itnim_attr_s attr;
+	struct bfa_fcs_port_s *fcs_port;
+	unsigned long   flags;
+	bfa_status_t    status;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, pwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find FCS
port\n");
+	}
+
+	status = bfa_fcs_itnim_attr_get(fcs_port, rpwwn, &attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (status != BFA_STATUS_OK)
+		return snprintf(buf, PAGE_SIZE,
+				"error getting itnim attribute\n");
+
+	if (strcmp(sys_attr->attr.name, "state") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				bfad_sysfs_state_to_string(attr.state,
+
fcpim_state_table));
+	} else {
+		return 0;
+	}
+}
+
+static          ssize_t
+bfad_itnim_stats_show(struct kobject *kobj, struct kobj_attribute
*sys_attr,
+		      char *buf)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	u64        rpwwn, vpwwn;
+	struct bfa_pport_attr_s pattr;
+	unsigned long   flags;
+	struct bfa_itnim_stats_s stats;
+	struct bfa_fcs_port_s *fcs_port;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "Error finding bfad\n");
+
+	if (vpwwn == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		vpwwn = pattr.pwwn;
+	}
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, vpwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find FCS
port\n");
+	}
+
+	if (bfa_fcs_itnim_stats_get(fcs_port, rpwwn, &stats) !=
BFA_STATUS_OK) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "error getting itnim
stats");
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "onlines") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.onlines);
+	else if (strcmp(sys_attr->attr.name, "offlines") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.offlines);
+	else if (strcmp(sys_attr->attr.name, "prli_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.prli_sent);
+	else if (strcmp(sys_attr->attr.name, "prli_rsp_acc") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.prli_rsp_acc);
+	else if (strcmp(sys_attr->attr.name, "prli_rsp_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.prli_rsp_err);
+	else if (strcmp(sys_attr->attr.name, "prli_rsp_parse_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.prli_rsp_parse_err);
+	else if (strcmp(sys_attr->attr.name, "fcxp_alloc_wait") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.fcxp_alloc_wait);
+	else if (strcmp(sys_attr->attr.name,
"second_level_error_recovery") ==
+		 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.sler);
+	else if (strcmp(sys_attr->attr.name, "initiator_mode") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.initiator);
+	else
+		return 0;
+}
+
+/**
+ * @brief Function to show RPORT-ITNIM attributes
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer to be filled in.
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_sysfs_itnim_show(struct kobject *kobj, struct kobj_attribute
*attr,
+		      char *buf)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	u64        rpwwn, vpwwn;
+	struct bfa_pport_attr_s pattr;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "error finding IOC.\n");
+
+	if (vpwwn == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		vpwwn = pattr.pwwn;
+	}
+
+	return bfad_itnim_show_attr(bfad, vf_id, vpwwn, rpwwn, buf,
attr);
+}
+
+/**
+ * @brief Function to configure RPORT-ITNIM attributes e.g. statsclear
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer contains user input
+ * @param[in] count - Number of bytes in 'buf'
+ * @retval count - Number of bytes of 'buf' used in the function
+ */
+static          ssize_t
+bfad_sysfs_itnim_store(struct kobject *kobj, struct kobj_attribute
*attr,
+		       const char *buf, size_t count)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	u64        rpwwn, vpwwn;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_fcs_itnim_s *itnim;
+	struct bfa_pport_attr_s pattr;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return count;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (vpwwn == 0) {
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		vpwwn = pattr.pwwn;
+	}
+
+	if (strcmp(attr->attr.name, "reset") == 0) {
+		fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id,
vpwwn);
+		if (fcs_port == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return count;
+		}
+
+		itnim = bfa_fcs_itnim_lookup(fcs_port, rpwwn);
+		if (itnim == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return count;
+		}
+
+		bfa_fcs_itnim_stats_clear(fcs_port, rpwwn);
+		bfa_itnim_clear_stats(bfa_fcs_itnim_get_halitn(itnim));
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return count;
+}
+
+static struct kobj_attribute itnim_state_attribute =
+__ATTR(state, 0444, bfad_sysfs_itnim_show, NULL);
+
+static struct kobj_attribute itnim_stats_onlines_attribute =
+__ATTR(onlines, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_offlines_attribute =
+__ATTR(offlines, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_prli_sent_attribute =
+__ATTR(prli_sent, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_prli_rsp_acc_attribute =
+__ATTR(prli_rsp_acc, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_prli_rsp_err_attribute =
+__ATTR(prli_rsp_err, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_prli_rsp_parse_err_attribute =
+__ATTR(prli_rsp_parse_err, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_fcxp_alloc_wait_attribute =
+__ATTR(fcxp_alloc_wait, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute
itnim_stats_sec_level_err_recovery_attribute =
+__ATTR(second_level_error_recovery, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_initiator_mode_attribute =
+__ATTR(initiator_mode, 0444, bfad_itnim_stats_show, NULL);
+static struct kobj_attribute itnim_stats_reset_attribute =
+__ATTR(reset, 0200, NULL, bfad_sysfs_itnim_store);
+
+static struct attribute *itnim_stats[] = {
+	&itnim_stats_onlines_attribute.attr,
+	&itnim_stats_offlines_attribute.attr,
+	&itnim_stats_prli_sent_attribute.attr,
+	&itnim_stats_prli_rsp_acc_attribute.attr,
+	&itnim_stats_prli_rsp_err_attribute.attr,
+	&itnim_stats_prli_rsp_parse_err_attribute.attr,
+	&itnim_stats_fcxp_alloc_wait_attribute.attr,
+	&itnim_stats_sec_level_err_recovery_attribute.attr,
+	&itnim_stats_initiator_mode_attribute.attr,
+	&itnim_stats_reset_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group itnim_stats_group = {
+	.attrs = itnim_stats,
+	.name = "statistics",
+};
+
+static struct attribute *itnim_attrs[] = {
+	&itnim_state_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group itnim_attr_group = {
+	.attrs = itnim_attrs,
+};
+
+/*
+ * RPORT Commands
+ */
+static          ssize_t
+bfad_rport_attr_show(struct bfad_s *bfad, int vf_id, wwn_t pwwn, wwn_t
rpwwn,
+		     char *buf, struct kobj_attribute *sys_attr)
+{
+	int             len = 0;
+	struct bfa_rport_attr_s attr;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_fcs_rport_s *fcs_rport;
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, pwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find FCS
port\n");
+	}
+
+	fcs_rport = bfa_fcs_rport_lookup(fcs_port, rpwwn);
+	if (fcs_rport == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find rport\n");
+	}
+
+	bfa_fcs_rport_get_attr(fcs_rport, &attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "port_id") == 0)
+		return snprintf(buf, PAGE_SIZE, "%06x\n",
+				bfa_os_ntoh3b(attr.pid));
+	else if (strcmp(sys_attr->attr.name, "pwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(attr.pwwn, buf, len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "nwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(attr.nwwn, buf, len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "state") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				bfad_sysfs_state_to_string(attr.state,
+
rport_state_table));
+	} else if (strcmp(sys_attr->attr.name, "class_of_service") == 0)
{
+		if (attr.fc_cos == FC_CLASS_2) {
+			return snprintf(buf, PAGE_SIZE, "Class-2\n");
+		} else if (attr.fc_cos == FC_CLASS_3) {
+			return snprintf(buf, PAGE_SIZE, "Class-3\n");
+		} else if (attr.fc_cos == FC_CLASS_2_3) {
+			return snprintf(buf, PAGE_SIZE, "Class-2,
Class-3\n");
+		}
+	} else if (strcmp(sys_attr->attr.name, "data_field_size") == 0)
{
+		return snprintf(buf, PAGE_SIZE, "%d\n", attr.df_sz);
+	} else if (strcmp(sys_attr->attr.name, "cisc") == 0) {
+		if (attr.cisc)
+			return snprintf(buf, PAGE_SIZE, "%s\n",
"Supported");
+		else
+			return snprintf(buf, PAGE_SIZE, "%s\n",
+					"Not Supported");
+	} else if (strcmp(sys_attr->attr.name, "speed") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n", "TBD");
+	} else if (strcmp(sys_attr->attr.name, "qos_priority") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n", "TBD");
+	} else if (strcmp(sys_attr->attr.name, "symbolic_name") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
attr.symname.symname);
+	}
+
+	return 0;
+
+}
+
+static          ssize_t
+bfad_rport_stats_show(struct kobject *kobj, struct kobj_attribute
*sys_attr,
+		      char *buf)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	struct bfa_rport_stats_s stats;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_fcs_rport_s *fcs_rport;
+	unsigned long   flags;
+	struct bfa_pport_attr_s pattr;
+	u64        rpwwn, vpwwn;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "Error finding bfad\n");
+
+	if (vpwwn == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		vpwwn = pattr.pwwn;
+	}
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, vpwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find FCS
port\n");
+	}
+
+	fcs_rport = bfa_fcs_rport_lookup(fcs_port, rpwwn);
+	if (fcs_rport == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find rport\n");
+	}
+
+	bfa_fcs_rport_get_stats(fcs_rport, &stats);
+	bfa_rport_get_stats(bfa_fcs_rport_get_halrport(fcs_rport),
+			    &stats.hal_stats);
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "offlines") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.offlines);
+	else if (strcmp(sys_attr->attr.name, "onlines") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.onlines);
+	else if (strcmp(sys_attr->attr.name, "rscns") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.rscns);
+	else if (strcmp(sys_attr->attr.name, "plogi_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.plogis);
+	else if (strcmp(sys_attr->attr.name, "plogi_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.plogi_accs);
+	else if (strcmp(sys_attr->attr.name, "plogi_timeouts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.plogi_timeouts);
+	else if (strcmp(sys_attr->attr.name, "plogi_failed") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.plogi_failed);
+	else if (strcmp(sys_attr->attr.name, "plogi_rejects") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.plogi_rejects);
+	else if (strcmp(sys_attr->attr.name, "plogi_rcvd") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.plogi_rcvd);
+	else if (strcmp(sys_attr->attr.name, "prli_rcvd") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.prli_rcvd);
+	else if (strcmp(sys_attr->attr.name, "logo_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.logos);
+	else if (strcmp(sys_attr->attr.name, "logo_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.logo_accs);
+
+	return 0;
+
+}
+
+/**
+ * @brief Function to show RPORT attributes
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer to be filled in.
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_sysfs_rport_show(struct kobject *kobj, struct kobj_attribute
*attr,
+		      char *buf)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	struct bfa_pport_attr_s pattr;
+	u64        rpwwn, vpwwn;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "Error finding bfad\n");
+
+	if (vpwwn == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		vpwwn = pattr.pwwn;
+	}
+
+	return bfad_rport_attr_show(bfad, vf_id, vpwwn, rpwwn, buf,
attr);
+}
+
+/**
+ * @brief Function to configure RPORT attributes e.g. statsclear
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer contains user input
+ * @param[in] count - Number of bytes in 'buf'
+ * @retval count - Number of bytes of 'buf' used in the function
+ */
+static          ssize_t
+bfad_sysfs_rport_store(struct kobject *kobj, struct kobj_attribute
*attr,
+		       const char *buf, size_t count)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id;
+	u64        rpwwn, vpwwn;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_pport_attr_s pattr;
+	struct bfa_fcs_rport_s *fcs_rport;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &vpwwn,
&rpwwn);
+	if (bfad == NULL)
+		return count;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	if (vpwwn == 0) {
+		bfa_pport_get_attr(&bfad->bfa, &pattr);
+		vpwwn = pattr.pwwn;
+	}
+
+	if (strcmp(attr->attr.name, "reset") == 0) {
+		fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id,
vpwwn);
+		if (fcs_port == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return count;
+		}
+
+		fcs_rport = bfa_fcs_rport_lookup(fcs_port, rpwwn);
+		if (fcs_rport == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return count;
+		}
+
+		bfa_fcs_rport_clear_stats(fcs_rport);
+
bfa_rport_clear_stats(bfa_fcs_rport_get_halrport(fcs_rport));
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return count;
+}
+
+static struct kobj_attribute rport_port_id_attribute =
+__ATTR(port_id, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_pwwn_attribute =
+__ATTR(pwwn, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_nwwn_attribute =
+__ATTR(nwwn, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_state_attribute =
+__ATTR(state, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_class_of_service_attribute =
+__ATTR(class_of_service, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_data_field_size_attribute =
+__ATTR(data_field_size, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_cisc_attribute =
+__ATTR(cisc, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_speed_attribute =
+__ATTR(speed, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_qos_priority_attribute =
+__ATTR(qos_priority, 0444, bfad_sysfs_rport_show, NULL);
+static struct kobj_attribute rport_symbolic_name_attribute =
+__ATTR(symbolic_name, 0444, bfad_sysfs_rport_show, NULL);
+
+static struct kobj_attribute rport_stats_offlines_attribute =
+__ATTR(offlines, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_onlines_attribute =
+__ATTR(onlines, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_rscns_attribute =
+__ATTR(rscns, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_sent_attribute =
+__ATTR(plogi_sent, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_accepts_attribute =
+__ATTR(plogi_accepts, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_timeouts_attribute =
+__ATTR(plogi_timeouts, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_failed_attribute =
+__ATTR(plogi_failed, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_rejects_attribute =
+__ATTR(plogi_rejects, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_plogi_rcvd_attribute =
+__ATTR(plogi_rcvd, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_prli_rcvd_attribute =
+__ATTR(prli_rcvd, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_logo_sent_attribute =
+__ATTR(logo_sent, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_logo_accepts_attribute =
+__ATTR(logo_accepts, 0444, bfad_rport_stats_show, NULL);
+static struct kobj_attribute rport_stats_reset_attribute =
+__ATTR(reset, 0200, NULL, bfad_sysfs_rport_store);
+
+static struct attribute *rport_stats[] = {
+	&rport_stats_offlines_attribute.attr,
+	&rport_stats_onlines_attribute.attr,
+	&rport_stats_rscns_attribute.attr,
+	&rport_stats_plogi_sent_attribute.attr,
+	&rport_stats_plogi_accepts_attribute.attr,
+	&rport_stats_plogi_timeouts_attribute.attr,
+	&rport_stats_plogi_failed_attribute.attr,
+	&rport_stats_plogi_rejects_attribute.attr,
+	&rport_stats_plogi_rcvd_attribute.attr,
+	&rport_stats_prli_rcvd_attribute.attr,
+	&rport_stats_logo_sent_attribute.attr,
+	&rport_stats_logo_accepts_attribute.attr,
+	&rport_stats_reset_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group rport_stats_group = {
+	.attrs = rport_stats,
+	.name = "statistics",
+};
+
+static struct attribute *rport_attrs[] = {
+	&rport_port_id_attribute.attr,
+	&rport_pwwn_attribute.attr,
+	&rport_nwwn_attribute.attr,
+	&rport_state_attribute.attr,
+	&rport_class_of_service_attribute.attr,
+	&rport_data_field_size_attribute.attr,
+	&rport_cisc_attribute.attr,
+	&rport_speed_attribute.attr,
+	&rport_qos_priority_attribute.attr,
+	&rport_symbolic_name_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group rport_attr_group = {
+	.attrs = rport_attrs,
+};
+
+static struct bfad_kobj_s *
+bfad_sysfs_search_kobj(u64 pwwn, enum bfad_kobj_type type, u16 vf_id,
+		       u64 vport_id, wwn_t rport_id,
+		       struct list_head *list)
+{
+	struct bfad_kobj_s    *bfad_kobj = NULL;
+
+	if (list_empty(list))
+		return NULL;
+
+	list_for_each_entry(bfad_kobj, list, kobj_list_entry) {
+		if (bfad_kobj->type == type && bfad_kobj->vf_id == vf_id
+		    && bfad_kobj->vport_id == vport_id
+		    && bfad_kobj->rport_id == rport_id
+		    && bfad_kobj->pwwn == pwwn)
+			return bfad_kobj;
+	}
+
+	return NULL;
+}
+
+static void
+bfad_sysfs_remove_deleted_rports(struct bfa_fcs_port_s *fcs_port, u64
pwwn,
+				 u16 vf_id, struct list_head *list)
+{
+	struct bfa_fcs_rport_s *fcs_rport;
+	struct bfad_kobj_s    *bfad_kobj = NULL;
+	struct list_head *pos, *next;
+
+	if (list_empty(list))
+		return;
+
+	/*
+	 * Delete the ITNIM nodes first
+	 */
+	list_for_each_safe(pos, next, list) {
+		bfad_kobj = list_entry(pos, struct bfad_kobj_s,
+
kobj_list_entry);
+		if (bfad_kobj->type == KOBJ_TYPE_ITNIM
+		    && bfad_kobj->vf_id == vf_id && bfad_kobj->pwwn ==
pwwn) {
+			fcs_rport =
+				bfa_fcs_rport_lookup(fcs_port,
+
bfad_kobj->rport_id);
+			if (fcs_rport == NULL) {
+				sysfs_remove_group(bfad_kobj->kobj,
+						   &itnim_stats_group);
+				kobject_put(bfad_kobj->kobj);
+				list_del(&bfad_kobj->kobj_list_entry);
+				kfree(bfad_kobj);
+			}
+		}
+	}
+
+	/*
+	 * Delete the RPORT itself
+	 */
+	list_for_each_safe(pos, next, list) {
+		bfad_kobj = list_entry(pos, struct bfad_kobj_s,
+
kobj_list_entry);
+		if (bfad_kobj->type == KOBJ_TYPE_RPORT
+		    && bfad_kobj->vf_id == vf_id && bfad_kobj->pwwn ==
pwwn) {
+			fcs_rport =
+				bfa_fcs_rport_lookup(fcs_port,
+
bfad_kobj->rport_id);
+			if (fcs_rport == NULL) {
+				sysfs_remove_group(bfad_kobj->kobj,
+						   &rport_stats_group);
+				kobject_put(bfad_kobj->kobj);
+				list_del(&bfad_kobj->kobj_list_entry);
+				kfree(bfad_kobj);
+			}
+		}
+	}
+}
+
+static void
+bfad_sysfs_delete_all_rports(struct bfad_s *bfad, enum bfad_kobj_type
type,
+			     u16 vf_id, struct list_head *list)
+{
+	struct bfad_kobj_s    *bfad_kobj = NULL;
+	struct bfa_pport_attr_s pattr;
+	struct list_head *pos, *next;
+	unsigned long   flags;
+
+	if (list_empty(list))
+		return;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_pport_get_attr(&bfad->bfa, &pattr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	list_for_each_safe(pos, next, list) {
+		bfad_kobj = list_entry(pos, struct bfad_kobj_s,
+						 kobj_list_entry);
+		if (bfad_kobj->type == type && bfad_kobj->vf_id == vf_id
+		    && bfad_kobj->inst == bfad->inst_no) {
+			if (type == KOBJ_TYPE_RPORT)
+				sysfs_remove_group(bfad_kobj->kobj,
+						   &rport_stats_group);
+			else
+				sysfs_remove_group(bfad_kobj->kobj,
+						   &itnim_stats_group);
+			kobject_put(bfad_kobj->kobj);
+			list_del(&bfad_kobj->kobj_list_entry);
+			kfree(bfad_kobj);
+		}
+	}
+}
+
+static          ssize_t
+bfad_rport_main_show_list(struct bfad_s *bfad, struct kobject *kobj,
int vf_id,
+			  wwn_t pwwn, wwn_t vpwwn, char *buf)
+{
+	int             len = 0, i;
+	wwn_t          *rports = NULL;
+	int             nrports = SYSFS_MAX_RPORTS;
+	struct bfad_kobj_s    *bfad_kobj;
+	unsigned long   flags;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_fcs_rport_s *fcs_rport;
+	struct kobject *parent_kobj;
+	struct list_head *kobj_vport_list;
+	char            kobj_name[32];
+	int             retval;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port =
+		bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id,
+					vpwwn ? vpwwn : pwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "can't find FCS
port\n");
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	rports = kzalloc(sizeof(wwn_t) * nrports, GFP_KERNEL);
+	if (rports == NULL)
+		return snprintf(buf, PAGE_SIZE, "memory sqeeze\n");
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_fcs_port_get_rports(fcs_port, rports, &nrports);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	kobj_vport_list = &bfad_kobj_base_list;
+
+	len = snprintf(buf, PAGE_SIZE, "No. of rports: %d\n", nrports);
+
+	/*
+	 * Create a directory entry for each rport
+	 */
+	for (i = 0; i < nrports; i++) {
+		fcs_rport = bfa_fcs_rport_lookup(fcs_port, rports[i]);
+		if (fcs_rport == NULL) {
+			kfree(rports);
+			return len +=
+				snprintf(buf + len, PAGE_SIZE - len,
+					 "can't find FCS port \n");
+		}
+
+		if (bfad_sysfs_search_kobj
+		    (pwwn, KOBJ_TYPE_RPORT, vf_id, vpwwn, rports[i],
+		     kobj_vport_list))
+			continue;
+
+		bfad_kobj = kzalloc(sizeof(struct bfad_kobj_s),
GFP_KERNEL);
+		if (!bfad_kobj)
+			return snprintf(buf, PAGE_SIZE, "memory
sqeeze\n");
+
+		sprintf(kobj_name, "rp-");
+		bfad_sysfs_print_pwwn(rports[i], &kobj_name[3]);
+
+		bfad_kobj->type = KOBJ_TYPE_RPORT;
+		bfad_kobj->inst = bfad->inst_no;
+		bfad_kobj->vf_id = vf_id;
+		bfad_kobj->rport_id = rports[i];
+		bfad_kobj->vport_id = vpwwn;
+		bfad_kobj->pwwn = pwwn;
+
+		bfad_kobj->kobj =
+			kobject_create_and_add(kobj_name,
bfad->lport_kobj);
+		if (!bfad_kobj->kobj)
+			return snprintf(buf, PAGE_SIZE,
+					"failed to register rport
kobj\n");
+
+		retval = sysfs_create_group(bfad_kobj->kobj,
&rport_attr_group);
+		if (retval) {
+			kobject_put(bfad_kobj->kobj);
+			kfree(bfad_kobj);
+			return snprintf(buf, PAGE_SIZE,
+					"failed to create
rport_attr\n");
+		}
+
+		retval = sysfs_create_group(bfad_kobj->kobj,
+					    &rport_stats_group);
+		if (retval) {
+			kobject_put(bfad_kobj->kobj);
+			kfree(bfad_kobj);
+			return snprintf(buf, PAGE_SIZE,
+					"failed to create
rport_stats\n");
+		}
+
+		list_add_tail(&bfad_kobj->kobj_list_entry,
kobj_vport_list);
+
+		parent_kobj = bfad_kobj->kobj;
+
+		/*
+		 * Create itinm node here
+		 */
+		bfad_kobj = kzalloc(sizeof(struct bfad_kobj_s),
GFP_KERNEL);
+		if (!bfad_kobj)
+			return snprintf(buf, PAGE_SIZE, "memory
sqeeze\n");
+
+		sprintf(kobj_name, "itnim");
+		bfad_kobj->type = KOBJ_TYPE_ITNIM;
+		bfad_kobj->inst = bfad->inst_no;
+		bfad_kobj->vf_id = vf_id;
+		bfad_kobj->rport_id = rports[i];
+		bfad_kobj->vport_id = vpwwn;
+		bfad_kobj->pwwn = pwwn;
+
+		bfad_kobj->kobj =
+			kobject_create_and_add(kobj_name, parent_kobj);
+		if (!bfad_kobj->kobj) {
+			return snprintf(buf, PAGE_SIZE,
+					"failed to register itnim
kobj\n");
+		}
+
+		retval = sysfs_create_group(bfad_kobj->kobj,
&itnim_attr_group);
+		if (retval) {
+			kobject_put(bfad_kobj->kobj);
+			kfree(bfad_kobj);
+			return snprintf(buf, PAGE_SIZE,
+					"failed to create
itnim_attr\n");
+		}
+
+		retval = sysfs_create_group(bfad_kobj->kobj,
+					    &itnim_stats_group);
+		if (retval) {
+			kobject_put(bfad_kobj->kobj);
+			kfree(bfad_kobj);
+			return snprintf(buf, PAGE_SIZE,
+					"failed to create
itnim_stats\n");
+		}
+
+		list_add_tail(&bfad_kobj->kobj_list_entry,
kobj_vport_list);
+	}
+
+	/*
+	 * Remove deleted rports
+	 */
+	bfad_sysfs_remove_deleted_rports(fcs_port, pwwn, vf_id,
+					 kobj_vport_list);
+
+	kfree(rports);
+	return len;
+
+}
+
+static          ssize_t
+bfad_lport_attr_show(struct bfad_s *bfad, u16 vf_id, char *buf,
+			struct bfa_port_attr_s *attr,
+			struct kobj_attribute *sys_attr)
+{
+	int             len = 0;
+	unsigned long   flags;
+
+	if (strcmp(sys_attr->attr.name, "port_id") == 0) {
+		if (attr->pid)
+			len = snprintf(buf, PAGE_SIZE, "%06x\n",
+				       bfa_os_ntoh3b(attr->pid));
+		else
+			len = snprintf(buf, PAGE_SIZE, "--\n");
+	} else if (strcmp(sys_attr->attr.name, "state") == 0) {
+		if (attr->port_type != BFA_PPORT_TYPE_VPORT) {
+			struct bfa_pport_attr_s pp_attr;
+			struct bfa_port_attr_s port_attr;
+
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
+			bfa_pport_get_attr(&bfad->bfa, &pp_attr);
+
bfa_fcs_port_get_attr(&bfad->bfa_fcs.fabric.bport,
+					      &port_attr);
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+			if (pp_attr.topology != BFA_PPORT_TOPOLOGY_NONE)
+				pp_attr.pid = port_attr.pid;
+			else
+				pp_attr.pid = 0;
+
+			pp_attr.port_type = port_attr.port_type;
+
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
+
bfad_sysfs_state_to_string(pp_attr.
+							port_state,
+
port_state_table));
+		} else {
+			struct bfa_fcs_vport_s *fcs_vport;
+			struct bfa_vport_attr_s vp_attr;
+
+			spin_lock_irqsave(&bfad->bfad_lock, flags);
+			fcs_vport =
+				bfa_fcs_vport_lookup(&bfad->bfa_fcs,
vf_id,
+
attr->port_cfg.pwwn);
+			if (fcs_vport == NULL) {
+				spin_unlock_irqrestore(&bfad->bfad_lock,
flags);
+				len = snprintf(buf, PAGE_SIZE,
+					       "Could not find
fcs_vport\n");
+				return len;
+			}
+
+			bfa_fcs_vport_get_attr(fcs_vport, &vp_attr);
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
+
bfad_sysfs_state_to_string(vp_attr.
+							vport_state,
+
vport_state_table));
+		}
+	} else if (strcmp(sys_attr->attr.name, "type") == 0) {
+		len = snprintf(buf, PAGE_SIZE, "Base Port\n");
+	} else if (strcmp(sys_attr->attr.name, "pwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(attr->port_cfg.pwwn, buf,
len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+	} else if (strcmp(sys_attr->attr.name, "nwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(attr->port_cfg.nwwn, buf,
len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+	} else if (strcmp(sys_attr->attr.name, "symbolic_name") == 0) {
+		len = snprintf(buf, PAGE_SIZE, "%s\n",
+			       attr->port_cfg.sym_name.symname);
+	} else if (strcmp(sys_attr->attr.name, "role") == 0) {
+		switch (attr->port_cfg.roles) {
+		case BFA_PORT_ROLE_FCP_IM:
+			len = snprintf(buf, PAGE_SIZE, "FCP
Initiator\n");
+			break;
+		case BFA_PORT_ROLE_FCP_TM:
+			len = snprintf(buf, PAGE_SIZE, "FCP Target\n");
+			break;
+		case BFA_PORT_ROLE_FCP_IPFC:
+			len = snprintf(buf, PAGE_SIZE, "IP over FC\n");
+			break;
+		default:
+			len = snprintf(buf, PAGE_SIZE, "Unknown: %d\n",
+				       attr->port_cfg.roles);
+			break;
+		}
+	}
+
+	return len;
+}
+
+static          ssize_t
+bfad_lport_stats_show(struct kobject *kobj, struct kobj_attribute
*sys_attr,
+		      char *buf)
+{
+	int             ioc_inst = 1;
+	int             vf_id = 0;
+	struct bfad_s  *bfad;
+	wwn_t           pwwn, rp;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_port_stats_s stats;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &pwwn,
&rp);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, pwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "failed to locate
lport\n");
+	}
+
+	bfa_fcs_port_get_stats(fcs_port, &stats);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "ns_plogi_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_plogi_sent);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_plogi_accepts);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_rsp_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_plogi_rsp_err);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_acc_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_plogi_acc_err);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_rejects") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rejects);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_unknown_rsp") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_plogi_unknown_rsp);
+	else if (strcmp(sys_attr->attr.name, "ns_plogi_alloc_wait") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_plogi_alloc_wait);
+	else if (strcmp(sys_attr->attr.name, "ns_rspnid_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rspnid_sent);
+	else if (strcmp(sys_attr->attr.name, "ns_rspnid_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_rspnid_accepts);
+	else if (strcmp(sys_attr->attr.name, "ns_rspnid_rsp_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_rspnid_rsp_err);
+	else if (strcmp(sys_attr->attr.name, "ns_rspnid_rejects") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_rspnid_rejects);
+	else if (strcmp(sys_attr->attr.name, "ns_rspnid_alloc_wait") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_rspnid_alloc_wait);
+	else if (strcmp(sys_attr->attr.name, "ns_rftid_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rftid_sent);
+	else if (strcmp(sys_attr->attr.name, "ns_rftid_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rftid_accepts);
+	else if (strcmp(sys_attr->attr.name, "ns_rftid_rsp_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rftid_rsp_err);
+	else if (strcmp(sys_attr->attr.name, "ns_rftid_rejects") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_rftid_rejects);
+	else if (strcmp(sys_attr->attr.name, "ns_rftid_alloc_wait") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_rftid_alloc_wait);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_sent") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_gidft_sent);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_accepts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_gidft_accepts);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_rsp_err") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_gidft_rsp_err);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_rejects") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_gidft_rejects);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_unknown_rsp") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_gidft_unknown_rsp);
+	else if (strcmp(sys_attr->attr.name, "ns_gidft_alloc_wait") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.ns_gidft_alloc_wait);
+
+	else if (strcmp(sys_attr->attr.name, "ns_timeouts") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_timeouts);
+	else if (strcmp(sys_attr->attr.name, "ns_retries") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.ns_retries);
+	else if (strcmp(sys_attr->attr.name, "num_rscn") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n", stats.num_rscn);
+	else if (strcmp(sys_attr->attr.name, "num_portid_rscn") == 0)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
stats.num_portid_rscn);
+	else
+		return 0;
+}
+
+/**
+ * @brief Function to display LPORT attributes/statistics
+ * @param[in] kobj  - kobject of the LPORT directory
+ * @param[in] buf   - Buffer to be filled in with attributes/statistics
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_sysfs_lport_show(struct kobject *kobj, struct kobj_attribute
*attr,
+		      char *buf)
+{
+	int             ioc_inst = 1, len = 0;
+	struct bfad_s  *bfad;
+	int             vf_id = 0;
+	wwn_t           pwwn, rp;
+	struct bfa_fcs_port_s *fcs_port;
+	struct bfa_port_attr_s pattr;
+	unsigned long   flags;
+
+	bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id, &pwwn,
&rp);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id, pwwn);
+	if (fcs_port == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return snprintf(buf, PAGE_SIZE, "failed to locate
lport\n");
+	}
+
+	if (strcmp(attr->attr.name, "refresh_rports") == 0) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		len = bfad_rport_main_show_list(bfad, kobj, vf_id, pwwn,
0,
+						buf);
+	} else {
+		bfa_fcs_port_get_attr(fcs_port, &pattr);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		len = bfad_lport_attr_show(bfad, vf_id, buf, &pattr,
attr);
+	}
+
+	return len;
+}
+
+static          ssize_t
+bfad_sysfs_lport_store(struct kobject *kobj, struct kobj_attribute
*attr,
+		       const char *buf, size_t count)
+{
+	int             ioc_inst = 1;
+	struct bfad_s  *bfad;
+	int             vf_id = 0;
+	wwn_t           pwwn, rpwwn;
+	struct bfa_fcs_port_s *fcs_port;
+	unsigned long   flags;
+
+	if (strcmp(attr->attr.name, "reset") == 0) {
+		bfad = bfad_sysfs_get_param(kobj, &ioc_inst, &vf_id,
&pwwn,
+					    &rpwwn);
+		if (bfad == NULL)
+			return -EINVAL;
+
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		fcs_port = bfa_fcs_lookup_port(&bfad->bfa_fcs, vf_id,
pwwn);
+		if (fcs_port == NULL) {
+			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+			return -EINVAL;
+		}
+
+		bfa_fcs_port_clear_stats(fcs_port);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	}
+
+	return count;
+}
+
+static struct kobj_attribute lport_pwwn_attribute =
+__ATTR(pwwn, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_nwwn_attribute =
+__ATTR(nwwn, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_port_id_attribute =
+__ATTR(port_id, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_type_attribute =
+__ATTR(type, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_state_attribute =
+__ATTR(state, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_symbolic_name_attribute =
+__ATTR(symbolic_name, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_role_attribute =
+__ATTR(role, 0444, bfad_sysfs_lport_show, NULL);
+static struct kobj_attribute lport_refresh_rports_attribute =
+__ATTR(refresh_rports, 0444, bfad_sysfs_lport_show, NULL);
+
+static struct kobj_attribute lport_stats_ns_plogi_sent_attribute =
+__ATTR(ns_plogi_sent, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_accepts_attribute =
+__ATTR(ns_plogi_accepts, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_rsp_err_attribute =
+__ATTR(ns_plogi_rsp_err, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_acc_err_attribute =
+__ATTR(ns_plogi_acc_err, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_rejects_attribute =
+__ATTR(ns_plogi_rejects, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_unknown_rsp_attribute
=
+__ATTR(ns_plogi_unknown_rsp, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_plogi_alloc_wait_attribute
=
+__ATTR(ns_plogi_alloc_wait, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_ns_rspnid_sent_attribute =
+__ATTR(ns_rspnid_sent, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rspnid_accepts_attribute =
+__ATTR(ns_rspnid_accepts, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rspnid_rsp_err_attribute =
+__ATTR(ns_rspnid_rsp_err, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rspnid_rejects_attribute =
+__ATTR(ns_rspnid_rejects, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rspnid_alloc_wait_attribute
=
+__ATTR(ns_rspnid_alloc_wait, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_ns_rftid_sent_attribute =
+__ATTR(ns_rftid_sent, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rftid_accepts_attribute =
+__ATTR(ns_rftid_accepts, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rftid_rsp_err_attribute =
+__ATTR(ns_rftid_rsp_err, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rftid_rejects_attribute =
+__ATTR(ns_rftid_rejects, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_rftid_alloc_wait_attribute
=
+__ATTR(ns_rftid_alloc_wait, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_ns_gidft_sent_attribute =
+__ATTR(ns_gidft_sent, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_gidft_accepts_attribute =
+__ATTR(ns_gidft_accepts, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_gidft_rsp_err_attribute =
+__ATTR(ns_gidft_rsp_err, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_gidft_rejects_attribute =
+__ATTR(ns_gidft_rejects, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_gidft_unknown_rsp_attribute
=
+__ATTR(ns_gidft_unknown_rsp, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_gidft_alloc_wait_attribute
=
+__ATTR(ns_gidft_alloc_wait, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_ns_timeouts_attribute =
+__ATTR(ns_timeouts, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_ns_retries_attribute =
+__ATTR(ns_retries, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_num_rscn_attribute =
+__ATTR(num_rscn, 0444, bfad_lport_stats_show, NULL);
+static struct kobj_attribute lport_stats_num_portid_rscn_attribute =
+__ATTR(num_portid_rscn, 0444, bfad_lport_stats_show, NULL);
+
+static struct kobj_attribute lport_stats_reset_attribute =
+__ATTR(reset, 0200, NULL, bfad_sysfs_lport_store);
+
+static struct attribute *lport_attrs[] = {
+	&lport_pwwn_attribute.attr,
+	&lport_nwwn_attribute.attr,
+	&lport_port_id_attribute.attr,
+	&lport_type_attribute.attr,
+	&lport_state_attribute.attr,
+	&lport_symbolic_name_attribute.attr,
+	&lport_role_attribute.attr,
+	&lport_refresh_rports_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group lport_attr_group = {
+	.attrs = lport_attrs,
+};
+
+static struct attribute *lport_stats[] = {
+	&lport_stats_ns_plogi_sent_attribute.attr,
+	&lport_stats_ns_plogi_accepts_attribute.attr,
+	&lport_stats_ns_plogi_rsp_err_attribute.attr,
+	&lport_stats_ns_plogi_acc_err_attribute.attr,
+	&lport_stats_ns_plogi_rejects_attribute.attr,
+	&lport_stats_ns_plogi_unknown_rsp_attribute.attr,
+	&lport_stats_ns_plogi_alloc_wait_attribute.attr,
+
+	&lport_stats_ns_rspnid_sent_attribute.attr,
+	&lport_stats_ns_rspnid_accepts_attribute.attr,
+	&lport_stats_ns_rspnid_rsp_err_attribute.attr,
+	&lport_stats_ns_rspnid_rejects_attribute.attr,
+	&lport_stats_ns_rspnid_alloc_wait_attribute.attr,
+
+	&lport_stats_ns_rftid_sent_attribute.attr,
+	&lport_stats_ns_rftid_accepts_attribute.attr,
+	&lport_stats_ns_rftid_rsp_err_attribute.attr,
+	&lport_stats_ns_rftid_rejects_attribute.attr,
+	&lport_stats_ns_rftid_alloc_wait_attribute.attr,
+
+	&lport_stats_ns_gidft_sent_attribute.attr,
+	&lport_stats_ns_gidft_accepts_attribute.attr,
+	&lport_stats_ns_gidft_rsp_err_attribute.attr,
+	&lport_stats_ns_gidft_rejects_attribute.attr,
+	&lport_stats_ns_gidft_unknown_rsp_attribute.attr,
+	&lport_stats_ns_gidft_alloc_wait_attribute.attr,
+
+	&lport_stats_ns_timeouts_attribute.attr,
+	&lport_stats_ns_retries_attribute.attr,
+
+	&lport_stats_num_rscn_attribute.attr,
+	&lport_stats_num_portid_rscn_attribute.attr,
+
+	&lport_stats_reset_attribute.attr,
+
+	NULL,
+};
+
+static struct attribute_group lport_stats_group = {
+	.attrs = lport_stats,
+	.name = "statistics",
+};
+
+/**
+ * @brief Function to display physical port status
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_pport_enable_show(struct bfad_s *bfad, char *buf)
+{
+	int             len = 0;
+
+	return len;
+}
+
+/**
+ * @brief Function to enable/disable physical port
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer contains user input
+ * @retval - 0 on SUCCESS
+ * @retval - negative value on FAILURE
+ */
+static          ssize_t
+bfad_pport_enable_store(struct bfad_s *bfad, const char *buf)
+{
+	unsigned long   flags;
+	if (strncmp("enable", buf, strlen(buf) - 1) == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_enable(&bfad->bfa);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	} else if (strncmp("disable", buf, strlen(buf) - 1) == 0) {
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		bfa_pport_disable(&bfad->bfa);
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	} else
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * @brief Function to display physical port attribute values
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_pport_attr_show(struct bfad_s *bfad, char *buf,
+		     struct kobj_attribute *sys_attr)
+{
+	int             len = 0;
+	struct bfa_pport_attr_s pattr;
+	struct bfa_port_attr_s attr;
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_pport_get_attr(&bfad->bfa, &pattr);
+	bfa_fcs_port_get_attr(&bfad->bfa_fcs.fabric.bport, &attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	pattr.port_type = attr.port_type;
+
+	if (strcmp(sys_attr->attr.name, "pwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(pattr.pwwn, buf, len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "nwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(pattr.nwwn, buf, len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "port_id") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%06x\n",
+				bfa_os_ntoh3b(attr.pid));
+	} else if (strcmp(sys_attr->attr.name, "media") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n", "sw");
+	} else if (strcmp(sys_attr->attr.name, "state") == 0) {
+		if (pattr.port_state >= BFA_PPORT_ST_UNINIT
+		    && pattr.port_state <= BFA_PPORT_ST_MAX_STATE)
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
+
bfad_sysfs_state_to_string(pattr.
+							port_state,
+
port_state_table));
+		else
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"invalid");
+
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "port_type") == 0) {
+		switch (pattr.port_type) {
+		case BFA_PPORT_TYPE_UNKNOWN:
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"unknown");
+			break;
+		case BFA_PPORT_TYPE_TRUNKED:
+			len = snprintf(buf, PAGE_SIZE - len, "%s\n",
"trunked");
+			break;
+		case BFA_PPORT_TYPE_NPORT:
+			len = snprintf(buf, PAGE_SIZE, "%s\n", "nport");
+			break;
+		case BFA_PPORT_TYPE_NLPORT:
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"nlport");
+		case BFA_PPORT_TYPE_LPORT:
+			len = snprintf(buf, PAGE_SIZE, "%s\n", "lport");
+			break;
+		case BFA_PPORT_TYPE_P2P:
+			len = snprintf(buf, PAGE_SIZE, "%s\n", "p2p");
+			break;
+		case BFA_PPORT_TYPE_VPORT:
+			len = snprintf(buf, PAGE_SIZE, "%s\n", "vport");
+			break;
+		default:
+			len = snprintf(buf, PAGE_SIZE, "%s(%d)\n",
"invalid",
+				       pattr.port_type);
+			break;
+		}
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "supported_classes") ==
0) {
+		switch (pattr.cos_supported) {
+		case FC_CLASS_2:
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"FC_CLASS_2");
+			break;
+		case FC_CLASS_3:
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"FC_CLASS_3");
+			break;
+		case FC_CLASS_2_3:
+			len = snprintf(buf, PAGE_SIZE, "%s\n",
"FC_CLASS_3");
+			break;
+		default:
+			len = snprintf(buf, PAGE_SIZE, "%s\n", "--");
+			break;
+		}
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "symbolic_name") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				pattr.port_symname.symname);
+	} else if (strcmp(sys_attr->attr.name, "recv_bb_credits") == 0)
{
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				pattr.pport_cfg.rx_bbcredit);
+	} else {
+		return 0;
+	}
+}
+
+static void
+bfad_sysfs_hcb_comp(void *arg, bfa_status_t status)
+{
+	struct bfad_hal_comp *fcomp = (struct bfad_hal_comp *)arg;
+
+	fcomp->status = status;
+	complete(&fcomp->comp);
+}
+
+/**
+ * @brief Function to display physical port statistics
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_pport_stats_show(struct kobject *kobj, struct kobj_attribute
*sys_attr,
+		      char *buf)
+{
+	struct bfa_pport_stats_s stats;
+	bfa_status_t    status;
+	struct bfad_hal_comp fcomp;
+	unsigned long   flags;
+	struct bfad_s  *bfad;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "Error finding bfad\n");
+
+	memset(&stats, 0, sizeof(struct bfa_pport_stats_s));
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_pport_get_stats(&bfad->bfa, &stats,
bfad_sysfs_hcb_comp,
+				     &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (status != BFA_STATUS_OK)
+		return snprintf(buf, PAGE_SIZE, "failed to get
stats\n");
+
+	wait_for_completion(&fcomp.comp);
+
+	if (strcmp(sys_attr->attr.name, "secs_since_reset") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.secs_since_reset);
+	else if (strcmp(sys_attr->attr.name, "tx_frames") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.tx_frames);
+	else if (strcmp(sys_attr->attr.name, "tx_words") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.tx_words);
+	else if (strcmp(sys_attr->attr.name, "rx_frames") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.rx_frames);
+	else if (strcmp(sys_attr->attr.name, "rx_words") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.rx_words);
+	else if (strcmp(sys_attr->attr.name, "lip_count") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.lip_count);
+	else if (strcmp(sys_attr->attr.name, "nos_count") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.nos_count);
+	else if (strcmp(sys_attr->attr.name, "error_frames") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.error_frames);
+	else if (strcmp(sys_attr->attr.name, "dropped_frames") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.dropped_frames);
+	else if (strcmp(sys_attr->attr.name, "link_failures") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.link_failures);
+	else if (strcmp(sys_attr->attr.name, "loss_of_syncs") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.loss_of_syncs);
+	else if (strcmp(sys_attr->attr.name, "loss_of_signals") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.loss_of_signals);
+	else if (strcmp(sys_attr->attr.name, "primitive_seq_errs") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.primseq_errs);
+	else if (strcmp(sys_attr->attr.name, "invalid_ordered_set") ==
0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.bad_os_count);
+	else if (strcmp(sys_attr->attr.name, "invalid_crcs") == 0)
+		return snprintf(buf, PAGE_SIZE, "%lld\n",
+				(long long)stats.invalid_crcs);
+	else
+		return 0;
+}
+
+/**
+ * @brief Function to clear physical port statistics
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer contains user input
+ * @retval - 0 on SUCCESS
+ */
+static          ssize_t
+bfad_pport_stats_store(struct bfad_s *bfad, const char *buf)
+{
+	struct bfad_hal_comp fcomp;
+	unsigned long   flags;
+	bfa_status_t    status;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_pport_clear_stats(&bfad->bfa, bfad_sysfs_hcb_comp,
&fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	wait_for_completion(&fcomp.comp);
+
+	return 0;
+}
+
+/**
+ * @brief Function to display physical port topology
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_pport_topo_show(struct bfad_s *bfad, char *buf,
+		     struct kobj_attribute *sys_attr)
+{
+	enum bfa_pport_topology topology;
+	struct bfa_pport_attr_s attr;
+	unsigned long   flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "topology_current") == 0) {
+		topology = attr.topology;
+	} else if (strcmp(sys_attr->attr.name, "topology_config") == 0)
{
+		topology = attr.pport_cfg.topology;
+	} else {
+		return 0;
+	}
+
+	if (topology == BFA_PPORT_TOPOLOGY_P2P) {
+		return snprintf(buf, PAGE_SIZE, "p2p\n");
+	} else if (topology == BFA_PPORT_TOPOLOGY_LOOP) {
+		return snprintf(buf, PAGE_SIZE, "loop\n");
+	} else if (topology == BFA_PPORT_TOPOLOGY_AUTO) {
+		return snprintf(buf, PAGE_SIZE, "auto\n");
+	} else {
+		return snprintf(buf, PAGE_SIZE, "invalid (%d)\n",
topology);
+	}
+}
+
+/**
+ * @brief Function to change physical port topology
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer contains user input
+ * @retval - 0 on SUCCESS
+ * @retval - negative value on FAILURE
+ */
+static          ssize_t
+bfad_pport_topo_store(struct bfad_s *bfad, const char *buf)
+{
+	bfa_status_t    status;
+	enum bfa_pport_topology topo;
+	unsigned long   flags;
+
+	if (strncmp("p2p", buf, strlen(buf) - 1) == 0)
+		topo = BFA_PPORT_TOPOLOGY_P2P;
+	else if (strncmp("loop", buf, strlen(buf) - 1) == 0)
+		topo = BFA_PPORT_TOPOLOGY_LOOP;
+	else if (strncmp("auto", buf, strlen(buf) - 1) == 0)
+		topo = BFA_PPORT_TOPOLOGY_AUTO;
+	else
+		topo = BFA_PPORT_TOPOLOGY_NONE;
+
+	if (topo == BFA_PPORT_TOPOLOGY_NONE)
+		return -EIO;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_pport_cfg_topology(&bfad->bfa, topo);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	return 0;
+}
+
+static char    *
+bfad_get_speed_str(int speed)
+{
+	static struct bfa_state port_spd[] = {
+		{BFA_PPORT_SPEED_UNKNOWN, "---"},
+		{BFA_PPORT_SPEED_1GBPS, "1G "},
+		{BFA_PPORT_SPEED_2GBPS, "2G "},
+		{BFA_PPORT_SPEED_4GBPS, "4G "},
+		{BFA_PPORT_SPEED_8GBPS, "8G "},
+		{BFA_PPORT_SPEED_AUTO, "auto"},
+	};
+	int             j = 0;
+
+	while (port_spd[j].code <= BFA_PPORT_SPEED_AUTO) {
+		if (port_spd[j].code == speed)
+			return port_spd[j].str;
+		j++;
+	}
+
+	return "Invalid";
+}
+
+/**
+ * @brief Function to display physical port speed
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_pport_speed_show(struct bfad_s *bfad, char *buf,
+		      struct kobj_attribute *sys_attr)
+{
+	struct bfa_pport_attr_s attr;
+	unsigned long   flags;
+	int             speed;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_pport_get_attr(&bfad->bfa, &attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (strcmp(sys_attr->attr.name, "speed_current") == 0) {
+		speed = attr.speed;
+	} else if (strcmp(sys_attr->attr.name, "speed_config") == 0) {
+		speed = attr.pport_cfg.speed;
+	} else {
+		return 0;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
bfad_get_speed_str(speed));
+}
+
+/**
+ * @brief Function to change physical port speed
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer contains user input
+ * @retval - 0 on SUCCESS
+ * @retval - negative value on FAILURE
+ */
+static          ssize_t
+bfad_pport_speed_store(struct bfad_s *bfad, const char *buf)
+{
+	bfa_status_t    status;
+	enum bfa_pport_speed speed;
+	unsigned long   flags;
+
+	if (strncmp("1gbps", buf, strlen(buf) - 1) == 0) {
+		speed = BFA_PPORT_SPEED_1GBPS;
+	} else if (strncmp("2gbps", buf, strlen(buf) - 1) == 0) {
+		speed = BFA_PPORT_SPEED_2GBPS;
+	} else if (strncmp("4gbps", buf, strlen(buf) - 1) == 0) {
+		speed = BFA_PPORT_SPEED_4GBPS;
+	} else if (strncmp("8gbps", buf, strlen(buf) - 1) == 0) {
+		speed = BFA_PPORT_SPEED_8GBPS;
+	} else if (strncmp("auto", buf, strlen(buf) - 1) == 0) {
+		speed = BFA_PPORT_SPEED_AUTO;
+	} else
+		return -EIO;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_pport_cfg_speed(&bfad->bfa, speed);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * @brief Function to show physical port maxfrm
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in the function
+ * @retval - number of bytes of 'buf' filled
+ */
+static          ssize_t
+bfad_pport_maxfrm_show(struct bfad_s *bfad, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			bfa_pport_get_maxfrsize(&bfad->bfa));
+}
+
+/**
+ * @brief Function to change physical port maxfrm value
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer contains user input
+ * @retval - 0 on SUCCESS
+ * @retval - negative value on FAILURE
+ */
+static          ssize_t
+bfad_pport_maxfrm_store(struct bfad_s *bfad, const char *buf)
+{
+	int             maxfrsize;
+	unsigned long   flags;
+
+	sscanf(buf, "%d", &maxfrsize);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (bfa_pport_cfg_maxfrsize(&bfad->bfa, (u16) maxfrsize)
+	    != BFA_STATUS_OK) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return -EIO;
+	}
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return 0;
+}
+
+/**
+ * @brief Function to show physical ports parameters
+ * @param[in] kobj - kobject of the (vport) directory
+ * @param[in] attr - Attributes of the directory
+ * @param[out] buf - Buffer to be returned with (attribute/statistic)
values
+ * @retval - size of the 'buf' filled
+ */
+static          ssize_t
+bfad_sysfs_pport_show(struct kobject *kobj, struct kobj_attribute
*attr,
+		      char *buf)
+{
+	struct bfad_s  *bfad;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	if (strcmp(attr->attr.name, "enable") == 0) {
+		return bfad_pport_enable_show(bfad, buf);
+	} else if (strncmp(attr->attr.name, "topology_", 9) == 0) {
+		return bfad_pport_topo_show(bfad, buf, attr);
+	} else if (strncmp(attr->attr.name, "speed_", 6) == 0) {
+		return bfad_pport_speed_show(bfad, buf, attr);
+	} else if (strcmp(attr->attr.name, "maxfrm") == 0) {
+		return bfad_pport_maxfrm_show(bfad, buf);
+	} else {
+		return bfad_pport_attr_show(bfad, buf, attr);
+	}
+}
+
+/**
+ * @brief Function to change physical port parameters e.g.
speed/topology etc.
+ * @param[in] kobj  - kobject of the (port) directory
<ROOT/INST/bfa/port>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer contains user input
+ * @param[in] count - Number of bytes in 'buf'
+ * @retval count - Number of bytes of 'buf' used in the function
+ */
+static          ssize_t
+bfad_sysfs_pport_store(struct kobject *kobj, struct kobj_attribute
*attr,
+		       const char *buf, size_t count)
+{
+	struct bfad_s  *bfad;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	if (strcmp(attr->attr.name, "enable") == 0) {
+		bfad_pport_enable_store(bfad, buf);
+	} else if (strcmp(attr->attr.name, "reset") == 0) {
+		bfad_pport_stats_store(bfad, buf);
+	} else if (strcmp(attr->attr.name, "topo_config") == 0) {
+		bfad_pport_topo_store(bfad, buf);
+	} else if (strcmp(attr->attr.name, "speed_config") == 0) {
+		bfad_pport_speed_store(bfad, buf);
+	} else if (strcmp(attr->attr.name, "maxfrm") == 0) {
+		bfad_pport_maxfrm_store(bfad, buf);
+	}
+
+	return count;
+}
+
+static struct kobj_attribute pport_enable_attribute =
+__ATTR(enable, 0644, bfad_sysfs_pport_show, bfad_sysfs_pport_store);
+static struct kobj_attribute pport_pwwn_attribute =
+__ATTR(pwwn, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_nwwn_attribute =
+__ATTR(nwwn, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_port_id_attribute =
+__ATTR(port_id, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_media_attribute =
+__ATTR(media, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_state_attribute =
+__ATTR(state, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_type_attribute =
+__ATTR(port_type, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_supported_classes_attribute =
+__ATTR(supported_classes, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_symbolic_name_attribute =
+__ATTR(symbolic_name, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_recv_bb_credits_attribute =
+__ATTR(recv_bb_credits, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_topo_cur_attribute =
+__ATTR(topology_current, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_topo_config_attribute =
+__ATTR(topology_config, 0644, bfad_sysfs_pport_show,
+       bfad_sysfs_pport_store);
+static struct kobj_attribute pport_speed_cur_attribute =
+__ATTR(speed_current, 0444, bfad_sysfs_pport_show, NULL);
+static struct kobj_attribute pport_speed_config_attribute =
+__ATTR(speed_config, 0644, bfad_sysfs_pport_show,
+       bfad_sysfs_pport_store);
+static struct kobj_attribute pport_maxfrm_attribute =
+__ATTR(maxfrm, 0644, bfad_sysfs_pport_show, bfad_sysfs_pport_store);
+
+static struct kobj_attribute pport_stats_secs_since_reset_attribute =
+__ATTR(secs_since_reset, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_tx_frames_attribute =
+__ATTR(tx_frames, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_tx_words_attribute =
+__ATTR(tx_words, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_rx_frames_attribute =
+__ATTR(rx_frames, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_rx_words_attribute =
+__ATTR(rx_words, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_lips_attribute =
+__ATTR(lip_count, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_noss_attribute =
+__ATTR(nos_count, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_err_frames_attribute =
+__ATTR(error_frames, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_dropped_frames_attribute =
+__ATTR(dropped_frames, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_link_failures_attribute =
+__ATTR(link_failures, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_loss_of_syncs_attribute =
+__ATTR(loss_of_syncs, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_loss_of_sigs_attribute =
+__ATTR(loss_of_signals, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_prim_seq_errs_attribute =
+__ATTR(primitive_seq_errs, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_invalid_ordered_set_attribute
=
+__ATTR(invalid_ordered_set, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_invalid_crcs_attribute =
+__ATTR(invalid_crcs, 0444, bfad_pport_stats_show, NULL);
+static struct kobj_attribute pport_stats_reset_attribute =
+__ATTR(reset, 0200, NULL, bfad_sysfs_pport_store);
+
+static struct attribute *pport_attrs[] = {
+	&pport_enable_attribute.attr,
+	&pport_pwwn_attribute.attr,
+	&pport_nwwn_attribute.attr,
+	&pport_port_id_attribute.attr,
+	&pport_media_attribute.attr,
+	&pport_state_attribute.attr,
+	&pport_type_attribute.attr,
+	&pport_supported_classes_attribute.attr,
+	&pport_symbolic_name_attribute.attr,
+	&pport_recv_bb_credits_attribute.attr,
+	&pport_topo_cur_attribute.attr,
+	&pport_topo_config_attribute.attr,
+	&pport_speed_cur_attribute.attr,
+	&pport_speed_config_attribute.attr,
+	&pport_maxfrm_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group pport_attr_group = {
+	.attrs = pport_attrs,
+};
+
+static struct attribute *pport_stats[] = {
+	&pport_stats_secs_since_reset_attribute.attr,
+	&pport_stats_tx_frames_attribute.attr,
+	&pport_stats_tx_words_attribute.attr,
+	&pport_stats_rx_frames_attribute.attr,
+	&pport_stats_rx_words_attribute.attr,
+	&pport_stats_lips_attribute.attr,
+	&pport_stats_noss_attribute.attr,
+	&pport_stats_err_frames_attribute.attr,
+	&pport_stats_dropped_frames_attribute.attr,
+	&pport_stats_link_failures_attribute.attr,
+	&pport_stats_loss_of_syncs_attribute.attr,
+	&pport_stats_loss_of_sigs_attribute.attr,
+	&pport_stats_prim_seq_errs_attribute.attr,
+	&pport_stats_invalid_ordered_set_attribute.attr,
+	&pport_stats_invalid_crcs_attribute.attr,
+	&pport_stats_reset_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group pport_stats_group = {
+	.attrs = pport_stats,
+	.name = "statistics",
+};
+
+/**
+ * @brief Function to display IOC attributes
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_ioc_attr_show(struct bfad_s *bfad, char *buf,
+		   struct kobj_attribute *sys_attr)
+{
+	int             len = 0;
+	struct bfa_ioc_attr_s  attr;
+	struct bfa_pport_attr_s pattr;
+	unsigned long   flags;
+
+	memset(&attr, 0, sizeof(struct bfa_ioc_attr_s));
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfa_get_attr(&bfad->bfa, &attr);
+	bfa_pport_get_attr(&bfad->bfa, &pattr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	strcpy(attr.driver_attr.fw_ver, attr.adapter_attr.fw_ver);
+
+	memcpy(&attr.pci_attr, &bfad->pci_attr,
+			sizeof(struct bfa_ioc_pci_attr_s));
+
+	if (strcmp(sys_attr->attr.name, "chip_rev") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.pci_attr.chip_rev);
+	} else if (strcmp(sys_attr->attr.name, "manufacturer") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.adapter_attr.manufacturer);
+	} else if (strcmp(sys_attr->attr.name, "serial_num") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.adapter_attr.serial_num);
+	} else if (strcmp(sys_attr->attr.name, "model_desc") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.adapter_attr.model_descr);
+	} else if (strcmp(sys_attr->attr.name, "pwwn") == 0) {
+		len = bfad_sysfs_snprint_pwwn(pattr.pwwn, buf, 0);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "nwwn") == 0) {
+		len += bfad_sysfs_snprint_pwwn(pattr.nwwn, buf, len);
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		return len;
+	} else if (strcmp(sys_attr->attr.name, "hw_ver") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.adapter_attr.hw_ver);
+	} else if (strcmp(sys_attr->attr.name, "fw_ver") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.driver_attr.fw_ver);
+	} else if (strcmp(sys_attr->attr.name, "optrom_ver") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.driver_attr.ob_ver);
+	} else if (strcmp(sys_attr->attr.name, "bios_ver") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n",
+				attr.driver_attr.bios_ver);
+	} else if (strcmp(sys_attr->attr.name, "port_count") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				attr.adapter_attr.nports);
+	} else if (strcmp(sys_attr->attr.name, "name") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n", "bfa");
+	} else if (strcmp(sys_attr->attr.name, "hw_name") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%s\n", bfad->pci_name);
+	} else {
+		return 0;
+	}
+}
+
+/**
+ * @brief Function to display IOC statistics
+ * @param[in] bfad  - IOC
+ * @param[in] buf   - Buffer to be filled in with attributes
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_ioc_stats_show(struct kobject *kobj, struct kobj_attribute *attr,
+		    char *buf)
+{
+	struct bfad_s  *bfad;
+	struct bfa_ioc_stats_s stats;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return snprintf(buf, PAGE_SIZE, "Error finding bfad\n");
+
+	bfa_ioc_get_stats(&bfad->bfa, &stats);
+
+	if (strcmp(attr->attr.name, "heartbeat_count") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.drv_stats.hb_count);
+	} else if (strcmp(attr->attr.name, "disable_requests") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.drv_stats.disable_reqs);
+	} else if (strcmp(attr->attr.name, "enable_requests") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.drv_stats.enable_reqs);
+	} else if (strcmp(attr->attr.name, "disable_replies") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.drv_stats.disable_replies);
+	} else if (strcmp(attr->attr.name, "enable_replies") == 0) {
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				stats.drv_stats.enable_replies);
+	} else {
+		return 0;
+	}
+}
+
+static          ssize_t
+bfad_ioc_stats_store(struct bfad_s *bfad, const char *buf)
+{
+	int             len = 0;
+	bfa_status_t    status;
+	unsigned long   flags;
+	struct bfad_hal_comp fcomp;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_iocfc_clear_stats(&bfad->bfa, bfad_sysfs_hcb_comp,
&fcomp);
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (status != BFA_STATUS_OK)
+		return -EINVAL;
+
+	wait_for_completion(&fcomp.comp);
+
+	return len;
+}
+
+static          ssize_t
+bfad_ioc_intr_show(struct bfad_s *bfad, char *buf)
+{
+	int             len = 0;
+
+	return len;
+}
+
+static          ssize_t
+bfad_ioc_intr_store(struct bfad_s *bfad, const char *buf, int latency,
+		    int delay)
+{
+	struct bfa_iocfc_intr_attr_s intr_attr;
+	bfa_status_t    status;
+	unsigned long   flags;
+
+	intr_attr.latency = latency;
+	intr_attr.delay = delay;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	status = bfa_iocfc_israttr_set(&bfad->bfa, &intr_attr);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (status != BFA_STATUS_OK)
+		return -EIO;
+
+	return 0;
+}
+
+static          ssize_t
+bfad_ioc_power_show(struct bfad_s *bfad, char *buf)
+{
+	int             len = 0;
+
+	return len;
+}
+
+static          ssize_t
+bfad_ioc_power_store(struct bfad_s *bfad, const char *buf)
+{
+	int             len = 0;
+
+	return len;
+}
+
+/**
+ * @brief Function to show IOC attributes
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer to be filled in.
+ * @retval - Number of bytes of 'buf' filled in.
+ */
+static          ssize_t
+bfad_sysfs_ioc_show(struct kobject *kobj, struct kobj_attribute *attr,
+		    char *buf)
+{
+	struct bfad_s  *bfad;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	if (strcmp(attr->attr.name, "intr") == 0) {
+		return bfad_ioc_intr_show(bfad, buf);
+	} else if (strcmp(attr->attr.name, "power") == 0) {
+		return bfad_ioc_power_show(bfad, buf);
+	} else {
+		return bfad_ioc_attr_show(bfad, buf, attr);
+	}
+}
+
+/**
+ * @brief Function to configure IOC attributes e.g.
power/stats/interrupt
+ * @param[in] kobj  - kobject of the 'ioc' directory
<ROOT/INST/bfa/ioc>
+ * @param[in] attr  - Attributes of the directory
+ * @param[in] buf   - Buffer contains user input
+ * @param[in] count - Number of bytes in 'buf'
+ * @retval count - Number of bytes of 'buf' used in the function
+ */
+static          ssize_t
+bfad_sysfs_ioc_store(struct kobject *kobj, struct kobj_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct bfad_s  *bfad;
+
+	bfad = bfad_find_bfad_by_kobj(kobj);
+	if (bfad == NULL)
+		return -EINVAL;
+
+	if (strncmp(attr->attr.name, "stats_reset", 6) == 0) {
+		bfad_ioc_stats_store(bfad, buf);
+	} else if (strcmp(attr->attr.name, "intr") == 0) {
+		int             delay = 100, latency = 100;	/* HACK
Alert
+								 **!! */
+		bfad_ioc_intr_store(bfad, buf, delay, latency);
+	} else if (strcmp(attr->attr.name, "power") == 0) {
+		bfad_ioc_power_store(bfad, buf);
+	}
+
+	return count;
+}
+
+static struct kobj_attribute chip_rev_attribute =
+__ATTR(chip_rev, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute manufacturer_attribute =
+__ATTR(manufacturer, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute serial_num_attribute =
+__ATTR(serial_num, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute model_desc_attribute =
+__ATTR(model_desc, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute pwwn_attribute =
+__ATTR(pwwn, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute nwwn_attribute =
+__ATTR(nwwn, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute hw_ver_attribute =
+__ATTR(hw_ver, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute fw_ver_attribute =
+__ATTR(fw_ver, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute optrom_ver_attribute =
+__ATTR(optrom_ver, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute bios_ver_attribute =
+__ATTR(bios_ver, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute port_count_attribute =
+__ATTR(port_count, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute name_attribute =
+__ATTR(name, 0444, bfad_sysfs_ioc_show, NULL);
+static struct kobj_attribute hw_name_attribute =
+__ATTR(hw_name, 0444, bfad_sysfs_ioc_show, NULL);
+
+static struct kobj_attribute ioc_intr_attribute =
+__ATTR(intr, 0644, bfad_sysfs_ioc_show, bfad_sysfs_ioc_store);
+static struct kobj_attribute ioc_power_attribute =
+__ATTR(power, 0644, bfad_sysfs_ioc_show, bfad_sysfs_ioc_store);
+
+static struct kobj_attribute ioc_stats_hb_count_attribute =
+__ATTR(heartbeat_count, 0444, bfad_ioc_stats_show, NULL);
+static struct kobj_attribute ioc_stats_disable_reqs_attribute =
+__ATTR(disable_requests, 0444, bfad_ioc_stats_show, NULL);
+static struct kobj_attribute ioc_stats_enable_reqs_attribute =
+__ATTR(enable_requests, 0444, bfad_ioc_stats_show, NULL);
+static struct kobj_attribute ioc_stats_disable_reps_attribute =
+__ATTR(disable_replies, 0444, bfad_ioc_stats_show, NULL);
+static struct kobj_attribute ioc_stats_enable_reps_attribute =
+__ATTR(enable_replies, 0444, bfad_ioc_stats_show, NULL);
+static struct kobj_attribute ioc_stats_reset_attribute =
+__ATTR(reset, 0200, NULL, bfad_sysfs_ioc_store);
+
+static struct attribute *ioc_attrs[] = {
+	&chip_rev_attribute.attr,
+	&manufacturer_attribute.attr,
+	&serial_num_attribute.attr,
+	&model_desc_attribute.attr,
+	&pwwn_attribute.attr,
+	&nwwn_attribute.attr,
+	&hw_ver_attribute.attr,
+	&fw_ver_attribute.attr,
+	&optrom_ver_attribute.attr,
+	&bios_ver_attribute.attr,
+	&port_count_attribute.attr,
+	&name_attribute.attr,
+	&hw_name_attribute.attr,
+	&ioc_intr_attribute.attr,
+	&ioc_power_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group ioc_attr_group = {
+	.attrs = ioc_attrs,
+};
+
+static struct attribute *ioc_stats[] = {
+	&ioc_stats_hb_count_attribute.attr,
+	&ioc_stats_disable_reqs_attribute.attr,
+	&ioc_stats_enable_reqs_attribute.attr,
+	&ioc_stats_disable_reps_attribute.attr,
+	&ioc_stats_enable_reps_attribute.attr,
+	&ioc_stats_reset_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group ioc_stats_group = {
+	.attrs = ioc_stats,
+	.name = "statistics",
+};
+
+/**
+ * @brief
+ * Create the device sysfs attribute for PCI function level control .
+ */
+void
+bfad_os_device_sysfs_create(struct bfad_s *bfad)
+{
+	int             retval;
+
+	/*
+	 * Create bfa sub-directory under the pci device
+	 */
+	bfad->bfa_kobj = kobject_create_and_add("bfa",
&bfad->pcidev->dev.kobj);
+	if (!bfad->bfa_kobj) {
+		printk(KERN_WARNING "failed to create bfa_kobj%d\n",
+		       bfad->inst_no);
+		return;
+	}
+
+	/*
+	 * Create ioc sub-directory under bfa
+	 */
+	bfad->ioc_kobj = kobject_create_and_add("ioc", bfad->bfa_kobj);
+	if (!bfad->ioc_kobj) {
+		printk(KERN_WARNING "failed to create ioc_kobj%d\n",
+		       bfad->inst_no);
+		goto out_ioc_kobj;
+	}
+
+	/*
+	 * Create ioc attribute files under ioc
+	 */
+	retval = sysfs_create_group(bfad->ioc_kobj, &ioc_attr_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create ioc_attr%d %d\n",
+		       bfad->inst_no, retval);
+		goto out_ioc_attr;
+	}
+
+	/*
+	 * Create ioc statistics under ioc
+	 */
+	retval = sysfs_create_group(bfad->ioc_kobj, &ioc_stats_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create ioc_stats%d %d\n",
+		       bfad->inst_no, retval);
+		goto out_ioc_attr;
+	}
+
+	/*
+	 * Create pport sub-directory under bfa
+	 */
+	bfad->pport_kobj = kobject_create_and_add("pport",
bfad->bfa_kobj);
+	if (!bfad->pport_kobj) {
+		printk(KERN_WARNING "failed to create pport_kobj%d\n",
+		       bfad->inst_no);
+		goto out_pport_kobj;
+	}
+
+	/*
+	 * Create pport attribute files under pport
+	 */
+	retval = sysfs_create_group(bfad->pport_kobj,
&pport_attr_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create pport_attr%d\n",
+		       bfad->inst_no);
+		goto out_pport_attr;
+	}
+
+	/*
+	 * Create pport statistics under pport
+	 */
+	retval = sysfs_create_group(bfad->pport_kobj,
&pport_stats_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create pport_stats%d
%d\n",
+		       bfad->inst_no, retval);
+		goto out_pport_attr;
+	}
+
+	/*
+	 * Create lport sub-directory under bfa
+	 */
+	bfad->lport_kobj = kobject_create_and_add("lport",
bfad->bfa_kobj);
+	if (!bfad->lport_kobj) {
+		printk(KERN_WARNING "failed to create lport_kobj%d\n",
+		       bfad->inst_no);
+		goto out_lport_kobj;
+	}
+
+	/*
+	 * Create lport attribute files under lport
+	 */
+	retval = sysfs_create_group(bfad->lport_kobj,
&lport_attr_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create lport_attr%d\n",
+		       bfad->inst_no);
+		goto out_lport_attr;
+	}
+
+	/*
+	 * Create lport statistics under lport
+	 */
+	retval = sysfs_create_group(bfad->lport_kobj,
&lport_stats_group);
+	if (retval) {
+		printk(KERN_WARNING "failed to create lport_stats%d
%d\n",
+		       bfad->inst_no, retval);
+		goto out_lport_attr;
+	}
+
+	return;
+
+out_lport_attr:
+	kobject_put(bfad->lport_kobj);
+	bfad->lport_kobj = NULL;
+out_lport_kobj:
+	sysfs_remove_group(bfad->pport_kobj, &pport_stats_group);
+out_pport_attr:
+	kobject_put(bfad->pport_kobj);
+	bfad->pport_kobj = NULL;
+out_pport_kobj:
+	sysfs_remove_group(bfad->ioc_kobj, &ioc_stats_group);
+out_ioc_attr:
+	kobject_put(bfad->ioc_kobj);
+	bfad->ioc_kobj = NULL;
+out_ioc_kobj:
+	kobject_put(bfad->bfa_kobj);
+	bfad->bfa_kobj = NULL;
+	return;
+}
+
+void
+bfad_os_device_sysfs_remove(struct bfad_s *bfad)
+{
+	/*
+	 * Delete itnims & rports of the base port
+	 */
+	bfad_sysfs_delete_all_rports(bfad, KOBJ_TYPE_ITNIM, 0,
+				     &bfad_kobj_base_list);
+	bfad_sysfs_delete_all_rports(bfad, KOBJ_TYPE_RPORT, 0,
+				     &bfad_kobj_base_list);
+
+	sysfs_remove_group(bfad->ioc_kobj, &ioc_stats_group);
+	sysfs_remove_group(bfad->pport_kobj, &pport_stats_group);
+	sysfs_remove_group(bfad->lport_kobj, &lport_stats_group);
+
+	kobject_put(bfad->lport_kobj);
+	kobject_put(bfad->pport_kobj);
+	kobject_put(bfad->ioc_kobj);
+	kobject_put(bfad->bfa_kobj);
+}
diff -urpN orig/drivers/scsi/bfa/bfad_sysfs.h
patch/drivers/scsi/bfa/bfad_sysfs.h
--- orig/drivers/scsi/bfa/bfad_sysfs.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_sysfs.h	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BFAD_SYSFS_H__
+#define __BFAD_SYSFS_H__
+
+int bfad_os_sysfs_lport_delete_dir(struct bfad_s *bfad, int vf_id,
+			int ioc_inst, u64 pwwn);
+int bfad_os_sysfs_lport_add_dir(struct bfad_s *bfad, int vf_id,
+			int ioc_inst, struct bfa_port_cfg_s port_cfg);
+int bfad_os_sysfs_vf_add_dir(struct bfad_s *bfad, int ioc_inst, u16
vf_id);
+int bfad_os_sysfs_vf_delete_dir(struct bfad_s *bfad, u16 vf_id);
+char *bfad_os_sysfs_get_ioc_path(struct bfad_s *bfad);
+struct bfad_s *bfad_os_find_bfad_by_path(char *path);
+
+#endif
diff -urpN orig/drivers/scsi/bfa/bfad_tm.h
patch/drivers/scsi/bfa/bfad_tm.h
--- orig/drivers/scsi/bfa/bfad_tm.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_tm.h	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/*
+ * Brocade Fibre Channel HBA Linux Target Mode Driver
+ */
+
+/**
+ * @file tm/dummy/bfad_tm.h BFA callback dummy header file for BFA
Linux target mode PCI interface module.
+ */
+
+#ifndef __BFAD_TM_H__
+#define __BFAD_TM_H__
+
+#include <defs/bfa_defs_status.h>
+
+#define FCPT_NAME 		""
+
+/*
+ * Called from base Linux driver on (De)Init events
+ */
+
+/* attach tgt template with scst */
+#define bfad_tm_module_init()	do {} while (0)
+
+/* detach/release tgt template */
+#define bfad_tm_module_exit()	do {} while (0)
+
+#define bfad_tm_probe(x)	do {} while (0)
+#define bfad_tm_probe_undo(x)	do {} while (0)
+#define bfad_tm_probe_post(x)	do {} while (0)
+
+/*
+ * Called by base Linux driver but triggered by BFA FCS on config
events
+ */
+#define bfad_tm_port_new(x, y)		BFA_STATUS_OK
+#define bfad_tm_port_delete(x, y)	do {} while (0)
+
+/*
+ * Called by base Linux driver but triggered by BFA FCS on PLOGI/O
events
+ */
+#define bfad_tm_port_online(x, y)	do {} while (0)
+#define bfad_tm_port_offline(x, y)	do {} while (0)
+
+#endif
diff -urpN orig/drivers/scsi/bfa/bfad_trcmod.h
patch/drivers/scsi/bfa/bfad_trcmod.h
--- orig/drivers/scsi/bfa/bfad_trcmod.h	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/bfad_trcmod.h	2008-09-24
12:08:24.000000000 -0700
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/**
+ * @file bfad_trcmod.h Linux driver trace modules
+ */
+
+
+#ifndef __BFAD_TRCMOD_H__
+#define __BFAD_TRCMOD_H__
+
+#include <cs/bfa_trc.h>
+
+/*
+ * !!! Only append to the enums defined here to avoid any versioning
+ * !!! needed between trace utility and driver version
+ */
+enum {
+	/* 2.6 Driver */
+	BFA_TRC_LDRV_BFAD		= 1,
+	BFA_TRC_LDRV_BFAD_2_6		= 2,
+	BFA_TRC_LDRV_BFAD_2_6_9		= 3,
+	BFA_TRC_LDRV_BFAD_2_6_10	= 4,
+	BFA_TRC_LDRV_INTR		= 5,
+	BFA_TRC_LDRV_IOCTL		= 6,
+	BFA_TRC_LDRV_OS			= 7,
+	BFA_TRC_LDRV_IM			= 8,
+	BFA_TRC_LDRV_IM_2_6		= 9,
+	BFA_TRC_LDRV_IM_2_6_9		= 10,
+	BFA_TRC_LDRV_IM_2_6_10		= 11,
+	BFA_TRC_LDRV_TM			= 12,
+	BFA_TRC_LDRV_IPFC		= 13,
+	BFA_TRC_LDRV_IM_2_4		= 14,
+	BFA_TRC_LDRV_IM_VMW		= 15,
+	BFA_TRC_LDRV_IM_LT_2_6_10	= 16,
+};
+
+#endif /* __BFAD_TRCMOD_H__ */
