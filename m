From: Dmitry Katsubo <dma_k@mail.ru>
Subject: scsi-sd fails with error "Invalid field in cdb" for SATA-to-USB adapter
 JMicron
Date: Sat, 07 Nov 2015 13:18:39 +0100
Message-ID: <563DEC1F.5090905@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:48016 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbKGMVS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2015 07:21:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-general@vger.kernel.org

Hello,

In continuation to the issue described in [1] and [2]:

Unfortunately, I still suffer from the same problem on Linux kernel
v4.2.3. The problem is in detailed described in [3], in particular I see
the following in dmesg:

sd 6:0:0:0: [sdd] 234441648 512-byte logical blocks: (120 GB/111 GiB)
sd 6:0:0:0: [sdd] 4096-byte physical blocks
sd 6:0:0:0: [sdd] Write Protect is off
sd 6:0:0:0: [sdd] Mode Sense: 53 00 10 08
sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports
DPO and FUA
...
sd 6:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
sd 6:0:0:0: [sdd] tag#0 Sense Key : Illegal Request [current]
sd 6:0:0:0: [sdd] tag#0 Add. Sense: Invalid field in cdb
sd 6:0:0:0: [sdd] tag#0 CDB: Write(10) 2a 08 00 00 10 80 00 00 08 00
blk_update_request: critical target error, dev sdd, sector 4224
BTRFS: lost page write due to I/O error on /dev/sdd1
BTRFS: bdev /dev/sdd1 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0

I believe that according to patches [4], [5] I should see something like
"Disabling FUA" in logs.

Any information about how to fix the problem is appreciated.

> [1] http://permalink.gmane.org/gmane.linux.scsi/91997
> [2] http://permalink.gmane.org/gmane.linux.usb.general/120430
> [3] http://unix.stackexchange.com/questions/237204/
> [4] https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable/+blame/v4.2.3/drivers/scsi/sd.c#2446
> [5] https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable/+blame/v4.2.3/drivers/usb/storage/unusual_devs.h#1990

-- 
With best regards,
Dmitry
