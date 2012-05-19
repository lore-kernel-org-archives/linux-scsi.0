From: Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] [SCSI] scsi_pm: fix passing incompatible pointer for
 scsi_device_resume()
Date: Sat, 19 May 2012 18:08:23 +0800
Message-ID: <1337422103.23904.1.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2ESKId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 May 2012 06:08:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Aaron Lu <Aaron.Lu@amd.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Fix below build warning:

  CC      drivers/scsi/scsi_pm.o
drivers/scsi/scsi_pm.c: In function 'scsi_dev_type_suspend':
drivers/scsi/scsi_pm.c:30:5: warning: passing argument 1 of 'scsi_device_resume' from incompatible pointer type [enabled by default]
include/scsi/scsi_device.h:368:13: note: expected 'struct scsi_device *' but argument is of type 'struct device *'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/scsi/scsi_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9bd2c41..d4201de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -27,7 +27,7 @@ static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
 		if (drv && drv->suspend) {
 			err = drv->suspend(dev, msg);
 			if (err)
-				scsi_device_resume(dev);
+				scsi_device_resume(to_scsi_device(dev));
 		}
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
-- 
1.7.5.4



