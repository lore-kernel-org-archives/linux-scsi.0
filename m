From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 08/37] isci: Escalate to I_T_Nexus_Reset when
 the device is gone.
Date: Thu, 22 Mar 2012 17:28:34 -0700
Message-ID: <20120323002834.18065.18839.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62505 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab2CWANG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:06 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

If LUN reset sees that the device is gone, it returns TMF_RESP_FUNC_FAILED
to cause libsas to escalate to an I_T_Nexus_Reset.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 9b8632f..26de06e 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -842,10 +842,10 @@ int isci_task_lu_reset(struct domain_device *dev, u8 *lun)
 		__func__, dev, ihost, isci_device);
 
 	if (!isci_device) {
-		/* If the device is gone, stop the escalations. */
+		/* If the device is gone, escalate to I_T_Nexus_Reset. */
 		dev_dbg(&ihost->pdev->dev, "%s: No dev\n", __func__);
 
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = TMF_RESP_FUNC_FAILED;
 		goto out;
 	}
 	if (isci_remote_device_suspend(ihost, isci_device) != SCI_SUCCESS) {

