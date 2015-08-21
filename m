From: =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>
Subject: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in mvs_slot_task_free
Date: Fri, 21 Aug 2015 07:29:22 +0300
Message-ID: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37869 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbHUE3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2015 00:29:51 -0400
Received: by widdq5 with SMTP id dq5so5880008wid.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 21:29:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>

When pci_pool_alloc fails in mvs_task_prep then task->lldd_task stays
NULL but it's later used in mvs_abort_task as slot which is passed
to mvs_slot_task_free causing NULL pointer dereference.

Just return from mvs_slot_task_free when passed with NULL slot.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 454536c..9c78074 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info *mvi, u32=
 rx_desc)
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *=
task,
 			  struct mvs_slot_info *slot, u32 slot_idx)
 {
+	if (!slot)
+		return;
 	if (!slot->task)
 		return;
 	if (!sas_protocol_ata(task->task_proto))
--=20
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
