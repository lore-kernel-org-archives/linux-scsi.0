Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ECBC63777
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 07:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADF020857
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 07:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VxprLGRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgK3Hmi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 02:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3Hmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 02:42:37 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C24C0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 29 Nov 2020 23:41:57 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id f15so7505429qto.13
        for <linux-scsi@vger.kernel.org>; Sun, 29 Nov 2020 23:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=BFi0jnKIZFMhJeYPCjt9H6Ouo+m8AFUYKGbdV58NOTI=;
        b=VxprLGRDqEFENQZ5qMu9rzGJqljnPt05YvI/7bDKOcd1/igCUatrMOpZqUi4B2o/XF
         OLun+mmlkt9KrZAW37nOkaTc9EFq4bcUnwUrBcj325BaPwkIzorMvHHcxvHMEa+x/1OY
         r9xQpdyM2ZpjfchEHpdoqSD/+C5yI+X7uXpIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=BFi0jnKIZFMhJeYPCjt9H6Ouo+m8AFUYKGbdV58NOTI=;
        b=VR3bQywfLPaHG6UQWyUa9C3X23Jgohkurh+p8Vr0/jEQ3AX69P3vsHhNOAa6XlTlna
         GcmmIvmTjeDj7QcxmN2WRbWN9vStwK4XZm6fse1hcAN7gbEM/+ru6ngWJSHulUn0BFjP
         favqmqD8UhTXbzwoU6N3yujQWSZyqZnjNnKQCYH/RMWylwXsUwfqsO3oAwr2SEriFbM0
         ScLASiF0StXxAK+JtQZ0LAFDDGXIMEEJyUH97GTKktZS5gPFD7vyeuY0qUxnOlJFGfep
         h0i+/Jnp9uXLDwHkDLdrc/J/Sp78MszDp8iGCy7SV0cAXZxTnAb9ARp6r/J+d7LGPurt
         3lQA==
X-Gm-Message-State: AOAM530czpAp3cI0N6GDYZR0OeM4nrNmubzqIxVDhF+kr1Qqy+59Lm/+
        NtHuG394zW4n3yppuV6tK7exDPEKTPK1JgqxiupFBQ==
X-Google-Smtp-Source: ABdhPJzYueYlaHvOCGb90M5gPkJ7Z+jSueEXb/fFX6KUi4rlAmxwMpCHCdt3rc+noAaPvan47rg1AFkvYWPiS3DTze4=
X-Received: by 2002:ac8:7c83:: with SMTP id y3mr19894829qtv.201.1606722116338;
 Sun, 29 Nov 2020 23:41:56 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201015133633.61836-1-kashyap.desai@broadcom.com> <0531d781-38ed-0098-d5b8-727a3e143dde@huawei.com>
In-Reply-To: <0531d781-38ed-0098-d5b8-727a3e143dde@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH474dcanfbsV89LhwRzZrrXX/AdAKO++gXqYeAe6A=
Date:   Mon, 30 Nov 2020 13:11:53 +0530
Message-ID: <ba2f9cb923dc61e523e4ae41db615f9b@mail.gmail.com>
Subject: RE: [PATCH v1 1/3] add io_uring with IOPOLL support in scsi layer
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-block@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000051f3505b54e2502"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000051f3505b54e2502
Content-Type: text/plain; charset="UTF-8"

> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> > 72b12102f777..5a3c383a2bb3 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1766,6 +1766,19 @@ static void scsi_mq_exit_request(struct
> blk_mq_tag_set *set, struct request *rq,
> >   			       cmd->sense_buffer);
> >   }
> >
> > +
> > +static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx) {
> > +	struct request_queue *q = hctx->queue;
> > +	struct scsi_device *sdev = q->queuedata;
> > +	struct Scsi_Host *shost = sdev->host;
>
> could we separately set hctx->driver_data = shost or similar for a quicker
> lookup? I don't see hctx->driver_data set for SCSI currently.
> Going through the scsi_device looks strange - I know that it is done in
> scsi_commit_rqs.

John - I have included your comments. Below is add-on patch which handles
all your comment except one.
Below is just compiled (not tested patch). Please let me know if you like to
handle "scsi_init_hctx" in this patch or shall we do it as a separate patch
(out of this patch series.) ?


--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1769,9 +1769,7 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set
*set, struct request *rq,

 static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
 {
-       struct request_queue *q = hctx->queue;
-       struct scsi_device *sdev = q->queuedata;
-       struct Scsi_Host *shost = sdev->host;
+       struct Scsi_Host *shost = hctx->driver_data;

        if (shost->hostt->mq_poll)
                return shost->hostt->mq_poll(shost, hctx->queue_num);
@@ -1779,6 +1777,14 @@ static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
        return 0;
 }

+static int scsi_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+                         unsigned int hctx_idx)
+{
+       struct Scsi_Host *shost = data;
+       hctx->driver_data = shost;
+       return 0;
+}
+
 static int scsi_map_queues(struct blk_mq_tag_set *set)
 {
        struct Scsi_Host *shost = container_of(set, struct Scsi_Host,
tag_set);
@@ -1846,6 +1852,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit =
{
        .cleanup_rq     = scsi_cleanup_rq,
        .busy           = scsi_mq_lld_busy,
        .map_queues     = scsi_map_queues,
+       .init_hctx      = scsi_init_hctx,
        .poll           = scsi_mq_poll,
 };

@@ -1875,6 +1882,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
        .cleanup_rq     = scsi_cleanup_rq,
        .busy           = scsi_mq_lld_busy,
        .map_queues     = scsi_map_queues,
+       .init_hctx      = scsi_init_hctx,
        .poll           = scsi_mq_poll,
 };

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 5844374a85b1..cc30df96f5f7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -9,8 +9,8 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
-#include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>

 struct Scsi_Host;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 905ee6b00c55..a0cda0f66b84 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -274,7 +274,7 @@ struct scsi_host_template {
         * SCSI interface of blk_poll - poll for IO completions.
         * Possible interface only if scsi LLD expose multiple h/w queues.
         *
-        * Return values: Number of completed entries found.
+        * Return value: Number of completed entries found.
         *
         * Status: OPTIONAL
         */

>
> > +
> > +	if (shost->hostt->mq_poll)
>
> to avoid this check, could we reject if .mq_poll is not set and
> HCTX_TYPE_POLL is?

Is this urgent or shall we improve later ? I am not able to figure out how
you want to manage this ? Can you explain little bit ?

Kashyap

>
> > +		return shost->hostt->mq_poll(shost, hctx->queue_num);
> > +
> > +	return 0;
> > +}

--000000000000051f3505b54e2502
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgMiYHWQ9D
WroAzUOzjyTxwhw8Ue7TxS1WS+N+xxsmqx4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMTMwMDc0MTU2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKHAI6DIhAZGJuTrylaVyxlzt+Xx
82zLtf0BJC6b8W8NgDnS/D1gqMntnE680kMZvmciwm6nhlfZhNPnfOP87hbBhJIUXX2ZFyKFQkJl
M+Oob0pM7UMZC77QnfvLIzGlKbZCLyDhGitU/T5GKA2YeZfmPi99FA4krMzTB+JL/m4QavxLNkF1
PZdeGh9Zz2uuWIDAc3OfYE8koYaJ+xeNtQZeScdAXod48pF5YWI6mxLD6FRfXTehDtO79pGjWol0
vUX34dUAB7GJTJJi/O9azaHTvK1eo3TOJbvx3E5y9O0jLNR2UReUldbAYsXKPA1BNx9DmdKTMYvY
j58zSMkVBX4=
--000000000000051f3505b54e2502--
