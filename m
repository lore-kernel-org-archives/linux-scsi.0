Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3904EC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiHDNAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239720AbiHDNAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B96328
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:35 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 17so3774407plj.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=Y+6f2VvUZcHg3TgFP8d7BtfgXev7y29maiUJgd9nriQ=;
        b=Bv10A5P7gkq9UoJ7L6KSgFGPzhvpxFUJH154HBnlYjLZsIwl1J1W9BUd3biyyHQ6WT
         uCJwKWeTnJo9BTEqYF5qzuGqOii8I2NV6CiNTVnt5OTUVLnGP5PFR5gwHBZAWn3/JmqB
         iQN5FRsMA/WdW1qwOc303yoZ86Hl7//s91khE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=Y+6f2VvUZcHg3TgFP8d7BtfgXev7y29maiUJgd9nriQ=;
        b=TiQ4MXoge8aHuVwD8FmuAuE9u4noUB4nOger50la0ZH8gCrcvUFhvuqgKrkbnY4jOV
         aPjrADFloJXzzxuXwXc/x6eK2kca+98E2xAqBEoPR5OsK6AIkvs+t9LRMRsqm3FwkNji
         JrdYm6KjU+24bM0P0dyi5UopUCk9BzdlzPJ2yjeVdI1X5m2apW/piFhVpu4fT5MjnPQ8
         R1OyldyT6YrCqPrcUYKfTehE46XT6vcN9c/Z0gDu25LKYum3PijHGF92DgaCuAFjdt2x
         evovVcPPK1mWkXczmTgsQkWp2JjMoBPZVu2xVDuhA+pNpk1xAYAYrn7HZ49SzLlZEKi9
         nL3g==
X-Gm-Message-State: ACgBeo3Zbsp+9DMrDwcigJrutI98hWSKuuzZsKI82/6d9hHH3tUSwMaP
        VZhdDVEiniVyfNEONW3wLWsh8gql9cvOHRMAxT5035EzNRRjBOHbmcoAWeMNbWW8gIMIFBFC2y9
        q9bKgJC0aHBevDa4AMJRXMKzpatNMLTx5dnxsk4gL5IoA83r1d3/L68LcoBHNyObnExphwCPLBv
        MIG0Yob3t4
X-Google-Smtp-Source: AA6agR4ZvloeusKNLfaydm1TOJZYPYqwypvS5ejNfoOW3Y1sWanTUDcg8NJ+1+aqDXz032kUVSJmkg==
X-Received: by 2002:a17:903:110e:b0:16c:defc:a092 with SMTP id n14-20020a170903110e00b0016cdefca092mr1757895plh.143.1659618033681;
        Thu, 04 Aug 2022 06:00:33 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:33 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v2 06/15] mpi3mr: Add helper functions to retrieve device objects
Date:   Thu,  4 Aug 2022 18:42:17 +0530
Message-Id: <20220804131226.16653-7-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006a921705e569efff"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006a921705e569efff
Content-Transfer-Encoding: 8bit

Added below helper functions,
- Get the device's sas address by reading
  correspond device's Device page0,
- Get the expander object from expander list based
  on expander's handle,
- Get the target device object from target device list
  based on device's sas address,
- Get the expander device object from expander list
  based on expanders's sas address,
- Get hba port object from hba port table list
  based on port's port id

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  14 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c        |   3 +
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 278 +++++++++++++++++++++++++
 3 files changed, 295 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 006bc5d..742caf5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -570,10 +570,12 @@ struct mpi3mr_enclosure_node {
  *
  * @sas_address: World wide unique SAS address
  * @dev_info: Device information bits
+ * @hba_port: HBA port entry
  */
 struct tgt_dev_sas_sata {
 	u64 sas_address;
 	u16 dev_info;
+	struct mpi3mr_hba_port *hba_port;
 };
 
 /**
@@ -984,6 +986,10 @@ struct scmd_priv {
  * @cfg_page: Default memory for configuration pages
  * @cfg_page_dma: Configuration page DMA address
  * @cfg_page_sz: Default configuration page memory size
+ * @sas_hba: SAS node for the controller
+ * @sas_expander_list: SAS node list of expanders
+ * @sas_node_lock: Lock to protect SAS node list
+ * @hba_port_table_list: List of HBA Ports
  * @enclosure_list: List of Enclosure objects
  */
 struct mpi3mr_ioc {
@@ -1162,6 +1168,10 @@ struct mpi3mr_ioc {
 	dma_addr_t cfg_page_dma;
 	u16 cfg_page_sz;
 
+	struct mpi3mr_sas_node sas_hba;
+	struct list_head sas_expander_list;
+	spinlock_t sas_node_lock;
+	struct list_head hba_port_table_list;
 	struct list_head enclosure_list;
 };
 
@@ -1317,4 +1327,8 @@ int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
 int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
 	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
+
+u8 mpi3mr_is_expander_device(u16 device_info);
+struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
+	u8 port_id);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ca718cb..b75ce73 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4692,11 +4692,14 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->tgtdev_lock);
 	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
+	spin_lock_init(&mrioc->sas_node_lock);
 
 	INIT_LIST_HEAD(&mrioc->fwevt_list);
 	INIT_LIST_HEAD(&mrioc->tgtdev_list);
 	INIT_LIST_HEAD(&mrioc->delayed_rmhs_list);
 	INIT_LIST_HEAD(&mrioc->delayed_evtack_cmds_list);
+	INIT_LIST_HEAD(&mrioc->sas_expander_list);
+	INIT_LIST_HEAD(&mrioc->hba_port_table_list);
 	INIT_LIST_HEAD(&mrioc->enclosure_list);
 
 	mutex_init(&mrioc->reset_mutex);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 8c76bf5..f1da7ef 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,6 +9,236 @@
 
 #include "mpi3mr.h"
 
+/**
+ * __mpi3mr_expander_find_by_handle - expander search by handle
+ * @mrioc: Adapter instance reference
+ * @handle: Firmware device handle of the expander
+ *
+ * Context: The caller should acquire sas_node_lock
+ *
+ * This searches for expander device based on handle, then
+ * returns the sas_node object.
+ *
+ * Return: Expander sas_node object reference or NULL
+ */
+static struct mpi3mr_sas_node *__mpi3mr_expander_find_by_handle(struct mpi3mr_ioc
+	*mrioc, u16 handle)
+{
+	struct mpi3mr_sas_node *sas_expander, *r;
+
+	r = NULL;
+	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
+		if (sas_expander->handle != handle)
+			continue;
+		r = sas_expander;
+		goto out;
+	}
+ out:
+	return r;
+}
+
+/**
+ * mpi3mr_is_expander_device - if device is an expander
+ * @device_info: Bitfield providing information about the device
+ *
+ * Return: 1 if the device is expander device, else 0.
+ */
+u8 mpi3mr_is_expander_device(u16 device_info)
+{
+	if ((device_info & MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_MASK) ==
+	     MPI3_SAS_DEVICE_INFO_DEVICE_TYPE_EXPANDER)
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * mpi3mr_get_sas_address - retrieve sas_address for handle
+ * @mrioc: Adapter instance reference
+ * @handle: Firmware device handle
+ * @sas_address: Address to hold sas address
+ *
+ * This function issues device page0 read for a given device
+ * handle and gets the SAS address and return it back
+ *
+ * Return: 0 for success, non-zero for failure
+ */
+static int mpi3mr_get_sas_address(struct mpi3mr_ioc *mrioc, u16 handle,
+	u64 *sas_address)
+{
+	struct mpi3_device_page0 dev_pg0;
+	u16 ioc_status;
+	struct mpi3_device0_sas_sata_format *sasinf;
+
+	*sas_address = 0;
+
+	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
+	    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
+	    handle))) {
+		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
+		return -ENXIO;
+	}
+
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc, "device page read failed for handle(0x%04x), with ioc_status(0x%04x) failure at %s:%d/%s()!\n",
+		    handle, ioc_status, __FILE__, __LINE__, __func__);
+		return -ENXIO;
+	}
+
+	if (le16_to_cpu(dev_pg0.flags) &
+	    MPI3_DEVICE0_FLAGS_CONTROLLER_DEV_HANDLE)
+		*sas_address = mrioc->sas_hba.sas_address;
+	else if (dev_pg0.device_form == MPI3_DEVICE_DEVFORM_SAS_SATA) {
+		sasinf = &dev_pg0.device_specific.sas_sata_format;
+		*sas_address = le64_to_cpu(sasinf->sas_address);
+	} else {
+		ioc_err(mrioc, "%s: device_form(%d) is not SAS_SATA\n",
+		    __func__, dev_pg0.device_form);
+		return -ENXIO;
+	}
+	return 0;
+}
+
+/**
+ * __mpi3mr_get_tgtdev_by_addr - target device search
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of the device
+ * @hba_port: HBA port entry
+ *
+ * This searches for target device from sas address and hba port
+ * pointer then return mpi3mr_tgt_dev object.
+ *
+ * Return: Valid tget_dev or NULL
+ */
+static struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr(struct mpi3mr_ioc *mrioc,
+	u64 sas_address, struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	assert_spin_locked(&mrioc->tgtdev_lock);
+
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
+		if ((tgtdev->dev_type == MPI3_DEVICE_DEVFORM_SAS_SATA) &&
+		    (tgtdev->dev_spec.sas_sata_inf.sas_address == sas_address)
+		    && (tgtdev->dev_spec.sas_sata_inf.hba_port == hba_port))
+			goto found_device;
+	return NULL;
+found_device:
+	mpi3mr_tgtdev_get(tgtdev);
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_get_tgtdev_by_addr - target device search
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of the device
+ * @hba_port: HBA port entry
+ *
+ * This searches for target device from sas address and hba port
+ * pointer then return mpi3mr_tgt_dev object.
+ *
+ * Context: This function will acquire tgtdev_lock and will
+ * release before returning the mpi3mr_tgt_dev object.
+ *
+ * Return: Valid tget_dev or NULL
+ */
+static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_addr(struct mpi3mr_ioc *mrioc,
+	u64 sas_address, struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+
+	if (!hba_port)
+		goto out;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_addr(mrioc, sas_address, hba_port);
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+out:
+	return tgtdev;
+}
+
+/**
+ * mpi3mr_expander_find_by_sas_address - sas expander search
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of expander
+ * @hba_port: HBA port entry
+ *
+ * Return: A valid SAS expander node or NULL.
+ *
+ */
+static struct mpi3mr_sas_node *mpi3mr_expander_find_by_sas_address(
+	struct mpi3mr_ioc *mrioc, u64 sas_address,
+	struct mpi3mr_hba_port *hba_port)
+{
+	struct mpi3mr_sas_node *sas_expander, *r = NULL;
+
+	if (!hba_port)
+		goto out;
+
+	list_for_each_entry(sas_expander, &mrioc->sas_expander_list, list) {
+		if ((sas_expander->sas_address != sas_address) ||
+					 (sas_expander->hba_port != hba_port))
+			continue;
+		r = sas_expander;
+		goto out;
+	}
+out:
+	return r;
+}
+
+/**
+ * __mpi3mr_sas_node_find_by_sas_address - sas node search
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of expander or sas host
+ * @hba_port: HBA port entry
+ * Context: Caller should acquire mrioc->sas_node_lock.
+ *
+ * If the SAS address indicates the device is direct attached to
+ * the controller (controller's SAS address) then the SAS node
+ * associated with the controller is returned back else the SAS
+ * address and hba port are used to identify the exact expander
+ * and the associated sas_node object is returned. If there is
+ * no match NULL is returned.
+ *
+ * Return: A valid SAS node or NULL.
+ *
+ */
+static struct mpi3mr_sas_node *__mpi3mr_sas_node_find_by_sas_address(
+	struct mpi3mr_ioc *mrioc, u64 sas_address,
+	struct mpi3mr_hba_port *hba_port)
+{
+
+	if (mrioc->sas_hba.sas_address == sas_address)
+		return &mrioc->sas_hba;
+	return mpi3mr_expander_find_by_sas_address(mrioc, sas_address,
+	    hba_port);
+}
+
+/**
+ * mpi3mr_parent_present - Is parent present for a phy
+ * @mrioc: Adapter instance reference
+ * @phy: SAS transport layer phy object
+ *
+ * Return: 0 if parent is present else non-zero
+ */
+static int mpi3mr_parent_present(struct mpi3mr_ioc *mrioc, struct sas_phy *phy)
+{
+	unsigned long flags;
+	struct mpi3mr_hba_port *hba_port = phy->hostdata;
+
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	if (__mpi3mr_sas_node_find_by_sas_address(mrioc,
+	    phy->identify.sas_address,
+	    hba_port) == NULL) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		return -1;
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+	return 0;
+}
+
 /**
  * mpi3mr_convert_phy_link_rate -
  * @link_rate: link rate as defined in the MPI header
@@ -428,3 +658,51 @@ static int mpi3mr_add_expander_phy(struct mpi3mr_ioc *mrioc,
 	mr_sas_phy->phy = phy;
 	return 0;
 }
+
+/**
+ * mpi3mr_alloc_hba_port - alloc hba port object
+ * @mrioc: Adapter instance reference
+ * @port_id: Port number
+ *
+ * Alloc memory for hba port object.
+ */
+static struct mpi3mr_hba_port *
+mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
+{
+	struct mpi3mr_hba_port *hba_port;
+
+	hba_port = kzalloc(sizeof(struct mpi3mr_hba_port),
+	    GFP_KERNEL);
+	if (!hba_port)
+		return NULL;
+	hba_port->port_id = port_id;
+	ioc_info(mrioc, "hba_port entry: %p, port: %d is added to hba_port list\n",
+	    hba_port, hba_port->port_id);
+	list_add_tail(&hba_port->list, &mrioc->hba_port_table_list);
+	return hba_port;
+}
+
+/**
+ * mpi3mr_get_hba_port_by_id - find hba port by id
+ * @mrioc: Adapter instance reference
+ * @port_id - Port ID to search
+ *
+ * Return: mpi3mr_hba_port reference for the matched port
+ */
+
+struct mpi3mr_hba_port *mpi3mr_get_hba_port_by_id(struct mpi3mr_ioc *mrioc,
+	u8 port_id)
+{
+	struct mpi3mr_hba_port *port, *port_next;
+
+	list_for_each_entry_safe(port, port_next,
+	    &mrioc->hba_port_table_list, list) {
+		if (port->port_id != port_id)
+			continue;
+		if (port->flags & MPI3MR_HBA_PORT_FLAG_DIRTY)
+			continue;
+		return port;
+	}
+
+	return NULL;
+}
-- 
2.27.0


--0000000000006a921705e569efff
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINskL5lVYQqd4ZDxKmgW
4I0j/pgt8dqtXbGy4a5L0OuqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDAzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAEkQTsy3bbBjVneKYBkDlUXtw3Kmx2j7cSFRY8
uf8eK/vkJybN77LprkRTRb3JjTe62hlzX2i8evJzfkrxUAIDUEhRpdRucLYznlvZTgsO/k6TZjxw
C7HHTQueF/s3vc/iBqIJeBO41y1Ke6IGq/O34VvxPwEAd05AOIUMLoqqkLaHKVB0AbrKs0DbPhJf
hsrhf85o/yZhPC5uL9bdSqM0dCRY5a6lWpHK+lx0UTCzFivC0Oo1Ud9ybAPvZwRpNXct5la+/sfX
/NWKAgdjsXOdDl4acdFEpwyhz9Pc0BHDHpSusokqPqdAGdaXuQVx25ky2VU1fZ3NQhKhoX73VX/W
--0000000000006a921705e569efff--
