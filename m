From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Fri, 07 Dec 2012 14:13:46 +0800
Message-ID: <50C1891A.7040900@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>  <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike>  <21511277.LLinyDpbAK@vostro.rjw.lan>  <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike>  <20121203081321.GA9990@mint-spring.sh.intel.com>  <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com>  <20121203162323.GB19802@htj.dyndns.org> <1354623100.3206.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2LGGNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 01:13:25 -0500
In-Reply-To: <1354623100.3206.34.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 12/04/2012 08:11 PM, James Bottomley wrote:
> On Mon, 2012-12-03 at 08:23 -0800, Tejun Heo wrote:
>> Hello, James.
>>
>> On Mon, Dec 03, 2012 at 08:25:43AM +0000, James Bottomley wrote:
>>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>>> index e65c62e..1756151 100644
>>>> --- a/include/scsi/scsi_device.h
>>>> +++ b/include/scsi/scsi_device.h
>>>> @@ -160,6 +160,7 @@ struct scsi_device {
>>>>  	unsigned can_power_off:1; /* Device supports runtime power off */
>>>>  	unsigned wce_default_on:1;	/* Cache is ON by default */
>>>>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
>>>> +	unsigned event_driven:1; /* No need to poll the device */
>>>>  
>>>>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>>>>  	struct list_head event_list;	/* asserted events */
>>>
>>> Yes, but if we can get away with doing that, it should be in genhd
>>> because it's completely generic.
>>>
>>> I was imagining we'd have to fake the reply to the test unit ready or
>>> some other commands, which is why it would need to be in sr.c
>>>
>>> The check events code is Tejun's baby, if he's OK with it then just do
>>> it in genhd.c
>>
>> The problem here is there's no easy to reach genhd from libata (or the
>> other way around) without going through sr.  I think we're gonna have
>> to have something in sr one way or the other.
> 
> Can't we do that via an event? It's a bit clunky because we need the
> callback in the layer that sees the sdev, which is libata-scsi, we just
> need an analogue of ata_scsi_media_change_notify, but ignoring and
> allowing polling is essentially event driven as well, so it should all
> work.  We'll need a listener in genhd, which might be trickier.

Hi Tejun,

Do you have any comments on James' suggestion? I want to know your
opinion, thanks.

Hi James,

Do you mean we start a thread in genhd that listen to events, so that
some driver can send an event to genhd about if the device should be
polled? I'm thinking where to store such information. If store it in
struct disk_events, then we will need to know which gendisk is for
the device, but how? Maybe by loop scan all gendisk's driverfs_dev?
If store it in struct device, then we do not need to send the event but
just set a flag in sturct device in libata, and let genhd check this
flag when poll. So I don't quite understand this, can you please
elaborate? Thanks.

Thanks,
Aaron

> 
> This may also work as the more generic route for stuff where we can't
> connect the bottom to the top of the stack (which looks like a problem
> we'll begin wrestling with a lot now).
> 
> James
> 
> 

