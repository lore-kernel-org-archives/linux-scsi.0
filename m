From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH] Fix libata-eh don't retry command after reset succeeded.
Date: Mon, 14 Jan 2013 09:01:12 -0500
Message-ID: <50F40FA8.4070101@teksavvy.com>
References: <201301141820562689358@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:37696 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175Ab3ANOBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2013 09:01:14 -0500
In-Reply-To: <201301141820562689358@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik <jgarzik@redhat.com>
Cc: ycbzzjlby <ycbzzjlby@gmail.com>, mlord <mlord@pobox.com>, linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

> 
> From 9cc9a85f17a8525e53caf430611d762c105d324c Mon Sep 17 00:00:00 2001
> From: Bian Yu <ycbzzjlby@gmail.com>
> Date: Tue, 18 Dec 2012 05:58:34 -0500
> Subject: [PATCH] Fix libata-eh don't retry command after reset succeeded.
>  It's introduced by commit 8d899e70c1b3afff, When disk has a UNC error,
>  qc->err_mask will set AC_ERR_MEDIA flag.
>  Signed-off-by: Bian Yu <ycbzzjlby@gmail.com>
>  
> ---
>  drivers/ata/libata-eh.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>  
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index bf039b0..bcf4437 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2094,7 +2094,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
>   */
>  static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
>  {
> -       if (qc->flags & AC_ERR_MEDIA)
> +       if (qc->err_mask & AC_ERR_MEDIA)
>                 return 0;       /* don't retry media errors */
>         if (qc->flags & ATA_QCFLAG_IO)
>                 return 1;       /* otherwise retry anything from fs stack */
> -- 
> 1.7.1

Yup, good catch.  The original patch to fix retries (from me) had it that way,
but somewhere among the enforced revisions this error crept in unnoticed.

Jeff -- wanna pick this one up?
Could be useful for -stable, too.

