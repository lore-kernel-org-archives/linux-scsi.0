From: brking@us.ibm.com
Subject: [PATCH 1/1] SCSI: Set tag type
Date: Wed, 09 Feb 2005 17:34:01 -0600
Message-ID: <200502092334.j19NY2Lr015775@d01av04.pok.ibm.com>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58075 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261970AbVBIXeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2005 18:34:03 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j19NY3A6021282
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 18:34:03 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j19NY32t198454
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 18:34:03 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j19NY2Nx015806
	for <linux-scsi@vger.kernel.org>; Wed, 9 Feb 2005 18:34:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The current implementation of scsi_set_tag_type does not allow for
a transition of ordered to simple. The attached patch fixes this.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc3-bk6-bjking1/include/scsi/scsi_tcq.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/scsi/scsi_tcq.h~scsi_set_tag_type include/scsi/scsi_tcq.h
--- linux-2.6.11-rc3-bk6/include/scsi/scsi_tcq.h~scsi_set_tag_type	2005-02-09 17:23:46.000000000 -0600
+++ linux-2.6.11-rc3-bk6-bjking1/include/scsi/scsi_tcq.h	2005-02-09 17:24:58.000000000 -0600
@@ -38,9 +38,11 @@ static inline void scsi_set_tag_type(str
 	switch (tag) {
 	case MSG_ORDERED_TAG:
 		sdev->ordered_tags = 1;
-		/* fall through */
+		sdev->simple_tags = 1;
+		break;
 	case MSG_SIMPLE_TAG:
 		sdev->simple_tags = 1;
+		sdev->ordered_tags = 0;
 		break;
 	case 0:
 		/* fall through */
_
