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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE46C55178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEDF20878
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GV3qcI5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751854AbgJ0NI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35616 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbgJ0NI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id f38so771460pgm.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tvUmMYlnP+gYRbgT5nceIyw0tTb29ZfCxVnLpiGPYXg=;
        b=GV3qcI5bSVHuMjsYlXWHbnj/HHkiSGbH7B5QtuI9xBSTWBVsZA1vl4PnnEftqThzOt
         MpjBLFGEr18P+Bh7ulNWhpU/Z5UWyFOamXC35Vw5YakvUI/nAtYKlFvELj5E2yWSJpaY
         ZAfhzC8JG9ccv5qsqSjHZjnCdRTq19GCqulT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tvUmMYlnP+gYRbgT5nceIyw0tTb29ZfCxVnLpiGPYXg=;
        b=OUogIPF7utRwJ629DhLHbJS4qB8LTdUEK/KQUNMBr/5TrE50jBU2BCY8MPvOr1Hwe6
         HBd+//PDNEpiC2KGjHc9x5GX/tDuAqypjO4u0Gd3xBRcYhm+yOhxsSzNs28khnHbajD0
         DMvwTPSMKXiNfrIxi0aCOYm9JjvCKf8BZN3ITeHfhEGz8vTbgGRQNKawwxmiNDl6GVEo
         c8rMQbb0Muo10Gj+A9cssmypKt1PdBMoVGxOLfW4+8mT3EKtDv0GwKTjUhC5dmciXWUG
         fj3+nnE/n9phH036py4WOs6bRZshB+DA0OkngO0SaD4D/Zee6BvcGgLUY8zWkFSTGrUV
         GXFA==
X-Gm-Message-State: AOAM531kH9GqD5HNdD1G5qxHDmcpluHGd5VjgH1MaHu12vrKxJYoFme9
        v/S42J96PNPbzdjUUH/6Be1y6mkiw86OSA==
X-Google-Smtp-Source: ABdhPJzPEOexgr8VpPYqoCRtbehOc5KaB6kE1ujyiouQnJd/g14NupiN23EQPvjxEBXKOvNo0QhowQ==
X-Received: by 2002:a62:8847:0:b029:15b:51c6:6a10 with SMTP id l68-20020a6288470000b029015b51c66a10mr2304552pfd.69.1603804105436;
        Tue, 27 Oct 2020 06:08:25 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:24 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 02/14] mpt3sas: Allocate memory for hba_port objects
Date:   Tue, 27 Oct 2020 18:38:35 +0530
Message-Id: <20201027130847.9962-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000006380a05b2a6be7a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000006380a05b2a6be7a

Allocate hba_port object whenever a new HBA's wide/narrow
port is identified while processing the SASIOUnitPage0's
phy data and add this object to port_table_list.
And deallocate these objects during driver unload.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 73 ++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index db9c816..a40fa7e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -356,6 +356,30 @@ _scsih_srch_boot_encl_slot(u64 enclosure_logical_id, u16 slot_number,
 	    SlotNumber)) ? 1 : 0;
 }
 
+/**
+ * mpt3sas_get_port_by_id - get hba port entry corresponding to provided
+ *			  port number from port list
+ * @ioc: per adapter object
+ * @port_id: port number
+ *
+ * Search for hba port entry corresponding to provided port number,
+ * if available return port object otherwise return NULL.
+ */
+struct hba_port *
+mpt3sas_get_port_by_id(struct MPT3SAS_ADAPTER *ioc, u8 port_id)
+{
+	struct hba_port *port, *port_next;
+
+	list_for_each_entry_safe(port, port_next,
+	    &ioc->port_table_list, list) {
+		if (port->port_id == port_id &&
+		    !(port->flags & HBA_PORT_FLAG_DIRTY_PORT))
+			return port;
+	}
+
+	return NULL;
+}
+
 /**
  * _scsih_is_boot_device - search for matching boot device.
  * @sas_address: sas address
@@ -5732,7 +5756,8 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
 	u16 attached_handle;
-	u8 link_rate;
+	u8 link_rate, port_id;
+	struct hba_port *port;
 
 	dtmprintk(ioc,
 		  ioc_info(ioc, "updating handles for sas_host(0x%016llx)\n",
@@ -5756,13 +5781,28 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
 		link_rate = sas_iounit_pg0->PhyData[i].NegotiatedLinkRate >> 4;
 		if (i == 0)
-			ioc->sas_hba.handle = le16_to_cpu(sas_iounit_pg0->
-			    PhyData[0].ControllerDevHandle);
+			ioc->sas_hba.handle = le16_to_cpu(
+			    sas_iounit_pg0->PhyData[0].ControllerDevHandle);
+		port_id = sas_iounit_pg0->PhyData[i].Port;
+		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
+			if (!port)
+				goto out;
+
+			port->port_id = port_id;
+			ioc_info(ioc,
+			    "hba_port entry: %p, port: %d is added to hba_port list\n",
+			    port, port->port_id);
+			if (ioc->shost_recovery)
+				port->flags = HBA_PORT_FLAG_NEW_PORT;
+			list_add_tail(&port->list, &ioc->port_table_list);
+		}
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
 		if (attached_handle && link_rate < MPI2_SAS_NEG_LINK_RATE_1_5)
 			link_rate = MPI2_SAS_NEG_LINK_RATE_1_5;
+		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
 		mpt3sas_transport_update_links(ioc, ioc->sas_hba.sas_address,
 		    attached_handle, i, link_rate);
 	}
@@ -5789,7 +5829,8 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 	u16 ioc_status;
 	u16 sz;
 	u8 device_missing_delay;
-	u8 num_phys;
+	u8 num_phys, port_id;
+	struct hba_port *port;
 
 	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
 	if (!num_phys) {
@@ -5882,8 +5923,24 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 		if (i == 0)
 			ioc->sas_hba.handle = le16_to_cpu(sas_iounit_pg0->
 			    PhyData[0].ControllerDevHandle);
+
+		port_id = sas_iounit_pg0->PhyData[i].Port;
+		if (!(mpt3sas_get_port_by_id(ioc, port_id))) {
+			port = kzalloc(sizeof(struct hba_port), GFP_KERNEL);
+			if (!port)
+				goto out;
+
+			port->port_id = port_id;
+			ioc_info(ioc,
+			   "hba_port entry: %p, port: %d is added to hba_port list\n",
+			   port, port->port_id);
+			list_add_tail(&port->list,
+			    &ioc->port_table_list);
+		}
+
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		ioc->sas_hba.phy[i].phy_id = i;
+		ioc->sas_hba.phy[i].port = mpt3sas_get_port_by_id(ioc, port_id);
 		mpt3sas_transport_add_host_phy(ioc, &ioc->sas_hba.phy[i],
 		    phy_pg0, ioc->sas_hba.parent_dev);
 	}
@@ -10136,6 +10193,7 @@ static void scsih_remove(struct pci_dev *pdev)
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	Mpi2ConfigReply_t mpi_reply;
+	struct hba_port *port, *port_next;
 
 	if (_scsih_get_shost_and_ioc(pdev, &shost, &ioc))
 		return;
@@ -10198,6 +10256,12 @@ static void scsih_remove(struct pci_dev *pdev)
 			    mpt3sas_port->remote_identify.sas_address);
 	}
 
+	list_for_each_entry_safe(port, port_next,
+	    &ioc->port_table_list, list) {
+		list_del(&port->list);
+		kfree(port);
+	}
+
 	/* free phys attached to the sas_host */
 	if (ioc->sas_hba.num_phys) {
 		kfree(ioc->sas_hba.phy);
@@ -10987,6 +11051,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_event_ack_list);
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
+	INIT_LIST_HEAD(&ioc->port_table_list);
 
 	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 
-- 
2.18.4


--00000000000006380a05b2a6be7a
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
Tamuql3TGzCMFPKOXrf+WvMZrzRO7XXCsSAv/vrprTEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODI1WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFOsx8f2MOu5d0YWWGqz
AMbJYlzcsK+515Bkght28zyEZaIv7FiPvocsFkMB9gYqLseyLt9ArbBIj92kbLGHj7Tt+tiTuCmu
BrjhxF6tC4tjG2K7sY4YNtQhbmo0SbvlQd7/pnEDsjjXFGTHMUlwkTFiZ0LzI+f+ZqqU5pV9/PvT
M8F1Y8RpjIlrxwWJHbHjLRKdNi4GgU8AjjPr93nRLen+JKwuYa5BHAijcnkUOkpneDBx1jcl8/ID
3G+VZT9Rtijwlx0gHCDCSe0rwssrlMRsSarO+HrshGs3MaH72t8AbwAH6Ip23lCv/RgFYMXJrb//
/OPIm9yj6NyjvfjcZPw=
--00000000000006380a05b2a6be7a--
