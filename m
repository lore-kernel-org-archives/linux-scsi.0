From: weiping zhang <zhangweiping@didichuxing.com>
Subject: Re: [PATCH] scsi-sysfs: correct errno for host_reset
Date: Mon, 14 Aug 2017 20:30:35 +0800
Message-ID: <20170814123035.GA22428@bogon.didichuxing.com>
References: <20170810175212.GA19528@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.didichuxing.com ([111.202.154.82]:29425 "EHLO
        BJEXCAS003.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752946AbdHNMaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 08:30:46 -0400
Content-Disposition: inline
In-Reply-To: <20170810175212.GA19528@localhost.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 01:52:17AM +0800, weiping zhang wrote:
> if scsi_host_template->host_reset is NULL, when user
> "echo adapter > /sys/class/scsi_host/hostx/host_reset",
> -EINVAL will return even string compare successfully. It make user confuse.
> 
> change to:
> -EINVAL		if string not match "adapter" / "firmware";
> -EOPNOTSUPP	if string match but not implement ->host_reset.
> 
> Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dff8faf..3e664f4 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -272,6 +272,8 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
>  
>  	if (sht->host_reset)
>  		ret = sht->host_reset(shost, type);
> +	else
> +		ret = -EOPNOTSUPP;
>  
>  exit_store_host_reset:
>  	if (ret == 0)
> -- 
Hi Martin,

Could you please take a look at this patch at your convinience.

thanks
