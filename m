Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6DFC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864CD2072E
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgFWLK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:10:27 -0400
Received: from comms.puri.sm ([159.203.221.185]:55998 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732332AbgFWLK1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 07:10:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 02D7FDF849;
        Tue, 23 Jun 2020 04:10:27 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RS5o28ebxMJH; Tue, 23 Jun 2020 04:10:26 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm, Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH] scsi: sd: add runtime pm to open / release
Date:   Tue, 23 Jun 2020 13:10:18 +0200
Message-Id: <20200623111018.31954-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This add a very conservative but simple implementation for runtime PM
to the sd scsi driver:
Resume when opened (mounted) and suspend when released (unmounted).

Improvements that allow suspending while a device is "open" can
be added later, but now we save power when no filesystem is mounted
and runtime PM is enabled.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/sd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..fe4cb7c50ec1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1372,6 +1372,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
 	sdev = sdkp->device;
+	scsi_autopm_get_device(sdev);
 
 	/*
 	 * If the device is in error recovery, wait until it is done.
@@ -1418,6 +1419,9 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 error_out:
 	scsi_disk_put(sdkp);
+
+	scsi_autopm_put_device(sdev);
+
 	return retval;	
 }
 
@@ -1441,6 +1445,8 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
+	scsi_autopm_put_device(sdev);
+
 	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
-- 
2.20.1

