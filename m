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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB972C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F29F20829
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dXxraGnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751859AbgJ0NIh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47070 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbgJ0NIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id y14so870378pfp.13
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7PXCzGzyAmwCTLjqftH/cZ+D7jEdEHk/ia4oPx2XZZo=;
        b=dXxraGncH6JOp1s0gK4D9ljMLRF2iDB8Qo7C9nmy1H6sEkOqRHa6mxvKLe2kTs1z4i
         oBTEHmyQLRdrQYicgCnPINu8I9egdhG0W1g9bA/LeBdIuXwYQDFxL/BGlocpk7uRj8O+
         dsknoixOlDZT1RcUZ+pajkxTerf2oiL0MpRBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7PXCzGzyAmwCTLjqftH/cZ+D7jEdEHk/ia4oPx2XZZo=;
        b=YevNZ3nxoxVdH499gytzLHIuSJaLO/Jgl1TscCUIsBb9eY4RIzFMo0J01DaD12ZVpp
         2Hceh1SpbmRiYJmfLonYXNAM8iNNyS3yZ/5Kl8qV/7rISvuCb4RKv8u/ckXbSVqz28JA
         zm7qK+WZuJ4FmAghdxD3uzRoYYQWOBKPdiu6kLpw8F7qXq+5XT/1fKsykUBqOjn52MaD
         SsfakIfmeSE4y4jpR0mZKaRGw7PuR/O+dqxN2U7yFJefFNEWzv0jk/z8K75ZgFsXX4Z4
         Wr7MxSCbkwqGv8iKvyNqVuaj/bqmRLT/wzXhW1dS0/l76rac4ZJhoGA9a+4WAqb0X0n1
         Zc6A==
X-Gm-Message-State: AOAM530KkyztFvRo1/5CIozkyfun3mQBBqZuWZqIhkWtAwYmoxEfr2Jd
        +obi3K7MAPNOiUat+V/8ics9QA==
X-Google-Smtp-Source: ABdhPJztwEWuba2z9LHoj5BOpIiqNClthRekI39MlXozZ+sauF8a5ejiRyPWwlzvT/ZBi6eej+ATTQ==
X-Received: by 2002:a62:8458:0:b029:160:843:18b7 with SMTP id k85-20020a6284580000b0290160084318b7mr2210037pfd.77.1603804114174;
        Tue, 27 Oct 2020 06:08:34 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:33 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 05/14] mpt3sas: Get device objects using sas_address & portID
Date:   Tue, 27 Oct 2020 18:38:38 +0530
Message-Id: <20201027130847.9962-6-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008d9a6805b2a6be9c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008d9a6805b2a6be9c

Currently driver retrieve the sas_devie/sas_expander objects
from corresponding object's lists using just device's
SAS Address. Now driver will retrieve the objects from the
corresponding objects list using device's SAS Address
and PhysicalPort(or PortID) number.

where
PhysicalPort number - Port number of the HBA through which this
device is accessing.

Here are the list of objects that driver retrieves based on
SAS Address & PhysicalPort number,

* Retrieve sas_device object from sas_device_list using device's
  SAS Address & PhysicalPort number,
* Retrieve sas_expander object from sas_expander_list using expander
  device's SAS Address & PhysicalPort number,

Also, where ever driver is matching the objects with device's
SAS Address, now, in addition to it driver has to match the device
PhysicalPort number also.

Added additional function parameter named 'port' of type
struct hba_port in below list of functions,
 * mpt3sas_expander_remove()
 * mpt3sas_device_remove_by_sas_address()
 * mpt3sas_scsih_expander_find_by_sas_address()
 * mpt3sas_get_sdev_by_addr()
 * __mpt3sas_get_sdev_by_addr()
 * _scsih_ublock_io_device()
 * _transport_sas_node_find_by_sas_address()
 * _transport_sanity_check()

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  16 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 175 ++++++++++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  74 ++++++----
 3 files changed, 178 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index aef872a..b5d1fc5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1652,20 +1652,26 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 void mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 void mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle);
-void mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
+void mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	struct hba_port *port);
 void mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address);
+	u64 sas_address, struct hba_port *port);
 u8 mpt3sas_check_for_pending_internal_cmds(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
+struct hba_port *
+mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port);
 
 struct _sas_node *mpt3sas_scsih_expander_find_by_handle(
 	struct MPT3SAS_ADAPTER *ioc, u16 handle);
 struct _sas_node *mpt3sas_scsih_expander_find_by_sas_address(
-	struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
+	struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	struct hba_port *port);
 struct _sas_device *mpt3sas_get_sdev_by_addr(
-	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
+	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	 struct hba_port *port);
 struct _sas_device *__mpt3sas_get_sdev_by_addr(
-	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
+	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	 struct hba_port *port);
 struct _sas_device *mpt3sas_get_sdev_by_handle(struct MPT3SAS_ADAPTER *ioc,
 	u16 handle);
 struct _pcie_device *mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0067025..4542d66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -638,48 +638,67 @@ mpt3sas_get_pdev_from_target(struct MPT3SAS_ADAPTER *ioc,
 	return ret;
 }
 
+/**
+ * mpt3sas_get_sdev_by_addr - get _sas_device object corresponding to provided
+ *				sas address from sas_device_list list
+ * @ioc: per adapter object
+ * @port: port number
+ *
+ * Search for _sas_device object corresponding to provided sas address,
+ * if available return _sas_device object address otherwise return NULL.
+ */
 struct _sas_device *
 __mpt3sas_get_sdev_by_addr(struct MPT3SAS_ADAPTER *ioc,
-					u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	struct _sas_device *sas_device;
 
+	if (!port)
+		return NULL;
+
 	assert_spin_locked(&ioc->sas_device_lock);
 
-	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
-		if (sas_device->sas_address == sas_address)
-			goto found_device;
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
+		if (sas_device->sas_address != sas_address)
+			continue;
+		if (sas_device->port != port)
+			continue;
+		sas_device_get(sas_device);
+		return sas_device;
+	}
 
-	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
-		if (sas_device->sas_address == sas_address)
-			goto found_device;
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list) {
+		if (sas_device->sas_address != sas_address)
+			continue;
+		if (sas_device->port != port)
+			continue;
+		sas_device_get(sas_device);
+		return sas_device;
+	}
 
 	return NULL;
-
-found_device:
-	sas_device_get(sas_device);
-	return sas_device;
 }
 
 /**
  * mpt3sas_get_sdev_by_addr - sas device search
  * @ioc: per adapter object
  * @sas_address: sas address
+ * @port: hba port entry
  * Context: Calling function should acquire ioc->sas_device_lock
  *
- * This searches for sas_device based on sas_address, then return sas_device
- * object.
+ * This searches for sas_device based on sas_address & port number,
+ * then return sas_device object.
  */
 struct _sas_device *
 mpt3sas_get_sdev_by_addr(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-			sas_address);
+	    sas_address, port);
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	return sas_device;
@@ -848,13 +867,17 @@ _scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 }
 
 /**
- * mpt3sas_device_remove_by_sas_address - removing device object by sas address
+ * mpt3sas_device_remove_by_sas_address - removing device object by
+ *					sas address & port number
  * @ioc: per adapter object
  * @sas_address: device sas_address
+ * @port: hba port entry
+ *
+ * Return nothing.
  */
 void
 mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	struct _sas_device *sas_device;
 	unsigned long flags;
@@ -863,7 +886,7 @@ mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	sas_device = __mpt3sas_get_sdev_by_addr(ioc, sas_address);
+	sas_device = __mpt3sas_get_sdev_by_addr(ioc, sas_address, port);
 	if (sas_device) {
 		list_del_init(&sas_device->list);
 		sas_device_put(sas_device);
@@ -1457,21 +1480,26 @@ out:
  * mpt3sas_scsih_expander_find_by_sas_address - expander device search
  * @ioc: per adapter object
  * @sas_address: sas address
+ * @port: hba port entry
  * Context: Calling function should acquire ioc->sas_node_lock.
  *
- * This searches for expander device based on sas_address, then returns the
- * sas_node object.
+ * This searches for expander device based on sas_address & port number,
+ * then returns the sas_node object.
  */
 struct _sas_node *
 mpt3sas_scsih_expander_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
-	struct _sas_node *sas_expander, *r;
+	struct _sas_node *sas_expander, *r = NULL;
+
+	if (!port)
+		return r;
 
-	r = NULL;
 	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
 		if (sas_expander->sas_address != sas_address)
 			continue;
+		if (sas_expander->port != port)
+			continue;
 		r = sas_expander;
 		goto out;
 	}
@@ -1788,7 +1816,7 @@ scsih_target_alloc(struct scsi_target *starget)
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	rphy = dev_to_rphy(starget->dev.parent);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	   rphy->identify.sas_address);
+	   rphy->identify.sas_address, NULL);
 
 	if (sas_device) {
 		sas_target_priv_data->handle = sas_device->handle;
@@ -1949,7 +1977,8 @@ scsih_slave_alloc(struct scsi_device *sdev)
 	} else  if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-					sas_target_priv_data->sas_address);
+		    sas_target_priv_data->sas_address,
+		    sas_target_priv_data->port);
 		if (sas_device && (sas_device->starget == NULL)) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s : sas_device->starget set to starget @ %d\n",
@@ -2554,7 +2583,8 @@ scsih_slave_configure(struct scsi_device *sdev)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	   sas_device_priv_data->sas_target->sas_address);
+	   sas_device_priv_data->sas_target->sas_address,
+	   sas_device_priv_data->sas_target->port);
 	if (!sas_device) {
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		dfailprintk(ioc,
@@ -3669,11 +3699,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
  * _scsih_ublock_io_device - prepare device to be deleted
  * @ioc: per adapter object
  * @sas_address: sas address
+ * @port: hba port entry
  *
  * unblock then put device in offline state
  */
 static void
-_scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
+_scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
+	u64 sas_address, struct hba_port *port)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
@@ -3685,6 +3717,8 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
 			continue;
+		if (sas_device_priv_data->sas_target->port != port)
+			continue;
 		if (sas_device_priv_data->block)
 			_scsih_internal_device_unblock(sdev,
 				sas_device_priv_data);
@@ -3785,7 +3819,8 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT3SAS_ADAPTER *ioc,
 		    SAS_END_DEVICE) {
 			spin_lock_irqsave(&ioc->sas_device_lock, flags);
 			sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-			    mpt3sas_port->remote_identify.sas_address);
+			    mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 			if (sas_device) {
 				set_bit(sas_device->handle,
 						ioc->blocking_handles);
@@ -3804,7 +3839,8 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT3SAS_ADAPTER *ioc,
 		    SAS_FANOUT_EXPANDER_DEVICE) {
 			expander_sibling =
 			    mpt3sas_scsih_expander_find_by_sas_address(
-			    ioc, mpt3sas_port->remote_identify.sas_address);
+			    ioc, mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 			_scsih_block_io_to_children_attached_to_ex(ioc,
 			    expander_sibling);
 		}
@@ -3893,6 +3929,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct _tr_list *delayed_tr;
 	u32 ioc_state;
 	u8 tr_method = 0;
+	struct hba_port *port = NULL;
 
 	if (ioc->pci_error_recovery) {
 		dewtprintk(ioc,
@@ -3921,6 +3958,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		sas_target_priv_data = sas_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
 		sas_address = sas_device->sas_address;
+		port = sas_device->port;
 	}
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	if (!sas_device) {
@@ -3968,7 +4006,7 @@ _scsih_tm_tr_send(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 						    pcie_device->enclosure_level,
 						    pcie_device->connector_name));
 		}
-		_scsih_ublock_io_device(ioc, sas_address);
+		_scsih_ublock_io_device(ioc, sas_address, port);
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
 
@@ -6036,7 +6074,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	if (sas_address_parent != ioc->sas_hba.sas_address) {
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
 		sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-		    sas_address_parent);
+		    sas_address_parent, mpt3sas_get_port_by_id(ioc, port_id));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (!sas_expander) {
 			rc = _scsih_expander_add(ioc, parent_handle);
@@ -6048,7 +6086,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_address = le64_to_cpu(expander_pg0.SASAddress);
 	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-	    sas_address);
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	if (sas_expander)
@@ -6149,7 +6187,8 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * @sas_address: expander sas_address
  */
 void
-mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
+mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
+	struct hba_port *port)
 {
 	struct _sas_node *sas_expander;
 	unsigned long flags;
@@ -6157,9 +6196,12 @@ mpt3sas_expander_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 	if (ioc->shost_recovery)
 		return;
 
+	if (!port)
+		return;
+
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_expander = mpt3sas_scsih_expander_find_by_sas_address(ioc,
-	    sas_address);
+	    sas_address, port);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 	if (sas_expander)
 		_scsih_expander_node_remove(ioc, sas_expander);
@@ -6282,7 +6324,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 {
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasDevicePage0_t sas_device_pg0;
-	struct _sas_device *sas_device;
+	struct _sas_device *sas_device = NULL;
 	struct _enclosure_node *enclosure_dev = NULL;
 	u32 ioc_status;
 	unsigned long flags;
@@ -6290,6 +6332,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 	struct scsi_target *starget;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	u32 device_info;
+	struct hba_port *port;
 
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle)))
@@ -6312,8 +6355,11 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+	port = mpt3sas_get_port_by_id(ioc, sas_device_pg0.PhysicalPort);
+	if (!port)
+		goto out_unlock;
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address);
+	    sas_address, port);
 
 	if (!sas_device)
 		goto out_unlock;
@@ -6369,7 +6415,7 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
 		goto out_unlock;
 
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-	_scsih_ublock_io_device(ioc, sas_address);
+	_scsih_ublock_io_device(ioc, sas_address, port);
 
 	if (sas_device)
 		sas_device_put(sas_device);
@@ -6442,7 +6488,7 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
 
 	port_id = sas_device_pg0.PhysicalPort;
 	sas_device = mpt3sas_get_sdev_by_addr(ioc,
-					sas_address);
+	    sas_address, mpt3sas_get_port_by_id(ioc, port_id));
 	if (sas_device) {
 		clear_bit(handle, ioc->pend_os_device_add);
 		sas_device_put(sas_device);
@@ -6555,7 +6601,8 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 	if (sas_device->starget && sas_device->starget->hostdata) {
 		sas_target_priv_data = sas_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
-		_scsih_ublock_io_device(ioc, sas_device->sas_address);
+		_scsih_ublock_io_device(ioc, sas_device->sas_address,
+		    sas_device->port);
 		sas_target_priv_data->handle =
 		     MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
@@ -6787,7 +6834,7 @@ _scsih_sas_topology_change_event(struct MPT3SAS_ADAPTER *ioc,
 	/* handle expander removal */
 	if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING &&
 	    sas_expander)
-		mpt3sas_expander_remove(ioc, sas_address);
+		mpt3sas_expander_remove(ioc, sas_address, port);
 
 	return 0;
 }
@@ -6888,7 +6935,7 @@ _scsih_sas_device_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_address = le64_to_cpu(event_data->SASAddress);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    sas_address);
+	    sas_address, mpt3sas_get_port_by_id(ioc, event_data->PhysicalPort));
 
 	if (!sas_device || !sas_device->starget)
 		goto out;
@@ -7037,7 +7084,7 @@ _scsih_pcie_device_remove_from_sml(struct MPT3SAS_ADAPTER *ioc,
 	if (pcie_device->starget && pcie_device->starget->hostdata) {
 		sas_target_priv_data = pcie_device->starget->hostdata;
 		sas_target_priv_data->deleted = 1;
-		_scsih_ublock_io_device(ioc, pcie_device->wwid);
+		_scsih_ublock_io_device(ioc, pcie_device->wwid, NULL);
 		sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
 
@@ -7159,7 +7206,7 @@ _scsih_pcie_check_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 	pcie_device_put(pcie_device);
 
-	_scsih_ublock_io_device(ioc, wwid);
+	_scsih_ublock_io_device(ioc, wwid, NULL);
 
 	return;
 }
@@ -8762,6 +8809,8 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 	struct _sas_device *sas_device = NULL;
 	struct _enclosure_node *enclosure_dev = NULL;
 	unsigned long flags;
+	struct hba_port *port = mpt3sas_get_port_by_id(
+	    ioc, sas_device_pg0->PhysicalPort);
 
 	if (sas_device_pg0->EnclosureHandle) {
 		enclosure_dev =
@@ -8778,6 +8827,8 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 			continue;
 		if (sas_device->slot != le16_to_cpu(sas_device_pg0->Slot))
 			continue;
+		if (sas_device->port != port)
+			continue;
 		sas_device->responding = 1;
 		starget = sas_device->starget;
 		if (starget && starget->hostdata) {
@@ -9186,6 +9237,8 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 	u16 handle = le16_to_cpu(expander_pg0->DevHandle);
 	u16 enclosure_handle = le16_to_cpu(expander_pg0->EnclosureHandle);
 	u64 sas_address = le64_to_cpu(expander_pg0->SASAddress);
+	struct hba_port *port = mpt3sas_get_port_by_id(
+	    ioc, expander_pg0->PhysicalPort);
 
 	if (enclosure_handle)
 		enclosure_dev =
@@ -9196,6 +9249,8 @@ _scsih_mark_responding_expander(struct MPT3SAS_ADAPTER *ioc,
 	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
 		if (sas_expander->sas_address != sas_address)
 			continue;
+		if (sas_expander->port != port)
+			continue;
 		sas_expander->responding = 1;
 
 		if (enclosure_dev) {
@@ -9252,9 +9307,10 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 
 		handle = le16_to_cpu(expander_pg0.DevHandle);
 		sas_address = le64_to_cpu(expander_pg0.SASAddress);
-		pr_info("\texpander present: handle(0x%04x), sas_addr(0x%016llx)\n",
-			handle,
-		    (unsigned long long)sas_address);
+		pr_info(
+		    "\texpander present: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
+		    handle, (unsigned long long)sas_address,
+		    expander_pg0.PhysicalPort);
 		_scsih_mark_responding_expander(ioc, &expander_pg0);
 	}
 
@@ -9426,8 +9482,10 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		}
 		handle = le16_to_cpu(expander_pg0.DevHandle);
 		spin_lock_irqsave(&ioc->sas_node_lock, flags);
+		port_id = expander_pg0.PhysicalPort;
 		expander_device = mpt3sas_scsih_expander_find_by_sas_address(
-		    ioc, le64_to_cpu(expander_pg0.SASAddress));
+		    ioc, le64_to_cpu(expander_pg0.SASAddress),
+		    mpt3sas_get_port_by_id(ioc, port_id));
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
@@ -9578,7 +9636,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		port_id = sas_device_pg0.PhysicalPort;
 		sas_device = mpt3sas_get_sdev_by_addr(ioc,
-		    le64_to_cpu(sas_device_pg0.SASAddress));
+		    le64_to_cpu(sas_device_pg0.SASAddress),
+		    mpt3sas_get_port_by_id(ioc, port_id));
 		if (sas_device) {
 			sas_device_put(sas_device);
 			continue;
@@ -10023,21 +10082,25 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 		if (mpt3sas_port->remote_identify.device_type ==
 		    SAS_END_DEVICE)
 			mpt3sas_device_remove_by_sas_address(ioc,
-			    mpt3sas_port->remote_identify.sas_address);
+			    mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 		else if (mpt3sas_port->remote_identify.device_type ==
 		    SAS_EDGE_EXPANDER_DEVICE ||
 		    mpt3sas_port->remote_identify.device_type ==
 		    SAS_FANOUT_EXPANDER_DEVICE)
 			mpt3sas_expander_remove(ioc,
-			    mpt3sas_port->remote_identify.sas_address);
+			    mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 	}
 
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
 	    sas_expander->sas_address_parent, sas_expander->port);
 
-	ioc_info(ioc, "expander_remove: handle(0x%04x), sas_addr(0x%016llx)\n",
-		 sas_expander->handle, (unsigned long long)
-		 sas_expander->sas_address);
+	ioc_info(ioc,
+	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
+	    sas_expander->handle, (unsigned long long)
+	    sas_expander->sas_address,
+	    sas_expander->port->port_id);
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);
@@ -10283,13 +10346,15 @@ static void scsih_remove(struct pci_dev *pdev)
 		if (mpt3sas_port->remote_identify.device_type ==
 		    SAS_END_DEVICE)
 			mpt3sas_device_remove_by_sas_address(ioc,
-			    mpt3sas_port->remote_identify.sas_address);
+			    mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 		else if (mpt3sas_port->remote_identify.device_type ==
 		    SAS_EDGE_EXPANDER_DEVICE ||
 		    mpt3sas_port->remote_identify.device_type ==
 		    SAS_FANOUT_EXPANDER_DEVICE)
 			mpt3sas_expander_remove(ioc,
-			    mpt3sas_port->remote_identify.sas_address);
+			    mpt3sas_port->remote_identify.sas_address,
+			    mpt3sas_port->hba_port);
 	}
 
 	list_for_each_entry_safe(port, port_next,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index aab3b14..54c004e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -64,6 +64,7 @@
  * _transport_sas_node_find_by_sas_address - sas node search
  * @ioc: per adapter object
  * @sas_address: sas address of expander or sas host
+ * @port: hba port entry
  * Context: Calling function should acquire ioc->sas_node_lock.
  *
  * Search for either hba phys or expander device based on handle, then returns
@@ -71,13 +72,13 @@
  */
 static struct _sas_node *
 _transport_sas_node_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	if (ioc->sas_hba.sas_address == sas_address)
 		return &ioc->sas_hba;
 	else
 		return mpt3sas_scsih_expander_find_by_sas_address(ioc,
-		    sas_address);
+		    sas_address, port);
 }
 
 /**
@@ -439,6 +440,7 @@ _transport_delete_port(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_port *mpt3sas_port)
 {
 	u64 sas_address = mpt3sas_port->remote_identify.sas_address;
+	struct hba_port *port = mpt3sas_port->hba_port;
 	enum sas_device_type device_type =
 	    mpt3sas_port->remote_identify.device_type;
 
@@ -448,10 +450,11 @@ _transport_delete_port(struct MPT3SAS_ADAPTER *ioc,
 
 	ioc->logging_level |= MPT_DEBUG_TRANSPORT;
 	if (device_type == SAS_END_DEVICE)
-		mpt3sas_device_remove_by_sas_address(ioc, sas_address);
+		mpt3sas_device_remove_by_sas_address(ioc,
+		    sas_address, port);
 	else if (device_type == SAS_EDGE_EXPANDER_DEVICE ||
 	    device_type == SAS_FANOUT_EXPANDER_DEVICE)
-		mpt3sas_expander_remove(ioc, sas_address);
+		mpt3sas_expander_remove(ioc, sas_address, port);
 	ioc->logging_level &= ~MPT_DEBUG_TRANSPORT;
 }
 
@@ -571,18 +574,21 @@ _transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  * @sas_node: sas node object (either expander or sas host)
  * @sas_address: sas address of device being added
+ * @port: hba port entry
  *
  * See the explanation above from _transport_delete_duplicate_port
  */
 static void
 _transport_sanity_check(struct MPT3SAS_ADAPTER *ioc, struct _sas_node *sas_node,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	int i;
 
 	for (i = 0; i < sas_node->num_phys; i++) {
 		if (sas_node->phy[i].remote_identify.sas_address != sas_address)
 			continue;
+		if (sas_node->phy[i].port != port)
+			continue;
 		if (sas_node->phy[i].phy_belongs_to_port == 1)
 			_transport_del_phy_from_an_existing_port(ioc, sas_node,
 			    &sas_node->phy[i]);
@@ -631,7 +637,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	INIT_LIST_HEAD(&mpt3sas_port->port_list);
 	INIT_LIST_HEAD(&mpt3sas_port->phy_list);
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
-	sas_node = _transport_sas_node_find_by_sas_address(ioc, sas_address);
+	sas_node = _transport_sas_node_find_by_sas_address(ioc,
+	    sas_address, hba_port);
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 
 	if (!sas_node) {
@@ -655,7 +662,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	mpt3sas_port->hba_port = hba_port;
 	_transport_sanity_check(ioc, sas_node,
-	    mpt3sas_port->remote_identify.sas_address);
+	    mpt3sas_port->remote_identify.sas_address, hba_port);
 
 	for (i = 0; i < sas_node->num_phys; i++) {
 		if (sas_node->phy[i].remote_identify.sas_address !=
@@ -676,6 +683,18 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_device = mpt3sas_get_sdev_by_addr(ioc,
+		    mpt3sas_port->remote_identify.sas_address,
+		    mpt3sas_port->hba_port);
+		if (!sas_device) {
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out_fail;
+		}
+		sas_device->pend_sas_rphy_add = 1;
+	}
+
 	if (!sas_node->parent_dev) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
@@ -716,18 +735,6 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	rphy->identify = mpt3sas_port->remote_identify;
 
-	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
-		sas_device = mpt3sas_get_sdev_by_addr(ioc,
-				    mpt3sas_port->remote_identify.sas_address);
-		if (!sas_device) {
-			dfailprintk(ioc,
-				    ioc_info(ioc, "failure at %s:%d/%s()!\n",
-					     __FILE__, __LINE__, __func__));
-			goto out_fail;
-		}
-		sas_device->pend_sas_rphy_add = 1;
-	}
-
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
@@ -793,7 +800,7 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	sas_node = _transport_sas_node_find_by_sas_address(ioc,
-	    sas_address_parent);
+	    sas_address_parent, port);
 	if (!sas_node) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return;
@@ -1020,7 +1027,8 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 		return;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
-	sas_node = _transport_sas_node_find_by_sas_address(ioc, sas_address);
+	sas_node = _transport_sas_node_find_by_sas_address(ioc,
+	    sas_address, port);
 	if (!sas_node) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return;
@@ -1267,10 +1275,13 @@ _transport_get_linkerrors(struct sas_phy *phy)
 	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasPhyPage1_t phy_pg1;
+	struct hba_port *port = phy->hostdata;
+	int port_id = port->port_id;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
-	    phy->identify.sas_address) == NULL) {
+	    phy->identify.sas_address,
+	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1321,7 +1332,7 @@ _transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    rphy->identify.sas_address);
+	    rphy->identify.sas_address, 0);
 	if (sas_device) {
 		*identifier = sas_device->enclosure_logical_id;
 		rc = 0;
@@ -1351,7 +1362,7 @@ _transport_get_bay_identifier(struct sas_rphy *rphy)
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	sas_device = __mpt3sas_get_sdev_by_addr(ioc,
-	    rphy->identify.sas_address);
+	    rphy->identify.sas_address, 0);
 	if (sas_device) {
 		rc = sas_device->slot;
 		sas_device_put(sas_device);
@@ -1554,11 +1565,14 @@ _transport_phy_reset(struct sas_phy *phy, int hard_reset)
 	struct MPT3SAS_ADAPTER *ioc = phy_to_ioc(phy);
 	Mpi2SasIoUnitControlReply_t mpi_reply;
 	Mpi2SasIoUnitControlRequest_t mpi_request;
+	struct hba_port *port = phy->hostdata;
+	int port_id = port->port_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
-	    phy->identify.sas_address) == NULL) {
+	    phy->identify.sas_address,
+	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1611,10 +1625,13 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 	int rc = 0;
 	unsigned long flags;
 	int i, discovery_active;
+	struct hba_port *port = phy->hostdata;
+	int port_id = port->port_id;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
-	    phy->identify.sas_address) == NULL) {
+	    phy->identify.sas_address,
+	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
@@ -1748,10 +1765,13 @@ _transport_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	int i;
 	int rc = 0;
 	unsigned long flags;
+	struct hba_port *port = phy->hostdata;
+	int port_id = port->port_id;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
-	    phy->identify.sas_address) == NULL) {
+	    phy->identify.sas_address,
+	    mpt3sas_get_port_by_id(ioc, port_id)) == NULL) {
 		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
 		return -EINVAL;
 	}
-- 
2.18.4


--0000000000008d9a6805b2a6be9c
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
bWKtWgjgDVpNrNh1KEFzxs7lrWrsHhKy30YjCUj7gSEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODM0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIz9iHHLWK8wqbWmj+EV
UBq6gpJNN9ZOxj3z4n/uFFheeiVKeBmMjb7h+pZxityl9SU1xheBsby84mFI9WRX+HzwFtdyIhIo
tzZB8CZ3oi6eO3Xi/IkOSOLTzWFZ7hjDJU5o3iRlMhMQ5+bXKXK9gkxYp6zHkx1o1/nyAvuUrhHE
hpj7DR/U4XyrXvDrkehldTAc9o5U0+k86WLD8N7QOmQ/3+XDASnOKlDwHMVb644WiTcm+pY5XJ9L
4uZ8aNeDmkf//r61chkjPC0NRsOG/U2FQG0j//2P5DsC8LDTigd3SFhja9odhActJ5AsBgGLnq5z
kHUKyq8q/6tar82OBSY=
--0000000000008d9a6805b2a6be9c--
