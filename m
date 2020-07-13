Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBBBC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990D22065D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.org header.i=@ozlabs.org header.b="O9oApCeN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGMIjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:39:13 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35677 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGMIjN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 04:39:13 -0400
Received: by ozlabs.org (Postfix, from userid 1010)
        id 4B4xrv3RxFz9sR4; Mon, 13 Jul 2020 18:39:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1594629551; bh=eEL+NIdVjI0sm+42HEBVksKKYNXOUSN5j0MmVpNHvRA=;
        h=From:To:Cc:Subject:Date:From;
        b=O9oApCeNhxVO+iDv3/2w10D6Q3iZsSMgibyslMtR0L1lxc8ec5V67jZVdwSEdQgwO
         DnqCgSwmnGYcPl5phXGva2DEw9NfclNqoSsm3c6vgcDpeD5tgDCpt8a12vTImcthRA
         VQzdDLQ/KAunTCbxdp6PBcFxMzGsznjG8ioLfEBsA3p4Ssx3UsTzlNUpN7EZ/GQFWb
         HuMVhjFMF/2BLdjfrt+oCFU6CrQDR+ThMJaz4Id2BnoealMlGD4iRQj98kXrquQlh7
         79D3ifv6+lgOce9McKV1Bnvsl2aEZrDv9qRGiXvO2T6/KKq5/ykODZMrmE5sRAOgQ5
         uD5mlynFb5GMQ==
From:   Anton Blanchard <anton@ozlabs.org>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] lpfc: Quieten some printks
Date:   Mon, 13 Jul 2020 18:39:08 +1000
Message-Id: <20200713083908.1104927-1-anton@ozlabs.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a big box the lpfc driver emits a few thousand "Set Affinity" lines
to the console. Reduce the priority of these from KERN_ERR to KERN_INFO,
and also fix a few printks that had no log level.

Signed-off-by: Anton Blanchard <anton@ozlabs.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6637f84a3d1b..daa41ddaf33d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11008,7 +11008,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 		/* 1 to 1, the first LPFC_CPU_FIRST_IRQ cpus to a unique hdwq */
 		cpup->hdwq = idx;
 		idx++;
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"3333 Set Affinity: CPU %d (phys %d core %d): "
 				"hdwq %d eq %d flg x%x\n",
 				cpu, cpup->phys_id, cpup->core_id,
@@ -11086,7 +11086,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			start_cpu = first_cpu;
 		cpup->hdwq = new_cpup->hdwq;
  logit:
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"3335 Set Affinity: CPU %d (phys %d core %d): "
 				"hdwq %d eq %d flg x%x\n",
 				cpu, cpup->phys_id, cpup->core_id,
@@ -13974,8 +13974,8 @@ lpfc_init(void)
 {
 	int error = 0;
 
-	printk(LPFC_MODULE_DESC "\n");
-	printk(LPFC_COPYRIGHT "\n");
+	pr_info(LPFC_MODULE_DESC "\n");
+	pr_info(LPFC_COPYRIGHT "\n");
 
 	error = misc_register(&lpfc_mgmt_dev);
 	if (error)
-- 
2.26.2

