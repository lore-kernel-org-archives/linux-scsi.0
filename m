Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12780FA3741
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 09:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJ1JC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 05:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJ1JCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 05:02:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7831C5E2B
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 02:02:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p3so4318730pld.10
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 02:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAiJB9MKZCWn+RLBDfGT3Gbi18FcAmS7PVrHp03tcUw=;
        b=RcBaNav0qBw0+VAxIQiJPlmKDX0rk4QkVI9IsZDD/pVSgI8wIzoXXa+ery0/61tHSN
         9wHg8OH+WQ2XDPtA3IgyX+PG/CqXkMux2DapG7eRxcFJNK8iixA/VkT4OWOC4IAwxA78
         eSLsitGdLP7ygfOG66FMKMGvt2NofPCzifkW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAiJB9MKZCWn+RLBDfGT3Gbi18FcAmS7PVrHp03tcUw=;
        b=mGs23Xx2O91R8kbDj0RODvbDukzQUvW/n5FjZSxvEQWDRn4C6akkouy7mZGsqFNgYs
         1Jqbc12xBxTtt0xs7W6Q0P7b155xinu5IMg2J66//ggxpa1jIAwpedazJ13UidYmiIUQ
         dNZEb/BL/WD49ysYS0FT7B39Ad/bS5+cA3qgJbAAaY7CCVJmkXoNASgOe3ygCUj2mTyf
         gRHJykOS0RK+AG/5s0nSywdKGJ7H54esfZ5L+T8pVVSGCQiBXN0nJqhB2w1C2B2veW04
         slKWTHR00vVnr+ppaoTtVNc48TLuCOCjdmYbBhAJcgTtqbW6lBw7ySbZa4sskChnYBoE
         vhgA==
X-Gm-Message-State: ACrzQf36yiCopoxv4Hle0KmSrs6FkWw8l2UcTy/NRUaSyEuGwmvxBxNx
        NyjMq0kkDXCs7TepHW3wgBTtuz1TjzD74jRzEuhPCZgTEWY0BW8LXPR3d0Qjibxb4QDvyUyxiBy
        Qpipn/X2g/ejY47FIu2Ub6+Jx+rsQpOPDM3KLMS8pDnOcCHlNsrBJR2kQVqZokMQNoGDKgWegjr
        tf+a9OJjm4
X-Google-Smtp-Source: AMsMyM7TWiryZir443KG8SCMTLIeEiNfwrhy9/Ja1KJceM4koWkHHz1ApqHrMHn7o6tZ6MWjdtedCA==
X-Received: by 2002:a17:90b:1c02:b0:213:17f1:50a7 with SMTP id oc2-20020a17090b1c0200b0021317f150a7mr14766128pjb.138.1666947767661;
        Fri, 28 Oct 2022 02:02:47 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a207-20020a621ad8000000b0056bd737fdf3sm2414077pfa.123.2022.10.28.02.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:02:47 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Date:   Fri, 28 Oct 2022 14:46:55 +0530
Message-Id: <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000096267d05ec148590"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000096267d05ec148590
Content-Transfer-Encoding: 8bit

Remove the usage of dma_get_required_mask() API.
Directly set the DMA mask to 63/64 if the system
is a 64bit machine.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4e981ccaac41..69061545d9d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2992,8 +2992,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 	struct sysinfo s;
 	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
 		ioc->dma_mask = 32;
 		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-- 
2.27.0


--00000000000096267d05ec148590
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
vZXeqKYupAd0/kWANIYKfeXvBSrhLTL/JLyu02jrKwUQmNeV/csW4n51mmbQyz5VRjLIaM9r93rl
EKIoHplnybLWh6glNdzUbh+wpglCjssypREDVGZjlDD7NS2Q6FUCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU90fCF++yKdqz
eSa+l3ox+Xh3bUUwDQYJKoZIhvcNAQELBQADggEBAEdSkxxx3jOPvsTAmqeChWssN7WYUZOhNQu/
+6bxE3/kn9StH6miItK87eIRsO0FFVLDJBnhWz0EGzWEliC68mV8ecDApK5douyO1VfXN8awZZ33
i/RQS2sGbz1vIfPu54rtnwXGoUiXRaSOz0pLy/JRCFyHOj+8GKauKkyrUWiD0j1xPTJ1p8/KOyKd
hPIHLRxnZxqpa2GjCtl3IYjKK8WbWx0NXkszaVTVRIn8e++VyiiH/yFXVyOEQxkZRQZWzTjPE9o/
R31F09e8yABfehc+e00bSP23FKNuA8dwS29RHLpjmd+m5EtbFGD4EUANHzCSTA89S/iWNoaWteab
v6IxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwftyuc
ixn6z19iSQwwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIc/GXFjdHtYiM6sln7T
W2NstrFI7mrwjfAWs9LM7qpiMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTAyODA5MDI0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBNo4vWijJbg2YexftCgt1kGyn1nukd1v5AnTDF
wVovoFnRBndeMyDB7pksMl5PZNUjm6TInBaXGVCbHjBSoGBMmRg6xAKM8h2PNq8vsgMoCv376A22
ovBInUKBBS6RBt+TagQBFnHzrueGoNk23Q7dMFb3oTazj39Xs4a9oOmEn1QaGWIj+jKNn7lg8KBY
IJ+uT7/SMKnGLNEwXPqpOG9SQJE+bfpiIhRnLAURwOI5X+JUq8hvG4nA/Pi8ZR956lvzR+OCiULE
h3HAtb3EJK6JrB/VOpOq1z+9AbhZcCGHsSoQ7jZzBsD53let1XowPr0ce4ZLBFlcpFqIUBxa999x
--00000000000096267d05ec148590--
