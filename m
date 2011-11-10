From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Thu, 10 Nov 2011 14:22:46 +0800
Message-ID: <1320906166-15459-5-git-send-email-ming.m.lin@intel.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add ata port runtime suspend/resume/idle callbacks.
Set ->eh_noresume to skip the runtime PM calls on scsi host
in the error handler to avoid dead lock.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c      |   19 +++++++++++++++++++
 drivers/ata/libata-scsi.c      |    1 +
 drivers/ata/libata-transport.c |    3 +++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b77c40c..719d23c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -5302,9 +5303,27 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_runtime_suspend(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	int rc;
+
+	rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+	return rc;
+}
+
+static int ata_port_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
+
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
+
+	.runtime_suspend = ata_port_runtime_suspend,
+	.runtime_resume = ata_port_resume,
+	.runtime_idle = ata_port_runtime_idle,
 };
 
 /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4c2a524..f7afdd5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3377,6 +3377,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		if (!shost)
 			goto err_alloc;
 
+		shost->eh_noresume = 1;
 		*(struct ata_port **)&shost->hostdata[0] = ap;
 		ap->scsi_host = shost;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index a979bd76..9a7f0ea 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -291,6 +291,9 @@ int ata_tport_add(struct device *parent,
 		goto tport_err;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
-- 
1.7.2.5

