From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 24/37] isci: Fix RNC suspend call for
 SCI_RESUMING state.
Date: Thu, 22 Mar 2012 17:29:58 -0700
Message-ID: <20120323002957.18065.95993.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAOa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:30 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Instead of immediately transitioning to the SCI_RNC_AWAIT_SUSPENSION
state, handle the SCI_RNC_RESUMING suspend transition from the
SCI_RNC_READY state like the SCI_RNC_INVALIDATING --> SCI_RNC_POSTING
transitions do now, by setting the destination state for the entry
into the READY state.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_node_context.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index faeae95..b698081 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -321,8 +321,6 @@ static void sci_remote_node_context_ready_state_enter(struct sci_base_state_mach
 {
 	struct sci_remote_node_context *rnc = container_of(sm, typeof(*rnc), sm);
 	enum sci_remote_node_context_destination_state dest_select;
-	scics_sds_remote_node_context_callback usr_cb = rnc->user_callback;
-	void *usr_param = rnc->user_cookie;
 	int tell_user = 1;
 
 	dest_select = rnc->destination_state;
@@ -334,12 +332,10 @@ static void sci_remote_node_context_ready_state_enter(struct sci_base_state_mach
 			rnc, rnc->suspend_reason,
 			SCI_SOFTWARE_SUSPEND_EXPECTED_EVENT);
 
-		if (dest_select == RNC_DEST_SUSPENDED_RESUME) {
-			sci_remote_node_context_resume(rnc, usr_cb, usr_param);
+		if (dest_select == RNC_DEST_SUSPENDED_RESUME)
 			tell_user = 0;  /* Wait until ready again. */
-		}
 	}
-	if (tell_user && rnc->user_callback)
+	if (tell_user)
 		sci_remote_node_context_notify_user(rnc);
 }
 
@@ -584,8 +580,6 @@ enum sci_status sci_remote_node_context_suspend(
 		dest_param = sci_rnc->destination_state;
 
 	switch (state) {
-	case SCI_RNC_RESUMING:
-		break;  /* The RNC has been posted, so start the suspend. */
 	case SCI_RNC_READY:
 		break;
 	case SCI_RNC_INVALIDATING:
@@ -596,6 +590,8 @@ enum sci_status sci_remote_node_context_suspend(
 			return SCI_FAILURE_INVALID_STATE;
 		}
 		/* Fall through and handle like SCI_RNC_POSTING */
+	case SCI_RNC_RESUMING:
+		/* Fall through and handle like SCI_RNC_POSTING */
 	case SCI_RNC_POSTING:
 		/* Set the destination state to AWAIT - this signals the
 		 * entry into the SCI_RNC_READY state that a suspension

