From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] bnx2fc: fix an error code in _bnx2fc_create()
Date: Tue, 4 Nov 2014 13:37:59 +0300
Message-ID: <20141104103759.GB19096@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We should be returning an error code here instead of success.  Either
-ENODEV or -ENOMEM would work.  There is also a failure message in
printk().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index dfed4be..251b114 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2195,6 +2195,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	interface = bnx2fc_interface_create(hba, netdev, fip_mode);
 	if (!interface) {
 		printk(KERN_ERR PFX "bnx2fc_interface_create failed\n");
+		rc = -ENOMEM;
 		goto ifput_err;
 	}
 
