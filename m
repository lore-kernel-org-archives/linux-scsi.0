From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 2/2] libsas: Enhance libsas hotplug
Date: Thu, 25 May 2017 20:31:45 +0800
Message-ID: <5926CEB1.2060109@huawei.com>
References: <1495262360-40135-1-git-send-email-wangyijing@huawei.com>
 <1495262360-40135-3-git-send-email-wangyijing@huawei.com>
 <58d547fa-a607-a51c-0c54-eecf05d3e498@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58d547fa-a607-a51c-0c54-eecf05d3e498@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, fangwei1@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi John, thanks for your review and comments!

在 2017/5/25 17:04, John Garry 写道:
> Hi,
> 
> There are some comments, inline.
> 
> In general, if it works, it looks ok.
> 
> Other reviews would be greatly appreciated - Hannes, Christoph, Johannes, Dan - please.
> 
>> Libsas complete a hotplug event notified by LLDD in several works,
>> for example, if libsas receive a PHYE_LOSS_OF_SIGNAL, we process it
>> in following steps:
>>
>> notify_phy_event    [interrupt context]
>>     sas_queue_event        [queue work on shost->work_q]
>>         sas_phye_loss_of_signal        [running in shost->work_q]
>>             sas_deform_port        [remove sas port]
>>                 sas_unregister_dev
>>                     sas_discover_event    [queue destruct work on shost->work_q tail]
>>
>> In above case, complete whole hotplug in two works, remove sas port first, then
>> put the destruction of device in another work and queue it on in the tail of
>> workqueue, since sas port is the parent of the children rphy device, so if remove
>> sas port first, the children rphy device would also be deleted, when the destruction
>> work coming, it would find the target has been removed already, and report a
>> sysfs warning calltrace.
>>
>> queue tail                                             queue head
>> DISCE_DESTRUCT----> PORTE_BYTES_DMAED event ----->PHYE_LOSS_OF_SIGNAL[running]
>>
>> There are other hotplug issues in current framework, in above case, if there is
>> hotadd sas event queued between hotremove works, the hotplug order would be broken
>> and unexpected issues would happen.
>>
>> In this patch, we try to solve these issues in following steps:
>> 1. create a new workqueue used to run sas event work, instead of scsi host workqueue,
>>    because we may block sas event work, we cannot block the normal scsi works.
> 
> What do we block the event work for?

When libsas receive a phy down event, sas_deform_port would be called, and now we block sas_deform_port
and wait for destruction work finish, in sas_destruct_devices, we may wait ata error handler, it would
take a long time, so if do all stuff in scsi host workq, libsas may block other scsi works too long.

> 
>> 2. create a new workqueue used to run sas discovery events work, instead of scsi host
>>    workqueue, because in some cases, eg. in revalidate domain event, we may unregister
>>    a sas device and discover new one, we must sync the execution, wait the remove process
>>    finish, then start a new discovery. So we must put the probe and destruct discovery
>>    events in a new workqueue to avoid deadlock.
>> 3. introudce a asd_sas_port level wait-complete and a sas_discovery level wait-complete
>>    we use former wait-complete to achieve a sas event atomic process and use latter to
>>    make a sas discovery sync.
>> 4. remove disco_mutex in sas_revalidate_domain, since now sas_revalidate_domain sync
>>    the destruct discovery event execution, it's no need to lock disco mutex there.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/scsi/libsas/sas_discover.c | 58 ++++++++++++++++++++++++++++----------
>>  drivers/scsi/libsas/sas_event.c    |  2 +-
>>  drivers/scsi/libsas/sas_expander.c |  9 +++++-
>>  drivers/scsi/libsas/sas_init.c     | 31 +++++++++++++++++++-
>>  drivers/scsi/libsas/sas_internal.h | 50 ++++++++++++++++++++++++++++++++
>>  drivers/scsi/libsas/sas_port.c     |  4 +++
>>  include/scsi/libsas.h              | 11 +++++++-
>>  7 files changed, 146 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
>> index 60de662..43e8a1e 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -503,11 +503,10 @@ static void sas_revalidate_domain(struct work_struct *work)
>>      struct domain_device *ddev = port->port_dev;
>>
>>      /* prevent revalidation from finding sata links in recovery */
>> -    mutex_lock(&ha->disco_mutex);
>>      if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
>>          SAS_DPRINTK("REVALIDATION DEFERRED on port %d, pid:%d\n",
>>                  port->id, task_pid_nr(current));
>> -        goto out;
>> +        return;
>>      }
>>
>>      clear_bit(DISCE_REVALIDATE_DOMAIN, &port->disc.pending);
>> @@ -521,20 +520,57 @@ static void sas_revalidate_domain(struct work_struct *work)
>>
>>      SAS_DPRINTK("done REVALIDATING DOMAIN on port %d, pid:%d, res 0x%x\n",
>>              port->id, task_pid_nr(current), res);
>> - out:
>> -    mutex_unlock(&ha->disco_mutex);
>> +}
>> +
>> +static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
>> +    [DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
>> +    [DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
>> +    [DISCE_PROBE] = sas_probe_devices,
>> +    [DISCE_SUSPEND] = sas_suspend_devices,
>> +    [DISCE_RESUME] = sas_resume_devices,
>> +    [DISCE_DESTRUCT] = sas_destruct_devices,
>> +};
>> +
>> +/* a simple wrapper for sas discover event funtions */
>> +static void sas_discover_common_fn(struct work_struct *work)
>> +{
>> +    struct sas_discovery_event *ev = to_sas_discovery_event(work);
>> +    struct asd_sas_port *port = ev->port;
>> +
>> +    sas_event_fns[ev->type](work);
>> +    sas_unbusy_port(port);
>>  }
>>
>>  /* ---------- Events ---------- */
>>
>>  static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
>>  {
>> +    int ret;
>> +    struct sas_discovery_event *ev = to_sas_discovery_event(&sw->work);
>> +    struct asd_sas_port *port = ev->port;
>> +
>>      /* chained work is not subject to SA_HA_DRAINING or
>>       * SAS_HA_REGISTERED, because it is either submitted in the
>>       * workqueue, or known to be submitted from a context that is
>>       * not racing against draining
>>       */
> 
> Is this comment still valid (even if you have not touched the drain logic work)?

Yes, I think so.

> 
>> -    scsi_queue_work(ha->core.shost, &sw->work);
>> +    sas_busy_port(port);
>> +
>> +    /*
>> +     * discovery event probe and destruct would be called in other
>> +     * discovery event like discover domain and revalidate domain
>> +     * events, in some cases, we need to sync execute probe and destruct
>> +     * events, so run discover events except probe/destruct in a new
>> +     * workqueue.
>> +     */
>> +    if (ev->type == DISCE_PROBE || ev->type == DISCE_DESTRUCT)
>> +        ret = scsi_queue_work(ha->core.shost, &sw->work);
>> +    else
>> +        ret = queue_work(ha->disc_q, &sw->work);
>> +
>> +    if (ret != 1)
>> +        /* queue a work fail, unbusy the ha before return */
>> +        sas_unbusy_port(port);
> 
> Do we really need to check for this error case, since we have dynamic work structs (I think queue_work only fails if we try requeuing a work item)?

We only change sas event work to dynamic, for sas discovery event work, it's still static.

> 
>>  }
>>
>>  static void sas_chain_event(int event, unsigned long *pending,
>> @@ -575,18 +611,10 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
>>  {
>>      int i;
>>
>> -    static const work_func_t sas_event_fns[DISC_NUM_EVENTS] = {
>> -        [DISCE_DISCOVER_DOMAIN] = sas_discover_domain,
>> -        [DISCE_REVALIDATE_DOMAIN] = sas_revalidate_domain,
>> -        [DISCE_PROBE] = sas_probe_devices,
>> -        [DISCE_SUSPEND] = sas_suspend_devices,
>> -        [DISCE_RESUME] = sas_resume_devices,
>> -        [DISCE_DESTRUCT] = sas_destruct_devices,
>> -    };
>> -
>>      disc->pending = 0;
>>      for (i = 0; i < DISC_NUM_EVENTS; i++) {
>> -        INIT_SAS_WORK(&disc->disc_work[i].work, sas_event_fns[i]);
>> +        INIT_SAS_WORK(&disc->disc_work[i].work, sas_discover_common_fn);
>>          disc->disc_work[i].port = port;
>> +        disc->disc_work[i].type = i;
>>      }
>>  }
>> diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
>> index 06c5c4b..c0fc07d 100644
>> --- a/drivers/scsi/libsas/sas_event.c
>> +++ b/drivers/scsi/libsas/sas_event.c
>> @@ -41,7 +41,7 @@ void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
>>          if (list_empty(&sw->drain_node))
>>              list_add(&sw->drain_node, &ha->defer_q);
>>      } else
>> -        scsi_queue_work(ha->core.shost, &sw->work);
>> +        queue_work(ha->event_q, &sw->work);
>>  }
>>
>>  static void sas_queue_event(int event, struct sas_work *work,
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 570b2cb..a8c8ae1 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -822,7 +822,9 @@ static struct domain_device *sas_ex_discover_end_dev(
>>
>>          list_add_tail(&child->disco_list_node, &parent->port->disco_list);
>>
>> +        wait_discover_event_init(child->port);
>>          res = sas_discover_sata(child);
>> +        wait_for_discover_event_finish(child->port);
>>          if (res) {
>>              SAS_DPRINTK("sas_discover_sata() for device %16llx at "
>>                      "%016llx:0x%x returned 0x%x\n",
>> @@ -847,7 +849,9 @@ static struct domain_device *sas_ex_discover_end_dev(
>>
>>          list_add_tail(&child->disco_list_node, &parent->port->disco_list);
>>
>> +        wait_discover_event_init(child->port);
>>          res = sas_discover_end_dev(child);
> 
> In sas_discover_end_dev(), we may return before sending the queue event (if LLDD notify dev found returns error), we please take care of this.

Good catch, I will fix this case, thanks!

> 
>> +        wait_for_discover_event_finish(child->port);
>>          if (res) {
>>              SAS_DPRINTK("sas_discover_end_dev() for device %16llx "
>>                      "at %016llx:0x%x returned 0x%x\n",
>> @@ -1890,8 +1894,11 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
>>                  if (child->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
>>                      child->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
>>                      sas_unregister_ex_tree(parent->port, child);
>> -                else
>> +                else {
>> +                    wait_discover_event_init(parent->port);
>>                      sas_unregister_dev(parent->port, child);
>> +                    wait_for_discover_event_finish(parent->port);
>> +                }
>>                  found = child;
>>                  break;
>>              }
>> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
>> index 79f95d0..1c49483 100644
>> --- a/drivers/scsi/libsas/sas_init.c
>> +++ b/drivers/scsi/libsas/sas_init.c
>> @@ -38,6 +38,8 @@
>>
>>  #include "../scsi_sas_internal.h"
>>
>> +static DEFINE_IDA(sas_ida);
>> +
>>  static struct kmem_cache *sas_task_cache;
>>
>>  struct sas_task *sas_alloc_task(gfp_t flags)
>> @@ -116,6 +118,7 @@ void sas_hae_reset(struct work_struct *work)
>>  int sas_register_ha(struct sas_ha_struct *sas_ha)
>>  {
>>      int error = 0;
>> +    char name[64];
>>
>>      mutex_init(&sas_ha->disco_mutex);
>>      spin_lock_init(&sas_ha->phy_port_lock);
>> @@ -146,6 +149,30 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
>>          goto Undo_ports;
>>      }
>>
>> +    sas_ha->id = ida_simple_get(&sas_ida, 0, 0, GFP_KERNEL);
>> +    if(sas_ha->id < 0)
>> +        goto Undo_ports;
>> +
>> +    memset(name, 0, 64);
> 
> Why memset and then sprintf?
> 
>> +    snprintf(name, 64, "sas-event-%d", sas_ha->id);
> 
> Can you just use unique dev_name(sas_ha->dev) to help form this name, so that you don't have to introduce IDR?

I check the sas_ha->dev, and found it's point to platform device, so it should be safe to use dev_name(sas_ha->dev), thanks!

> 
>> +    sas_ha->event_q = create_singlethread_workqueue(name);
>> +
>> +    /*
>> +     * sas-disc-xx workqueue run the discover work except
>> +     * probe and destruct.
>> +     */
>> +    snprintf(name, 64, "sas-disc-%d", sas_ha->id);
>> +    sas_ha->disc_q = create_singlethread_workqueue(name);
>> +    if(!sas_ha->event_q || !sas_ha->disc_q) {
>> +        ida_simple_remove(&sas_ida, sas_ha->id);
>> +        if (sas_ha->event_q)
>> +            destroy_workqueue(sas_ha->event_q);
>> +        if (sas_ha->disc_q)
>> +            destroy_workqueue(sas_ha->disc_q);
> 
> Can this error handling be a bit more concise?

OK, will refresh.

> 
>> +        goto Undo_ports;
>> +    }
>> +
>> +
>>      INIT_LIST_HEAD(&sas_ha->eh_done_q);
>>      INIT_LIST_HEAD(&sas_ha->eh_ata_q);
>>
>> @@ -181,6 +208,9 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
>>      __sas_drain_work(sas_ha);
>>      mutex_unlock(&sas_ha->drain_mutex);
>>
>> +    destroy_workqueue(sas_ha->event_q);
>> +    destroy_workqueue(sas_ha->disc_q);
>> +    ida_simple_remove(&sas_ida, sas_ha->id);
>>      return 0;
>>  }
>>
>> @@ -568,7 +598,6 @@ void sas_domain_release_transport(struct scsi_transport_template *stt)
>>  EXPORT_SYMBOL_GPL(sas_domain_release_transport);
>>
>>  /* ---------- SAS Class register/unregister ---------- */
>> -
>>  static int __init sas_class_init(void)
>>  {
>>      sas_task_cache = KMEM_CACHE(sas_task, SLAB_HWCACHE_ALIGN);
>> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
>> index 33ce7e5..276df8e 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -100,6 +100,56 @@ void sas_free_device(struct kref *kref);
>>  extern const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS];
>>  extern const work_func_t sas_port_event_fns[PORT_NUM_EVENTS];
>>
>> +static inline void wait_discover_event_init(struct asd_sas_port *port)
> 
> You need to change function names to have "sas" prefix. Actually these functions are all a bit messy.

OK.

> 
>> +{
>> +    if (port) {
> 
> This init and wait function are currently act ask bookend wrappers. I think it may be better to put them in the wrapped function (if possible), as:
> a. probably then we don't need port NULL check
> b. handles situations where event is possibly not queued, like the suspected sas_discover_end_dev()
> 
>> +        init_completion(&port->disc.completion);
>> +        port->disc.wait = 1;
>> +    }
>> +}
>> +
>> +static inline void wait_for_discover_event_finish(
>> +        struct asd_sas_port *port)
>> +{
>> +    if (port && port->disc.wait == 1)
> 
> Can you just use completion_done() instead of introducing another variable in discovery_event.wait?

What I am worried about completion_done() may be called before we call wait_for_compltion(), in this case,
the process will hang.


> 
>> +        wait_for_completion(&port->disc.completion);
>> +}
>> +
>> +static inline void wait_sas_event_init(struct asd_sas_port *port)
>> +{
>> +    if (port) {
>> +        init_completion(&port->completion);
>> +        port->busy = 0;
>> +    }
>> +}
>> +
>> +static inline void wait_for_sas_event_finish(
>> +        struct asd_sas_port *port)
>> +{
>> +    if (port && port->busy)
>> +        wait_for_completion(&port->completion);
>> +}
>> +
>> +static inline void sas_busy_port(struct asd_sas_port *port)
>> +{
>> +    if (port)
>> +        port->busy++;
> 
> Why not use kref?

Good idea, will replace.

> 
>> +}
>> +
>> +static inline void sas_unbusy_port(struct asd_sas_port *port)
>> +{
>> +    if (port && (port->busy > 0)) {
>> +        port->busy--;
>> +        if (!port->busy)
>> +            complete(&port->completion);
>> +    }
>> +
>> +    if (port && (port->disc.wait == 1)) {
> 
> Why check port twice?

Will remove the second check, thanks!

> 
>> +        complete(&port->disc.completion);
>> +        port->disc.wait = 0;
>> +    }
>> +}
>> +
>>  #ifdef CONFIG_SCSI_SAS_HOST_SMP
>>  extern int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>>                  struct request *rsp);
>> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
>> index 9326628..8d8b38c 100644
>> --- a/drivers/scsi/libsas/sas_port.c
>> +++ b/drivers/scsi/libsas/sas_port.c
>> @@ -191,7 +191,9 @@ static void sas_form_port(struct asd_sas_phy *phy)
>>      if (si->dft->lldd_port_formed)
>>          si->dft->lldd_port_formed(phy);
>>
>> +    wait_sas_event_init(port);
>>      sas_discover_event(phy->port, DISCE_DISCOVER_DOMAIN);
>> +    wait_for_sas_event_finish(port);
> 
> Is it neater to put these calls inside sas_discover_event()?

Now we have two wait-complete, first for sas event, like in sas_form_port/sas_deform_port,
second, for sas_discover event, like in sas_revalidate_domain, also, sas_discover_event()
may be called recursive, there is some difficult to put these calls inside it.


> 
>>  }
>>
>>  /**
>> @@ -218,7 +220,9 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
>>          dev->pathways--;
>>
>>      if (port->num_phys == 1) {
>> +        wait_sas_event_init(port);
>>          sas_unregister_domain_devices(port, gone);
>> +        wait_for_sas_event_finish(port);
>>          sas_port_delete(port->port);
>>          port->port = NULL;
>>      } else {
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index c4444ad..4b931d4 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -240,6 +240,9 @@ static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_str
>>  struct sas_discovery_event {
>>      struct sas_work work;
>>      struct asd_sas_port *port;
>> +    enum discover_event    type;
>> +    int wait;
>> +    struct completion completion;
>>  };
>>
>>  static inline struct sas_discovery_event *to_sas_discovery_event(struct work_struct *work)
>> @@ -256,6 +259,8 @@ struct sas_discovery {
>>      u8     eeds_a[8];
>>      u8     eeds_b[8];
>>      int    max_level;
>> +    int    wait;
>> +    struct completion completion;
> 
> Again, does completion_done() do the same job as wait element?

same as above.

> 
>>  };
>>
>>  /* The port struct is Class:RW, driver:RO */
>> @@ -276,7 +281,8 @@ struct asd_sas_port {
>>
>>  /* public: */
>>      int id;
>> -
>> +    int busy;
>> +    struct completion completion;
> 
> I think public means LLDD can access, which is not the case

OK. will move them up.

> 
>>      enum sas_class   class;
>>      u8               sas_addr[SAS_ADDR_SIZE];
>>      u8               attached_sas_addr[SAS_ADDR_SIZE];
>> @@ -387,6 +393,7 @@ struct sas_ha_struct {
>>      int          eh_active;
>>      wait_queue_head_t eh_wait_q;
>>      struct list_head  eh_dev_q;
>> +    int       id; /* for create workqueue */
>>
>>      struct mutex disco_mutex;
>>
>> @@ -396,6 +403,8 @@ struct sas_ha_struct {
>>      char *sas_ha_name;
>>      struct device *dev;      /* should be set */
>>      struct module *lldd_module; /* should be set */
>> +    struct workqueue_struct    *event_q;
>> +    struct workqueue_struct    *disc_q;
>>
>>      u8 *sas_addr;          /* must be set */
>>      u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];
>>
> 
> 
> .
> 
