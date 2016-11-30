From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: dpt_i2o: double free on error path
Date: Wed, 30 Nov 2016 22:36:48 +0300
Message-ID: <20161130193648.GA24818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Quentin Lambert <lambert.quentin@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We recently introduced a kfree() in the caller for this function.
That's where, logically, you would think the kfree() should be.
Unfortunately the code was just ugly and not buggy so the static
checker warning was a false postive and introduced a double free.

I've removed the old kfree() and left the new one.

Fixes: 021e2927586d ("scsi: dpt_i2o: Add a missing call to kfree")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index f88b3d2..27c0dce 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -651,7 +651,6 @@ static u32 adpt_ioctl_to_context(adpt_hba * pHba, void *reply)
 	}
 	spin_unlock_irqrestore(pHba->host->host_lock, flags);
 	if (i >= nr) {
-		kfree (reply);
 		printk(KERN_WARNING"%s: Too many outstanding "
 				"ioctl commands\n", pHba->name);
 		return (u32)-1;
