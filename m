From: Alexander Duyck <aduyck@mirantis.com>
Subject: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD
 reads
Date: Wed, 20 Jan 2016 22:35:15 -0800
Message-ID: <20160121063039.3803.66.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34324 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbcAUGfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2016 01:35:18 -0500
Received: by mail-pa0-f41.google.com with SMTP id uo6so18387745pac.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 22:35:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@odin.com, hare@suse.de, linux-scsi@vger.kernel.org
Cc: alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de

Recent changes to the kernel pulled in during the merge window have
resulted in my system generating an endless loop of the following type of
errors:

[  318.965756] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  318.968457] ata14.00: configured for UDMA/66
[  318.970656] ata14: EH complete
[  318.984366] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  318.986854] ata14.00: irq_stat 0x40000001
[  318.989138] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 22 dma 16640 in
         Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[  318.995986] ata14: hard resetting link

I bisected the issue and found the patch responsible for the issue was
commit 09e2b0b14690 "scsi: rescan VPD attributes".  This commit contained
several issues.

First, the commit had changed the behavior in terms of what devices we
called scsi_attach_vpd() for.  As a result we were calling it for devices
that didn't support a scsi_level of 6, SCSI 3, so VPD accesses could
result in errors.

Second, the commit as well as a follow-on patch for it contained a number
of RCU errors.  Specifically the code was structured such that we had
accesses outside of RCU locked regions, and repeated use of the RCU
protected pointer without using the proper accessors.  As such it was
possible to get into a serious corruption situation should a pointer be
updated.

Ultimately neither of these bugs were my root cause.  It turns out the
Marvel Console SCSI device in my system needed to have a flag set to
disable VPD access in order to keep things from looping through the error
repeatedly.  In order to resolve it I had to add the kernel parameter
"scsi_mod.dev_flags=Marvell:Console:0x4000000".  This allowed my system to
boot without any errors, however the first two issues described above are
still relevent so I thought I would provide the patches since I had already
written them up.

---

Alexander Duyck (2):
      scsi: Do not attach VPD to devices that don't support it
      scsi: Fix RCU handling for VPD pages


 drivers/scsi/scsi.c        |   55 ++++++++++++++++++++++++--------------------
 drivers/scsi/scsi_lib.c    |   12 +++++-----
 drivers/scsi/scsi_scan.c   |    3 +-
 drivers/scsi/scsi_sysfs.c  |   14 ++++++-----
 include/scsi/scsi_device.h |   14 +++++++----
 5 files changed, 54 insertions(+), 44 deletions(-)

--
