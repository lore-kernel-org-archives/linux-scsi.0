From: Robert Nagy <robert.nagy@gmail.com>
Subject: READ CAPACITY failed on ia64
Date: Tue, 14 Aug 2007 13:50:05 +0200
Message-ID: <20070814115005.GA31094@bsd.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.bsd.hu ([195.228.252.157]:36689 "EHLO bsd.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759967AbXHNLuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 07:50:14 -0400
Received: from bsd.hu (robert@localhost.bsd.hu [127.0.0.1])
	by bsd.hu (8.14.1/8.13.4) with ESMTP id l7EBo6Ta020709
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 13:50:06 +0200 (CEST)
Received: (from robert@localhost)
	by bsd.hu (8.14.1/8.13.4/Submit) id l7EBo6gc023873
	for linux-scsi@vger.kernel.org; Tue, 14 Aug 2007 13:50:06 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

Here is an ia64 box with a QLogic QLA12160 PCI to SCSI Host Adapter
and two SCSI disks.

One of them is a SEAGATE ST318453LC (18352 MB) the other one is a
SEAGATE ST3146807LC (147GB). The ST3146807LC disk works fine in
other boxes. I just put it into this one from a HP server where
it was working with the *same* controller.

In this box I get the following error message:

sd 0:0:2:0: [sdb] READ CAPACITY failed
sd 0:0:2:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:2:0: [sdb] Sense Key : 0x3 [current]
sd 0:0:2:0: [sdb] ASC=0x31 ASCQ=0x0
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: ab 00 10 08
sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FU
A
sd 0:0:2:0: [sdb] Attached SCSI disk

I am currently running 2.6.22 but I've also tried with serveral other
(and older) kernels and it still can't get the capacity of the disk.

The other disk ST318453LC is just working fine and it is serving
as the system disk.
The only thing I can do is to run scsiformat(8) which finishes
correctly. I've also tried to fill the disk with zeroes using dd(1)
but that did not help anything either.

The full dmesg of the box can be found at http://humppa.hu/dmesg.scsi

EFI information:
Seg: 1 Bus: 0 Dev: 3 Func: 0 - Qlogic 12160 SCSI Controller detected: Firmware Rev 6
  (Pun 1,Lun 0): SEAGATE ST318453LC       0002
  (Pun 2,Lun 0): SEAGATE ST3146807LC      0003

Do you guys have any idea? 

Thanks
