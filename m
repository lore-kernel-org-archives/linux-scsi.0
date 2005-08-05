From: "Edward A. Hildum" <ehildum@mail.arc.nasa.gov>
Subject: sym53c8xx_2 driver problem with SCSI-1 device
Date: Fri, 05 Aug 2005 09:43:14 -0700
Message-ID: <42F39722.8090109@mail.arc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pony2pub.arc.nasa.gov ([128.102.31.42]:52745 "EHLO arc.nasa.gov")
	by vger.kernel.org with ESMTP id S261425AbVHEXnQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 19:43:16 -0400
Received: from [128.102.173.254] (HELO [128.102.173.53])
  by pony2pub.arc.nasa.gov (CommuniGate Pro SMTP 4.3.3)
  with ESMTP id 20985211 for linux-scsi@vger.kernel.org; Fri, 05 Aug 2005 16:43:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I'm having communication problems between an sym53c895 host adapter and 
an old/slow SCSI-1 device.  I'm using FC4 linux with the most recent FC4 
-released kernel 2.6.12-1.1398.  The sym53c8xx_2 driver version is 
sym-2.2.0.  The sym53c8xx_2 driver was working for me until the 2.6.10 
kernel release (driver version sym-2.1.18m).  After that point, the 
driver has trouble probing the device.  The initial inquiry command 
appears to complete most of the time, but read capacity does not.  I put 
some print statements in scsi_glue.c to look at the CDB contents before 
scsi commands are issued and the buffer contents after commands 
complete, and some data does get received.  The read capacity command, 
for example, should get 00 01 FF FF 00 00 02 00, but instead gets 00 00 
00 00 00 01 FF FF.

I append a portion of the driver output from /var/log/messages with 
driver parameters  verb=2 debug=0x246.  If the full output or other 
debug= options would be helpful, I can send the full file.

The SCSI device in question is strictly async, rejects all messages, 
does not disconnect and its transfer speed is less than 5MB/s.  It is 
currently the only device on the bus.  It works fine with the aic7xxx 
driver on a different desktop machine running the 2.6.12-1.1398 FC4 
kernel release.

Does this ring any bells with anybody?

I will be out of my office until 8/16, but I will try to check in 
periodically until then.

Thanks for your help,
Ted Hildum


---- /var/log/messages ----
kernel: sym0: <895> rev 0x2 at pci 0000:03:06.0 irq 5
kernel: sym0: Symbios NVRAM, ID 7, Fast-40, SE, parity checking
kernel: sym0: open drain IRQ line driver, using on-chip SRAM
kernel: sym0: using LOAD/STORE-based firmware.
kernel: sym0: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 
00/00/00/00/00/00
kernel: sym0: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 = (hex) 
07/4e/80/01/08/24
kernel: 0:  <7c07fe00>
kernel: 2:  <721a0000>
kernel: 4:  <72140000>
kernel: 6:  <e3340004>
kernel: 8:  <980cef10>
kernel: 10:  <e3100004>

---- snip ----

kernel: 322:  <80080000>
kernel: 0:  <f3340004>
kernel: 2:  <f21c0004>
kernel: 4:  <f31c0004>
kernel: 6:  <98080000>
kernel: sym0: enabling clock multiplier
kernel: sym0: Downloading SCSI SCRIPTS.
kernel: sym0: SCSI BUS has been reset.
kernel: sym0: command processing suspended for 3 seconds
kernel: sym0: SCSI BUS mode change from SE to SE.
kernel: sym0: enabling clock multiplier
kernel: sym0: Downloading SCSI SCRIPTS.
kernel: sym0: SCSI BUS has been reset.
kernel: sym0: command processing suspended for 3 seconds
kernel: scsi3 : sym-2.2.0
kernel: sym0: command processing resumed
kernel: P13 RL=1 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=25 OADR=a2cfec0
kernel:  3:0:2:0: PM 40 40 e8200b10 / a2cfee4 1 e82007f0.
kernel:   Vendor: BCE       Model: SCSI-DSPXrevA 2.  Rev: 29-4
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 01
kernel:  target3:0:2: Beginning Domain Validation
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=1 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=25 OADR=a41e000
kernel:  3:0:2:0: PM 40 40 e8200b10 / a41e024 1 e82007f0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=1 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=25 OADR=a41e025
kernel:  3:0:2:0: PM 40 40 e8200b10 / a41e049 1 e82007f0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=1 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=25 OADR=a41e025
kernel:  3:0:2:0: PM 40 40 e8200b10 / a41e049 1 e82007f0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=1 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=25 OADR=a41e025
kernel:  3:0:2:0: PM 40 40 e8200b10 / a41e049 1 e82007f0.
kernel:  target3:0:2: Ending Domain Validation
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel: sda : READ CAPACITY failed.
kernel: sda : status=0, message=00, host=7, driver=00
kernel: sda : sense not available.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=24 D=0
kernel: CP=cafdec00 DSP=a11d2e0 NXT=a11d2e0 VDSP=ca11d2d8 CMD=11 OCMD=11
kernel: TBLP=cafdec4c OLEN=20 OADR=afdef70
kernel: sd 3:0:2:0: PM 50 50 e8200b10 / afdef78 18 a11d2e0.
kernel: sda: asking for cache data failed
kernel: sda: assuming drive cache: write through

---- snip ----

kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel: SCSI error : <3 0 2 0> return code = 0x70000
kernel: end_request: I/O error, dev sda, sector 0
kernel: Buffer I/O error on device sda, logical block 0
kernel:  unable to read partition table
kernel: Attached scsi disk sda at scsi3, channel 0, id 2, lun 0
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=219 D=0
kernel: CP=cafdec00 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=cafdef54 OLEN=ff OADR=ab98000
kernel: sd 3:0:2:0: PM 40 40 e8200b10 / ab98024 db e82007f0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=219 D=0
kernel: CP=ca11d800 DSP=e82007f0 NXT=e82007f0 VDSP=ca0cb7e8 CMD=11 OCMD=11
kernel: TBLP=ca11db54 OLEN=ff OADR=ab98000
kernel: sd 3:0:2:0: PM 40 40 e8200b10 / ab98024 db e82007f0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=4092 D=0
kernel: CP=cafdec00 DSP=e82007c0 NXT=e82007c0 VDSP=ca0cb7b8 CMD=11 OCMD=11
kernel: TBLP=cafdef24 OLEN=1000 OADR=af1e000
kernel: sd 3:0:2:0: PM 40 40 e8200b10 / af1e004 ffc e82007c0.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: P13 RL=4092 D=0
kernel: CP=ca11d800 DSP=e8200780 NXT=e8200780 VDSP=ca0cb778 CMD=11 OCMD=11
kernel: TBLP=ca11dae4 OLEN=1000 OADR=ab4c000
kernel: sd 3:0:2:0: PM 40 40 e8200b10 / ab4c004 ffc e8200780.
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel: SCSI error : <3 0 2 0> return code = 0x70000
kernel: end_request: I/O error, dev sda, sector 512
kernel: Buffer I/O error on device sda, logical block 64
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel:  target3:0:2: ppr msgout: 1-6-4-0-0-0-0-0.
kernel: sd 3:0:2:0: extraneous data discarded.
kernel: sd 3:0:2:0: COMMAND FAILED (87 0 1).
kernel: SCSI error : <3 0 2 0> return code = 0x70000
kernel: end_request: I/O error, dev sda, sector 512
kernel: Buffer I/O error on device sda, logical block 64

---- end /var/log/messages ----
