Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276D3C33CB1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 16:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE7E121D56
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193014;
	bh=trtCWoN8ogvj+86mNN3WNvr68un08wdCv6fUFwKQf9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2YjPGZM2BeLelDxI33rtzVUCur3ZkK/3m/J9Yw4KUl1TznwYlVXbeAb3eU8U1hOiQ
	 PDElCT+WzcD+HsTQiIH+NdxNzEd9Wh/JBPjtXjwD2qlKMqDXm0ME4zvnrVdyTddkZl
	 1RI/Rb2CV93JQ4j8mfD9/3NtT9BK7739UgvM/OHE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgAPQna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729028AbgAPQn3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF5CF207FF;
        Thu, 16 Jan 2020 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193009;
        bh=trtCWoN8ogvj+86mNN3WNvr68un08wdCv6fUFwKQf9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5E91EFdo7bwKKrBhCBNn83jRPogf3+golUxXfl22S8XbyQvDmAViZ/n8mgv8IhWB
         m+LCKllO1t/neLOj4Cpdp++fgEBTlzRNhOxFU0P3Dp110sqE1J8eN0uMepYNsKnVOT
         UCUTld/1U8nIZ3p/5V6rle0QZugG5Pho3BxoMCTw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 006/205] scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
Date:   Thu, 16 Jan 2020 11:39:41 -0500
Message-Id: <20200116164300.6705-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 35a635af54ce79881eb35ba20b64dcb1e81b0389 ]

In lpfc_release_io_buf, an lpfc_io_buf is returned to the 'available' pool
before any associated sgl or cmd and rsp buffers are returned via their
respective 'put' routines.  If xri rebalancing occurs and an lpfc_io_buf
structure is reused quickly, there may be a race condition between release
of old and association of new resources.

Re-ordered lpfc_release_io_buf to release sgl and cmd/rsp
buffer lists before releasing the lpfc_io_buf structure for re-use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Link: https://lore.kernel.org/r/20190922035906.10977-17-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dd542bd161d2..9771638b64ba 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20108,6 +20108,13 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
 	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
+	if (phba->cfg_xpsgl && !phba->nvmet_support &&
+	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
+		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
+
+	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
+		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
+
 	if (phba->cfg_xri_rebalancing) {
 		if (lpfc_ncmd->expedite) {
 			/* Return to expedite pool */
@@ -20172,13 +20179,6 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 		spin_unlock_irqrestore(&qp->io_buf_list_put_lock,
 				       iflag);
 	}
-
-	if (phba->cfg_xpsgl && !phba->nvmet_support &&
-	    !list_empty(&lpfc_ncmd->dma_sgl_xtra_list))
-		lpfc_put_sgl_per_hdwq(phba, lpfc_ncmd);
-
-	if (!list_empty(&lpfc_ncmd->dma_cmd_rsp_list))
-		lpfc_put_cmd_rsp_buf_per_hdwq(phba, lpfc_ncmd);
 }
 
 /**
-- 
2.20.1

