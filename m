Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8246DC4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F91821D41
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 20:24:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G2caJV6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbgJZUYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 16:24:50 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44280 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731433AbgJZUYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 16:24:50 -0400
Received: by mail-ot1-f67.google.com with SMTP id e20so9169802otj.11
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2020 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=ZCh9ynE/VSZ8UJo2nNgpZO5eNtoHAObNXX2OSd1v0TQ=;
        b=G2caJV6oDQ7Mm1UWJPivMij7d1nENfJEwv4Gka4xRLFWWqUZqeSvCZx/eTQWYfHilE
         wPtFN3vA9mjmXpxW1rE/pqjnT+7sNt5VCytaE69rxRzHxh69JgSzY0gapJVGVcPFv4aD
         i7s+RFNLozVacJPk7aw0AEfcpIbdGyto72a1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=ZCh9ynE/VSZ8UJo2nNgpZO5eNtoHAObNXX2OSd1v0TQ=;
        b=pZiTd9lwRwAdmtPq0sVACD4JHLJC/MIfIQ7YzDa4lrhAk9d/BS3XkDVyQkiOFJkKVV
         6X+98b9JYjlMM+lh4UsHbBI12VXVjM+zTZo8RsFJwcRfxJ11w9/y07XPHsbDv+qg9RHJ
         lSp2AUlNDoT32O/B2xhyP2ewgE63jmyw/H8QaH46MmYMZKiCLVVJEWdQQ/12vrwudPKw
         pEKByrRBoItq2fmjak4DGYA/s5YvFnf3GicQKlIzy6xiyWHxtcsz0XL0cGrIEhInvsC6
         n1ioUC5svHxXEwP0U7FsO/v3HHnA/Cb1D0EKlafoxf2k+VfCrgIxcy99aggLbm/K13xv
         6QqA==
X-Gm-Message-State: AOAM531Ma1S/Xc6wjMOUQ9k+ctb6WOEa+ksZpTWz6fd5Nh2GA8YQT1tQ
        /itNlom2Hj5ACmQ9hOLnQ1YJYuUh1q+nAA4Lyz45Jw==
X-Google-Smtp-Source: ABdhPJwNpd7+meIfemJtf/8BnBFikaK2pKcz/Vwo2F5T0OEBchlXHpJJLzLjh1cqZHuR1qwPXP3OM5qCzQpCQVRI9G0=
X-Received: by 2002:a05:6830:1c3c:: with SMTP id f28mr17036494ote.188.1603743889005;
 Mon, 26 Oct 2020 13:24:49 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
         <1603370091-9337-3-git-send-email-muneendra.kumar@broadcom.com> <8d29df3e8fc04a781191092f65a4e7ca45ce3d63.camel@redhat.com>
In-Reply-To: <8d29df3e8fc04a781191092f65a4e7ca45ce3d63.camel@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLv5vf0y45oXVLFrswKM5p1yAny/wKZQkLVAvL4yu2nS3wwgA==
Date:   Tue, 27 Oct 2020 01:54:46 +0530
Message-ID: <4d3f1e94f7e283a1d8f9f289b3e09a6c@mail.gmail.com>
Subject: RE: [patch v4 2/5] scsi: Added a new error code in scsi.h
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d516af05b298b87c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d516af05b298b87c
Content-Type: text/plain; charset="UTF-8"

Hi Ewan,
Thanks for the input .
I will add this change.

Regards,
Muneendra.

-----Original Message-----
From: Ewan D. Milne [mailto:emilne@redhat.com]
Sent: Monday, October 26, 2020 5:16 PM
To: Muneendra <muneendra.kumar@broadcom.com>; linux-scsi@vger.kernel.org;
michael.christie@oracle.com; hare@suse.de
Cc: jsmart2021@gmail.com; mkumar@redhat.com
Subject: Re: [patch v4 2/5] scsi: Added a new error code in scsi.h

Don't you need to add the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition() ?   DID_TRANSPORT_FAILFAST returns
SUCCESS but the default case returns ERROR.

-Ewan


On Thu, 2020-10-22 at 18:04 +0530, Muneendra wrote:
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
>
> Clearing the SCMD_NORETRIES_ABORT bit in state flag before
> blk_mq_start_request
>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>
> ---
> v4:
> No change
>
> v3:
> Rearranged the patch by merging second hunk of the previous(v2)
> patch3 to this patch
>
> v2:
> Newpatch
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  include/scsi/scsi.h     | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> 1a2e9bab42ef..2b5dea07498e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1660,6 +1660,7 @@ static blk_status_t scsi_queue_rq(struct
> blk_mq_hw_ctx *hctx,
>  		req->rq_flags |= RQF_DONTPREP;
>  	} else {
>  		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
>  	}
>
>  	cmd->flags &= SCMD_PRESERVED_FLAGS;
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h index
> 5339baadc082..5b287ad8b727 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
>  				 * paths might yield different results */  #define
> DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
> #define DID_MEDIUM_ERROR  0x13  /* Medium error */
> +#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
>  #define DRIVER_OK       0x00	/* Driver
> status                           */
>
>  /*

--000000000000d516af05b298b87c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCCEmxpSWW61QOgbIQyNGEhayFsnU6YEwpE/HNhZ6T4dETAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMjYyMDI0NDlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAtBBc8t94xNpU+4qt
fs2GmCNOkGnBPwzRT7EsOI15htu/9yJOi9m8SOSA5KrS+Tu1cYuUCt13VOFIYH11pHHSGetNxicO
Koa6YI+lGxi0yaQ+jckI+4dp5jIYNLmIEwTuz6m4SQH/MmgvyhBfnrjCkGaLtwKD4AoEqKYxajOr
lBR6UCxmtVs7Q4mqb1r54M+Q2SnuspqCEMbYy8by+sTtKSqxyQmXR5weKxwo7EOQUGPDX/wZFK0w
oehnV5XM+sAT9wzguwaeXeqAe81JIrOCLgKYqSXZub0r9xUAOBujx5GbJPvvSFPULojl4IgQPLlh
eYCvkt/Phx6p3s0a33qU/Q==
--000000000000d516af05b298b87c--
