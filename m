From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
Date: Wed, 07 Dec 2011 08:35:33 -0600
Message-ID: <1323268533.3021.37.camel@dabdike>
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>
	 <1323106159-6562-2-git-send-email-pbonzini@redhat.com>
	 <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>
	 <4EDF34CB.2080100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EDF34CB.2080100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-12-07 at 10:41 +0100, Paolo Bonzini wrote:
> On 12/06/2011 07:09 PM, James Bottomley wrote:
> > On Mon, 2011-12-05 at 18:29 +0100, Paolo Bonzini wrote:
> >> The virtio-scsi HBA is the basis of an alternative storage stack
> >> for QEMU-based virtual machines (including KVM).
> >
> > Could you clarify what the problem with virtio-blk is?
> 
> In a nutshell, if virtio-blk had no problems, then you could also throw 
> away iSCSI and extend NBD instead. :)

Um, I wouldn't make that as an argument.  For a linux only transport,
nbd is far better than iSCSI mainly because it's a lot simpler and
easier and doesn't have a tied encapsulation ... it is chosen in a lot
of implementations for that reason.

> The main problem is that *every* new feature requires updating three or 
> more places: the spec, the host (QEMU), and the guest drivers (at least 
> two: Linux and Windows).  Exposing the new feature also requires 
> updating all the hosts, but also all the guests.

Define "new feature"; you mean the various request types for flush and
discard?

> With virtio-scsi, the host device provides nothing but a SCSI transport. 
>   You still have to update everything (spec+host+guest) when something 
> is added to the SCSI transport, but that's a pretty rare event.

Well, no it's not, the transports are the fastest evolving piece of the
SCSI spec.  What I think you mean to say here is that we take care to
preserve compatibility with older transports while we add the newer
features, so you're not forced to adopt them?

>   In the 
> most common case, there is a feature that the guest already knows about, 
> but that QEMU does not implement (for example a particular mode page 
> bit).  Once the host is updated to expose the feature, the guest picks 
> it up automatically.

That's in the encapsulation, surely; these are used to set up the queue,
so only the queue runner (i.e. the host) needs to know.  If the guest
really wants the information, it encapsulates the request in SG_IO which
has been a stable API for donkey's years.

> Say I want to let guests toggle the write cache.  With virtio-blk, this 
> is not part of the spec so first I would have to add a new feature bit 
> and a field in the configuration space of the device.  I would need to 
> the host (of course), but I would also have to teach guest drivers about 
> the new feature and field.  I cannot just send a MODE SELECT command via 
> SG_IO, because the block device might be backed by a file.

I don't get this.  If you have a file backed SCSI device, you have to
interpret the MODE_SELECT command on the transport.  How is that any
different from unwrapping the SG_IO picking out the MODE_SELECT and
interpreting it?

> With virtio-scsi, the guest will just go to the mode pages and flip the 
> WCE bit.  I don't need to update the virtio-scsi spec, because the spec 
> only defines the transport.  I don't need to update the guest driver, 
> because it likewise only defines the transport and sd.c already knows 
> how to do MODE SENSE/MODE SELECT.

sd might, but I don't see how the back end works for a file without your
doing interpretation.

>   I do need to teach the QEMU target of 
> course, but that will always be smaller than the sum of 
> host+Linux+Windows changes required for virtio-blk (if only because the 
> Windows driver already contains a sort of SCSI target).
> 
> Regarding passthrough, non-block devices and task management functions 
> cannot be passed via virtio-blk.  Lack of TMFs make virtio-blk's error 
> handling less than optimal in the guest.

This would be presumably because most of the errors (i.e. the transport
ones) are handled in the host.  All the guest has to do is pass on the
error codes the host gives it.

You worry me enormously talking about TMFs because they're transport
specific.  SAM defines the generalities but the transports define the
exact implementations.  If you expose them, your device will behave
slightly differently depending on what the physical attachment is.  This
is really a recipe for code explosion because to special case them
you'll need to know what the host transport actually is and that's a
huge amount of knowledge to pass through.  You'd really be better off
using standardised pass throughs, like FCoE (or even iSCSI) if you want
this.

> >> Compared to virtio-blk it is more scalable, because it supports
> >> many LUNs on a single PCI slot),
> >
> > This is just multiplexing, surely, which should be easily fixable in
> > virtio-blk?
> 
> Yes, you can do that.   I did play with a "virtio-over-virtio" device, 
> but it was actually more complex than virtio-scsi and would not fix the 
> other problems.
> 
> >> more powerful (it more easily supports passthrough of host devices
> >> to the guest)
> >
> > I assume this means exclusive passthrough?
> 
> It doesn't really matter if it is exclusive or not (it can be 
> non-exclusive with NPIV or iSCSI in the host; otherwise it pretty much 
> has to be exclusive, because persistent reservations do not work).  The 
> important point is that it's at the LUN level rather than the host level.

virtio-blk can pass through at the LUN level surely: every LUN (in fact
every separate SCSI device) has a separate queue.

> > In which case, why doesn't passing the host block queue through to
> > the guest just work? That means the host is doing all the SCSI back
> > end stuff and you've just got a lightweight queue pass through.
> 
> If you want to do passthrough, virtio-scsi is exactly this, a 
> lightweight queue.
> 
> There are other possible uses, where the target is on the host.  QEMU 
> itself can act as the target, or you can use LIO with FILEIO or IBLOCK 
> backends.

If you use an iSCSI back end, why not an iSCSI initiator.  They may be
messy but at least the interaction is defined and expected rather than
encapsulated like you'd be doing with virtio-scsi.

> >> and more easily extensible (new SCSI features implemented by QEMU
> >> should not require updating the driver in the guest).
> >
> > I don't really understand this comment at all:  The block protocol is
> > far simpler than SCSI, but includes SG_IO, which can encapsulate all
> > of the SCSI features ...
> 
> The problem is that SG_IO is bolted on.  It doesn't work if the guest's 
> block device is backed by a file, and in general the guest shouldn't 
> care about that. 

Well how does virtio-scsi cope when file backed?  It's the same problem:
you get a non READ/WRITE command and you have to interpret it according
to some set of rules.  That's the same problem whether the command comes
via virtio-scsi or via SG_IO on virtio-blk.  The real difference is that
with virtio-blk most of the initial start up (which is where all the
weird and wonderful discover commands come from) is in the host.

>  The command might be passed down to a real disk, 
> interpreted by an iSCSI target, or emulated by QEMU.  There's no reason 
> why a guest should see any difference and indeed with virtio-scsi it 
> does not (besides the obvious differences in INQUIRY data).
> 
> And even if it works, it is neither the main I/O mechanism nor the main 
> configuration mechanism.  Regarding configuration, see the above example 
> of toggling the write cache.
> 
> Regarding I/O, an example would be adding "discard" support.  With 
> virtio-scsi, you just make sure that the emulated target supports WRITE 
> SAME w/UNMAP.  With virtio-blk it's again spec+host+guest updates. 
> Bypassing this with SG_IO would mean copying a lot of code from sd.c and 
> not working with files (cutting out both sparse and non-raw files, which 
> are the most common kind of virt thin-provisioning).

so I agree, supporting REQ_DISCARD are host updates because they're an
expansion of the block protocol.  However, they're rare, and, as you
said, you have to update the emulated targets anyway.  Incidentally,
REQ_DISCARD was added in 2008.  In that time close to 50 new commands
have been added to SCSI, so the block protocol is pretty slow moving.

> Not to mention that virtio-blk does I/O in units of 512 bytes.  It 
> supports passing an arbitrary logical block size in the configuration 
> space, but even then there's no guarantee that SG_IO will use the same 
> size.  To use SG_IO, you have to fetch the logical block size with READ 
> CAPACITY.

So here what I think you're telling me is that virtio-blk doesn't have a
correct discovery protocol?  That's easily fixable, surely (and not via
SG_IO ... you need discovery of the host queue parameters, so an
extension to block extracting block parameters).

> Also, using SG_IO for I/O will bypass the host cache and might leave the 
> host in a pretty confused state, so you could not reliably do extended 
> copy using SG_IO, for example.  Spec+host+driver once more.  (And 
> modifying the spec would be a spectacular waste of time because the 
> outcome would be simply a dumbed down version of SBC, and quite hard to 
> get right the first time).
> 
> SG_IO is also very much tied to Linux guests, both in the host and in 
> the guest.  For example, the spec includes an "errors" field that is not 
> defined in the spec.  Reading the virtio-blk code shows that it is 
> really a (status, msg_status, host_status, driver_status) combo.  In the 
> guest, not all OSes tell the driver if the I/O request came from a 
> "regular" command or from SCSI pass-through.  In Windows, all disks are 
> like Linux /dev/sdX, so Windows drivers cannot send SG_IO requests to 
> the host.
> 
> All this makes SG_IO a workaround, but not a solution.  Which 
> virtio-scsi is.

I don't think I understand any of this.  Most of the operation of the
device goes via native block queue (REQ_*) commands ... that's how we
run all block queues anyway.  Applications use SG_IO for various well
co-ordinated (or not, admittedly, in the case of udev) actions ... if
that's so fragile, desktops would have fallen over long ago.

> > I'm not familiar necessarily with the problems of QEMU devices, but
> > surely it can unwrap the SG_IO transport generically rather than
> > having to emulate on a per feature basis?
> 
> QEMU does interpret virtio-blk's SG_IO just by passing down the ioctl. 
> With the virtio-scsi backend you can choose between doing so or 
> emulating everything.

So why is that choice not available to virto-blk?  surely it could
interpret after unwrapping the SG_IO encapsulation.

Reading back all of this, I think there's some basic misunderstanding
somewhere, so let me see if I can make the discussion more abstract.

The way we run a storage device today (be it scsi or something else) is
via a block queue.  The only interaction a user gets is via that queue.
Therefore, in Linux, slicing the interaction at the queue and
transporting all the queue commands to some back end produces exactly
what we have today ... now correctly implemented, virtio-blk should do
that (and if there are problems in the current implementation, I'd
rather see them fixed), so it should have full equivalency to what a
native linux userspace sees.

Because of the slicing at the top, most of the actual processing,
including error handling and interpretation goes on in the back end
(i.e. the host) and anything request based like dm-mp and md (but
obviously not lvm, which is bio based) ... what I seem to see implied
but not stated in the above is that you have some reason you want to
move this into the guest, which is what happens if you slice at a lower
level (like SCSI)?

One of the problems you might also pick up slicing within SCSI is that
if (by some miracle, admittedly) we finally disentangle ATA from SCSI,
you'll lose ATA and SATA support in virtio-scsi.  Today you also loose
support for non-SCSI block devices like mmc 

James
