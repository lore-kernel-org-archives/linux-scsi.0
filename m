From: Willem Riede <wrlk@riede.org>
Subject: aic7xxx 6.2.24 bug report
Date: Sat, 28 Dec 2002 15:45:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021228204505.GC9319@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gBSKj5C11223
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 15:45:05 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here's a problem with aic7xxx 6.2.24 in 2.5.53 -- it refuses to handle 
my /dev/sdb. Works just fine with 6.2.4 in 2.5.52. 

This is from my log when booting linux 2.5.53:

Dec 24 15:31:15 fallguy kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.24
Dec 24 15:31:15 fallguy kernel:         <Adaptec aic7895 Ultra SCSI adapter>
Dec 24 15:31:15 fallguy kernel:         aic7895C: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs
Dec 24 15:31:15 fallguy kernel: 
Dec 24 15:31:15 fallguy kernel: (scsi1:A:1): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
Dec 24 15:31:15 fallguy kernel: (scsi0:A:3:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:15 fallguy kernel: (scsi0:A:3:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:16 fallguy kernel:   Vendor: OnStream  Model: SC-30             Rev: 1.09
Dec 24 15:31:16 fallguy kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Dec 24 15:31:16 fallguy kernel: (scsi0:A:3:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:16 fallguy kernel: (scsi0:A:3:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:16 fallguy kernel: (scsi0:A:6:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:16 fallguy kernel:   Vendor: MATSHITA  Model: CD-R   CW-7502    Rev: 4.17
Dec 24 15:31:16 fallguy kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Dec 24 15:31:16 fallguy kernel: (scsi0:A:6:0): refuses WIDE negotiation.  Using 8bit transfers
Dec 24 15:31:16 fallguy kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.24
Dec 24 15:31:16 fallguy kernel:         <Adaptec aic7895 Ultra SCSI adapter>
Dec 24 15:31:16 fallguy kernel:         aic7895C: Ultra Wide Channel B, SCSI Id=7, 32/253 SCBs
Dec 24 15:31:16 fallguy kernel: 
Dec 24 15:31:16 fallguy kernel: (scsi1:A:0): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
Dec 24 15:31:16 fallguy kernel:   Vendor: IBM       Model: DNES-318350W      Rev: SA30
Dec 24 15:31:16 fallguy kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Dec 24 15:31:16 fallguy kernel: scsi1:A:0:0: Tagged Queuing enabled.  Depth 16
Dec 24 15:31:16 fallguy kernel:   Vendor: IBM       Model: DGHS09U           Rev: 0350
Dec 24 15:31:16 fallguy kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Dec 24 15:31:16 fallguy kernel: scsi1:A:1:0: Tagged Queuing enabled.  Depth 16
Dec 24 15:31:17 fallguy kernel: SCSI device sda: drive cache: write through
Dec 24 15:31:17 fallguy kernel: SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
Dec 24 15:31:17 fallguy kernel:  sda: sda1 sda2 sda3 sda4
Dec 24 15:31:17 fallguy kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Dec 24 15:31:17 fallguy kernel: SCSI device sdb: drive cache: write through
Dec 24 15:31:17 fallguy kernel: SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
Dec 24 15:31:17 fallguy kernel:  sdb:SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 8000002
Dec 24 15:31:17 fallguy kernel: Current sdsdb: sense key Aborted Command
Dec 24 15:31:17 fallguy kernel: Additional sense: Synchronous data transfer error
Dec 24 15:31:17 fallguy kernel: end_request: I/O error, dev sdb, sector 0
Dec 24 15:31:17 fallguy kernel: Buffer I/O error on device sd(8,16), logical block 0
Dec 24 15:31:17 fallguy kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 8000002
Dec 24 15:31:18 fallguy kernel: Current sdsdb: sense key Aborted Command
Dec 24 15:31:18 fallguy kernel: Additional sense: Synchronous data transfer error
Dec 24 15:31:18 fallguy kernel: end_request: I/O error, dev sdb, sector 0
Dec 24 15:31:18 fallguy kernel: Buffer I/O error on device sd(8,16), logical block 0
Dec 24 15:31:18 fallguy kernel:  unable to read partition table
Dec 24 15:31:18 fallguy kernel: Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

The partition table doesn't get read.

But the disk is still accepted by the 2.5.52 kernel:

Dec 28 15:14:50 fallguy kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.4
Dec 28 15:14:50 fallguy kernel:         <Adaptec aic7895 Ultra SCSI adapter>
Dec 28 15:14:50 fallguy kernel:         aic7895C: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs
Dec 28 15:14:50 fallguy kernel: 
Dec 28 15:14:50 fallguy kernel: (scsi0:A:3): 10.000MB/s transfers (10.000MHz, offset 7)
Dec 28 15:14:50 fallguy kernel:   Vendor: OnStream  Model: SC-30             Rev: 1.09
Dec 28 15:14:50 fallguy kernel:   Type:   Sequential-Access                  ANSI SCSI revision: 02
Dec 28 15:14:50 fallguy kernel:   Vendor: MATSHITA  Model: CD-R   CW-7502    Rev: 4.17
Dec 28 15:14:50 fallguy kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
Dec 28 15:14:50 fallguy kernel: (scsi0:A:6): 10.000MB/s transfers (10.000MHz, offset 8)
Dec 28 15:14:50 fallguy kernel: scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.4
Dec 28 15:14:50 fallguy kernel:         <Adaptec aic7895 Ultra SCSI adapter>
Dec 28 15:14:51 fallguy kernel:         aic7895C: Ultra Wide Channel B, SCSI Id=7, 32/253 SCBs
Dec 28 15:14:51 fallguy kernel: 
Dec 28 15:14:51 fallguy kernel: (scsi1:A:0): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
Dec 28 15:14:51 fallguy kernel:   Vendor: IBM       Model: DNES-318350W      Rev: SA30
Dec 28 15:14:51 fallguy kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Dec 28 15:14:51 fallguy kernel: (scsi1:A:1): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
Dec 28 15:14:51 fallguy kernel:   Vendor: IBM       Model: DGHS09U           Rev: 0350
Dec 28 15:14:51 fallguy kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Dec 28 15:14:51 fallguy kernel: scsi1:A:0:0: Tagged Queuing enabled.  Depth 16
Dec 28 15:14:51 fallguy kernel: SCSI device sda: drive cache: write through
Dec 28 15:14:51 fallguy kernel: SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
Dec 28 15:14:51 fallguy kernel:  sda: sda1 sda2 sda3 sda4
Dec 28 15:14:51 fallguy kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Dec 28 15:14:51 fallguy kernel: scsi1:A:1:0: Tagged Queuing enabled.  Depth 16
Dec 28 15:14:51 fallguy kernel: SCSI device sdb: drive cache: write through
Dec 28 15:14:51 fallguy kernel: SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
Dec 28 15:14:51 fallguy kernel:  sdb: sdb1 sdb2 sdb3
Dec 28 15:14:51 fallguy kernel: Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

Let me know if you want me to provide more information, or try something.

Regards, Willem Riede.
