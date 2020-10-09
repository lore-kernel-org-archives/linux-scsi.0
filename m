Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08469C43457
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC2922267
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JqBVtpEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390213AbgJIRO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731420AbgJIRO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86A3C0613D6
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 132so815468pfz.5
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a6rgsjUykzfrKcvJUQiHXlaLIlcAaFqJytzTXP4r0Jg=;
        b=JqBVtpEcccWlF6aavF0hmBOh1MUY8zSez0FUlx1RFrRPnM5VKtiLD39JGSRncTqzf9
         30WnOWjR3OuJeSpeHKnzPQuA9ACZdmdt/xGbxOAIOcwS2NUa8Ii1NCi06durnCvoo2DU
         XZSScYYA8vr7VLACBix4t6gsNEjbaAogUqV7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a6rgsjUykzfrKcvJUQiHXlaLIlcAaFqJytzTXP4r0Jg=;
        b=NpbZS1WlZ5W5GSGdAaquI0q5EIrGHQyBMgyIcJfjg46ugjwUh8uZc/8bY+D+rBNgAT
         PX/AGTZKVK8H/C2thDPKk2N+HV3lqF6eH64PizfoXblEIQiiJ0Pi9Z1BHMnVYyrSkEcV
         qBCipICLWGwn56EMkqLT83W9yMF8M6AcZ2Nc4b814nUSyM6laz2F+kseSRnpo+5oK9J3
         vE/kzHTfVRHgVJwhZf0W9nQH2prpzwV4E9gImijxq2fcrN82L0rdo6/qjsV7TtXIshQ6
         gjQZGkRY8uYtbvktDsmWJTeuox2BsCUZAZFAdzIO+A+eKCgfHESqx6le0rnTRLmpeWmm
         KYOw==
X-Gm-Message-State: AOAM532PpGPl0gqa8Gn5Y+UrXJ7nMpU5netVh7CFyA3VyN0XvRfzTaFB
        S35ooolHfSBOe0XBpiqYkRcookEYWohTB4TIF6U=
X-Google-Smtp-Source: ABdhPJzsM+EKh9R6BAcwJ/f3aE49/yrS+BEJ70LUnSVvmc0wGA1Lx2kkqcQlbSxlxkdZ5CMx0GZrTg==
X-Received: by 2002:a62:4e87:0:b029:154:fdb9:548 with SMTP id c129-20020a624e870000b0290154fdb90548mr12900042pfb.26.1602263665093;
        Fri, 09 Oct 2020 10:14:25 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:24 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 04/14] mpt3sas: Update hba_port's sas_address & phy_mask
Date:   Fri,  9 Oct 2020 22:44:30 +0530
Message-Id: <20201009171440.4949-5-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a1093a05b1401491"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a1093a05b1401491

Update hba_port's sas_address & phy_mask fields whenever
a direct expander or sas/sata target devices are
added or removed.

- When any direct attached device is discovered then driver
        - gets the hba_port object corresponding to device's
          PhysicalPort number,
        - update's the hba_port's sas_address field with
          device's SAS Address,
        - update's the hba_port's phy_mask filed with device's
          narrow/wide port Phy number bits.

        Also,
        - if any sas/sata end device (not only direct
          direct attached devices) is added then
          corresponding sas_device object's port variable
          is assigned with hba_port object's address who's
          port_id matches with device's PhysicalPort number.
        - if any expander device is added then corresponding
          sas_expander object's port variable is assigned
          with hba_port object's address who's port_id
          matches with expander device's PhysicalPort number.

- When any direct attached device is detached then driver
  will delete the hba_port object's corresponding to
  device's PhysicalPort number.

- Whenever any HBA phy's link (of direct attached device's port)
  comes up then update the phy_mask field of corresponding
  hba_port object.

- Added a new function parameter named 'port' of type
  struct hba_port to below functions,
  * mpt3sas_transport_port_add()
  * mpt3sas_transport_port_remove()
  * mpt3sas_transport_update_links()

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  7 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 81 ++++++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 65 +++++++++++++++++--
 3 files changed, 126 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 2dde574..aef872a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1792,16 +1792,17 @@ extern struct scsi_transport_template *mpt3sas_transport_template;
 u8 mpt3sas_transport_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 struct _sas_port *mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc,
-	u16 handle, u64 sas_address);
+	u16 handle, u64 sas_address, struct hba_port *port);
 void mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
-	u64 sas_address_parent);
+	u64 sas_address_parent, struct hba_port *port);
 int mpt3sas_transport_add_host_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	*mpt3sas_phy, Mpi2SasPhyPage0_t phy_pg0, struct device *parent_dev);
 int mpt3sas_transport_add_expander_phy(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_phy *mpt3sas_phy, Mpi2ExpanderPage1_t expander_pg1,
 	struct device *parent_dev);
 void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate);
+	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate,
+	struct hba_port *port);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
 /* trigger data externs */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e8ffe1e..0067025 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -908,7 +908,7 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
-	     sas_device->sas_address_parent)) {
+	     sas_device->sas_address_parent, sas_device->port)) {
 		_scsih_sas_device_remove(ioc, sas_device);
 	} else if (!sas_device->starget) {
 		/*
@@ -919,7 +919,8 @@ _scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
 		if (!ioc->is_driver_loading) {
 			mpt3sas_transport_port_remove(ioc,
 			    sas_device->sas_address,
-			    sas_device->sas_address_parent);
+			    sas_device->sas_address_parent,
+			    sas_device->port);
 			_scsih_sas_device_remove(ioc, sas_device);
 		}
 	} else
@@ -1768,6 +1769,7 @@ scsih_target_alloc(struct scsi_target *starget)
 		if (pcie_device) {
 			sas_target_priv_data->handle = pcie_device->handle;
 			sas_target_priv_data->sas_address = pcie_device->wwid;
+			sas_target_priv_data->port = NULL;
 			sas_target_priv_data->pcie_dev = pcie_device;
 			pcie_device->starget = starget;
 			pcie_device->id = starget->id;
@@ -1791,6 +1793,7 @@ scsih_target_alloc(struct scsi_target *starget)
 	if (sas_device) {
 		sas_target_priv_data->handle = sas_device->handle;
 		sas_target_priv_data->sas_address = sas_device->sas_address;
+		sas_target_priv_data->port = sas_device->port;
 		sas_target_priv_data->sas_dev = sas_device;
 		sas_device->starget = starget;
 		sas_device->id = starget->id;
@@ -5804,7 +5807,8 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
 		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
 		mpt3sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
-		    attached_handle, i, link_rate);
+		    attached_handle, i, link_rate,
+		    ioc->sas_hba.phy[i].port);
 	}
  out:
 	kfree(sas_iounit_pg0);
@@ -5994,6 +5998,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	int i;
 	unsigned long flags;
 	struct _sas_port *mpt3sas_port = NULL;
+	u8 port_id;
 
 	int rc = 0;
 
@@ -6026,6 +6031,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			__FILE__, __LINE__, __func__);
 		return -1;
 	}
+
+	port_id = expander_pg0.PhysicalPort;
 	if (sas_address_parent != ioc->sas_hba.sas_address) {
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
@@ -6059,6 +6066,13 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander->num_phys = expander_pg0.NumPhys;
 	sas_expander->sas_address_parent = sas_address_parent;
 	sas_expander->sas_address = sas_address;
+	sas_expander->port = mpt3sas_get_port_by_id(ioc, port_id);
+	if (!sas_expander->port) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -1;
+		goto out_fail;
+	}
 
 	ioc_info(ioc, "expander_add: handle(0x%04x), parent(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
 		 handle, parent_handle,
@@ -6077,7 +6091,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	INIT_LIST_HEAD(&sas_expander->sas_port_list);
 	mpt3sas_port = mpt3sas_transport_port_add(ioc, handle,
-	    sas_address_parent);
+	    sas_address_parent, sas_expander->port);
 	if (!mpt3sas_port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
@@ -6096,6 +6110,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
+		sas_expander->phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
 
 		if ((mpt3sas_transport_add_expander_phy(ioc,
 		    &sas_expander->phy[i], expander_pg1,
@@ -6123,7 +6138,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 
 	if (mpt3sas_port)
 		mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
-		    sas_address_parent);
+		    sas_address_parent, sas_expander->port);
 	kfree(sas_expander);
 	return rc;
 }
@@ -6388,6 +6403,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	u32 ioc_status;
 	u64 sas_address;
 	u32 device_info;
+	u8 port_id;
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
@@ -6424,6 +6440,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	    sas_device_pg0.AccessStatus))
 		return -1;
 
+	port_id = sas_device_pg0.PhysicalPort;
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
 					sas_address);
 	if (sas_device) {
@@ -6466,6 +6483,12 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	sas_device->phy = sas_device_pg0.PhyNum;
 	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
+	sas_device->port = mpt3sas_get_port_by_id(ioc, port_id);
+	if (!sas_device->port) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
 
 	if (le16_to_cpu(sas_device_pg0.Flags)
 		& MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
@@ -6499,6 +6522,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	else
 		_scsih_sas_device_add(ioc, sas_device);
 
+out:
 	sas_device_put(sas_device);
 	return 0;
 }
@@ -6539,7 +6563,8 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 	if (!ioc->hide_drives)
 		mpt3sas_transport_port_remove(ioc,
 		    sas_device->sas_address,
-		    sas_device->sas_address_parent);
+		    sas_device->sas_address_parent,
+		    sas_device->port);
 
 	ioc_info(ioc, "removing handle(0x%04x), sas_addr(0x%016llx)\n",
 		 sas_device->handle, (u64)sas_device->sas_address);
@@ -6650,6 +6675,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address;
 	unsigned long flags;
 	u8 link_rate, prev_link_rate;
+	struct hba_port *port;
 	Mpi2EventDataSasTopologyChangeList_t *event_data =
 		(Mpi2EventDataSasTopologyChangeList_t *)
 		fw_event->event_data;
@@ -6671,6 +6697,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	parent_handle = le16_to_cpu(event_data->ExpanderDevHandle);
+	port = mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort);
 
 	/* handle expander add */
 	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_ADDED)
@@ -6683,6 +6710,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	if (sas_expander) {
 		sas_address = sas_expander->sas_address;
 		max_phys = sas_expander->num_phys;
+		port = sas_expander->port;
 	} else if (parent_handle < ioc->sas_hba.num_phys) {
 		sas_address = ioc->sas_hba.sas_address;
 		max_phys = ioc->sas_hba.num_phys;
@@ -6725,7 +6753,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 				break;
 
 			mpt3sas_transport_update_links(ioc, sas_address,
-			    handle, phy_number, link_rate);
+			    handle, phy_number, link_rate, port);
 
 			if (link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
 				break;
@@ -6744,7 +6772,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 				break;
 
 			mpt3sas_transport_update_links(ioc, sas_address,
-			    handle, phy_number, link_rate);
+			    handle, phy_number, link_rate, port);
 
 			_scsih_add_device(ioc, handle, phy_number, 0);
 
@@ -8300,7 +8328,8 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 	parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 	if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
 		mpt3sas_transport_update_links(ioc, sas_address, handle,
-		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
+		    mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort));
 
 	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
 	_scsih_add_device(ioc, handle, 0, 1);
@@ -8606,7 +8635,9 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
-			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
+			    mpt3sas_get_port_by_id(ioc,
+			    sas_device_pg0.PhysicalPort));
 
 		_scsih_add_device(ioc, handle, 0, 1);
 
@@ -9345,7 +9376,8 @@ _scsih_refresh_expander_links(struct MPT3SAS_ADAPTER *ioc,
 
 		mpt3sas_transport_update_links(ioc, sas_expander->sas_address,
 		    le16_to_cpu(expander_pg1.AttachedDevHandle), i,
-		    expander_pg1.NegotiatedLinkRate >> 4);
+		    expander_pg1.NegotiatedLinkRate >> 4,
+		    sas_expander->port);
 	}
 }
 
@@ -9364,7 +9396,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2RaidPhysDiskPage0_t pd_pg0;
 	Mpi2EventIrConfigElement_t element;
 	Mpi2ConfigReply_t mpi_reply;
-	u8 phys_disk_num;
+	u8 phys_disk_num, port_id;
 	u16 ioc_status;
 	u16 handle, parent_handle;
 	u64 sas_address;
@@ -9454,9 +9486,11 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			ioc_info(ioc, "\tBEFORE adding phys disk: handle (0x%04x), sas_addr(0x%016llx)\n",
 				 handle,
 				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
+			port_id = sas_device_pg0.PhysicalPort;
 			mpt3sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
-			    MPI2_SAS_NEG_LINK_RATE_1_5);
+			    MPI2_SAS_NEG_LINK_RATE_1_5,
+			    mpt3sas_get_port_by_id(ioc, port_id));
 			set_bit(handle, ioc->pd_handles);
 			retry_count = 0;
 			/* This will retry adding the end device.
@@ -9542,6 +9576,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		if (!(_scsih_is_end_device(
 		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
 			continue;
+		port_id = sas_device_pg0.PhysicalPort;
 		sas_device = mpt3sas_get_sdev_by_addr(ioc,
 		    le64_to_cpu(sas_device_pg0.SASAddress));
 		if (sas_device) {
@@ -9554,7 +9589,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 				 handle,
 				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
-			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
+			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
+			    mpt3sas_get_port_by_id(ioc, port_id));
 			retry_count = 0;
 			/* This will retry adding the end device.
 			 * _scsih_add_device() will decide on retries and
@@ -9997,7 +10033,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
-	    sas_expander->sas_address_parent);
+	    sas_expander->sas_address_parent, sas_expander->port);
 
 	ioc_info(ioc, "expander_remove: handle(0x%04x), sas_addr(0x%016llx)\n",
 		 sas_expander->handle, (unsigned long long)
@@ -10341,6 +10377,7 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 	unsigned long flags;
 	int rc;
 	int tid;
+	struct hba_port *port;
 
 	 /* no Bios, return immediately */
 	if (!ioc->bios_pg3.BiosVersion)
@@ -10382,19 +10419,24 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 		handle = sas_device->handle;
 		sas_address_parent = sas_device->sas_address_parent;
 		sas_address = sas_device->sas_address;
+		port = sas_device->port;
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 		if (ioc->hide_drives)
 			return;
+
+		if (!port)
+			return;
+
 		if (!mpt3sas_transport_port_add(ioc, handle,
-		    sas_address_parent)) {
+		    sas_address_parent, port)) {
 			_scsih_sas_device_remove(ioc, sas_device);
 		} else if (!sas_device->starget) {
 			if (!ioc->is_driver_loading) {
 				mpt3sas_transport_port_remove(ioc,
 				    sas_address,
-				    sas_address_parent);
+				    sas_address_parent, port);
 				_scsih_sas_device_remove(ioc, sas_device);
 			}
 		}
@@ -10482,7 +10524,7 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 
 	while ((sas_device = get_next_sas_device(ioc))) {
 		if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
-		    sas_device->sas_address_parent)) {
+		    sas_device->sas_address_parent, sas_device->port)) {
 			_scsih_sas_device_remove(ioc, sas_device);
 			sas_device_put(sas_device);
 			continue;
@@ -10496,7 +10538,8 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 			if (!ioc->is_driver_loading) {
 				mpt3sas_transport_port_remove(ioc,
 				    sas_device->sas_address,
-				    sas_device->sas_address_parent);
+				    sas_device->sas_address_parent,
+				    sas_device->port);
 				_scsih_sas_device_remove(ioc, sas_device);
 				sas_device_put(sas_device);
 				continue;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 6ec5b7f..aab3b14 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -594,6 +594,7 @@ _transport_sanity_check(struct MPT3SAS_ADAPTER *ioc, struct _sas_node *sas_node,
  * @ioc: per adapter object
  * @handle: handle of attached device
  * @sas_address: sas address of parent expander or sas host
+ * @port: hba port entry
  * Context: This function will acquire ioc->sas_node_lock.
  *
  * Adding new port object to the sas_node->sas_port_list.
@@ -602,7 +603,7 @@ _transport_sanity_check(struct MPT3SAS_ADAPTER *ioc, struct _sas_node *sas_node,
  */
 struct _sas_port *
 mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *hba_port)
 {
 	struct _sas_phy *mpt3sas_phy, *next;
 	struct _sas_port *mpt3sas_port;
@@ -613,6 +614,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	int i;
 	struct sas_port *port;
 
+	if (!hba_port) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return NULL;
+	}
+
 	mpt3sas_port = kzalloc(sizeof(struct _sas_port),
 	    GFP_KERNEL);
 	if (!mpt3sas_port) {
@@ -646,6 +653,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 
+	mpt3sas_port->hba_port = hba_port;
 	_transport_sanity_check(ioc, sas_node,
 	    mpt3sas_port->remote_identify.sas_address);
 
@@ -653,8 +661,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		if (sas_node->phy[i].remote_identify.sas_address !=
 		    mpt3sas_port->remote_identify.sas_address)
 			continue;
+		if (sas_node->phy[i].port != hba_port)
+			continue;
 		list_add_tail(&sas_node->phy[i].port_siblings,
 		    &mpt3sas_port->phy_list);
+		if (sas_node->handle <= ioc->sas_hba.num_phys)
+			hba_port->phy_mask |= (1 << i);
 		mpt3sas_port->num_phys++;
 	}
 
@@ -686,14 +698,21 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			    mpt3sas_phy->phy_id);
 		sas_port_add_phy(port, mpt3sas_phy->phy);
 		mpt3sas_phy->phy_belongs_to_port = 1;
+		mpt3sas_phy->port = hba_port;
 	}
 
 	mpt3sas_port->port = port;
-	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE)
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		rphy = sas_end_device_alloc(port);
-	else
+		if (sas_node->handle <= ioc->sas_hba.num_phys)
+			hba_port->sas_address = sas_device->sas_address;
+	} else {
 		rphy = sas_expander_alloc(port,
 		    mpt3sas_port->remote_identify.device_type);
+		if (sas_node->handle <= ioc->sas_hba.num_phys)
+			hba_port->sas_address =
+			    mpt3sas_port->remote_identify.sas_address;
+	}
 
 	rphy->identify = mpt3sas_port->remote_identify;
 
@@ -751,6 +770,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
  * @ioc: per adapter object
  * @sas_address: sas address of attached device
  * @sas_address_parent: sas address of parent expander or sas host
+ * @port: hba port entry
  * Context: This function will acquire ioc->sas_node_lock.
  *
  * Removing object and freeing associated memory from the
@@ -758,7 +778,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
  */
 void
 mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
-	u64 sas_address_parent)
+	u64 sas_address_parent, struct hba_port *port)
 {
 	int i;
 	unsigned long flags;
@@ -766,6 +786,10 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	struct _sas_node *sas_node;
 	u8 found = 0;
 	struct _sas_phy *mpt3sas_phy, *next_phy;
+	struct hba_port *hba_port_next, *hba_port = NULL;
+
+	if (!port)
+		return;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_node = _transport_sas_node_find_by_sas_address(ioc,
@@ -778,6 +802,8 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	    port_list) {
 		if (mpt3sas_port->remote_identify.sas_address != sas_address)
 			continue;
+		if (mpt3sas_port->hba_port != port)
+			continue;
 		found = 1;
 		list_del(&mpt3sas_port->port_list);
 		goto out;
@@ -788,6 +814,21 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		return;
 	}
 
+	if (sas_node->handle <= ioc->sas_hba.num_phys) {
+		list_for_each_entry_safe(hba_port, hba_port_next,
+		    &ioc->port_table_list, list) {
+			if (hba_port != port)
+				continue;
+			if (hba_port->sas_address != sas_address)
+				continue;
+			ioc_info(ioc,
+			    "remove hba_port entry: %p port: %d from hba_port list\n",
+			    hba_port, hba_port->port_id);
+			list_del(&hba_port->list);
+			kfree(hba_port);
+		}
+	}
+
 	for (i = 0; i < sas_node->num_phys; i++) {
 		if (sas_node->phy[i].remote_identify.sas_address == sas_address)
 			memset(&sas_node->phy[i].remote_identify, 0 ,
@@ -961,14 +1002,19 @@ mpt3sas_transport_add_expander_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
  * @handle: attached device handle
  * @phy_number: phy number
  * @link_rate: new link rate
+ * @port: hba port entry
+ *
+ * Return nothing.
  */
 void
 mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate)
+	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate,
+	struct hba_port *port)
 {
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct _sas_phy *mpt3sas_phy;
+	struct hba_port *hba_port = NULL;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery)
 		return;
@@ -988,6 +1034,15 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		    &mpt3sas_phy->remote_identify);
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address);
+		if (sas_node->handle <= ioc->sas_hba.num_phys) {
+			list_for_each_entry(hba_port,
+			    &ioc->port_table_list, list) {
+				if (hba_port->sas_address == sas_address &&
+				    hba_port == port)
+					hba_port->phy_mask |=
+					    (1 << mpt3sas_phy->phy_id);
+			}
+		}
 	} else
 		memset(&mpt3sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
-- 
2.18.4


--000000000000a1093a05b1401491
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
spkVu8pydHfaGSyCIyYl8M+65LxOkHkSZZt2y/Zp+FgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDI1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJWi3ukPtyaJAw08l5bx
76r6tCx/SW0EFDAmjQKhHBIipuJLPDZcejlH5jQOtndh/aILbp2E8KVhWTjRUzggCe8Rg5kzUL2q
2ZT15YGPNV7wcoUNlXAdYUXkcaxRjKAsulueLjrSLz49JcrCbqPXJxffLMYe7QtTDuTTOiYfzNFL
Is9/qktb1aH0o4Tiz7MSyQopjEEVggAHzYeYA6VOUBzhRQJnzZ881HjgsgMXJv+Bv4UYDnebOypy
Zb99UxYFrnjlYIenziErNX5qJlU3pMTzilIllF8/KoYKOwC/v5cByAxoGycrZTWWZXsq71UtTk1g
w9h7DmNdWmNmCChABDk=
--000000000000a1093a05b1401491--
