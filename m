Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADBEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 03:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C891265237
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 03:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCIDjX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 22:39:23 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59714 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhCIDjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2021 22:39:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UR.n5AG_1615261154;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UR.n5AG_1615261154)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 11:39:21 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     oliver@neukum.org
Cc:     aliakc@web.de, lenehan@twibble.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: dc395x: Use bitwise instead of arithmetic operator for flags
Date:   Tue,  9 Mar 2021 11:39:13 +0800
Message-Id: <1615261153-32647-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/scsi/dc395x.c:2921:28-29: WARNING: sum of probable bitmasks,
consider |.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 3ea345c1..91362e6 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -2918,7 +2918,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 	} else {
 		if ((srb->state & (SRB_START_ + SRB_MSGOUT))
 		    || !(srb->
-			 state & (SRB_DISCONNECT + SRB_COMPLETED))) {
+			 state & (SRB_DISCONNECT | SRB_COMPLETED))) {
 			/*
 			 * Selection time out 
 			 * SRB_START_ || SRB_MSGOUT || (!SRB_DISCONNECT && !SRB_COMPLETED)
-- 
1.8.3.1

