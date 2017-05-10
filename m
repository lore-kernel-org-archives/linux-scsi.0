From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 13/15] lpfc: Fix NVMEI's handling of NVMET's PRLI response attributes
Date: Wed, 10 May 2017 12:07:11 -0700
Message-ID: <20170510190713.30171-14-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34717 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbdEJTHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:38 -0400
Received: by mail-qt0-f195.google.com with SMTP id l39so55482qtb.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:38 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Code review of NVMEI's FC_PORT_ROLE_NVME_DISCOVERY
looked wrong.

Discussions with storage architecture team clarified
NVMEI's audit of the PRLI response port roles.  Following up
discussion with code review showed a few minor corrections
were required - especially in anticipation of NVME auto
discovery.

During PRLI, NVMEI should sent prli_init - which it it
does.  NVMET should send prli_tgt and prli_disc - which it does.
When NVMEI receives a PRLI Response now, it audits the
incoming target bits and stores the attributes in the
corresponding NDLP.  Later, when NVMEI registers the NVME
rport, it uses the stored ndlp attributes to set the rport
port_roles correctly.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_disc.h      | 1 +
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 9d5a379f4b15..094c97b9e5f7 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -90,6 +90,7 @@ struct lpfc_nodelist {
 #define NLP_FCP_INITIATOR  0x10			/* entry is an FCP Initiator */
 #define NLP_NVME_TARGET    0x20			/* entry is a NVME Target */
 #define NLP_NVME_INITIATOR 0x40			/* entry is a NVME Initiator */
+#define NLP_NVME_DISCOVERY 0x80                 /* entry has NVME disc srvc */
 
 	uint16_t	nlp_fc4_type;		/* FC types node supports. */
 						/* Assigned from GID_FF, only
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8777c2d5f50d..bff3de053df4 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1944,7 +1944,13 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		/* Target driver cannot solicit NVME FB. */
 		if (bf_get_be32(prli_tgt, nvpr)) {
+			/* Complete the nvme target roles.  The transport
+			 * needs to know if the rport is capable of
+			 * discovery in addition to its role.
+			 */
 			ndlp->nlp_type |= NLP_NVME_TARGET;
+			if (bf_get_be32(prli_disc, nvpr))
+				ndlp->nlp_type |= NLP_NVME_DISCOVERY;
 			if ((bf_get_be32(prli_fba, nvpr) == 1) &&
 			    (bf_get_be32(prli_fb_sz, nvpr) > 0) &&
 			    (phba->cfg_nvme_enable_fb) &&
-- 
2.11.0
