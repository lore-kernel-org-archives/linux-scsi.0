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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1612AC433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4A022265
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JGmCKiFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgJIRO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732780AbgJIROY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:24 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF80C0613D5
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:24 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so7396483pfc.7
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aJrECrdquUVN0z3wjrmL2Z+dTCCN71M+Vn21NYH9YxA=;
        b=JGmCKiFXz9sRYRBQZOp+EfNqAUidRMmei+QgBW2XoMgafHS1UHAxWKWUh2U3GXwn1S
         0A8FP+j/Cbp8vBsTxy+9m9f741wDUnfk+BpqXc6hAaJZGTkf+BX6jttOdC8sqI2qNEpn
         xdzK1n3g6blx7suatPRX6CqV2iVGvgqhz9wXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aJrECrdquUVN0z3wjrmL2Z+dTCCN71M+Vn21NYH9YxA=;
        b=WWgTCMpd/4m2RjNs73q5eoBKDZ4/RGrS0yeKUmM3EjU/aDoZLfbHP0bJRx80vQebr4
         fz6vLR6oPjfhYXPl6jlCKSdp9w+NMdOiFHWE5HOqW49ghI8SZnvFR2ACj1HxqNg0/wGI
         csm1vamNBwBjpikzHbP6i80FMQMuZi53FBPJ+Ty1ukIT+8sf2oaKWhasLIR9QC7rV+vF
         PRuyVyOYHXO+fhuKKodzglSh1N8mbmZ/9HmC9N8qGg/YCIDxAHtVlLNBiq5zHh5nQkAm
         lmBR20g9GyQrg61wDxYNlkJhE0fSWx07PrlEeEewWAcBnDo/mbxBEUyQf481Ub/g3l0C
         MYWw==
X-Gm-Message-State: AOAM532AknX/hXINGw2/fsAkwzhJDER4cxXWy9wJ/zl2IdpIe8MTzvR9
        adrL3pkUJTcRoI/Jo9SzcvySlQ==
X-Google-Smtp-Source: ABdhPJzo7GiFf6LnBuKcxl2Fce1Mgt1z4rbuPb22HKmYNB/qWE3ps1k1QI7r85HwfOkWTmPFsBSD/A==
X-Received: by 2002:a63:490e:: with SMTP id w14mr4179479pga.275.1602263662054;
        Fri, 09 Oct 2020 10:14:22 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:21 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 03/14] mpt3sas: Rearrange _scsih_mark_responding_sas_device()
Date:   Fri,  9 Oct 2020 22:44:29 +0530
Message-Id: <20201009171440.4949-4-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008533bf05b1401449"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008533bf05b1401449

Rearrange _scsih_mark_responding_sas_device function for better
code management. No functional change.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 116 +++++++++++++--------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a40fa7e..e8ffe1e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8742,69 +8742,69 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
 	}
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
 	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
-		if ((sas_device->sas_address == le64_to_cpu(
-		    sas_device_pg0->SASAddress)) && (sas_device->slot ==
-		    le16_to_cpu(sas_device_pg0->Slot))) {
-			sas_device->responding = 1;
-			starget = sas_device->starget;
-			if (starget && starget->hostdata) {
-				sas_target_priv_data = starget->hostdata;
-				sas_target_priv_data->tm_busy = 0;
-				sas_target_priv_data->deleted = 0;
-			} else
-				sas_target_priv_data = NULL;
-			if (starget) {
-				starget_printk(KERN_INFO, starget,
-				    "handle(0x%04x), sas_addr(0x%016llx)\n",
-				    le16_to_cpu(sas_device_pg0->DevHandle),
-				    (unsigned long long)
-				    sas_device->sas_address);
+		if (sas_device->sas_address != le64_to_cpu(
+		    sas_device_pg0->SASAddress))
+			continue;
+		if (sas_device->slot != le16_to_cpu(sas_device_pg0->Slot))
+			continue;
+		sas_device->responding = 1;
+		starget = sas_device->starget;
+		if (starget && starget->hostdata) {
+			sas_target_priv_data = starget->hostdata;
+			sas_target_priv_data->tm_busy = 0;
+			sas_target_priv_data->deleted = 0;
+		} else
+			sas_target_priv_data = NULL;
+		if (starget) {
+			starget_printk(KERN_INFO, starget,
+			    "handle(0x%04x), sas_addr(0x%016llx)\n",
+			    le16_to_cpu(sas_device_pg0->DevHandle),
+			    (unsigned long long)
+			    sas_device->sas_address);
 
-				if (sas_device->enclosure_handle != 0)
-					starget_printk(KERN_INFO, starget,
-					 "enclosure logical id(0x%016llx),"
-					 " slot(%d)\n",
-					 (unsigned long long)
-					 sas_device->enclosure_logical_id,
-					 sas_device->slot);
-			}
-			if (le16_to_cpu(sas_device_pg0->Flags) &
-			      MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
-				sas_device->enclosure_level =
-				   sas_device_pg0->EnclosureLevel;
-				memcpy(&sas_device->connector_name[0],
-					&sas_device_pg0->ConnectorName[0], 4);
-			} else {
-				sas_device->enclosure_level = 0;
-				sas_device->connector_name[0] = '\0';
-			}
+			if (sas_device->enclosure_handle != 0)
+				starget_printk(KERN_INFO, starget,
+				 "enclosure logical id(0x%016llx), slot(%d)\n",
+				 (unsigned long long)
+				 sas_device->enclosure_logical_id,
+				 sas_device->slot);
+		}
+		if (le16_to_cpu(sas_device_pg0->Flags) &
+		      MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
+			sas_device->enclosure_level =
+			   sas_device_pg0->EnclosureLevel;
+			memcpy(&sas_device->connector_name[0],
+				&sas_device_pg0->ConnectorName[0], 4);
+		} else {
+			sas_device->enclosure_level = 0;
+			sas_device->connector_name[0] = '\0';
+		}
 
-			sas_device->enclosure_handle =
-				le16_to_cpu(sas_device_pg0->EnclosureHandle);
-			sas_device->is_chassis_slot_valid = 0;
-			if (enclosure_dev) {
-				sas_device->enclosure_logical_id = le64_to_cpu(
-					enclosure_dev->pg0.EnclosureLogicalID);
-				if (le16_to_cpu(enclosure_dev->pg0.Flags) &
-				    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
-					sas_device->is_chassis_slot_valid = 1;
-					sas_device->chassis_slot =
-						enclosure_dev->pg0.ChassisSlot;
-				}
+		sas_device->enclosure_handle =
+			le16_to_cpu(sas_device_pg0->EnclosureHandle);
+		sas_device->is_chassis_slot_valid = 0;
+		if (enclosure_dev) {
+			sas_device->enclosure_logical_id = le64_to_cpu(
+				enclosure_dev->pg0.EnclosureLogicalID);
+			if (le16_to_cpu(enclosure_dev->pg0.Flags) &
+			    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
+				sas_device->is_chassis_slot_valid = 1;
+				sas_device->chassis_slot =
+					enclosure_dev->pg0.ChassisSlot;
 			}
+		}
 
-			if (sas_device->handle == le16_to_cpu(
-			    sas_device_pg0->DevHandle))
-				goto out;
-			pr_info("\thandle changed from(0x%04x)!!!\n",
-			    sas_device->handle);
-			sas_device->handle = le16_to_cpu(
-			    sas_device_pg0->DevHandle);
-			if (sas_target_priv_data)
-				sas_target_priv_data->handle =
-				    le16_to_cpu(sas_device_pg0->DevHandle);
+		if (sas_device->handle == le16_to_cpu(
+		    sas_device_pg0->DevHandle))
 			goto out;
-		}
+		pr_info("\thandle changed from(0x%04x)!!!\n",
+		    sas_device->handle);
+		sas_device->handle = le16_to_cpu(
+		    sas_device_pg0->DevHandle);
+		if (sas_target_priv_data)
+			sas_target_priv_data->handle =
+			    le16_to_cpu(sas_device_pg0->DevHandle);
+		goto out;
 	}
  out:
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
-- 
2.18.4


--0000000000008533bf05b1401449
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
4syeZpJGwrprQvfuajKCOvZvhgBfNSEhXu8Rx8xNOpAwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDIzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFpYy1PgI7nMe84JpgfE
VlbI7b0EcX6U6sGqX5gsfmiMi2MG5YHLleEsMyxzuWTAFW8ClL48AjAGr/0aB1dLX48bamUqHKWR
oGwEfLI6dlemR8HHdbuoGthh6p73McdjzTbutODXf2TTxTB7QZcXdyTbOWmYH6iFs1ZZisQ+/bfv
X7l76OFYGjkowRNyqdEkPdYBfyrSZmz3W9zDcBPbgwS82EtzCDCE56sDZCSFEV0g/suBwGdn9qTe
oHSa/ChdG+oxpeGnlviQfYBQwZ95efyPPV8//JyUIx+0f1zyBjJ7dKGUK9HQ0m587jcdYDRnFpwV
X3OmzvVtG83WHCfU8CU=
--0000000000008533bf05b1401449--
