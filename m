Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA16EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943C623104
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbhALLpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729397AbhALLpm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:45:42 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB281C061575
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 03:45:01 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c14so1348750qtn.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 03:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=1T0idZqMLc4DRMAHGZJABDEvVBVpes26TM0gIni7kec=;
        b=cTEMhq9PpQfT99szXxMpYRG2va207NoINq1axKqBEdm4BaI0dIi2wev4m4seFfU2+s
         iNv3Pr7GVSgs3NfyLReX65aDgnRy+EQ+7hlfv+KmvqPjJuMuGvob9Yfa0dMxYgkLPiC1
         OEHmBBGo+pFgsEyef0AARh7s3zn0HV+hgIHhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=1T0idZqMLc4DRMAHGZJABDEvVBVpes26TM0gIni7kec=;
        b=hxOplnExuBGpCmOG/4iApMsUAZIwwziylNXLYrgv7u9gTek0E2a0xkOf2t1+l2du8R
         UyLnHg8k7Ij6sPocp1CPsR/soRwSvn4hfd4Yfdj25CawRYPNO/yh3JIW0lr63t8gKv0Q
         OxHXbNDeqD1HEeItiFJ3NZmFaeccR5POno1gMiAYdizeMBCHkgPNVWloiH4Pq/3gJg95
         e1e1/W4LwN9kp/ThqSrffV2zKdhDjQ9NIMgzA8O28xEfSqrdEs9jkcZO+MDq0RCAr4aq
         AvsRfliHirNo07DKBrVBRhFuTtHCsQb6LxQ3bbEfaZjVvvGYcrp7HJ67/WKiVR/MmttZ
         vLUg==
X-Gm-Message-State: AOAM530ebGyogsd6BZgGSD6FCp7BGXQPrPkjSr9viwSvL2z6WWs02MVa
        f6oGDm9BkPjSm6oTVk17mmakp2+oy/Bqjx4vGI2ZgvTbUWOp7X6uupdfBA3brisYJpePQAr5j3x
        3/aPSzx1EEZahYeFf+eX6fe/ljf73
X-Google-Smtp-Source: ABdhPJxcGt8kNXlOAzJKK+ROgZALMntqhSeknsdLrB9uz+137yiY46AgH3Yala2L5E0tQY2rOBJmmrxfvM07bwXqaDA=
X-Received: by 2002:ac8:6f4f:: with SMTP id n15mr4175457qtv.216.1610451900954;
 Tue, 12 Jan 2021 03:45:00 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <20210112014203.GA60605@T590> <4b50f067-a368-2197-c331-a8c981f5cd02@huawei.com>
 <20210112090634.GA97446@T590> <e5832d8b-383c-9734-85a1-6f36bdb5a773@huawei.com>
In-Reply-To: <e5832d8b-383c-9734-85a1-6f36bdb5a773@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLK1Tl3n9fZXq51bK89gKniZzGk2wIkQ7HVAdrZcb8B5o4EcAGH6ytZqACXHwA=
Date:   Tue, 12 Jan 2021 17:14:58 +0530
Message-ID: <7a342a60943cd7ed28d319b189c105ba@mail.gmail.com>
Subject: RE: About scsi device queue depth
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000082045005b8b28dc5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000082045005b8b28dc5
Content-Type: text/plain; charset="UTF-8"

> On 12/01/2021 09:06, Ming Lei wrote:
> >> OPs read. Here's the fio script:
> >>
> >> [global]
> >> rw=read
> >> direct=1
> >> ioengine=libaio
> >> iodepth=40
> >> numjobs=20
> >> bs=4k
> >> ;size=10240000m
> >> ;zero_buffers=1
> >> group_reporting=1
> >> ;ioscheduler=noop
> >> ;cpumask=0xffe
> >> ;cpus_allowed=1-47
> >> ;gtod_reduce=1
> >> ;iodepth_batch=2
> >> ;iodepth_batch_complete=2
> >> runtime=60
> >> ;thread
> >> loops = 10000
> > Is there any effect on random read IOPS when you decrease sdev queue
> > depth? For sequential IO, IO merge can be enhanced by that way.
> >
>
> Let me check...

John - Can you check your test with rq_affinity = 2  and nomerges=2 ?

I have noticed similar drops (whatever you have reported) -  "once we reach
near pick of sdev or host queue depth, sometimes performance drop due to
contention."
But this behavior keep changing since kernel changes in this area is very
actively happened in past. So I don't know the exact details about kernel
version etc.
I have similar setup (16 SSDs) and I will try similar test on latest kernel.

BTW - I remember that rq_affinity=2 play major role in such issue.  I
usually do testing with rq_affinity = 2.



>
> Thanks,
> John

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

--00000000000082045005b8b28dc5
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgM83Rfymm
BwrZoepbJHoVWH/T8+O7Gk6b9wFeSfTGAi8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMTEyMTE0NTAxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFfl9vnITTX9mww7ebE+VEicBimh
DbNjNKXITNX5TFnvGvDT/Q7/k4xgOnr7u5wUdQ5YobAx/5g9rnf20islUcyLCt1xjXvRUFPmaoER
bo1alyq1aDyxPEa1onfwrAQuCc73CPlmnov9tHu2q1WR7p5EoxO9EanbfpSli2wgF803NgS3LquT
soKeGlXd2l6XVl6QRbUV4dC73jx3RCrKfm8U87EGT0wJb5IoByc1Kc3edBsyh6ZGnL+lb5CSSDNN
0MxX4CT1t899JWGZoVvRiLoe/ktnFQbyajRkOd+Ojf8AYf3UcVMnNfyINLmQIW7BGutKFpEctkPO
pQ55ENG1XzA=
--00000000000082045005b8b28dc5--
