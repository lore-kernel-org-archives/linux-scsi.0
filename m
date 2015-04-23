From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Thu, 23 Apr 2015 11:31:26 +0000
Message-ID: <bug-81861-11613-EYH9tqQv6s@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57294 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933900AbbDWLbb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:31:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33B81203AE
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 11:31:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9638B203AF
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 11:31:28 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #23 from linux-ide@crashplan.pro ---
On the Linux-scsi mailing list a possible patch was introduced that has been
tested to fix another appearance of the mvsas port expander mvs_task_prep
panic.

In that case the resulting panics for the combination mvsas + port expander +
SATA drives were:
1. RIP  [<ffffffffa00cd7ed>] mvs_task_prep+0x78d/0xe40 [mvsas]
2. RIP  [<ffffffffa00bd90f>] mvs_task_prep+0x73f/0xd50 [mvsas]
3. RIP  [<ffffffffa006f5b0>] mvs_task_prep_ata+0x80/0x3a0 [mvsas]
4. RIP: 0010:[<ffffffffa00f1877>]  [<ffffffffa00f1877>]
mvs_task_exec.isra.13+0x827/0xf10 [mvsas]

---

James Bottomley wrote on 16-04-15 at 07:16:

Well, that narrows it down.  It looks like there's a longstanding bug in
mvs_task_prep_ata() where the physical PHY field is populated by taking
an index through the HBA phy table.  This field is ignored for STP but
the phy table is too small and it uses the expander phy number to index
it (hence the GPF as we fall off the end of the phy table trying to
dereference sas_phy->id).

This should fix the problem.

James

---

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 2d5ab6d..454536c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -441,14 +441,11 @@ static u32 mvs_get_ncq_tag(struct sas_task *task, u32
*tag)
 static int mvs_task_prep_ata(struct mvs_info *mvi,
                  struct mvs_task_exec_info *tei)
 {
-    struct sas_ha_struct *sha = mvi->sas;
     struct sas_task *task = tei->task;
     struct domain_device *dev = task->dev;
     struct mvs_device *mvi_dev = dev->lldd_dev;
     struct mvs_cmd_hdr *hdr = tei->hdr;
     struct asd_sas_port *sas_port = dev->port;
-    struct sas_phy *sphy = dev->phy;
-    struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
     struct mvs_slot_info *slot;
     void *buf_prd;
     u32 tag = tei->tag, hdr_tag;
@@ -468,7 +465,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
     slot->tx = mvi->tx_prod;
     del_q = TXQ_MODE_I | tag |
         (TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-        (MVS_PHY_ID << TXQ_PHY_SHIFT) |
+        ((sas_port->phy_mask & TXQ_PHY_MASK) << TXQ_PHY_SHIFT) |
         (mvi_dev->taskfileset << TXQ_SRS_SHIFT);
     mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
