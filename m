From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM TOPIC][LSF/MM ATTEND] multipath redesign
Date: Fri, 13 Jan 2017 16:56:18 +0100
Message-ID: <def3ef1e-1a81-aab1-7fa8-ade1ebeaa0d5@suse.de>
References: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
 <20170111222339.GC19051@redhat.com>
 <19415684-1ec7-1926-b420-3b53ea247e1b@suse.de>
 <20170112172959.GT2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53663 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdAMP40 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 10:56:26 -0500
In-Reply-To: <20170112172959.GT2732@octiron.msp.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On 01/12/2017 06:29 PM, Benjamin Marzinski wrote:
> On Thu, Jan 12, 2017 at 09:27:40AM +0100, Hannes Reinecke wrote:
>> On 01/11/2017 11:23 PM, Mike Snitzer wrote:
>>> On Wed, Jan 11 2017 at  4:44am -0500,
>>> Hannes Reinecke <hare@suse.de> wrote:
>>>
>>>> Hi all,
>>>>
>>>> I'd like to attend LSF/MM this year, and would like to discuss a
>>>> redesign of the multipath handling.
>>>>
>>>> With recent kernels we've got quite some functionality required for
>>>> multipathing already implemented, making some design decisions of the
>>>> original multipath-tools implementation quite pointless.
>>>>
>>>> I'm working on a proof-of-concept implementation which just uses a
>>>> simple configfs interface and doesn't require a daemon altogether.
>>>>
>>>> At LSF/MM I'd like to discuss how to move forward here, and whether we'd
>>>> like to stay with the current device-mapper integration or move away
>>> >from that towards a stand-alone implementation.
>>>
>>> I'd really like open exchange of the problems you're having with the
>>> current multipath-tools and DM multipath _before LSF_.  Last LSF only
>>> scratched the surface on people having disdain for the complexity that is
>>> the multipath-tools userspace.  But considering how much of the
>>> multipath-tools you've written I find it fairly comical that you're the
>>> person advocating switching away from it.
>>>
>> Yeah, I know.
>>
>> But I've stared long and hard at the code, and found some issues really hard
>> to overcome. Even more so as most things it does are really pointless.
>>
>> multipathd _insists_ on redoing the _entire_ device layout for basically any
>> operation (except for path checking).
>> As the data structures allow only for a single setup it uses a lock per
>> multipath device to protect against concurrent changes.
>> When lots of uevents are to be processed this lock is heavily contended,
>> leading to a slow-down of uevent processing.
>> (cf the patchseries from Tang Junhui and my earlier pathset for
>> lock pushdown)
>>
>> I've tried to move that lock down even further with distinct locks for
>> device paths and multipath devices, but ultimately failed as it would amount
>> to essentially a rewrite of the core engine.
> 
> The multipath user-space tools locking IS horrible and touches
> everything.  I could never see a way around it that didn't involve
> a ground-up redesign.
>  
:-)

>>> But if less userspace involvement is needed then fix userspace.  Fail to
>>> see how configfs is any different than the established DM ioctl interface.
>>>
>>> As I just said in another email DM multipath could benefit from
>>> factoring out the SCSI-specific bits so that they are nicely optimized
>>> away if using new transports (e.g. NVMEoF).
>>>
>>> Could be lessons can be learned from your approach but I'd prefer we
>>> provably exhaust the utility of the current DM multipath kernel
>>> implementation.  DM multipath is one of the most actively maintained and
>>> updated DM targets (aside from thinp and cache).  As you know DM
>>> multipath has grown blk-mq support which yielded serious performance
>>> improvement.  You also noted (in an earlier email) that I reintroduced
>>> bio-based DM multipath.  On a data path level we have all possible block
>>> core interfaces plumbed.  And yes, they all involve cloning due to the
>>> underlying Device Mapper core.  Open to any ideas on optimization.  If
>>> DM is imposing some inherent performance limitation then please report
>>> it accordingly.
>>>
>> Ah. And I thought you disliked request-based multipathing ...
>>
>> It's not _actually_ the DM interface which I'm objecting to, it's more the
>> user-space implementation.
>> The daemon is build around some design decisions which are simply not
>> applicable anymore:
>> - we now _do_ have reliable device identifications, so the the 'path_id'
>> functionality is pointless.
> 
> This could be largely fixed in the existing code. The route that the
> latest patch from Tang Junhui are going still grabs the wwid if we got
> it from the uevent, but it isn't necesary, as long was we're careful.
> Currently rbd devices don't get their wwid from the uevent but all other
> devices do. It would probably be possible to write an rbd device udev
> rule to set a variable so that they can work through udev environment
> variables too.
> 
But this is still only working around the problem.
We only should need to touch the device-mapper tables when setting up
devices or during reconfiguration.

>> - The 'alua' device handler also provides you with reliable priority
>> information, so it should be possible to do away with the 'prio' setting,
>> too.
> 
> But this isn't true for all devices. Also, Like I mentioned last year
> when this got brought up, no matter how we group the paths, there end up
> being users that have good reasons why they want them grouped
> differently in their case.  The path priority/grouping seems like one
> place where evidence has shown that we should give users the tools to
> make policy decisions, instead of making them ourselves.
> 
>> - And for (most) SCSI devices the 'state' setting provides a reliable
>> indicator if the device is useable.
> 
> This is also not true for all devices.
> 
So? The 'state' attribute reflects the internal SCSI device state.
If _that_ doesn't work reliably you end up with I/O errors.
Which eventually will end up with the 'state' attribute being
synchronized with the actual device state (or being set to 'offline').

> So, are you planning on creating a multipath implementation that only
> handles some devices? Obviously, the current userspace tools are still
> around to handle setups that this wouldn't.
> 
No, certainly not.
ATM my implementation is merely a testbed, as new
features/functionalities can be more easily implemented there.
I don't see any issues with porting this to device-mapper as such.

> While I've daydreamed of rewriting the multipath tools multiple times,
> and having nothing aginst you doing it in concept, I would be happier
> knowing that it won't simply mean that there are two sets of tools, that
> both need to be supported to deal with all customer configurations.
> 
Sure. I feel the pain of supporting multipath-tools all too strongly.
Having two tools for the same thing is always a pain, and I would like
to avoid this if at all possible.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
