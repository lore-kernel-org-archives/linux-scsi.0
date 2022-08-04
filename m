Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61CDC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbiHDNAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239782AbiHDNAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DA56179
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 17so19346828pfy.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=MN2cr6hYyqM9Sa5K2bLn1FbgGZB8tf8qL66TJ7hmWZ4=;
        b=Vic1fIV2VykOkP44/X3UU5Vl4Gy8U4qhU2+gBQfigJDJL60muqKYV/yRRUzeXUS+EU
         BzMpvjDwZ7hiboYf2nwU4C28tM4vfz8ZhEPYRFRzPT06Au8nK1UKgJqTZUOzOUfzCOh2
         PNeBRUCHCdeYBEWZkQPpIESQFkLer/l0U+Xig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=MN2cr6hYyqM9Sa5K2bLn1FbgGZB8tf8qL66TJ7hmWZ4=;
        b=EzPLTMyPbCLf/F73vOlgjKRjA1l+/08Uc6VR3Rss/r03Xsv+jbTnNxOILgAuz6ziH7
         OMVnW6SrXb8BvnMuFJuxEMjwaODiGConpOB1un5sn9o7xGBBAmyt6OY5StUKwZlhyNXC
         Qc+dfER6Ipmh6szq0qgzzHoNLawopaStpaXY3KSYoPjKWIxdU1e+jtELG6RFZuwpDv+E
         BryJAnLi/dg5GhmdeoeedfUDHCtcFdXVXc1Z1PCqeX3sIt/CswpYB7wTLTbI2byj2QPP
         Do7H4WmpkkuozPqAK8QMVpYeG0D7ys3CYrtRkIfVLp/ZICFNhvFpPdxwpjfSM06yIV8X
         /tIA==
X-Gm-Message-State: ACgBeo00pdcmOzSmDufKItCaNWcy1WWPehjINv5bKvz1R38t5Ap4js7h
        2mX+C7ZHJFr5x+GNpvHSqM/WGA4bWX9kb2gCzIVb7ieuK+zUFhQ7bS+6XLGc6abqpD6ILWQCPa0
        pHvzIDeO6gfNEe5n9QcgzrkuCHuueaHwYWGa/o1XcyE9dBVUJo6Bixp5BXpTlnSjcKMvrvUJGWY
        mgrV7qP5SX
X-Google-Smtp-Source: AA6agR5ecEGmV/bD2UTXWPpnY3s7uleGhhbwk82+dvNrI5ypW2GsBI0IqO3m4ndftKot7hzZfaW+Og==
X-Received: by 2002:a63:f306:0:b0:41a:6258:dcd2 with SMTP id l6-20020a63f306000000b0041a6258dcd2mr1524363pgh.28.1659618044712;
        Thu, 04 Aug 2022 06:00:44 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:44 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 10/15] mpi3mr: Get target object based on rphy
Date:   Thu,  4 Aug 2022 18:42:21 +0530
Message-Id: <20220804131226.16653-11-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001067d105e569f0a0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001067d105e569f0a0
Content-Transfer-Encoding: 8bit

When device is registered with the STL then
get the corresponding device's target object
using the rphy in below callback functions,

- mpi3mr_target_alloc,
- mpi3mr_slave_alloc,
- mpi3mr_slave_configure,
- mpi3mr_slave_destroy

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  4 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  2 +
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 61 +++++++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 29 ++++++++++++
 4 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9cd5f88..a91a57b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -997,6 +997,7 @@ struct scmd_priv {
  * @cfg_page_dma: Configuration page DMA address
  * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
+ * @scsi_device_channel: Channel ID for SCSI devices
  * @sas_hba: SAS node for the controller
  * @sas_expander_list: SAS node list of expanders
  * @sas_node_lock: Lock to protect SAS node list
@@ -1180,6 +1181,7 @@ struct mpi3mr_ioc {
 	u16 cfg_page_sz;
 
 	u8 sas_transport_enabled;
+	u8 scsi_device_channel;
 	struct mpi3mr_sas_node sas_hba;
 	struct list_head sas_expander_list;
 	spinlock_t sas_node_lock;
@@ -1355,6 +1357,8 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_hba_port *hba_port);
 void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_tgt_dev *tgtdev);
+struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
+	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy);
 void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
 	bool device_add);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8af43c5..295ad8c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3745,6 +3745,8 @@ retry_init:
 	if (!(mrioc->facts.ioc_capabilities &
 	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED)) {
 		mrioc->sas_transport_enabled = 1;
+		mrioc->scsi_device_channel = 1;
+		mrioc->shost->max_channel = 1;
 	}
 
 	mrioc->reply_sz = mrioc->facts.reply_sz;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 9a32dc6..aed9b60 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4031,9 +4031,10 @@ static void mpi3mr_slave_destroy(struct scsi_device *sdev)
 	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
-	struct mpi3mr_tgt_dev *tgt_dev;
+	struct mpi3mr_tgt_dev *tgt_dev = NULL;
 	unsigned long flags;
 	struct scsi_target *starget;
+	struct sas_rphy *rphy = NULL;
 
 	if (!sdev->hostdata)
 		return;
@@ -4046,7 +4047,14 @@ static void mpi3mr_slave_destroy(struct scsi_device *sdev)
 	scsi_tgt_priv_data->num_luns--;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	if (starget->channel == mrioc->scsi_device_channel)
+		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	else if (mrioc->sas_transport_enabled && !starget->channel) {
+		rphy = dev_to_rphy(starget->dev.parent);
+		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+		    rphy->identify.sas_address, rphy);
+	}
+
 	if (tgt_dev && (!scsi_tgt_priv_data->num_luns))
 		tgt_dev->starget = NULL;
 	if (tgt_dev)
@@ -4111,16 +4119,23 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
-	struct mpi3mr_tgt_dev *tgt_dev;
+	struct mpi3mr_tgt_dev *tgt_dev = NULL;
 	unsigned long flags;
 	int retval = 0;
+	struct sas_rphy *rphy = NULL;
 
 	starget = scsi_target(sdev);
 	shost = dev_to_shost(&starget->dev);
 	mrioc = shost_priv(shost);
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	if (starget->channel == mrioc->scsi_device_channel)
+		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	else if (mrioc->sas_transport_enabled && !starget->channel) {
+		rphy = dev_to_rphy(starget->dev.parent);
+		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+		    rphy->identify.sas_address, rphy);
+	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	if (!tgt_dev)
 		return -ENXIO;
@@ -4168,11 +4183,12 @@ static int mpi3mr_slave_alloc(struct scsi_device *sdev)
 	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
-	struct mpi3mr_tgt_dev *tgt_dev;
+	struct mpi3mr_tgt_dev *tgt_dev = NULL;
 	struct mpi3mr_sdev_priv_data *scsi_dev_priv_data;
 	unsigned long flags;
 	struct scsi_target *starget;
 	int retval = 0;
+	struct sas_rphy *rphy = NULL;
 
 	starget = scsi_target(sdev);
 	shost = dev_to_shost(&starget->dev);
@@ -4180,7 +4196,14 @@ static int mpi3mr_slave_alloc(struct scsi_device *sdev)
 	scsi_tgt_priv_data = starget->hostdata;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+
+	if (starget->channel == mrioc->scsi_device_channel)
+		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+	else if (mrioc->sas_transport_enabled && !starget->channel) {
+		rphy = dev_to_rphy(starget->dev.parent);
+		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+		    rphy->identify.sas_address, rphy);
+	}
 
 	if (tgt_dev) {
 		if (tgt_dev->starget == NULL)
@@ -4223,6 +4246,8 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	struct mpi3mr_tgt_dev *tgt_dev;
 	unsigned long flags;
 	int retval = 0;
+	struct sas_rphy *rphy = NULL;
+	bool update_stgt_priv_data = false;
 
 	scsi_tgt_priv_data = kzalloc(sizeof(*scsi_tgt_priv_data), GFP_KERNEL);
 	if (!scsi_tgt_priv_data)
@@ -4231,8 +4256,25 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	starget->hostdata = scsi_tgt_priv_data;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
-	if (tgt_dev && !tgt_dev->is_hidden) {
+
+	if (starget->channel == mrioc->scsi_device_channel) {
+		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
+		if (tgt_dev && !tgt_dev->is_hidden)
+			update_stgt_priv_data = true;
+		else
+			retval = -ENXIO;
+	} else if (mrioc->sas_transport_enabled && !starget->channel) {
+		rphy = dev_to_rphy(starget->dev.parent);
+		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
+		    rphy->identify.sas_address, rphy);
+		if (tgt_dev && !tgt_dev->is_hidden && !tgt_dev->non_stl &&
+		    (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_SAS_SATA))
+			update_stgt_priv_data = true;
+		else
+			retval = -ENXIO;
+	}
+
+	if (update_stgt_priv_data) {
 		scsi_tgt_priv_data->starget = starget;
 		scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 		scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
@@ -4246,8 +4288,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 		if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
 			scsi_tgt_priv_data->throttle_group =
 			    tgt_dev->dev_spec.vd_inf.tg;
-	} else
-		retval = -ENXIO;
+	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	return retval;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index ff85cf3..48cee03 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -198,6 +198,35 @@ static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
 	}
 }
 
+/**
+ * __mpi3mr_get_tgtdev_by_addr_and_rphy - target device search
+ * @mrioc: Adapter instance reference
+ * @sas_address: SAS address of the device
+ * @rphy: SAS transport layer rphy object
+ *
+ * This searches for target device from sas address and rphy
+ * pointer then return mpi3mr_tgt_dev object.
+ *
+ * Return: Valid tget_dev or NULL
+ */
+struct mpi3mr_tgt_dev *__mpi3mr_get_tgtdev_by_addr_and_rphy(
+	struct mpi3mr_ioc *mrioc, u64 sas_address, struct sas_rphy *rphy)
+{
+	struct mpi3mr_tgt_dev *tgtdev;
+
+	assert_spin_locked(&mrioc->tgtdev_lock);
+
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
+		if ((tgtdev->dev_type == MPI3_DEVICE_DEVFORM_SAS_SATA) &&
+		    (tgtdev->dev_spec.sas_sata_inf.sas_address == sas_address)
+		    && (tgtdev->dev_spec.sas_sata_inf.rphy == rphy))
+			goto found_device;
+	return NULL;
+found_device:
+	mpi3mr_tgtdev_get(tgtdev);
+	return tgtdev;
+}
+
 /**
  * mpi3mr_expander_find_by_sas_address - sas expander search
  * @mrioc: Adapter instance reference
-- 
2.27.0


--0000000000001067d105e569f0a0
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICXXG3lb1rviuQZj3Zei
wOuKvlYTc8Vyp2SjFriPARhoMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDA0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBNLFBOIZfQw4DzP7OLe0iBcL/o7CQRONA4+bxB
4YKOwEwyweRlGR2neufzomDddIdOaKxVur/DjTSYxtrL+4Y8aQ8/UQMCcRl2Cd+F1Takx99GazV4
9QS9URAnCUYuEtnlm9fRODSpmNSPBm/tAE55slCefEt/cUMGva3cNnXF5PmGT6DW3ZIse0Xluzil
Dw0z331wGA89SENX32unKwrVOtA+WraIUFWS8QbAYolxtxdJFNqri6n6YpYqxcCc9M2ChS8NBi7k
Nwa9zJ5rtS2salce7+BcnTJ7toeo10mUdz6RYazYjA5Hy4QCe+iF1fizg4UX9I5IELERxarVmRok
--0000000000001067d105e569f0a0--
