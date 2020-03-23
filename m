Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51327C54FCE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2471E20714
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCWQy1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:54:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgCWQy1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 12:54:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70E66B17A;
        Mon, 23 Mar 2020 16:54:25 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, David Disseldorp <ddiss@suse.de>
Subject: [RFC PATCH 2/5] scsi: target: drop xcopy DISK BLOCK LENGTH debug
Date:   Mon, 23 Mar 2020 17:54:07 +0100
Message-Id: <20200323165410.24423-3-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
References: <20200323165410.24423-1-ddiss@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The DISK BLOCK LENGTH field is carried with XCOPY target descriptors on
the wire, but is currently unmarshalled during 0x02 segment descriptor
passing. The unmarshalled value is currently unused, so drop it.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.c | 5 -----
 drivers/target/target_core_xcopy.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 7e5b13da0c20..66b68295c50f 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -315,11 +315,6 @@ static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op
 		xop->nolb, (unsigned long long)xop->src_lba,
 		(unsigned long long)xop->dst_lba);
 
-	if (dc != 0) {
-		xop->dbl = get_unaligned_be24(&desc[29]);
-
-		pr_debug("XCOPY seg desc 0x02: DC=1 w/ dbl: %u\n", xop->dbl);
-	}
 	return 0;
 }
 
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 26ba4c3c9cff..0840b03e8faa 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -35,7 +35,6 @@ struct xcopy_op {
 	unsigned short stdi;
 	unsigned short dtdi;
 	unsigned short nolb;
-	unsigned int dbl;
 
 	struct xcopy_pt_cmd *src_pt_cmd;
 	struct xcopy_pt_cmd *dst_pt_cmd;
-- 
2.16.4

