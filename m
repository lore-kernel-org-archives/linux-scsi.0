From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux
	(SCST),	target drivers for iSCSI and QLogic Fibre Channel cards released
Date: Wed, 09 Jul 2008 12:34:03 -0700
Message-ID: <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
References: <4873BCA5.10103@vlnb.net>
	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
	 <48749EB2.1070902@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41432 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750940AbYGITeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 15:34:10 -0400
In-Reply-To: <48749EB2.1070902@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, nab@kernel.org

On Wed, 2008-07-09 at 15:19 +0400, Vladislav Bolkhovitin wrote:
> Hi Nicholas,
> 
> Nicholas A. Bellinger wrote:
> > Hi Vlad,
> > 
> > On Tue, 2008-07-08 at 23:14 +0400, Vladislav Bolkhovitin wrote:
> >> I'm glad to announce that version 1.0.0 of Generic SCSI Target Middle 
> >> Level for Linux (SCST) was released and available for download from 
> >> http://scst.sourceforge.net/downloads.html
> > 
> > Congratulations on reaching your v1.0.0 release!
> 
> Thanks!
> 
> >> Comparison with the mainstream target middle level STGT you can find on 
> >> the SCST vs STGT page http://scst.sourceforge.net/scstvsstgt.html. In 
> >> short, SCST has the following main advantages over STGT:
> > 
> > I noticed that you included a reference to my presentation at LSF 08' on
> > your SCST vs. STGT page liked above, and took my description of your
> > work (you are more than welcome to come and present your own case at LSF
> > '09) very much out of context.
> 
> I wasn't on the presentation, so on it might have looked as out of 
> context.

Either was I until I dropped the program chair (Chris Mason was our
gracious host this year) a note about some of the topics that I thought
would be useful to discuss in the storage transport track.  As LSF is a
Usenix sponsered event, this basically consisted of a bunch of notes wrt
Linux/iSCSI, LIO-Core+LIO-Target and what has now become (alot of things
change in 5 months in the Linux/iSCSI world) the VHACS cloud.  Please
have a look at Linux-iSCSI.org to see what VHACS and VHACS-VM is. :-)


>  I have only documents, which I referenced. In them, especially 
> in "2008 Linux Storage & Filesystem Workshop" summary, it doesn't look 
> as I took it out of context. You put emphasis on "older" vs 
> "current"/"new", didn't you ;)?

Well, my job was to catch everyone up to speed on the status of the 4
(four) different (insert your favorite SAM capable transport name here)
Linux v2.6 based target projects.  With all of the acroynms for the
standards+implementations+linux-kernel being extremly confusing to
anyone who does know all of them by heart.  Even those people in the
room, who where fimilar with storage, but not necessarly with target
mode engine design, its hard to follow.   You will notice is the actual
slide discussing the status SCST, nothing about old vs. new is
mentioned.

>  Plus, Mike Christie is also listed as an 
> author.
> 

Yes, the Honorable Mr. Christie was discussing SYSFS infrastructure that
we are going to need for a generic target mode engine.

> BTW, there are another inaccuracies on your slides:
> 
>   - STGT doesn't support "hardware accelerated traditional iSCSI 
> (Qlogic)", at least I have not found any signs of it.
> 

<nod>, that is correct.  It does it's hardware acceleration generically
using OFA VERBS for hardware that do wire protocol that implements
fabric dependent direct data placement.  iSER does this with 504[0-4],
and I don't recall exactly how IB does it.   Anyways, the point is that
they use a single interface so that hardware vendors do not have to
implement their own APIs, which are very complex, and usually very buggy
when coming from a company who is trying to get a design into ASIC.

>   - For SCST you wrote "Only project to support PSCSI, FC and SAS Target 
> mode (with out of tree hardware drivers)". This is ambiguous statement, 
> but looks like you meant that SCST is intended and limited to support 
> only the listed transport. This is incorrect. SCST is intended to 
> support ALL possible transports and types backstorage.
> 

Sure, my intention was to make the point about kernel level drivers for
speciality engines being pushed out of tree because of the lack of k.o
storage engine for which they can push generically push packets to.

> > If you wish to reference my presentation, please at least make the
> > comparision between LIO-Core+LIO-Target vs. SCST vs. STGT, and NOT JUST
> > SCST vs. STGT so that the community are large can understand the
> > differences and technical challenges.
> 
> The SCST vs STGT page was written a long ago, before I ever looked at 
> LIO. I wasn't actually going to refer to your presentation, just added a 
> small note to your funny, from my POV, "older" vs "new" architecture 
> comparison ;)
> 

Heh. :-)

> But, when I have time for careful look, I'm going to write some LIO 
> critics. So far, at the first glance:
> 
>   - It is too iSCSI-centric. ISCSI is a very special transport, so looks 
> like when you decide to add in LIO drivers for other transports, 
> especially for parallel SCSI and SAS, you are going to have big troubles 
> and major redesign.

Not true.  Because LIO-Core subsystem API is battle hardened (you could
say it is the 2nd oldest, behind UNH's :), allocating LIO-Core SE tasks
(that then get issued to LIO-Core subsystem plugins) from a SCSI CDB
with sectors+offset for ICF_SCSI_DATA_SG_IO_CDB, or a generically
emulated SCSI control CDB or logic in LIO-Core, or using LIO-Core/PSCSI
to let the underlying hardware do its thing, but still fill in the holes
so that *ANY* SCSI subsystem, including from different OSes, can talk
with storage objects behind LIO-Core when running in initiator mode
amoungst the possible fabrics.   Some of the classic examples here are:

*) Because the Solaris 10 SCSI subsystem requiring all iSCSI devices to
have EVPD information, otherwise LUN registration would fail.  This
means that suddently struct block_device and struct file need to have
WWN information, which may be DIFFERENT based upon if said object was a
Linux/MD or LVM block device, for example.

*) Every cluster design that required block level shared storage needs
to have at least SAM-2 Reservations.

*) Exporting via LIO-Core Hardware RAID adapters on OSes where
max_sectors cannot be easily changed.  This is because some Hardware
RAID requires a smaller struct scsi_device->max_sector to handle smaller
stripe sizes for their arrays.

*) Some adapters in drivers/scsi which are not REAL SCSI devices emulate
none/some WWN or control logic mentioned above.  I have had to do a
couple of hacks over the years in LIO-Core/PSCSI to make everything
place nice going to the client side of the cloud, check out
iscsi_target_pscsi.c:pscsi_transport_complete() to see what I mean.

>  And this is a real showstopper for making LIO-Core 
> the default and the only SCSI target framework. SCST is SCSI-centric, 

Well, one needs to understand that LIO-Core subsystem API is more than a
SCSI target framework.  Its a generic method of accessing any possible
storage object of the storage stack, and having said engine handle the
hardware restrictions (be they physical or virtual) for the underlying
storage object.  It can run as a SCSI engine to real (or emualted) SCSI
hardware from linux/drivers/scsi, but the real strength is that it sits
above the SCSI/BLOCK/FILE layers and uses a single codepath for all
underlying storage objects.  For example in the lio-core-2.6.git tree, I
chose the location linux/drivers/lio-core, because LIO-Core uses 'struct
file' from fs/, 'struct block_device' from block/ and struct scsi_device
from drivers/scsi.

Its worth to note that I am still doing the re-org of LIO-Core and
LIO-Target v3.0.0, but this will be coming soon along with the first non
traditional iSCSI packets to run across LIO-Core.

> just because there's no way to make *SCSI* target framework not being 
> SCSI-centric. Nobody blames Linux SCSI (initiator) mid-layer for being 
> SCSI-centric, correct?

Well, as we have discussed before, the emulation of the SCSI control
path is really a whole different monster, and I am certainly not
interested in having to emulate all of the t10.org standards
myself. :-)  

> 
>   - Seems, it's a bit overcomplicated, because it has too many abstract 
> interfaces where there's not much need it them. Having too many abstract 
> interfaces makes code analyze a lot more complicated. For comparison, 
> SCST has only 2 such interfaces: for target drivers and for backstorage 
> dev handlers. Plus, there is half-abstract interface for memory 
> allocator (sgv_pool_set_allocator()) to allow scst_user to allocate user 
> space supplied pages. And they cover all needs.
> 

Well, I have discussed why I think the LIO-Core design (which was more
neccessity at the start) has been able to work with for all kernel
subsystems/storage objects on all architectures for v2.2, v2.4 and v2.6
kernels.  I also mention these at the 10,000 ft level in my LSF 08'
pres.  

>   - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
> relationship, as it used to be in STGT (now in STGT support for 
> pass-through mode seems to be removed), which isn't mentioned anywhere.
> 

Please be more specific by what you mean here.  Also, note that because
PSCSI is an LIO-Core subsystem plugin, LIO-Core handles the limitations
of the storage object through the LIO-Core subsystem API.  This means
that things like (received initiator CDB sectors > LIO-Core storage
object max_sectors) are handled generically by LIO-Core, using a single
set of algoritims for all I/O interaction with Linux storage systems.
These algoritims are also the same for DIFFERENT types of transport
fabrics, both those that expect LIO-Core to allocate memory, OR that
hardware will have preallocated memory and possible restrictions from
the CPU/BUS architecture (take non-cache coherent MIPS for example) of
how the memory gets DMA'ed or PIO'ed down to the packet's intended
storage object.

>   - There is some confusion in the code in the function and variable 
> names between persistent and SAM-2 reservations.
> 

Well, that would be because persistent reservations are not emulated
generally for all of the subsystem plugins just yet.  Obviously with
LIO-Core/PSCSI if the underlying hardware supports it, it will work.

>   - There is at least one SCSI standard violation: target and LUN resets 
> don't clear the reservation.
> 

Noted.  This needs to be fixed in v3.0.0 and then backported to
v2.9-STABLE.

> Again, it is the first impression, without deep analyze, so I might be 
> wrong somewhere.
> 
> > The more in fighting between the
> > leaders in our community, the less the community benefits.
> 
> Sure. If my note hurts you, I can remove it. But you should also remove 
> from your presentation and the summary paper those psychological 
> arguments to not confuse people.
> 

Its not about removing, it is about updating the page to better reflect
the bigger picture so folks coming to the sight can get the latest
information from last update.

Many thanks for your most valuable of time,

--nab


