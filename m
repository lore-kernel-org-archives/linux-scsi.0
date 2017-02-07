From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] aacraid: information leak in aac_send_raw_srb()
Date: Tue, 7 Feb 2017 18:00:00 +0300
Message-ID: <20170207150000.GA1757@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23056 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753587AbdBGPAk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 10:00:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The aac_srb_reply struct ends in a 2 byte hole so we end up leaking a
bit of information to user space.

Fixes: 423400e64d37 ("scsi: aacraid: Include HBA direct interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 614842a9eb07..12dc867b7c74 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -948,6 +948,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			&((struct aac_native_hba *)srbfib->hw_fib_va)->resp.err;
 		struct aac_srb_reply reply;
 
+		memset(&reply, 0, sizeof(reply));
 		reply.status = ST_OK;
 		if (srbfib->flags & FIB_CONTEXT_FLAG_FASTRESP) {
 			/* fast response */
