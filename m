From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: Re: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Mon, 19 Jan 2004 08:09:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119160958.60827.qmail@web10407.mail.yahoo.com>
References: <20040119052701.GA16779@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10407.mail.yahoo.com ([216.136.130.99]:32903 "HELO
	web10407.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265284AbUASQJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 11:09:59 -0500
In-Reply-To: <20040119052701.GA16779@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

Ok, I don't know if this was the 'right' fix, but I noticed
that the Kconfig file in the qla2xxx directory was different
in the -b9 resync patchset, so I tried copying the old one
back from the plain 2.6.1-mm4 tree, and now I got the
modules built and installed. After enabling debugging and
rebooting -- we now have LUNs! Attached is the output from
/var/log/messages showing the -b9 module loading and finding
the Nexsan arrays and their associated disk volumes. There
are supposed to be two LUNs per array as shown, and now I
have disk devices /dev/sdb - /dev/sde as expected. The
unknown partition table comments are correct also, since
I'm using the raw devices without any partitioning as
members of RAID1 mirror sets.

A couple of minor points:

- It appears that the patched driver still reports itself
  as v8.00.00b8-debug, rather than b9.

- Someone noted this on the list before I think, but I also
  noticed it: when you unload and re-load the qla2300 module,
  it appears to not be decrementing some counter. The first
  time, you get /proc/scsi/qla2xxx/2 and /proc/scsi/qla2xxx/3,
  and the second time you get /4 and /5, and so forth, each
  time you re-load. The logical names of the scsi devices
  are not affected, just the numbers in the /proc/scsi/qla2xxx
  directory.

/var/log/messages
-----------------------------------------------------------
Jan 19 07:55:14 thing2 kernel: QLogic Fibre Channel HBA Driver (f88bd000)
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: Found an ISP2312, irq
25, iobase 0xf8895000
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: Configuring PCI
space...
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: Configure NVRAM
parameters...
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: Verifying loaded RISC
code...
Jan 19 07:55:20 thing2 kernel: scsi(2): **** Load RISC code ****
Jan 19 07:55:20 thing2 kernel: scsi(2): Verifying Checksum of loaded RISC
code.
Jan 19 07:55:20 thing2 kernel: scsi(2): Checksum OK, start firmware.
Jan 19 07:55:20 thing2 kernel: scsi(2): Issue init firmware.
Jan 19 07:55:20 thing2 kernel: scsi(2): Asynchronous LIP RESET (f8f7).
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: LIP reset occured
(f8f7).
Jan 19 07:55:20 thing2 kernel: qla2300 0000:01:02.0: Waiting for LIP to
complete...
Jan 19 07:55:21 thing2 kernel: scsi(2): LIP occured (f8f7).
Jan 19 07:55:21 thing2 kernel: qla2300 0000:01:02.0: LIP occured (f8f7).
Jan 19 07:55:21 thing2 kernel: scsi(2): Asynchronous LOOP UP (2 Gbps).
Jan 19 07:55:21 thing2 kernel: qla2300 0000:01:02.0: LOOP UP detected (2
Gbps).
Jan 19 07:55:21 thing2 kernel: scsi(2): Asynchronous PORT UPDATE.
Jan 19 07:55:21 thing2 kernel: scsi(2): Port database changed ffff 0006.
Jan 19 07:55:21 thing2 kernel: scsi(2): F/W Ready - OK 
Jan 19 07:55:21 thing2 kernel: scsi(2): fw_state=3 curr time=fffe433e.
Jan 19 07:55:21 thing2 kernel: qla2300 0000:01:02.0: Topology - (Loop), Host
Loop address 0x1
Jan 19 07:55:21 thing2 kernel: scsi(2): Configure loop -- dpc flags =0x80040
Jan 19 07:55:22 thing2 kernel: qla2x00_mailbox_command(2): **** FAILED.
mbx0=4006, mbx1=7e, mbx2=0, cmd=6a ****
Jan 19 07:55:22 thing2 kernel: qla2x00_get_port_name(2): failed=102.
Jan 19 07:55:22 thing2 kernel: scsi(2): MBC_GET_PORT_NAME Failed, No FL Port
Jan 19 07:55:22 thing2 kernel: scsi(2): Alloc Target 0 @ f7a4b800
Jan 19 07:55:22 thing2 kernel: scsi(2): Assigning target ID=00 @ f7a4b800 to
loop id=0x0000, port state=0x4, port down retry=60
Jan 19 07:55:22 thing2 kernel: scsi(2): Alloc Lun 0 @ tgt 0.
Jan 19 07:55:22 thing2 kernel: scsi(2): Alloc Lun 1 @ tgt 0.
Jan 19 07:55:22 thing2 kernel: scsi(2): LOOP READY
Jan 19 07:55:22 thing2 kernel: DEBUG: detect hba 2 at address = f6c9c1b8
Jan 19 07:55:22 thing2 kernel: scsi2 : qla2xxx
Jan 19 07:55:22 thing2 kernel: qla2300 0000:01:02.0: 
Jan 19 07:55:22 thing2 kernel:  QLogic Fibre Channel HBA Driver:
8.00.00b8-debug
Jan 19 07:55:22 thing2 kernel:   QLogic QLA2340 - 
Jan 19 07:55:22 thing2 kernel:   ISP2312: PCI (66 MHz) @ 0000:01:02.0 hdma-,
host#=2, fw=3.02.20 IPX
Jan 19 07:55:22 thing2 kernel:   Vendor: NEXSAN    Model: ATAboy(821DFC56) 
Rev: 5020
Jan 19 07:55:22 thing2 kernel:   Type:   Direct-Access                     
ANSI SCSI revision: 04
Jan 19 07:55:22 thing2 kernel: qla2300 0000:01:02.0: scsi(2:0:0:0): Enabled
tagged queuing, queue depth 32.
Jan 19 07:55:23 thing2 kernel: SCSI device sdb: 3904296875 512-byte hdwr
sectors (1999000 MB)
Jan 19 07:55:23 thing2 kernel: SCSI device sdb: drive cache: write back
Jan 19 07:55:23 thing2 kernel:  sdb: unknown partition table
Jan 19 07:55:23 thing2 kernel: Attached scsi disk sdb at scsi2, channel 0,
id 0, lun 0
Jan 19 07:55:23 thing2 kernel: Attached scsi generic sg2 at scsi2, channel
0, id 0, lun 0,  type 0
Jan 19 07:55:23 thing2 kernel: scsi(2:0:0) UNDERRUN status detected
0x15-0x800.
Jan 19 07:55:23 thing2 kernel:   Vendor: NEXSAN    Model: ATAboy(821DFC56) 
Rev: 5020
Jan 19 07:55:23 thing2 kernel:   Type:   Direct-Access                     
ANSI SCSI revision: 04
Jan 19 07:55:23 thing2 kernel: qla2300 0000:01:02.0: scsi(2:0:0:1): Enabled
tagged queuing, queue depth 32.
Jan 19 07:55:23 thing2 kernel: SCSI device sdc: 196367187 512-byte hdwr
sectors (100540 MB)
Jan 19 07:55:23 thing2 kernel: SCSI device sdc: drive cache: write back
Jan 19 07:55:23 thing2 kernel:  sdc: unknown partition table
Jan 19 07:55:23 thing2 kernel: Attached scsi disk sdc at scsi2, channel 0,
id 0, lun 1
Jan 19 07:55:23 thing2 kernel: Attached scsi generic sg3 at scsi2, channel
0, id 0, lun 1,  type 0
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: Found an ISP2312, irq
25, iobase 0xf889b000
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: Configuring PCI
space...
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: Configure NVRAM
parameters...
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: Verifying loaded RISC
code...
Jan 19 07:55:24 thing2 kernel: scsi(3): **** Load RISC code ****
Jan 19 07:55:24 thing2 kernel: scsi(3): Verifying Checksum of loaded RISC
code.
Jan 19 07:55:24 thing2 kernel: scsi(3): Checksum OK, start firmware.
Jan 19 07:55:24 thing2 kernel: scsi(3): Issue init firmware.
Jan 19 07:55:24 thing2 kernel: scsi(3): Asynchronous LIP RESET (f8f7).
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: LIP reset occured
(f8f7).
Jan 19 07:55:24 thing2 kernel: qla2300 0000:01:03.0: Waiting for LIP to
complete...
Jan 19 07:55:25 thing2 kernel: scsi(3): LIP occured (f8f7).
Jan 19 07:55:25 thing2 kernel: qla2300 0000:01:03.0: LIP occured (f8f7).
Jan 19 07:55:25 thing2 kernel: scsi(3): Asynchronous LOOP UP (2 Gbps).
Jan 19 07:55:25 thing2 kernel: qla2300 0000:01:03.0: LOOP UP detected (2
Gbps).
Jan 19 07:55:25 thing2 kernel: scsi(3): Asynchronous PORT UPDATE.
Jan 19 07:55:25 thing2 kernel: scsi(3): Port database changed ffff 0006.
Jan 19 07:55:25 thing2 kernel: scsi(3): F/W Ready - OK 
Jan 19 07:55:25 thing2 kernel: scsi(3): fw_state=3 curr time=fffe51b1.
Jan 19 07:55:25 thing2 kernel: qla2300 0000:01:03.0: Topology - (Loop), Host
Loop address 0x1
Jan 19 07:55:25 thing2 kernel: scsi(3): Configure loop -- dpc flags =0x80040
Jan 19 07:55:25 thing2 kernel: qla2x00_mailbox_command(3): **** FAILED.
mbx0=4006, mbx1=7e, mbx2=0, cmd=6a ****
Jan 19 07:55:25 thing2 kernel: qla2x00_get_port_name(3): failed=102.
Jan 19 07:55:25 thing2 kernel: scsi(3): MBC_GET_PORT_NAME Failed, No FL Port
Jan 19 07:55:25 thing2 kernel: scsi(3): Alloc Target 0 @ f6cf1800
Jan 19 07:55:25 thing2 kernel: scsi(3): Assigning target ID=00 @ f6cf1800 to
loop id=0x0000, port state=0x4, port down retry=60
Jan 19 07:55:26 thing2 kernel: scsi(3): Alloc Lun 0 @ tgt 0.
Jan 19 07:55:26 thing2 kernel: scsi(3): Alloc Lun 1 @ tgt 0.
Jan 19 07:55:26 thing2 kernel: scsi(3): LOOP READY
Jan 19 07:55:26 thing2 kernel: DEBUG: detect hba 3 at address = f6bf01b8
Jan 19 07:55:26 thing2 kernel: scsi3 : qla2xxx
Jan 19 07:55:26 thing2 kernel: qla2300 0000:01:03.0: 
Jan 19 07:55:26 thing2 kernel:  QLogic Fibre Channel HBA Driver:
8.00.00b8-debug
Jan 19 07:55:26 thing2 kernel:   QLogic QLA2340 - 
Jan 19 07:55:26 thing2 kernel:   ISP2312: PCI (66 MHz) @ 0000:01:03.0 hdma-,
host#=3, fw=3.02.20 IPX
Jan 19 07:55:26 thing2 kernel:   Vendor: NEXSAN    Model: ATAboy(821DFC55) 
Rev: 5020
Jan 19 07:55:26 thing2 kernel:   Type:   Direct-Access                     
ANSI SCSI revision: 04
Jan 19 07:55:26 thing2 kernel: qla2300 0000:01:03.0: scsi(3:0:0:0): Enabled
tagged queuing, queue depth 32.
Jan 19 07:55:26 thing2 kernel: SCSI device sdd: 3904296875 512-byte hdwr
sectors (1999000 MB)
Jan 19 07:55:26 thing2 kernel: SCSI device sdd: drive cache: write back
Jan 19 07:55:26 thing2 kernel:  sdd: unknown partition table
Jan 19 07:55:26 thing2 kernel: Attached scsi disk sdd at scsi3, channel 0,
id 0, lun 0
Jan 19 07:55:26 thing2 kernel: Attached scsi generic sg4 at scsi3, channel
0, id 0, lun 0,  type 0
Jan 19 07:55:27 thing2 kernel: scsi(3:0:0) UNDERRUN status detected
0x15-0x800.
Jan 19 07:55:27 thing2 kernel:   Vendor: NEXSAN    Model: ATAboy(821DFC55) 
Rev: 5020
Jan 19 07:55:27 thing2 kernel:   Type:   Direct-Access                     
ANSI SCSI revision: 04
Jan 19 07:55:27 thing2 kernel: qla2300 0000:01:03.0: scsi(3:0:0:1): Enabled
tagged queuing, queue depth 32.
Jan 19 07:55:27 thing2 kernel: SCSI device sde: 196367187 512-byte hdwr
sectors (100540 MB)
Jan 19 07:55:27 thing2 kernel: SCSI device sde: drive cache: write back
Jan 19 07:55:27 thing2 kernel:  sde: unknown partition table
Jan 19 07:55:27 thing2 kernel: Attached scsi disk sde at scsi3, channel 0,
id 0, lun 1
Jan 19 07:55:27 thing2 kernel: Attached scsi generic sg5 at scsi3, channel
0, id 0, lun 1,  type 0
----------------------------------------------------



__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
