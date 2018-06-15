From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 5/8] mpt3sas: Fix _transport_smp_handler() error path
Date: Fri, 15 Jun 2018 14:41:58 -0700
Message-ID: <20180615214201.25365-6-bart.vanassche@wdc.com>
References: <20180615214201.25365-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180615214201.25365-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch avoids that smatch complains about a double unlock on
ioc->transport_cmds.mutex.

Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 05d506d78c66..f4b02dd7f6cf 100644
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
+job_done:
 	bsg_job_done(job, rc, reslen);
 }
 
-- 
2.17.0
