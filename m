Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8EEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 09:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB30E64E22
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 09:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhCAJbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 04:31:49 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:43150 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233853AbhCAJbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 04:31:48 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app4 (Coremail) with SMTP id cS_KCgB3L2M6tDxgbI7lAQ--.4232S4;
        Mon, 01 Mar 2021 17:30:38 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: aic79xx: Add missing check in ahd_handle_seqint
Date:   Mon,  1 Mar 2021 17:30:29 +0800
Message-Id: <20210301093029.27977-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgB3L2M6tDxgbI7lAQ--.4232S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWkXFW5uF4rur43tF48Xrb_yoW8try5pa
        9ag397Ar4DCrsrtr4rW34vqF15G3W0ka43CFn3W3s2kFnxKas8uFy7Kr1rWF4kCr97Zr9I
        g3ZIk3yfWF4UGrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgcLBlZdtSjMQAAFsX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ahd_lookup_scb() may return a null pointer and further lead to
null pointer dereference in case DATA_OVERRUN. Fix this by adding
a null check.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 44 +++++++++++++++--------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3e3100dbfda3..f990f7f48f49 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2199,30 +2199,32 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 
 		scbindex = ahd_get_scbptr(ahd);
 		scb = ahd_lookup_scb(ahd, scbindex);
+		if (scb != NULL) {
 #ifdef AHD_DEBUG
-		lastphase = ahd_inb(ahd, LASTPHASE);
-		if ((ahd_debug & AHD_SHOW_RECOVERY) != 0) {
-			ahd_print_path(ahd, scb);
-			printk("data overrun detected %s.  Tag == 0x%x.\n",
-			       ahd_lookup_phase_entry(lastphase)->phasemsg,
-			       SCB_GET_TAG(scb));
-			ahd_print_path(ahd, scb);
-			printk("%s seen Data Phase.  Length = %ld.  "
-			       "NumSGs = %d.\n",
-			       ahd_inb(ahd, SEQ_FLAGS) & DPHASE
-			       ? "Have" : "Haven't",
-			       ahd_get_transfer_length(scb), scb->sg_count);
-			ahd_dump_sglist(scb);
-		}
+			lastphase = ahd_inb(ahd, LASTPHASE);
+			if ((ahd_debug & AHD_SHOW_RECOVERY) != 0) {
+				ahd_print_path(ahd, scb);
+				printk("data overrun detected %s.  Tag == 0x%x.\n",
+					ahd_lookup_phase_entry(lastphase)->phasemsg,
+					SCB_GET_TAG(scb));
+				ahd_print_path(ahd, scb);
+				printk("%s seen Data Phase.  Length = %ld.  "
+					"NumSGs = %d.\n",
+					ahd_inb(ahd, SEQ_FLAGS) & DPHASE
+					? "Have" : "Haven't",
+					ahd_get_transfer_length(scb), scb->sg_count);
+				ahd_dump_sglist(scb);
+			}
 #endif
 
-		/*
-		 * Set this and it will take effect when the
-		 * target does a command complete.
-		 */
-		ahd_freeze_devq(ahd, scb);
-		ahd_set_transaction_status(scb, CAM_DATA_RUN_ERR);
-		ahd_freeze_scb(scb);
+			/*
+			* Set this and it will take effect when the
+			* target does a command complete.
+			*/
+			ahd_freeze_devq(ahd, scb);
+			ahd_set_transaction_status(scb, CAM_DATA_RUN_ERR);
+			ahd_freeze_scb(scb);
+		}
 		break;
 	}
 	case MKMSG_FAILED:
-- 
2.17.1

