From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
Date: Tue, 11 Dec 2012 14:32:32 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E75BB255@inbmail02.lsi.com>
References: <20121207062801.GD18220@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121207062801.GD18220@elgon.mountain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Friday, December 07, 2012 11:58 AM
To: Nandigama, Nagalakshmi
Cc: Reddy, Sreekanth; Support; James E.J. Bottomley; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi

ioc->diag_trigger_mpi is an SL_WH_MPI_TRIGGERS_T struct.

There is a cut and paste error here and SL_WH_EVENT_TRIGGERS_T is used instead of SL_WH_MPI_TRIGGERS_T.  Since the SL_WH_EVENT_TRIGGERS_T is smaller than SL_WH_MPI_TRIGGERS_T, it means we only clear part of the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

This is a static analysis patch.  Even though I'm pretty sure it's correct, I'm not able to test it.

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8af944d..3e35e64 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3136,7 +3136,7 @@ _ctl_diag_trigger_mpi_store(struct device *cdev,
 	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
 	sz = min(sizeof(struct SL_WH_MPI_TRIGGERS_T), count);
 	memset(&ioc->diag_trigger_mpi, 0,
-	    sizeof(struct SL_WH_EVENT_TRIGGERS_T));
+	    sizeof(struct SL_WH_MPI_TRIGGERS_T));
 	memcpy(&ioc->diag_trigger_mpi, buf, sz);
 	if (ioc->diag_trigger_mpi.ValidEntries > NUM_VALID_ENTRIES)
 		ioc->diag_trigger_mpi.ValidEntries = NUM_VALID_ENTRIES;
