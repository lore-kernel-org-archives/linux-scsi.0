From: Michael Reed <mdr@sgi.com>
Subject: fc transport creates second set of targets for devices in an "md"
Date: Thu, 08 Jun 2006 14:13:12 -0500
Message-ID: <448876C8.3090303@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:43156 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S964933AbWFHTNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 15:13:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

I created an md device on two fibre channel disks, sde and sdf.
I then disabled the switch port to which the hba is connected.
After the remote port time out messages, I re-enabled the switch
port.  Three things happen that are weird.  First, two unexpected
responses while scanning.  Second, the creation of sdm and
sdn.  Third, the md device remains inaccessible.

I don't think this is working the way it's intended to.  I
suspect it will cause big problems for multi-path volume managers
in a fail back situation.

Mike





duck /root# ls /sys/block
hda    loop1  loop4  loop7  ram10  ram13  ram2  ram5  ram8  sdb  sde  sdh  sdk
hdc    loop2  loop5  ram0   ram11  ram14  ram3  ram6  ram9  sdc  sdf  sdi  sdl
loop0  loop3  loop6  ram1   ram12  ram15  ram4  ram7  sda   sdd  sdg  sdj

duck /root# mdadm --create /dev/md0 --level stripe -n 2 /dev/sde /dev/sdf
md: bind<sde>
md: bind<sdf>
md0: setting max_sectors to 128, segment boundary to 32767
raid0: looking at sdf
raid0:   comparing sdf(35843584) with sdf(35843584)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sde
raid0:   comparing sde(35843584) with sdf(35843584)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 71687168 blocks.
raid0 : conf->hash_spacing is 71687168 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
mdadm: array /dev/md0 started.

duck /root# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [multipath]
md0 : active raid0 sdf[1] sde[0]
      71687168 blocks 64k chunks
unused devices: <none>


duck /root# dd if=/dev/md0 bs=256k count=1 of=/dev/null
1+0 records in
1+0 records out
262144 bytes (262 kB) copied, 0.0133771 seconds, 19.6 MB/s


************************* portdisable 11 on fibre channel switch *******************

duck /root#  rport-5:0-0: blocked FC remote port time out: removing target and saving binding
 rport-5:0-1: blocked FC remote port time out: removing target and saving binding
 rport-5:0-2: blocked FC remote port time out: removing target and saving binding
 rport-5:0-3: blocked FC remote port time out: removing target and saving binding
 rport-5:0-4: blocked FC remote port time out: removing target and saving binding
 rport-5:0-5: blocked FC remote port time out: removing target and saving binding
 rport-5:0-6: blocked FC remote port time out: removing target and saving binding
 rport-5:0-7: blocked FC remote port time out: removing target and saving binding
 rport-5:0-8: blocked FC remote port time out: removing target and saving binding
 rport-5:0-9: blocked FC remote port time out: removing target and saving binding
 rport-5:0-10: blocked FC remote port time out: removing target and saving binding
 rport-5:0-11: blocked FC remote port time out: removing target and saving binding
 rport-5:0-12: blocked FC remote port time out: removing target and saving binding
 rport-5:0-13: blocked FC remote port time out: removing target and saving binding
 rport-5:0-14: blocked FC remote port time out: removing target and saving binding
 rport-5:0-15: blocked FC remote port time out: removing target and saving binding


duck /root# ls /sys/block
hda    loop1  loop4  loop7  ram1   ram12  ram15  ram4  ram7  sda  sdd
hdc    loop2  loop5  md0    ram10  ram13  ram2   ram5  ram8  sdb
loop0  loop3  loop6  ram0   ram11  ram14  ram3   ram6  ram9  sdc


duck /root# !dd
dd if=/dev/md0 bs=256k count=1 of=/dev/null
 5:0:8:0: rejecting I/O to dead device
Buffer I/O error on device md0, logical block 0
Buffer I/O error on device md0, logical block 1
Buffer I/O error on device md0, logical block 2
Buffer I/O error on device md0, logical block 3
Buffer I/O error on device md0, logical block 8
Buffer I/O error on device md0, logical block 9
Buffer I/O error on device md0, logical block 10
Buffer I/O error on device md0, logical block 11
Buffer I/O error on device md0, logical block 16
Buffer I/O error on device md0, logical block 17
 5:0:9:0: rejecting I/O to dead device
 5:0:8:0: rejecting I/O to dead device
dd: reading `/dev/md0': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0655691 seconds, 0.0 kB/s

************************* portenable 11 on fibre channel switch *******************



  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:0:31: Attached scsi generic sg4 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:1:31: Attached scsi generic sg5 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:2:31: Attached scsi generic sg6 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:3:31: Attached scsi generic sg7 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:4:31: Attached scsi generic sg8 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:5:31: Attached scsi generic sg9 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:6:31: Attached scsi generic sg10 type 0
  Vendor: SGI       Model: Universal Xport   Rev: 0615
  Type:   Direct-Access                      ANSI SCSI revision: 03
 5:0:7:31: Attached scsi generic sg11 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
SCSI device sdg: 71687372 512-byte hdwr sectors (36704 MB)
sdg: Write Protect is off
sdg: Mode Sense: ab 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
 sdg: sdg1 sdg9 sdg11
sd 5:0:8:0: Attached scsi disk sdg
sd 5:0:8:0: Attached scsi generic sg12 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
error 1
 5:0:8:0: Unexpected response from lun 0 while scanning, scan aborted   <<<<<<<<<<<<<<<<<<<<<<<
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdh: 71687372 512-byte hdwr sectors (36704 MB)
sdh: Write Protect is off
sdh: Mode Sense: ab 00 10 08
SCSI device sdh: drive cache: write back w/ FUA
SCSI device sdh: 71687372 512-byte hdwr sectors (36704 MB)
sdh: Write Protect is off
sdh: Mode Sense: ab 00 10 08
SCSI device sdh: drive cache: write back w/ FUA
 sdh: sdh1 sdh9 sdh11
sd 5:0:9:0: Attached scsi disk sdh
sd 5:0:9:0: Attached scsi generic sg13 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
error 1
 5:0:9:0: Unexpected response from lun 0 while scanning, scan aborted   <<<<<<<<<<<<<<<<<<<<<<<<<<
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdi: 71687372 512-byte hdwr sectors (36704 MB)
sdi: Write Protect is off
sdi: Mode Sense: ab 00 10 08
SCSI device sdi: drive cache: write back w/ FUA
SCSI device sdi: 71687372 512-byte hdwr sectors (36704 MB)
sdi: Write Protect is off
sdi: Mode Sense: ab 00 10 08
SCSI device sdi: drive cache: write back w/ FUA
 sdi: sdi1 sdi9 sdi11
sd 5:0:10:0: Attached scsi disk sdi
sd 5:0:10:0: Attached scsi generic sg14 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdj: 71687372 512-byte hdwr sectors (36704 MB)
sdj: Write Protect is off
sdj: Mode Sense: ab 00 10 08
SCSI device sdj: drive cache: write back w/ FUA
SCSI device sdj: 71687372 512-byte hdwr sectors (36704 MB)
sdj: Write Protect is off
sdj: Mode Sense: ab 00 10 08
SCSI device sdj: drive cache: write back w/ FUA
 sdj: sdj1 sdj9 sdj11
sd 5:0:11:0: Attached scsi disk sdj
sd 5:0:11:0: Attached scsi generic sg15 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdk: 71687372 512-byte hdwr sectors (36704 MB)
sdk: Write Protect is off
sdk: Mode Sense: ab 00 10 08
SCSI device sdk: drive cache: write back w/ FUA
SCSI device sdk: 71687372 512-byte hdwr sectors (36704 MB)
sdk: Write Protect is off
sdk: Mode Sense: ab 00 10 08
SCSI device sdk: drive cache: write back w/ FUA
 sdk: sdk1 sdk9 sdk11
sd 5:0:12:0: Attached scsi disk sdk
sd 5:0:12:0: Attached scsi generic sg16 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdl: 71687372 512-byte hdwr sectors (36704 MB)
sdl: Write Protect is off
sdl: Mode Sense: ab 00 10 08
SCSI device sdl: drive cache: write back w/ FUA
SCSI device sdl: 71687372 512-byte hdwr sectors (36704 MB)
sdl: Write Protect is off
sdl: Mode Sense: ab 00 10 08
SCSI device sdl: drive cache: write back w/ FUA
 sdl: sdl1 sdl9 sdl11
sd 5:0:13:0: Attached scsi disk sdl
sd 5:0:13:0: Attached scsi generic sg17 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdm: 71687372 512-byte hdwr sectors (36704 MB)
sdm: Write Protect is off
sdm: Mode Sense: ab 00 10 08
SCSI device sdm: drive cache: write back w/ FUA
SCSI device sdm: 71687372 512-byte hdwr sectors (36704 MB)
sdm: Write Protect is off
sdm: Mode Sense: ab 00 10 08
SCSI device sdm: drive cache: write back w/ FUA
 sdm: sdm1 sdm9 sdm11
sd 5:0:14:0: Attached scsi disk sdm
sd 5:0:14:0: Attached scsi generic sg18 type 0
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdn: 71687372 512-byte hdwr sectors (36704 MB)
sdn: Write Protect is off
sdn: Mode Sense: ab 00 10 08
SCSI device sdn: drive cache: write back w/ FUA
SCSI device sdn: 71687372 512-byte hdwr sectors (36704 MB)
sdn: Write Protect is off
sdn: Mode Sense: ab 00 10 08
SCSI device sdn: drive cache: write back w/ FUA
 sdn: sdn1 sdn9 sdn11
sd 5:0:15:0: Attached scsi disk sdn
sd 5:0:15:0: Attached scsi generic sg19 type 0



duck /root# ls /sys/block
hda    loop1  loop4  loop7  ram1   ram12  ram15  ram4  ram7  sda  sdd  sdi  sdl
hdc    loop2  loop5  md0    ram10  ram13  ram2   ram5  ram8  sdb  sdg  sdj  sdm
loop0  loop3  loop6  ram0   ram11  ram14  ram3   ram6  ram9  sdc  sdh  sdk  sdn


duck /root# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [multipath]
md0 : active raid0 sdf[1] sde[0]
      71687168 blocks 64k chunks
unused devices: <none>



duck /root# !dd
dd if=/dev/md0 bs=256k count=1 of=/dev/null
 5:0:8:0: rejecting I/O to dead device
printk: 23 messages suppressed.
Buffer I/O error on device md0, logical block 0
Buffer I/O error on device md0, logical block 1
Buffer I/O error on device md0, logical block 2
Buffer I/O error on device md0, logical block 3
Buffer I/O error on device md0, logical block 8
Buffer I/O error on device md0, logical block 9
Buffer I/O error on device md0, logical block 10
Buffer I/O error on device md0, logical block 11
Buffer I/O error on device md0, logical block 16
Buffer I/O error on device md0, logical block 17
 5:0:9:0: rejecting I/O to dead device
 5:0:8:0: rejecting I/O to dead device
dd: reading `/dev/md0': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.154544 seconds, 0.0 kB/s


