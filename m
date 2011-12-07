From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
Date: Wed, 07 Dec 2011 10:41:31 +0100
Message-ID: <4EDF34CB.2080100@redhat.com>
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>  <1323106159-6562-2-git-send-email-pbonzini@redhat.com> <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323194999.3014.8.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 12/06/2011 07:09 PM, James Bottomley wrote:
> On Mon, 2011-12-05 at 18:29 +0100, Paolo Bonzini wrote:
>> The virtio-scsi HBA is the basis of an alternative storage stack
>> for QEMU-based virtual machines (including KVM).
>
> Could you clarify what the problem with virtio-blk is?

In a nutshell, if virtio-blk had no problems, then you could also throw 
away iSCSI and extend NBD instead. :)

The main problem is that *every* new feature requires updating three or 
more places: the spec, the host (QEMU), and the guest drivers (at least 
two: Linux and Windows).  Exposing the new feature also requires 
updating all the hosts, but also all the guests.

With virtio-scsi, the host device provides nothing but a SCSI transport. 
  You still have to update everything (spec+host+guest) when something 
is added to the SCSI transport, but that's a pretty rare event.  In the 
most common case, there is a feature that the guest already knows about, 
but that QEMU does not implement (for example a particular mode page 
bit).  Once the host is updated to expose the feature, the guest picks 
it up automatically.

Say I want to let guests toggle the write cache.  With virtio-blk, this 
is not part of the spec so first I would have to add a new feature bit 
and a field in the configuration space of the device.  I would need to 
the host (of course), but I would also have to teach guest drivers about 
the new feature and field.  I cannot just send a MODE SELECT command via 
SG_IO, because the block device might be backed by a file.

With virtio-scsi, the guest will just go to the mode pages and flip the 
WCE bit.  I don't need to update the virtio-scsi spec, because the spec 
only defines the transport.  I don't need to update the guest driver, 
because it likewise only defines the transport and sd.c already knows 
how to do MODE SENSE/MODE SELECT.  I do need to teach the QEMU target of 
course, but that will always be smaller than the sum of 
host+Linux+Windows changes required for virtio-blk (if only because the 
Windows driver already contains a sort of SCSI target).

Regarding passthrough, non-block devices and task management functions 
cannot be passed via virtio-blk.  Lack of TMFs make virtio-blk's error 
handling less than optimal in the guest.

>> Compared to virtio-blk it is more scalable, because it supports
>> many LUNs on a single PCI slot),
>
> This is just multiplexing, surely, which should be easily fixable in
> virtio-blk?

Yes, you can do that.   I did play with a "virtio-over-virtio" device, 
but it was actually more complex than virtio-scsi and would not fix the 
other problems.

>> more powerful (it more easily supports passthrough of host devices
>> to the guest)
>
> I assume this means exclusive passthrough?

It doesn't really matter if it is exclusive or not (it can be 
non-exclusive with NPIV or iSCSI in the host; otherwise it pretty much 
has to be exclusive, because persistent reservations do not work).  The 
important point is that it's at the LUN level rather than the host level.

> In which case, why doesn't passing the host block queue through to
> the guest just work? That means the host is doing all the SCSI back
> end stuff and you've just got a lightweight queue pass through.

If you want to do passthrough, virtio-scsi is exactly this, a 
lightweight queue.

There are other possible uses, where the target is on the host.  QEMU 
itself can act as the target, or you can use LIO with FILEIO or IBLOCK 
backends.

>> and more easily extensible (new SCSI features implemented by QEMU
>> should not require updating the driver in the guest).
>
> I don't really understand this comment at all:  The block protocol is
> far simpler than SCSI, but includes SG_IO, which can encapsulate all
> of the SCSI features ...

The problem is that SG_IO is bolted on.  It doesn't work if the guest's 
block device is backed by a file, and in general the guest shouldn't 
care about that.  The command might be passed down to a real disk, 
interpreted by an iSCSI target, or emulated by QEMU.  There's no reason 
why a guest should see any difference and indeed with virtio-scsi it 
does not (besides the obvious differences in INQUIRY data).

And even if it works, it is neither the main I/O mechanism nor the main 
configuration mechanism.  Regarding configuration, see the above example 
of toggling the write cache.

Regarding I/O, an example would be adding "discard" support.  With 
virtio-scsi, you just make sure that the emulated target supports WRITE 
SAME w/UNMAP.  With virtio-blk it's again spec+host+guest updates. 
Bypassing this with SG_IO would mean copying a lot of code from sd.c and 
not working with files (cutting out both sparse and non-raw files, which 
are the most common kind of virt thin-provisioning).

Not to mention that virtio-blk does I/O in units of 512 bytes.  It 
supports passing an arbitrary logical block size in the configuration 
space, but even then there's no guarantee that SG_IO will use the same 
size.  To use SG_IO, you have to fetch the logical block size with READ 
CAPACITY.

Also, using SG_IO for I/O will bypass the host cache and might leave the 
host in a pretty confused state, so you could not reliably do extended 
copy using SG_IO, for example.  Spec+host+driver once more.  (And 
modifying the spec would be a spectacular waste of time because the 
outcome would be simply a dumbed down version of SBC, and quite hard to 
get right the first time).

SG_IO is also very much tied to Linux guests, both in the host and in 
the guest.  For example, the spec includes an "errors" field that is not 
defined in the spec.  Reading the virtio-blk code shows that it is 
really a (status, msg_status, host_status, driver_status) combo.  In the 
guest, not all OSes tell the driver if the I/O request came from a 
"regular" command or from SCSI pass-through.  In Windows, all disks are 
like Linux /dev/sdX, so Windows drivers cannot send SG_IO requests to 
the host.

All this makes SG_IO a workaround, but not a solution.  Which 
virtio-scsi is.

> I'm not familiar necessarily with the problems of QEMU devices, but
> surely it can unwrap the SG_IO transport generically rather than
> having to emulate on a per feature basis?

QEMU does interpret virtio-blk's SG_IO just by passing down the ioctl. 
With the virtio-scsi backend you can choose between doing so or 
emulating everything.

Paolo
