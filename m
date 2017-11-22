From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: lpfc: Use after free in lpfc_rq_buf_free()
Date: Wed, 22 Nov 2017 11:58:03 +0300
Message-ID: <20171122085803.lwajodogeyovzjoa@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23008 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdKVI6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Nov 2017 03:58:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The error message dereferences "rqb_entry" so we need to print it first
and then free the buffer.

Fixes: 6c621a2229b0 ("scsi: lpfc: Separate NVMET RQ buffer posting from IO resources SGL/iocbq/context")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 56faeb049b4a..87c08ff37ddd 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -753,12 +753,12 @@ lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 	drqe.address_hi = putPaddrHigh(rqb_entry->dbuf.phys);
 	rc = lpfc_sli4_rq_put(rqb_entry->hrq, rqb_entry->drq, &hrqe, &drqe);
 	if (rc < 0) {
-		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"6409 Cannot post to RQ %d: %x %x\n",
 				rqb_entry->hrq->queue_id,
 				rqb_entry->hrq->host_index,
 				rqb_entry->hrq->hba_index);
+		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 	} else {
 		list_add_tail(&rqb_entry->hbuf.list, &rqbp->rqb_buffer_list);
 		rqbp->buffer_count++;
