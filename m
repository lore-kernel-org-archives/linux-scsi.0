From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 24 Sep 2008 14:13:39 -0500
Message-ID: <48DA9163.9070209@cs.wisc.edu>
References: <1210700704.16304.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32776 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYIXTUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 15:20:11 -0400
In-Reply-To: <1210700704.16304.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@novell.com>

James Smart wrote:
> This patch, discussed in the initial thread on target can_queue limits
> (see  http://marc.info/?l=linux-scsi&m=120944296225094&w=2 )
> allows the target can_queue limit to be obtained from the device list based on
> Inquiry data obtained during scan.
> 
> I have pinged several of the array vendors to supply target-port level values
> for their arrays. Hopefully, we will see them populate the device list with some
> real values shortly.
> 
> This patch was cut against scsi-misc-2.6, and depends on Mike Christies patches
> contained in the original thread.
> 
> -- james s
> 
> PS: This sure desires the promoting of the starget in sysfs, with an attribute
>     for the can_queue value.
> 

I was thinking that for the QUEUE_FULL ramp back up problem, I would do 
a userspace daemon that after some algorithm decided when it was time, 
we could start increasing the queue depth.

And then I was thinking that because it needed to know when devices were 
getting QUEUE_FULLs so it could figure out when to ramp back up, it 
could be based off of a userspace daemon Hannes was talking about that 
would pass scsi info/errors to userspace so it could be handled there 
(this was originally to handle the sense data that indicated that the 
lun data changed and so we were going to kick off a scan and delete old 
deices from userspace).

Then I was thinking that I could extend the daemon to handle the problem 
that this patch was handling too. The daemon would listen for starget or 
port kobject addition events. Then it would do a inquiry to get the 
target info and match it with some table, then it could write to a 
straget->can_queue sysfs file to set the can_queue value.

What do you think? Would userspace be a ok place to put all this. 
Hannes, had you started on any of the userspace or kernel infrastructure 
for passing sense to userspace that I could work off of?
