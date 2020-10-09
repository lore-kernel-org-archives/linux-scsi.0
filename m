Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916ACC43467
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576DC22265
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ebVZ+mhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390216AbgJIRO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgJIROT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D12C0613D2
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so7679318pgf.9
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8k7WMP8iw16DLxMJ/FqH28mukdoKop1lTy8CdlgJ7WY=;
        b=ebVZ+mhfUpQndzU6QIti24HcjCniy6t1YEg5t3Iauj9YMJH11w4OuLb8NNTVQlmBlL
         2A+xLlY6KnPkdUnPomDk/JmGfTDRcbfnzf9EXe3eaixRNcBGXaMY1SV3/cah5Nlravml
         jbBCriZbljaR4SecXl2PDWMSjbY8Gbet4yOns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8k7WMP8iw16DLxMJ/FqH28mukdoKop1lTy8CdlgJ7WY=;
        b=oNy+w+vpQ38Jp2s0VJMeL7Cr1+Efh32T1engm3VEHJ1wzgBgpToVdkwA1QSEJOvxsv
         akhTxzTFCRPQPd0fO5Y6Jopq6K4BaLzluEYCaJlabI5OzaVQCFQunQu/8lt7DFO/uu6h
         SoHyL1N1IxhqmmfRK4+tVrkXUUzKNZ7tdTfS/lRgEcQ9jSrJOTzkxAx4bnqvz7eDed1C
         qMp2IYjeGJwAjJQprK/EjrV1RiOgnwTaG6MUgTFgxoFXNXPx4p547PEZRdegGky+q0fG
         +0X8zogfBCdt1kVcTZVo2M+HFrJebhfsxfWagtnPJIn8e1O/hC/AbOrENxfE6YzvN+Gp
         TpuQ==
X-Gm-Message-State: AOAM5306UZasHhdsm3rmcdcBAIDmJTq2tq1VLEdwBTQhILoqcy78xhil
        qSlin6h5p3Otixgfn3K/BX8ffQ==
X-Google-Smtp-Source: ABdhPJxff2kBjo8rWpNdPvRNU1yjKXF6pL8YpSn1LRwsVidRLBql4yhPVsAh1v/jJ+oUhgEOetfXWw==
X-Received: by 2002:a05:6a00:2d5:b029:13c:1611:653b with SMTP id b21-20020a056a0002d5b029013c1611653bmr13316711pft.13.1602263658980;
        Fri, 09 Oct 2020 10:14:18 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:17 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 02/14] mpt3sas: Allocate memory for hba_port objects
Date:   Fri,  9 Oct 2020 22:44:28 +0530
Message-Id: <20201009171440.4949-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000419b5d05b14014e4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000419b5d05b14014e4

Allocate hba_port object whenever a new HBA's wide/narrow
port is identified while processing the SASIOUnitPage0's
phy data and add this object to port_table_list.
And deallocate these objects during driver unload.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
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


--000000000000419b5d05b14014e4
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
KnVdLgFaMCbkZe8cAu6cqfa7j4suL8EWlWaAAxyjkj0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDE5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAB8TJAuk9yibkFLLTDke
3SuxdownnZq6m0RFXMJakwMO3ILVijmNDp7LVhlM8SZaXDPj9Au51/PNPJLBQ3mX61CSU6HginEb
e/q1nOLZ5CG0MEFCXUM4UWpxITNe7i6s1VRQDllvHYcyEn89jD1QbyaElk1fVF3/R5hgCOBcL3Oe
DowiHst9+45zNo3Y6fHlqFgXAcnXGsuiftXG4u5Hrn5ZE660qhwq2SxXi0rPA9cov4EQR4z8vco7
5rQxBLo6zqhORzy4hnVOU92Krnbv5oLC34m9z+uJh6iykR4mIJgwgH2Vi/nL9mu9nDoxVYtqTOBJ
6mlouectcYTYcDJccnc=
--000000000000419b5d05b14014e4--
