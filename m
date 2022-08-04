Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1319C19F2D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239484AbiHDNAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbiHDNAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BB862D0
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gj1so4528990pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=+7wMLVCUtyMO2GhjRanjaZTbKuU80xS0MZdWZfmVtUI=;
        b=CqbsnTO73Dw/MNFGGxRslSwW8zryuMb3SgEcrLt/gDrQpSE9S87joFVeH8woR9N8Y6
         OJYa46pKyNgLJYflnXNWtLhTLjQTz42q5wr6oA6JfkbZqiPIHxMwdRpVRfOryn4xdoAz
         B8lWXnfQu9e8Ki3OVagM/+rdun8oD0AnnWpqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=+7wMLVCUtyMO2GhjRanjaZTbKuU80xS0MZdWZfmVtUI=;
        b=UtCump82ui2XkCykYJu1zym2qWnJLAdDqAhqcN5JAIQCYdBygk/uGIcMpHnDtCc1Hd
         5Ovg/0T0a6+5ROxo+EnEoQtcMd06kNwOzsQxnStGU0Q6fkVsj/JwoTLgfz4B7Z3xD/q3
         rXIuPicDZcDit9yCg4+hHaRyvfpkHZdMQH3/hnBBqBVavQQXjXd/Z95/xq+glLsAjMoE
         OLdB1v0zAagEQHhrC+p1+tcJpBfykm93Typ330m6bCtgpacwiLgYmAuqA5ab2w6P/hq2
         BlVZlJvZAmcAxyAikTvZzxoLIYjkqpkA5fU+NwlHRVVGeIJcZN0pptuPBR+kX1e2wzED
         UyLA==
X-Gm-Message-State: ACgBeo2dt+gT3uSq/2BbDQIzltu6ZOtVMbcrxJw/dCnL/d6lmwLsiB/p
        HwauCmX7V61TE3t2xjVHbZaHuJ4d9K+wAO/QDwJvSJ05FsDKeTKLDg2N2HK57Zn97qVk0HCK1OE
        xv/u/0gEkpS/i7QV/tswE13JzTZIo8AqmmeydQIzABppYaBLxrwRsHYHdYiie2BZdc3QZ2utm3x
        gHbQHv/Huz
X-Google-Smtp-Source: AA6agR5IrF+9LOssRuRMPg3wDhvUrQSSdhtsv9Pj2EsDa5RiOLFSrzu19F9KBWN1UgHNvjx3hOoayA==
X-Received: by 2002:a17:90b:3e8b:b0:1f5:2a52:9148 with SMTP id rj11-20020a17090b3e8b00b001f52a529148mr1984528pjb.175.1659618036189;
        Thu, 04 Aug 2022 06:00:36 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:35 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madani@oracle.com>
Subject: [PATCH v2 07/15] mpi3mr: Add helper functions to manage device's port
Date:   Thu,  4 Aug 2022 18:42:18 +0530
Message-Id: <20220804131226.16653-8-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a536c205e569ef44"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a536c205e569ef44
Content-Transfer-Encoding: 8bit

Added below helper functions,
- Add, update the host phys with STL
- Add, remove the device's sas port with STL

Reviewed-by: Himanshu Madhani <himanshu.madani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  13 +
 drivers/scsi/mpi3mr/mpi3mr_os.c        |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 525 +++++++++++++++++++++++++
 3 files changed, 539 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 742caf5..8ab843a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -570,12 +570,18 @@ struct mpi3mr_enclosure_node {
  *
  * @sas_address: World wide unique SAS address
  * @dev_info: Device information bits
+ * @sas_transport_attached: Is this device exposed to transport
+ * @pend_sas_rphy_add: Flag to check device is in process of add
  * @hba_port: HBA port entry
+ * @rphy: SAS transport layer rphy object
  */
 struct tgt_dev_sas_sata {
 	u64 sas_address;
 	u16 dev_info;
+	u8 sas_transport_attached;
+	u8 pend_sas_rphy_add;
 	struct mpi3mr_hba_port *hba_port;
+	struct sas_rphy *rphy;
 };
 
 /**
@@ -1331,4 +1337,11 @@ int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
 u8 mpi3mr_is_expander_device(u16 device_info);
 struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
 	u8 port_id);
+void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc);
+void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc);
+void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
+	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
+	struct mpi3mr_hba_port *hba_port);
+void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
+	bool device_add);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b75ce73..905b434 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -804,7 +804,7 @@ static void mpi3mr_set_io_divert_for_all_vd_in_tg(struct mpi3mr_ioc *mrioc,
  *
  * Return: None.
  */
-static void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
+void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
 	bool device_add)
 {
 	ioc_notice(mrioc, "Device %s was in progress before the reset and\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index f1da7ef..3de9fa0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -706,3 +706,528 @@ struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
 
 	return NULL;
 }
+
+/**
+ * mpi3mr_update_links - refreshing SAS phy link changes
+ * @mrioc: Adapter instance reference
+ * @sas_address_parent: SAS address of parent expander or host
+ * @handle: Firmware device handle of attached device
+ * @phy_number: Phy number
+ * @link_rate: New link rate
+ * @hba_port: HBA port entry
+ *
+ * Return: None.
+ */
+void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
+	u64 sas_address_parent, u16 handle, u8 phy_number, u8 link_rate,
+	struct mpi3mr_hba_port *hba_port)
+{
+	unsigned long flags;
+	struct mpi3mr_sas_node *mr_sas_node;
+	struct mpi3mr_sas_phy *mr_sas_phy;
+
+	if (mrioc->reset_in_progress)
+		return;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	mr_sas_node = __mpi3mr_sas_node_find_by_sas_address(mrioc,
+	    sas_address_parent, hba_port);
+	if (!mr_sas_node) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		return;
+	}
+
+	mr_sas_phy = &mr_sas_node->phy[phy_number];
+	mr_sas_phy->attached_handle = handle;
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+	if (handle && (link_rate >= MPI3_SAS_NEG_LINK_RATE_1_5)) {
+		mpi3mr_set_identify(mrioc, handle,
+		    &mr_sas_phy->remote_identify);
+		mpi3mr_add_phy_to_an_existing_port(mrioc, mr_sas_node,
+		    mr_sas_phy, mr_sas_phy->remote_identify.sas_address,
+		    hba_port);
+	} else
+		memset(&mr_sas_phy->remote_identify, 0, sizeof(struct
+		    sas_identify));
+
+	if (mr_sas_phy->phy)
+		mr_sas_phy->phy->negotiated_linkrate =
+		    mpi3mr_convert_phy_link_rate(link_rate);
+
+	if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+		dev_info(&mr_sas_phy->phy->dev,
+		    "refresh: parent sas_address(0x%016llx),\n"
+		    "\tlink_rate(0x%02x), phy(%d)\n"
+		    "\tattached_handle(0x%04x), sas_address(0x%016llx)\n",
+		    (unsigned long long)sas_address_parent,
+		    link_rate, phy_number, handle, (unsigned long long)
+		    mr_sas_phy->remote_identify.sas_address);
+}
+
+/**
+ * mpi3mr_sas_host_refresh - refreshing sas host object contents
+ * @mrioc: Adapter instance reference
+ *
+ * This function refreshes the controllers phy information and
+ * updates the SAS transport layer with updated information,
+ * this is executed for each device addition or device info
+ * change events
+ *
+ * Return: None.
+ */
+void mpi3mr_sas_host_refresh(struct mpi3mr_ioc *mrioc)
+{
+	int i;
+	u8 link_rate;
+	u16 sz, port_id, attached_handle;
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+
+	dprint_transport_info(mrioc,
+	    "updating handles for sas_host(0x%016llx)\n",
+	    (unsigned long long)mrioc->sas_hba.sas_address);
+
+	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
+	    (mrioc->sas_hba.num_phys *
+	     sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		return;
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	mrioc->sas_hba.handle = 0;
+	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
+		if (sas_io_unit_pg0->phy_data[i].phy_flags &
+		    (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
+		     MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
+			continue;
+		link_rate =
+		    sas_io_unit_pg0->phy_data[i].negotiated_link_rate >> 4;
+		if (!mrioc->sas_hba.handle)
+			mrioc->sas_hba.handle = le16_to_cpu(
+			    sas_io_unit_pg0->phy_data[i].controller_dev_handle);
+		port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
+		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
+			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
+				goto out;
+
+		mrioc->sas_hba.phy[i].handle = mrioc->sas_hba.handle;
+		attached_handle = le16_to_cpu(
+		    sas_io_unit_pg0->phy_data[i].attached_dev_handle);
+		if (attached_handle && link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+			link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+		mrioc->sas_hba.phy[i].hba_port =
+			mpi3mr_get_hba_port_by_id(mrioc, port_id);
+		mpi3mr_update_links(mrioc, mrioc->sas_hba.sas_address,
+		    attached_handle, i, link_rate,
+		    mrioc->sas_hba.phy[i].hba_port);
+	}
+ out:
+	kfree(sas_io_unit_pg0);
+}
+
+/**
+ * mpi3mr_sas_host_add - create sas host object
+ * @mrioc: Adapter instance reference
+ *
+ * This function creates the controllers phy information and
+ * updates the SAS transport layer with updated information,
+ * this is executed for first device addition or device info
+ * change event.
+ *
+ * Return: None.
+ */
+void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
+{
+	int i;
+	u16 sz, num_phys = 1, port_id, ioc_status;
+	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
+	struct mpi3_sas_phy_page0 phy_pg0;
+	struct mpi3_device_page0 dev_pg0;
+	struct mpi3_enclosure_page0 encl_pg0;
+	struct mpi3_device0_sas_sata_format *sasinf;
+
+	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
+	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		return;
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+	num_phys = sas_io_unit_pg0->num_phys;
+	kfree(sas_io_unit_pg0);
+
+	mrioc->sas_hba.host_node = 1;
+	INIT_LIST_HEAD(&mrioc->sas_hba.sas_port_list);
+	mrioc->sas_hba.parent_dev = &mrioc->shost->shost_gendev;
+	mrioc->sas_hba.phy = kcalloc(num_phys,
+	    sizeof(struct mpi3mr_sas_phy), GFP_KERNEL);
+	if (!mrioc->sas_hba.phy)
+		return;
+
+	mrioc->sas_hba.num_phys = num_phys;
+
+	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
+	    (num_phys * sizeof(struct mpi3_sas_io_unit0_phy_data));
+	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_io_unit_pg0)
+		return;
+
+	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	mrioc->sas_hba.handle = 0;
+	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
+		if (sas_io_unit_pg0->phy_data[i].phy_flags &
+		    (MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
+		    MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
+			continue;
+		if (mpi3mr_cfg_get_sas_phy_pg0(mrioc, &ioc_status, &phy_pg0,
+		    sizeof(struct mpi3_sas_phy_page0),
+		    MPI3_SAS_PHY_PGAD_FORM_PHY_NUMBER, i)) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out;
+		}
+		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out;
+		}
+
+		if (!mrioc->sas_hba.handle)
+			mrioc->sas_hba.handle = le16_to_cpu(
+			    sas_io_unit_pg0->phy_data[i].controller_dev_handle);
+		port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
+
+		if (!(mpi3mr_get_hba_port_by_id(mrioc, port_id)))
+			if (!mpi3mr_alloc_hba_port(mrioc, port_id))
+				goto out;
+
+		mrioc->sas_hba.phy[i].handle = mrioc->sas_hba.handle;
+		mrioc->sas_hba.phy[i].phy_id = i;
+		mrioc->sas_hba.phy[i].hba_port =
+		    mpi3mr_get_hba_port_by_id(mrioc, port_id);
+		mpi3mr_add_host_phy(mrioc, &mrioc->sas_hba.phy[i],
+		    phy_pg0, mrioc->sas_hba.parent_dev);
+	}
+	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
+	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
+	    mrioc->sas_hba.handle))) {
+		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
+		goto out;
+	}
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
+		    mrioc->sas_hba.handle, ioc_status, __FILE__, __LINE__,
+		    __func__);
+		goto out;
+	}
+	mrioc->sas_hba.enclosure_handle =
+	    le16_to_cpu(dev_pg0.enclosure_handle);
+	sasinf = &dev_pg0.device_specific.sas_sata_format;
+	mrioc->sas_hba.sas_address =
+	    le64_to_cpu(sasinf->sas_address);
+	ioc_info(mrioc,
+	    "host_add: handle(0x%04x), sas_addr(0x%016llx), phys(%d)\n",
+	    mrioc->sas_hba.handle,
+	    (unsigned long long) mrioc->sas_hba.sas_address,
+	    mrioc->sas_hba.num_phys);
+
+	if (mrioc->sas_hba.enclosure_handle) {
+		if (!(mpi3mr_cfg_get_enclosure_pg0(mrioc, &ioc_status,
+		    &encl_pg0, sizeof(dev_pg0),
+		    MPI3_ENCLOS_PGAD_FORM_HANDLE,
+		    mrioc->sas_hba.enclosure_handle)) &&
+		    (ioc_status == MPI3_IOCSTATUS_SUCCESS))
+			mrioc->sas_hba.enclosure_logical_id =
+				le64_to_cpu(encl_pg0.enclosure_logical_id);
+	}
+
+out:
+	kfree(sas_io_unit_pg0);
+}
+
+/**
+ * mpi3mr_sas_port_add - Expose the SAS device to the SAS TL
+ * @mrioc: Adapter instance reference
+ * @handle: Firmware device handle of the attached device
+ * @sas_address_parent: sas address of parent expander or host
+ * @hba_port: HBA port entry
+ *
+ * This function creates a new sas port object for the given end
+ * device matching sas address and hba_port and adds it to the
+ * sas_node's sas_port_list and expose the attached sas device
+ * to the SAS transport layer through sas_rphy_add.
+ *
+ * Returns a valid mpi3mr_sas_port reference or NULL.
+ */
+static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
+	u16 handle, u64 sas_address_parent, struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_sas_phy *mr_sas_phy, *next;
+	struct mpi3mr_sas_port *mr_sas_port;
+	unsigned long flags;
+	struct mpi3mr_sas_node *mr_sas_node;
+	struct sas_rphy *rphy;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	int i;
+	struct sas_port *port;
+
+	if (!hba_port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return NULL;
+	}
+
+	mr_sas_port = kzalloc(sizeof(struct mpi3mr_sas_port), GFP_KERNEL);
+	if (!mr_sas_port)
+		return NULL;
+
+	INIT_LIST_HEAD(&mr_sas_port->port_list);
+	INIT_LIST_HEAD(&mr_sas_port->phy_list);
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	mr_sas_node = __mpi3mr_sas_node_find_by_sas_address(mrioc,
+	    sas_address_parent, hba_port);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	if (!mr_sas_node) {
+		ioc_err(mrioc, "%s:could not find parent sas_address(0x%016llx)!\n",
+		    __func__, (unsigned long long)sas_address_parent);
+		goto out_fail;
+	}
+
+	if ((mpi3mr_set_identify(mrioc, handle,
+	    &mr_sas_port->remote_identify))) {
+		ioc_err(mrioc,  "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
+	if (mr_sas_port->remote_identify.device_type == SAS_PHY_UNUSED) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
+	mr_sas_port->hba_port = hba_port;
+	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
+	    mr_sas_port->remote_identify.sas_address, hba_port);
+
+	for (i = 0; i < mr_sas_node->num_phys; i++) {
+		if ((mr_sas_node->phy[i].remote_identify.sas_address !=
+		    mr_sas_port->remote_identify.sas_address) ||
+		    (mr_sas_node->phy[i].hba_port != hba_port))
+			continue;
+		list_add_tail(&mr_sas_node->phy[i].port_siblings,
+		    &mr_sas_port->phy_list);
+		mr_sas_port->num_phys++;
+	}
+
+	if (!mr_sas_port->num_phys) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
+	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		tgtdev = mpi3mr_get_tgtdev_by_addr(mrioc,
+		    mr_sas_port->remote_identify.sas_address,
+		    mr_sas_port->hba_port);
+
+		if (!tgtdev) {
+			ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			goto out_fail;
+		}
+		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 1;
+	}
+
+	if (!mr_sas_node->parent_dev) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
+	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if ((sas_port_add(port))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
+
+	list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list,
+	    port_siblings) {
+		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+			dev_info(&port->dev,
+			    "add: handle(0x%04x), sas_address(0x%016llx), phy(%d)\n",
+			    handle, (unsigned long long)
+			    mr_sas_port->remote_identify.sas_address,
+			    mr_sas_phy->phy_id);
+		sas_port_add_phy(port, mr_sas_phy->phy);
+		mr_sas_phy->phy_belongs_to_port = 1;
+		mr_sas_phy->hba_port = hba_port;
+	}
+
+	mr_sas_port->port = port;
+	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		rphy = sas_end_device_alloc(port);
+		tgtdev->dev_spec.sas_sata_inf.rphy = rphy;
+	} else {
+		rphy = sas_expander_alloc(port,
+		    mr_sas_port->remote_identify.device_type);
+	}
+	rphy->identify = mr_sas_port->remote_identify;
+
+	if (mrioc->current_event)
+		mrioc->current_event->pending_at_sml = 1;
+
+	if ((sas_rphy_add(rphy))) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+	}
+	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
+		tgtdev->dev_spec.sas_sata_inf.sas_transport_attached = 1;
+		mpi3mr_tgtdev_put(tgtdev);
+	}
+
+	dev_info(&rphy->dev,
+	    "%s: added: handle(0x%04x), sas_address(0x%016llx)\n",
+	    __func__, handle, (unsigned long long)
+	    mr_sas_port->remote_identify.sas_address);
+
+	mr_sas_port->rphy = rphy;
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_add_tail(&mr_sas_port->port_list, &mr_sas_node->sas_port_list);
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	if (mrioc->current_event) {
+		mrioc->current_event->pending_at_sml = 0;
+		if (mrioc->current_event->discard)
+			mpi3mr_print_device_event_notice(mrioc, true);
+	}
+
+	return mr_sas_port;
+
+ out_fail:
+	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
+	    port_siblings)
+		list_del(&mr_sas_phy->port_siblings);
+	kfree(mr_sas_port);
+	return NULL;
+}
+
+/**
+ * mpi3mr_sas_port_remove - remove port from the list
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of attached device
+ * @sas_address_parent: SAS address of parent expander or host
+ * @hba_port: HBA port entry
+ *
+ * Removing object and freeing associated memory from the
+ * sas_port_list.
+ *
+ * Return: None
+ */
+static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
+	u64 sas_address_parent, struct mpi3mr_hba_port *hba_port)
+{
+	int i;
+	unsigned long flags;
+	struct mpi3mr_sas_port *mr_sas_port, *next;
+	struct mpi3mr_sas_node *mr_sas_node;
+	u8 found = 0;
+	struct mpi3mr_sas_phy *mr_sas_phy, *next_phy;
+	struct mpi3mr_hba_port *srch_port, *hba_port_next = NULL;
+
+	if (!hba_port)
+		return;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	mr_sas_node = __mpi3mr_sas_node_find_by_sas_address(mrioc,
+	    sas_address_parent, hba_port);
+	if (!mr_sas_node) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		return;
+	}
+	list_for_each_entry_safe(mr_sas_port, next, &mr_sas_node->sas_port_list,
+	    port_list) {
+		if (mr_sas_port->remote_identify.sas_address != sas_address)
+			continue;
+		if (mr_sas_port->hba_port != hba_port)
+			continue;
+		found = 1;
+		list_del(&mr_sas_port->port_list);
+		goto out;
+	}
+
+ out:
+	if (!found) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		return;
+	}
+
+	if (mr_sas_node->host_node) {
+		list_for_each_entry_safe(srch_port, hba_port_next,
+		    &mrioc->hba_port_table_list, list) {
+			if (srch_port != hba_port)
+				continue;
+			ioc_info(mrioc,
+			    "removing hba_port entry: %p port: %d from hba_port list\n",
+			    srch_port, srch_port->port_id);
+			list_del(&hba_port->list);
+			kfree(hba_port);
+			break;
+		}
+	}
+
+	for (i = 0; i < mr_sas_node->num_phys; i++) {
+		if (mr_sas_node->phy[i].remote_identify.sas_address ==
+		    sas_address)
+			memset(&mr_sas_node->phy[i].remote_identify, 0,
+			    sizeof(struct sas_identify));
+	}
+
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
+	if (mrioc->current_event)
+		mrioc->current_event->pending_at_sml = 1;
+
+	list_for_each_entry_safe(mr_sas_phy, next_phy,
+	    &mr_sas_port->phy_list, port_siblings) {
+		if ((mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO))
+			dev_info(&mr_sas_port->port->dev,
+			    "remove: sas_address(0x%016llx), phy(%d)\n",
+			    (unsigned long long)
+			    mr_sas_port->remote_identify.sas_address,
+			    mr_sas_phy->phy_id);
+		mr_sas_phy->phy_belongs_to_port = 0;
+		if (!mrioc->stop_drv_processing)
+			sas_port_delete_phy(mr_sas_port->port,
+			    mr_sas_phy->phy);
+		list_del(&mr_sas_phy->port_siblings);
+	}
+	if (!mrioc->stop_drv_processing)
+		sas_port_delete(mr_sas_port->port);
+	ioc_info(mrioc, "%s: removed sas_address(0x%016llx)\n",
+	    __func__, (unsigned long long)sas_address);
+
+	if (mrioc->current_event) {
+		mrioc->current_event->pending_at_sml = 0;
+		if (mrioc->current_event->discard)
+			mpi3mr_print_device_event_notice(mrioc, false);
+	}
+
+	kfree(mr_sas_port);
+}
-- 
2.27.0


--000000000000a536c205e569ef44
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILgD83h1fU4ThIS9or8v
NxREW4vOjAT4o3OA+2qHDubCMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDAzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBCA/se7YsGmEuvtdwi2s5s2mp+9oG/3ZzYz6jF
z4NxhN4vfVBF2qO5rQqjNc17ynyB42155LuuS2Z/8BExg6ncavdLc0DQYb0uBYlbgBDW54cbHx6X
tEmqDfhL2bTEwuYAi8d3ZU1mnYTtEhXrrXTdM+snATaaeXFlYC/+5P+I6VOgykpbUg074bYvjB16
RG1CWx5kJAwlHJ+WbG5D0RvcMn6xuy9WloWF/Fqk8MMRTVTUXHVhqc6GdWSb8feV2L5XmndK9RTf
HAwZU4s6IkD/A3sazufzre4a/Qr/e9lM1JlhLFBr7ukB27D9S08fbWcx/Jg0wQOIpbwiTQR7GErB
--000000000000a536c205e569ef44--
