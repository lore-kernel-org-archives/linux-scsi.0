From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v3 2/3] scsi: libsas: fix error when getting phy events
Date: Mon, 8 Jan 2018 10:02:22 +0100
Message-ID: <b33c22a8-1ba1-592d-591d-7c28af96f569@suse.com>
References: <20180104130433.42813-1-yanaijie@huawei.com>
 <20180104130433.42813-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:38199 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755087AbeAHJC1 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 8 Jan 2018 04:02:27 -0500
In-Reply-To: <20180104130433.42813-3-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, John Garry <john.garry@huawei.com>, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>

On 01/04/2018 02:04 PM, Jason Yan wrote:
> The intend purpose here was to goto out if smp_execute_task() returned
> error. Obviously something got screwed up. We will never get these link
> error statistics below:
> 
> ~:/sys/class/sas_phy/phy-1:0:12 # cat invalid_dword_count
> 0
> ~:/sys/class/sas_phy/phy-1:0:12 # cat running_disparity_error_count
> 0
> ~:/sys/class/sas_phy/phy-1:0:12 # cat loss_of_dword_sync_count
> 0
> ~:/sys/class/sas_phy/phy-1:0:12 # cat phy_reset_problem_count
> 0
> 
> Obviously we should goto error handler if smp_execute_task() returns
> non-zero.
> 
> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: chenqilin <chenqilin2@huawei.com>
> CC: chenxiang <chenxiang66@hisilicon.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_expander.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 4b0c67f..6eab487 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -686,7 +686,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
>  	res = smp_execute_task(dev, req, RPEL_REQ_SIZE,
>  			            resp, RPEL_RESP_SIZE);
>  
> -	if (!res)
> +	if (res)
>  		goto out;
>  
>  	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
