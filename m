Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10ADC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 19:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiDGTfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 15:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiDGTfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 15:35:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666562C270D
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 12:33:08 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gt4so6523446pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 12:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=92yOUFSY1cQoKrxaX9Lr9ZvhyZ3VMWdXdjCqoIeIpuY=;
        b=V8JsvxX5POKzsSxfKNhLF2Kc8g7/I363WF8apbheuLq52N3gXCRpDAIw8NnNXY4avt
         sHF2wC/nkreXvaV2eCSfQVpmSc/THwx3sDeY4Jw+k1m+3Lmopgl11YE1fOjoomVYDU7W
         See6FGZqRApvIR+CvYj/qHMVcQzMvEd57JSZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=92yOUFSY1cQoKrxaX9Lr9ZvhyZ3VMWdXdjCqoIeIpuY=;
        b=eKELKHV/CZkn+B8ZeBv1nRBf+4LRbvvJBvkbbhSwYhscjx2ZvPkdu/1j/frEPZryHH
         evPFza3tCu4V13iRhJH3AnMfhTo/0zR5ZdtbK0s5HCWdF9E5vMNNjENKGEk49VqGoUcj
         Ga3S1VEtKT7MTa7R1OK7aQj8liVELyQNGLN+PeG8LQrP3mdxVayyoPgl1GdqVa2yo8qu
         6eUKP0EyjOOqH1kkZJLa3gD5VNnvuHv8TVfIUrBSP4BqTiyVPzjeKQ1i0enO/fWIbAdK
         1oDZBAlvh1mcqW/m8tK5n1us5+UcvfP9Jyy53BXRHMUPJNSu0v3gJMaRzrrESC/S6Fr2
         G0FA==
X-Gm-Message-State: AOAM5304HUVsd7fiWoanM8zsiPBFije5ycm+jzihYmrfWnzCdZgVgDxf
        EU/Y9ZrJEykMccK1VMUDi6tZxRbjkw9JlTjsP2qqgmny2PoMfspl8brSBlWAuV6P2ADqBIsjW6B
        /lUMmmCuDBA5vUoKXmI3JuGmyJNCIM8W+VZHUQBx0LgwfMR977yTw5JYrHNzKh0CDsfqwpMcpBS
        WnQuyTTi48Mw==
X-Google-Smtp-Source: ABdhPJyaliNRqP5JOcQWbFatDNtyAmGEfm6eOzlt8YjHgNwW3lrxHdPcLKaWlQFLIXA295PgnEMjKA==
X-Received: by 2002:a17:902:b213:b0:156:5a00:325f with SMTP id t19-20020a170902b21300b001565a00325fmr15315254plr.127.1649359798093;
        Thu, 07 Apr 2022 12:29:58 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o3-20020a056a0015c300b004fb24adc4b8sm23579275pfu.159.2022.04.07.12.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 12:29:57 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
Date:   Thu,  7 Apr 2022 15:29:08 -0400
Message-Id: <20220407192913.345411-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407192913.345411-1-sumit.saxena@broadcom.com>
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e5e66305dc158024"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e5e66305dc158024
Content-Transfer-Encoding: 8bit

MPI headers are used by user space applications so
it makes sense to move them to uapi/scsi/mpi3mr.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h                       | 14 +++++++-------
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_cnfg.h  |  0
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_image.h |  0
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_init.h  |  0
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_ioc.h   |  0
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_pci.h   |  0
 .../mpi => include/uapi/scsi/mpi3mr}/mpi30_sas.h   |  0
 .../uapi/scsi/mpi3mr}/mpi30_transport.h            |  0
 8 files changed, 7 insertions(+), 7 deletions(-)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_cnfg.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_image.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_init.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_ioc.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_pci.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_sas.h (100%)
 rename {drivers/scsi/mpi3mr/mpi => include/uapi/scsi/mpi3mr}/mpi30_transport.h (100%)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 877b0925dbc5..7538571e61a6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -39,13 +39,13 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
-#include "mpi/mpi30_transport.h"
-#include "mpi/mpi30_cnfg.h"
-#include "mpi/mpi30_image.h"
-#include "mpi/mpi30_init.h"
-#include "mpi/mpi30_ioc.h"
-#include "mpi/mpi30_sas.h"
-#include "mpi/mpi30_pci.h"
+#include <uapi/scsi/mpi3mr/mpi30_transport.h>
+#include <uapi/scsi/mpi3mr/mpi30_cnfg.h>
+#include <uapi/scsi/mpi3mr/mpi30_image.h>
+#include <uapi/scsi/mpi3mr/mpi30_init.h>
+#include <uapi/scsi/mpi3mr/mpi30_ioc.h>
+#include <uapi/scsi/mpi3mr/mpi30_sas.h>
+#include <uapi/scsi/mpi3mr/mpi30_pci.h>
 #include "mpi3mr_debug.h"
 
 /* Global list and lock for storing multiple adapters managed by the driver */
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/include/uapi/scsi/mpi3mr/mpi30_cnfg.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
rename to include/uapi/scsi/mpi3mr/mpi30_cnfg.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/include/uapi/scsi/mpi3mr/mpi30_image.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_image.h
rename to include/uapi/scsi/mpi3mr/mpi30_image.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/include/uapi/scsi/mpi3mr/mpi30_init.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_init.h
rename to include/uapi/scsi/mpi3mr/mpi30_init.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/include/uapi/scsi/mpi3mr/mpi30_ioc.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
rename to include/uapi/scsi/mpi3mr/mpi30_ioc.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/include/uapi/scsi/mpi3mr/mpi30_pci.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_pci.h
rename to include/uapi/scsi/mpi3mr/mpi30_pci.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/include/uapi/scsi/mpi3mr/mpi30_sas.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_sas.h
rename to include/uapi/scsi/mpi3mr/mpi30_sas.h
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/include/uapi/scsi/mpi3mr/mpi30_transport.h
similarity index 100%
rename from drivers/scsi/mpi3mr/mpi/mpi30_transport.h
rename to include/uapi/scsi/mpi3mr/mpi30_transport.h
-- 
2.27.0


--000000000000e5e66305dc158024
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBUwwggQ0oAMCAQICDChBOkGaEPGP0mg3WjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAxMzJaFw0yMjA5MTUxMTUxMTRaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFN1bWl0IFNheGVuYTEoMCYGCSqGSIb3DQEJ
ARYZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOF5aZbhKAGhO2KcMnxG7J5OqnrzKx30t4wT0WY/866w1NOgOCYXWCq6tm3cBUYkGV+47kUL
uSdVPhzDNe/yMoEuqDK9c7h2/xwLHYj8VInnXa5m9xvuldXZYQBiJx2goa6RRRmTNKesy+u5W/CN
hhy3/qf36UTobP4BfBsV7cnRZyGN2TYljb0nU60przTERky6gYtJ7LeUe00UNOduEeGcXFLAC+//
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHa3piALoEtAaiA7PoOf1oLNDc3JXhFA
ntR2RRAHZ5goMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
NzE5Mjk1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAVVgASg7SRmH4wgYKuvum/8TvAvhTJONa/XW2/1NJT3+fmEzGE
KGH4091SnSnYSsMNWcjIDrCGzrXvhK5699tK71rcOKtQOs6EuyaP8El7Nc748aGw7YCML2EKUO/x
PqIQNYGePWm6w/h6w/GyD//3xe7RWifoepdzPJC3C6k/65M4YAW2ZR9qTzT1E5+1f0AvkXa/Yxue
zxoaJSR6cshqE0x7PtoXiOUCwpVPVOaPYArSXyemkAwEhZyx2Se938w2Ch5b+0lPfQQml+dyhxV+
X31YAGAm6u+duMUdoUW1iq9HTg+XINJrDn3+R9iNvED+HdXtj0ydqs0zMB4bZyd1
--000000000000e5e66305dc158024--
