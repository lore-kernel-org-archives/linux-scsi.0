From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 07/10] hpsa: hide logical drives with format in progress
 from linux
Date: Fri, 27 Sep 2013 12:54:39 -0400
Message-ID: <5245B84F.6090605@interlog.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com> <20130923183401.19995.99662.stgit@beardog.cce.hp.com> <5245868B.4080900@redhat.com> <20130927133451.GY31476@beardog.cce.hp.com> <52458FBA.3010602@redhat.com> <20130927144155.GZ31476@beardog.cce.hp.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38484 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3I0QzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Sep 2013 12:55:09 -0400
In-Reply-To: <20130927144155.GZ31476@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com, Tomas Henzl <thenzl@redhat.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

On 13-09-27 10:41 AM, scameron@beardog.cce.hp.com wrote:
> On Fri, Sep 27, 2013 at 04:01:30PM +0200, Tomas Henzl wrote:
>> On 09/27/2013 03:34 PM, scameron@beardog.cce.hp.com wrote:
>>> On Fri, Sep 27, 2013 at 03:22:19PM +0200, Tomas Henzl wrote:
>>>> On 09/23/2013 08:34 PM, Stephen M. Cameron wrote:
>>>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>>>
>>>>> SCSI mid layer doesn't seem to handle logical drives undergoing format
>>>>> very well.  scsi_add_device on such devices seems to result in hitting
>>>>> those devices with a TUR at a rate of 3Hz for awhile, transitioning
>>>>> to hitting them with a READ(10) at a much higher rate indefinitely,
>>>>> and at boot time, this prevents the system from coming up.  If we
>>>>> do not expose such devices to the kernel, it isn't bothered by them.
>>>> Is the result of this patch that the drive is no more visible for the user
>>>> and he can't follow the formatting progress?
>>> Yes (subsequent patch monitors the progress and brings the drive
>>> online when it's ready).
>>>
>>>> I think a better option is to fix the kernel to handle formatting devices better
>>> Yeah, you're probably right. (This is what comes of writing code for all
>>> the distros then forward porting to kernel.org code.  Grumble-grumble-management
>>> grumble-grumble real-world problems.)
>>>
>>>> or harden the hpsa so it can cope with TURs or reads (ignore) from a formatting
>>>> device.
>>> I don't think hpsa driver had any problem with the TURs or READs though,
>>> they would be returned to the mid layer just fine (TUR returned sense data
>>> indicating not ready, format in progress, I forget what the reads
>>> returned, whatever the firmware filled in for the sense data, which
>>> was reasonable), but the mid-layer was relentless and just never
>>> really proceeded, iirc.
>>>
>>> Since we were trying to make this work on existing OSes where fixing the
>>> SCSI mid layer wasn't an option, we came up with this.
>>
>> I'm actually glad that you care about existing OSes :)
>
> And the pain of porting would be much the same regardless of
> whether the port is forward or backward, I suppose.
>
>>
>> Do you know whether the midlayer has similar problems with other drivers?
>
> No, not sure.   One thing that's a bit unusual about hpsa is it uses
> the scan_start and scan_finished members of scsi_host_template, so hpsa
> does its own scanning, rather than let the midlayer do the scanning which
> is due to Smart Array's weirdness around the vicinity of SCSI_REPORT_LUNS.
>
> I suspect that a lld driver calling scsi_add_device() on something which
> is NOT READY/FORMAT IN PROGRESS is what provokes the trouble.  Most drivers
> do not call scsi_add_device() directly at all, so it's quite possible most
> drivers do not experience such a problem. A few do call scsi_add_device()
> directly, like ipr or pmcraid, so these might conceivably have a similar
> problem.
>
> We ran into this problem with what we call "Rapid Parity Initialization", which
> is what you get when the RAID controller leaves the logical volume in a NOT
> READY/FORMAT IN PROGRESS state and devotes itself entirely to initializing
> parity data and when that's done, then the volume starts acting normally.
>
> Initializing the parity data can take quite a long time (hours), but not as
> long as initializing it on the fly under load, which, with very large,
> relatively slow drives can take nigh on forever, hence the "rapid" parity
> initialization moniker.  So, if those other RAID controllers don't have a
> similar feature that produces a relatively long lived NOT READY/FORMAT IN
> PROGRESS state, they may not bump into the problem.

     {0x04,0x04,"Logical unit not ready, format in progress"},
     {0x04,0x05,"Logical unit not ready, rebuild in progress"},
     {0x04,0x06,"Logical unit not ready, recalculation in progress"},
     {0x04,0x07,"Logical unit not ready, operation in progress"},
...
     {0x04,0x1b,"Logical unit not ready, sanitize in progress"},

Wouldn't perhaps 0x4,0x5 be more accurate? If someone managed to
send a FORMAT UNIT or SANITIZE to a physical drive behind your LV,
that would be a completely different issue.

Doug Gilbert


