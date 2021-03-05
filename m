Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SUBJ_ACC_NUM,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A457EC43381
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8213065019
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhCEK34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 05:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCEK3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 05:29:52 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA53C061574
        for <linux-scsi@vger.kernel.org>; Fri,  5 Mar 2021 02:29:52 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o38so1066105pgm.9
        for <linux-scsi@vger.kernel.org>; Fri, 05 Mar 2021 02:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=EECy5bSckiPYGsnBg4Zcm/6sLlGAk9HQRcTK7FGBack=;
        b=E8uKG732gPkmd+puKqhONNT+d3nuzHEXA53pKuCin4SkGhmcRUUFbOWUDhrno1MTQX
         zG4qeHGH8morXFivIczPiTi9+K/nJfKifIMDzskoRD78drFPwnTW6i4241DaEm59ywJu
         UQyoSwzGgRTzESQzGatGXayZ8DolVSiNHyxqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=EECy5bSckiPYGsnBg4Zcm/6sLlGAk9HQRcTK7FGBack=;
        b=ZpIjkGhPWAO6NJX8bjJtpe5ETzaWy1OQswc9mSL1Bj88J39h2UJl0TRYAar8ZpE8JF
         r7UMgJCUm2NISEc8PkurJGqOYpwIIr2HCVVZIqJarb91WlIikbRoPNqgY/d+LYTcOksm
         DMAYn5wMl8WEywPY/ckCNXTEjXelV7GfBOlUK3l+UKOA6GTeNprX1OA5Qib3BQj/QM1q
         PxAF32gSOsMMH5RaY7tweNQpdP1qh/aMwkvI/I/jD2qyH9uFgAmHN+BFT7X/pTXl4GJp
         6vw8pOLVqMkIhdPoTgUiQX5HJRifjri3ZSsoaHriCXhXRDORlpdw//pCE115Ol8u+n9W
         sZiA==
X-Gm-Message-State: AOAM530ZSh5kl+M0UhBfIwtyNXbP2X5CdACheqazDwDPnpyQ0ecP/4GG
        RJn8K08K2Jav8WMLpwqNiitrEQmIT4su+3UN+ERAfjxK0vA/UL42KDedAZinT/0ldqLmNd0lKzo
        MLBCGhTyqdf/S6ot8DJn74BStVjlrD6RAUwDyrB2eXTveHA7qz4KY7EPJxB89XAlXMq7rrT1jCb
        clQiUFIOXan37aQT2B+PRG
X-Google-Smtp-Source: ABdhPJzNpBrmMsm9TXpo8toDyt6E2p2OIKG1MOArmDLY9V37kb9l6kU7nqiyqVTHDaRveIwo6VPHpw==
X-Received: by 2002:aa7:900e:0:b029:1ee:14ea:f719 with SMTP id m14-20020aa7900e0000b02901ee14eaf719mr8327517pfo.46.1614940191161;
        Fri, 05 Mar 2021 02:29:51 -0800 (PST)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v15sm2015983pgl.44.2021.03.05.02.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:29:50 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 6/7] mpt3sas: Handle reply post array DMA allocations in same  4G region
Date:   Fri,  5 Mar 2021 15:59:03 +0530
Message-Id: <20210305102904.7560-7-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
References: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007cfb1405bcc790c4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007cfb1405bcc790c4
Content-Transfer-Encoding: 8bit

According to MPI Specification Reply post Array buffer should not cross
4GB boundary. So while allocating Reply Post Array buffer, if it
crosses the 4GB boundary then,
* Release the already allocated memory pools and
* Reallocate them by changing the DMA coherent mask to 32 bit.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 55 ++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bd180db..a74aab9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5630,6 +5630,39 @@ _base_allocate_reply_free_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	return 0;
 }
 
+/**
+ * _base_allocate_reply_post_free_array - Allocating DMA'able memory
+ *			for reply post free array.
+ * @ioc: Adapter object
+ * @reply_post_free_array_sz: DMA Pool size
+ * Return: 0 for success, non-zero for failure.
+ */
+
+static int
+_base_allocate_reply_post_free_array(struct MPT3SAS_ADAPTER *ioc,
+	u32 reply_post_free_array_sz)
+{
+	ioc->reply_post_free_array_dma_pool =
+	    dma_pool_create("reply_post_free_array pool",
+	    &ioc->pdev->dev, reply_post_free_array_sz, 16, 0);
+	if (!ioc->reply_post_free_array_dma_pool)
+		return -ENOMEM;
+	ioc->reply_post_free_array =
+	    dma_pool_alloc(ioc->reply_post_free_array_dma_pool,
+	    GFP_KERNEL, &ioc->reply_post_free_array_dma);
+	if (!ioc->reply_post_free_array)
+		return -EAGAIN;
+	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_post_free_array,
+	    reply_post_free_array_sz)) {
+		dinitprintk(ioc, pr_err(
+		    "Bad Reply Free Pool! Reply Free (0x%p) Reply Free dma = (0x%llx)\n",
+		    ioc->reply_free,
+		    (unsigned long long) ioc->reply_free_dma));
+		ioc->use_32bit_dma = true;
+		return -EAGAIN;
+	}
+	return 0;
+}
 /**
  * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
  *                     for reply queues.
@@ -6102,22 +6135,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->rdpq_array_enable) {
 		reply_post_free_array_sz = ioc->reply_queue_count *
 		    sizeof(Mpi2IOCInitRDPQArrayEntry);
-		ioc->reply_post_free_array_dma_pool =
-		    dma_pool_create("reply_post_free_array pool",
-		    &ioc->pdev->dev, reply_post_free_array_sz, 16, 0);
-		if (!ioc->reply_post_free_array_dma_pool) {
-			dinitprintk(ioc,
-				    ioc_info(ioc, "reply_post_free_array pool: dma_pool_create failed\n"));
-			goto out;
-		}
-		ioc->reply_post_free_array =
-		    dma_pool_alloc(ioc->reply_post_free_array_dma_pool,
-		    GFP_KERNEL, &ioc->reply_post_free_array_dma);
-		if (!ioc->reply_post_free_array) {
-			dinitprintk(ioc,
-				    ioc_info(ioc, "reply_post_free_array pool: dma_pool_alloc failed\n"));
-			goto out;
-		}
+		rc = _base_allocate_reply_post_free_array(ioc,
+		    reply_post_free_array_sz);
+		if (rc == -ENOMEM)
+			return -ENOMEM;
+		else if (rc == -EAGAIN)
+			goto try_32bit_dma;
 	}
 	ioc->config_page_sz = 512;
 	ioc->config_page = dma_alloc_coherent(&ioc->pdev->dev,
-- 
2.27.0


--0000000000007cfb1405bcc790c4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBXAwggRYoAMCAQICDCAc2j96+IoHW5040jANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjQzNTVaFw0yMjA5MTUxMTMwMjdaMIGm
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xITAfBgNVBAMTGFN1Z2FuYXRoIFByYWJ1IFN1YnJhbWFuaTE0
MDIGCSqGSIb3DQEJARYlc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJp3W6i+yVqwmKTbucNHNrAD35AKBa4GklrnUcWS
As4Yz62jxfJOu+dcysfahgpi3JcAhTe/eRMLc5on8ReYZAYCMNJ+jpNKRuf1Abgh6nfhcNf+cuGb
S83CJlqxdJjbnimwwbueitA/edWTFjcULNUDZZEmAPJkbHXmlTlJD8TMdR0ezem/d4niexc4RCyt
YMUhnlcyFg+2OR0MKuT2Q714Ka0IamXFyyXhX5wD9B+ITo5hu+ZtXV2RuOXy0U2bIEQzFPVJ7QA9
hUD4z7+jEN/0xIbuF8EJZMsb6XAT+CFOjnizM5yvGFfmupDlyQ4JuVb86R8v2AEDpXmbdnS1tDkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUH
MAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3Nn
Y2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
SQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29u
YWxzaWduMmNhMjAyMC5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUuc3VicmFtYW5pQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk
1b5I3qGPzzAdBgNVHQ4EFgQURmgYmHXuw9VrKqnEjPBuviQS0CEwDQYJKoZIhvcNAQELBQADggEB
AAp1Yt9kkxViI/9B/AQxLFmuC9wWruix0ajjegaJ/HZ6C1ky/V9QvI1MwweIhBiuk2jttOzO4h87
rADIQnEI3bf5ccaw61CJNqc6Cb4LiEIjPF7py8f6+rHL928xCUnKqeCO2sC0A+k39bCiyHaGo432
eXxWNXxGrLg6/2TuwgOtvbil0hWwK/Wf5ql2YiZXy8wRo9IhHoY/4cJLS/Fay8yKX8IdhEc3pNbu
dDLaJg39U0ikF3NHtNMaXXHgh6TMs3OsWhH4+zlvkC0eSC6dvasGxmpPQPQe/0huBB8gDbzGrRg/
cRn2ctMmNHxZO4EBJ5SzsV/lHimTk+5K39lzkzYxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQ
ZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwgHNo/eviKB1udONIwDQYJYIZIAWUDBAIBBQCggdQwLwYJ
KoZIhvcNAQkEMSIEILv2uTpS7CDEXmUYD4uZ8DrAIEZXnF7kE1l4IrRgoiaLMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMwNTEwMjk1MlowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAI
oHRhLhZoibiY5UWvRVn4IxjOIO4AuQmMzW6EMP7uTrctR3+s6PexEh/XoS3EmQqW6G+U/HfInM9b
adFglzBKs4GDGdo3Fwg+hFZO/4BCKOQ04OseZ7QhOdOfN1Y1wrleXE6+oxFia0/0In54/53SNnTm
Zdjk4wi1oO2BMLkJMwEE7LUvLJswSYZAb8U/s8npjiKn+XgOB7fsaHYODMh6pX7NmiSDf2ZSTjJA
qRo4txzo06xHJDWRdvVpjQJvx09nViRpm49L/bYwsK3yfZ9Uj5y0Yy+IN++VU19df6RXGeuCIfsG
1Yy95UXLx5KSfv3liiXGTNxxZ6cELQBeHX/Y
--0000000000007cfb1405bcc790c4--
