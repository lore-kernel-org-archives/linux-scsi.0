From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] fix to serialize unload and discovery
Date: Thu, 19 Oct 2006 13:58:23 -0700 (PDT)
Message-ID: <20061019205823.48812.qmail@web31802.mail.mud.yahoo.com>
References: <20061019032337.GA19570@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:38320 "HELO
	web31802.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1946491AbWJSU6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 16:58:24 -0400
In-Reply-To: <20061019032337.GA19570@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com, linux-scsi@vger.kernel.org

--- malahal@us.ibm.com wrote:
> sas_discover_domain() and sas_deform_port() assume that they are single
> threaded and never run in parallel.

This is indeed not true.

> That is mostly true as we have a
> single threaded work queue to handle discovery and other events.

Hint: when the port is gone, it is gone...

> The
> only race I find is unloading a module will call sas_deform_port()
> without watching if there is a discovery event is in progress. This
> patch will stop queuing further events, flush the queue, and then call
> sas_deform_port() to avoid the race.

You need a much more elaborate (read: general solution, aka algorithm)
framework to solve this.

Needless to say, I don't observe these bugs and errors in my version
of the SAS Stack.

    Luben

> 
> Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> 
> 
> diff -r 8fe3b862f968 drivers/scsi/libsas/sas_discover.c
> --- a/drivers/scsi/libsas/sas_discover.c	Tue Oct 17 13:24:04 2006 -0700
> +++ b/drivers/scsi/libsas/sas_discover.c	Tue Oct 17 13:25:28 2006 -0700
> @@ -722,7 +722,7 @@ int sas_discover_event(struct asd_sas_po
>  	BUG_ON(ev >= DISC_NUM_EVENTS);
>  
>  	sas_queue_event(ev, &disc->disc_event_lock, &disc->pending,
> -			&disc->disc_work[ev], port->ha->core.shost);
> +			&disc->disc_work[ev], port->ha);
>  
>  	return 0;
>  }
> diff -r 8fe3b862f968 drivers/scsi/libsas/sas_event.c
> --- a/drivers/scsi/libsas/sas_event.c	Tue Oct 17 13:24:04 2006 -0700
> +++ b/drivers/scsi/libsas/sas_event.c	Tue Oct 17 13:25:28 2006 -0700
> @@ -31,7 +31,7 @@ static void notify_ha_event(struct sas_h
>  	BUG_ON(event >= HA_NUM_EVENTS);
>  
>  	sas_queue_event(event, &sas_ha->event_lock, &sas_ha->pending,
> -			&sas_ha->ha_events[event], sas_ha->core.shost);
> +			&sas_ha->ha_events[event], sas_ha);
>  }
>  
>  static void notify_port_event(struct asd_sas_phy *phy, enum port_event event)
> @@ -41,7 +41,7 @@ static void notify_port_event(struct asd
>  	BUG_ON(event >= PORT_NUM_EVENTS);
>  
>  	sas_queue_event(event, &ha->event_lock, &phy->port_events_pending,
> -			&phy->port_events[event], ha->core.shost);
> +			&phy->port_events[event], ha);
>  }
>  
>  static void notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
> @@ -51,7 +51,7 @@ static void notify_phy_event(struct asd_
>  	BUG_ON(event >= PHY_NUM_EVENTS);
>  
>  	sas_queue_event(event, &ha->event_lock, &phy->phy_events_pending,
> -			&phy->phy_events[event], ha->core.shost);
> +			&phy->phy_events[event], ha);
>  }
>  
>  int sas_init_events(struct sas_ha_struct *sas_ha)
> diff -r 8fe3b862f968 drivers/scsi/libsas/sas_init.c
> --- a/drivers/scsi/libsas/sas_init.c	Tue Oct 17 13:24:04 2006 -0700
> +++ b/drivers/scsi/libsas/sas_init.c	Tue Oct 17 13:29:02 2006 -0700
> @@ -85,6 +85,9 @@ int sas_register_ha(struct sas_ha_struct
>  	else if (sas_ha->lldd_queue_size == -1)
>  		sas_ha->lldd_queue_size = 128; /* Sanity */
>  
> +	sas_ha->state = SAS_HA_REGISTERED;
> +	spin_lock_init(&sas_ha->state_lock);
> +
>  	error = sas_register_phys(sas_ha);
>  	if (error) {
>  		printk(KERN_NOTICE "couldn't register sas phys:%d\n", error);
> @@ -123,9 +126,18 @@ Undo_phys:
>  
>  int sas_unregister_ha(struct sas_ha_struct *sas_ha)
>  {
> +	unsigned long flags;
> +
>  	if (sas_ha->lldd_max_execute_num > 1) {
>  		sas_shutdown_queue(sas_ha);
>  	}
> +
> +	/* Set the state to unregistered to avoid further
> +	 * events to be queued */
> +	spin_lock_irqsave(&sas_ha->state_lock, flags);
> +	sas_ha->state = SAS_HA_UNREGISTERED;
> +	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
> +	scsi_flush_work(sas_ha->core.shost);
>  
>  	sas_unregister_ports(sas_ha);
>  
> diff -r 8fe3b862f968 drivers/scsi/libsas/sas_internal.h
> --- a/drivers/scsi/libsas/sas_internal.h	Tue Oct 17 13:24:04 2006 -0700
> +++ b/drivers/scsi/libsas/sas_internal.h	Tue Oct 17 13:25:28 2006 -0700
> @@ -80,7 +80,7 @@ static inline void sas_queue_event(int e
>  static inline void sas_queue_event(int event, spinlock_t *lock,
>  				   unsigned long *pending,
>  				   struct work_struct *work,
> -				   struct Scsi_Host *shost)
> +				   struct sas_ha_struct *sas_ha)
>  {
>  	unsigned long flags;
>  
> @@ -91,7 +91,12 @@ static inline void sas_queue_event(int e
>  	}
>  	__set_bit(event, pending);
>  	spin_unlock_irqrestore(lock, flags);
> -	scsi_queue_work(shost, work);
> +
> +	spin_lock_irqsave(&sas_ha->state_lock, flags);
> +	if (sas_ha->state != SAS_HA_UNREGISTERED) {
> +		scsi_queue_work(sas_ha->core.shost, work);
> +	}
> +	spin_unlock_irqrestore(&sas_ha->state_lock, flags);
>  }
>  
>  static inline void sas_begin_event(int event, spinlock_t *lock,
> diff -r 8fe3b862f968 include/scsi/libsas.h
> --- a/include/scsi/libsas.h	Tue Oct 17 13:24:04 2006 -0700
> +++ b/include/scsi/libsas.h	Tue Oct 17 13:25:28 2006 -0700
> @@ -307,11 +307,19 @@ struct scsi_core {
>  	int               queue_thread_kill;
>  };
>  
> +enum sas_ha_state {
> +       SAS_HA_REGISTERED,
> +       SAS_HA_UNREGISTERED
> +};
> +
>  struct sas_ha_struct {
>  /* private: */
>  	spinlock_t       event_lock;
>  	struct work_struct ha_events[HA_NUM_EVENTS];
>  	unsigned long	 pending;
> +
> +	enum sas_ha_state state;
> +	spinlock_t 	  state_lock;
>  
>  	struct scsi_core core;
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

