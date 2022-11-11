Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC577C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 10:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiKKKX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiKKKXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 05:23:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF68EA4
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 02:22:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so4347823pjl.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 02:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mxxof+Jmiy20EGQjDLp7bPE7vLo/LDdVQnFmL7UVLlc=;
        b=LZJOghw5y0+Iq5OL4+CJUpf5mTqSQWIAmyu25R1I/STnx6FhFr6VF3UccYufCaqehG
         MZzQBRQ3f7m2fYq0R4QwGFRBAYAPJPDq879n7WK0VMzZYUgbFt5y6JJCtbmUkgfZaFUZ
         lcPXlZ4vYQjNb8VIF66Y15xD+QweA1dfRZRfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mxxof+Jmiy20EGQjDLp7bPE7vLo/LDdVQnFmL7UVLlc=;
        b=Aahw6ZWwTxwns9C1NghLwTneWSht6zS8Kc5pfWXRIqVDHhBwlqVrthlgnUrC0XULMi
         3seabWyfluk0az3mBpyg+1+fXvXxhB5nAa31NDiDwdtcWdjG4J3RXRP/7TPyefnvyz2A
         49CgGw3OZkzbnJZGHyERQDUQ8e9EypvHLbRhy8Dgg8eYvAGjTlox9ZZ/hbUyLhUvxwI+
         1e2Y3CIhPDIm8XHywWmMH6jIt4FmqBorde/Y5RixjHyxJQMyXONkQiHxqJ5ZPzjbfhWH
         Tz5DjBvzm6k51kcAdTCwJI0+UwHVnoo0Gv6keVcUivfbNAEajV6vUJl25oCxor3jxtkW
         TJVA==
X-Gm-Message-State: ANoB5pkMkrc9Cnb2Lhv4CLmGahQzMkF/A6Kj1kKZnDbXIqRcvI1LGpIu
        JSiNDO/vfWGO2k3MesPU/M1esdf6oqQ4xoELUcQOSpXYBAcii7TFAk7Ik23C0J/kESTe9bMbzAK
        P7o6hgGvfB8Qp880IHbQiS9Z4mleITwGiF366IF1BFWDWxMoGhIuxfNoR86i8+fYZschJ1tmpSM
        Bg3O4fssiI
X-Google-Smtp-Source: AA0mqf4V1PW3h9eqEOK7L3BdnepyPRsGRniSozZZs7Mba6wmj3HlIdY2b44hW92C6rmGE2h+z9SXOA==
X-Received: by 2002:a17:90a:e64b:b0:20d:b124:33b1 with SMTP id ep11-20020a17090ae64b00b0020db12433b1mr1130340pjb.202.1668162177707;
        Fri, 11 Nov 2022 02:22:57 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0055f209690c0sm1240691pfp.50.2022.11.11.02.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:22:56 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 0/1] mpi3mr: Remove usage of dma_get_required_mask api
Date:   Fri, 11 Nov 2022 15:52:45 +0530
Message-Id: <20221111102246.19995-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000f182f05ed2f4668"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000f182f05ed2f4668
Content-Transfer-Encoding: 8bit

Directly set the dma mask to 63 if the system is a 64 bit machine
otherwise set the dma mask to 32bit.

Sreekanth Reddy (1):
  mpi3mr: Remove usage of dma_get_required_mask api

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.27.0


--0000000000000f182f05ed2f4668
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
ixn6z19iSQwwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINBvOQ6Z8g++U7a/lLnX
qBANJ6jwhvzAF8Xg2SUwY48rMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTExMTEwMjI1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCKkFOMjQBhHu73hMCRiWlY7JWGXfS6uVV8IfYh
RXX2pZ8peQq8LIOZpm8grOL9MomCBN7hnjAOKNJ6Y+qZpr1kTjfbbcbaWRFCKYr5l6lFC2/R7xbB
vco7pWFMctHlBq7FAVQKBobWI7/CUiciOLw7cvUID6B/a+Ivo8TQrhHTSrOto/9zDX52IgJBgp6M
68xsWkV69FhFpQc75zPHhHRXqrunVZYue9Rr9rnYM9aM0qNPJw5Z9Ha2SNZpkJPWh1SQZ6XqVcye
xdjVrFrbAcGInO9SQa9rWnuTjgf9tzlk+Z/En5NI5CxBuka86so9tiqjHIFgKjs2yMdo0PlsxnxD
--0000000000000f182f05ed2f4668--
