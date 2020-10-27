Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BF8C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCDD320878
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TvS0pDRH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751874AbgJ0NIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:51 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53553 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441500AbgJ0NIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:51 -0400
Received: by mail-pj1-f68.google.com with SMTP id g16so755983pjv.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=78EwkV+RjrwpZqsl91CDk3iP3kdMU2M+QW6TzKkQmvI=;
        b=TvS0pDRH/FYJ00Rn0HjYpOyFW4AMK7HHXeV9gBxotMxW9NzxXnHgG0tKpTq4fElhpU
         aasWMMeg/v6IjAgCZ6YWofCy0e1C1HJSsrKh5ysSvqYURQgzi6RcA4TW2qRj9ft3TWaE
         cGFR81tmP2OngFyYdjLKw8ulFUIrpr2CXHdTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=78EwkV+RjrwpZqsl91CDk3iP3kdMU2M+QW6TzKkQmvI=;
        b=ti/6qeoFeZomoxwn1YKKF76s7HS6wAHTOePm3pC9k7a++31VBIv9cUEwS2l98nU10Y
         ilClR9YO6AnNUiYpNzDrgdshHn2kjjp6G4BnSE2mm/qRqgkAfD87neDdyfk1/alRE3HQ
         qyPlb+jHcmiW5zMZXezJ86/lK59/ncf2BP99MPqBEYz4kifxU57YltPPL4avEfi1zP0b
         Rh4BGg1TU8PL7kLGt2NBxQNFHYT3W4+a/KRmI22Lho4D2cWC5sjZRfs2KhNCqrhpOaaW
         qE/S9SVjdH7c2crqOzxIpv2Qw6JGzZhRsZagARJZ+X2y2fk1SCZCAyH2fdNxB+ASNLvF
         6KJg==
X-Gm-Message-State: AOAM5310LmJ9fTW71adWoAAliF7L96uIvQrB2sc6GqF0afQd/fJpL6kz
        y6Vts14XI9FK+E0Ht4wxwEHnsg==
X-Google-Smtp-Source: ABdhPJxQRTz8qqLPe4ZlAEUQ0dBEz5SI9nzF/LL8urw/JA5Eu3swHEtcbmyFgFnZmWcbfy2box1eaw==
X-Received: by 2002:a17:902:8c88:b029:d5:ffe1:6653 with SMTP id t8-20020a1709028c88b02900d5ffe16653mr2363687plo.22.1603804129027;
        Tue, 27 Oct 2020 06:08:49 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:47 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 10/14] mpt3sas: Handling HBA vSES device
Date:   Tue, 27 Oct 2020 18:38:43 +0530
Message-Id: <20201027130847.9962-11-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000077177005b2a6bf30"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000077177005b2a6bf30

Each direct attached device will have a unique Port ID,
but with an exception. i.e. HBA vSES may use the same
Port ID of another direct attached device Port's ID.
So special handling is needed for vSES.

Create a virtual_phy object when a new HBA vSES device
is detected and add this virtual_phy object to
vphys_list of port ID's hba_port object.
When the HBA vSES device is removed then remove the
corresponding virtual_phy object from it's parent's
hba_port's vphy_list and free this virtual_vphy object.

Below are variables of virtual_phy objects,
sas_address:    SAS address of vSES device,
phy_mask:       HBA phy bit which is assigned to vSES device
flag:           used during host reset to refresh this virtual_phy object

In hba_port object added vphy_mask field to hold the list
of HBA phy bits which are assigned to vSES devices, Also added
vphy_list list to hold list of virtual_phy objects which holds
the same portID of current hba_port's portID.

Also, added a hba_vphy field in _sas_phy object to determine
whether this _sas_phy object belongs to vSES device or not.

- Allocate a virtual_phy object whenever a virtual phy is detected
  while processing the SASIOUnitPage0's phy data. And this allocated
  virtual_phy object to corresponding PortID''s hba_port's vphy_list.

- When a vSES device is added to the SML then initialize the corresponding
  virtual_phy objects's sas_address field with vSES device's SAS
  Address.

- Free this virtual_phy object during driver unload time and when
  this vSES device is removed.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 106 +++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  80 ++++++++++++++---
 3 files changed, 198 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a8e42d1..e7d047a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -771,6 +771,7 @@ struct _sas_phy {
 	u16	handle;
 	u16	attached_handle;
 	u8	phy_belongs_to_port;
+	u8	hba_vphy;
 	struct hba_port *port;
 };
 
@@ -1023,12 +1024,29 @@ struct reply_post_struct {
 	dma_addr_t			reply_post_free_dma;
 };
 
+/**
+ * struct virtual_phy - vSES phy structure
+ * sas_address: SAS Address of vSES device
+ * phy_mask: vSES device's phy number
+ * flags: flags used to manage this structure
+ */
+struct virtual_phy {
+	struct	list_head list;
+	u64	sas_address;
+	u32	phy_mask;
+	u8	flags;
+};
+
+#define MPT_VPHY_FLAG_DIRTY_PHY	0x01
+
 /**
  * struct hba_port - Saves each HBA's Wide/Narrow port info
  * @sas_address: sas address of this wide/narrow port's attached device
  * @phy_mask: HBA PHY's belonging to this port
  * @port_id: port number
  * @flags: hba port flags
+ * @vphys_mask : mask of vSES devices Phy number
+ * @vphys_list : list containing vSES device structures
  */
 struct hba_port {
 	struct list_head list;
@@ -1036,6 +1054,8 @@ struct hba_port {
 	u32	phy_mask;
 	u8      port_id;
 	u8	flags;
+	u32	vphys_mask;
+	struct list_head vphys_list;
 };
 
 /* hba port flags */
@@ -1688,6 +1708,9 @@ mpt3sas_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 struct _sas_device *
 __mpt3sas_get_sdev_by_rphy(struct MPT3SAS_ADAPTER *ioc, struct sas_rphy *rphy);
+struct virtual_phy *
+mpt3sas_get_vphy_by_phy(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *port, u32 phy);
 
 /* config shared API */
 u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2b87003..6463876 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -380,6 +380,30 @@ mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port_id)
 	return NULL;
 }
 
+/**
+ * mpt3sas_get_vphy_by_phy - get virtual_phy object corresponding to phy number
+ * @ioc: per adapter object
+ * @port: hba_port object
+ * @phy: phy number
+ *
+ * Return virtual_phy object corresponding to phy number.
+ */
+struct virtual_phy *
+mpt3sas_get_vphy_by_phy(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *port, u32 phy)
+{
+	struct virtual_phy *vphy, *vphy_next;
+
+	if (!port->vphys_mask)
+		return NULL;
+
+	list_for_each_entry_safe(vphy, vphy_next, &port->vphys_list, list) {
+		if (vphy->phy_mask & (1 << phy))
+			return vphy;
+	}
+	return NULL;
+}
+
 /**
  * _scsih_is_boot_device - search for matching boot device.
  * @sas_address: sas address
@@ -6152,6 +6176,47 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	port_table_entry = NULL;
 }
 
+/**
+ * _scsih_alloc_vphy - allocate virtual_phy object
+ * @ioc: per adapter object
+ * @port_id: Port ID number
+ * @phy_num: HBA Phy number
+ *
+ * Returns allocated virtual_phy object.
+ */
+static struct virtual_phy *
+_scsih_alloc_vphy(struct MPT3SAS_ADAPTER *ioc, u8 port_id, u8 phy_num)
+{
+	struct virtual_phy *vphy;
+	struct hba_port *port;
+
+	port = mpt3sas_get_port_by_id(ioc, port_id);
+	if (!port)
+		return NULL;
+
+	vphy = mpt3sas_get_vphy_by_phy(ioc, port, phy_num);
+	if (!vphy) {
+		vphy = kzalloc(sizeof(struct virtual_phy), GFP_KERNEL);
+		if (!vphy)
+			return NULL;
+
+		/*
+		 * Enable bit corresponding to HBA phy number on it's
+		 * parent hba_port object's vphys_mask field.
+		 */
+		port->vphys_mask |= (1 << phy_num);
+		vphy->phy_mask |= (1 << phy_num);
+
+		INIT_LIST_HEAD(&port->vphys_list);
+		list_add_tail(&vphy->list, &port->vphys_list);
+
+		ioc_info(ioc,
+		    "vphy entry: %p, port id: %d, phy:%d is added to port's vphys_list\n",
+		    vphy, port->port_id, phy_num);
+	}
+	return vphy;
+}
+
 /**
  * _scsih_sas_host_refresh - refreshing sas host object contents
  * @ioc: per adapter object
@@ -6172,6 +6237,7 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 	u16 attached_handle;
 	u8 link_rate, port_id;
 	struct hba_port *port;
+	Mpi2SasPhyPage0_t phy_pg0;
 
 	dtmprintk(ioc,
 		  ioc_info(ioc, "updating handles for sas_host(0x%016llx)\n",
@@ -6211,6 +6277,31 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 				port->flags = HBA_PORT_FLAG_NEW_PORT;
 			list_add_tail(&port->list, &ioc->port_table_list);
 		}
+		/*
+		 * Check whether current Phy belongs to HBA vSES device or not.
+		 */
+		if (le32_to_cpu(sas_iounit_pg0->PhyData[i].ControllerPhyDeviceInfo) &
+		    MPI2_SAS_DEVICE_INFO_SEP &&
+		    (link_rate >=  MPI2_SAS_NEG_LINK_RATE_1_5)) {
+			if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply,
+			    &phy_pg0, i))) {
+				ioc_err(ioc,
+				    "failure at %s:%d/%s()!\n",
+				     __FILE__, __LINE__, __func__);
+				goto out;
+			}
+			if (!(le32_to_cpu(phy_pg0.PhyInfo) &
+			    MPI2_SAS_PHYINFO_VIRTUAL_PHY))
+				continue;
+			/*
+			 * Allocate a virtual_phy object for vSES device, if
+			 * this vSES device is hot added.
+			 */
+			if (!_scsih_alloc_vphy(ioc, port_id, i))
+				goto out;
+			ioc->sas_hba.phy[i].hba_vphy = 1;
+		}
+
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
@@ -6353,6 +6444,21 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			    &ioc->port_table_list);
 		}
 
+		/*
+		 * Check whether current Phy belongs to HBA vSES device or not.
+		 */
+		if ((le32_to_cpu(phy_pg0.PhyInfo) &
+		    MPI2_SAS_PHYINFO_VIRTUAL_PHY) &&
+		    (phy_pg0.NegotiatedLinkRate >> 4) >=
+		    MPI2_SAS_NEG_LINK_RATE_1_5) {
+			/*
+			 * Allocate a virtual_phy object for vSES device.
+			 */
+			if (!_scsih_alloc_vphy(ioc, port_id, i))
+				goto out;
+			ioc->sas_hba.phy[i].hba_vphy = 1;
+		}
+
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		ioc->sas_hba.phy[i].phy_id = i;
 		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index d52d8b3..256dae1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -690,6 +690,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	struct _sas_device *sas_device = NULL;
 	int i;
 	struct sas_port *port;
+	struct virtual_phy *vphy = NULL;
 
 	if (!hba_port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -743,9 +744,20 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			continue;
 		list_add_tail(&sas_node->phy[i].port_siblings,
 		    &mpt3sas_port->phy_list);
-		if (sas_node->handle <= ioc->sas_hba.num_phys)
-			hba_port->phy_mask |= (1 << i);
 		mpt3sas_port->num_phys++;
+		if (sas_node->handle <= ioc->sas_hba.num_phys) {
+			if (!sas_node->phy[i].hba_vphy) {
+				hba_port->phy_mask |= (1 << i);
+				continue;
+			}
+
+			vphy = mpt3sas_get_vphy_by_phy(ioc, hba_port, i);
+			if (!vphy) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				    __FILE__, __LINE__, __func__);
+				goto out_fail;
+			}
+		}
 	}
 
 	if (!mpt3sas_port->num_phys) {
@@ -795,8 +807,14 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		rphy = sas_end_device_alloc(port);
 		sas_device->rphy = rphy;
-		if (sas_node->handle <= ioc->sas_hba.num_phys)
-			hba_port->sas_address = sas_device->sas_address;
+		if (sas_node->handle <= ioc->sas_hba.num_phys) {
+			if (!vphy)
+				hba_port->sas_address =
+				    sas_device->sas_address;
+			else
+				vphy->sas_address =
+				    sas_device->sas_address;
+		}
 	} else {
 		rphy = sas_expander_alloc(port,
 		    mpt3sas_port->remote_identify.device_type);
@@ -866,6 +884,7 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	u8 found = 0;
 	struct _sas_phy *mpt3sas_phy, *next_phy;
 	struct hba_port *hba_port_next, *hba_port = NULL;
+	struct virtual_phy *vphy, *vphy_next = NULL;
 
 	if (!port)
 		return;
@@ -894,17 +913,56 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	}
 
 	if (sas_node->handle <= ioc->sas_hba.num_phys) {
+		if (port->vphys_mask) {
+			list_for_each_entry_safe(vphy, vphy_next,
+			    &port->vphys_list, list) {
+				if (vphy->sas_address != sas_address)
+					continue;
+				ioc_info(ioc,
+				    "remove vphy entry: %p of port:%p,from %d port's vphys list\n",
+				    vphy, port, port->port_id);
+				port->vphys_mask &= ~vphy->phy_mask;
+				list_del(&vphy->list);
+				kfree(vphy);
+			}
+		}
+
 		list_for_each_entry_safe(hba_port, hba_port_next,
 		    &ioc->port_table_list, list) {
 			if (hba_port != port)
 				continue;
-			if (hba_port->sas_address != sas_address)
-				continue;
-			ioc_info(ioc,
-			    "remove hba_port entry: %p port: %d from hba_port list\n",
-			    hba_port, hba_port->port_id);
-			list_del(&hba_port->list);
-			kfree(hba_port);
+			/*
+			 * Delete hba_port object if
+			 *  - hba_port object's sas address matches with current
+			 *    removed device's sas address and no vphy's
+			 *    associated with it.
+			 *  - Current removed device is a vSES device and
+			 *    none of the other direct attached device have
+			 *    this vSES device's port number (hence hba_port
+			 *    object sas_address field will be zero).
+			 */
+			if ((hba_port->sas_address == sas_address ||
+			    !hba_port->sas_address) && !hba_port->vphys_mask) {
+				ioc_info(ioc,
+				    "remove hba_port entry: %p port: %d from hba_port list\n",
+				    hba_port, hba_port->port_id);
+				list_del(&hba_port->list);
+				kfree(hba_port);
+			} else if (hba_port->sas_address == sas_address &&
+			    hba_port->vphys_mask) {
+				/*
+				 * Current removed device is a non vSES device
+				 * and a vSES device has the same port number
+				 * as of current device's port number. Hence
+				 * only clear the sas_address filed, don't
+				 * delete the hba_port object.
+				 */
+				ioc_info(ioc,
+				    "clearing sas_address from hba_port entry: %p port: %d from hba_port list\n",
+				    hba_port, hba_port->port_id);
+				port->sas_address = 0;
+			}
+			break;
 		}
 	}
 
-- 
2.18.4


--00000000000077177005b2a6bf30
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Rag/s/0IKyxAQsoBcla5ZufuDE5ir/mlnYktkPJdg+kns/OPDsINSyWqNYE9PKy9+3cp/fItNFtH
krg1AgMBAAGjggHTMIIBzzAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsG
AQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2ln
bjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29t
L2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEF
BQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBE
BgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWdu
MnNoYTJnMy5jcmwwJwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNV
HSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4E
FgQU1CyhXqcQo40SZ7kFS/AiOnRW6lMwDQYJKoZIhvcNAQELBQADggEBAFeMmmz112eNFAV8Ense
5WremClV5F3Md1xS0yXKqxlgakUJaOI/Fai7OLQaQqsEoxW6/QqWEi1wbZOccbdritOkL5b7sVUp
SU9OfuIlV8c3XMLaWSIluy+0ImtRJ49jDCI4KtQESHrqfQRZcc1C/avZvNED3U4b10U6N3SY+59b
fm2Vlwacwp+8ESTp49DsLcJqc4U/0rUZxLWtgPokzS+ovX+JAu8zx1SmOzUC4hj4Bp6Vnfd5KWUK
JJQBmQHXii+acSeTgHmPWUYs3tYQ0uIX0Yy8LUWPdGbEq+KWepzY2otC+iVWdngCCv8Nf1Xo1jki
AGJ6hrlWFE0qJVWv25sxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hB
MjU2IC0gRzMCDBmG1a14/wFg8qBhUjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg
HED9577K2oaRhJxoyMweK2huzewqLBimVD/gkND7uMIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODUwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAH6NU/q58IDd+mB4WlZe
PfooDpeMgRjgE8RKH6E62dQ9Alsf7mBifNwrzolQdFz2nSQyYPRmkBa+50LceNzSVgpNuxTjHCEU
FspySR/cmXuvOfmXXEHAs6kLB5TJ9wjZdzKTrQpHYBkAoHS5I3jlYKWf7LPdjTrxUhjZ2/lIwJ61
tjYilm+2mgsTMJEDDmHnXkKpdL7Qp8+7n9v/zUxLDy8wEc/WS5MN1CDHVCXV90TrYlV0hUxXC1zp
L/HF2fXCw00uDE7MVEwUH7ibwArRmmpuqVuk8AkFH5eEsES8r5wA9SQpgbwWFHtgtGXV2foAUzqE
ZPz0wtT+Ov0b5J8M8dI=
--00000000000077177005b2a6bf30--
