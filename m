From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For
	Linux	(SCST),	target drivers for iSCSI and QLogic Fibre Channel cards
	released
Date: Thu, 10 Jul 2008 14:26:07 -0700
Message-ID: <1215725167.31245.104.camel@haakon2.linux-iscsi.org>
References: <4873BCA5.10103@vlnb.net>
	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
	 <48749EB2.1070902@vlnb.net>
	 <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
	 <48765433.70604@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42816 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754425AbYGJV0O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 17:26:14 -0400
In-Reply-To: <48765433.70604@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jeff Garzik <jeff@garzik.org>, Leonid Grossman <leonid.grossman@neterion.com>, "H. Peter Anvin" <hpa@zytor.com>, Pete Wyckoff <pw@osc.edu>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rwalker@medallion.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Mazarick <mazarick@bellsouth.net>, Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@thunk.org>, Jerome Martin <tramjoe.merin@gmail.com>

On Thu, 2008-07-10 at 22:25 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> >>  I have only documents, which I referenced. In them, especially 
> >> in "2008 Linux Storage & Filesystem Workshop" summary, it doesn't look 
> >> as I took it out of context. You put emphasis on "older" vs 
> >> "current"/"new", didn't you ;)?
> > 
> > Well, my job was to catch everyone up to speed on the status of the 4
> > (four) different (insert your favorite SAM capable transport name here)
> > Linux v2.6 based target projects.  With all of the acroynms for the
> > standards+implementations+linux-kernel being extremly confusing to
> > anyone who does know all of them by heart.  Even those people in the
> > room, who where fimilar with storage, but not necessarly with target
> > mode engine design, its hard to follow.
> 
> Yes, this is a problem. Even storage experts are not too familiar with 
> SCSI internals and not willing much to get better familiarity. Hence, 
> almost nobody really understands for what is all those SCSI processing 
> in SCST..
> 

Which is why being specific when we talk about these many varied
subjects (see below) that all fit into the bigger picture we all want to
get to (see VHACS) is of utmost importance.

> >> BTW, there are another inaccuracies on your slides:
> >>
> >>   - STGT doesn't support "hardware accelerated traditional iSCSI 
> >> (Qlogic)", at least I have not found any signs of it.
> >>
> > 
> > <nod>, that is correct.  It does it's hardware acceleration generically
> > using OFA VERBS for hardware that do wire protocol that implements
> > fabric dependent direct data placement.  iSER does this with 504[0-4],
> > and I don't recall exactly how IB does it.   Anyways, the point is that
> > they use a single interface so that hardware vendors do not have to
> > implement their own APIs, which are very complex, and usually very buggy
> > when coming from a company who is trying to get a design into ASIC.
> 
> ISER is "iSCSI Extensions for RDMA", while usually under "hardware 
> accelerated traditional iSCSI" people mean regular hardware iSCSI cards, 
> like QLogic 4xxx. Hence, your sentence for most people, including 
> myself, was incorrect and confusing.


Yes, I know the difference between traditional TCP and Direct Data
Placement (DDP) on multiple fabric interconnects.  (I own multiple
Qlogic, Intel, Alacratec traditional iSCSI cards myself, and have gotten
them all to work with LIO at some point).  The point that I was making
is that OFA VERBS does it INDEPENDENT of the vendor actually PRODUCING
the card/chip/whatever.  That means:

I) It makes the vendor's job easier producing silicon, because they
don't need to spend lots of extra engineering resources on producing the
types of APIs (VERBS, DAPL, MPI) that (some) cluster guys need for their
apps.  

II) It allows other vendors who are also making hardware to implement
the same fabric to benefit from others using/building/changing the code.

III) It allows storage engine architects (like ourselves) to use a
single API (and codebase with OFA) to push packets DDP packet for iSER
(RFC-5045) to the engine.

Anyways, the point is that with traditional iSCSI hardware acceleration.
there was never anything like that, because those implemenetations, most
noteably TOE (yes, I also worked on a TOE hardware at one point too :-)
where always considered a 'point in time' solution.

> >> But, when I have time for careful look, I'm going to write some LIO 
> >> critics. So far, at the first glance:
> >>
> >>   - It is too iSCSI-centric. ISCSI is a very special transport, so looks 
> >> like when you decide to add in LIO drivers for other transports, 
> >> especially for parallel SCSI and SAS, you are going to have big troubles 
> >> and major redesign.
> > 
> > Not true.  Because LIO-Core subsystem API is battle hardened (you could
> > say it is the 2nd oldest, behind UNH's :), allocating LIO-Core SE tasks
> > (that then get issued to LIO-Core subsystem plugins) from a SCSI CDB
> > with sectors+offset for ICF_SCSI_DATA_SG_IO_CDB, or a generically
> > emulated SCSI control CDB or logic in LIO-Core, or using LIO-Core/PSCSI
> > to let the underlying hardware do its thing, but still fill in the holes
> > so that *ANY* SCSI subsystem, including from different OSes, can talk
> > with storage objects behind LIO-Core when running in initiator mode
> > amoungst the possible fabrics.   Some of the classic examples here are:
> > 
> > *) Because the Solaris 10 SCSI subsystem requiring all iSCSI devices to
> > have EVPD information, otherwise LUN registration would fail.  This
> > means that suddently struct block_device and struct file need to have
> > WWN information, which may be DIFFERENT based upon if said object was a
> > Linux/MD or LVM block device, for example.
> > 
> > *) Every cluster design that required block level shared storage needs
> > to have at least SAM-2 Reservations.
> > 
> > *) Exporting via LIO-Core Hardware RAID adapters on OSes where
> > max_sectors cannot be easily changed.  This is because some Hardware
> > RAID requires a smaller struct scsi_device->max_sector to handle smaller
> > stripe sizes for their arrays.
> > 
> > *) Some adapters in drivers/scsi which are not REAL SCSI devices emulate
> > none/some WWN or control logic mentioned above.  I have had to do a
> > couple of hacks over the years in LIO-Core/PSCSI to make everything
> > place nice going to the client side of the cloud, check out
> > iscsi_target_pscsi.c:pscsi_transport_complete() to see what I mean.
> 
> I meant something different: interface between target drivers and SCSI 
> target core. Here (seems) you are going to have big troubles when you 
> try to add not-iSCSI transport, like FC, for instance.
> 

I know what you mean.  The point that I am making is that LIO-Core <->
Subsystem and LIO-Target <-> LIO-Core are seperated for all intensive
purposes in the lio-core-2.6.git tree.

Once the SCST interface between Fabric <-> Engine and can be hooked up
to v3.0.0 LIO-Core (Engine) <-> Subsystem (Linux Storage Stack) we will
be good to go to port ALL Fabric plugins, from SCST, iSER from STGT, and
eventually _NON_ SCSI fabrics as well (think AoE and Target Mode SATA).

> >>  And this is a real showstopper for making LIO-Core 
> >> the default and the only SCSI target framework. SCST is SCSI-centric, 
> > 
> > Well, one needs to understand that LIO-Core subsystem API is more than a
> > SCSI target framework.  Its a generic method of accessing any possible
> > storage object of the storage stack, and having said engine handle the
> > hardware restrictions (be they physical or virtual) for the underlying
> > storage object.  It can run as a SCSI engine to real (or emualted) SCSI
> > hardware from linux/drivers/scsi, but the real strength is that it sits
> > above the SCSI/BLOCK/FILE layers and uses a single codepath for all
> > underlying storage objects.  For example in the lio-core-2.6.git tree, I
> > chose the location linux/drivers/lio-core, because LIO-Core uses 'struct
> > file' from fs/, 'struct block_device' from block/ and struct scsi_device
> > from drivers/scsi.
> 
> SCST and iSCSI-SCST, basically, do the same things, except iSCSI MC/S 
> and related, + something more, like 1-to-many pass-through and 
> scst_user, which need a big chunks of code, correct? And they are 
> together about 2 times smaller:
> 

Yes, something much more.  A complete implementation of traditional
iSCSI/TCP (known as RFC-3720), iSCSI/SCTP (which will be important in
the future), and IPv6 (also important) is a significant amount of logic.
When I say a 'complete implementation' I mean:

I) Active-Active connection layer recovery (known as
ErrorRecoveryLevel=2).  (We are going to use the same code for iSER for
inter-nexus OS independent (eg: below the SCSI Initiator level)
recovery.  Again, the important part here is that recovery and
outstanding task migration happens transparently to the host OS SCSI
subsystem.  This means (at least with iSCSI and iSER): not having to
register multiple LUNs and depend (at least completely) on SCSI WWN
information, and OS dependent SCSI level multipath.  

II) MC/S for multiplexing (same as I), as well as being able to
multiplex across multiple cards and subnets (using TCP, SCTP has
multi-homing).  Also being able to bring iSCSI connections up/down on
the fly, until we all have iSCSI/SCTP, is very important too.

III) Every possible combination of RFC-3720 defined parameter keys (and
provide the apparatis to prove it).  And yes, anyone can do this today
against their own Target.  I created core-iscsi-dv specifically for
testing LIO-Target <-> LIO-Core back in 2005.  Core-iSCSI-DV is the
_ONLY_ _PUBLIC_ RFC-3720 domain validation tool that will actually
demonstrate, using ANY data integrity tool complete domain validation of
user defined keys.  Please have a look at:

http://linux-iscsi.org/index.php/Core-iscsi-dv

http://www.linux-iscsi.org/files/core-iscsi-dv/README

Any traditional iSCSI target mode implementation + Storage Engine +
Subsystem Plugin that thinks its ready to go into the kernel will have
to pass at LEAST the 8k test loop interations, the simplest being:

HeaderDigest, DataDigest, MaxRecvDataSegmentLength (512 -> 262144, in
512 byte increments)

Core-iSCSI-DV is also a great indication of stability and data integrity
of hardware/software of an iSCSI Target + Engine, espically when you
have multiple core-iscsi-dv nodes hitting multiple VHACS clouds on
physical machines within the cluster.  I have never run IET against
core-iscsi-dv personally, and I don't think Ming or Ross has either.  So
until SOMEONE actually does this first, I think that iSCSI-SCST is more
of an experiment for your our devel that a strong contender for
Linux/iSCSI Target Mode.

> $ find core-iscsi/svn/trunk/target/target -type f -name "*.[ch]"|xargs wc
> 59764  163202 1625877 total
> +
> $ find core-iscsi/svn/trunk/target/include -type f -name "*.[ch]"|xargs
> 2981  9316 91930 total
> =
> 62745      1717807
> 
> vs
> 
> $ find svn/trunk/scst -type f -name "*.[ch]"|xargs wc
> 28327  77878 734625 total
> +
> $ find svn/trunk/iscsi-scst/kernel -type f -name "*.[ch]"|xargs wc
> 7857  20394 194693 total
> =
> 36184        929318
> 
> Or did I count incorrectly?
> 
> > Its worth to note that I am still doing the re-org of LIO-Core and
> > LIO-Target v3.0.0, but this will be coming soon along with the first non
> > traditional iSCSI packets to run across LIO-Core.
> > 
> >> just because there's no way to make *SCSI* target framework not being 
> >> SCSI-centric. Nobody blames Linux SCSI (initiator) mid-layer for being 
> >> SCSI-centric, correct?
> > 
> > Well, as we have discussed before, the emulation of the SCSI control
> > path is really a whole different monster, and I am certainly not
> > interested in having to emulate all of the t10.org standards
> > myself. :-)  
> 
> Sure, there optional things. But there are also requirements, which must 
> be followed. So, this isn't about interested or not, this is about must 
> do or don't do at all.
> 

<nod>

> >>   - Seems, it's a bit overcomplicated, because it has too many abstract 
> >> interfaces where there's not much need it them. Having too many abstract 
> >> interfaces makes code analyze a lot more complicated. For comparison, 
> >> SCST has only 2 such interfaces: for target drivers and for backstorage 
> >> dev handlers. Plus, there is half-abstract interface for memory 
> >> allocator (sgv_pool_set_allocator()) to allow scst_user to allocate user 
> >> space supplied pages. And they cover all needs.
> > 
> > Well, I have discussed why I think the LIO-Core design (which was more
> > neccessity at the start) has been able to work with for all kernel
> > subsystems/storage objects on all architectures for v2.2, v2.4 and v2.6
> > kernels.  I also mention these at the 10,000 ft level in my LSF 08'
> > pres.  
> 
> Nobody in the Linux kernel community is interested to have obsolete or 
> unneeded for the current kernel version code in the kernel, so if you 
> want LIO core be in the kernel, you will have to make a major cleanup.
> 

Obviously not.  Also, what I was talking about there was the strength
and flexibility of the LIO-Core design (it even ran on the Playstation 2
at one point, http://linux-iscsi.org/index.php/Playstation2/iSCSI, when
MIPS r5900 boots modern v2.6, then we will do it again with LIO :-)

Anyways, just so everyone is clear:

v2.9-STABLE LIO-Target from Linux-iSCSI.org SVN:  Works on all Modern
v2.6 kernels up until >= v2.6.26.

v3.0.0 LIO-Core in lio-core-2.6.git tree on kernel.org: All legacy code
removed, currently at v2.6.26-rc9, tested on powerpc and x86.

Please look at my code before making such blanket statements please.

> Also, see the above LIO vs SCST size comparison. Is the additional code 
> all about the obsolete/currently unneeded features?
> 
> >>   - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
> >> relationship, as it used to be in STGT (now in STGT support for 
> >> pass-through mode seems to be removed), which isn't mentioned anywhere.
> >>
> > 
> > Please be more specific by what you mean here.  Also, note that because
> > PSCSI is an LIO-Core subsystem plugin, LIO-Core handles the limitations
> > of the storage object through the LIO-Core subsystem API.  This means
> > that things like (received initiator CDB sectors > LIO-Core storage
> > object max_sectors) are handled generically by LIO-Core, using a single
> > set of algoritims for all I/O interaction with Linux storage systems.
> > These algoritims are also the same for DIFFERENT types of transport
> > fabrics, both those that expect LIO-Core to allocate memory, OR that
> > hardware will have preallocated memory and possible restrictions from
> > the CPU/BUS architecture (take non-cache coherent MIPS for example) of
> > how the memory gets DMA'ed or PIO'ed down to the packet's intended
> > storage object.
> 
> See here: 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06911.html
> 

<nod>

> >>   - There is some confusion in the code in the function and variable 
> >> names between persistent and SAM-2 reservations.
> > 
> > Well, that would be because persistent reservations are not emulated
> > generally for all of the subsystem plugins just yet.  Obviously with
> > LIO-Core/PSCSI if the underlying hardware supports it, it will work.
> 
> What you did (passing reservation commands directly to devices and 
> nothing more) will work only with a single initiator per device, where 
> reservations in the majority of cases are not needed at all.

I know, like I said, implementing Persistent Reservations for stuff
besides real SCSI hardware with LIO-Core/PSCSI is a TODO item.  Note
that the VHACS cloud (see below) will need this for DRBD objects at some
point.

>  With 
> multiple initiators, as it is in clusters and where reservations are 
> really needed, it will sooner or later lead to data corruption. See the 
> referenced above message as well as the whole thread.
> 

Obviously with any target, if a non-shared resources is accessed by
multiple initiator/client nodes and there is no data coherency layer, or
reserverations or ACLS, or whatever there is going to be a problem.
That is a no-brainer.

Now, with a shared resource, such as a Quorum disk for a traditional
cluster design, or a cluster filesystem (such as OCFS2, GFS, Lustre,
etc) handle the data coherency just fine with SPC-2 Reserve today with
all LIO-Core v2.9 and v3.0.0. storage objects from all subsystems.

> >>> The more in fighting between the
> >>> leaders in our community, the less the community benefits.
> >> Sure. If my note hurts you, I can remove it. But you should also remove 
> >> from your presentation and the summary paper those psychological 
> >> arguments to not confuse people.
> >>
> > 
> > Its not about removing, it is about updating the page to better reflect
> > the bigger picture so folks coming to the sight can get the latest
> > information from last update.
> 
> Your suggestions?
> 

I would consider helping with this at some point, but as you can see, I
am extremly busy ATM.  I have looked at SCST quite a bit over the years,
but I am not the one making a public comparision page, at least not
yet. :-)  So until then, at least explain how there are 3 projects on
your page, with the updated 10,000 ft overviews, and mabye even add some
links to LIO-Target and a bit about VHACS cloud.  I would be willing to
include info about SCST into the Linux-iSCSI.org wiki.  Also, please
feel free to open an account and start adding stuff about SCST yourself
to the site.

For Linux-iSCSI.org and VHACS (which is really where everything is going
now), please have a look at:

http://linux-iscsi.org/index.php/VHACS-VM
http://linux-iscsi.org/index.php/VHACS

Btw, the VHACS and LIO-Core design will allow for other fabrics to be
used inside our cloud, and between other virtualized client setups who
speak the wire protocol presented by the server side of VHACS cloud.

Many thanks for your most valuable of time,

--nab



