From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 4/6] [SCSI] sd: check runtime status in sd_shutdown
Date: Wed, 23 Nov 2011 15:01:24 +0800
Message-ID: <1322031686-28233-5-git-send-email-ming.m.lin@intel.com>
References: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1KWHBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2011 02:01:40 -0500
In-Reply-To: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

sd_shutdown is called during reboot/poweroff.
It may fail if parent device, for example, ata port, was runtime suspended.

Fix it by checking runtime status of sd.
Exit immediately if sd was runtime suspended already.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..7b3f807 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -2741,6 +2742,9 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
+	if (pm_runtime_suspended(dev))
+		goto exit;
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
@@ -2751,6 +2755,7 @@ static void sd_shutdown(struct device *dev)
 		sd_start_stop_device(sdkp, 0);
 	}
 
+exit:
 	scsi_disk_put(sdkp);
 }
 
-- 
1.7.2.5

