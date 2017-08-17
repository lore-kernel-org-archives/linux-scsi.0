From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: sg: off by one in sg_ioctl()
Date: Thu, 17 Aug 2017 10:09:54 +0300
Message-ID: <20170817070954.d4gg7hqgg2qjf6d3@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20772 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdHQHKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 03:10:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

If "val" is SG_MAX_QUEUE then we are one element beyond the end of the
"rinfo" array so the > should be >=.

Fixes: 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d7ff71e0c85c..84e782d8e7c3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1021,7 +1021,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			val = 0;
 			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val > SG_MAX_QUEUE)
+				if (val >= SG_MAX_QUEUE)
 					break;
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 				rinfo[val].req_state = srp->done + 1;
