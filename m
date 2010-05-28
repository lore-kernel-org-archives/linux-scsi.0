From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
Date: Thu, 27 May 2010 19:01:24 -0700
Message-ID: <1275012084.9661.66.camel@haakon2.linux-iscsi.org>
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
	 <4BFEBCEF.8010201@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45988 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755132Ab0E1CBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 22:01:34 -0400
In-Reply-To: <4BFEBCEF.8010201@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Richard Sharpe <realrichardsharpe@gmail.com>, James Smart <James.Smart@Emulex.Com>, Jeff Garzik <jeff@garzik.org>, Joel Becker <joel.becker@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, 2010-05-27 at 22:41 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 05/20/2010 05:09 AM wrote:
> > Greetings James and Co,
> > 
> > I would like to formally request the inclusion of TCM Core v4 codebase
> > containing the fabric independent configfs infrastructure design and
> > TCM_Loop SCSI LLD fabric module supporting multi-fabric I_T Nexus and
> > Port emulation for SAS, FC and iSCSI into mainline for v2.6.35
> > 
> > The plan is to push TCM Core and the TCM_Loop LLD module for use with
> > existing userspace applications into mainline first, and then focus on
> > extending the upstream fabric libraries (libiscsi, libfc, libsas) for
> > new and future TCM modules to support a common set of kernel-level
> > target mode infrastructure for HW and SW fabric engines once the main
> > target pieces are in place.
> > 
> > On the userspace fabric <-> kernel backstore side, the TCM_Loop fabric
> > module is currently running with full SPC-3 PR and ALUA support using
> > fabric-independent virtual SCSI target port emulation with the STGT
> > iSCSI userspace fabric code and SG_IO backstores.  TCM_Loop is also
> > being used with SG_IO for QEMU-KVM megasas HBA emulation into Linux and
> > MSFT x86 guests and is able to run at sustained 10 Gb/sec throughput
> > into KVM guest.
> > 
> > For the kernelspace fabric <-> userspace backstore side for v2.6.35, the
> > plan is to extend the existing drivers/scsi/scsi_tgt_[lib,if].c direct
> > mapped ring interface to the WIP kernel level TCM/STGT subsystem
> > backstore plugin mentioned in previously on linux-scsi.  This will allow
> > projects presenting a userspace block device to access existing TCM
> > kernel level target module fabric drivers.
> 
> I've got 2 question and 1 note.
> 
> 1. Are there any evidences that TCM has any value over STGT?

TCM provides a HBA / device model for kernel level backstores with SPC-4
PR and ALUA logic on top of mainline Linux storage subsystems.  The TCM
v4 design also provides a fabric independent control plane using a set
of generic struct config_groups and fabric context dependent
CONFIGFS_EATTR() based macros that allow for rapid development of new,
conversion of existing, and extention of existing TCM fabric modules.

When used in combination with STGT userspace fabric modules and SG_IO
backstore (tgt.git:usr/iscsi/ for example) and TCM_Loop Port and Nexus
emulation, it allows any kernel level TCM backstore and associated SPC-4
PR and ALUA logic to be made accessable to STGT fabric module code
running in userspace.

Also, STGT currently does not contain the ability to run in SCSI LLD
mode so it is not possible to access kernel level target functionality
inside of a QEMU-KVM guest using virtio or the new megasas HBA
emulation.  Using the TCM_Loop fabric module it is now possible to
access TCM fabric independent SPC-4 logic into the virtualized guest
with any hypervisor (kvm, xen, vmw) that properly supports scsi-generic
and some manner of HBA emulation.

>  So far, 
> I've only read not supported words with once a reference to my effort on 
> completely unrelated project.

I have no idea what you are talking about here.  As mentioned in my
original email, my efforts for mainling TCM have been to extend and
complement STGT.  In open source you have to build upon what already
exists upstream and move forward.

> 
> 2. Are there any users of this code using it in production to prove its 
> usability and stability? I mean, used not by RisingTide and its 
> customers, because on the RisingTide's web page it's clearly written 
> that their target software "partially available as the open-source LIO 
> Core target".

Wrong.  We (RisingTide) validate and maintain a backport tree of TCM and
LIO kernel code for our customers who do not necessarly run on bleeding
edge kernels.

Also just FYI, here in North America you can go into almost any major
electronics store and purchase a storage server from multiple different
vendors containing TCM/LIO code directly from lio-core-2.6.git/master.
But you should really understand that the 'who is using what' has never
been a strong agruement for mainline acceptance of any project.

>  So, all the RisingTide's experience isn't relevant for 
> this code.

Surely you must be joking.  Customer experience in real production
environments is invaluable for your code.

>  As we can see Linux-iSCSI.org development mailing list 
> (http://groups.google.com/group/linux-iscsi-target-dev?hl=en) has near 
> zero activity.

Wrong again.  The LIO-devel list contains series after series of
bisectable commits that are posted in a human readable and reviewable
manner.  All of the interesting commits related to the v4 configfs
design and port of LIO-Target, TCM_FC, and TCM_Loop fabric modules have
been posted to linux-scsi over the last months as well.

> 
> The note is that the idea to use the STGT's scsi_tgt_[lib,if].c direct 
> mapped ring interface to extend TCM in the user space and allow present 
> STGT's user space devices to work with TCM is unpractical, because the 
> STGT's interface and devices are built around SCSI target state machine 
> and memory management in the user space, while TCM has them both in the 
> kernel.

I think you are misunderstanding what the TCM STGT backstore subsystem
plugin at lio-core-2.6.git/drivers/target/target_core_stgt.c is supposed
to do, and what I have proposed with the second area of TCM and STGT
compatibility.

We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
allow TCM to access userspace backstores transparently with existing
kernel level TCM fabric modules, and using the generic configfs fabric
module infrastructure in target_core_fabric_configfs.c for the port and
I_T nexus control plane just as you would with any TCM backstore
subsystem today.

Again, in open source you have to build upon what already exists and
move forward.  The original STGT kernel <-> userspace ring abstraction
and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
what is required for handling fabric I/O processing and I_T Nexus and
Port management in kernel space with a userspace backstore.  It is
really just a matter of allowing the STGT ring request to optionally be
sent out to userspace as a standalone LUN instead of as a target port.

Best,

--nab

