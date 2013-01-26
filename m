From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: balloon: Make adjustments to the pressure report
Date: Fri, 25 Jan 2013 16:18:47 -0800
Message-ID: <1359159527-8148-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42722
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3AYXvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2013 18:51:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

The host expects that the pressure report includes the pressure due to the
pages that have been ballooned. Make necessary adjustments to reflect that.
Also, include the free memory information in the pressure report.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index ce6f984..32a96f1 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -529,15 +529,21 @@ static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg *msg)
 static void post_status(struct hv_dynmem_device *dm)
 {
 	struct dm_status status;
+	struct sysinfo val;
 
-
+	si_meminfo(&val);
 	memset(&status, 0, sizeof(struct dm_status));
 	status.hdr.type = DM_STATUS_REPORT;
 	status.hdr.size = sizeof(struct dm_status);
 	status.hdr.trans_id = atomic_inc_return(&trans_id);
 
-
-	status.num_committed = vm_memory_committed();
+	/*
+	 * The host expects the guest to report free memory.
+	 * Further, the host expects the pressure information to
+	 * include the ballooned out pages.
+	 */
+	status.num_avail = val.freeram;
+	status.num_committed = vm_memory_committed() + dm->num_pages_ballooned;
 
 	vmbus_sendpacket(dm->dev->channel, &status,
 				sizeof(struct dm_status),
-- 
1.7.4.1

