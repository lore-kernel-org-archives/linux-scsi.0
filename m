From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] multipath redesign
Date: Thu, 12 Jan 2017 09:27:40 +0100
Message-ID: <19415684-1ec7-1926-b420-3b53ea247e1b@suse.de>
References: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
 <20170111222339.GC19051@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbdALI1m (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 03:27:42 -0500
In-Reply-To: <20170111222339.GC19051@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 01/11/2017 11:23 PM, Mike Snitzer wrote:
> On Wed, Jan 11 2017 at  4:44am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> Hi all,
>>
>> I'd like to attend LSF/MM this year, and would like to discuss a
>> redesign of the multipath handling.
>>
>> With recent kernels we've got quite some functionality required for
>> multipathing already implemented, making some design decisions of the
>> original multipath-tools implementation quite pointless.
>>
>> I'm working on a proof-of-concept implementation which just uses a
>> simple configfs interface and doesn't require a daemon altogether.
>>
>> At LSF/MM I'd like to discuss how to move forward here, and whether we'd
>> like to stay with the current device-mapper integration or move away
>> from that towards a stand-alone implementation.
>
> I'd really like open exchange of the problems you're having with the
> current multipath-tools and DM multipath _before LSF_.  Last LSF only
> scratched the surface on people having disdain for the complexity that is
> the multipath-tools userspace.  But considering how much of the
> multipath-tools you've written I find it fairly comical that you're the
> person advocating switching away from it.
>
Yeah, I know.

But I've stared long and hard at the code, and found some issues really 
hard to overcome. Even more so as most things it does are really pointless.

multipathd _insists_ on redoing the _entire_ device layout for basically 
any operation (except for path checking).
As the data structures allow only for a single setup it uses a lock per 
multipath device to protect against concurrent changes.
When lots of uevents are to be processed this lock is heavily contended, 
leading to a slow-down of uevent processing.
(cf the patchseries from Tang Junhui and my earlier pathset for
lock pushdown)

I've tried to move that lock down even further with distinct locks for 
device paths and multipath devices, but ultimately failed as it would 
amount to essentially a rewrite of the core engine.

> But if less userspace involvement is needed then fix userspace.  Fail to
> see how configfs is any different than the established DM ioctl interface.
>
> As I just said in another email DM multipath could benefit from
> factoring out the SCSI-specific bits so that they are nicely optimized
> away if using new transports (e.g. NVMEoF).
>
> Could be lessons can be learned from your approach but I'd prefer we
> provably exhaust the utility of the current DM multipath kernel
> implementation.  DM multipath is one of the most actively maintained and
> updated DM targets (aside from thinp and cache).  As you know DM
> multipath has grown blk-mq support which yielded serious performance
> improvement.  You also noted (in an earlier email) that I reintroduced
> bio-based DM multipath.  On a data path level we have all possible block
> core interfaces plumbed.  And yes, they all involve cloning due to the
> underlying Device Mapper core.  Open to any ideas on optimization.  If
> DM is imposing some inherent performance limitation then please report
> it accordingly.
>
Ah. And I thought you disliked request-based multipathing ...

It's not _actually_ the DM interface which I'm objecting to, it's more 
the user-space implementation.
The daemon is build around some design decisions which are simply not 
applicable anymore:
- we now _do_ have reliable device identifications, so the the 'path_id' 
functionality is pointless.
- The 'alua' device handler also provides you with reliable priority 
information, so it should be possible to do away with the 'prio' 
setting, too.
- And for (most) SCSI devices the 'state' setting provides a reliable 
indicator if the device is useable.

Hence I've implemented a notifier chain (hooked onto 'struct gendisk') 
which provides events for path up/path down etc.
With that it's possible to automatically fail and reinstate paths.
However, what's missing is an automatic pathgroup switch once all paths 
in a group are down.
In the current implementation the device-mapper target doesn't have any 
inkling about path priorities; it just sees path groups as such.
As it stands should reasonably trivial to switch to the next available 
pathgroup, but fallback will become ... interesting.
So we would need to update the interface here to allow for path group 
priorities and also for transmitting the fallback information.

Nothing insurmountable, agreed.
But once we do this most of the current functionality of the 
multipath-tools daemon will become obsolete.

Plus I wasn't quite sure about the direction device-mapper itself will 
be going, so I decided to implement a stand-alone version as a testbed.
I'm not trying to push that at all costs; I'm perfectly happy with 
updating device-mapper.
As long as no-one insists we're having to use the bio-based interface ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
