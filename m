From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] scsi/fcoe: convert to kworker
Date: Fri, 10 Jun 2016 12:38:12 +0200
Message-ID: <20160610103812.ojgzop6qdv3mos5d@c203.arch.suse.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
 <20160311161704.GA5083@infradead.org>
 <56E2F30F.5030108@linutronix.de>
 <20160315081940.GB9136@infradead.org>
 <20160412151654.GB20685@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbcFJKiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 06:38:15 -0400
Content-Disposition: inline
In-Reply-To: <20160412151654.GB20685@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Vasu Dev <vasu.dev@intel.com>, fcoe-devel@open-fcoe.org

On Tue, Apr 12, 2016 at 05:16:54PM +0200, Sebastian Andrzej Siewior wro=
te:
> The driver creates its own per-CPU threads which are updated based on
> CPU hotplug events. It is also possible to use kworkers and remove so=
me
> of the kthread infrastrucure.
>=20
> The code checked ->thread to decide if there is an active per-CPU
> thread. By using the kworker infrastructure this is no longer possibl=
e (or
> required). The thread pointer is saved in `kthread' instead of `threa=
d' so
> anything trying to use thread is caught by the compiler. Currently on=
ly the
> bnx2fc driver is using struct fcoe_percpu_s and the kthread member.
>=20
> After a CPU went offline, we may still enqueue items on the "offline"
> CPU. This isn't much of a problem. The work will be done on a random
> CPU. The allocated crc_eof_page page won't be cleaned up. It is proba=
bly
> expected that the CPU comes up at some point so it should not be a
> problem. The crc_eof_page memory is released of course once the modul=
e is
> removed.
>=20
> This patch was only compile-tested due to -ENODEV.
>=20
> Cc: Vasu Dev <vasu.dev@intel.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: fcoe-devel@open-fcoe.org
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Tested in a Boot from FCoE scenario using a BCM57840.

Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

> ---
> v1=E2=80=A6v2: use kworker instead of smbthread as per hch
>=20
> If you want this I would the same for the two bnx drivers.
>=20
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   8 +-
>  drivers/scsi/fcoe/fcoe.c          | 276 ++++------------------------=
----------
>  include/scsi/libfcoe.h            |   6 +-
>  3 files changed, 34 insertions(+), 256 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/=
bnx2fc_fcoe.c
> index d7029ea5d319..cfb1b5b40d6c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -466,7 +466,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct=
 net_device *dev,
> =20
>  	__skb_queue_tail(&bg->fcoe_rx_list, skb);
>  	if (bg->fcoe_rx_list.qlen =3D=3D 1)
> -		wake_up_process(bg->thread);
> +		wake_up_process(bg->kthread);
> =20
>  	spin_unlock(&bg->fcoe_rx_list.lock);
> =20
> @@ -2663,7 +2663,7 @@ static int __init bnx2fc_mod_init(void)
>  	}
>  	wake_up_process(l2_thread);
>  	spin_lock_bh(&bg->fcoe_rx_list.lock);
> -	bg->thread =3D l2_thread;
> +	bg->kthread =3D l2_thread;
>  	spin_unlock_bh(&bg->fcoe_rx_list.lock);
> =20
>  	for_each_possible_cpu(cpu) {
> @@ -2736,8 +2736,8 @@ static void __exit bnx2fc_mod_exit(void)
>  	/* Destroy global thread */
>  	bg =3D &bnx2fc_global;
>  	spin_lock_bh(&bg->fcoe_rx_list.lock);
> -	l2_thread =3D bg->thread;
> -	bg->thread =3D NULL;
> +	l2_thread =3D bg->kthread;
> +	bg->kthread =3D NULL;
>  	while ((skb =3D __skb_dequeue(&bg->fcoe_rx_list)) !=3D NULL)
>  		kfree_skb(skb);
> =20
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 0efe7112fc1f..f7c7ccc156da 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -67,9 +67,6 @@ static DEFINE_MUTEX(fcoe_config_mutex);
> =20
>  static struct workqueue_struct *fcoe_wq;
> =20
> -/* fcoe_percpu_clean completion.  Waiter protected by fcoe_create_mu=
tex */
> -static DECLARE_COMPLETION(fcoe_flush_completion);
> -
>  /* fcoe host list */
>  /* must only by accessed under the RTNL mutex */
>  static LIST_HEAD(fcoe_hostlist);
> @@ -80,7 +77,6 @@ static int fcoe_reset(struct Scsi_Host *);
>  static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
>  static int fcoe_rcv(struct sk_buff *, struct net_device *,
>  		    struct packet_type *, struct net_device *);
> -static int fcoe_percpu_receive_thread(void *);
>  static void fcoe_percpu_clean(struct fc_lport *);
>  static int fcoe_link_ok(struct fc_lport *);
> =20
> @@ -107,7 +103,6 @@ static int fcoe_ddp_setup(struct fc_lport *, u16,=
 struct scatterlist *,
>  static int fcoe_ddp_done(struct fc_lport *, u16);
>  static int fcoe_ddp_target(struct fc_lport *, u16, struct scatterlis=
t *,
>  			   unsigned int);
> -static int fcoe_cpu_callback(struct notifier_block *, unsigned long,=
 void *);
>  static int fcoe_dcb_app_notification(struct notifier_block *notifier=
,
>  				     ulong event, void *ptr);
> =20
> @@ -136,11 +131,6 @@ static struct notifier_block fcoe_notifier =3D {
>  	.notifier_call =3D fcoe_device_notification,
>  };
> =20
> -/* notification function for CPU hotplug events */
> -static struct notifier_block fcoe_cpu_notifier =3D {
> -	.notifier_call =3D fcoe_cpu_callback,
> -};
> -
>  /* notification function for DCB events */
>  static struct notifier_block dcb_notifier =3D {
>  	.notifier_call =3D fcoe_dcb_app_notification,
> @@ -1245,152 +1235,21 @@ static int __exit fcoe_if_exit(void)
>  	return 0;
>  }
> =20
> -/**
> - * fcoe_percpu_thread_create() - Create a receive thread for an onli=
ne CPU
> - * @cpu: The CPU index of the CPU to create a receive thread for
> - */
> -static void fcoe_percpu_thread_create(unsigned int cpu)
> +static void fcoe_thread_cleanup_local(unsigned int cpu)
>  {
> -	struct fcoe_percpu_s *p;
> -	struct task_struct *thread;
> -
> -	p =3D &per_cpu(fcoe_percpu, cpu);
> -
> -	thread =3D kthread_create_on_node(fcoe_percpu_receive_thread,
> -					(void *)p, cpu_to_node(cpu),
> -					"fcoethread/%d", cpu);
> -
> -	if (likely(!IS_ERR(thread))) {
> -		kthread_bind(thread, cpu);
> -		wake_up_process(thread);
> -
> -		spin_lock_bh(&p->fcoe_rx_list.lock);
> -		p->thread =3D thread;
> -		spin_unlock_bh(&p->fcoe_rx_list.lock);
> -	}
> -}
> -
> -/**
> - * fcoe_percpu_thread_destroy() - Remove the receive thread of a CPU
> - * @cpu: The CPU index of the CPU whose receive thread is to be dest=
royed
> - *
> - * Destroys a per-CPU Rx thread. Any pending skbs are moved to the
> - * current CPU's Rx thread. If the thread being destroyed is bound t=
o
> - * the CPU processing this context the skbs will be freed.
> - */
> -static void fcoe_percpu_thread_destroy(unsigned int cpu)
> -{
> -	struct fcoe_percpu_s *p;
> -	struct task_struct *thread;
>  	struct page *crc_eof;
> -	struct sk_buff *skb;
> -#ifdef CONFIG_SMP
> -	struct fcoe_percpu_s *p0;
> -	unsigned targ_cpu =3D get_cpu();
> -#endif /* CONFIG_SMP */
> +	struct fcoe_percpu_s *p;
> =20
> -	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
> -
> -	/* Prevent any new skbs from being queued for this CPU. */
> -	p =3D &per_cpu(fcoe_percpu, cpu);
> +	p =3D per_cpu_ptr(&fcoe_percpu, cpu);
>  	spin_lock_bh(&p->fcoe_rx_list.lock);
> -	thread =3D p->thread;
> -	p->thread =3D NULL;
>  	crc_eof =3D p->crc_eof_page;
>  	p->crc_eof_page =3D NULL;
>  	p->crc_eof_offset =3D 0;
>  	spin_unlock_bh(&p->fcoe_rx_list.lock);
> =20
> -#ifdef CONFIG_SMP
> -	/*
> -	 * Don't bother moving the skb's if this context is running
> -	 * on the same CPU that is having its thread destroyed. This
> -	 * can easily happen when the module is removed.
> -	 */
> -	if (cpu !=3D targ_cpu) {
> -		p0 =3D &per_cpu(fcoe_percpu, targ_cpu);
> -		spin_lock_bh(&p0->fcoe_rx_list.lock);
> -		if (p0->thread) {
> -			FCOE_DBG("Moving frames from CPU %d to CPU %d\n",
> -				 cpu, targ_cpu);
> -
> -			while ((skb =3D __skb_dequeue(&p->fcoe_rx_list)) !=3D NULL)
> -				__skb_queue_tail(&p0->fcoe_rx_list, skb);
> -			spin_unlock_bh(&p0->fcoe_rx_list.lock);
> -		} else {
> -			/*
> -			 * The targeted CPU is not initialized and cannot accept
> -			 * new	skbs. Unlock the targeted CPU and drop the skbs
> -			 * on the CPU that is going offline.
> -			 */
> -			while ((skb =3D __skb_dequeue(&p->fcoe_rx_list)) !=3D NULL)
> -				kfree_skb(skb);
> -			spin_unlock_bh(&p0->fcoe_rx_list.lock);
> -		}
> -	} else {
> -		/*
> -		 * This scenario occurs when the module is being removed
> -		 * and all threads are being destroyed. skbs will continue
> -		 * to be shifted from the CPU thread that is being removed
> -		 * to the CPU thread associated with the CPU that is processing
> -		 * the module removal. Once there is only one CPU Rx thread it
> -		 * will reach this case and we will drop all skbs and later
> -		 * stop the thread.
> -		 */
> -		spin_lock_bh(&p->fcoe_rx_list.lock);
> -		while ((skb =3D __skb_dequeue(&p->fcoe_rx_list)) !=3D NULL)
> -			kfree_skb(skb);
> -		spin_unlock_bh(&p->fcoe_rx_list.lock);
> -	}
> -	put_cpu();
> -#else
> -	/*
> -	 * This a non-SMP scenario where the singular Rx thread is
> -	 * being removed. Free all skbs and stop the thread.
> -	 */
> -	spin_lock_bh(&p->fcoe_rx_list.lock);
> -	while ((skb =3D __skb_dequeue(&p->fcoe_rx_list)) !=3D NULL)
> -		kfree_skb(skb);
> -	spin_unlock_bh(&p->fcoe_rx_list.lock);
> -#endif
> -
> -	if (thread)
> -		kthread_stop(thread);
> -
>  	if (crc_eof)
>  		put_page(crc_eof);
> -}
> -
> -/**
> - * fcoe_cpu_callback() - Handler for CPU hotplug events
> - * @nfb:    The callback data block
> - * @action: The event triggering the callback
> - * @hcpu:   The index of the CPU that the event is for
> - *
> - * This creates or destroys per-CPU data for fcoe
> - *
> - * Returns NOTIFY_OK always.
> - */
> -static int fcoe_cpu_callback(struct notifier_block *nfb,
> -			     unsigned long action, void *hcpu)
> -{
> -	unsigned cpu =3D (unsigned long)hcpu;
> -
> -	switch (action) {
> -	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
> -		FCOE_DBG("CPU %x online: Create Rx thread\n", cpu);
> -		fcoe_percpu_thread_create(cpu);
> -		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> -		FCOE_DBG("CPU %x offline: Remove Rx thread\n", cpu);
> -		fcoe_percpu_thread_destroy(cpu);
> -		break;
> -	default:
> -		break;
> -	}
> -	return NOTIFY_OK;
> +	flush_work(&p->work);
>  }
> =20
>  /**
> @@ -1509,26 +1368,6 @@ static int fcoe_rcv(struct sk_buff *skb, struc=
t net_device *netdev,
> =20
>  	fps =3D &per_cpu(fcoe_percpu, cpu);
>  	spin_lock(&fps->fcoe_rx_list.lock);
> -	if (unlikely(!fps->thread)) {
> -		/*
> -		 * The targeted CPU is not ready, let's target
> -		 * the first CPU now. For non-SMP systems this
> -		 * will check the same CPU twice.
> -		 */
> -		FCOE_NETDEV_DBG(netdev, "CPU is online, but no receive thread "
> -				"ready for incoming skb- using first online "
> -				"CPU.\n");
> -
> -		spin_unlock(&fps->fcoe_rx_list.lock);
> -		cpu =3D cpumask_first(cpu_online_mask);
> -		fps =3D &per_cpu(fcoe_percpu, cpu);
> -		spin_lock(&fps->fcoe_rx_list.lock);
> -		if (!fps->thread) {
> -			spin_unlock(&fps->fcoe_rx_list.lock);
> -			goto err;
> -		}
> -	}
> -
>  	/*
>  	 * We now have a valid CPU that we're targeting for
>  	 * this skb. We also have this receive thread locked,
> @@ -1543,8 +1382,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct=
 net_device *netdev,
>  	 * in softirq context.
>  	 */
>  	__skb_queue_tail(&fps->fcoe_rx_list, skb);
> -	if (fps->thread->state =3D=3D TASK_INTERRUPTIBLE)
> -		wake_up_process(fps->thread);
> +	schedule_work_on(cpu, &fps->work);
>  	spin_unlock(&fps->fcoe_rx_list.lock);
> =20
>  	return NET_RX_SUCCESS;
> @@ -1713,15 +1551,6 @@ static int fcoe_xmit(struct fc_lport *lport, s=
truct fc_frame *fp)
>  }
> =20
>  /**
> - * fcoe_percpu_flush_done() - Indicate per-CPU queue flush completio=
n
> - * @skb: The completed skb (argument required by destructor)
> - */
> -static void fcoe_percpu_flush_done(struct sk_buff *skb)
> -{
> -	complete(&fcoe_flush_completion);
> -}
> -
> -/**
>   * fcoe_filter_frames() - filter out bad fcoe frames, i.e. bad CRC
>   * @lport: The local port the frame was received on
>   * @fp:	   The received frame
> @@ -1792,8 +1621,7 @@ static void fcoe_recv_frame(struct sk_buff *skb=
)
>  	fr =3D fcoe_dev_from_skb(skb);
>  	lport =3D fr->fr_dev;
>  	if (unlikely(!lport)) {
> -		if (skb->destructor !=3D fcoe_percpu_flush_done)
> -			FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb\n");
> +		FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb\n");
>  		kfree_skb(skb);
>  		return;
>  	}
> @@ -1857,40 +1685,28 @@ static void fcoe_recv_frame(struct sk_buff *s=
kb)
>  }
> =20
>  /**
> - * fcoe_percpu_receive_thread() - The per-CPU packet receive thread
> - * @arg: The per-CPU context
> + * fcoe_receive_work() - The per-CPU worker
> + * @work: The work struct
>   *
> - * Return: 0 for success
>   */
> -static int fcoe_percpu_receive_thread(void *arg)
> +static void fcoe_receive_work(struct work_struct *work)
>  {
> -	struct fcoe_percpu_s *p =3D arg;
> +	struct fcoe_percpu_s *p;
>  	struct sk_buff *skb;
>  	struct sk_buff_head tmp;
> =20
> +	p =3D container_of(work, struct fcoe_percpu_s, work);
>  	skb_queue_head_init(&tmp);
> =20
> -	set_user_nice(current, MIN_NICE);
> +	spin_lock_bh(&p->fcoe_rx_list.lock);
> +	skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
> +	spin_unlock_bh(&p->fcoe_rx_list.lock);
> =20
> -	while (!kthread_should_stop()) {
> +	if (!skb_queue_len(&tmp))
> +		return;
> =20
> -		spin_lock_bh(&p->fcoe_rx_list.lock);
> -		skb_queue_splice_init(&p->fcoe_rx_list, &tmp);
> -
> -		if (!skb_queue_len(&tmp)) {
> -			set_current_state(TASK_INTERRUPTIBLE);
> -			spin_unlock_bh(&p->fcoe_rx_list.lock);
> -			schedule();
> -			continue;
> -		}
> -
> -		spin_unlock_bh(&p->fcoe_rx_list.lock);
> -
> -		while ((skb =3D __skb_dequeue(&tmp)) !=3D NULL)
> -			fcoe_recv_frame(skb);
> -
> -	}
> -	return 0;
> +	while ((skb =3D __skb_dequeue(&tmp)))
> +		fcoe_recv_frame(skb);
>  }
> =20
>  /**
> @@ -2450,36 +2266,19 @@ static int fcoe_link_ok(struct fc_lport *lpor=
t)
>   *
>   * Must be called with fcoe_create_mutex held to single-thread compl=
etion.
>   *
> - * This flushes the pending skbs by adding a new skb to each queue a=
nd
> - * waiting until they are all freed.  This assures us that not only =
are
> - * there no packets that will be handled by the lport, but also that=
 any
> - * threads already handling packet have returned.
> + * This flushes the pending skbs by flush the work item for each CPU=
=2E The work
> + * item on each possible CPU is flushed because we may have used the=
 per-CPU
> + * struct of an offline CPU.
>   */
>  static void fcoe_percpu_clean(struct fc_lport *lport)
>  {
>  	struct fcoe_percpu_s *pp;
> -	struct sk_buff *skb;
>  	unsigned int cpu;
> =20
>  	for_each_possible_cpu(cpu) {
>  		pp =3D &per_cpu(fcoe_percpu, cpu);
> =20
> -		if (!pp->thread || !cpu_online(cpu))
> -			continue;
> -
> -		skb =3D dev_alloc_skb(0);
> -		if (!skb)
> -			continue;
> -
> -		skb->destructor =3D fcoe_percpu_flush_done;
> -
> -		spin_lock_bh(&pp->fcoe_rx_list.lock);
> -		__skb_queue_tail(&pp->fcoe_rx_list, skb);
> -		if (pp->fcoe_rx_list.qlen =3D=3D 1)
> -			wake_up_process(pp->thread);
> -		spin_unlock_bh(&pp->fcoe_rx_list.lock);
> -
> -		wait_for_completion(&fcoe_flush_completion);
> +		flush_work(&pp->work);
>  	}
>  }
> =20
> @@ -2625,22 +2424,11 @@ static int __init fcoe_init(void)
>  	mutex_lock(&fcoe_config_mutex);
> =20
>  	for_each_possible_cpu(cpu) {
> -		p =3D &per_cpu(fcoe_percpu, cpu);
> +		p =3D per_cpu_ptr(&fcoe_percpu, cpu);
> +		INIT_WORK(&p->work, fcoe_receive_work);
>  		skb_queue_head_init(&p->fcoe_rx_list);
>  	}
> =20
> -	cpu_notifier_register_begin();
> -
> -	for_each_online_cpu(cpu)
> -		fcoe_percpu_thread_create(cpu);
> -
> -	/* Initialize per CPU interrupt thread */
> -	rc =3D __register_hotcpu_notifier(&fcoe_cpu_notifier);
> -	if (rc)
> -		goto out_free;
> -
> -	cpu_notifier_register_done();
> -
>  	/* Setup link change notification */
>  	fcoe_dev_setup();
> =20
> @@ -2652,12 +2440,6 @@ static int __init fcoe_init(void)
>  	return 0;
> =20
>  out_free:
> -	for_each_online_cpu(cpu) {
> -		fcoe_percpu_thread_destroy(cpu);
> -	}
> -
> -	cpu_notifier_register_done();
> -
>  	mutex_unlock(&fcoe_config_mutex);
>  	destroy_workqueue(fcoe_wq);
>  	return rc;
> @@ -2690,14 +2472,8 @@ static void __exit fcoe_exit(void)
>  	}
>  	rtnl_unlock();
> =20
> -	cpu_notifier_register_begin();
> -
> -	for_each_online_cpu(cpu)
> -		fcoe_percpu_thread_destroy(cpu);
> -
> -	__unregister_hotcpu_notifier(&fcoe_cpu_notifier);
> -
> -	cpu_notifier_register_done();
> +	for_each_possible_cpu(cpu)
> +		fcoe_thread_cleanup_local(cpu);
> =20
>  	mutex_unlock(&fcoe_config_mutex);
> =20
> diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
> index de7e3ee60f0c..c6fbbb6581d3 100644
> --- a/include/scsi/libfcoe.h
> +++ b/include/scsi/libfcoe.h
> @@ -319,14 +319,16 @@ struct fcoe_transport {
> =20
>  /**
>   * struct fcoe_percpu_s - The context for FCoE receive thread(s)
> - * @thread:	    The thread context
> + * @kthread:	    The thread context (used by bnx2fc)
> + * @work:	    The work item (used by fcoe)
>   * @fcoe_rx_list:   The queue of pending packets to process
>   * @page:	    The memory page for calculating frame trailer CRCs
>   * @crc_eof_offset: The offset into the CRC page pointing to availab=
le
>   *		    memory for a new trailer
>   */
>  struct fcoe_percpu_s {
> -	struct task_struct *thread;
> +	struct task_struct *kthread;
> +	struct work_struct work;
>  	struct sk_buff_head fcoe_rx_list;
>  	struct page *crc_eof_page;
>  	int crc_eof_offset;
> --=20
> 2.8.0.rc3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
