Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE3EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 10:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F29264FE4
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 10:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCJKv2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 05:51:28 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:36260 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229706AbhCJKvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Mar 2021 05:51:17 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app2 (Coremail) with SMTP id by_KCgB3XomDpEhgYxkiAg--.43318S4;
        Wed, 10 Mar 2021 18:50:48 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: aic79xx: Add missing check in ahc_handle_seqint
Date:   Wed, 10 Mar 2021 18:50:42 +0800
Message-Id: <20210310105042.31660-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgB3XomDpEhgYxkiAg--.43318S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWrCFW3GrykGr43Aw1UJrb_yoW5Arykp3
        Z7K392krs5ur4jy3y8Xw4vqa15Jr4xtasIyF1xG3s2kr43Ca45u3WIgFyaqF1kWr92qrya
        gas09rWDJr4UWwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUTBlZdtSrQTAANsX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ahc_lookup_scb() may return a null pointer and further lead to
null-pointer-dereference in case DATA_OVERRUN. Fix this by adding
a null check.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 72 +++++++++++++++--------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 4b04ab8908f8..3a1cd6a0334e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1382,43 +1382,45 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 		u_int i;
 
 		scb = ahc_lookup_scb(ahc, scbindex);
-		for (i = 0; i < num_phases; i++) {
-			if (lastphase == ahc_phase_table[i].phase)
-				break;
-		}
-		ahc_print_path(ahc, scb);
-		printk("data overrun detected %s."
-		       "  Tag == 0x%x.\n",
-		       ahc_phase_table[i].phasemsg,
-		       scb->hscb->tag);
-		ahc_print_path(ahc, scb);
-		printk("%s seen Data Phase.  Length = %ld.  NumSGs = %d.\n",
-		       ahc_inb(ahc, SEQ_FLAGS) & DPHASE ? "Have" : "Haven't",
-		       ahc_get_transfer_length(scb), scb->sg_count);
-		if (scb->sg_count > 0) {
-			for (i = 0; i < scb->sg_count; i++) {
-
-				printk("sg[%d] - Addr 0x%x%x : Length %d\n",
-				       i,
-				       (ahc_le32toh(scb->sg_list[i].len) >> 24
-					& SG_HIGH_ADDR_BITS),
-				       ahc_le32toh(scb->sg_list[i].addr),
-				       ahc_le32toh(scb->sg_list[i].len)
-				       & AHC_SG_LEN_MASK);
+		if (scb != NULL) {
+			for (i = 0; i < num_phases; i++) {
+				if (lastphase == ahc_phase_table[i].phase)
+					break;
 			}
+			ahc_print_path(ahc, scb);
+			printk("data overrun detected %s."
+				"  Tag == 0x%x.\n",
+				ahc_phase_table[i].phasemsg,
+				scb->hscb->tag);
+			ahc_print_path(ahc, scb);
+			printk("%s seen Data Phase.  Length = %ld.  NumSGs = %d.\n",
+				ahc_inb(ahc, SEQ_FLAGS) & DPHASE ? "Have" : "Haven't",
+				ahc_get_transfer_length(scb), scb->sg_count);
+			if (scb->sg_count > 0) {
+				for (i = 0; i < scb->sg_count; i++) {
+
+					printk("sg[%d] - Addr 0x%x%x : Length %d\n",
+						i,
+						(ahc_le32toh(scb->sg_list[i].len) >> 24
+						& SG_HIGH_ADDR_BITS),
+						ahc_le32toh(scb->sg_list[i].addr),
+						ahc_le32toh(scb->sg_list[i].len)
+						& AHC_SG_LEN_MASK);
+				}
+			}
+			/*
+			* Set this and it will take effect when the
+			* target does a command complete.
+			*/
+			ahc_freeze_devq(ahc, scb);
+			if ((scb->flags & SCB_SENSE) == 0) {
+				ahc_set_transaction_status(scb, CAM_DATA_RUN_ERR);
+			} else {
+				scb->flags &= ~SCB_SENSE;
+				ahc_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
+			}
+			ahc_freeze_scb(scb);
 		}
-		/*
-		 * Set this and it will take effect when the
-		 * target does a command complete.
-		 */
-		ahc_freeze_devq(ahc, scb);
-		if ((scb->flags & SCB_SENSE) == 0) {
-			ahc_set_transaction_status(scb, CAM_DATA_RUN_ERR);
-		} else {
-			scb->flags &= ~SCB_SENSE;
-			ahc_set_transaction_status(scb, CAM_AUTOSENSE_FAIL);
-		}
-		ahc_freeze_scb(scb);
 
 		if ((ahc->features & AHC_ULTRA2) != 0) {
 			/*
-- 
2.17.1

