From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Mon, 07 May 2007 18:24:44 +0400
Message-ID: <463F36AC.3010207@vlnb.net>
References: <20070504160712.GB16528@austin.ibm.com>	<200705041704.l44H4WXa003789@mbox.iij4u.or.jp>	<463B72F6.3000207@torque.net> <20070506053629P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:59629 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445AbXEGO4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:56:51 -0400
In-Reply-To: <20070506053629P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, stgt-devel@lists.berlios.de, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
>>>>It looks like the pass-through target support is currently broken, at
>>>>least as I've checked for ibmvstgt, but I think it's a general problem.
>>>>I wanted to check my assumptions and get ideas.
>>>
>>>Yeah, unfortunately, it works only with the iSCSI target driver (which
>>>runs in user space).
>>>
>>>
>>>
>>>>The code isn't allocating any memory to pass along to the sg code to store
>>>>the result of a read or data for a write.  Currently, dxferp for sg_io_hdr
>>>>or dout_xferp/din_xferp for sg_io_v4 are assigned to the value of uaddr,
>>>>which is set to 0 in kern_queue_cmd.  With the pointer set to NULL,
>>>>the pass-through target isn't going to function.  Even if we had memory
>>>>allocated, there isn't a means of getting data to be written via sg down
>>>>this code path.
>>>>
>>>>What ideas are there as to how the data will get to user-space so that
>>>>we can use sg?
>>>
>>>For kernel-space drivers, we don't need to go to user-space. We can do
>>>the pass-through in kernel space. I talked with James about this last
>>>year and he said that if the code is implemented cleanly, he would
>>>merges it into mainline.
>>
>>We already have a pass-through in the kernel space for
>>kernel space drivers. It is the scsi_tgt* code.
> 
> 
> Could you elaborate more?
> 
> What I meant that is that the kernel tgt code (scsi_tgt*) receives
> SCSI commands from one lld and send them to another lld instead of
> sending them to user space.

Although the approach of passing SCSI commands from a target LLD to an
initiator one without any significant interventions from the target
software looks to be nice and simple, you should realize how limited,
unsafe and illegal it is, since it badly violates SCSI specs.

Before I elaborate, let's have the following terminology in addition to
one described in SAM:

  - Target system - the overall system containing target and initiator
devices (and their LDDs). Target system exports one or more initiator
devices via the target device(s).

  - Target device - a SCSI device on the target system in the target mode.

  - Initiator device - a SCSI device on the target system in the
initiator mode. It actually serves commands that come from remote
initiators via target device(s).

  - Remote initiator - a SCSI initiator device connected to the target
device on the target system and uses (i.e. sends SCSI commands) exported
by it devices.

  - Target software - software that runs on the target system and
implements the necessary pass-through functionality

Let's consider a simplest case when a target system has one target
device, one initiator device and it exports the initiator device via the
target device as pass-through. The problem is that then the target
system creates a new SCSI target device, which is not the same as the
exported initiator device. Particularly, the new device could have >1
nexuses with remote initiators connected to it, while the initiator
device has no glue about them, it sees a single nexus with the target
system and only it.

And so? All the event notifications, which should be seen by all remote
initiators will be delivered to only one of them or not generated at
all, since some events are generated only for I_T nexuses other, than
one on which the command causing the event is received. The most common
example of such events is Unit Attentions. For example, after MODE
SELECT command, all remote initiators, except one, who sent the command,
shall receive "MODE PARAMETERS CHANGED" Unit Attention. Otherwise a bad
and quiet data corruption could happen.

More complicated example is SCSI reservations, doesn't matter persistent
or SPC-2 ones. Since the initiator device knows only about one nexus,
instead of actual many of them, the reservation commands should be
completely handled by target software on the target system. Having
delivery of Unit Attentions to all remote initiators especially
important for reservations, since they could mean that a reservation was
revoked by another initiator via, e.g., some task management function.

Things get even worse if we realize that (1) the initiator device could
report about its capabilities (like ACA support), which aren't supported
by the target software, hence misinform the remote initiators and again
could provoke a quiet data corruption, and (2) accesses to the initiator
devices from local programs on the target systems create another I_T
nexus, which needs to be handled as well.

(I suppose it is obvious that if the target system exports >1 initiator
devices via a single target device, since the initiator devices don't
know about each other, the target software in any case needs to
implement its own LUN addressing as well as own REPORT LUNS command
handler).

Thus, such in-kernel pass-through mode could be used only for limited
set of SCSI commands and SCSI device types with a big caution and
complete comprehension what's going on and how it should be. The latter
isn't true in the absolute majority of uses and users, so such approach
will give users a perfect weapon to shoot themselfs.

If you start addressing the above issues, I believe, you will endup with:

  - Either with complete duplicating the SCSI state machine in both user
and kernel code, eventually copying what's already done in SCST (see below)

  - Or have so complicated interactions between user space and kernel
that you will never like them (here is why:
http://lkml.org/lkml/2006/7/1/41, http://lkml.org/lkml/2007/4/24/364 and
http://lkml.org/lkml/2007/4/24/451, I totally agree with Linus),

  - Or fully drop the in-kernel pass-through and leave only the user
space one with all its drawbacks and penalties. But, I believe, in this 
case you will also have serious difficulties handling the local nexus 
case (i.e. commands originated from local applications on the target 
system) cleanly.

So, if you need in-kernel pass-through I would suggest you to look at
SCST project (http://scst.sf.net), which is currently stable and mature,
although also not fully finished yet. It was historically from the very
beginning designed for full feature in-kernel pass-through for not only
stateless SCSI devices, like disks, but also for stateful SCSI devices
(like SSC ones a.k.a. tapes), where the correct handling of all above is
essential. In additional to considerably better performance, the
complete in-kernel approach makes the code simpler, smaller and cleaner
as well as allows such things as zero-copy buffered file IO, i.e. when 
data are sent to remote initiators or received from them directly 
from/to the page cache (currently under development). For those who need 
implementing SCSI devices in the user space scst_user module is about to 
be added. Since the SCSI state machine is in kernel the interface 
provided by scst_user is very simple, it essentially consists from only 
a single IOCTL and allows to have overhead as low as a single syscall 
per SCSI command without any additional context switches. It is already 
implemented and works. For some legal reasons I can't at the moment 
publish it, but you can see its full description in the project's SVN 
docs (you can get them using command "svn co 
https://svn.sourceforge.net/svnroot/scst/trunk/doc").

Thanks to all who managed to read until this,
Vlad

P.S. This message is not to start a new flamewar, this is just an
attempt of a healthy criticism for the current mainline target approach
as well as a hope to get some healthy criticism for SCST.


