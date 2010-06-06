From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: Still havind major MVSAS issues.
Date: Sun, 06 Jun 2010 14:13:16 +0200
Message-ID: <4C0B90DC.6070800@powercraft.nl>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>       <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>       <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>       <CDBC7B5488B245E689B39330542DC434@usish.com.cn>       <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>       <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>       <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org> <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org> <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060005030707020301080602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:52584 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab0FFMNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2010 08:13:20 -0400
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: Caspar Smit <c.smit@truebit.nl>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yugendranath R Singh - ERS, HCL Tech" <yugendranath.s@hcl.in>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.in>, "Mohan Kumar TG, ERS,HCLTech" <mohankumartg@hcl.in>

This is a multi-part message in MIME format.
--------------060005030707020301080602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear Srini,

I spent a few weeks catering information and did some intensive
testing the last few days.

Srinivas Naga Venkatasatya Pasagadugula wrote, on 06-05-10 08:01:
> 1. Is this is the problem with only WD SATA drives? (I don't have WD SATA drives to reproduce this issue.)
> 2. Whether the problem is with direct attached SATA drives or drives connected in expanders also?
> 3. Could you please provide me the "dmesg" log or "/var/log/messages" log.  
> 4. How much the capacity of SATA drives connected to controller?
> 5. Your HBA is having 6440 chipset? 

With a few tricks I managed to boot my OS from the mvsas controller. I
got eleven different sata disks attached from a 4-port mini-sas
backplate without expander to the two Marvel 88SE63xx/64xx mvsas
controllers in my system.

I managed to add five mdadm raid1 arrays without added the actual
active sync device (so one disk for each array) I build my lvm systems
on top of this and did a lot of file transfers for testing.

This worked stable enough, there are HDIO_GET_IDENTITY errors during
boot and operation, but the hard disks seem to be working.

So to debug if issues are related to some brand of harddisk, I started
to add WDC, Hitachi, SAMSUNG, Maxtor and Seagate disks to the
respected raid1 array, the disks are of different sizes (320GB, 500GB,
1TB.)

The sync starts and will fail directly or a while later on failures in
the mvsas driver. I attached an failure example as attachment.

The failures are of grave severity, I have lost complete lvm2 volumes
and raid arrays during testing.

Do you also have a SuperMicro AOC-SASLP-MV8 controller for testing?

I would love to use the controllers for production, but they are
currently unstable. I hope this information helps to solve the mvsas
issues?

With kind regards,

Jelle de Jong

--------------060005030707020301080602
Content-Type: text/plain;
 name="melany-kernel-debug04.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="melany-kernel-debug04.txt"

#-----------------------------------------------------------------------

2010-06-96 mvsas kernel module issues

#-----------------------------------------------------------------------

# the system seems to be stable without using an active synced raid1 array, on the moment I add a drive to the raid1 array so it can start syncing the mvsas driver is ginging errors locking the hole raid array

# raid1 with /dev/md5 will lockup causing all lvm systems using teh md5 to lockup, system reboot fails at shuting down lvm volumes, SysRq b is needed to reboot.

#-----------------------------------------------------------------------

# lspci -nn | grep SCSI
02:00.0 SCSI storage controller [0100]: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B [11ab:6485] (rev 01)
03:00.0 SCSI storage controller [0100]: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B [11ab:6485] (rev 01)

#-----------------------------------------------------------------------

Jun  6 13:22:45 melany kernel: [58739.130711] md: bind<sdg1>
Jun  6 13:22:45 melany mdadm[2484]: RebuildStarted event detected on md device /dev/md5
Jun  6 13:22:45 melany kernel: [58739.174013] RAID1 conf printout:
Jun  6 13:22:45 melany kernel: [58739.174016]  --- wd:1 rd:2
Jun  6 13:22:45 melany kernel: [58739.174018]  disk 0, wo:0, o:1, dev:sdb1
Jun  6 13:22:45 melany kernel: [58739.174019]  disk 1, wo:1, o:1, dev:sdg1
Jun  6 13:22:45 melany kernel: [58739.174399] md: recovery of RAID array md5
Jun  6 13:22:45 melany kernel: [58739.174400] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jun  6 13:22:45 melany kernel: [58739.174402] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jun  6 13:22:45 melany kernel: [58739.174405] md: using 128k window, over a total of 312560576 blocks.
Jun  6 13:23:16 melany kernel: [58769.804083] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:23:16 melany kernel: [58769.804087] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:23:46 melany kernel: [58799.816089] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:23:46 melany kernel: [58799.816093] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:24:17 melany kernel: [58830.816071] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:24:17 melany kernel: [58830.816075] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:24:29 melany kernel: [58842.961180] raid1: Disk failure on sdg1, disabling device.
Jun  6 13:24:29 melany kernel: [58842.961181] raid1: Operation continuing on 1 devices.
Jun  6 13:25:00 melany kernel: [58873.816103] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:25:00 melany kernel: [58873.816107] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:25:31 melany kernel: [58904.816073] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:25:31 melany kernel: [58904.816077] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:25:46 melany kernel: [58920.532075] INFO: task md5_resync:2813 blocked for more than 120 seconds.
Jun  6 13:25:46 melany kernel: [58920.532083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  6 13:25:46 melany kernel: [58920.532091] md5_resync    D 0000000000000000     0  2813      2 0x00000000
Jun  6 13:25:46 melany kernel: [58920.532094]  ffffffff814471f0 0000000000000046 0000000000000000 ffffffff8104a0b8
Jun  6 13:25:46 melany kernel: [58920.532097]  0000000000000086 0000000000000086 000000000000f8a0 ffff880029657fd8
Jun  6 13:25:46 melany kernel: [58920.532099]  00000000000155c0 00000000000155c0 ffff88006e74b170 ffff88006e74b468
Jun  6 13:25:46 melany kernel: [58920.532102] Call Trace:
Jun  6 13:25:46 melany kernel: [58920.532108]  [<ffffffff8104a0b8>] ? try_to_wake_up+0x249/0x259
Jun  6 13:25:46 melany kernel: [58920.532112]  [<ffffffff8103aa9c>] ? __wake_up_common+0x44/0x72
Jun  6 13:25:46 melany kernel: [58920.532119]  [<ffffffffa01a2424>] ? raise_barrier+0x12c/0x163 [raid1]
Jun  6 13:25:46 melany kernel: [58920.532122]  [<ffffffff8104a0c8>] ? default_wake_function+0x0/0x9
Jun  6 13:25:46 melany kernel: [58920.532124]  [<ffffffff8104a0b8>] ? try_to_wake_up+0x249/0x259
Jun  6 13:25:46 melany kernel: [58920.532127]  [<ffffffffa01a2ed7>] ? sync_request+0x177/0x512 [raid1]
Jun  6 13:25:46 melany kernel: [58920.532131]  [<ffffffffa018b2f1>] ? is_mddev_idle+0xaa/0xfd [md_mod]
Jun  6 13:25:46 melany kernel: [58920.532135]  [<ffffffffa018ba2f>] ? md_do_sync+0x6eb/0xaf6 [md_mod]
Jun  6 13:25:46 melany kernel: [58920.532140]  [<ffffffffa018c664>] ? md_thread+0xf1/0x10f [md_mod]
Jun  6 13:25:46 melany kernel: [58920.532142]  [<ffffffff8103aa9c>] ? __wake_up_common+0x44/0x72
Jun  6 13:25:46 melany kernel: [58920.532145]  [<ffffffffa018c573>] ? md_thread+0x0/0x10f [md_mod]
Jun  6 13:25:46 melany kernel: [58920.532148]  [<ffffffff810644d1>] ? kthread+0x79/0x81
Jun  6 13:25:46 melany kernel: [58920.532151]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Jun  6 13:25:46 melany kernel: [58920.532153]  [<ffffffff81064458>] ? kthread+0x0/0x81
Jun  6 13:25:46 melany kernel: [58920.532155]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Jun  6 13:26:02 melany kernel: [58935.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:26:02 melany kernel: [58935.816075] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:26:02 melany kernel: [58935.816095] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816096] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816099] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 26 41 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816104] end_request: I/O error, dev sdb, sector 75329
Jun  6 13:26:02 melany kernel: [58935.816123] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816124] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816126] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 25 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816130] end_request: I/O error, dev sdb, sector 75073
Jun  6 13:26:02 melany kernel: [58935.816138] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816139] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816141] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 24 c1 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816145] end_request: I/O error, dev sdb, sector 74945
Jun  6 13:26:02 melany kernel: [58935.816152] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816153] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816154] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 23 c1 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816158] end_request: I/O error, dev sdb, sector 74689
Jun  6 13:26:02 melany kernel: [58935.816165] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816166] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816168] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 23 41 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816172] end_request: I/O error, dev sdb, sector 74561
Jun  6 13:26:02 melany kernel: [58935.816179] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816180] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816182] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 22 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816185] end_request: I/O error, dev sdb, sector 74305
Jun  6 13:26:02 melany kernel: [58935.816192] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816194] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816195] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 21 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816199] end_request: I/O error, dev sdb, sector 74049
Jun  6 13:26:02 melany kernel: [58935.816206] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816207] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816209] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 20 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816213] end_request: I/O error, dev sdb, sector 73793
Jun  6 13:26:02 melany kernel: [58935.816220] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816221] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816223] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1f 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816226] end_request: I/O error, dev sdb, sector 73537
Jun  6 13:26:02 melany kernel: [58935.816234] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816235] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816237] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1d c1 00 01 80 00
Jun  6 13:26:02 melany kernel: [58935.816241] end_request: I/O error, dev sdb, sector 73153
Jun  6 13:26:02 melany kernel: [58935.816248] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816249] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816251] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1c c1 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816255] end_request: I/O error, dev sdb, sector 72897
Jun  6 13:26:02 melany kernel: [58935.816262] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816263] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816265] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1c 41 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816269] end_request: I/O error, dev sdb, sector 72769
Jun  6 13:26:02 melany kernel: [58935.816276] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816277] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816279] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1b c1 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816282] end_request: I/O error, dev sdb, sector 72641
Jun  6 13:26:02 melany kernel: [58935.816290] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816291] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816292] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1b 41 00 00 80 00
Jun  6 13:26:02 melany kernel: [58935.816296] end_request: I/O error, dev sdb, sector 72513
Jun  6 13:26:02 melany kernel: [58935.816303] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816304] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816306] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 1a 41 00 01 00 00
Jun  6 13:26:02 melany kernel: [58935.816310] end_request: I/O error, dev sdb, sector 72257
Jun  6 13:26:02 melany kernel: [58935.816318] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:26:02 melany kernel: [58935.816319] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:26:02 melany kernel: [58935.816320] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 17 c1 00 02 80 00
Jun  6 13:26:02 melany kernel: [58935.816324] end_request: I/O error, dev sdb, sector 71617
Jun  6 13:26:33 melany kernel: [58966.816067] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:26:33 melany kernel: [58966.816071] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:27:04 melany kernel: [58997.816079] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:27:04 melany kernel: [58997.816083] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:27:35 melany kernel: [59028.816068] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:27:35 melany kernel: [59028.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:27:35 melany kernel: [59028.816083] sd 6:0:1:0: [sdb] Unhandled error code
Jun  6 13:27:35 melany kernel: [59028.816085] sd 6:0:1:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  6 13:27:35 melany kernel: [59028.816087] sd 6:0:1:0: [sdb] CDB: Read(10): 28 00 00 01 26 c1 00 00 80 00
Jun  6 13:27:35 melany kernel: [59028.816092] end_request: I/O error, dev sdb, sector 75457
Jun  6 13:27:46 melany kernel: [59040.532072] INFO: task md5_raid1:26610 blocked for more than 120 seconds.
Jun  6 13:27:46 melany kernel: [59040.532080] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  6 13:27:46 melany kernel: [59040.532088] md5_raid1     D ffff8800018555c0     0 26610      2 0x00000000
Jun  6 13:27:46 melany kernel: [59040.532091]  ffff88006d248e20 0000000000000046 ffff88006e851240 ffffffff810b406c
Jun  6 13:27:46 melany kernel: [59040.532094]  ffff880032ea4fc0 ffff88006e851240 000000000000f8a0 ffff880023459fd8
Jun  6 13:27:46 melany kernel: [59040.532096]  00000000000155c0 00000000000155c0 ffff88006e74b880 ffff88006e74bb78
Jun  6 13:27:46 melany kernel: [59040.532098] Call Trace:
Jun  6 13:27:46 melany kernel: [59040.532104]  [<ffffffff810b406c>] ? mempool_alloc+0x55/0x106
Jun  6 13:27:46 melany kernel: [59040.532113]  [<ffffffffa018c8a5>] ? md_super_wait+0xae/0xc6 [md_mod]
Jun  6 13:27:46 melany kernel: [59040.532116]  [<ffffffff8106479e>] ? autoremove_wake_function+0x0/0x2e
Jun  6 13:27:46 melany kernel: [59040.532120]  [<ffffffffa018d455>] ? md_update_sb+0x285/0x312 [md_mod]
Jun  6 13:27:46 melany kernel: [59040.532124]  [<ffffffffa018ea10>] ? md_check_recovery+0x1e2/0x4b9 [md_mod]
Jun  6 13:27:46 melany kernel: [59040.532127]  [<ffffffffa01a3ee5>] ? raid1d+0x2f/0xde0 [raid1]
Jun  6 13:27:46 melany kernel: [59040.532130]  [<ffffffff81047e65>] ? finish_task_switch+0x3a/0xa7
Jun  6 13:27:46 melany kernel: [59040.532133]  [<ffffffff812ea1a4>] ? thread_return+0x79/0xe0
Jun  6 13:27:46 melany kernel: [59040.532136]  [<ffffffff812ea544>] ? schedule_timeout+0x1e/0xb8
Jun  6 13:27:46 melany kernel: [59040.532139]  [<ffffffffa018c664>] ? md_thread+0xf1/0x10f [md_mod]
Jun  6 13:27:46 melany kernel: [59040.532141]  [<ffffffff8106479e>] ? autoremove_wake_function+0x0/0x2e
Jun  6 13:27:46 melany kernel: [59040.532145]  [<ffffffffa018c573>] ? md_thread+0x0/0x10f [md_mod]
Jun  6 13:27:46 melany kernel: [59040.532147]  [<ffffffff810644d1>] ? kthread+0x79/0x81
Jun  6 13:27:46 melany kernel: [59040.532150]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Jun  6 13:27:46 melany kernel: [59040.532151]  [<ffffffff81064458>] ? kthread+0x0/0x81
Jun  6 13:27:46 melany kernel: [59040.532153]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Jun  6 13:28:06 melany kernel: [59059.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:28:06 melany kernel: [59059.816076] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  6 13:28:37 melany kernel: [59090.816067] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  6 13:28:37 melany kernel: [59090.816071] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5

#-----------------------------------------------------------------------

# mdadm /dev/md5 --fail /dev/sdg1 --remove /dev/sdg1
mdadm: set /dev/sdg1 faulty in /dev/md5

#-----------------------------------------------------------------------

# lsscsi
[6:0:0:0]    disk    ATA      WDC WD5000AAKS-0 05.0  /dev/sda
[6:0:1:0]    disk    ATA      Hitachi HDT72503 V54O  /dev/sdb
[6:0:2:0]    disk    ATA      ST3500418AS      CC38  /dev/sdc
[6:0:3:0]    disk    ATA      SAMSUNG HD501LJ  CR10  /dev/sdd
[6:0:4:0]    disk    ATA      SAMSUNG HD103UJ  1AA0  /dev/sde
[7:0:0:0]    disk    ATA      WDC WD5000AAKS-6 12.0  /dev/sdf
[7:0:1:0]    disk    ATA      Maxtor 6V320F0   VA11  /dev/sdg
[7:0:2:0]    disk    ATA      ST3500630AS      3.AA  /dev/sdh
[7:0:3:0]    disk    ATA      WDC WD10EARS-00Y 80.0  /dev/sdi
[7:0:4:0]    disk    ATA      SAMSUNG HD501LJ  CR10  /dev/sdj
[7:0:5:0]    disk    ATA      SAMSUNG HD103UJ  1AA0  /dev/sdk

#-----------------------------------------------------------------------

ST3500630AS 3.AA
dd if=/dev/zero of=/dev/sdh bs=1M count=10000
dd if=/dev/sdh of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 134.242 s, 78.1 MB/s
10485760000 bytes (10 GB) copied, 133.4 s, 78.6 MB/s

ST3500418AS CC38
dd if=/dev/zero of=/dev/sdc bs=1M count=10000
dd if=/dev/sdc of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 77.5993 s, 135 MB/s
10485760000 bytes (10 GB) copied, 75.5511 s, 139 MB/s

SAMSUNG HD501LJ  CR10
dd if=/dev/zero of=/dev/sdd bs=1M count=10000
dd if=/dev/sdd of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 128.377 s, 81.7 MB/s
10485760000 bytes (10 GB) copied, 127.639 s, 82.2 MB/s

WDC WD5000AAKS-0 05.0
dd if=/dev/zero of=/dev/sda bs=1M count=10000
dd if=/dev/sda of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 75.7749 s, 138 MB/s
10485760000 bytes (10 GB) copied, 75.4374 s, 139 MB/s

Hitachi HDT72503 V54O
dd if=/dev/zero of=/dev/sdb bs=1M count=10000
dd if=/dev/sdb of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 174.459 s, 60.1 MB/s
10485760000 bytes (10 GB) copied, 136.734 s, 76.7 MB/s

SAMSUNG HD103UJ  1AA0
dd if=/dev/zero of=/dev/sde bs=1M count=10000
dd if=/dev/sde of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 106.147 s, 98.8 MB/s
10485760000 bytes (10 GB) copied, 103.246 s, 102 MB/s

WDC WD5000AAKS-6 12.0
dd if=/dev/zero of=/dev/sdf bs=1M count=10000
dd if=/dev/sdf of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 131.26 s, 79.9 MB/s
10485760000 bytes (10 GB) copied, 131.367 s, 79.8 MB/s

SAMSUNG HD501LJ  CR10
dd if=/dev/zero of=/dev/sdj bs=1M count=10000
dd if=/dev/sdj of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 118.223 s, 88.7 MB/s
10485760000 bytes (10 GB) copied, 117.453 s, 89.3 MB/s

Maxtor 6V320F0   VA11
dd if=/dev/zero of=/dev/sdg bs=1M count=10000
dd if=/dev/sdg of=/dev/null bs=1M count=10000
10485760000 bytes (10 GB) copied, 147.384 s, 71.1 MB/s
10485760000 bytes (10 GB) copied, 146.607 s, 71.5 MB/s

#-----------------------------------------------------------------------

--------------060005030707020301080602
Content-Type: text/plain;
 name="melany-kernel-debug02.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="melany-kernel-debug02.txt"

Jun  5 16:23:15 melany kernel: [14702.229388] md: md1 stopped.
Jun  5 16:23:15 melany kernel: [14702.229395] md: unbind<sdd>
Jun  5 16:23:15 melany mdadm[2415]: DeviceDisappeared event detected on md device /dev/md1
Jun  5 16:23:15 melany kernel: [14702.240064] md: export_rdev(sdd)
Jun  5 16:23:15 melany kernel: [14702.240147] md1: detected capacity change from 500107771904 to 0
Jun  5 16:28:22 melany kernel: [15009.192715]  sdc: unknown partition table
Jun  5 16:28:25 melany kernel: [15012.484279]  sdc: sdc1
Jun  5 16:28:25 melany ata_id[15369]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-8-32'
Jun  5 16:29:46 melany kernel: [15092.918641] md: bind<sdd>
Jun  5 16:29:46 melany kernel: [15092.918857] md: bind<sdc>
Jun  5 16:29:46 melany kernel: [15093.043908] raid1: md1 is not clean -- starting background reconstruction
Jun  5 16:29:46 melany kernel: [15093.043911] raid1: raid set md1 active with 2 out of 2 mirrors
Jun  5 16:29:46 melany kernel: [15093.043930] md1: detected capacity change from 0 to 500107771904
Jun  5 16:29:46 melany kernel: [15093.044122]  md1: p1
Jun  5 16:33:54 melany mdadm[2415]: RebuildStarted event detected on md device /dev/md1
Jun  5 16:33:54 melany kernel: [15341.219444] md: resync of RAID array md1
Jun  5 16:33:54 melany kernel: [15341.219448] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jun  5 16:33:54 melany kernel: [15341.219449] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
Jun  5 16:33:54 melany kernel: [15341.219453] md: using 128k window, over a total of 488386496 blocks.
Jun  5 16:34:27 melany kernel: [15373.816071] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:34:27 melany kernel: [15373.816075] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:34:27 melany kernel: [15373.816089] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:34:27 melany kernel: [15373.816092] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:34:58 melany kernel: [15404.816039] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:34:58 melany kernel: [15404.816043] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:34:58 melany kernel: [15404.816055] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:34:58 melany kernel: [15404.816057] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:35:29 melany kernel: [15435.816074] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:35:29 melany kernel: [15435.816078] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:35:29 melany kernel: [15435.816089] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:35:29 melany kernel: [15435.816092] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:36:00 melany kernel: [15466.816077] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:36:00 melany kernel: [15466.816081] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:36:00 melany kernel: [15466.816093] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:36:00 melany kernel: [15466.816095] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:36:13 melany kernel: [15480.544071] INFO: task md1_resync:15403 blocked for more than 120 seconds.
Jun  5 16:36:13 melany kernel: [15480.544080] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 16:36:13 melany kernel: [15480.544088] md1_resync    D 0000000000000000     0 15403      2 0x00000000
Jun  5 16:36:13 melany kernel: [15480.544091]  ffffffff814471f0 0000000000000046 0000000000000000 ffff880037b3c680
Jun  5 16:36:13 melany kernel: [15480.544094]  ffff880033ab8540 ffffffff8116cfe8 000000000000f8a0 ffff88003448ffd8
Jun  5 16:36:13 melany kernel: [15480.544096]  00000000000155c0 00000000000155c0 ffff88003799f100 ffff88003799f3f8
Jun  5 16:36:13 melany kernel: [15480.544099] Call Trace:
Jun  5 16:36:13 melany kernel: [15480.544105]  [<ffffffff8116cfe8>] ? elv_merged_request+0x30/0x39
Jun  5 16:36:13 melany kernel: [15480.544113]  [<ffffffffa01a2424>] ? raise_barrier+0x12c/0x163 [raid1]
Jun  5 16:36:13 melany kernel: [15480.544116]  [<ffffffff8104a0c8>] ? default_wake_function+0x0/0x9
Jun  5 16:36:13 melany kernel: [15480.544119]  [<ffffffff8104a0b8>] ? try_to_wake_up+0x249/0x259
Jun  5 16:36:13 melany kernel: [15480.544122]  [<ffffffffa01a2ed7>] ? sync_request+0x177/0x512 [raid1]
Jun  5 16:36:13 melany kernel: [15480.544126]  [<ffffffffa018b2f1>] ? is_mddev_idle+0xaa/0xfd [md_mod]
Jun  5 16:36:13 melany kernel: [15480.544130]  [<ffffffffa018ba2f>] ? md_do_sync+0x6eb/0xaf6 [md_mod]
Jun  5 16:36:13 melany kernel: [15480.544135]  [<ffffffffa018c664>] ? md_thread+0xf1/0x10f [md_mod]
Jun  5 16:36:13 melany kernel: [15480.544138]  [<ffffffff8103aa9c>] ? __wake_up_common+0x44/0x72
Jun  5 16:36:13 melany kernel: [15480.544141]  [<ffffffffa018c573>] ? md_thread+0x0/0x10f [md_mod]
Jun  5 16:36:13 melany kernel: [15480.544144]  [<ffffffff810644d1>] ? kthread+0x79/0x81
Jun  5 16:36:13 melany kernel: [15480.544147]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Jun  5 16:36:13 melany kernel: [15480.544149]  [<ffffffff81064458>] ? kthread+0x0/0x81
Jun  5 16:36:13 melany kernel: [15480.544150]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Jun  5 16:36:31 melany kernel: [15497.816089] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:36:31 melany kernel: [15497.816093] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:36:31 melany kernel: [15497.816105] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:36:31 melany kernel: [15497.816107] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:37:02 melany kernel: [15528.816082] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:37:02 melany kernel: [15528.816086] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:37:02 melany kernel: [15528.816098] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:37:02 melany kernel: [15528.816101] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:37:02 melany kernel: [15528.816111] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816112] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816115] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 4a 80 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816120] end_request: I/O error, dev sdd, sector 19072
Jun  5 16:37:02 melany kernel: [15528.816149] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816150] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816152] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 49 80 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.816156] end_request: I/O error, dev sdd, sector 18816
Jun  5 16:37:02 melany kernel: [15528.816165] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816166] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816168] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 49 00 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816172] end_request: I/O error, dev sdd, sector 18688
Jun  5 16:37:02 melany kernel: [15528.816186] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816187] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816189] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 48 00 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.816193] end_request: I/O error, dev sdd, sector 18432
Jun  5 16:37:02 melany kernel: [15528.816204] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816205] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816207] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 47 80 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816211] end_request: I/O error, dev sdd, sector 18304
Jun  5 16:37:02 melany kernel: [15528.816220] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816221] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816223] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 46 80 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.816227] end_request: I/O error, dev sdd, sector 18048
Jun  5 16:37:02 melany kernel: [15528.816239] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816240] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816242] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 45 80 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.816245] end_request: I/O error, dev sdd, sector 17792
Jun  5 16:37:02 melany kernel: [15528.816257] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816258] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816260] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 45 00 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816264] end_request: I/O error, dev sdd, sector 17664
Jun  5 16:37:02 melany kernel: [15528.816272] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816274] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816275] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 44 80 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816279] end_request: I/O error, dev sdd, sector 17536
Jun  5 16:37:02 melany kernel: [15528.816288] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816289] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816291] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 44 00 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816294] end_request: I/O error, dev sdd, sector 17408
Jun  5 16:37:02 melany kernel: [15528.816303] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816304] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816306] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 43 80 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.816309] end_request: I/O error, dev sdd, sector 17280
Jun  5 16:37:02 melany kernel: [15528.816318] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.816320] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.816321] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 42 80 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.816325] end_request: I/O error, dev sdd, sector 17024
Jun  5 16:37:02 melany kernel: [15528.817530] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.817531] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.817533] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 41 80 00 01 00 00
Jun  5 16:37:02 melany kernel: [15528.817537] end_request: I/O error, dev sdd, sector 16768
Jun  5 16:37:02 melany kernel: [15528.817549] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.817550] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.817552] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 41 00 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.817556] end_request: I/O error, dev sdd, sector 16640
Jun  5 16:37:02 melany kernel: [15528.817565] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.817566] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.817568] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 40 80 00 00 80 00
Jun  5 16:37:02 melany kernel: [15528.817572] end_request: I/O error, dev sdd, sector 16512
Jun  5 16:37:02 melany kernel: [15528.817581] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.817583] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.817584] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 3e 00 00 02 80 00
Jun  5 16:37:02 melany kernel: [15528.817588] end_request: I/O error, dev sdd, sector 15872
Jun  5 16:37:02 melany kernel: [15528.817614] sd 0:0:0:0: [sda] Unhandled error code
Jun  5 16:37:02 melany kernel: [15528.817615] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:37:02 melany kernel: [15528.817617] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
Jun  5 16:37:02 melany kernel: [15528.817621] end_request: I/O error, dev sda, sector 0
Jun  5 16:37:02 melany kernel: [15528.817627] Buffer I/O error on device sda, logical block 0
Jun  5 16:37:02 melany kernel: [15528.817634] Buffer I/O error on device sda, logical block 1
Jun  5 16:37:02 melany kernel: [15528.817639] Buffer I/O error on device sda, logical block 2
Jun  5 16:37:02 melany kernel: [15528.817645] Buffer I/O error on device sda, logical block 3
Jun  5 16:37:33 melany kernel: [15559.816070] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:37:33 melany kernel: [15559.816074] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:38:04 melany kernel: [15590.816073] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:38:04 melany kernel: [15590.816077] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:38:35 melany kernel: [15621.816074] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:38:35 melany kernel: [15621.816078] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:39:07 melany kernel: [15653.816067] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:39:07 melany kernel: [15653.816071] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:39:38 melany kernel: [15684.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:39:38 melany kernel: [15684.816076] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:40:09 melany kernel: [15715.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:40:09 melany kernel: [15715.816076] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:40:09 melany kernel: [15715.816089] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:40:09 melany kernel: [15715.816090] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:40:09 melany kernel: [15715.816092] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 4a 80 00 00 08 00
Jun  5 16:40:09 melany kernel: [15715.816098] end_request: I/O error, dev sdd, sector 19072
Jun  5 16:40:09 melany kernel: [15715.816115] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:40:09 melany kernel: [15715.816117] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:40:09 melany kernel: [15715.816118] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 00 00 4b 00 00 02 80 00
Jun  5 16:40:09 melany kernel: [15715.816123] end_request: I/O error, dev sdd, sector 19200
Jun  5 16:40:40 melany kernel: [15746.816066] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:40:40 melany kernel: [15746.816070] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:40:40 melany kernel: [15746.816077] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:40:40 melany kernel: [15746.816080] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:41:11 melany kernel: [15777.817848] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:41:11 melany kernel: [15777.817851] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:41:11 melany kernel: [15777.817857] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:41:11 melany kernel: [15777.817859] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:41:42 melany kernel: [15808.816072] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:41:42 melany kernel: [15808.816076] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:41:42 melany kernel: [15808.816083] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:41:42 melany kernel: [15808.816085] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:41:42 melany kernel: [15808.816098] sd 0:0:3:0: [sdd] Unhandled error code
Jun  5 16:41:42 melany kernel: [15808.816099] sd 0:0:3:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:41:42 melany kernel: [15808.816101] sd 0:0:3:0: [sdd] CDB: Read(10): 28 00 3a 38 5f 80 00 00 08 00
Jun  5 16:41:42 melany kernel: [15808.816106] end_request: I/O error, dev sdd, sector 976772992
Jun  5 16:42:13 melany kernel: [15839.816079] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:42:13 melany kernel: [15839.816083] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:42:13 melany kernel: [15840.544069] INFO: task md1_raid1:15386 blocked for more than 120 seconds.
Jun  5 16:42:13 melany kernel: [15840.544078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 16:42:13 melany kernel: [15840.544086] md1_raid1     D ffff8800018555c0     0 15386      2 0x00000000
Jun  5 16:42:13 melany kernel: [15840.544089]  ffff88003799a350 0000000000000046 ffff880037a9b928 ffff88006d33fd00
Jun  5 16:42:13 melany kernel: [15840.544092]  0000000000000000 ffff880037b3b4e0 000000000000f8a0 ffff88001e0a9fd8
Jun  5 16:42:13 melany kernel: [15840.544094]  00000000000155c0 00000000000155c0 ffff88003799cdb0 ffff88003799d0a8
Jun  5 16:42:13 melany kernel: [15840.544097] Call Trace:
Jun  5 16:42:13 melany kernel: [15840.544102]  [<ffffffff8116dd4e>] ? elv_insert+0x190/0x260
Jun  5 16:42:13 melany kernel: [15840.544106]  [<ffffffff81175fad>] ? __generic_unplug_device+0x12/0x2c
Jun  5 16:42:13 melany kernel: [15840.544108]  [<ffffffff81176ac1>] ? __make_request+0x3d2/0x428
Jun  5 16:42:13 melany kernel: [15840.544111]  [<ffffffff812ea544>] ? schedule_timeout+0x1e/0xb8
Jun  5 16:42:13 melany kernel: [15840.544114]  [<ffffffff811751fd>] ? generic_make_request+0x28c/0x2d7
Jun  5 16:42:13 melany kernel: [15840.544116]  [<ffffffff812ea419>] ? wait_for_common+0xde/0x14f
Jun  5 16:42:13 melany kernel: [15840.544120]  [<ffffffff8104a0c8>] ? default_wake_function+0x0/0x9
Jun  5 16:42:13 melany kernel: [15840.544122]  [<ffffffff8117530e>] ? submit_bio+0xc6/0xcd
Jun  5 16:42:13 melany kernel: [15840.544130]  [<ffffffffa018c93e>] ? sync_page_io+0x81/0xa6 [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544134]  [<ffffffffa01a43f7>] ? raid1d+0x541/0xde0 [raid1]
Jun  5 16:42:13 melany kernel: [15840.544137]  [<ffffffff81047e65>] ? finish_task_switch+0x3a/0xa7
Jun  5 16:42:13 melany kernel: [15840.544139]  [<ffffffff812ea1a4>] ? thread_return+0x79/0xe0
Jun  5 16:42:13 melany kernel: [15840.544141]  [<ffffffff8104021a>] ? check_preempt_wakeup+0x1dd/0x268
Jun  5 16:42:13 melany kernel: [15840.544144]  [<ffffffff812ea544>] ? schedule_timeout+0x1e/0xb8
Jun  5 16:42:13 melany kernel: [15840.544148]  [<ffffffffa018c664>] ? md_thread+0xf1/0x10f [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544150]  [<ffffffff8106479e>] ? autoremove_wake_function+0x0/0x2e
Jun  5 16:42:13 melany kernel: [15840.544154]  [<ffffffffa018c573>] ? md_thread+0x0/0x10f [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544156]  [<ffffffff810644d1>] ? kthread+0x79/0x81
Jun  5 16:42:13 melany kernel: [15840.544159]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Jun  5 16:42:13 melany kernel: [15840.544161]  [<ffffffff81064458>] ? kthread+0x0/0x81
Jun  5 16:42:13 melany kernel: [15840.544162]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Jun  5 16:42:13 melany kernel: [15840.544164] INFO: task md1_resync:15403 blocked for more than 120 seconds.
Jun  5 16:42:13 melany kernel: [15840.544170] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 16:42:13 melany kernel: [15840.544177] md1_resync    D 0000000000000000     0 15403      2 0x00000000
Jun  5 16:42:13 melany kernel: [15840.544180]  ffffffff814471f0 0000000000000046 0000000000000000 ffff880037b3c680
Jun  5 16:42:13 melany kernel: [15840.544182]  ffff880033ab8540 ffffffff8116cfe8 000000000000f8a0 ffff88003448ffd8
Jun  5 16:42:13 melany kernel: [15840.544184]  00000000000155c0 00000000000155c0 ffff88003799f100 ffff88003799f3f8
Jun  5 16:42:13 melany kernel: [15840.544187] Call Trace:
Jun  5 16:42:13 melany kernel: [15840.544189]  [<ffffffff8116cfe8>] ? elv_merged_request+0x30/0x39
Jun  5 16:42:13 melany kernel: [15840.544192]  [<ffffffffa01a2424>] ? raise_barrier+0x12c/0x163 [raid1]
Jun  5 16:42:13 melany kernel: [15840.544195]  [<ffffffff8104a0c8>] ? default_wake_function+0x0/0x9
Jun  5 16:42:13 melany kernel: [15840.544197]  [<ffffffff8104a0b8>] ? try_to_wake_up+0x249/0x259
Jun  5 16:42:13 melany kernel: [15840.544200]  [<ffffffffa01a2ed7>] ? sync_request+0x177/0x512 [raid1]
Jun  5 16:42:13 melany kernel: [15840.544204]  [<ffffffffa018b2f1>] ? is_mddev_idle+0xaa/0xfd [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544207]  [<ffffffffa018ba2f>] ? md_do_sync+0x6eb/0xaf6 [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544212]  [<ffffffffa018c664>] ? md_thread+0xf1/0x10f [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544214]  [<ffffffff8103aa9c>] ? __wake_up_common+0x44/0x72
Jun  5 16:42:13 melany kernel: [15840.544218]  [<ffffffffa018c573>] ? md_thread+0x0/0x10f [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544220]  [<ffffffff810644d1>] ? kthread+0x79/0x81
Jun  5 16:42:13 melany kernel: [15840.544222]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Jun  5 16:42:13 melany kernel: [15840.544224]  [<ffffffff81064458>] ? kthread+0x0/0x81
Jun  5 16:42:13 melany kernel: [15840.544225]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Jun  5 16:42:13 melany kernel: [15840.544227] INFO: task pvremove:15408 blocked for more than 120 seconds.
Jun  5 16:42:13 melany kernel: [15840.544232] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  5 16:42:13 melany kernel: [15840.544239] pvremove      D 0000000000000000     0 15408   9453 0x00020000
Jun  5 16:42:13 melany kernel: [15840.544242]  ffff88006fb73880 0000000000000086 0000000000000000 ffffffff8104a0b8
Jun  5 16:42:13 melany kernel: [15840.544244]  ffff88006f803080 0000000000000092 000000000000f8a0 ffff88002b10bfd8
Jun  5 16:42:13 melany kernel: [15840.544246]  00000000000155c0 00000000000155c0 ffff88003799a350 ffff88003799a648
Jun  5 16:42:13 melany kernel: [15840.544248] Call Trace:
Jun  5 16:42:13 melany kernel: [15840.544251]  [<ffffffff8104a0b8>] ? try_to_wake_up+0x249/0x259
Jun  5 16:42:13 melany kernel: [15840.544253]  [<ffffffff8103aa9c>] ? __wake_up_common+0x44/0x72
Jun  5 16:42:13 melany kernel: [15840.544256]  [<ffffffffa01a24f5>] ? wait_barrier+0x9a/0xd7 [raid1]
Jun  5 16:42:13 melany kernel: [15840.544258]  [<ffffffff8104a0c8>] ? default_wake_function+0x0/0x9
Jun  5 16:42:13 melany kernel: [15840.544260]  [<ffffffff810646bf>] ? bit_waitqueue+0x10/0xa0
Jun  5 16:42:13 melany kernel: [15840.544263]  [<ffffffffa01a505a>] ? make_request+0x70/0x70e [raid1]
Jun  5 16:42:13 melany kernel: [15840.544265]  [<ffffffff810e2491>] ? get_partial_node+0x15/0x79
Jun  5 16:42:13 melany kernel: [15840.544268]  [<ffffffff810e4785>] ? __slab_alloc+0xd3/0x39b
Jun  5 16:42:13 melany kernel: [15840.544270]  [<ffffffff810b406c>] ? mempool_alloc+0x55/0x106
Jun  5 16:42:13 melany kernel: [15840.544274]  [<ffffffffa018a9f2>] ? md_make_request+0xb6/0xf1 [md_mod]
Jun  5 16:42:13 melany kernel: [15840.544277]  [<ffffffff811751fd>] ? generic_make_request+0x28c/0x2d7
Jun  5 16:42:13 melany kernel: [15840.544279]  [<ffffffff8117530e>] ? submit_bio+0xc6/0xcd
Jun  5 16:42:13 melany kernel: [15840.544282]  [<ffffffff81110810>] ? dio_bio_submit+0x52/0x66
Jun  5 16:42:13 melany kernel: [15840.544285]  [<ffffffff81111336>] ? __blockdev_direct_IO+0x851/0xa60
Jun  5 16:42:13 melany kernel: [15840.544288]  [<ffffffff81186133>] ? kobject_get+0x12/0x17
Jun  5 16:42:13 melany kernel: [15840.544290]  [<ffffffff8110f8af>] ? blkdev_direct_IO+0x45/0x4a
Jun  5 16:42:13 melany kernel: [15840.544293]  [<ffffffff8110ec1b>] ? blkdev_get_blocks+0x0/0x8b
Jun  5 16:42:13 melany kernel: [15840.544296]  [<ffffffff810b398f>] ? generic_file_aio_read+0xf6/0x527
Jun  5 16:42:13 melany kernel: [15840.544298]  [<ffffffff81182e74>] ? compat_blkdev_ioctl+0x458/0x162c
Jun  5 16:42:13 melany kernel: [15840.544300]  [<ffffffff8110ff7e>] ? __blkdev_get+0x298/0x344
Jun  5 16:42:13 melany kernel: [15840.544303]  [<ffffffff81110031>] ? blkdev_open+0x0/0x96
Jun  5 16:42:13 melany kernel: [15840.544305]  [<ffffffff81110098>] ? blkdev_open+0x67/0x96
Jun  5 16:42:13 melany kernel: [15840.544307]  [<ffffffff810ec649>] ? do_sync_read+0xce/0x113
Jun  5 16:42:13 melany kernel: [15840.544310]  [<ffffffff8106479e>] ? autoremove_wake_function+0x0/0x2e
Jun  5 16:42:13 melany kernel: [15840.544312]  [<ffffffff810efb03>] ? vfs_getattr+0x56/0x61
Jun  5 16:42:13 melany kernel: [15840.544314]  [<ffffffff810ed092>] ? vfs_read+0xa6/0xff
Jun  5 16:42:13 melany kernel: [15840.544317]  [<ffffffff810ed1a7>] ? sys_read+0x45/0x6e
Jun  5 16:42:13 melany kernel: [15840.544319]  [<ffffffff810374ff>] ? cstar_dispatch+0x7/0x2e
Jun  5 16:42:44 melany kernel: [15870.804393] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:42:44 melany kernel: [15870.804397] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:43:15 melany mdadm[2415]: Rebuild99 event detected on md device /dev/md1
Jun  5 16:43:15 melany kernel: [15901.804466] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:43:15 melany kernel: [15901.804470] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
Jun  5 16:43:15 melany kernel: [15901.804477] sd 0:0:2:0: [sdc] Unhandled error code
Jun  5 16:43:15 melany kernel: [15901.804478] sd 0:0:2:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
Jun  5 16:43:15 melany kernel: [15901.804481] sd 0:0:2:0: [sdc] CDB: Read(10): 28 00 00 00 4a 80 00 00 08 00
Jun  5 16:43:15 melany kernel: [15901.804486] end_request: I/O error, dev sdc, sector 19072
Jun  5 16:43:15 melany kernel: [15901.804506] raid1: Disk failure on sdd, disabling device.
Jun  5 16:43:15 melany kernel: [15901.804507] raid1: Operation continuing on 1 devices.
Jun  5 16:43:15 melany kernel: [15901.804518] raid1: sdd: unrecoverable I/O read error for block 19072
Jun  5 16:43:15 melany kernel: [15901.804556] md: md1: resync done.
Jun  5 16:43:15 melany mdadm[2415]: Fail event detected on md device /dev/md1, component device /dev/sdd
Jun  5 16:43:46 melany kernel: [15932.804362] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
Jun  5 16:43:46 melany kernel: [15932.804367] /build/buildd-linux-2.6_2.6.32-9-i386-0BnCTJ/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5

--------------060005030707020301080602--
