From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: libfc: Remove an unneeded condition
Date: Thu, 24 Nov 2016 13:52:38 +0300
Message-ID: <20161124105238.GB17225@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19425 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935138AbcKXKxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Nov 2016 05:53:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We verified that resp_code is FC_SPP_RESP_ACK earlier so we don't need
to check again here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 110a707..c991f3b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1196,7 +1196,6 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		 * Check if the image pair could be established
 		 */
 		if (rdata->spp_type != FC_TYPE_FCP ||
-		    resp_code != FC_SPP_RESP_ACK ||
 		    !(pp->spp.spp_flags & FC_SPP_EST_IMG_PAIR)) {
 			/*
 			 * Nope; we can't use this port as a target.
