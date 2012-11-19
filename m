From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 19 Nov 2012 11:21:53 +0800
Message-ID: <50A9A5D1.5060900@intel.com>
References: <Pine.LNX.4.44L0.1211182058450.10879-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1211182058450.10879-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/19/2012 10:07 AM, Alan Stern wrote:
> On Sun, 18 Nov 2012, Tejun Heo wrote:
> 
>> Hey, Alan.
> 
> Hey...
> 
>> It's controlled by /sys/class/scsi_host/hostX/link_power_management.
>> Once enabled, the power saving is completedly handled by hardware.  If
>> link stays idle longer than certain duration, the hardware initiates
>> low power state and leaves it when something needs to happen.
>>
>>>> So, this whole autopm thing doesn't sound like a good idea to me.
>>>
>>> No doubt it's better suited to some devices than to others.
>>
>> Yeah, SATA seems to need a different approach than USB.
> 
> Based on your description, I agree.
> 
>>> That may be true for SATA.  For USB optical drives, it does make sense
>>> to power-down the host controller when the drive isn't in use.  USB
>>> suspend/resume takes on the order of 50-100 ms or so.
>>
>> I see.  For SATA too, the controller / link bring up doesn't take too
>> long.  The crappy part is what the attached, especially ATAPI, devices
>> would do after such events as those events will be visible to them
>> basically as random link resets.
>>
>> So, at least for SATA, I think what autopm can do is...
>>
>> * Trigger zpodd if possible.
>>
>> * Trigger suspend iff polling isn't happening on the device.
> 
> That sums it up nicely.  Of course, the PM core is unaware of details
> such as media polling.  What we can do is have the SATA runtime-idle
> method return -EBUSY if the device isn't a ZPODD and if polling is
> enabled.  Unfortunately I don't think there's any way currently to
> trigger autopm when the user turns off polling.  Maybe something could
> be added to the appropriate sysfs handler.

OK, thanks for your(both of you) suggestions.

But probably for ZPODD devices first, as it has a clear use case and
should already have productions. For async notification capable ODDs,
I'll leave it for someone else or maybe at a later time if I can get
such a device to test on.

To conclude, the ata port's runtime idle callback will return 0 when:
1 It attached a ZPODD capable ODD;
2 Or it attached a hard disk.
For all other cases, it will return -EBUSY.
Does this look correct?

Thanks,
Aaron

