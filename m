Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70907C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A86B60F94
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhJMHxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 03:53:40 -0400
Received: from comms.puri.sm ([159.203.221.185]:47924 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238733AbhJMHxh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 03:53:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 1A652DFAC1;
        Wed, 13 Oct 2021 00:51:04 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id evIA57ZQRvWE; Wed, 13 Oct 2021 00:51:03 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     martin.kepplinger@puri.sm
Cc:     bvanassche@acm.org, dgilbert@interlog.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
Subject: [PATCH] scsi: sd: print write through due to no caching mode page as warning
Date:   Wed, 13 Oct 2021 09:50:50 +0200
Message-Id: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
MIME-Version: 1.0
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

hi Bart and all who it may concern,

I only resending the same patch I sent in January before:
https://lore.kernel.org/linux-scsi/20210122083000.32598-1-martin.kepplinger@puri.sm/

I like it more when messages printed as errors point to real problems that
need fixing.

thanks,
                         martin




 drivers/scsi/sd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a646d27df681..33ea36b41136 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2793,7 +2793,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_WARNING, sdkp,
+				"No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2848,7 +2849,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_first_printk(KERN_ERR, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
-- 
2.30.2

