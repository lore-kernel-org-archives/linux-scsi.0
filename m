From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 2/3] [BNX2I] link bnx2i hba and cnic device before
 registering the device
Date: Thu, 25 Mar 2010 10:54:42 -0700
Message-ID: <1269539682.28522.68949.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4571 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0CYRyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 13:54:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, mchan@broadcom.com, waie@broadcom.com

	[BNX2I] link bnx2i hba and cnic device before registering the device
 	
	* When bnx2/cnic/bnx2i drivers are loaded in certain order, bnx2i will
	  will not initialize the device correctly because 'hba->cnic' will
	  be NULL when bnx2i_start() is called from register_device() context.
	  Under this condition 'ifdown' and 'ifup' of associated network interface
	  is required to bring iscsi adapter state to ready state so that it
	  will accept iscsi connection setup within the chip
	* Initializing 'hba->cnic' before calling register_device() will fix
	  this issue

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 6d8172e..737dce0 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -278,6 +278,7 @@ static int bnx2i_init_one(struct bnx2i_hba *hba, struct cnic_dev *cnic)
 	int rc;
 
 	mutex_lock(&bnx2i_dev_lock);
+	hba->cnic = cnic;
 	rc = cnic->register_device(cnic, CNIC_ULP_ISCSI, hba);
 	if (!rc) {
 		hba->age++;
@@ -324,8 +325,7 @@ void bnx2i_ulp_init(struct cnic_dev *dev)
 	if (bnx2i_init_one(hba, dev)) {
 		printk(KERN_ERR "bnx2i - hba %p init failed\n", hba);
 		bnx2i_free_hba(hba);
-	} else
-		hba->cnic = dev;
+	}
 }
 
 
-- 
1.6.5.1




