From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] fcoe_create() fails without destroying the kmem slab.
Date: Tue, 04 Dec 2007 16:52:06 -0800
Message-ID: <20071205005205.26153.74710.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:56691 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751008AbXLEAwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:52:08 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:52:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

fcoe_create() fails without destroying the kmem slab.

This causes the next create to panic.
The destroy should be done in openfc_put_dev.

Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/openfc/openfc_if.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 0d9c370..6f9a276 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -1115,7 +1115,6 @@ void openfc_unregister(struct fcdev *dev)
 	fc_remove_host(openfcp->host);
 	scsi_remove_host(openfcp->host);
 	fcs_destroy(openfcp->fcs_state);
-	openfc_destroy_scsi_slab(openfcp);
 }
 EXPORT_SYMBOL(openfc_unregister);
 
@@ -1127,9 +1126,7 @@ void openfc_put_dev(struct fcdev *dev)
 {
 	struct openfc_softc *openfcp = openfc_get_softc(dev);
 
-	/*
-	 * put back the scsi host structure
-	 */
+	openfc_destroy_scsi_slab(openfcp);
 	scsi_host_put(openfcp->host);
 }
 EXPORT_SYMBOL(openfc_put_dev);


