From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: Tree for Aug 1
Date: Wed, 1 Aug 2018 21:58:37 -0700
Message-ID: <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
References: <20180801175852.36549130@canb.auug.org.au>
 <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com>
 <20180801234727.GA3762@roeck-us.net>
 <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
 <1533168205.3158.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533168205.3158.12.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Ming Lei <tom.leiming@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/01/2018 05:03 PM, James Bottomley wrote:
> On Thu, 2018-08-02 at 07:57 +0800, Ming Lei wrote:
>> On Thu, Aug 2, 2018 at 7:47 AM, Guenter Roeck <linux@roeck-us.net>
>> wrote:
>>> On Wed, Aug 01, 2018 at 03:52:45PM -0700, James Bottomley wrote:
>>>> On Wed, 2018-08-01 at 15:48 -0700, Guenter Roeck wrote:
>>>>> On Wed, Aug 01, 2018 at 05:58:52PM +1000, Stephen Rothwell
>>>>> wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> Changes since 20180731:
>>>>>>
>>>>>> The pci tree gained a conflict against the pci-current tree.
>>>>>>
>>>>>> The net-next tree gained a conflict against the bpf tree.
>>>>>>
>>>>>> The block tree lost its build failure.
>>>>>>
>>>>>> The staging tree still had its build failure due to an
>>>>>> interaction
>>>>>> with
>>>>>> the vfs tree for which I disabled CONFIG_EROFS_FS.
>>>>>>
>>>>>> The kspp tree lost its build failure.
>>>>>>
>>>>>> Non-merge commits (relative to Linus' tree): 10070
>>>>>>   9137 files changed, 417605 insertions(+), 179996 deletions(-
>>>>>> )
>>>>>>
>>>>>> -----------------------------------------------------------
>>>>>> ------
>>>>>> -----------
>>>>>>
>>>>>
>>>>> The widespread kernel hang issues are still seen. I managed
>>>>> to bisect it after working around the transient build failures.
>>>>> Bisect log is attached below. Unfortunately, it doesn't help
>>>>> much.
>>>>> The culprit is reported as:
>>>>>
>>>>> 2d542828c5e9 Merge remote-tracking branch 'scsi/for-next'
>>>>>
>>>>> The preceding merge,
>>>>>
>>>>> 453f1d821165 Merge remote-tracking branch 'cgroup/for-next'
>>>>>
>>>>> checks out fine, as does the tip of scsi-next (commit
>>>>> 103c7b7e0184,
>>>>> "Merge branch 'misc' into for-next"). No idea how to proceed.
>>>>
>>>> This sounds like you may have a problem with this patch:
>>>>
>>>>      commit d5038a13eca72fb216c07eb717169092e92284f1
>>>>       Author: Johannes Thumshirn <jthumshirn@suse.de>
>>>>       Date:   Wed Jul 4 10:53:56 2018 +0200
>>>>
>>>>           scsi: core: switch to scsi-mq by default
>>>>
>>>> To verify, boot with the additional kernel parameter
>>>>
>>>> scsi_mod.use_blk_mq=0
>>>>
>>>> Which will reverse the effect of the above patch.
>>>>
>>>
>>> Yes, that fixes the problem.
>>
>> That may not the root cause, given this issue is only started to
>> see from next-20180731, but d5038a13eca7 (scsi: core: switch to
>> scsi-mq by default)
>> has been in -next for quite a while.
>>
>> Seems something new causes this issue.
> 
> Read my other email about how to find this.
> 
> https://marc.info/?l=linux-scsi&m=153316446223676
> 
> Now that we've confirmed the issue, Gunter, could you attempt to bisect
> it as that email describes?
> 

So, I am more and more baffled.

I ran another round of bisect, this time each test executing twice,
once with "scsi_mod.use_blk_mq=1" and once with "scsi_mod.use_blk_mq=0",
requiring both to pass. Bisect still points to the merge as culprit.

Ok, one step further: Actually _revert_ commit d5038a13eca72 before running
each test, meaning the default is use_blk_mq=0. Still run both tests.
Bisect _still_ points to the merge of scsi-next as culprit.

So, to me it looks like the problem is triggered by _something_ in
scsi-next, combined with _something_ in -next prior to the merge,
not specifically associated with use_blk_mq=[0|1] or d5038a13eca72,
but to a combination of some patch in scsi-next and some other patch.

I am running out of ideas. Any thoughts on how to track this down further ?

Guenter
