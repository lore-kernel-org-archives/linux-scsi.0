From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 3/6] [SCSI] runtime resume device before system suspend
Date: Wed, 23 Nov 2011 15:01:23 +0800
Message-ID: <1322031686-28233-4-git-send-email-ming.m.lin@intel.com>
References: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

scsi device runtime PM is using PMSG_SUSPEND. System PM may use other state
that may not be compatiable with PMSG_SUSPEND.

So we need to runtime resume the device before system suspend.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---

Alan,

Could you add your Signed-off-by?
Free free to change the commit logs.

 drivers/scsi/scsi_pm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d329f8b..549ea72 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -49,8 +49,10 @@ static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		pm_runtime_resume(dev);
 		err = scsi_dev_type_suspend(dev, msg);
+	}
 	return err;
 }
 
-- 
1.7.2.5
