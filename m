From: Hannes Reinecke <hare@novell.com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Fri, 26 Sep 2008 09:46:47 +0200
Message-ID: <48DC9367.6050402@novell.com>
References: <1210700704.16304.1.camel@localhost.localdomain> <48DA9163.9070209@cs.wisc.edu> <48DA9746.9090003@emulex.com> <48DBD53E.4040604@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYIZHqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 03:46:49 -0400
In-Reply-To: <48DBD53E.4040604@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> James Smart wrote:
>> This sounds reasonable, but I wouldn't eliminate this can_queue limit. 
> 
> I was not going to elimitate it. It is all muddled in the one mail, so 
> it is confusing.
> 
> I was just going to set it based on target vendor info table in 
> userspace from a scsi daemon that was going to handle this issue and 
> handle ramp ups due to QUEUE_FULL ramp downs and other scsi issues like 
> the handling of sense that indicates disks changes size or report lun 
> data changes.
> 
> Hannes had mentioned he was making some event infrastructure to handle 
> the sense, and I thought I could extend his userspce code to handle the 
> ramp up issue and handle setting this value. So for just the 
> starget->can_queue issue, the daemon would listen for target hotplug 
> events, then it would do sg io to device on it and get the vendor info 
> and look up the target in a table and then if found would write to a 
> starget->can_queue sysfs file to set the value.
> 
Currently I've implemented another scsi netlink event, which just
transports the sense code to the outside world. Next step will be
a daemon which listens to the SCSI netlink events and reacts upon
that; will work largely along the lines udev does.
So we'll be getting a sysfs patch for the device, the message class,
and some payload for the message.
Configuration will quite simple, probably just something like:

[message class]
	[payload regex]	[command]
	[payload regex] [command]

etc.
I'll probably implementing some pre-defined commands like rescan,
but will also add a simple callout for executing commands directly.

> The same daemon could also handle the sense handling and handle other 
> errors like when to ramp up from when we ramp down due to QUEUE_FULLs. 
> So it is basically a scsi-ml/lib in userpsace that could be easily 
> packaged for distros to carry.
Quite easily. Actually, that was the point of that program.

Cheers,

Hannes
