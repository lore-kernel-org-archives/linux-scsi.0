From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 10/11] scsi: sr: support (un)block events
Date: Tue, 30 Oct 2012 13:02:35 +0800
Message-ID: <508F5F6B.2040706@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>  <1351501298-3716-11-git-send-email-aaron.lu@intel.com> <1351534295.3051.9.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1351534295.3051.9.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/30/2012 02:11 AM, James Bottomley wrote:
> On Mon, 2012-10-29 at 17:01 +0800, Aaron Lu wrote:
>> 2 interfaces are added to block/unblock events for the disk sr manages.
>> This is used by SATA ZPODD, when ODD is runtime powered off, the events
>> poll is no longer needed so better be blocked. And once powered on,
>> events poll will be unblocked.
>>
>> These 2 interfaces are needed here because SATA layer does not have
>> access to the gendisk structure sr manages.
> 
> I'm afraid this is a nasty layering violation.  You can't have a low
> level driver have knowledge of a call back in an upper layer one (in
> this case sr_block_events).

I agree. But since ZPODD is now implemented in ATA layer now, this seems
the only way to do it.

> 
> This is all done it looks like because of the problem of getting access
> to the scsi_cd structure from libata, but it's not the right way to
> solve it.

Indeed, and any suggestion on a right way?

> 
> I also don't really think you need to do any blocking or unblocking.  As
> I said in the previous thread, just fake the events the standard tells
> you to, so userspace can probe to its heart's content and you can keep
> the device powered off.

No problem for the device, the problem is for its ancestor devices in my
current implementation. If the event is not blocked, the ODD will be
runtime resumed every 2 seconds. And along the way, all its ancestor
devices will have to be runtime resumed every 2 seconds, even I did some
trick to avoid power on the ODD itself. This is not a good thing from
power management perspective.

And there are two reasons I want to align runtime PM with ZPODD:

1 Simpler code.
And if I do not align ZPODD with runtime PM, I will need to maintain the
ODD's software status myself, and deal with some race conditions like
when I was to power off the ODD, a new command may arrive; or when the
ODD is powering on, all arriving commands need to be failed for the
moment untill the ODD is fully recovered from EH, etc. And all these
things can be avoided if I rely on runtime PM framework.

2 Integrate with the whole system
With runtime PM, when ODD is suspended, its ancestor devices will have a
chance to enter low power state.

Basically, I think power off is a special suspend state, it should
happen after the device enters runtime suspended state, and this is the
idea I used to implement ZPODD.

Thanks,
Aaron

> 
> James
> 
> 
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>>  drivers/scsi/Makefile   |  1 +
>>  drivers/scsi/sr_zpodd.c | 21 +++++++++++++++++++++
>>  drivers/scsi/sr_zpodd.h |  9 +++++++++
>>  3 files changed, 31 insertions(+)
>>  create mode 100644 drivers/scsi/sr_zpodd.c
>>  create mode 100644 drivers/scsi/sr_zpodd.h
>>
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 888f73a..474efe2 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -177,6 +177,7 @@ sd_mod-objs	:= sd.o
>>  sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
>>  
>>  sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
>> +sr_mod-$(CONFIG_SATA_ZPODD) += sr_zpodd.o
>>  ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
>>  		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
>>  			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
>> diff --git a/drivers/scsi/sr_zpodd.c b/drivers/scsi/sr_zpodd.c
>> new file mode 100644
>> index 0000000..0686e8c
>> --- /dev/null
>> +++ b/drivers/scsi/sr_zpodd.c
>> @@ -0,0 +1,21 @@
>> +#include <linux/module.h>
>> +#include <linux/genhd.h>
>> +#include <linux/cdrom.h>
>> +#include "sr.h"
>> +
>> +bool sr_block_events(struct device *dev)
>> +{
>> +	struct scsi_cd *cd = dev_get_drvdata(dev);
>> +	if (cd)
>> +		return disk_try_block_events(cd->disk);
>> +	return false;
>> +}
>> +EXPORT_SYMBOL(sr_block_events);
>> +
>> +void sr_unblock_events(struct device *dev)
>> +{
>> +	struct scsi_cd *cd = dev_get_drvdata(dev);
>> +	if (cd)
>> +		disk_unblock_events(cd->disk);
>> +}
>> +EXPORT_SYMBOL(sr_unblock_events);
>> diff --git a/drivers/scsi/sr_zpodd.h b/drivers/scsi/sr_zpodd.h
>> new file mode 100644
>> index 0000000..49c6a55
>> --- /dev/null
>> +++ b/drivers/scsi/sr_zpodd.h
>> @@ -0,0 +1,9 @@
>> +#ifndef __SR_ZPODD_H__
>> +#define __SR_ZPODD_H__
>> +
>> +#include <linux/device.h>
>> +
>> +extern bool sr_block_events(struct device *dev);
>> +extern void sr_unblock_events(struct device *dev);
>> +
>> +#endif
> 
> 

