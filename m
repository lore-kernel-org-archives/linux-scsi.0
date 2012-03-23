From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 02/37] isci: Fixed bug in resumption from RNC
 Tx/Rx suspend state.
Date: Thu, 22 Mar 2012 17:27:59 -0700
Message-ID: <20120323002759.18065.25535.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12366 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab2CWAMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:12:31 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

The resumption from the Tx/Rx suspended state should work the same
as the Tx suspended state.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_node_context.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 3a55ba6..3e84975 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -557,10 +557,16 @@ enum sci_status sci_remote_node_context_resume(struct sci_remote_node_context *s
 		sci_rnc->user_callback = cb_fn;
 		sci_rnc->user_cookie   = cb_p;
 		return SCI_SUCCESS;
-	case SCI_RNC_TX_SUSPENDED: {
+	case SCI_RNC_TX_SUSPENDED:
+	case SCI_RNC_TX_RX_SUSPENDED: {
 		struct isci_remote_device *idev = rnc_to_dev(sci_rnc);
 		struct domain_device *dev = idev->domain_dev;
 
+		/* If this is an expander attached SATA device we must
+		 * invalidate and repost the RNC since this is the only way
+		 * to clear the TCi to NCQ tag mapping table for the RNi.
+		 * All other device types we can just resume.
+		 */
 		sci_remote_node_context_setup_to_resume(sci_rnc, cb_fn, cb_p);
 
 		if (dev_is_sata(dev) && dev->parent)
@@ -569,10 +575,6 @@ enum sci_status sci_remote_node_context_resume(struct sci_remote_node_context *s
 			sci_change_state(&sci_rnc->sm, SCI_RNC_RESUMING);
 		return SCI_SUCCESS;
 	}
-	case SCI_RNC_TX_RX_SUSPENDED:
-		sci_remote_node_context_setup_to_resume(sci_rnc, cb_fn, cb_p);
-		sci_change_state(&sci_rnc->sm, SCI_RNC_RESUMING);
-		return SCI_FAILURE_INVALID_STATE;
 	case SCI_RNC_AWAIT_SUSPENSION:
 		sci_remote_node_context_setup_to_resume(sci_rnc, cb_fn, cb_p);
 		return SCI_SUCCESS;

