From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 13/14] isci: remove bus and reset handlers
Date: Thu, 05 Jan 2012 17:00:07 -0800
Message-ID: <20120106010007.11464.42991.stgit@localhost6.localdomain6>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25275 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030273Ab2AFBAH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2012 20:00:07 -0500
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-ide@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

Remove ->eh_device_reset_handler() and ->eh_bus_reset_handler() for the
same reason they are not implemented for libata hosts, they cannot be
implemented reliably with ata-eh.  ATA error recovery wants to divert
all resets to the eh thread and wait for completion, these handlers may
be invoked from a non-blocking ioctl.

The other path they are called from is libsas-eh, and if we escalate
past I_T_nexus reset we have larger problems i.e. tear down all
in-flight commands in the domain potentially without notification to the
lldd if it has chosen not to implement ->lldd_clear_nexus_port() /
->lldd_clear_nexus_ha().

Cc: Jack Wang <jack_wang@usish.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |    2 --
 drivers/scsi/isci/task.c |   23 -----------------------
 drivers/scsi/isci/task.h |    2 --
 3 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 40293b3..437f76b 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -157,8 +157,6 @@ static struct scsi_host_template isci_sht = {
 	.sg_tablesize			= SG_ALL,
 	.max_sectors			= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering			= ENABLE_CLUSTERING,
-	.eh_device_reset_handler	= sas_eh_device_reset_handler,
-	.eh_bus_reset_handler		= isci_bus_reset_handler,
 	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 48df8e5..edaba78 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1322,26 +1322,3 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 	isci_put_device(idev);
 	return ret;
 }
-
-int isci_bus_reset_handler(struct scsi_cmnd *cmd)
-{
-	struct domain_device *dev = sdev_to_domain_dev(cmd->device);
-	struct isci_host *ihost = dev_to_ihost(dev);
-	struct isci_remote_device *idev;
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&ihost->scic_lock, flags);
-	idev = isci_lookup_device(dev);
-	spin_unlock_irqrestore(&ihost->scic_lock, flags);
-
-	if (!idev) {
-		ret = TMF_RESP_FUNC_COMPLETE;
-		goto out;
-	}
-
-	ret = isci_reset_device(ihost, dev, idev);
- out:
-	isci_put_device(idev);
-	return ret;
-}
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 8ffcdc9..7bc6fd6 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -209,8 +209,6 @@ int isci_queuecommand(
 	struct scsi_cmnd *scsi_cmd,
 	void (*donefunc)(struct scsi_cmnd *));
 
-int isci_bus_reset_handler(struct scsi_cmnd *cmd);
-
 /**
  * enum isci_completion_selection - This enum defines the possible actions to
  *    take with respect to a given request's notification back to libsas.

