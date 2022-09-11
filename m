Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0635ECAAD3
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIKWPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiIKWPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:14 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C659113CD2
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:11 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q11so1848150qkc.12
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DCIpr8h2aVDWh3vAvmFXHi1pWMnjEk45azUk+drAaMQ=;
        b=QRLFoYPlxJqQQeSaQKfXdgeZ0/gvrZ6Yc6rdEdMvLoNWija8hW+adBLToNhVnQ27OK
         iY2O1N+J7xqHvwU8Evtn6sqSZzbjNjCZYz1ODXPXK7bCR2B5yqTbJqwTyBea5nFKcJTr
         p9Hn6dsa5zhwW+tt1QTsT9S1h9BA9UGjgbJCIaAYn/BH1v8i3fWuPO3z2InSY/lRDWBZ
         hINGyxwTG3n22S1h361REFhX0GkWNrGlaq7o9QT56mm2D6NsQd+hD8nuP3LpEBwXVDrX
         pQkkyFdotCXmFAB3E6TM0h551+cHdQ2slfsCLWEnxPZw8AeSfrJJN5gwNqLocTTYFCyC
         g88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DCIpr8h2aVDWh3vAvmFXHi1pWMnjEk45azUk+drAaMQ=;
        b=KVEdwwo8QuxYH+jRNXstNpZIpQlRvqAKjaWCtipSU7hH8P4tK+l1HvGvhg46tpaNDQ
         CrcaMT2aPYEwLVpmzhlWGl+/WzLwr1m4TyvLCOKN3vgzEGfHTLwhrxFZ/VyreQedebd0
         jaAlCI52BRx+xkqQcB23iLz/UTYhE171vdn7Q+bTE3kl7okOLvh0N2bDY/6lf+UPtl61
         wvCTMGYGEaVtyrJqvcimqiG5uKzpyu7kamzAuj2jBVIUbzsCRTJRv6tZxUygOf+p1RwF
         0wJqTK3y2nooPj7YcIf2MHryio1FdDYcsRuHTIqbsLrQ8rOlaov9Ct1/ki2Dt7I+DY4p
         FIkA==
X-Gm-Message-State: ACgBeo1t6wUBzJ8gzuBRAvqXe80dr1Q6WuKAgq6MNg3s3KkIDDzksgoL
        +4kEM8GkVnyUTSFDw1CcjDefktA6MsQ=
X-Google-Smtp-Source: AA6agR5BdhOrTeTpCKbOzBE5Ny1qLK+Q+1xiIcW9luwzCnRCxNBMfdsV+QSvUgcCo0YjJPKRMvExzw==
X-Received: by 2002:a37:bc84:0:b0:6ce:18a8:7e63 with SMTP id m126-20020a37bc84000000b006ce18a87e63mr3500328qkf.206.1662934510859;
        Sun, 11 Sep 2022 15:15:10 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/13] lpfc: Fix prli_fc4_req checks in PRLI handling
Date:   Sun, 11 Sep 2022 15:14:53 -0700
Message-Id: <20220911221505.117655-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The if statment check (prli_fc4_req & PRLI_NVME_TYPE) evaluates to
true when receiving a PRLI request for bogus FC4 type codes that
happen to have the 3rd or 5th bit set because PRLI_NVME_TYPE is 0x28.
This leads to sending a PRLI_NVME_ACC even for bogus FC4 type codes.

Change the bitwise & check to an exact == type code check to ensure
we send PRLI_NVME_ACC only for NVME type coded PRLI requests.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9e69de9eb992..4c372553e2aa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6006,7 +6006,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	if (prli_fc4_req == PRLI_FCP_TYPE) {
 		cmdsize = sizeof(uint32_t) + sizeof(PRLI);
 		elsrspcmd = (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK));
-	} else if (prli_fc4_req & PRLI_NVME_TYPE) {
+	} else if (prli_fc4_req == PRLI_NVME_TYPE) {
 		cmdsize = sizeof(uint32_t) + sizeof(struct lpfc_nvme_prli);
 		elsrspcmd = (ELS_CMD_ACC | (ELS_CMD_NVMEPRLI & ~ELS_RSP_MASK));
 	} else {
@@ -6069,7 +6069,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		npr->ConfmComplAllowed = 1;
 		npr->prliType = PRLI_FCP_TYPE;
 		npr->initiatorFunc = 1;
-	} else if (prli_fc4_req & PRLI_NVME_TYPE) {
+	} else if (prli_fc4_req == PRLI_NVME_TYPE) {
 		/* Respond with an NVME PRLI Type */
 		npr_nvme = (struct lpfc_nvme_prli *) pcmd;
 		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
-- 
2.35.3

