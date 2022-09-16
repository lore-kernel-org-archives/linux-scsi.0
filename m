Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0ADC54EE9
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 09:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiIPJE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiIPJEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 05:04:51 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5571317E2B;
        Fri, 16 Sep 2022 02:04:43 -0700 (PDT)
X-UUID: c7fad526ab334a69bcc43fa2b2b7863a-20220916
X-CPASD-INFO: 667a6e91ea5b4c42b2c2d700126f9ce8@f4ZxgWOXZ2GRgXeug6Z_bIJjk2KUY1B
        _c2xWlmeTkViVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3hXhxgWaTaQ==
X-CLOUD-ID: 667a6e91ea5b4c42b2c2d700126f9ce8
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:197.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:94.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5.
        0,SPF:4.0,EDMS:-5,IPLABEL:4992.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-5
        ,AUF:2,DUF:4980,ACD:82,DCD:82,SL:0,EISP:0,AG:0,CFC:0.452,CFSR:0.069,UAT:0,RAF
        :0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EA
        F:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: c7fad526ab334a69bcc43fa2b2b7863a-20220916
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: c7fad526ab334a69bcc43fa2b2b7863a-20220916
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(210.12.40.82)] by mailgw
        (envelope-from <lienze@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 667135051; Fri, 16 Sep 2022 17:05:14 +0800
From:   Enze Li <lienze@kylinos.cn>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     lienze@kylinos.cn, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sr: simplify the sr_open function
Date:   Fri, 16 Sep 2022 17:04:25 +0800
Message-Id: <20220916090425.604738-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.37.3
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
index a278b739d0c5..ad1704e21609 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -587,20 +587,15 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
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
2.37.3

