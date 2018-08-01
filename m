From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] fcoe: fix use-after-free in fcoe_ctlr_els_send
Date: Wed, 1 Aug 2018 08:30:13 +0200
Message-ID: <a3ad59a7-3ccb-46e7-60b6-6ce073417564@suse.de>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180731134603.20089-2-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731134603.20089-2-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, ard <ard@kwaak.net>
List-Id: linux-scsi@vger.kernel.org

On 07/31/2018 03:46 PM, Johannes Thumshirn wrote:
> KASAN reports a use-after-free in fcoe_ctlr_els_send() when we're
> sending a LOGO and have FIP debugging enabled. This is because we're
> first freeing the skb and then printing the frame's DID. But the DID
> is a member of the FC frame header which in turn is the skb's payload.
> 
> Exchange the debug print and kfree_skb() calls so we're not touching
> the freed data.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index ea23c8dffc25..ceb35ebbeb8f 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -799,9 +799,9 @@ int fcoe_ctlr_els_send(struct fcoe_ctlr *fip, struct fc_lport *lport,
>  	fip->send(fip, skb);
>  	return -EINPROGRESS;
>  drop:
> -	kfree_skb(skb);
>  	LIBFCOE_FIP_DBG(fip, "drop els_send op %u d_id %x\n",
>  			op, ntoh24(fh->fh_d_id));
> +	kfree_skb(skb);
>  	return -EINVAL;
>  }
>  EXPORT_SYMBOL(fcoe_ctlr_els_send);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
