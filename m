Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B47EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF5964FD6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCKSOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:14:47 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51124 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCKSOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:14:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3103D204259;
        Thu, 11 Mar 2021 19:14:34 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AzFt619Rxqf3; Thu, 11 Mar 2021 19:14:32 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 037C120426C;
        Thu, 11 Mar 2021 19:14:30 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        colin.king@canonical.com
Subject: [PATCH 4/4] sg: sg_common_write: remove debug remnant
Date:   Thu, 11 Mar 2021 13:14:23 -0500
Message-Id: <20210311181423.137646-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311181423.137646-1-dgilbert@interlog.com>
References: <20210311181423.137646-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The removed check was added as part of scattergun debugging to
find a problem that was fixed elsewhere. The associated SG_LOG
message has never been seen in testing.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b6e06e039d5b..9593f8eaf56c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1120,11 +1120,6 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		res = -EIDRM;	/* this failure unexpected but observed */
 		goto err_out;
 	}
-	if (xa_get_mark(&fp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
-		SG_LOG(1, fp, "%s: ahhh, request erased!!!\n", __func__);
-		res = -ENODEV;
-		goto err_out;
-	}
 	srp->rq->timeout = cwrp->timeout;
 	sg_execute_cmd(fp, srp);
 	return srp;
-- 
2.25.1

