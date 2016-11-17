From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 05/15] scsi: fc: provide fc_bsg_to_rport()
	helper
Date: Thu, 17 Nov 2016 10:31:15 +0100
Message-ID: <6210a4b7340010b556b49b9175ac6c6d35f13f02.1479374719.git.jthumshirn@suse.de>
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
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "open list:IBM Power Virtual FC Device Drivers" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Provide fc_bsg_to_rport() helper that will become handy when we're moving
from struct fc_bsg_job to a plain struct bsg_job. Also move all LLDDs to use
the new helper.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Acked-by: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/s390/scsi/zfcp_fc.c      | 8 +++++---
 drivers/scsi/ibmvscsi/ibmvfc.c   | 2 +-
 drivers/scsi/libfc/fc_lport.c    | 4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 4 ++--
 drivers/scsi/qla2xxx/qla_bsg.c   | 4 ++--
 drivers/scsi/scsi_transport_fc.c | 3 ++-
 include/scsi/scsi_transport_fc.h | 5 +++++
 7 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 3937deb..c751003 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -901,12 +901,13 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 	u8 gs_type;
 	struct zfcp_adapter *adapter;
 	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct Scsi_Host *shost;
 
 	preamble_word1 = bsg_request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
-	shost = fc_bsg_to_shost(job);
+	shost = rport ? rport_to_shost(rport) : fc_bsg_to_shost(job);
 	adapter = (struct zfcp_adapter *) shost->hostdata[0];
 
 	switch (gs_type) {
@@ -940,7 +941,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
-	struct fc_rport *rport = job->rport;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_bsg_request *bsg_request = job->request;
 	struct zfcp_port *port;
 	u32 d_id;
@@ -988,8 +989,9 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct zfcp_adapter *adapter;
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
 	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 
-	shost = job->rport ? rport_to_shost(job->rport) : fc_bsg_to_shost(job);
+	shost = rport ? rport_to_shost(rport) : fc_bsg_to_shost(job);
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 02df1f1..4c73fc7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1822,7 +1822,7 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
-	struct fc_rport *rport = job->rport;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct ibmvfc_passthru_mad *mad;
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 3e3afe6..5e24ca3 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2103,7 +2103,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 
 	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
-		rport = job->rport;
+		rport = fc_bsg_to_rport(job);
 		if (!rport)
 			break;
 
@@ -2113,7 +2113,7 @@ int fc_lport_bsg_request(struct fc_bsg_job *job)
 		break;
 
 	case FC_BSG_RPT_CT:
-		rport = job->rport;
+		rport = fc_bsg_to_rport(job);
 		if (!rport)
 			break;
 
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 45184ee..19847d7 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -386,7 +386,7 @@ struct lpfc_dmabufext {
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_rport_data *rdata = job->rport->dd_data;
+	struct lpfc_rport_data *rdata = fc_bsg_to_rport(job)->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct ulp_bde64 *bpl = NULL;
@@ -660,7 +660,7 @@ struct lpfc_dmabufext {
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
@@ -264,7 +264,7 @@
 	uint16_t nextlid = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -2485,7 +2485,7 @@
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b6e7abf..0a66dfa 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3640,11 +3640,12 @@ static void fc_bsg_softirq_done(struct request *rq)
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
