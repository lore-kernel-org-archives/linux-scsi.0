From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 22 Aug 2014 17:36:22 +0000
Message-ID: <bug-81861-11613-mY1VFlCHk0@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36891 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVRgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 13:36:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E4B42201C0
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 17:36:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 50DD32018E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 17:36:23 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #12 from Alan <alan@lxorguk.ukuu.org.uk> ---
   0xffffffffa01c481e <+1838>:    mov    0x254(%rbx),%ecx

is loading an offset from something. It can't be line 471.

It could be line 472, or could be 468. but the offset looks way too big to be
either unless its been optimised somewhat. It's not always entirely accurate.

At this point what might be useful is to add lines between then and rebuild ...
ie



                printk("[");
467        slot = &mvi->slot_info[tag];
                printk("%d ", tag);
468        slot->tx = mvi->tx_prod;
                printk("%p ",  slot);
469        del_q = TXQ_MODE_I | tag |
470            (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
471            (MVS_PHY_ID << TXQ_PHY_SHIFT) |
472            (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
                printk("%d", mvi->tx_prod]);
473        mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
                printk("]\n");

and try again. When it dies just before the oops you should have  lines of the
form

[num num num]

the final one of which is incomplete. Where it ends tells us where it died and
the values may even give
us a guess at why. If the final [ .. ] sequence is complete then it crashed
somewhere else in the routine and gdb is confused.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
