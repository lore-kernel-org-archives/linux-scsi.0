From: yangsheng <sickamd@gmail.com>
Subject: [PATCH] Set error value while device_add() failed.
Date: Fri, 14 Jan 2011 02:48:43 +0800
Message-ID: <1294944523-6546-1-git-send-email-sickamd@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43630 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1AMStE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2011 13:49:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, yangsheng <sickamd@gmail.com>

Signed-off-by: yangsheng <sickamd@gmail.com>
---
 drivers/scsi/sd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d21dd17..2ca5250 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2474,7 +2474,8 @@ static int sd_probe(struct device *dev)
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, dev_name(dev));
 
-	if (device_add(&sdkp->dev))
+	error = device_add(&sdkp->dev);
+	if (error)
 		goto out_free_index;
 
 	get_device(dev);
-- 
1.7.2.3

