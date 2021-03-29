Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20942C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB4F61969
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 06:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhC2GYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 02:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhC2GYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 02:24:23 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FDBC061574
        for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2021 23:24:23 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id x16so5963963qvk.3
        for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2021 23:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=TtZpxRmyXiQaCFq7lVVzio46mTnnxbdOFCyySo5yh3o=;
        b=FVkAYdIACLGaBlHnIxKXXi/yrXDfV6XyYtnzayEgmAdcHQKA2JNBEcGYxfeSpdlKxy
         QARxvVqloVMnwDsFCP+mmVXj3xVvKhiaNN4f4lekaS4VRh6xDN/6MnDZAZJEj8BvcuXT
         u+sk37PtbfGI3d23R595/giINlv45BOHjKGv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=TtZpxRmyXiQaCFq7lVVzio46mTnnxbdOFCyySo5yh3o=;
        b=XG4/AiXWL+X3S3e0BV66ltziCOMYW2CnL0dDRbG5tUYuNdxVeURTL/qCrhqufyXyK/
         kex8sxQK+XfjXvEd1Yl5D0rZe2tlJbMGLjh6T3BlP9E+j8CRvojOWE/X6tovouM8whnd
         qQtlUuj/M+8OKjGkB829+8WoCbAvTGAA7e0IWFQaVOi5qaTPS8Yz2V5jmNLULvAJ/46g
         8LhLvZiQCyQsBATPQtczVce/KNImvw1KPfu73Y9xfKsJI+KzTTyMJXJOin34pshBGOBo
         zO6A3f96CxwAAFipWQRmiX3O8BuitviG+qrzyR2bwF237XjFr5kdJnn47pIzgD+IX1/y
         /9Gw==
X-Gm-Message-State: AOAM532e17PrywLNQpzVAPxo0MR4ceT2SgzQUFfECr11JN3Nac0lx5PH
        2bp/2jAlXK0nW1VSTWtBT5YquX62m0DSi9/4O/1iFw==
X-Google-Smtp-Source: ABdhPJza7SQarVnME/YlkH+HVqt6Juln435uDctTgRfJ5thzlIrOK4RdiULBIkqYS0Le81pRSMHIVW90UrmALPupHns=
X-Received: by 2002:a05:6214:9c9:: with SMTP id dp9mr23883267qvb.34.1616999062627;
 Sun, 28 Mar 2021 23:24:22 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
In-Reply-To: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHV6J6hu5NVcRVaP9BEW0OUkthBRqqc9mQQ
Date:   Mon, 29 Mar 2021 11:54:18 +0530
Message-ID: <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com>
Subject: RE: MegaRaid SAS 9341-8i issue
To:     =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        linux-scsi@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c0ac5905bea6eeed"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c0ac5905bea6eeed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi -

Can you send us full dmesg logs of each working and non-working case. ?
On 3rd motherboard was it any working combination of kernel, driver and FW =
?
OR it never worked on 3rd mother board ?

Kashyap

> -----Original Message-----
> From: Fr=C3=A9d=C3=A9ric Pierret [mailto:frederic.pierret@qubes-os.org]
> Sent: Sunday, March 28, 2021 10:26 PM
> To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
> Subject: MegaRaid SAS 9341-8i issue
>
> Hi,
>
> I'm having issue with a MegaRaid 9341-8i card which is properly working o=
n
> two motherboards (kernel-5.10.25 and kernel-5.11.10) but not on a third
> for
> which I want it to work. I originally received this card with a firmware
> from
> 2018 and I've updated it to the latest from Broadcom website
> (24.21.0-0148)
> but in both cases, I've the same issue on the third motherboard:
>
> [   14.013135] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
> base_addr(phys):0x00000000fe800000  mapped virt_addr:0x(ptrval)
> [   14.013142] megaraid_sas 0000:01:00.0: FW now in Ready state
> [   14.013148] megaraid_sas 0000:01:00.0: 63 bit DMA mask and 32 bit
> consistent mask
> [   14.013933] megaraid_sas 0000:01:00.0: firmware supports msix        :
> (96)
> [   14.014439] megaraid_sas 0000:01:00.0: requested/available msix 5/5
> [   14.014445] megaraid_sas 0000:01:00.0: current msix/online cpus      :
> (5/4)
> [   14.014447] megaraid_sas 0000:01:00.0: RDPQ mode     : (disabled)
> [   14.014453] megaraid_sas 0000:01:00.0: Current firmware supports
> maximum commands: 272        LDIO threshold: 237
> [   14.014631] megaraid_sas 0000:01:00.0: Configured max firmware
> commands: 271
> [   14.015377] megaraid_sas 0000:01:00.0: Performance mode :Latency
> [   14.015380] megaraid_sas 0000:01:00.0: FW supports sync cache        :
> Yes
> [   14.015388] megaraid_sas 0000:01:00.0: megasas_disable_intr_fusion is
> called outbound_intr_mask:0x40000009
> [   14.037098] megaraid_sas 0000:01:00.0: Init cmd return status FAILED
> for
> SCSI host 2
> [   14.037762] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw 639=
9
>
> Trying to rmmod then modprobe leads to something that looks like stuck
> state or such:
>
> [  570.269770] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
> base_addr(phys):0x00000000fe800000  mapped
> virt_addr:0x00000000f42ba0e1 [  570.269775] megaraid_sas 0000:01:00.0:
> Waiting for FW to come to ready state [  570.269780] megaraid_sas
> 0000:01:00.0: FW in FAULT state, Fault code:0x10000 subcode:0x0
> func:megasas_transition_to_ready [  570.269782] megaraid_sas
> 0000:01:00.0: System Register set:
> (***)
> [  570.269908] megaraid_sas 0000:01:00.0: Failed to transition controller
> to
> ready from megasas_init_fw!
> [  570.269919] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw 639
>
> The motherboard which is not working is a recent one: Asrock X570D4U-2L2T
> with a Ryzen 3900XT.
>
> I've read a lot of things on internet saying that might be CSM issues or
> such
> but no luck with that. On the two working motherboards, it works in
> legacy/UEFI only. I've also tested the card on a x16 or x8 slots, the sam=
e
> result. I've attempted to build megaraid driver provided from Broadcom
> (07.716.01.00-2). Up to a slight adjustment in a log call using older
> attribute
> "host_busy", I'm hitting an unrelated issue due to KBUILD_CFLAGS recursio=
n
> in arch/x86/Makefile.
>
> After hours and hours of testing, I'm currently out of ideas. Does anyone
> has
> an idea or could help me into adding useful debug info in the driver or
> such?
>
> Thank very much in advance,
> Fr=C3=A9d=C3=A9ric

--000000000000c0ac5905bea6eeed
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIN0BYPRb5FHX42JZ7+haVdx0HuqN
QGf79U0g8oTieJqvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDMyOTA2MjQyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAB0I+Yncb1socn4JNVEZniL6mhKeZN2ecr49bhmi9kJkFA
YDtW/u2lHOA05Ro/LJjotSUH3+BvtWbkq5SCYhpJvprjbxKjRQjqRagZqEB8hDwDgMnBUO/aEjMv
teQdT+Rr8ZdxoCqkGNykEi26E/jfrp2QorG0bcws/dFaULtYr7viH3hkU4g06mP2uiGr59hX7/NG
N1tXoQ1bhuBUz2mO21COwEqVDHzbw+s8qkIZYXHCfm0FhIb7SRIbWB9Pd2X9K4nSvJgDHjlv8aS0
nV4EpTqtu7cOhBe3Z73tWz7okGtmMzIVvR/KQZYvxXkvkdjqZd7rym9DMBmv8yK41wXL
--000000000000c0ac5905bea6eeed--
