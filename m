From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi: break from queue depth adjusting loops when
 device found
Date: Fri, 4 Jul 2014 19:21:52 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B86659@G9W0745.americas.hpqcorp.net>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
 <20140703171106.GA16788@lst.de> <53B6878C.502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:28568 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaGDTZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 15:25:48 -0400
In-Reply-To: <53B6878C.502@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, 04 July, 2014 5:53 AM
> To: Christoph Hellwig; Stephen M. Cameron
> Cc: james.bottomley@parallels.com; Elliott, Robert (Server Storage);
> stephenmcameron@gmail.com; linux-scsi@vger.kernel.org; Vasu Dev; Mike
> Christie
> Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
> found
> 
> On 07/03/2014 07:11 PM, Christoph Hellwig wrote:
> > On Thu, Jul 03, 2014 at 10:05:57AM -0500, Stephen M. Cameron wrote:
> >> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >>
> >> Don't loop through all the devices even after
> >> finding the one we're looking for
> >
> > The comments in the code seem to indicate that we want to modify
> > the queue depth for all LUNs on a given target.
> >
> > Ccing Mike and Vasu as they wrote this code.
> >
> Indeed, that was the idea.
> This piece of code tries to keep track of the remote port queue
> depth, which isn't represented at all.
> Thing is, each remote target has a target queue depth which can hold
> only so many outstanding SCSI requests. If that is full it'll return
> BUSY for _all_ LUNs served from that port.
> And the very _next_ command after the one which filled the target
> queue will get the BUSY status.
> So we need to decrease the queue depth on _all_ LUNs here to avoid
> starvation of individual devices.
> 
> Hence I guess this is not the correct fix.

Some SCSI target device designs work that way, but others don't. 

In the original SCSI Architecture Model (SAM-1; 1995):
* BUSY meant "the logical unit is busy" 
* TASK SET FULL meant "the logical unit does not have enough 
  resources" 

It didn't say "SCSI target port" or "SCSI target device", so
they were not intended to be affected by other logical units.
That was based on the idealized notion that each I_T_L nexus was 
independent, also assumed by the hierarchical LUN addressing 
scheme and the SCSI Controller Commands (SCC) standard.

With that interpretation, the command identifier/tag (the Q in 
I_T_L_Q nexus) is independent for each I_T_L nexus - two 
logical units behind the same SCSI target port could use the 
same tag value at the same time for different commands.

However, every SCSI transport protocol after parallel SCSI
has chosen to share command tags across all logical units; 
passing the (usually) 8-byte LUN field in every IU/frame is 
not practical.  So, that idealized I_T_L nexus concept has
broken down.  Implementations really have a mix of SCSI target 
device, SCSI target port, and logical unit resources.

When we added the optional status qualifier to SAM-4 (2006), 
we added a SCOPE field indicating if the scope of the BUSY or 
TASK SET FULL is for:
* just the logical unit;
* all logical units in the SCSI target device accessible through 
  the SCSI target port; or
* all logical units in the SCSI target device.

There is no VPD page field defined to report which scope(s) are
implemented or describing the resource limits.  Some designs
are simple, others are complicated.

If TASK SET FULL means a SCSI target port limit has been 
reached, then decrementing the limit on all the logical 
units will over-correct.  If the limit is 256 and there
are 16 LUNs, nominally 16 per LUN, and you send a 257th
command, then the total will drop to 16x15=240, not 256.

mpt3sas assigns separate target numbers for target ports it
discovers, so the SCSI midlayer queue depth logic is more 
correct if those SCSI target devices are implementing a 
SCSI target port scope for BUSY and TASK SET FULL, but 
incorrect if they are implementing a logical unit scope.

[    2.711047] scsi 0:0:0:0: Direct-Access     HP       EO0400JDVFB      HPD1 PQ: 0 ANSI: 6
[    2.711746] scsi 0:0:1:0: Direct-Access     HP       EO0400JDVFB      HPD1 PQ: 0 ANSI: 6
[    2.712423] scsi 0:0:2:0: Direct-Access     HP       EO0400JDVFB      HPD1 PQ: 0 ANSI: 6

hpsa presents multiple LUNs in one target, and a TASK SET FULL 
on one logical unit doesn't mean that you'll get it on the 
others, so the SCSI midlayer queue depth logic is incorrect:
[   10.790885] scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 ANSI: 5
[   10.791095] scsi 2:0:0:1: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 ANSI: 5
[   10.791300] scsi 2:0:0:2: Direct-Access     HP       LOGICAL VOLUME   10.0 PQ: 0 ANSI: 5

The SCSI host template .cmd_per_lun value, which is used
to set the default initial queue depth for each device 
(i.e., each LUN), implies the logical unit scope. 

Perhaps the SCSI midlayer should keep track of both
SCSI target port and logical unit queue depths, parse
the status qualifier if present, and let the host
template advise on the policy to assume if the
status qualifier is not present.

Short of that, I think it's best to assume logical unit
scope, which always the presumption in SCSI, for BUSY
and TASK SET FULL.

There is some code for a scsi_target structure that I 
don't understand and have just been ignoring: target_busy, 
target_blocked, etc.  Does that represent the SCSI target 
port over multiple logical units, or does that relate to 
target-mode where the system is acting as the SCSI target 
and presenting logical units itself?

---
Rob Elliott    HP Server Storage






