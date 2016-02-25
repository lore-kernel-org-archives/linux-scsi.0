From: Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v1 3/3] scsi: allow scsi devices to use direct complete
Date: Wed, 24 Feb 2016 16:11:29 -0800
Message-ID: <1456359089-19807-3-git-send-email-dbasehore@chromium.org>
References: <1456359089-19807-1-git-send-email-dbasehore@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35769 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759003AbcBYALs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2016 19:11:48 -0500
Received: by mail-pf0-f179.google.com with SMTP id c10so22640457pfc.2
        for <linux-scsi@vger.kernel.org>; Wed, 24 Feb 2016 16:11:47 -0800 (PST)
In-Reply-To: <1456359089-19807-1-git-send-email-dbasehore@chromium.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pm@vger.kernel.org
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>

This allows scsi devices to remain runtime suspended for system
suspend. Since runtime suspend is stricter than system suspend
callbacks, this is just returning a positive number for the prepare
callback.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
---
 drivers/scsi/scsi_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index b44c1bb..7af76ad 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -178,7 +178,7 @@ static int scsi_bus_prepare(struct device *dev)
 		/* Wait until async scanning is finished */
 		scsi_complete_async_scans();
 	}
-	return 0;
+	return 1;
 }
 
 static int scsi_bus_suspend(struct device *dev)
-- 
2.7.0.rc3.207.g0ac5344

