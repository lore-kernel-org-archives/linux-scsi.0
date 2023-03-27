Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BFCC74A5B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 03:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjC0DAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Mar 2023 23:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjC0C7x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Mar 2023 22:59:53 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509804ED3
        for <linux-scsi@vger.kernel.org>; Sun, 26 Mar 2023 19:59:49 -0700 (PDT)
X-UUID: c4daff19a1b049f888d20da393b82179-20230327
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:2d3f173c-38f1-4eae-a86c-ea9bbfb17fda,IP:-32
        768,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:-32768,SF:-32768,FIL
        E:-32768,BULK:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-INFO: VERSION:1.1.20,REQID:2d3f173c-38f1-4eae-a86c-ea9bbfb17fda,IP:-3276
        8,URL:-32768,TC:-32768,Content:-32768,EDM:-32768,RT:-32768,SF:-32768,FILE:
        -32768,BULK:-32768,RULE:Release_Ham,ACTION:release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:nil,BulkID:nil,BulkQuantity:0,Recheck:
        0,SF:nil,TC:nil,Content:nil,EDM:nil,IP:nil,URL:nil,File:nil,Bulk:nil,QS:ni
        l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: c4daff19a1b049f888d20da393b82179-20230327
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(210.12.40.82)] by mailgw
        (envelope-from <lienze@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1133451332; Mon, 27 Mar 2023 10:59:16 +0800
From:   Enze Li <lienze@kylinos.cn>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, lienze@kylinos.cn, enze.li@gmx.com
Subject: [PATCH] scsi: sr: simplify the sr_open function
Date:   Mon, 27 Mar 2023 11:02:37 +0800
Message-Id: <20230327030237.3407253-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the sr_open function by removing the goto label as it does only
return one error code.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 drivers/scsi/sr.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9e51dcd30bfd..12869e6d4ebd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -590,20 +590,15 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
 {
 	struct scsi_cd *cd = cdi->handle;
 	struct scsi_device *sdev = cd->device;
-	int retval;
 
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
 	 */
-	retval = -ENXIO;
 	if (!scsi_block_when_processing_errors(sdev))
-		goto error_out;
+		return -ENXIO;
 
 	return 0;
-
-error_out:
-	return retval;	
 }
 
 static void sr_release(struct cdrom_device_info *cdi)
-- 
2.39.2

