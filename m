Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67479C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 12:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiIHMlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiIHMlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 08:41:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177FDD076C
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 05:41:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t3so12644641ply.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 05:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date;
        bh=FQ98sBpGcvy+EEwifOpxCNgdcwc2Mdk46wztXTap1zE=;
        b=QbUy2ZNJ++y1IZFMQXZi8usvYIcFc00/DkL8XzuwZWSQTv/1aMHXRiEwqARArVzRyW
         H/bplcASLhoMnuRpl6cnbxUZ7sKsV9Y/SdHtDPKVwhUITfa0/PGGkJ9g9zCkavVc0HSV
         6cyD5U9jxEx7CDVE5rOwxRp7OgkNCK9nlD55M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=FQ98sBpGcvy+EEwifOpxCNgdcwc2Mdk46wztXTap1zE=;
        b=m+AQgIOvsgbMJfu1IDMuY1zow0ukAZap6dZNtKUjhrQwcCpzIED5f/B4raCz2d4094
         a6G9Ni57yo2m0afGDNSCsD/1+kT9eLFJ1HdMnHB6SSm2AM31I7cK7fqo4y2yf+RrsbJa
         ajEf1mn9D+eUJpX1B3W7hiJktkPF/Rra5qeecoGmYI4YqiDr0X9JYCBMV/QzVz0cx1Gw
         Txhj7NFOjr1niMbMJraiHj10/rRX80wYNtL3ki8wUypNgQmEjl0O6AXmV01h5/XAn9/k
         OuFkLGEL4SENkoxfkU7t/tpNFqwZiU11Y+1QAg4oHfpVYlAJgOazR7xdoL0ZArxJsQ9S
         Ow8g==
X-Gm-Message-State: ACgBeo0qdErXyBvc+1NzRwZuwmgvrCpbVsNUmELw+ymuoLG/nBGssb4J
        mcE+xY/6sCEEAqvYs6/4Sx7fS/oNcvgg3MnCFXWsUVUQ7hs75SN61Bv7REqCpjvdz9lQrQkk9rt
        hBqAwsvq2qluLYAEDk2lq6pL45dzeZuPzrUdoT0JoVcpyrONdInFsc9Fpbn9vupGl5F555wFqoj
        l96FJQwiMh
X-Google-Smtp-Source: AA6agR565BsHV/lscIKR/5q4B6UYzhiWZ1Uk4gNL7RbeQKvAFfH5s/qp9QzJnaejufwO5ZvsFVPSMw==
X-Received: by 2002:a17:90b:38c1:b0:200:8f03:63d8 with SMTP id nn1-20020a17090b38c100b002008f0363d8mr4006489pjb.148.1662640881031;
        Thu, 08 Sep 2022 05:41:21 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c17-20020a63ef51000000b0043395af24f6sm11106807pgk.25.2022.09.08.05.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:41:20 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 3/9] mpi3mr: Schedule IRQ kthreads only on non-RT kernels
Date:   Thu,  8 Sep 2022 18:23:26 +0530
Message-Id: <20220908125332.21110-4-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
References: <20220908125332.21110-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000022eb7f05e829bfda"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000022eb7f05e829bfda
Content-Transfer-Encoding: 8bit

In RT kernels, the IRQ handler's code is executed as a
kernel thread. So, the driver is modified not to explicitly
schedule the IRQ kernel thread.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index cc700e2..78792f2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -537,6 +537,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+#ifndef CONFIG_PREEMPT_RT
 		/*
 		 * Exit completion loop to avoid CPU lockup
 		 * Ensure remaining completion happens from threaded ISR.
@@ -545,7 +546,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 			op_reply_q->enable_irq_poll = true;
 			break;
 		}
-
+#endif
 	} while (1);
 
 	writel(reply_ci,
@@ -614,6 +615,8 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 		return IRQ_NONE;
 }
 
+#ifndef CONFIG_PREEMPT_RT
+
 static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 {
 	struct mpi3mr_intr_info *intr_info = privdata;
@@ -691,6 +694,8 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 	return IRQ_HANDLED;
 }
 
+#endif
+
 /**
  * mpi3mr_request_irq - Request IRQ and register ISR
  * @mrioc: Adapter instance reference
@@ -713,8 +718,13 @@ static inline int mpi3mr_request_irq(struct mpi3mr_ioc *mrioc, u16 index)
 	snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
 	    mrioc->driver_name, mrioc->id, index);
 
+#ifndef CONFIG_PREEMPT_RT
 	retval = request_threaded_irq(pci_irq_vector(pdev, index), mpi3mr_isr,
 	    mpi3mr_isr_poll, IRQF_SHARED, intr_info->name, intr_info);
+#else
+	retval = request_threaded_irq(pci_irq_vector(pdev, index), mpi3mr_isr_primary,
+	    NULL, IRQF_SHARED, intr_info->name, intr_info);
+#endif
 	if (retval) {
 		ioc_err(mrioc, "%s: Unable to allocate interrupt %d!\n",
 		    intr_info->name, pci_irq_vector(pdev, index));
@@ -2179,9 +2189,13 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		pi = 0;
 	op_req_q->pi = pi;
 
+#ifndef CONFIG_PREEMPT_RT
 	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
 	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
 		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll = true;
+#else
+	atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios);
+#endif
 
 	writel(op_req_q->pi,
 	    &mrioc->sysif_regs->oper_queue_indexes[reply_qidx].producer_index);
-- 
2.27.0


--00000000000022eb7f05e829bfda
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVUwggQ9oAMCAQICDHJ6qvXSR4uS891jDjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAyMTFaFw0yMjA5MTUxMTUxNTZaMIGU
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD1NyZWVrYW50aCBSZWRkeTErMCkGCSqGSIb3
DQEJARYcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAM11a0WXhMRf+z55FvPxVs60RyUZmrtnJOnUab8zTrgbomymXdRB6/75SvK5zuoS
vqbhMdvYrRV5ratysbeHnjsfDV+GJzHuvcv9KuCzInOX8G3rXAa0Ow/iodgTPuiGxulzqKO85XKn
bwqwW9vNSVVW+q/zGg4hpJr4GCywE9qkW7qSYva67acR6vw3nrl2OZpwPjoYDRgUI8QRLxItAgyi
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINIMJaUdRIbpfcdAaFwl
k4oPydcbiCBhP4YusJIGiCpOMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkwODEyNDEyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCJloqmZMkw/nhcwsA3Gp2UUBxLI65EsAbo0mRZ
LhFmaSEzw5wZunm+sBHEf7G4pynHva73FHbPy9vtnYv9KL4KoNXNDPPFyTGGzl3BdI7yf0yUZDFF
eqi2GzaPvqhbRPTEnAuspBXfWHHI04Bt4aPMg/pkK41GIAFvVSjdPbQJndSNEU8xPLSCEg/neDaJ
9a89HN9aFdVlD+ay0JDXsM1454jJpaYYowzEqMDlYZKAggVwkY3tsX+KeV2XURemKng/EqLLSFb/
G6fAfW5YJjGMMATpefJpL0sbcLpwmD/350Y7I8eEP04m7JGztSl40Uq6SmG0YuSXP8MWpFw0EiX1
--00000000000022eb7f05e829bfda--
