Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6611C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A752320658
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgC0OUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:20:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:55208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbgC0OUP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 10:20:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36CFEB029;
        Fri, 27 Mar 2020 14:20:14 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3 4/5] scsi: target: increase XCOPY I/O size
Date:   Fri, 27 Mar 2020 15:19:53 +0100
Message-Id: <20200327141954.955-5-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200327141954.955-1-ddiss@suse.de>
References: <20200327141954.955-1-ddiss@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The I/O size is already bound by dev_attrib.hw_max_sectors, so increase
the hardcoded XCOPY_MAX_SECTORS maximum to improve performance against
backstores with high-latency.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_xcopy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 9558974185ea..f1aaf7140798 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -5,7 +5,7 @@
 #define XCOPY_TARGET_DESC_LEN		32
 #define XCOPY_SEGMENT_DESC_LEN		28
 #define XCOPY_NAA_IEEE_REGEX_LEN	16
-#define XCOPY_MAX_SECTORS		1024
+#define XCOPY_MAX_SECTORS		4096
 
 /*
  * SPC4r37 6.4.6.1
-- 
2.16.4

