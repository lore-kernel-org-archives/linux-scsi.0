Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B645C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1834964EC1
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhBBLdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhBBLat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:30:49 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB239C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2021 03:30:08 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id r77so19369334qka.12
        for <linux-scsi@vger.kernel.org>; Tue, 02 Feb 2021 03:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=UY/s5yyXMv7vuHamwbGW1X9I5GuJOAdSLc9fI8ncp+o=;
        b=XutGQTuBPdULcB2+W/u6TztafqS6iy1wFfO7iyv525rOziWXvGJOOf0lUyJTOHNi6s
         u8j/ZiJmVWt5jrdL3H/mFBKZ2YvQojrIKdufpmzAI6Nk2dQAD3JuHBfzPiOFYDYn/MLE
         A89ieM7H3I7NjK0fbPOYaVdUlCtx6lVttKdK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=UY/s5yyXMv7vuHamwbGW1X9I5GuJOAdSLc9fI8ncp+o=;
        b=FVV7QVmjyqVkd8P45DXHRoEf0jML18qhsgjoqyYKN9kLumm3A8MVim42PqfCOgbAtn
         NKsvAGw6aR38Cbdg8GClS4++sPZXhS/X/FOEdb6No1Ow1VXPNrdkMeGKabT8xiBMsUGu
         rC8U0KM+U4tEjetYq3DyVCK+I4i1qDbfn1ODvNss3X9kXrQ/tZp5UuRrtN6CKJv9in2a
         AL4aN88tSYBX+WA6nZCifQqUAsAcuWdBmfMWEyobAq+4Tt9X/iPQ2AzaCnmkRexf/X6N
         kP3u364Jj2SmHO/ip/ilwu72FBwWMD8lH7KxPaCRss8F9Gfy/IPGHbrvJFJbHQMuZLiV
         u4tA==
X-Gm-Message-State: AOAM530/M4pCBrLPuZk7Ld5sg7OG5P1EhiCEhXk6QbAWZyUjwjA46pdj
        80pSX1D+iCFLxP8wtLy0kFMtJFzz94SeV7fNsOO8NBAtv5liZA==
X-Google-Smtp-Source: ABdhPJyEPnKOcJVdZQqOu/yYWZL3zTwvErAOn7FFBbkxXuYx8OkITaV9gd+EWIPrZ9VisCHmPd4McKNg8sgbsh7C3dk=
X-Received: by 2002:a37:b204:: with SMTP id b4mr20390725qkf.72.1612265407752;
 Tue, 02 Feb 2021 03:30:07 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
 <20210201051619.19909-3-kashyap.desai@broadcom.com> <698414dc-401c-10ea-30a9-0aeedc9b1349@suse.de>
In-Reply-To: <698414dc-401c-10ea-30a9-0aeedc9b1349@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLpk6B91v+2gq2y2PoJeWVJQMMz8AIfy1e2AcmS6FioADnC0A==
Date:   Tue, 2 Feb 2021 17:00:05 +0530
Message-ID: <b930e147c940c6e1d2bbb94a5d854bd2@mail.gmail.com>
Subject: RE: [PATCH v3 2/4] megaraid_sas: iouring iopoll support
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-block@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000efb05705ba58ca59"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000efb05705ba58ca59
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> >
> > +int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int
> > +queue_num) {
> > +
> > +	struct megasas_instance *instance;
> > +	int num_entries =3D 0;
> > +	struct fusion_context *fusion;
> > +
> > +	instance =3D (struct megasas_instance *)shost->hostdata;
> > +
> > +	fusion =3D instance->ctrl_context;
> > +
> > +	queue_num =3D queue_num + instance->low_latency_index_start;
> > +
> > +	if (!atomic_add_unless(&fusion->busy_mq_poll[queue_num], 1, 1))
> > +		return 0;
> > +
> > +	num_entries =3D complete_cmd_fusion(instance, queue_num, NULL);
> > +	atomic_dec(&fusion->busy_mq_poll[queue_num]);
> > +
> > +	return num_entries;
> > +}
> > +
> >   /**
> >    * megasas_enable_irq_poll() - enable irqpoll
> >    * @instance:			Adapter soft state
>
> I really wonder if we need the atomic counter here.
> complete_cmd_fusion() will already return the number of completed
> commands, so the only benefit we're getting is to avoid calling
> complete_cmd_fusion() if no commands are pending.
> But if no commands are pending we are necessarily off the hot path anyway=
,
> so calling complete_cmd_fusion() here (and have it return 0) should matte=
r
> much.
> Am I wrong?
Hannes -

I think you are talking about busy_mq_poll atomic counter. This counter
avoid race condition of having complete_cmd_fusion() (for specific
queue_number) called from multiple context.
It is possible that we have hctx0 (which is in polled mode) with multiple
cpu_mask. Without this counter, more than one poll thread can attempt to
poll on hctx0 and we will end up in panic or some other issues. This counte=
r
will make sure poll is executed from only one context and if poll on
specific hctx is active, another poll will simply return as very first poll
will take care the completion.

Kashyap

>
> Otherwise: All thumbs up for this work. Very good job.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg HRB 3680=
9
> (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

--000000000000efb05705ba58ca59
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgSGzy4SJ4
Eg1TzENhdvtjeiOjJM+jkR+sIoPgfeP5HL4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjAyMTEzMDA4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABuGrx4H1zmbop8I73aQx3djttlt
tBOeDgjO3KJGySjbS2tpsNL+N/Wsl5fWOga/SmuqVKOZgtwfVjC69cBSFLSVnPRg4mS6deFr46Ul
s+EhCiuwmz+QsM7Ck7pZnhTnqnfvQLTGTqWVFJ9A31jBT9bKO9OwvlMnjmurheX6VzokLBk2jNhg
IqwDlMdMMm7Zzvqwo1nN6c5eTsBuBUjZOunSR9QMOjeUnRWgf39MZsBZ2JJoWx6QzffmoN3pLXkO
0WncRu0qXA7QUBIcJS+ELLZYKWhe/HHiN86VZXHZaIALAwF+QDOfn5xKArZa/WU+b/rbQLuB3NVc
NpUKX73Lz5w=
--000000000000efb05705ba58ca59--
