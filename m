From: Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] isci: Argument of function prototype is of wrong type
Date: Fri,  4 May 2012 16:00:47 +0200
Message-ID: <1336140047-31009-1-git-send-email-emilgoode@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40593 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2EDN6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 09:58:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: intel-linux-scu@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, edmund.nadolski@intel.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>

The second argument of the sci_remote_node_context_suspend
function prototype should be an enum.

Sparse is warning about this:

drivers/scsi/isci/remote_node_context.c:567:17: error:
	symbol 'sci_remote_node_context_suspend'
	redeclared with different type (originally declared 
	at drivers/scsi/isci/remote_node_context.h:214)
	- incompatible argument 2 (different signedness)

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/scsi/isci/remote_node_context.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index a703b9c..1177204 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -212,7 +212,7 @@ enum sci_status sci_remote_node_context_destruct(struct sci_remote_node_context
 						      scics_sds_remote_node_context_callback callback,
 						      void *callback_parameter);
 enum sci_status sci_remote_node_context_suspend(struct sci_remote_node_context *sci_rnc,
-						     u32 suspend_type,
+						     enum sci_remote_node_suspension_reasons,
 						     u32 suspension_code);
 enum sci_status sci_remote_node_context_resume(struct sci_remote_node_context *sci_rnc,
 						    scics_sds_remote_node_context_callback cb_fn,
-- 
1.7.9.5

