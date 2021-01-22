Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BCBC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A324C23381
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhAVIcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:32:42 -0500
Received: from comms.puri.sm ([159.203.221.185]:55718 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbhAVIb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 03:31:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id A161BE0493;
        Fri, 22 Jan 2021 00:30:39 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aWWOJ88zosmC; Fri, 22 Jan 2021 00:30:39 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     dgilbert@interlog.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH] scsi: sd: print write through due to no caching mode page as warning
Date:   Fri, 22 Jan 2021 09:30:00 +0100
Message-Id: <20210122083000.32598-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SD cardreaders it's extremely common not to find cache on disk.
The following error messages are thus very common and don't point
to a real error one could try to fix but rather describe how the disk
works:

sd 0:0:0:0: [sda] No Caching mode page found
sd 0:0:0:0: [sda] Assuming drive cache: write through

Print these messages as warnings instead of errors.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/sd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e7c52d6df4dc..db0171c81c5b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2808,7 +2808,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_WARNING, sdkp,
+				"No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2863,7 +2864,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_first_printk(KERN_ERR, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
-- 
2.20.1

