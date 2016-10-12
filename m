From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v2 06/16] scsi: fc: provide fc_bsg_to_rport()
	helper
Date: Wed, 12 Oct 2016 15:06:32 +0200
Message-ID: <1e2e7efa478b213200a7c0a8a934d4c959bcb3de.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, James Smart <james.smart-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Provide fc_bsg_to_rport() helper that will become handy when we're moving
from struct fc_bsg_job to a plain struct bsg_job. Also move all LLDDs to use
the new helper.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      | 5 +++--
 drivers/scsi/ibmvscsi/ibmvfc.c   | 2 +-
 drivers/scsi/libfc/fc_lport.c    | 4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 4 ++--
 drivers/scsi/qla2xxx/qla_bsg.c   | 4 ++--
 drivers/scsi/scsi_transport_fc.c | 3 ++-
 include/scsi/scsi_transport_fc.h | 5 +++++
 7 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 813c286..1977a66 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -938,7 +938,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
-	struct fc_rport *rport = job->rport;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_bsg_request *bsg_request = job->request;
 	struct zfcp_port *port;
 	u32 d_id;
@@ -986,8 +986,9 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct zfcp_adapter *adapter;
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
 	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 
-	shost = job->rport ? rport_to_shost(job->rport) : fc_bsg_to_shost(job);
+	shost = rport ? rport_to_shost(rport) : fc_bsg_to_shost(job);
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f7b50af..35114d9 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1816,7 +1816,7 @@ unlock_out:
 static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
-	struct fc_rport *rport = job->rport;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct ibmvfc_passthru_mad *mad;
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index c60fdb9..156708a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2102,7 +2102,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 
 	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
-		rport = job->rport;
+		rport = fc_bsg_to_rport(job);
 		if (!rport)
 			break;
 
@@ -2112,7 +2112,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_RPT_CT:
-		rport = job->rport;
+		rport = fc_bsg_to_rport(job);
 		if (!rport)
 			break;
 
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
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 109b852..917eafe 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -264,7 +264,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -2485,7 +2485,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index d6d18ce..96b3a2e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3640,11 +3640,12 @@ fc_bsg_job_timeout(struct request *req)
 {
 	struct fc_bsg_job *job = (void *) req->special;
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 	int err = 0, done = 0;
 
-	if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
+	if (rport && rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
 	spin_lock_irqsave(&job->job_lock, flags);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index efb9488..9f53fe3 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -824,6 +824,11 @@ static inline struct Scsi_Host *fc_bsg_to_shost(struct fc_bsg_job *job)
 	return job->shost;
 }
 
+static inline struct fc_rport *fc_bsg_to_rport(struct fc_bsg_job *job)
+{
+	return job->rport;
+}
+
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
-- 
1.8.5.6
