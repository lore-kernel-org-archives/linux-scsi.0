From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (followup)
Date: Mon, 14 Jul 2008 22:17:47 +0400
Message-ID: <487B984B.9060403@vlnb.net>
References: <4873BCA5.10103@vlnb.net>	 <1215551354.3977.6.camel@haakon2.linux-iscsi.org>	 <48749EB2.1070902@vlnb.net>	 <1215632043.9339.89.camel@haakon2.linux-iscsi.org>	 <48765433.70604@vlnb.net>	 <1215725167.31245.104.camel@haakon2.linux-iscsi.org>	 <4877A948.6090507@vlnb.net> <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:44820 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753980AbYGNSQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 14:16:58 -0400
In-Reply-To: <1215833281.13668.94.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jeff Garzik <jeff@garzik.org>, Leonid Grossman <leonid.grossman@neterion.com>, "H. Peter Anvin" <hpa@zytor.com>, Pete Wyckoff <pw@osc.edu>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rwalker@medallion.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Mazarick <mazarick@bellsouth.net>, Andrew Morton <akpm@osdl.org>, David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@thunk.org>, Jerome Martin <tramjoe.merin@gmail.com>

Nicholas A. Bellinger wrote:
>>  So
>>> until SOMEONE actually does this first, I think that iSCSI-SCST is more
>>> of an experiment for your our devel that a strong contender for
>>> Linux/iSCSI Target Mode.
>> There are big doubts among storage experts if features I and II are 
>> needed at all, see, e.g. http://lkml.org/lkml/2008/2/5/331.
> 
> Well, jgarzik is both a NETWORKING and STORAGE (he was a networking guy
> first, mind you) expert!

Well, you can question Jeff Garzik knowledge, but just look around. How 
many are there OS'es supporting MC/S on the initiator level? I know only 
one: Windows. Neither Linux's mainline open-iscsi, nor xBSD, nor Solaris 
don't support MC/S as initiators. Only your core-iscsi supports it, but 
you abandoned its development in favor of open-iscsi and I've heard 
there are big problems to run it on the recent kernels.

Then, how many are there open source iSCSI targets supporting MC/S? 
Neither xBSD, nor Solaris have it. People simply prefer developing MPIO, 
because there are other SCSI transports and they all need multipath as 
well. Then, finally, if that multipath works well for, e.g., FC, why it 
wouldn't work also well for iSCSI?

>>  I also tend 
>> to agree, that for block storage on practice MC/S is not needed or, at 
>> least, definitely doesn't worth the effort, because:
> 
> Trying to agrue against MC/S (or against any other major part of
> RFC-3720, including ERL=2) is saying that Linux/iSCSI should be BEHIND
> what the greatest minds in the IETF have produced (and learned) from
> iSCSI.  Considering so many people are interested in seeing Linux/iSCSI
> be best and most complete implementation possible, surely one would not
> be foolish enough to try to debate that Linux should be BEHIND what
> others have figured out, be it with RFCs or running code.

A rather psychological argument again. One more "older" vs "newer"? ;)

> Also, you should understand that MC/S is more than about just moving
> data I/O across multiple TCP connections, its about being able to bring
> those paths up/down on the fly without having to actually STOP/PAUSE
> anything. Then you then add the ERL=2 pixie dust, which you should
> understand, is the result of over a decade of work creating RFC-3720
> within the IETF IPS TWG.  What you have is a fabric that does not
> STOP/PAUSE from an OS INDEPENDENT LEVEL (below the OS dependent SCSI
> subsystem layer) perspective, on every possible T/I node, big and small,
> open or closed platform.  Even as we move towards more logic in the
> network layer (a la Stream Control Transmission Protocol), we will still
> benefit from RFC-3720 as the years roll on.  Quite a powerful thing..

Still not convincing that those are worth the effort considering that 
there is MPIO implementation anyway in the OS.

To make you statements clearer, can you write what *real life* tasks the 
above going to solve, which can't be solved by MPIO?

>> 1. It is useless for sync. untagged operation (regular reads in most 
>> cases over a single stream), when always there is only one command being 
>> executed at any time, because of the commands connection allegiance, 
>> which forbids transferring data for a command over multiple connections.
> 
> This is a very Parallel SCSI centric way of looking at design of SAM.
> Since SAM allows the transport fabric to enforce its own ordering rules
> (it does offer some of its own SCSI level ones of course).  Obviously
> each fabric (PSCSI, FC, SAS, iSCSI) are very different from the bus
> phase perspective.  But, if you look back into the history of iSCSI, you
> will see that an asymmetric design with seperate CONTROL/DATA TCP
> connections was considered originally BEFORE the Command Sequence Number
> (CmdSN) ordering algoritim was adopted that allows both SINGLE and
> MULTIPLE TCP connections to move both CONTROL/DATA packets across a
> iSCSI Nexus.

No, the above isn't Parallel SCSI centric way of looking, it's a 
practical way of looking. All attempts to distribute commands between 
several cores to get better performance are helpless, if there is always 
only one being executed command at time. In this case MC/S is useless 
and brings nothing (if not makes things worse because of possible 
overhead). Only bonding can improve throughput in this case, because it 
can distribute data transfers of those single commands over several 
links, which MC/S can't do by design. And this scenario isn't rare. In 
fact, it's the most common. Just count commands coming to your target 
during single stream reads. This is why WRITEs are almost always very 
much outperform READs.

> Using MC/S with a modern iSCSI implementation to take advantage of lots
> of cores and hardware threads is something that allows one to multiplex
> across multiple vendor's NIC ports, with the least possible overhead, in
> the OS INDEPENDENT manner.  Keep in mind that you can do the allocation
> and RX of WRITE data OOO, but the actual *EXECUTION* down via the
> subsystem API (which is what LIO-Target <-> LIO-Core does, in a generic
> way) MUST BE in the same over as the CDBs came from the iSCSI Initiator
> port.  This is the only requirement for iSCSI CmdSN order rules wrt the
> SCSI Architecture Model.

Yes, I've already written that keeping commands order between several 
links is the only real advantage of MC/S. But can you name *practical* 
uses of it in block storage?

>> 2. The only advantage it has over traditional OS multi-pathing is 
>> keeping commands execution order, but on practice at the moment there is 
>> no demand for this feature, because all OS'es I know don't rely on 
>> commands order to protect data integrity. They use other techniques, 
>> like queue draining. A good target should be able itself to scheduler 
>> coming commands for execution in the correct from performance POV order 
>>   and not rely for that on the commands order as they came from initiators.
> 
> Ok, you are completely missing the point of MC/S and ERL=2. Notice how
> it works in both iSCSI *AND* iSER (even across DDP fabrics!).  I
> discussed the significant benefit of ERL=2 in numerious previous
> threads.  But they can all be neatly summerized in:
> 
> http://linux-iscsi.org/builds/user/nab/Inter.vs.OuterNexus.Multiplexing.pdf
> 
> Internexus Multiplexing is DESIGNED to work with OS dependent multipath
> transparently, and as a matter of fact, it complements it quite well, in
> a OSI (independent) method.  Its completely up to the admin to determine
> the benefit and configure the knobs.

Nicholas, seems you miss the important point: Linux has multipath 
*anyway* and MC/S can't change it.

>>  From other side, devices bonding also preserves commands execution 
>> order, but doesn't suffer from the connection allegiance limitation of 
>> MC/S, so can boost performance ever for sync untagged operations. Plus, 
>> it's pretty simple, easy to use and doesn't need any additional code. I 
>> don't have the exact numbers of MC/S vs bonding performance comparison 
>> (mostly, because open-iscsi doesn't support MC/S, but very curious to 
>> see them), but have very strong suspicious that on modern OS'es, which 
>> do TCP frames reorder in zero-copy manner, there shouldn't be much 
>> performance difference between MC/S vs bonding in the maximum possible 
>> throughput, but bonding should outperform MC/S a lot in case of sync 
>> untagged operations.
> 
> Simple case here for you to get your feet wet with MC/S.  Try doing
> bonding across 4x GB/sec ports on 2x socket 2x core x86_64 and compare
> MC/S vs. OS dependent networking bonding and see what you find. There
> about two iSCSI initiators for two OSes that implementing MC/S and
> LIO-Target <-> LIO-Target.  Anyone interested in the CPU overhead on
> this setup between MC/S and Link Layer bonding across 2x 2x 1 Gb/sec
> port chips on 4 core x86_64..?

I think, everybody interested to see those numbers. Do you have any?

>> Anyway, I think features I and II, if added, would increase iSCSI-SCST 
>> kernel side code not more than on 5K lines, because most of the code is 
>> already there, the most important part which missed is fixes of locking 
>> problems, which almost never add a lot of code.
> 
> You can think whatever you want.  Why don't you have a look at
> lio-core-2.6.git and see how big they are for yourself.

I almost doubled the iSCSI-SCST in-kernel size by that estimation 
(currently it's 7.8K lines long)

>>  Relating Core-iSCSI-DV, 
>> I'm sure iSCSI-SCST will pass it without problems among the required set 
>> of iSCSI features, although still there are some limitations, derived 
>> from IET, for instance, support for multu-PDU commands in discovery 
>> sessions, which isn't implemented. But for adding to iSCSI-SCST optional 
>> iSCSI features there should be good *practical* reasons, which at the 
>> moment don't exist. And unused features are bad features, because they 
>> overcomplicate the code and make its maintainance harder for no gain.
> 
> Again, you can think whatever you want.  But since you did not implement
> the majority of the iSCSI-SCST code yourself, (or implement your own
> iSCSI Initiator in parallel with your own iSCSI Target), I do not
> believe you are in a position to say.  Any IET devs want to comment on
> this..?

You already asked me don't do blanket statements. Can you don't make 
them yourself, please? I very much appreciate the work, which IET 
developers done, but, in fact, I had to rewrite at least 70% of in 
kernel part of IET, because of many problems, starting from:

  - Simple code quality issues, which made code auditing practically 
impossible. For instance, struct iscsi_cmnd has field pdu_list, which 
used in different part of the code both as list and list entry. Now, how 
many time would you need to find out in a random code place how it 
should be used, as list entry or list? And how big is the probability to 
guess wrongly? I suspect, such issues is the main reason why development 
of IET was frozen at some point. It's simply impossible to tell looking 
at a patch touching the corresponding code if it's correct or not.

to more sophisticated problems like:

  - a Russian roulette with VMware, mentioned there: 
http://communities.vmware.com/thread/53797?tstart=0&start=15. BTW, LIO 
target isn't affected by that simply by accident, because of the reset 
SCSI violation, which I already mentioned.

I also had to considerably change the user space part, particularly, 
iSCSI negotiation, because interpretation of the iSCSI RFC, which IET 
has, forces it to use by default very inoptimal values.

Now guess, was I able to do that without sufficient understanding of 
iSCSI or not?

Actually, if I had known about open source LIO iSCSI target 
implementation, I would have chosen it, not IET as the base. And now we 
wouldn't have a point to discuss ;)

>>>>>>   - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
>>>>>> relationship, as it used to be in STGT (now in STGT support for 
>>>>>> pass-through mode seems to be removed), which isn't mentioned anywhere.
>>>>>>
>>>>> Please be more specific by what you mean here.  Also, note that because
>>>>> PSCSI is an LIO-Core subsystem plugin, LIO-Core handles the limitations
>>>>> of the storage object through the LIO-Core subsystem API.  This means
>>>>> that things like (received initiator CDB sectors > LIO-Core storage
>>>>> object max_sectors) are handled generically by LIO-Core, using a single
>>>>> set of algoritims for all I/O interaction with Linux storage systems.
>>>>> These algoritims are also the same for DIFFERENT types of transport
>>>>> fabrics, both those that expect LIO-Core to allocate memory, OR that
>>>>> hardware will have preallocated memory and possible restrictions from
>>>>> the CPU/BUS architecture (take non-cache coherent MIPS for example) of
>>>>> how the memory gets DMA'ed or PIO'ed down to the packet's intended
>>>>> storage object.
>>>> See here: 
>>>> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06911.html
>>>>
>>> <nod>
>>>
>>>>>>   - There is some confusion in the code in the function and variable 
>>>>>> names between persistent and SAM-2 reservations.
>>>>> Well, that would be because persistent reservations are not emulated
>>>>> generally for all of the subsystem plugins just yet.  Obviously with
>>>>> LIO-Core/PSCSI if the underlying hardware supports it, it will work.
>>>> What you did (passing reservation commands directly to devices and 
>>>> nothing more) will work only with a single initiator per device, where 
>>>> reservations in the majority of cases are not needed at all.
>>> I know, like I said, implementing Persistent Reservations for stuff
>>> besides real SCSI hardware with LIO-Core/PSCSI is a TODO item.  Note
>>> that the VHACS cloud (see below) will need this for DRBD objects at some
>>> point.
>> The problem is that persistent reservations don't work for multiple 
>> initiators even for real SCSI hardware with LIO-Core/PSCSI and I clearly 
>> described why in the referenced e-mail. Nicholas, why don't you want to 
>> see it?
> 
> Why don't you provide a reference in the code to where you think the
> problem is, and/or problem case using Linux iSCSI Initiators VMs to
> demonstrate the bug..?

I described the problem in the referenced e-mail pretty well. Do you 
have problems with reading and understanding it?

>>>>>>> The more in fighting between the
>>>>>>> leaders in our community, the less the community benefits.
>>>>>> Sure. If my note hurts you, I can remove it. But you should also remove 
>>>>>> from your presentation and the summary paper those psychological 
>>>>>> arguments to not confuse people.
>>>>>>
>>>>> Its not about removing, it is about updating the page to better reflect
>>>>> the bigger picture so folks coming to the sight can get the latest
>>>>> information from last update.
>>>> Your suggestions?
>>>>
>>> I would consider helping with this at some point, but as you can see, I
>>> am extremly busy ATM.  I have looked at SCST quite a bit over the years,
>>> but I am not the one making a public comparision page, at least not
>>> yet. :-)  So until then, at least explain how there are 3 projects on
>>> your page, with the updated 10,000 ft overviews, and mabye even add some
>>> links to LIO-Target and a bit about VHACS cloud.  I would be willing to
>>> include info about SCST into the Linux-iSCSI.org wiki.  Also, please
>>> feel free to open an account and start adding stuff about SCST yourself
>>> to the site.
>>>
>>> For Linux-iSCSI.org and VHACS (which is really where everything is going
>>> now), please have a look at:
>>>
>>> http://linux-iscsi.org/index.php/VHACS-VM
>>> http://linux-iscsi.org/index.php/VHACS
>>>
>>> Btw, the VHACS and LIO-Core design will allow for other fabrics to be
>>> used inside our cloud, and between other virtualized client setups who
>>> speak the wire protocol presented by the server side of VHACS cloud.
>>>
>>> Many thanks for your most valuable of time,
>>>
> 
> New v0.8.15 VHACS-VM images online btw.  Keep checking the site for more details.
> 
> Many thanks for your most valuable of time,
> 
> --nab
> 
> 
> 

