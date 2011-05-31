From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: reproduceable storage errors on high IO load
Date: Tue, 31 May 2011 11:34:52 +0200
Message-ID: <20110531113452.4f234274.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:37029 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1EaJwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 05:52:18 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 0A8454A8083
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2011 11:34:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id BFB1393E2B
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2011 11:34:52 +0200 (CEST)
Received: from taeuber (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id A5AA793E28
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2011 11:34:52 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there,

I have a problem with a SW-RAID6. It is reproduceable also after changing the hole hardware.
I startet with a Suse 11.2. The problem occured during writing much data to the array (high io load).
This is hopefully the right ML for my problem. Otherwise please excuse me and point me the the right ML.


Then I changed the PSU. Still errors on high load.
Then I changed the sata controller (Sil 3114 - sata_sil) with one with a different chipset (driver: sata_mv). Still errors on high load.
Then I changed the disk enclosure and all cables. Still errors.
Then I changed the mainboard (tyan opteron) with one from supermicro (H8SCM-F) with 6-core opteron. Still errors.
Then I changed to ubuntu 10.04 -> 10.10. Still errors
Then I tried different schedulars (noop,anticipatory,cfq,deadline). Still errors.
Then I tried kernel options: noapic + acpi=off without luck.
Then I changed the sata controller with a areca sas (driver: mvsas). Still errors.
Then I tried some different hdds (orig: Western Digital WDC WD2002FYPS + WDC WD2003FYYS; new: Seagate ST3320620NS). Still errors.
Then I tried some different kernel versions from ubuntu without luck:
2.6.32-22-server
2.6.35-25-server

Then I tried self compiled kernels without luck:
2.6.35.13
2.6.38.6
2.6.39: same problem occurs but later

The current configuration:
- tested only 64-bit kernels
- Supermicro H8SCM-F (AMD SR5650+SP5100) with 6-core opteron
- Areca (non-raid) ARC-1300ix-16 sas controller
- SW-RAID6 over 8 Western Digital HDDs (sone WDC WD2002FYPS + some WDC WD2003FYYS)
- redundant PSU

How to reproduce my problem:
mdadm -C /dev/md3 -l6 -n8 /dev/sd[c-h] missing missing
(the two missing hdds prevent this raid from initial sync)

Everything is just fine till yet.
Now produce high io-load:
mke2fs -j /dev/md3

The detailed history (search for Lars to get my posts):
https://bugs.launchpad.net/ubuntu/+bug/550559

The error messages changed a bit during the kernel versions.
The nearly complete dmesg output:
https://launchpadlibrarian.net/72325163/20110524.dmesg.out

Is there something I do wrong? Could someone help me to debug this?
Thanks
Lars
