From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/18] libosd: OSDv1 preliminary implementation
Date: Wed, 05 Nov 2008 15:12:15 +0200
Message-ID: <49119BAF.6040603@panasas.com>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:51391 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYKENMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 08:12:19 -0500
In-Reply-To: <20081104180347.GA9818@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>

Sam Ravnborg wrote:

> On Tue, Nov 04, 2008 at 06:44:29PM +0200, Boaz Harrosh wrote:
>> Implementation of the most basic OSD functionality and
>> infrastructure. Mainly Format, Create/Remove Partition,
>> Create/Remove Object, and read/write.
>>
>> - Add Makefile and Kbuild to compile libosd.ko
>> - osd_initiator.c Implementation file for osd_initiator.h
>>   and osd_sec.h APIs
>> - osd_debug.h - Some kprintf macro definitions
> 
> A few comments below.
> 
> 	Sam
> 

Thanks Sam for looking

> 
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  drivers/scsi/osd/Kbuild          |   26 +++
>>  drivers/scsi/osd/Makefile        |   37 +++
>>  drivers/scsi/osd/osd_debug.h     |   27 +++
>>  drivers/scsi/osd/osd_initiator.c |  450 ++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 540 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/scsi/osd/Kbuild
>>  create mode 100755 drivers/scsi/osd/Makefile
>>  create mode 100644 drivers/scsi/osd/osd_debug.h
>>  create mode 100644 drivers/scsi/osd/osd_initiator.c
>>
>> diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
>> new file mode 100644
>> index 0000000..b4678e0
>> --- /dev/null
>> +++ b/drivers/scsi/osd/Kbuild
>> @@ -0,0 +1,26 @@
>> +#
>> +# Kbuild for the OSD modules
>> +#
>> +# Copyright (C) 2008 Panasas Inc.  All rights reserved.
>> +#
>> +# Authors:
>> +#   Boaz Harrosh <bharrosh@panasas.com>
>> +#   Benny Halevy <bhalevy@panasas.com>
>> +#
>> +# This program is free software; you can redistribute it and/or modify
>> +# it under the terms of the GNU General Public License version 2
>> +#
>> +
>> +ifneq ($(OSD_INC),)
>> +# we are built out-of-tree Kconfigure everything as on
>> +
>> +CONFIG_SCSI_OSD_INITIATOR=m
>> +EXTRA_CFLAGS += -DCONFIG_SCSI_OSD_INITIATOR -DCONFIG_SCSI_OSD_INITIATOR_MODULE
>> +
>> +EXTRA_CFLAGS += -I$(OSD_INC)
>> +# EXTRA_CFLAGS += -DCONFIG_SCSI_OSD_DEBUG
>> +
>> +endif
>> +
>> +libosd-objs := osd_initiator.o
>> +obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
> 
> When you submit for inclusion please clean this up.
> 1) use ccflags-y as replacement for EXTRA_CFLAGS
> 2) use libosd-y as replacement for libosd-objs
> 

This is a most valuable information thanks. I have copy
pasted these stuff, while learning. I guess from the wrong
example. Thanks it looks much more logical that way.

>> +
>> +#ifdef CONFIG_SCSI_OSD_INITIATOR_MODULE
>> +MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
>> +MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
>> +MODULE_LICENSE("GPL");
>> +#endif
> 
> no ifdef around here.
> 

Grate, thanks. Again the wrong copy-paste.

>> +void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
>> +{
>> +	memset(osdd, 0, sizeof(*osdd));
>> +	osdd->scsi_dev = scsi_dev;
>> +	osdd->def_timeout = BLK_DEFAULT_SG_TIMEOUT;
>> +	/* TODO: Allocate pools for osd_request attributes ... */
>> +}
>> +EXPORT_SYMBOL(osd_dev_init);
> kernel-doc comments for all exported funtions / variables.
> 

I have some kernel-doc comments of exported functions in the Header
file. I have not yet finished all of them. (Laziness on my part).

Are kernel-doc comments in headers a big NO-NO. I like it this way,
so when I have to learn a new Library all the information
I need to know is in the header. Also the header is a much better place
when you do programing by shopping, that is you don't know what you need
and you look for what's available.

Thanks
Boaz
