From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 07 Feb 2008 07:38:15 -0800
Message-ID: <1202398695.1805.48.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain> <47A751C5.60600@vlnb.net>
	 <1202149322.3096.66.camel@localhost.localdomain>
	 <47A75B8A.3020503@vlnb.net>
	 <1202151293.3096.80.camel@localhost.localdomain>
	 <47A8B210.8040202@vlnb.net>
	 <1202238802.3133.71.camel@localhost.localdomain>
	 <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:26644 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754267AbYBGPjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 10:39:05 -0500
In-Reply-To: <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

On Thu, 2008-02-07 at 14:13 +0100, Bart Van Assche wrote: 
> Since the focus of this thread shifted somewhat in the last few
> messages, I'll try to summarize what has been discussed so far:
> - There was a number of participants who joined this discussion
> spontaneously. This suggests that there is considerable interest in
> networked storage and iSCSI.
> - It has been motivated why iSCSI makes sense as a storage protocol
> (compared to ATA over Ethernet and Fibre Channel over Ethernet).
> - The direct I/O performance results for block transfer sizes below 64
> KB are a meaningful benchmark for storage target implementations.
> - It has been discussed whether an iSCSI target should be implemented
> in user space or in kernel space. It is clear now that an
> implementation in the kernel can be made faster than a user space
> implementation (http://kerneltrap.org/mailarchive/linux-kernel/2008/2/4/714804).
> Regarding existing implementations, measurements have a.o. shown that
> SCST is faster than STGT (30% with the following setup: iSCSI via
> IPoIB and direct I/O block transfers with a size of 512 bytes).
> - It has been discussed which iSCSI target implementation should be in
> the mainstream Linux kernel. There is no agreement on this subject
> yet. The short-term options are as follows:
> 1) Do not integrate any new iSCSI target implementation in the
> mainstream Linux kernel.
> 2) Add one of the existing in-kernel iSCSI target implementations to
> the kernel, e.g. SCST or PyX/LIO.
> 3) Create a new in-kernel iSCSI target implementation that combines
> the advantages of the existing iSCSI kernel target implementations
> (iETD, STGT, SCST and PyX/LIO).
> 
> As an iSCSI user, I prefer option (3). The big question is whether the
> various storage target authors agree with this ?
> 

I think the other data point here would be that final target design
needs to be as generic as possible.  Generic in the sense that the
engine eventually needs to be able to accept NDB and other ethernet
based target mode storage configurations to an abstracted device object
(struct scsi_device, struct block_device, or struct file) just as it
would for an IP Storage based request.

We know that NDB and *oE will have their own naming and discovery, and
the first set of IO tasks to be completed would be those using
(iscsi_cmd_t->cmd_flags & ICF_SCSI_DATA_SG_IO_CDB) in
iscsi_target_transport.c in the current code.    These are single READ_*
and WRITE_* codepaths that perform DMA memory pre-proceessing in v2.9
LIO-SE. 

Also, being able to tell the engine to accelerate to DMA ring operation
(say to underlying struct scsi_device or struct block_device) instead of
fileio in some cases you will see better performance when using hardware
(ie: not a underlying kernel thread queueing IO into block).  But I have
found FILEIO with sendpage with MD to be faster in single threaded tests
than struct block_device.  I am currently using IBLOCK for LVM for core
LIO operation (which actually sits on software MD raid6).  I do this
because using submit_bio() with se_mem_t mapped arrays of struct
scatterlist -> struct bio_vec can handle power failures properly, and
not send back StatSN Acks to the Initiator who thinks that everything
has already made it to disk.  This is the case with doing IO to struct
file in the kernel today without a kernel level O_DIRECT.

Also for proper kernel-level target mode support, using struct file with
O_DIRECT for storage blocks and emulating control path CDBS is one of
the work items.  This can be made generic or obtained from the
underlying storage object (anything that can be exported from LIO
Subsystem TPI) For real hardware (struct scsi_device in just about all
the cases these days).  Last time I looked this was due to
fs/direct-io.c:dio_refill_pages() using get_user_pages()...

For really transport specific CDB and control code, which in good amount
of cases, we are going eventually be expected to emulate in software. 
I really like how STGT breaks this up into per device type code
segments; spc.c sbc.c mmc.c ssc.c smc.c etc.  Having all of these split
out properly is one strong point of STGT IMHO, and really makes learning
things much easier.  Also, being able to queue these IOs into a
userspace and receive a asynchronous response back up the storage stack.
I think this is actually a pretty interesting potential for passing
storage protocol packets into userspace apps and leave the protocol
state machines and recovery paths in the kernel with a generic target
engine.

Also, I know that the SCST folks have put alot of time into getting the
very SCSI hardware specific target mode control modes to work.  I
personally own a bunch of this adapters, and would really like to see
better support for target mode on non iSCSI type adapters with a single
target mode storage engine that abstracts storage subsystems and wire
protocol fabrics.

--nab

