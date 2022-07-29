Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B24C19F29
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 13:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiG2NG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 09:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbiG2NFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 09:05:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC969796AA
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so7062734pjz.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=0D+Hz9gON7eYRtQdD3gCpGSYdxQni4Q1qXY/yz6PIbI=;
        b=GSInKzQkBu13OfTtWSE9OvOl9N3jjJSTbe1gfr7dO/zaKp2yoiAMoh5ilBawQS1fJ6
         hP7q04d8+8tS6GFqDunPwDQWIlzGRKbwoO+YfQ55Mg1D70bnUbQ1gl5rhQvC8hfV4Lmf
         XmwDLWw/HEcteyBV6X4rMd8c3+a66xBUHgQWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=0D+Hz9gON7eYRtQdD3gCpGSYdxQni4Q1qXY/yz6PIbI=;
        b=y3ceUnQkIbNIQW/589zYQweln1XP4S8yCSxlrt9lKYnpuSO/ESGRjNq5PA7qbelwLd
         93Dcx90rskb4TC5eXS5fBH/9y/tAPiMGk1HXnQUWCt68h124uUdJVfEAtkDsqzRpZpuf
         wetjparuOUR7j6Vni/8TYJx9feSaRlreRAUGB3HJDSYP6i8Lew70NgqNzGvtFGHNJtqC
         OsIq7QLSrGGrmuL207V57q8/ySxo/Vh0ZXLvf3XvbVS7yF3eRbzMcKXc3uQ3znxJjp+L
         b2z2E5niLOKQqR7EHxx+1Dx/HUOxrElaQqSHGatIN4uA+ZyCCasGTd5Ab5B/ZWzXKMHz
         ppJQ==
X-Gm-Message-State: ACgBeo3vu4EPkHx/+nbEjN7LrK1oxaNOSQNMJ0mqTDq6777fbnrCUeaR
        7QjhrSxdH98QchAZAVlWPN4fDn1RbPro/nw4g34zO09DvJWJp3ynDO8OjbpCASO1kgN3cOpn3rm
        yUZBE35CkXthZP5N7waR1tCcs4PJYwcaZo6CtV1tX2pBlCPLBo6qALor8TTFjDHZE3UZrdZWoUD
        fQzLjgrri3
X-Google-Smtp-Source: AA6agR5N/8dTmR+OAwnUGRlplH2iBuQ8cGGK8MFmZgrwoG6a7oiCNN/pcoUk6sHHWWG5GU9qNkEHlA==
X-Received: by 2002:a17:902:6b07:b0:16b:f220:92fb with SMTP id o7-20020a1709026b0700b0016bf22092fbmr3887803plk.96.1659099877885;
        Fri, 29 Jul 2022 06:04:37 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b0016dd6929af5sm1225816pls.206.2022.07.29.06.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 06:04:37 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 10/15] mpi3mr: Get target object based on rphy
Date:   Fri, 29 Jul 2022 18:46:22 +0530
Message-Id: <20220729131627.15019-11-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e5de6305e4f14af9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e5de6305e4f14af9
Content-Transfer-Encoding: 8bit

When device is registered with the STL then
get the corresponding device's target object
using the rphy in below callback functions,

- mpi3mr_target_alloc,
- mpi3mr_slave_alloc,
- mpi3mr_slave_configure,
- mpi3mr_slave_destroy

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
index 0659d3f..9155434 100644
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
index 1d6ae9d..f7faf6e 100644
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


--000000000000e5de6305e4f14af9
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFCWUjC+jf+AlLN2vvCP
T5UMiTiBGoQBcZUL3RkOMa7VMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyOTEzMDQzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAbs50Z8Hr0KpOnx2YY7CbpiRqqMTWbhsrSBd8R
D6KTE0A+DTjI4fQdf9x9gJsyje0kmE4mZdOXNkHkgSr71SpG+3PaiiOHNso6HKdiJYFpvBCxxnhh
bqrm5kSSGskyb5OuvPNa0nujSW3SLjDeJgUUJ0dydpBhKrN9UkDUf4vCOFtQu+Q+Pv+lOobTSu/i
PjPf/acvJiQI2/b1qoaMuzoxJDA9dw0t4UsIGNqY3f0avJWeZyc0wU8vmUTnBoXNYNh8lnBVbLtB
5e+ou06i1Shkh2F4ezebb1yfsJMT+uUavJE6blsgJxf01ExUYhOl2e8ku3uJXgLZ+8+NdNYtL5Tn
--000000000000e5de6305e4f14af9--
