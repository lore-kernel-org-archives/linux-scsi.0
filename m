Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E4AC4740C
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288A0214AF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sj9zYjXi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfIVD7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:17 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35113 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfIVD7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:17 -0400
Received: by mail-ot1-f68.google.com with SMTP id z6so9417455otb.2
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G8c70pp1rOeoL6lqRZBslA+Yg/6EoNv+VxK0kiJ3HxY=;
        b=sj9zYjXifRIG8YAYzsFEAQRt7BDb+JEz/VkGcc7cm78+/B0EVK0eV1vSDKqO5ffgYy
         G85g+PQZWc0IaiM8K69BM68RZ3qNMNccckztT+lA11xitSdhZqZBFloxamLPeWjADAWf
         qih3HY2rw5uvGy8v1pVk1+apX+d5vWLExprWpvJ5t3TB5jXaX597ZmsLtDfu9iMrcF2r
         Z5j5jXQrDVBeWoOLIivZ95gfif8fBEVFORcmLuchhlqSaeTUM/wbW+HrIqHzRV/J5eNd
         uzLqnzgHnEwqC/IxDBGYJ7bge5KzkLSgOExYbXed3I9l7lT/7bDqiZ3YC1gcZBL3Bc5u
         Eiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G8c70pp1rOeoL6lqRZBslA+Yg/6EoNv+VxK0kiJ3HxY=;
        b=QJkLoYMHkd3/6Hr0/4q1ZNpeqTyQuRaergPp+YJisc4CPxpXNyW+e6Iw7gHF3oYuYK
         rE5i1C1r6VIsHB+g0Zyd+9J+9Kg534OI1tQy8fnhZ2/cx6V2o4P9ZVOYJVJizJn2u3Wo
         cxfkS2+IqRmZfieuOMtEVDQAI6BIHtuSCfRQOxiNQyCpSltmmjnCzM1o8l1NsCrijO4L
         //R82mO1E8SK8nC5md/DMSqwnBwsmYK50O2c2meurUOH29zCSsCt9/nrT8bvXyytm+gR
         3CNOlTsvQzGnrrOF54OZLDV0brWCCOasz5daCONyTmiqS1nmwsolLCkI2BL+Vq/muHEB
         7VJA==
X-Gm-Message-State: APjAAAV1AEp3GggZGU6l86MWPKSeIiK9yGGYkcmaZXLrSNUyjEaQ40cx
        VPjEstxeQETR0Y0W7g1ZedUTwF97
X-Google-Smtp-Source: APXvYqzj49tYe6xtQlCDor+RAqtzjsswBiOXu3HvtKqFUS8p2EbIzfMcN3MBRK+uv2Z8pClTYoJGPQ==
X-Received: by 2002:a9d:3463:: with SMTP id v90mr18034780otb.29.1569124756649;
        Sat, 21 Sep 2019 20:59:16 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 02/20] lpfc: Fix premature re-enabling of interrupts in lpfc_sli_host_down
Date:   Sat, 21 Sep 2019 20:58:48 -0700
Message-Id: <20190922035906.10977-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use of spin_lock_irq may re-enable interrupts prematurely.

Convert to spin_lock. Note: code is under the phba->hba_lock which
has been locked with irqsave.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a0c6945b8139..3b3ae2182e59 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10678,14 +10678,14 @@ lpfc_sli_host_down(struct lpfc_vport *vport)
 				set_bit(LPFC_DATA_READY, &phba->data_flags);
 			}
 			prev_pring_flag = pring->flag;
-			spin_lock_irq(&pring->ring_lock);
+			spin_lock(&pring->ring_lock);
 			list_for_each_entry_safe(iocb, next_iocb,
 						 &pring->txq, list) {
 				if (iocb->vport != vport)
 					continue;
 				list_move_tail(&iocb->list, &completions);
 			}
-			spin_unlock_irq(&pring->ring_lock);
+			spin_unlock(&pring->ring_lock);
 			list_for_each_entry_safe(iocb, next_iocb,
 						 &pring->txcmplq, list) {
 				if (iocb->vport != vport)
-- 
2.13.7

