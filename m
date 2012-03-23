From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 34/37] isci: Manage the IREQ_NO_AUTO_FREE_TAG
 under scic_lock.
Date: Thu, 22 Mar 2012 17:30:59 -0700
Message-ID: <20120323003059.18065.87507.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:15:32 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Since there is a possibilty of a timeout waiting for the RNC suspension,
handle the exit case from the task termination under scic_lock, and leave
the tag allocated if the termination timed-out.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 48765aa..a3a6487 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -243,8 +243,11 @@ enum sci_status isci_remote_device_terminate_requests(
 					 idev->rnc.destination_state,
 					 ireq, ireq->flags);
 			}
+			spin_lock_irqsave(&ihost->scic_lock, flags);
 			clear_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags);
-			isci_free_tag(ihost, ireq->io_tag);
+			if (!test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
+				isci_free_tag(ihost, ireq->io_tag);
+			spin_unlock_irqrestore(&ihost->scic_lock, flags);
 		} else {
 			/* Terminate all TCs. */
 			sci_remote_device_terminate_requests(idev);

