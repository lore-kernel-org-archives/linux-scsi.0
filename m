From: Jeff DeFouw <mrj@plorb.com>
Subject: 3.16 commit 89fb4cd errors on drives without SYNC CACHE
Date: Sat, 15 Nov 2014 20:14:57 -0500
Message-ID: <20141116011457.GA19264@blorp.plorb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:50527 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbaKPBXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Nov 2014 20:23:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

Kernel 3.16 includes commit
89fb4cd1f717a871ef79fa7debbe840e3225cd54
scsi: handle flush errors properly

I have an old USB backup drive that indicates a write cache but does not 
support Synchronize Cache(10).  The request error now gets returned, 
resulting in a journal abort and inability to write to the ext3 
filesystem.  I was able to work around the problem by adding a new USB 
storage quirk that completes the request without contacting the drive.  
Is it acceptable for a drive to respond this way, and therefore need to 
be handled in the SCSI layer, or is a new USB storage quirk the right 
way to go?

Detection:

[  471.204020] usb 1-2: new high-speed USB device number 2 using ehci-pci
[  471.336900] usb 1-2: New USB device found, idVendor=0d49, idProduct=7100
[  471.336903] usb 1-2: New USB device strings: Mfr=1, Product=3, SerialNumber=2
[  471.336906] usb 1-2: Product: OneTouch II
[  471.336908] usb 1-2: Manufacturer: Maxtor
[  471.336910] usb 1-2: SerialNumber: L60N3ANG    
[  471.450333] usb-storage 1-2:1.0: USB Mass Storage device detected
[  471.450421] scsi8 : usb-storage 1-2:1.0
[  471.450512] usbcore: registered new interface driver usb-storage
[  472.501374] scsi 8:0:0:0: Direct-Access     Maxtor   OneTouch II      023g PQ: 0 ANSI: 4
[  472.501712] sd 8:0:0:0: Attached scsi generic sg4 type 0
[  472.554993] sd 8:0:0:0: [sdd] 586114704 512-byte logical blocks: (300 GB/279 GiB)
[  472.608733] sd 8:0:0:0: [sdd] Write Protect is off
[  472.608735] sd 8:0:0:0: [sdd] Mode Sense: 24 00 00 00
[  472.662478] sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  472.847985]  sdd: sdd1 sdd2
[  473.063339] sd 8:0:0:0: [sdd] Attached SCSI disk

Write failure:

[ 2812.782271] sd 9:0:0:0: [sdd] Done: 
[ 2812.782276] 0xffff88007960c9c0 SUCCESS
[ 2812.782279] sd 9:0:0:0: [sdd]  
[ 2812.782282] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[ 2812.782285] sd 9:0:0:0: [sdd] CDB: 
[ 2812.782286] Write(10): 2a 00 00 90 10 3f 00 00 30 00
[ 2812.782293] sd 9:0:0:0: [sdd] scsi host busy 1 failed 0
[ 2812.782897] sd 9:0:0:0: [sdd] Done: 
[ 2812.782900] 0xffff88007960c9c0 SUCCESS
[ 2812.782902] sd 9:0:0:0: [sdd]  
[ 2812.782904] Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK
[ 2812.782905] sd 9:0:0:0: [sdd] CDB: 
[ 2812.782906] Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
[ 2812.782911] sd 9:0:0:0: [sdd]  
[ 2812.782912] Sense Key : Illegal Request [current] 
[ 2812.782914] sd 9:0:0:0: [sdd]  
[ 2812.782916] Add. Sense: Invalid command operation code
[ 2812.782917] sd 9:0:0:0: [sdd] scsi host busy 1 failed 0
[ 2812.782922] end_request: critical target error, dev sdd, sector 9441391
[ 2812.782931] Aborting journal on device sdd1-8.

-- 
Jeff DeFouw <mrj@plorb.com>
