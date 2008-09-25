From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Thu, 25 Sep 2008 15:03:47 -0400
Message-ID: <48DBE093.5090804@emulex.com>
References: <1210700704.16304.1.camel@localhost.localdomain> <48DA9163.9070209@cs.wisc.edu> <48DA9240.5090407@cs.wisc.edu> <48DBDB33.3050206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49304 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYIYTEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 15:04:09 -0400
In-Reply-To: <48DBDB33.3050206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@novell.com>


Mike Christie wrote:
> So what I am asking is we can do the setting of starget->can_queue from:
> 
> 1. kernel devinfo table like in this patch.
> 
> 2. udev rule.
> 
> 3. userspace scsi daemon that handles lots of junk scsi-ml in the kernel
> does not want to handle.

Sure. all can work.

My preferences:
- I prefer to set max's before we start to send i/o that checks against 
them, meaning I like the kernel devinfo table better. But, I can't see a 
scenario where any max would likely be exceeded (unless the max is 
really really low) before a user-space thing could set it.

- Queue depth handling - giving the headaches, the closer to the 
hardware the better.  The ramp-down should be in the kernel/driver and 
not userspace. Ramp-up can be in user-space. Note: queue depth should be 
per lun, and thus never touch target can_queue limits.  So queue_depths 
and tgt can_queue shouldn't be discussed together. (Yes, even with jbods 
  where the tgt and lun are the same - there will be a relationship, but 
I still wouldn't marry the two).

-- james
