Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7EACD98C0
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 20:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjJJUvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjJJUvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 16:51:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B908F
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 13:51:12 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3296b3f03e5so4113201f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 13:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696971070; x=1697575870; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMvNgoqd6YMY6PytxtLuyuPyCuqVe/N25XtwaEAPuzs=;
        b=joZw5pg2h2bB5BLA8HEH+flAgGOjGFIVJiz6Iy7dLwxzsCvKGZSqgVS/wqpAJ6eubP
         FrK7b5pXIf8mEeLsoEgFMmR8M41w26t2kZTmQcz1aPKOZY/NIfbTo/F+vasneX6g6SSG
         r4tz9OtOJwmxllUi7XxkQ8XM4kniNVjWYDRci0aTNuDF9BTmAh4KRDuvdkKSiUhQEyao
         QysMRTVE/aZrwyrL3yT9uU7n4/I8gn/xbIN5D3XSlmmOkNlkot5hbgRFi+HcsTpE5Q82
         hU2/AcgGRVEv2T+XMZp3Nx+fAuhPGMBymWSaWkhnbuWpPnaMMEyv79ycQ1h/k/mc507j
         jo/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696971070; x=1697575870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMvNgoqd6YMY6PytxtLuyuPyCuqVe/N25XtwaEAPuzs=;
        b=Y/5YLt1t9E1mN8I8plkO8TdVaX9BRi9WnJfRwVH41D8aEKU9WnGtrwHDlmztItqkJU
         jE5OOpCUa0T2kmLLdFcORlhebVxX4A8Ew7iKhHB6tu89Gu1C593lOOhpwHjrEF9wuS93
         VpGUF7TgkyAHKPHUfKMVcpWzpqdMeymNZcXc3p04myXD72RVmFsq6qLKeLHbzsyehu9S
         C1isY81QW3JSoIQWrtq/BJh3x9FZVVr7SwxmM7DbUtUIiKIG8FSYnLBceKL5trxup4tm
         4nfxpFDaV27iM7XtVy745yOwHbNzhAkwLAmmC9VDBPOuSBqSQV1zmXiupfGvs4TOw+D9
         9DCQ==
X-Gm-Message-State: AOJu0Yw1QPo/Uxg1UaRFG7Kqc9NtNsTLKv7Fwisg+UVr9hyYJX1c1X9V
        ZHuzeKgpYT2glctEuksBD4BhtarMbbLFZo8xkNlNiQ==
X-Google-Smtp-Source: AGHT+IFD5aFZr73w4wpXqWke4TyoAYdTiGQEP1nzTNLXm0gTwIHlIeUCxqfh3wqRsquyDHBiotWE1pLg+3EkY78tg1Q=
X-Received: by 2002:adf:e788:0:b0:31c:70b0:426b with SMTP id
 n8-20020adfe788000000b0031c70b0426bmr17483743wrm.63.1696971070288; Tue, 10
 Oct 2023 13:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20231010-ibmvfc-fix-bitfields-type-v1-1-37e95b5a60e5@kernel.org>
In-Reply-To: <20231010-ibmvfc-fix-bitfields-type-v1-1-37e95b5a60e5@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 10 Oct 2023 13:50:55 -0700
Message-ID: <CAKwvOdksaN1j_y4sVGZYudt3920zE8oXfwy7=x9FdBXiaK_ZUA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ibmvfc: Use 'unsigned int' for single-bit bitfields
 in 'struct ibmvfc_host'
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     tyreld@linux.ibm.com, martin.petersen@oracle.com,
        jejb@linux.ibm.com, trix@redhat.com, brking@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2023 at 1:32=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy) several times along the
> lines of:
>
>   drivers/scsi/ibmvscsi/ibmvfc.c:650:17: warning: implicit truncation fro=
m 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Wsingle-bi=
t-bitfield-constant-conversion]
>     650 |                 vhost->reinit =3D 1;
>         |                               ^ ~
>
> A single-bit signed integer bitfield only has possible values of -1 and
> 0, not 0 and 1 like an unsigned one would. No context appears to check
> the actual value of these bitfields, just whether or not it is zero.
> However, it is easy enough to change the type of the fields to 'unsigned
> int', which keeps the same size in memory and resolves the warning.
>
> Fixes: 5144905884e2 ("scsi: ibmvfc: Use a bitfield for boolean flags")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index 331ecf8254be..745ad5ac7251 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -892,15 +892,15 @@ struct ibmvfc_host {
>         int init_retries;
>         int discovery_threads;
>         int abort_threads;
> -       int client_migrated:1;
> -       int reinit:1;
> -       int delay_init:1;
> -       int logged_in:1;
> -       int mq_enabled:1;
> -       int using_channels:1;
> -       int do_enquiry:1;
> -       int aborting_passthru:1;
> -       int scan_complete:1;
> +       unsigned int client_migrated:1;
> +       unsigned int reinit:1;
> +       unsigned int delay_init:1;
> +       unsigned int logged_in:1;
> +       unsigned int mq_enabled:1;
> +       unsigned int using_channels:1;
> +       unsigned int do_enquiry:1;
> +       unsigned int aborting_passthru:1;
> +       unsigned int scan_complete:1;
>         int scan_timeout;
>         int events_to_log;
>  #define IBMVFC_AE_LINKUP       0x0001
>
> ---
> base-commit: b6f2e063017b92491976a40c32a0e4b3c13e7d2f
> change-id: 20231010-ibmvfc-fix-bitfields-type-971a07c64ec6
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,
~Nick Desaulniers
