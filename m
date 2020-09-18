Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2DEC43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC0B206DB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600398459;
	bh=T3ieBczVoOGtJ8Z+Ukuh2lyvCRGchjx8Grvfc97QzAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iPweVXhASDgiSYCyGcuNpxOARIh5tu8VHXzkaoXyG61uIeUwFWcGjhFH+TE/I8q8K
	 QImD78xraZPt3aalSv1jIX6Wm28vJRnuIOc6vVRvjfhtwzAwLRAY/oeMeAKzlqIVug
	 H9EoXTWauvnwsJXMf2pLCbvZEa4WLsBXjF1oBPZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgIRDHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgIRCDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8300235F7;
        Fri, 18 Sep 2020 02:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394621;
        bh=T3ieBczVoOGtJ8Z+Ukuh2lyvCRGchjx8Grvfc97QzAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Akrq5vxDNAJkZaRGPZQfuQv4uZMLQOrralQW1Klx+ty9vCP/R5JwSRh3m5m15fdeg
         JpuN0BDsW9SNR4AZmaZn0NYE+ooixMdkqfDaxP3U9hkEZ+b6DuHUD9UX7pZxzz5/Yx
         hR2r8xYZKNRsgzJEf1jZ6Bmgo8nYkeWoZHtz+vj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 123/330] scsi: lpfc: Fix release of hwq to clear the eq relationship
Date:   Thu, 17 Sep 2020 21:57:43 -0400
Message-Id: <20200918020110.2063155-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 821bc882accaaaf1bbecf5c0ecef659443e3e8cb ]

When performing reset testing, the eq's list for related hwqs was getting
corrupted.  In cases where there is not a 1:1 eq to hwq, the eq is
shared. The eq maintains a list of hwqs utilizing it in case of cpu
offlining and polling. During the reset, the hwqs are being torn down so
they can be recreated. The recreation was getting confused by seeing a
non-null eq assignment on the eq and the eq list became corrupt.

Correct by clearing the hdwq eq assignment when the hwq is cleaned up.

Link: https://lore.kernel.org/r/20200128002312.16346-6-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 95abffd9ad100..d4c83eca0ad2c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9124,6 +9124,7 @@ lpfc_sli4_release_hdwq(struct lpfc_hba *phba)
 		/* Free the CQ/WQ corresponding to the Hardware Queue */
 		lpfc_sli4_queue_free(hdwq[idx].io_cq);
 		lpfc_sli4_queue_free(hdwq[idx].io_wq);
+		hdwq[idx].hba_eq = NULL;
 		hdwq[idx].io_cq = NULL;
 		hdwq[idx].io_wq = NULL;
 		if (phba->cfg_xpsgl && !phba->nvmet_support)
-- 
2.25.1

