Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA9DC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 10:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3362A207FF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 10:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IyTNQnFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgLAK1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 05:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgLAK1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 05:27:33 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B8AC0613CF
        for <linux-scsi@vger.kernel.org>; Tue,  1 Dec 2020 02:26:53 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id l2so712537qtq.4
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 02:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=bH8ztwCRU7pfTOLoILzVjZFsh17/ewwKwqqjXHAHAWw=;
        b=IyTNQnFmqD8xymgByLLZ71KOgCrlX045mpaIAlpO7nNt71/UgrnWjH8FewmzoLiQgu
         SDCLR71ROGrNlQR6mGLQ++WPGtYaWX1gMzml2Ln9CyMzcCkNe+TLqvlIVkXOdT+v9n2v
         ut+2PTVCSdSel+axnO7SiPCTksB+MWPA5VNpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=bH8ztwCRU7pfTOLoILzVjZFsh17/ewwKwqqjXHAHAWw=;
        b=UUJ5oAkau9LCTmkD/vCW/Da6zWIhohukoge7sMmY0GClA092L7Sw29Dvb86Czv+6it
         /3VkoBnZx2pf0bBJdQUmIjtVdtNaLuYTuBnZOnfyyj/4gnX4GjgtUe/tZaPqyLaVsHuG
         3RLS6E6cap9oXpjP76RAEXok7gVWEOh1P8TYdenk0e6O4NO9Osi7xcu8D4NdSH/PgDeo
         +jV19ayZyLJhnxaQE9g/5Z1CFgmZ/leJNkhgMxEXH6RXdgOW55VDwxXoZVihjk78N4qq
         XESx46f7nL3Xqy6y66RGb+Zn1I+MQqZ0BjVBDHrFPhjWTDHlCx1dzjbaPWUQC7BazdIc
         7NaA==
X-Gm-Message-State: AOAM533Id+vxVaVWWx/pt2GVBgYoHNP7q9rVJkd2ktNQUqhxvQOmX87u
        4Bdm1cTa2b1M4c1Tog23TWhLzIbu/bnZ/rO2fp9Lwg==
X-Google-Smtp-Source: ABdhPJx/eK3kaxXybCCDbemkS5QCDknx3+6eTbvxrOQaqdPOFuAMAsKYB2tbpj61XpDtM4QTX9QsswcWLsG83hwKO0Q=
X-Received: by 2002:ac8:67da:: with SMTP id r26mr1981528qtp.101.1606818412623;
 Tue, 01 Dec 2020 02:26:52 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
In-Reply-To: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQCu1iWdKqdBukxlHXC3erINxxwMWawx6Xzw
Date:   Tue, 1 Dec 2020 15:56:50 +0530
Message-ID: <6cd6f97324474f88a0a748e218c8dddf@mail.gmail.com>
Subject: RE: [bug report] Hang on sync after dd
To:     John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     chenxiang <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Ewan Milne <emilne@redhat.com>,
        Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b85c1505b56490fd"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b85c1505b56490fd
Content-Type: text/plain; charset="UTF-8"

> @Kashyap, have you guys tested megaraid sas much for this?

John - I tested V4 version "scsi: core: Only re-run queue in
scsi_end_request() if device queue is busy" on MR controller.
I used different reduced device queue depth (1 to 16). I can try the exact
same test case with MR controller.

>
> Thanks,
> John
>
>
> Block debugfs info is as follows:
>
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat active cpu101/ cpu96/
> cpu99/ dispatch_busy io_poll sched_tags tags busy cpu102/ cpu97/ ctx_map
> dispatched queued sched_tags_bitmap tags_bitmap cpu100/ cpu103/ cpu98/
> dispatch flags run state type estuary:/sys/kernel/debug/block/sda/hctx8$
> cat
> cpu cpu100/ cpu101/ cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu cpu100/ cpu101/
> cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/ completed
> default_rq_list dispatched merged poll_rq_list read_rq_list
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/dispatched
> 0 0
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu97/dispatched
> 0 0
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu98/dispatched
> 0 0
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu99/dispatched
> 0 0
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/dispatched
> 3 0
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/completed
> 2 0
> estuary:/sys/kernel/debug/block/sda/hctx8$
> estuary:/sys/kernel/debug/block/sda/hctx8$
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat state SCHED_RESTART

When I tested V3 "scsi: core: Only re-run queue in scsi_end_request() if
device queue  is busy". I noticed the similar hang and that was fixed in V4
(final patch).
Let me try on MR controller one more time. Hctx state SCHED_RESTART
indicates that someone should kicked-off h/w queue but it was missed. It may
be possible that
When you revert " scsi: core: Only re-run queue in scsi_end_request() if
device queue  is busy", actual race condition windows narrows and it may be
actually existing hidden issue.


> estuary:/sys/kernel/debug/block/sda/hctx8$ ls active cpu101 cpu96 cpu99
> dispatch_busy io_poll sched_tags tags busy cpu102 cpu97 ctx_map
> dispatched queued sched_tags_bitmap tags_bitmap
> cpu100 cpu103 cpu98 dispatch flags run state type
> estuary:/sys/kernel/debug/block/sda/hctx8$ cat dispatch 000000007abb596e
> {.op=FLUSH, .cmd_flags=PREFLUSH,
> .rq_flags=FLUSH_SEQ|MQ_INFLIGHT|DONTPREP, .state=idle, .tag=21,
> .internal_tag=-1, .cmd=opcode=0x35 35 00 00 00 00 00 00 00 00 00,
> .retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=60.000,

If this issue is reproducible, can you check pending commands. Is there any
pattern in pending command ?

> allocated 2208.876 s ago} estuary:/sys/kernel/debug/block/sda/hctx8$
>
>
> On cpu100, it seems completed is less than number dispatched.

--000000000000b85c1505b56490fd
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgY24pjB/D
I53q81YAksVmO8q0jvtlJpRa2lG5xQPA40swGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjAxMTAyNjUyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABxB8hx1MyKQZjYQLNkrBcCFw2cP
OfjCLsTab00u8KuE1m9THldiPl3fyyRou13TrCof/FKD6MrR9ci1w3q8DiageqkVGBUuljEEs6ne
rcf5KALotyaTiccX56TzBPEbMGHKRI52nVUM9dp9t/pdR/OCjW2M2NeZT8gC64e/+h+FVLu6dRBf
82qSBFnl5BTuD1kqhQyjIqcRPnHiILkF3WsIQrlgBE373+tVYh2j9slHiSdKwNSnpyYk2BZgh8t8
ZjBeV7/GQ3HRZkD5ss9e59VGMCcUtfmy2L7+jxY1jGo9QJkc1yfEuT6GfDfMG63V+Su+7Ku4UImy
s5uU69FNF6M=
--000000000000b85c1505b56490fd--
