From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For	Linux	(SCST),	target
 drivers for iSCSI and QLogic Fibre Channel cards	released
Date: Fri, 11 Jul 2008 22:41:12 +0400
Message-ID: <4877A948.6090507@vlnb.net>
References: <4873BCA5.10103@vlnb.net>	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>	 <48749EB2.1070902@vlnb.net>	 <1215632043.9339.89.camel@haakon2.linux-iscsi.org>	 <48765433.70604@vlnb.net> <1215725167.31245.104.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:50672 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752704AbYGKSkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 14:40:32 -0400
In-Reply-To: <1215725167.31245.104.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jeff Garzik <jeff@garzik.org>, Leonid Grossman <leonid.grossman@neterion.com>, "H. Peter Anvin" <hpa@zytor.com>, Pete Wyckoff <pw@osc.edu>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rwalker@medallion.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Mazarick <mazarick@bellsouth.net>, Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@thunk.org>, Jerome Martin <tramjoe.merin@gmail.com>

Nicholas A. Bellinger wrote:
>>>>  And this is a real showstopper for making LIO-Core 
>>>> the default and the only SCSI target framework. SCST is SCSI-centric, 
>>> Well, one needs to understand that LIO-Core subsystem API is more than a
>>> SCSI target framework.  Its a generic method of accessing any possible
>>> storage object of the storage stack, and having said engine handle the
>>> hardware restrictions (be they physical or virtual) for the underlying
>>> storage object.  It can run as a SCSI engine to real (or emualted) SCSI
>>> hardware from linux/drivers/scsi, but the real strength is that it sits
>>> above the SCSI/BLOCK/FILE layers and uses a single codepath for all
>>> underlying storage objects.  For example in the lio-core-2.6.git tree, I
>>> chose the location linux/drivers/lio-core, because LIO-Core uses 'struct
>>> file' from fs/, 'struct block_device' from block/ and struct scsi_device
>>> from drivers/scsi.
>> SCST and iSCSI-SCST, basically, do the same things, except iSCSI MC/S 
>> and related, + something more, like 1-to-many pass-through and 
>> scst_user, which need a big chunks of code, correct? And they are 
>> together about 2 times smaller:
> 
> Yes, something much more.  A complete implementation of traditional
> iSCSI/TCP (known as RFC-3720), iSCSI/SCTP (which will be important in
> the future), and IPv6 (also important) is a significant amount of logic.
> When I say a 'complete implementation' I mean:
> 
> I) Active-Active connection layer recovery (known as
> ErrorRecoveryLevel=2).  (We are going to use the same code for iSER for
> inter-nexus OS independent (eg: below the SCSI Initiator level)
> recovery.  Again, the important part here is that recovery and
> outstanding task migration happens transparently to the host OS SCSI
> subsystem.  This means (at least with iSCSI and iSER): not having to
> register multiple LUNs and depend (at least completely) on SCSI WWN
> information, and OS dependent SCSI level multipath.  
> 
> II) MC/S for multiplexing (same as I), as well as being able to
> multiplex across multiple cards and subnets (using TCP, SCTP has
> multi-homing).  Also being able to bring iSCSI connections up/down on
> the fly, until we all have iSCSI/SCTP, is very important too.
> 
> III) Every possible combination of RFC-3720 defined parameter keys (and
> provide the apparatis to prove it).  And yes, anyone can do this today
> against their own Target.  I created core-iscsi-dv specifically for
> testing LIO-Target <-> LIO-Core back in 2005.  Core-iSCSI-DV is the
> _ONLY_ _PUBLIC_ RFC-3720 domain validation tool that will actually
> demonstrate, using ANY data integrity tool complete domain validation of
> user defined keys.  Please have a look at:
> 
> http://linux-iscsi.org/index.php/Core-iscsi-dv
> 
> http://www.linux-iscsi.org/files/core-iscsi-dv/README
> 
> Any traditional iSCSI target mode implementation + Storage Engine +
> Subsystem Plugin that thinks its ready to go into the kernel will have
> to pass at LEAST the 8k test loop interations, the simplest being:
> 
> HeaderDigest, DataDigest, MaxRecvDataSegmentLength (512 -> 262144, in
> 512 byte increments)
> 
> Core-iSCSI-DV is also a great indication of stability and data integrity
> of hardware/software of an iSCSI Target + Engine, espically when you
> have multiple core-iscsi-dv nodes hitting multiple VHACS clouds on
> physical machines within the cluster.  I have never run IET against
> core-iscsi-dv personally, and I don't think Ming or Ross has either.  So
> until SOMEONE actually does this first, I think that iSCSI-SCST is more
> of an experiment for your our devel that a strong contender for
> Linux/iSCSI Target Mode.

There are big doubts among storage experts if features I and II are 
needed at all, see, e.g. http://lkml.org/lkml/2008/2/5/331. I also tend 
to agree, that for block storage on practice MC/S is not needed or, at 
least, definitely doesn't worth the effort, because:

1. It is useless for sync. untagged operation (regular reads in most 
cases over a single stream), when always there is only one command being 
executed at any time, because of the commands connection allegiance, 
which forbids transferring data for a command over multiple connections.

2. The only advantage it has over traditional OS multi-pathing is 
keeping commands execution order, but on practice at the moment there is 
no demand for this feature, because all OS'es I know don't rely on 
commands order to protect data integrity. They use other techniques, 
like queue draining. A good target should be able itself to scheduler 
coming commands for execution in the correct from performance POV order 
  and not rely for that on the commands order as they came from initiators.

 From other side, devices bonding also preserves commands execution 
order, but doesn't suffer from the connection allegiance limitation of 
MC/S, so can boost performance ever for sync untagged operations. Plus, 
it's pretty simple, easy to use and doesn't need any additional code. I 
don't have the exact numbers of MC/S vs bonding performance comparison 
(mostly, because open-iscsi doesn't support MC/S, but very curious to 
see them), but have very strong suspicious that on modern OS'es, which 
do TCP frames reorder in zero-copy manner, there shouldn't be much 
performance difference between MC/S vs bonding in the maximum possible 
throughput, but bonding should outperform MC/S a lot in case of sync 
untagged operations.

Anyway, I think features I and II, if added, would increase iSCSI-SCST 
kernel side code not more than on 5K lines, because most of the code is 
already there, the most important part which missed is fixes of locking 
problems, which almost never add a lot of code. Relating Core-iSCSI-DV, 
I'm sure iSCSI-SCST will pass it without problems among the required set 
of iSCSI features, although still there are some limitations, derived 
from IET, for instance, support for multu-PDU commands in discovery 
sessions, which isn't implemented. But for adding to iSCSI-SCST optional 
iSCSI features there should be good *practical* reasons, which at the 
moment don't exist. And unused features are bad features, because they 
overcomplicate the code and make its maintainance harder for no gain.

So, current SCST+iSCSI-SCST 36K lines + 5K new lines = 41K lines, which 
still a lot less than LIO's 63K lines. I downloaded the cleanuped 
lio-core-2.6.git tree and:

$ find lio-core-2.6/drivers/lio-core -type f -name "*.[ch]"|xargs wc
57064  156617 1548344 total

Still much bigger.

> Obviously not.  Also, what I was talking about there was the strength
> and flexibility of the LIO-Core design (it even ran on the Playstation 2
> at one point, http://linux-iscsi.org/index.php/Playstation2/iSCSI, when
> MIPS r5900 boots modern v2.6, then we will do it again with LIO :-)

SCST and the target drivers have been successfully ran on PPC and 
Sparc64, so I don't see any reasons, why it can't be ran on Playstation 
2 as well.

>>>>   - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
>>>> relationship, as it used to be in STGT (now in STGT support for 
>>>> pass-through mode seems to be removed), which isn't mentioned anywhere.
>>>>
>>> Please be more specific by what you mean here.  Also, note that because
>>> PSCSI is an LIO-Core subsystem plugin, LIO-Core handles the limitations
>>> of the storage object through the LIO-Core subsystem API.  This means
>>> that things like (received initiator CDB sectors > LIO-Core storage
>>> object max_sectors) are handled generically by LIO-Core, using a single
>>> set of algoritims for all I/O interaction with Linux storage systems.
>>> These algoritims are also the same for DIFFERENT types of transport
>>> fabrics, both those that expect LIO-Core to allocate memory, OR that
>>> hardware will have preallocated memory and possible restrictions from
>>> the CPU/BUS architecture (take non-cache coherent MIPS for example) of
>>> how the memory gets DMA'ed or PIO'ed down to the packet's intended
>>> storage object.
>> See here: 
>> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06911.html
>>
> 
> <nod>
> 
>>>>   - There is some confusion in the code in the function and variable 
>>>> names between persistent and SAM-2 reservations.
>>> Well, that would be because persistent reservations are not emulated
>>> generally for all of the subsystem plugins just yet.  Obviously with
>>> LIO-Core/PSCSI if the underlying hardware supports it, it will work.
>> What you did (passing reservation commands directly to devices and 
>> nothing more) will work only with a single initiator per device, where 
>> reservations in the majority of cases are not needed at all.
> 
> I know, like I said, implementing Persistent Reservations for stuff
> besides real SCSI hardware with LIO-Core/PSCSI is a TODO item.  Note
> that the VHACS cloud (see below) will need this for DRBD objects at some
> point.

The problem is that persistent reservations don't work for multiple 
initiators even for real SCSI hardware with LIO-Core/PSCSI and I clearly 
described why in the referenced e-mail. Nicholas, why don't you want to 
see it?

>>>>> The more in fighting between the
>>>>> leaders in our community, the less the community benefits.
>>>> Sure. If my note hurts you, I can remove it. But you should also remove 
>>>> from your presentation and the summary paper those psychological 
>>>> arguments to not confuse people.
>>>>
>>> Its not about removing, it is about updating the page to better reflect
>>> the bigger picture so folks coming to the sight can get the latest
>>> information from last update.
>> Your suggestions?
>>
> 
> I would consider helping with this at some point, but as you can see, I
> am extremly busy ATM.  I have looked at SCST quite a bit over the years,
> but I am not the one making a public comparision page, at least not
> yet. :-)  So until then, at least explain how there are 3 projects on
> your page, with the updated 10,000 ft overviews, and mabye even add some
> links to LIO-Target and a bit about VHACS cloud.  I would be willing to
> include info about SCST into the Linux-iSCSI.org wiki.  Also, please
> feel free to open an account and start adding stuff about SCST yourself
> to the site.
> 
> For Linux-iSCSI.org and VHACS (which is really where everything is going
> now), please have a look at:
> 
> http://linux-iscsi.org/index.php/VHACS-VM
> http://linux-iscsi.org/index.php/VHACS
> 
> Btw, the VHACS and LIO-Core design will allow for other fabrics to be
> used inside our cloud, and between other virtualized client setups who
> speak the wire protocol presented by the server side of VHACS cloud.
> 
> Many thanks for your most valuable of time,
> 
> --nab
> 
> 
> 
> 

