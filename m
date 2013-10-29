From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] [SCSI] hpsa: fix return value check in start_controller_lockup_detector()
Date: Tue, 29 Oct 2013 11:09:27 -0500
Message-ID: <20131029160927.GB31390@beardog.cce.hp.com>
References: <CAPgLHd8NoumfDWXN7fqDucWJ7Nr0KppW=24sCJpn9ynGOzLhcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1967 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3J2QJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 12:09:35 -0400
Content-Disposition: inline
In-Reply-To: <CAPgLHd8NoumfDWXN7fqDucWJ7Nr0KppW=24sCJpn9ynGOzLhcQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: JBottomley@parallels.com, yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Tue, Oct 29, 2013 at 02:43:56PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function kthread_run() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/hpsa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 891c86b..f413b14 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -4757,7 +4757,8 @@ static void start_controller_lockup_detector(struct ctlr_info *h)
>  			kthread_run(detect_controller_lockup_thread,
>  						NULL, HPSA);
>  	}
> -	if (!hpsa_lockup_detector) {
> +	if (IS_ERR(hpsa_lockup_detector)) {
> +		hpsa_lockup_detector = NULL;
>  		dev_warn(&h->pdev->dev,
>  			"Could not start lockup detector thread\n");
>  		return;

Ack.

Thanks.

-- steve

