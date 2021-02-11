Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575A0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CC8164D5D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBKMQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhBKMNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:13:45 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9303DC061788
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 04:13:04 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id v10so1564492qtq.7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 04:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=Ey26aWKuC+w/T9BqEfA/br94P1JZgqd0/m4JF7tQ/4U=;
        b=WfSnAzi+v32QsnOyJeNhg24DNI1eavgJLx/UDjJySKuBx6UTUv3dkJ2RVjsTtU6+db
         tS/lfNQJFLzP+rNo7+dqrc6NA0BSVwQyIbZq6c7mVYAX/R1jQG//n9eEQdi5LrLHZCbe
         WxiPbrxU2lpXoBlvj6t2CWAABffJ3Sz1jHf4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=Ey26aWKuC+w/T9BqEfA/br94P1JZgqd0/m4JF7tQ/4U=;
        b=V6BkL5jV3TRd9u21PSOAM1hV3c9vljIrmro1d7ZfSakLuV/Oh6zzRVZMyj30Lq3Z3w
         erm8EN1Lm0zZJr1649KH3Opx9OysU2y9OMoRe3YIuqq3fpIJjUbBEkJs/xzScLrdH65y
         cNZ2sRzRQARPRqDBhgDY3y8DpZ9KifpRgRG4W44U6cNZ0jC73RW1b+Z1pA3jQDWyFgov
         A36xdpGtNyqzQTTwRriRDl6/m7UL4UAeQncheQ0QkCVlDdwmjbIKO6yd2gYDHKmpXtzW
         42LHRk7KHmATHlCGrB3djLAKRk51VBg7kcTgug+jguuzcbZdLEdGyqcGk6qiLebaCFn7
         e6Iw==
X-Gm-Message-State: AOAM533FiLbU5UC9enYQl4ygUZ38aqLOYYvu+Tp/gNZWDG1XRARpJ7lD
        kV3olbaFMvk1vVL2WHMK9lxUeCfsPPDq+vC43Uielg==
X-Google-Smtp-Source: ABdhPJxF1klj501kTrqVurzP7a+yqbx+WUakx1uDeyge/PpTQ0BdhNL3ckGiXt+tQ/ZDcD4got8VSUjXJLGhHd/F8KA=
X-Received: by 2002:ac8:4911:: with SMTP id e17mr7426844qtq.190.1613045583737;
 Thu, 11 Feb 2021 04:13:03 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210209225624.108341-1-dgilbert@interlog.com>
 <CAHsXFKEhiwHmMmJ00eeA1ikP3wdiJP2xggsuO0Qc9H1ogNXnVQ@mail.gmail.com> <c9084cf7-4f75-dc62-1927-a2695f6cc52c@interlog.com>
In-Reply-To: <c9084cf7-4f75-dc62-1927-a2695f6cc52c@interlog.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJfnbiQypQwuIVn9N6EURl07bARLALfNPrNAYVng9mpHnuooA==
Date:   Thu, 11 Feb 2021 17:43:01 +0530
Message-ID: <3253ac6a020bd3c36ed03519c4182250@mail.gmail.com>
Subject: RE: [PATCH v3] scsi_debug: add new defer_type for mq_poll
To:     dgilbert@interlog.com
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000b42ab05bb0e716d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000b42ab05bb0e716d
Content-Type: text/plain; charset="UTF-8"

> Kashyap,
> There is another issue here, namely iodepth > host_max_queue (64 > 32) and
> in my setup that is not handled well. So there is a problem with
> scsi_debug
> *** or the mid-level in handling this case.
>
> If you have modified the sd driver to call blk_poll() then perhaps you
> could try
> the above test again with a reduced iodepth.

Doug -

I debug the issue and found the fix. We need to remove below code to handle
this new defer type for mq poll.
Earlier I did not used " REQ_HIPRI" to handle mq poll, but now you are
managing it through REQ_HIPRI check, it is safe and required to have below
patch.


diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b9ec3a47fbf1..c50de49a2c2f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5437,13 +5437,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd,
struct sdebug_dev_info *devip,
        sd_dp = sqcp->sd_dp;
        spin_unlock_irqrestore(&sqp->qc_lock, iflags);

-       /* Do not complete IO from default completion path.
-        * Let it to be on queue.
-        * Completion should happen from mq_poll interface.
-        */
-       if ((sqp - sdebug_q_arr) >= (submit_queues - poll_queues))
-               return 0;
-
        if (!sd_dp) {
                sd_dp = kzalloc(sizeof(*sd_dp), GFP_ATOMIC);
                if (!sd_dp) {


On top of your v3 patch + above fix, I am able to run IO and there are no
issues.  There is no issue with higher QD as well, so we are good to go.

Tested-by: Kashyap Desai <kashyap.desai@broadcom.com>

So how shall we progress now ? Shall I ask Martin to pick all the patches
from " [PATCH v3 0/4] io_uring iopoll in scsi layer" since this patch has
dependency on my series.

Kashyap

>
> Doug Gilbert
>
> *** the scsi_debug should either yield a TASK SET FULL status or return
>      SCSI_MLQUEUE_HOST_BUSY from queuecommand() when it has run out of
>      slots.
>
> > [seqprecon]
> > filename=/dev/sdd
> > [seqprecon]
> > filename=/dev/sde
> > [seqprecon]
> > filename=/dev/sdf
> >
> >
> > I will ask Martin to pick all the patches from "[v3,1/4] add io_uring
> > with IOPOLL support in the scsi layer" except scsi_debug. We can work
> > on scsi_debug and send standalone patch.
> >
> > Kashyap

--0000000000000b42ab05bb0e716d
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQguqNOM7TJ
vCLzIehnlavzQDzko5D0gvEyykFbAf2sB44wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjExMTIxMzA0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAF0Ka7ZgRvBF0MX7qZkqUxV2WqSm
QdwzbEJLvHAqa2gR30L/3tGPTYPHUl8sL9CJXGnHu9lZSosIIRq8qGLh7s3n3vMOmyDbvGLjRKVu
NvwGu+BMpK16C7RSsStgd6wJjRQoNp1vdfkvmd6vzvbpnsgmsecWCFerfAv2oEuZ+8cKwWwG9/Ux
vARjJk0Oim/1qqaGb7pP5vh9yFcN6gg7ZQqVfEqZQDQWHiQtyVI0s55f93WQQFK+o7zrPEOOiF61
zcV87AtRFsAubDZEMXRERZhcIGHHFgAT/D1uS2xIF5KYGZ7VyWcG5gx3N0hY4xwHOuw7HUPxKikr
Ndph38nWLOg=
--0000000000000b42ab05bb0e716d--
