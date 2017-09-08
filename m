From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mpt3sas: Fix a double unlock in _transport_smp_handler()
Date: Fri, 8 Sep 2017 13:40:12 +0300
Message-ID: <20170907143006.f3aeniflflmj7j7q@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33039 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbdIHKk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2017 06:40:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We can't "goto out;" if we're not holding "ioc->transport_cmds.mutex".
It leads to a double unlock bug, and I don't think we should set
"ioc->transport_cmds.status" if we don't have the lock.

Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I'm not totally sure about the .status thing.  This is a static checker
fix.

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index d3940c5d079d..c9cd9ed90002 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1936,12 +1936,12 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		pr_info(MPT3SAS_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		rc = -EFAULT;
-		goto out;
+		goto job_done;
 	}
 
 	rc = mutex_lock_interruptible(&ioc->transport_cmds.mutex);
 	if (rc)
-		goto out;
+		goto job_done;
 
 	if (ioc->transport_cmds.status != MPT3_CMD_NOT_USED) {
 		pr_err(MPT3SAS_FMT "%s: transport_cmds in use\n", ioc->name,
@@ -2066,6 +2066,7 @@ _transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
  out:
 	ioc->transport_cmds.status = MPT3_CMD_NOT_USED;
 	mutex_unlock(&ioc->transport_cmds.mutex);
+ job_done:
 	bsg_job_done(job, rc, reslen);
 }
 
