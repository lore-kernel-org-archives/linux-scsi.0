From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 6/6] ata: add ata port runtime PM callbacks
Date: Wed, 23 Nov 2011 15:01:26 +0800
Message-ID: <1322031686-28233-7-git-send-email-ming.m.lin@intel.com>
References: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8690 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1KWHBo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2011 02:01:44 -0500
In-Reply-To: <1322031686-28233-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

Add ata port runtime suspend/resume/idle callbacks.
Set ->eh_noresume to skip the runtime PM calls on scsi host
in the error handler to avoid dead lock.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c      |   10 ++++++++++
 drivers/ata/libata-scsi.c      |    1 +
 drivers/ata/libata-transport.c |    4 ++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 04c208e..15a3d4d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -5307,9 +5308,18 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_runtime_idle(struct device *dev)
+{
+	return pm_runtime_suspend(dev);
+}
+
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
+
+	.runtime_suspend = ata_port_suspend_common,
+	.runtime_resume = ata_port_resume,
+	.runtime_idle = ata_port_runtime_idle,
 };
 
 /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7ae1e77..508a60b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3381,6 +3381,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		if (!shost)
 			goto err_alloc;
 
+		shost->eh_noresume = 1;
 		*(struct ata_port **)&shost->hostdata[0] = ap;
 		ap->scsi_host = shost;
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 3ceb3d9..9a7f0ea 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -32,6 +32,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -290,6 +291,9 @@ int ata_tport_add(struct device *parent,
 		goto tport_err;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	transport_add_device(dev);
 	transport_configure_device(dev);
 
-- 
1.7.2.5

