From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux	(SCST),	target
 drivers for iSCSI and QLogic Fibre Channel cards released
Date: Thu, 10 Jul 2008 22:25:55 +0400
Message-ID: <48765433.70604@vlnb.net>
References: <4873BCA5.10103@vlnb.net>	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>	 <48749EB2.1070902@vlnb.net> <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:50625 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752317AbYGJSZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 14:25:11 -0400
In-Reply-To: <1215632043.9339.89.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, nab@kernel.org

Nicholas A. Bellinger wrote:
>>  I have only documents, which I referenced. In them, especially 
>> in "2008 Linux Storage & Filesystem Workshop" summary, it doesn't look 
>> as I took it out of context. You put emphasis on "older" vs 
>> "current"/"new", didn't you ;)?
> 
> Well, my job was to catch everyone up to speed on the status of the 4
> (four) different (insert your favorite SAM capable transport name here)
> Linux v2.6 based target projects.  With all of the acroynms for the
> standards+implementations+linux-kernel being extremly confusing to
> anyone who does know all of them by heart.  Even those people in the
> room, who where fimilar with storage, but not necessarly with target
> mode engine design, its hard to follow.

Yes, this is a problem. Even storage experts are not too familiar with 
SCSI internals and not willing much to get better familiarity. Hence, 
almost nobody really understands for what is all those SCSI processing 
in SCST..

>> BTW, there are another inaccuracies on your slides:
>>
>>   - STGT doesn't support "hardware accelerated traditional iSCSI 
>> (Qlogic)", at least I have not found any signs of it.
>>
> 
> <nod>, that is correct.  It does it's hardware acceleration generically
> using OFA VERBS for hardware that do wire protocol that implements
> fabric dependent direct data placement.  iSER does this with 504[0-4],
> and I don't recall exactly how IB does it.   Anyways, the point is that
> they use a single interface so that hardware vendors do not have to
> implement their own APIs, which are very complex, and usually very buggy
> when coming from a company who is trying to get a design into ASIC.

ISER is "iSCSI Extensions for RDMA", while usually under "hardware 
accelerated traditional iSCSI" people mean regular hardware iSCSI cards, 
like QLogic 4xxx. Hence, your sentence for most people, including 
myself, was incorrect and confusing.

>> But, when I have time for careful look, I'm going to write some LIO 
>> critics. So far, at the first glance:
>>
>>   - It is too iSCSI-centric. ISCSI is a very special transport, so looks 
>> like when you decide to add in LIO drivers for other transports, 
>> especially for parallel SCSI and SAS, you are going to have big troubles 
>> and major redesign.
> 
> Not true.  Because LIO-Core subsystem API is battle hardened (you could
> say it is the 2nd oldest, behind UNH's :), allocating LIO-Core SE tasks
> (that then get issued to LIO-Core subsystem plugins) from a SCSI CDB
> with sectors+offset for ICF_SCSI_DATA_SG_IO_CDB, or a generically
> emulated SCSI control CDB or logic in LIO-Core, or using LIO-Core/PSCSI
> to let the underlying hardware do its thing, but still fill in the holes
> so that *ANY* SCSI subsystem, including from different OSes, can talk
> with storage objects behind LIO-Core when running in initiator mode
> amoungst the possible fabrics.   Some of the classic examples here are:
> 
> *) Because the Solaris 10 SCSI subsystem requiring all iSCSI devices to
> have EVPD information, otherwise LUN registration would fail.  This
> means that suddently struct block_device and struct file need to have
> WWN information, which may be DIFFERENT based upon if said object was a
> Linux/MD or LVM block device, for example.
> 
> *) Every cluster design that required block level shared storage needs
> to have at least SAM-2 Reservations.
> 
> *) Exporting via LIO-Core Hardware RAID adapters on OSes where
> max_sectors cannot be easily changed.  This is because some Hardware
> RAID requires a smaller struct scsi_device->max_sector to handle smaller
> stripe sizes for their arrays.
> 
> *) Some adapters in drivers/scsi which are not REAL SCSI devices emulate
> none/some WWN or control logic mentioned above.  I have had to do a
> couple of hacks over the years in LIO-Core/PSCSI to make everything
> place nice going to the client side of the cloud, check out
> iscsi_target_pscsi.c:pscsi_transport_complete() to see what I mean.

I meant something different: interface between target drivers and SCSI 
target core. Here (seems) you are going to have big troubles when you 
try to add not-iSCSI transport, like FC, for instance.

>>  And this is a real showstopper for making LIO-Core 
>> the default and the only SCSI target framework. SCST is SCSI-centric, 
> 
> Well, one needs to understand that LIO-Core subsystem API is more than a
> SCSI target framework.  Its a generic method of accessing any possible
> storage object of the storage stack, and having said engine handle the
> hardware restrictions (be they physical or virtual) for the underlying
> storage object.  It can run as a SCSI engine to real (or emualted) SCSI
> hardware from linux/drivers/scsi, but the real strength is that it sits
> above the SCSI/BLOCK/FILE layers and uses a single codepath for all
> underlying storage objects.  For example in the lio-core-2.6.git tree, I
> chose the location linux/drivers/lio-core, because LIO-Core uses 'struct
> file' from fs/, 'struct block_device' from block/ and struct scsi_device
> from drivers/scsi.

SCST and iSCSI-SCST, basically, do the same things, except iSCSI MC/S 
and related, + something more, like 1-to-many pass-through and 
scst_user, which need a big chunks of code, correct? And they are 
together about 2 times smaller:

$ find core-iscsi/svn/trunk/target/target -type f -name "*.[ch]"|xargs wc
59764  163202 1625877 total
+
$ find core-iscsi/svn/trunk/target/include -type f -name "*.[ch]"|xargs
2981  9316 91930 total
=
62745      1717807

vs

$ find svn/trunk/scst -type f -name "*.[ch]"|xargs wc
28327  77878 734625 total
+
$ find svn/trunk/iscsi-scst/kernel -type f -name "*.[ch]"|xargs wc
7857  20394 194693 total
=
36184        929318

Or did I count incorrectly?

> Its worth to note that I am still doing the re-org of LIO-Core and
> LIO-Target v3.0.0, but this will be coming soon along with the first non
> traditional iSCSI packets to run across LIO-Core.
> 
>> just because there's no way to make *SCSI* target framework not being 
>> SCSI-centric. Nobody blames Linux SCSI (initiator) mid-layer for being 
>> SCSI-centric, correct?
> 
> Well, as we have discussed before, the emulation of the SCSI control
> path is really a whole different monster, and I am certainly not
> interested in having to emulate all of the t10.org standards
> myself. :-)  

Sure, there optional things. But there are also requirements, which must 
be followed. So, this isn't about interested or not, this is about must 
do or don't do at all.

>>   - Seems, it's a bit overcomplicated, because it has too many abstract 
>> interfaces where there's not much need it them. Having too many abstract 
>> interfaces makes code analyze a lot more complicated. For comparison, 
>> SCST has only 2 such interfaces: for target drivers and for backstorage 
>> dev handlers. Plus, there is half-abstract interface for memory 
>> allocator (sgv_pool_set_allocator()) to allow scst_user to allocate user 
>> space supplied pages. And they cover all needs.
> 
> Well, I have discussed why I think the LIO-Core design (which was more
> neccessity at the start) has been able to work with for all kernel
> subsystems/storage objects on all architectures for v2.2, v2.4 and v2.6
> kernels.  I also mention these at the 10,000 ft level in my LSF 08'
> pres.  

Nobody in the Linux kernel community is interested to have obsolete or 
unneeded for the current kernel version code in the kernel, so if you 
want LIO core be in the kernel, you will have to make a major cleanup.

Also, see the above LIO vs SCST size comparison. Is the additional code 
all about the obsolete/currently unneeded features?

>>   - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
>> relationship, as it used to be in STGT (now in STGT support for 
>> pass-through mode seems to be removed), which isn't mentioned anywhere.
>>
> 
> Please be more specific by what you mean here.  Also, note that because
> PSCSI is an LIO-Core subsystem plugin, LIO-Core handles the limitations
> of the storage object through the LIO-Core subsystem API.  This means
> that things like (received initiator CDB sectors > LIO-Core storage
> object max_sectors) are handled generically by LIO-Core, using a single
> set of algoritims for all I/O interaction with Linux storage systems.
> These algoritims are also the same for DIFFERENT types of transport
> fabrics, both those that expect LIO-Core to allocate memory, OR that
> hardware will have preallocated memory and possible restrictions from
> the CPU/BUS architecture (take non-cache coherent MIPS for example) of
> how the memory gets DMA'ed or PIO'ed down to the packet's intended
> storage object.

See here: 
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06911.html

>>   - There is some confusion in the code in the function and variable 
>> names between persistent and SAM-2 reservations.
> 
> Well, that would be because persistent reservations are not emulated
> generally for all of the subsystem plugins just yet.  Obviously with
> LIO-Core/PSCSI if the underlying hardware supports it, it will work.

What you did (passing reservation commands directly to devices and 
nothing more) will work only with a single initiator per device, where 
reservations in the majority of cases are not needed at all. With 
multiple initiators, as it is in clusters and where reservations are 
really needed, it will sooner or later lead to data corruption. See the 
referenced above message as well as the whole thread.

>>> The more in fighting between the
>>> leaders in our community, the less the community benefits.
>> Sure. If my note hurts you, I can remove it. But you should also remove 
>> from your presentation and the summary paper those psychological 
>> arguments to not confuse people.
>>
> 
> Its not about removing, it is about updating the page to better reflect
> the bigger picture so folks coming to the sight can get the latest
> information from last update.

Your suggestions?

> Many thanks for your most valuable of time,
> 
> --nab
> 
> 
> 

