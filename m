From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/7] libsas: add sas event wait-complete support
Date: Fri, 14 Jul 2017 08:51:03 +0200
Message-ID: <b2939814-ebbe-866a-b067-e94d7e814647@suse.de>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-5-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-5-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 09:06 AM, Yijing Wang wrote:
> Introduce wait-complete for libsas sas event processing,
> execute sas port create/destruct in sync.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 41 ++++++++++++++++++++++++++++----------
>  drivers/scsi/libsas/sas_internal.h | 34 +++++++++++++++++++++++++++++++
>  drivers/scsi/libsas/sas_port.c     |  4 ++++
>  include/scsi/libsas.h              |  5 ++++-
>  4 files changed, 72 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 60de662..5d4a3a8 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -525,16 +525,43 @@ static void sas_revalidate_domain(struct work_struct *work)
>  	mutex_unlock(&ha->disco_mutex);
>  }
>  
> +static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
> +	[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
> +	[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
> +	[DISCE_PROBE] = sas_probe_devices,
> +	[DISCE_SUSPEND] = sas_suspend_devices,
> +	[DISCE_RESUME] = sas_resume_devices,
> +	[DISCE_DESTRUCT] = sas_destruct_devices,
> +};
> +
> +/* a simple wrapper for sas discover event funtions */
> +static void sas_discover_common_fn(struct work_struct *work)
> +{
> +	struct sas_discovery_event *ev = to_sas_discovery_event(work);
> +	struct asd_sas_port *port = ev->port;
> +
> +	sas_event_fns[ev->type](work);
> +	sas_port_put(port);
> +}
> +
> +
>  /* ---------- Events ---------- */
>  
>  static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
>  {
> +	int ret;
> +	struct sas_discovery_event *ev = to_sas_discovery_event(&sw->work);
> +	struct asd_sas_port *port = ev->port;
> +
>  	/* chained work is not subject to SA_HA_DRAINING or
>  	 * SAS_HA_REGISTERED, because it is either submitted in the
>  	 * workqueue, or known to be submitted from a context that is
>  	 * not racing against draining
>  	 */
> -	scsi_queue_work(ha->core.shost, &sw->work);
> +	sas_port_get(port);
> +	ret = scsi_queue_work(ha->core.shost, &sw->work);
> +	if (ret != 1)
> +		sas_port_put(port);
>  }
>  
>  static void sas_chain_event(int event, unsigned long *pending,
> @@ -575,18 +602,10 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
>  {
>  	int i;
>  
> -	static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
> -		[DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
> -		[DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
> -		[DISCE_PROBE] = sas_probe_devices,
> -		[DISCE_SUSPEND] = sas_suspend_devices,
> -		[DISCE_RESUME] = sas_resume_devices,
> -		[DISCE_DESTRUCT] = sas_destruct_devices,
> -	};
> -
>  	disc->pending = 0;
>  	for (i = 0; i < DISC_NUM_EVENTS; i++) {
> -		INIT_SAS_WORK(&disc->disc_work[i].work, sas_event_fns[i]);
> +		INIT_SAS_WORK(&disc->disc_work[i].work, sas_discover_common_fn);
>  		disc->disc_work[i].port = port;
> +		disc->disc_work[i].type = i;
>  	}
>  }
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index f03ce64..890b5d26 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -100,6 +100,40 @@ void sas_free_device(struct kref *kref);
>  extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
>  extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
>  
> +static void sas_complete_event(struct kref *kref)
> +{
> +	struct asd_sas_port *port = container_of(kref, struct asd_sas_port, ref);
> +
> +	complete_all(&port->completion);
> +}
> +
> +static inline void sas_port_put(struct asd_sas_port *port)
> +{
> +	if (port->is_sync)
> +		kref_put(&port->ref, sas_complete_event);
> +}
> +
> +static inline void sas_port_wait_init(struct asd_sas_port *port)
> +{
> +	init_completion(&port->completion);
> +	kref_init(&port->ref);
> +	port->is_sync = true;
> +}
> +
> +static inline void sas_port_wait_completion(
> +		struct asd_sas_port *port)
> +{
> +	sas_port_put(port);
> +	wait_for_completion(&port->completion);
> +	port->is_sync = false;
> +}
> +
> +static inline void sas_port_get(struct asd_sas_port *port)
> +{
> +	if (port && port->is_sync)
> +		kref_get(&port->ref);
> +}
> +
>  #ifdef CONFIG_SCSI_SAS_HOST_SMP
>  extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  				struct request *rsp);
> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> index 9326628..d589adb 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -191,7 +191,9 @@ static void sas_form_port(struct asd_sas_phy *phy)
>  	if (si->dft->lldd_port_formed)
>  		si->dft->lldd_port_formed(phy);
>  
> +	sas_port_wait_init(port);
>  	sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
> +	sas_port_wait_completion(port);
>  }
>  
>  /**
> @@ -218,7 +220,9 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
>  		dev->pathways--;
>  
>  	if (port->num_phys == 1) {
> +		sas_port_wait_init(port);
>  		sas_unregister_domain_devices(port, gone);
> +		sas_port_wait_completion(port);
>  		sas_port_delete(port->port);
>  		port->port = NULL;
>  	} else {

I would rather use the standard on-stack completion here;
like this:

	DECLARE_COMPLETION_ONSTACK(complete);
	port->completion = &complete;
	sas_unregister_domain_devices(port, gone);
	wait_for_completion(&complete);
	sas_port_delete(port->port);

which would simplify the above helpers to:

static inline void sas_port_put(struct asd_sas_port *port)
{
	if (port->completion)
		kref_put(&port->ref, sas_complete_event);
}

and you could do away with the 'is_sync' helper.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
