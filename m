From: Shoemaker Christopher A NPRI <ShoemakerCA@Npt.NUWC.Navy.Mil>
Subject: qla2xxx random device resets, eventual io errors, invalid context
Date: Thu, 25 Sep 2003 15:50:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3BEEE23D31CAD2118D920008C75D894604E1D5A6@NPRI54EXC21.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from NPRI54MAI02.Npt.NUWC.Navy.Mil ([164.223.1.101]:54538 "EHLO
	npri54mai02.npt.nuwc.navy.mil") by vger.kernel.org with ESMTP
	id S261722AbTIYTxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 15:53:37 -0400
Received: from npri54exc24.npt.nuwc.navy.mil
 (NPRI54EXC24.NPT.NUWC.NAVY.MIL [129.190.70.87])
 by npri54mai02.npt.nuwc.navy.mil (PMDF V6.2-X17 #30632)
 with ESMTP id <KZWA08OFXG88UE00SC@npri54mai02.npt.nuwc.navy.mil> for
 linux-scsi@vger.kernel.org; Thu,
 25 Sep 2003 15:50:33 -0400 (Eastern Daylight Time)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'andrew.vasquez@qlogic.com'" <andrew.vasquez@qlogic.com>

[ I apologize in advance for the length of this post.  I'm trying to summarize and organize two weeks of very frustrating experiences.  :( ]

Hi,
	I've got one qla2200 and two qla2300's in a Dell PowerEdge6450.  Each qla2xxx HBA has one device attached.  The second qla2300 has been recently added, but I've been unable to get the new device up reliably.  I've tried MANY, MANY things, and I'm pretty frustrated by the whole thing.  But, before I give up, I wanted to try to summarize all the things I tried and the failure modes I observed.  Maybe this info will be useful to someone?  Maybe someone has some advice for me?  I'm happy to answer questions, apply patches, etc.  Please cc, I'm not subscribed.
 
****  Info on my hardware config: ****
	Dell Power Edge 6450, (4GB RAM), most recent BIOS (A12)
	I believe the qla2200 card is sold, (perhaps assembled, too?) by VMetro, and the qla2300s by Atto.



 	**** Info about the 2200 and its device (actually 3 devices at one id):
Sep 23 12:25:39 fer kernel: qla2x00_set_info starts at address = f8861060
Sep 23 12:25:39 fer kernel: qla2x00: Found  VID=1077 DID=2200 SSVID=1077 SSDID=1
Sep 23 12:25:39 fer kernel: scsi(3): Found a QLA2200  @ bus 3, device 0xb, irq 25, iobase 0xac00
Sep 23 12:25:39 fer kernel: scsi(3): Allocated 4096 SRB(s).
Sep 23 12:25:39 fer kernel: scsi(3): Configure NVRAM parameters...
Sep 23 12:25:39 fer kernel: scsi(3): 32 Bit PCI Addressing Enabled.
Sep 23 12:25:39 fer kernel: scsi(3): Scatter/Gather entries= 896
Sep 23 12:25:39 fer kernel: scsi(3): Verifying loaded RISC code...
Sep 23 12:25:39 fer kernel: scsi(3): Verifying chip...
Sep 23 12:25:39 fer kernel: scsi(3): Waiting for LIP to complete...
Sep 23 12:25:39 fer kernel: scsi(3): LIP reset occurred.
Sep 23 12:25:39 fer kernel: scsi(3): LIP occurred.
Sep 23 12:25:39 fer kernel: scsi(3): LOOP UP detected.
Sep 23 12:25:39 fer kernel: scsi(3): Topology - (Loop), Host Loop address 0x0
Sep 23 12:25:39 fer kernel: scsi3 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 3 device 11 irq 25
Sep 23 12:25:39 fer kernel:         Firmware version:  2.02.03, Driver version 6.05.00
Sep 23 12:25:39 fer kernel: 
Sep 23 12:25:39 fer kernel: blk: queue f7fb6618, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:39 fer kernel:   Vendor: WS        Model: CycloneRAID       Rev: 2.01
Sep 23 12:25:39 fer kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Sep 23 12:25:39 fer kernel: blk: queue f7fb7a18, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:39 fer kernel:   Vendor: WS        Model: CycloneRAID       Rev: 2.01
Sep 23 12:25:39 fer kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Sep 23 12:25:39 fer kernel: blk: queue f7f27618, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:39 fer kernel:   Vendor: WS        Model: CycloneRAID       Rev: 2.01
Sep 23 12:25:39 fer kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Sep 23 12:25:39 fer kernel: blk: queue f7feae18, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:39 fer kernel: scsi(3:0:0:0): Enabled tagged queuing, queue depth 32.
Sep 23 12:25:39 fer rpc.statd[1760]: Version 1.0.1 Starting
Sep 23 12:25:39 fer kernel: scsi(3:0:0:1): Enabled tagged queuing, queue depth 32.
Sep 23 12:25:39 fer nfslock: rpc.statd startup succeeded
Sep 23 12:25:39 fer kernel: scsi(3:0:0:2): Enabled tagged queuing, queue depth 32.
Sep 23 12:25:39 fer kernel: Attached scsi disk sda at scsi3, channel 0, id 0, lun 0
Sep 23 12:25:39 fer kernel: Attached scsi disk sdb at scsi3, channel 0, id 0, lun 1
Sep 23 12:25:39 fer kernel: Attached scsi disk sdc at scsi3, channel 0, id 0, lun 2
Sep 23 12:25:39 fer kernel: SCSI device sda: 1418395648 512-byte hdwr sectors (726219 MB)
Sep 23 12:25:39 fer kernel: Partition check:
Sep 23 12:25:39 fer kernel:  sda: sda1
Sep 23 12:25:39 fer kernel: SCSI device sdb: 1418395648 512-byte hdwr sectors (726219 MB)
Sep 23 12:25:39 fer kernel:  sdb: sdb1
Sep 23 12:25:39 fer kernel: SCSI device sdc: 1418395648 512-byte hdwr sectors (726219 MB)
Sep 23 12:25:39 fer kernel:  sdc: sdc1



 	**** Info about the 2300s and their devices:
Sep 23 12:25:40 fer kernel: scsi5 : QLogic QLA2300 PCI to Fibre Channel Host Adapter: bus 14 device 12 irq 19
Sep 23 12:25:40 fer kernel:         Firmware version:  3.01.18, Driver version 6.05.00
Sep 23 12:25:40 fer kernel: 
Sep 23 12:25:40 fer kernel: scsi6 : QLogic QLA2300 PCI to Fibre Channel Host Adapter: bus 14 device 13 irq 20
Sep 23 12:25:40 fer kernel:         Firmware version:  3.01.18, Driver version 6.05.00
Sep 23 12:25:40 fer kernel: 
Sep 23 12:25:40 fer kernel: blk: queue f7039818, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:40 fer kernel:   Vendor: CAEN      Model: RAPTOR 16         Rev:     
Sep 23 12:25:40 fer kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Sep 23 12:25:40 fer kernel: blk: queue f7039618, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:40 fer kernel: scsi(5:0:0:0): Enabled tagged queuing, queue depth 32.
Sep 23 12:25:40 fer kernel:   Vendor: IFT       Model: SR2500            Rev: 0323
Sep 23 12:25:40 fer kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Sep 23 12:25:40 fer kernel: blk: queue f6b10618, I/O limit 4095Mb (mask 0xffffffff)
Sep 23 12:25:40 fer kernel: scsi(6:0:0:0): Enabled tagged queuing, queue depth 32.
Sep 23 12:25:40 fer kernel: Attached scsi disk sde at scsi5, channel 0, id 0, lun 0
Sep 23 12:25:40 fer kernel: Attached scsi disk sdf at scsi6, channel 0, id 0, lun 0
Sep 23 12:25:40 fer kernel: SCSI device sde: 4294950912 512-byte hdwr sectors (2199015 MB)
Sep 23 12:25:40 fer kernel:  sde: sde1
Sep 23 12:25:40 fer kernel: SCSI device sdf: 4007141376 512-byte hdwr sectors (2051656 MB)
Sep 23 12:25:40 fer kernel:  sdf: sdf1 < sdf5 >


**** First, my experiences in the 2.4.x category.  That includes:
  1) 2.4.20-(rh9) out-of-box
  2) vanilla 2.4.22 w/ qla2x00 ver. 6.05.00 
  3) 2.4.23-pre5 w/ same 6.05.00

  In each case, the error messages would vary slightly, but the behavior was essentially the same.  Every time, my task was to start 3 cp commands, one from each of the 3 lun devices on the qla2200 to the new device on the new qla2300.  In total, this should result in a total of about 1TB being copied, but I never got more than about 2.9GB moved before things go bad.

  The first thing I notice is that the copy seems to go very slowly.  Right now, I don't care too much.  I'm guessing it may be due to bounce buffers if either qla2200 or qla2300 driver doesn't do DMA, or doesn't do DMA to highmem (I've got 4GB, and highmem support on, at least for the kernels I compile.  I'm not sure about the redhat kernel.)  Anyway, I'm patient, and more concerned about reliability at the moment.  So I wait.
  Then, after about 25 minutes, the cp's fail with things like:
     "I/O error: dev 08:55, sector 79491616"
  ad nauseum (with different sector #'s, of course).

  So I start poking around.  I notice that I am constantly getting LIP reset messages in /var/log/messages.  Every few seconds I get something like: 

Sep 22 12:42:47 fer kernel: scsi(5): LIP reset occurred.
Sep 22 12:42:47 fer kernel: scsi(5): LIP occurred.
Sep 22 12:42:47 fer kernel: scsi(5): Waiting for LIP to complete...
Sep 22 12:42:47 fer kernel: scsi(5): Topology - (Loop), Host Loop address 0x2

  scsi(5) is the qla2300 I'm writing to.  I don't see a pattern to the intervals: 12:42:47, 12:42:52, 12:42:55, 12:43:00, 12:43:20, 12:43:34, 12:43:37, 12:43:40, 12:44:04, 12:44:28, etc.

  Google turns up http://www.ncsa.uiuc.edu/~aloftus/FibreChannel/FAQ.html which says that the LIP reset messages can be caused by conflicting loop IDs, along with this:  
	"NOTE: QLogic cards (on linux) log this message to /var/log/messages regardless of what mode the card is operating in. According to QLogic support, this message should be ignored when the card is operating in point-to-point mode."
  Well, my cards aren't on a fabric (no switch), but they are in loop mode, so can I ignore the messages?  I try some things various things related to this, but with no effect.  [ See the list down below where I collected a lot of my failed attempts.]

  Closer examination of logs revealed that I also, every once in a while, get one of these thrown in:
Sep 22 13:55:47 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
  (ignore the times, they are from different runs.  Here's two more:
Sep 22 13:58:12 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
Sep 22 14:06:09 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.

  And occasionally, I get a little more:
Sep 22 14:13:04 fer kernel: scsi(5:0:0:0): DEVICE RESET ISSUED.
Sep 22 14:13:09 fer kernel: scsi(5:0:0:0): LOOP RESET ISSUED.
Sep 22 14:13:09 fer kernel: qla2xxx_eh_bus_reset Exiting: status=SUCCESS


  In fact, it may be coincidental, but the initial onset of IO errors, about 25 minutes into the high load seems to correspond with some of these more verbose messages, like:
Sep 23 13:53:38 fer kernel: scsi(6:0:0:0): DEVICE RESET ISSUED.
Sep 23 13:54:05 fer kernel: scsi(6:0:0:0): LOOP RESET ISSUED.
Sep 23 13:54:05 fer kernel: scsi(6): LIP reset occurred.
Sep 23 13:54:05 fer kernel: qla2xxx_eh_bus_reset Exiting: status=SUCCESS
Sep 23 13:54:05 fer kernel: scsi(6): LIP occurred.
Sep 23 13:54:05 fer kernel: scsi(6): Waiting for LIP to complete...
Sep 23 13:54:05 fer kernel: scsi(6): Topology - (Loop), Host Loop address 0x2
Sep 23 13:54:32 fer kernel: scsi: device set offline - not ready or command retry failed after bus reset: host 6 channel 0 id 0 lun 0
Sep 23 13:55:16 fer last message repeated 2 times
Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79485792
Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79487840
Sep 23 13:55:16 fer kernel: EXT3-fs error (device sd(8,85)): ext3_get_inode_loc: unable to read inode block - inode=9568257, block=19136514
Sep 23 13:55:16 fer kernel:  I/O error: dev 08:55, sector 79488856
	ad nauseum....

**** THINGS I'VE TRIED:
	-) I set both qla2300's to "Set Hard Loop ID", with different IDs.
		Reboot, I try again, same behavior.
	-) I set the qla2300 for scsi(5) (the one I'm actually using) to point-to-point mode.  (The device can do either loop or point-to-point.)
		Reboot, I try again, same behavior.
	-) As I wrote above, I tried changing to vanilla 2.4.22 w/ qla2x00 ver. 6.05.00 and 2.4.23-pre5 w/ same 6.05.00.
		Each time, same behavior.
	-) I upgrade the firmware on the RAID device from 3.23j to ver. 3.23r from ftp://ftp.infortrend.com/3200%265200/firmware/3.23/
		Reboot, again, same behavior.
	-) I switch the two devices to the opposite qla2300 HBA, thinking maybe the new one is just bad.
		Reboot, again, same behavior with the other HBA.
	-) I switch to a spare cable I have.  (It's a copper cable, no optics here.)
		Reboot, again, same errors.
	-) I upgrade the Dell PE6450 BIOS from A9 to A12.
		Reboot, no change.
	-) I format the target partition with reiserfs instead of ext3.
		Reboot, try again, same failure after the normal 25 minutes, but messy clean-up, because when ext3 detects io errors it unmounts and remount read-only, so the cp's fail on permission errors.  Reiserfs OTOH, wasn't so accommodating: processes get stuck in D state and won't die, and the devices can't be unmount.
		By the way, when reformatting as ext3, I took the opportunity to do a bad-block check.  The thing took a LONG time, but finished without a single error.
	-) I compiled-out kernel preemption.
		Reboot, no change.
	-) I try acpi=off.
		Reboot, no change.
	-) I tried a few more unlikely things that I won't admit to :), all with no effect :-(


**** AND WHEN I TRIED 2.6.0-test5[-bk11]:  ******

	[ begin OT ] I had a tough time getting 2.6.0-test5 running, even though I'd gotten it running once before on my laptop, and even though I had the new init-modutils and mkinitrd stuff.  Basically, I couldn't get it to mount root in the initrd.  I tried: root=LABEL=/, /dev/sdd3, /dev/sda3, 833, 0833, 08:03, 803, 0803, 08:03, you get the picture.  Always the same problem.  [I'm suspicious that there may be recent bugs in do_mounts.[ch], but I'm not patient enough to investigate.]  [ end OT ]
	Anyway, final solution was to compile scsi_mod, sd_mod, aic7xxx, and megaraid stuff into the kernel, but I left qla2200 and qla2300 as modules.  So, I'm using: 2.6.0-test5-bk11 with qla2xxx driver ver. 8.00.00b5 + mksully's patch to allow compile.  Oh, and I compiled-in a lot of debug options.

	The first thing I notice when I boot up are the messages below.  They refer to the qla2200 (scsi4, with 3 luns), and two qla2300s (scsi5, and scsi6).  I get these on boot-up only, I think.

Sep 25 09:02:25 fer kernel: scsi(4:0:0:0) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:25 fer kernel: scsi(4:0:0:0) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 18 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:0) Mid-layer underflow detected (48 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:0) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:1) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:1) Mid-layer underflow detected (48 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:1) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:2) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:2) Mid-layer underflow detected (48 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(4:0:0:2) Mid-layer underflow detected (54 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(5:0:0:0) Mid-layer underflow detected (4c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(5:0:0:0) Mid-layer underflow detected (3c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(5:0:0:0) Mid-layer underflow detected (38 of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(5:0:0:0) Mid-layer underflow detected (4c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(6:0:0:0) Mid-layer underflow detected (4c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(6:0:0:0) Mid-layer underflow detected (3c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times
Sep 25 09:02:26 fer kernel: scsi(6:0:0:0) Mid-layer underflow detected (4c of 60 bytes)...returning error status.
Sep 25 09:02:26 fer last message repeated 19 times


  When I try the 3 cp commands, I notice that I get a much higher initial through-put.  300MB shows up in 'df -h' in just a second or two.  It's probably just hitting the 1GB cache RAM on the RAID, but still, it didn't start out so fast on 2.4.23-pre5. (or maybe the credit belong to the ver. 8 qla2xxx driver, I don't know.)  However, it only takes a few seconds to fail.  (Good in a way, before, every test took about 25 minutes to fail.)  Almost immediately, I get hundreds of these:

Sep 25 09:29:59 fer kernel: SCSI error : <6 0 0 0> return code = 0x20000
Sep 25 09:29:59 fer kernel: end_request: I/O error, dev sdf, sector 1572807462
Sep 25 09:29:59 fer kernel: Buffer I/O error on device sdf5, logical block 196600917
Sep 25 09:29:59 fer kernel: lost page write due to I/O error on sdf5
Sep 25 09:29:59 fer kernel: SCSI error : <6 0 0 0> return code = 0x20000
Sep 25 09:29:59 fer kernel: end_request: I/O error, dev sdf, sector 1572808486
Sep 25 09:29:59 fer kernel: Buffer I/O error on device sdf5, logical block 196601045
Sep 25 09:29:59 fer kernel: lost page write due to I/O error on sdf5


	with at least one of these shortly thereafter:

Sep 25 09:30:05 fer kernel: qla2xxx_eh_abort: cmd already done sp=00000000
Sep 25 09:30:05 fer kernel: SCSI error : <6 0 0 0> return code = 0x20000
Sep 25 09:30:05 fer kernel: end_request: I/O error, dev sdf, sector 1572832926
Sep 25 09:30:05 fer kernel: Buffer I/O error on device sdf5, logical block 196604100
Sep 25 09:30:05 fer kernel: lost page write due to I/O error on sdf5
Sep 25 09:30:05 fer kernel: qla2xxx_eh_abort: cmd already done sp=00000000
Sep 25 09:30:14 fer last message repeated 36 times
Sep 25 09:30:14 fer kernel: qla2xxx_eh_device_reset: cmd already done sp=00000000
Sep 25 09:30:14 fer kernel: scsi(6:0:0:0): LOOP RESET ISSUED.
Sep 25 09:30:14 fer kernel: scsi(6): LIP reset occured.
Sep 25 09:30:14 fer kernel: qla2xxx_eh_bus_reset(6): reset succeded
Sep 25 09:30:14 fer kernel: scsi(6): Asynchronous LIP Occured.
Sep 25 09:30:14 fer kernel: scsi(6): Port database changed.
Sep 25 09:30:14 fer kernel: scsi(6): Waiting for LIP to complete...
Sep 25 09:30:14 fer kernel: scsi(6): Topology - (Loop), Host Loop address 0x2
Sep 25 09:30:25 fer kernel: SCSI error : <6 0 0 0> return code = 0x20000
Sep 25 09:30:25 fer kernel: end_request: I/O error, dev sdf, sector 1572829846
Sep 25 09:30:25 fer kernel: Buffer I/O error on device sdf5, logical block 196603715
Sep 25 09:30:25 fer kernel: lost page write due to I/O error on sdf5


	eventually resulting in several repeated occurrences of the slightly more ominous messages:

Sep 25 09:31:04 fer kernel: qla2xxx_eh_abort scsi(6:0:0:0): cmd_timeout_in_sec=0x1e.
Sep 25 09:31:04 fer kernel: Debug: sleeping function called from invalid context at include/asm/semaphore.h:145
Sep 25 09:31:04 fer kernel: SCSI error : <6 0 0 0> return code = 0x20000
Sep 25 09:31:04 fer kernel: end_request: I/O error, dev sdf, sector 1572833950
Sep 25 09:31:04 fer kernel: Buffer I/O error on device sdf5, logical block 196604228
Sep 25 09:31:04 fer kernel: lost page write due to I/O error on sdf5
Sep 25 09:31:04 fer kernel: in_atomic():0, irqs_disabled():1
Sep 25 09:31:04 fer kernel: Call Trace:
Sep 25 09:31:04 fer kernel:  [<c01237de>] __might_sleep+0x9e/0xc0
Sep 25 09:31:04 fer kernel:  [<f890735b>] qla2x00_mailbox_command+0x62b/0x730 [qla2300]
Sep 25 09:31:04 fer kernel:  [<f8906830>] qla2x00_mbx_sem_timeout+0x0/0x20 [qla2300]
Sep 25 09:31:04 fer kernel:  [<f8907bd4>] qla2x00_abort_command+0x114/0x180 [qla2300]
Sep 25 09:31:04 fer kernel:  [<c0127659>] release_console_sem+0x139/0x180
Sep 25 09:31:04 fer kernel:  [<c012740b>] printk+0x1db/0x290
Sep 25 09:31:04 fer kernel:  [<f88f9761>] qla2xxx_eh_abort+0x591/0x1020 [qla2300]
Sep 25 09:31:04 fer kernel:  [<c0240b71>] blk_plug_device+0x91/0x130
Sep 25 09:31:04 fer kernel:  [<c02714cc>] scsi_request_fn+0x2dc/0x540
Sep 25 09:31:04 fer kernel:  [<c026ac00>] scsi_done+0x0/0x80
Sep 25 09:31:04 fer kernel:  [<c026e3b1>] scsi_try_to_abort_cmd+0x81/0x100
Sep 25 09:31:04 fer kernel:  [<c027123b>] scsi_request_fn+0x4b/0x540
Sep 25 09:31:04 fer kernel:  [<c026e582>] scsi_eh_abort_cmds+0x52/0x100
Sep 25 09:31:04 fer kernel:  [<c026f629>] scsi_unjam_host+0x1d9/0x2d0
Sep 25 09:31:04 fer kernel:  [<c02705cb>] scsi_run_queue+0x14b/0x1f0
Sep 25 09:31:04 fer kernel:  [<c0121070>] default_wake_function+0x0/0x30
Sep 25 09:31:04 fer kernel:  [<c026f8c0>] scsi_error_handler+0x1a0/0x230
Sep 25 09:31:04 fer kernel:  [<c026f720>] scsi_error_handler+0x0/0x230
Sep 25 09:31:04 fer kernel:  [<c010930d>] kernel_thread_helper+0x5/0x18
Sep 25 09:31:04 fer kernel: 

	and more yuckiness that I probably shouldn't paste, including "buffer layer error at fs/buffer.c:2827", which I sent to the linux-fsdevel mailing list.


**** Remaining Questions:  (sorry so many, feel free to answer only one)
	-) Is a LIP reset the same as a LOOP reset?
	-) What is causing the constant LIP resets?  Is it a problem?
	-) Are the IO errors caused by a failure to recover from some reset, or is it the other way around?
	-) What is causing the DEVICE resets?
	-) Should those mid-layer underflow messages concern me?
	-) Basically, what on earth, if anything, can I do to get this working under linux?

Thanks for reading.  Please help me if you can.  

- Chris Shoemaker
