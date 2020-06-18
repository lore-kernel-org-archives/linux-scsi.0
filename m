Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975CBC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7338E20776
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592448539;
	bh=QIlGLf7nDUlZtRArNO4LcuTLmawRlFYKBDMqXqRElDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GNTlgxzsEHHe/hVBZkAMpkBdqeo+9itoidc6NMGJWXNDNBM4hfqpPSC+30ZIOLqKe
	 m7rz1jbYmM3FmAMd422khysFb5RAy95NZhWRSs6go4Can62ndcW+K3WBiBFwYp7st9
	 sIY1HGFtedmzStH56Bi0QMzWTvn+NyY4aJ1Q3lOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgFRCsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgFRBJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86CB921D93;
        Thu, 18 Jun 2020 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442585;
        bh=QIlGLf7nDUlZtRArNO4LcuTLmawRlFYKBDMqXqRElDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8TEDNF9Q7vLKn4xowmdyS2x05uZ9ZAuaQLU2JQED/YviBK8kBePG16FsxdUrsM8a
         +ziD6B8xvxs3lF3brGjACqVPC7yKykZ5Y2sZi2SBfCeA9la3bSDhnlHyyQKznb19sM
         nhThjo3JnofOXVmw3z6zLtM1X44gaWe4guYuOClY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Daniel Wagner <dwagner@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 076/388] scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
Date:   Wed, 17 Jun 2020 21:02:53 -0400
Message-Id: <20200618010805.600873-76-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 7217e6e694da3aae6d17db8a7f7460c8d4817ebf ]

In order to create or activate a new node, lpfc_els_unsol_buffer() invokes
lpfc_nlp_init() or lpfc_enable_node() or lpfc_nlp_get(), all of them will
return a reference of the specified lpfc_nodelist object to "ndlp" with
increased refcnt.

When lpfc_els_unsol_buffer() returns, local variable "ndlp" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
lpfc_els_unsol_buffer(). When "ndlp" in DEV_LOSS, the function forgets to
decrease the refcnt increased by lpfc_nlp_init() or lpfc_enable_node() or
lpfc_nlp_get(), causing a refcnt leak.

Fix this issue by calling lpfc_nlp_put() when "ndlp" in DEV_LOSS.

Link: https://lore.kernel.org/r/1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 80d1e661b0d4..35fbcb4d52eb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8514,6 +8514,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	spin_lock_irq(shost->host_lock);
 	if (ndlp->nlp_flag & NLP_IN_DEV_LOSS) {
 		spin_unlock_irq(shost->host_lock);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
 		goto dropit;
 	}
 	spin_unlock_irq(shost->host_lock);
-- 
2.25.1

