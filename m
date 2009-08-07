From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] drivers/scsi: Check NULL for kmalloc() return
Date: Fri, 07 Aug 2009 19:54:43 +0000
Message-ID: <1249674883.8183.223.camel@mulgrave.site>
References: <20090807183953.GA22286@fencepost.gnu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35493 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933185AbZHGTyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 15:54:46 -0400
In-Reply-To: <20090807183953.GA22286@fencepost.gnu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Davidlohr Bueso A." <dave@gnu.org>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, 2009-08-07 at 14:39 -0400, Davidlohr Bueso A. wrote:
> Verify that ch->dt is not NULL before using it:
> ch-dt[elem] = value;
> 
> Signed-off-by: Davidlohr Bueso

This actually needs to be an email address, not just a name, so

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

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

This isn't quite right because you'll leak the memory allocated for
buffer here.

For bonus points, the GFP_DMA in the kzalloc() of buffer is bogus ...
this routine can sleep at all points.

James


