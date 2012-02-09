From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 08/29] qla2xxx: Return blank sysfs string on initial get thermal failure.
Date: Thu, 9 Feb 2012 11:15:40 -0800
Message-ID: <1328814961-21866-9-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:38658
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758398Ab2BITcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:09 -0500
Received: from mail25-ch1 (localhost [127.0.0.1])	by mail25-ch1-R.bigfish.com
 (Postfix) with ESMTP id B5B1C4A0178	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:08 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

When thermal temperature initially fails, return a blank string to the
sysfs interface.  This fixes the initial display of 0.00 followed by
subsequent display of blank line; the initial 0.00 should have not
displayed for cards that do not support thermal temperature.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 0635be5..5433f95 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1365,7 +1365,7 @@ qla2x00_thermal_temp_show(struct device *dev,
 	else if (!vha->hw->flags.eeh_busy)
 		rval = qla2x00_get_thermal_temp(vha, &temp, &frac);
 	if (rval != QLA_SUCCESS)
-		temp = frac = 0;
+		return snprintf(buf, PAGE_SIZE, "\n");
 
 	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", temp, frac);
 }
-- 
1.6.0.2


