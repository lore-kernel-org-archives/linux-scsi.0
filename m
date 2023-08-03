Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3587C04A6A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Aug 2023 13:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbjHCNE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 09:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbjHCNEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 09:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375E42737;
        Thu,  3 Aug 2023 06:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9960961DA1;
        Thu,  3 Aug 2023 13:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7ABC433C9;
        Thu,  3 Aug 2023 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691067837;
        bh=/sJ8GlqSaIa7yRItwZDrRue08c6UD48Inf6m+MdMfDs=;
        h=From:To:Cc:Subject:Date:From;
        b=jxGnvcQ7cQ9bXa/kgAC1Y9Dkb8MR+MecHZZiT1BXicAOBxeFW1/tnVe/E+Tdp4bZL
         TSe0xfZkT2z3z5ODMeNKNlPYcjTRcO9y41iPYk/9lYS2JuVacDiWkFoYZNHwaghrD0
         Ju172NxMtKbrbhIldht3Cx+KYAkOCSF4lpodv1tMbF08vVXN16S9QQmSPOQo7OPWLY
         b6tIUfJOikLML0veYY7zqW70KzwLuXpila6UmEY31Nysz8OKN2S3ei7YXbcFOsw2iF
         eqLOetBmkUV+YL5+GQqtIFi0ep9w5PC7G3oGF4V2q4ZbFGt5/QhwT/+l8O6ZtZYx/t
         TuC+qxUotf4QA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, BassCheck <bass@buaa.edu.cn>,
        Justin Tee <justin.tee@broadcom.com>,
        Laurence Oberman <loberman@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 1/2] scsi: lpfc: Fix a possible data race in lpfc_unregister_fcf_rescan()
Date:   Thu,  3 Aug 2023 09:03:52 -0400
Message-Id: <20230803130354.641771-1-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.251
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 0e881c0a4b6146b7e856735226208f48251facd8 ]

The variable phba->fcf.fcf_flag is often protected by the lock
phba->hbalock() when is accessed. Here is an example in
lpfc_unregister_fcf_rescan():

  spin_lock_irq(&phba->hbalock);
  phba->fcf.fcf_flag |= FCF_INIT_DISC;
  spin_unlock_irq(&phba->hbalock);

However, in the same function, phba->fcf.fcf_flag is assigned with 0
without holding the lock, and thus can cause a data race:

  phba->fcf.fcf_flag = 0;

To fix this possible data race, a lock and unlock pair is added when
accessing the variable phba->fcf.fcf_flag.

Reported-by: BassCheck <bass@buaa.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://lore.kernel.org/r/20230630024748.1035993-1-islituo@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0abce779fbb13..12602b161bd80 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6699,7 +6699,9 @@ lpfc_unregister_fcf_rescan(struct lpfc_hba *phba)
 	if (rc)
 		return;
 	/* Reset HBA FCF states after successful unregister FCF */
+	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag = 0;
+	spin_unlock_irq(&phba->hbalock);
 	phba->fcf.current_rec.flag = 0;
 
 	/*
-- 
2.40.1

