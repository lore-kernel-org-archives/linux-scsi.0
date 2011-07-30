From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6/9] isci: Leave requests alone if already terminating.
Date: Fri, 29 Jul 2011 17:17:05 -0700
Message-ID: <20110730001705.28430.88797.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3ARG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:17:06 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>, linux-scsi@vger.kernel.org

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Instead of immediately completing any request that has a second
termination call made on it, wait for the TC done/abort HW event.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index b4cf998..b5d3a8c 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -732,12 +732,20 @@ sci_io_request_terminate(struct isci_request *ireq)
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		return SCI_SUCCESS;
 	case SCI_REQ_TASK_WAIT_TC_RESP:
+		/* The task frame was already confirmed to have been
+		 * sent by the SCU HW.  Since the state machine is
+		 * now only waiting for the task response itself,
+		 * abort the request and complete it immediately
+		 * and don't wait for the task response.
+		 */
 		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
 		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
 		return SCI_SUCCESS;
 	case SCI_REQ_ABORTING:
-		sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
-		return SCI_SUCCESS;
+		/* If a request has a termination requested twice, return
+		 * a failure indication, since HW confirmation of the first
+		 * abort is still outstanding.
+		 */
 	case SCI_REQ_COMPLETED:
 	default:
 		dev_warn(&ireq->owning_controller->pdev->dev,

