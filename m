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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0321FC433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B88122265
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iNYk3zso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbgJIROt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731745AbgJIROr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:47 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AD3C0613D5
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 7so7672913pgm.11
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d6J1fjKXrnaRDwolj8h8mOhIFSxetmOlRplJZt5LDHU=;
        b=iNYk3zso6OR7jIeR9ciW3l5Op2KGVw8l+K85qTIRtRO8dQGUnQgojtuTlStvcGDTA7
         BjLKIzEgjXsa9DceEkH956sJH0U11JYzhvDEcJ3WW5RSmufsLFnEuWINcut4zGiuO1Yz
         Z6aaZJ58loYottnb/ynJw+WWS3k9QGGGD9CRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d6J1fjKXrnaRDwolj8h8mOhIFSxetmOlRplJZt5LDHU=;
        b=paMm8Pp97zt5CicE22A64l0gbDmkSzbiZago68j8o1eWq36W5k/JsNuuDm5tvlUhxu
         nZqu2g//PW3ppfGi7qT1HGXr5XiXBn4u2ojQn/4+d5NgLhjXq/B0ZM64/23wpdGas0As
         xebtjAE4wVKvcxGYOHapYDyMo/rYD/BdyGF5N3Z4yPnyx7z4KPzfSYM3EH4/sSRMPlp2
         QkLsLFx3s32thT2LtViC7pbeKWSRTPjCbE5C8dPr0NSHm5ts9S5WEf+UpMcBLjiHRSQ0
         Fd5H06JNqRA041qPzaA3GAPUFLWn+xA19IUXXFvg3AuV3ktmiAQuzT5rq/PfAFkB51jw
         /tNA==
X-Gm-Message-State: AOAM533KL6InjuNE6OIsuLqWSccuLn7OLZnj4u1qIg99nTuAULxqy7TO
        wlMUVtCDk3fRWXzdQZUAxquQKA==
X-Google-Smtp-Source: ABdhPJxdbdy2F6XBKxJTtoXbMyf/w3unb5daLLDAkllb4nTCSkGYMfvvvaNnAwnSb2J/54CZQ6947g==
X-Received: by 2002:a65:4bcc:: with SMTP id p12mr4037430pgr.353.1602263686574;
        Fri, 09 Oct 2020 10:14:46 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:45 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 11/14] mpt3sas: Add bypass_dirty_port_flag parameter
Date:   Fri,  9 Oct 2020 22:44:37 +0530
Message-Id: <20201009171440.4949-12-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e63b1c05b1401509"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e63b1c05b1401509

Added a new parameter bypass_dirty_port_flag in function
mpt3sas_get_port_by_id(). When this parameter is set to one
then search for matching hba port entry from port_table_list
even when this hba_port entry is marked as dirty.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
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
index 22ffc50..522e4d0 100644
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
@@ -6189,7 +6196,7 @@ _scsih_alloc_vphy(struct MPT3SAS_ADAPTER *ioc, u8 port_id, u8 phy_num)
 	struct virtual_phy *vphy;
 	struct hba_port *port;
 
-	port = mpt3sas_get_port_by_id(ioc, port_id);
+	port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!port)
 		return NULL;
 
@@ -6263,7 +6270,7 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			ioc->sas_hba.handle = le16_to_cpu(
 			    sas_iounit_pg0->PhyData[0].ControllerDevHandle);
 		port_id = sas_iounit_pg0->PhyData[i].Port;
-		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+		if (!(mpt3sas_get_port_by_id(ioc, port_id, 0))) {
 			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
 			if (!port)
 				goto out;
@@ -6306,7 +6313,8 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		    AttachedDevHandle);
 		if (attached_handle && link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
 			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
-		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		ioc->sas_hba.phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 		mpt3sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
 		    attached_handle, i, link_rate,
 		    ioc->sas_hba.phy[i].port);
@@ -6430,7 +6438,7 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			    PhyData[0].ControllerDevHandle);
 
 		port_id = sas_iounit_pg0->PhyData[i].Port;
-		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+		if (!(mpt3sas_get_port_by_id(ioc, port_id, 0))) {
 			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
 			if (!port)
 				goto out;
@@ -6460,7 +6468,8 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		ioc->sas_hba.phy[i].phy_id = i;
-		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		ioc->sas_hba.phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 		mpt3sas_transport_add_host_phy(ioc, &ioc->sas_hba.phy[i],
 		    phy_pg0, ioc->sas_hba.parent_dev);
 	}
@@ -6552,7 +6561,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	if (sas_address_parent != ioc->sas_hba.sas_address) {
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-		    sas_address_parent, mpt3sas_get_port_by_id(ioc, port_id));
+		    sas_address_parent,
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (!sas_expander) {
 			rc = _scsih_expander_add(ioc, parent_handle);
@@ -6564,7 +6574,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_address = le64_to_cpu(expander_pg0.SASAddress);
 	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id, 0));
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	if (sas_expander)
@@ -6582,7 +6592,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	sas_expander->num_phys = expander_pg0.NumPhys;
 	sas_expander->sas_address_parent = sas_address_parent;
 	sas_expander->sas_address = sas_address;
-	sas_expander->port = mpt3sas_get_port_by_id(ioc, port_id);
+	sas_expander->port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!sas_expander->port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
@@ -6627,7 +6637,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		sas_expander->phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
+		sas_expander->phy[i].port =
+		    mpt3sas_get_port_by_id(ioc, port_id, 0);
 
 		if ((mpt3sas_transport_add_expander_phy(ioc,
 		    &sas_expander->phy[i], expander_pg1,
@@ -6834,7 +6845,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
-	port = mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort);
+	port = mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort, 0);
 	if (!port)
 		goto out_unlock;
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
@@ -6967,7 +6978,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 
 	port_id = sas_device_pg0.PhysicalPort;
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id, 0));
 	if (sas_device) {
 		clear_bit(handle, ioc->pend_os_device_add);
 		sas_device_put(sas_device);
@@ -7008,7 +7019,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 	sas_device->phy = sas_device_pg0.PhyNum;
 	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
 	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
-	sas_device->port = mpt3sas_get_port_by_id(ioc, port_id);
+	sas_device->port = mpt3sas_get_port_by_id(ioc, port_id, 0);
 	if (!sas_device->port) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
@@ -7223,7 +7234,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 
 	parent_handle = le16_to_cpu(event_data->ExpanderDevHandle);
-	port = mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort);
+	port = mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort, 0);
 
 	/* handle expander add */
 	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_ADDED)
@@ -7414,7 +7425,8 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(event_data->SASAddress);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address, mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort));
+	    sas_address,
+	    mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort, 0));
 
 	if (!sas_device || !sas_device->starget)
 		goto out;
@@ -8855,7 +8867,8 @@ _scsih_sas_pd_add(struct MPT3SAS_ADAPTER *ioc,
 	if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address))
 		mpt3sas_transport_update_links(ioc, sas_address, handle,
 		    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
-		    mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort));
+		    mpt3sas_get_port_by_id(ioc,
+		    sas_device_pg0.PhysicalPort, 0));
 
 	_scsih_ir_fastpath(ioc, handle, element->PhysDiskNum);
 	_scsih_add_device(ioc, handle, 0, 1);
@@ -9163,7 +9176,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 			mpt3sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5,
 			    mpt3sas_get_port_by_id(ioc,
-			    sas_device_pg0.PhysicalPort));
+			    sas_device_pg0.PhysicalPort, 0));
 
 		_scsih_add_device(ioc, handle, 0, 1);
 
@@ -9289,7 +9302,7 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 	struct _enclosure_node *enclosure_dev = NULL;
 	unsigned long flags;
 	struct hba_port *port = mpt3sas_get_port_by_id(
-	    ioc, sas_device_pg0->PhysicalPort);
+	    ioc, sas_device_pg0->PhysicalPort, 0);
 
 	if (sas_device_pg0->EnclosureHandle) {
 		enclosure_dev =
@@ -9717,7 +9730,7 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 	u16 enclosure_handle = le16_to_cpu(expander_pg0->EnclosureHandle);
 	u64 sas_address = le64_to_cpu(expander_pg0->SASAddress);
 	struct hba_port *port = mpt3sas_get_port_by_id(
-	    ioc, expander_pg0->PhysicalPort);
+	    ioc, expander_pg0->PhysicalPort, 0);
 
 	if (enclosure_handle)
 		enclosure_dev =
@@ -9964,7 +9977,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		port_id = expander_pg0.PhysicalPort;
 		expander_device = mpt3sas_scsih_expander_find_by_sas_address(
 		    ioc, le64_to_cpu(expander_pg0.SASAddress),
-		    mpt3sas_get_port_by_id(ioc, port_id));
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
@@ -10027,7 +10040,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			mpt3sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5,
-			    mpt3sas_get_port_by_id(ioc, port_id));
+			    mpt3sas_get_port_by_id(ioc, port_id, 0));
 			set_bit(handle, ioc->pd_handles);
 			retry_count = 0;
 			/* This will retry adding the end device.
@@ -10116,7 +10129,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		port_id = sas_device_pg0.PhysicalPort;
 		sas_device = mpt3sas_get_sdev_by_addr(ioc,
 		    le64_to_cpu(sas_device_pg0.SASAddress),
-		    mpt3sas_get_port_by_id(ioc, port_id));
+		    mpt3sas_get_port_by_id(ioc, port_id, 0));
 		if (sas_device) {
 			sas_device_put(sas_device);
 			continue;
@@ -10128,7 +10141,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
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


--000000000000e63b1c05b1401509
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
XcrRIQTU1bYuGSzYrzI/5zK4R2ZjuloRIii9ezEgRKQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDQ2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAH1r6kg650LKMSv6uqGC
dNPI/diV2mGE3cw3yDbDkaYE0m5qsYadx0YFIq1GSUphlNZ1ISFJDje8fBOnMicAeZbCWKrwZyGp
FzK6t5EZoGArRzKfBeA1102c/1ElwkymY0AksiILtycCo1M/LizogyU+LrX6g3TDFIqDRIOXhPnM
Evzv0GHpeV8iJKjy27Rbnu+DbgB3K1qtT3rAT5F9+geke7Z+7FBSZbZ6qW3WdEBA1bUjAengqT/f
maGOD8S4Nvz8v2HtffybVxFNsNTNZ4n/wM+jk/O7CqXBUx4SkYjXDHHTx3eJ39ncIM48S5FIPsY2
//wFPTg/HQLdVVzZHUI=
--000000000000e63b1c05b1401509--
