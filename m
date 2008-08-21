From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
 The Future of Target mode and Cloud storage on Linux
Date: Thu, 21 Aug 2008 23:42:51 +0400
Message-ID: <48ADC53B.6090501@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:41803 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbYHUTme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 15:42:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ksummit-2008-discuss@lists.linux-foundation.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>

(My apologies that I'm late to this discussion. I wasn't subscribed to 
ksummit-2008-discuss, so wasn't aware about it. Big thanks to Nicholas 
who pointed me on it. For the same reason I will reply to all related 
messages at once. Sorry, I wasn't able to restore all the CC's. I hope, 
nobody would object that I added scst-devel and linux-scsi mailing lists 
on CC. I added them, because I understand that ksummit-2008-discuss 
mailing list isn't the best place for such discussion.)

> The main complaint about STGT is that it's mostly based in user space.
> With the big objection being that this makes it hard to share the
> in-kernel packet processing pieces between the in-kernel initiators and
> the in-user targets.  (Conversely, this in userspace thing is one reason
> why developers like STGT: it's easy to get at the protocol stacks and
> inject things).

Unfortunately, you keep ignoring the essential point that STGT is 
fundamentally based on microkernel-like distributed processing 
architecture, from which Linux gone from the very beginning, because it 
makes things a lot more complicated for virtually no gain. See below 
about buffers memory manager problem as an example of such 
overcomplication. As soon as there is a boundary in processing, there 
are immediately all that boundary related troubles.

> The solution that seemed to secure agreement at the storage summit was
> to enhance STGT with the in-kernel pieces of SCST to allow for both
> in-user and in-kernel targets depending on what the stack user
> wanted ... but I've seen no patches for this.

No surprises, because it is practically impossible. A SCSI target core, 
basically, consist from 3 parts: (1) SCSI target state machine, (2) 
buffers memory manager and (3) commands execution backend. The 
fundamental difference between SCST and STGT, which makes them so widely 
incompatible is the buffers memory manager. In SCST it's fully in the 
kernel, but for STGT it's in the user space. Direct consequence of this 
that the user space must be able to see buffers, so many optimizations, 
like putting pages directly to page cache, are impossible for security 
reasons. Additionally, the buffers memory manager is a central piece of 
code around which the whole SCSI target engine is built. Parts of code 
from SCST would be compatible with STGT only when the whole memory 
manager would be moved in STGT from user space to kernel space together 
with all related SCSI target state machine states, which in turn carry 
almost all other target states to the kernel. But then the questions 
would arise: "What's left for user space?" and "What's the difference 
with SCST"?

> The problem is that there are two separate constituencies for a target
> mode implementation
> 
>      1. People who need target mode to hack on storage fabrics. For them
>         a user mode implementation is much more easily hackable than a
>         kernel one.
>      2. People who want maximal efficiency in the target.  For them,
>         shoving everything into the kernel seems to be the best thing to
>         do.
> 
> The problem is that the currently upstream STGT implementation satisfies
> the first constituency.  The loud clamour for upstreaming SCST is to
> satisfy the second.  Amazingly enough, I think both constituencies have
> a right to a solution.  I also don't think two separate solutions with
> non overlapping code bases in the kernel is the right thing to do, so
> what I'd like is for us to evolve the existing solution into something
> that will work for both (by taking pieces of the out of SCST and placing
> them into STGT).
> 
> The problem is that proponents of constituency number 2 term the code
> for constituency 1 "flawed" because they don't see anything in user
> space satisfying their efficiency need.  Until we can get past this
> either 1 or 2 mentality there is going to be no progress because
> "progress" is offered as take it or leave it solutions for either
> constituency.
> 
> The solution I offered that I think might satisfy both is the ability to
> run pieces of the current STGT in-kernel to get the efficiency gains.  I
> haven't heard any other solutions proposed that would satisfy both ...
> unless I've missed something?

James, you missed that SCST for a long time has support for implementing 
backstorage devices in the user space. This is provided through 
backstorage device handler called scst_user. You can find its interface 
description in http://scst.sourceforge.net/scst_user_spec.txt and the 
example code in http://scst.sourceforge.net/handler_fileio_tgt.html. And 
one interesting point about it that it's more efficient than STGT, 
because SCST has memory manager in kernel, which eliminates the need in 
constant malloc()/get_user_pages()/free() calls on each SCSI command and 
allows on average only one context switch and one user-kernel switch per 
command. At least two companies sell VTLs based on SCST/scst_user and 
several developing their products.

Thus, SCST satisfies both kinds of people: ones who need maximal 
efficiency and ones who want more easily hackable implementation of 
their devices.

If all necessary pieces of STGT moved in the kernel, it would become 
pretty much the same as SCST at the moment. Then, for what all that 
effort would be? How many years would it take? Wouldn't it be simpler to 
grab already existing program, than to solve already solved problems one 
more time?

> The basic comment is that since we've already discussed it at the
> storage summit, and there's been no code progress at all since that
> time, what benefit is to be gained by airing it with a wider audience
> (particularly a less storage centric one)?

Related to SCST, I'm going to submit it together with 3 target drivers 
(for iSCSI, FC and SRPT transports) for review and inclusion after I 
return from vacation in the second half of September. Almost all is 
already ready for that, I simply don't want to disappear in the middle 
of discussion.

> Should the generic target mode be based on SCSI (like SCST), or, should
> it sit _ABOVE_ drivers/scsi, and allow for a generic method for both
> SCSI and non SCSI based transports. 

I proposed for a SCSI target a separate subsystem, which I described in 
http://lkml.org/lkml/2008/5/2/348 and http://lkml.org/lkml/2008/5/4/160. 
There is almost no common between regular (initiator) SCSI and target 
subsystems. Relations between them similar to relations between regular 
SCSI and block subsystems. Hence, there is no point to keep them 
together. It would be better if they are separated with separate 
maintainers.

> I believe the LIO-Core algoritims
> for allocation of linked list pages subsystem dependent memory are ideal
> for the latter, which is what should be the princaple topic discussion
> regardless kernel-level generic target mode infrastructure.   That is,
> common code that can be used for both target mode iSCSI, FC, FCoE,
> PSCSI, AoE and SATA.

I've also thought how to make SCST core useful for non-SCSI transports, 
namely AoE. It seems to me that the best way would be if for all AoE 
commands AoE target driver (let's use SCSI terms) would submit to SCST 
core the corresponding generated by it SCSI CDBs. Since ATA can be 
considered as a functional subset of SCSI, such approach should work 
pretty well. Other transports (FCoE and SATA) are, basically, SCSI, so 
they can be used directly.

> Hmm, really? STGT development is more active IET.

Tomo-san, be honest. It was *you*, who stopped the IET development, 
forcing people to switch to STGT. There is no point to prepare patches 
for IET, if they will never get merged.

> That sounds like a perfect topic for the scsi mailing list, why not take
> it there right now and get it resolved this week?

I agree. Simply there are too few people who simply understand what 
"SCSI target" means and there are no big chances to have sufficient 
amount of them there.

Vlad
