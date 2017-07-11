From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 1/7] libsas: Use static sas event pool to appease sas
 event lost
Date: Tue, 11 Jul 2017 16:37:25 +0100
Message-ID: <e45b90d1-9547-3845-9114-b794277d6c72@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-2-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-2-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/07/2017 08:06, Yijing Wang wrote:
> Now libsas hotplug work is static, every sas event type has its own
> static work, LLDD driver queue the hotplug work into shost->work_q.
> If LLDD driver burst post lots hotplug events to libsas, the hotplug
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
> This patch and use static sas event work pool to appease this issue, since
> it's static work pool, it won't make memory exhaust.
>

[ ... ]

>
> +#define	PORT_POOL_SIZE	(PORT_NUM_EVENTS * 5)
> +#define	PHY_POOL_SIZE	(PHY_NUM_EVENTS * 5)
> +
>  /* The phy pretty much is controlled by the LLDD.
>   * The class only reads those fields.
>   */
>  struct asd_sas_phy {
>  /* private: */
> -	struct asd_sas_event   port_events[PORT_NUM_EVENTS];
> -	struct asd_sas_event   phy_events[PHY_NUM_EVENTS];
> -
> -	unsigned long port_events_pending;
> -	unsigned long phy_events_pending;
> +	struct asd_sas_event   port_events[PORT_POOL_SIZE];
> +	struct asd_sas_event   phy_events[PHY_POOL_SIZE];
>
>  	int error;

Hi Yijing,

So now we are creating a static pool of events per PHY/port, instead of 
having 1 static work struct per event per PHY/port. So, for sure, this 
avoids the dynamic event issue of system memory exhaustion which we 
discussed in v1+v2 series. And it seems to possibly remove issue of 
losing SAS events.

But how did you determine the pool size for a PHY/port? It would seem to 
be 5 * #phy events or #port events (which is also 5, I figure by 
coincidence). How does this deal with flutter of >25 events?

Thanks,
John
