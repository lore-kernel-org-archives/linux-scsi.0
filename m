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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38966C433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB80522267
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bJGYk0rW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733075AbgJIROj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgJIROb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CD7C0613D5
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:31 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so4776615pfa.9
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SF1gi20AYFwbj6S4mgnFZSZs57yPB1dR67FeE9iWWGU=;
        b=bJGYk0rWhex4V0Dt013ZjWPJfr9EJqipUXUqA6qwgB2ShTRqtCoBIsC3HuVkdGSaF9
         cUOQ12Zf78QdnhMHVBknbXdh7EkIH7P//SBUWpmjy+lXqV4DZETIIp3dcFUk8vkTZ2Z+
         bRpFLCYyVTf/R8IsOxHRml9Pt5ZBrwdfFKs3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SF1gi20AYFwbj6S4mgnFZSZs57yPB1dR67FeE9iWWGU=;
        b=H/znNntd46FSd8QsXEgpw6kHuP8XW/zljWZRzaoJ8Bjc7ZjG2Yu5fxEY5MI7jBwZqG
         KN/P/wjYsG6ddMuoQ1FvHjqsFbc7yuv1Z56bBR83Qj/fUHmsLac4dOW7eQUCHZZuVqNh
         LQuFck8ij94DCWHVrMG/UL2GL6VvqjyjYop2MAiHY3Y+FJ3MMC5XX2LEci7SHNbHJ+YY
         UjHYNsZFHES+XM1s9S+3iV+hJ2C/JZDhgHhEww3d4fqQ5SR1B93Yrlr19t6eGpfZ6rmW
         /i8AdTl2meoIHil08x6kCwqWiFjjll7aEYuM39/mItec91W9expRUNTCSmN/O1WLoJBp
         k6Hw==
X-Gm-Message-State: AOAM533M3RIKqVvkiaR+eoRkHGWrFAK2PVLM+mUZD5R78r5wRUp0RWC0
        pMB7kwtF6DVMijgJTL7Yjl4Uhg==
X-Google-Smtp-Source: ABdhPJzUBZIMK+ZQL3EEOFrjEXX++w9obpQyOgKA45GjRb/XuO2DwZ/7F6u6qhUgroAM+b2KRaUwaQ==
X-Received: by 2002:a62:c1c5:0:b029:155:2a10:504f with SMTP id i188-20020a62c1c50000b02901552a10504fmr11386452pfg.13.1602263671068;
        Fri, 09 Oct 2020 10:14:31 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:30 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 06/14] mpt3sas: Rename transport_del_phy_from_an_existing_port
Date:   Fri,  9 Oct 2020 22:44:32 +0530
Message-Id: <20201009171440.4949-7-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fa68fe05b140142e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000fa68fe05b140142e

* Renamed _transport_add_phy_to_an_existing_port to
  mpt3sas_transport_add_phy_to_an_existing_port &
  _transport_del_phy_from_an_existing_port to
  mpt3sas_transport_del_phy_from_an_existing_port,
  as driver has to call these functions from outside
  mpt3sas_transport.c file now.

* Added extra function argument 'port' of type
  struct hba_port in above renamed functions.

* Also in above functions, check for portID before
  adding/removing the phy from the _sas_port object.
  i.e. add/remove the phy from _sas_port object only
  if _sas_port's port object and phy's port object
  are the same.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  7 +++++
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 35 ++++++++++++++++--------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index b5d1fc5..24db627 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1811,6 +1811,13 @@ void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	struct hba_port *port);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
+void
+mpt3sas_transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_node, struct _sas_phy *mpt3sas_phy);
+void
+mpt3sas_transport_add_phy_to_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_node, struct _sas_phy *mpt3sas_phy,
+	u64 sas_address, struct hba_port *port);
 /* trigger data externs */
 void mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 54c004e..560ce32 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -503,16 +503,17 @@ _transport_add_phy(struct MPT3SAS_ADAPTER *ioc, struct _sas_port *mpt3sas_port,
 }
 
 /**
- * _transport_add_phy_to_an_existing_port - adding new phy to existing port
+ * mpt3sas_transport_add_phy_to_an_existing_port - adding new phy to existing port
  * @ioc: per adapter object
  * @sas_node: sas node object (either expander or sas host)
  * @mpt3sas_phy: mpt3sas per phy object
  * @sas_address: sas address of device/expander were phy needs to be added to
+ * @port: hba port entry
  */
-static void
-_transport_add_phy_to_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
+void
+mpt3sas_transport_add_phy_to_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_node *sas_node, struct _sas_phy *mpt3sas_phy,
-	u64 sas_address)
+	u64 sas_address, struct hba_port *port)
 {
 	struct _sas_port *mpt3sas_port;
 	struct _sas_phy *phy_srch;
@@ -520,11 +521,16 @@ _transport_add_phy_to_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 	if (mpt3sas_phy->phy_belongs_to_port == 1)
 		return;
 
+	if (!port)
+		return;
+
 	list_for_each_entry(mpt3sas_port, &sas_node->sas_port_list,
 	    port_list) {
 		if (mpt3sas_port->remote_identify.sas_address !=
 		    sas_address)
 			continue;
+		if (mpt3sas_port->hba_port != port)
+			continue;
 		list_for_each_entry(phy_srch, &mpt3sas_port->phy_list,
 		    port_siblings) {
 			if (phy_srch == mpt3sas_phy)
@@ -537,13 +543,13 @@ _transport_add_phy_to_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * _transport_del_phy_from_an_existing_port - delete phy from existing port
+ * mpt3sas_transport_del_phy_from_an_existing_port - delete phy from existing port
  * @ioc: per adapter object
  * @sas_node: sas node object (either expander or sas host)
  * @mpt3sas_phy: mpt3sas per phy object
  */
-static void
-_transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
+void
+mpt3sas_transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_node *sas_node, struct _sas_phy *mpt3sas_phy)
 {
 	struct _sas_port *mpt3sas_port, *next;
@@ -559,7 +565,11 @@ _transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 			if (phy_srch != mpt3sas_phy)
 				continue;
 
-			if (mpt3sas_port->num_phys == 1)
+			/*
+			 * Don't delete port during host reset,
+			 * just delete phy.
+			 */
+			if (mpt3sas_port->num_phys == 1 && !ioc->shost_recovery)
 				_transport_delete_port(ioc, mpt3sas_port);
 			else
 				_transport_delete_phy(ioc, mpt3sas_port,
@@ -590,8 +600,8 @@ _transport_sanity_check(struct MPT3SAS_ADAPTER *ioc, struct _sas_node *sas_node,
 		if (sas_node->phy[i].port != port)
 			continue;
 		if (sas_node->phy[i].phy_belongs_to_port == 1)
-			_transport_del_phy_from_an_existing_port(ioc, sas_node,
-			    &sas_node->phy[i]);
+			mpt3sas_transport_del_phy_from_an_existing_port(ioc,
+			    sas_node, &sas_node->phy[i]);
 	}
 }
 
@@ -1040,8 +1050,6 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	if (handle && (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)) {
 		_transport_set_identify(ioc, handle,
 		    &mpt3sas_phy->remote_identify);
-		_transport_add_phy_to_an_existing_port(ioc, sas_node,
-		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address);
 		if (sas_node->handle <= ioc->sas_hba.num_phys) {
 			list_for_each_entry(hba_port,
 			    &ioc->port_table_list, list) {
@@ -1051,6 +1059,9 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 					    (1 << mpt3sas_phy->phy_id);
 			}
 		}
+		mpt3sas_transport_add_phy_to_an_existing_port(ioc, sas_node,
+		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address,
+		    port);
 	} else
 		memset(&mpt3sas_phy->remote_identify, 0 , sizeof(struct
 		    sas_identify));
-- 
2.18.4


--000000000000fa68fe05b140142e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQSwYJKoZIhvcNAQcCoIIQPDCCEDgCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2gMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFTTCCBDWgAwIBAgIMGYbVrXj/AWDyoGFSMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTE1
MTU2WhcNMjIwOTE1MTE1MTU2WjCBlDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRgwFgYDVQQDEw9TcmVl
a2FudGggUmVkZHkxKzApBgkqhkiG9w0BCQEWHHNyZWVrYW50aC5yZWRkeUBicm9hZGNvbS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC5niRDfOcA/lFVV4Ef3caitEmDttFcfX8E
gCdwYxGiEDiO37ld/yjXb+HO8Y3Jk+dlVMltv+IdjiUPF+vr+J2NnRBy4sWkgifn+o4/VpUmBLhL
NW+bBYuIuG4+iUoA9XXuqZZNN55aelW0TperHdzcZSfhByomrRfnBUlH2Spvd/EU4DjW25SXwSF/
+uC6y31UYvj52z/Vzvqpapm6CKt0e+JFxTSdRS6Fsf+f/5/++IM51GSIrrePsCgrgq6S1S9kdKIn
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
iTYnuNQ4iupio9JRBK96OfEsWtf0GUibZYn4auwKu2wwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDMxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJ0YNHBnYQVw629RAalc
ojZNo8iJ1mveW/CeKsJYqsIHioSZJ94mka3k9Lh8sVNCRpqF1Cb5sRaMSV921OSpPDY5cP44b+4h
759WaAApV4nutrwcXBeOuztt8J84v0pp0edQhUnIr1wrkEAtywxZJGUaaBFzbVbaL0WX/4F3xn7w
DoGQ/MVAs5W8w2JI2D4LzekUUONuaMblAaM+eFBTTlf/RW9g72e5j2Xd+oCA45fj+uE8uWSXyYnu
bU6+CN3Kf+gL0Cxsb2y57LlsPa78cCR2HgS5RDkdzheHBQFojrbCo1FQXKVfknAGQTWHEebuQIbL
FYy5N1jDIK+FKb91v5A=
--000000000000fa68fe05b140142e--
