From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Thu, 13 Jun 2013 12:43:41 -0700
Message-ID: <51BA20ED.6040200@mellanox.com>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B8777B.5050201-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Bart,

>  
> +What:		/sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
> +Date:		September 1, 2013
> +KernelVersion:	3.11
> +Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Number of seconds the SCSI layer will wait after a transport
> +		layer error has been observed before removing a target port.
> +		Zero means immediate removal.
>   
A negative value will disable the target port removal.
> +
> +What:		/sys/class/srp_remote_ports/port-<h>:<n>/fast_io_fail_tmo
> +Date:		September 1, 2013
> +KernelVersion:	3.11
> +Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Number of seconds the SCSI layer will wait after a transport
> +		layer error has been observed before failing I/O. Zero means
> +		immediate removal. A negative value will disable this
> +		behavior.
>
>   
<snip>
> +
> +/**
> + * srp_tmo_valid() - check timeout combination validity
> + *
> + * If no fast I/O fail timeout has been configured then the device loss timeout
> + * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail timeout has
> + * been configured then it must be below the device loss timeout.
> + */
> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
> +{
> +	return (fast_io_fail_tmo < 0 && 1 <= dev_loss_tmo &&
> +		dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
> +		|| (0 <= fast_io_fail_tmo &&
> +		    (dev_loss_tmo < 0 ||
> +		     (fast_io_fail_tmo < dev_loss_tmo &&
> +		      dev_loss_tmo < LONG_MAX / HZ))) ? 0 : -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
>   
fast_io_fail_tmo is off, one cannot turn off dev_loss_tmo with negative 
value
dev_loss_tmo is off, one cannot turn off fast_io_fail_tmo with negative 
value

<snip>
>
> + * srp_reconnect_rport - reconnect by invoking srp_function_template.reconnect()
> + *
> + * Blocks SCSI command queueing before invoking reconnect() such that the
> + * scsi_host_template.queuecommand() won't be invoked concurrently with
> + * reconnect(). This is important since a reconnect() implementation may
> + * reallocate resources needed by queuecommand(). Please note that this
> + * function neither waits until outstanding requests have finished nor tries
> + * to abort these. It is the responsibility of the reconnect() function to
> + * finish outstanding commands before reconnecting to the target port.
> + */
> +int srp_reconnect_rport(struct srp_rport *rport)
> +{
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	struct srp_internal *i = to_srp_internal(shost->transportt);
> +	struct scsi_device *sdev;
> +	int res;
> +
> +	pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
> +
> +	res = mutex_lock_interruptible(&rport->mutex);
> +	if (res) {
> +		pr_debug("%s: mutex_lock_interruptible() returned %d\n",
> +			 dev_name(&shost->shost_gendev), res);
> +		goto out;
> +	}
> +
> +	spin_lock_irq(shost->host_lock);
> +	scsi_block_requests(shost);
> +	spin_unlock_irq(shost->host_lock);
> +
>   
In scsi_block_requests() definition, no locks are assumed held.

If rport's state is already SRP_RPORT_BLOCKED, I don't think we need to 
do extra block with scsi_block_requests()

Shouldn't we avoid using both scsi_block/unblock_requests() and 
scsi_target_block/unblock()?
ie. in srp_start_tl_fail_timers()  call scsi_block_requests(), in 
__rport_fast_io_fail_timedout() and rport_dev_loss_timedout() call 
scsi_unblock_requests()
and using scsi_block/unblock_requests in this fuction.
> +	while (scsi_request_fn_active(shost))
> +		msleep(20);
> +
> +	res = i->f->reconnect(rport);
> +	scsi_unblock_requests(shost);
> +	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
> +		 dev_name(&shost->shost_gendev), rport->state, res);
> +	if (res == 0) {
> +		cancel_delayed_work(&rport->fast_io_fail_work);
> +		cancel_delayed_work(&rport->dev_loss_work);
> +		rport->failed_reconnects = 0;
> +		scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
> +		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
> +		/*
> +		 * It can occur that after fast_io_fail_tmo expired and before
> +		 * dev_loss_tmo expired that the SCSI error handler has
> +		 * offlined one or more devices. scsi_target_unblock() doesn't
> +		 * change the state of these devices into running, so do that
> +		 * explicitly.
> +		 */
> +		spin_lock_irq(shost->host_lock);
> +		__shost_for_each_device(sdev, shost)
> +			if (sdev->sdev_state == SDEV_OFFLINE)
> +				sdev->sdev_state = SDEV_RUNNING;
> +		spin_unlock_irq(shost->host_lock);
> +	} else if (rport->state == SRP_RPORT_RUNNING) {
> +		srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
> +		scsi_target_unblock(&shost->shost_gendev,
> +				    SDEV_TRANSPORT_OFFLINE);
>   
Would this unblock override the fast_io_fail_tmo functionality?

> +	}
> +	mutex_unlock(&rport->mutex);
> +
> +out:
> +	return res;
> +}
> +EXPORT_SYMBOL(srp_reconnect_rport);
> +
> +static void srp_reconnect_work(struct work_struct *work)
> +{
> +	struct srp_rport *rport = container_of(to_delayed_work(work),
> +					struct srp_rport, reconnect_work);
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	int delay, res;
> +
> +	res = srp_reconnect_rport(rport);
> +	if (res != 0) {
> +		shost_printk(KERN_ERR, shost,
> +			     "reconnect attempt %d failed (%d)\n",
> +			     ++rport->failed_reconnects, res);
> +		delay = rport->reconnect_delay *
> +			min(100, max(1, rport->failed_reconnects - 10));
> +		if (delay > 0)
> +			queue_delayed_work(system_long_wq,
> +					   &rport->reconnect_work, delay * HZ);
> +	}
> +}
> +
> +static void __rport_fast_io_fail_timedout(struct srp_rport *rport)
> +{
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	struct srp_internal *i;
> +
> +	lockdep_assert_held(&rport->mutex);
> +
> +	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
> +		return;
> +	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
> +
> +	/* Involve the LLDD if possible to terminate all io on the rport. */
> +	i = to_srp_internal(shost->transportt);
> +	if (i->f->terminate_rport_io)
> +		i->f->terminate_rport_io(rport);
> +}
> +
> +/**
> + * rport_fast_io_fail_timedout() - fast I/O failure timeout handler
> + *
> + * Unblocks the SCSI host.
> + */
> +static void rport_fast_io_fail_timedout(struct work_struct *work)
> +{
> +	struct srp_rport *rport = container_of(to_delayed_work(work),
> +					struct srp_rport, fast_io_fail_work);
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +
> +	pr_debug("fast_io_fail_tmo expired for %s.\n",
> +		 dev_name(&shost->shost_gendev));
> +
> +	mutex_lock(&rport->mutex);
> +	__rport_fast_io_fail_timedout(rport);
> +	mutex_unlock(&rport->mutex);
> +}
> +
> +/**
> + * rport_dev_loss_timedout() - device loss timeout handler
> + *
> + * Note: rport->ft->rport_delete must either unblock the SCSI host or schedule
> + * SCSI host removal.
> + */
> +static void rport_dev_loss_timedout(struct work_struct *work)
> +{
> +	struct srp_rport *rport = container_of(to_delayed_work(work),
> +					struct srp_rport, dev_loss_work);
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	struct srp_internal *i = to_srp_internal(shost->transportt);
> +
> +	pr_err("dev_loss_tmo expired for %s.\n",
> +	       dev_name(&shost->shost_gendev));
> +
> +	mutex_lock(&rport->mutex);
> +	WARN_ON(srp_rport_set_state(rport, SRP_RPORT_LOST) != 0);
> +	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
> +	mutex_unlock(&rport->mutex);
> +
> +	i->f->rport_delete(rport);
> +}
> +
> +/**
> + * srp_start_tl_fail_timers() - start the transport layer failure timers
> + *
> + * Start the transport layer fast I/O failure and device loss timers. Do not
> + * modify a timer that was already started.
> + */
> +void srp_start_tl_fail_timers(struct srp_rport *rport)
> +{
> +	struct Scsi_Host *shost = rport_to_shost(rport);
> +	int delay;
> +
> +	mutex_lock(&rport->mutex);
> +	pr_debug("%s current state: %d\n", dev_name(&shost->shost_gendev),
> +		 rport->state);
> +	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) != 0)
> +		goto out_unlock;
> +	pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
> +		 rport->state);
> +	scsi_target_block(&shost->shost_gendev);
> +
> +	if (rport->fast_io_fail_tmo >= 0)
> +		queue_delayed_work(system_long_wq, &rport->fast_io_fail_work,
> +				   1UL * rport->fast_io_fail_tmo * HZ);
> +	if (rport->dev_loss_tmo >= 0)
> +		queue_delayed_work(system_long_wq, &rport->dev_loss_work,
> +				   1UL * rport->dev_loss_tmo * HZ);
> +	delay = rport->reconnect_delay;
> +	if (delay > 0)
> +		queue_delayed_work(system_long_wq, &rport->reconnect_work,
> +				   1UL * delay * HZ);
> +out_unlock:
> +	mutex_unlock(&rport->mutex);
> +}
> +EXPORT_SYMBOL(srp_start_tl_fail_timers);
> +
> +/**
> + * srp_timed_out - SRP transport intercept of the SCSI timeout EH
> + *
> + * If a timeout occurs while an rport is in the blocked state, ask the SCSI
> + * EH to continue waiting (BLK_EH_RESET_TIMER). Otherwise let the SCSI core
> + * handle the timeout (BLK_EH_NOT_HANDLED).
> + *
> + * Note: This function is called from soft-IRQ context and with the request
> + * queue lock held.
> + */
> +static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_device *sdev = scmd->device;
> +
> +	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
> +	return scsi_device_blocked(sdev) ? BLK_EH_RESET_TIMER :
> +		BLK_EH_NOT_HANDLED;
>   
if one turn off fast_io_fail_tmo, rport_fast_io_fail_timedout() won't be 
called, and reconnect is failed, scsi_device_blocked remains true, error 
recovery cannot happen
I think it should be
return (scsi_device_blocked(sdev) && rport->fast_io_fail_tmo > 0) ? 
BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;

-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
