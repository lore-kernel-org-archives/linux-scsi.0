From: Mark Rustad <mark.d.rustad@intel.com>
Subject: [PATCH] scsi: Avoid NULL dereferences in scsi_cmd_to_driver
Date: Thu, 21 Jun 2012 12:23:42 -0700
Message-ID: <20120621192342.30692.9665.stgit@host1-mdrustad.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50611 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970Ab2FUTYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jun 2012 15:24:36 -0400
Received: from host1-mdrustad.localdomain (localhost [127.0.0.1])
	by host1-mdrustad.localdomain (8.14.5/8.14.5) with ESMTP id q5LJNg2G030722
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 12:23:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Avoid crashing if the private_data pointer happens to be NULL. This has
been seen sometimes when a host reset happens, notably when there are
many LUNs.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
---

 include/scsi/scsi_cmnd.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 1e11985..ac06cc5 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,10 +134,16 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	struct scsi_driver **sdp;
+
 	if (!cmd->request->rq_disk)
 		return NULL;
 
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+	sdp = (struct scsi_driver **)cmd->request->rq_disk->private_data;
+	if (!sdp)
+		return NULL;
+
+	return *sdp;
 }
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);

