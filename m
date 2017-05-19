From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] lpfc: nvmet_fc: fix format string
Date: Fri, 19 May 2017 10:04:31 +0200
Message-ID: <20170519080447.1043039-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The lpfc_nvmeio_data() tracing helper always takes a format string and
three additional arguments. The latest caller has a format string with
only two integer arguments, causing this harmless warning:

drivers/scsi/lpfc/lpfc_nvmet.c: In function 'lpfc_nvmet_xmt_fcp_release':
drivers/scsi/lpfc/lpfc_nvmet.c:802:25: error: too many arguments for format [-Werror=format-extra-args]
  lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,

We could add a dummy argument here, but it seems reasonable to print
the 'abort' flag as the third argument.

Fixes: 19b58d9473e8 ("nvmet_fc: add req_release to lldd api")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f94294b77b7b..24d54dd016d4 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -799,8 +799,8 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	}
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
-	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
-			 ctxp->state, 0);
+	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d abt %d\n", ctxp->oxid,
+			 ctxp->state, aborting);
 
 	atomic_inc(&lpfc_nvmep->xmt_fcp_release);
 
-- 
2.9.0
