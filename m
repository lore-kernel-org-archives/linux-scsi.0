From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH 1/2] ibmvscsi: allocate lpevents for ibmvscsi on iseries
Date: Thu, 6 Jul 2006 22:07:47 -0500
Message-ID: <17581.53251.881015.839796@hound.rchland.ibm.com>
References: <17581.52781.675644.492909@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.202]:41618 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751157AbWGGDJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2006 23:09:03 -0400
In-Reply-To: <17581.52781.675644.492909@hound.rchland.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: sfr@canb.auug.org.au


Allocate the correct number of lp events when running
ibmvscsi on legacy iseries

Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>

---

 drivers/scsi/ibmvscsi/iseries_vscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

882b543a07d9ef639ede721fd422ccb8d546d17c
diff --git a/drivers/scsi/ibmvscsi/iseries_vscsi.c b/drivers/scsi/ibmvscsi/iseries_vscsi.c
index 7eed0b0..6aeb5f0 100644
--- a/drivers/scsi/ibmvscsi/iseries_vscsi.c
+++ b/drivers/scsi/ibmvscsi/iseries_vscsi.c
@@ -81,7 +81,7 @@ int ibmvscsi_init_crq_queue(struct crq_q
 	int rc;
 
 	single_host_data = hostdata;
-	rc = viopath_open(viopath_hostLp, viomajorsubtype_scsi, 0);
+	rc = viopath_open(viopath_hostLp, viomajorsubtype_scsi, max_requests);
 	if (rc < 0) {
 		printk("viopath_open failed with rc %d in open_event_path\n",
 		       rc);
-- 
1.2.4.gc98264

