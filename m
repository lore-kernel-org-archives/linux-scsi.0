From: Clem Pryke <pryke@focus.uchicago.edu>
Subject: adp94xx driver cause system crash
Date: Mon, 25 Sep 2006 15:27:44 -0500
Message-ID: <200609252027.k8PKRi4F016783@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_9822759860"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from focus.uchicago.edu ([128.135.70.184]:19346 "EHLO
	focus.uchicago.edu") by vger.kernel.org with ESMTP id S1751069AbWIYU1t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 16:27:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pryke@focus.uchicago.edu

This is a multipart MIME message.

--==_Exmh_9822759860
Content-Type: text/plain; charset=us-ascii

I have a quad AMD64 system (Tyan S4882UG2NR-D motherboard) with 16GB RAM 
running RHEL4 update 1 (stock 2.6.9-11.ELsmp kernel).

I purchased and installed an Adaptec 58300 SAS controller card.

I downloaded and installed Adaptec adp94xx driver module (version 
adp94xx-1.2.5918-rhel4, rpm package adp94xx.rhel4qu1.x86_64.rpm).

modprobe adp94xx caused all 12 drives to be attached and appear in 
/proc/scsi/scsi. Drives were setup as single partition using parted and slaved 
together as 11 disk raid 5 array with 1 hot spare using mdadm. Array re-sync 
was proceeding normally.

After approx 1 hour error messages concerning one of the disks appeared. 15 
min later same error again, but this time more messages followed by HARD CRASH 
of the system. Kernel panic type stuff on console.

Any help or info regarding similar experiences much appreciated.

Relevant part of /var/log/messages output attached.

Clem



--==_Exmh_9822759860
Content-Type: text/plain ; name="messages_edit.txt"; charset=us-ascii
Content-Description: messages_edit.txt
Content-Disposition: attachment; filename="messages_edit.txt"

Sep 13 16:56:04 find kernel: adp94xx: no version for "struct_module" found: kernel tainted.
Sep 13 16:56:04 find kernel: adp94xx: module license 'Adaptec' taints kernel.
Sep 13 16:56:04 find kernel: adp94xx: 1.2.5918.0
Sep 13 16:56:04 find kernel: ACPI: PCI interrupt 0000:02:02.0[A] -> GSI 26 (level, low) -> IRQ 201
Sep 13 16:56:04 find kernel: XNotify: Event 0x2
Sep 13 16:56:04 find kernel: XNotify: Event 0x3
Sep 13 16:56:05 find kernel: XNotify: Event 0x10000
Sep 13 16:56:05 find last message repeated 11 times
Sep 13 16:56:05 find kernel: Disc:alloc ldev 0 0
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 1
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 2
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 4
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 5
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 6
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 8
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 9
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 10
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 12
Sep 13 16:56:05 find kernel: Disc:alloc ldev 2 13
Sep 13 16:56:05 find kernel: Disc:alloc ldev 5 0
Sep 13 16:56:05 find kernel: scsi2 : Adaptec adp94xx SAS/SATA HostRAID Controller
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi0:0:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdc: drive cache: write back
Sep 13 16:56:05 find kernel:  sdc: unknown partition table
Sep 13 16:56:05 find scsi.agent[5800]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:0:0/2:0:0:0
Sep 13 16:56:05 find scsi.agent[5820]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:1/2:2:1:0
Sep 13 16:56:05 find kernel: Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Sep 13 16:56:05 find scsi.agent[5844]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:2/2:2:2:0
Sep 13 16:56:05 find scsi.agent[5880]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:5/2:2:5:0
Sep 13 16:56:05 find scsi.agent[5859]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:4/2:2:4:0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:1:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find scsi.agent[5994]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:8/2:2:8:0
Sep 13 16:56:05 find kernel: SCSI device sdd: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find scsi.agent[5973]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:6/2:2:6:0
Sep 13 16:56:05 find scsi.agent[6030]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:9/2:2:9:0
Sep 13 16:56:05 find scsi.agent[6051]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:10/2:2:10:0
Sep 13 16:56:05 find scsi.agent[6069]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:12/2:2:12:0
Sep 13 16:56:05 find kernel: SCSI device sdd: drive cache: write back
Sep 13 16:56:05 find kernel:  sdd: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdd at scsi2, channel 2, id 1, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find scsi.agent[6135]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:2:13/2:2:13:0
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:2:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sde: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find scsi.agent[6161]: disk at /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:5:0/2:5:0:0
Sep 13 16:56:05 find kernel: SCSI device sde: drive cache: write back
Sep 13 16:56:05 find kernel:  sde: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sde at scsi2, channel 2, id 2, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:4:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdf: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdf: drive cache: write back
Sep 13 16:56:05 find kernel:  sdf: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdf at scsi2, channel 2, id 4, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:5:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdg: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdg: drive cache: write back
Sep 13 16:56:05 find kernel:  sdg: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdg at scsi2, channel 2, id 5, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:6:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdh: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdh: drive cache: write back
Sep 13 16:56:05 find kernel:  sdh: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdh at scsi2, channel 2, id 6, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:8:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdi: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdi: drive cache: write back
Sep 13 16:56:05 find kernel:  sdi: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdi at scsi2, channel 2, id 8, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:9:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdj: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:05 find kernel: SCSI device sdj: drive cache: write back
Sep 13 16:56:05 find kernel:  sdj: unknown partition table
Sep 13 16:56:05 find kernel: Attached scsi disk sdj at scsi2, channel 2, id 9, lun 0
Sep 13 16:56:05 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:05 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:05 find kernel: scsi2:10:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:05 find kernel: SCSI device sdk: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:06 find kernel: SCSI device sdk: drive cache: write back
Sep 13 16:56:06 find kernel:  sdk: unknown partition table
Sep 13 16:56:06 find kernel: Attached scsi disk sdk at scsi2, channel 2, id 10, lun 0
Sep 13 16:56:06 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:06 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:06 find kernel: scsi2:12:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:06 find kernel: SCSI device sdl: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:06 find kernel: SCSI device sdl: drive cache: write back
Sep 13 16:56:06 find kernel:  sdl: unknown partition table
Sep 13 16:56:06 find kernel: Attached scsi disk sdl at scsi2, channel 2, id 12, lun 0
Sep 13 16:56:06 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:06 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:06 find kernel: scsi2:13:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:06 find kernel: SCSI device sdm: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:06 find kernel: SCSI device sdm: drive cache: write back
Sep 13 16:56:06 find kernel:  sdm: unknown partition table
Sep 13 16:56:06 find kernel: Attached scsi disk sdm at scsi2, channel 2, id 13, lun 0
Sep 13 16:56:06 find kernel:   Vendor: ST375064  Model: 0AS               Rev: 3.AA
Sep 13 16:56:06 find kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Sep 13 16:56:06 find kernel: scsi5:0:0: Tagged Queuing enabled. Depth 32
Sep 13 16:56:06 find kernel: SCSI device sdn: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 16:56:06 find kernel: SCSI device sdn: drive cache: write back
Sep 13 16:56:06 find kernel:  sdn: unknown partition table
Sep 13 16:56:06 find kernel: Attached scsi disk sdn at scsi2, channel 5, id 0, lun 0
Sep 13 17:00:01 find crond(pam_unix)[6270]: session opened for user root by (uid=0)
Sep 13 17:00:01 find crond(pam_unix)[6270]: session closed for user root
Sep 13 17:01:01 find crond(pam_unix)[6277]: session opened for user root by (uid=0)
Sep 13 17:01:01 find crond(pam_unix)[6277]: session closed for user root
Sep 13 17:06:22 find sshd(pam_unix)[6292]: session opened for user pryke by (uid=0)
Sep 13 17:10:01 find crond(pam_unix)[6428]: session opened for user root by (uid=0)
Sep 13 17:10:01 find crond(pam_unix)[6428]: session closed for user root
Sep 13 17:13:42 find kernel: SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 17:13:42 find kernel: SCSI device sdc: drive cache: write back
Sep 13 17:13:42 find kernel:  sdc: sdc1
Sep 13 17:13:44 find kernel: SCSI device sdc: 1465149168 512-byte hdwr sectors (750156 MB)
Sep 13 17:13:44 find kernel: SCSI device sdc: drive cache: write back
Sep 13 17:13:44 find kernel:  sdc: sdc1
Sep 13 17:20:01 find crond(pam_unix)[6560]: session opened for user root by (uid=0)
Sep 13 17:20:01 find crond(pam_unix)[6560]: session closed for user root
Sep 13 17:30:01 find crond(pam_unix)[7222]: session opened for user root by (uid=0)
Sep 13 17:30:01 find crond(pam_unix)[7222]: session closed for user root
Sep 13 17:36:16 find kernel: md: couldn't update array info. -22
Sep 13 17:36:32 find kernel: md: bind<sdc1>
Sep 13 17:36:32 find kernel: md: bind<sdd1>
Sep 13 17:36:32 find kernel: md: bind<sde1>
Sep 13 17:36:32 find kernel: md: bind<sdf1>
Sep 13 17:36:32 find kernel: md: bind<sdg1>
Sep 13 17:36:32 find kernel: md: bind<sdh1>
Sep 13 17:36:32 find kernel: md: bind<sdi1>
Sep 13 17:36:32 find kernel: md: bind<sdj1>
Sep 13 17:36:32 find kernel: md: bind<sdk1>
Sep 13 17:36:32 find kernel: md: bind<sdl1>
Sep 13 17:36:32 find kernel: md: bind<sdn1>
Sep 13 17:36:32 find kernel: md: bind<sdm1>
Sep 13 17:36:32 find kernel: raid5: device sdl1 operational as raid disk 9
Sep 13 17:36:32 find kernel: raid5: device sdk1 operational as raid disk 8
Sep 13 17:36:32 find kernel: raid5: device sdj1 operational as raid disk 7
Sep 13 17:36:32 find kernel: raid5: device sdi1 operational as raid disk 6
Sep 13 17:36:32 find kernel: raid5: device sdh1 operational as raid disk 5
Sep 13 17:36:32 find kernel: raid5: device sdg1 operational as raid disk 4
Sep 13 17:36:32 find kernel: raid5: device sdf1 operational as raid disk 3
Sep 13 17:36:32 find kernel: raid5: device sde1 operational as raid disk 2
Sep 13 17:36:32 find kernel: raid5: device sdd1 operational as raid disk 1
Sep 13 17:36:32 find kernel: raid5: device sdc1 operational as raid disk 0
Sep 13 17:36:32 find kernel: raid5: allocated 11612kB for md1
Sep 13 17:36:32 find kernel: raid5: raid level 5 set md1 active with 10 out of 11 devices, algorithm 2
Sep 13 17:36:32 find kernel: RAID5 conf printout:
Sep 13 17:36:32 find kernel:  --- rd:11 wd:10 fd:1
Sep 13 17:36:32 find kernel:  disk 0, o:1, dev:sdc1
Sep 13 17:36:32 find kernel:  disk 1, o:1, dev:sdd1
Sep 13 17:36:32 find kernel:  disk 2, o:1, dev:sde1
Sep 13 17:36:32 find kernel:  disk 3, o:1, dev:sdf1
Sep 13 17:36:32 find kernel:  disk 4, o:1, dev:sdg1
Sep 13 17:36:32 find kernel:  disk 5, o:1, dev:sdh1
Sep 13 17:36:32 find kernel:  disk 6, o:1, dev:sdi1
Sep 13 17:36:32 find kernel:  disk 7, o:1, dev:sdj1
Sep 13 17:36:32 find kernel:  disk 8, o:1, dev:sdk1
Sep 13 17:36:32 find kernel:  disk 9, o:1, dev:sdl1
Sep 13 17:36:32 find kernel: RAID5 conf printout:
Sep 13 17:36:32 find kernel:  --- rd:11 wd:10 fd:1
Sep 13 17:36:32 find kernel:  disk 0, o:1, dev:sdc1
Sep 13 17:36:32 find kernel:  disk 1, o:1, dev:sdd1
Sep 13 17:36:32 find kernel:  disk 2, o:1, dev:sde1
Sep 13 17:36:32 find kernel:  disk 3, o:1, dev:sdf1
Sep 13 17:36:32 find kernel:  disk 4, o:1, dev:sdg1
Sep 13 17:36:32 find kernel:  disk 5, o:1, dev:sdh1
Sep 13 17:36:32 find kernel:  disk 6, o:1, dev:sdi1
Sep 13 17:36:32 find kernel:  disk 7, o:1, dev:sdj1
Sep 13 17:36:32 find kernel:  disk 8, o:1, dev:sdk1
Sep 13 17:36:32 find kernel:  disk 9, o:1, dev:sdl1
Sep 13 17:36:33 find kernel:  disk 10, o:1, dev:sdm1
Sep 13 17:36:33 find kernel: RAID5 conf printout:
Sep 13 17:36:33 find kernel:  --- rd:11 wd:10 fd:1
Sep 13 17:36:33 find kernel:  disk 0, o:1, dev:sdc1
Sep 13 17:36:33 find kernel:  disk 1, o:1, dev:sdd1
Sep 13 17:36:33 find kernel:  disk 2, o:1, dev:sde1
Sep 13 17:36:33 find kernel:  disk 3, o:1, dev:sdf1
Sep 13 17:36:33 find kernel:  disk 4, o:1, dev:sdg1
Sep 13 17:36:33 find kernel:  disk 5, o:1, dev:sdh1
Sep 13 17:36:33 find kernel:  disk 6, o:1, dev:sdi1
Sep 13 17:36:33 find kernel:  disk 7, o:1, dev:sdj1
Sep 13 17:36:33 find kernel:  disk 8, o:1, dev:sdk1
Sep 13 17:36:33 find kernel:  disk 9, o:1, dev:sdl1
Sep 13 17:36:33 find kernel:  disk 10, o:1, dev:sdm1
Sep 13 17:36:33 find kernel: md: syncing RAID array md1
Sep 13 17:36:33 find kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Sep 13 17:36:33 find kernel: md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
Sep 13 17:36:33 find kernel: md: using 128k window, over a total of 732574464 blocks.
Sep 13 17:40:01 find crond(pam_unix)[7236]: session opened for user root by (uid=0)
Sep 13 17:40:01 find crond(pam_unix)[7236]: session closed for user root
Sep 13 17:49:32 find sshd(pam_unix)[7263]: session opened for user john by (uid=0)
Sep 13 17:49:34 find sshd(pam_unix)[7263]: session closed for user john
Sep 13 17:49:40 find sshd(pam_unix)[7281]: session opened for user john by (uid=0)
Sep 13 17:50:01 find crond(pam_unix)[7296]: session opened for user root by (uid=0)
Sep 13 17:50:01 find crond(pam_unix)[7296]: session closed for user root
Sep 13 17:50:05 find sshd(pam_unix)[7281]: session closed for user john
Sep 13 17:51:04 find sshd(pam_unix)[7304]: session opened for user pryke by (uid=0)
Sep 13 17:51:04 find sshd(pam_unix)[7304]: session closed for user pryke
Sep 13 17:51:09 find sshd(pam_unix)[7324]: session opened for user pryke by (uid=0)
Sep 13 17:51:09 find sshd(pam_unix)[7324]: session closed for user pryke
Sep 13 17:52:18 find sshd(pam_unix)[7345]: session opened for user pryke by (uid=0)
Sep 13 17:52:18 find sshd(pam_unix)[7345]: session closed for user pryke
Sep 13 18:00:01 find crond(pam_unix)[7362]: session opened for user root by (uid=0)
Sep 13 18:00:01 find crond(pam_unix)[7363]: session opened for user quad by (uid=0)
Sep 13 18:00:01 find crond(pam_unix)[7362]: session closed for user root
Sep 13 18:01:01 find crond(pam_unix)[7386]: session opened for user root by (uid=0)
Sep 13 18:01:01 find crond(pam_unix)[7386]: session closed for user root
Sep 13 18:10:01 find crond(pam_unix)[7413]: session opened for user root by (uid=0)
Sep 13 18:10:01 find crond(pam_unix)[7413]: session closed for user root
Sep 13 18:20:01 find crond(pam_unix)[7417]: session opened for user root by (uid=0)
Sep 13 18:20:01 find crond(pam_unix)[7417]: session closed for user root
Sep 13 18:30:01 find crond(pam_unix)[7420]: session opened for user root by (uid=0)
Sep 13 18:30:01 find crond(pam_unix)[7420]: session closed for user root
Sep 13 18:33:36 find kernel: hr_ioreq_timedout:cmd 0x103f170ad80 (2,13,0) opcode 0x2a: Enter
Sep 13 18:33:36 find kernel: hr_reset_lu: ioreq_to_reset: 000001008d5fa000, State: 22, ioreq: 000001008e1f4000, State: 0x1.
Sep 13 18:33:36 find kernel: hr_reset_lu: ioreq_to_reset: 000001008d5fa000, State: 22, ioreq: 000001008e1f4000, State: 0x20.
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9c
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9c
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9d
Sep 13 18:33:36 find last message repeated 4 times
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9e
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9f
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9e
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9f
Sep 13 18:33:36 find last message repeated 6 times
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa0
Sep 13 18:33:36 find last message repeated 6 times
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa1
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa1
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa2
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa2
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0xa3
Sep 13 18:33:36 find last message repeated 2 times
Sep 13 18:33:36 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xb 0x8f 0x9c
Sep 13 18:33:36 find kernel: hr_reset_lu_done, pOSD: 000001008e1f48b0, pOSD_Status: 0x0, ioreq: 000001008e1f4000
Sep 13 18:33:36 find kernel: hr_reset_lu: ioreq_to_reset: 000001008d5fa000, State: 22, ioreq: 000001008e1f4000, State: 0x8.
Sep 13 18:40:01 find crond(pam_unix)[7443]: session opened for user root by (uid=0)
Sep 13 18:40:01 find crond(pam_unix)[7443]: session closed for user root
Sep 13 18:46:10 find crond(pam_unix)[7363]: session closed for user quad
Sep 13 18:48:27 find kernel: hr_ioreq_timedout:cmd 0x103fe548580 (2,13,0) opcode 0x2a: Enter
Sep 13 18:48:27 find kernel: hr_reset_lu: ioreq_to_reset: 0000010088e1e000, State: 22, ioreq: 000001008881f000, State: 0x1.
Sep 13 18:48:27 find kernel: hr_reset_lu: ioreq_to_reset: 0000010088e1e000, State: 22, ioreq: 000001008881f000, State: 0x20.
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xa8
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xa9
Sep 13 18:48:27 find last message repeated 2 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xaa
Sep 13 18:48:27 find last message repeated 5 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xab
Sep 13 18:48:27 find last message repeated 4 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xac
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xac
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xad
Sep 13 18:48:27 find last message repeated 2 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xae
Sep 13 18:48:27 find last message repeated 2 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xaf
Sep 13 18:48:27 find last message repeated 2 times
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xb0
Sep 13 18:48:27 find kernel: hr_ioreq_timedout: cmd 0x101febb91c0 ioreq is already in EH, give it another timer
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xa8
Sep 13 18:48:27 find kernel: PostOSD: DID_ERROR opcode 0x2a 0x0 0xe 0x8c 0xa8
Sep 13 18:48:51 find kernel: XNotify: Event 0xc
Sep 13 18:48:51 find kernel: hr_handle_tmf_req: event 0xc
Sep 13 18:48:51 find kernel: adp94xx: CDA_NOTIFY_EVENT_RESET_OCCURING_ON_ADAPTER
Sep 13 18:48:51 find kernel: XNotify: Event 0x2
Sep 13 18:48:51 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:51 find kernel: hr_reset_lu_done, pOSD: 000001008881f8b0, pOSD_Status: 0x0, ioreq: 000001008881f000
Sep 13 18:48:51 find kernel: hr_reset_lu: ioreq_to_reset: 0000010088e1e000, State: 22, ioreq: 000001008881f000, State: 0x8.
Sep 13 18:48:51 find kernel: XNotify: Event 0x2
Sep 13 18:48:51 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:52 find kernel: XNotify: Event 0x2
Sep 13 18:48:52 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:53 find kernel: XNotify: Event 0x2
Sep 13 18:48:53 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:54 find kernel: XNotify: Event 0x2
Sep 13 18:48:54 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:55 find kernel: XNotify: Event 0x2
Sep 13 18:48:55 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:55 find kernel: XNotify: Event 0x2
Sep 13 18:48:55 find kernel: adp94xx: CDA_NOTIFY_EVENT_SUSPEND_IO
Sep 13 18:48:55 find kernel: XNotify: Event 0x3
Sep 13 18:48:55 find kernel: adp94xx: CDA_NOTIFY_EVENT_RESUME_IO
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000102ffdddcc0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000102856b3a80, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f170c1c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 000001014737c780, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 000001014737b740, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 000001004d9ee2c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103fe548180, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f172b3c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f170a580, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103401e0cc0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000101febb95c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103401e02c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103fe548780, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 0000010176b88b80, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f357dbc0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103fe548d80, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f1700480, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f170a780, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 0000010151b85040, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f1708d40, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000102fd820480, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 000001018f7b2980, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103401e08c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 000001033fcc6100, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 0000010176b88980, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103f1700a80, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000102fcb86b40, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000103fe548580, opcode 0x2a.
Sep 13 18:48:57 find kernel: (scsi2: Ch 2 Id 13 Lun 0): Abort requested for SCSI cmd 00000101febb91c0, opcode 0x2a.
Sep 13 18:48:57 find kernel: scsi: Device offlined - not ready after error recovery: host 2 channel 2 id 13 lun 0
Sep 13 18:48:57 find last message repeated 28 times
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099306
Sep 13 18:48:57 find kernel: raid5: Disk failure on sdm1, disabling device. Operation continuing on 10 devices
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099330
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099362
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099490
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099618
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099626
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099642
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099770
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099818
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099834
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099866
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099874
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244099962
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100050
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100058
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100130
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100258
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100386
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100514
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100586
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100642
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100650
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100754
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100882
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244100898
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244101026
Sep 13 18:48:57 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:57 find kernel: end_request: I/O error, dev sdm, sector 244101154
Sep 13 18:48:57 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:58 find kernel: end_request: I/O error, dev sdm, sector 244099114
Sep 13 18:48:58 find kernel: scsi2 (13:0): rejecting I/O to offline device
Sep 13 18:48:58 find kernel: SCSI error : <2 2 13 0> return code = 0x6000000
Sep 13 18:48:58 find kernel: end_request: I/O error, dev sdm, sector 244099234
Sep 13 18:48:58 find kernel: scsi2 (13:0): rejecting I/O to offline device

Followed by hard crash

--==_Exmh_9822759860--


