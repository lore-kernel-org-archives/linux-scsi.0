From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 5 May 2015 11:31:50 +0200
Message-ID: <55488E06.8040308@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
 <5541FB3F.70902@dev.mellanox.co.il> <5542111E.1080305@sandisk.com>
 <5542439D.1000107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5542439D.1000107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/30/15 17:00, Sagi Grimberg wrote:
> On 4/30/2015 2:25 PM, Bart Van Assche wrote:
>> On 04/30/15 11:51, Sagi Grimberg wrote:
>>> On 4/30/2015 11:58 AM, Bart Van Assche wrote:
>>>> @@ -170,6 +170,7 @@ struct srp_rdma_ch {
>>>>
>>>>       struct completion    tsk_mgmt_done;
>>>>       u8            tsk_mgmt_status;
>>>> +    bool            connected;
>>>
>>> I generally agree with this flag, but I'm a bit confused about the
>>> semantics of two connected flags? Also, we check the target connected
>>> flag on TMFs, although we are executing it on a channel (should we
>>> check both?)
>>>
>>> I'd say keep only the channel connected flag, the target logic needs to
>>> be mandated by the state.
>>
>> I think we need both flags. The ch->connected flag is used only in
>> srp_destroy_qp() to verify whether a channel has been disconnected
>> before it is destroyed. The target->connected flag provides an easy way
>> to test the connected state in e.g. srp_disconnect_target().
>
> We can just as easily check rport state. rport state is modified before
> target-connected. I still think one is redundant.

Sorry but I disagree. If e.g. both the fast_io_fail and dev_loss_tmo 
timers have been disabled then the rport state is SRP_RPORT_RUNNING all 
the time. At least in that case it is not possible to derive the 
target->connected state from the rport state.

>> And if it
>> is attempted to send a task management function over a channel that has
>> just been disconnected that should be fine since any channel disconnect
>> causes tl_err_work to be queued. That last action will sooner or later
>> result in a reconnect.
>
> Will it be fine to queue commands when the channel is in reconnecting
> stage?

As one can see in srp_reconnect_rport() the associated SCSI devices are 
blocked as long as a reconnect is in progress. This means that 
srp_queuecommand() won't be called while a reconnect is in progress.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
