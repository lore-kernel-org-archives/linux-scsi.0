From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v3 5/7] libsas: add a new workqueue to run probe/destruct
 discovery event
Date: Wed, 12 Jul 2017 17:50:36 +0100
Message-ID: <b1c7f058-c450-beb3-a909-8129e7042f87@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-6-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-6-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/07/2017 08:06, Yijing Wang wrote:
> Sometimes, we want sync libsas probe or destruct in sas discovery work,
> like when libsas revalidate domain. We need to split probe and destruct
> work from the scsi host workqueue.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 13 ++++++++++++-
>  drivers/scsi/libsas/sas_init.c     |  8 ++++++++
>  include/scsi/libsas.h              |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 5d4a3a8..a25d648 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -559,7 +559,18 @@ static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  	 * not racing against draining
>  	 */
>  	sas_port_get(port);
> -	ret = scsi_queue_work(ha->core.shost, &sw->work);
> +	/*
> +	 * discovery event probe and destruct would be called in other
> +	 * discovery event like discover domain and revalidate domain
> +	 * events, in some cases, we need to sync execute probe and destruct
> +	 * events, so run probe and destruct discover events except in a new
> +	 * workqueue.

Can we just use ha->disc_q for all discovery events for simplicity? 
Would this solve the disco mutex you try to solve in patch 7/7?

> +	 */
> +	if (ev->type == DISCE_PROBE || ev->type == DISCE_DESTRUCT)
> +		ret = queue_work(ha->disc_q, &sw->work);
> +	else
> +		ret = scsi_queue_work(ha->core.shost, &sw->work);
> +
>  	if (ret != 1)

Uhh, we are mixing bool and int here... but we're forced to by 
scsi_queue_work()

>  		sas_port_put(port);
>  }
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 2f3b736..df1d78b 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -152,6 +152,13 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
>  	if (!sas_ha->event_q)
>  		goto Undo_ports;
>
> +	snprintf(name, 64, "%s_disc_q", dev_name(sas_ha->dev));
> +	sas_ha->disc_q = create_singlethread_workqueue(name);
> +	if(!sas_ha->disc_q) {
> +		destroy_workqueue(sas_ha->event_q);
> +		goto Undo_ports;
> +	}
> +
>  	INIT_LIST_HEAD(&sas_ha->eh_done_q);
>  	INIT_LIST_HEAD(&sas_ha->eh_ata_q);
>
> @@ -187,6 +194,7 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
>  	__sas_drain_work(sas_ha);
>  	mutex_unlock(&sas_ha->drain_mutex);
>  	destroy_workqueue(sas_ha->event_q);
> +	destroy_workqueue(sas_ha->disc_q);
>
>  	return 0;
>  }
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index c2ef05e..4bcb9fe 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -406,6 +406,7 @@ struct sas_ha_struct {
>  	struct device *dev;	  /* should be set */
>  	struct module *lldd_module; /* should be set */
>  	struct workqueue_struct *event_q;
> +	struct workqueue_struct *disc_q;
>
>  	u8 *sas_addr;		  /* must be set */
>  	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
>
