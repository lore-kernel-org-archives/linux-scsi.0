Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBB6C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 21:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26827208B8
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 21:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZiL6RMCx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgI2Vim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 17:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2Vim (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 17:38:42 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C6C0613D0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 14:33:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y14so4951639pgf.12
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 14:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=81yt8ZHlFhcARm41HNGZ/DZyWQhRW0xQVcOhh7Pi6lI=;
        b=ZiL6RMCxIS0x4e/28fGvgLIO3bc0RWETe02fnjs2DOOThBuu9FWdKQzR+qctXqT4b7
         H4fEszS3FklcqMe2ZX1kig3TWC1MCOrRTJHfaS8+jAgkx8JFqYbjSjFV8L4Hbc+sWHbg
         h30gXTztUthsfuzwzb1vUDXmVUvH3fU7+Ilc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=81yt8ZHlFhcARm41HNGZ/DZyWQhRW0xQVcOhh7Pi6lI=;
        b=rlR2HfF84Ga1n4aZAgZzVDATMFH5mvNxxZva6HW5sjNt8E0/JJEOmUjS7UsO3aYI5e
         ZBJQG553LhimOpy1c7fANPjNYgK7B3d/x3REfAnxN+WRog+aVRj/7S4HNGIvMhP5Z8ci
         tE/SLK3OTb4/4+BWjWvDjAk98+SxZuE4OjoA5mREf/ZZj4N+KujNyFk5j1QaWNJGtbcV
         VwpkNGJHGALv3b4x5zNoj1KtSPQCKR0lQQlGxOXiddVTsnwgeDKHDFZ1kJ5aLpD9rKze
         mhBpmMj1G3L5oJLulD6JHc7xi6lACFpJK4IY6gSaM8o9Kgkn8nccPO0y8LvO0pGlgD/d
         aXhQ==
X-Gm-Message-State: AOAM532ZumoyWIGSThWVckKEpFf9FQkAO1ZZPrlIjIF54PV0PS17jb4R
        yZw0i8F85RYYS7nn5z1PHa1+p7aU4V1Z3oOk14c=
X-Google-Smtp-Source: ABdhPJzipes+rLaQtByVJl6CBRoAQsRne69PwVXOghof2f+F8hkzkw0oooMiAhZTW/SsIUWkK74eCA==
X-Received: by 2002:a65:454c:: with SMTP id x12mr4902263pgr.101.1601415200632;
        Tue, 29 Sep 2020 14:33:20 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z63sm6130938pfz.187.2020.09.29.14.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 14:33:19 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: fc: Update statistics for host and rport on
 FPIN reception.
To:     Shyam Sundar <ssundar@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        James Smart <james.smart@broadcom.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-2-njavali@marvell.com>
 <31d735ac-90d6-a601-0d8e-c15739684d23@broadcom.com>
 <1230F28E-B730-4022-B4CA-6A47C49F15FD@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <a0ace8fd-eaec-bb53-11d1-b686a90e16f4@broadcom.com>
Date:   Tue, 29 Sep 2020 14:33:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1230F28E-B730-4022-B4CA-6A47C49F15FD@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000032e2c305b07a8810"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000032e2c305b07a8810
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US



On 9/28/2020 1:07 PM, Shyam Sundar wrote:
> I am open to removing the accounting against the "detecting" port for now, given that currently, there are no known implementations where the N_Port initiates the FPIN ELS.
> Let me know what you think.

Ok - let's not change counters on the "detecting" port.

>
>      I guess this is ok - but it makes it hard for administrators.  I believe
>      this is the list of the other nports (aka npiv) on the "attached port"
>      that is generating the error.  In that respect, it is correct to
>      increment their counters - but I hope that an administrator knows that
>      may resolve to a single physical port with only 1/N the error count.
>       From our use case in linux, as an initiator, to match an rport it must
>      be a target port using npiv and from our point of view we don't know
>      that they are all sharing the same physical port.
>
> Shyam: I agree. But with the information in hand, I am not sure how we could do this better at this point.

Agree - we'll leave it as is.

>
>      Question: I know we've been asked to log the fpins to the kernel log.
>      Holding on to the counts and so is good, but it still loses some of the
>      relationship of the detected port (what detected what attached port).
>      What's your thinking on it. Should it be something in these common
>      routines and enabled/disabled by a sysfs toggle ?
>
> Shyam: So far, I have been looking at it from the point of gathering and maintain the error stats, closest to the source of their origin.
> So irrespective of if an error was "detected" by the Nx_Port itself, or by the F_Port attached to it, we are pointing the administrator towards the Nx_Port (by accounting for the error and tying it to that port).
>
> Having said that, I do not think I completely grasp the essence of your question here, and your proposal of turning it on/off. Could you please elaborate.

I'm saying that we have no idea who the "detecting" port was in all of 
the statistics. At least, by not counting the detecting port, we know 
that anything that has counters incrementing was generating the issue.   
I don't know how important it is to know the detecting port - if 
switch/fabric, it probably doesn't matter. If an NxPort, it may be 
interesting to know.  We also have no idea if all the counter updates 
occurred in 1 fpin, or in N fpins.    What I was suggesting was to log 
something like "FPIN  <type> <detecting> <attached>", with one per 
descriptor type in the FPIN.  We could default this logging off, and 
change a tunable to turn it on.

However, I feel like I'm trying to hard for this - so let's just ignore 
it. We can always add it in the future.

>
> All the other comments make sense to me. I'll roll them in and send out another patchset shortly.
>
> Regards
> Shyam
>
>
Sounds good.  Thanks

-- james


--00000000000032e2c305b07a8810
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgYq85HLmrq6v+I0g3
ddbJwr/6y3rLMTStWeW4LlSxqpEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAwOTI5MjEzMzIxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAADXMsoPVE4ku9GcfKhv7s/41MfJKk6TY636
zaMHyD5u3B6kPnQRSgXpvwGXRq+QTddht2tm8vO6T6b1vRETnA7Sekwi8oLR3KPSN4rinj4SqNFp
b5qPCP7seSGvitKEIlSfKnUIHLmxB29l5PL1KHZWqjwC3pern0j5uaqD5TrZkq6EE4FI2+Ih98Z7
ilyyaOTwCFJ36TkRlsoeJkxH45Ewmv5JsFOQb9pONt2Wdg7O2ZdxCAFN1hb9U7pU77MVOUIARCdE
X3/zb2sMseB03J7OwYvFROQvwzVtwqiKbYZnanl2l8AYxSWOaOeA2t8SgsHehkj5du2co3zs7hzV
yC8=
--00000000000032e2c305b07a8810--
