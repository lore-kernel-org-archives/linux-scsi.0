From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [Open-FCoE] [PATCH] fcoe: fix reset of fip selection time.
Date: Mon, 29 Feb 2016 15:16:27 -0500
Message-ID: <20160229201627.GA11220@hmsreliant.think-freely.org>
References: <20160229113652.2680.73280.stgit@ukketine.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39060 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbcB2UQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 15:16:42 -0500
Content-Disposition: inline
In-Reply-To: <20160229113652.2680.73280.stgit@ukketine.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Usha Ketineni <usha.k.ketineni@intel.com>
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

On Mon, Feb 29, 2016 at 03:36:52AM -0800, Usha Ketineni wrote:
> Do not reset fip selection time for every advertisement
> in fcoe_ctlr_recv_adv() but set it only once for the first
> validated FCF. Otherwise FCF selection won't happen when the
> advertisements consistently arrive with sub FCOE_CTLR_START_DELAY
> periodicity.
> 
> Tested-by: Narendra K <narendra_k@dell.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Acked-by: Vasu Dev <vasu.dev@intel.com>
> Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index d68d572..0c85ef6 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -1079,7 +1079,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
>  	 * If this is the first validated FCF, note the time and
>  	 * set a timer to trigger selection.
>  	 */
> -	if (mtu_valid && !fip->sel_fcf && fcoe_ctlr_fcf_usable(fcf)) {
> +	if (mtu_valid && !fip->sel_fcf && !fip->sel_time &&
> +	    fcoe_ctlr_fcf_usable(fcf)) {
>  		fip->sel_time = jiffies +
>  			msecs_to_jiffies(FCOE_CTLR_START_DELAY);
>  		if (!timer_pending(&fip->timer) ||
> 
> _______________________________________________
> fcoe-devel mailing list
> fcoe-devel@open-fcoe.org
> http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

