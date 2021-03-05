Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D58C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEF46501F
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 10:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhCEK3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 05:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCEK3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 05:29:47 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45299C061574
        for <linux-scsi@vger.kernel.org>; Fri,  5 Mar 2021 02:29:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z7so1191270plk.7
        for <linux-scsi@vger.kernel.org>; Fri, 05 Mar 2021 02:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=f9hkrKiVPHnDo7MF4pdPVf4YKDVYPJUGwn+NxRFrtOU=;
        b=NvXQR4frqkdjelrZY3xsyS6HOGsTw6fg4K8iGUZbZyW3wXSYhdadRfpneQITvJld1C
         FJRXvSQwWTHWv1JvcM7ySfzv8w6LdFemSHgyBqtvb/OW68s+5vZVI8Xtr7QxrteooE67
         7DwQAv/EiphAkdaBa8+py8dyBiB/EGqXhJLes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=f9hkrKiVPHnDo7MF4pdPVf4YKDVYPJUGwn+NxRFrtOU=;
        b=JEiPt6gQvnQ4kZ53vVnKUadrtJ3qGTMFxfcpHP70uOA0gfcTonsqv8JNnBKjgiHH99
         zoRLh0lCTI3nLBRpJIEvRAne1GFPeqmzGFmuSti8KHkMHHyWE3cjLx8NqgSOnyjjB1HH
         LZOUxQ1jq1fjjdlaeNb/npjuckDoATMQ1/mpRAOTHuNWAnvoFP/WqLG+5L9zx4qEOVIp
         yLmx55sC/86v3I7FAoJeqoguogFsKWUnkS5Awzp6aAEM8rpt7EkpM9gMC5sew6FpNaem
         bu1sXJ2YP/pY8ViSM/3mswqMiIdGZpeBzZ5ZRtCUKDFw/WvrP1lXvKs6pGQkDsjX+yqU
         Txxg==
X-Gm-Message-State: AOAM533v87TiTkWb5dcPXFZjdo/x83htSN6GbFZ57prwdeIH3PfOmBwH
        h3DMghVgKsizOVzdyXzgNloUwCUKpOL4R247OmfbcL5ksk30yD0HtplV69X6YMsRXlWxOIMiRpl
        t7mXTqlNS2G6fuE0MELgWyj8cxU8uvsLAdpzRhbkMPgzgq2/XzD2Nmq5JJFsRFfXfN3CqhgdtHt
        pzgMS41gPvKC2Ae+HFj9Vy
X-Google-Smtp-Source: ABdhPJxoiJcPhoEkdVejyG2drw0GfBckOOgltkMDpoMKwaf5vpxnQS7BRaGJhv2wHwbvNPzr4IQkqg==
X-Received: by 2002:a17:90b:a0d:: with SMTP id gg13mr9280201pjb.29.1614940186002;
        Fri, 05 Mar 2021 02:29:46 -0800 (PST)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v15sm2015983pgl.44.2021.03.05.02.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:29:45 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 4/7] mpt3sas: Handle reply pool DMA allocations in same 4G  region
Date:   Fri,  5 Mar 2021 15:59:01 +0530
Message-Id: <20210305102904.7560-5-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
References: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000029bd2d05bcc79024"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000029bd2d05bcc79024
Content-Transfer-Encoding: 8bit

According to MPI Specification Reply buffers should not cross
4GB boundary. So while allocating Reply buffers, if any buffer
crosses the 4GB boundary then,
* Release the already allocated memory pools and
* Reallocate them by changing the DMA coherent mask to 32 bit

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 63 ++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6ef4925..e94abce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5559,6 +5559,41 @@ _base_allocate_sense_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	return 0;
 }
 
+/**
+ * _base_allocate_reply_pool - Allocating DMA'able memory
+ *			for reply pool.
+ * @ioc: Adapter object
+ * @sz: DMA Pool size
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+_base_allocate_reply_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
+{
+	/* reply pool, 4 byte align */
+	ioc->reply_dma_pool = dma_pool_create("reply pool",
+	    &ioc->pdev->dev, sz, 4, 0);
+	if (!ioc->reply_dma_pool)
+		return -ENOMEM;
+	ioc->reply = dma_pool_alloc(ioc->reply_dma_pool, GFP_KERNEL,
+	    &ioc->reply_dma);
+	if (!ioc->reply)
+		return -EAGAIN;
+	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz)) {
+		dinitprintk(ioc, pr_err(
+		    "Bad Reply Pool! Reply (0x%p) Reply dma = (0x%llx)\n",
+		    ioc->reply, (unsigned long long) ioc->reply_dma));
+		ioc->use_32bit_dma = true;
+		return -EAGAIN;
+	}
+	ioc->reply_dma_min_address = (u32)(ioc->reply_dma);
+	ioc->reply_dma_max_address = (u32)(ioc->reply_dma) + sz;
+	ioc_info(ioc,
+	    "reply pool(0x%p) - dma(0x%llx): depth(%d), frame_size(%d), pool_size(%d kB)\n",
+	    ioc->reply, (unsigned long long)ioc->reply_dma,
+	    ioc->reply_free_queue_depth, ioc->reply_sz, sz/1024);
+	return 0;
+}
+
 /**
  * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
  *                     for reply queues.
@@ -6008,32 +6043,14 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	    "element_size(%d), pool_size(%d kB)\n",
 	    ioc->sense, (unsigned long long)ioc->sense_dma, ioc->scsiio_depth,
 	    SCSI_SENSE_BUFFERSIZE, sz / 1024);
-
 	/* reply pool, 4 byte align */
 	sz = ioc->reply_free_queue_depth * ioc->reply_sz;
-	ioc->reply_dma_pool = dma_pool_create("reply pool", &ioc->pdev->dev, sz,
-					      4, 0);
-	if (!ioc->reply_dma_pool) {
-		ioc_err(ioc, "reply pool: dma_pool_create failed\n");
-		goto out;
-	}
-	ioc->reply = dma_pool_alloc(ioc->reply_dma_pool, GFP_KERNEL,
-	    &ioc->reply_dma);
-	if (!ioc->reply) {
-		ioc_err(ioc, "reply pool: dma_pool_alloc failed\n");
-		goto out;
-	}
-	ioc->reply_dma_min_address = (u32)(ioc->reply_dma);
-	ioc->reply_dma_max_address = (u32)(ioc->reply_dma) + sz;
-	dinitprintk(ioc,
-		    ioc_info(ioc, "reply pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB)\n",
-			     ioc->reply, ioc->reply_free_queue_depth,
-			     ioc->reply_sz, sz / 1024));
-	dinitprintk(ioc,
-		    ioc_info(ioc, "reply_dma(0x%llx)\n",
-			     (unsigned long long)ioc->reply_dma));
+	rc = _base_allocate_reply_pool(ioc, sz);
+	if (rc == -ENOMEM)
+		return -ENOMEM;
+	else if (rc == -EAGAIN)
+		goto try_32bit_dma;
 	total_sz += sz;
-
 	/* reply free queue, 16 byte align */
 	sz = ioc->reply_free_queue_depth * 4;
 	ioc->reply_free_dma_pool = dma_pool_create("reply_free pool",
-- 
2.27.0


--00000000000029bd2d05bcc79024
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
KoZIhvcNAQkEMSIEIMICe0jl+QCWxzb9Ok/HDtHYY2cKG3SooIwl2/fNanTwMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMwNTEwMjk0NlowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCB
RNaAhoZyQPeHLYAuTxJNK/1PnKBKVdEHJ2/OOrndtM0ybxsCwbFEDtEHoDwlx/dMGofC18j/94mV
vLJDJ1ftfU/MGPJwkaONylvFjK/N9n+rigGjmMSSUYgIqSNpTABp0Q8B8KIP6Z5e0kvW3qzYrNfh
GuAW0CNbpx9lsQBLAupTXIqmiwk/EpVqNmvjE3BP1lvy5xUXmGQ7cG+QlCg9xezVoAx0mcIizHcb
cuZMTn3/lreVVHnLpeypoFLoxuO++mfTbCpD8532/N/dHGtt6+0Pa4MDevqJBFWeMmgAwzdVmtFT
WDkElU+jQv6G3CMmQco3FYPzYxa0QInoJ9Qq
--00000000000029bd2d05bcc79024--
