Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4938C6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIKWPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiIKWPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:13 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C697813CC7
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:12 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id h21so5023826qta.3
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=s9cOsk5kAjxGoHr2H8VEPpvtjytxMVGw+5n53BxnbrY=;
        b=ThacgjhMU60BHZf4RMiQbWBD9wKFUWL5fKPyA7F4hevIwAS6aEe/WVjzV1tMOaEyM7
         +9tvdPsOKjujWeyF9JLspSttwIc9IZXrP3+Y6GSCyfR+owVwx/7aLmJBtimBgdn/y9NP
         1vwTo7J6XuZhp08MOTFF7gNKyNK1bbt3pmPEZxPALEOZoI34DQ6yd+xayPN1yn0CSdWl
         l1luCZojzOjkDWYnS0sz3VwD6UtqTq0hx/TZ2B3FFNgPmP34oAmwLJ6FZmDoHW7GFm9m
         QnT68iXb2WB5lAbn4X0Ibo5S+ZnKGkahpG9kXYricEXWCje4NeSirbFw1MAZ8bFDMpyS
         I8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=s9cOsk5kAjxGoHr2H8VEPpvtjytxMVGw+5n53BxnbrY=;
        b=6w+fb6S2kSrmBDefM2LFDK+AKHc/IDkPqiP+stTzW9ssTym6J6/icPlWoFg/YopaTG
         AVXzvVjOc4h50AdxSQ4tgnVe0nKDfVrsrcHHfyu9irGn8TFzJaxH8MYO6B920vkgdG7s
         zr+kW6bbJqQ9NT0O3kUysqMFzrxXUzasTRNPwPmWfscltL00I3JNeSnVise5fFLMlzZp
         wdOW/DLkMx2BQoJmkXgqnPHuN9ofcjrvwoeGXTxHukdLZSBWHPCjzBi+AH553zrTghgZ
         Zx5O9pe6DV0R9tIX7axZwIzfIyuSjBtgeBT7cwEOF0eU+ir9oiCR61XxoxyP2+/Tj5lN
         KeSg==
X-Gm-Message-State: ACgBeo3p3IblOslgvcycQa3uPoySNswpUjpY4MGnVQbalPfy7yaAg8c0
        B2AeyWmXX6EpZOifmS8IaFQSkcF8WbU=
X-Google-Smtp-Source: AA6agR6zIdbSDuSru+gN8ZOKK5LYp1w2zhuYrT5BeUhl8vhaokdxR1maNMGj9uue6TO62+qE/oIO7g==
X-Received: by 2002:a05:622a:181e:b0:343:68e6:a5a with SMTP id t30-20020a05622a181e00b0034368e60a5amr21743523qtc.236.1662934511825;
        Sun, 11 Sep 2022 15:15:11 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/13] lpfc: Fix FLOGI ACC with wrong SID in PT2PT topology
Date:   Sun, 11 Sep 2022 15:14:54 -0700
Message-Id: <20220911221505.117655-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a FLOGI is received before we have issued our FLOGI, the ACC
response to the received FLOGI is issued with SID 2 instead of the
expected fabric controller SID.  Certain target vendors ignore the
malformed ACC with SID 2 and wait for a properly filled ACC with
a fabric controller SID.

The lpfc_sli_prep_wqe routine depends on the FC_PT2PT flag to
fill in the fabric controller SID when in PT2PT mode, but due to
a previous commit the flag was getting cleared.  Fix by adding a
check for the defer_flogi_acc flag to know whether or not to clear
the FC_PT2PT flag on link up.

Fixes: 439b93293ff2 ("scsi: lpfc: Fix unsolicited FLOGI receive handling during PT2PT discovery")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 83d2b29ee2a6..24d533c0b729 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1353,8 +1353,13 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 				   FCH_EVT_LINKUP, 0);
 
 	spin_lock_irq(shost->host_lock);
-	vport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI | FC_ABORT_DISCOVERY |
-			    FC_RSCN_MODE | FC_NLP_MORE | FC_RSCN_DISCOVERY);
+	if (phba->defer_flogi_acc_flag)
+		vport->fc_flag &= ~(FC_ABORT_DISCOVERY | FC_RSCN_MODE |
+				    FC_NLP_MORE | FC_RSCN_DISCOVERY);
+	else
+		vport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI |
+				    FC_ABORT_DISCOVERY | FC_RSCN_MODE |
+				    FC_NLP_MORE | FC_RSCN_DISCOVERY);
 	vport->fc_flag |= FC_NDISC_ACTIVE;
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
-- 
2.35.3

