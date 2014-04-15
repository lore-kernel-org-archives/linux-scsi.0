From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] aic79xx: fix misuse of static variables
Date: Tue, 15 Apr 2014 08:11:10 +0200
Message-ID: <CA+rthh9Rk+y=zBahWdU3xS2WqsvWwcoyY6YWJKojtSweAaOYzQ@mail.gmail.com>
References: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47022 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaDOGLL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2014 02:11:11 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so6469053lbj.17
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 23:11:10 -0700 (PDT)
In-Reply-To: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Mathias Krause <minipli@googlemail.com>, PaX Team <pageexec@freemail.hu>

On 30 March 2014 15:30, Mathias Krause <minipli@googlemail.com> wrote:
> The format strings for various printk()s make use of a temporary
> variable that is declared 'static'. This is probably not intended,
> so fix those.
>
> Found in the PaX patch, written by the PaX Team.
>
> Cc: PaX Team <pageexec@freemail.hu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>
> Remark: Compile tested only! I've no such hardware.
>
>  drivers/scsi/aic7xxx/aic79xx_pci.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
> index 14b5f8d0e7..cc9bd26f5d 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
> @@ -827,7 +827,7 @@ ahd_pci_intr(struct ahd_softc *ahd)
>                 for (bit = 0; bit < 8; bit++) {
>
>                         if ((pci_status[i] & (0x1 << bit)) != 0) {
> -                               static const char *s;
> +                               const char *s;
>
>                                 s = pci_status_strings[bit];
>                                 if (i == 7/*TARG*/ && bit == 3)
> @@ -887,23 +887,15 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat)
>
>                 for (bit = 0; bit < 8; bit++) {
>
> -                       if ((split_status[i] & (0x1 << bit)) != 0) {
> -                               static const char *s;
> -
> -                               s = split_status_strings[bit];
> -                               printk(s, ahd_name(ahd),
> +                       if ((split_status[i] & (0x1 << bit)) != 0)
> +                               printk(split_status_strings[bit], ahd_name(ahd),
>                                        split_status_source[i]);
> -                       }
>
>                         if (i > 1)
>                                 continue;
>
> -                       if ((sg_split_status[i] & (0x1 << bit)) != 0) {
> -                               static const char *s;
> -
> -                               s = split_status_strings[bit];
> -                               printk(s, ahd_name(ahd), "SG");
> -                       }
> +                       if ((sg_split_status[i] & (0x1 << bit)) != 0)
> +                               printk(split_status_strings[bit], ahd_name(ahd), "SG");
>                 }
>         }
>         /*
> --
> 1.7.10.4
>

Ping? James, Hannes? How to proceed with this patch?

Mathias
