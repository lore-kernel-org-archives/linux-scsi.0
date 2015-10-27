From: Dmitry Katsubo <dma_k@mail.ru>
Subject: scsi-sd fails with error "Invalid field in cdb" for SATA-to-USB adapter
 JMicron
Date: Tue, 27 Oct 2015 20:47:19 +0100
Message-ID: <562FD4C7.1020504@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.181.169]:33318 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201AbbJ0TyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2015 15:54:20 -0400
Received: from smtp5.mail.ru (smtp5.mail.ru [94.100.179.24])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 50E4FBD4102
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2015 22:46:24 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:49926 helo=centurion)
	by smtp5.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ZrACM-0000vW-At
	for linux-scsi@vger.kernel.org; Tue, 27 Oct 2015 22:46:22 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id C085B1E7DCC
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2015 20:46:22 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
