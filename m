Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC02AC00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiG2NGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiG2NFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:44 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E749785AE
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h132so3962895pgc.10
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=hC3fqz8sNxG30ODLH2kUVm0loiUc5YhgMb+VzmcoKlE=;
        b=AsJ8cUKA3x0Ut1OiHUCocHn4qIHbROId5c2sgCTsasOxX/6xmKGPmzrt+NgJpyXblz
         X62iUNRAMwgAcnAagLMsB1SW0l3h3m0k8wxkkXhoZ4GkAjY4bYp0uoatEF6fpP8gCN8q
         LrRNpZrQ22pUAv/43AkkDEAY1ArdZqga/5sJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=hC3fqz8sNxG30ODLH2kUVm0loiUc5YhgMb+VzmcoKlE=;
        b=smR2hMmsUDFOgC5tPo1hRUsoHpwwsxNmo6OIWHstij5zss9ycXcwevTIpCLsMqosCe
         17cz/xhqp9f1f2NGsv5Mj/5dACbIENrB2rwfcg8TMO7DkvrgsbAWus4wGbsPuFGU8zGZ
         NRTVU6CIFJcT4NL9E7sda3csFjUQdJ5ud+FnMcvOzQeInC4xSfaF+UxNEDYISD3MMtlG
         DOtnFgcnzjzctLD+GYOWRvTnrJTE16ZNi/RSb48kHcrDwuPFM/+FbrUWbiip5L1oJi2X
         wkv+P3YqUsk1bxxVAuscMN1wRZeZDkwPWssQ69WZvJuQ3O3izxno7UltnJaJsX6i5Fih
         mdQA==
X-Gm-Message-State: AJIora9YRlg+8kb1qc8e0ikWG/Ys1O2WJgI+CK3Qitf5tyxuNN/nXK0E
        hXtm8iKkyUrpGC58aNLoSbLL1T8pJ/4vQFDfPd72o+t8pHT09Kk2A5m1PRI/p3W46QgeT/xoXo6
        XiOy8sZ/2mlq6/wk+ogkPNSQhpGlsT0XsPNvG56LfbBluUEAoLwhnYwhWeYZQzkB2QwAmnxzsHE
        cb7Cl7e5Mm
X-Google-Smtp-Source: AGRyM1sz1u2qP2Fu0wrAm8/x7seyqeXMFQsPIUIeccnYm5hsjeT/1CHkYWh/0jieJuRnyea4rPF0Ew==
X-Received: by 2002:a05:6a00:2282:b0:52b:bab:16a4 with SMTP id f2-20020a056a00228200b0052b0bab16a4mr3457129pfe.17.1659099879725;
        Fri, 29 Jul 2022 06:04:39 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:39 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 11/15] mpi3mr: Add SAS SATA end devices to STL
Date:   Fri, 29 Jul 2022 18:46:23 +0530
Message-Id: <20220729131627.15019-12-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000049de205e4f14bb2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000049de205e4f14bb2
Content-Transfer-Encoding: 8bit

Register/unregister the SAS, SATA devices to
SCSI Transport Layer(STL) whenever the corresponding device
is added/removed from topology.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  10 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  83 ++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 158 +++++++++++++++++++++++++
 3 files changed, 234 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index a91a57b..21ea021 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -569,7 +569,10 @@ struct mpi3mr_enclosure_node {
  * information cached from firmware given data
  *
  * @sas_address: World wide unique SAS address
+ * @sas_address_parent: Sas address of parent expander or host
  * @dev_info: Device information bits
+ * @phy_id: Phy identifier provided in device page 0
+ * @attached_phy_id: Attached phy identifier provided in device page 0
  * @sas_transport_attached: Is this device exposed to transport
  * @pend_sas_rphy_add: Flag to check device is in process of add
  * @hba_port: HBA port entry
@@ -577,7 +580,10 @@ struct mpi3mr_enclosure_node {
  */
 struct tgt_dev_sas_sata {
 	u64 sas_address;
+	u64 sas_address_parent;
 	u16 dev_info;
+	u8 phy_id;
+	u8 attached_phy_id;
 	u8 sas_transport_attached;
 	u8 pend_sas_rphy_add;
 	struct mpi3mr_hba_port *hba_port;
@@ -1357,6 +1363,10 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_hba_port *hba_port);
 void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev);
+int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev);
+void mpi3mr_remove_tgtdev_from_sas_transport(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev);
 struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
 	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy);
 void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index aed9b60..a486fe3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -836,19 +836,25 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 		tgt_priv->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
 	}
 
-	if (tgtdev->starget) {
-		if (mrioc->current_event)
-			mrioc->current_event->pending_at_sml = 1;
-		scsi_remove_target(&tgtdev->starget->dev);
-		tgtdev->host_exposed = 0;
-		if (mrioc->current_event) {
-			mrioc->current_event->pending_at_sml = 0;
-			if (mrioc->current_event->discard) {
-				mpi3mr_print_device_event_notice(mrioc, false);
-				return;
+	if (!mrioc->sas_transport_enabled || (tgtdev->dev_type !=
+	    MPI3_DEVICE_DEVFORM_SAS_SATA) || tgtdev->non_stl) {
+		if (tgtdev->starget) {
+			if (mrioc->current_event)
+				mrioc->current_event->pending_at_sml = 1;
+			scsi_remove_target(&tgtdev->starget->dev);
+			tgtdev->host_exposed = 0;
+			if (mrioc->current_event) {
+				mrioc->current_event->pending_at_sml = 0;
+				if (mrioc->current_event->discard) {
+					mpi3mr_print_device_event_notice(mrioc,
+					    false);
+					return;
+				}
 			}
 		}
-	}
+	} else
+		mpi3mr_remove_tgtdev_from_sas_transport(mrioc, tgtdev);
+
 	ioc_info(mrioc, "%s :Removed handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
 }
@@ -870,21 +876,25 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev;
 
+	if (mrioc->reset_in_progress)
+		return -1;
+
 	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
 	if (!tgtdev) {
 		retval = -1;
 		goto out;
 	}
-	if (tgtdev->is_hidden) {
+	if (tgtdev->is_hidden || tgtdev->host_exposed) {
 		retval = -1;
 		goto out;
 	}
-	if (!tgtdev->host_exposed && !mrioc->reset_in_progress) {
+	if (!mrioc->sas_transport_enabled || (tgtdev->dev_type !=
+	    MPI3_DEVICE_DEVFORM_SAS_SATA) || tgtdev->non_stl){
 		tgtdev->host_exposed = 1;
 		if (mrioc->current_event)
 			mrioc->current_event->pending_at_sml = 1;
-		scsi_scan_target(&mrioc->shost->shost_gendev, 0,
-		    tgtdev->perst_id,
+		scsi_scan_target(&mrioc->shost->shost_gendev,
+		    mrioc->scsi_device_channel, tgtdev->perst_id,
 		    SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
 		if (!tgtdev->starget)
 			tgtdev->host_exposed = 0;
@@ -895,7 +905,8 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 				goto out;
 			}
 		}
-	}
+	} else
+		mpi3mr_report_tgtdev_to_sas_transport(mrioc, tgtdev);
 out:
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
@@ -1087,6 +1098,9 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.sas_sata_inf.dev_info = dev_info;
 		tgtdev->dev_spec.sas_sata_inf.sas_address =
 		    le64_to_cpu(sasinf->sas_address);
+		tgtdev->dev_spec.sas_sata_inf.phy_id = sasinf->phy_num;
+		tgtdev->dev_spec.sas_sata_inf.attached_phy_id =
+		    sasinf->attached_phy_identifier;
 		if ((dev_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) !=
 		    MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_END_DEVICE)
 			tgtdev->is_hidden = 1;
@@ -1494,12 +1508,30 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	int i;
 	u16 handle;
 	u8 reason_code;
-	u64 exp_sas_address = 0;
+	u64 exp_sas_address = 0, parent_sas_address = 0;
 	struct mpi3mr_hba_port *hba_port = NULL;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_sas_node *sas_expander = NULL;
+	unsigned long flags;
+	u8 link_rate, prev_link_rate, parent_phy_number;
 
 	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
+	if (mrioc->sas_transport_enabled) {
+		hba_port = mpi3mr_get_hba_port_by_id(mrioc,
+		    event_data->io_unit_port);
+		if (le16_to_cpu(event_data->expander_dev_handle)) {
+			spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+			sas_expander = __mpi3mr_expander_find_by_handle(mrioc,
+			    le16_to_cpu(event_data->expander_dev_handle));
+			if (sas_expander) {
+				exp_sas_address = sas_expander->sas_address;
+				hba_port = sas_expander->hba_port;
+			}
+			spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+			parent_sas_address = exp_sas_address;
+		} else
+			parent_sas_address = mrioc->sas_hba.sas_address;
+	}
 
 	for (i = 0; i < event_data->num_entries; i++) {
 		if (fwevt->discard)
@@ -1521,6 +1553,23 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
 			mpi3mr_tgtdev_put(tgtdev);
 			break;
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
+		case MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE:
+		{
+			if (!mrioc->sas_transport_enabled || tgtdev->non_stl
+			    || tgtdev->is_hidden)
+				break;
+			link_rate = event_data->phy_entry[i].link_rate >> 4;
+			prev_link_rate = event_data->phy_entry[i].link_rate & 0xF;
+			if (link_rate == prev_link_rate)
+				break;
+			if (!parent_sas_address)
+				break;
+			parent_phy_number = event_data->start_phy_num + i;
+			mpi3mr_update_links(mrioc, parent_sas_address, handle,
+			    parent_phy_number, link_rate, hba_port);
+		}
 		default:
 			break;
 		}
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index f7faf6e..c449820 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1660,3 +1660,161 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 		mpi3mr_expander_node_remove(mrioc, sas_expander);
 
 }
+
+/**
+ * mpi3mr_get_sas_negotiated_logical_linkrate - get linkrate
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device
+ *
+ * This function identifies whether the target device is
+ * attached directly or through expander and issues sas phy
+ * page0 or expander phy page1 and gets the link rate, if there
+ * is any failure in reading the pages then this returns link
+ * rate of 1.5.
+ *
+ * Return: logical link rate.
+ */
+static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	u8 link_rate = MPI3_SAS_NEG_LINK_RATE_1_5, phy_number;
+	struct mpi3_sas_expander_page1 expander_pg1;
+	struct mpi3_sas_phy_page0 phy_pg0;
+	u32 phynum_handle;
+	u16 ioc_status;
+
+	phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;
+	if (!(tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED)) {
+		phynum_handle = ((phy_number<<MPI3_SAS_EXPAND_PGAD_PHYNUM_SHIFT)
+				 | tgtdev->parent_handle);
+		if (mpi3mr_cfg_get_sas_exp_pg1(mrioc, &ioc_status,
+		    &expander_pg1, sizeof(expander_pg1),
+		    MPI3_SAS_EXPAND_PGAD_FORM_HANDLE_PHY_NUM,
+		    phynum_handle)) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out;
+		}
+		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out;
+		}
+		link_rate = (expander_pg1.negotiated_link_rate &
+			     MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+			MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+		goto out;
+	}
+	if (mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
+	    sizeof(struct mpi3_sas_phy_page0),
+	    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, phy_number)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	link_rate = (phy_pg0.negotiated_link_rate &
+		     MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
+		MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+out:
+	return link_rate;
+}
+
+/**
+ * mpi3mr_report_tgtdev_to_sas_transport - expose dev to SAS TL
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device
+ *
+ * This function exposes the target device after
+ * preparing host_phy, setting up link rate etc.
+ *
+ * Return: 0 on success, non-zero for failure.
+ */
+int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	int retval = 0;
+	u8 link_rate, parent_phy_number;
+	u64 sas_address_parent, sas_address;
+	struct mpi3mr_hba_port *hba_port;
+	u8 port_id;
+
+	if ((tgtdev->dev_type != MPI3_DEVICE_DEVFORM_SAS_SATA) ||
+	    !mrioc->sas_transport_enabled)
+		return -1;
+
+	sas_address = tgtdev->dev_spec.sas_sata_inf.sas_address;
+	if (!mrioc->sas_hba.num_phys)
+		mpi3mr_sas_host_add(mrioc);
+	else
+		mpi3mr_sas_host_refresh(mrioc);
+
+	if (mpi3mr_get_sas_address(mrioc, tgtdev->parent_handle,
+	    &sas_address_parent) != 0) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+	tgtdev->dev_spec.sas_sata_inf.sas_address_parent = sas_address_parent;
+
+	parent_phy_number = tgtdev->dev_spec.sas_sata_inf.phy_id;
+	port_id = tgtdev->io_unit_port;
+
+	hba_port = mpi3mr_get_hba_port_by_id(mrioc, port_id);
+	if (!hba_port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return -1;
+	}
+	tgtdev->dev_spec.sas_sata_inf.hba_port = hba_port;
+
+	link_rate = mpi3mr_get_sas_negotiated_logical_linkrate(mrioc, tgtdev);
+
+	mpi3mr_update_links(mrioc, sas_address_parent, tgtdev->dev_handle,
+	    parent_phy_number, link_rate, hba_port);
+
+	tgtdev->host_exposed = 1;
+	if (!mpi3mr_sas_port_add(mrioc, tgtdev->dev_handle,
+	    sas_address_parent, hba_port)) {
+		tgtdev->host_exposed = 0;
+		retval = -1;
+	} else if ((!tgtdev->starget)) {
+		if (!mrioc->is_driver_loading)
+			mpi3mr_sas_port_remove(mrioc, sas_address,
+			    sas_address_parent, hba_port);
+		tgtdev->host_exposed = 0;
+		retval = -1;
+	}
+	return retval;
+}
+
+/**
+ * mpi3mr_remove_tgtdev_from_sas_transport - remove from SAS TL
+ * @mrioc: Adapter instance reference
+ * @tgtdev: Target device
+ *
+ * This function removes the target device
+ *
+ * Return: None.
+ */
+void mpi3mr_remove_tgtdev_from_sas_transport(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_tgt_dev *tgtdev)
+{
+	u64 sas_address_parent, sas_address;
+	struct mpi3mr_hba_port *hba_port;
+
+	if ((tgtdev->dev_type != MPI3_DEVICE_DEVFORM_SAS_SATA) ||
+	    !mrioc->sas_transport_enabled)
+		return;
+
+	hba_port = tgtdev->dev_spec.sas_sata_inf.hba_port;
+	sas_address = tgtdev->dev_spec.sas_sata_inf.sas_address;
+	sas_address_parent = tgtdev->dev_spec.sas_sata_inf.sas_address_parent;
+	mpi3mr_sas_port_remove(mrioc, sas_address, sas_address_parent,
+	    hba_port);
+	tgtdev->host_exposed = 0;
+}
-- 
2.27.0


--000000000000049de205e4f14bb2
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJlD6RiB/XysAQomLVtF
9tTepUpwu072ZHOlj5k+9ZRbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQ0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC8Cx3prfcaah8ojW+QifKIidVWU8P1b7ZbklpZ
MEQnyPvFmNgiTEkdVrxVwytsQZvAXoCmNN/MR2BgqJ+cTYiotkP5W2Jun9kmz3EQlJfVRE1bt57p
w6kMAf4wo+ctXJoGCl4GgqtUym+eEKT+8eO69oVNqgS8UJGrsUDPYiFxZfMy8gJJWAiOKpmtd8mr
O605/bOBhT+/GN60siPoe6a1WimV4wcXkXVKF9Vc9Gxq8wEX0lqSoZEj1DsZ0qOV1P1ZtNTKwyJT
8Bb79aJ7t4wHHrRucN06hCjFUZ/OtJhmt71pZJUa8z52jI4C6WsoYHkn6i+jXT9n75UFuYziiEnC
--000000000000049de205e4f14bb2--
