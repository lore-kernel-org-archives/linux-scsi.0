Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA13FC5519F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58D112076E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 09:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NAwI1K6b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgK3JHa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgK3JH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 04:07:29 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3324C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 01:06:48 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id 7so7646668qtp.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 01:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=jgr0nWIjkx0kuZSJuJ1IacXhyPRAdRXzO4pD/ww1R9g=;
        b=NAwI1K6bpB47m1s4Oxu47QVZjplMUi/ladLvQ+/ZcagLgKS+vlzIeFDC7xKXMIAJuH
         oxqGyF0iN/3+xfDXfJIXeznOiSq8G62VE6QAaWjJLHZpxMpaO9DtLKVPeLWhOHamdo5q
         3uTwmS2Y/DjuJ8wRsGQIubHax7HVlEtRR2YZw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=jgr0nWIjkx0kuZSJuJ1IacXhyPRAdRXzO4pD/ww1R9g=;
        b=mpX+5PDoSmBcwQvz4MSldZlquUmvujkSlyFt9HmB1A/U34dfpDCQM7DjioesDcmCuH
         8lqF8oGzbAI57glmqHJk5eOocBw7rlBjxU2Wk6DXMo2zjBGwG16ukah150xjvf7hlk1T
         tJ51C3O7hueELmJsQvm+51AWYL442J2yuQIDA3jz8RsEOrdeQ4gMOzBKZCI8yuPJOpx4
         nns4cp2vcIcyEPRYrqZMTNlD3J0/D4489ub3esGsntIkscn6cfN0y4Egmbyh+YM1Eoe+
         BUTNxbg7H0sxAG7B/QtCm+OEo8u3/3rupu3R2TljvN6CN7WKeIIK9nE1rVPdSwxleA2v
         kFUQ==
X-Gm-Message-State: AOAM532NoKJuQJbgzTRhnVh2shIpYxqwKbOsIo/TRPL/P38BPc1m/rWM
        NwpeVBbrMthd+DlJ89PUHh9DjSZ3cecur9Di9OCeKMCx9hM8sg==
X-Google-Smtp-Source: ABdhPJy/G3H0qoBblPKMB5QGVFbQfHSk3ULTFyfbggWc9X8h+RPqrok5kFWnXQxBTmJgkqP/7FRHGZnMH2WtzY0YJ9U=
X-Received: by 2002:ac8:7a7a:: with SMTP id w26mr8725096qtt.216.1606727207914;
 Mon, 30 Nov 2020 01:06:47 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201015133721.63476-1-kashyap.desai@broadcom.com> <56c55fed-3034-9fbf-b089-a07e74d9b05b@interlog.com>
In-Reply-To: <56c55fed-3034-9fbf-b089-a07e74d9b05b@interlog.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKUm/+n80BG5XDZqj6B7AOaaFsZXQLRJEHUqE4tACA=
Date:   Mon, 30 Nov 2020 14:36:45 +0530
Message-ID: <1d8b5c319efd67aadd411632ee519295@mail.gmail.com>
Subject: RE: [PATCH v1 3/3] scsi_debug: iouring iopoll support
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000819c1405b54f5403"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000819c1405b54f5403
Content-Type: text/plain; charset="UTF-8"

>
> On 2020-10-15 9:37 a.m., Kashyap Desai wrote:
> > Add support of iouring iopoll interface in scsi_debug.
> > This feature requires shared hosttag support in kernel and driver.
>
> I am continuing to test this patch. There is one fix shown inline below
> plus a
> question near the end.

Hi Doug,  I have created add-on patch which includes all your comment. I am
also able to see the issue you reported and below patch fix it.
I will hold V2 revision of the series and I will wait for your Review-by and
Tested-by Tag.

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4d9cc6af588c..fb328253086d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5675,6 +5675,7 @@ MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer
length granularity exponent
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout,
8->recovered_err... (def=0)");
 MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get
new store (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
+MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to
max(submit_queues - 1)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration
between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
@@ -5683,7 +5684,6 @@ MODULE_PARM_DESC(sector_size, "logical block size in
bytes (def=512)");
 MODULE_PARM_DESC(statistics, "collect statistics on commands, queues
(def=0)");
 MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
 MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
-MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues");
 MODULE_PARM_DESC(tur_ms_to_ready, "TEST UNIT READY millisecs before initial
good status (def=0)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba
(def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in
blocks (def=1)");
@@ -7199,7 +7199,7 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost,
unsigned int queue_num)
        do {
                spin_lock_irqsave(&sqp->qc_lock, iflags);
                qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
-               if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE)))
+               if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
                        goto out;

                sqcp = &sqp->qc_arr[qc_idx];
@@ -7477,10 +7477,17 @@ static int sdebug_driver_probe(struct device *dev)
                hpnt->host_tagset = 1;

        /* poll queues are possible for nr_hw_queues > 1 */
-       if (hpnt->nr_hw_queues == 1)
+       if (hpnt->nr_hw_queues == 1 || (poll_queues < 1)) {
+               pr_warn("%s: trim poll_queues to 0. poll_q/nr_hw = (%d/%d)
\n",
+                        my_name, poll_queues, hpnt->nr_hw_queues);
                poll_queues = 0;
+       }

-       /* poll queues  */
+       /*
+        * Poll queues don't need interrupts, but we need at least one I/O
queue
+        * left over for non-polled I/O.
+        * If condition not met, trim poll_queues to 1 (just for
simplicity).
+        */
        if (poll_queues >= submit_queues) {
                pr_warn("%s: trim poll_queues to 1\n", my_name);
                poll_queues = 1;


> > +	do {
> > +		spin_lock_irqsave(&sqp->qc_lock, iflags);
> > +		qc_idx = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
> > +		if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE)))
>
> The above line IMO needs to be:
> 		if (unlikely((qc_idx < 0) || (qc_idx >= sdebug_max_queue)))
>
> If not, when sdebug_max_queue < SDEBUG_CANQUEUE and there is no
> request waiting then "scp is NULL, ..." is reported suggesting there is an
> error.

BTW -  Is below piece of code at sdebug_q_cmd_complete() requires similar
change ?
Use sdebug_max_queue instead of SDEBUG_CANQUEUE
        if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE))) {
                pr_err("wild qc_idx=%d\n", qc_idx);
                return;
        }

Kashyap

--000000000000819c1405b54f5403
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg0yNhUeBb
TrQ5ZGC4Kq3hEz5yN7CtFvmSVqmsknObR7UwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMTMwMDkwNjQ4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKTPM7Vw5zaCY4nzWG+yIvCj4X7f
wRhkVC8qCsqAw55iCkWc5iGyQ3oEJs1s3DfPN7Fpyr1wsvj9HuTunjGeNejih1V8cICU472kZopE
/tWEFzYrks5l3JUH/g78YFhfwd1jkfPTTGgq85a0r5uJmHMVAUhVT0c0ESw76K4dO7XPkhVTJqDE
5fl/Oav7JI/ZOsgy53WvC1kOZkV/SmS9KI5bRAlf/p02qD2Tx4bnRMwIMI/EXoiOZUTDfD3Uk52w
Q50e3hEyBuznHp/GPLqkkbO+9+RtrThrIus7ZmcXiHgiUEgSH8HXNoTk5rnSvvluTvTtg1c/Ob1+
YEdXMJVo7XA=
--000000000000819c1405b54f5403--
