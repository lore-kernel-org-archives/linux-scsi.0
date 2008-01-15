From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] sg: set class_data after success
Date: Tue, 15 Jan 2008 13:17:47 +0900
Message-ID: <20080115131747L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52544 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYAOER7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 23:17:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@HansenPartnership.com, mdr@sgi.com, linux-scsi@vger.kernel.org, tomof@acm.org

If cdev_add fails in sg_add, sg_remove crashes since class_data is
bogus.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f1871ea..92b4367 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1418,7 +1418,6 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 		goto out;
 	}
 
-	class_set_devdata(cl_dev, sdp);
 	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
 	if (error)
 		goto cdev_add_err;
@@ -1447,6 +1446,8 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 		    "Attached scsi generic sg%d type %d\n", sdp->index,
 		    scsidp->type);
 
+	class_set_devdata(cl_dev, sdp);
+
 	return 0;
 
 cdev_add_err:
-- 
1.5.3.4

