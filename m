From: =?UTF-8?B?0KHQtdGA0LPQtdC5?= <gedsv@narod.ru>
Subject: ACARD AEC6710D SCSI adapter and Vuescan problem
Date: Wed, 14 Dec 2011 18:05:37 +0200
Message-ID: <4EE8C951.4090104@narod.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from forward5.mail.yandex.net ([77.88.46.21]:47745 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1LNQKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 11:10:44 -0500
Received: from smtp2.mail.yandex.net (smtp2.mail.yandex.net [77.88.46.102])
	by forward5.mail.yandex.net (Yandex) with ESMTP id 8F1FC12021A3
	for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2011 20:03:02 +0400 (MSK)
Received: from smtp2.mail.yandex.net (localhost [127.0.0.1])
	by smtp2.mail.yandex.net (Yandex) with ESMTP id 6B4EBE20480
	for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2011 20:03:02 +0400 (MSK)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all!
I have the old film-scanner Acer/Benq ScanWit 2720S with the ACARD 
AEC6710D SCSI-to-PCI adapter (chipset ATP870IU-C). The scanner works 
fine on the PC with WinXP but not with OpenSUSE 11.4 (kernel: 
2.6.37.6.-0.9 x86_64).
I'm trying to use VueScan (trial version, 9.0.66) for scanning.
VueScan detect the scanner but when I click 'Preview' or 'Scan' button 
the program send some commands to the scanner (his status is 'Busy ...') 
and no result appear :(
When the VueScan is terminated the scanner cannot be detected by VueScan 
again (I need to restart PC).

The VueScan log file contains many lines like:
1 0 INQUIRY 12 0 0 0 24 0 80000004 0xxx

I know that the atp870u driver has many problem and it is better to buy 
any other adapter like Adaptec 29xx.

But maybe I can help with the atp870u driver debugging :) I think my 
scanner doesn't works because atp870u has some bugs.

There is some output about my scsi device:
lsscsi
[1:0:0:0]    cd/dvd  Optiarc  DVD RW AD-7170A  1.02  /dev/sr0
[3:0:0:0]    disk    ATA      ST3250310AS      3.AA  /dev/sda
[5:0:0:0]    disk    Generic  USB SD Reader    1.00  /dev/sdb
[5:0:0:1]    disk    Generic  USB CF Reader    1.01  /dev/sdc
[5:0:0:2]    disk    Generic  USB SM Reader    1.02  /dev/sdd
[5:0:0:3]    disk    Generic  USB MS Reader    1.03  /dev/sde
[6:0:6:0]    scanner Color    FilmScanner____1 0117  -

ls -lsh /dev/sg*
0 crw-rw----  1 root  cdrom 21, 0 Dec 14 17:36 /dev/sg0
0 crw-rw----  1 root  disk  21, 1 Dec 14 17:36 /dev/sg1
0 crw-rw----  1 root  disk  21, 2 Dec 14 17:36 /dev/sg2
0 crw-rw----  1 root  disk  21, 3 Dec 14 17:36 /dev/sg3
0 crw-rw----  1 root  disk  21, 4 Dec 14 17:36 /dev/sg4
0 crw-rw----  1 root  disk  21, 5 Dec 14 17:36 /dev/sg5
0 crwxrwxrwx+ 1 username lp    21, 6 dec 14 17:36 /dev/sg6

cat /proc/scsi/scsi
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: Optiarc  Model: DVD RW AD-7170A  Rev: 1.02
   Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST3250310AS      Rev: 3.AA
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
   Vendor: Generic  Model: USB SD Reader    Rev: 1.00
   Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi5 Channel: 00 Id: 00 Lun: 01
   Vendor: Generic  Model: USB CF Reader    Rev: 1.01
   Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi5 Channel: 00 Id: 00 Lun: 02
   Vendor: Generic  Model: USB SM Reader    Rev: 1.02
   Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi5 Channel: 00 Id: 00 Lun: 03
   Vendor: Generic  Model: USB MS Reader    Rev: 1.03
   Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 06 Lun: 00
   Vendor: Color    Model: FilmScanner____1 Rev: 0117
   Type:   Scanner                          ANSI  SCSI revision: 02
