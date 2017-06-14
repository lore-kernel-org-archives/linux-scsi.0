From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sas: scsi_queue_work can fail, so make callers
 aware
Date: Wed, 14 Jun 2017 13:57:13 +0100
Message-ID: <1d42fe4e-f6fb-17f5-946f-a44637000372@huawei.com>
References: <20170614115243.17776-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8289 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdFNM5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2017 08:57:47 -0400
In-Reply-To: <20170614115243.17776-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, wangyijing@huawei.com, Linuxarm <linuxarm@huawei.com>

On 14/06/2017 12:52, Johannes Thumshirn wrote:
> libsas uses scsi_queue_work() to queue it's internal event
> notifications. scsi_queue_work() can return -EINVAL if the work queue
> doesn't exist and it does call queue_work() which can return false if
> the work is already queued.
>

Hi Johannes,

When the queuing fails and we an report error, what is the caller, i.e. 
the LLDD, supposed to do with this information?

I mean, the LLDD is just reporting an event, like a broadcast event, and 
libsas could not handle it for some reason. The LLDD probably does not 
know how to handle this, apart from printing an error or maybe even 
disabling the originating PHY.

> Make the SAS event code capable of returning errors up to the caller,
> which is handy when changing to dynamically allocated work in libsas
> as well, as discussed here: https://lkml.org/lkml/2017/6/14/121.

I will comment on this patchset separately.

Much appreciated,
John

>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libsas/sas_event.c    | 36 ++++++++++++++++++++++--------------
>  drivers/scsi/libsas/sas_internal.h |  4 ++--
>  include/scsi/libsas.h              |  6 +++---
>  3 files changed, 27 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
> index aadbd5314c5c..c0d0d979b76d 100644
> --- a/drivers/scsi/libsas/sas_event.c
> +++ b/drivers/scsi/libsas/sas_event.c
> @@ -27,30 +27,38 @@
>  #include "sas_internal.h"
>  #include "sas_dump.h"
>
> -void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
> +int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  {
> +	int rc = 0;
> +
>  	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
> -		return;
> +		return 0;
>
>  	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
>  		/* add it to the defer list, if not already pending */
>  		if (list_empty(&sw->drain_node))
>  			list_add(&sw->drain_node, &ha->defer_q);
>  	} else
> -		scsi_queue_work(ha->core.shost, &sw->work);
> +		rc = scsi_queue_work(ha->core.shost, &sw->work);
> +
> +	return rc;
>  }
>
> -static void sas_queue_event(int event, unsigned long *pending,
> +static int sas_queue_event(int event, unsigned long *pending,
>  			    struct sas_work *work,
>  			    struct sas_ha_struct *ha)
>  {
> +	int rc = 0;
> +
>  	if (!test_and_set_bit(event, pending)) {
>  		unsigned long flags;
>
>  		spin_lock_irqsave(&ha->lock, flags);
> -		sas_queue_work(ha, work);
> +		rc = sas_queue_work(ha, work);
>  		spin_unlock_irqrestore(&ha->lock, flags);
>  	}
> +
> +	return rc;
>  }
>
>
> @@ -116,32 +124,32 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
>  	mutex_unlock(&ha->disco_mutex);
>  }
>
> -static void notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
> +static int notify_ha_event(struct sas_ha_struct *sas_ha, enum ha_event event)
>  {
>  	BUG_ON(event >= HA_NUM_EVENTS);
>
> -	sas_queue_event(event, &sas_ha->pending,
> -			&sas_ha->ha_events[event].work, sas_ha);
> +	return sas_queue_event(event, &sas_ha->pending,
> +			       &sas_ha->ha_events[event].work, sas_ha);
>  }
>
> -static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
> +static int notify_port_event(struct asd_sas_phy *phy, enum port_event event)
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>
>  	BUG_ON(event >= PORT_NUM_EVENTS);
>
> -	sas_queue_event(event, &phy->port_events_pending,
> -			&phy->port_events[event].work, ha);
> +	return sas_queue_event(event, &phy->port_events_pending,
> +			       &phy->port_events[event].work, ha);
>  }
>
> -void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
> +int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
>  {
>  	struct sas_ha_struct *ha = phy->ha;
>
>  	BUG_ON(event >= PHY_NUM_EVENTS);
>
> -	sas_queue_event(event, &phy->phy_events_pending,
> -			&phy->phy_events[event].work, ha);
> +	return sas_queue_event(event, &phy->phy_events_pending,
> +			       &phy->phy_events[event].work, ha);
>  }
>
>  int sas_init_events(struct sas_ha_struct *sas_ha)
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index b306b7843d99..a216c957b639 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -76,7 +76,7 @@ void sas_porte_broadcast_rcvd(struct work_struct *work);
>  void sas_porte_link_reset_err(struct work_struct *work);
>  void sas_porte_timer_event(struct work_struct *work);
>  void sas_porte_hard_reset(struct work_struct *work);
> -void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
> +int sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
>
>  int sas_notify_lldd_dev_found(struct domain_device *);
>  void sas_notify_lldd_dev_gone(struct domain_device *);
> @@ -85,7 +85,7 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
>  			enum phy_func phy_func, struct sas_phy_linkrates *);
>  int sas_smp_get_phy_events(struct sas_phy *phy);
>
> -void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
> +int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
>  void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
>  struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
>  struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index dd0f72c95abe..cfaeed256ab2 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -415,9 +415,9 @@ struct sas_ha_struct {
>  				* their siblings when forming wide ports */
>
>  	/* LLDD calls these to notify the class of an event. */
> -	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
> -	void (*notify_port_event)(struct asd_sas_phy *, enum port_event);
> -	void (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
> +	int (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
> +	int (*notify_port_event)(struct asd_sas_phy *, enum port_event);
> +	int (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
>
>  	void *lldd_ha;		  /* not touched by sas class code */
>
>
