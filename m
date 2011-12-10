From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
Date: Sat, 10 Dec 2011 17:37:58 +0100
Message-ID: <4EE38AE6.1060508@redhat.com>
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>  <1323106159-6562-2-git-send-email-pbonzini@redhat.com>  <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>  <4EDF34CB.2080100@redhat.com> <1323268533.3021.37.camel@dabdike>  <4EE0B712.7000006@redhat.com> <1323461170.13189.17.camel@dabdike.cust.hotspot.t-mobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62621 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1LJQiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Dec 2011 11:38:08 -0500
In-Reply-To: <1323461170.13189.17.camel@dabdike.cust.hotspot.t-mobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

On 12/09/2011 09:06 PM, James Bottomley wrote:
> On Thu, 2011-12-08 at 14:09 +0100, Paolo Bonzini wrote:
>>> Well, no it's not, the transports are the fastest evolving piece of the
>>> SCSI spec.
>>
>> No, I mean when something is added to the generic definition of SCSI
>> transport (SAM, more or less), not the individual transports.  When the
>> virtio-scsi transport has to change, you still have to update
>> spec+host+guest, but that's relatively rare.
>
> This doesn't make sense:  You talk about wanting TMF access which *is*
> transport defined.

TMF access is transport defined.  The definition of TMFs is part of SAM 
and not fast moving.  The virtio-scsi spec tells you how to access TMFs 
on virtio-scsi; it doesn't tell you what the TMFs do, because it just 
refers you to SAM.

Device commands can be treated opaquely when doing passthrough, so their 
rate of change does not matter.  And you can always leave them out in 
the emulated target, too.  If some new command turns out to be 
interesting enough to implement it in the emulated target, you do it and 
guests that can use the feature will start using it.

>> So, for virtio-blk, SG_IO is good for persistent reservations, burning
>> CDs, and basically nothing else.  Neither of these can really be done in
>> the host by interpreting, so for virtio-blk it makes sense to simply
>> pass through.
>
> It is a pass through for user space ... I don't get what your point is.
> All of the internal commands for setup are handled in the host.

In the host or in the guest kernel?  I'm not sure I understand your 
point either. :)

> All the guest is doing is attaching to a formed block queue. I think,
> as I've said several times before, all of this indicates virtio-blk
> doesn't do discovery of the host block queue properly, but that's
> fixable.

Well, the only fix is to disable SG_IO.  For example, suppose the host 
disk is 4k-lbs and you present it to the guest as 512b-logical, 
4096-byte physical.  That's a sensible thing to do if you want the guest 
boot from that disk.

Now, SG_IO will see 4k-lbs, and you cannot change it.  To avoid showing 
mismatched geometry to the guest, _the only fix is to disable SG_IO_. 
If you do so, you prevent the guest from doing possibly useful things 
with it (e.g. PR).  If you don't, you have to cross your fingers and 
hope the guest won't do possibly harmful things with it.

Of course, virtio-scsi is not a silver bullet.  If you want to modify 
the block limits you won't be able to pass the LUN through anymore, and 
you will have to use an emulated target; that's obvious.  However, in 
_no_ case will there be a mismatch between the queue parameters seen by 
the kernel and what you get in SG_IO.

>>> You worry me enormously talking about TMFs because they're transport
>>> specific.
>>
>> True, but virtio-blk for example cannot even retry a command at all.
>
> Why would it need to.  You seem to understand that architecturally the
> queue is sliced, but what you don't seem to appreciate is that error
> handling is done below this ... i.e. in the host in your model, so
> virtio-blk properly implemented *shouldn't* be doing retries.

There may be no error handling in the host at all, for example if the 
host is using as a simple userspace iSCSI initiator that just sends 
commands over TCP.  It's also possible that non-Linux OSes cannot be 
told "no error handling".  Windows expects the driver to be able to 
reset LUNs/buses/hosts, for example.

> You seem to be stating error handling in a way that necessarily
> violates the layering of block and then declaring this to be a
> problem.  It isn't; in virtio-block, errors are handled in the host
> and passed up to the guest when resolved.

I agree, but in practice it doesn't always work like that, depending on 
your storage backends.  Again, the choice with virtio-blk is either 
"keep it broken" or "don't do it".

> Why do you worry about WCE?  That's a SCSI feature and it's handled in
> the host.

No, the guest must also be able to toggle it.  But that's irrelevant. 
The point is: you need discovery of geometry parameters, of topology 
parameters, of cache parameters.  You need reads, writes, flushes, 
discards.  Why reinvent the wheel every time, and not encapsulate those 
within SPC/SBC commands?  Consider that:

1) you also need to support generic SCSI commands for userspace, and 
virtio-blk's solution for that sucks;

2) you would anyway need the SCSI encapsulation code for the sake of 
Windows drivers (only it would run in the Windows guests rather than in 
the host).

At some point you start wondering whether you're heading straight to a 
local optimum, and why every other virtualization platform is doing 
something else.  virtio-blk's main feature is its simplicity; it's quite 
possible that we're past the break-even point for virtio-blk's simplicity.

> The point here is that virtio-blk operates at the
> block level, so you should too [...] you don't ask to pierce the
> abstraction to try to see SCSI parameters.

Exactly!  That's why I say SG_IO on virtio-blk is a very bad idea, and 
if clients need SCSI (and they do) they should be presented a real SCSI 
device, which virtio-scsi provides.

>> Regarding updates to the targets, you have much more control on the host
>> than the guest.  Updating the host is trivial compared to updating the
>> guest.
>
> So is this a turf war?  virto-blk isn't evolving fast enough (and since
> you say lagging behind and DISCARD was a 2008 feature, that seems
> reasonable) so you want to invent and additional backend that can move
> faster?

No turf war at all, simply different choices favoring flexibility and 
extensibility over simplicity.  (And even that is not entirely true: the 
actual virtio drivers are simpler for virtio-scsi, though of course the 
whole stack is more complex).

virtio-blk lags behind by design, because it tries to follow the Linux 
block layer's protocol.  To add a new feature to the protocol, in 
practice it has to be already in the block layer, even if there is a 
useful addition that non-Linux guests could use.  Then you have to come 
to an agreement on spec updates, implement it in host, and get the guest 
driver updated.

With virtio-scsi, you sidestep the problems completely, because all you 
need to do in the host is provide a SCSI target with a decent command 
set.  The spec heavily relies on SAM and refers you to it and the other 
SCSI specifications.  New features can be added even before Linux adopts 
a new feature, as soon as SPC or SBC includes them.  You do not need 
separate work on a separate spec, and you do not risk getting that part 
wrong.  And once Linux non-virt devices do gain support for the new 
feature, virt devices also gain it.  Sometimes for free, for example if 
you had already done the host implementation for Windows guests.

>>> Incidentally, REQ_DISCARD was added in 2008.  In that time close to
>>> 50 new commands have been added to SCSI, so the block protocol is
>>> pretty slow moving.
>>
>> That also means that virtio-blk cannot give guests access to the full
>> range of features that might want to use.  Not all OSes are Linux, not
>> all OSes limit themselves to the features of the Linux block protocol.
>
> So you're trying to solve the non-linux guest problem?  My observation
> from Windows has been that windows device queues mostly behave
> reasonably similarly to Linux ... that's not exactly, but similarly
> enough that we can translate the requests.

That's not the case, actually.  I don't know how Windows device queues 
work, but Windows storage drivers can only hook themselves at the SCSI 
layer.  A Windows storage driver cannot distinguish a read that came 
from the disk driver, from a READ that came from userspace via 
passthrough (not unlike a Linux driver for a SCSI host).

For this reason, Windows virtio-blk devices do not have the equivalent 
of SG_IO.  If you send a READ command via SCSI passthrough, it becomes a 
regular read.  If you send an INQUIRY, you get artificial data that the 
Windows virtio-blk device makes up.

[snip]

> OK, so I think the problem boils down to two components:
>
>       1. virtio-blk isn't developing fast enough.  This looks to be a
>          fairly easily fixable problem

Agreed, the immediate shortcomings are fixable, though the slowness is 
inherent in virtio-blk.  It can even be considered a feature, because it 
is a consequence of virtio-blk's simplicity.

>       2. Discover in virtio-blk isn't done properly.  Again, this looks
>          to be easily fixable.

No, this is not a problem.  virtio-blk does discovery very well.  The 
problems are all with the SG_IO interface:

1. When you create a virtio-blk device on say /dev/sdb, you have more 
flexibility than just passing /dev/sdb through to the guest.  But if you 
use this flexibility, you have no choice but to disable SG_IO altogether 
(or leave it enabled, and hope the guest doesn't corrupt its own data 
inadvertently).

2. SG_IO is limited to Linux guests, so that non-Linux guests are 
limited in practice to the feature set of the Linux block layer.

3. Even on Linux, SG_IO is not reliably a part of the userspace ABI for 
virtio disks.  That's because it may work or not depending on how 
storage has been configured.

4. SG_IO on virtio-blk does not cover non-block SCSI devices.

> Once you fix the above, most of what you're asking for, which is mainly
> SCSI encapsulation for discovery and error handling in the guest for no
> reason I can discern, becomes irrelevant.

SCSI encapsulation is not an end by itself.  It just lets you reuse work 
on an existing spec rather than making up one.

Paolo
