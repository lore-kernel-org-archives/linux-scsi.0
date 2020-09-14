Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BA0C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F5B206C9
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600094135;
	bh=jbKqVgYyt3WvvappifNaKnDCFj63tYxxqnvdh/gRnzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YXtir4sKKYyl/BRTUBP8+3o2JAk89L62CNIxs00kRmBxG9S3RGR0axoHmhL4ZVi76
	 fATci3rCVDqo/83oBcCFZkSiFtCvwaeAt8IsRI1ZwrZkW2h9t5so0uM0ECGN9yR2Uy
	 gP4fWuNO7Hfyzp4uaGi3aguLs4p1EKla01wG37B4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgINOff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgINNFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C8322250;
        Mon, 14 Sep 2020 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088708;
        bh=jbKqVgYyt3WvvappifNaKnDCFj63tYxxqnvdh/gRnzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lt523xVr5mU2wbsS1QMndTiXAytOYkTnjBXXyZaZdBxPWqIBdRiZeK47iGma82giH
         kc/Er7xBuTPJ6P+UVawWSyST0a5ZA3HOfz/FlHFu81rvMoivMSqTQR4s8WOz9oznSf
         8PpNgHCP9XOsqCysmYmdFhCw4S+4N25g5Kit3+dE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/19] scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
Date:   Mon, 14 Sep 2020 09:04:47 -0400
Message-Id: <20200914130502.1804708-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130502.1804708-1-sashal@kernel.org>
References: <20200914130502.1804708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

[ Upstream commit 7b08e89f98cee9907895fabb64cf437bc505ce9a ]

The driver is unable to successfully login with remote device. During pt2pt
login, the driver completes its FLOGI request with the remote device having
WWN precedence.  The remote device issues its own (delayed) FLOGI after
accepting the driver's and, upon transmitting the FLOGI, immediately
recognizes it has already processed the driver's FLOGI thus it transitions
to sending a PLOGI before waiting for an ACC to its FLOGI.

In the driver, the FLOGI is received and an ACC sent, followed by the PLOGI
being received and an ACC sent. The issue is that the PLOGI reception
occurs before the response from the adapter from the FLOGI ACC is
received. Processing of the PLOGI sets state flags to perform the REG_RPI
mailbox command and proceed with the rest of discovery on the port. The
same completion routine used by both FLOGI and PLOGI is generic in
nature. One of the things it does is clear flags, and those flags happen to
drive the rest of discovery.  So what happened was the PLOGI processing set
the flags, the FLOGI ACC completion cleared them, thus when the PLOGI ACC
completes it doesn't see the flags and stops.

Fix by modifying the generic completion routine to not clear the rest of
discovery flag (NLP_ACC_REGLOGIN) unless the completion is also associated
with performing a mailbox command as part of its handling.  For things such
as FLOGI ACC, there isn't a subsequent action to perform with the adapter,
thus there is no mailbox cmd ptr. PLOGI ACC though will perform REG_RPI
upon completion, thus there is a mailbox cmd ptr.

Link: https://lore.kernel.org/r/20200828175332.130300-3-james.smart@broadcom.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9032793c405eb..6a4b496081e4a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4112,7 +4112,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 out:
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) && shost) {
 		spin_lock_irq(shost->host_lock);
-		ndlp->nlp_flag &= ~(NLP_ACC_REGLOGIN | NLP_RM_DFLT_RPI);
+		if (mbox)
+			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
+		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(shost->host_lock);
 
 		/* If the node is not being used by another discovery thread,
-- 
2.25.1

