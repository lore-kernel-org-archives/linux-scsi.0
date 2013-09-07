From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Sat, 07 Sep 2013 23:05:39 +0800
Message-ID: <522B40C3.2080605@intel.com>
References: <Pine.LNX.4.44L0.1309061153010.1165-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1309061153010.1165-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2013 11:56 PM, Alan Stern wrote:
> On Fri, 6 Sep 2013, James Bottomley wrote:
> 
>>> layer runtime PM. Accordingly, the SCSI bus layer runtime PM callback is
>>> simplified as all SCSI devices that implement runtime PM are now request
>>> based.
>>
>> OK, let's now try for a descriptive changelog.  All SCSI devices
>> (including sr) are "request based".  I think what you mean is "all SCSI
>> devices which implement runtime PM have an exposed block device"?
> 
> Actually Aaron means "All SCSI drivers implementing runtime PM now use
> the block layer's request-based mechanism."

Exactly, thanks for the clarification Alan. I'll update changlog using
the above words in v3.

> 
>>> Note that due to ODD will be polled every 2 seconds,
>>
>> Since the device will be polled every 2 seconds
>>
>>>  for suspend to
>>> actually happen, the autosuspend_delay can not be set to more than 2
>>> seconds or the polling interval has to be increased.
>>
>> Is this true?  What about event driven devices?  Supposing a distro has
>> a different interval.
>>
>> How about
>>
>> If your Distribution polls the device, the autosuspend interval cannot
>> be set to longer than the polling interval otherwise the device will
>> never suspend.
> 
> The default polling done by the kernel uses 2-second intervals.  Of 
> course, distributions and users can change this or disable it entirely.

What about:
Note that due to the device will be polled by kernel at a constant
interval specified at /sys/module/block/parameters/events_dfl_poll_msecs,
the default value is 2 seconds, the autosuspend delay cannot be set to
longer than the polling interval otherwise the device will never suspend.

Thanks,
Aaron
