From: brking@us.ibm.com
Subject: [PATCH 08/26] ipr: Prevent upper layer driver binding
Date: Tue, 01 Nov 2005 17:01:01 -0600
Message-ID: <200511012301.jA1N11Vk015600@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:24262 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751404AbVKAXBD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Nov 2005 18:01:03 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N12k0000822
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:02 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N12Xg102396
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:02 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N12d3015622
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Set the no_uld_attach for devices ipr does not want
upper layer drivers to attach to. These devices are
only reported for RAID management and only sg should
be used to talk to them.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_no_uld_attach drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_no_uld_attach	2005-10-31 21:53:02.203453384 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:53:02.256445328 -0600
@@ -2789,8 +2789,10 @@ static int ipr_slave_configure(struct sc
 	if (res) {
 		if (ipr_is_af_dasd_device(res))
 			sdev->type = TYPE_RAID;
-		if (ipr_is_af_dasd_device(res) || ipr_is_ioa_resource(res))
+		if (ipr_is_af_dasd_device(res) || ipr_is_ioa_resource(res)) {
 			sdev->scsi_level = 4;
+			sdev->no_uld_attach = 1;
+		}
 		if (ipr_is_vset_device(res)) {
 			sdev->timeout = IPR_VSET_RW_TIMEOUT;
 			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
_
