From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] fc class: fix fc_transport_init error handling
Date: Tue, 17 Nov 2009 21:25:16 -0600
Message-ID: <1258514716-2564-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZKREFF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 23:05:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If transport_class_register fails we should unregister any
registered classes, or we will leak memory or other
resources.

I did a quick modprobe of scsi_transport_fc to test the
patch.

Patch was made over scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_fc.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index c6f70da..45be82f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -648,11 +648,22 @@ static __init int fc_transport_init(void)
 		return error;
 	error = transport_class_register(&fc_vport_class);
 	if (error)
-		return error;
+		goto unreg_host_class;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
-		return error;
-	return transport_class_register(&fc_transport_class);
+		goto unreg_vport_class;
+	error = transport_class_register(&fc_transport_class);
+	if (error)
+		goto unreg_rport_class;
+	return 0;
+
+unreg_rport_class:
+	transport_class_unregister(&fc_rport_class);
+unreg_vport_class:
+	transport_class_unregister(&fc_vport_class);
+unreg_host_class:
+	transport_class_unregister(&fc_host_class);
+	return error;
 }
 
 static void __exit fc_transport_exit(void)
-- 
1.6.2.2

