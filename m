From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] lpfc: fix double free of bound CQ/WQ ring pointer
Date: Mon,  3 Apr 2017 18:51:15 -0300
Message-ID: <1491256275-27836-1-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45339 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751468AbdDCVv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 17:51:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v33LXtRN004511
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 17:51:26 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29kqbkdspn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2017 17:51:25 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 3 Apr 2017 18:51:24 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v33LpMhH31064164
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 18:51:22 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v33LpMbA007061
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 18:51:23 -0300
In-Reply-To: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jthumshirn@suse.de
Cc: linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, james.smart@broadcom.com, anton@samba.org, martin.petersen@oracle.com

commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
binds the CQs and WQs ring pointer (sets it to same address on both).

    lpfc_create_wq_cq():
    ...
            rc = lpfc_cq_create(phba, cq, eq, <...>)
    ...
                    rc = lpfc_wq_create(phba, wq, cq, qtype);
    ...
                    /* Bind this CQ/WQ to the NVME ring */
                    pring = wq->pring;
    ...
                    cq->pring = pring;
    ...

The commit frees both CQ & WQ for FCP/NVME on lpfc_sli4_queue_destroy(),
which causes a double free (potential corruption or panic) on freeing
the ring pointer of the second entity (CQ is first, WQ is second):

    lpfc_pci_remove_one() # that is, .remove / .shutdown
    -> lpfc_pci_remove_one_s4()
       -> lpfc_sli4_hba_unset()
          -> lpfc_sli4_queue_destroy()

             -> lpfc_sli4_release_queues()  # Release FCP/NVME cqs
                -> __lpfc_sli4_release_queue()
                   -> lpfc_sli4_queue_free()
                      -> kfree(queue->pring)  # first free

             -> lpfc_sli4_release_queues()  # Release FCP/NVME wqs
                -> __lpfc_sli4_release_queue()
                   -> lpfc_sli4_queue_free()
                      -> kfree(queue->pring)  # second free

So, check for WQs in lpfc_sli4_queue_free() and do not free the pring,
as it is freed before in the bound CQ.  [the WQs are created only via
lpfc_wq_create(), which sets struct lpfc_queue::type == LPFC_WQ.  And
that happens in 2 sites (lpfc_create_wq_cq() & lpfc_fof_queue_setup()),
both of which bind the CQs & WQs. Thus, checking for the LPFC_WQ type
correlates to whether the WQ is bound to a CQ, which is freed first.]

Additional details:

For reference, that binding also occurs on one other function:

    lpfc_fof_queue_setup():
    ...
                    rc = lpfc_cq_create(phba, phba->sli4_hba.oas_cq, <...>)
    ...
                    rc = lpfc_wq_create(phba, phba->sli4_hba.oas_wq, <...>)
    ...
                    /* Bind this CQ/WQ to the NVME ring */
                    pring = phba->sli4_hba.oas_wq->pring;
    ...
                    phba->sli4_hba.oas_cq->pring = pring;

And used to occur similarly on lpfc_sli4_queue_setup(), but was changed
by that commit; although the problem is more related to the new freeing
pattern introduced in lpfc_sli4_queue_destroy() plus the bound CQs/WQs.

    -               /* Bind this WQ to the next FCP ring */
    -               pring = &psli->ring[MAX_SLI3_CONFIGURED_RINGS + fcp_wqidx];
    ...
    -               phba->sli4_hba.fcp_cq[fcp_wqidx]->pring = pring;

commit 85e8a23936ab ("scsi: lpfc: Add shutdown method for kexec") made
this more likely as lpfc_pci_remove_one() is called on driver shutdown
(e.g., modprobe -r / rmmod).

(this patch is partially based on a different patch suggested by Johannes,
 thus adding a Suggested-by tag for due credit.)

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reported-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Suggested-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1c9fa45df7eb..8befe841adaa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13758,7 +13758,14 @@ void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
 		lpfc_free_rq_buffer(queue->phba, queue);
 		kfree(queue->rqbp);
 	}
-	kfree(queue->pring);
+
+	/*
+	 * The WQs/CQs' pring is bound (same pointer).
+	 * So free it only once, and not again on WQ.
+	 */
+	if (queue->type != LPFC_WQ)
+		kfree(queue->pring);
+
 	kfree(queue);
 	return;
 }
-- 
1.8.3.1
