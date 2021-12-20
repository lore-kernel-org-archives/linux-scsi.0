Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD636C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhLTOEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhLTOEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:48 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1371C061574
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:47 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so12960883pja.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=+Vf+KANpCllkkrCYBRkSA7RkQSZifac+u/ZU5nKKXec=;
        b=Lp0hqg3xgHzfuOPBfv8fIGjKa3+bxptv2i4LQG58j8D5zghkA3QpA8hbVZlkBA7282
         aCxL4b+RP0lvSQCoBjRfPHqSlBTdeZnfFPFhzv5VA9a3XboSg+/1ahkB/soZdfJZrmfT
         xUZjfwHT7C7jJqF2JWwrZd7Oqh9ICfW8ld+cQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=+Vf+KANpCllkkrCYBRkSA7RkQSZifac+u/ZU5nKKXec=;
        b=6Q8XQJ3faBobOEN//uXSgP0C1wEm8rw7sBMXj/fcnxKcy8Im1ya4cXpM8ot1c5GqaZ
         aWzo3cP4Ff78dZXAXXJgsS2yUiOdUvpqR+6IYQGhfXR6qrkYq+ANFmXTgt/oxmIusEET
         DApUeaLzzBl5FG2kZMNbAJYfSRvvjdwaNqCgb7W+K2zTIXSf/aRBCASfa7RXYCebJf6V
         +dfUmajztkRqIcVUPc1KtYtIrJorN1O/8qayNd47s7e5/kvpM2644XdT72EhVdbJ81SH
         DrasOCRtSZjDWNSjhGFqmKuU1cDKA1ZiKmy+m4/dRdglgoi9P00aL7dmT+3N/LHXbyGP
         qxYw==
X-Gm-Message-State: AOAM5314uZtKNfzoBWlfaqMfs7PmLD8X4rscVT2bijwgIYpmWtEuJdLf
        Rm9LzyB5fe9rUsmfjtjG/Q20fMCwWm8B0JJ4/yKyl+ydIP35ci2ziqWyefWmoXD1cwYl8TYYVaX
        3SEKojaccBo39wwAW/JdvxqV0kiybmtdrCOaWF0TtrQ3QaA6yYmolNo2EGkvsNuV5JHDm/V69Fr
        7iLeRhqmg+
X-Google-Smtp-Source: ABdhPJzzDSz715DN6LLs74a8LRKSbkyc4noMj1SGL28W5pjUGbJ4aLUV0Z5Ad6nmVatrntb/9FhDGw==
X-Received: by 2002:a17:902:7007:b0:143:c6e8:4117 with SMTP id y7-20020a170902700700b00143c6e84117mr16982991plk.55.1640009086819;
        Mon, 20 Dec 2021 06:04:46 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:46 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 20/25] mpi3mr: Print cable mngnt and temp threshold events
Date:   Mon, 20 Dec 2021 19:41:54 +0530
Message-Id: <20211220141159.16117-21-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000012f93505d3945f77"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000012f93505d3945f77
Content-Transfer-Encoding: 8bit

Print cable management & temperature threshold events data.

Also used vendor id & device id macro definitions from
MPI3 headers.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  1 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 75 +++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d5f7f58..1cbc732 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3503,6 +3503,7 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PREPARE_FOR_RESET);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_TEMP_THRESHOLD);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 192986f..d893c6d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2051,6 +2051,66 @@ static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.shutdown_timeout = shutdown_timeout;
 }
 
+/**
+ * mpi3mr_tempthreshold_evt_th - Temp threshold event tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: event data
+ *
+ * Displays temperature threshold event details and fault code
+ * if any is hit due to temperature exceeding threshold.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_tempthreshold_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	struct mpi3_event_data_temp_threshold *evtdata =
+	    (struct mpi3_event_data_temp_threshold *)event_reply->event_data;
+
+	ioc_err(mrioc, "Temperature threshold levels %s%s%s exceeded for sensor: %d !!! Current temperature in Celsius: %d\n",
+	    (le16_to_cpu(evtdata->status) & 0x1) ? "Warning " : " ",
+	    (le16_to_cpu(evtdata->status) & 0x2) ? "Critical " : " ",
+	    (le16_to_cpu(evtdata->status) & 0x4) ? "Fatal " : " ", evtdata->sensor_num,
+	    le16_to_cpu(evtdata->current_temperature));
+	mpi3mr_print_fault_info(mrioc);
+}
+
+/**
+ * mpi3mr_cablemgmt_evt_th - Cable management event tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: event data
+ *
+ * Displays Cable manegemt event details.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_cablemgmt_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	struct mpi3_event_data_cable_management *evtdata =
+	    (struct mpi3_event_data_cable_management *)event_reply->event_data;
+
+	switch (evtdata->status) {
+	case MPI3_EVENT_CABLE_MGMT_STATUS_INSUFFICIENT_POWER:
+	{
+		ioc_info(mrioc, "An active cable with receptacle_id %d cannot be powered.\n"
+		    "Devices connected to this cable are not detected.\n"
+		    "This cable requires %d mW of power.\n",
+		    evtdata->receptacle_id,
+		    le32_to_cpu(evtdata->active_cable_power_requirement));
+		break;
+	}
+	case MPI3_EVENT_CABLE_MGMT_STATUS_DEGRADED:
+	{
+		ioc_info(mrioc, "A cable with receptacle_id %d is not running at optimal speed\n",
+		    evtdata->receptacle_id);
+		break;
+	}
+	default:
+		break;
+	}
+}
+
 /**
  * mpi3mr_os_handle_events - Firmware event handler
  * @mrioc: Adapter instance reference
@@ -2125,9 +2185,18 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		mpi3mr_energypackchg_evt_th(mrioc, event_reply);
 		break;
 	}
+	case MPI3_EVENT_TEMP_THRESHOLD:
+	{
+		mpi3mr_tempthreshold_evt_th(mrioc, event_reply);
+		break;
+	}
+	case MPI3_EVENT_CABLE_MGMT:
+	{
+		mpi3mr_cablemgmt_evt_th(mrioc, event_reply);
+		break;
+	}
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_SAS_DISCOVERY:
-	case MPI3_EVENT_CABLE_MGMT:
 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
 	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
 	case MPI3_EVENT_PCIE_ENUMERATION:
@@ -4247,8 +4316,8 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
 	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_LSI_LOGIC, 0x00A5,
-		    PCI_ANY_ID, PCI_ANY_ID)
+		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
+		    MPI3_MFGPAGE_DEVID_SAS4116, PCI_ANY_ID, PCI_ANY_ID)
 	},
 	{ 0 }
 };
-- 
2.27.0


--00000000000012f93505d3945f77
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPLbvkh5Sh6uqCa1RCLs
iGt4wQDy6qOUPBlTWbrg2H8oMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ0N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBaFAvHhrH5GoXeqiHcOGA0D4DPCifEUK8pUPjg
xhsSEX2nv+kk4k786Nt9cQF8uBotzhnRI1KfSScmM8RmM+wSTu2+XmJO5+Ll18hVOwgPBqOejCnj
P27mpixZ1w1ndY+kNF9inMYMXpj2b5USRnsETyPArWI7YYHnWpUVt4kYPOByOkqfPESyOC2UqWtI
P7jWbnmVjk5nZq3KqoB9ihXW0KYF/uTm/xhHsu8iYNkZQ/oHhLfNeV6lXrA/SIqCLmfbWsqD4XeN
JFnInx+It9L3A2IfQAXj8YWt4USf4sDy4AILZETn2hzDWDK8Gn0tdxLKUdZzHvgOgBo9gP/Fi+iP
--00000000000012f93505d3945f77--
