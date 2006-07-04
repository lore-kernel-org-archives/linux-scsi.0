From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: scan error after FC link recovery when device was in use
Date: Tue, 04 Jul 2006 13:22:01 +0200
Message-ID: <44AA4F59.3040800@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60885 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751287AbWGDLWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jul 2006 07:22:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 0F3E319D922
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jul 2006 13:22:12 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14871-04 for <linux-scsi@vger.kernel.org>;
 Tue,  4 Jul 2006 13:22:05 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 32FC219D930
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jul 2006 13:22:04 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id 9B8F62B179
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jul 2006 13:22:01 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


With 2.6.17.2, if a FC device is in use (mounted FS), a scan error is reported 
when recovering after a 'long' link down period (>30s, 'no device timeout'). 
Then, devices aren't detected again (and oops are generated when reloading HBA 
drivers, but this may be a side effect).

We have this issue with point to point configuration using:
- Emulex + DDN
- Emulex + NEC
- QLogic + DDN
- QLogic + NEC

In all cases, we got the message "Unexpected response from lun 0 while scanning, 
scan aborted" in the scsi_report_lun_scan function (scsi_scan.c) and I'm 
thinking there's something wrong when calling scsi_probe_and_add_lun.
We don't have such error if devices aren't used (not mounted) when link failure 
occurs.

Do you know if such issue has already been encountered ?
May be an already existing patch ? (I look for scsi_probe_and_add_lun in the 
mailling list but didn't find any revelant message)

Here are the extracts from syslog about these errors:


lpfc + DDN:
===========
...
Jul  3 09:15:30 s_kernel@iotiger2 kernel: lpfc 0000:06:02.0: 0:1305 Link Down 
Event x2 received Data: x2 x20 x0
Jul  3 09:16:00 s_kernel@iotiger2 kernel: lpfc 0000:06:02.0: 0:0203 Nodev 
timeout on WWPN 23:0:0:1:ff:3:2:a8 NPort xef Data: x8 x7 x0
Jul  3 09:16:05 s_kernel@iotiger2 kernel: rport-2:0-0: blocked FC remote port 
time out: removing target and saving binding
Jul  3 09:17:01 s_kernel@iotiger2 kernel: lpfc 0000:06:02.0: 0:1303 Link Up 
Event x3 received Data: x3 x1 x8 x2
Jul  3 09:17:01 s_kernel@iotiger2 kernel: Vendor: DDN       Model: S2A 8500 
      Rev: 5.22
Jul  3 09:17:01 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 03
Jul  3 09:17:01 s_kernel@iotiger2 kernel: SCSI device sdd: 571416576 512-byte 
hdwr sectors (292565 MB)
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sdd: Write Protect is off
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sdd: Mode Sense: a7 00 10 08
Jul  3 09:17:01 s_kernel@iotiger2 kernel: SCSI device sdd: drive cache: write 
back w/ FUA
Jul  3 09:17:01 s_kernel@iotiger2 kernel: SCSI device sdd: 571416576 512-byte 
hdwr sectors (292565 MB)
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sdd: Write Protect is off
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sdd: Mode Sense: a7 00 10 08
Jul  3 09:17:01 s_kernel@iotiger2 kernel: SCSI device sdd: drive cache: write 
back w/ FUA
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sdd: unknown partition table
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sd 2:0:0:0: Attached scsi disk sdd
Jul  3 09:17:01 s_kernel@iotiger2 kernel: sd 2:0:0:0: Attached scsi generic sg4 
type 0
Jul  3 09:17:01 s_kernel@iotiger2 kernel: Vendor: DDN       Model: S2A 8500 
      Rev: 5.22
Jul  3 09:17:01 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 03
Jul  3 09:17:01 s_kernel@iotiger2 kernel: error 1
Jul  3 09:17:01 s_kernel@iotiger2 kernel: 2:0:0:0: Unexpected response from lun 
0 while scanning, scan aborted
...


lpfc + NEC:
===========
...
Jul  4 06:11:44 s_kernel@iotiger2 kernel: EXT3 FS on sdg, internal journal
Jul  4 06:11:44 s_kernel@iotiger2 kernel: EXT3-fs: recovery complete.
Jul  4 06:11:44 s_kernel@iotiger2 kernel: EXT3-fs: mounted filesystem with 
ordered data mode.
Jul  4 06:12:03 s_kernel@iotiger2 kernel: lpfc 0000:06:02.1: 1:1305 Link Down 
Event x2 received Data: x2 x20 x0
Jul  4 06:12:33 s_kernel@iotiger2 kernel: lpfc 0000:06:02.1: 1:0203 Nodev 
timeout on WWPN 20:6:0:0:13:84:0:35 NPort xdc Data: x8 x7 x0
Jul  4 06:12:38 s_kernel@iotiger2 kernel: rport-3:0-0: blocked FC remote port 
time out: removing target and saving binding
Jul  4 06:12:42 s_kernel@iotiger2 kernel: lpfc 0000:06:02.1: 1:1303 Link Up 
Event x3 received Data: x3 x1 x8 x2
Jul  4 06:12:42 s_kernel@iotiger2 kernel: Vendor: NEC       Model: iStorage 2000 
     Rev: 2800
Jul  4 06:12:42 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 04
Jul  4 06:12:42 s_kernel@iotiger2 kernel: SCSI device sdh: 138412032 512-byte 
hdwr sectors (70867 MB)
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sdh: Write Protect is off
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sdh: Mode Sense: 97 00 00 08
Jul  4 06:12:42 s_kernel@iotiger2 kernel: SCSI device sdh: drive cache: write back
Jul  4 06:12:42 s_kernel@iotiger2 kernel: SCSI device sdh: 138412032 512-byte 
hdwr sectors (70867 MB)
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sdh: Write Protect is off
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sdh: Mode Sense: 97 00 00 08
Jul  4 06:12:42 s_kernel@iotiger2 kernel: SCSI device sdh: drive cache: write back
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sdh: unknown partition table
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sd 3:0:0:0: Attached scsi disk sdh
Jul  4 06:12:42 s_kernel@iotiger2 kernel: sd 3:0:0:0: Attached scsi generic sg12 
type 0
Jul  4 06:12:42 s_kernel@iotiger2 kernel: Vendor: NEC       Model: iStorage 2000 
     Rev: 2800
Jul  4 06:12:42 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 04
Jul  4 06:12:42 s_kernel@iotiger2 kernel: error 1
Jul  4 06:12:42 s_kernel@iotiger2 kernel: 3:0:0:0: Unexpected response from lun 
0 while scanning, scan aborted
...

QLogic+NEC
==========
...
Jul  4 09:47:10 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LIP reset 
occured (f8ef).
Jul  4 09:47:10 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LOOP DOWN 
detected (2).
Jul  4 09:47:14 s_kernel@iotiger2 kernel: qla2400 0000:07:01.0: LOOP DOWN 
detected (2).
Jul  4 09:47:45 s_kernel@iotiger2 kernel: rport-9:0-0: blocked FC remote port 
time out: removing target and saving binding
Jul  4 09:47:50 s_kernel@iotiger2 kernel: rport-8:0-0: blocked FC remote port 
time out: removing target and saving binding
Jul  4 09:48:11 s_kernel@iotiger2 kernel: qla2400 0000:07:01.0: LIP reset 
occured (f7f7).
Jul  4 09:48:11 s_kernel@iotiger2 kernel: qla2400 0000:07:01.0: LIP occured (f7f7).
Jul  4 09:48:11 s_kernel@iotiger2 kernel: qla2400 0000:07:01.0: LOOP UP detected 
(2 Gbps).
Jul  4 09:48:11 s_kernel@iotiger2 kernel: Vendor: NEC       Model: iStorage 2000 
     Rev: 2800
Jul  4 09:48:11 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 04
Jul  4 09:48:11 s_kernel@iotiger2 kernel: SCSI device sdi: 138412032 512-byte 
hdwr sectors (70867 MB)
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sdi: Write Protect is off
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sdi: Mode Sense: 97 00 00 08
Jul  4 09:48:11 s_kernel@iotiger2 kernel: SCSI device sdi: drive cache: write back
Jul  4 09:48:11 s_kernel@iotiger2 kernel: SCSI device sdi: 138412032 512-byte 
hdwr sectors (70867 MB)
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sdi: Write Protect is off
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sdi: Mode Sense: 97 00 00 08
Jul  4 09:48:11 s_kernel@iotiger2 kernel: SCSI device sdi: drive cache: write back
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sdi: unknown partition table
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sd 8:0:0:0: Attached scsi disk sdi
Jul  4 09:48:11 s_kernel@iotiger2 kernel: sd 8:0:0:0: Attached scsi generic sg14 
type 0
Jul  4 09:48:11 s_kernel@iotiger2 kernel: Vendor: NEC       Model: iStorage 2000 
     Rev: 2800
Jul  4 09:48:11 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 04
Jul  4 09:48:11 s_kernel@iotiger2 kernel: error 1
Jul  4 09:48:11 s_kernel@iotiger2 kernel: 8:0:0:0: Unexpected response from lun 
0 while scanning, scan aborted
...

QLogic+DDN
==========
...
Jul  4 10:01:31 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LOOP DOWN 
detected (2).
Jul  4 10:02:06 s_kernel@iotiger2 kernel: rport-9:0-0: blocked FC remote port 
time out: removing target and saving binding
Jul  4 10:03:05 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LIP reset 
occured (f7f7).
Jul  4 10:03:05 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LIP occured (f7f7).
Jul  4 10:03:05 s_kernel@iotiger2 kernel: qla2400 0000:07:01.1: LOOP UP detected 
(2 Gbps).
Jul  4 10:03:05 s_kernel@iotiger2 kernel: Vendor: DDN       Model: S2A 8500 
      Rev: 5.22
Jul  4 10:03:05 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 03
Jul  4 10:03:05 s_kernel@iotiger2 kernel: SCSI device sdl: 571416576 512-byte 
hdwr sectors (292565 MB)
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sdl: Write Protect is off
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sdl: Mode Sense: a7 00 10 08
Jul  4 10:03:05 s_kernel@iotiger2 kernel: SCSI device sdl: drive cache: write 
back w/ FUA
Jul  4 10:03:05 s_kernel@iotiger2 kernel: SCSI device sdl: 571416576 512-byte 
hdwr sectors (292565 MB)
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sdl: Write Protect is off
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sdl: Mode Sense: a7 00 10 08
Jul  4 10:03:05 s_kernel@iotiger2 kernel: SCSI device sdl: drive cache: write 
back w/ FUA
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sdl: unknown partition table
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sd 9:0:0:0: Attached scsi disk sdl
Jul  4 10:03:05 s_kernel@iotiger2 kernel: sd 9:0:0:0: Attached scsi generic sg15 
type 0
Jul  4 10:03:05 s_kernel@iotiger2 kernel: Vendor: DDN       Model: S2A 8500 
      Rev: 5.22
Jul  4 10:03:05 s_kernel@iotiger2 kernel: Type:   Direct-Access 
      ANSI SCSI revision: 03
Jul  4 10:03:05 s_kernel@iotiger2 kernel: error 1
Jul  4 10:03:05 s_kernel@iotiger2 kernel: 9:0:0:0: Unexpected response from lun 
0 while scanning, scan aborted
...

-- 
Frederic TEMPORELLI
