From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Wed, 05 Dec 2012 20:50:54 +0100
Message-ID: <50BFA59E.10208@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com> <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org> <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com> <1354242098.3670.3.camel@obelisk.thedillows.org> <CAJZOPZJBTRXftrW5NWEEHnf2QWsni0HMTAV_PKSgDtA7GO=wRw@mail.gmail.com> <50BF9760.2080801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50BF9760.2080801-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/05/12 19:50, Bart Van Assche wrote:
> On 12/05/12 19:23, Or Gerlitz wrote:
>> On Fri, Nov 30, 2012 at 4:21 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
>> [...]
>>> Modulo a few style issues (braces around one line if branches, etc.) and
>>> having three state variables vs one, I can live with everything up to
>>> aabfa852acd27962 at git://github.com/bvanassche/linux.git#srp-ha. Those
>>> two are small things that can be fixed later and are not worth holding
>>> things up any further.
>>>
>>> I'll try to spend some time on the final four patches tomorrow
>>> afternoon.
>>
>> Dave, Bart
>>
>> My colleague Alex Turin <alextu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> tried  today the bits as
>> they appear in Roland's kernel.org tree / for-next branch up to commit
>>   fb57e1dbbd4 and here's some feedback
>>
>> Basically, what he did was connecting  to a target, next take down the
>> IB port on the initiator side, and issue some IOs (dd if=/dev/sdb
>> of=/dev/null count=1)
>>
>> Our recollection of events from the logs (below) is the following
>>
>> 1. queued command get completion status 5
>>
>> 2. as part of error handling srp_reset_host() was called,
>>
>> 3. srp_reset_host() calls to srp_reconnect_target() which fails cause
>> port is down.
>>
>> 4. srp_reconnect_target() on failure calls to srp_queue_remove_work()
>> which sets
>> target->status to SRP_TARGET_REMOVED.
>>
>> 5.srp_reset_host() called second time. it calls to
>> srp_reconnect_target() but target->state == SRP_TARGET_REMOVED.
>> srp_reconnect_target() checks if target->state != SRP_TARGET_LIVE and
>> return -EAGAIN.
>>
>> This probably means that even after enabling port it will still fail
>> to reconnect?
>
> Hello Or,
>
> The only way to make I/O work reliably if a failure can occur at the
> transport layer is to use multipathd on top of ib_srp. If a connection
> fails for some reason, then the SRP SCSI host will be removed after the
> SCSI error handler has finished with its error recovery strategy. And
> once the transport layer is operational again and srp_daemon detects
> that the initiator is no longer logged in srp_daemon will make ib_srp
> log in again. multipathd will then cause I/O to continue over the new path.

(replying to my own e-mail)

Another possible approach would be to follow the FC model and to block 
I/O when a port goes down and to unblock I/O once I/O is again possible. 
Some time ago I had posted a patch that went somewhat in this direction 
and in which ib_srp tried to reconnect to a target repeatedly after a 
transport layer failure. That patch can be found here:

http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg10158.html

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
