From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 27/37] isci: Add protocol indicator for TMF
 requests.
Date: Thu, 22 Mar 2012 17:30:18 -0700
Message-ID: <20120323003018.18065.23809.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:50 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Requests contructed as task management requests need to have the protocol
indicator set so the completion decode can observe any RNC suspension
conditions.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index df713d5..5c97102 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3130,6 +3130,12 @@ enum sci_status sci_task_request_construct(struct isci_host *ihost,
 	if (dev->dev_type == SAS_END_DEV || dev_is_sata(dev)) {
 		set_bit(IREQ_TMF, &ireq->flags);
 		memset(ireq->tc, 0, sizeof(struct scu_task_context));
+
+		/* Set the protocol indicator. */
+		if (dev_is_sata(dev))
+			ireq->protocol = SAS_PROTOCOL_STP;
+		else
+			ireq->protocol = SAS_PROTOCOL_SSP;
 	} else
 		status = SCI_FAILURE_UNSUPPORTED_PROTOCOL;
 

