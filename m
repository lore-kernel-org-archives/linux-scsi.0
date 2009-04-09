From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Date: Thu, 09 Apr 2009 09:25:24 -0400
Message-ID: <49DDF744.1090209@garzik.org>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49DDF1EB.2060200@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Alan Cox wrote:
>> Something like this then ?
>>
>>
>> The legacy old IDE API for this is a bit primitive so we try and map 
>> stuff
>> sensibly onto it.
>>
>> - Add flags2 as we ran out of flags
>> - Set PIO over DMA devices to report 32bit
>> - Add ability to change the PIO32 settings if the controller permits it
>> - Add that functionality into the sff drivers
>> - Add that functionality into the VLB legacy driver
>> - Turn on the 32bit PIO on the ninja32 and add support there
>>
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ..
> 
> By all means go ahead with something like this,
> and thanks for doing it, Alan.
> 
> But.. these do look rather suspiciously like sysfs attrs to me.
> 
> We didn't have a sysfs in the IDE days (so Gadi added the klunky
> procfs "settings" thing for there), but we do now.
> 
> I'm happy to update hdparm to check sysfs if that's where this
> ends up, or to do almost nothing for it if we stick with the ioctls.

hmmm, Tejun's storage summit presentation would be quite relevant at 
this juncture :)

The short answer:  we need a control mechanism for tasks such SATA PHY 
twiddling, host controller reset, host controller configuration 
(set/clear 32-bit I/O in this example), ...

sysfs attrs are desired for this, but we've held off largely because 
this is all intertwined with the long term direction of "storage model", 
"transport protocol" and libata's eventual move away from strict SCSI 
dependency.

I think the best place for sysfs attr attachment is an ata_transport 
module, something that's needed to be written for quite a while.  You 
can see some of the eventual direction in scsi_transport_*.[ch] and 
raid_class.c.

Eventually I hope to reach a point where the current crop of SATA+SAS 
controllers out in the field (e.g. mvsas) will attach to 
scsi_transport_sas or ata_transport, depending on controller port 
configuration and attached device(s).  And for the sake of users' 
sanity, a single utility should be used to configure a SATA+SAS 
controller port.  Requiring use of hdparm when the port is in SATA mode, 
and sg_* when the port is in SAS mode, is a bit annoying.

	Jeff




