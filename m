Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC037C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 07:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF6664DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 07:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhA1HSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 02:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhA1HQi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 02:16:38 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679FAC061574
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 23:15:58 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id i30so4300057ota.6
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 23:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mL2u/pZgwa4rAkIWydl2SqcXSXaaCsKqWURlavUcG1Y=;
        b=OU+JNnyohUbECUwlJv/TGgyQe2S1E9XeBxDf2eObJEjlM6ZpwfSuqZXuysah7xXVI/
         d6is0yGErOnByENzwi6PE3vc4pK1bdOVrEpi8elJdC/5e+Kajs++sQjC5/4z3ZUM630m
         nQpsZRUCs47oHEagg89EHatdglepdETp4AonM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mL2u/pZgwa4rAkIWydl2SqcXSXaaCsKqWURlavUcG1Y=;
        b=Vst+wo+2CXG+UyF/tPN4A/6y4R0wboAyb0Nf4rACKe0S2gOo8tKDV0kzjBBxTs5ZPF
         wGFfLmKwfi+RP6VzxK/xcrD+RZMKKVyDiUSuGH7v1zU6OF8+X2rD5zgXduJgDI85JQ8G
         j6ReYjohBAEr5QcRGw99/3ag00iI184vfGqrfpBXUNWDiFamWF2K8vT19lGePievhVnu
         RMho0em2yBw0m49FtA102PMYZaFwSv4RVQcr7rmpZKX1NJP55omUwUt5MpvxqLygxfwW
         s/Zaoiczo8SsT4pknqkRezUqgWAl7dSejP/5KQgO+HHXuKAeQHm4K8pJePpbOgd3+VEU
         66zQ==
X-Gm-Message-State: AOAM533KdLd806Wkc6uS1pNJtcZVabOyN8CbCBlgQNuG6fvQ7n9VjSn9
        yOfoOTVvE6Vb9i4nUHzIn/yUmOXCmaz5RPTwqTAE/w==
X-Google-Smtp-Source: ABdhPJxHL59i+JPAydim3b7PQcdGo8/EQnKf43hkcfGcSrddx7Z3wfib5zgRHlBEwkOHFz0I89WyP2ZblLIk7cpT+RU=
X-Received: by 2002:a9d:1c9a:: with SMTP id l26mr10464807ota.316.1611818157530;
 Wed, 27 Jan 2021 23:15:57 -0800 (PST)
MIME-Version: 1.0
References: <20210127223840.GB1350451@T590>
In-Reply-To: <20210127223840.GB1350451@T590>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 28 Jan 2021 12:45:46 +0530
Message-ID: <CAK=zhgok5X45F-SpFkeTLe9ufA8PozUc7HESEzXDJNMLcxDJ7Q@mail.gmail.com>
Subject: Re: [MPT3SAS bug] wrong queue setting for HDD. drive
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c0709b05b9f0a8cf"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c0709b05b9f0a8cf
Content-Type: text/plain; charset="UTF-8"

Ming,

Below referred commit changes apply only for NVMe drives.

Driver sets nomerges & virtual boundary under below if condition. And
the driver sets MPT_TARGET_FLAGS_PCIE_DEVICE bit in
sas_target_priv_data->flags only for NVMe drives.

if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
           ...
                blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
                                sdev->request_queue);
                blk_queue_virt_boundary(sdev->request_queue,
                                ioc->page_size - 1);
}

on my local setup, I have both SAS HDD and NVMe drives as shown below,

[11:0:20:0]  disk    SEAGATE  ST600MP0005      VS09  /dev/sdz
[11:2:0:0]   disk    NVMe     INTEL SSDPE2MW40 0174  /dev/sdab

and default nomerge setting for these drives is as show below,
/sys/devices/pci0000:80/0000:80:03.0/0000:85:00.0/host11/port-11:0/expander-11:0/port-11:0:19/end_device-11:0:19/target11:0:20/11:0:20:0/block/sdz/queue/nomerges:0
/sys/devices/pci0000:80/0000:80:03.0/0000:85:00.0/host11/target11:2:0/11:2:0:0/block/sdab/queue/nomerges:2

so, for SAS HDD drive default nomerge setting is zero and for NVMe
drive the default nomerge setting is two.

 Thanks,
Sreekanth

On Thu, Jan 28, 2021 at 4:08 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> Hello Guys,
>
> The commit[1] is supposed for NVMe device only, but we found the change is
> actually done on the following mpt3sas HDD. drive:
>
>         #sginfo /dev/sdc
>         INQUIRY response (cmd: 0x12)
>         ----------------------------
>         Device Type                        0
>         Vendor:                    SEAGATE
>         Product:                   ST16000NM002G
>         Revision level:            E003)
>
> So NOMERGES is enabled, and virt boundary limit is applied on this HDD.
> device, and performance drop is observed, can you take a look at the
> issue?
>
>
> [1] commit d1b01d14b7baa8a4bb4c11305c8cca73456b2f7c
> Author: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Date:   Tue Oct 31 18:02:33 2017 +0530
>
>     scsi: mpt3sas: Set NVMe device queue depth as 128
>
>     Sets nvme device queue depth, name and displays device capabilities
>
>
>
> Thanks,
> Ming
>

--000000000000c0709b05b9f0a8cf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Rag/s/0IKyxAQsoBcla5ZufuDE5ir/mlnYktkPJdg+kns/OPDsINSyWqNYE9PKy9+3cp/fItNFtH
krg1AgMBAAGjggHTMIIBzzAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsG
AQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2ln
bjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29t
L2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEF
BQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBE
BgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWdu
MnNoYTJnMy5jcmwwJwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNV
HSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4E
FgQU1CyhXqcQo40SZ7kFS/AiOnRW6lMwDQYJKoZIhvcNAQELBQADggEBAFeMmmz112eNFAV8Ense
5WremClV5F3Md1xS0yXKqxlgakUJaOI/Fai7OLQaQqsEoxW6/QqWEi1wbZOccbdritOkL5b7sVUp
SU9OfuIlV8c3XMLaWSIluy+0ImtRJ49jDCI4KtQESHrqfQRZcc1C/avZvNED3U4b10U6N3SY+59b
fm2Vlwacwp+8ESTp49DsLcJqc4U/0rUZxLWtgPokzS+ovX+JAu8zx1SmOzUC4hj4Bp6Vnfd5KWUK
JJQBmQHXii+acSeTgHmPWUYs3tYQ0uIX0Yy8LUWPdGbEq+KWepzY2otC+iVWdngCCv8Nf1Xo1jki
AGJ6hrlWFE0qJVWv25sxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hB
MjU2IC0gRzMCDBmG1a14/wFg8qBhUjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg
5coQef7H80rkTaZAmqg6ozAiMDAqZufQ53JglrVcVnAwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjEwMTI4MDcxNTU4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADldeaGXaS8Ci6epj8vO
AR2dNTPGj6QyejGqpfX3/hATllsx8pTW7tmLmekNLBhUwRWMfu/jZ2/0HhCOeG18zMK0elUfyCZW
waa5B3fl+DFL8tVzTl020eoUTEIzHIbjCYooQJEfTMQ4P2lBrj1ZjdeEHICdbH8a+F2LBl4iC9CM
M4F0SHNGqT6/6OFG2+JpwI1lckft5k17smX8mcBvpr6WeZfhEdwcEhZR0yw9FQLXPu69pIPFTxyh
IXGHeHeYiuQLwjQOJuRizFNSZW51VZpVlx329+Ih/Jvyt9BpBNf6wxgn7MkVteNDuCWc8heGviMX
hkBFsmNmO76SzSG3idM=
--000000000000c0709b05b9f0a8cf--
