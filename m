From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 04/15] scsi: fc: provide fc_bsg_to_shost()
	helper
Date: Thu, 17 Nov 2016 10:31:14 +0100
Message-ID: <b6faf0859190f5e4567bc11e039ed9ec113e5505.1479374719.git.jthumshirn@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, "open list:BROCADE BFA FC SCSI DRIVER" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>"open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <li>
List-Id: linux-scsi@vger.kernel.org

Provide fc_bsg_to_shost() helper that will become handy when we're moving from
struct fc_bsg_job to a plain struct bsg_job. Also use this little helper in
the LLDDs.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Acked-by: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      |  6 +++--
 drivers/scsi/bfa/bfad_bsg.c      |  6 ++---
 drivers/scsi/ibmvscsi/ibmvfc.c   |  4 +--
 drivers/scsi/libfc/fc_lport.c    |  2 +-
 drivers/scsi/lpfc/lpfc_bsg.c     | 34 ++++++++++++-------------
 drivers/scsi/qla2xxx/qla_bsg.c   | 54 ++++++++++++++++++++--------------------
 drivers/scsi/scsi_transport_fc.c |  2 +-
 include/scsi/scsi_transport_fc.h |  5 ++++
 8 files changed, 59 insertions(+), 54 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 87f6330..3937deb 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -901,11 +901,13 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 	u8 gs_type;
 	struct zfcp_adapter *adapter;
 	struct fc_bsg_request *bsg_request = job->request;
+	struct Scsi_Host *shost;
 
 	preamble_word1 = bsg_request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
-	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
+	shost = fc_bsg_to_shost(job);
+	adapter = (struct zfcp_adapter *) shost->hostdata[0];
 
 	switch (gs_type) {
 	case FC_FST_ALIAS:
@@ -987,7 +989,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
 	struct fc_bsg_request *bsg_request = job->request;
 
-	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
+	shost = job->rport ? rport_to_shost(job->rport) : fc_bsg_to_shost(job);
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index e49a6c8..d3094270 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3135,8 +3135,7 @@
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t vendor_cmd = bsg_request->rqst_data.h_vendor.vendor_cmd[0];
-	struct bfad_im_port_s *im_port =
-			(struct bfad_im_port_s *) job->shost->hostdata[0];
+	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
 	struct bfad_s *bfad = im_port->bfad;
 	struct request_queue *request_q = job->req->q;
 	void *payload_kbuf;
@@ -3358,8 +3357,7 @@ struct bfad_buf_info *
 bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
-	struct bfad_im_port_s *im_port =
-			(struct bfad_im_port_s *) job->shost->hostdata[0];
+	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
 	struct bfad_s *bfad = im_port->bfad;
 	bfa_bsg_fcpt_t *bsg_fcpt;
 	struct bfad_fcxp    *drv_fcxp;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6070361..02df1f1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1708,7 +1708,7 @@ static void ibmvfc_bsg_timeout_done(struct ibmvfc_event *evt)
  **/
 static int ibmvfc_bsg_timeout(struct fc_bsg_job *job)
 {
-	struct ibmvfc_host *vhost = shost_priv(job->shost);
+	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
 	unsigned long port_id = (unsigned long)job->dd_data;
 	struct ibmvfc_event *evt;
 	struct ibmvfc_tmf *tmf;
@@ -1821,7 +1821,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
  **/
 static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 {
-	struct ibmvfc_host *vhost = shost_priv(job->shost);
+	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
 	struct fc_rport *rport = job->rport;
 	struct ibmvfc_passthru_mad *mad;
 	struct ibmvfc_event *evt;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 8ea6e93..3e3afe6 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2088,7 +2088,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct request *rsp = job->req->next_rq;
-	struct Scsi_Host *shost = job->shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport;
 	struct fc_rport_priv *rdata;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 46f0b8f..45184ee 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -384,7 +384,7 @@ struct lpfc_dmabufext {
 static int
 lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
@@ -658,7 +658,7 @@ struct lpfc_dmabufext {
 static int
 lpfc_bsg_rport_els(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
@@ -1202,7 +1202,7 @@ struct lpfc_dmabufext {
 static int
 lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct set_ct_event *event_req;
@@ -1287,7 +1287,7 @@ struct lpfc_dmabufext {
 static int
 lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -1625,7 +1625,7 @@ struct lpfc_dmabufext {
 static int
 lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -2201,10 +2201,10 @@ struct lpfc_dmabufext {
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
@@ -2241,10 +2241,10 @@ struct lpfc_dmabufext {
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
@@ -2325,12 +2325,12 @@ struct lpfc_dmabufext {
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
@@ -3018,7 +3018,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 static int
 lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_bsg_event *evt;
@@ -3322,7 +3322,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 static int
 lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_mgmt_rev_reply *event_reply;
@@ -4933,7 +4933,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static int
 lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
@@ -5093,7 +5093,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static int
 lpfc_menlo_cmd(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_hba *phba = vport->phba;
@@ -5257,7 +5257,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static int
 lpfc_forced_link_speed(struct fc_bsg_job *job)
 {
-	struct Scsi_Host *shost = job->shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct lpfc_vport *vport = shost_priv(shost);
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -5400,7 +5400,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 int
 lpfc_bsg_timeout(struct fc_bsg_job *job)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9293d5a..109b852 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,4 +1,4 @@
-/*
+	/*
  * QLogic Fibre Channel HBA Driver
  * Copyright (c)  2003-2014 QLogic Corporation
  *
@@ -122,7 +122,7 @@
 static int
 qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 {
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
@@ -271,7 +271,7 @@
 		ha = vha->hw;
 		type = "FC_BSG_RPT_ELS";
 	} else {
-		host = bsg_job->shost;
+		host = fc_bsg_to_shost(bsg_job);
 		vha = shost_priv(host);
 		ha = vha->hw;
 		type = "FC_BSG_HST_ELS_NOLOGIN";
@@ -432,7 +432,7 @@
 {
 	srb_t *sp;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = (DRIVER_ERROR << 16);
@@ -710,7 +710,7 @@
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval;
@@ -950,7 +950,7 @@
 qla84xx_reset(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
@@ -987,7 +987,7 @@
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct verify_chip_entry_84xx *mn = NULL;
@@ -1099,7 +1099,7 @@
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct access_chip_84xx *mn = NULL;
@@ -1297,7 +1297,7 @@
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_port_param *port_param = NULL;
@@ -1455,7 +1455,7 @@
 qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1492,7 +1492,7 @@
 qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1528,7 +1528,7 @@
 qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1580,7 +1580,7 @@
 qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1630,7 +1630,7 @@
 qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1676,7 +1676,7 @@
 qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1721,7 +1721,7 @@
 qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
@@ -1770,7 +1770,7 @@
 qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t rval = EXT_STATUS_OK;
@@ -1949,7 +1949,7 @@
 qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	int rval = (DRIVER_ERROR << 16);
@@ -2072,7 +2072,7 @@
 qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_serdes_reg sr;
@@ -2114,7 +2114,7 @@
 qla8044_serdes_op(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval = 0;
 	struct qla_serdes_reg_ex sr;
@@ -2156,7 +2156,7 @@
 qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_flash_update_caps cap;
@@ -2188,7 +2188,7 @@
 qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	uint64_t online_fw_attr = 0;
@@ -2234,7 +2234,7 @@
 qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_bbcr_data bbcr;
@@ -2294,7 +2294,7 @@
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
@@ -2354,7 +2354,7 @@
 qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	struct Scsi_Host *host = bsg_job->shost;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	scsi_qla_host_t *vha = shost_priv(host);
 	int rval;
 	struct qla_dport_diag *dd;
@@ -2489,7 +2489,7 @@
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
-		host = bsg_job->shost;
+		host = fc_bsg_to_shost(bsg_job);
 		vha = shost_priv(host);
 	}
 
@@ -2528,7 +2528,7 @@
 qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
-	scsi_qla_host_t *vha = shost_priv(bsg_job->shost);
+	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
 	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	int cnt, que;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 66871c8..b6e7abf 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3639,7 +3639,7 @@ static void fc_bsg_softirq_done(struct request *rq)
 fc_bsg_job_timeout(struct request *req)
 {
 	struct fc_bsg_job *job = (void *) req->special;
-	struct Scsi_Host *shost = job->shost;
+	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 	int err = 0, done = 0;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index eca8ed7..efb9488 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -819,6 +819,11 @@ static inline void u64_to_wwn(u64 inm, u8 *wwn)
 	vport->vport_state = new_state;
 }
 
+static inline struct Scsi_Host *fc_bsg_to_shost(struct fc_bsg_job *job)
+{
+	return job->shost;
+}
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
-- 
1.8.5.6
