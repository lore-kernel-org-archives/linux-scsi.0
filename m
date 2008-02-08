From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 08 Feb 2008 03:33:15 -0800
Message-ID: <1202470395.1805.127.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain> <47A751C5.60600@vlnb.net>
	 <1202149322.3096.66.camel@localhost.localdomain>
	 <47A75B8A.3020503@vlnb.net>
	 <1202151293.3096.80.camel@localhost.localdomain>
	 <47A8B210.8040202@vlnb.net>
	 <1202238802.3133.71.camel@localhost.localdomain>
	 <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
	 <47AB0B63.20500@vlnb.net>
	 <alpine.DEB.1.00.0802071437404.12791@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:28961 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759677AbYBHLd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 06:33:57 -0500
In-Reply-To: <alpine.DEB.1.00.0802071437404.12791@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, 2008-02-07 at 14:51 -0800, david@lang.hm wrote:
> On Thu, 7 Feb 2008, Vladislav Bolkhovitin wrote:
> 
> > Bart Van Assche wrote:
> >> - It has been discussed which iSCSI target implementation should be in
> >> the mainstream Linux kernel. There is no agreement on this subject
> >> yet. The short-term options are as follows:
> >> 1) Do not integrate any new iSCSI target implementation in the
> >> mainstream Linux kernel.
> >> 2) Add one of the existing in-kernel iSCSI target implementations to
> >> the kernel, e.g. SCST or PyX/LIO.
> >> 3) Create a new in-kernel iSCSI target implementation that combines
> >> the advantages of the existing iSCSI kernel target implementations
> >> (iETD, STGT, SCST and PyX/LIO).
> >> 
> >> As an iSCSI user, I prefer option (3). The big question is whether the
> >> various storage target authors agree with this ?
> >
> > I tend to agree with some important notes:
> >
> > 1. IET should be excluded from this list, iSCSI-SCST is IET updated for SCST 
> > framework with a lot of bugfixes and improvements.
> >
> > 2. I think, everybody will agree that Linux iSCSI target should work over 
> > some standard SCSI target framework. Hence the choice gets narrower: SCST vs 
> > STGT. I don't think there's a way for a dedicated iSCSI target (i.e. PyX/LIO) 
> > in the mainline, because of a lot of code duplication. Nicholas could decide 
> > to move to either existing framework (although, frankly, I don't think 
> > there's a possibility for in-kernel iSCSI target and user space SCSI target 
> > framework) and if he decide to go with SCST, I'll be glad to offer my help 
> > and support and wouldn't care if LIO-SCST eventually replaced iSCSI-SCST. The 
> > better one should win.
> 
> why should linux as an iSCSI target be limited to passthrough to a SCSI 
> device.
> 

<nod>

I don't think anyone is saying it should be.  It makes sense that the
more mature SCSI engines that have working code will be providing alot
of the foundation as we talk about options..

>From comparing the designs of SCST and LIO-SE, we know that SCST has
supports very SCSI specific target mode hardware, including software
target mode forks of other kernel code.  This code for the target mode
pSCSI, FC and SAS control paths (more for the state machines, that CDB
emulation) that will most likely never need to be emulated on non SCSI
target engine.  SCST has support for the most SCSI fabric protocols of
the group (although it is lacking iSER) while the LIO-SE only supports
traditional iSCSI using Linux/IP (this means TCP, SCTP and IPv6).  The
design of LIO-SE was to make every iSCSI initiator that sends SCSI CDBs
and data to talk to every potential device in the Linux storage stack on
the largest amount of hardware architectures possible.

Most of the iSCSI Initiators I know (including non Linux) do not rely on
heavy SCSI task management, and I think this would be a lower priority
item to get real SCSI specific recovery in the traditional iSCSI target
for users.  Espically things like SCSI target mode queue locking
(affectionally called Auto Contingent Allegiance) make no sense for
traditional iSCSI or iSER, because CmdSN rules are doing this for us.

> the most common use of this sort of thing that I would see is to load up a 
> bunch of 1TB SATA drives in a commodity PC, run software RAID, and then 
> export the resulting volume to other servers via iSCSI. not a 'real' SCSI 
> device in sight.
> 

I recently moved the last core LIO target machine from a hardware RAID5
to MD RAID6 with struct block_device exported LVM objects via
Linux/iSCSI to PVM and HVM domains, and I have been very happy with the
results.  Being able to export any physical or virtual storage object
from whatever layer makes sense for your particular case.  This applies
to both block and file level access.  For example, making an iSCSI
Initiator and Target run in the most limited in environments places
where NAS (espically userspace server side) would have a really hard
time fitting, has always been a requirement.  You can imagine a system
with a smaller amount of memory (say 32MB) having a difficult time doing
I/O to any amount of NAS clients.

If are talking about memory required to get best performance, using
kernel level DMA ring allocation and submission to a generic target
engine uses a significantly smaller amount of memory, than say
traditional buffered FILEIO.  Going futher up the storage stack with
buffered file IO, regardless of if its block or file level, will always
start to add overhead.  I think that kernel level FILEIO with O_DIRECT
and asyncio would probably help alot in this case for general target
mode usage of MD and LVM block devices.

This is because when we are using PSCSI or IBLOCK to queue I/Os which,
may need be different from the original IO from the initiator/client due
to OS storage subsystem differences and/or physical HBA limitiations for
the layers below block.  The current LIO-SE API excepts the storage
object to present these physical limitiations if to engine they exist.
This is called iscsi_transport_t in iscsi_target_transport.h currently,
but really should be called something like target_subsytem_api_t and
plugins called target_pscsi_t, target_bio_t, target_file_t, etc.

> As far as how good a standard iSCSI is, at this point I don't think it 
> really matters. There are too many devices and manufacturers out there 
> that implement iSCSI as their storage protocol (from both sides, offering 
> storage to other systems, and using external storage). Sometimes the best 
> technology doesn't win, but Linux should be interoperable with as much as 
> possible and be ready to support the winners and the loosers in technology 
> options, for as long as anyone chooses to use the old equipment (after 
> all, we support things like Arcnet networking, which lost to Ethernet many 
> years ago)
> 

The RFC-3720 standard has been stable for going on four years in 2008,
and as the implementations continue to mature, having Linux lead the way
in iSCSI Target, Initiator and Target/Initiator that can potentially run
on anything that can boot Linux on the many, many types of system and
storage around these days is the goal.  I can't personally comment on
how many of these types of systems that target mode or iSCSI stacks have
run in other people's environments, but I have personally been involved
getting LIO/SE and Core/iSCSI running on i386 and x86_64, along with
Alpha, ia64, MIPS, PPC and POWER, and lots of ARM.  I believe the LIO
Target and Initiator stacks have been able to run on the smallest
systems so far, including a uclinux 2.6 sub 100 Mhz board and ~4 MB of
usable sytem memory.  This is still today with the LIO target stack,
which has been successfully run on the OpenMoko device with memory and
FILEIO. :-)

--nab

Btw, I definately agree that being able to export the large amount of
legacy drivers will continue to be an important part..

