Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FF3C433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 16:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D344761059
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 16:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhECQ6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 12:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhECQxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 12:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55F3161429;
        Mon,  3 May 2021 16:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060128;
        bh=E/VjnYJy91YhTHT/RiVfvE26KSzttDEQeUZREHPw+9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmTb08GXitXfPZIz3aoUsHwUdfU+Cb5XRXqJQUD19oVEjmJE/synqgoe8tJsPfWWT
         ZPihilaAuxxSYufK/ueEN8Rec9pa2eUw3VkZJOwDvO9AaJ+W5cOwZSq8coP0hELySF
         zXoEdnUD+hdDZ5ebdIMyzHi/CWCzFmnPxzw7VxTGZcSUKURM8fc8nKwHmpCh67dq9x
         SY/JPqQBqtn/pOehok40jFVdgfz/pP50egmx+NhVa/QeyozMWaaLAWNiNfNUwy0EPg
         MdhM1X4am9sUcHzhJ6X+cNjv7jYY59KSI7YRINcXJeQvzFDzWsJgl31NVjcBs4xmCM
         rqbo6p/0zLJPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/31] scsi: lpfc: Fix pt2pt connection does not recover after LOGO
Date:   Mon,  3 May 2021 12:41:35 -0400
Message-Id: <20210503164204.2854178-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit bd4f5100424d17d4e560d6653902ef8e49b2fc1f ]

On a pt2pt setup, between 2 initiators, if one side issues a a LOGO, there
is no relogin attempt. The FC specs are grey in this area on which port
(higher wwn or not) is to re-login.

As there is no spec guidance, unconditionally re-PLOGI after the logout to
ensure a login is re-established.

Link: https://lore.kernel.org/r/20210301171821.3427-8-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 96411754aa43..40c6d6eacea9 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -708,9 +708,14 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_type & NLP_NVME_TARGET) ||
+		(vport->fc_flag & FC_PT2PT))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node */
+		/* Only try to re-login if this is NOT a Fabric Node
+		 * AND the remote NPORT is a FCP/NVME Target or we
+		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
+		 * case for LOGO as a response to ADISC behavior.
+		 */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(shost->host_lock);
-- 
2.30.2

