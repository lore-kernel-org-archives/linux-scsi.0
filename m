From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: mptsas related problem [2.6.22], LSI SAS1064ET PCI-E
Date: Tue, 18 Sep 2007 08:06:56 +0200
Message-ID: <200709180806.56744.arekm@maven.pl>
References: <200709101955.57016.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:48696 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbXIRGHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 02:07:07 -0400
In-Reply-To: <200709101955.57016.arekm@maven.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya <sathya.prakash@lsi.com>

On Monday 10 of September 2007, Arkadiusz Miskiewicz wrote:
> Hello,
>
> SR2520SAXS platform (S5000VSA mainboard in 2U SR2520 chassis) with
>
> 08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET
> PCI-Express Fusion-MPT SAS (rev 02)
>
> onboard (well afaik on backplane) and four SATA discs in various soft=
ware
> raids level (1, 5 and 10) per partition.
>
> Under bigger I/O load mptsas kicks out hdd disks like:
> mptsas: ioc0: removing sata device, channel 0, id 24, phy 2

I was able to reproduce it on second machine (also SR2520SAXS platform)=
 in ~2=20
hours of heavy IO with other Samsung hard disks (400GB, previously 320G=
B). I=20
also tested WDC WD3200YS-01P 320GB hard disk but the problem didn't occ=
ur=20
here even after 20h of testing.

Looks like it's triggered only with some hard disks. I'm going to test =
Seagate=20
disks now.

> mptscsih: ioc0: attempting task abort! (sc=3Dffff810158ecb540)
> sd 0:0:2:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 0a ad 28 de 00 00 10 00
> mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort}=
,
> SubCode(0x0403)
> mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Exe=
cuted},
> SubCode(0x0000)
> mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff810158ecb540)
> mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort}=
,
> SubCode(0x0403)
> mptscsih: ioc0: attempting target reset! (sc=3Dffff810158ecb540)
> sd 0:0:2:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 0a ad 28 de 00 00 10 00
> mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff810158ecb540)
> mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
> mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort}=
,
> SubCode(0x0403)
> mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Exe=
cuted},
> SubCode(0x0000)
> mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
> mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort}=
,
> SubCode(0x0403)
> mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL}, Code=3D{Reset}=
,
> SubCode(0x1000)
> mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL}, Code=3D{Reset}=
,
> SubCode(0x1000)
> mptscsih: ioc0: attempting target reset! (sc=3Dffff81006ea80b40)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
> mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff81006ea80b40)
> mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
> mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not=
 Yet
> Executed}, SubCode(0x0000)
> mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
> mptscsih: ioc0: attempting bus reset! (sc=3Dffff81006ea80b40)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
> mptscsih: ioc0: bus reset: SUCCESS (sc=3Dffff81006ea80b40)
> mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
> mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not=
 Yet
> Executed}, SubCode(0x0000)
> mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
> mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea806c0)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
> mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not=
 Yet
> Executed}, SubCode(0x0000)
> mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea806c0)
> mptscsih: ioc0: Attempting host reset! (sc=3Dffff81006ea80b40)
> mptbase: Initiating ioc0 recovery
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 35004742
> raid10: Disk failure on sdb3, disabling device.
>         Operation continuing on 3 devices
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 35004732
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 50036487
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 57635839
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 75634150
> raid5: Disk failure on sdb4, disabling device. Operation continuing o=
n 3
> devices
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 82503262
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 83868190
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 105214542
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 131203934
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 161928270
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 161928398
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 175936606
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 187551886
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 290607566
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 399736142
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 456110686
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 524831054
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 12540919
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 42590839
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 593333070
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 27559031
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 27571575
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
> end_request: I/O error, dev sdb, sector 27580407
> RAID10 conf printout:
>  --- wd:3 rd:4
>  disk 0, wo:0, o:1, dev:sdd3
>  disk 1, wo:0, o:1, dev:sdc3
>  disk 2, wo:0, o:1, dev:sda3
>  disk 3, wo:1, o:0, dev:sdb3
> RAID10 conf printout:
>  --- wd:3 rd:4
>  disk 0, wo:0, o:1, dev:sdd3
>  disk 1, wo:0, o:1, dev:sdc3
>  disk 2, wo:0, o:1, dev:sda3
> md: md3: recovery done.
> RAID5 conf printout:
>  --- rd:4 wd:3
>  disk 0, o:1, dev:sdd4
>  disk 1, o:1, dev:sdc4
>  disk 2, o:1, dev:sda4
>  disk 3, o:0, dev:sdb4
> RAID5 conf printout:
>  --- rd:4 wd:3
>  disk 0, o:1, dev:sdd4
>  disk 1, o:1, dev:sdc4
>  disk 2, o:1, dev:sda4
> mptsas: ioc0: removing sata device, channel 0, id 24, phy 2
> sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> sd 0:0:1:0: [sdb] Result: hostbyte=3D0x01 driverbyte=3D0x00
>
> # cat /proc/mdstat
> Personalities : [raid10] [raid1] [raid6] [raid5] [raid4]
> md3 : active raid5 sdb4[4](F) sdd4[0] sda4[2] sdc4[1]
>       840207168 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> md1 : active raid1 sdd2[0] sdc2[3] sda2[2] sdb2[1]
>       497920 blocks [4/4] [UUUU]
>
> md0 : active raid10 sdd1[0] sdb1[3] sda1[2] sdc1[1]
>       3999872 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>
> md2 : active raid10 sdd3[0] sdb3[4](F) sda3[2] sdc3[1]
>       60002560 blocks 64K chunks 2 near-copies [4/3] [UUU_]
>
> unused devices: <none>



--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
