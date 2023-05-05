Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AE3C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 14:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbjEEOOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 10:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjEEOOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 10:14:35 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD73718171;
        Fri,  5 May 2023 07:14:27 -0700 (PDT)
Received: from dd-virtual-machine.localdomain ([183.202.113.128])
        (user=u202114568@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 345EDGT4019430-345EDGT5019430
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 5 May 2023 22:13:19 +0800
From:   Yuchen Yang <u202114568@hust.edu.cn>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Yuchen Yang <u202114568@hust.edu.cn>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: scsi: 3w-xxxx: Add error handling for initialization failure in `tw_probe`
Date:   Fri,  5 May 2023 22:12:55 +0800
Message-Id: <20230505141259.7730-1-u202114568@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: u202114568@hust.edu.cn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch complains that:
tw_probe() warn: missing error code 'retval'

This patch adds error checking to `tw_probe` function to handle 
initialization failure. If `tw_reset_sequence` function returns a 
non-zero value, the function will return an `-EINVAL` error code 
to indicate the initialization failure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yuchen Yang <u202114568@hust.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org> 
---
The issue is found by static analyzer. The patched code has passed
Smatch checker, but remains untested on real device.
---
 drivers/scsi/3w-xxxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 36c34ced0cc1..641b8a2bbbd5 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2305,8 +2305,10 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (tw_reset_sequence(tw_dev))
+	if (tw_reset_sequence(tw_dev)) {
+		retval = -EINVAL;
 		goto out_release_mem_region;
+	}
 
 	/* Set host specific parameters */
 	host->max_id = TW_MAX_UNITS;
-- 
2.25.1

