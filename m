From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v4 6/7] scsi: sr: balance sr disk events block depth
Date: Fri, 27 Jul 2012 17:00:49 +0800
Message-ID: <1343379650-2867-7-git-send-email-aaron.lu@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Sergei Shtylyov <sshtylyov@mvista.com>, Oliver Neukum <oneukum@suse.de>
Cc: Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

When the ODD is resumed, disk_unblock_events should be called when:
1 The ODD is runtime resumed;
2 System is resuming from S3 and the ODD is runtime suspended before S3;
But not when the system is resuming from S3 and the ODD is runtime
active before S3.

So seperate the resume calls, one for system resume and one for runtime
resume to do different things accordingly.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cbc14ea..f0c4aa2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -82,6 +82,11 @@ static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
 static int sr_suspend(struct device *, pm_message_t msg);
 static int sr_resume(struct device *);
+static int sr_runtime_resume(struct device *);
+
+static struct dev_pm_ops sr_pm_ops = {
+	.runtime_resume = sr_runtime_resume,
+};
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -91,6 +96,7 @@ static struct scsi_driver sr_template = {
 		.remove		= sr_remove,
 		.suspend	= sr_suspend,
 		.resume		= sr_resume,
+		.pm		= &sr_pm_ops,
 	},
 	.done			= sr_done,
 };
@@ -213,6 +219,23 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
 static int sr_resume(struct device *dev)
 {
 	struct scsi_cd *cd;
+
+	/*
+	 * If ODD is runtime suspended before system pm, unblock disk
+	 * events now since on system resume we will fully resume it
+	 * and set its runtime status to active.
+	 */
+	if (pm_runtime_suspended(dev)) {
+		cd = dev_get_drvdata(dev);
+		disk_unblock_events(cd->disk);
+	}
+
+	return 0;
+}
+
+static int sr_runtime_resume(struct device *dev)
+{
+	struct scsi_cd *cd;
 	struct scsi_sense_hdr sshdr;
 
 	cd = dev_get_drvdata(dev);
-- 
1.7.11.3


