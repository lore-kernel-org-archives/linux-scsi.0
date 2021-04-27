Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0F1C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 05:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D60613F4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 05:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhD1Fg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 01:36:26 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:58676 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235614AbhD1FgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 01:36:22 -0400
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 6228D30E92;
        Tue, 27 Apr 2021 22:27:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 6228D30E92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1619587657;
        bh=Zs1VoJ2QFpjVkHfavT8dq+bS2QLucnaHhCZ0emcILsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC8LkPLPoaD9B9Nn9gEAfzVKWWIl4pgI4LSvSp2J9zSe4KSbD2aT3hsJQ2UPoNxZZ
         omC7KxO5mMc/X96S8ZzcVuZHhtxGBvLSrDHE5Q++7UUDt7a23Mljx8FwuZSaq6kfR1
         f4EDFoOnzdqzD3ubKRPM+iFxCtwVPmCM4M4UVaeQ=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v10 10/13] lpfc: vmid: Appends the vmid in the wqe before sending
Date:   Wed, 28 Apr 2021 04:04:54 +0530
Message-Id: <1619562897-14062-11-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch adds the vmid in wqe before sending out the request.
The type of vmid depends on the configured type and is checked before
being appended.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v10:
Removed redudant code

v9:
No change

v8:
Modified the log messages

v7:
No change

v6:
No change

v5:
Modified the comments

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 23fb896aa260..b16f38f87710 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9760,6 +9760,8 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 				*pcmd == ELS_CMD_RSCN_XMT ||
 				*pcmd == ELS_CMD_FDISC ||
 				*pcmd == ELS_CMD_LOGO ||
+				*pcmd == ELS_CMD_QFPA ||
+				*pcmd == ELS_CMD_UVEM ||
 				*pcmd == ELS_CMD_PLOGI)) {
 				bf_set(els_req64_sp, &wqe->els_req, 1);
 				bf_set(els_req64_sid, &wqe->els_req,
@@ -10322,6 +10324,18 @@ __lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
 		bf_set(wqe_wqes, &wqe->generic.wqe_com, 0);
 	}
 
+	/* add the VMID tags as per switch response */
+	if (unlikely(piocb->iocb_flag & LPFC_IO_VMID)) {
+		if (phba->pport->vmid_priority_tagging) {
+			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
+					(piocb->vmid_tag.cs_ctl_vmid));
+		} else {
+			bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
+			wqe->words[31] = piocb->vmid_tag.app_id;
+		}
+	}
 	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
 	return rc;
 }
-- 
2.26.2

