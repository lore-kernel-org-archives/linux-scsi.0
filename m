From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: LVM2 vs FileIO - pros/cons?
Date: Wed, 10 Sep 2008 20:48:36 -0700
Message-ID: <1221104916.27831.283.camel@haakon2.linux-iscsi.org>
References: <3d4acab5-db19-48ce-a2b1-c4ce2e502652@x35g2000hsb.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:26338 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681AbYIKDsj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 23:48:39 -0400
In-Reply-To: <3d4acab5-db19-48ce-a2b1-c4ce2e502652@x35g2000hsb.googlegroups.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: SCST-Devel <scst-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, STGT-Devel <stgt-devel@lists.berlios.de>, DRBD-DEV <drbd-dev@lists.linbit.com>, LKML <linux-kernel@vger.kernel.org>

On Wed, 2008-09-10 at 10:16 -0700, Martin wrote:
> If I have space presented to my iscsi host as a large hw-based LUN,
> and I would like to provide that to initiators in several chunks
> through multiple targets, am I best off dividing up the space using
> the FileIO hba type, or setting up LVM2, or another option?  What are
> the pros and cons of the possible choices?
> 

So, the targets communicate with LVM2's device-mapper struct
block_device using struct bio requets that employs *UNBUFFERED*
opteration.  That is, acknowledgements for iSCSI I/O CDBs get sent back
to the Initiator Port (or client or whatever you want to call it) *ONLY*
when the underlying storage tells it it has be put down to the media.
If you are using a hardware RAID, this means that the request may be
going into a write-back or write-through memory cache before it actually
goes down to disk.  With a hardware RAID, you need a battery backup in
order to ensure data integrity across a power failure.  There is a
limitiation with kernel level FILEIO where O_DIRECT is unimplemented on
kernel level memory pages, which means only *BUFFERED* ops are supported
on FILEIO.  If a machine was to crash and then restart with the same
kernel level export, the initiator side would have the incorrect view of
the actual blocks on media.  NOT GOOD..  Same type of problem if your
hardware RAID does has write cache enabled and *NO* battery backup.

A transport layer like SCSI or SATA is a DMA ring to hardware, and has
no concept of buffers, they just queue requests into the hardware ring
and out onto the BUS, etc.  The same type of unbuffered option is
happens for a SCSI passthrough (eg, LIO-Target hba_type=1).  Using
struct scsi_device as a target engine storage object in kernel space
*REQUIRES* this type of unbuffered I/O, and actually happens to be the
fastest because you remove the requirement of your iSCSI I/Os from
having to go through the block layer.

For your particular case, I would recommend using IBLOCK with LVM for
production with the current stable code, and a Hardware RAID adapter
with a deep TCQ depth and a larger max_sectors per request if you need
100 MB/sec + performance.  I am waiting to retest the IBLOCK performance
as virtual block devices get ported to the new upstream stacking model.
One of the setups that I most interested in is LVM2 on software RAID6,
which is the setup used for current Linux-iSCSI.org production fabric
with around a dozen or so exported volumes.  Let me know if you run into
singnificant performance issues using LVM as you start to scale the
number IBLOCK LVM2 exports.  It would also be worthwhile to test with
FILEIO just to see if there is any type of scheduling strangeless going
between layers..

Going a little deeper to the actual problems for those interested kernel
storage folks:

Using kernel level IBLOCK with struct bio to different underlying
backing parent virtual and/or physical block devices.  That is, the
final underlying struct block_device may just be another virtual struct
block_device for the underlying iSCSI/SAS/FC storage fabric, etc..
There seems to be a very small difference between exporting something
that appears as a SCSI device under Linux either as the struct
scsi_device (with LIO-Core/pSCSI) or struct block_device (with
LIO-Core/IBLOCK) that points *DIRECTLY* to struct scsi_device device and
then down to the real disks.  There is however a very large difference
when you are combining different virtual struct block_devices and
looking them together, this is something that is currently being worked
on for v2.6.27 and beyond code..

The struct bio's page direct mapping from received packets for the WRITE
case with true zero-copy I/O from an RDMA fabric (eg: non traditional
iSCSI) will probably be working sooner than using FILEIO the existing
struct file_operations API, but who knows.. ;-)  That is another
interesting question for the emerging RDMA logic from OFA in upstream
kernels.  The primary solution for this from my previous research was
trying using kernel level O_DIRECT for a struct file using sendpage() on
the transmit side and sockets on the receive side, and then the LIO-Core
zero copy linked list struct page allocation into contigiously single
page allocated struct scatterlist for Linux storage subsystems.  Using
multiple contigious page struct scatterlist allocations for incoming
packets will help improve performance for struct bio into struct
block_device for LVM2 to backing storage, but there is still work to be
done to make it generic for upstream kernels..

Thanks for the great questions Martin!

--nab

