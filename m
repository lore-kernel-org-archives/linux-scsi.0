Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F21C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiG2NGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiG2NFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAD456B8D
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ha11so4783783pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=XR5uKBoUxdOzfof8mcoDlJU2LJYFqGFfvpcD7bFmYrU=;
        b=DqDXBIZcRbT457CXqNWPgpdN+jHsxPE0Z9SQu/9EGVtLzosk+JjhD9Pa0fny9/CuWR
         WXJJrrGYmu3WK141PlCrrsZ9CTb4kxUs04tnFJsCSL7VLyRyT3SewrHPDkfqpYb0c+c6
         N41P23ZrexqzFqYYn4/Zua/xJNtlf23rJJFdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=XR5uKBoUxdOzfof8mcoDlJU2LJYFqGFfvpcD7bFmYrU=;
        b=AjuejB3VMAefUF8F1wBDkHzIGTRiPySJjdGt8lgxBhmqm2/5beO9UrN/yaPPqehtBC
         EW59CyQmQMFEJk20rSzcuPkxfz4n8DmU0NAwHt2SQnx4Dn4JFdTICZjlV2Mysw4XIJ+2
         tZlLvH7mipJj7DJErGa2Qq16v0pWgojRF+RVyUFPlaiaJja3IMwvsyhtVIOI6uCTzhb6
         3zFH5sqBVKT43o2xOjTznVla1+P9eE0HkuIczHLFrUK3NyXufdqXkxXUbq4OYWfgvQ87
         W7WRLDgYpUYaUGYxY2Qg43g7FpN7YiPDs8Dcw+kHXr1J9ufuF2rzlAoySp2TzVGwthRY
         SOMw==
X-Gm-Message-State: ACgBeo0sbQynyMFYYRcOW2Cn86dHDkhiRL3Mney8JynXgIrcBgWtOyUm
        R5AbamDHcbQ9tJdPe7PZjkERrVIXD379qeDzhC3T7MaTu0nA6mKkhNut+WRcStkKh1TwxBai8XQ
        9SkC0DxY9cdNBKBoHeVZUZHDS5B3sxPLxVhOKcgdp8OM3kUJFi2x/+fQ6bKdgNVtSP5F55q5Lgj
        nozS/3ApjR
X-Google-Smtp-Source: AA6agR4WR3tc6w18Nmpn3OXYto1DMcSMWmSzMdXrxY+/YNCvfu9fukGfnAYwyYVtcI7n6UYRZFmu0g==
X-Received: by 2002:a17:902:ab0f:b0:16d:b340:bf8f with SMTP id ik15-20020a170902ab0f00b0016db340bf8fmr3841790plb.140.1659099876093;
        Fri, 29 Jul 2022 06:04:36 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:35 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 09/15] mpi3mr: Add expander devices to STL
Date:   Fri, 29 Jul 2022 18:46:21 +0530
Message-Id: <20220729131627.15019-10-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cc084805e4f14a2f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cc084805e4f14a2f
Content-Transfer-Encoding: 8bit

Register/unregister the expander devices to
SCSI Transport Layer(STL) whenever the corresponding expander
is added/removed from topology.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |   7 +
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  36 ++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 402 ++++++++++++++++++++++++-
 3 files changed, 436 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8c8703e..9cd5f88 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1341,6 +1341,11 @@ int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
 
 u8 mpi3mr_is_expander_device(u16 device_info);
+int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle);
+void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
+	struct mpi3mr_hba_port *hba_port);
+struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_ioc
+	*mrioc, u16 handle);
 struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
 	u8 port_id);
 void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc);
@@ -1348,6 +1353,8 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc);
 void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
 	struct mpi3mr_hba_port *hba_port);
+void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev);
 void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
 	bool device_add);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ae77422..9a32dc6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -824,7 +824,7 @@ void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
  *
  * Return: 0 on success, non zero on failure.
  */
-static void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
+void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev)
 {
 	struct mpi3mr_stgt_priv_data *tgt_priv;
@@ -1494,7 +1494,10 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	int i;
 	u16 handle;
 	u8 reason_code;
+	u64 exp_sas_address = 0;
+	struct mpi3mr_hba_port *hba_port = NULL;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_sas_node *sas_expander = NULL;
 
 	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
 
@@ -1524,6 +1527,13 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		if (tgtdev)
 			mpi3mr_tgtdev_put(tgtdev);
 	}
+
+	if (mrioc->sas_transport_enabled && (event_data->exp_status ==
+	    MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING)) {
+		if (sas_expander)
+			mpi3mr_expander_remove(mrioc, exp_sas_address,
+			    hba_port);
+	}
 }
 
 /**
@@ -1744,7 +1754,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
 	struct mpi3_device_page0 *dev_pg0 = NULL;
-	u16 perst_id;
+	u16 perst_id, handle, dev_info;
+	struct mpi3_device0_sas_sata_format *sasinf = NULL;
 
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
@@ -1758,10 +1769,23 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
 	{
-		struct mpi3_device_page0 *dev_pg0 =
-		    (struct mpi3_device_page0 *)fwevt->event_data;
-		mpi3mr_report_tgtdev_to_host(mrioc,
-		    le16_to_cpu(dev_pg0->persistent_id));
+		dev_pg0 = (struct mpi3_device_page0 *)fwevt->event_data;
+		perst_id = le16_to_cpu(dev_pg0->persistent_id);
+		handle = le16_to_cpu(dev_pg0->dev_handle);
+		if (perst_id != MPI3_DEVICE0_PERSISTENTID_INVALID)
+			mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
+		else if (mrioc->sas_transport_enabled &&
+		    (dev_pg0->device_form == MPI3_DEVICE_DEVFORM_SAS_SATA)) {
+			sasinf = &dev_pg0->device_specific.sas_sata_format;
+			dev_info = le16_to_cpu(sasinf->device_info);
+			if (!mrioc->sas_hba.num_phys)
+				mpi3mr_sas_host_add(mrioc);
+			else
+				mpi3mr_sas_host_refresh(mrioc);
+
+			if (mpi3mr_is_expander_device(dev_info))
+				mpi3mr_expander_add(mrioc, handle);
+		}
 		break;
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index b85d60f..1d6ae9d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -21,7 +21,7 @@
  *
  * Return: Expander sas_node object reference or NULL
  */
-static struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_ioc
+struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_ioc
 	*mrioc, u16 handle)
 {
 	struct mpi3mr_sas_node *sas_expander, *r;
@@ -159,6 +159,45 @@ out:
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_remove_device_by_sas_address - remove the device
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of the device
+ * @hba_port: HBA port entry
+ *
+ * This searches for target device using sas address and hba
+ * port pointer then removes it from the OS.
+ *
+ * Return: None
+ */
+static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
+	u64 sas_address, struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+	u8 was_on_tgtdev_list = 0;
+
+	if (!hba_port)
+		return;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_addr(mrioc,
+			 sas_address, hba_port);
+	if (tgtdev) {
+		if (!list_empty(&tgtdev->list)) {
+			list_del_init(&tgtdev->list);
+			was_on_tgtdev_list = 1;
+			mpi3mr_tgtdev_put(tgtdev);
+		}
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	if (was_on_tgtdev_list) {
+		if (tgtdev->host_exposed)
+			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+		mpi3mr_tgtdev_put(tgtdev);
+	}
+}
+
 /**
  * mpi3mr_expander_find_by_sas_address - sas expander search
  * @mrioc: Adapter instance reference
@@ -379,6 +418,35 @@ static void mpi3mr_add_phy_to_an_existing_port(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * mpi3mr_delete_sas_port - helper function to removing a port
+ * @mrioc: Adapter instance reference
+ * @mr_sas_port: Internal Port object
+ *
+ * Return: None.
+ */
+static void  mpi3mr_delete_sas_port(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_port *mr_sas_port)
+{
+
+	u64 sas_address = mr_sas_port->remote_identify.sas_address;
+	struct mpi3mr_hba_port *hba_port = mr_sas_port->hba_port;
+	enum sas_device_type device_type =
+	    mr_sas_port->remote_identify.device_type;
+
+	dev_info(&mr_sas_port->port->dev,
+	    "remove: sas_address(0x%016llx)\n",
+	    (unsigned long long) sas_address);
+
+	if (device_type == SAS_END_DEVICE)
+		mpi3mr_remove_device_by_sas_address(mrioc, sas_address,
+		    hba_port);
+
+	else if (device_type == SAS_EDGE_EXPANDER_DEVICE ||
+	    device_type == SAS_FANOUT_EXPANDER_DEVICE)
+		mpi3mr_expander_remove(mrioc, sas_address, hba_port);
+}
+
 /**
  * mpi3mr_del_phy_from_an_existing_port - del phy from a port
  * @mrioc: Adapter instance reference
@@ -402,8 +470,12 @@ static void mpi3mr_del_phy_from_an_existing_port(struct mpi3mr_ioc *mrioc,
 		    port_siblings) {
 			if (srch_phy != mr_sas_phy)
 				continue;
-			mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
-			    mr_sas_phy);
+			if ((mr_sas_port->num_phys == 1) &&
+			    !mrioc->reset_in_progress)
+				mpi3mr_delete_sas_port(mrioc, mr_sas_port);
+			else
+				mpi3mr_delete_sas_phy(mrioc, mr_sas_port,
+				    mr_sas_phy);
 			return;
 		}
 	}
@@ -1235,3 +1307,327 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 
 	kfree(mr_sas_port);
 }
+
+/**
+ * mpi3mr_expander_node_add - insert an expander to the list.
+ * @mrioc: Adapter instance reference
+ * @sas_expander: Expander sas node
+ * Context: This function will acquire sas_node_lock.
+ *
+ * Adding new object to the ioc->sas_expander_list.
+ *
+ * Return: None.
+ */
+static void mpi3mr_expander_node_add(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_add_tail(&sas_expander->list, &mrioc->sas_expander_list);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+}
+
+/**
+ * mpi3mr_expander_add -  Create expander object
+ * @mrioc: Adapter instance reference
+ * @handle: Expander firmware device handle
+ *
+ * This function creating expander object, stored in
+ * sas_expander_list and expose it to the SAS transport
+ * layer.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
+{
+	struct mpi3mr_sas_node *sas_expander;
+	struct mpi3mr_enclosure_node *enclosure_dev;
+	struct mpi3_sas_expander_page0 expander_pg0;
+	struct mpi3_sas_expander_page1 expander_pg1;
+	u16 ioc_status, parent_handle, temp_handle;
+	u64 sas_address, sas_address_parent = 0;
+	int i;
+	unsigned long flags;
+	u8 port_id, link_rate;
+	struct mpi3mr_sas_port *mr_sas_port = NULL;
+	struct mpi3mr_hba_port *hba_port;
+	u32 phynum_handle;
+
+	int rc = 0;
+
+	if (!handle)
+		return -1;
+
+	if (mrioc->reset_in_progress)
+		return -1;
+
+	if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
+	    sizeof(expander_pg0), MPI3_SAS_EXPAND_PGAD_FORM_HANDLE, handle))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	parent_handle = le16_to_cpu(expander_pg0.parent_dev_handle);
+	if (mpi3mr_get_sas_address(mrioc, parent_handle, &sas_address_parent)
+	    != 0) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	port_id = expander_pg0.io_unit_port;
+	hba_port = mpi3mr_get_hba_port_by_id(mrioc, port_id);
+	if (!hba_port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+
+	if (sas_address_parent != mrioc->sas_hba.sas_address) {
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+		sas_expander =
+		   mpi3mr_expander_find_by_sas_address(mrioc,
+		    sas_address_parent, hba_port);
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		if (!sas_expander) {
+			rc = mpi3mr_expander_add(mrioc, parent_handle);
+			if (rc != 0)
+				return rc;
+		} else {
+			/*
+			 * When there is a parent expander present, update it's
+			 * phys where child expander is connected with the link
+			 * speed, attached dev handle and sas address.
+			 */
+			for (i = 0 ; i < sas_expander->num_phys ; i++) {
+				phynum_handle =
+				    (i << MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT) |
+				    parent_handle;
+				if (mpi3mr_cfg_get_sas_exp_pg1(mrioc,
+				    &ioc_status, &expander_pg1,
+				    sizeof(expander_pg1),
+				    MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM,
+				    phynum_handle)) {
+					ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+					    __FILE__, __LINE__, __func__);
+					rc = -1;
+					return rc;
+				}
+				if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+					ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+					    __FILE__, __LINE__, __func__);
+					rc = -1;
+					return rc;
+				}
+				temp_handle = le16_to_cpu(
+				    expander_pg1.attached_dev_handle);
+				if (temp_handle != handle)
+					continue;
+				link_rate = (expander_pg1.negotiated_link_rate &
+				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+				mpi3mr_update_links(mrioc, sas_address_parent,
+				    handle, i, link_rate, hba_port);
+			}
+		}
+	}
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	sas_address = le64_to_cpu(expander_pg0.sas_address);
+	sas_expander = mpi3mr_expander_find_by_sas_address(mrioc,
+	    sas_address, hba_port);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	if (sas_expander)
+		return 0;
+
+	sas_expander = kzalloc(sizeof(struct mpi3mr_sas_node),
+	    GFP_KERNEL);
+	if (!sas_expander)
+		return -1;
+
+	sas_expander->handle = handle;
+	sas_expander->num_phys = expander_pg0.num_phys;
+	sas_expander->sas_address_parent = sas_address_parent;
+	sas_expander->sas_address = sas_address;
+	sas_expander->hba_port = hba_port;
+
+
+	ioc_info(mrioc,
+	    "expander_add: handle(0x%04x), parent(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
+	    handle, parent_handle, (unsigned long long)
+	    sas_expander->sas_address, sas_expander->num_phys);
+
+	if (!sas_expander->num_phys) {
+		rc = -1;
+		goto out_fail;
+	}
+	sas_expander->phy = kcalloc(sas_expander->num_phys,
+	    sizeof(struct mpi3mr_sas_phy), GFP_KERNEL);
+	if (!sas_expander->phy) {
+		rc = -1;
+		goto out_fail;
+	}
+
+	INIT_LIST_HEAD(&sas_expander->sas_port_list);
+	mr_sas_port = mpi3mr_sas_port_add(mrioc, handle, sas_address_parent,
+	    sas_expander->hba_port);
+	if (!mr_sas_port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		rc = -1;
+		goto out_fail;
+	}
+	sas_expander->parent_dev = &mr_sas_port->rphy->dev;
+	sas_expander->rphy = mr_sas_port->rphy;
+
+	for (i = 0 ; i < sas_expander->num_phys ; i++) {
+		phynum_handle = (i << MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT) |
+		    handle;
+		if (mpi3mr_cfg_get_sas_exp_pg1(mrioc, &ioc_status,
+		    &expander_pg1, sizeof(expander_pg1),
+		    MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM,
+		    phynum_handle)) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
+		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
+
+		sas_expander->phy[i].handle = handle;
+		sas_expander->phy[i].phy_id = i;
+		sas_expander->phy[i].hba_port = hba_port;
+
+		if ((mpi3mr_add_expander_phy(mrioc, &sas_expander->phy[i],
+		    expander_pg1, sas_expander->parent_dev))) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
+	}
+
+	if (sas_expander->enclosure_handle) {
+		enclosure_dev =
+			mpi3mr_enclosure_find_by_handle(mrioc,
+						sas_expander->enclosure_handle);
+		if (enclosure_dev)
+			sas_expander->enclosure_logical_id = le64_to_cpu(
+			    enclosure_dev->pg0.enclosure_logical_id);
+	}
+
+	mpi3mr_expander_node_add(mrioc, sas_expander);
+	return 0;
+
+out_fail:
+
+	if (mr_sas_port)
+		mpi3mr_sas_port_remove(mrioc,
+		    sas_expander->sas_address,
+		    sas_address_parent, sas_expander->hba_port);
+	kfree(sas_expander->phy);
+	kfree(sas_expander);
+	return rc;
+}
+
+/**
+ * mpi3mr_expander_node_remove - recursive removal of expander.
+ * @mrioc: Adapter instance reference
+ * @sas_expander: Expander device object
+ *
+ * Removes expander object and freeing associated memory from
+ * the sas_expander_list and removes the same from SAS TL, if
+ * one of the attached device is an expander then it recursively
+ * removes the expander device too.
+ *
+ * Return nothing.
+ */
+static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander)
+{
+	struct mpi3mr_sas_port *mr_sas_port, *next;
+	unsigned long flags;
+	u8 port_id;
+
+	/* remove sibling ports attached to this expander */
+	list_for_each_entry_safe(mr_sas_port, next,
+	   &sas_expander->sas_port_list, port_list) {
+		if (mrioc->reset_in_progress)
+			return;
+		if (mr_sas_port->remote_identify.device_type ==
+		    SAS_END_DEVICE)
+			mpi3mr_remove_device_by_sas_address(mrioc,
+			    mr_sas_port->remote_identify.sas_address,
+			    mr_sas_port->hba_port);
+		else if (mr_sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
+		    mr_sas_port->remote_identify.device_type ==
+		    SAS_FANOUT_EXPANDER_DEVICE)
+			mpi3mr_expander_remove(mrioc,
+			    mr_sas_port->remote_identify.sas_address,
+			    mr_sas_port->hba_port);
+	}
+
+	port_id = sas_expander->hba_port->port_id;
+	mpi3mr_sas_port_remove(mrioc, sas_expander->sas_address,
+	    sas_expander->sas_address_parent, sas_expander->hba_port);
+
+	ioc_info(mrioc, "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
+	    sas_expander->handle, (unsigned long long)
+	    sas_expander->sas_address, port_id);
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_del(&sas_expander->list);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	kfree(sas_expander->phy);
+	kfree(sas_expander);
+}
+
+
+/**
+ * mpi3mr_expander_remove - Remove expander object
+ * @mrioc: Adapter instance reference
+ * @sas_address: Remove expander sas_address
+ * @hba_port: HBA port reference
+ *
+ * This function remove expander object, stored in
+ * mrioc->sas_expander_list and removes it from the SAS TL by
+ * calling mpi3mr_expander_node_remove().
+ *
+ * Return: None
+ */
+void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
+	struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_sas_node *sas_expander;
+	unsigned long flags;
+
+	if (mrioc->reset_in_progress)
+		return;
+
+	if (!hba_port)
+		return;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	sas_expander = mpi3mr_expander_find_by_sas_address(mrioc, sas_address,
+	    hba_port);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+	if (sas_expander)
+		mpi3mr_expander_node_remove(mrioc, sas_expander);
+
+}
-- 
2.27.0


--000000000000cc084805e4f14a2f
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEoiN1jM35H+t7Ww2CqE
ZIxGns84lq7/jy1gdQkf+tPhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQzNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCqLCNhJftq/bwxBx40HvtBMpMAmBBWw+fGUBJV
I9Qc985sa/6XnyLMcNckP5cWdOaqqWgkzFUk4WTER6FXCUWzLFv5xba7lBRBnFA7WcJFCtM18FgN
LT2km0uUyoLHC3TyzcE2UNRnz0tsmq7QfqBGdtp8dW4bRLL4CUddOGro1mPXqTFQm2I/hAg8IU1m
5qMOhD+j4K1UN/TBj6cECSZP644jnUZxDHdXZ8xsqe91U9ayqclad9IsATt+9hm07yJuIZoeNoMW
lumQCALqUhqCAu4svpZtxZS7QbTzX1mxVt49L8PQ9bYItBQknO4Q6p/DTqjUnKCn0poJOV+nJkjd
--000000000000cc084805e4f14a2f--
