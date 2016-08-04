From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/22] fcoe: filter out frames from invalid vlans
Date: Thu, 4 Aug 2016 13:35:03 +0200
Message-ID: <20160804113503.gshhvmocfcf2pp33@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbcHDLgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 07:36:44 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On Wed, Aug 03, 2016 at 03:13:07PM +0200, Hannes Reinecke wrote:
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 1d0bec6..e7a14aa 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -2710,11 +2710,21 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
>  		struct fc_rport_priv rdata;
>  		struct fcoe_rport frport;
>  	} buf;
> -	int rc;
> +	int rc, vlan_id = 0;
>  
>  	fiph = (struct fip_header *)skb->data;
>  	sub = fiph->fip_subcode;
>  
> +	if (fip->lp->vlan)
> +		vlan_id = skb_vlan_tag_get_id(skb);
> +
> +	if (vlan_id && vlan_id != fip->lp->vlan) {
> +		LIBFCOE_FIP_DBG(fip, "vn_recv drop frame sub %x vlan %d\n",
> +				sub, vlan_id);
> +		rc = -EAGAIN;
> +		goto drop;
> +	}
> +
>  	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
>  	if (rc) {
>  		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
> -- 
> 1.8.5.6

-ENOSIGNEDOFF and while you're at it, can you give 1 or 2 lines why we need to
filter it out in the commit message.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
