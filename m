From: Mike Krinkin <krinkin.m.u@gmail.com>
Subject: patch "libata: Add support for SCT Write Same" breaks system
Date: Thu, 8 Sep 2016 22:27:37 +0300
Message-ID: <20160908192736.GA4356@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:32951 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932165AbcIHT1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2016 15:27:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shaun@tancheff.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, tj@kernel.org, hch@lst.de, shaun.tancheff@seagate.com

Hi,

i tried recent linux-next on my laptop, and after boot system is
almost unusable because most of apps just crash with segfaults and
in dmesg output there are a lot of errors like this:

[   17.641510] do_general_protection: 51 callbacks suppressed
[   17.641514] traps: dpkg[2831] general protection ip:40be90 sp:7ffd6daad9b8 error:0 in dpkg[400000+43000]
[   17.648882] apport[2832]: segfault at 800000000 ip 0000000000485896 sp 00007ffece3b6c40 error 6 in python3.5[400000+3a7000]
[   17.648965] Process 2832(apport) has RLIMIT_CORE set to 1
[   17.648967] Aborting core
[   17.653463] gpu-manager[2818]: segfault at 0 ip 00007f77c4b8eb5a sp 00007ffc7a01b348 error 4 in libc-2.23.so[7f77c4af0000+1c0000]
[   17.660760] apport[2833]: segfault at 800000000 ip 0000000000485896 sp 00007ffddfe2a650 error 6 in python3.5[400000+3a7000]
[   17.660841] Process 2833(apport) has RLIMIT_CORE set to 1
[   17.660843] Aborting core
[   18.192604] apport[2847]: segfault at 800000000 ip 0000000000485896 sp 00007ffd2d4a82c0 error 6 in python3.5[400000+3a7000]
[   18.192630] Process 2847(apport) has RLIMIT_CORE set to 1
[   18.192633] Aborting core
[   19.089476] traps: dpkg[2861] general protection ip:40be90 sp:7ffcabc70fa8 error:0 in dpkg[400000+43000]
[   19.096747] apport[2862]: segfault at 800000000 ip 0000000000485896 sp 00007ffeda308490 error 6 in python3.5[400000+3a7000]
[   19.096827] Process 2862(apport) has RLIMIT_CORE set to 1
[   19.096829] Aborting core
[   19.101197] gpu-manager[2849]: segfault at 0 ip 00007fdccfef8b5a sp 00007ffeb4758488 error 4 in libc-2.23.so[7fdccfe5a000+1c0000]
[   19.106683] apport[2863]: segfault at 800000000 ip 0000000000485896 sp 00007ffcf8955d10 error 6 in python3.5[400000+3a7000]
[   19.106708] Process 2863(apport) has RLIMIT_CORE set to 1
[   19.106709] Aborting core
[   19.616176] apport[2898]: segfault at 800000000 ip 0000000000485896 sp 00007ffd12c29180 error 6 in python3.5[400000+3a7000]
[   19.616216] Process 2898(apport) has RLIMIT_CORE set to 1
[   19.616217] Aborting core
[   23.182904] lsb_release[2911]: segfault at 800000000 ip 0000000000485896 sp 00007ffca2f6bec0 error 6 in python3.5[400000+3a7000]
[   23.185672] apport[2913]: segfault at 800000000 ip 0000000000485896 sp 00007ffcf199e160 error 6 in python3.5[400000+3a7000]
[   23.185698] Process 2913(apport) has RLIMIT_CORE set to 1
[   23.185698] Aborting core
[   23.212363] apport[2921]: segfault at 800000000 ip 0000000000485896 sp 00007ffe934094c0 error 6 in python3.5[400000+3a7000]
[   23.212389] Process 2921(apport) has RLIMIT_CORE set to 1
[   23.212390] Aborting core
[   23.223112] apport[2926]: segfault at 800000000 ip 0000000000485896 sp 00007ffcc68e1240 error 6 in python3.5[400000+3a7000]
[   23.223137] Process 2926(apport) has RLIMIT_CORE set to 1
[   23.223137] Aborting core

git bisect points at commit 7b20309428598df00ffe ("libata: Add support for SCT
Write Same". I temporary fixed problem with the following change:

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 08d9c8e..0dcd59e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1159,6 +1159,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
        sdev->use_10_for_rw = 1;
        sdev->use_10_for_ms = 1;
+       sdev->no_write_same = 1;
 
        /* Schedule policy is determined by ->qc_defer() callback and
         * it needs to see every deferred qc.  Set dev_blocked to 1 to

Don't know whether it will help or not, but here is my hdparm output:

sudo hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
	Model Number:       SAMSUNG MZNLN512HCJH-000L1              
	Serial Number:      S201NX0H404301      
	Firmware Revision:  EMT22L0Q
	Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions, SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
	Used: unknown (minor revision code 0x0039) 
	Supported: 9 8 7 6 5 
	Likely used: 9
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors: 1000215216
	Logical  Sector size:                   512 bytes
	Physical Sector size:                   512 bytes
	Logical Sector-0 offset:                  0 bytes
	device size with M = 1024*1024:      488386 MBytes
	device size with M = 1000*1000:      512110 MBytes (512 GB)
	cache/buffer size  = unknown
	Nominal Media Rotation Rate: Solid State Device
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 16
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	SET_MAX security extension
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	64-bit World wide name
	    	Write-Read-Verify feature set
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	{READ,WRITE}_DMA_EXT_GPL commands
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Gen3 signaling speed (6.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	   *	READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
	   *	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Asynchronous notification (eg. media change)
	   *	Software settings preservation
	    	Device Sleep (DEVSLP)
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Write Same (AC2)
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	   *	DOWNLOAD MICROCODE DMA command
	   *	SET MAX SETPASSWORD/UNLOCK DMA commands
	   *	WRITE BUFFER DMA command
	   *	READ BUFFER DMA command
	   *	Data Set Management TRIM supported (limit 8 blocks)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
	2min for SECURITY ERASE UNIT. 8min for ENHANCED SECURITY ERASE UNIT. 
Logical Unit WWN Device Identifier: 5002538d00000000
	NAA		: 5
	IEEE OUI	: 002538
	Unique ID	: d00000000
Device Sleep:
	DEVSLP Exit Timeout (DETO): 50 ms (drive)
	Minimum DEVSLP Assertion Time (MDAT): 30 ms (drive)
Checksum: correct

