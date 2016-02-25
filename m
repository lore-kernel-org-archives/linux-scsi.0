From: Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v2 2/3] PM / sleep: try to runtime suspend for direct complete
Date: Wed, 24 Feb 2016 16:22:27 -0800
Message-ID: <1456359748-22838-2-git-send-email-dbasehore@chromium.org>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35962 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799AbcBYAWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2016 19:22:33 -0500
Received: by mail-pa0-f48.google.com with SMTP id yy13so21502896pab.3
        for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2016 16:22:33 -0800 (PST)
In-Reply-To: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pm@vger.kernel.org
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>

This tries to runtime suspend devices that are still active for direct
complete. This is for cases such as autosuspend delays which leaves
devices able to runtime suspend but still active. It's beneficial in
this case to runtime suspend the device to take advantage of direct
complete when possible.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
---
 drivers/base/power/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e0017d9..9693032 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1380,7 +1380,12 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 		goto Complete;
 
 	if (dev->power.direct_complete) {
-		if (pm_runtime_status_suspended(dev)) {
+		/*
+		 * Check if we're runtime suspended. If not, try to runtime
+		 * suspend for autosuspend cases.
+		 */
+		if (pm_runtime_status_suspended(dev) ||
+		    !pm_runtime_suspend(dev)) {
 			pm_runtime_disable(dev);
 			if (pm_runtime_status_suspended(dev))
 				goto Complete;
-- 
2.7.0.rc3.207.g0ac5344

