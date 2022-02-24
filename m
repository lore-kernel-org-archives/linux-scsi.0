Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF56AC43217
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 17:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiBXR4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 12:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiBXR4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 12:56:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B36279470;
        Thu, 24 Feb 2022 09:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZJLHsJZRmOB+kmTyTps0yjW93HpIMz1963/RA3Y/yaw=; b=id6eQBUp5wgIeXRuKw2YzyhPKH
        Gqsruj8ne7EZE6rXVU0cGW6DKpwdL9Ll58xUEUR4zPy07/9KNnPQDA8CNU8nIWEMdJhnYzkTBsKVF
        6TmjXBDadgerujDS+Hznv5YAWoqLFA4Hk2Oq6pFs/cZyNPkKwszjTRTd4EM/NUmws/uaYXkzCiTaE
        SRQiMiZE38CE6nDmI02XHy8AaNuRvjp28qu6RoeHt19lEImXPWKW0ZejiB7OOmCE8SJ0PsTNihvEB
        5rAM0rDyjczY4+Qn7/fFsPyOjb3X9B1nk4iBXYypFVv2uf5tor41XGG7y95Gz6850EA7shnPQ1HSu
        jPYNsk5Q==;
Received: from 089144202139.atnat0011.highway.a1.net ([89.144.202.139] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNILk-001ub1-Gv; Thu, 24 Feb 2022 17:56:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 8/8] scsi: remove <scsi/scsi_request.h>
Date:   Thu, 24 Feb 2022 18:55:52 +0100
Message-Id: <20220224175552.988286-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224175552.988286-1-hch@lst.de>
References: <20220224175552.988286-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This header is empty now except for an include of <linux/blk-mq.h>, so
remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/cdrom/cdrom.c             | 1 -
 drivers/scsi/scsi_transport_sas.c | 1 -
 include/linux/bsg-lib.h           | 1 -
 include/scsi/scsi_cmnd.h          | 1 -
 include/scsi/scsi_request.h       | 7 -------
 5 files changed, 11 deletions(-)
 delete mode 100644 include/scsi/scsi_request.h

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 1b57d4666e43c..7bd10d63ddbe5 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -284,7 +284,6 @@
 #include <linux/times.h>
 #include <linux/uaccess.h>
 #include <scsi/scsi_common.h>
-#include <scsi/scsi_request.h>
 
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 4ee578b181da5..12bff64dade64 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -34,7 +34,6 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 6b211323a489c..9e97ced2896df 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -10,7 +10,6 @@
 #define _BLK_BSG_
 
 #include <linux/blkdev.h>
-#include <scsi/scsi_request.h>
 
 struct bsg_job;
 struct request;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 4b33ca6a7c7d6..76c5eaeeb3b54 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -10,7 +10,6 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_request.h>
 
 struct Scsi_Host;
 struct scsi_driver;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
deleted file mode 100644
index 6d424d3e8d02f..0000000000000
--- a/include/scsi/scsi_request.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _SCSI_SCSI_REQUEST_H
-#define _SCSI_SCSI_REQUEST_H
-
-#include <linux/blk-mq.h>
-
-#endif /* _SCSI_SCSI_REQUEST_H */
-- 
2.30.2

