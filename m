From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH] ibmvfc: add FC Class 3 Error Recovery support
Date: Wed,  3 Aug 2016 16:36:53 -0500
Message-ID: <1470260213-19087-3-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The ibmvfc driver currently doesn't support FC Class 3 Error Recovery.
However, it is simply a matter of informing the VIOS that the payload
expects to use sequence level error recovery via a bit flag in the
ibmvfc_cmd structure.

This patch adds a module parameter to enable error recovery support
at boot time. When enabled the RETRY service parameter bit is set
during PRLI, and ibmvfc_cmd->flags includes the IBMVFC_CLASS_3_ERR
bit.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 10 ++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 4a680ce..6b92169 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -52,6 +52,7 @@ static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
 static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
 static unsigned int log_level = IBMVFC_DEFAULT_LOG_LEVEL;
+static unsigned int cls3_error = IBMVFC_CLS3_ERROR;
 static LIST_HEAD(ibmvfc_head);
 static DEFINE_SPINLOCK(ibmvfc_driver_lock);
 static struct scsi_transport_template *ibmvfc_transport_template;
@@ -86,6 +87,9 @@ MODULE_PARM_DESC(debug, "Enable driver debug information. "
 module_param_named(log_level, log_level, uint, 0);
 MODULE_PARM_DESC(log_level, "Set to 0 - 4 for increasing verbosity of device driver. "
 		 "[Default=" __stringify(IBMVFC_DEFAULT_LOG_LEVEL) "]");
+module_param_named(cls3_error, cls3_error, uint, 0);
+MODULE_PARM_DESC(log_level, "Enable FC Class 3 Error Recovery. "
+		 "[Default=" __stringify(IBMVFC_CLS3_ERROR) "]");
 
 static const struct {
 	u16 status;
@@ -1335,6 +1339,9 @@ static int ibmvfc_map_sg_data(struct scsi_cmnd *scmd,
 	struct srp_direct_buf *data = &vfc_cmd->ioba;
 	struct ibmvfc_host *vhost = dev_get_drvdata(dev);
 
+	if (cls3_error)
+		vfc_cmd->flags |= cpu_to_be16(IBMVFC_CLASS_3_ERR);
+
 	sg_mapped = scsi_dma_map(scmd);
 	if (!sg_mapped) {
 		vfc_cmd->flags |= cpu_to_be16(IBMVFC_NO_MEM_DESC);
@@ -3383,6 +3390,9 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
 	prli->parms.service_parms = cpu_to_be32(IBMVFC_PRLI_INITIATOR_FUNC);
 	prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_READ_FCP_XFER_RDY_DISABLED);
 
+	if (cls3_error)
+		prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_RETRY);
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 8fae032..7f9bb07 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -54,6 +54,7 @@
 #define IBMVFC_DEV_LOSS_TMO		(5 * 60)
 #define IBMVFC_DEFAULT_LOG_LEVEL	2
 #define IBMVFC_MAX_CDB_LEN		16
+#define IBMVFC_CLS3_ERROR		0
 
 /*
  * Ensure we have resources for ERP and initialization:
-- 
2.7.4
