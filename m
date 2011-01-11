From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] cxgbi: set ulpmode only if digest is on
Date: Tue, 11 Jan 2011 14:24:59 -0600
Message-ID: <4D2CBC9B.4000007@cs.wisc.edu>
References: <201101072245.p07Mjdea027574@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47507 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1AKU2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2011 15:28:17 -0500
In-Reply-To: <201101072245.p07Mjdea027574@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 01/07/2011 04:45 PM, kxie@chelsio.com wrote:
> [PATCH 1/2] cxgbi: set ulpmode only if digest is on
>
> From: Karen Xie<kxie@chelsio.com>
>
> There is need to set ulpmode on the tx skbs if no digest is enabled.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>
> ---
>   drivers/scsi/cxgbi/libcxgbi.c |   17 ++++++++++-------
>   1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index be56617..17dcada 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1908,13 +1908,16 @@ EXPORT_SYMBOL_GPL(cxgbi_conn_alloc_pdu);
>
>   static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
>   {
> -	u8 submode = 0;
> -
> -	if (hcrc)
> -		submode |= 1;
> -	if (dcrc)
> -		submode |= 2;
> -	cxgbi_skcb_ulp_mode(skb) = (ULP2_MODE_ISCSI<<  4) | submode;
> +	if (hcrc || dcrc) {
> +		u8 submode = 0;
> +
> +		if (hcrc)
> +			submode |= 1;
> +		if (dcrc)
> +			submode |= 2;
> +		cxgbi_skcb_ulp_mode(skb) = (ULP2_MODE_ISCSI<<  4) | submode;
> +	} else
> +		cxgbi_skcb_ulp_mode(skb) = 0;
>   }
>
>   int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
>

Ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
