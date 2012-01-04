From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 08/15] isci: remove unused 'isci_tmf->device' field
Date: Wed, 04 Jan 2012 01:33:05 -0800
Message-ID: <20120104093305.9147.96260.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2ADJdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:05 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>

From: Maciej Trela <maciej.trela@intel.com>

As the field was never set, isci_print_tmf() using 'isci_tmf->device'
sometimes causes a kernel crash if the dev_dbg() statement is enabled.
Remove the unused field both from isci_tmf struct definition and from
isci_print_tmf()

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |    2 +-
 drivers/scsi/isci/task.h |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 66ad3dc..f5a3f7d 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -496,7 +496,7 @@ static int isci_task_execute_tmf(struct isci_host *ihost,
 		}
 	}
 
-	isci_print_tmf(tmf);
+	isci_print_tmf(ihost, tmf);
 
 	if (tmf->status == SCI_SUCCESS)
 		ret =  TMF_RESP_FUNC_COMPLETE;
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index bc78c0a..1b27b37 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -106,7 +106,6 @@ struct isci_tmf {
 	} resp;
 	unsigned char lun[8];
 	u16 io_tag;
-	struct isci_remote_device *device;
 	enum isci_tmf_function_codes tmf_code;
 	int status;
 
@@ -120,10 +119,10 @@ struct isci_tmf {
 
 };
 
-static inline void isci_print_tmf(struct isci_tmf *tmf)
+static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)
 {
 	if (SAS_PROTOCOL_SATA == tmf->proto)
-		dev_dbg(&tmf->device->isci_port->isci_host->pdev->dev,
+		dev_dbg(&ihost->pdev->dev,
 			"%s: status = %x\n"
 			"tmf->resp.d2h_fis.status = %x\n"
 			"tmf->resp.d2h_fis.error = %x\n",
@@ -132,7 +131,7 @@ static inline void isci_print_tmf(struct isci_tmf *tmf)
 			tmf->resp.d2h_fis.status,
 			tmf->resp.d2h_fis.error);
 	else
-		dev_dbg(&tmf->device->isci_port->isci_host->pdev->dev,
+		dev_dbg(&ihost->pdev->dev,
 			"%s: status = %x\n"
 			"tmf->resp.resp_iu.data_present = %x\n"
 			"tmf->resp.resp_iu.status = %x\n"

