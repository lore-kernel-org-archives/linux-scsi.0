Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C441C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B7364F4D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCQPvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:51:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37231 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232713AbhCQPut (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 11:50:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 65D2F204195;
        Wed, 17 Mar 2021 16:28:07 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IVrw3aXaYwLo; Wed, 17 Mar 2021 16:28:05 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 8C8D220426F;
        Wed, 17 Mar 2021 16:28:04 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH v2 2/6] sg: sg_remove_sfp_usercontext: remove NULL check
Date:   Wed, 17 Mar 2021 11:27:54 -0400
Message-Id: <20210317152758.51689-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317152758.51689-1-dgilbert@interlog.com>
References: <20210317152758.51689-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The NULL check on sdp is useless as it has already been
de-referenced. sg_fd object without valid parent pointer
(sdp) should never occur.

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7d4a0fd9ee32..77fec70b7c2f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3918,10 +3918,8 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	       o_count, sfp);
 	kfree(sfp);
 
-	if (sdp) {
-		scsi_device_put(sdp->device);
-		kref_put(&sdp->d_ref, sg_device_destroy);
-	}
+	scsi_device_put(sdp->device);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
 
-- 
2.25.1

