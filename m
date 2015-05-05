From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 06/12] scsi_transport_srp: Reduce failover time
Date: Tue, 5 May 2015 11:38:53 +0200
Message-ID: <55488FAD.5090407@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EF01.3030008@sandisk.com>
 <5542002D.8060308@dev.mellanox.co.il> <55420BAA.7060507@sandisk.com>
 <554246E6.9020503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554246E6.9020503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/30/15 17:14, Sagi Grimberg wrote:
> On 4/30/2015 2:02 PM, Bart Van Assche wrote:
>> On 04/30/15 12:13, Sagi Grimberg wrote:
>>> On 4/30/2015 11:59 AM, Bart Van Assche wrote:
>>>> Unlike FC, there is no risk that SCSI devices will be offlined
>>>> by the error handler if it is started while a reconnect attempt
>>>> is ongoing. Hence report timeout errors as soon as possible
>>>> if a higher software layer (e.g. multipathd) needs to be informed
>>>> about a timeout. It is assumed that if both fast_io_fail_tmo < 0
>>>> and rport->dev_loss_tmo < 0 that this means that there is no
>>>> need to report timeouts quickly.
>>>>
>>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
>>>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>>>> ---
>>>>   drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
>>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_transport_srp.c
>>>> b/drivers/scsi/scsi_transport_srp.c
>>>> index 4a44337..6667c2b 100644
>>>> --- a/drivers/scsi/scsi_transport_srp.c
>>>> +++ b/drivers/scsi/scsi_transport_srp.c
>>>> @@ -61,6 +61,11 @@ static inline struct Scsi_Host
>>>> *rport_to_shost(struct srp_rport *r)
>>>>       return dev_to_shost(r->dev.parent);
>>>>   }
>>>>
>>>> +static inline struct srp_rport *shost_to_rport(struct Scsi_Host
>>>> *shost)
>>>> +{
>>>> +    return transport_class_to_srp_rport(&shost->shost_gendev);
>>>> +}
>>>> +
>>>>   /**
>>>>    * srp_tmo_valid() - check timeout combination validity
>>>>    * @reconnect_delay: Reconnect delay in seconds.
>>>> @@ -626,9 +631,11 @@ static enum blk_eh_timer_return
>>>> srp_timed_out(struct scsi_cmnd *scmd)
>>>>       struct scsi_device *sdev = scmd->device;
>>>>       struct Scsi_Host *shost = sdev->host;
>>>>       struct srp_internal *i = to_srp_internal(shost->transportt);
>>>> +    struct srp_rport *rport = shost_to_rport(shost);
>>>>
>>>>       pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
>>>> -    return i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
>>>> +    return rport->fast_io_fail_tmo < 0 && rport->dev_loss_tmo < 0 &&
>>>> +        i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
>>>>           BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
>>>>   }
>>>>
>>>>
>>>
>>> I'm not sure I understand the purpose of this patch? If the user
>>> requested fast_io_fail_tmo of X, I would assume it wants srp to retry
>>> for the command for X secs. Why should we fail it any earlier than that?
>>>
>>> There is a situation where I've seen srp starting the fast_io_fail_tmo
>>> later than expected because the QP retry exceeded error completion
>>> arrives late for certain workloads. Was this the motivation for this
>>> patch?
>>
>> The purpose of the srp_timed_out() function is not about failing
>> commands early but about postponing timeout errors. The above patch
>> causes a SCSI timeout to be handled as soon as the command timer expires
>> if rport->fast_io_fail_tmo >= 0 or rport->dev_loss_tmo >= 0.
>
> This change is effective only when
> time_to_wc_err + fast_io_fail_tmo < cmd_timeout.
>
> If the user chose this configuration, I imagine the wanted behavior is
> that the timeout errors won't be propagated as soon as the cmd timeout
> expires no?
>
> Today, srp return BLK_EH_RESET_TIMER until fast_io_fail_tmo kicks in,
> and at that point, it unblocks the scsi target terminates all the
> commands with TRANSPORT_FAIL_FAST. This will change the behavior to
> trigger scsi-eh (abort, reset_device) and reset_host will trigger
> another reconnect which is redundant (we have reconnect work inflight).
>
> Can you explain the motivation?

Sure. The only reason why the srp_timed_out() function has been added is 
to avoid that I/O times out when both the fast_io_fail and dev_loss 
mechanisms have been disabled and while a reconnect is ongoing. However, 
if multipathd is running we want timeout errors to be reported as soon 
as possible such that multipathd can switch to another path quickly if 
another working path is available.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
