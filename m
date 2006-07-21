From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC] move scsi parts of dm hw handlers to scsi layer
Date: Fri, 21 Jul 2006 13:41:28 +0200 (CEST)
Message-ID: <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
References: <1153480817.8030.15.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:61407 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161059AbWGULla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 07:41:30 -0400
In-Reply-To: <1153480817.8030.15.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, agk@redhat.com

Am Fr 21.07.2006 13:20 schrieb Mike Christie <michaelc@cs.wisc.edu>:

> Currently dm-multipath has what it calls hw_handlers that contain hw
> details and currently those handlers can be used to failover storage
> works, LSI/Engenio RDAC mode, and EMC Clariion boxes. This code is a
> little strange in dm-multipath and they are doing scsi no good (think
> about problems initializing scsi disks/paths when they are in a
> passive
> path that requires explicit/manual activation and we retry over and
> over
> and over).
> 
Yes, good idea. And it would even solve the problem of getting all this
weird
error messages during booting as now these handlers are independently of
of
the multipathing configuration and we're now able to handle weird path 
configurations natively.

> The patch below begins to push the scsi hw handler code down to the
> scsi
> layer. I only began to covert dm-emc.c and it only hooks in at the
> sense
> decoding in scsi_error.c. I wanted to make sure I was going about the
> module loading and binding correctly. With a new target bus we could
> do
> some driver model stuff instead, but I was not sure if that was
> appropriate for this?
> 
Why don't we use scsi_devinfo for this?
We have to have some sort of device table anyway as these handlers are
far from being generic, so any sense code which triggers action on one
device might be perfectly ok for others.

Easiest way would be to have one BLIST flag for each hardware handler
and merge the respective hardware handler into that target if the
blacklist entry matches.

> Next up would be to get Jens's cmd type tree and work on the message
> passing code.
> 
> And this patch currently does not work since I do not have a Clariion
> box and I do not know what to match for the {vendor, model} tuple. I
> think it was something like DCG or DGC and the model had different
> RAID
> strings depending on how it was setup and could have some other string
> if it did not use RAID. If you have a Clariion or you work for EMC and
> happen to know this info could you pass those strings to me?
> 
IIRC this is

'DGC' 'DISK'
'DGC' 'RAID 10'
'DGC' 'RAID 5'

Hrmph. There is one bit which doesn't quite work out.
While the hardware handler knows how to handle error codes and how to
switch
paths for a specific device, it doesn't know _when_ to switch it.
I don't think it's a clever idea to switch paths whenever you encounter
an
passive path. Seems like you could do a nice ping-pong that way ...

Cheers,

Hannes

