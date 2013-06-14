From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Fri, 14 Jun 2013 10:59:32 -0700
Message-ID: <51BB5A04.3080901@mellanox.com>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BB1857.7040802-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Bart,

> On 06/13/13 21:43, Vu Pham wrote:
>   
>> Hello Bart,
>>
>>     
>>> +What:        /sys/class/srp_remote_ports/port-<h>:<n>/dev_loss_tmo
>>> +Date:        September 1, 2013
>>> +KernelVersion:    3.11
>>> +Contact:    linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> +Description:    Number of seconds the SCSI layer will wait after a 
>>> transport
>>> +        layer error has been observed before removing a target port.
>>> +        Zero means immediate removal.
>>>       
>> A negative value will disable the target port removal.
>>
>> <snip>
>>     
>>> +
>>> +/**
>>> + * srp_tmo_valid() - check timeout combination validity
>>> + *
>>> + * If no fast I/O fail timeout has been configured then the device 
>>> loss timeout
>>> + * must be below SCSI_DEVICE_BLOCK_MAX_TIMEOUT. If a fast I/O fail 
>>> timeout has
>>> + * been configured then it must be below the device loss timeout.
>>> + */
>>> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
>>> +{
>>> +    return (fast_io_fail_tmo < 0 && 1 <= dev_loss_tmo &&
>>> +        dev_loss_tmo <= SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
>>> +        || (0 <= fast_io_fail_tmo &&
>>> +            (dev_loss_tmo < 0 ||
>>> +             (fast_io_fail_tmo < dev_loss_tmo &&
>>> +              dev_loss_tmo < LONG_MAX / HZ))) ? 0 : -EINVAL;
>>> +}
>>> +EXPORT_SYMBOL_GPL(srp_tmo_valid);
>>>       
>> fast_io_fail_tmo is off, one cannot turn off dev_loss_tmo with negative 
>> value
>> dev_loss_tmo is off, one cannot turn off fast_io_fail_tmo with negative 
>> value
>>     
>
> OK, will update the documentation such that it correctly refers to "off" instead of a negative value and I will also mention that dev_loss_tmo can now be disabled.
>
>   
It's not only the documentation but also the code logic, you cannot turn 
dev_loss_tmo off if fast_io_fail_tmo already turned off and vice versa 
with the return statement above.
>> <snip>
>>     
>>> + * srp_reconnect_rport - reconnect by invoking 
>>> srp_function_template.reconnect()
>>> + *
>>> + * Blocks SCSI command queueing before invoking reconnect() such that 
>>> the
>>> + * scsi_host_template.queuecommand() won't be invoked concurrently with
>>> + * reconnect(). This is important since a reconnect() implementation may
>>> + * reallocate resources needed by queuecommand(). Please note that this
>>> + * function neither waits until outstanding requests have finished 
>>> nor tries
>>> + * to abort these. It is the responsibility of the reconnect() 
>>> function to
>>> + * finish outstanding commands before reconnecting to the target port.
>>> + */
>>> +int srp_reconnect_rport(struct srp_rport *rport)
>>> +{
>>> +    struct Scsi_Host *shost = rport_to_shost(rport);
>>> +    struct srp_internal *i = to_srp_internal(shost->transportt);
>>> +    struct scsi_device *sdev;
>>> +    int res;
>>> +
>>> +    pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
>>> +
>>> +    res = mutex_lock_interruptible(&rport->mutex);
>>> +    if (res) {
>>> +        pr_debug("%s: mutex_lock_interruptible() returned %d\n",
>>> +             dev_name(&shost->shost_gendev), res);
>>> +        goto out;
>>> +    }
>>> +
>>> +    spin_lock_irq(shost->host_lock);
>>> +    scsi_block_requests(shost);
>>> +    spin_unlock_irq(shost->host_lock);
>>> +
>>>       
>> In scsi_block_requests() definition, no locks are assumed held.
>>     
>
> Good catch :-) However, if you look around in drivers/scsi you will see that several SCSI LLD drivers invoke scsi_block_requests() with the host lock held. I'm not sure whether these LLDs or the scsi_block_requests() documentation is incorrect. Anyway, I'll leave the locking statements out since these are not necessary around this call of scsi_block_requests().
>
>   
>> If rport's state is already SRP_RPORT_BLOCKED, I don't think we need to 
>> do extra block with scsi_block_requests()
>>     
>
> Please keep in mind that srp_reconnect_rport() can be called from two different contexts: that function can not only be called from inside the SRP transport layer but also from inside the SCSI error handler (see also the srp_reset_device() modifications in a later patch in this series). If this function is invoked from the context of the SCSI error handler the chance is high that the SCSI device will have another state than SDEV_BLOCK. Hence the scsi_block_requests() call in this function.
>   
Yes, srp_reconnect_rport() can be called from two contexts; however, it 
deals with same rport & rport's state.
I'm thinking something like this:

    if (rport->state != SRP_RPORT_BLOCKED) {
	scsi_block_requests(shost);

    while (scsi_request_fn_active(shost))
        msleep(20);

    res = i->f->reconnect(rport);

    pr_debug("%s (state %d): transport.reconnect() returned %d\n",
         dev_name(&shost->shost_gendev), rport->state, res);
    if (res == 0) {
        cancel_delayed_work(&rport->fast_io_fail_work);
        cancel_delayed_work(&rport->dev_loss_work);
        rport->failed_reconnects = 0;
        scsi_unblock_requests(shost);
        srp_rport_set_state(rport, SRP_RPORT_RUNNING);
        /*
         * It can occur that after fast_io_fail_tmo expired and before
         * dev_loss_tmo expired that the SCSI error handler has
         * offlined one or more devices. scsi_target_unblock() doesn't
         * change the state of these devices into running, so do that
         * explicitly.
         */
        spin_lock_irq(shost->host_lock);
        __shost_for_each_device(sdev, shost)
            if (sdev->sdev_state == SDEV_OFFLINE)
                sdev->sdev_state = SDEV_RUNNING;
        spin_unlock_irq(shost->host_lock);
    } else if (rport->state != SRP_RPORT_BLOCKED) {
        scsi_unblock_requests(shost);
	mutex_unlock(&rport->mutex);
	srp_start_tl_fail_timers(rport);  /* we should consider some elapse time already passed ie. scsi command timedout seconds)
	mutex_lock(&rport->mutex);
    }

>   
>> Shouldn't we avoid using both scsi_block/unblock_requests() and 
>> scsi_target_block/unblock()?
>> ie. in srp_start_tl_fail_timers()  call scsi_block_requests(), in 
>> __rport_fast_io_fail_timedout() and rport_dev_loss_timedout() call 
>> scsi_unblock_requests()
>> and using scsi_block/unblock_requests in this function.
>>     
>
> I agree that using only one of these two mechanisms would be more elegant. However, the advantage of using scsi_target_block() as long as fast_io_fail_tmo has not expired is that this functions set the SDEV_BLOCK state which is recognized by multipathd.
Could you point out the advantage of multipathd recognizing the 
SDEV_BLOCK state while fast_io_fail_tmo has not expired?

>  The reason scsi_block_requests() is used in the above function is to prevent that a user can reenable requests via sysfs while a new InfiniBand RC connection is being established. A call of srp_queuecommand() concurrently with srp_create_target_ib() can namely result in a kernel crash.
>
>   
Agreed.
I think that we can use only the pair 
scsi_block_requests()/scsi_unblock_requests() unless the advantage of 
multipathd recognizing the SDEV_BLOCK is noticeable.
>>> +    while (scsi_request_fn_active(shost))
>>> +        msleep(20);
>>> +
>>> +    res = i->f->reconnect(rport);
>>> +    scsi_unblock_requests(shost);
>>> +    pr_debug("%s (state %d): transport.reconnect() returned %d\n",
>>> +         dev_name(&shost->shost_gendev), rport->state, res);
>>> +    if (res == 0) {
>>> +        cancel_delayed_work(&rport->fast_io_fail_work);
>>> +        cancel_delayed_work(&rport->dev_loss_work);
>>> +        rport->failed_reconnects = 0;
>>> +        scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
>>> +        srp_rport_set_state(rport, SRP_RPORT_RUNNING);
>>> +        /*
>>> +         * It can occur that after fast_io_fail_tmo expired and before
>>> +         * dev_loss_tmo expired that the SCSI error handler has
>>> +         * offlined one or more devices. scsi_target_unblock() doesn't
>>> +         * change the state of these devices into running, so do that
>>> +         * explicitly.
>>> +         */
>>> +        spin_lock_irq(shost->host_lock);
>>> +        __shost_for_each_device(sdev, shost)
>>> +            if (sdev->sdev_state == SDEV_OFFLINE)
>>> +                sdev->sdev_state = SDEV_RUNNING;
>>> +        spin_unlock_irq(shost->host_lock);
>>> +    } else if (rport->state == SRP_RPORT_RUNNING) {
>>> +        srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
>>> +        scsi_target_unblock(&shost->shost_gendev,
>>> +                    SDEV_TRANSPORT_OFFLINE);
>>>       
>> Would this unblock override the fast_io_fail_tmo functionality?
>>     
>
> Sorry but I don't think so. If something goes wrong with the transport layer then the function srp_start_tl_fail_timers() gets invoked. That function starts with changing the state from SRP_RPORT_RUNNING into SRP_RPORT_BLOCKED. In other words, the code below "if (rport->state == SRP_RPORT_RUNNING)" can only be reached if srp_reconnect_rport() is invoked from the context of the SCSI error handler and not if it is called from inside one of the new SRP transport layer times. In other words, whether or not that code will be reached depends on whether fast_io_fail_tmo is below or above the SCSI command timeout.
>
>   
Yes, if one set RC retry_count=7 and fast_io_fail_tmo > scsi command 
timed out, the scsi command timed out may happen before transport error 
detected, so srp_reconnect_rport() will called in scsi error handler 
context and the else if statement above will override the 
fast_io_fail_tmo functionality.
Please look back to my reference code above.
>>> +static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
>>> +{
>>> +    struct scsi_device *sdev = scmd->device;
>>> +
>>> +    pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
>>> +    return scsi_device_blocked(sdev) ? BLK_EH_RESET_TIMER :
>>> +        BLK_EH_NOT_HANDLED;
>>>       
>> if one turn off fast_io_fail_tmo, rport_fast_io_fail_timedout() won't be 
>> called, and reconnect is failed, scsi_device_blocked remains true, error 
>> recovery cannot happen
>> I think it should be
>> return (scsi_device_blocked(sdev) && rport->fast_io_fail_tmo > 0) ? 
>> BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
>>     
>
> How about the following alternative ?
>   
It look good. Let me do some testing

-vu

> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 53b34b3..84574fb 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -550,11 +550,12 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
>                 goto out_unlock;
>         pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
>                  rport->state);
> -       scsi_target_block(&shost->shost_gendev);
>  
> -       if (rport->fast_io_fail_tmo >= 0)
> +       if (rport->fast_io_fail_tmo >= 0) {
> +               scsi_target_block(&shost->shost_gendev);
>                 queue_delayed_work(system_long_wq, &rport->fast_io_fail_work,
>                                    1UL * rport->fast_io_fail_tmo * HZ);
> +       }
>         if (rport->dev_loss_tmo >= 0)
>                 queue_delayed_work(system_long_wq, &rport->dev_loss_work,
>                                    1UL * rport->dev_loss_tmo * HZ);
>
> Bart.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
