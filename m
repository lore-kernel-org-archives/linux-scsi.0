From: Tim Small <tim@buttersideup.com>
Subject: Very slow throughput when using cdparanoia on two SATA CDROM drives
 with /dev/sr but not /dev/sg
Date: Thu, 06 Nov 2014 13:25:06 +0000
Message-ID: <545B76B2.1020906@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:41672 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbaKFNyK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 08:54:10 -0500
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
	by relay1.allsecuredomains.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <tim@buttersideup.com>)
	id 1XmN3j-0007Ea-NR
	for linux-scsi@vger.kernel.org; Thu, 06 Nov 2014 13:25:07 +0000
Received: from [172.19.198.5] (ermintrude.lan [172.19.198.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by zebedee.buttersideup.com (Postfix) with ESMTPSA id 541BC60250
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2014 13:25:07 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I've got a big box of audio CDs to read, so I hooked up a load of SATA
CDROM drives to a machine (Intel motherboard AHCI, and SATA SiI3124
controllers - in this example one was attached to each host controller),
so that I could read them in parallel.

I'm using kernel 3.16.3, with cdparanoia 3.10.2 - both from Debian
Jessie.  https://www.xiph.org/paranoia/manual.html

When two (or more) drives are read simultaneously, the performance falls
to pieces (throughput from each drive drops by 95%) if more than one
/dev/sr* device is being read by cdparanoia.

If I tell cdparanoia to use the corresponding /dev/sg devices, then no
significant throughput drop is experienced when reading multiple drives
simultaneously.

As an example, using these two drives:

[1:0:0:0]    cd/dvd  TSSTcorp DVD+-RW TS-H653G DW10  /dev/sr0   /dev/sg4
[14:0:0:0]   cd/dvd  PLDS     DVD+-RW DH-16A6S YD11  /dev/sr9   /dev/sg16


... in the following results I used "time cdparanoia -v -d /dev/XXX 1
/tmp/1.wav" - where XXX was substituted for either sr9 or sg16


On an otherwise idle machine, I did these two sequentially:

sr9: 38 seconds

sg16: 38 seconds



Simultaneous with: cdparanoia -d /dev/sr0 11 /tmp/11.wav (and auto
restarted that command when it completed) I then ran these two sequentially:

sr9: 680 seconds

sg16: 38 seconds



Simultaneous with: cdparanoia -d /dev/sg4 11 /tmp/11.wav as above:

sr9: 40 seconds

sg16: 40 seconds


This is a diff of the two sets of cdparanoia -v output (using the sr
devices vs the sg devices):

--- /tmp/sr     2014-11-06 12:41:43.094867889 +0000
+++ /tmp/sg     2014-11-06 12:42:00.463123769 +0000
@@ -2,9 +2,9 @@
 
 Using cdda library version: 10.2
 Using paranoia library version: 10.2
-Checking /dev/sr9 for cdrom...
-        Testing /dev/sr9 for SCSI/MMC interface
-                SG_IO device: /dev/sr9
+Checking /dev/sg16 for cdrom...
+        Testing /dev/sg16 for SCSI/MMC interface
+                SG_IO device: /dev/sg16
 
 CDROM model sensed sensed: PLDS DVD+-RW DH-16A6S YD11
 
@@ -13,9 +13,9 @@
 
 Checking for MMC style command set...
         Drive is MMC style
-        DMA scatter/gather table entries: 1
+        DMA scatter/gather table entries: 167
         table entry size: 131072 bytes
-        maximum theoretical transfer: 55 sectors
+        maximum theoretical transfer: 9185 sectors
         Setting default read size to 27 sectors (63504 bytes).
 
 Verifying CDDA command set...
@@ -23,3 +23,5 @@


I'm happy to try other kernel versions to gather more data.  Which
kernel trees/branches should I try?

I'm also assuming this is more likely to be a SCSI layer bug than a SATA
one, so let me know if that's probably wrong.  Also, is reporting here
best or bugzilla?

Cheers,

Tim.

