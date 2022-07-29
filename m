Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D715FC19F2B
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiG2NGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbiG2NFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FBC77A70
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so7175486pjh.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=dEwTRs1VSoBcPKfx7TcWyIJuzhQjmXasgYADIVjNgpM=;
        b=R5HHA6Grnd16+167RS1KKfKfqdTybjvtmPvc5SsL5do5KTAmlIKwbi5hp3QWxzXpPh
         BoJ4AgsogPzQLg2L0gt9XWFhlpnWCvGYRl3SM0FZFUaRcg9HmKYf/s25yM7rYqi7Nm5y
         tAbSznuneSbiUuSadpObvzVGMqHXEinyEqS+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=dEwTRs1VSoBcPKfx7TcWyIJuzhQjmXasgYADIVjNgpM=;
        b=rnoFs37OulWVEUfnMwbA5qhJrJtpX1EEVeuPe2k9aNVPXk1J4MDQWWoZFvLlYAvBmO
         Ri5qh0XD/BYkGDRf/w5uNUYVLaoQG2PXGvqrWQJJFyv2Fcpul/GT13kXfwQmRIoj6/gV
         flhg/cf/pV488G8mNEtRi70mZCmb7jUFQY7c2mVK1m/Uk+t6JS3ju5ZpxyU2GmKgaCWr
         WXWwhCVpsINHm71DydSHCfXWm4ccvJFT60frM9I8naedcrrFP/Mia85K3n5OM/adGG7f
         2MJlHP5zmaLdNm+1ZowcD2v/QbyzIip0z87s5Puu+HpNN4uwgfZlGrheLiYQuvkQNTiy
         6BOw==
X-Gm-Message-State: ACgBeo03OFXYlaSqpNMIe8yFOmN6eOEfAk9vvlBmyj9PjNRVFU7g1snw
        R+V7A9sKjYER6pSIHIcbZrAgkkdgDEfmf/KQnrVNr4vAq6EtD6f9wnbophAgr/7H70yu2fYIes3
        En/I8d2bfa8vNAZRGCaWQTLB2T/EyKOkuxFBkgq2llu6ESAlh2BK7W1jE0ZYFpi1DKaTA4tFMmG
        dIE9kOAZz6
X-Google-Smtp-Source: AA6agR4WII16ntJr0YBtsU2XEnvgsyabr5s7qOEivGGRMg6ycDz+lkpQV2cVQMlrw4ZUomHs3t3CfQ==
X-Received: by 2002:a17:902:ea0d:b0:16d:c5c0:f180 with SMTP id s13-20020a170902ea0d00b0016dc5c0f180mr3865365plg.10.1659099874257;
        Fri, 29 Jul 2022 06:04:34 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:33 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 08/15] mpi3mr: Enable STL on HBAs where multipath is disabled
Date:   Fri, 29 Jul 2022 18:46:20 +0530
Message-Id: <20220729131627.15019-9-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b0381c05e4f14ab0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b0381c05e4f14ab0
Content-Transfer-Encoding: 8bit

Register the SAS, SATA devices to SCSI Transport Layer (STL)
only if multipath capability is disabled on the controller's
firmware.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  6 ++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 13 +++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 31 +++++++++++++++++++++++++++----
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 8ab843a..8c8703e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -650,6 +650,8 @@ union _form_spec_inf {
  * @dev_type: SAS/SATA/PCIE device type
  * @is_hidden: Should be exposed to upper layers or not
  * @host_exposed: Already exposed to host or not
+ * @io_unit_port: IO Unit port ID
+ * @non_stl: Is this device not to be attached with SAS TL
  * @io_throttle_enabled: I/O throttling needed or not
  * @q_depth: Device specific Queue Depth
  * @wwid: World wide ID
@@ -669,6 +671,8 @@ struct mpi3mr_tgt_dev {
 	u8 dev_type;
 	u8 is_hidden;
 	u8 host_exposed;
+	u8 io_unit_port;
+	u8 non_stl;
 	u8 io_throttle_enabled;
 	u16 q_depth;
 	u64 wwid;
@@ -992,6 +996,7 @@ struct scmd_priv {
  * @cfg_page: Default memory for configuration pages
  * @cfg_page_dma: Configuration page DMA address
  * @cfg_page_sz: Default configuration page memory size
+ * @sas_transport_enabled: SAS transport enabled or not
  * @sas_hba: SAS node for the controller
  * @sas_expander_list: SAS node list of expanders
  * @sas_node_lock: Lock to protect SAS node list
@@ -1174,6 +1179,7 @@ struct mpi3mr_ioc {
 	dma_addr_t cfg_page_dma;
 	u16 cfg_page_sz;
 
+	u8 sas_transport_enabled;
 	struct mpi3mr_sas_node sas_hba;
 	struct list_head sas_expander_list;
 	spinlock_t sas_node_lock;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 9c36f52..0659d3f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1136,6 +1136,13 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		return -EPERM;
 	}
 
+	if ((mrioc->sas_transport_enabled) && (mrioc->facts.ioc_capabilities &
+	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED))
+		ioc_err(mrioc,
+		    "critical error: multipath capability is enabled at the\n"
+		    "\tcontroller while sas transport support is enabled at the\n"
+		    "\tdriver, please reboot the system or reload the driver\n");
+
 	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
 	if (mrioc->facts.max_devhandle % 8)
 		dev_handle_bitmap_sz++;
@@ -3453,6 +3460,7 @@ static const struct {
 	char *name;
 } mpi3mr_capabilities[] = {
 	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
+	{ MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED, "MultiPath" },
 };
 
 /**
@@ -3734,6 +3742,11 @@ retry_init:
 		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
 		    MPI3MR_HOST_IOS_KDUMP);
 
+	if (!(mrioc->facts.ioc_capabilities &
+	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED)) {
+		mrioc->sas_transport_enabled = 1;
+	}
+
 	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 905b434..ae77422 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1032,6 +1032,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	tgtdev->perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	tgtdev->dev_handle = le16_to_cpu(dev_pg0->dev_handle);
 	tgtdev->dev_type = dev_pg0->device_form;
+	tgtdev->io_unit_port = dev_pg0->io_unit_port;
 	tgtdev->encl_handle = le16_to_cpu(dev_pg0->enclosure_handle);
 	tgtdev->parent_handle = le16_to_cpu(dev_pg0->parent_dev_handle);
 	tgtdev->slot = le16_to_cpu(dev_pg0->slot);
@@ -1092,6 +1093,13 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		else if (!(dev_info & (MPI3_SAS_DEVICE_INFO_STP_SATA_TARGET |
 		    MPI3_SAS_DEVICE_INFO_SSP_TARGET)))
 			tgtdev->is_hidden = 1;
+
+		if (((tgtdev->devpg0_flag &
+		    MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTACHED)
+		    && (tgtdev->devpg0_flag &
+		    MPI3_DEVICE0_FLAGS_ATT_METHOD_VIRTUAL)) ||
+		    (tgtdev->parent_handle == 0xFFFF))
+			tgtdev->non_stl = 1;
 		break;
 	}
 	case MPI3_DEVICE_DEVFORM_PCIE:
@@ -1124,6 +1132,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		    ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=
 		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_SCSI_DEVICE))
 			tgtdev->is_hidden = 1;
+		tgtdev->non_stl = 1;
 		if (!mrioc->shost)
 			break;
 		prot_mask = scsi_host_get_prot(mrioc->shost);
@@ -1147,6 +1156,7 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		tgtdev->dev_spec.vd_inf.state = vdinf->vd_state;
 		if (vdinf->vd_state == MPI3_DEVICE0_VD_STATE_OFFLINE)
 			tgtdev->is_hidden = 1;
+		tgtdev->non_stl = 1;
 		tgtdev->dev_spec.vd_inf.tg_id = vdinf_io_throttle_group;
 		tgtdev->dev_spec.vd_inf.tg_high =
 		    le16_to_cpu(vdinf->io_throttle_group_high) * 2048;
@@ -1424,8 +1434,9 @@ mpi3mr_sastopochg_evt_debug(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "%s :sas topology change: (%s)\n",
 	    __func__, status_str);
 	ioc_info(mrioc,
-	    "%s :\texpander_handle(0x%04x), enclosure_handle(0x%04x) start_phy(%02d), num_entries(%d)\n",
+	    "%s :\texpander_handle(0x%04x), port(%d), enclosure_handle(0x%04x) start_phy(%02d), num_entries(%d)\n",
 	    __func__, le16_to_cpu(event_data->expander_dev_handle),
+	    event_data->io_unit_port,
 	    le16_to_cpu(event_data->enclosure_handle),
 	    event_data->start_phy_num, event_data->num_entries);
 	for (i = 0; i < event_data->num_entries; i++) {
@@ -1732,6 +1743,9 @@ static void mpi3mr_set_qd_for_all_vd_in_tg(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
+	struct mpi3_device_page0 *dev_pg0 = NULL;
+	u16 perst_id;
+
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
 
@@ -1752,8 +1766,10 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	{
-		mpi3mr_devinfochg_evt_bh(mrioc,
-		    (struct mpi3_device_page0 *)fwevt->event_data);
+		dev_pg0 = (struct mpi3_device_page0 *)fwevt->event_data;
+		perst_id = le16_to_cpu(dev_pg0->persistent_id);
+		if (perst_id != MPI3_DEVICE0_PERSISTENTID_INVALID)
+			mpi3mr_devinfochg_evt_bh(mrioc, dev_pg0);
 		break;
 	}
 	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
@@ -1851,6 +1867,9 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
 	u16 perst_id = 0;
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
+	if (perst_id == MPI3_DEVICE0_PERSISTENTID_INVALID)
+		return retval;
+
 	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
 	if (tgtdev) {
 		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
@@ -4850,7 +4869,11 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 	if (wq)
 		destroy_workqueue(wq);
-	scsi_remove_host(shost);
+
+	if (mrioc->sas_transport_enabled)
+		sas_remove_host(shost);
+	else
+		scsi_remove_host(shost);
 
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
-- 
2.27.0


--000000000000b0381c05e4f14ab0
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBzPY74xEiFtSkCQL5ZN
BsoSfgEktChObiSo2Uq4wtHSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCaJ5zoTyW7xzcT2pOiV/XNe+MAHecAlMOzqp/L
4KpHKLzDEMFaPYV5JHTiq8n5knBSEIWHbN0dakWfSCSR6Zr6J84vDZ0pu7YslWLuiNcPGN/sSfba
pW5FrYcLvbgj6DZd2HZ/xzUVVRBbtocqwE+lP2Tiu7j85PYwaUqLgS4vGMkCWvBDyWnK52oTWkhF
uUWZHVfjK5WfFfiX6qnqYd3MeSJyL5+QF5t5cMHg+fEDa+4av59+4tmLiFP0GEPYwIgthCVEosXg
z/OAujQVYqJ+sEM5WOhUc8MCFtyG4oq1m68kJWUbXylGvUi+cTWLNVP/xCpbjDU2wNRZXPftHAJx
--000000000000b0381c05e4f14ab0--
