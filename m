From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing test
Date: Mon, 22 Aug 2011 16:34:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108221632130.9774@swampdragon.chaosbits.net>
References: <1314021636-11528-2-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24746 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1HVOeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 10:34:01 -0400
In-Reply-To: <1314021636-11528-2-git-send-email-julia@diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: Robert Love <robert.w.love@intel.com>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The initializations of both fcoe_nport_scsi_transport and
> fcoe_vport_scsi_transport can fail, so test both of them.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
> statement S;
> @@
> 
> x = f(...);
> (
> if (\(x == NULL\|IS_ERR(x)\)) S
> |
> *if (\(y == NULL\|IS_ERR(y)\))
>  { ... when != x
>    return ...; }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/fcoe/fcoe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ba710e3..921b636 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1096,7 +1096,7 @@ static int __init fcoe_if_init(void)
>  	fcoe_vport_scsi_transport =
>  		fc_attach_transport(&fcoe_vport_fc_functions);
>  
> -	if (!fcoe_nport_scsi_transport) {
> +	if (!fcoe_nport_scsi_transport || !fcoe_vport_scsi_transport) {
>  		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
>  		return -ENODEV;
>  	}
> 

I only took a quick look, so I may have overlooked something, so bear with 
me.

fc_attach_transport() allocates memory with kzalloc. If either call fails 
the other may have succeeded and we'll leak the memory allocated to one of 
them.

Shouldn't we be kfree()'ing the two variables before the 'return -ENODEV'?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

