From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 30/44] lpfc: use fc_bsg_to_rport() to access a bsg_job's rport
Date: Tue, 11 Oct 2016 13:29:01 +0200
Message-ID: <bc4bfebbb6ad5da60fb162457e32c65de212359a.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index bfcc37d..dae7cc3 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -386,7 +386,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct lpfc_rport_data *rdata = fc_bsg_to_rport(job)->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct ulp_bde64 *bpl = NULL;
@@ -660,7 +660,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct lpfc_rport_data *rdata = fc_bsg_to_rport(job)->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
-- 
1.8.5.6
