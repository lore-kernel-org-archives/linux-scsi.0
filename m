From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/5] isci: SATA/STP I/O is only returned in the normal path to
 libsas
Date: Wed, 28 Sep 2011 18:47:46 -0700
Message-ID: <20110929014746.23617.33826.stgit@localhost6.localdomain6>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1I2Brr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:47:47 -0400
In-Reply-To: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Since libsas has it's own means to escalate SATA/STP device error
handling depending on task status codes, return all SATA/STP I/O
on the normal path.

i.e. skip sas_task_abort() and let sas_ata_task_done() disposition the
qc.  Longer term we want to audit non-essential calls to
sas_task_abort().

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index 4a7fa90..15b18d1 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -286,6 +286,25 @@ isci_task_set_completion_status(
 	task->task_status.resp = response;
 	task->task_status.stat = status;
 
+	switch (task->task_proto) {
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+
+		if (task_notification_selection
+		    == isci_perform_error_io_completion) {
+			/* SATA/STP I/O has it's own means of scheduling device
+			* error handling on the normal path.
+			*/
+			task_notification_selection
+				= isci_perform_normal_io_completion;
+		}
+		break;
+	default:
+		break;
+	}
+
 	switch (task_notification_selection) {
 
 	case isci_perform_error_io_completion:

