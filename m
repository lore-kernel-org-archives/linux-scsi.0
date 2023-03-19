Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6CAC7618A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 04:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjCSE2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 00:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjCSE2H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 00:28:07 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02C24A5C2;
        Sat, 18 Mar 2023 21:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9FbnT
        AjA5B6RRdoMYtIDm7Imv8oR58PlaeRgwtUFegM=; b=JWjVLMIqacWdTTh6b33MF
        zPc84cV4fstNStSSwRuNN37hXJZ7/oND0eWg2eeLcCTkJxk2W5D8UGF79wyzsphm
        DjgZ9jP2pcfy5OvQpUcURw1tGPB/MRO/d7ac3cQu6lEZWt2jSHrGJbm5z1Ug0mAp
        EAlG5DyD4tfauKLW2fviH4=
Received: from lizhe.. (unknown [120.245.132.192])
        by zwqz-smtp-mta-g4-2 (Coremail) with SMTP id _____wAntjI1jxZky9HpAQ--.60522S4;
        Sun, 19 Mar 2023 12:27:55 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lizhe <sensor1010@163.com>
Subject: [PATCH v1] scsi: scsi_debug: Remove redundant driver match function
Date:   Sun, 19 Mar 2023 12:27:32 +0800
Message-Id: <20230319042732.278691-1-sensor1010@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wAntjI1jxZky9HpAQ--.60522S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr4UGr4UCFWUGF43Aw1UJrb_yoWDZrXE93
        yavFn7Wr1fKF18t3Z3Gr47ZFZF9ayUJFWv9F4Fq3savw1xXryvv3yDZrnrXw45X3ykJa9r
        uw1DZr40v3yUXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRNtC7UUUUUU==
X-Originating-IP: [120.245.132.192]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/1tbiSAQ3q1+FhPx5fwABs1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If there is no driver match function, the driver core assumes that each
candidate pair (driver, device) matches, see driver_match_device()

Drop the pseudo_lld bus's match function that always returned 1 and so
implements the same behaviour as when there is no match function.

Signed-off-by: Lizhe <sensor1010@163.com>
---
 drivers/scsi/scsi_debug.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8553277effb3..fa6f150b7364 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7950,15 +7950,8 @@ static void sdebug_driver_remove(struct device *dev)
 	scsi_host_put(sdbg_host->shost);
 }
 
-static int pseudo_lld_bus_match(struct device *dev,
-				struct device_driver *dev_driver)
-{
-	return 1;
-}
-
 static struct bus_type pseudo_lld_bus = {
 	.name = "pseudo",
-	.match = pseudo_lld_bus_match,
 	.probe = sdebug_driver_probe,
 	.remove = sdebug_driver_remove,
 	.drv_groups = sdebug_drv_groups,
-- 
2.34.1

