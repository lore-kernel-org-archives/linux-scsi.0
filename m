From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 09/15] scsi: change FC drivers to use 'struct
	bsg_job'
Date: Thu, 17 Nov 2016 10:31:19 +0100
Message-ID: <5726f89a404273e9d8479ee4d09b7bf5cb1b3a9a.1479374720.git.jthumshirn@suse.de>
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

Change FC drivers to use 'struct bsg_job' from bsg-lib.h instead of 'struct
fc_bsg_job' from scsi_transport_fc.h and remove 'struct fc_bsg_job'.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Acked-by: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/s390/scsi/zfcp_ext.h     |  4 +--
 drivers/s390/scsi/zfcp_fc.c      | 15 ++++----
 drivers/scsi/bfa/bfad_bsg.c      | 10 +++---
 drivers/scsi/bfa/bfad_im.h       |  4 +--
 drivers/scsi/ibmvscsi/ibmvfc.c   |  9 ++---
 drivers/scsi/libfc/fc_lport.c    | 10 +++---
 drivers/scsi/lpfc/lpfc_bsg.c     | 76 ++++++++++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_crtn.h    |  4 +--
 drivers/scsi/qla2xxx/qla_bsg.c   | 61 ++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_def.h   |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h   |  4 +--
 drivers/scsi/qla2xxx/qla_iocb.c  |  8 ++---
 drivers/scsi/qla2xxx/qla_isr.c   |  6 ++--
 drivers/scsi/qla2xxx/qla_mr.c    |  5 +--
 drivers/scsi/scsi_transport_fc.c | 20 +++++------
 include/scsi/libfc.h             |  2 +-
 include/scsi/scsi_transport_fc.h | 63 ++++++++++-----------------------
 17 files changed, 139 insertions(+), 164 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index c8fed9f..968a0ab 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -84,8 +84,8 @@ extern void zfcp_fc_enqueue_event(struct zfcp_adapter *,
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
-extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
-extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
+extern int zfcp_fc_exec_bsg_job(struct bsg_job *);
+extern int zfcp_fc_timeout_bsg_job(struct bsg_job *);
 extern void zfcp_fc_sym_name_update(struct work_struct *);
 extern unsigned int zfcp_fc_port_scan_backoff(void);
 extern void zfcp_fc_conditional_port_scan(struct zfcp_adapter *);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index c751003..f01b9a4 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/utsname.h>
 #include <linux/random.h>
+#include <linux/bsg-lib.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/libfc.h>
 #include "zfcp_ext.h"
@@ -885,7 +886,7 @@ void zfcp_fc_sym_name_update(struct work_struct *work)
 
 static void zfcp_fc_ct_els_job_handler(void *data)
 {
-	struct fc_bsg_job *job = data;
+	struct bsg_job *job = data;
 	struct zfcp_fsf_ct_els *zfcp_ct_els = job->dd_data;
 	struct fc_bsg_reply *jr = job->reply;
 
@@ -895,7 +896,7 @@ static void zfcp_fc_ct_els_job_handler(void *data)
 	fc_bsg_jobdone(job, jr->result, jr->reply_payload_rcv_len);
 }
 
-static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
+static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct bsg_job *job)
 {
 	u32 preamble_word1;
 	u8 gs_type;
@@ -928,7 +929,7 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 
 static void zfcp_fc_ct_job_handler(void *data)
 {
-	struct fc_bsg_job *job = data;
+	struct bsg_job *job = data;
 	struct zfcp_fc_wka_port *wka_port;
 
 	wka_port = zfcp_fc_job_wka_port(job);
@@ -937,7 +938,7 @@ static void zfcp_fc_ct_job_handler(void *data)
 	zfcp_fc_ct_els_job_handler(data);
 }
 
-static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
+static int zfcp_fc_exec_els_job(struct bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
@@ -960,7 +961,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
 }
 
-static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
+static int zfcp_fc_exec_ct_job(struct bsg_job *job,
 			       struct zfcp_adapter *adapter)
 {
 	int ret;
@@ -983,7 +984,7 @@ static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
 	return ret;
 }
 
-int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
+int zfcp_fc_exec_bsg_job(struct bsg_job *job)
 {
 	struct Scsi_Host *shost;
 	struct zfcp_adapter *adapter;
@@ -1013,7 +1014,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	}
 }
 
-int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *job)
+int zfcp_fc_timeout_bsg_job(struct bsg_job *job)
 {
 	/* hardware tracks timeout, reset bsg timeout to not interfere */
 	return -EAGAIN;
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index d3094270..cdc25e6 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3130,7 +3130,7 @@
 }
 
 static int
-bfad_im_bsg_vendor_request(struct fc_bsg_job *job)
+bfad_im_bsg_vendor_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -3314,7 +3314,7 @@ struct bfad_buf_info *
 }
 
 int
-bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
+bfad_fcxp_bsg_send(struct bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
 	struct bfa_fcxp_s *hal_fcxp;
@@ -3354,7 +3354,7 @@ struct bfad_buf_info *
 }
 
 int
-bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
+bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
 	struct bfad_im_port_s *im_port = shost_priv(fc_bsg_to_shost(job));
@@ -3562,7 +3562,7 @@ struct bfad_buf_info *
 }
 
 int
-bfad_im_bsg_request(struct fc_bsg_job *job)
+bfad_im_bsg_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -3590,7 +3590,7 @@ struct bfad_buf_info *
 }
 
 int
-bfad_im_bsg_timeout(struct fc_bsg_job *job)
+bfad_im_bsg_timeout(struct bsg_job *job)
 {
 	/* Don't complete the BSG job request - return -EAGAIN
 	 * to reset bsg job timeout : for ELS/CT pass thru we
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 836fdc2..c81ec2a 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -166,8 +166,8 @@ void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
-int bfad_im_bsg_request(struct fc_bsg_job *job);
-int bfad_im_bsg_timeout(struct fc_bsg_job *job);
+int bfad_im_bsg_request(struct bsg_job *job);
+int bfad_im_bsg_timeout(struct bsg_job *job);
 
 /*
  * Macro to set the SCSI device sdev_bflags - sdev_bflags are used by the
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4c73fc7..f59b0a1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -32,6 +32,7 @@
 #include <linux/of.h>
 #include <linux/pm.h>
 #include <linux/stringify.h>
+#include <linux/bsg-lib.h>
 #include <asm/firmware.h>
 #include <asm/irq.h>
 #include <asm/vio.h>
@@ -1701,12 +1702,12 @@ static void ibmvfc_bsg_timeout_done(struct ibmvfc_event *evt)
 
 /**
  * ibmvfc_bsg_timeout - Handle a BSG timeout
- * @job:	struct fc_bsg_job that timed out
+ * @job:	struct bsg_job that timed out
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_timeout(struct fc_bsg_job *job)
+static int ibmvfc_bsg_timeout(struct bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
 	unsigned long port_id = (unsigned long)job->dd_data;
@@ -1814,12 +1815,12 @@ static int ibmvfc_bsg_plogi(struct ibmvfc_host *vhost, unsigned int port_id)
 
 /**
  * ibmvfc_bsg_request - Handle a BSG request
- * @job:	struct fc_bsg_job to be executed
+ * @job:	struct bsg_job to be executed
  *
  * Returns:
  *	0 on success / other on failure
  **/
-static int ibmvfc_bsg_request(struct fc_bsg_job *job)
+static int ibmvfc_bsg_request(struct bsg_job *job)
 {
 	struct ibmvfc_host *vhost = shost_priv(fc_bsg_to_shost(job));
 	struct fc_rport *rport = fc_bsg_to_rport(job);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index cc98ebc..c428ce3 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -149,7 +149,7 @@
  * @offset:   The offset into the response data
  */
 struct fc_bsg_info {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_lport *lport;
 	u16 rsp_code;
 	struct scatterlist *sg;
@@ -1901,7 +1901,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *info_arg)
 {
 	struct fc_bsg_info *info = info_arg;
-	struct fc_bsg_job *job = info->job;
+	struct bsg_job *job = info->job;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct fc_lport *lport = info->lport;
 	struct fc_frame_header *fh;
@@ -1964,7 +1964,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_els_request(struct fc_bsg_job *job,
+static int fc_lport_els_request(struct bsg_job *job,
 				struct fc_lport *lport,
 				u32 did, u32 tov)
 {
@@ -2025,7 +2025,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_ct_request(struct fc_bsg_job *job,
+static int fc_lport_ct_request(struct bsg_job *job,
 			       struct fc_lport *lport, u32 did, u32 tov)
 {
 	struct fc_bsg_info *info;
@@ -2081,7 +2081,7 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  *			    FC Passthrough requests
  * @job: The BSG passthrough job
  */
-int fc_lport_bsg_request(struct fc_bsg_job *job)
+int fc_lport_bsg_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 19847d7..b19ad9e 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -98,7 +98,7 @@ struct lpfc_bsg_menlo {
 #define TYPE_MENLO	4
 struct bsg_job_data {
 	uint32_t type;
-	struct fc_bsg_job *set_job; /* job waiting for this iocb to finish */
+	struct bsg_job *set_job; /* job waiting for this iocb to finish */
 	union {
 		struct lpfc_bsg_event *evt;
 		struct lpfc_bsg_iocb iocb;
@@ -298,7 +298,7 @@ struct lpfc_dmabufext {
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
@@ -382,7 +382,7 @@ struct lpfc_dmabufext {
  * @job: fc_bsg_job to handle
  **/
 static int
-lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
+lpfc_bsg_send_mgmt_cmd(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
@@ -575,7 +575,7 @@ struct lpfc_dmabufext {
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_nodelist *ndlp;
@@ -656,7 +656,7 @@ struct lpfc_dmabufext {
  * @job: fc_bsg_job to handle
  **/
 static int
-lpfc_bsg_rport_els(struct fc_bsg_job *job)
+lpfc_bsg_rport_els(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
@@ -927,7 +927,7 @@ struct lpfc_dmabufext {
 	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
-	struct fc_bsg_job *job = NULL;
+	struct bsg_job *job = NULL;
 	struct fc_bsg_reply *bsg_reply;
 	struct bsg_job_data *dd_data = NULL;
 	unsigned long flags;
@@ -1200,7 +1200,7 @@ struct lpfc_dmabufext {
  * @job: SET_EVENT fc_bsg_job
  **/
 static int
-lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_set_event(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
@@ -1285,7 +1285,7 @@ struct lpfc_dmabufext {
  * @job: GET_EVENT fc_bsg_job
  **/
 static int
-lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_get_event(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
@@ -1397,7 +1397,7 @@ struct lpfc_dmabufext {
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp;
@@ -1477,7 +1477,7 @@ struct lpfc_dmabufext {
  * @num_entry: Number of enties in the bde.
  **/
 static int
-lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct fc_bsg_job *job, uint32_t tag,
+lpfc_issue_ct_rsp(struct lpfc_hba *phba, struct bsg_job *job, uint32_t tag,
 		  struct lpfc_dmabuf *cmp, struct lpfc_dmabuf *bmp,
 		  int num_entry)
 {
@@ -1623,7 +1623,7 @@ struct lpfc_dmabufext {
  * @job: SEND_MGMT_RESP fc_bsg_job
  **/
 static int
-lpfc_bsg_send_mgmt_rsp(struct fc_bsg_job *job)
+lpfc_bsg_send_mgmt_rsp(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
@@ -1782,7 +1782,7 @@ struct lpfc_dmabufext {
  * All of this is done in-line.
  */
 static int
-lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -2040,7 +2040,7 @@ struct lpfc_dmabufext {
  * loopback mode in order to perform a diagnostic loopback test.
  */
 static int
-lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba, struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -2194,7 +2194,7 @@ struct lpfc_dmabufext {
  * command from the user to proper driver action routines.
  */
 static int
-lpfc_bsg_diag_loopback_mode(struct fc_bsg_job *job)
+lpfc_bsg_diag_loopback_mode(struct bsg_job *job)
 {
 	struct Scsi_Host *shost;
 	struct lpfc_vport *vport;
@@ -2230,7 +2230,7 @@ struct lpfc_dmabufext {
  * command from the user to proper driver action routines.
  */
 static int
-lpfc_sli4_bsg_diag_mode_end(struct fc_bsg_job *job)
+lpfc_sli4_bsg_diag_mode_end(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -2309,7 +2309,7 @@ struct lpfc_dmabufext {
  * applicaiton.
  */
 static int
-lpfc_sli4_bsg_link_diag_test(struct fc_bsg_job *job)
+lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -3016,7 +3016,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
  * of loopback mode.
  **/
 static int
-lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
+lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -3320,7 +3320,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
  * @job: GET_DFC_REV fc_bsg_job
  **/
 static int
-lpfc_bsg_get_dfc_rev(struct fc_bsg_job *job)
+lpfc_bsg_get_dfc_rev(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -3375,7 +3375,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 {
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_reply *bsg_reply;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	uint32_t size;
 	unsigned long flags;
 	uint8_t *pmb, *pmb_buf;
@@ -3551,11 +3551,11 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * This is routine handles BSG job for mailbox commands completions with
  * multiple external buffers.
  **/
-static struct fc_bsg_job *
+static struct bsg_job *
 lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 	uint8_t *pmb, *pmb_buf;
 	unsigned long flags;
@@ -3646,7 +3646,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static void
 lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 
 	job = lpfc_bsg_issue_mbox_ext_handle_job(phba, pmboxq);
@@ -3686,7 +3686,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 static void
 lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 
 	job = lpfc_bsg_issue_mbox_ext_handle_job(phba, pmboxq);
@@ -3818,7 +3818,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * non-embedded external bufffers.
  **/
 static int
-lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			      enum nemb_type nemb_tp,
 			      struct lpfc_dmabuf *dmabuf)
 {
@@ -4006,7 +4006,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * non-embedded external bufffers.
  **/
 static int
-lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			       enum nemb_type nemb_tp,
 			       struct lpfc_dmabuf *dmabuf)
 {
@@ -4173,7 +4173,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * with embedded sussystem 0x1 and opcodes with external HBDs.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 			     struct lpfc_dmabuf *dmabuf)
 {
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
@@ -4322,7 +4322,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * user space through BSG.
  **/
 static int
-lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct fc_bsg_job *job)
+lpfc_bsg_read_ebuf_get(struct lpfc_hba *phba, struct bsg_job *job)
 {
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	struct lpfc_sli_config_mbox *sli_cfg_mbx;
@@ -4392,7 +4392,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * from user space through BSG.
  **/
 static int
-lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 			struct lpfc_dmabuf *dmabuf)
 {
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -4515,7 +4515,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * command with multiple non-embedded external buffers.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_ebuf(struct lpfc_hba *phba, struct bsg_job *job,
 			     struct lpfc_dmabuf *dmabuf)
 {
 	int rc;
@@ -4560,7 +4560,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * (0x9B) mailbox commands and external buffers.
  **/
 static int
-lpfc_bsg_handle_sli_cfg_ext(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_handle_sli_cfg_ext(struct lpfc_hba *phba, struct bsg_job *job,
 			    struct lpfc_dmabuf *dmabuf)
 {
 	struct fc_bsg_request *bsg_request = job->request;
@@ -4638,7 +4638,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * let our completion handler finish the command.
  **/
 static int
-lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
+lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	struct lpfc_vport *vport)
 {
 	struct fc_bsg_request *bsg_request = job->request;
@@ -4931,7 +4931,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * @job: MBOX fc_bsg_job for LPFC_BSG_VENDOR_MBOX.
  **/
 static int
-lpfc_bsg_mbox_cmd(struct fc_bsg_job *job)
+lpfc_bsg_mbox_cmd(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
@@ -5000,7 +5000,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 			struct lpfc_iocbq *rspiocbq)
 {
 	struct bsg_job_data *dd_data;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	struct fc_bsg_reply *bsg_reply;
 	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp, *cmp, *rmp;
@@ -5091,7 +5091,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * supplied in the menlo request header xri field.
  **/
 static int
-lpfc_menlo_cmd(struct fc_bsg_job *job)
+lpfc_menlo_cmd(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct fc_bsg_request *bsg_request = job->request;
@@ -5255,7 +5255,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 }
 
 static int
-lpfc_forced_link_speed(struct fc_bsg_job *job)
+lpfc_forced_link_speed(struct bsg_job *job)
 {
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct lpfc_vport *vport = shost_priv(shost);
@@ -5303,7 +5303,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * @job: fc_bsg_job to handle
  **/
 static int
-lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
+lpfc_bsg_hst_vendor(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -5361,7 +5361,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * @job: fc_bsg_job to handle
  **/
 int
-lpfc_bsg_request(struct fc_bsg_job *job)
+lpfc_bsg_request(struct bsg_job *job)
 {
 	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
@@ -5398,7 +5398,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
  * the waiting function which will handle passing the error back to userspace
  **/
 int
-lpfc_bsg_timeout(struct fc_bsg_job *job)
+lpfc_bsg_timeout(struct bsg_job *job)
 {
 	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
 	struct lpfc_hba *phba = vport->phba;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 16195b7..15d2bfd 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -429,8 +429,8 @@ int lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *, uint16_t,
 #define HBA_EVENT_LINK_DOWN              3
 
 /* functions to support SGIOv4/bsg interface */
-int lpfc_bsg_request(struct fc_bsg_job *);
-int lpfc_bsg_timeout(struct fc_bsg_job *);
+int lpfc_bsg_request(struct bsg_job *);
+int lpfc_bsg_timeout(struct bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
 int lpfc_bsg_ct_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 917eafe..342e8a3 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -9,6 +9,7 @@
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
+#include <linux/bsg-lib.h>
 
 /* BSG support for ELS/CT pass through */
 void
@@ -16,7 +17,7 @@
 {
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
@@ -30,7 +31,7 @@
 {
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_qla_host *vha = sp->fcport->vha;
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
 	struct qla_hw_data *ha = vha->hw;
@@ -120,7 +121,7 @@
 }
 
 static int
-qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
+qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
 	struct fc_bsg_request *bsg_request = bsg_job->request;
@@ -249,7 +250,7 @@
 }
 
 static int
-qla2x00_process_els(struct fc_bsg_job *bsg_job)
+qla2x00_process_els(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_rport *rport;
@@ -428,7 +429,7 @@
 }
 
 static int
-qla2x00_process_ct(struct fc_bsg_job *bsg_job)
+qla2x00_process_ct(struct bsg_job *bsg_job)
 {
 	srb_t *sp;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
@@ -706,7 +707,7 @@
 }
 
 static int
-qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
+qla2x00_process_loopback(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -947,7 +948,7 @@
 }
 
 static int
-qla84xx_reset(struct fc_bsg_job *bsg_job)
+qla84xx_reset(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -983,7 +984,7 @@
 }
 
 static int
-qla84xx_updatefw(struct fc_bsg_job *bsg_job)
+qla84xx_updatefw(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -1095,7 +1096,7 @@
 }
 
 static int
-qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
+qla84xx_mgmt_cmd(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -1293,7 +1294,7 @@
 }
 
 static int
-qla24xx_iidma(struct fc_bsg_job *bsg_job)
+qla24xx_iidma(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -1382,7 +1383,7 @@
 }
 
 static int
-qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
+qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
 	uint8_t is_update)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
@@ -1452,7 +1453,7 @@
 }
 
 static int
-qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
+qla2x00_read_optrom(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1489,7 +1490,7 @@
 }
 
 static int
-qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
+qla2x00_update_optrom(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1525,7 +1526,7 @@
 }
 
 static int
-qla2x00_update_fru_versions(struct fc_bsg_job *bsg_job)
+qla2x00_update_fru_versions(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1577,7 +1578,7 @@
 }
 
 static int
-qla2x00_read_fru_status(struct fc_bsg_job *bsg_job)
+qla2x00_read_fru_status(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1627,7 +1628,7 @@
 }
 
 static int
-qla2x00_write_fru_status(struct fc_bsg_job *bsg_job)
+qla2x00_write_fru_status(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1673,7 +1674,7 @@
 }
 
 static int
-qla2x00_write_i2c(struct fc_bsg_job *bsg_job)
+qla2x00_write_i2c(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1718,7 +1719,7 @@
 }
 
 static int
-qla2x00_read_i2c(struct fc_bsg_job *bsg_job)
+qla2x00_read_i2c(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1767,7 +1768,7 @@
 }
 
 static int
-qla24xx_process_bidir_cmd(struct fc_bsg_job *bsg_job)
+qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -1946,7 +1947,7 @@
 }
 
 static int
-qlafx00_mgmt_cmd(struct fc_bsg_job *bsg_job)
+qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2069,7 +2070,7 @@
 }
 
 static int
-qla26xx_serdes_op(struct fc_bsg_job *bsg_job)
+qla26xx_serdes_op(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2111,7 +2112,7 @@
 }
 
 static int
-qla8044_serdes_op(struct fc_bsg_job *bsg_job)
+qla8044_serdes_op(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2153,7 +2154,7 @@
 }
 
 static int
-qla27xx_get_flash_upd_cap(struct fc_bsg_job *bsg_job)
+qla27xx_get_flash_upd_cap(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2185,7 +2186,7 @@
 }
 
 static int
-qla27xx_set_flash_upd_cap(struct fc_bsg_job *bsg_job)
+qla27xx_set_flash_upd_cap(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2231,7 +2232,7 @@
 }
 
 static int
-qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
+qla27xx_get_bbcr_data(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2290,7 +2291,7 @@
 }
 
 static int
-qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
+qla2x00_get_priv_stats(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -2351,7 +2352,7 @@
 }
 
 static int
-qla2x00_do_dport_diagnostics(struct fc_bsg_job *bsg_job)
+qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
@@ -2394,7 +2395,7 @@
 }
 
 static int
-qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
+qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
@@ -2472,7 +2473,7 @@
 }
 
 int
-qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
+qla24xx_bsg_request(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
@@ -2525,7 +2526,7 @@
 }
 
 int
-qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
+qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 {
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 	scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 73b12e4..5236e3f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -403,7 +403,7 @@ struct srb_iocb {
 	int iocbs;
 	union {
 		struct srb_iocb iocb_cmd;
-		struct fc_bsg_job *bsg_job;
+		struct bsg_job *bsg_job;
 		struct srb_cmd scmd;
 	} u;
 	void (*done)(void *, void *, int);
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 6ca0081..c51d9f3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -733,8 +733,8 @@ extern void qla2x00_set_model_info(scsi_qla_host_t *, uint8_t *,
 extern int qla8044_read_temperature(scsi_qla_host_t *);
 
 /* BSG related functions */
-extern int qla24xx_bsg_request(struct fc_bsg_job *);
-extern int qla24xx_bsg_timeout(struct fc_bsg_job *);
+extern int qla24xx_bsg_request(struct bsg_job *);
+extern int qla24xx_bsg_timeout(struct bsg_job *);
 extern int qla84xx_reset_chip(scsi_qla_host_t *, uint16_t);
 extern int qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *,
 	dma_addr_t, size_t, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6929fda..221ad89 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2197,7 +2197,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
         els_iocb->entry_type = ELS_IOCB_TYPE;
@@ -2251,7 +2251,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	uint16_t tot_dsds;
 	scsi_qla_host_t *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
 	int entry_count = 1;
 
@@ -2328,7 +2328,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	uint16_t tot_dsds;
         scsi_qla_host_t *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
 	int entry_count = 1;
 
@@ -2834,7 +2834,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 	struct scatterlist *sg;
 	int index;
 	int entry_count = 1;
-	struct fc_bsg_job *bsg_job = sp->u.bsg_job;
+	struct bsg_job *bsg_job = sp->u.bsg_job;
 
 	/*Update entry type to indicate bidir command */
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d83e083..19f1848 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1356,7 +1356,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	const char func[] = "CT_IOCB";
 	const char *type;
 	srb_t *sp;
-	struct fc_bsg_job *bsg_job;
+	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	int res;
@@ -1415,7 +1415,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	const char func[] = "ELS_CT_IOCB";
 	const char *type;
 	srb_t *sp;
-	struct fc_bsg_job *bsg_job;
+	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
@@ -1908,7 +1908,7 @@ struct scsi_dif_tuple {
 	uint16_t	scsi_status;
 	uint16_t thread_id;
 	uint32_t rval = EXT_STATUS_OK;
-	struct fc_bsg_job *bsg_job = NULL;
+	struct bsg_job *bsg_job = NULL;
 	struct fc_bsg_request *bsg_request;
 	struct fc_bsg_reply *bsg_reply;
 	sts_entry_t *sts;
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index b597d04..02f1de1 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include <linux/bsg-lib.h>
 #include <scsi/scsi_tcq.h>
 #include <linux/utsname.h>
 
@@ -2206,7 +2207,7 @@
 {
 	const char func[] = "IOSB_IOCB";
 	srb_t *sp;
-	struct fc_bsg_job *bsg_job;
+	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
 	struct srb_iocb *iocb_job;
 	int res;
@@ -3254,7 +3255,7 @@
 {
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
-	struct fc_bsg_job *bsg_job;
+	struct bsg_job *bsg_job;
 	struct fc_bsg_request *bsg_request;
 	struct fxdisc_entry_fx00 fx_iocb;
 	uint8_t entry_cnt = 1;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index bf948c7..10a2254 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3562,7 +3562,7 @@ struct fc_vport *
 static void
 fc_destroy_bsgjob(struct kref *kref)
 {
-	struct fc_bsg_job *job = container_of(kref, struct fc_bsg_job, kref);
+	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 	struct request *rq = job->req;
 
 	blk_end_request_all(rq, rq->errors);
@@ -3581,7 +3581,7 @@ struct fc_vport *
  * @result:	job reply result
  * @reply_payload_rcv_len: length of payload received
  */
-void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
+void fc_bsg_jobdone(struct bsg_job *job, int result,
 		    unsigned int reply_payload_rcv_len)
 {
 	struct request *req = job->req;
@@ -3615,7 +3615,7 @@ void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
  */
 static void fc_bsg_softirq_done(struct request *rq)
 {
-	struct fc_bsg_job *job = rq->special;
+	struct bsg_job *job = rq->special;
 
 	kref_put(&job->kref, fc_destroy_bsgjob);
 }
@@ -3627,7 +3627,7 @@ static void fc_bsg_softirq_done(struct request *rq)
 static enum blk_eh_timer_return
 fc_bsg_job_timeout(struct request *req)
 {
-	struct fc_bsg_job *job = (void *) req->special;
+	struct bsg_job *job = (void *) req->special;
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
@@ -3686,12 +3686,12 @@ static void fc_bsg_softirq_done(struct request *rq)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request *rsp = req->next_rq;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	int ret;
 
 	BUG_ON(req->special);
 
-	job = kzalloc(sizeof(struct fc_bsg_job) + i->f->dd_bsg_size,
+	job = kzalloc(sizeof(struct bsg_job) + i->f->dd_bsg_size,
 			GFP_KERNEL);
 	if (!job)
 		return -ENOMEM;
@@ -3706,8 +3706,6 @@ static void fc_bsg_softirq_done(struct request *rq)
 	 */
 
 	req->special = job;
-	job->shost = shost;
-	job->rport = rport;
 	job->req = req;
 	if (i->f->dd_bsg_size)
 		job->dd_data = (void *)&job[1];
@@ -3760,7 +3758,7 @@ enum fc_dispatch_result {
  */
 static enum fc_dispatch_result
 fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct fc_bsg_job *job)
+			 struct bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_bsg_request *bsg_request = job->request;
@@ -3862,7 +3860,7 @@ enum fc_dispatch_result {
  */
 static enum fc_dispatch_result
 fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
-			 struct fc_rport *rport, struct fc_bsg_job *job)
+			 struct fc_rport *rport, struct bsg_job *job)
 {
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct fc_bsg_request *bsg_request = job->request;
@@ -3925,7 +3923,7 @@ enum fc_dispatch_result {
 		       struct fc_rport *rport, struct device *dev)
 {
 	struct request *req;
-	struct fc_bsg_job *job;
+	struct bsg_job *job;
 	enum fc_dispatch_result ret;
 	struct fc_bsg_reply *bsg_reply;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 6f81b28..96dd0b3 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -912,7 +912,7 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
 int fc_set_mfs(struct fc_lport *, u32 mfs);
 struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
-int fc_lport_bsg_request(struct fc_bsg_job *);
+int fc_lport_bsg_request(struct bsg_job *);
 void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
 void fc_lport_iterate(void (*func)(struct fc_lport *, void *), void *);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 8ae5680..1da8b71 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -32,6 +32,7 @@
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_netlink.h>
+#include <scsi/scsi_host.h>
 
 struct scsi_transport_template;
 
@@ -625,38 +626,6 @@ struct fc_host_attrs {
 #define fc_host_dev_loss_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
 
-/* Values for fc_bsg_job->state_flags (bitflags) */
-#define FC_RQST_STATE_INPROGRESS	0
-#define FC_RQST_STATE_DONE		1
-
-struct fc_bsg_job {
-	struct Scsi_Host *shost;
-	struct fc_rport *rport;
-	struct device *dev;
-	struct request *req;
-	struct kref kref;
-
-	struct fc_bsg_request *request;
-	struct fc_bsg_reply *reply;
-	unsigned int request_len;
-	unsigned int reply_len;
-	/*
-	 * On entry : reply_len indicates the buffer size allocated for
-	 * the reply.
-	 *
-	 * Upon completion : the message handler must set reply_len
-	 *  to indicates the size of the reply to be returned to the
-	 *  caller.
-	 */
-
-	/* DMA payloads for the request/response */
-	struct bsg_buffer request_payload;
-	struct bsg_buffer reply_payload;
-
-	void *dd_data;			/* Used for driver-specific storage */
-};
-
-
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void    (*get_rport_dev_loss_tmo)(struct fc_rport *);
@@ -693,8 +662,8 @@ struct fc_function_template {
 	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
 
 	/* bsg support */
-	int	(*bsg_request)(struct fc_bsg_job *);
-	int	(*bsg_timeout)(struct fc_bsg_job *);
+	int	(*bsg_request)(struct bsg_job *);
+	int	(*bsg_timeout)(struct bsg_job *);
 
 	/* allocation lengths for host-specific data */
 	u32	 			dd_fcrport_size;
@@ -817,16 +786,6 @@ static inline void u64_to_wwn(u64 inm, u8 *wwn)
 	vport->vport_state = new_state;
 }
 
-static inline struct Scsi_Host *fc_bsg_to_shost(struct fc_bsg_job *job)
-{
-	return job->shost;
-}
-
-static inline struct fc_rport *fc_bsg_to_rport(struct fc_bsg_job *job)
-{
-	return job->rport;
-}
-
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
@@ -849,7 +808,21 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
-void fc_bsg_jobdone(struct fc_bsg_job *job, int result,
+void fc_bsg_jobdone(struct bsg_job *job, int result,
 		    unsigned int reply_payload_rcv_len);
 
+static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
+{
+	if (scsi_is_host_device(job->dev))
+		return dev_to_shost(job->dev);
+	return rport_to_shost(dev_to_rport(job->dev));
+}
+
+static inline struct fc_rport *fc_bsg_to_rport(struct bsg_job *job)
+{
+	if (scsi_is_fc_rport(job->dev))
+		return dev_to_rport(job->dev);
+	return NULL;
+}
+
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.8.5.6
