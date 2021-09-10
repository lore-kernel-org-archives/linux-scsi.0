Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492FDC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BDF1611F0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 00:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhIJAmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233285AbhIJATo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63F62610A3;
        Fri, 10 Sep 2021 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233114;
        bh=jrYfTcMRemDgUOMZ625TC1DiMS2P/XHo05XSHtljRuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG/lXR7EJJuFXBV6+ncEO2mff/dgZ7kKf2bcF2rNwfplrJ4gxFZNL0sm+WVFyRLw4
         e1tRInmyFqM4+ThbAUGYY/gDwSqAukUR81Flk9QwRlSioy0S/7pIep+m3duNzpRsSw
         vY8nENkYMUIMAGdfI/Fyc/bn/05QYTrenm/K4ZAg+5Bx5EG9QIWYs/Okj0vncaqh6l
         +0EOUq9zXqRC5NpM+lwmqfpLzfRmZfwxjvbm4veewgN9AMSrA1kQMxWpTRmo2PigJe
         jnmS525QmhkGNwuBj5rHIAeuxUKepOL95004y3PAXhQmcXTEXdOeyOclE3uwT07wXd
         VkIKyPzhvGVnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 09/88] scsi: lpfc: Fix NULL ptr dereference with NPIV ports for RDF handling
Date:   Thu,  9 Sep 2021 20:17:01 -0400
Message-Id: <20210910001820.174272-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2d338eb55b14ab9d245e8b1d982adecca8c4c613 ]

RDF ELS handling for NPIV ports may result in an incorrect NDLP reference
count.  In the event of a persistent link down, this may lead to premature
release of an NDLP structure and subsequent NULL ptr dereference panic.

Remove extraneous lpfc_nlp_put() call in NPIV port RDF processing.

Link: https://lore.kernel.org/r/20210707184351.67872-9-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 933927f738c7..6e7b81184db3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3267,7 +3267,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		return 1;
 	}
 
-	/* Keep the ndlp just in case RDF is being sent */
 	return 0;
 }
 
@@ -3511,11 +3510,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
-	/* RDF ELS is not required on an NPIV VN_Port.  */
-	if (vport->port_type == LPFC_NPIV_PORT) {
-		lpfc_nlp_put(ndlp);
+	/* RDF ELS is not required on an NPIV VN_Port. */
+	if (vport->port_type == LPFC_NPIV_PORT)
 		return -EACCES;
-	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RDF);
-- 
2.30.2

