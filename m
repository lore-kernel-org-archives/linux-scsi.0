From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 26 Sep 2014 07:04:54 +0000
Message-ID: <bug-81861-11613-jrCXIyg9si@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbaIZHE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 03:04:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 586AB202D1
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 07:04:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 04063202E6
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 07:04:56 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

Leon Woestenberg <sidebranch.linux@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sidebranch.linux@gmail.com

--- Comment #17 from Leon Woestenberg <sidebranch.linux@gmail.com> ---

With TXQ_PHY_SHIFT being 12, and TXQ_CMD_SHIFT being 29, it seems the PHY
one-bit-hot coding appears in bits 12 through 28 inclusive.

I.e. 16 bits or PHY ID's are supported.

The register transmitted to the controller seems a 32-bit fixed register, so
this seems a hardware limitation rather than software driver limitation.

469        del_q = TXQ_MODE_I | tag |
470            (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
471            (MVS_PHY_ID << TXQ_PHY_SHIFT) |
472            (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
                printk("%d", mvi->tx_prod]);
473        mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);

Remaining question: how is this supposed to fly with port expanders where PHY
ID's get >16?


Thanks to an extensive debug report by e-mail from Rob Elliott (HP Server
Storage) --- thanks! --- which I copied ad verbatim:

---
1. Although MVS_PHY_ID looks like a constant, it's really not:
#define MVS_PHY_ID (1U << sas_phy->id)

2. This fault:
[   32.271218] BUG: unable to handle kernel NULL pointer dereference at
0000000000000255
(although 255 looks like a decimal number 0xff, it's really hex 0x255)

at this line:
  0xffffffffa01c481e <+1838>:    mov    0x254(%rbx),%ecx

implies that rbx contains 1, so 0x254 + 1 = 0x255.

3. pahole drivers/scsi/mvsas/mv_sas.o
shows there are two structures with fields at offset 596:
* asd_sas_phy.id
* asd_sas_port.sas_addr[8]

4. objdump -drS drivers/scsi/mvsas/mv_sas.o
shows only a few lines with 0x254(%something), one of which
is the del_q line you've identified:

mvs_task_prep_ata(struct mvs_info *mvi, struct mvs_task_exec_info *tei):
       struct sas_ha_struct *sha = mvi->sas;
       struct sas_task *task = tei->task;
       struct domain_device *dev = task->dev;
       struct sas_phy *sphy = dev->phy;
       struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];

       ...
       del_q = TXQ_MODE_I | tag |
               (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
               (MVS_PHY_ID << TXQ_PHY_SHIFT) |
               (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
       mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);

MVS_PHY_ID =
sas_phy->id =
sha->sas_phy[sphy->number] =
mvi->sas->sas_phy[dev->phy->number] =
mvi->sas->sas_phy[task->dev->phy->number]->id
mvi->sas->sas_phy[tei->task->dev->phy->number]->id

Looking at the offsets reported by pahole, that means:
%rdi->56->344[%rsi->0->0->56->688]->254

mvi->sas->sas_phy is a pointer to a pointer:
struct sas_ha_struct {
...
       struct asd_sas_phy * *     sas_phy;              /*   344     8 */

You might look for somewhere that could accidentally
be setting sas_phy[something] to a for loop index,
with a typecast hiding the problem from the compiler.
Or, the phy->number value being passed might be
out of range; if there were discovery errors, something
might not have been initialized like this function expects.


Rob Elliott    HP Server Storage
---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
