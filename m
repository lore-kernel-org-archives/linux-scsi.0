From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] bnx2fc: check IS_ERR() instead of NULL
Date: Tue, 4 Nov 2014 13:37:17 +0300
Message-ID: <20141104103717.GA19096@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The bnx2fc_if_create() function returns NULL on failure, it never
returns an error pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 79e5c94..dfed4be 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1081,7 +1081,7 @@ static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
 	mutex_unlock(&bnx2fc_dev_lock);
 	rtnl_unlock();
 
-	if (IS_ERR(vn_port)) {
+	if (!vn_port) {
 		printk(KERN_ERR PFX "bnx2fc_vport_create (%s) failed\n",
 			netdev->name);
 		return -EIO;
