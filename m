From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 1/2] libsas: Don't process sas events in static works
Date: Wed, 14 Jun 2017 10:48:40 +0200
Message-ID: <692abe7a-149f-c1bf-5f28-3e36cad81b5a@suse.de>
References: <1497425597-18799-1-git-send-email-wangyijing@huawei.com>
 <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497425597-18799-2-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Yousong He <heyousong@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 06/14/2017 09:33 AM, Yijing Wang wrote:
> Now libsas hotplug work is static, LLDD driver queue
> the hotplug work into shost->work_q. If LLDD driver
> burst post lots hotplug events to libsas, the hotplug
> events may pending in the workqueue like
> 
> shost->work_q
> new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
>                                 |<-------wait worker to process-------->|
> In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue it
> to shost->work_q, but this work is already pending, so it would be lost.
> Finally, libsas delete the related sas port and sas devices, but LLDD driver
> expect libsas add the sas port and devices(last sas event).
> 
> This patch remove the static defined hotplug work, and use dynamic work to
> avoid missing hotplug events.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Yousong He <heyousong@huawei.com>
> Signed-off-by: Qilin Chen <chenqilin2@huawei.com>
> ---

[...]

>  static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>  {
> +	struct sas_ha_event *ev;
> +
>  	BUG_ON(event >= HA_NUM_EVENTS);
>  
> -	sas_queue_event(event, &sas_ha->pending,
> -			&sas_ha->ha_events[event].work, sas_ha);
> +	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
> +	if (!ev)
> +		return;
GFP_ATOMIC allocations can fail and then no events will be queued *and* we
don't report the error back to the caller.



> index 64e9cdd..c227a8b 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -111,10 +111,6 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
>  
>  void sas_hae_reset(struct work_struct *work)
>  {
> -	struct sas_ha_event *ev = to_sas_ha_event(work);
> -	struct sas_ha_struct *ha = ev->ha;
> -
> -	clear_bit(HAE_RESET, &ha->pending);
>  }

I don't really get why you need a stubbed out sas_hae_reset(). Can't we
just kill it if it doesn't have anything left to do?


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
