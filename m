From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198111] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
 [swapper/0:0] [libahci]
Date: Sat, 09 Dec 2017 17:52:49 +0000
Message-ID: <bug-198111-11613-6uo8HObjIr@https.bugzilla.kernel.org/>
References: <bug-198111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33596 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbdLIRwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2017 12:52:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 80405290DB
        for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2017 17:52:50 +0000 (UTC)
In-Reply-To: <bug-198111-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198111

SviMik (svimik@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|All                         |x86-64

--- Comment #1 from SviMik (svimik@gmail.com) ---
Just noticed there were more messages prior to the oops message:

[01:54:17] ata1.00: exception Emask 0x0 SAct 0x6000000 SErr 0x0 action 0x6
frozen
[01:54:17] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:17] ata1.00: cmd 61/20:c8:70:b7:56/00:00:02:00:00/40 tag 25 ncq dma
16384 out
[01:54:17]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:17] ata1.00: status: { DRDY }
[01:54:17] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:17] ata1.00: cmd 61/18:d0:18:20:55/00:00:05:00:00/40 tag 26 ncq dma
12288 out
[01:54:17]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:17] ata1.00: status: { DRDY }
[01:54:26] ata1.00: device reported invalid CHS sector 0
[01:54:26] ata1.00: device reported invalid CHS sector 0
[01:54:57] ata1.00: exception Emask 0x0 SAct 0x500005 SErr 0x0 action 0x6
frozen
[01:54:57] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:57] ata1.00: cmd 61/10:00:a8:76:55/00:00:05:00:00/40 tag 0 ncq dma 8192
out
[01:54:57]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:57] ata1.00: status: { DRDY }
[01:54:57] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:57] ata1.00: cmd 61/08:10:c8:5b:57/00:00:02:00:00/40 tag 2 ncq dma 4096
out
[01:54:57]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:57] ata1.00: status: { DRDY }
[01:54:57] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:57] ata1.00: cmd 61/20:a0:d8:5b:57/00:00:02:00:00/40 tag 20 ncq dma
16384 out
[01:54:57]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:57] ata1.00: status: { DRDY }
[01:54:57] ata1.00: failed command: WRITE FPDMA QUEUED
[01:54:57] ata1.00: cmd 61/10:b0:10:e7:23/00:00:00:00:00/40 tag 22 ncq dma 8192
out
[01:54:57]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:54:57] ata1.00: status: { DRDY }
[01:55:01] ata1.00: device reported invalid CHS sector 0
[01:55:01] ata1.00: device reported invalid CHS sector 0
[01:55:01] ata1.00: device reported invalid CHS sector 0
[01:55:01] ata1.00: device reported invalid CHS sector 0
[01:55:32] ata1.00: exception Emask 0x0 SAct 0xf000000 SErr 0x0 action 0x6
frozen
[01:55:32] ata1.00: failed command: WRITE FPDMA QUEUED
[01:55:32] ata1.00: cmd 61/10:c0:10:e7:23/00:00:00:00:00/40 tag 24 ncq dma 8192
out
[01:55:32]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:55:32] ata1.00: status: { DRDY }
[01:55:32] ata1.00: failed command: WRITE FPDMA QUEUED
[01:55:32] ata1.00: cmd 61/20:c8:d8:5b:57/00:00:02:00:00/40 tag 25 ncq dma
16384 out
[01:55:32]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:55:32] ata1.00: status: { DRDY }
[01:55:32] ata1.00: failed command: WRITE FPDMA QUEUED
[01:55:32] ata1.00: cmd 61/08:d0:c8:5b:57/00:00:02:00:00/40 tag 26 ncq dma 4096
out
[01:55:32]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:55:32] ata1.00: status: { DRDY }
[01:55:32] ata1.00: failed command: WRITE FPDMA QUEUED
[01:55:32] ata1.00: cmd 61/10:d8:a8:76:55/00:00:05:00:00/40 tag 27 ncq dma 8192
out
[01:55:32]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:55:32] ata1.00: status: { DRDY }
[01:55:38] ata1.00: device reported invalid CHS sector 0
[01:55:38] ata1.00: device reported invalid CHS sector 0
[01:55:38] ata1.00: device reported invalid CHS sector 0
[01:55:38] ata1.00: device reported invalid CHS sector 0
[01:56:09] ata1.00: NCQ disabled due to excessive errors
[01:56:09] ata1.00: exception Emask 0x0 SAct 0x40000 SErr 0x0 action 0x6 frozen
[01:56:09] ata1.00: failed command: WRITE FPDMA QUEUED
[01:56:09] ata1.00: cmd 61/98:90:58:10:d4/00:00:02:00:00/40 tag 18 ncq dma
77824 out
[01:56:09]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:56:09] ata1.00: status: { DRDY }
[01:56:14] ata1.00: device reported invalid CHS sector 0
[01:57:42] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[01:57:42] ata1.00: failed command: WRITE DMA
[01:57:42] ata1.00: cmd ca/00:08:f8:3b:54/00:00:00:00:00/e5 tag 29 dma 4096 out
[01:57:42]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[01:57:42] ata1.00: status: { DRDY }
[01:57:45] ata1.00: device reported invalid CHS sector 0
[01:59:30] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
---------  and then goes the oops message posted above ---------

-- 
You are receiving this mail because:
You are the assignee for the bug.
