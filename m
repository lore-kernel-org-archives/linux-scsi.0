From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 17:07:43 +0800
Message-ID: <5051A25F.7040704@intel.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>    <1347522049-1836-2-git-send-email-aaron.lu@intel.com>   <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>   <50519801.6080502@intel.com>  <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>  <50519E08.10800@intel.com> <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/13/2012 04:56 PM, James Bottomley wrote:
> On Thu, 2012-09-13 at 16:49 +0800, Aaron Lu wrote:
>> On 09/13/2012 04:37 PM, James Bottomley wrote:
>>> On Thu, 2012-09-13 at 16:23 +0800, Aaron Lu wrote:
>>>> On 09/13/2012 04:14 PM, James Bottomley wrote:
>>>>> On Thu, 2012-09-13 at 15:40 +0800, Aaron Lu wrote:
>>>>>> The ready_to_power_off flag is used to give indication to ATA layer
>>>>>> if this device's power can be removed when runtime suspended.
>>>>>>
>>>>>> This flag is determined by individual SCSI driver like sr, sd.
>>>>>>
>>>>>> This flag is introduced to support zero power ODD. When ODD
>>>>>> is runtime suspended, it may not be OK to remove its power.
>>>>>>
>>>>>> But for disk, it is always OK to be powered off, so set this flag.
>>>>>
>>>>> It is? I may have missed this, but where do you flush the cache of write
>>>>> back cache devices you're about to power off?
>>>>
>>>> I suppose that is handled in sd_suspend callback, the power off happens
>>>> after a device is runtime suspended.
>>>
>>> Well that would mean something is wrong somewhere:  For runtime power
>>> management using idle timers and forced standby, there's no need to
>>
>> The current mechanism for scsi disk runtime pm is based on open/close.
>> If there is some process opened this block device, it will be in active
>> state; only when all opened session exited, it will enter runtime
>> suspend state.
> 
> A mounted disk is open for the period of the mount.  I thought the use
> case for runtime PM was the laptop one but most laptops have a single
> device to use as root, so if you never use runtime PM on an open device,
> you never use it on 99% of our target systems ... doesn't that make the
> feature a bit useless?

I agree, but it may be helpful in some cases.

> 
>>> flush the cache (if the drive goes into standby on its own as a result
>>> of an idle timeout, the cache will never flush).  The cache needs to
>>> flush before we power off the device: that's before the system goes into
>>> S3, or now before you power it off at runtime.  Flushing the cache on
>>> runtime transitions to standby will likely cause performance problems
>>> since that happens quite often.
>>
>> As explained above, it didn't happen that often, especially for user who
>> has only one disk, the disk will be mounted, which makes it never be
>> able to enter runtime suspend state.
> 
> So what's the target audience for the feature.  If it isn't laptops or
> standard desktops, is it the enterprise?

To make this feature useful for normal laptop user, a better mechanism
for scsi disk runtime pm is needed. Alan Stern and Lin Ming has been
working on this, and I'll see if I can make that patch work later.

So I think this is basically 2 things, one is the runtime suspend of the
disk, another is when it is runtime suspended, how to remove its power.
I'm currently doing the latter one, which is simpler, so I want to do it
first :-)

And there may exist some cases this can be helpful, if user has 2 or
more disks attached and he is only using one of them or some other
corner cases that I don't know.

Considering the effort to implement this feature pretty small, and it
shouldn't cause trouble for existing system, I think this may be worth
it.

Thanks,
Aaron
