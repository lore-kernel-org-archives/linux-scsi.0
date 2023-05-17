Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4343C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 14:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjEQOQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjEQOQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 10:16:00 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A276E76AC;
        Wed, 17 May 2023 07:15:57 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 29FFE342727;
        Wed, 17 May 2023 17:15:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=hhuCKxrOOMxz40mcCv
        w/VMLdNFqtSTgFPVATb9/tl+U=; b=sMbLdFAx/ejGSVNnMZU/HwlZXl3H/Jgq0v
        6qfcK51nmaQZczl6q2j3IsDycrEqGFAUuoncgfDy0BGecGvJFUteyE4ITTxfUmEj
        bnjblzJ6Nw/wYjIcPnPKPLpp3uq5NvoYMn08poW/0AOF+LU+7nd+3XQb4Q9qizVq
        qc1hv6pvg=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 204B9341E5B;
        Wed, 17 May 2023 17:15:56 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Wed, 17 May 2023 17:15:55 +0300
Received: from yadro.com (172.22.1.19) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 17 May
 2023 17:15:54 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>,
        "Dmitry Bogdanov" <d.bogdanov@yadro.com>
Subject: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
Date:   Wed, 17 May 2023 17:15:37 +0300
Message-ID: <20230517141537.80936-3-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517141537.80936-1-k.shelekhin@yadro.com>
References: <20230517141537.80936-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.1.19]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a thin provisioned block device lacks free LBA it ends bio requests
with BLK_STS_NOSPC. Currently iblock treats bio status as a boolean and
terminates failed requests with LOGICAL UNIT COMMUNICATION FAILURE if
the status is non-zero. Thus, initiators see space allocation errors as
I/O errors.

This commit modifies the iblock_req structure to store the status of the
first failed bio instead of the total number of failed bios. The status
is then used to set the specific sense reason.

For BLK_STS_NOSPC the sense reason is set to TCM_SPACE_ALLOCATION_FAILED
as per SBC-3 4.7.3.6.

On Linux initiators:

old:

  $ dd if=/dev/zero of=/dev/sda oflag=direct bs=4k count=1
  dd: error writing '/dev/sda': I/O error

new:

  $ dd if=/dev/zero of=/dev/sda oflag=direct bs=4k count=1
  dd: error writing '/dev/sda': No space left on device

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_iblock.c | 28 +++++++++++++++++++++-------
 drivers/target/target_core_iblock.h |  2 +-
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index cc838ffd1294..78831a3df511 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -310,20 +310,33 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
+static sense_reason_t iblock_blk_status_to_reason(blk_status_t status)
+{
+	switch (status) {
+	case BLK_STS_OK:
+		return TCM_NO_SENSE;
+	case BLK_STS_NOSPC:
+		return TCM_SPACE_ALLOCATION_FAILED;
+	default:
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+}
+
 static void iblock_complete_cmd(struct se_cmd *cmd)
 {
 	struct iblock_req *ibr = cmd->priv;
-	u8 status;
+	sense_reason_t reason;
 
 	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
-		status = SAM_STAT_CHECK_CONDITION;
+	reason = iblock_blk_status_to_reason(atomic_read(&ibr->status));
+
+	if (reason == TCM_NO_SENSE)
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	else
-		status = SAM_STAT_GOOD;
+		target_complete_cmd_with_sense(cmd, SAM_STAT_CHECK_CONDITION, reason);
 
-	target_complete_cmd(cmd, status);
 	kfree(ibr);
 }
 
@@ -335,9 +348,10 @@ static void iblock_bio_done(struct bio *bio)
 	if (bio->bi_status) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
 		/*
-		 * Bump the ib_bio_err_cnt and release bio.
+		 * Set the error status of the iblock request to the error
+		 * status of the first failed bio.
 		 */
-		atomic_inc(&ibr->ib_bio_err_cnt);
+		atomic_cmpxchg(&ibr->status, BLK_STS_OK, bio->bi_status);
 		smp_mb__after_atomic();
 	}
 
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 8c55375d2f75..fda2e41b2e74 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -13,7 +13,7 @@
 
 struct iblock_req {
 	refcount_t pending;
-	atomic_t ib_bio_err_cnt;
+	atomic_t status;
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
-- 
2.40.1


