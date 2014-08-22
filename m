From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 22 Aug 2014 13:19:17 +0000
Message-ID: <bug-81861-11613-Jdt2m4kGBn@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbaHVNTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 09:19:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C99BD2018E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 13:19:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 640F52017A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 13:19:18 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #9 from linux-ide@crashplan.pro ---
re: Thats not a sensible resolution, it can't be faulting on that line.

Another try using a newer version of package gdb-minimal (Ubuntu 7.7-0ubuntu3.2
from trusty-proposed) gives these identical results where address <+1838> maps
to line 471 in mvsas.c and that points to "(MVS_PHY_ID << TXQ_PHY_SHIFT) |".

# cat /sys/module/mvsas/sections/.init.text
0xffffffffa01c2000

(gdb) add-symbol-file
/usr/lib/debug/lib/modules/3.13.0-24-generic/kernel/drivers/scsi/mvsas/mvsas.ko
0xffffffffa01c2000
add symbol table from file
"/usr/lib/debug/lib/modules/3.13.0-24-generic/kernel/drivers/scsi/mvsas/mvsas.ko"
at
    .text_addr = 0xffffffffa01c2000

   0xffffffffa01c481e <+1838>:    mov    0x254(%rbx),%ecx

(gdb) list *0xffffffffa01c481e
0xffffffffa01c481e is in mvs_task_prep
(/build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c:471).
466        }
467        slot = &mvi->slot_info[tag];
468        slot->tx = mvi->tx_prod;
469        del_q = TXQ_MODE_I | tag |
470            (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
471            (MVS_PHY_ID << TXQ_PHY_SHIFT) |
472            (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
473        mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
474
475        if (task->data_dir == DMA_FROM_DEVICE)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
