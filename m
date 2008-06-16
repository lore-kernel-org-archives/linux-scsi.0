From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] iscsi class: fix endpoint leak
Date: Mon, 16 Jun 2008 10:11:35 -0500
Message-ID: <1213629095-5078-5-git-send-email-michaelc@cs.wisc.edu>
References: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-2-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-3-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYFPPMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:12:01 -0400
In-Reply-To: <1213629095-5078-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

class_find_device gets a ref to the device so we must release it.
The class will serialize access to the ep so we do not have to worry
about a remove racing with the callers access, so we can simplify the
use and drop the ref right away.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8e34f3c..3af7cbc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -219,6 +219,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
+	struct iscsi_endpoint *ep;
 	struct device *dev;
 
 	dev = class_find_device(&iscsi_endpoint_class, &handle,
@@ -226,7 +227,13 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	if (!dev)
 		return NULL;
 
-	return iscsi_dev_to_endpoint(dev);
+	ep = iscsi_dev_to_endpoint(dev);
+	/*
+	 * we can drop this now because the interface will prevent
+	 * removals and lookups from racing.
+	 */
+	put_device(dev);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
-- 
1.5.4.1

