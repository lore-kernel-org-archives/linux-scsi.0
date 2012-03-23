From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 12/37] isci: All pending TCs are terminated when
 the RNC is invalidated.
Date: Thu, 22 Mar 2012 17:28:55 -0700
Message-ID: <20120323002855.18065.65435.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:28 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_node_context.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 75cf043..adbb4b8 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -275,8 +275,8 @@ static void sci_remote_node_context_invalidating_state_enter(struct sci_base_sta
 {
 	struct sci_remote_node_context *rnc = container_of(sm, typeof(*rnc), sm);
 
-	/* Terminate outstanding requests pending abort. */
-	sci_remote_device_abort_requests_pending_abort(rnc_to_dev(rnc));
+	/* Terminate all outstanding requests. */
+	sci_remote_device_terminate_requests(rnc_to_dev(rnc));
 	sci_remote_node_context_invalidate_context_buffer(rnc);
 }
 

