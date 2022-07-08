Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48C2CCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiGHXmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGHXmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:42:43 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846B6D9C0
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 16:42:40 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s14so194058ljs.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1z/XYffrQE1ulbZWqvB17ZvgZDPHSFhdrO4bt0sud0=;
        b=rwQIfx2Rbka3ZHXrSst/zHyIhKR2xW8QfdqVBrkvu70qG4LbOgX2/R7lqpN7urgSGj
         kW/vig2rxrw5x7BzghZ113H429+v5QNUXswiV5ZJ4sglOAcVoa1d/8+i15DcFgPlA4F/
         FRbh2JPOxgmXZOYbz9bx0muHxBonv8wFVGhPibkcY0RkzlW3wmuKuW4PYg9BS1NTBJYO
         bBlB9zQqFoE1tfmMg3xHd9pgI11PYjcfO3Ta5JHIuhEzYKZTr4o9w5zuOnGrakuZoksG
         ZHVXkuBvG253i4A3tfL6Pwgf+HtvL4RaNLKtDz5Um8913lZvvDuPY1bD1Zad3vxX5WPE
         jQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1z/XYffrQE1ulbZWqvB17ZvgZDPHSFhdrO4bt0sud0=;
        b=OlMY/gG9sh6AbKUa0NQCmDH9n2aUvmvBioKmtcwnYIMKm5jRgy6bdLAXbkoTxRNJxv
         qEJrq3nkQ7MZu+aXZ/atSMe3J6fm0Cel1jvw7PjFUeUQIYvoc/vGJ0j7SqyU5mQW0ZfC
         9A4mWFXoLfZDPysoXH52Rris8YL9D1Gt1+uAMaBs/WsSa92XnpATAaEVrpozY+CaZ0NC
         52CzinKM55XFKAsjKaJzB5A68LMgHWdygFxbNsQGvqCgbVNHnEfU6MovXU+uoDthOQln
         EaC+m56eNi7ebuEaQ26pPJlxJqYFGRHiJD9mjHEJKYIz6t927+NOBB2MHJlK4PvJseaZ
         x9NQ==
X-Gm-Message-State: AJIora9z+iODWw/clN6zujHF+sOk2SQvNcMPux9ejfxjt6nvQ4Ic0VG3
        CJQZ+4LQVhpKHO4NFR7RJcnYq7Jj75QG/00PdsCdPw==
X-Google-Smtp-Source: AGRyM1vOYSphaV8U+fKakVnibkqv4glTuEdXHVh6JjOdl+7EiEGP/eDNnQirMA5rO1tyZG9VLt5QlYutmIVp385/51c=
X-Received: by 2002:a2e:3109:0:b0:25a:8a0c:40e2 with SMTP id
 x9-20020a2e3109000000b0025a8a0c40e2mr3237589ljx.26.1657323757825; Fri, 08 Jul
 2022 16:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220708211447.135209-1-justinstitt@google.com>
In-Reply-To: <20220708211447.135209-1-justinstitt@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 8 Jul 2022 16:42:25 -0700
Message-ID: <CAKwvOdmXCB7VoQLXfBgfyxdMvqaNeacMVbkCFptAqzX21KuPtg@mail.gmail.com>
Subject: Re: [PATCH] target: iscsi: fix clang -Wformat warning
To:     Justin Stitt <justinstitt@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 8, 2022 at 2:15 PM Justin Stitt <justinstitt@google.com> wrote:
>
> When building with Clang we encounter these warnings:
> | drivers/target/iscsi/iscsi_target_login.c:719:24: error: format
> | specifies type 'unsigned short' but the argument has type 'int'
> | [-Werror,-Wformat] " from node: %s\n", atomic_read(&sess->nconn),
> -
> | drivers/target/iscsi/iscsi_target_login.c:767:12: error: format
> | specifies type 'unsigned short' but the argument has type 'int'
> | [-Werror,-Wformat] " %s\n", atomic_read(&sess->nconn),
>
> For both warnings, the format specifier is `%hu` which describes an
> unsigned short. The resulting type of atomic_read is an int. The
> proposed fix is to listen to Clang and swap the format specifier.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>

See also:
https://lore.kernel.org/lkml/CAKwvOd=uOrDe5DWnXn7fx8+kTCF6gQVYhgqpnDFbaKunfBBVVg@mail.gmail.com/

> ---
>  drivers/target/iscsi/iscsi_target_login.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 6b94eecc4790..0778591abae7 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -715,7 +715,7 @@ void iscsi_post_login_handler(
>
>                 list_add_tail(&conn->conn_list, &sess->sess_conn_list);
>                 atomic_inc(&sess->nconn);
> -               pr_debug("Incremented iSCSI Connection count to %hu"
> +               pr_debug("Incremented iSCSI Connection count to %d"
>                         " from node: %s\n", atomic_read(&sess->nconn),
>                         sess->sess_ops->InitiatorName);
>                 spin_unlock_bh(&sess->conn_lock);
> @@ -763,7 +763,7 @@ void iscsi_post_login_handler(
>         spin_lock_bh(&sess->conn_lock);
>         list_add_tail(&conn->conn_list, &sess->sess_conn_list);
>         atomic_inc(&sess->nconn);
> -       pr_debug("Incremented iSCSI Connection count to %hu from node:"
> +       pr_debug("Incremented iSCSI Connection count to %d from node:"
>                 " %s\n", atomic_read(&sess->nconn),
>                 sess->sess_ops->InitiatorName);
>         spin_unlock_bh(&sess->conn_lock);
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>


-- 
Thanks,
~Nick Desaulniers
