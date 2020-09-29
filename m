Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E611C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 15:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71C820773
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 15:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E0huqZxT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgI2PAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgI2PAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 11:00:54 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA431C061755
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 08:00:53 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x69so5899271lff.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 08:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1GwQ+UmSgBap2xDJOnlv0tajv/XZJKozGCp6WRyJA+Y=;
        b=E0huqZxTemJT8q5ekV8j9JatNb0X8V3XeeiG4rz7zc6gVlmghArbHGk2vpAzTXTT1d
         X50Ko4ngF0k8tlzW4eg1SxvZu29OhkWFfWeQ5v9mqEQrgp0J99kWv3aNrOd+iMEXWMl5
         n0iTw2NI6U9ustY9x4I6fAV47pInuXYNeOXvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1GwQ+UmSgBap2xDJOnlv0tajv/XZJKozGCp6WRyJA+Y=;
        b=UE7MhOfbslzzulA288dXRO6oBgmo00RHnRcGE9KKy8TozKKHBjfUOZgxHNxSTzO1Rl
         mJGt/4VB9/TkmpC+JFKpBG3JUiHSFjY86kGMansvrWwA9ArgG0PCBrdAObU5pus5YPXj
         bla+t+cDG90SMZnzqwt7txoObVevk7J2Lsjws4VMrlUU7uWSFmuNUey9UEpyfiYNso9b
         +9uSWGaJFdPCKGkaKn86HRYd56oUp4smIj8YMoQPIeK60f2IqeF5aSHAEtntONXW97b9
         BEKtjnUJlMphtacI8L4tdj2J+XdeOKi9u0rdU5KexyMnCBPtN5H/u5rVkld8RjWqq9dP
         pHug==
X-Gm-Message-State: AOAM533//1SL9bH/OddwYUEorbbE5nupljpLW1CmfN0+epVuPl4OD07a
        fKEQybfHl2qKnnR+YOo406raviJ74nnCZ5AscpbHLg==
X-Google-Smtp-Source: ABdhPJxEHyDy00WcdrbfotlHD3Q7FCmAloojn4cg/jh4xdAC8Ee0P9M7+RRYxzVHXg7Vi2zSED5ynTzNXDpP2wPJmkU=
X-Received: by 2002:a19:4344:: with SMTP id m4mr1520453lfj.181.1601391652060;
 Tue, 29 Sep 2020 08:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <CALnajPCsBkOnogZHF30g1XnAs6jLzGTQmsL4RyCA-ReHv=3ANQ@mail.gmail.com>
 <CA+RiK648dzV=sAEV03VrpEmLoxZnHcBHkmUbP0Q3wdBvCQ6YGQ@mail.gmail.com>
 <CALnajPDYZs+gPY8eN7thyYGyWu2j4W1uBN63LDyYwmjJtVb0vA@mail.gmail.com>
 <CALnajPAXKzBCprU0s2i7XMtLaDDYqmUXf+9cRFzw_Z3Wjn14BA@mail.gmail.com> <CALnajPBXsXgqWOth+ABF_HgLVPjQSESZ1w-wwmNZnvbaXfgsUQ@mail.gmail.com>
In-Reply-To: <CALnajPBXsXgqWOth+ABF_HgLVPjQSESZ1w-wwmNZnvbaXfgsUQ@mail.gmail.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Tue, 29 Sep 2020 20:34:52 +0530
Message-ID: <CA+RiK64a9Tj3orj6uQ4eNb1o2T--mwcwdsF1n6POLG++6oeQtw@mail.gmail.com>
Subject: Re: Bug 209177 - mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
To:     Sundar Nagarajan <sun.nagarajan@gmail.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000973b9005b0750c22"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000973b9005b0750c22
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sundar,

Please check if below two patches are available in the mpt3sas driver
you are using.
If you are seeing issues with these patches applied (Or) If your
driver is already having mentioned patches, provide us driver log with
"mpt3sas.logging_level=3D0x3f8=E2=80=9D.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/scsi/mpt3sas?h=3Dv5.9-rc4&id=3D61e6ba03ea26f0205e535862009ff6ffdbf4d=
e0c
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/scsi/mpt3sas?h=3Dv5.9-rc4&id=3Df56577e8c7d0f3054f97d1f0d1cbe9a4d179c=
c47

I could see these patches in 5.8.12
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drive=
rs/scsi/mpt3sas/mpt3sas_base.c?h=3Dv5.8.12.

Thanks,
Suganath


On Tue, Sep 29, 2020 at 4:18 PM Sundar Nagarajan
<sun.nagarajan@gmail.com> wrote:
>
> Sorry if I am mailing too many people.
> Copying additional people in the hope that someone has the time to guide =
me on how to report, debug and fix this bug in the 5.8 kernel.
>
> bugzilla.kernel org bug report:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D209177
>
>
>
>
> On Tue, Sep 22, 2020 at 7:08 PM Sundar Nagarajan <sun.nagarajan@gmail.com=
> wrote:
>>
>> Any guidance on how I should go about trying with the 35.100.00.00 drive=
r?
>> In particular:
>>
>> Which patch do I apply?
>> Which kernel version do I apply the patch to?
>>
>> Regards,
>> Sundar
>>
>>
>> On Thu, Sep 10, 2020 at 10:51 PM Sundar Nagarajan <sun.nagarajan@gmail.c=
om> wrote:
>>>
>>> Hi Suganath,
>>>
>>> Thank you for the quick reply.
>>>
>>> I am a bit of a newbie in pllying linux kernel patches etc.
>>>
>>> Would I apply this patch to the stock (5.8.8) kernel.org kernel:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=
=3D5.10/scsi-queue
>>>
>>> Sundar
>>>
>>>
>>>
>>> On Thu, Sep 10, 2020 at 10:46 PM Suganath Prabu Subramani <suganath-pra=
bu.subramani@broadcom.com> wrote:
>>>>
>>>> Hi Sundar,
>>>>
>>>> Can you please try with the latest driver 35.100.00.00. =3D> "https://=
git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=3D5.10/scsi-qu=
eue"
>>>> This has fixes related to "RDPQ" scsi: mpt3sas: Fix reply queue count =
in non RDPQ mode.
>>>> scsi: mpt3sas: Fix memset() in non-RDPQ mode.
>>>>
>>>> Thanks,
>>>> Suganath
>>>>
>>>> On Fri, Sep 11, 2020 at 10:00 AM Sundar Nagarajan <sun.nagarajan@gmail=
.com> wrote:
>>>>>
>>>>> I am new to reporting linux kernel bugs.
>>>>> Apologies if this is sent to you in error.
>>>>> I got your email using: `perl scripts/get_maintainer.pl -f
>>>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c` as indicated in
>>>>> https://www.kernel.org/doc/html/latest/admin-guide/reporting-bugs.htm=
l
>>>>>
>>>>> bugzilla.kernel org bug report:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

--000000000000973b9005b0750c22
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgQ05m6K0lkF7oTlH+4fW16OgT3UYVHjsR8DmOUAJO
zQMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwOTI5MTUwMDUy
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAKvXhOrFHR7kjfEf98PvXlGCgw6xWATkzNBdngy5qHLZAb6IfAo3TP2qUXcw
ahzqRe8lIElxFjbNC+EpAU3v40NbP2Oh9FaYNwRbZUbcQSPS/bM5NX4NFAB+zlmhSxze8lPIs572
S3zliMUKDS3RZNDYhpMgVAd0Ee0JNxuFON7J3aZ9WY2A5sWEbkhgxLQyrOJz+C1lOba2j5WT8uLF
SFyV8p8jYOzLpPp0kUeC7GlFYGDQJy8ZTiAoecGXNZAKxaHPaOmWqXBNixkW66isfTUCXs2pJPIu
DfM4xQ3BXf4sMoTovpN0B2R+Q56TeqD0PJPOV1+ynxb9AfVsB+ksxRA=
--000000000000973b9005b0750c22--
