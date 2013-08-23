From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [RFC PATCH] scsi: Add failfast mode to avoid infinite retry loop
Date: Fri, 23 Aug 2013 08:26:46 -0400
Message-ID: <52175506.6010502@gmail.com>
References: <20130819093925.7867.19221.stgit@ltc223.sdl.hitachi.co.jp>  <1376922616.2069.9.camel@dabdike.int.hansenpartnership.com>  <5213172E.1060905@hitachi.com> <1377022167.3872.13.camel@localhost.localdomain> <52172721.1040203@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52172721.1040203@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>
Cc: emilne@redhat.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/23/2013 05:10 AM, Eiichi Tsukata wrote:
> (2013/08/21 3:09), Ewan Milne wrote:
>> On Tue, 2013-08-20 at 16:13 +0900, Eiichi Tsukata wrote:
>>> (2013/08/19 23:30), James Bottomley wrote:
>>>> On Mon, 2013-08-19 at 18:39 +0900, Eiichi Tsukata wrote:
>>>>> Hello,
>>>>>
>>>>> This patch adds scsi device failfast mode to avoid infinite retry loop.
>>>>>
>>>>> Currently, scsi error handling in scsi_decide_disposition() and
>>>>> scsi_io_completion() unconditionally retries on some errors. This is because
>>>>> retryable errors are thought to be temporary and the scsi device will soon
>>>>> recover from those errors. Normally, such retry policy is appropriate because
>>>>> the device will soon recover from temporary error state.
>>>>> But there is no guarantee that device is able to recover from error state
>>>>> immediately. Some hardware error may prevent device from recovering.
>>>>> Therefore hardware error can results in infinite command retry loop. In fact,
>>>>> CHECK_CONDITION error with the sense-key = UNIT_ATTENTION caused infinite
>>>>> retry loop in our environment. As the comments in kernel source code says,
>>>>> UNIT_ATTENTION means the device must have been a power glitch and expected
>>>>> to immediately recover from the state. But it seems that hardware error
>>>>> caused permanent UNIT_ATTENTION error.
>>>>>
>>>>> To solve the above problem, this patch introduces scsi device "failfast 
>>>>> mode".
>>>>> If failfast mode is enabled, retry counts of all scsi commands are limited to
>>>>> scsi->allowed(== SD_MAX_RETRIES == 5). All commands are prohibited to retry
>>>>> infinitely, and immediately fails when the retry count exceeds upper limit.
>>>>> Failfast mode is useful on mission critical systems which are required
>>>>> to keep running flawlessly because they need to failover to the secondary
>>>>> system once they detect failures.
>>>>> On default, failfast mode is disabled because failfast policy is not suitable
>>>>> for most use cases which can accept I/O latency due to device hardware error.
>>>>>
>>>>> To enable failfast mode(default disabled):
>>>>>            # echo 1> /sys/bus/scsi/devices/X:X:X:X/failfast
>>>>> To disable:
>>>>>            # echo 0> /sys/bus/scsi/devices/X:X:X:X/failfast
>>>>>
>>>>> Furthermore, I'm planning to make the upper limit count configurable.
>>>>> Currently, I have two plans to implement it:
>>>>> (1) set same upper limit count on all errors.
>>>>> (2) set upper limit count on each error.
>>>>> The first implementation is simple and easy to implement but not flexible.
>>>>> Someone wants to set different upper limit count on each errors depends on 
>>>>> the
>>>>> scsi device they use. The second implementation satisfies such requirement
>>>>> but can be too fine-grained and annoying to configure because scsi error
>>>>> codes are so much. The default 5 times retry may too much on some errors but
>>>>> too few on other errors.
>>>>>
>>>>> Which would be the appropriate implementation?
>>>>> Any comments or suggestions are welcome as usual.
>>>>
>>>> I'm afraid you'll need to propose another solution.  We have a large
>>>> selection of commands which, by design, retry until the command exceeds
>>>> it's timeout.  UA is one of those (as are most of the others you're
>>>> limiting).  How do you kick this device out of its UA return (because
>>>> that's the recovery that needs to happen)?
>>>>
>>>> James
>>>>
>>>>
>>>
>>> Thanks for reviewing, James.
>>>
>>> Originally, I planned that once the retry count exceeds its limit,
>>> a monitoring tool stops the server with the scsi prink error message
>>> as a trigger.
>>> Current failfast mode implementation is that the command fails when
>>> retry command exceeds its limit. However, I noticed that only printing error 
>>> messages
>>> on retry counts excess without changing retry logic will be enough
>>> to stop the server and take fail over.  Though there is no guarantee that
>>> userspace application can work properly on disk failure condition.
>>> So, now I'm considering that just calling panic() on retry excess is better.
>>>
>>> For that reason, I propose the solution that adding "panic_on_error" option to
>>> sysfs parameter and if panic_on_error mode is enabled the server panics
>>> immediately once it detects retry excess. Of course, it is disabled on default.
>>>
>>> I would appreciate it if you could give me some comments.
>>>
>>> Eiichi
>>> -- 
>>
>> For what it's worth, I've seen a report of a case where a storage array
>> returned a CHECK CONDITION with invalid sense data, which caused the
>> command to be retried indefinitely.
>
> Thank you for commenting, Ewan.
> I appreciate your information about indefinite retry on CHECK CONDITION.
>
>> I'm not sure what you can do about
>> this, if the device won't ever complete a command without an error.
>> Perhaps it should be offlined after sufficiently bad behavior.
>>
>> I don't think you want to panic on an error, though.  In a clustered
>> environment it is possible that the other systems will all fail in the
>> same way, for example.
>>
>> -Ewan
>>
>
> Yes, basically the device should be offlined on error detection.
> Just offlining the disk is enough when an error occurs on "not" os-installed
> system disk. Panic is going too far on such case.
>
> However, in a clustered environment where computers use each its own disk and
> do not share the same disk, calling panic() will be suitable when an error
> occurs in system disk. Because even on such disk error, cluster monitoring
> tool may not be able to detect the system failure while heartbeat can continue
> working.
> So, I think basically offlining is enough and also, panic is necessary on some 
> cases.
>
> Eiichi
>

I think that most file systems would let you decide when to panic on an IO error 
(like ext4's various mount options). Sometimes panic will be the right thing to 
do, but I think that should not be done in the SCSI system but at a higher layer.

What if you have multiple LUN's and file systems and only lose one? Should we 
panic them all?

Best regards,

Ric
