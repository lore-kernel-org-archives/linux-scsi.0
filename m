Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A32C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Jan 2022 18:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243299AbiA3SAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Jan 2022 13:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiA3SAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jan 2022 13:00:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17FBC061714;
        Sun, 30 Jan 2022 10:00:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id p7so22316535edc.12;
        Sun, 30 Jan 2022 10:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hifISJNHBmnFk0GC+A9Z0ayqNnCFaEB7i+E3Na0lpu0=;
        b=VVko/nJ6k+qZW+S4gH+Mc8gh07d2IL6mV7xXmaND9vpbFfjZ6GcK+4ZNxh0bDtcilr
         uH/awgMFbXkxznR0O1mO7clmHnYfzqSMEcy+7OhhSY25vfuoyrbfDVWfbDq2wxE1cO+S
         rSVnpzg6B7vXrp9usdCPc0//qZoHJ2F2C+UWM7JWuCtdsTPhDR03jGBC1AZ+sCrbdpSs
         +ATcsG13Wvn7wmG4ozk11b4yaUIgjUN+lrvRnpDauMO4HVTo9S6tyhzeOxnYGCX+nuG9
         A/vNkxVuVIaFtJc0YOni9uRC4W8qMUNy8Ba3YGdBszQmrXLRUoVi3YjBhHYYAmi/nHEu
         U5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hifISJNHBmnFk0GC+A9Z0ayqNnCFaEB7i+E3Na0lpu0=;
        b=iWy9+0kiMa0VEpZxShTwPkB+OyOTBhxX+TwJ79t971laVhdPG2VJUBt/iCmKumtf1A
         iLXPf11kQylW6G42pBPpMg+duEa5au1C5lf+mMTyNf6Wrk3BYLR9zYcwM4rUlGPCAv0l
         o5TyDFTWiV1jY2E8dm1a9x0hqswrHYGPTG3sxv8dPlrSR+8+ayHuXwkPbTMXJeWtJYFu
         8DIubYVdhMjDcsq6sjviagefz9+u3PUOXiO1qjBE2tlWsCzioFV/nfywWP+0kJ2vkIj6
         Jk3MXWDXVfiZw4zYtSJFBy8LdO1Vmyj/2IwcgS/BCeSt1yUlIgg2zLqlQpRQ5cf5ljkw
         gMqQ==
X-Gm-Message-State: AOAM532wuB0JKhnIzSe2/2JTlnrTp6FJ6P7BZPs6lwG4vaOIlF+iOZ5V
        8PjgmJoA0c63jPE/CgfcLZ9nkVveB4gRC+nIjE8=
X-Google-Smtp-Source: ABdhPJw/7sZ/WX230/bQO9F/RVXuatPnwm/FcMRjriLox5Qz6EKrPVNP272AC5aFbSbGb+uPn1LUYKm+kA3WKxubY8s=
X-Received: by 2002:a05:6402:1601:: with SMTP id f1mr17288718edv.165.1643565632215;
 Sun, 30 Jan 2022 10:00:32 -0800 (PST)
MIME-Version: 1.0
References: <20220127084754.GA25644@kili>
In-Reply-To: <20220127084754.GA25644@kili>
From:   Mark Mielke <mark.mielke@gmail.com>
Date:   Sun, 30 Jan 2022 13:00:21 -0500
Message-ID: <CALm7yL0Z-A1mk5OfonTU9zu2izO54Q65nX55fpNYeaeaiZKX0A@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use strcmp() instead of strncmp()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, I knee jerk react to "partial match", which was a red flag for
me, so strncmp() is almost never used for "partial match" in my
experience. :-)

It's really that strncmp() should be used for buffer overflow
protection, but in this case - it's not. Since, the ", 5" applies to
the clearly visible "=All" that is both allocated and '\0' terminated.
It should be against the remaining buffer size of text_ptr. So,
removing the ", 5" leaves it equally as bad at buffer overflow
protection as it was before. :-)

On Thu, Jan 27, 2022 at 10:19 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> We want to match the whole string "=All" and this code does that, but
> strncmp() is normally used for a partial match and it's more readable
> to use strcmp().
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..4534101a7376 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -2213,7 +2213,7 @@ iscsit_process_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>         /* '=' confirmed in strncmp */
>         text_ptr = strchr(text_in, '=');
>         BUG_ON(!text_ptr);
> -       if (!strncmp("=All", text_ptr, 5)) {
> +       if (!strcmp("=All", text_ptr)) {
>                 cmd->cmd_flags |= ICF_SENDTARGETS_ALL;
>         } else if (!strncmp("=iqn.", text_ptr, 5) ||
>                    !strncmp("=eui.", text_ptr, 5)) {
> --
> 2.20.1
>


-- 
Mark Mielke <mark.mielke@gmail.com>
