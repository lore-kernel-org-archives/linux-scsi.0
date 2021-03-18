Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC102C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B22B64D96
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCRJM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhCRJMS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 05:12:18 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ACFC06174A
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:18 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e33so1028531pgm.13
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=8D1/QuNripT2HONeexac5qUMB6JWK8nqKhOXc8I5xOw=;
        b=BKkku96/yqG0U0QWpBhFgpLYXVY7fN1X31ZLwqiTsvCFkzrFGi266+f2QVbnMWzy7M
         48y39zZLzjg6k4h//yTbdpwVjXVjTpeNxlclLG8E6NJo9V+QXo7OEB7zJNFGskYJ/H7/
         6SikeR7RU+D/u1pKr5jqFHLnmoGoQZhv0oRY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=8D1/QuNripT2HONeexac5qUMB6JWK8nqKhOXc8I5xOw=;
        b=X9wEBfDzi6ojgtB1M/UqKr4I9dym4lJzQTGo4y85Uh75ZVTHxappoyzt1+2hlzI+7n
         n1Cd3ybSzBTIlO32bbBHNRZnPmH7GO50RK3X4/5bkdsLMTQB42Z47ogfudqYlySh4M01
         tmb36PdaUyGQroMRm8eliysUHus+v2xqZGwg5r6Donfgbkd4fbl88WY4pD3EcKvkfEo4
         oRHNQnOv19QJJBVKj2ggSTumQBDRxYWpV+Rj7KQ3dvPTC/j99tRjaeaRl0MhiMhorhBe
         VhQ80UB9MuQRhAUeEiQahAT2NOZTy8JqYcmXJRbfCRTZsNEyJrngKfPpQAqvSpR0I78y
         5O5A==
X-Gm-Message-State: AOAM530ISOiIaMcElpY5cPPRHIh4Lrswu5/eYEmtx45kb9d8h6qk+Bp+
        VB+CtlFcSG2LL2xWS/KFMWDL3xSZwx7bPGxEJ2Xina81LWK3xpsbmMajISNoK0bGWkaFKW1nCat
        HORoDLccVPmInk/kj3pSl243AMV4xJPLouS1ottEQ5d9rcV5CTt/ai5Bi/LooIUefsc2D40MPNH
        I31Dj3biHoQlxTexTSIOWT
X-Google-Smtp-Source: ABdhPJwr0LHkSvanWe/VvRK0Of1JAhmlXPR84Ie1QS8sXutbKyB1ODVK1kZI1ZytLt7GPpZRfugJbA==
X-Received: by 2002:a65:4347:: with SMTP id k7mr6229320pgq.88.1616058737072;
        Thu, 18 Mar 2021 02:12:17 -0700 (PDT)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 11sm1413350pgt.83.2021.03.18.02.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 02:12:16 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH V2 4/7] mpt3sas: Handle reply pool DMA allocations in same 4G region
Date:   Thu, 18 Mar 2021 14:41:48 +0530
Message-Id: <20210318091151.39349-5-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
References: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000019c7d05bdcbff6b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000019c7d05bdcbff6b
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
index 308d817..e8b2930 100644
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


--000000000000019c7d05bdcbff6b
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
KoZIhvcNAQkEMSIEID9ZGd39QqBgybv1gbVifhswOAhPnhNorntQjnkXqYweMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMxODA5MTIxN1owaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAT
50xqfYlT9vQgXEMgBxx6MUnscD0n78K+yGhxtzFBk6U+YXiITed5kra+P51AtXTDIBvkLPRDuq4i
LHJOHKou+6y7fDt1i+UNkyfrs+oUlmXf433UqOFgsa6IY/67aSXu9/DrjMfcmh7RfNEYzBVjhk4V
Snhvj1fi8GmAmvVStCoMXZeABZFArBntpf0Cq4zEPokfTJJczfNntb3ZVMTOOA4tmFmMkzbBDKuJ
WtWpmdDdHjMQWfQZixaJgjmBPZttDqcsXQgLlQM7OYIDAmyXh+E3xcByP9Hu8Q3bbpHJk5otuv3B
12tAGZ57VuSsgZzDMbnGyJyizRW2xa8vRDix
--000000000000019c7d05bdcbff6b--
