From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: qla2xxx random device resets, eventual io errors, invalid context
Date: Thu, 25 Sep 2003 16:25:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED2B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:32328 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S262080AbTIYXZG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 19:25:06 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Shoemaker Christopher A NPRI <ShoemakerCA@Npt.NUWC.Navy.Mil>
Cc: linux-scsi@vger.kernel.org

Christopher,

> [ I apologize in advance for the length of this post.  I'm 
> trying to summarize and organize two weeks of very 
> frustrating experiences.  :( ]
> 

The more information the better...

> I've got one qla2200 and two qla2300's in a Dell PowerEdge6450.
> Each qla2xxx HBA has one device attached.  The second qla2300 has
> been recently added, but I've been unable to get the new device up
> reliably.  I've tried MANY, MANY things, and I'm pretty frustrated
> by the whole thing.  But, before I give up, I wanted to try to
> summarize all the things I tried and the failure modes I observed.
> Maybe this info will be useful to someone?  Maybe someone has some
> advice for me?  I'm happy to answer questions, apply patches, etc.
> Please cc, I'm not subscribed.
>  
...
>  	**** Info about the 2300s and their devices:
> Sep 23 12:25:40 fer kernel: scsi5 : QLogic QLA2300 PCI to 
> Fibre Channel Host Adapter: bus 14 device 12 irq 19
> Sep 23 12:25:40 fer kernel:         Firmware version:  
> 3.01.18, Driver version 6.05.00
> Sep 23 12:25:40 fer kernel: 
> Sep 23 12:25:40 fer kernel: scsi6 : QLogic QLA2300 PCI to 
> Fibre Channel Host Adapter: bus 14 device 13 irq 20
...
> **** First, my experiences in the 2.4.x category.  That includes:
>   1) 2.4.20-(rh9) out-of-box
>   2) vanilla 2.4.22 w/ qla2x00 ver. 6.05.00 
>   3) 2.4.23-pre5 w/ same 6.05.00
...
>   The first thing I notice is that the copy seems to go very 
> slowly.  Right now, I don't care too much.  I'm guessing it 
> may be due to bounce buffers if either qla2200 or qla2300 
> driver doesn't do DMA, or doesn't do DMA to highmem (I've got 
> 4GB, and highmem support on, at least for the kernels I 
> compile.  I'm not sure about the redhat kernel.)
>

I have a feeling the kernel is using bounce-buffers for the transfers.
Unfortunately, not all kernels (vary by version and distribution) use
a consistent nomenclature for scsi host template members, i.e.
can_dma_32, highmem_io, vary_io, etc...  Earlier versions of the
drivers would attempt to infer names/existence of members based on
kernel CONFIG options and version -- the success rate was rather poor.  

> Anyway, I'm 
> patient, and more concerned about reliability at the moment.  
> So I wait.
>

Our next driver release will use a 'more' intelligent method of
determining host members with the help of the compiler.  

But as you stated, reliability is paramount.

>   Then, after about 25 minutes, the cp's fail with things like:
>      "I/O error: dev 08:55, sector 79491616"
>   ad nauseum (with different sector #'s, of course).
> 
>   So I start poking around.  I notice that I am constantly 
> getting LIP reset messages in /var/log/messages.  Every few 
> seconds I get something like: 
> 
> Sep 22 12:42:47 fer kernel: scsi(5): LIP reset occurred.
> Sep 22 12:42:47 fer kernel: scsi(5): LIP occurred.
> Sep 22 12:42:47 fer kernel: scsi(5): Waiting for LIP to complete...
> Sep 22 12:42:47 fer kernel: scsi(5): Topology - (Loop), Host 
> Loop address 0x2
> 

This is not good.  All your subsequent observations appear to be side
effects of the RESETs occurring on the loop.  

>   scsi(5) is the qla2300 I'm writing to.  I don't see a 
> pattern to the intervals: 12:42:47, 12:42:52, 12:42:55, 
> 12:43:00, 12:43:20, 12:43:34, 12:43:37, 12:43:40, 12:44:04, 
> 12:44:28, etc.
> 
>   Google turns up 
> http://www.ncsa.uiuc.edu/~aloftus/FibreChannel/FAQ.html which 
> says that the LIP reset messages can be caused by conflicting 
> loop IDs, along with this:  
> 	"NOTE: QLogic cards (on linux) log this message to 
> /var/log/messages regardless of what mode the card is 
> operating in. According to QLogic support, this message 
> should be ignored when the card is operating in point-to-point mode."
>
>   Well, my cards aren't on a fabric (no switch), but they are 
> in loop mode, so can I ignore the messages?
>

No, this is the problem, or at least one of them.  You need to
determine why LIP resets are occuring within the loop.  

> I try some 
> things various things related to this, but with no effect.  [ 
> See the list down below where I collected a lot of my failed 
> attempts.]
> 
>   Closer examination of logs revealed that I also, every once 
> in a while, get one of these thrown in:
> Sep 22 13:55:47 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
>   (ignore the times, they are from different runs.  Here's two more:
> Sep 22 13:58:12 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
> Sep 22 14:06:09 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
> 
>   And occasionally, I get a little more:
> Sep 22 14:13:04 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
> Sep 22 14:13:09 fer kernel: scsi(5:0:0:0): LOOP RESET ISSUED.
> Sep 22 14:13:09 fer kernel: qla2xxx_eh_bus_reset Exiting: 
> status=SUCCESS
> 

The mid-layer error handler is elevating the recovery based on the
failing commands.

>   In fact, it may be coincidental, but the initial onset of 
> IO errors, about 25 minutes into the high load seems to 
> correspond with some of these more verbose messages, like:
> Sep 23 13:53:38 fer kernel: scsi(6:0:0:0): DEVICE RESET ISSUED.
> Sep 23 13:54:05 fer kernel: scsi(6:0:0:0): LOOP RESET ISSUED.
> Sep 23 13:54:05 fer kernel: scsi(6): LIP reset occurred.
> Sep 23 13:54:05 fer kernel: qla2xxx_eh_bus_reset Exiting: 
> status=SUCCESS
> Sep 23 13:54:05 fer kernel: scsi(6): LIP occurred.
> Sep 23 13:54:05 fer kernel: scsi(6): Waiting for LIP to complete...
> Sep 23 13:54:05 fer kernel: scsi(6): Topology - (Loop), Host 
> Loop address 0x2
> Sep 23 13:54:32 fer kernel: scsi: device set offline - not 
> ready or command retry failed after bus reset: host 6 channel 
> 0 id 0 lun 0
> Sep 23 13:55:16 fer last message repeated 2 times
> Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79485792
> Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79487840
> Sep 23 13:55:16 fer kernel: EXT3-fs error (device sd(8,85)): 
> ext3_get_inode_loc: unable to read inode block - 
> inode=9568257, block=19136514
> Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79488856
> 	ad nauseum....
> 

Ultimately, the mid-layer gives up, and I/O errors are reported.
Bottom-line, we need to figure out which device within the loop is
causing the resets.

> **** THINGS I'VE TRIED:
> 	-) I set both qla2300's to "Set Hard Loop ID", with 
> different IDs.
>
...
> 	-) I upgrade the firmware on the RAID device from 3.23j 
> to ver. 3.23r from ftp://ftp.infortrend.com/3200%265200/firmware/3.23/
> 		Reboot, again, same behavior.
> 	-) I switch the two devices to the opposite qla2300 
> HBA, thinking maybe the new one is just bad.
> 		Reboot, again, same behavior with the other HBA.
>

Given this information, my best guess would be the target may be
having some problems within the loop, since as you say, the problems
followed the HBA.

> 	Anyway, final solution was to compile scsi_mod, sd_mod, 
> aic7xxx, and megaraid stuff into the kernel, but I left 
> qla2200 and qla2300 as modules.  So, I'm using: 
> 2.6.0-test5-bk11 with qla2xxx driver ver. 8.00.00b5 + 
> mksully's patch to allow compile.
>
Beta 6 will arrive RSN.

> Oh, and I compiled-in a > lot of debug options.
> 
> 	The first thing I notice when I boot up are the 
> messages below.  They refer to the qla2200 (scsi4, with 3 
> luns), and two qla2300s (scsi5, and scsi6).  I get these on 
> boot-up only, I think.
> 
> Sep 25 09:02:25 fer kernel: scsi(4:0:0:0) Mid-layer underflow 
> detected (54 of 60 bytes)...returning error status.
> Sep 25 09:02:25 fer kernel: scsi(4:0:0:0) Mid-layer underflow 
> detected (54 of 60 bytes)...returning error status.
> Sep 25 09:02:26 fer last message repeated 18 times
> Sep 25 09:02:26 fer kernel: scsi(4:0:0:0) Mid-layer underflow 
> detected (48 of 60 bytes)...returning error status.
> 

Yes, this has been noted on linux-scsi, ignore for now.

>   When I try the 3 cp commands, I notice that I get a much 
> higher initial through-put.  300MB shows up in 'df -h' in 
> just a second or two.  It's probably just hitting the 1GB 
> cache RAM on the RAID, but still, it didn't start out so fast 
> on 2.4.23-pre5. (or maybe the credit belong to the ver. 8 
> qla2xxx driver, I don't know.)  However, it only takes a few 
> seconds to fail.  (Good in a way, before, every test took 
> about 25 minutes to fail.)  Almost immediately, I get 
> hundreds of these:
> 
> Sep 25 09:29:59 fer kernel: SCSI error : <6 0 0 0> return 
> code = 0x20000
> Sep 25 09:29:59 fer kernel: end_request: I/O error, dev sdf, 
> sector 1572807462
> Sep 25 09:29:59 fer kernel: Buffer I/O error on device sdf5, 
> logical block 196600917
> Sep 25 09:29:59 fer kernel: lost page write due to I/O error on sdf5
> Sep 25 09:29:59 fer kernel: SCSI error : <6 0 0 0> return 
>
...
> Sep 25 09:30:14 fer kernel: qla2xxx_eh_device_reset: cmd 
> already done sp=00000000
> Sep 25 09:30:14 fer kernel: scsi(6:0:0:0): LOOP RESET ISSUED.
> Sep 25 09:30:14 fer kernel: scsi(6): LIP reset occured.
> Sep 25 09:30:14 fer kernel: qla2xxx_eh_bus_reset(6): reset succeded
> Sep 25 09:30:14 fer kernel: scsi(6): Asynchronous LIP Occured.
> Sep 25 09:30:14 fer kernel: scsi(6): Port database changed.
> Sep 25 09:30:14 fer kernel: scsi(6): Waiting for LIP to complete...
> Sep 25 09:30:14 fer kernel: scsi(6): Topology - (Loop), Host 
> Loop address 0x2
> Sep 25 09:30:25 fer kernel: SCSI error : <6 0 0 0> return 
> code = 0x20000
> Sep 25 09:30:25 fer kernel: end_request: I/O error, dev sdf, 
> sector 1572829846
> Sep 25 09:30:25 fer kernel: Buffer I/O error on device sdf5, 
> logical block 196603715
> Sep 25 09:30:25 fer kernel: lost page write due to I/O error on sdf5
> 

As I stated earlier, we need to find and diagnose the LIP reset
problem.

The quickest route, from a driver perspective, would be to get a FC
trace between the HBA and target.  Would you happen to have a finisar
available?

We could then tell immediately where the reset is occuring.  But,
given that the problem seems to follow the HBA that the target in
question is plugged into, once again, it's likely that this a target
problem.

> Sep 25 09:31:04 fer kernel: qla2xxx_eh_abort scsi(6:0:0:0): 
> cmd_timeout_in_sec=0x1e.
> Sep 25 09:31:04 fer kernel: Debug: sleeping function called 
> from invalid context at include/asm/semaphore.h:145
> Sep 25 09:31:04 fer kernel: SCSI error : <6 0 0 0> return 
> code = 0x20000
> Sep 25 09:31:04 fer kernel: end_request: I/O error, dev sdf, 
> sector 1572833950
> Sep 25 09:31:04 fer kernel: Buffer I/O error on device sdf5, 
> logical block 196604228
> Sep 25 09:31:04 fer kernel: lost page write due to I/O error on sdf5
> Sep 25 09:31:04 fer kernel: in_atomic():0, irqs_disabled():1
> Sep 25 09:31:04 fer kernel: Call Trace:
> Sep 25 09:31:04 fer kernel:  [<c01237de>] __might_sleep+0x9e/0xc0
> Sep 25 09:31:04 fer kernel:  [<f890735b>] 
> qla2x00_mailbox_command+0x62b/0x730 [qla2300]
> Sep 25 09:31:04 fer kernel:  [<f8906830>] 
> qla2x00_mbx_sem_timeout+0x0/0x20 [qla2300]
> Sep 25 09:31:04 fer kernel:  [<f8907bd4>] 
> qla2x00_abort_command+0x114/0x180 [qla2300]
> Sep 25 09:31:04 fer kernel:  [<c0127659>] 
> release_console_sem+0x139/0x180
> Sep 25 09:31:04 fer kernel:  [<c012740b>] printk+0x1db/0x290
> Sep 25 09:31:04 fer kernel:  [<f88f9761>] 
> qla2xxx_eh_abort+0x591/0x1020 [qla2300]
...
> 	and more yuckiness that I probably shouldn't paste, 
> including "buffer layer error at fs/buffer.c:2827", which I 
> sent to the linux-fsdevel mailing list.
> 

This is not good.  I'll look into this for the 8.x series driver.

> **** Remaining Questions:  (sorry so many, feel free to 
> answer only one)
> 	-) Is a LIP reset the same as a LOOP reset?

No, the LIP reset notification is a result of the firmware receiving a
LIP reset primitive sequence.  The LOOP reset is occuring as a result
of the mid-layer attempting to recover from the command problems.

> 	-) What is causing the constant LIP resets?  Is it a problem?

Yes.

> 	-) Are the IO errors caused by a failure to recover 
> from some reset, or is it the other way around?
> 	-) What is causing the DEVICE resets?
>

side effect of error handling.

> 	-) Should those mid-layer underflow messages concern me?
> 	-) Basically, what on earth, if anything, can I do to 
> get this working under linux?
> 

I may be able to provide a more defintive answer if a FC trace was
provided.

Hope this helps,

Andrew Vasquez
QLogic Corporation
