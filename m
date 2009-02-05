From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] fcoe: Fibre Channel over Ethernet
Date: Wed, 4 Feb 2009 18:24:41 -0800
Message-ID: <20090204182441.4a8def70.akpm@linux-foundation.org>
References: <20081209231005.17830.92133.stgit@fritz>
	<20081209231024.17830.97893.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZBECZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2009 21:25:54 -0500
In-Reply-To: <20081209231024.17830.97893.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, andi@firstfloor.org, jeffrey.t.kirsher@intel.com

On Tue, 09 Dec 2008 15:10:24 -0800 Robert Love <robert.w.love@intel.com> wrote:

> Encapsulation protocol for running Fibre Channel over Ethernet interfaces.
> Creates virtual Fibre Channel host adapters using libfc.
> 
> This layer is the LLD to the scsi-ml. It allocates the Scsi_Host, utilizes
> libfc for Fibre Channel protocol processing and interacts with netdev to
> send/receive Ethernet packets.
> 

I stumbled across this while looking for new and weird kthread API usages..

> ...
>
> +/**
> + * fcoe_transport_lookup - check if the transport is already registered
> + * @t: the transport to be looked up
> + *
> + * This compares the parent device (pci) vendor and device id
> + *
> + * Returns: NULL if not found
> + *
> + * TODO - return default sw transport if no other transport is found
> + **/

The kerneldoc comments consistently close with

**/

which is consistently unconventional.  Not wrong, just odd.

>
> ...
>
> +int fcoe_transport_register(struct fcoe_transport *t)
> +{
> +	struct fcoe_transport *tt;
> +
> +	/* TODO - add fcoe_transport specific initialization here */
> +	mutex_lock(&fcoe_transports_lock);
> +	list_for_each_entry(tt, &fcoe_transports, list) {
> +		if (tt == t) {
> +			mutex_unlock(&fcoe_transports_lock);
> +			return -EEXIST;
> +		}
> +	}
> +	list_add_tail(&t->list, &fcoe_transports);
> +	mutex_unlock(&fcoe_transports_lock);
> +
> +	mutex_init(&t->devlock);
> +	INIT_LIST_HEAD(&t->devlist);

Seems wrong to make this available for lookups pror to completing its
initialisation.

> +	printk(KERN_DEBUG "fcoe_transport_register:%s\n", t->name);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fcoe_transport_register);
> +
>
> ...
>
> +int fcoe_load_transport_driver(struct net_device *netdev)
> +{
> +	struct pci_dev *pci;
> +	struct device *dev = netdev->dev.parent;
> +
> +	if (fcoe_transport_lookup(netdev)) {
> +		/* load default transport */
> +		printk(KERN_DEBUG "fcoe: already loaded transport for %s\n",
> +		       netdev->name);
> +		return -EEXIST;
> +	}
> +
> +	pci = to_pci_dev(dev);
> +	if (dev->bus != &pci_bus_type) {
> +		printk(KERN_DEBUG "fcoe: support noly PCI device\n");

typo

> +		return -ENODEV;
> +	}
> +	printk(KERN_DEBUG "fcoe: loading driver fcoe-pci-0x%04x-0x%04x\n",
> +	       pci->vendor, pci->device);
> +
> +	return request_module("fcoe-pci-0x%04x-0x%04x",
> +			      pci->vendor, pci->device);
> +
>
> ...
>
> +static int fcoe_sw_lport_config(struct fc_lport *lp)
> +{
> +	int i = 0;
> +
> +	lp->link_status = 0;
> +	lp->max_retry_count = 3;
> +	lp->e_d_tov = 2 * 1000;	/* FC-FS default */
> +	lp->r_a_tov = 2 * 2 * 1000;
> +	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
> +			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
> +
> +	/*
> +	 * allocate per cpu stats block
> +	 */
> +	for_each_online_cpu(i)
> +		lp->dev_stats[i] = kzalloc(sizeof(struct fcoe_dev_stats),
> +					   GFP_KERNEL);
> +
> +	/* lport fc_lport related configuration */
> +	fc_lport_config(lp);
> +
> +	return 0;
> +}

Has the CPU hotplugging code been tested?  This seems to not do things
which fcoe_create_percpu_data() does.

> +/*
> + * fcoe_sw_netdev_config - sets up fcoe_softc for lport and network
> + * related properties
> + * @lp : ptr to the fc_lport
> + * @netdev : ptr to the associated netdevice struct
> + *
> + * Must be called after fcoe_sw_lport_config() as it will use lport mutex
> + *
> + * Returns : 0 for success
> + *
> + */
>
> ...
>
> +static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
> +			     void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +
> +	switch (action) {
> +	case CPU_ONLINE:
> +		fcoe_create_percpu_data(cpu);
> +		break;
> +	case CPU_DEAD:
> +		fcoe_destroy_percpu_data(cpu);
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}

This function forgets to create and destroy the per-cpu kernel threads.

>
> ...
>
> +/*
> + * fcoe_percpu_clean - frees skb of the corresponding lport from the per
> + * cpu queue.
> + * @lp: the fc_lport
> + */

This purports to bea kerneldoc comment but mieese the /** token.

The first line of the kernedoc comment should not have a linbreak -
kerneldoc doesn't understand that.

>
> ...
>
> +static struct fcoe_softc *fcoe_hostlist_lookup_softc(
> +	const struct net_device *dev)
> +{
> +	struct fcoe_softc *fc;
> +
> +	read_lock(&fcoe_hostlist_lock);
> +	list_for_each_entry(fc, &fcoe_hostlist, list) {
> +		if (fc->real_dev == dev) {
> +			read_unlock(&fcoe_hostlist_lock);
> +			return fc;
> +		}
> +	}
> +	read_unlock(&fcoe_hostlist_lock);
> +	return NULL;
> +}

It's strange to take a lock, look something up, drop the lock and then
return the looked-up object without having taken any steps to prevent
some other thread of control from destroying that object while the
caller is playing with it.  (ie: take a reference on it).

>
> ...
>
> +static int __init fcoe_init(void)
> +{
> +	int cpu;
> +	struct fcoe_percpu_s *p;
> +
> +
> +	INIT_LIST_HEAD(&fcoe_hostlist);
> +	rwlock_init(&fcoe_hostlist_lock);
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +	register_cpu_notifier(&fcoe_cpu_notifier);
> +#endif /* CONFIG_HOTPLUG_CPU */

This could/should use hotcpu_notifier(), lose the ifdefs.

> +
> +	/*
> +	 * initialize per CPU interrupt thread
> +	 */
> +	for_each_online_cpu(cpu) {
> +		p = kzalloc(sizeof(struct fcoe_percpu_s), GFP_KERNEL);
> +		if (p) {
> +			p->thread = kthread_create(fcoe_percpu_receive_thread,
> +						   (void *)p,
> +						   "fcoethread/%d", cpu);
> +
> +			/*
> +			 * if there is no error then bind the thread to the cpu
> +			 * initialize the semaphore and skb queue head
> +			 */
> +			if (likely(!IS_ERR(p->thread))) {
> +				p->cpu = cpu;
> +				fcoe_percpu[cpu] = p;
> +				skb_queue_head_init(&p->fcoe_rx_list);
> +				kthread_bind(p->thread, cpu);
> +				wake_up_process(p->thread);
> +			} else {
> +				fcoe_percpu[cpu] = NULL;
> +				kfree(p);
> +
> +			}
> +		}
> +	}

afaict nothing is done here to avoid races against CPU hotplug.

What happens if the kzalloc() failed?

> +	/*
> +	 * setup link change notification
> +	 */
> +	fcoe_dev_setup();
> +
> +	init_timer(&fcoe_timer);
> +	fcoe_timer.data = 0;
> +	fcoe_timer.function = fcoe_watchdog;

Could use setup_timer() here.

> +	fcoe_timer.expires = (jiffies + (10 * HZ));
> +	add_timer(&fcoe_timer);

Could actually use mod_timer() here.

> +	/* initiatlize the fcoe transport */
> +	fcoe_transport_init();
> +
> +	fcoe_sw_init();
> +
> +	return 0;
> +}
> +module_init(fcoe_init);
> +
> +/**
> + * fcoe_exit - fcoe module unloading cleanup
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +static void __exit fcoe_exit(void)
> +{
> +	u32 idx;
> +	struct fcoe_softc *fc, *tmp;
> +	struct fcoe_percpu_s *p;
> +	struct sk_buff *skb;
> +
> +	/*
> +	 * Stop all call back interfaces
> +	 */
> +#ifdef CONFIG_HOTPLUG_CPU
> +	unregister_cpu_notifier(&fcoe_cpu_notifier);
> +#endif /* CONFIG_HOTPLUG_CPU */

Use unregister_hotcpu_notifier(), lose ifdef (I think).

> +	fcoe_dev_cleanup();
> +
> +	/*
> +	 * stop timer
> +	 */
> +	del_timer_sync(&fcoe_timer);
> +
> +	/* releases the assocaited fcoe transport for each lport */

typo

> +	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
> +		fcoe_transport_release(fc->real_dev);
> +
> +	for (idx = 0; idx < NR_CPUS; idx++) {
> +		if (fcoe_percpu[idx]) {
> +			kthread_stop(fcoe_percpu[idx]->thread);
> +			p = fcoe_percpu[idx];
> +			spin_lock_bh(&p->fcoe_rx_list.lock);
> +			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
> +				kfree_skb(skb);
> +			spin_unlock_bh(&p->fcoe_rx_list.lock);
> +			if (fcoe_percpu[idx]->crc_eof_page)
> +				put_page(fcoe_percpu[idx]->crc_eof_page);
> +			kfree(fcoe_percpu[idx]);
> +		}
> +	}

The iterating across NR_CPUS is rather, umm, old-fashioned.

It'd be better to lock against cpu hotplugging then use
for_each_online_cpu().

> +	/* remove sw trasnport */
> +	fcoe_sw_exit();
> +
> +	/* detach the transport */
> +	fcoe_transport_exit();
> +}
>
> ...
>
> +static inline struct fcoe_softc *fcoe_softc(
> +	const struct fc_lport *lp)

weird code layout, used everywhere.

> +{
> +	return (struct fcoe_softc *)lport_priv(lp);

unneeded/undesirable cast of void*.  There are probably zillions of
instances of this - there always are.

> +}
> +
>
> ...
>

