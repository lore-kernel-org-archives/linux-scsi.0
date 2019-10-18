Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18C7CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 16:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A68205C9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 16:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394122AbfJRQVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 12:21:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:43046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfJRQVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 12:21:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63664B2D4;
        Fri, 18 Oct 2019 16:21:12 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH] scsi: lpfc: Check queue pointer before use
Date:   Fri, 18 Oct 2019 18:21:11 +0200
Message-Id: <20191018162111.8798-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The queue pointer might not be valid. The rest of the code checks the
pointer before accessing it. lpfc_sli4_process_missed_mbox_completions
is the only place where the check is missing.

Fixes: 657add4e5e15 ("scsi: lpfc: Fix poor use of hardware queues if fewer irq vectors")
Cc: James Smart <jsmart2021@gmail.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

Not entirely sure if this correct. I tried to understand the logic of
the mentioned patch but failed to grasps all the details. Anyway, we
observe a crash in lpfc_sli4_process_missed_mbox_completions() while
iterating the array. All but the last one entry has a valid pointer.

Thanks,
Daniel

 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 379c37451645..149966ba8a17 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7906,7 +7906,7 @@ lpfc_sli4_process_missed_mbox_completions(struct lpfc_hba *phba)
 	if (sli4_hba->hdwq) {
 		for (eqidx = 0; eqidx < phba->cfg_irq_chann; eqidx++) {
 			eq = phba->sli4_hba.hba_eq_hdl[eqidx].eq;
-			if (eq->queue_id == sli4_hba->mbx_cq->assoc_qid) {
+			if (eq && eq->queue_id == sli4_hba->mbx_cq->assoc_qid) {
 				fpeq = eq;
 				break;
 			}
-- 
2.16.4

