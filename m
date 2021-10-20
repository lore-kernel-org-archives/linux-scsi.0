Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2304C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8182260F9E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 18:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhJTSpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 14:45:52 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36748 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230487AbhJTSpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 14:45:51 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id BE7FE42B33;
        Wed, 20 Oct 2021 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1634755414; x=1636569815; bh=EQ/DfBxRZzoAavKJuG89Mkbv+nuEzCs37r8
        97dMJ9VU=; b=BU3qJJ6q4hkUJTSWw24UnoD45blAgtHTjPcwZlBd8RO3b8ny5F7
        Nd+m6+OEKvs5GPggLXgYgrvtZ/W9FJ+MJxezUdt3JKxuOBOgCpos/2+TOZBkzJ/t
        QoOTNy4NnKINKrWlYQ6f8E0O/hmYcsLwgzcNyLu1GkBGeEzE1dMed7OM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Bw5q7IXKruwV; Wed, 20 Oct 2021 21:43:34 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BCF2042B34;
        Wed, 20 Oct 2021 21:43:33 +0300 (MSK)
Received: from yadro.com (10.199.9.171) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 Oct 2021 21:43:32 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
Date:   Wed, 20 Oct 2021 21:43:19 +0300
Message-ID: <20211020184319.588002-3-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211020184319.588002-1-k.shelekhin@yadro.com>
References: <20211020184319.588002-1-k.shelekhin@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.9.171]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
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
 drivers/target/target_core_iblock.c | 24 ++++++++++++++++++++----
 drivers/target/target_core_iblock.h |  2 +-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 4069a1edcfa3..b4c12584906b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -305,20 +305,35 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
+static sense_reason_t iblock_blk_status_to_reason(blk_status_t status)
+{
+       switch (status) {
+       case BLK_STS_OK:
+               return TCM_NO_SENSE;
+       case BLK_STS_NOSPC:
+               return TCM_SPACE_ALLOCATION_FAILED;
+       default:
+               return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+       }
+}
+
 static void iblock_complete_cmd(struct se_cmd *cmd)
 {
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
+	sense_reason_t reason;
 
 	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
+	reason = iblock_blk_status_to_reason(atomic_read(&ibr->status));
+
+	if (reason != TCM_NO_SENSE)
 		status = SAM_STAT_CHECK_CONDITION;
 	else
 		status = SAM_STAT_GOOD;
 
-	target_complete_cmd(cmd, status);
+	target_complete_cmd_with_sense(cmd, status, reason);
 	kfree(ibr);
 }
 
@@ -330,9 +345,10 @@ static void iblock_bio_done(struct bio *bio)
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
2.33.0

