Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD810C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Dec 2021 11:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhLPLzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 06:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhLPLzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2021 06:55:43 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1B8C06173E
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 03:55:43 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id t6so23067175qkg.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 03:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=LN+tSu+8oB9sbkjm5MbXzSED1k0q/68ucoEUIMFZYkE=;
        b=R6CCqQe4rlUxGNVFOL8NKZp/tBGf6Ol6fJR2UwKK6NdlXzS1h0ug7UXCdYTcJ0Qf1d
         ItvUWQp+THFIFYspidKGN236ly9opBuLcYj5LIaXKoW81zv93254vMOxGg15bfcatkxn
         pAwsy/pSMb32ZJY9uHK5g0Rw438XPVsmudyjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=LN+tSu+8oB9sbkjm5MbXzSED1k0q/68ucoEUIMFZYkE=;
        b=5P1BsrCEbDUTRz8UBaZAge9YyGxaqBQkJlcD0Ql5d5MnPuDw0nJkH0CHeBcqi/JG5x
         0JgmTzy2SFS0dh5UkexuOpV6yZCBufPb6vuJ11a2Ys3VQBgnwSc5gdxwvaHrhgaH8wN3
         SQB8/w1ksy9SGzIiljkAb7o8WnUOQ7nIRw+ZnYVumINiuz5Q4m5opqc5wff1nooubMxq
         TpftLLnp6WYVpU48WG55fOjPvdQvExBcK1SZ8CiRZu/L0P0BBjeDrgZ6rQ9ZrECqeGF9
         4xXUa1FOUzoovj+q06QdEhKFdMnGkipc/TE1o9pcwO4W8aFMu6GMnfJN3yziON/xcjrg
         EUcw==
X-Gm-Message-State: AOAM532+cwJn9Uw101Lg4vyMiQidESTfNWVCqdDJllN+k6IWawD2K36t
        LjdGKDzc1PDUd6tpCU4S6N6eYsPmkGy/23RoW5mdeg==
X-Google-Smtp-Source: ABdhPJwA4rhyjxGY7MO/VTHtF8GYgH8uzQjHS09M9Ei25sT6b1dkurABd9+RmwsEqXpJ5IXI2pMlBaYJ6BqftksdZQM=
X-Received: by 2002:a37:4047:: with SMTP id n68mr11395251qka.346.1639655742664;
 Thu, 16 Dec 2021 03:55:42 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210906065003.439019-1-ming.lei@redhat.com> <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
 <YblitnLqJtkK/xBt@T590> <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com>
 <YbmhDNrnVLcfbK/l@T590> <3065cf1a25a99a2dd89e9065d679410e@mail.gmail.com> <YbnmD6yW1v7YWizf@T590>
In-Reply-To: <YbnmD6yW1v7YWizf@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQCw9RdeG8B11ACtJOqN2MhOUMiBIQFcykQ1AY8PSusCS4w5QAGYevsEAYBQr3wCBMUVBa4wVDZQ
Date:   Thu, 16 Dec 2021 17:25:41 +0530
Message-ID: <7518aac238de9a2c2ec3f857c43dd2e9@mail.gmail.com>
Subject: RE: [PATCH] blk-mq: avoid to iterate over stale request
To:     Ming Lei <ming.lei@redhat.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001caa6405d3421ada"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001caa6405d3421ada
Content-Type: text/plain; charset="UTF-8"

> >
> > I mean, shared bitmap in my whole discussion. Megaraid_sas driver use
> > shared bitmap, so it is exposed and It is confirmed from this
discussion.
> > Do we still have exposure (if "blk-mq: avoid to iterate over stale
> > request" is not part of kernel)  to mpi3mr type driver which does not
> > use shared bitmap but has nr_hw_queues > 1. ?
>
> Not sure I understand your poing, but patch "blk-mq: avoid to iterate
over
> stale request" can cover both shared tags or not.

I agree with all above reply.

My query is for mpi3mr driver which is not calling "host->host_tagset =
1;", but nr_hw_queues are more than 1.
Current <mpi3mr> driver is nvme style interface. nr_hw_queues  > 1 and
host->host_tagset = 0.

Is this patch  "blk-mq: avoid to iterate over stale request" is applicable
for <mpi3mr> driver ?

Kashyap

>
>
>
> Thanks,
> Ming

--0000000000001caa6405d3421ada
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKht0jsilwey7j6VyRmpUm/qNf4E
bf8fSxbn9PCZpHMOMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MTIxNjExNTU0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCD6e/e8qu2xh1+I+PE0KTvCr5vhG37CDjRtyB59aa79POd
0G7Gnqlc8IAQy5K+7ulfWfWlLYET9qe39QhOEzPyV3jpeFRAW3gt5RrNcCsqRaWiZk59LC1IMihr
3xyZPLjivCNz3dn+Of8hsiqBq0ycGRsrAafBPuIN20Q35S4tjxTCKrpy6JTE5VEAfIbcNLe46VUb
wOavv0sqgSX68V9VAOO6sEk2eCt0nFt6VkPPaHielIDSMZP0kGBio2G2+Ygf6wF8XU6p99QnabTY
nsrJqdclc2yTr5utDe/N6pm1hExUWddYUb+zFzu7aDEK7fWTKqyJX5Hv+yF5gDnRS3zZ
--0000000000001caa6405d3421ada--
