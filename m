From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Mon, 14 Jan 2013 15:18:24 +0800
Message-ID: <50F3B140.2030003@intel.com>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com>  <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>  <1341550812.3023.3.camel@dabdike.hilton.com>  <1341554872.3628.30.camel@minggr> <1341561953.3023.31.camel@dabdike.hilton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341561953.3023.31.camel@dabdike.hilton.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Removed LinMing@intel

Hi James,

Sorry for the late reply, as I'm just picking up this work and thought
this may still need some discussion/clarification. Please see below.

On 07/06/2012 04:05 PM, James Bottomley wrote:
> On Fri, 2012-07-06 at 14:07 +0800, Lin Ming wrote:
>> On Fri, 2012-07-06 at 09:00 +0400, James Bottomley wrote:
>>> On Fri, 2012-07-06 at 12:04 +0800, Lin Ming wrote:
>>>> When a request is added:
>>>>     If device is suspended or is suspending and the request is not a
>>>>     PM request, resume the device.
>>>>
>>>> When a request finishes:
>>>>     Call pm_runtime_mark_last_busy().
>>>>
>>>> When pick a request:
>>>>     If device is resuming/suspending, then only PM request is allowed to go.
>>>>     Return NULL for other cases.
>>>
>>> This is a complete reinvention of the quiesce state, just with new names
>>> and moved up to block in part ... why do we have to have two separate
>>> systems for stopping a device and sending special commands when the
>>> device is suspended, why not just one?
>>
>> Yes, there are some duplicates with scsi layer quiesce state.
>> I'd like to do the cleanup.
> 
> The mechanism is pretty much identical:  For quiesce you set the sdev
> state to SDEV_QUIESCE and then send in special requests with REQ_PREEMPT
> to bypass the suspend.  In your additional scheme you set a queue flag
> RPM_SUSPENDED by a pm specific set of callbacks and you only then accept
> requests with REQ_PM.  I don't see any difference in actual effect
> (well, except that quiesce can be done on a non-empty queue, but that's
> a simple flag difference).

My understanding of quiesce state is that, it is used by scsi driver to
say: hold on for a moment, no more FS requests, I need to do some
housekeeping work for the device and when I'm done, I'll put it back to
normal state.

The housekeeping work will generally involve executing some commands for
the device using scsi_execute, as all requests originated from
scsi_execute are of type REQ_PREEMPT. But it is not for suspending the
device.

While for runtime suspended state, we can't say: everybody quiet, I'm
gonna sleep, so I'll ignore all of your requests. Instead, we keep track
of the device's activity, and once we have learned that it is not being
used by anyone, we put it into a low power state. And if there is any
requests arrived for it due to whatever user, we will need to resume it
to process the request.

So I think they are different, serves for different purposes.

> 
> What I don't want to see is duplicated mechanisms.  If you want to make
> a general quiesce mechanism in block instead of SCSI, I'm fine with
> that, but I want to see our current quiesce mechanism moved to it first
> since that demonstrates you got it right.  If you don't want to do that,
> then just use the existing mechanism in SCSI.
> 
> Now that I look at it, your q->nr_pending is an inexact duplicate of
> sdev->device_busy as well.  Again, no objection to moving this to block,
> but if you then make SCSI use it for sdev->device_busy, you'll get a
> very fast indication of whether you got this right or not, which is an
> excellent reason for unifying.

The nr_pending is the counter of how many requests are in the device's
request queue, while the device_busy is how many commands are being
processed by the device, and they can be different as Alan Stern has put
it here:
http://www.spinics.net/lists/linux-scsi/msg60497.html

And I think we still need device_busy in scsi layer, for the case when
the scsi prepare phase decides to defer the request(due to no memory or
whatever), we will have 1 request in the queue while no commands are
being processed by the device. And we need to keep track of such
information in order to decide if we need restart the queue when we
return BLKPREP_DEFER in function scsi_prep_return:

        case BLKPREP_DEFER:
                /*
                 * If we defer, the blk_peek_request() returns NULL, but the
                 * queue must be restarted, so we schedule a callback to happen
                 * shortly.
                 */
                if (sdev->device_busy == 0)
                        blk_delay_queue(q, SCSI_QUEUE_DELAY);
                break;

So I think we still need device_busy.

OK, this is my understanding, they may be wrong, so please let me know
what do you think, thanks.

-Aaron
