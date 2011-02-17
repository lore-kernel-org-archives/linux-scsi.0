From: Artem Bokhan <aptem@ngs.ru>
Subject: LSI SAS2008-based controller does not export disks behind raid
Date: Thu, 17 Feb 2011 19:58:17 +0600
Message-ID: <4D5D2979.1000609@ngs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout10.ngs.ru ([195.93.186.216]:13897 "EHLO smtpout.ngs.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1BQN6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2011 08:58:39 -0500
Received: from [192.168.12.34] (unknown [192.168.12.34])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: aptem@ngs.ru)
	by mail.ngs.ru (smtp) with ESMTP id DB56A179DB819D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2011 19:58:30 +0600 (NOVT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  Hello.

I have LSI SAS2008-based controller (mpt2sas driver). Old firmware exports disks 
behind raid so they could be read by smartmontools, new one does not. Is this 
firmware-only issue or behaviour could be forced by driver?

Old behavior:

[...]
Feb  2 23:57:03 ubuntu kernel: [    3.745023] mpt2sas0: LSISAS2008: 
FWVersion(04.00.00.00), ChipRevision(0x02), BiosVersion(07.03.00.00)
Feb  2 23:57:03 ubuntu kernel: [    3.745028] mpt2sas0: 
Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag 
Trace Buffer,Task Set Full,NCQ)
Feb  2 23:57:03 ubuntu kernel: [    3.745095] mpt2sas0: sending port enable !!
Feb  2 23:57:03 ubuntu kernel: [    5.473091] mpt2sas0: host_add: 
handle(0x0001), sas_addr(0x50030480004c4df0), phys(8)
Feb  2 23:57:03 ubuntu kernel: [    7.108617] scsi 7:0:0:0: CD-ROM            
TEAC     DV-W28S-V        D.0A PQ: 0 ANSI: 0
Feb  2 23:57:03 ubuntu kernel: [    7.119447] sr0: scsi3-mmc drive: 24x/24x 
writer dvd-ram cd/rw xa/form2 cdda tray
Feb  2 23:57:03 ubuntu kernel: [    7.119453] Uniform CD-ROM driver Revision: 3.20
Feb  2 23:57:03 ubuntu kernel: [    7.119639] sr 7:0:0:0: Attached scsi generic 
sg0 type 5
Feb  2 23:57:03 ubuntu kernel: [   12.707672] mpt2sas0: port enable: SUCCESS
Feb  2 23:57:03 ubuntu kernel: [   13.086899] scsi 0:1:0:0: Direct-Access     
LSI      Logical Volume   3000 PQ: 0 ANSI: 6
Feb  2 23:57:03 ubuntu kernel: [   13.088373] scsi 0:1:0:0: RAID1: 
handle(0x0143), wwid(0x0c73dae32c7319bf), pd_count(2), type(SATA)
Feb  2 23:57:03 ubuntu kernel: [   13.088380] scsi 0:1:0:0: qdepth(128), 
tagged(1), simple(1), ordered(0), scsi_level(7), cmd_que(1)
Feb  2 23:57:03 ubuntu kernel: [   13.088543] sd 0:1:0:0: Attached scsi generic 
sg1 type 0
Feb  2 23:57:03 ubuntu kernel: [   13.088899] sd 0:1:0:0: [sda] 488280064 
512-byte logical blocks: (249 GB/232 GiB)
Feb  2 23:57:03 ubuntu kernel: [   13.089446] sd 0:1:0:0: [sda] Write Protect is 
off
Feb  2 23:57:03 ubuntu kernel: [   13.089685] sd 0:1:0:0: [sda] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Feb  2 23:57:03 ubuntu kernel: [   13.090558]  sda:
Feb  2 23:57:03 ubuntu kernel: [   13.090770] scsi 0:0:0:0: Direct-Access     
ATA      WDC WD2502ABYS-0 3B03 PQ: 0 ANSI: 5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

Feb  2 23:57:03 ubuntu kernel: [   13.091155] scsi 0:0:0:0: SATA: 
handle(0x0009), sas_addr(0x4433221102000000), device_name(0x4ee15001ce3badae)
Feb  2 23:57:03 ubuntu kernel: [   13.091158] scsi 0:0:0:0: SATA: 
enclosure_logical_id(0x50030480004c4df0), slot(2)
Feb  2 23:57:03 ubuntu kernel: [   13.091355] scsi 0:0:0:0: atapi(n), ncq(y), 
asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb  2 23:57:03 ubuntu kernel: [   13.091359] scsi 0:0:0:0: qdepth(32), 
tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Feb  2 23:57:03 ubuntu kernel: [   13.091430] scsi 0:0:0:0: Attached scsi 
generic sg2 type 0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

Feb  2 23:57:03 ubuntu kernel: [   13.106287]  sda1 sda2 <
Feb  2 23:57:03 ubuntu kernel: [   13.108938] scsi 0:0:1:0: Direct-Access     
ATA      WDC WD2502ABYS-0 3B03 PQ: 0 ANSI: 5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

Feb  2 23:57:03 ubuntu kernel: [   13.109311]  sda5 >
Feb  2 23:57:03 ubuntu kernel: [   13.109622] scsi 0:0:1:0: SATA: 
handle(0x000a), sas_addr(0x4433221103000000), device_name(0x4ee15001d696030a)
Feb  2 23:57:03 ubuntu kernel: [   13.109628] scsi 0:0:1:0: SATA: 
enclosure_logical_id(0x50030480004c4df0), slot(3)
Feb  2 23:57:03 ubuntu kernel: [   13.109743] scsi 0:0:1:0: atapi(n), ncq(y), 
asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Feb  2 23:57:03 ubuntu kernel: [   13.109747] scsi 0:0:1:0: qdepth(32), 
tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)
Feb  2 23:57:03 ubuntu kernel: [   13.109865] scsi 0:0:1:0: Attached scsi 
generic sg3 type 0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 

Feb  2 23:57:03 ubuntu kernel: [   13.110295] sd 0:1:0:0: [sda] Attached SCSI disk



New behavior:

Feb  3 10:50:11 ubuntu kernel: [    3.684393] mpt2sas0: LSISAS2008: 
FWVersion(08.00.00.00), ChipRevision(0x02), BiosVersion(07.15.00.00)
Feb  3 10:50:11 ubuntu kernel: [    3.684397] mpt2sas0: 
Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag 
Trace Buffer,Task Set Fu
ll,NCQ)
Feb  3 10:50:11 ubuntu kernel: [    3.684462] mpt2sas0: sending port enable !!
Feb  3 10:50:11 ubuntu kernel: [    5.198735] mpt2sas0: host_add: 
handle(0x0001), sas_addr(0x50030480004c4df0), phys(8)
Feb  3 10:50:11 ubuntu kernel: [    8.256411] scsi 7:0:0:0: CD-ROM            
TEAC     DV-W28S-V        D.0A PQ: 0 ANSI: 0
Feb  3 10:50:11 ubuntu kernel: [    8.269509] sr0: scsi3-mmc drive: 24x/24x 
writer dvd-ram cd/rw xa/form2 cdda tray
Feb  3 10:50:11 ubuntu kernel: [    8.269514] Uniform CD-ROM driver Revision: 3.20
Feb  3 10:50:11 ubuntu kernel: [    8.269706] sr 7:0:0:0: Attached scsi generic 
sg0 type 5
Feb  3 10:50:11 ubuntu kernel: [   11.061165] mpt2sas0: port enable: SUCCESS
Feb  3 10:50:11 ubuntu kernel: [   11.061688] scsi 0:1:0:0: Direct-Access     
LSI      Logical Volume   3000 PQ: 0 ANSI: 6
Feb  3 10:50:11 ubuntu kernel: [   11.062438] scsi 0:1:0:0: RAID1: 
handle(0x011e), wwid(0x0c73dae32c7319bf), pd_count(2), type(SATA)
Feb  3 10:50:11 ubuntu kernel: [   11.062444] scsi 0:1:0:0: qdepth(128), 
tagged(1), simple(1), ordered(0), scsi_level(7), cmd_que(1)
Feb  3 10:50:11 ubuntu kernel: [   11.062602] sd 0:1:0:0: Attached scsi generic 
sg1 type 0
Feb  3 10:50:11 ubuntu kernel: [   11.063018] sd 0:1:0:0: [sda] 488280064 
512-byte logical blocks: (249 GB/232 GiB)
Feb  3 10:50:11 ubuntu kernel: [   11.063312] sd 0:1:0:0: [sda] Write Protect is 
off
Feb  3 10:50:11 ubuntu kernel: [   11.063450] sd 0:1:0:0: [sda] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Feb  3 10:50:11 ubuntu kernel: [   11.063728]  sda: sda1 sda2 < sda5 >
Feb  3 10:50:11 ubuntu kernel: [   11.087127] sd 0:1:0:0: [sda] Attached SCSI disk
