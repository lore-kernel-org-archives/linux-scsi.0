From: jsmart2021@gmail.com
Subject: [PATCH-v1 04/22] Fix log message in completion path.
Date: Wed, 19 Apr 2017 21:46:23 -0700
Message-ID: <20170420044641.10657-5-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35871 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938019AbdDTErB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:01 -0400
Received: by mail-oi0-f65.google.com with SMTP id a3so346040oii.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:00 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

In the lpfc_nvme_io_cmd_wqe_cmpl routine the driver was printing two
pointers and the DID for the rport whenever an IO completed on a now
that had transitioned to a non active state.

There is no need to print the node pointer address for a node that
is not active the DID should be enough to debug.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 2a87428..bc6946f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -787,9 +787,8 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	ndlp = rport->ndlp;
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
-				 "6061 rport %p, ndlp %p, DID x%06x ndlp "
-				 "not ready.\n",
-				 rport, ndlp, rport->remoteport->port_id);
+				 "6061 rport %p,  DID x%06x node not ready.\n",
+				 rport, rport->remoteport->port_id);
 
 		ndlp = lpfc_findnode_did(vport, rport->remoteport->port_id);
 		if (!ndlp) {
-- 
2.1.0
