From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
Date: Sat, 29 May 2010 21:26:39 +0400
Message-ID: <4C014E4F.90206@vlnb.net>
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>	 <4BFEBCEF.8010201@vlnb.net> <1275012084.9661.66.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0E2R0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 May 2010 13:26:36 -0400
In-Reply-To: <1275012084.9661.66.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Richard Sharpe <realrichardsharpe@gmail.com>, James Smart <James.Smart@Emulex.Com>, Jeff Garzik <jeff@garzik.org>, Joel Becker <joel.becker@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Nicholas A. Bellinger, on 05/28/2010 06:01 AM wrote:
> On Thu, 2010-05-27 at 22:41 +0400, Vladislav Bolkhovitin wrote:
>> Nicholas A. Bellinger, on 05/20/2010 05:09 AM wrote:
>>> Greetings James and Co,
>>>
>>> I would like to formally request the inclusion of TCM Core v4 codebase
>>> containing the fabric independent configfs infrastructure design and
>>> TCM_Loop SCSI LLD fabric module supporting multi-fabric I_T Nexus and
>>> Port emulation for SAS, FC and iSCSI into mainline for v2.6.35
>>>
>>> The plan is to push TCM Core and the TCM_Loop LLD module for use with
>>> existing userspace applications into mainline first, and then focus on
>>> extending the upstream fabric libraries (libiscsi, libfc, libsas) for
>>> new and future TCM modules to support a common set of kernel-level
>>> target mode infrastructure for HW and SW fabric engines once the main
>>> target pieces are in place.
>>>
>>> On the userspace fabric <-> kernel backstore side, the TCM_Loop fabric
>>> module is currently running with full SPC-3 PR and ALUA support using
>>> fabric-independent virtual SCSI target port emulation with the STGT
>>> iSCSI userspace fabric code and SG_IO backstores.  TCM_Loop is also
>>> being used with SG_IO for QEMU-KVM megasas HBA emulation into Linux and
>>> MSFT x86 guests and is able to run at sustained 10 Gb/sec throughput
>>> into KVM guest.
>>>
>>> For the kernelspace fabric <-> userspace backstore side for v2.6.35, the
>>> plan is to extend the existing drivers/scsi/scsi_tgt_[lib,if].c direct
>>> mapped ring interface to the WIP kernel level TCM/STGT subsystem
>>> backstore plugin mentioned in previously on linux-scsi.  This will allow
>>> projects presenting a userspace block device to access existing TCM
>>> kernel level target module fabric drivers.
>> I've got 2 question and 1 note.
>>
>> 1. Are there any evidences that TCM has any value over STGT?
> 
> TCM provides a HBA / device model for kernel level backstores with SPC-4
> PR and ALUA logic on top of mainline Linux storage subsystems.  The TCM
> v4 design also provides a fabric independent control plane using a set
> of generic struct config_groups and fabric context dependent
> CONFIGFS_EATTR() based macros that allow for rapid development of new,
> conversion of existing, and extention of existing TCM fabric modules.
> 
> When used in combination with STGT userspace fabric modules and SG_IO
> backstore (tgt.git:usr/iscsi/ for example) and TCM_Loop Port and Nexus
> emulation, it allows any kernel level TCM backstore and associated SPC-4
> PR and ALUA logic to be made accessable to STGT fabric module code
> running in userspace.
> 
> Also, STGT currently does not contain the ability to run in SCSI LLD
> mode so it is not possible to access kernel level target functionality
> inside of a QEMU-KVM guest using virtio or the new megasas HBA
> emulation.  Using the TCM_Loop fabric module it is now possible to
> access TCM fabric independent SPC-4 logic into the virtualized guest
> with any hypervisor (kvm, xen, vmw) that properly supports scsi-generic
> and some manner of HBA emulation.

All the above can be implemented in STGT. Considering that they were 
only recently added in TCM, why they were not added in STGT instead?

>> So far, 
>> I've only read not supported words with once a reference to my effort on 
>> completely unrelated project.
> 
> I have no idea what you are talking about here.  As mentioned in my
> original email, my efforts for mainling TCM have been to extend and
> complement STGT.  In open source you have to build upon what already
> exists upstream and move forward.

This sounds very attractive, but not practical. Because of fundamental 
architectural differences, you'd end up with 2 separate somehow coupled 
subsystems doing the same things by 2 different interfaces. Definitely, 
this ugly end result would not be something which everybody liked and 
expected.

>> 2. Are there any users of this code using it in production to prove its 
>> usability and stability? I mean, used not by RisingTide and its 
>> customers, because on the RisingTide's web page it's clearly written 
>> that their target software "partially available as the open-source LIO 
>> Core target".
> libs
> Wrong.  We (RisingTide) validate and maintain a backport tree of TCM and
> LIO kernel code for our customers who do not necessarly run on bleeding
> edge kernels.

Year, you are making from the "partially available" the "fully 
available" code.

> Also just FYI, here in North America you can go into almost any major
> electronics store and purchase a storage server from multiple different
> vendors containing TCM/LIO code directly from lio-core-2.6.git/master.

Names, please.

Do you mean Netgear 
(http://old.nabble.com/Re%3A-Invalid-module-format---no-symbol-version-formodule_layout-p27116634.html)?

Anyway, it is apparent that open source LIO/TCM you are pushing has none 
or very few production users and there are no signs it is changing. 
Users prefer alternative solutions.

Moreover, I have not seen any positive reference about production usage 
of LIO/TCM anywhere, the only reference I've seen so far was the above 
negative feedback about the Netgear experience.

> But you should really understand that the 'who is using what' has never
> been a strong agruement for mainline acceptance of any project.

Size of the users base has always been one of the main arguments.

>>  As we can see Linux-iSCSI.org development mailing list 
>> (http://groups.google.com/group/linux-iscsi-target-dev?hl=en) has near 
>> zero activity.
> 
> Wrong again.  The LIO-devel list contains series after series of
> bisectable commits that are posted in a human readable and reviewable
> manner.  All of the interesting commits related to the v4 configfs
> design and port of LIO-Target, TCM_FC, and TCM_Loop fabric modules have
> been posted to linux-scsi over the last months as well.

Year, you are the one making traffic there.

>> The note is that the idea to use the STGT's scsi_tgt_[lib,if].c direct 
>> mapped ring interface to extend TCM in the user space and allow present 
>> STGT's user space devices to work with TCM is unpractical, because the 
>> STGT's interface and devices are built around SCSI target state machine 
>> and memory management in the user space, while TCM has them both in the 
>> kernel.
> 
> I think you are misunderstanding what the TCM STGT backstore subsystem
> plugin at lio-core-2.6.git/drivers/target/target_core_stgt.c is supposed
> to do, and what I have proposed with the second area of TCM and STGT
> compatibility.

Nicholas,

I have been working in area of SCSI targets since 2003, I have created 
the best OSS SCSI target subsystem which is widely used and getting 
better and better every day. I am one of few people among recipients of 
this thread who has sufficient knowledge and experience to be able see 
the whole picture and be able to evaluate quality and consequences of 
the code and architectural decisions in this area. (Even deep experience 
in SCSI initiator side development is not quite sufficient for that, 
because SCSI initiator and target sides solve completely different tasks 
[1].) If something isn't clear for me, I can simply look in the source 
code and quickly find out the answers.

<MOANING ON>

Actually, I'd prefer to stay away from all those TCM discussions and let 
somebody similarly skillful to judge. But, since there is no such person 
appearing, I have to participate myself to explain the real state of 
things and let people judge based on _facts_, not the marketing stuff 
you are too often presenting. So far too much of what you have written 
after closer examinations turned out to be a misleading half-truth as in 
this particular case, where the end result isn't going to be what 
everybody would expect hearing about "TCM and STGT compatibility" or as 
it was before with "1 to many" pass-through which only sometimes "1 to 
many", otherwise not enforced "1 to 1", welcoming data corruption, or 
even before with Persistent Reservations which worked as expected only 
with a single connected initiator, etc.. I have to explain everybody for 
who it isn't obvious what is true and what is NOT true in your 
"half-truth". Competition is a good thing, but without all those 
undercover dirty marketing games which I'm really tired. They are 
disgusting.

<MOANING OFF>

> We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
> allow TCM to access userspace backstores transparently with existing
> kernel level TCM fabric modules, and using the generic configfs fabric
> module infrastructure in target_core_fabric_configfs.c for the port and
> I_T nexus control plane just as you would with any TCM backstore
> subsystem today.
> 
> Again, in open source you have to build upon what already exists and
> move forward.  The original STGT kernel <-> userspace ring abstraction
> and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
> scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
> what is required for handling fabric I/O processing and I_T Nexus and
> Port management in kernel space with a userspace backstore.  It is
> really just a matter of allowing the STGT ring request to optionally be
> sent out to userspace as a standalone LUN instead of as a target port.

You'd end up in one of 2 options:

1. You'd make TCM to pass-through requests from its target drivers 
("fabric modules" in your terminology) directly to the STGT core in the 
user space bypassing TCM's internal memory management and target state 
machine, i.e. effectively make them behave as STGT target drivers. As 
the result, we would have 2 separate interfaces (TCM and STGT) doing the 
same thing as well as 2 sets of target drivers and 2 sets of backend 
handlers from each interface. That apparently wouldn't be a Linux's way 
of doing things. It wouldn't be moving forward, it would be moving in 
the maintenance hell.

2. You'd just throw away existing STGT messages and add new ones. Then 
add in STGT a big "TCM compatibility" level to make STGT and it's 
backend be able to use the new messages and work with new model with 
memory management and target state machine in the kernel. Obviously, it 
would be even uglier than (1).

But it's an Open Source, so you can do whatever you want. Show us the 
code and we will see. My intention is only to _warn_ people that they 
shouldn't count on your (marketing) plans, because there are fundamental 
reasons preventing them be implemented in an acceptable way.

Also I should note that the decision to extend the fabric libraries by 
additional target mode specific routines is a very bad move. I already 
covered this topic in http://lkml.org/lkml/2008/12/10/245. In short, 
SCSI initiator and target sides share nearly nothing in the processing 
code [2], so they should be separated to keep different things 
separately, as a good design practice required, not to heap them 
altogether as it's currently done and you are going to continue. Good 
example of how it is already done is NFS client (fs/nfs/) and server 
(fs/nfsd/), which share only few ACL processing routines in fs/nfs_common/.

Vlad

[1] SCSI initiator and target are a client and a server correspondingly, 
where one is generating requests and parsing responses, another one 
parsing requests and generating responses, so they have very few in 
common. Like apache (server) and links/firefox (client), or sendmail 
(server) and mutt/thunderbird (client).

[2] Initiator and target modes share only (1) constants, (2) low level 
memory processing and mapping routines. Both of them already separated 
out in the headers and the block subsystem. In case if a hardware 
supports both initiator and target modes at the same time, the target 
mode support should be done as an add-on through a set of hooks exported 
by the corresponding initiator module for the hardware to allow the 
target add-on to process target mode commands from the hardware. This 
way code for both modes would be clearly separated and it would allow to 
load the target mode add-on only when it is needed.
