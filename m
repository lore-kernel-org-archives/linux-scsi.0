From: John Drescher <drescherjm@gmail.com>
Subject: Re: Possible mptsas regression post 3.5.0
Date: Tue, 28 Aug 2012 12:42:22 -0400
Message-ID: <CAEhu1-4FqG7MhfOwrBnd1mtCVp2=SiOzpeBXt_597bDYjY17bA@mail.gmail.com>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	<CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
	<CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
	<CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
	<CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
	<1346132253.12384.6.camel@localhost.localdomain>
	<CAEhu1-6nKpX=tqES95AsPn-yFioS8-5+mcU1maSYh0AozVT5PA@mail.gmail.com>
	<1346170350.12384.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41285 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2H1QmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 12:42:23 -0400
In-Reply-To: <1346170350.12384.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

>> [  174.758218] scsi_remove_target[0]: reap 0:0 state: 2 reap: 1 dev_del: 1
>
> Thanks!  Does the attached patch fix the issue for you?
>

That worked!

[  169.402990] netconsole: network logging started
[  200.903700] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
[  205.173793] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  205.173876] sd 0:0:0:0: [sda]
[  205.173919] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  205.177611] md/raid:md1: Disk failure on sda2, disabling device.
[  205.177611] md/raid:md1: Operation continuing on 11 devices.
[  205.177653] md/raid1:md0: Disk failure on sda1, disabling device.
[  205.177653] md/raid1:md0: Operation continuing on 9 devices.
[  205.234825] md: recovery of RAID array md0
[  205.234921] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  205.235016] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[  205.235171] md: using 128k window, over a total of 1048512k.
[  205.244799] md: delaying recovery of md1 until md0 has finished
(they share one or more physical units)
[  205.304574] md: unbind<sda1>
[  205.313688] md: unbind<sda2>
[  205.321117] md: export_rdev(sda1)
[  205.331098] md: export_rdev(sda2)
[  214.452649] mptsas: ioc0: attaching sata device: fw_channel 0,
fw_id 0, phy 0, sas_addr 0x1221000000000000
[  214.459858] scsi 0:0:7:0: Direct-Access     ATA      WDC
WD2500JD-00H 2D08 PQ: 0 ANSI: 5
[  214.461941] sd 0:0:7:0: Attached scsi generic sg0 type 0
[  214.462949] sd 0:0:7:0: [sda] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[  214.781445] sd 0:0:7:0: [sda] Write Protect is off
[  214.788044] sd 0:0:7:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  215.017999]  sda: sda1 sda2
[  215.342944] sd 0:0:7:0: [sda] Attached SCSI disk
[  230.608957] md: md0: recovery done.
[  230.641045] md: recovery of RAID array md1
[  230.641140] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  230.641238] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[  230.641394] md: using 128k window, over a total of 243147776k.


localhost ~ # uname -a
Linux localhost
3.5.0-bisect-9-test-scsi-remove-target-fix-00014-g10f8d5b-dirty #10
SMP Tue Aug 28 12:33:16 EDT 2012 x86_64 Intel(R) Xeon(R) CPU E31230 @
3.20GHz GenuineIntel GNU/Linux


localhost ~ # cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [raid0]
[linear] [multipath]
md0 : active raid1 sdj1[0] sdk1[2] sdf1[10](S) sdb1[11](S) sdg1[9]
sdh1[8] sdl1[7] sdm1[6] sde1[5] sdd1[4] sdi1[3] sdc1[1]
      1048512 blocks [10/10] [UUUUUUUUUU]

md1 : active raid6 sdk2[17] sdj2[18] sdf2[16] sdm2[19] sdl2[14]
sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21] sdb2[20] sdc2[1]
      2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
[12/11] [_UUUUUUUUUUU]
      [>....................]  recovery =  1.2% (3134952/243147776)
finish=100.1min speed=39954K/sec

unused devices: <none>

John
