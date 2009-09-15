From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC PATCH 0/19] A kernel-level configfs enabled generic	target
 engine for Linux v2.6.32
Date: Tue, 15 Sep 2009 22:08:35 +0400
Message-ID: <4AAFD823.3050309@vlnb.net>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>	 <4AAE907E.1020205@vlnb.net> <1252961396.2067.316.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIOSIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 14:08:39 -0400
In-Reply-To: <1252961396.2067.316.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

Nicholas A. Bellinger, on 09/15/2009 12:49 AM wrote:
> On Mon, 2009-09-14 at 22:50 +0400, Vladislav Bolkhovitin wrote:
>> Nicholas A. Bellinger, on 09/12/2009 05:55 AM wrote:
>>> Greetings all,
>>>
>>> This is my humble request for review and inclusion of
>>> Target_Core_Mod/ConfigFS v3.2 from lio-core-2.6.git code into mainline
>>> v2.6.32.  With TCM v3.2, the two major SPC-4 SCSI target mode fabric
>>> features that have now been completed: Persistent Reservation APTPL and
>>> implict/explict ALUA are the first all optional SPC4 defined feature
>>> implementation of PR and ALUA in the Linux OSS target theatre using an
>>> upstream user-driven virtual filesystem directory hierarchy structure
>>> based on configfs that can be configured in realtime in combination with
>>> interpreted userspace code.
>>>
>>> Both of these new features are now being used to provide Persistent Reservations
>>> across target power loss and asymmetric multipath I/O to both Linux and non-Linux
>>> clients.  There is also an optional ALUA transition delay logic that has been
>>> included to futher debug and improve existing upstream client side Linux kernel code
>>> using TCM v3.2. These patches have been diffed against v2.6.31, and tested on x86
>>> 32-bit HVM, x86_64 KVM, and powerpc.
>>>
>>> There is cleanup work continuing to make the TCM code to use dprintk(),
>>> and some include cleanups, and other minor fixes.  The code has also
>>> been run through checkpatch again since the posting in April, and all
>>> errors have been removed, with the exception of one ConfigFS macro
>>> define triggering a checkpatch false positive.
>>>
>>> As with the posting of the TCM v3.0 code earlier in April, I have
>>> decided to break up the submissions into the generic target_core_mod
>>> piece (this patch series) and then a seperate one that will be appearing
>>> in the next days for v3.2 of the LIO-Target iSCSI fabric module.
>>>
>>> More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:
>>>
>>> http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
>>> http://www.linux-iscsi.org/index.php/Persistent_Reservations
>>> http://www.linux-iscsi.org/index.php/ALUA
>>>
>>> The complete v3.x TCM CLI operations set can be found here:
>>>
>>> http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations
>>>
>>> Instructions and examples for getting setup:
>>>
>>> http://linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
>>> http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod
>> Some questions among many I have:
>>
>> 1. Where and how TCM is better over the existing mainline target 
>> framework STGT to justify such a move as adding a new piece of code 
>> doing the same job?
> 
> I think from reading my original email and the list of patches it is
> quite obvious to the people involved what are the major pieces of
> functionality available in TCM v3.2 that people actually *want* and
> *care* about that is not available in the existing STGT framework.

Probably, I'm not sufficiently smart, but benefits of "TCM v3.2" aren't 
obvious for me at all. Could you list them point by point?

Especially interesting, why the above mentioned features can't be added 
in the STGT instead of creating something a whole new?

>> 2. On the linux-iscsi.org main page (BTW, the comparison on that page 
>> isn't fully correct about STGT and SCST) you claim that TCM is a generic 
>> target engine. But how can you prove (and test) that if there are no 
>> hardware target drivers for TCM?
> 
> I am not sure why you think you need hardware target drivers to prove
> that a target engine is generic..?  Why don't you look at the TCM v3.2
> code (like everyone else is doing) and see for yourself..?

I looked there many times. Hardware target drivers fundamentally 
different from software drivers, because they need to do some processing 
on IRQ level. You can't test the corresponding target's framework 
branches and prove they provide sufficient functionality using a driver, 
which doesn't need such functionality.

>> Also patch 7 implements MIBs through procfs. Procfs is for long time 
>> forbidden for adding anything like that, so you can't push it in the 
>> mainline.
> 
> There are other subsystems (Linux/Net and SCTP for example) that use
> procfs for read-only MIBs statistics, so TCM actually having an
> implementation of SCSI MIBs available (no other target projects have
> SCSI MIBs btw) under procfs is hardly a show-stopper considering the
> *entire* control path for TCM v3.2 is using upstream configfs code
> anyways.

Addition of new non-process related entries in /proc is fully forbidden 
and it doesn't matter if those entries used on "control path" or in 
corner cases.

Vlad

