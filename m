From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 16:49:12 +0800
Message-ID: <50519E08.10800@intel.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>   <1347522049-1836-2-git-send-email-aaron.lu@intel.com>  <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>  <50519801.6080502@intel.com> <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2IMIta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2012 04:49:30 -0400
In-Reply-To: <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On 09/13/2012 04:37 PM, James Bottomley wrote:
> On Thu, 2012-09-13 at 16:23 +0800, Aaron Lu wrote:
>> On 09/13/2012 04:14 PM, James Bottomley wrote:
>>> On Thu, 2012-09-13 at 15:40 +0800, Aaron Lu wrote:
>>>> The ready_to_power_off flag is used to give indication to ATA layer
>>>> if this device's power can be removed when runtime suspended.
>>>>
>>>> This flag is determined by individual SCSI driver like sr, sd.
>>>>
>>>> This flag is introduced to support zero power ODD. When ODD
>>>> is runtime suspended, it may not be OK to remove its power.
>>>>
>>>> But for disk, it is always OK to be powered off, so set this flag.
>>>
>>> It is? I may have missed this, but where do you flush the cache of write
>>> back cache devices you're about to power off?
>>
>> I suppose that is handled in sd_suspend callback, the power off happens
>> after a device is runtime suspended.
> 
> Well that would mean something is wrong somewhere:  For runtime power
> management using idle timers and forced standby, there's no need to

The current mechanism for scsi disk runtime pm is based on open/close.
If there is some process opened this block device, it will be in active
state; only when all opened session exited, it will enter runtime
suspend state.

> flush the cache (if the drive goes into standby on its own as a result
> of an idle timeout, the cache will never flush).  The cache needs to
> flush before we power off the device: that's before the system goes into
> S3, or now before you power it off at runtime.  Flushing the cache on
> runtime transitions to standby will likely cause performance problems
> since that happens quite often.

As explained above, it didn't happen that often, especially for user who
has only one disk, the disk will be mounted, which makes it never be
able to enter runtime suspend state.

Thanks,
Aaron
