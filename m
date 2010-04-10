From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Sat, 10 Apr 2010 16:50:02 -0700
Message-ID: <1270943402.6412.150.camel@haakon2.linux-iscsi.org>
References: <4BB45632.5020700@suse.de>
	 <1270186392.28897.76.camel@haakon2.linux-iscsi.org>
	 <4BBDDDA3.7000006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:29406 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752480Ab0DJXuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 19:50:07 -0400
In-Reply-To: <4BBDDDA3.7000006@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2010-04-08 at 15:44 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > On Thu, 2010-04-01 at 10:15 +0200, Hannes Reinecke wrote:
> >> Hi all,
> >>
> > 
> > Greetings Hannes,
> > 
> > Just a few comments on your proposal..
> > 
> >> [Topic]
> >> Handling of invalid requests in virtual HBAs
> >>
> >> [Abstract]
> >> This discussion will focus on the problem of correct request handling with virtual HBAs.
> >> For KVM I have implemented a 'megasas' HBA emulation which serves as a backend for the
> >> megaraid_sas linux driver.
> >> It is now possible to connect several disks from different (physical) HBAs to that
> >> HBA emulation, each having different logical capabilities wrt transfersize,
> >> sgl size, sgl length etc.
> >>
> >> The goal of this discussion is how to determine the 'best' capability setting for the
> >> virtual HBA and how to handle hotplug scenarios, where a disk might be plugged in
> >> which has incompatible settings from the one the virtual HBA is using currently.
> >>

<SNIP>

> > What values should be enforced by TCM based on metadata presented by TCM
> > subsystem plugins (pSCSI, IBLOCK, FILEIO) for struct block_device, and
> > what is expected to be enforced by underlying Linux subsystems
> > presenting struct block_device..?
> > 
> > For the virtual TCM subsystem plugin cases (IBLOCK, FILEIO, RAMDISK) the
> > can_queue is a competely arbitary value and is enforced by the
> > underyling Linux subsystem.  There are a couple of special cases:
> > 
> > *) For TCM/pSCSI, can_queue is enforced from struct scsi_device->queue_depth
> >    and max_sectors from the smaller of the two values from struct Scsi_Host->max_sectors
> >    and struct scsi_device->request_queue->limits.max_sectors.
> > 
> > *) For TCM/IBLOCK, max_sectors is enforced based on struct request_queue->limits.max_sectors.
> > 
> > *) For TCM/FILEIO and TCM/RAMDISK, both can_queue and max_sectors are
> >    set to arbitrarly high values.
> > 
> > Also I should mention that TCM_Loop code currently uses a hardcoded
> > struct scsi_host_template->can_queue=1 and ->max_sectors=128, but will
> > work fine with larger values.   Being able to change the Linux/SCSI
> > queue depth on the fly for TCM_Loop virtual SAS ports being used in KVM
> > guest could be quite useful for managing KVM Guest megasas emulation I/O
> > traffic on a larger scale..
> > 
> And my question / topic here is how to handle a hotplug capability in these
> cases: What happens if a device / HBA is plugged in with different / lower
> capabilities than those announced?

I think this question depends a great deal upon the coupling of the
virtual HBA queue depth and per physical Linux/SCSI reported device
queue depth.  Using the TCM/pSCSI subsystem plugin as an example here to
reference plain /dev/sdX backstores, there are two possible modes of
operation using referenced struct scsi_device's and their parent struct
Scsi_Host's:

Virtual HBA Mode: Present a arbitrarily high virtual HBA queue depth and
allow individual struct scsi_device's from different underlying struct
Scsi_Host's to hang from a single TCM HBA.  TCM will enforce the per
device queue depth presented by struct scsi_device->queue_depth.   

Physical HBA Mode: Enforce an physical LLD queue_depth from each
underlying struct Scsi_Host and all struct scsi_device attached to it.
This is required for SCSI LLDs that report a higher struct
scsi_device->queue_depth than what the underlying hardware for struct
Scsi_Host is capable.  TCM will enforce the per HBA and per device queue
depths presented by the SCSI LLD.

The main requirement for SCSI LLDs with the first mode to function
properly is that the underlying Linux/SCSI LLD must present the proper
struct scsi_device->queue_depth, and the sum total of queue slots
exposed by struct scsi_device's cannot exceed what the parent struct
Scsi_Host is capable of (also can change based on the number of LUNs
presented by the SCSI LLD)

I had ran into some buggy SCSI LLDs in v2.4 kernel days that reported
their queue depths improperly, but do not recall coming across this
issue personally recently on modern v2.6 drivers/scsi/ (not sure if they
are completely gone now).  So with this in mind, I added support for
virtual HBA mode (called PHV_VIRUTAL_HOST_ID and default) while leaving
the legacy phyiscal HBA mode available (called PHV_LLD_SCSI_HOST_NO) for
broken SCSI LLDs.  The commit for doing this with TCM/pSCSI is here:

[Target_Core_Mod/pSCSI]: Decouple subsystem plugin from struct Scsi_Host

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=da5ed2625e7690c33f776dd1a907a2739fe7f779

> Can we change the announced settings for the HBA on the fly?

In existing TCM v3.x code, the HBA queue depth is not exposed as a
configfs attribute, so unfortuately this cannot be changed just yet..
However the per TCM device virtual and physical queue_depth is available
at:

/sys/kernel/config/target/core/$HBA/$DEV/attrib/[hw_]queue_depth

The 'queue_depth' attribute here what is being actively enforced by TCM
for the backstore device, and the 'hw_queue_depth' attribute is what had
been reported by TCM/pSCSI via struct scsi_device->queue_depth.

Changing 'queue_depth' for the backstore currently requires that no
fabric module port symlinks exist, but this is something that will be
changing for TCM 4.0.

Also, changing 'hw_queue_depth' from underlying struct scsi_device for
the plain /dev/sdX currently requires that the device be re-registered
from TCM.  However, it would be easy enough to do this on the fly if
there was a target mode callback present in
drivers/scsi/scsi.c:scsi_adjust_queue_depth() to tell me when the change
is happening within the LLD.  :-)

> 
> > The other big advantage of using TCM_Loop with your megasas guest
> > emulation means that existing TCM logic for >= SPC-3 T10 NAA naming, PR,
> > and ALUA emulation is immediately available to KVM guest, and does not
> > have to be reproduced in QEMU code.
> > 
> I'm not doubting that using TCM_loop here would be advantageous.
> But I have to find a solution for folks just wanting to run on plain /dev/sdX.
> 

Well, I think that using a scsi-debug-esque model like TCM_Loop + SG_IO
on top of a target infrastructure enforcing underlying HBA and device
requirements would give KVM Guests alot of flexibility with existing
code, even for the plain /dev/sdX case.

> And I need to find a common ground here to argue with the KVM folks,
> whose main objection against the megasas emulation is this issue.
>
> Either way would be fine by me, I just think we should come to a common
> understanding.
> 

Completely understood.  I will give SG_IO + TCM_Loop a shot with megasas
emulation into KVM Guest and see how things look with using backstores
configured with the two HBA Modes for TCM/pSCSI (plain /dev/sdX)
discussed above.

Best,

--nab


