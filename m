From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Tue, 29 Oct 2013 22:10:07 +0300
Message-ID: <20131029191007.GD21820@longonot.mountain>
References: <20131025144452.GA28451@ngolde.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3J2TNS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 15:13:18 -0400
Content-Disposition: inline
In-Reply-To: <20131025144452.GA28451@ngolde.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, security@kernel.org

If "fibsize" is zero then it leads to a ZERO_SIZE_PTR dereference when
we dereference user_srbcmd.

Due to a missing capable() check in the compat ioctls then this error
can be triggered without CAP_SYS_RAWIO.  I have fixed that in a separate
patch.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d85ac1a..efd0ba3 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -511,7 +511,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if (fibsize == 0 ||
+	    fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
