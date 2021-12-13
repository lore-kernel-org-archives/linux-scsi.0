Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E815C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 11:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhLMLVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 06:21:14 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4261 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhLMLVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 06:21:13 -0500
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJv764Qfz67ySK;
        Mon, 13 Dec 2021 19:19:47 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 12:21:11 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 11:21:10 +0000
Subject: Re: [PATCH 11/15] scsi: libsas: Refactor out
 sas_queue_deferred_work()
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-12-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <29a7ccb2-9b25-5da7-2a3e-609718593ecd@huawei.com>
Date:   Mon, 13 Dec 2021 11:20:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-12-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.94]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please consider these:

On 17/11/2021 02:45, chenxiang wrote:

I'd have "scsi: libsas: Refactor sas_queue_deferred_work()"

> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> In the 2rd part of function __sas_drain_work, it queues defer work. And it
> will be used in other places, so refactor out sas_queue_deferred_work().

The second part of the function __sas_drain_work() queues the deferred 
work. This functionality would be duplicated in other places, so factor 
out into sas_queue_deferred_work().

Thanks,
John

> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/libsas/sas_event.c    | 25 ++++++++++++++-----------
>   drivers/scsi/libsas/sas_internal.h |  1 +
>   2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index af605620ea13..01e544ca518a 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -41,12 +41,23 @@ static int sas_queue_event(int event, struct sas_work *work,
>   	return rc;
>   }
>   
> -
> -void __sas_drain_work(struct sas_ha_struct *ha)
> +void sas_queue_deferred_work(struct sas_ha_struct *ha)
>   {
>   	struct sas_work *sw, *_sw;
>   	int ret;
>   
> +	spin_lock_irq(&ha->lock);
> +	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
> +		list_del_init(&sw->drain_node);
> +		ret = sas_queue_work(ha, sw);
> +		if (ret != 1)
> +			sas_free_event(to_asd_sas_event(&sw->work));
> +	}
> +	spin_unlock_irq(&ha->lock);
> +}
> +
> +void __sas_drain_work(struct sas_ha_struct *ha)
> +{
>   	set_bit(SAS_HA_DRAINING, &ha->state);
>   	/* flush submitters */
>   	spin_lock_irq(&ha->lock);
> @@ -55,16 +66,8 @@ void __sas_drain_work(struct sas_ha_struct *ha)
>   	drain_workqueue(ha->event_q);
>   	drain_workqueue(ha->disco_q);
>   
> -	spin_lock_irq(&ha->lock);
>   	clear_bit(SAS_HA_DRAINING, &ha->state);
> -	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
> -		list_del_init(&sw->drain_node);
> -		ret = sas_queue_work(ha, sw);
> -		if (ret != 1)
> -			sas_free_event(to_asd_sas_event(&sw->work));
> -
> -	}
> -	spin_unlock_irq(&ha->lock);
> +	sas_queue_deferred_work(ha);
>   }
>   
>   int sas_drain_work(struct sas_ha_struct *ha)
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index ad9764a976c3..acd515c01861 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -57,6 +57,7 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha);
>   
>   void sas_disable_revalidation(struct sas_ha_struct *ha);
>   void sas_enable_revalidation(struct sas_ha_struct *ha);
> +void sas_queue_deferred_work(struct sas_ha_struct *ha);
>   void __sas_drain_work(struct sas_ha_struct *ha);
>   
>   void sas_deform_port(struct asd_sas_phy *phy, int gone);
> 

