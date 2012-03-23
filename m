From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 11/37] isci: Device access in the error path
 does not depend on IDEV_GONE.
Date: Thu, 22 Mar 2012 17:28:50 -0700
Message-ID: <20120323002850.18065.78951.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25696 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWANX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:23 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 29ce881..9d8720d 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -427,7 +427,7 @@ int isci_task_lu_reset(struct domain_device *dev, u8 *lun)
 	int ret;
 
 	spin_lock_irqsave(&ihost->scic_lock, flags);
-	idev = isci_lookup_device(dev);
+	idev = isci_get_device(dev->lldd_dev);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
 	dev_dbg(&ihost->pdev->dev,
@@ -507,7 +507,7 @@ int isci_task_abort_task(struct sas_task *task)
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
 	    old_request)
-		idev = isci_lookup_device(task->dev);
+		idev = isci_get_device(task->dev->lldd_dev);
 
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
@@ -593,6 +593,9 @@ int isci_task_abort_task(struct sas_task *task)
 					    ISCI_ABORT_TASK_TIMEOUT_MS);
 	}
 out:
+	dev_warn(&ihost->pdev->dev,
+		 "%s: Done; dev = %p, task = %p , old_request == %p\n",
+		 __func__, idev, task, old_request);
 	isci_put_device(idev);
 	return ret;
 }

