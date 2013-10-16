From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
Date: Wed, 16 Oct 2013 18:41:05 -0400
Message-ID: <525F1601.8080906@interlog.com>
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com>	 <5253A9E7.5030707@oracle.com> <52540C7F.8050207@interlog.com> <1381929897.1864.0.camel@dabdike>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1381929897.1864.0.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 13-10-16 09:24 AM, James Bottomley wrote:
> On Tue, 2013-10-08 at 09:45 -0400, Douglas Gilbert wrote:
>> On 13-10-08 02:44 AM, vaughan wrote:
>>> Hi Madper,
>>>
>>> CC to Douglas to get comments.
>>> I use the rw_semaphore o_sem to protect excl open, introduced in commit
>>> 15b06f9a02406e5460001db6d5af5c738cd3d4e7 since v3.12-rc1.
>>> Is it forbidden to do like that in kernel?...
>>
>> It appears you can not (allow sg_open() to hold a semaphore
>> then return to the user space). So you will need to do some
>> rework on that patch or revert it.
>
> OK, there being no reply on this, I'll do the revert ... that's all four
> patches, correct?

That seems to be the case. Vaughan acknowledged the
problem and forwarded it to me 8 days ago. Yes, it
seems to be a "no-no" to hold a any kernel semaphore
when returning to the user space; in this case from
sg_open(). I was hoping a revised patch might
appear from Vaughan but to date that has not been
the case. So with only a few weeks to go before
lk 3.12 is released, reverting the whole 4 patches
in that series seems to be the safest course.

Also without a new patch from Vaughan in the next few
weeks he may also miss the opportunity of getting
his improved O_EXCL logic into the lk 3.13 series.


Thinking about how to solve this problem: a field could
be added to 'struct sg_device' with one of three states:
no_opens, non_excl_opens and excl_open. It could be
manipulated by sg_open() and sg_release() like a
read-write semaphore. And the faulty 'struct
rw_semaphore o_sem' in sg_device could be replaced by a
normal semaphore to protect the manipulation of the new
three-state field.

Doug Gilbert
