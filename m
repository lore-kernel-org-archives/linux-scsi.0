From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 11/17] smartpqi: minor tweaks to update time support
Date: Mon, 29 Aug 2016 11:33:38 +0200
Message-ID: <20160829093338.3juwfp6xcjzib26h@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222991200.31214.16478440159265351246.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756937AbcH2Jdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 05:33:45 -0400
Content-Disposition: inline
In-Reply-To: <147222991200.31214.16478440159265351246.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Fri, Aug 26, 2016 at 11:45:12AM -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
> 
> minor tweaks to update time support
> 
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 2759c90..a8b8671 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -588,10 +588,6 @@ static void pqi_update_time_worker(struct work_struct *work)
>  	ctrl_info = container_of(to_delayed_work(work), struct pqi_ctrl_info,
>  		update_time_work);
>  
> -	if (!ctrl_info) {
> -		printk("%s: NULL controller pointer.\n", __func__);
> -		return;
> -	}
>  	rc = pqi_write_current_time_to_host_wellness(ctrl_info);
>  	if (rc)
>  		dev_warn(&ctrl_info->pci_dev->dev,
> @@ -602,9 +598,9 @@ static void pqi_update_time_worker(struct work_struct *work)
>  }
>  
>  static inline void pqi_schedule_update_time_worker(
> -			struct pqi_ctrl_info *ctrl_info)
> +	struct pqi_ctrl_info *ctrl_info)
>  {
> -	schedule_delayed_work(&ctrl_info->update_time_work, 120);
> +	schedule_delayed_work(&ctrl_info->update_time_work, 0);
>  }

Why are you using schedule_delayed_work() if you have a timeout of 0?
>From __queue_delayed_work():
1513         /*
1514          * If @delay is 0, queue @dwork->work immediately.  This is for
1515          * both optimization and correctness.  The earliest @timer can
1516          * expire is on the closest next tick and delayed_work users depend
1517          * on that there's no such delay when @delay is 0.
1518          */
1519         if (!delay) {
1520                 __queue_work(cpu, wq, &dwork->work);
1521                 return;
1522         }


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
