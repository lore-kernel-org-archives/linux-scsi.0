From: Kees Cook <keescook@google.com>
Subject: Re: [patch] [SCSI] megaraid: missing bounds check in mimd_to_kioc()
Date: Wed, 20 Nov 2013 16:40:14 -0800
Message-ID: <CAGXu5j+nz5jhDSpuGhNY2bUxDW4indEjo5qj5fGaS8uQxSt3Fg@mail.gmail.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131030171351.GB4130@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45665 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3KUAkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 19:40:15 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so775002oag.30
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 16:40:14 -0800 (PST)
In-Reply-To: <20131030171351.GB4130@longonot.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, "security@kernel.org" <security@kernel.org>, Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>

Hi,

On Wed, Oct 30, 2013 at 10:13 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> pthru32->dataxferlen comes from the user so we need to check that it's
> not too large so we don't overflow the buffer.
>
> Reported-by: Nico Golde <nico@ngolde.de>
> Reported-by: Fabian Yamaguchi <fabs@goesec.de>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

I don't see this in Linus's tree nor linux-next yet. Can someone pick this up?

Thanks!

-Kees

> ---
> Please review this carefully because I have not tested it.
>
> diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
> index dfffd0f..a706927 100644
> --- a/drivers/scsi/megaraid/megaraid_mm.c
> +++ b/drivers/scsi/megaraid/megaraid_mm.c
> @@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
>
>         pthru32->dataxferaddr   = kioc->buf_paddr;
>         if (kioc->data_dir & UIOC_WR) {
> +               if (pthru32->dataxferlen > kioc->xferlen)
> +                       return -EINVAL;
>                 if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
>                                                 pthru32->dataxferlen)) {
>                         return (-EFAULT);
>



-- 
Kees Cook
Chrome OS Security
