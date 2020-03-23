Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79F1C3F2CD
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5A22206C3
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgCWQy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:54:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:50526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgCWQy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 12:54:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DEEBAF68;
        Mon, 23 Mar 2020 16:54:24 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, David Disseldorp <ddiss@suse.de>
Subject: [RFC PATCH 1/5] scsi: target: use #def for xcopy descriptor len
Date:   Mon, 23 Mar 2020 17:54:06 +0100
Message-Id: <20200323165410.24423-2-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
References: <20200323165410.24423-1-ddiss@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 425c1070de08..7e5b13da0c20 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -134,7 +134,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 * Assigned designator
 	 */
 	desig_len = desc[7];
-	if (desig_len != 16) {
+	if (desig_len != XCOPY_NAA_IEEE_REGEX_LEN) {
 		pr_err("XCOPY 0xe4: invalid desig_len: %d\n", (int)desig_len);
 		return -EINVAL;
 	}
-- 
2.16.4

