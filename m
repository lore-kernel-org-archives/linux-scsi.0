From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 9/9] libata: do not suspend port if normal ODD is attached
Date: Sun,  6 Jan 2013 10:48:29 +0800
Message-ID: <1357440509-28108-10-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

For ODDs, the upper layer will poll for media change every a few
seconds, which will make it enter and leave suspend state very
oftern. And as each suspend will also cause a hard/soft reset,
the gain of runtime suspend is very little while the ODD may
mis-function after constantly being reset. So the idle callback
here will not proceed to suspend if a non-ZPODD capable ODD is
attached to the port.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 65a362e..f664a90 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5408,8 +5408,27 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+/*
+ * For ODDs, the upper layer will poll for media change every a few seconds,
+ * which will make it enter and leave suspend state every a few seconds. And
+ * as each suspend will cause a hard/soft reset, the gain of runtime suspend
+ * is very little and the ODD may mis-function after constantly being reset.
+ * So the idle callback here will not proceed to suspend if a non-ZPODD capable
+ * ODD is attached to the port.
+ */
 static int ata_port_runtime_idle(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+	struct ata_link *link;
+	struct ata_device *adev;
+
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		ata_for_each_dev(adev, link, ENABLED)
+			if (adev->class == ATA_DEV_ATAPI &&
+			    !zpodd_dev_enabled(adev))
+				return -EBUSY;
+	}
+
 	return pm_runtime_suspend(dev);
 }
 
-- 
1.7.11.7

