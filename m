From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Wed, 14 Jun 2017 17:28:34 +0800
Message-ID: <594101C2.702@huawei.com>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
 <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de> <5940FC1C.5050000@huawei.com>
 <3c713ab7-c958-ab1a-0a12-cdd5e876e845@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3c713ab7-c958-ab1a-0a12-cdd5e876e845@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Yousong He <heyousong@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/6/14 17:18, Johannes Thumshirn 写道:
> On 06/14/2017 11:04 AM, wangyijing wrote:
>>>>  static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>>>>  {
>>>> +	struct sas_ha_event *ev;
>>>> +
>>>>  	BUG_ON(event >= HA_NUM_EVENTS);
>>>>  
>>>> -	sas_queue_event(event, &sas_ha->pending,
>>>> -			&sas_ha->ha_events[event].work, sas_ha);
>>>> +	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
>>>> +	if (!ev)
>>>> +		return;
>>> GFP_ATOMIC allocations can fail and then no events will be queued *and* we
>>> don't report the error back to the caller.
>>>
>>
>> Yes, it's really a problem, but I don't find a better solution, do you have some suggestion ?
> 
> Something like this?
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c
> b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index d622db502ec9..27cd7307d308 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -894,7 +894,11 @@ static int hisi_sas_controller_reset(struct
> hisi_hba *hisi_hba)
>                 hisi_sas_release_tasks(hisi_hba);
>                 spin_unlock_irqrestore(&hisi_hba->lock, flags);
> 
> -               sas_ha->notify_ha_event(sas_ha, HAE_RESET);
> +               rc = sas_ha->notify_ha_event(sas_ha, HAE_RESET);
> +               if (rc) {
> +                       dev_warn(dev, "failed to queue HA event (%d)\n",
> rc);
> +                       goto out;
> +               }
>                 dev_dbg(dev, "controller reset successful!\n");
>         } else
>                 return -1;
> diff --git a/drivers/scsi/libsas/sas_event.c
> b/drivers/scsi/libsas/sas_event.c
> index aadbd5314c5c..6c91fb31f891 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -116,7 +116,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
>         mutex_unlock(&ha->disco_mutex);
>  }
> 
> -static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event
> event)
> +static int notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event
> event)
>  {
>         BUG_ON(event >= HA_NUM_EVENTS);
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index dd0f72c95abe..5d9cd6d20855 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -415,7 +415,7 @@ struct sas_ha_struct {
>                                 * their siblings when forming wide ports */
> 
>         /* LLDD calls these to notify the class of an event. */
> -       void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
> +       int (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
>         void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
>         void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);

This make sense, return a fail status and report it to the callers.


> 
> 
