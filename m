Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038AEC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C983622B48
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576078889;
	bh=4bJhGQXtqrfpaZR8jFrBGqtOoMr990NBGyFdV/V2GEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uvp2JmTGtaHXbflT2EwG9syJ0Y168/ixDeF/6hnGEBvr50+jf4pPVXJOFHHmajY8J
	 x6hT4BfVsyjSZkxQNHTxL4AlBODSzPcc+gt6MlWlhnyIk1W3yYr8IGT42aK7mpLkKg
	 EOpwwpWzreSU4NKCeYPgCEuc/9mrWI47LFHKp5QY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbfLKPlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbfLKPfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B24BE22B48;
        Wed, 11 Dec 2019 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078517;
        bh=4bJhGQXtqrfpaZR8jFrBGqtOoMr990NBGyFdV/V2GEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alDdxvSU+k6HrEVa0QNojrKT/JUmZdns/XxWWlzf0JKE6SLJTJmyPoUSwEbnTz6Zt
         YyQ6Y8q0EsRut08hJSKGT4/Q6z2LC7anwANyKVHGPUnn48eD92KKKI8nWt/O3f7I2M
         xHeZlZDEM2QuxOtoZjrpAFSEYK5DtkRVmRpRqcR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/42] scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
Date:   Wed, 11 Dec 2019 10:34:34 -0500
Message-Id: <20191211153510.23861-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit feff8b3d84d3d9570f893b4d83e5eab6693d6a52 ]

When operating in private loop mode, PLOGI exchanges are racing and the
driver tries to abort it's PLOGI. But the PLOGI abort ends up terminating
the login with the other end causing the other end to abort its PLOGI as
well. Discovery never fully completes.

Fix by disabling the PLOGI abort when private loop and letting the state
machine play out.

Link: https://lore.kernel.org/r/20191018211832.7917-5-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 21ec7b5b6c85c..fefef2884d590 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -454,8 +454,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	 * single discovery thread, this will cause a huge delay in
 	 * discovery. Also this will cause multiple state machines
 	 * running in parallel for this node.
+	 * This only applies to a fabric environment.
 	 */
-	if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) {
+	if ((ndlp->nlp_state == NLP_STE_PLOGI_ISSUE) &&
+	    (vport->fc_flag & FC_FABRIC)) {
 		/* software abort outstanding PLOGI */
 		lpfc_els_abort(phba, ndlp);
 	}
-- 
2.20.1

