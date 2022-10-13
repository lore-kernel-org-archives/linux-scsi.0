Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E632C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 02:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiJMCe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 22:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJMCe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 22:34:56 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1159512D3D;
        Wed, 12 Oct 2022 19:34:54 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 3CE731E80D9B;
        Thu, 13 Oct 2022 10:34:58 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2dK9rmU6JIsu; Thu, 13 Oct 2022 10:34:55 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 720C01E80D99;
        Thu, 13 Oct 2022 10:34:55 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH 4.19] scsi: sd: Fix 'sdkp' in sd_first_printk
Date:   Thu, 13 Oct 2022 10:34:38 +0800
Message-Id: <20221013023438.3263-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the sd_first_printk macro, replace the sdkp parameter with the
defined sdsk parameter to resolve the compilation error.

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/scsi/sd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index a7d4f50b67d4..e5bdf0a10071 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -133,7 +133,7 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 
 #define sd_first_printk(prefix, sdsk, fmt, a...)			\
 	do {								\
-		if ((sdkp)->first_scan)					\
+		if ((sdsk)->first_scan)					\
 			sd_printk(prefix, sdsk, fmt, ##a);		\
 	} while (0)
 
-- 
2.18.2

