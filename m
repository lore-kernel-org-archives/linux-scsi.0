From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH RESEND 4/5] ipr: Set scsi_level correctly for disk arrays
Date: Tue, 02 Dec 2014 12:47:46 -0600
Message-ID: <201412021847.sB2IlkT5007118@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41737 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBSry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 13:47:54 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 11:47:53 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 336CB3E4003D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 11:47:51 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2IksAT14549124
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:46:54 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2IlnuI007488
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:47:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org, brking@linux.vnet.ibm.com


Set the scsi_level correctly for disk arrays such
that things like the rotational field get set
properly by sd.c.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_array_scsi_level drivers/scsi/ipr.c
--- scsi-queue/drivers/scsi/ipr.c~ipr_array_scsi_level	2014-12-02 12:13:28.585275691 -0600
+++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-12-02 12:13:28.591275641 -0600
@@ -4740,6 +4740,7 @@ static int ipr_slave_configure(struct sc
 			sdev->no_uld_attach = 1;
 		}
 		if (ipr_is_vset_device(res)) {
+			sdev->scsi_level = SCSI_SPC_3;
 			blk_queue_rq_timeout(sdev->request_queue,
 					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
_

