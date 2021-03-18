Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B727C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11BB64F18
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhCRJNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhCRJM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 05:12:27 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784A5C06174A
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e14so971501plj.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=sOh7GtmWAb8rhvdk9qbOHuTpgdUdc5W6VmfTf6ovlxM=;
        b=gOgnNtCcieJZkWlu7zHtWg0k/7Dtw9LukLPyrtmm26P6wrBu9MCVet53noeGjF1sN9
         3ASDLmltvg/cKTUacw7nAUC+LeRSg0I7knrFKx7WZ1mQtjL+lhLZ86YdikpqpteC1Qj1
         Ef2JxgK9O/Sh8au2axZ2zSQuTVXuoGCCmu824=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=sOh7GtmWAb8rhvdk9qbOHuTpgdUdc5W6VmfTf6ovlxM=;
        b=kUmha2++V1nm6Au1E9X4KFrtvTY2AkCQEO7VPD+ETleDJG2sAcYWrF8bYuRGEND33B
         2ZN/mEilEm7rgYrnertRwsPiHqBdKacFUVGr+uHsPLgpZo61eAC82LMZ+Rr53k0R/eEz
         tdS0VNMnMbuYU2f1Tw7XIs7oTl1OWdc6SpE9kfvxD3+7ZJ6SE1DxGhYQJ+16ULH3ONOi
         5bEBrMrgjwsBOvGd8SpflJrgCjI3EIfVAy2XpY4tcKeoVBaGf8HZ7VYCksSAimy9x7A3
         8TmOWuIe4P2D/C1LI3ALeRZjwKAIPjP5G052lHO560V1fwx3ug6QFKnL3sqj6nml7nFK
         LSHA==
X-Gm-Message-State: AOAM5333QWkwewduGfL1U+fcGR3falr3kWWPvpLz9HkG3yKCtJl9YM61
        GixRm6t4Kgczr1vQCZ7Oa8FVr8snv0pueUhEyxeFZgJPXp1taAdC/sZbVVl3mkyz4NaeOJwoT6D
        0uiV1jGLFDtkD18aQFx1uJl5ef7dbaucCfMIWjAcVhr+lxbt0xmU9+HnD+YQCxRKY3d96xCB3u5
        oswuTltq05lFnTG4vlc7R1
X-Google-Smtp-Source: ABdhPJxEWPi3h0yOSeaqILOPBe7uXYpOWC1YOe3UZCLyhLpelfSIV3Vko+AshyC4SthLNRSuKqGXOg==
X-Received: by 2002:a17:902:dcd4:b029:e6:5398:609f with SMTP id t20-20020a170902dcd4b02900e65398609fmr8584235pll.58.1616058746389;
        Thu, 18 Mar 2021 02:12:26 -0700 (PDT)
Received: from dhcp-10-123-20-76.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 11sm1413350pgt.83.2021.03.18.02.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 02:12:25 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH V2 7/7] mpt3sas : Update driver version to 37.101.00.00
Date:   Thu, 18 Mar 2021 14:41:51 +0530
Message-Id: <20210318091151.39349-8-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
References: <20210318091151.39349-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008cb53105bdcbff57"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008cb53105bdcbff57
Content-Transfer-Encoding: 8bit

Update driver version to 37.101.00.00

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index b86eced..98558d9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,9 +77,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"37.100.00.00"
+#define MPT3SAS_DRIVER_VERSION		"37.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		37
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
2.27.0


--0000000000008cb53105bdcbff57
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
KoZIhvcNAQkEMSIEILZQeuTwvbMjhlTinSztDY3hzbHXETS5LWS9yVW21A8lMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDMxODA5MTIyNlowaQYJKoZIhvcNAQkP
MVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAL
BgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAQ
ONzuIGteC754G+ez/0VCw7XmAqo26Jxwc/IG3Td/pY0qdwNmEUdj1k2SsKCyJP7Wz2UdG6A5cOXb
Qv/XeckF29ROI1ZzMUtZYBCSQeh6GrQaF2laIQ8Z/LxM8IAzqAXvObtLER1OEk5EMG5ffDE/Z8Zv
+Pw3P8ZKl3ypMGppqpQETPXjCxzOjyFeFAvTewflyftXiiMYmFeLEMOKPlPU4PlCcnnHINOekUJ9
6a0/3FxbCftW6l7jA6HIlMmGlxil6vuPUep6EKpYx97zy3HSAtXKYkYcZGLCCV6iUfgcfMqYuaKq
UT3RwIbOaJWe2Jve7gGndgyTXnw26ETRMSoZ
--0000000000008cb53105bdcbff57--
