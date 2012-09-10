From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH] [SCSI] libfcoe: use list_move instead of
 list_del/list_add
Date: Mon, 10 Sep 2012 18:07:26 +0000
Message-ID: <138EA028228D124A900F5E6746F3C2162F4E66A1@ORSMSX102.amr.corp.intel.com>
References: <CAPgLHd_m2J1W8Su4NJuShHTzwdb94t=-8=oFv6=r1OL5735uyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2IJSH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2012 14:07:28 -0400
In-Reply-To: <CAPgLHd_m2J1W8Su4NJuShHTzwdb94t=-8=oFv6=r1OL5735uyQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, "Love, Robert W" <robert.w.love@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move() instead of list_del() + list_add().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 2ebe03a..44b4d99 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -817,8 +817,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr
> *fip)
>  			 * fcoe_sysfs_fcf_del (which can sleep)
>  			 * after the put_cpu().
>  			 */
> -			list_del(&fcf->list);
> -			list_add(&fcf->list, &del_list);
> +			list_move(&fcf->list, &del_list);
>  			stats->VLinkFailureCount++;
>  		} else {
>  			if (time_after(next_timer, deadline))
> 

Looks good to me, thanks,

Reviewed-by: Yi Zou <yi.zou@intel.com>



