From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 16/37] isci: Fix the terminated I/O to not call
 sas_task_abort().
Date: Thu, 22 Mar 2012 17:29:15 -0700
Message-ID: <20120323002915.18065.42155.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28581 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWANt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:49 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

This addresses a regression from the commit "isci: Redesign
device suspension, abort, cleanup." in which the sas_task end
condition for terminated I/Os was made to call back on
sas_task_abort()".
This commit will be rolled into the original.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index d240f6d..78ca516 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2832,7 +2832,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 			__func__, request, task);
 
 		/* The request was terminated explicitly. */
-		clear_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
+		set_bit(IREQ_COMPLETE_IN_TARGET, &request->flags);
 		response = SAS_TASK_UNDELIVERED;
 
 		/* See if the device has been/is being stopped. Note

