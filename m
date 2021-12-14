Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D15EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 12:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhLNMes (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 07:34:48 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4275 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhLNMer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 07:34:47 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCyQ74NXHz67tlm;
        Tue, 14 Dec 2021 20:30:23 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 13:34:45 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Tue, 14 Dec
 2021 12:34:44 +0000
Subject: Re: [PATCH 14/15] scsi: libsas: Keep sas host active until finished
 some work
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-15-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c05f5d30-bc2a-6933-4f27-589242fb84d4@huawei.com>
Date:   Tue, 14 Dec 2021 12:34:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-15-git-send-email-chenxiang66@hisilicon.com>
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

Please consider som rewrite:

On 17/11/2021 02:45, chenxiang wrote:

"scsi: libsas: Keep sas host active until finished some work" -> "scsi: 
libsas: Keep host active while processing events"

> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> For those works from event queue, if executing them such as
> PORTE_BROADCAST_RCVD when sas host is suspended, it will resume sas host
> firstly as SMP IOs are sent in the process. So phyup will occur and it
> will call work PORTE_BYTES_DMAED. But the original work (such as
> PORTE_BROADCAST_RCVD) and the work PORTE_BYTES_DMAED are in the same
> singlethread workqueue, so the complete of original work waits for
> the complete of work PORTE_BYTES_DMAED while the complete of work
> PORTE_BYTES_DMAED wait for the complete of original and it is blocked.
> 
> So call pm_runtime_get_noresume() to keep sas host active until
> finished those works.
Processing events such as PORTE_BROADCAST_RCVD may cause dependency 
issues for runtime power management support.

Such a problem would be that handling a PORTE_BROADCAST_RCVD event 
requires that the host is resumed to send SMP commands. However, in 
resuming the host, the phyup events generated from re-enabling the phys 
are processed in the same workqueue as the original PORTE_BROADCAST_RCVD 
event. As such, the host will never finish resuming (as it waits for the 
phyup event processing), and then the PORTE_BROADCAST_RCVD event cannot 
be processed as the SMP commands are blocked, and so we have a deadlock.

Solve this problem by ensuring that libsas keeps the host active until 
completely finished processing phy or port events, such as 
PORTE_BYTES_DMAED. As such, we don't have to worry about resuming the 
host for processing individual SMP commands in this example.

> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Reviewed-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/libsas/sas_event.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index 626ef96b9348..3613b9b315bc 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -50,8 +50,10 @@ void sas_queue_deferred_work(struct sas_ha_struct *ha)
>   	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
>   		list_del_init(&sw->drain_node);
>   		ret = sas_queue_work(ha, sw);
> -		if (ret != 1)
> +		if (ret != 1) {
> +			pm_runtime_put(ha->dev);
>   			sas_free_event(to_asd_sas_event(&sw->work));
> +		}
>   	}
>   	spin_unlock_irq(&ha->lock);
>   }
> @@ -126,16 +128,22 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
>   static void sas_port_event_worker(struct work_struct *work)
>   {
>   	struct asd_sas_event *ev = to_asd_sas_event(work);
> +	struct asd_sas_phy *phy = ev->phy;
> +	struct sas_ha_struct *ha = phy->ha;
>   
>   	sas_port_event_fns[ev->event](work);
> +	pm_runtime_put(ha->dev);
>   	sas_free_event(ev);
>   }
>   
>   static void sas_phy_event_worker(struct work_struct *work)
>   {
>   	struct asd_sas_event *ev = to_asd_sas_event(work);
> +	struct asd_sas_phy *phy = ev->phy;
> +	struct sas_ha_struct *ha = phy->ha;
>   
>   	sas_phy_event_fns[ev->event](work);
> +	pm_runtime_put(ha->dev);
>   	sas_free_event(ev);
>   }
>   
> @@ -170,14 +178,19 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>   	if (!ev)
>   		return -ENOMEM;
>   
> +	/* Call pm_runtime_put() with pairs in sas_port_event_worker() */
> +	pm_runtime_get_noresume(ha->dev);
> +
>   	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
>   
>   	if (sas_defer_event(phy, ev))
>   		return 0;
>   
>   	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1)
> +	if (ret != 1) {
> +		pm_runtime_put(ha->dev);
>   		sas_free_event(ev);
> +	}
>   
>   	return ret;
>   }
> @@ -196,14 +209,19 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>   	if (!ev)
>   		return -ENOMEM;
>   
> +	/* Call pm_runtime_put() with pairs in sas_phy_event_worker() */
> +	pm_runtime_get_noresume(ha->dev);
> +
>   	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
>   
>   	if (sas_defer_event(phy, ev))
>   		return 0;
>   
>   	ret = sas_queue_event(event, &ev->work, ha);
> -	if (ret != 1)
> +	if (ret != 1) {
> +		pm_runtime_put(ha->dev);
>   		sas_free_event(ev);
> +	}
>   
>   	return ret;
>   }
> 

