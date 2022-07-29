Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0143DC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiG2NHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiG2NFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:18 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A186AA18
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:29 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h132so3962524pgc.10
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=KsfO1QhEYEDl6eTYqQzZotxeyna7f+13Z1lWr3CAFjU=;
        b=ToxxBSkhoIKg+XxREdB+hm8oinJuYl+ok0oQGhxGygyPc6ZndyYd4RAC12LYMnRPRG
         oPm8uAXvldpk20g9wvBgs++O3cKQdiMGochVC81ciPe+Dn+GI1g3so4sxm/Yie+dsaT/
         5sFsBiFx+0UfbYsgK0a3rgl8AMiSnaEI8QoU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=KsfO1QhEYEDl6eTYqQzZotxeyna7f+13Z1lWr3CAFjU=;
        b=cGfq/uKwNRyf92DIvZ91a/Zcbj1ro/esXbw1UAQC8zZ9UvhIpORE36AMxnatQkbYy9
         QuvlOfbxc4ZDAoSkSF6AJl/HR3p79bNS9QBc6jWiEyG1CdkhJhpLUs81DNQi3dNOZrQj
         YVMAhHhPWF2qPWG1bJE1HO/3Lo7hKSf3+yAUzVRqlF1l9vWo1aoBCoioFHABKNfcb7JW
         fSuTvCg3Ptq6rBftVTOw21Nn/Yo3GELyQbEWZWSUE0zNE9kIy40PZzvQDAkWk9SsWxK7
         7M1EFoHB1gcEoePEduHu+b4iSbH+7s+lajqbdxYans6KqEqVL4D3si6LQSEeiNWP3Paw
         oxhA==
X-Gm-Message-State: AJIora9eCEseWdMMUnZHCerZWRHTOaoB8ii5c5LPdKk5DRV44e7xNpxq
        lekAG6Eg/ihVohzZMos+DQtOcLnsUr0XrVdL2jShSqPfYQwf9bMgietJiQZeEPJmPA/dv2m5g79
        j/2VPPpoHklHt0uk/6UBCIFPNuYAcdtingeJ1haB0XXemN2S5Nqn9NBlrExnqDifXeP4LQ42ClA
        6K+wIM0pLc
X-Google-Smtp-Source: AGRyM1vbjkVW4L2VBRSj0jo1h0Zw7u9sJa/Yr8vBI324sMB+chAyK4p1wSr/b6zKfK0C2c2Gjghq8w==
X-Received: by 2002:a63:4d1:0:b0:419:af9f:385e with SMTP id 200-20020a6304d1000000b00419af9f385emr2975643pge.590.1659099868561;
        Fri, 29 Jul 2022 06:04:28 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:27 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 05/15] mpi3mr: Add framework to add phys to STL
Date:   Fri, 29 Jul 2022 18:46:17 +0530
Message-Id: <20220729131627.15019-6-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000591d1505e4f14a9b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000591d1505e4f14a9b
Content-Transfer-Encoding: 8bit

Added framework to register and unregister the
host and expander phys with SCSI Transport Layer (STL).

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/Makefile           |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h           |  93 ++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 430 +++++++++++++++++++++++++
 3 files changed, 524 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_transport.c

diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index f5cdbe4..ef86ca4 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -3,3 +3,4 @@ obj-m += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
 		mpi3mr_app.o \
+		mpi3mr_transport.o
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 542b462..006bc5d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -39,6 +39,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <uapi/scsi/scsi_bsg_mpi3mr.h>
+#include <scsi/scsi_transport_sas.h>
 
 #include "mpi/mpi30_transport.h"
 #include "mpi/mpi30_cnfg.h"
@@ -461,6 +462,98 @@ struct mpi3mr_throttle_group_info {
 	atomic_t pend_large_data_sz;
 };
 
+/* HBA port flags */
+#define MPI3MR_HBA_PORT_FLAG_DIRTY	0x01
+
+/**
+ * struct mpi3mr_hba_port - HBA's port information
+ * @port_id: Port number
+ * @flags: HBA port flags
+ */
+struct mpi3mr_hba_port {
+	struct list_head list;
+	u8 port_id;
+	u8 flags;
+};
+
+/**
+ * struct mpi3mr_sas_port - Internal SAS port information
+ * @port_list: List of ports belonging to a SAS node
+ * @num_phys: Number of phys associated with port
+ * @hba_port: HBA port entry
+ * @remote_identify: Attached device identification
+ * @rphy: SAS transport layer rphy object
+ * @port: SAS transport layer port object
+ * @phy_list: mpi3mr_sas_phy objects belonging to this port
+ */
+struct mpi3mr_sas_port {
+	struct list_head port_list;
+	u8 num_phys;
+	struct mpi3mr_hba_port *hba_port;
+	struct sas_identify remote_identify;
+	struct sas_rphy *rphy;
+	struct sas_port *port;
+	struct list_head phy_list;
+};
+
+/**
+ * struct mpi3mr_sas_phy - Internal SAS Phy information
+ * @port_siblings: List of phys belonging to a port
+ * @identify: Phy identification
+ * @remote_identify: Attached device identification
+ * @phy: SAS transport layer Phy object
+ * @phy_id: Unique phy id within a port
+ * @handle: Firmware device handle for this phy
+ * @attached_handle: Firmware device handle for attached device
+ * @phy_belongs_to_port: Flag to indicate phy belongs to port
+   @hba_port: HBA port entry
+ */
+struct mpi3mr_sas_phy {
+	struct list_head port_siblings;
+	struct sas_identify identify;
+	struct sas_identify remote_identify;
+	struct sas_phy *phy;
+	u8 phy_id;
+	u16 handle;
+	u16 attached_handle;
+	u8 phy_belongs_to_port;
+	struct mpi3mr_hba_port *hba_port;
+};
+
+/**
+ * struct mpi3mr_sas_node - SAS host/expander information
+ * @list: List of sas nodes in a controller
+ * @parent_dev: Parent device class
+ * @num_phys: Number phys belonging to sas_node
+ * @sas_address: SAS address of sas_node
+ * @handle: Firmware device handle for this sas_host/expander
+ * @sas_address_parent: SAS address of parent expander or host
+ * @enclosure_handle: Firmware handle of enclosure of this node
+ * @device_info: Capabilities of this sas_host/expander
+ * @non_responding: used to refresh the expander devices during reset
+ * @host_node: Flag to indicate this is a host_node
+ * @hba_port: HBA port entry
+ * @phy: A list of phys that make up this sas_host/expander
+ * @sas_port_list: List of internal ports of this node
+ * @rphy: sas_rphy object of this expander node
+ */
+struct mpi3mr_sas_node {
+	struct list_head list;
+	struct device *parent_dev;
+	u8 num_phys;
+	u64 sas_address;
+	u16 handle;
+	u64 sas_address_parent;
+	u16 enclosure_handle;
+	u64 enclosure_logical_id;
+	u8 non_responding;
+	u8 host_node;
+	struct mpi3mr_hba_port *hba_port;
+	struct mpi3mr_sas_phy *phy;
+	struct list_head sas_port_list;
+	struct sas_rphy *rphy;
+};
+
 /**
  * struct mpi3mr_enclosure_node - enclosure information
  * @list: List of enclosures
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
new file mode 100644
index 0000000..989bf63
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Driver for Broadcom MPI3 Storage Controllers
+ *
+ * Copyright (C) 2017-2022 Broadcom Inc.
+ *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
+ *
+ */
+
+#include "mpi3mr.h"
+
+/**
+ * mpi3mr_convert_phy_link_rate -
+ * @link_rate: link rate as defined in the MPI header
+ *
+ * Convert link_rate from mpi format into sas_transport layer
+ * form.
+ *
+ * Return: A valid SAS transport layer defined link rate
+ */
+static enum sas_linkrate mpi3mr_convert_phy_link_rate(u8 link_rate)
+{
+	enum sas_linkrate rc;
+
+	switch (link_rate) {
+	case MPI3_SAS_NEG_LINK_RATE_1_5:
+		rc = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_3_0:
+		rc = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_6_0:
+		rc = SAS_LINK_RATE_6_0_GBPS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_12_0:
+		rc = SAS_LINK_RATE_12_0_GBPS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_12_0_GBPS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_PHY_DISABLED:
+		rc = SAS_PHY_DISABLED;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_NEGOTIATION_FAILED:
+		rc = SAS_LINK_RATE_FAILED;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_PORT_SELECTOR:
+		rc = SAS_SATA_PORT_SELECTOR;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_SMP_RESET_IN_PROGRESS:
+		rc = SAS_PHY_RESET_IN_PROGRESS;
+		break;
+	case MPI3_SAS_NEG_LINK_RATE_SATA_OOB_COMPLETE:
+	case MPI3_SAS_NEG_LINK_RATE_UNKNOWN_LINK_RATE:
+	default:
+		rc = SAS_LINK_RATE_UNKNOWN;
+		break;
+	}
+	return rc;
+}
+
+/**
+ * mpi3mr_delete_sas_phy - Remove a single phy from port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_port: Internal Port object
+ * @mr_sas_phy: Internal Phy object
+ *
+ * Return: None.
+ */
+static void mpi3mr_delete_sas_phy(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_port *mr_sas_port,
+	struct mpi3mr_sas_phy *mr_sas_phy)
+{
+	u64 sas_address = mr_sas_port->remote_identify.sas_address;
+
+	dev_info(&mr_sas_phy->phy->dev,
+	    "remove: sas_address(0x%016llx), phy(%d)\n",
+	    (unsigned long long) sas_address, mr_sas_phy->phy_id);
+
+	list_del(&mr_sas_phy->port_siblings);
+	mr_sas_port->num_phys--;
+	sas_port_delete_phy(mr_sas_port->port, mr_sas_phy->phy);
+	mr_sas_phy->phy_belongs_to_port = 0;
+}
+
+/**
+ * mpi3mr_add_sas_phy - Adding a single phy to a port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_port: Internal Port object
+ * @mr_sas_phy: Internal Phy object
+ *
+ * Return: None.
+ */
+static void mpi3mr_add_sas_phy(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_port *mr_sas_port,
+	struct mpi3mr_sas_phy *mr_sas_phy)
+{
+	u64 sas_address = mr_sas_port->remote_identify.sas_address;
+
+	dev_info(&mr_sas_phy->phy->dev,
+	    "add: sas_address(0x%016llx), phy(%d)\n", (unsigned long long)
+	    sas_address, mr_sas_phy->phy_id);
+
+	list_add_tail(&mr_sas_phy->port_siblings, &mr_sas_port->phy_list);
+	mr_sas_port->num_phys++;
+	sas_port_add_phy(mr_sas_port->port, mr_sas_phy->phy);
+	mr_sas_phy->phy_belongs_to_port = 1;
+}
+
+/**
+ * mpi3mr_add_phy_to_an_existing_port - add phy to existing port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_node: Internal sas node object (expander or host)
+ * @mr_sas_phy: Internal Phy object *
+ * @sas_address: SAS address of device/expander were phy needs
+ *             to be added to
+ * @hba_port: HBA port entry
+ *
+ * Return: None.
+ */
+static void mpi3mr_add_phy_to_an_existing_port(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *mr_sas_node, struct mpi3mr_sas_phy *mr_sas_phy,
+	u64 sas_address, struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_sas_port *mr_sas_port;
+	struct mpi3mr_sas_phy *srch_phy;
+
+	if (mr_sas_phy->phy_belongs_to_port == 1)
+		return;
+
+	if (!hba_port)
+		return;
+
+	list_for_each_entry(mr_sas_port, &mr_sas_node->sas_port_list,
+	    port_list) {
+		if (mr_sas_port->remote_identify.sas_address !=
+		    sas_address)
+			continue;
+		if (mr_sas_port->hba_port != hba_port)
+			continue;
+		list_for_each_entry(srch_phy, &mr_sas_port->phy_list,
+		    port_siblings) {
+			if (srch_phy == mr_sas_phy)
+				return;
+		}
+		mpi3mr_add_sas_phy(mrioc, mr_sas_port, mr_sas_phy);
+		return;
+	}
+}
+
+/**
+ * mpi3mr_del_phy_from_an_existing_port - del phy from a port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_node: Internal sas node object (expander or host)
+ * @mr_sas_phy: Internal Phy object
+ *
+ * Return: None.
+ */
+static void mpi3mr_del_phy_from_an_existing_port(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *mr_sas_node, struct mpi3mr_sas_phy *mr_sas_phy)
+{
+	struct mpi3mr_sas_port *mr_sas_port, *next;
+	struct mpi3mr_sas_phy *srch_phy;
+
+	if (mr_sas_phy->phy_belongs_to_port == 0)
+		return;
+
+	list_for_each_entry_safe(mr_sas_port, next, &mr_sas_node->sas_port_list,
+	    port_list) {
+		list_for_each_entry(srch_phy, &mr_sas_port->phy_list,
+		    port_siblings) {
+			if (srch_phy != mr_sas_phy)
+				continue;
+			mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
+			    mr_sas_phy);
+			return;
+		}
+	}
+}
+
+/**
+ * mpi3mr_sas_port_sanity_check - sanity check while adding port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_node: Internal sas node object (expander or host)
+ * @sas_address: SAS address of device/expander
+ * @hba_port: HBA port entry
+ *
+ * Verifies whether the Phys attached to a device with the given
+ * SAS address already belongs to an existing sas port if so
+ * will remove those phys from the sas port
+ *
+ * Return: None.
+ */
+static void mpi3mr_sas_port_sanity_check(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *mr_sas_node, u64 sas_address,
+	struct mpi3mr_hba_port *hba_port)
+{
+	int i;
+
+	for (i = 0; i < mr_sas_node->num_phys; i++) {
+		if ((mr_sas_node->phy[i].remote_identify.sas_address !=
+		    sas_address) || (mr_sas_node->phy[i].hba_port != hba_port))
+			continue;
+		if (mr_sas_node->phy[i].phy_belongs_to_port == 1)
+			mpi3mr_del_phy_from_an_existing_port(mrioc,
+			    mr_sas_node, &mr_sas_node->phy[i]);
+	}
+}
+
+/**
+ * mpi3mr_set_identify - set identify for phys and end devices
+ * @mrioc: Adapter instance reference
+ * @handle: Firmware device handle
+ * @identify: SAS transport layer's identify info
+ *
+ * Populates sas identify info for a specific device.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_set_identify(struct mpi3mr_ioc *mrioc, u16 handle,
+	struct sas_identify *identify)
+{
+
+	struct mpi3_device_page0 device_pg0;
+	struct mpi3_device0_sas_sata_format *sasinf;
+	u16 device_info;
+	u16 ioc_status;
+
+	if (mrioc->reset_in_progress) {
+		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
+		return -EFAULT;
+	}
+
+	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &device_pg0,
+	    sizeof(device_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
+		return -ENXIO;
+	}
+
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
+		    handle, ioc_status, __FILE__, __LINE__, __func__);
+		return -EIO;
+	}
+
+	memset(identify, 0, sizeof(struct sas_identify));
+	sasinf = &device_pg0.device_specific.sas_sata_format;
+	device_info = le16_to_cpu(sasinf->device_info);
+
+	/* sas_address */
+	identify->sas_address = le64_to_cpu(sasinf->sas_address);
+
+	/* phy number of the parent device this device is linked to */
+	identify->phy_identifier = sasinf->phy_num;
+
+	/* device_type */
+	switch (device_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) {
+	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_NO_DEVICE:
+		identify->device_type = SAS_PHY_UNUSED;
+		break;
+	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE:
+		identify->device_type = SAS_END_DEVICE;
+		break;
+	case MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER:
+		identify->device_type = SAS_EDGE_EXPANDER_DEVICE;
+		break;
+	}
+
+	/* initiator_port_protocols */
+	if (device_info & MPI3_SAS_DEVICE_INFO_SSP_INITIATOR)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_SSP;
+	/* MPI3.0 doesn't have define for SATA INIT so setting both here*/
+	if (device_info & MPI3_SAS_DEVICE_INFO_STP_INITIATOR)
+		identify->initiator_port_protocols |= (SAS_PROTOCOL_STP |
+		    SAS_PROTOCOL_SATA);
+	if (device_info & MPI3_SAS_DEVICE_INFO_SMP_INITIATOR)
+		identify->initiator_port_protocols |= SAS_PROTOCOL_SMP;
+
+	/* target_port_protocols */
+	if (device_info & MPI3_SAS_DEVICE_INFO_SSP_TARGET)
+		identify->target_port_protocols |= SAS_PROTOCOL_SSP;
+	/* MPI3.0 doesn't have define for STP Target so setting both here*/
+	if (device_info & MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET)
+		identify->target_port_protocols |= (SAS_PROTOCOL_STP |
+		    SAS_PROTOCOL_SATA);
+	if (device_info & MPI3_SAS_DEVICE_INFO_SMP_TARGET)
+		identify->target_port_protocols |= SAS_PROTOCOL_SMP;
+	return 0;
+}
+
+/**
+ * mpi3mr_add_host_phy - report sas_host phy to SAS transport
+ * @mrioc: Adapter instance reference
+ * @mr_sas_phy: Internal Phy object
+ * @phy_pg0: SAS phy page 0
+ * @parent_dev: Prent device class object
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_add_host_phy(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_phy *mr_sas_phy, struct mpi3_sas_phy_page0 phy_pg0,
+	struct device *parent_dev)
+{
+	struct sas_phy *phy;
+	int phy_index = mr_sas_phy->phy_id;
+
+
+	INIT_LIST_HEAD(&mr_sas_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, phy_index);
+	if (!phy) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+	if ((mpi3mr_set_identify(mrioc, mr_sas_phy->handle,
+	    &mr_sas_phy->identify))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
+		return -1;
+	}
+	phy->identify = mr_sas_phy->identify;
+	mr_sas_phy->attached_handle = le16_to_cpu(phy_pg0.attached_dev_handle);
+	if (mr_sas_phy->attached_handle)
+		mpi3mr_set_identify(mrioc, mr_sas_phy->attached_handle,
+		    &mr_sas_phy->remote_identify);
+	phy->identify.phy_identifier = mr_sas_phy->phy_id;
+	phy->negotiated_linkrate = mpi3mr_convert_phy_link_rate(
+	    (phy_pg0.negotiated_link_rate &
+	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
+	phy->minimum_linkrate_hw = mpi3mr_convert_phy_link_rate(
+	    phy_pg0.hw_link_rate & MPI3_SAS_HWRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate_hw = mpi3mr_convert_phy_link_rate(
+	    phy_pg0.hw_link_rate >> 4);
+	phy->minimum_linkrate = mpi3mr_convert_phy_link_rate(
+	    phy_pg0.programmed_link_rate & MPI3_SAS_PRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate = mpi3mr_convert_phy_link_rate(
+	    phy_pg0.programmed_link_rate >> 4);
+	phy->hostdata = mr_sas_phy->hba_port;
+
+	if ((sas_phy_add(phy))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
+		return -1;
+	}
+	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		dev_info(&phy->dev,
+		    "add: handle(0x%04x), sas_address(0x%016llx)\n"
+		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
+		    mr_sas_phy->handle, (unsigned long long)
+		    mr_sas_phy->identify.sas_address,
+		    mr_sas_phy->attached_handle,
+		    (unsigned long long)
+		    mr_sas_phy->remote_identify.sas_address);
+	mr_sas_phy->phy = phy;
+	return 0;
+}
+
+/**
+ * mpi3mr_add_expander_phy - report expander phy to transport
+ * @mrioc: Adapter instance reference
+ * @mr_sas_phy: Internal Phy object
+ * @expander_pg1: SAS Expander page 1
+ * @parent_dev: Parent device class object
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+static int mpi3mr_add_expander_phy(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_phy *mr_sas_phy,
+	struct mpi3_sas_expander_page1 expander_pg1,
+	struct device *parent_dev)
+{
+	struct sas_phy *phy;
+	int phy_index = mr_sas_phy->phy_id;
+
+	INIT_LIST_HEAD(&mr_sas_phy->port_siblings);
+	phy = sas_phy_alloc(parent_dev, phy_index);
+	if (!phy) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+	if ((mpi3mr_set_identify(mrioc, mr_sas_phy->handle,
+	    &mr_sas_phy->identify))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
+		return -1;
+	}
+	phy->identify = mr_sas_phy->identify;
+	mr_sas_phy->attached_handle =
+	    le16_to_cpu(expander_pg1.attached_dev_handle);
+	if (mr_sas_phy->attached_handle)
+		mpi3mr_set_identify(mrioc, mr_sas_phy->attached_handle,
+		    &mr_sas_phy->remote_identify);
+	phy->identify.phy_identifier = mr_sas_phy->phy_id;
+	phy->negotiated_linkrate = mpi3mr_convert_phy_link_rate(
+	    (expander_pg1.negotiated_link_rate &
+	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+	    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT);
+	phy->minimum_linkrate_hw = mpi3mr_convert_phy_link_rate(
+	    expander_pg1.hw_link_rate & MPI3_SAS_HWRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate_hw = mpi3mr_convert_phy_link_rate(
+	    expander_pg1.hw_link_rate >> 4);
+	phy->minimum_linkrate = mpi3mr_convert_phy_link_rate(
+	    expander_pg1.programmed_link_rate & MPI3_SAS_PRATE_MIN_RATE_MASK);
+	phy->maximum_linkrate = mpi3mr_convert_phy_link_rate(
+	    expander_pg1.programmed_link_rate >> 4);
+	phy->hostdata = mr_sas_phy->hba_port;
+
+	if ((sas_phy_add(phy))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		sas_phy_free(phy);
+		return -1;
+	}
+	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		dev_info(&phy->dev,
+		    "add: handle(0x%04x), sas_address(0x%016llx)\n"
+		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
+		    mr_sas_phy->handle, (unsigned long long)
+		    mr_sas_phy->identify.sas_address,
+		    mr_sas_phy->attached_handle,
+		    (unsigned long long)
+		    mr_sas_phy->remote_identify.sas_address);
+	mr_sas_phy->phy = phy;
+	return 0;
+}
-- 
2.27.0


--000000000000591d1505e4f14a9b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINyiO9lRl2QpUdMRcJ54
BR3sQrwqGWmeJZWribxy+4aRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAHEseVHWyY377XkxgW/Bnr5j24pwKYjRslqmmA
vf+FwkkuG3ys5mYNMFq5sfdDbgugnePX4cbZxYOBhRkvF55BI/4sP+ndTgG1LnL+jN26mZMFWwNO
vvaoqycEvVBEvrwr6WaHFHgfbCIm4zvj5G6lSdNxozPwCAWtle8LZxBOCe5kIN+QRMRo8FJGWrUF
5w3Mky5XS0nC69/Z0uU0sCGE+UMxh6bZXiS0Z4lvM0k4hyqWnpiQ6a23GCUNd9LE+YbQukPTWqNa
5gZd2ffrX09nyFdOP5JaQ+KyhL4VgKF/MPa47/G7etOPzwGfCmURBSeD+ypWvhtiotK6I7fCBik0
--000000000000591d1505e4f14a9b--
