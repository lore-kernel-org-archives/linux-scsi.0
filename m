Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6CFC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 23:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F8F2151B
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 23:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgE2Xkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 19:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbgE2Xka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 19:40:30 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202C8C03E969;
        Fri, 29 May 2020 16:40:30 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jeoc0-000C4r-IW; Fri, 29 May 2020 23:40:28 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] hpsa_ioctl(): tidy up a bit
Date:   Sat, 30 May 2020 00:40:28 +0100
Message-Id: <20200529234028.46373-4-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200529234028.46373-1-viro@ZenIV.linux.org.uk>
References: <20200529233923.GL23230@ZenIV.linux.org.uk>
 <20200529234028.46373-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/hpsa.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c7fbe56891ef..81d0414e2117 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6577,14 +6577,11 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
  * ioctl
  */
 static int hpsa_ioctl(struct scsi_device *dev, unsigned int cmd,
-		      void __user *arg)
+		      void __user *argp)
 {
-	struct ctlr_info *h;
-	void __user *argp = (void __user *)arg;
+	struct ctlr_info *h = sdev_to_hba(dev);
 	int rc;
 
-	h = sdev_to_hba(dev);
-
 	switch (cmd) {
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWDISK:
-- 
2.11.0

