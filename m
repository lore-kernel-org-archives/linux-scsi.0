Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BA0C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 12:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4864221E3
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 12:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAKMQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 07:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbhAKMQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 07:16:14 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA0DC061786
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 04:15:33 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id w79so14347162qkb.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 04:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to;
        bh=cElkeEp+CDfnuvlwPZwm1bl4OFQ8I7cUOplthJZCRrU=;
        b=FRCUxMaTfckcdVWgPXv0R8KqdoVY7ljLbdCWr5dfrHMJvV1YN71W+vcjdhlJZL8frj
         cP4wKdvXoILWuXptzWV9UHNZC+PZW29xPS9SA/9jwJVsuNQ3r3LsD/I+C6XiAbQvXJiz
         uI8ARHExeQqSci+/nJSC1jI8tyG7hTP5kwYLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to;
        bh=cElkeEp+CDfnuvlwPZwm1bl4OFQ8I7cUOplthJZCRrU=;
        b=Wy09YLBNIFTn+Hr8ayzxczJgzno74yaqwe7/V0QSEimujP2vuTcy6VsuIN9biD9b3f
         0Q6gSC1f6ii5xHYzewGtd+jo81Do6aoX/O2g6DZh6rXnx1AeuofBb4juLlPSg0qSzvUB
         Pcy9MgexLlFV/85Ld/BWSNDybibpPV2flVb+I23YaIz+cNacrI7+I986fejqKDGcIJPr
         F8d27T3V77xxJ/ubCVwAeCUguRMmW/MlXzWmewhzSZ5T92UjHMr4JCjCSx5fzUXdlUYJ
         2T4diURO+MnyfU0AZEDBuZZ5omOqEzrjA3JKpIqJylaXPTwmXZUfEQ9mU+SjSuqFCHle
         SUGg==
X-Gm-Message-State: AOAM533zVslFROjBxIb0nQIYac+OGMp7bE3lrjukKR0kB+K5TIIAsonj
        6yR6dV7qn0p+CpAMNScUg8WigYG043CLuCkb5WICm8FjkbOVB0oVW8NddItSmssTRwAIlJ32DFl
        9LPRcapVYGyvJ4B/YhPN5sEBl161oiHKVkmja
X-Google-Smtp-Source: ABdhPJzd4eJ2gGWm3DifIqxI9zQvmzlQpQ/UDbnrQBZPz/oYj/D1dcxJp9HPlVG5+u8d/X+/Fd4gc8hmeaQdhQeI+co=
X-Received: by 2002:a05:620a:69c:: with SMTP id f28mr16012498qkh.127.1610367332388;
 Mon, 11 Jan 2021 04:15:32 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201203034100.29716-1-kashyap.desai@broadcom.com>
In-Reply-To: <20201203034100.29716-1-kashyap.desai@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHOEf3M/0CyAu39AtgNSQNXwBT1dKo0AZiQ
Date:   Mon, 11 Jan 2021 17:45:29 +0530
Message-ID: <af1ef280ded61be8ec5882b7a3b99ef9@mail.gmail.com>
Subject: RE: [PATCH v2 0/4] io_uring iopoll in scsi layer
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d3351805b89edcf3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d3351805b89edcf3
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

Due to some issue in RCU lock (only in debugging environments),  there was
booting issue and shared host tag support of megaraid_sas driver is revert
backed in 5.10 -
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit
/?id=1a0e1943d8798cb3241fb5edb9a836af1611b60a

== Commit message ==
It turns out that it causes long boot-time latencies (to the point of
timeouts and failed boots).

The cause is the increase in request queues, and a fix for that is queued
up for 5.11, but we're reverting this commit that triggered the problem
for now.
==

Can you include this patch set for 5.11 ?  I see (origin/5.11/scsi-queue)
has below change set. It looks like you have already queued up "shared
host tag feature for 5.11"

git log --oneline drivers/scsi/megaraid/
498854102c1c scsi: megaraid_sas: Update function description
977001df0368 scsi: megaraid_sas: Use generic power management
8ed9d987c6d9 scsi: megaraid_sas: Drop PCI wakeup calls from .resume
bba84aeccafb scsi: megaraid_sas: Simplify compat_ioctl handling
381d34e376e3 scsi: megaraid_sas: Check user-provided offsets
55e0500eb5c0 Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
103fbf8e4020 scsi: megaraid_sas: Added support for shared host tagset for
cpuhotplug
62aa501dc9dd scsi: megaraid: Make smp_affinity_enable static


Kashyap

> -----Original Message-----
> From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
> Sent: Thursday, December 3, 2020 9:11 AM
> To: linux-scsi@vger.kernel.org
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Subject: [PATCH v2 0/4] io_uring iopoll in scsi layer
>
> This patch series is to support io_uring iopoll feature in scsi stack.
This patch
> set requires shared hosttag support.
>
> This patch set is created on top of for-next branch of
>
https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux-block
>
> v2 ->
> - updated feedback from v1.
> - add reviewed-by & tested-by tag
> - remove flood of prints in scsi_debug driver during iopoll
>   reported by Douglas Gilbert.
> - added new patch to support to get shost from hctx.
>   added new helper function "scsi_init_hctx"
>
> v1 ->
> Fixed warnings in scsi_debug driver.
> Reported-by: kernel test robot <lkp@intel.com>
>
> Kashyap Desai (4):
>   add io_uring with IOPOLL support in scsi layer
>   megaraid_sas: iouring iopoll support
>   scsi_debug : iouring iopoll support
>   scsi: set shost as hctx driver_data
>
>  drivers/scsi/megaraid/megaraid_sas.h        |   2 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  90 ++++++++++++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  43 ++++++-
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   3 +
>  drivers/scsi/scsi_debug.c                   | 130 ++++++++++++++++++++
>  drivers/scsi/scsi_lib.c                     |  28 ++++-
>  include/scsi/scsi_cmnd.h                    |   1 +
>  include/scsi/scsi_host.h                    |  11 ++
>  8 files changed, 294 insertions(+), 14 deletions(-)
>
>
> base-commit: 0eedceafd3a63fd082743c914853ef4b9247dbe6
> --
> 2.18.1

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000d3351805b89edcf3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQggO4DHN0X
rNSGz7Lw7YqgpPYF4qmviLoPfHFS9bbkFKowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMTExMTIxNTMyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAI0aQBNbWucZmXn4Oa18u64DsxUj
la0R3O+Hufzf2L5mFvwUGkLsmf3tDkNFY83q5TPpiEVEvdFa/nnq1anJjHGlzA+x1keba7GDNAgT
hzstuX65NiBWDi6jo/9EfJFgn0HOuiFYQqJae2344XNhtU9+uebNpcpWZ6W3my2X7bn93Hb/rYkY
aFMeyMDoIy3TvYEeXhIBVpx3EjEUbCl51kDGURaBZ5sKqhr+G6tHftHQlUWClfdgLCW7XN/xH/tK
ArzeLgLAwk21mY0DfOV6j1xuq1GZO6bpbjVHyn2zVMa7iKbqLipamnEBWy/+19soz/bYucIP5jFD
6AhT4Qd/gss=
--000000000000d3351805b89edcf3--
