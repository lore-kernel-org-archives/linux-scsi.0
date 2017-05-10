From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 01/15] lpfc: Fix used-RPI accounting problem.
Date: Wed, 10 May 2017 12:06:59 -0700
Message-ID: <20170510190713.30171-2-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35915 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753773AbdEJTHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:25 -0400
Received: by mail-qk0-f193.google.com with SMTP id y128so719240qka.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:24 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

With 255 vports created a link trasition can casue a crash.

When going through discovery after a link bounce the driver is using
rpis before the cmd FCOE_POST_HDR_TEMPLATES completes. By doing that
the next rpi bumps the rpi range out of the boundary.

The fix it to increment the next_rpi only when the FCOE_POST_HDR_TEMPLATE
succeeds.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c  |  3 ++-
 drivers/scsi/lpfc/lpfc_init.c | 24 +++++-------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  8 ++++++++
 drivers/scsi/lpfc/lpfc_sli4.h |  1 +
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 67827e397431..3f9f6d5f8c69 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8667,7 +8667,8 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_do_scr_ns_plogi(phba, vport);
 	goto out;
 fdisc_failed:
-	if (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS)
+	if (vport->fc_vport &&
+	    (vport->fc_vport->vport_state != FC_VPORT_NO_FABRIC_RSCS))
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	/* Cancel discovery timer */
 	lpfc_can_disctmo(vport);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4b1eb98c228d..b1b181a756dc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6525,7 +6525,6 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	uint16_t rpi_limit, curr_rpi_range;
 	struct lpfc_dmabuf *dmabuf;
 	struct lpfc_rpi_hdr *rpi_hdr;
-	uint32_t rpi_count;
 
 	/*
 	 * If the SLI4 port supports extents, posting the rpi header isn't
@@ -6538,8 +6537,7 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 		return NULL;
 
 	/* The limit on the logical index is just the max_rpi count. */
-	rpi_limit = phba->sli4_hba.max_cfg_param.rpi_base +
-	phba->sli4_hba.max_cfg_param.max_rpi - 1;
+	rpi_limit = phba->sli4_hba.max_cfg_param.max_rpi;
 
 	spin_lock_irq(&phba->hbalock);
 	/*
@@ -6550,18 +6548,10 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 	curr_rpi_range = phba->sli4_hba.next_rpi;
 	spin_unlock_irq(&phba->hbalock);
 
-	/*
-	 * The port has a limited number of rpis. The increment here
-	 * is LPFC_RPI_HDR_COUNT - 1 to account for the starting value
-	 * and to allow the full max_rpi range per port.
-	 */
-	if ((curr_rpi_range + (LPFC_RPI_HDR_COUNT - 1)) > rpi_limit)
-		rpi_count = rpi_limit - curr_rpi_range;
-	else
-		rpi_count = LPFC_RPI_HDR_COUNT;
-
-	if (!rpi_count)
+	/* Reached full RPI range */
+	if (curr_rpi_range == rpi_limit)
 		return NULL;
+
 	/*
 	 * First allocate the protocol header region for the port.  The
 	 * port expects a 4KB DMA-mapped memory region that is 4K aligned.
@@ -6595,13 +6585,9 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba *phba)
 
 	/* The rpi_hdr stores the logical index only. */
 	rpi_hdr->start_rpi = curr_rpi_range;
+	rpi_hdr->next_rpi = phba->sli4_hba.next_rpi + LPFC_RPI_HDR_COUNT;
 	list_add_tail(&rpi_hdr->list, &phba->sli4_hba.lpfc_rpi_hdr_list);
 
-	/*
-	 * The next_rpi stores the next logical module-64 rpi value used
-	 * to post physical rpis in subsequent rpi postings.
-	 */
-	phba->sli4_hba.next_rpi += rpi_count;
 	spin_unlock_irq(&phba->hbalock);
 	return rpi_hdr;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2a4fc00dfa9b..e2d25ae5ba45 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17137,6 +17137,14 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
 				"status x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
 		rc = -ENXIO;
+	} else {
+		/*
+		 * The next_rpi stores the next logical module-64 rpi value used
+		 * to post physical rpis in subsequent rpi postings.
+		 */
+		spin_lock_irq(&phba->hbalock);
+		phba->sli4_hba.next_rpi = rpi_page->next_rpi;
+		spin_unlock_irq(&phba->hbalock);
 	}
 	return rc;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index da46471337c8..915e8d5581bd 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -698,6 +698,7 @@ struct lpfc_rpi_hdr {
 	struct lpfc_dmabuf *dmabuf;
 	uint32_t page_count;
 	uint32_t start_rpi;
+	uint16_t next_rpi;
 };
 
 struct lpfc_rsrc_blks {
-- 
2.11.0
