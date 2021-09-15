Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF5DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 12:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C4761178
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 12:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbhIOMqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237902AbhIOMqc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 08:46:32 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39605C061766
        for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2021 05:45:13 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id t2-20020a4ae9a2000000b0028c7144f106so842992ood.6
        for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2021 05:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=acZVV0S6zsbsvdCml6RDA7vWTUqqTaAA2WbZxTttdNc=;
        b=XW7wvQQFzxJx7NoPjiaQ4XaY+ZgMmz8ai7OxTzbtA9iLDshnfKieoByyWDLBc+ari7
         DCMNysfinIgyLOte6Df9GB9wT6ciKC5imZve0Pjo724+VujxqOsh3PG1v6XRT2eO4fO8
         KNgIySBgghXEeZ/FPaO4Q5vGHhDqFSYCRLaUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=acZVV0S6zsbsvdCml6RDA7vWTUqqTaAA2WbZxTttdNc=;
        b=7GgEEO4orA8VVxnCnIFkLJb82Y6+YODy6XkvXgTLrbOcEDXC+ptfJRBgZ3f9PlWZWC
         O2kA+U7PTdq9Hj28Yw6x2YHRXE5dpnsFmdcuqUNRpOR0zi+MLNc4SnAXXYEU5G9a7ekb
         CFZrImMH02xKmyLNgUzOoGUP0tPFu35oU9Me/VNX0VHE8Cq/0gHUkVvM441Tqf6rEyhB
         difWbobZ1d321ELH5u1hHEFN2PuvzdH+wjBY8z2AQTEYcnJKUye2TbVVQ9jXxh4KyjA2
         NpUG72kXUBTXcIAba3jTp014uRNwk71akv58aJpQpgqZNVwcYDXm3i/WaLHiHrfDh5Ac
         +VWw==
X-Gm-Message-State: AOAM532z+vN4kvoNNCa46QWFO2s5IY1SVLvdwKPSdw91Ua14/bWZSpF4
        kGIgh72CEXELJTnoQIPguujPeXC/m2wwoXf8qnKGjsw2/B1W+frscmX9KQ0c1WritusZcNTRV75
        fVsV5F6aGotaYWR05noCRfmQ+5ZjYeticXS7Z
X-Google-Smtp-Source: ABdhPJxTqbCwuH2DjxVRng03R0RDf/toZ1zDZKhR0mJmV6F9XqwgpRQvfBomoGKNSIytHLbreDopEQVvbPEeqAvI1aw=
X-Received: by 2002:a4a:a8c9:: with SMTP id r9mr18190946oom.49.1631709912155;
 Wed, 15 Sep 2021 05:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210914105539.6942-1-d.bogdanov@yadro.com> <20210914105539.6942-2-d.bogdanov@yadro.com>
In-Reply-To: <20210914105539.6942-2-d.bogdanov@yadro.com>
From:   Ram Kishore Vegesna <ram.vegesna@broadcom.com>
Date:   Wed, 15 Sep 2021 18:15:01 +0530
Message-ID: <CAF7aS0qZivtbxJmRmE7zFz1DjgDO5NjcZH1L8gFrw40QRNhCyw@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: efct: add state in nport sm trace printout
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, James Smart <james.smart@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ba145b05cc081140"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ba145b05cc081140
Content-Type: text/plain; charset="UTF-8"

Looks good. Thanks.

Reviewed-by: Ram Vegesna <ram.vegesna@broadcom.com>

On Tue, Sep 14, 2021 at 4:25 PM Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
>
> Similar to other state machine traces and to make debug easier add the
> state name to nport sm trace printout.
>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/scsi/elx/libefc/efc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
> index 927016283f41..468ff3cc9c00 100644
> --- a/drivers/scsi/elx/libefc/efc.h
> +++ b/drivers/scsi/elx/libefc/efc.h
> @@ -47,6 +47,6 @@ enum efc_scsi_del_target_reason {
>
>  #define nport_sm_trace(nport) \
>         efc_log_debug(nport->efc, \
> -               "[%s] %-20s\n", nport->display_name, efc_sm_event_name(evt)) \
> +               "[%s]  %-20s %-20s\n", nport->display_name, __func__, efc_sm_event_name(evt)) \
>
>  #endif /* __EFC_H__ */
> --
> 2.25.1
>

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

--000000000000ba145b05cc081140
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Vxab43fOCbFozIOlzutBV4fhpWlA3FrVNhbPhbwO398TsV3gUkYHkxoS9kLeRXHnNcdOcFMo8Maz
mQF6P67d881N/0Tt0k0MfXGTHytZvfFdayivzlL9nAnyXTzPFU8CAwEAAaOCAdkwggHVMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
IwYDVR0RBBwwGoEYcmFtLnZlZ2VzbmFAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwME
MB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBQt2m9JVe4cejFw9Mog
spXwL7sKWzANBgkqhkiG9w0BAQsFAAOCAQEAARwXxUTPdWpdSOs12BsNVMRlHdaahp3UNv1LW20i
ps55UslOtXjHiznNQr5nyhmnkH0TLxn12NGEV0BnOmb70Ml2klfFLXTw73cp/mxM2eOZX5ho+f8v
TuqwzxbJ+WAoFHzMJfevy9SEdovoE1TeBhc+IgZQR3zCkMt00bsKvKD0SmgNKiSmkHr+WbJCjCq7
tlkydEDuGjuSfbNzIcS0qLpqIHaSh/3WmF7TWzBJ8Ln1HwrvuMZ3Txksjsmpt34GFSubX+CGrYyW
ORNGomSiW66FqRvj0iaYYbNTIfnU7/iJy3CN8Z5SvVroNAQbRfoooT/loWsoiUUNmTR9kebvLzGC
Am0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAv
BgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDCHWmFjgp1UN
rBuhLTANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg65vPVcu92hmY9jk+rnOYjj7n
2G9iE18w8wkeCiO2T0MwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MjEwOTE1MTI0NTEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYw
CwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGOBCdaIelJ+T88yoCtcPsvKgblOjDWQ7lw6FQzPTLxN
TXf7h/eg56eAMXwAGUMTSMAExdBohqEHEAItdhpNY4CpweJWzeNLiOjP4cyMiOX5/OpIYc1tzZMC
uh0hbYbkDC77Y0xOxMpCHoPbW+wBJXFuWDVmrLZG0tSOCJ0VlzutidLzdsBGvYogxMf+H9tTq94d
i7wW8yAL9jwT1aBGs2yJJR6N2K5VMiOWNFcrsvyN8DqHaKHqmJoWfskjk5oKJfsOVCnnvEF3FqfW
C+dOJ2xGI580iivuE91VhwhYkhnSwGQ2dBKjckMs/z/z06uRNfuKi3gXZ+a4yhjqmxXYAvw=
--000000000000ba145b05cc081140--
