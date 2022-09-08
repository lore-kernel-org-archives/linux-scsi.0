Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A49C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 12:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiIHMmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 08:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiIHMlu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 08:41:50 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E22FE621D
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 05:41:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p18so17708454plr.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 05:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date;
        bh=TsOg7GSUtEzME0F1++ilL5Adptcp7HK141I7YuuCFmk=;
        b=iSF0FrA0VqNo9YwmL3UEOtT5tO9Mv6ra3d74pdiLQOj7ZXFHPj1uAJHJOJ1Wtt3xw6
         g4mHfmDVIq7ak82Vgf6sIThKAbTviK5JPKtHw0LOpiukKYxGQAd9616qzd/XjE45cIWA
         ODe0NkNU/B6YPhH6X6sq7k3rgvAKNOAzjX+ss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=TsOg7GSUtEzME0F1++ilL5Adptcp7HK141I7YuuCFmk=;
        b=cDRUOnb+BHDJdsDEK23CFfT+AyU8D5TjQLHmmQeETlB4tksKnh7FQXGx+5G2ZwW91o
         6uMZNxIyHL9qVf0niW+ukR0txLAbryQJ2Ja2toGLH6w5iZogD0oe3rHUMHpQvarZIzyd
         0BJb45ylGccwdcXMycmADM3U3hxCUvz+0zaLGhosDpLIVa+lynTvzXS+5k7aSYWBnNx8
         gI4Ev7nIDLGdi33vWQTFnXJAoOrjS8LKIFGzLh0ZZgIC/Pu3yGYo0WpEPS0viWCUVy1l
         /BkKJzvNiifTGhkQdfXEB5IekgkrXLI26T9nsDekv3X5jy/3T4k3HkyCuJgcW8bS5PYD
         xi0g==
X-Gm-Message-State: ACgBeo2DrTfjFBSuowRwuIhfvl2916PBz+f6qZba/BkeWoLabeB99Edh
        1+I/qiBiBgUAn+8iymHYU3J6PQVK/q0ID55Zry4KamD6ozkzhctq2c7aBPSdUwP/za3qx1YVruA
        AkyRWR25lo0KUyD1CjJaKAQftaucjxBo8Yl+R00FpXkFEwoPgDia6l6XaefbBspLbCzKen9Hlxw
        bUXHQr4HuF
X-Google-Smtp-Source: AA6agR5RdGb3BeCw7M+5KaZmEMZwdmV0y+3v/+vnVB5Yz+TrhiDvzCxF+kWpbKy0jg9xuHTpqZ/m/A==
X-Received: by 2002:a17:902:c944:b0:174:f62a:14f0 with SMTP id i4-20020a170902c94400b00174f62a14f0mr8796607pla.168.1662640890855;
        Thu, 08 Sep 2022 05:41:30 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c17-20020a63ef51000000b0043395af24f6sm11106807pgk.25.2022.09.08.05.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:41:30 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 8/9] mpi3mr: Fix scheduling while atomic type bug
Date:   Thu,  8 Sep 2022 18:23:31 +0530
Message-Id: <20220908125332.21110-9-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
References: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b9f3f005e829bfa7"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b9f3f005e829bfa7
Content-Transfer-Encoding: 8bit

Fix 'scheduling while atomic' type bug, which is
observed when pci_irq_vector() is called from
interrupt context.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 2 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index bd8eba2..def4c5e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -431,12 +431,14 @@ struct op_reply_qinfo {
  * struct mpi3mr_intr_info -  Interrupt cookie information
  *
  * @mrioc: Adapter instance reference
+ * @os_irq: irq number
  * @msix_index: MSIx index
  * @op_reply_q: Associated operational reply queue
  * @name: Dev name for the irq claiming device
  */
 struct mpi3mr_intr_info {
 	struct mpi3mr_ioc *mrioc;
+	int os_irq;
 	u16 msix_index;
 	struct op_reply_qinfo *op_reply_q;
 	char name[MPI3MR_NAME_LENGTH];
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ad78b9b..b5c3bf4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -627,15 +627,11 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
-	struct mpi3mr_ioc *mrioc;
-	u16 midx;
 	int ret;
 
 	if (!intr_info)
 		return IRQ_NONE;
 
-	mrioc = intr_info->mrioc;
-	midx = intr_info->msix_index;
 	/* Call primary ISR routine */
 	ret = mpi3mr_isr_primary(irq, privdata);
 
@@ -650,7 +646,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	    !atomic_read(&intr_info->op_reply_q->pend_ios))
 		return ret;
 
-	disable_irq_nosync(pci_irq_vector(mrioc->pdev, midx));
+	disable_irq_nosync(intr_info->os_irq);
 
 	return IRQ_WAKE_THREAD;
 }
@@ -696,7 +692,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 	    (num_op_reply < mrioc->max_host_ios));
 
 	intr_info->op_reply_q->enable_irq_poll = false;
-	enable_irq(pci_irq_vector(mrioc->pdev, midx));
+	enable_irq(intr_info->os_irq);
 
 	return IRQ_HANDLED;
 }
@@ -738,6 +734,7 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 		return retval;
 	}
 
+	intr_info->os_irq = pci_irq_vector(pdev, index);
 	return retval;
 }
 
-- 
2.27.0


--000000000000b9f3f005e829bfa7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDjeOGi9ErudHltJeJJG
xDFneUqLV6S0QImPMGhAJMv7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkwODEyNDEzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCJtR7aQlP/+15ARZGIw92U+y02dNWEU/EttN1g
AUxDPKyBU6TLmX+H55eYPIv/5TU8aX2kGDnXXoUsY1TOE/OwAV5mUr9/Xv2EbL2oLDNr11OFMiXu
ssGhM08EfYkiPap4v7c45+spnvNGz/bMJOMSt1Wc6T2bNPu9/ZnwRxOdZ9H5PZCHcRZ/llGNhr6w
pfIL9dax8ibXuHNGbH8x4D27ec0I0M57da0S/GTdXyfaMMSRDkuiN4cu6TrPzjKdj+sxnAb8QkYz
FYeWbc6Vt4zHrRIWDTqZz79T5Y/0Xs/lxPuh3OJ17Pel+kf/sJseMlNQbb0ZEqb/DUtCffAYQKL1
--000000000000b9f3f005e829bfa7--
