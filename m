Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF9BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 08:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240917AbhLOIpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 03:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240907AbhLOIpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 03:45:54 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0FDC061574
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 00:45:54 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id m25so21031401qtq.13
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 00:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=2ffxAKqul4eHaY0viqzbCI9asaVFdO8r13/5eli51f8=;
        b=UbHC4jn/54TY8BEixw7cq8dRV7xyBhXYEzijmSTU0u+DeBumRY7I/o0gLpHLXidkEc
         BUfH1+Bw+oPJIyqTkLxb+dg8Fdep9ZstxtoY1i5qujeYCUd1FpebUonYniadMbMi+9dN
         KMeDz/o5RISDlgvNOg+Ng4rP57q7DCkszRV1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=2ffxAKqul4eHaY0viqzbCI9asaVFdO8r13/5eli51f8=;
        b=DdV9BtobpbfsNQzJCVQtEDLWKxQByks2GjsqpPiZrr3SEj7l/WdRfiA2k6PjO37dn9
         a4XGD135Qsy+F8Ga+pOuH86PLRr66i2lPRTSI1sRP2zWhfdijorE/hJqYTF6VNhFudJd
         UDG2w0urFEk0X2HA8nEpewkMpE+x3totSxkahDwOCYFEshba8CGTUFOxZwCvy09JtHzr
         NSFW8QQUSpdf8jh4/0L/i0biWu51BrQFllAm8lOFbMcf6t2jsC/4c7TKjo1Ew/6p5Bbi
         /CPC63ud57ZZQlIA85cWy0x8zc10OMvDIw08C6dB2V7vGxWva6WIIXB8Q/+5tS3d5Cal
         P57w==
X-Gm-Message-State: AOAM5329IEJXNtIu4kcvwss7mhiAIjJU3YiYZZqzkFAKR++ihlip8ELd
        vcseVXLBiePB2EOQnFbWWbPkTJRMprwcZH5VHdZGNQ==
X-Google-Smtp-Source: ABdhPJyHvNQ+c2OOK4dayy6nGlwQPW5zIP3LMw/zLAshnW0e2lGpMBJ/VUcX8dfuElb6aT+tlMppdx0bnOZK6ZoAZOg=
X-Received: by 2002:a05:622a:1902:: with SMTP id w2mr10540984qtc.401.1639557953379;
 Wed, 15 Dec 2021 00:45:53 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210906065003.439019-1-ming.lei@redhat.com> <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
 <YblitnLqJtkK/xBt@T590> <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com> <YbmhDNrnVLcfbK/l@T590>
In-Reply-To: <YbmhDNrnVLcfbK/l@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQCw9RdeG8B11ACtJOqN2MhOUMiBIQFcykQ1AY8PSusCS4w5QAGYevsErkqv0SA=
Date:   Wed, 15 Dec 2021 14:15:51 +0530
Message-ID: <3065cf1a25a99a2dd89e9065d679410e@mail.gmail.com>
Subject: RE: [PATCH] blk-mq: avoid to iterate over stale request
To:     Ming Lei <ming.lei@redhat.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006a546f05d32b55d3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006a546f05d32b55d3
Content-Type: text/plain; charset="UTF-8"

> >
> > shared_tags->rqs[5] of hctx0 is having scmd = 0xAA (inflight command)
> > shared_tags->rqs[10] of hctx0 is having scmd = 0xAA (inflight command)
> > <- This is incorrect. While looping on hctx0 tags[], bitmap = 10 this
> > entry is also found which is actually outstanding on hctx1.
> > shared_tags->rqs[10] of hctx1 is having scmd = 0xBB (inflight command)
>
> Sorry, I am a bit confused, please look at the following code and
> blk_mq_find_and_get_req()(<-bt_tags_iter).


My issue is without shared tags. Below patch is certainly a fix for shared
tags (for 5.16-rc).
I have seen scsi eh deadlock issue on 5.15 kernel which does not have
shared tags (but it has shared bitmap.)

>
> void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>                 busy_tag_iter_fn *fn, void *priv) {
>         unsigned int flags = tagset->flags;
>         int i, nr_tags;
>
>         nr_tags = blk_mq_is_shared_tags(flags) ? 1 :
tagset->nr_hw_queues;
>
>         for (i = 0; i < nr_tags; i++) {
>                 if (tagset->tags && tagset->tags[i])
>                         __blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
>                                               BT_TAG_ITER_STARTED);
>         }
> }
>
> In case of shared tags, only tagset->tags[0] is iterated over, so both
> 5 and 10 are checked, and shared_tags->rqs[5] and shared_tags->rqs[10]
> shouldn't just point to the two latest requests? How can both 0xAA &
0xBB be
> retrieved from shared_tags->rqs[10]?

Since I am not talking about shared tags, you can remap same condition
now.
In 5.15 kernel (shared bitmap is enabled but not shared tags) -
blk_mq_tagset_busy_iter is called for each tags[] of nr_hw_queues times.
It will call  bt_tags_for_each()  for hctx0.tags->[], hctx1.tags->[] ..
Since tags->bitmap_tags is shared when it traverse hctx0.tags->[], it can
find hctx0.tags[10].rq which is really stale entry.
If the same request which is stale @ hctx0.tags[10] is really outstanding
at some other tag#, stale entry will be counted in host_busy.

>
> > Issue noticed by me is the exact same issue described @ below -
> > https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-5c10539492c
> > b@hu
> > awei.com/
> >
> > Issue is only exposed to shared host tagset. I got the required
> > information. Thanks.
> >
> > Kashyap
> > >
> > > > count total 2 inflight commands instead of 1 from hctx0 context +
> > > > From
> > > > hctx1 context, we will count 1 inflight command = Total is 3.
> > > > Even though we read after some delay, host_busy will be incorrect.
> > > > We expect host_busy = 2 but it will return 3.
> > > >
> > > > This patch fix my issue explained above for shared host-tag case.
> > > > I am confused reading the commit message. You may not have
> > > > intentionally fix the issue as I explained but indirectly it fixes
> > > > my issue. Am I
> > correct ?
> > > >
> > > > What was an issue reported by Luojiaxiang ? I am interested to
> > > > know if issue reported by Luojiaxiang had shared host tagset
enabled ?
> > >
> > > https://lore.kernel.org/linux-scsi/fe5cf6c4-ce5e-4a0f-f4ab-
> > > 5c10539492cb@huawei.com/
> >
> > I check this. It is same issue as what I am seeing on Broadcom
> > controller only if shared host tagset is enabled.
>
> But 67f3b2f822b7 ("blk-mq: avoid to iterate over stale request") isn't
only for
> shared tags.

I mean, shared bitmap in my whole discussion. Megaraid_sas driver use
shared bitmap, so it is exposed and It is confirmed from this discussion.
Do we still have exposure (if "blk-mq: avoid to iterate over stale
request" is not part of kernel)  to mpi3mr type driver which does not use
shared bitmap but has nr_hw_queues > 1. ?

Kashyap

>
>
>
> Thanks
> Ming

--0000000000006a546f05d32b55d3
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMOJFF7yumtcU4Lzi580cO6epAZT
nneAHt8NhTNl6d7JMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MTIxNTA4NDU1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAoiGI7Hp/WjyW3QNj10wwVMyZXYyuHQtOMus1oaQeQjECi
IJ8NpH7CZk3lTXHjErai8R44u11uXsbXOXzthjUOz8yA0e0jMGrZZhLj07J/TlQgVES/TwcXyqtx
dz1TCx1a8cMwOIa+C8GidEXfXZ5F26zDPvqxjH4BCLum/dE1VgilUfyIRNBNF6FaeNDy9qO4Fxm9
AFAEErnhoTDv4/rpXc46MqiTYFxGeSQXthmDr+8Qv44zVgW1uyvDjhJmvm1BF56v0DmNcgFP+jkF
ZaSSltLxbWwBl30Ju9HeecZEkccb7DXHUoXeMXJFFZC7cL6n5R52DT8t9D2FVKjwZT7m
--0000000000006a546f05d32b55d3--
