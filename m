From: Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v2 3/3] scsi: allow scsi devices to use direct complete
Date: Wed, 24 Feb 2016 16:22:28 -0800
Message-ID: <1456359748-22838-3-git-send-email-dbasehore@chromium.org>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-pm@vger.kernel.org
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>
List-Id: linux-scsi@vger.kernel.org

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
