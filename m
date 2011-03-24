From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] libsrp: Fix oops on ibmvscsis module remove
Date: Thu, 24 Mar 2011 15:16:35 -0500
Message-ID: <201103242016.p2OKGZsc014250@d03av05.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36026 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab1CXUQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2011 16:16:39 -0400
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2OJpIH9023974
	for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2011 15:51:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 8CA266E8036
	for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2011 16:16:37 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2OKGa7j478702
	for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2011 16:16:37 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2OKGaua014302
	for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2011 14:16:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com


While testing the ibmvscsis driver, an oops was observed on module
remove. This occurred due to some confusion regarding what layer
owns the drvdata in the struct device for an ibmvscsis device.
libsrp was overriding what ibmvscsis had already setup, so on
module remove we go off a bad pointer. Since libsrp appears
only to setup drvdata and never read the value, lets just remove
setting it in libsrp and let the server driver own the field.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/libsrp.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/scsi/libsrp.c~libsrp_fix_oops drivers/scsi/libsrp.c
--- linux-2.6/drivers/scsi/libsrp.c~libsrp_fix_oops	2011-03-24 15:09:01.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/libsrp.c	2011-03-24 15:09:17.000000000 -0500
@@ -126,8 +126,6 @@ int srp_target_alloc(struct srp_target *
 	INIT_LIST_HEAD(&target->cmd_queue);
 
 	target->dev = dev;
-	dev_set_drvdata(target->dev, target);
-
 	target->srp_iu_size = iu_size;
 	target->rx_ring_size = nr;
 	target->rx_ring = srp_ring_alloc(target->dev, nr, iu_size);
_
