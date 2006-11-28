From: Michael Ulitskiy <mulitskiy@acedsl.com>
Subject: Integrated aic7902B dual-channel SCSI adapter - high load average. Lots of processes in uninterruptible sleep
Date: Tue, 28 Nov 2006 17:58:09 -0500
Message-ID: <200611281758.09477.mulitskiy@acedsl.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.acecape.com ([66.114.74.12]:45535 "EHLO mail1.acecape.com")
	by vger.kernel.org with ESMTP id S1757843AbWK1W6e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 17:58:34 -0500
Received: from decay.hq.acecape.com (c2600-t1.acecape.com [66.114.76.250])
	by mail1.acecape.com (8.13.8/8.13.8) with ESMTP id kASMwXww011351
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2006 17:58:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a problem with what I believe might be related to the aic79xx driver.
I'm running 2.4.33.3 kernel with default aic79xx driver version 1.3.10, no options.
There're 2 drives in software RAID 1, hostRAID disabled:

root@mail2:~# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: COMPAQ   Model: BD3008A4C6       Rev: HPB4
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: COMPAQ   Model: BD3008A4C6       Rev: HPB4
  Type:   Direct-Access                    ANSI SCSI revision: 03

root@mail2:~# cat /proc/scsi/aic79xx/0
Adaptec AIC79xx driver version: 1.3.10
Adaptec AIC7902 Ultra320 SCSI adapter
aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Allocated SCBs: 64, SG List Length: 102

Serial EEPROM:
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8
0x09f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0430 0xb3f7

Target 0 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Goal: 320.000MB/s transfers (160.000MHz DT|IU|RTI|QAS, 16bit)
        Curr: 320.000MB/s transfers (160.000MHz DT|IU|RTI|QAS, 16bit)
        Transmission Errors 0
        Channel A Target 0 Lun 0 Settings
                Commands Queued 8762259
                Commands Active 3
                Command Openings 29
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz RDSTRM|DT|IU|RTI|QAS, 16bit)
        Goal: 320.000MB/s transfers (160.000MHz DT|IU|RTI|QAS, 16bit)
        Curr: 320.000MB/s transfers (160.000MHz DT|IU|RTI|QAS, 16bit)
        Transmission Errors 0
        Channel A Target 1 Lun 0 Settings
                Commands Queued 8784600
                Commands Active 2
                Command Openings 30
                Max Tagged Openings 32
                Device Queue Frozen Count 0
...

The machine is a mail server that was recently migrated to the new hardware
and now the load average is constantly between 10 and 20 and sometimes
climbs higher. top and vmstat shows lots of processes in uninterruptible 
sleep, which as far I understand means that the processes wait while the driver
code to complete:

root@mail2:~# vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0 12      0 316004 100400 1026312    0    0   117    55  180  183  4  4 92  0
 1  3      0 337004 100400 1026336    0    0    24  2052  526 1481  4  2 94  0
 0 14      0 334832 100404 1026432    0    0     0  1528  510 1059  4  2 94  0
 0  8      0 336312 100408 1026424    0    0     0  1868  494 1198  6  4 90  0

I wonder if anyone has seen anything like this and/or can advice any cure?
Do you think upgrading the driver to the latest provided by adaptec (2.0.20 I guess)
should help? Any other buttons to push?
There's another server running alongside with similar IO load on 2 SATA drives in software
RAID1 and load average never gets above 0.5
Please let me know if you need more info.
Thanks a lot,

Michael
