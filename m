Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FA0C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbjEWSWO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjEWSWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D890E5
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae4048627aso6257325ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866131; x=1687458131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgcGzZlXCGd3bc0jRl53WVeei9tpamQ4JEm5NYxlArY=;
        b=j/OtVarv1TgQQf/CzhwiHGZPlrSipzn0P3g5c9xeVqBDcofogd9s03Uf5TLVVCDyQ2
         3iLT+7J/PBdidJVreP+2oGSpFTqPccYBf2dyAJZEqyN3g60WNLsKSEzML5Gq8ZglnoAR
         JogaW2m6ttGqOAkrkdqWGgGayLAxMQ/Zm22cUPgVWRLLITx2AqcEuQcyr7ejlOShJI6s
         HBI0W6MhTHvPh6uRuJExPu5TPprWpElzk+N1lpXVnznPfdtHyza892kDEkHNcs0jzgOy
         HQa1o6QdTcAm6u4lpbvszWIdjVZSGCU9pdu0spPGcg4qrOkkhmjBnHXbidwYCxPG8qF6
         LTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866131; x=1687458131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgcGzZlXCGd3bc0jRl53WVeei9tpamQ4JEm5NYxlArY=;
        b=ZmrYzlbau6PhasLC2WQ/uMu9782yYsoPHGaNrGV2HS65pzn1xfCZP08dNMfbS1s426
         OL6GBc+TAZ9qyiicRc1v2AT8IrW7C7HALrw2AFQR9pALI6wWaTZuRX3L+J75KpifkYIe
         XH0FnzdW5cqyCgH/xSL6A9rgy+uVjPpsgb439yFSWsA9ZnBmGDDR2FUKdXgbezn5eJA9
         j6pbSC8SgNwVWRBJn8wL5z94xOPBxwR2W3FuC7eDrfCbV9q1V0nAWgBveuFnfpKTshm8
         NBoE8seWevsjI0jwpis6bYRVP0jnTV3USKkWP7FOYrMHlpprc7m95zAsXK8t4NoKp6pn
         ikUw==
X-Gm-Message-State: AC+VfDy9u41dibpbcb4qYI7Zl9FCnfo6RZPxJGUOalfu6SlL3w9cbOvn
        ksLr6w8lG2SkEfoPxnSiAOzfbPxds48=
X-Google-Smtp-Source: ACHHUZ7QVlGGWvpp5wVyHVDkyKZJeZUWLoVWnOj53jpeNOGBwERAwIZfnTVbK6eJbJxo1dOleb91IA==
X-Received: by 2002:a17:903:32c3:b0:1ae:3dcf:ecf3 with SMTP id i3-20020a17090332c300b001ae3dcfecf3mr16426294plr.6.1684866131385;
        Tue, 23 May 2023 11:22:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:10 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/9] lpfc: Fix use-after-free rport memory access in lpfc_register_remote_port
Date:   Tue, 23 May 2023 11:31:58 -0700
Message-Id: <20230523183206.7728-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Due to a target port D_ID swap, it is possible for the
lpfc_register_remote_port routine to touch post mortem fc_rport memory when
trying to access fc_rport->dd_data.

The D_ID swap causes a simultaneous call to lpfc_unregister_remote_port,
where fc_remote_port_delete reclaims fc_rport memory.

Remove the fc_rport->dd_data->pnode NULL assignment because the following
line reassigns ndlp->rport with an fc_rport object from fc_remote_port_add
anyways.  The pnode nullification is superfluous.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 67bfdddb897c..63e42e3f2165 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4498,14 +4498,6 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	if (vport->load_flag & FC_UNLOADING)
 		return;
 
-	/*
-	 * Disassociate any older association between this ndlp and rport
-	 */
-	if (ndlp->rport) {
-		rdata = ndlp->rport->dd_data;
-		rdata->pnode = NULL;
-	}
-
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
-- 
2.38.0

