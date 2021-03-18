Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D9FC43381
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E272B64D96
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhCRJM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCRJMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 05:12:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDAC06174A
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t18so2579798pjs.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=YEq6Abye5Wvvhc3if60disi4fg+eHXudElB4rRX/fcg=;
        b=XGE+yjMUS4BOc3LMeyzqaswlDatME7qfM5fApca93wDcwOUGU9ayxp8MFFe37/Fuq/
         5J080vpVAKzekyJuKowQE/ReDqSFGX6In8yUSCFvPjTn6yWILW7bsMQEtqsV6ALVJwQ3
         eItFHMeFaovipiZ6BrqSQKM94NVU9MQMhXy30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=YEq6Abye5Wvvhc3if60disi4fg+eHXudElB4rRX/fcg=;
        b=T0soDx7MXttOv1bCM92Mf3zoumHO21q26nl+uZ99EQ3jcQsCSsHVlWm9957Exs7txh
         /BpV4ip6+jc3pJbZ+Z0/EGm7A75cq9cW7jCtbhAKQd8ccK5xWfFUHKUEm+KmjGIh86hd
         BuqVf+V12M19i6poS9W+WAeo9OuoryQMamusLjhdp+YXSLQibQpY6AUJziWrsG7H7/QI
         KvvbHtGQs6dBlBgFXKjsxKzbzuGYh2ABgNC12zcACQVE2J/rFiEfHaZNKliKe0dNRC5X
         1qImZRUK+qZyKJnomirrwPrdpZ2m8o6eBzWcI5CZWMjdaySPpRBwTz8MLLh2UODXkPvK
         9/xg==
X-Gm-Message-State: AOAM532r5ZbmOlBeCzp6/Z629l6UqtAV2vCMEeIpHdGJTPlJFGXs9vG4
        mb3F02EwsHxNZ0f0LQdVWW8S7ynn27VeWInfMJjDu/+z/ZTgkXHFJP4XLoaDaVDN75myLbrV6zF
        /fe9vhlITrHXN/6nGKpDswAgRJexrtMV+lqtPoTADW8c78+VT0jK5lTHr5rLwFGHzUAlD8nyAOC
        7L8xcx4Fo4EFRrlqBBafQP
X-Google-Smtp-Source: ABdhPJyncAMtl5qqNHS5PutAfcdrkIOeF5OpeKYIUw/563DHOU/lYBrx30+WpyTDv2D+jpjW1eZF5g==
X-Received: by 2002:a17:902:b7c9:b029:e6:3d74:5dc5 with SMTP id v9-20020a170902b7c9b02900e63d745dc5mr8698132plz.16.1616058731143;
        Thu, 18 Mar 2021 02:12:11 -0700 (PDT)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 11sm1413350pgt.83.2021.03.18.02.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 02:12:10 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH V2 2/7] mpt3sas: Handle chain buffer DMA allocations in same 4G region
Date:   Thu, 18 Mar 2021 14:41:46 +0530
Message-Id: <20210318091151.39349-3-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
References: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000aaf4ee05bdcbfe5d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000aaf4ee05bdcbfe5d
Content-Transfer-Encoding: 8bit

According to MPI Specification Chain buffers should not cross
4GB boundary. So while allocating Chain buffers, if any buffer
crosses the 4GB boundary then,
* Release the already allocated memory pools and
* Reallocate them by changing the DMA coherent mask to 32 bit.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reported-by: kernel test robot <lkp@intel.com>
---
In V2 fixed inconsistent indenting warning.
  
 drivers/scsi/mpt3sas/mpt3sas_base.c | 83 ++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f9e6f8e..d3cadad 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5481,6 +5481,52 @@ _base_allocate_pcie_sgl_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	return 0;
 }
 
+/**
+ * _base_allocate_chain_dma_pool - Allocating DMA'able memory
+ *			for chain dma pool.
+ * @ioc: Adapter object
+ * @sz: DMA Pool size
+ * @ctr: Chain tracker
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+_base_allocate_chain_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
+{
+	int i = 0, j = 0;
+	struct chain_tracker *ctr;
+
+	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
+	    ioc->chain_segment_sz, 16, 0);
+	if (!ioc->chain_dma_pool)
+		return -ENOMEM;
+
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		for (j = ioc->chains_per_prp_buffer;
+		    j < ioc->chains_needed_per_io; j++) {
+			ctr = &ioc->chain_lookup[i].chains_per_smid[j];
+			ctr->chain_buffer = dma_pool_alloc(ioc->chain_dma_pool,
+			    GFP_KERNEL, &ctr->chain_buffer_dma);
+			if (!ctr->chain_buffer)
+				return -EAGAIN;
+			if (!mpt3sas_check_same_4gb_region((long)
+			    ctr->chain_buffer, ioc->chain_segment_sz)) {
+				ioc_err(ioc,
+				    "Chain buffers are not in same 4G !!! Chain buff (0x%p) dma = (0x%llx)\n",
+				    ctr->chain_buffer,
+				    (unsigned long long)ctr->chain_buffer_dma);
+				ioc->use_32bit_dma = true;
+				return -EAGAIN;
+			}
+		}
+	}
+	dinitprintk(ioc, ioc_info(ioc,
+	    "chain_lookup depth (%d), frame_size(%d), pool_size(%d kB)\n",
+	    ioc->scsiio_depth, ioc->chain_segment_sz, ((ioc->scsiio_depth *
+	    (ioc->chains_needed_per_io - ioc->chains_per_prp_buffer) *
+	    ioc->chain_segment_sz))/1024));
+	return 0;
+}
+
 /**
  * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
  *                     for reply queues.
@@ -5578,9 +5624,8 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
 	u16 sge_size;
-	int i, j;
+	int i;
 	int ret = 0, rc = 0;
-	struct chain_tracker *ct;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -5907,31 +5952,17 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		total_sz += sz * ioc->scsiio_depth;
 	}
 
-	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
-	    ioc->chain_segment_sz, 16, 0);
-	if (!ioc->chain_dma_pool) {
-		ioc_err(ioc, "chain_dma_pool: dma_pool_create failed\n");
-		goto out;
-	}
-	for (i = 0; i < ioc->scsiio_depth; i++) {
-		for (j = ioc->chains_per_prp_buffer;
-				j < ioc->chains_needed_per_io; j++) {
-			ct = &ioc->chain_lookup[i].chains_per_smid[j];
-			ct->chain_buffer = dma_pool_alloc(
-					ioc->chain_dma_pool, GFP_KERNEL,
-					&ct->chain_buffer_dma);
-			if (!ct->chain_buffer) {
-				ioc_err(ioc, "chain_lookup: pci_pool_alloc failed\n");
-				goto out;
-			}
-		}
-		total_sz += ioc->chain_segment_sz;
-	}
-
+	rc = _base_allocate_chain_dma_pool(ioc, ioc->chain_segment_sz);
+	if (rc == -ENOMEM)
+		return -ENOMEM;
+	else if (rc == -EAGAIN)
+		goto try_32bit_dma;
+	total_sz += ioc->chain_segment_sz * ((ioc->chains_needed_per_io -
+		ioc->chains_per_prp_buffer) * ioc->scsiio_depth);
 	dinitprintk(ioc,
-		    ioc_info(ioc, "chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
-			     ioc->chain_depth, ioc->chain_segment_sz,
-			     (ioc->chain_depth * ioc->chain_segment_sz) / 1024));
+	    ioc_info(ioc, "chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
+	    ioc->chain_depth, ioc->chain_segment_sz,
+	    (ioc->chain_depth * ioc->chain_segment_sz) / 1024));
 
 	/* sense buffers, 4 byte align */
 	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
-- 
2.27.0


--000000000000aaf4ee05bdcbfe5d
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
KoZIhvcNAQkEMSIEIKijYq5MNYuovTPxYpHB4heCoqB1Ghxjuj5F2w3hWSWRMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMxODA5MTIxMlowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBl
Si4AIkOOgbBQFHyBTvM5NXQeaKQ30acRZFCHaIUhYR+Ms954HrrQNcvnEi0Vbp5IbpyaBp1FEDWf
0GPPaZpsceg57QkCw6M64U1GtXscG0bzlVmb/JTH4W37BeAL45mQaFGeRR/D8YpMOvlupCh5d2j6
QAEMb/vtkHPrEu7aRUbs3Eua+QQaQ6jAt2FdbNyKwUHAGLSMotuwyZdWp+Rglokc34Lh+h9VZsup
36lgzUig25fInppTb0moJqpR9BHC/9UTkKqlNM3o44GfhW1wb6sB0vOEHk0NDVmhqPQG/VZOY112
kgQYYwdIXCLAqdCbb7zS3oLwEJHvnx6hQngw
--000000000000aaf4ee05bdcbfe5d--
