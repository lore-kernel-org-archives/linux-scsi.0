Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B62C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F31222C4
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213494;
	bh=TQNxn8PQb6pfkKLulXH3rqOfZl5w2skxGNN/p3loGqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rZNgYXU5B1VhgVMLEeTGQAbSi67HRDKsfRfD1SOPOYDmOUWHT2EOWj4DvEDAqowxx
	 WiDQG5m3naVrk4HAE44aqPhac7CcmTQ8V5qxeYTMGjWhkpEjWI2LUv9hOu3Sg6+0SW
	 ZeCAufPpb9Cvb8WXS+Bp4Rjju6hp3a1lUlKqRnFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390942AbfKHLox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390929AbfKHLox (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50ACE222CF;
        Fri,  8 Nov 2019 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213492;
        bh=TQNxn8PQb6pfkKLulXH3rqOfZl5w2skxGNN/p3loGqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNF2hBZ1uSbDkNPJ1Ym+h/MJhaHFGUeYWTAmO8aFZH6NwpnPYo1ESUKLMsKz/HG0a
         bInIBEeLETRnqiWEVTP+xTW4u/3xq2nQfhtRHe7YMPbeDcGeeLfYGX7Nw3FW3zae1Y
         pACQHAB7D2EBlYfxYeKtX+70UY784U0lThlTexbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 071/103] scsi: lpfc: Fix errors in log messages.
Date:   Fri,  8 Nov 2019 06:42:36 -0500
Message-Id: <20191108114310.14363-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2879265f514b1f4154288243c91438ddbedb3ed4 ]

Message 6408 is displayed for each entry in an array, but the cpu and queue
numbers were incorrect for the entry.  Message 6001 includes an extraneous
character.

Resolve both issues

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c  | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 23bdb1ca106e4..6c4499db969c1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -144,7 +144,7 @@ lpfc_nvme_delete_queue(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
-			"6001 ENTER.  lpfc_pnvme %p, qidx x%xi qhandle %p\n",
+			"6001 ENTER.  lpfc_pnvme %p, qidx x%x qhandle %p\n",
 			lport, qidx, handle);
 	kfree(handle);
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7ac1a067d7801..eacdcb931bdab 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1078,15 +1078,14 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 			idx = 0;
 	}
 
-	infop = phba->sli4_hba.nvmet_ctx_info;
-	for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
-		for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+	for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+		for (j = 0; j < phba->cfg_nvmet_mrq; j++) {
+			infop = lpfc_get_ctx_list(phba, i, j);
 			lpfc_printf_log(phba, KERN_INFO, LOG_NVME | LOG_INIT,
 					"6408 TOTAL NVMET ctx for CPU %d "
 					"MRQ %d: cnt %d nextcpu %p\n",
 					i, j, infop->nvmet_ctx_list_cnt,
 					infop->nvmet_ctx_next_cpu);
-			infop++;
 		}
 	}
 	return 0;
-- 
2.20.1

