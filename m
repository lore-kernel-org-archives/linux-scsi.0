From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 35/37] isci: Fix RNC
 AWAIT_SUSPENSION->INVALIDATING transition.
Date: Thu, 22 Mar 2012 17:31:04 -0700
Message-ID: <20120323003104.18065.34083.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:15:37 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

The RNC state machine would incorrectly transition from
SCI_RNC_AWAIT_SUSPENSION directly to SCI_RNC_INVALIDATING when a destruct
request was made.  This would skip the increment of the suspension count
and the abort of pending TCs (although the invalidating state would at
least cleanup outstanding TCs).

Instead, the RNC will transition to SCI_RNC_SUSPENDED and then start the
destruction process.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_node_context.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 920c2bb..6f0b61b 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -222,13 +222,19 @@ static void sci_remote_node_context_notify_user(
 
 static void sci_remote_node_context_continue_state_transitions(struct sci_remote_node_context *rnc)
 {
-	if ((rnc->destination_state == RNC_DEST_READY) ||
-	    (rnc->destination_state == RNC_DEST_SUSPENDED_RESUME)) {
+	switch (rnc->destination_state) {
+	case RNC_DEST_READY:
+	case RNC_DEST_SUSPENDED_RESUME:
 		rnc->destination_state = RNC_DEST_READY;
+		/* Fall through... */
+	case RNC_DEST_FINAL:
 		sci_remote_node_context_resume(rnc, rnc->user_callback,
-						    rnc->user_cookie);
-	} else
+					       rnc->user_cookie);
+		break;
+	default:
 		rnc->destination_state = RNC_DEST_UNSPECIFIED;
+		break;
+	}
 }
 
 static void sci_remote_node_context_validate_context_buffer(struct sci_remote_node_context *sci_rnc)
@@ -539,10 +545,12 @@ enum sci_status sci_remote_node_context_destruct(struct sci_remote_node_context
 	case SCI_RNC_READY:
 	case SCI_RNC_TX_SUSPENDED:
 	case SCI_RNC_TX_RX_SUSPENDED:
-	case SCI_RNC_AWAIT_SUSPENSION:
 		sci_remote_node_context_setup_to_destroy(sci_rnc, cb_fn, cb_p);
 		sci_change_state(&sci_rnc->sm, SCI_RNC_INVALIDATING);
 		return SCI_SUCCESS;
+	case SCI_RNC_AWAIT_SUSPENSION:
+		sci_remote_node_context_setup_to_destroy(sci_rnc, cb_fn, cb_p);
+		return SCI_SUCCESS;
 	case SCI_RNC_INITIAL:
 		dev_warn(scirdev_to_dev(rnc_to_dev(sci_rnc)),
 			 "%s: invalid state: %s\n", __func__,

