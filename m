From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
Date: Fri, 09 Dec 2011 15:06:10 -0500
Message-ID: <1323461170.13189.17.camel@dabdike.cust.hotspot.t-mobile.com>
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>
	 <1323106159-6562-2-git-send-email-pbonzini@redhat.com>
	 <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>
	 <4EDF34CB.2080100@redhat.com> <1323268533.3021.37.camel@dabdike>
	 <4EE0B712.7000006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EE0B712.7000006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-08 at 14:09 +0100, Paolo Bonzini wrote:
> > Well, no it's not, the transports are the fastest evolving piece of the
> > SCSI spec.
> 
> No, I mean when something is added to the generic definition of SCSI 
> transport (SAM, more or less), not the individual transports.  When the 
> virtio-scsi transport has to change, you still have to update 
> spec+host+guest, but that's relatively rare.

This doesn't make sense:  You talk about wanting TMF access which *is*
transport defined.  Even if we just concentrate on the primary device
commands, they add at a fairly fast rate ... something like 10x what the
block protocol adds at.

> >> In the most common case, there is a feature that the guest already
> >> knows about, but that QEMU does not implement (for example a
> >> particular mode page bit). Once the host is updated to expose the
> >> feature, the guest picks it up automatically.
> >
> > That's in the encapsulation, surely; these are used to set up the queue,
> > so only the queue runner (i.e. the host) needs to know.
> 
> Not at all.  You can start the guest in writethrough-cache mode.  Then, 
> guests that know how to do flush+FUA can enable writeback for 
> performance.  There's nothing virtio-blk or virtio-scsi specific in 
> this.  But in virtio-scsi you only need to update the host.  In 
> virtio-blk you need to update the guest and spec too.
> 
> > I don't get this.  If you have a file backed SCSI device, you have to
> > interpret the MODE_SELECT command on the transport.  How is that any
> > different from unwrapping the SG_IO picking out the MODE_SELECT and
> > interpreting it?
> 
> The difference is that virtio-scsi exposes a direct-access SCSI device, 
> nothing less nothing more.  virtio-blk exposes a disk that has nothing 
> to do with SCSI except that it happens to understand SG_IO; the primary 
> means for communication are the virtio-blk config space and read/write 
> requests.

So this sounds like the virtio block backend has the wrong
implementation ... just fix it?  What should happen is anything you send
to a block queue in the guest you should be able to send to a block
queue in the host.  If you employ that principle, then tere are no
communication problems and the set of supported features is exactly what
a block queue supports which, in turn, is exactly what a user expects.

> So, for virtio-blk, SG_IO is good for persistent reservations, burning 
> CDs, and basically nothing else.  Neither of these can really be done in 
> the host by interpreting, so for virtio-blk it makes sense to simply 
> pass through.

It is a pass through for user space ... I don't get what your point is.
All of the internal commands for setup are handled in the host.  All the
guest is doing is attaching to a formed block queue.  I think, as I've
said several times before, all of this indicates virtio-blk doesn't do
discovery of the host block queue properly, but that's fixable.

> For virtio-scsi, the SCSI command set is how you communicate with the 
> host, and you don't care about who ends up interpreting the commands: it 
> can be local or remote, userspace or kernelspace, a server or a disk, 
> you don't care.
> 
> So, QEMU is already (optionally) doing interpretation for virtio-scsi. 
> It's not for virtio-blk, and it's not going to.

So are you saying there's some unfixable bug in the virtio-blk back end
that renders it difficult to use?

> >> Regarding passthrough, non-block devices and task management functions
> >> cannot be passed via virtio-blk.  Lack of TMFs make virtio-blk's error
> >> handling less than optimal in the guest.
> >
> > This would be presumably because most of the errors (i.e. the transport
> > ones) are handled in the host.  All the guest has to do is pass on the
> > error codes the host gives it.
> >
> > You worry me enormously talking about TMFs because they're transport
> > specific.
> 
> True, but virtio-blk for example cannot even retry a command at all.

Why would it need to.  You seem to understand that architecturally the
queue is sliced, but what you don't seem to appreciate is that error
handling is done below this ... i.e. in the host in your model, so
virtio-blk properly implemented *shouldn't* be doing retries.  You seem
to be stating error handling in a way that necessarily violates the
layering of block and then declaring this to be a problem.  It isn't; in
virtio-block, errors are handled in the host and passed up to the guest
when resolved.  I think you think there's some problem with this, but
you haven't actually said what it is yet.

> >> It doesn't really matter if it is exclusive or not (it can be
> >> non-exclusive with NPIV or iSCSI in the host; otherwise it pretty much
> >> has to be exclusive, because persistent reservations do not work).  The
> >> important point is that it's at the LUN level rather than the host level.
> >
> > virtio-blk can pass through at the LUN level surely: every LUN (in fact
> > every separate SCSI device) has a separate queue.
> 
> virtio-blk isn't meant to do pass through.  virtio-blk had SG_IO bolted 
> on it, but this doesn't mean that the guest /dev/vdX is equivalent to 
> the host's /dev/sdY.  From kernelspace, features are lacking: no WCE 
> toggle, no thin provisioning, no extended copy, etc.  From userspace, 
> your block size might be screwed up or worse.  With virtio-scsi, by 
> definition the guest /dev/sdX can be as capable as the host's /dev/sdY 
> if you ask the host to do passthrough.

Why do you worry about WCE?  That's a SCSI feature and it's handled in
the host.  What you need is the discovery of the flush parameters and a
corresponding setting of those in the guest queue, so that flushes are
preserved in stream.  The point here is that virtio-blk operates at the
block level, so you should too ... as in you operate in the abstracted
block environment which sets flush type ... you don't ask to pierce the
abstraction to try to see SCSI parameters.  The flush type should be
passed between the queues as part of proper discovery.

> >> There are other possible uses, where the target is on the host.  QEMU
> >> itself can act as the target, or you can use LIO with FILEIO or IBLOCK
> >> backends.
> >
> > If you use an iSCSI back end, why not an iSCSI initiator.  They may be
> > messy but at least the interaction is defined and expected rather than
> > encapsulated like you'd be doing with virtio-scsi.
> 
> If you use an iSCSI initiator, you need to expose to the guest the 
> details of your storage, including possibly the authentication.
> 
> I'm not sure however if you interpreted LIO as LIO's iSCSI backend.  In 
> that case, note that a virtio-scsi backend for LIO is in the works too.
> 
> > so I agree, supporting REQ_DISCARD are host updates because they're an
> > expansion of the block protocol.  However, they're rare, and, as you
> > said, you have to update the emulated targets anyway.
> 
> New features are rare, but there are also features where virtio-blk is 
> lagging behind, and those aren't necessarily rare.
> 
> Regarding updates to the targets, you have much more control on the host 
> than the guest.  Updating the host is trivial compared to updating the 
> guest.

So is this a turf war?  virto-blk isn't evolving fast enough (and since
you say lagging behind and DISCARD was a 2008 feature, that seems
reasonable) so you want to invent and additional backend that can move
faster?

> > Incidentally, REQ_DISCARD was added in 2008.  In that time close to
> > 50 new commands have been added to SCSI, so the block protocol is
> > pretty slow moving.
> 
> That also means that virtio-blk cannot give guests access to the full 
> range of features that might want to use.  Not all OSes are Linux, not 
> all OSes limit themselves to the features of the Linux block protocol.

So you're trying to solve the non-linux guest problem?  My observation
from Windows has been that windows device queues mostly behave
reasonably similarly to Linux ... that's not exactly, but similarly
enough that we can translate the requests.  On this basis, I don't
really see why a windows block driver can't attach almost exactly to a
Linux Guest queue.  I could see where this would fail pre 2008 because
of MS_SYNC, but we can even do that now.

> >> Not to mention that virtio-blk does I/O in units of 512 bytes.  It
> >> supports passing an arbitrary logical block size in the configuration
> >> space, but even then there's no guarantee that SG_IO will use the same
> >> size.  To use SG_IO, you have to fetch the logical block size with READ
> >> CAPACITY.
> >
> > So here what I think you're telling me is that virtio-blk doesn't have a
> > correct discovery protocol?
> 
> No, I'm saying that virtio-blk's SG_IO is not meant to be used for 
> configuration, I/O or discovery. 

Exactly correct.  virtio-blk should have its own queue discovery
protocol.  This, I think, seems to be the missing piece.

>  If you want to use it for those tasks, 
> and it breaks, you're on your own.  virtio-blk lets you show a 
> 4k-logical-block disk as having 512b logical blocks, for example because 
> otherwise you could not boot from it; however, as soon as you use SG_IO 
> the truth shows.  The answer is "don't do it", but can be a severe 
> limitation.

Again, you've lost me ... part of the things a correct block discovery
protocol would get would be physical and logical sector size ... this
will show you exactly if you're using 4k sectors and whether you're
emulated.

> >>> I'm not familiar necessarily with the problems of QEMU devices, but
> >>> surely it can unwrap the SG_IO transport generically rather than
> >>> having to emulate on a per feature basis?
> >>
> >> QEMU does interpret virtio-blk's SG_IO just by passing down the ioctl.
> >> With the virtio-scsi backend you can choose between doing so or
> >> emulating everything.
> >
> > So why is that choice not available to virto-blk?  surely it could
> > interpret after unwrapping the SG_IO encapsulation.
> 
> Because if you do this, you get really no advantages.  Userspace uses 
> virtio-blk's SG_IO for only a couple of usecases, which hardly apply to 
> files.  On the other hand, if you use SPC/SBC as a unified protocol for 
> configuration, discovery and I/O, it makes sense to emulate.
> 
> > Reading back all of this, I think there's some basic misunderstanding
> > somewhere, so let me see if I can make the discussion more abstract.
> 
> Probably. :)
> 
> > The way we run a storage device today (be it scsi or something else) is
> > via a block queue.  The only interaction a user gets is via that queue.
> > Therefore, in Linux, slicing the interaction at the queue and
> > transporting all the queue commands to some back end produces exactly
> > what we have today ...
> 
> Let's draw it like this:
> 
>               guest       |                    host
>                           |
>   read() -> req() ---virtio-blk ---> read() -> req -> READ(16) -> device
> 
> > now correctly implemented, virtio-blk should do that (and if there
> > are problems in the current implementation, I'd rather see them
> > fixed), so it should have full equivalency to what a native linux
> > userspace sees.
> 
> Right: there are missing features I mentioned above, and SG_IO is very 
> limited with virtio-blk compared to native, but usually it is fine.  For 
> other OSes it is less than ideal, but it can work.  It can be improved 
> (not completely fixed), but again at some point, it makes sense to 
> rethink the stack.
> 
> > Because of the slicing at the top, most of the actual processing,
> > including error handling and interpretation goes on in the back end
> > (i.e. the host) and anything request based like dm-mp and md (but
> > obviously not lvm, which is bio based) ... what I seem to see implied
> > but not stated in the above is that you have some reason you want to
> > move this into the guest, which is what happens if you slice at a lower
> > level (like SCSI)?
> 
> Yes, that's what happens if you do passthrough:
> 
>               guest                 |            host
>                                     |
>   read() -> req() -> READ(16) --virtio-scsi ---> ioctl() -> ...
> 
> Advantages here include the ability to work with non-block devices, and 
> the ability to reuse all the discovery code that is or will be in sd.c. 
>   If you do like this and you want multipathing (for example) you indeed 
> have to move it into the VM, but it doesn't usually make much sense.
> 
> However, something else actually can happen in the host, and here lie 
> the interesting cases.  For example, the host userspace can send the 
> commands to the LUN via iSCSI, directly:
> 
>               guest                 | host with userspace iSCSI initiator
>                                     |
>   read() -> req() -> READ(16) --virtio-scsi ---> send() -> ...
> 
> This is still effectively passthrough, on the other hand it doesn't 
> require you to handle low-level details in the VM.  And unlike an iSCSI 
> initiator in the guest, you are free to change how the storage is 
> implemented.
> 
> A third implementation is to emulate SCSI commands by unpacking them in 
> host userspace:
> 
>               guest                 |            host
>                                     |
>   read() -> req() -> READ(16) --virtio-scsi ---> read() -> ...
> 
> Again, you reuse all the discovery code that is in sd.c, and future 
> improvements can be confined to the emulation code only.  In addition, 
> future improvements done to sd.c for non-virt will apply to virt as well 
> (either right away or modulo emulation improvements).  In addition, 
> you're 100% sure that when the guest uses SG_IO it will not exhibit any 
> quirks.  And it is also more flexible when your guests are not Linux.
> 
> There's nothing new in it.  As far as I know, only Xen has a dedicated 
> protocol for paravirtualized block devices (in addition to virtio). 
> Hyper-V and VMware both use paravirtualized SCSI.
> 
> > One of the problems you might also pick up slicing within SCSI is that
> > if (by some miracle, admittedly) we finally disentangle ATA from SCSI,
> > you'll lose ATA and SATA support in virtio-scsi.  Today you also loose
> > support for non-SCSI block devices like mmc
> 
> You do not lose that.  Just like virtio-blk cannot do SG_IO to mmc, 
> virtio-scsi is only be usable with mmc in emulated mode.

OK, so I think the problem boils down to two components:

     1. virtio-blk isn't developing fast enough.  This looks to be a
        fairly easily fixable problem
     2. Discover in virtio-blk isn't done properly.  Again, this looks
        to be easily fixable.

Once you fix the above, most of what you're asking for, which is mainly
SCSI encapsulation for discovery and error handling in the guest for no
reason I can discern, becomes irrelevant.

James
