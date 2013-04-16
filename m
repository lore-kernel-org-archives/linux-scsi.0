From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] megaraid_sas: release lock on error path
Date: Tue, 16 Apr 2013 10:44:19 +0300
Message-ID: <20130416074419.GA1571@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3DPHon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 03:44:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We should unlock here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9d53540..eb2385f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4931,11 +4931,12 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		printk(KERN_ERR "megaraid_sas: timed out while"
 			"waiting for HBA to recover\n");
 		error = -ENODEV;
-		goto out_kfree_ioc;
+		goto out_up;
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
+      out_up:
 	up(&instance->ioctl_sem);
 
       out_kfree_ioc:
