Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9C5C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 10:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1D522CF8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 10:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfICKS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 06:18:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:42760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727005AbfICKSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 06:18:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6948DADDD;
        Tue,  3 Sep 2019 10:18:54 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] Revert "gpss: core: no waiters left behind on deregister"
Date:   Tue,  3 Sep 2019 12:18:40 +0200
Message-Id: <20190903101840.16483-2-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903101840.16483-1-oneukum@suse.com>
References: <20190903101840.16483-1-oneukum@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit f95aec18e46af9d7fb6f312020824d536dd720dd.
---
 drivers/gnss/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gnss/core.c b/drivers/gnss/core.c
index 0d13bd2cefd5..e6f94501cb28 100644
--- a/drivers/gnss/core.c
+++ b/drivers/gnss/core.c
@@ -303,7 +303,7 @@ void gnss_deregister_device(struct gnss_device *gdev)
 	down_write(&gdev->rwsem);
 	gdev->disconnected = true;
 	if (gdev->count) {
-		wake_up_interruptible_all(&gdev->read_queue);
+		wake_up_interruptible(&gdev->read_queue);
 		gdev->ops->close(gdev);
 	}
 	up_write(&gdev->rwsem);
-- 
2.16.4

