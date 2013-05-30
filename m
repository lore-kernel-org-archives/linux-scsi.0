From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] fnic: potential dead lock in fnic_is_abts_pending()
Date: Thu, 30 May 2013 10:50:46 +0300
Message-ID: <20130530074926.GA8148@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45516 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967762Ab3E3HvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 May 2013 03:51:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There is an unlock missing if the == FNIC_IOREQ_ABTS_PENDING is
false.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis.  I can't test this.

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index be99e75..a97e6e5 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2432,11 +2432,9 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 			      "Found IO in %s on lun\n",
 			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
-			spin_unlock_irqrestore(io_lock, flags);
+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
 			ret = 1;
-			continue;
-		}
+		spin_unlock_irqrestore(io_lock, flags);
 	}
 
 	return ret;
