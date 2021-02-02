Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF752C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 10:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7467A64E2C
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 10:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhBBKdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 05:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhBBKde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 05:33:34 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29522C061573
        for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2021 02:32:54 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id v126so19251562qkd.11
        for <linux-scsi@vger.kernel.org>; Tue, 02 Feb 2021 02:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to;
        bh=Iu/xI0fxZWTVxbbLK+kaGTmM7IKyOnH/YZUk3dOwR48=;
        b=J7S9PhixBdPGwShf98IUzkDryg6jk/DwxzPSWjC1+w5DG4f6WK7W8xHG2FX+6YsICz
         b0OZFLsAsWFSjJFmBxyzat34HSjZuNhQ03Feci0F2VrVKpr2ZUw/yidm6EhgLwn5E2D0
         VgQ3ZCD0DbvAVH1Qq8WfjNYTu7GRKJFn8jbzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to;
        bh=Iu/xI0fxZWTVxbbLK+kaGTmM7IKyOnH/YZUk3dOwR48=;
        b=DCJEOtL08vt7B/KnxJA4MNl5Gsy9+XP04YbqSctXkiO+gOViFrZ1xqczM1O79Nv5UY
         2kldw3MwwJCnQo333G2pZWuEgre7n28aeGfrZCx335qTQsoPKOO6VfW0AzFSquPaaZRn
         f2NjPacWToWP7XlCdf9iQ0swIMaeMoKQxvp2V4nMwgUH11cWgZRc5N/BsF0/JZzw5525
         k0Ikn0MTEP0jDfA2nGaPHm/nlT018dDvKIcIMzi427snxaxkzvDQV40musFrPqW2DiV/
         uOKj2znjmjditdYFgvaydfDyuoF/xX578Ujufx2n+7WTW5+ETb2gjbGuLCv99wSKWdC7
         zRQQ==
X-Gm-Message-State: AOAM533cLZS572ccrqLkRxN2I4zzvUXT25ljFCkHOXW2gyG9KcAfSMhr
        fvuYlvZxzkqAFXapr0liSRLh3Rvm3kd6TGVA80J49nJ+C4CGPw==
X-Google-Smtp-Source: ABdhPJyHhHjudszG/tYa8H469rcklpEP418fv9jVw6gNMxFPDMq1vjWJejz7Gi0jceWy1enQycY/YLcYMhrThp604s8=
X-Received: by 2002:a37:b204:: with SMTP id b4mr20169981qkf.72.1612261973139;
 Tue, 02 Feb 2021 02:32:53 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210201051619.19909-1-kashyap.desai@broadcom.com> <ed737c08-e382-5654-09d6-0948b9411aac@interlog.com>
In-Reply-To: <ed737c08-e382-5654-09d6-0948b9411aac@interlog.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLpk6B91v+2gq2y2PoJeWVJQMMz8AGO/GxHqBL8Q5A=
Date:   Tue, 2 Feb 2021 16:02:50 +0530
Message-ID: <b4e6f2c1dd0e9c6adc9b9de68d0f82c5@mail.gmail.com>
Subject: RE: [PATCH v3 0/4] io_uring iopoll in scsi layer
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003782d905ba57fec0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003782d905ba57fec0
Content-Type: text/plain; charset="UTF-8"

> Hi,
> I don't understand how this patchset works. My testing shows scsi_debug is
> broken and I will be sending a correcting patch shortly (similar to the
> one I
> sent you on 20210108).

Hi Doug -

scsi_debug patch from this series works on my setup. I was under impression
that you want this patch to be available in tree and on top of current
patchset, you want to have further incremental update.
What do you suggest ? Do you want me to wait for your updated patch OR We
can ask Martin to pick all the patches except scsi_debug ? You can post
scsi_debug changes as another series or separate patch.

I have few more megaraid_sas patches in pipeline, so I am looking for this
series to be available as baseline.

Kashyap

>
> The scsi_debug driver is a simplified LLD that needs to know in advance
> whether a request/command issued to it will be using the .mq_poll
> callback.
> Perhaps you have found another way but one simple way to find that out is
> this test:
>     if (request->cmd_flags & REQ_HIPRI)
>

Agree. I am not very much familiar with scsi_debug code so used current code
change as starting point and from there things can be improved.

> In the case of scsi_debug (after my patch) the delay associated with the
> command is not wired up to generate an event which leads to completion.
> Instead, callbacks through .mq_poll are expected and they will check if
> that
> delay has expired, if not the callback returns 0. When the delay has
> expired
> and a .mq_poll is received then completion occurs.
>
> Doug Gilbert
>
> > v3 ->
> > - added reviewed-by tag
> > - Fix comment provided by Hannes for below patch.
> > https://patchwork.kernel.org/project/linux-scsi/patch/20201203034100.2
> > 9716-3-kashyap.desai@broadcom.com/
> > - Fix Functional issue of poll_queues settings not working in v2.
> >
> > v2 ->
> > - updated feedback from v1.
> > - added reviewed-by & tested-by tag
> > - remove flood of prints in scsi_debug driver during iopoll
> >    reported by Douglas Gilbert.
> > - added new patch to support to get shost from hctx.
> >    added new helper function "scsi_init_hctx"
> >
> > v1 ->
> > Fixed warnings in scsi_debug driver.
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > Kashyap Desai (4):
> >    add io_uring with IOPOLL support in scsi layer
> >    megaraid_sas: iouring iopoll support
> >    scsi_debug : iouring iopoll support
> >    scsi: set shost as hctx driver_data
> >
> >   drivers/scsi/megaraid/megaraid_sas.h        |   3 +
> >   drivers/scsi/megaraid/megaraid_sas_base.c   |  87 +++++++++++--
> >   drivers/scsi/megaraid/megaraid_sas_fusion.c |  42 ++++++-
> >   drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +
> >   drivers/scsi/scsi_debug.c                   | 130 ++++++++++++++++++++
> >   drivers/scsi/scsi_lib.c                     |  29 ++++-
> >   include/scsi/scsi_cmnd.h                    |   1 +
> >   include/scsi/scsi_host.h                    |  11 ++
> >   8 files changed, 291 insertions(+), 14 deletions(-)
> >
> >
> > base-commit: a927ec3995427e9c47752900ad2df0755d02aba5
> >

--0000000000003782d905ba57fec0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQRQYJKoZIhvcNAQcCoIIQNjCCEDICAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2aMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRzCCBC+gAwIBAgIMNJ2hfsaqieGgTtOzMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE0MTE0
NTE2WhcNMjIwOTE1MTE0NTE2WjCBkDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRYwFAYDVQQDEw1LYXNo
eWFwIERlc2FpMSkwJwYJKoZIhvcNAQkBFhprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALcJrXmVmbWEd4eX2uEKGBI6v43LPHKbbncKqMGH
Dez52MTfr4QkOZYWM4Rqv8j6vb8LPlUc9k0CEnC9Yaj9ZzDOcR+gHfoZ3F1JXSVRWdguz25MiB6a
bU8odXAymhaig9sNJLxiWid3RORmG/w1Nceflo/72Cwttt0ytDTKdF987/aVGqMIxg3NnXM/cn+T
0wUiccp8WINUie4nuR9pzv5RKGqAzNYyo8krQ2URk+3fGm1cPRoFEVAkwrCs/FOs6LfggC2CC4LB
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQghfh2dtSl
LDGAdN46HicY76Uhwy57HmXh6i16nNiqo98wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjAyMTAzMjUzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIkyRkIm6ACxkOIogbU1+6DBuqc5
JSkgQ6TOKbsr2zIaVtYEGYwfDaB3evGr7hy7reNtGvH0LEp8l4tBF0B2GjZr2bCXQqwObrWoB84n
EHQYWxtjIJTu0xe4p3i+OZjcaTG4ik+uItNjd860kg8Ve8xTw5qDMbwpw6BbWR5KV6Kix5eJGNIK
YeHAF3g/VHi2bgyh+/1WgIh2r+d+1z3D9jThIS88sfqz88yrCriOqx8vybKWqeYTnxhlhafJja33
A7QdG3XHCcXHfoxaKYgpCyu0QheR1Q8UK1+DoJhzNv0qCKBK7u/shd0ddGAvD0foX5AFIJQzq/42
wyM2xUz9BB4=
--0000000000003782d905ba57fec0--
