From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/scsi: Check NULL for kmalloc() return
Date: Fri, 7 Aug 2009 20:54:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0908072054080.8253@ask.diku.dk>
References: <20090807183953.GA22286@fencepost.gnu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:33488 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbZHGTAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Aug 2009 15:00:33 -0400
In-Reply-To: <20090807183953.GA22286@fencepost.gnu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Davidlohr Bueso A." <dave@gnu.org>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, 7 Aug 2009, Davidlohr Bueso A. wrote:

> Verify that ch->dt is not NULL before using it:
> ch-dt[elem] = value;

It looks like buffer should be freed as well?

julia

> Signed-off-by: Davidlohr Bueso
> 
> ---
>  drivers/scsi/ch.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index 7b1633a..96cbd20 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -353,6 +353,10 @@ ch_readconfig(scsi_changer *ch)
>         /* look up the devices of the data transfer elements */
>         ch->dt = kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_device),
>                          GFP_KERNEL);
> +
> +       if (!ch->dt)
> +               return -ENOMEM;
> +
>         for (elem = 0; elem < ch->counts[CHET_DT]; elem++) {
>                 id  = -1;
>                 lun = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
