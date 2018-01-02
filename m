From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/3] scsi: libsas: fix error when getting phy events
Date: Tue, 2 Jan 2018 13:50:00 +0000
Message-ID: <e88b6f32-4830-2cd9-9239-937a136a0254@huawei.com>
References: <20180102121510.12570-1-yanaijie@huawei.com>
 <20180102121510.12570-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:49665 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751622AbeABNu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jan 2018 08:50:27 -0500
In-Reply-To: <20180102121510.12570-3-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>, Linuxarm <linuxarm@huawei.com>

On 02/01/2018 12:15, Jason Yan wrote:
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
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: chenqilin <chenqilin2@huawei.com>
> CC: chenxiang <chenxiang66@hisilicon.com>
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

This seems to have been broken for some time.

Could you inject some errors on the link to verify that this function 
actually works properly with this change, i.e. non-zero reading?

Thanks,
John

>
>  	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
>
