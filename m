From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic
	target engine for Linux v2.6.32
Date: Mon, 21 Sep 2009 08:38:56 -0700
Message-ID: <1253547536.26893.21.camel@haakon2.linux-iscsi.org>
References: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
	 <4AB76BBB.3040703@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:38571 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822AbZIUPiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Sep 2009 11:38:55 -0400
In-Reply-To: <4AB76BBB.3040703@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Daniel Walker <dwalker@fifo99.com>

On Mon, 2009-09-21 at 16:04 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 09/19/2009 02:07 AM wrote:
> > Greetings all,
> > 
> > This is the second round of request for comments for TCM/ConfigFS v3.2 from lio-core-2.6.git.
> > Thanks to the folks who made comments, and I again invite people to take a look and make
> > recommendations on how the code can be futher improved to use the best available upstream
> > interfaces.
> > 
> > Also, the standalone patches for TCM v3.2 are now available from:
> > 
> > http://kernel.org/pub/linux/kernel/people/nab/target_core_mod-patches/
> > 
> > The first posting from 09112009 can be found here:
> > 
> > http://marc.info/?l=linux-kernel&m=125272088024636
> > 
> > The changelog since the posting on 09112009, which can be found here:
> > 
> > *) Convert to struct mutex for struct sempahore initialized with init_MUTEX() (mentioned by Daniel Walker)
> > *) Convert to struct completion for struct semaphore initialized with init_MUTEX_LOCKED() (mentioned by Daniel Walker)
> > *) Convert to use Kbuild instead of Makefile for drivers/target/ (mentioned by Boaz Harrosh)
> > *) Use include/asm-generic/div64.h for unsigned long long division on 32-bit architectures
> > *) Use include/linux/math64.h for unsigned long long modulo on 32-bit architectures
> > 
> > The lio-core-2.6.git tree can be found here:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> > 
> > More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:
> > 
> > http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
> > http://www.linux-iscsi.org/index.php/Persistent_Reservations
> > http://www.linux-iscsi.org/index.php/ALUA
> > 
> > The complete v3.x TCM CLI operations set can be found here:
> > 
> > http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations
> > 
> > Instructions and examples for getting setup:
> > 
> > http://www.linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
> > http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod
> 
> Nicholas,
> 
> In the previous iteration of this patchset I asked you some essential 
> questions about what advantages TCM has over STGT which can't be 
> implemented in STGT and can justify the move from it to TCM, as well as 
> how did you test TCM to claim that TCM is generic and, hence, can work 
> with hardware target adapters (http://lkml.org/lkml/2009/9/15/315). 
> There was no reply answering those questions, instead you keep pushing 
> your patches.

I am ignoring you because you ask questions that yourself have already
answered.  (why having certain drivers in kernel vs. user target mode
implementations make more sense than others).

I also ignore you because you never seem to be able to cite code
references when you make a claim when you say that TCM is not generic in
nature.  So, until you can provide me with source file + line
references, I will continue to dismiss your claims as handwaving.

>  (In fact, I received privately even 2 very emotional and 
> offensive replies from Nicholas Bellinger.)
> 

Yes, I am certainly not going to flame you in public with a long CC
list.

> So, since there is no reply, I didn't miss anything and there are no 
> points to justify the move from STGT to TCM, and TCM is "generic" only 
> for software iSCSI targets.

Code references in lio-core-2.6.git/drivers/target please..?

> 
> For sake of completeness, I should also mention that the move from STGT 
> to TCM is not a move forward, it's a move backward, because TCM doesn't 
> allow creation of backend and target drivers in user space.
> 

Heh, I hardly think that complete support for SPC-4 TCM Persistent
Resevations with APTPL and implict/explict ALUA using ConfigFS is a
setup back.. :P

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_pr.c
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_alua.c
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_configfs.c

Anyways, the plan is to slowly remove upstream STGT as equivilent
functionality is added to TCM.  In case you missed it, I do have some
code that uses the existing STGT upstream logic, but is still a WIP and
I have not been including it into the TCM patches for review:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_stgt.c

So that means that TCM will be using the kernel <-> user API that STGT
already uses for providing userspace target drivers.

> Hopefully, somebody more authoritative than I will ask you to stop 
> pushing your patches until you address the above questions.

I am not sure why you think that k.o members are not allowed to post on
a public list..?

Anyways, just as a told you in private, I am sorry that you decided to
huff and puff earlier this year about the move to configfs as preferred
method of controlling kernel-level target mode infrastructure, and
decided against you and your own communities best interests in doing so.
I have no problem working with the SCST community (or anyone) to move
forward for the benefit of all users, but until you can start bringing
real technical discussion and code review to the table, I have no
interest in working with you directly.

--nab


