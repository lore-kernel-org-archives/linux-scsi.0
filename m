From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/5] ipr: Set scsi_level correctly for disk arrays
Date: Mon, 28 Jul 2014 15:30:15 -0500
Message-ID: <53D6B2D7.2090006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55212 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaG1UbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 16:31:09 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 28 Jul 2014 16:31:08 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 9FCB738C8039
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:31:05 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23032.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6SKV5h52818446
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 20:31:05 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6SKUuwP001722
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:30:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>


Set the scsi_level correctly for disk arrays such
that things like the rotational field get set
properly by sd.c.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_array_scsi_level drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_array_scsi_level	2014-07-23 17:07:00.785527453 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2014-07-23 17:07:00.791527493 -0500
@@ -4747,6 +4747,7 @@ static int ipr_slave_configure(struct sc
 			sdev->no_uld_attach = 1;
 		}
 		if (ipr_is_vset_device(res)) {
+			sdev->scsi_level = SCSI_SPC_3;
 			blk_queue_rq_timeout(sdev->request_queue,
 					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
_

