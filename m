Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCFDC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 22:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7BE661039
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 22:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhIYWmv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 18:42:51 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35418
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230024AbhIYWmu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 18:42:50 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 155F14015E;
        Sat, 25 Sep 2021 22:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632609674;
        bh=IWETKfvDj1ycLSGBgyL822VHIbgmOP+GWioFWH2k5aA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=TiSo+YuuPt0XMzWRZMjLHono6pA8p0F/Q/3uGn9aajxCXO79ifFPR9P0z2K8qJU8h
         ZNNjJv6ZTVjCpg+i/LlkYC0omeIjTSG0FTbTT7gseOYSXLc/pMyoI0/MO3eV1bYdHf
         sGSfxZRlqOk/9thqtsokdm6K/RuEiiSvzHFmogJqdjT6lh6zD0nJ4KRooYOPeTBA2M
         dnL1Ol4D9iPqdncyscdZdPxsamJFnAIy1pkfqZf14l1XKVnagM8TpJg5Yb+UWfJdI1
         KunhKBu+/j1Oays3KSidtgMD5oDSFORhB50VZA/LWJAowUQzlwqBzyrISjthl/BujH
         pRFbuwbVNGyUQ==
From:   Colin King <colin.king@canonical.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: return NULL rather than a plain 0 integer
Date:   Sat, 25 Sep 2021 23:41:13 +0100
Message-Id: <20210925224113.183040-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Function lpfc_sli4_perform_vport_cvl returns a pointer to struct
lpfc_nodelist so returning a plain 0 integer isn't good practice.
Fix this by returning a NULL instead.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8d5537ec0f30..6dc0be8bc177 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6564,7 +6564,7 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp = lpfc_nlp_init(vport, Fabric_DID);
 		if (!ndlp)
-			return 0;
+			return NULL;
 		/* Set the node type */
 		ndlp->nlp_type |= NLP_FABRIC;
 		/* Put ndlp onto node list */
-- 
2.32.0

