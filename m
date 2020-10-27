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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF81C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6799020829
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Pn+BROSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751838AbgJ0NIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38144 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbgJ0NIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id f21so730497plr.5
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kLljICZPGJZD1YlrdX7cEhGJSSk7EH3X/eT1E5k7iqo=;
        b=Pn+BROSpcaKBWMA+ic/ryA2+2xpe7b2NYNpNl0jxie/xgB2vWGrvU6vR71P76SpSxW
         ytGR1meSA5LxWH5bNaIQ3FQn1q6Z2t0VFBgbrz9k+L9glRZY5opOMshRyBlTHEYERIBC
         EahSEz7BCg3D7UDo4hg1oOi3ctt3jVV8rmeJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kLljICZPGJZD1YlrdX7cEhGJSSk7EH3X/eT1E5k7iqo=;
        b=KIVwb6nTWU1z1dmEcA8hFb3P4aCW26zisTonUI9vGLLBzKlfksALbNOb09Z9RcEtjL
         ZH3202nbOSDk9I+Yt55HkVHm/aXidz8hMuaq7TR5vTEUZ2Sp7Cp4yqL0tEYls8BW6szk
         CEgpw6SJgcazrDH2mb9FhZwfkHE3KNviqidwqPlRKvyjLcKns0c3XwbKXGUx+gsQnX5u
         YJsNRTZBCFSu1RrK0OtFx5TnQPot+NgscdIbSu+ffQupU69i7Rq50gTUoqB31RTi8XS7
         zLZvfC02b7E6a6sNNabR/j0O3vA9iWjk2+AZ8ES60U48gWfbihywnjSrkQ4Ng3ac9FKq
         9SLQ==
X-Gm-Message-State: AOAM531FkfbU5EKlprwtdOD+VHVaq4Q1nWOFtxofCMmfFHppWDzJokn8
        SOR0bS33gVgSzOnn9tCcLACCz6t+FNUzCg==
X-Google-Smtp-Source: ABdhPJz/FWudMpMP3vRWAH5cvBHi9C8W82hnPkO4c9NnSp+PGT5mj7eT4KTg6ACWGjnT6dt8EJSdlQ==
X-Received: by 2002:a17:90b:92:: with SMTP id bb18mr2006087pjb.108.1603804131880;
        Tue, 27 Oct 2020 06:08:51 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:51 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 11/14] mpt3sas: Add bypass_dirty_port_flag parameter
Date:   Tue, 27 Oct 2020 18:38:44 +0530
Message-Id: <20201027130847.9962-12-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000995d9805b2a6bfab"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000995d9805b2a6bfab

Added a new parameter bypass_dirty_port_flag in function
mpt3sas_get_port_by_id(). When this parameter is set to one
then search for matching hba port entry from port_table_list
even when this hba_port entry is marked as dirty.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 63 ++++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 +--
 3 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e7d047a..cca14ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1684,7 +1684,8 @@ void mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 u8 mpt3sas_check_for_pending_internal_cmds(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
 struct hba_port *
-mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port);
+mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port,
+	u8 bypass_dirty_port_flag);
 
 struct _sas_node *mpt3sas_scsih_expander_find_by_handle(
 	struct MPT3SAS_ADAPTER *ioc, u16 handle);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6463876..b033f19 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -361,20 +361,27 @@ _scsih_srch_boot_encl_slot(u64 enclosure_logical_id, u16 slot_number,
  *			  port number from port list
  * @ioc: per adapter object
  * @port_id: port number
+ * @bypass_dirty_port_flag: when set look the matching hba port entry even
+ *			if hba port entry is marked as dirty.
  *
  * Search for hba port entry corresponding to provided port number,
  * if available return port object otherwise return NULL.
  */
 struct hba_port *
-mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port_id)
+mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc,
+	u8 port_id, u8 bypass_dirty_port_flag)
 {
 	struct hba_port *port, *port_next;
 
 	list_for_each_entry_safe(port, port_next,
 	    &ioc->port_table_list, list) {
-		if (port->port_id == port_id &&
-		    !(port->flags & HBA_PORT_FLAG_DIRTY_PORT))
+		if (port->port_id != port_id)
+			continue;
+		if (bypass_dirty_port_flag)
 			return port;
+		if (port->flags & HBA_PORT_FLAG_DIRTY_PORT)
+			continue;
+		return port;
 	}
 
 	return NULL;
@@ -6190,7 +6197,7 @@ _scsih_alloc_vphy(struct MPT3SAS_ADAPTER *ioc, u8 port_id, u8 phy_num)
 	struct virtual_phy *vphy;
 	struct hba_port *port;
 
-	port = mpt3sas_get_port_by_id(ioc, port_id);
+	port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!port)
 		return NULL;
 
@@ -6264,7 +6271,7 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			ioc->sas_hba.handle = le16_to_cpu(
 			    sas_iounit_pg0->PhyData[0].ControllerDevHandle);
 		port_id = sas_iounit_pg0->PhyData[i].Port;
-		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+		if (!(mpt3sas_get_port_by_id(ioc, port_id, 0))) {
 			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
 			if (!port)
 				goto out;
@@ -6307,7 +6314,8 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		    AttachedDevHandle);
 		if (attached_handle && link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
 			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
-		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		ioc->sas_hba.phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 		mpt3sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
 		    attached_handle, i, link_rate,
 		    ioc->sas_hba.phy[i].port);
@@ -6431,7 +6439,7 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			    PhyData[0].ControllerDevHandle);
 
 		port_id = sas_iounit_pg0->PhyData[i].Port;
-		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+		if (!(mpt3sas_get_port_by_id(ioc, port_id, 0))) {
 			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
 			if (!port)
 				goto out;
@@ -6461,7 +6469,8 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		ioc->sas_hba.phy[i].phy_id = i;
-		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		ioc->sas_hba.phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 		mpt3sas_transport_add_host_phy(ioc, &ioc->sas_hba.phy[i],
 		    phy_pg0, ioc->sas_hba.parent_dev);
 	}
@@ -6553,7 +6562,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	if (sas_address_parent != ioc->sas_hba.sas_address) {
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-		    sas_address_parent, mpt3sas_get_port_by_id(ioc, port_id));
+		    sas_address_parent,
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (!sas_expander) {
 			rc = _scsih_expander_add(ioc, parent_handle);
@@ -6565,7 +6575,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_address = le64_to_cpu(expander_pg0.SASAddress);
 	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id, 0));
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	if (sas_expander)
@@ -6583,7 +6593,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander->num_phys = expander_pg0.NumPhys;
 	sas_expander->sas_address_parent = sas_address_parent;
 	sas_expander->sas_address = sas_address;
-	sas_expander->port = mpt3sas_get_port_by_id(ioc, port_id);
+	sas_expander->port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!sas_expander->port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
@@ -6628,7 +6638,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		sas_expander->phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		sas_expander->phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 
 		if ((mpt3sas_transport_add_expander_phy(ioc,
 		    &sas_expander->phy[i], expander_pg1,
@@ -6835,7 +6846,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
-	port = mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort);
+	port = mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort, 0);
 	if (!port)
 		goto out_unlock;
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
@@ -6968,7 +6979,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 
 	port_id = sas_device_pg0.PhysicalPort;
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id, 0));
 	if (sas_device) {
 		clear_bit(handle, ioc->pend_os_device_add);
 		sas_device_put(sas_device);
@@ -7009,7 +7020,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	sas_device->phy = sas_device_pg0.PhyNum;
 	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
-	sas_device->port = mpt3sas_get_port_by_id(ioc, port_id);
+	sas_device->port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!sas_device->port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
@@ -7224,7 +7235,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	parent_handle = le16_to_cpu(event_data->ExpanderDevHandle);
-	port = mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort);
+	port = mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort, 0);
 
 	/* handle expander add */
 	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_ADDED)
@@ -7415,7 +7426,8 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(event_data->SASAddress);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort));
+	    sas_address,
+	    mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort, 0));
 
 	if (!sas_device || !sas_device->starget)
 		goto out;
@@ -8856,7 +8868,8 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 	if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
 		mpt3sas_transport_update_links(ioc, sas_address, handle,
 		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
-		    mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort));
+		    mpt3sas_get_port_by_id(ioc,
+		    sas_device_pg0.PhysicalPort, 0));
 
 	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
 	_scsih_add_device(ioc, handle, 0, 1);
@@ -9164,7 +9177,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
 			    mpt3sas_get_port_by_id(ioc,
-			    sas_device_pg0.PhysicalPort));
+			    sas_device_pg0.PhysicalPort, 0));
 
 		_scsih_add_device(ioc, handle, 0, 1);
 
@@ -9290,7 +9303,7 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 	struct _enclosure_node *enclosure_dev = NULL;
 	unsigned long flags;
 	struct hba_port *port = mpt3sas_get_port_by_id(
-	    ioc, sas_device_pg0->PhysicalPort);
+	    ioc, sas_device_pg0->PhysicalPort, 0);
 
 	if (sas_device_pg0->EnclosureHandle) {
 		enclosure_dev =
@@ -9718,7 +9731,7 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 	u16 enclosure_handle = le16_to_cpu(expander_pg0->EnclosureHandle);
 	u64 sas_address = le64_to_cpu(expander_pg0->SASAddress);
 	struct hba_port *port = mpt3sas_get_port_by_id(
-	    ioc, expander_pg0->PhysicalPort);
+	    ioc, expander_pg0->PhysicalPort, 0);
 
 	if (enclosure_handle)
 		enclosure_dev =
@@ -9965,7 +9978,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		port_id = expander_pg0.PhysicalPort;
 		expander_device = mpt3sas_scsih_expander_find_by_sas_address(
 		    ioc, le64_to_cpu(expander_pg0.SASAddress),
-		    mpt3sas_get_port_by_id(ioc, port_id));
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
@@ -10028,7 +10041,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			mpt3sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5,
-			    mpt3sas_get_port_by_id(ioc, port_id));
+			    mpt3sas_get_port_by_id(ioc, port_id, 0));
 			set_bit(handle, ioc->pd_handles);
 			retry_count = 0;
 			/* This will retry adding the end device.
@@ -10117,7 +10130,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		port_id = sas_device_pg0.PhysicalPort;
 		sas_device = mpt3sas_get_sdev_by_addr(ioc,
 		    le64_to_cpu(sas_device_pg0.SASAddress),
-		    mpt3sas_get_port_by_id(ioc, port_id));
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		if (sas_device) {
 			sas_device_put(sas_device);
 			continue;
@@ -10129,7 +10142,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 				 (u64)le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
-			    mpt3sas_get_port_by_id(ioc, port_id));
+			    mpt3sas_get_port_by_id(ioc, port_id, 0));
 			retry_count = 0;
 			/* This will retry adding the end device.
 			 * _scsih_add_device() will decide on retries and
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 256dae1..0d06025 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1414,7 +1414,7 @@ _transport_get_linkerrors(struct sas_phy *phy)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
 	    phy->identify.sas_address,
-	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
+	    mpt3sas_get_port_by_id(ioc, port_id, 0)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1703,7 +1703,7 @@ _transport_phy_reset(struct sas_phy *phy, int hard_reset)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
 	    phy->identify.sas_address,
-	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
+	    mpt3sas_get_port_by_id(ioc, port_id, 0)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1762,7 +1762,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
 	    phy->identify.sas_address,
-	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
+	    mpt3sas_get_port_by_id(ioc, port_id, 0)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1902,7 +1902,7 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
 	    phy->identify.sas_address,
-	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
+	    mpt3sas_get_port_by_id(ioc, port_id, 0)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
-- 
2.18.4


--000000000000995d9805b2a6bfab
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
uctR4RxOpBS+SFVPTF17F27JQP9PuD0oFvVfD1eS1VQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODUyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABG4YxW1TK2LWd3oFMoh
B7OLQ+ebg0W33I91ZdIx1wk0BV9z+rKnWyUPeQk6QmOl7YqAqSdnWZwJkU8l+WlWFKzzZ5C1+jwa
bMenIf6yfyHB5LabtIka+bNbt++2s/eAjU8Y0OX2YmIe6cpNVCeSdw4JyoyYmjtVRMU2M2v5kKs/
Bscs2AdimVw785SLraOEl9S/W7EjqkGTnjJTbHfqxphzF9SZWP4KLBx15azkNm+USL5d17ZG+bmF
6S5a80p38zyyKYHkJU6SYxn+LwJ88mqnskhJ3f93S2bdn+SW713aWcfOonrj0QRTFeD8YfQZZWcC
hFQp7o2PPKF5/OlhQIo=
--000000000000995d9805b2a6bfab--
