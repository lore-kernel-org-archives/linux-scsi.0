Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8618BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 18:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbhLNSlR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbhLNSlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 13:41:17 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C327C06173E
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 10:41:17 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id i12so18081421qvh.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 10:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=WON+ErZ0AZmFaxybB002PvtrOAiFXyUoDekWPa8ylv8=;
        b=ZRTuxP8qMiyc9brqLaUfGzRVpTMVcBGH1tMMqfKXbwxIW0d0DOfxNxWdEDGf7B1BPs
         YlqgHCcC0aJ6L1GRBPL/b+XqZtGrWY/1TO1N1cXUwEFtsILwjkC+7NdOJTJF5pOpPcVT
         WvbP1/YOXVXp29fVptsweSbw1PT7wopz6oiY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=WON+ErZ0AZmFaxybB002PvtrOAiFXyUoDekWPa8ylv8=;
        b=NxIYrrjULTD4N+hQXsoK44Rj6Gl3DZNK7te3dsPyMf2SUArdEpH9zmxew/xUgP/V6e
         4mDHUEuB7zJ2MfZcekUTzuW0UAdG36/gLCDewa4ZSFGEuue3TxvCuM0VaOfoC4rq+E4m
         RF2vhLSie8JRHaNwY84nWrtCJ3pEHQSro7CrljeSz03podGxSvnK7xR5Pjhkg1rLSPMJ
         8mOG2IDGVaa+ul6MT8HOnJiFx0lqUV+MQLCM+MPmXwdDEgaqZmrYdMK/PwIC78Zy5+Wk
         cAhQHtOOHKt0azO5RqoLpGah/yKtMxTuxn/RfRaYxMjYY3kA2H/qx2U7ARSrUYFtCmpC
         RXDQ==
X-Gm-Message-State: AOAM53341NYKvEeqd0fkLKh81UpEgP2eBqiTkInZry5sH1af4jr6nTHA
        A8NL3Vk/DumW3v8dZ3Y75YRgMCqEG/loUQWrmpuQcw==
X-Google-Smtp-Source: ABdhPJzdWdT6fkUlsCkUoy0Cm/mlOpmp5mPLdWalI2L8LEaklpwBLhB0XgwKmsngd1yv+VSkDnA3FFUd0DiFzXTHCys=
X-Received: by 2002:a05:6214:21e3:: with SMTP id p3mr7244873qvj.93.1639507275925;
 Tue, 14 Dec 2021 10:41:15 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210906065003.439019-1-ming.lei@redhat.com>
In-Reply-To: <20210906065003.439019-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQCw9RdeG8B11ACtJOqN2MhOUMiBIa6AQIaA
Date:   Wed, 15 Dec 2021 00:11:13 +0530
Message-ID: <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
Subject: RE: [PATCH] blk-mq: avoid to iterate over stale request
To:     Ming Lei <ming.lei@redhat.com>, luojiaxing <luojiaxing@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cfec3b05d31f88bd"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cfec3b05d31f88bd
Content-Type: text/plain; charset="UTF-8"

+ John Garry

> blk-mq can't run allocating driver tag and updating ->rqs[tag]
atomically,
> meantime blk-mq doesn't clear ->rqs[tag] after the driver tag is
released.
>
> So there is chance to iterating over one stale request just after the
tag is
> allocated and before updating ->rqs[tag].
>
> scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
in-flight
> requests after scsi host is blocked, so no new scsi command can be
marked as
> SCMD_STATE_INFLIGHT. However, driver tag allocation still can be run by
blk-
> mq core. One request is marked as SCMD_STATE_INFLIGHT, but this request
> may have been kept in another slot of ->rqs[], meantime the slot can be
> allocated out but ->rqs[] isn't updated yet. Then this in-flight request
is
> counted twice as SCMD_STATE_INFLIGHT. This way causes trouble in
handling
> scsi error.

Hi Ming,

We found similar issue on RHEL8.5 (kernel  does not have this patch in
discussion.). Issue reproduced on 5.15 kernel as well.
I understood this commit will fix specific race condition and avoid
reading incorrect host_busy value.
As per commit message - That incorrect host_busy will be just transient.
If we read after some delay, correct host_busy count will be available.
Right ?

In my case (I am using shared host tag enabled driver), it is not race
condition issue but stale rqs[] entries create permanent incorrect count
of host_busy.
Example - There are two pending IOs. This IOs are timed out. Bitmap of
pending IO is tag#5 (actually belongs to hctx0), tag#10 (actually belongs
to hctx1).  Note  - This is a shared bit map.
If hctx0 has same address of the request at 5th and 10th index, we will
count total 2 inflight commands instead of 1 from hctx0 context + From
hctx1 context, we will count 1 inflight command = Total is 3.
Even though we read after some delay, host_busy will be incorrect. We
expect host_busy = 2 but it will return 3.

This patch fix my issue explained above for shared host-tag case.  I am
confused reading the commit message. You may not have intentionally fix
the issue as I explained but indirectly it fixes my issue. Am I correct ?

What was an issue reported by Luojiaxiang ? I am interested to know if
issue reported by Luojiaxiang had shared host tagset enabled ?

Kashyap

>
> Fixes the issue by not iterating over stale request.
>
> Cc: linux-scsi@vger.kernel.org
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Reported-by: luojiaxing <luojiaxing@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-tag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c index
> 86f87346232a..ff5caeb82542 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -208,7 +208,7 @@ static struct request
> *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
>
>  	spin_lock_irqsave(&tags->lock, flags);
>  	rq = tags->rqs[bitnr];
> -	if (!rq || !refcount_inc_not_zero(&rq->ref))
> +	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
>  		rq = NULL;
>  	spin_unlock_irqrestore(&tags->lock, flags);
>  	return rq;
> --
> 2.31.1

--000000000000cfec3b05d31f88bd
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMjixw9cZ1cHhThIs7Ybwww4Rc4N
97/jW5sYYE87qB/SMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MTIxNDE4NDExNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCrFk06dTFxk/XiSwI9jsoLS66pOC1IqBi7yCzKYSnC8Djy
KYLyQZaBjCT3zA8G5VcElQBd8MT780gO0OU8Sy+oplAFi+WHIdLTvrKrqbVDaEgZbQqtutfnpkLG
D/wGoX9chKF21NaoiLuJPEOKw0MGf9EY95e5REILIjDLdA7xgyV1tUwZU6E5PLzYw76Wwp639QNe
JkG4U9sFQ/00CGsHCAdxpjf73ca+7uvrFx5P+eXKYpc/pv/BQ9XzQeEcVGHZ1SugRWb1xhs8rw7z
TnN6RxgbdiHlDGrhtWlfAzo8hkwIjIawoSW8bSPh6phy3tfH6erEMxcWFDMpZJTbIo5X
--000000000000cfec3b05d31f88bd--
