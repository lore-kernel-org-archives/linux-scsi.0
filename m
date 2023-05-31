Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A666CC7EE29
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 21:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjEaV72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjEaV71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 17:59:27 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD259107
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 14:59:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f606a80d34so1619775e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 14:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1685570365; x=1688162365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GykZUQl8e4K4bWNcxuVoME9Lh++RfQc0qIa9cbs3JvA=;
        b=Hklb5pXzG5rTVmWXaxPQ/5tnD5T4R+TatqUTs/6Xrsii7oeGRlPBukHglp43N5ELtF
         fmSXZjaG8ICzB2Jw0zu7aU/8EkXGMva/BC5td6KZz0++RKvAVQoBKt8hsMl/jDnYTJOJ
         Ecov/DZ491Avre0fw5k+ZUrBnCh2uTK6evwZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685570365; x=1688162365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GykZUQl8e4K4bWNcxuVoME9Lh++RfQc0qIa9cbs3JvA=;
        b=T2XeQHkcUOdOLnLUPBbSvJK624LV1Y81Bdb/fkPf/j16MlAOEsBJXMgzojVu7IiH1x
         1WEj85ELHlAT4q2BZZXTXxiUg0r72raTiUWTkIMpL5+iB5VTKhsAvdctgdncA9OecCbg
         eKIzMPoosqSATyaLq6drT0dGHPLMk8D88C5h9YhaV/kcvBTo/knWmSLFc1geSpeI35Ug
         saDGZLXQEdvE6VPz7fpZkHx7IJXRNSbeS+r5VebyxIUl5hGMIxsobrZM1VL1o9yzuoaA
         iPnIXPhZ0GYevQaUNMG1bNRkLdHoo9C8f9Q6Ty/foKhQSpqAYcSsipCQ4fJarPYQftnw
         +Igw==
X-Gm-Message-State: AC+VfDxvyqaGUJGS9f/NuW/ZolUDDjgHxgb+GtMe2Ykf6IavRdU5mt8+
        HcvBK3qVxaH8IFV+n/yz2s0MFiLvatBuKf8NtR3QyHgbPYAsxGbtVgbT8FrjNoUHERAMKmVu7+O
        vz8TiwppMnu3mznuzampyPK2FG1ta
X-Google-Smtp-Source: ACHHUZ7g4wk2HP6qr8xxfpbmteeJ2QZW4SX8ciWu32/tav2bb6vT7xMNIF9YZBGhUI+Z5oFoY9x9k0I3TEb7dIbJg3I=
X-Received: by 2002:adf:ef8d:0:b0:2f4:6574:5a93 with SMTP id
 d13-20020adfef8d000000b002f465745a93mr316155wro.4.1685570365094; Wed, 31 May
 2023 14:59:25 -0700 (PDT)
MIME-Version: 1.0
References: <ZG0fDdY/PPQ/ijlt@work> <CABPRKS9ykHvaOGUboDXZ261LLPS78+YFpOZAcJEeLKGfEUe21g@mail.gmail.com>
 <202305261041.4C23B96F@keescook> <CAAmqgVPcSa36H7J2ABPmgCkkn8d7Asy+Wdn-xmQLuPqTupE5Gg@mail.gmail.com>
 <yq1leh4froo.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1leh4froo.fsf@ca-mkp.ca.oracle.com>
From:   Justin Tee <justin.tee@broadcom.com>
Date:   Wed, 31 May 2023 14:59:13 -0700
Message-ID: <CAAmqgVP+7cXt-u8SaQoB4akOG77Q==em0wdg-p7CYsH68+nBtQ@mail.gmail.com>
Subject: Re: [PATCH v2][next] scsi: lpfc: Use struct_size() helper
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Justin Tee <justintee8345@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e1a39005fd046eb3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e1a39005fd046eb3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Sure, will do.  I'll post the formal patch shortly.

The __be32 no_of_objects comment can be ignored for this patch as I've
already incorporated that into another patch with subject line: [PATCH
1/1] lpfc: Fix incorrect big endian type assignments in FDMI and VMID
paths

Thanks,
Justin


On Wed, May 31, 2023 at 8:27=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Gustavo/Justin,
>
> >> > We probably should have declared no_of_objects as __be32 to have
> >> > avoided this confusion.
> >>
> >> Perhaps this patch can add that too?
> >
> > Yes, please.  Something like this is fine:
>
> Please send a formal patch. Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--000000000000e1a39005fd046eb3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
QsyUohclvlxgt5d/MsBG6WZxZ+uppzNvjEk/wUu+6JQNUVEMviA6eBCCi+4ShjZUbGPES11h5lw/
wuyQZDIjy+1hGPtLHBXI/QQEbU3OVdTRn+aEMwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdqdXN0aW4udGVlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUlHfvnuNaLp52RO2Y2En9J+7MKI4wDQYJ
KoZIhvcNAQELBQADggEBAGaBsEmLZwejb3YsmigadLZGto3hJ7Erq2YZLhL7Pgtxft1/j4JNLsRN
t3ZJIW2Xzfbj0p328xRekSP1gjZ9Szre0fxEFXH1sS1a7WP9E0fHxVW07xVsxGxo5opAh5Gf/bQH
S4x9pCO48FJI310L1RGQiqFKY/OECnXO821y8MAyObbGo9HNHP4Sk6F5J1v2qJzbLtMfj8ybbTGe
SidstRgjOIqMldZs2Koio14QFE7hJY+8KRiKfq+eb1EwQTMzBxZsMOL5vUSZjYg2+Fqwyr6YYp0w
Lsq/wH9o18xSvL/FikpG4JRxiT20RdM6DQrk9lv8ijASZCuN3JR61WUNz2AxggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwMd6BsMSBDsagVFtYwDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILdGG4ATss+1kkf47W8jwo/A7AFE7e29F5X/Vunt
4Z8XMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDUzMTIxNTky
NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQDJ9QYdikIQ0RPee72aO1lxue0mFBv7GSZLZzFWE4q5XgECAEaTUObv3MSJ
HG7FBjSGgRTt7zjWzi0sYO2GaWOKmerv499BDhUKRn9+GEfZ8lSI9DjW9pfb8L11xoIHjwKDW506
7lpjNWwF2g3bVImoDKmmWWj2LDloSf4yGWHEsptUNY2Tg9/Z3qxnUSJviHVM9D2QgkH7TD30mnLO
3aoQG7anwyCqJwJe/LaZS3wBK+bbxa6XJzqEbhEzm7NBYqmZOJSIJkK9WbdS0XxY3/Mj9Z+oq4j3
ElCtOuZBgfQtFLKmdUXcZjsf0x8IvCYNTobtJD/EQB6W+eYBezp4f7SE
--000000000000e1a39005fd046eb3--
