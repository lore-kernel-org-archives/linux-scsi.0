From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: unlock on error in pscsi_create_virtdevice()
Date: Sun, 2 Oct 2011 01:59:13 +0300
Message-ID: <20111001225913.GA15072@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:57336 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab1JAW7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2011 18:59:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

This function should take the lock on success but on the error cases
it doesn't.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ba9e94d..b619596 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -567,7 +567,7 @@ static struct se_device *pscsi_create_virtdevice(
 			if (IS_ERR(sh)) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return (struct se_device *) sh;
+				return ERR_CAST(sh);
 			}
 		}
 	} else {
@@ -609,6 +609,7 @@ static struct se_device *pscsi_create_virtdevice(
 				hba->hba_flags &= ~HBA_FLAGS_PSCSI_MODE;
 			}
 			pdv->pdv_sd = NULL;
+			spin_unlock_irq(sh->host_lock);
 			return ERR_PTR(-ENODEV);
 		}
 		return dev;
