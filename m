From: Bernd Schubert <bs@q-leap.de>
Subject: sil3114 data corruption
Date: Mon, 8 Oct 2007 14:44:28 +0200
Message-ID: <200710081444.28960.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:60434 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbXJHMob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Oct 2007 08:44:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

Hi,

somehow the sil3114 causes data corruption with some (newer?) disks. Simply 
filling the filesystem with zeros and reading the these data will make the 
kernel to report filesystem corruption. 
This is definitely not an issue of memory, since the systems (several tested) 
do have ECC memory and the memory is monitored with EDAC. 

Also not an issue of the filesystem, also several tested. 


[  345.051369]   Vendor: ATA       Model: ST3250820AS       Rev: 3.AA
[  345.060526]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[  345.069302]   Vendor: ATA       Model: ST3200822AS       Rev: 3.01
[  345.078551]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[  345.087522] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[  345.095381] SCSI device sda: drive cache: write back
[  345.101314] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[  345.109150] SCSI device sda: drive cache: write back
[  345.115007]  /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3
[  345.134017] sd 0:0:0:0: Attached scsi disk sda
[  345.139458] SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
[  345.147558] SCSI device sdb: drive cache: write back
[  345.153671] SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
[  345.161740] SCSI device sdb: drive cache: write back
[  345.167725]  /dev/scsi/host1/bus0/target0/lun0: p1 p2 p3
[  345.187133] sd 1:0:0:0: Attached scsi disk sdb


The ST3250820AS data on the ST3250820AS disk will suffer from data corruption, 
but the data on the older ST3200822AS will *not*.

kernel versions tested: 2.6.15-2.6.20

Any ideas how to proceed?

Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
