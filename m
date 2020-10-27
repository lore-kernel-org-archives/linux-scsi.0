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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B48C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D5E221F8
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JAdWOxCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751873AbgJ0NIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:47 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:35308 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbgJ0NIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:47 -0400
Received: by mail-pf1-f179.google.com with SMTP id b3so893949pfo.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eE+dKrSpU2VCs/pXGBIUWiRGunzz83I8pBk2lofcmQQ=;
        b=JAdWOxCiPFfzdOo+DUdoCd9fawG7cmPVp0X6pFI9dgVHO7QGhZw8qycrviSJftaUE7
         aF1ZV45bbVTDNv+d6jtRP75QPWI1e1sRQnRSEjdvUKK4wV9kgrgzllvzdQ52HcX4PBjc
         qdwAqUkgIbP1o5OMgc/f6tL2o+G61uiQxEGRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eE+dKrSpU2VCs/pXGBIUWiRGunzz83I8pBk2lofcmQQ=;
        b=ZNy72lHEqD0ONRzyQFnkLd714C9cQRzOQibOKqupUMQD55D9qtpYKkQcvllNBcSSJB
         GBA+aAGavbbldMA9ZX3luIJE/aQ1dlpGBV7V1dVwilgrxlZIc7UhdJo+rtjrkgPiFfJW
         3mzJDO2heGzJ3pnoiUbdLuYoiDWXl8q/ju6+VW/OKNUZtAhkGvneh5AFVggdIOSNqXOr
         wOQbVHohsZaW/gDLCO6la5GE2CmJm7bhfajWVv/7MSWeJ3jmwJ/yW+b67JZ8BKFQa0pB
         ++WrSux8HXGy1Ng3yUVroC79mdJe8GXndbi9MasxyzGUkEBhnkOFSLMfW641DHIjFkbV
         EeMQ==
X-Gm-Message-State: AOAM5335x1PlwXUBwG/XqEG/P9EKKnfyzGw5pqieX8lnkaz+Twj+UGKm
        e6I9DoyHEniPYupDBsDphwOHtw==
X-Google-Smtp-Source: ABdhPJxrovjcMLJURgIWJhjL+DeJGH/pj8eHVrZ8lH6bKOML84/YrpPuc4CgGAEuHZ2x6+8Re1x1Zw==
X-Received: by 2002:aa7:8f10:0:b029:161:79ae:eace with SMTP id x16-20020aa78f100000b029016179aeeacemr2113971pfr.45.1603804125609;
        Tue, 27 Oct 2020 06:08:45 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:44 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 09/14] mpt3sas: Set valid PhysicalPort in SMPPassThrough
Date:   Tue, 27 Oct 2020 18:38:42 +0530
Message-Id: <20201027130847.9962-10-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000391d2d05b2a6bf80"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000391d2d05b2a6bf80

Current driver is always setting PhysicalPort field as 0xFF for
SMPPassthrough Request message. So in zoning topologies this
SMPPassthrough command always operates on devices in one zone
(default zone) even when user issues SMP command for other zone
drives.

Now helper functions _transport_get_port_id_by_rphy() &
_transport_get_port_id_by_sas_phy() are defined to get Physical
Port number from sas_rphy & sas_phy respectively for
SMPPassthrough request message so that SMP Passthrough request
message is send to intended zone device.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  1 +
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 75 ++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 047d234..a8e42d1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -788,6 +788,7 @@ struct _sas_phy {
  * @phy: a list of phys that make up this sas_host/expander
  * @sas_port_list: list of ports attached to this sas_host/expander
  * @port: hba port entry containing node's port number info
+ * @rphy: sas_rphy object of this expander
  */
 struct _sas_node {
 	struct list_head list;
@@ -802,6 +803,7 @@ struct _sas_node {
 	struct hba_port *port;
 	struct	_sas_phy *phy;
 	struct list_head sas_port_list;
+	struct sas_rphy *rphy;
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3752314..2b87003 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6510,6 +6510,7 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		goto out_fail;
 	}
 	sas_expander->parent_dev = &mpt3sas_port->rphy->dev;
+	sas_expander->rphy = mpt3sas_port->rphy;
 
 	for (i = 0 ; i < sas_expander->num_phys ; i++) {
 		if ((mpt3sas_config_get_expander_pg1(ioc, &mpi_reply,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 3cc78c2..d52d8b3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -60,6 +60,24 @@
 
 #include "mpt3sas_base.h"
 
+/**
+ * _transport_get_port_id_by_sas_phy - get zone's port id that Phy belong to
+ * @phy - sas_phy object
+ *
+ * Return Port number
+ */
+static inline u8
+_transport_get_port_id_by_sas_phy(struct sas_phy *phy)
+{
+	u8 port_id = 0xFF;
+	struct hba_port *port = phy->hostdata;
+
+	if (port)
+		port_id = port->port_id;
+
+	return port_id;
+}
+
 /**
  * _transport_sas_node_find_by_sas_address - sas node search
  * @ioc: per adapter object
@@ -81,6 +99,49 @@ _transport_sas_node_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
 		    sas_address, port);
 }
 
+/**
+ * _transport_get_port_id_by_rphy - Get Port number from rphy object
+ * @ioc: per adapter object
+ * @rphy: sas_rphy object
+ *
+ * Returns Port number.
+ */
+static u8
+_transport_get_port_id_by_rphy(struct MPT3SAS_ADAPTER *ioc,
+	struct sas_rphy *rphy)
+{
+	struct _sas_node *sas_expander;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	u8 port_id = 0xFF;
+
+	if (!rphy)
+		return port_id;
+
+	if (rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE ||
+	    rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE) {
+		spin_lock_irqsave(&ioc->sas_node_lock, flags);
+		list_for_each_entry(sas_expander,
+		    &ioc->sas_expander_list, list) {
+			if (sas_expander->rphy == rphy) {
+				port_id = sas_expander->port->port_id;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+	} else if (rphy->identify.device_type == SAS_END_DEVICE) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = __mpt3sas_get_sdev_by_rphy(ioc, rphy);
+		if (sas_device) {
+			port_id = sas_device->port->port_id;
+			sas_device_put(sas_device);
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
+	return port_id;
+}
+
 /**
  * _transport_convert_phy_link_rate -
  * @link_rate: link rate returned from mpt firmware
@@ -289,7 +350,7 @@ struct rep_manu_reply {
  */
 static int
 _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
-	u64 sas_address, struct sas_expander_device *edev)
+	u64 sas_address, struct sas_expander_device *edev, u8 port_id)
 {
 	Mpi2SmpPassthroughRequest_t *mpi_request;
 	Mpi2SmpPassthroughReply_t *mpi_reply;
@@ -356,7 +417,7 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
-	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->PhysicalPort = port_id;
 	mpi_request->SASAddress = cpu_to_le64(sas_address);
 	mpi_request->RequestDataLength = cpu_to_le16(data_out_sz);
 	psge = &mpi_request->SGL;
@@ -772,7 +833,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	    MPI2_SAS_DEVICE_INFO_FANOUT_EXPANDER)
 		_transport_expander_report_manufacture(ioc,
 		    mpt3sas_port->remote_identify.sas_address,
-		    rphy_to_expander_device(rphy));
+		    rphy_to_expander_device(rphy), hba_port->port_id);
 	return mpt3sas_port;
 
  out_fail:
@@ -923,6 +984,7 @@ mpt3sas_transport_add_host_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	    phy_pg0.ProgrammedLinkRate & MPI2_SAS_PRATE_MIN_RATE_MASK);
 	phy->maximum_linkrate = _transport_convert_phy_link_rate(
 	    phy_pg0.ProgrammedLinkRate >> 4);
+	phy->hostdata = mpt3sas_phy->port;
 
 	if ((sas_phy_add(phy))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -993,6 +1055,7 @@ mpt3sas_transport_add_expander_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_phy
 	    expander_pg1.ProgrammedLinkRate & MPI2_SAS_PRATE_MIN_RATE_MASK);
 	phy->maximum_linkrate = _transport_convert_phy_link_rate(
 	    expander_pg1.ProgrammedLinkRate >> 4);
+	phy->hostdata = mpt3sas_phy->port;
 
 	if ((sas_phy_add(phy))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
@@ -1197,7 +1260,7 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
-	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->PhysicalPort = _transport_get_port_id_by_sas_phy(phy);
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 	mpi_request->SASAddress = cpu_to_le64(phy->identify.sas_address);
@@ -1493,7 +1556,7 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
-	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->PhysicalPort = _transport_get_port_id_by_sas_phy(phy);
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 	mpi_request->SASAddress = cpu_to_le64(phy->identify.sas_address);
@@ -1983,7 +2046,7 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 	memset(mpi_request, 0, sizeof(Mpi2SmpPassthroughRequest_t));
 	mpi_request->Function = MPI2_FUNCTION_SMP_PASSTHROUGH;
-	mpi_request->PhysicalPort = 0xFF;
+	mpi_request->PhysicalPort = _transport_get_port_id_by_rphy(ioc, rphy);
 	mpi_request->SASAddress = (rphy) ?
 	    cpu_to_le64(rphy->identify.sas_address) :
 	    cpu_to_le64(ioc->sas_hba.sas_address);
-- 
2.18.4


--000000000000391d2d05b2a6bf80
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
NXnfcUforGVkMnISm8biQGgXqOjwjyjYRLSNfkH2ifcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODQ2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACr1nlnH6BPLaMKQdkhR
nY7X/XW4ywbq6ts/TLalTLZAg/UFTffCj9ICerUbiBI04H2NN6ewUZt5NmqJ4b9Jfke7HUUbWXJI
pL1rGq27y54CJSPGhXYXatNp3vezjJSdPRwuLBvO92FR+UvbbKW5ABvklKVY0cegPlmUvvhnkbUO
uIOeLDrRhoesLk3/i29rfeCnkxMsNh7OkclSohwO/OuRZctTBCHSWvwzM2G7YneYXyNxhQoWkMIO
Qkwd752If5ARaomHCz84X44lR0J5zKUOR54f1LZCyQ7RCAoygxngN0kLrF0sCNpHZVlAridDgySD
LErZy2RpbNUqB7C/fqY=
--000000000000391d2d05b2a6bf80--
