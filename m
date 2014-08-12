From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Tue, 12 Aug 2014 22:02:09 +0000
Message-ID: <bug-81861-11613-vex6qYBdl5@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33834 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbaHLWCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2014 18:02:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC2E320107
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2014 22:02:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 495B820160
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2014 22:02:10 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #4 from linux-ide@crashplan.pro ---
Trying to debug mvs_task_prep with the help of the tutorial at
<http://www.opensourceforu.com/2011/01/understanding-a-kernel-oops/>.

# cat /sys/module/mvsas/sections/.init.text
0xffffffffa00c8000

# cd /lib/modules/3.13.0-24-generic/kernel/drivers/scsi/mvsas

# gdb mvsas.ko

(gdb) add-symbol-file
/usr/lib/debug/lib/modules/3.13.0-24-generic/kernel/drivers/scsi/mvsas/mvsas.ko
0xffffffffa00c8000

(gdb) disassemble mvs_task_prep

Hex to decimal: 0x72e = <+1838>

0xffffffffa00ca81e <+1838>:    mov    0x254(%rbx),%ecx

Thanks to the trick from
<https://blogs.oracle.com/ksplice/entry/8_gdb_tricks_you_should>
(gdb) set substitute-path /build/buildd /home/user/src

(gdb) list *0xffffffffa00ca81e
0xffffffffa00ca81e is in mvs_task_prep
(/build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c:471).
Line number 466 out of range;
/build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c has 306 lines.

I guess my gdb version 7.7 has a line counting bug according to
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=730630>

A manual approach using
<http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-trusty.git;a=blob;f=drivers/scsi/mvsas/mv_sas.c;h=6c1f223a8e1d335fa7c86a374e470e666e848906;hb=HEAD>:

467         slot = &mvi->slot_info[tag];
468         slot->tx = mvi->tx_prod;
469         del_q = TXQ_MODE_I | tag |
470                 (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
471                 (MVS_PHY_ID << TXQ_PHY_SHIFT) |
472                 (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
473         mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);

Results that "(MVS_PHY_ID << TXQ_PHY_SHIFT)" is the offending code.

How should that be patched?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
