From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/2] target: Don't allow setting WC emulation if device doesn't support
Date: Wed, 14 May 2014 15:48:06 -0700
Message-ID: <1400107687-15797-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaENWsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2014 18:48:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Just like for pSCSI, if the transport sets get_write_cache, then it is
not valid to enable write cache emulation for it. Return an error.

see https://bugzilla.redhat.com/show_bug.cgi?id=1082675

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 65001e1..d461ecb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -798,10 +798,10 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		pr_err("emulate_write_cache not supported for pSCSI\n");
 		return -EINVAL;
 	}
-	if (dev->transport->get_write_cache) {
-		pr_warn("emulate_write_cache cannot be changed when underlying"
-			" HW reports WriteCacheEnabled, ignoring request\n");
-		return 0;
+	if (flag &&
+	    dev->transport->get_write_cache) {
+		pr_err("emulate_write_cache not supported for this device\n");
+		return -EINVAL;
 	}
 
 	dev->dev_attrib.emulate_write_cache = flag;
-- 
1.9.0

