Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A14C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 04:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbiBIEHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 23:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346363AbiBID0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 22:26:16 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CC8C061576;
        Tue,  8 Feb 2022 19:26:15 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644377174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sbQcEhH/CPDuLNqbvluz1NLTZubPsF28DulkteTgQ3g=;
        b=m6UhLUtsi6j4grN0hoHwGZ6RJTBzyq5F0J2uRUbOhflEXosCmXvMZZRrFZNIUXrMMJWoVn
        jx9q+abuwzk85dzMXzAHUoll5UZkmerqGqjKD5ZgRa7LpBk/CBwcdVfh2VmE/QHilXASn3
        LZkuNxrewuE/r/4BU+Y/GZfaSmLvJu0=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bnx2i: Make use of the helper macro LIST_HEAD()
Date:   Wed,  9 Feb 2022 11:25:46 +0800
Message-Id: <20220209032547.38075-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace "struct list_head head = LIST_HEAD_INIT(head)" with
"LIST_HEAD(head)" to simplify the code.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/scsi/bnx2i/bnx2i_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 2b3f0c10478e..40561fc2823d 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -16,7 +16,7 @@
 
 #include "bnx2i.h"
 
-static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
+static LIST_HEAD(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-- 
2.25.1

