From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sg: remove unreachable code in SET_FORCE_LOW_DMA
Date: Wed, 1 Feb 2017 14:00:48 +0100
Message-ID: <20170201130048.GA5125@lst.de>
References: <1485948399-83339-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35144 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdBANAu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 08:00:50 -0500
Content-Disposition: inline
In-Reply-To: <1485948399-83339-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Feb 01, 2017 at 12:26:39PM +0100, Hannes Reinecke wrote:
> The low_dma value is always '1' in that branch, so the remaining
> 'if' statement can never be reached.
>
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/sg.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index dbe5b4b..652b934 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -890,14 +890,9 @@ static int max_sectors_bytes(struct request_queue *q)
>  		result = get_user(val, ip);
>  		if (result)
>  			return result;
> -		if (val) {
> +		if (val)
>  			sfp->low_dma = 1;
> -			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
> -				val = (int) sfp->reserve.bufflen;
> -				sg_remove_scat(sfp, &sfp->reserve);
> -				sg_build_reserve(sfp, val);
> -			}
> -		} else {
> +		else {

I think the proper fix is to check sfp->low_dma for 0 before updating
it, at least that seems to be the intent here.
