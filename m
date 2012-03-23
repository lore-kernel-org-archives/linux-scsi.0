From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 26/37] isci: Directly control
 IREQ_ABORT_PATH_ACTIVE when completing TMFs.
Date: Thu, 22 Mar 2012 17:30:13 -0700
Message-ID: <20120323003008.18065.50447.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:50 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

TMF requests, unlike normal I/O requests, need to handle I/O management
conditions in the completion function because TMFs are not handled in the
completion tasklet.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index e798c6a..084f8f7 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -719,6 +719,9 @@ isci_task_request_complete(struct isci_host *ihost,
 	 */
 	set_bit(IREQ_TERMINATED, &ireq->flags);
 
+	if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
+		wake_up_all(&ihost->eventq);
+
 	if (!test_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags))
 		isci_free_tag(ihost, ireq->io_tag);
 

