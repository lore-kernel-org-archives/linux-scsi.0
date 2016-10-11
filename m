From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 21/44] lpfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
Date: Tue, 11 Oct 2016 13:28:52 +0200
Message-ID: <eff347cbd5cc976d43b3eb4f40e9b1f6ec0e09c0.1476180827.git.jthumshirn@suse.de>
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
 drivers/scsi/lpfc/lpfc_bsg.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 447a7af..bfcc37d 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -384,7 +384,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
 static int
 lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
@@ -658,7 +658,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 static int
 lpfc_bsg_rport_els(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
@@ -1202,7 +1202,7 @@ lpfc_bsg_ct_unsol_abort(struct lpfc_hba *phba, struct hbq_dmabuf *dmabuf)
 static int
 lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct set_ct_event *event_req;
@@ -1287,7 +1287,7 @@ job_error:
 static int
 lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -1625,7 +1625,7 @@ no_dd_data:
 static int
 lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -2201,10 +2201,10 @@ lpfc_bsg_diag_loopback_mode(struct fc_bsg_job *job)
 	struct lpfc_hba *phba;
 	int rc;
 
-	shost = job->shost;
+	shost = fc_bsg_to_shost(job);
 	if (!shost)
 		return -ENODEV;
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = shost_priv(shost);
 	if (!vport)
 		return -ENODEV;
 	phba = vport->phba;
@@ -2241,10 +2241,10 @@ lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
 	uint32_t timeout;
 	int rc, i;
 
-	shost = job->shost;
+	shost = fc_bsg_to_shost(job);
 	if (!shost)
 		return -ENODEV;
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = shost_priv(shost);
 	if (!vport)
 		return -ENODEV;
 	phba = vport->phba;
@@ -2325,12 +2325,12 @@ lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
 	struct diag_status *diag_status_reply;
 	int mbxstatus, rc = 0;
 
-	shost = job->shost;
+	shost = fc_bsg_to_shost(job);
 	if (!shost) {
 		rc = -ENODEV;
 		goto job_error;
 	}
-	vport = (struct lpfc_vport *)job->shost->hostdata;
+	vport = shost_priv(shost);
 	if (!vport) {
 		rc = -ENODEV;
 		goto job_error;
@@ -3018,7 +3018,7 @@ err_post_rxbufs_exit:
 static int
 lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_bsg_event *evt;
@@ -3322,7 +3322,7 @@ loopback_test_exit:
 static int
 lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_mgmt_rev_reply *event_reply;
@@ -4933,7 +4933,7 @@ job_cont:
 static int
 lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
@@ -5093,7 +5093,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
 static int
 lpfc_menlo_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
@@ -5353,7 +5353,7 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 int
 lpfc_bsg_timeout(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-- 
1.8.5.6
