From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] pluto/fc - fix INQUIRY still using !use_sg commands
Date: Mon, 15 Oct 2007 19:34:09 +0200
Message-ID: <4713A491.7020701@panasas.com>
References: <4713A175.9020408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10429 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765588AbXJORe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 13:34:29 -0400
In-Reply-To: <4713A175.9020408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>linux-scsi <linux>
Cc: FUJITA Tomonori <tomof@acm.org>


  - pluto.c was still issuing use_sg == 0 commands down to
    fc.c, which was already converted. Fix that by adding
    a member to hold the inquiry_buffer in struct fcp_cmnd
    and using it when mapping/unmapping of command payload,
    if needed.

  - Also fix a compilation warning in pluto_info() now that
    driver can be compiled not only on sparc.

  - Stop using struct scsi_cmnd members that will be removed
    soon.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/fc4/fc.c       |   21 +++++++++++++++------
 drivers/fc4/fcp_impl.h |    2 ++
 drivers/scsi/pluto.c   |   14 +++++++-------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
index 48c3b62..3962ba8 100644
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -429,11 +429,16 @@ static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hd
 			if (sense_len > sizeof(SCpnt->sense_buffer)) sense_len = sizeof(SCpnt->sense_buffer);
 			memcpy(SCpnt->sense_buffer, ((char *)(rsp+1)), sense_len);
 		}
-		
-		if (fcmd->data)
-			dma_unmap_sg(fc->dev, scsi_sglist(SCpnt),
-				     scsi_sg_count(SCpnt),
-				     SCpnt->sc_data_direction);
+
+		if (fcmd->data) {
+			if (fcmd->inquiry_buff)
+				dma_unmap_single(fc->dev, fcmd->data,
+					      FC_INQUIRY_SIZE, DMA_FROM_DEVICE);
+			else
+				dma_unmap_sg(fc->dev, scsi_sglist(SCpnt),
+					     scsi_sg_count(SCpnt),
+					     SCpnt->sc_data_direction);
+		}
 		break;
 	default:
 		host_status=DID_ERROR; /* FIXME */
@@ -776,7 +781,11 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 		} else
 			fcp_cntl = FCP_CNTL_QTYPE_UNTAGGED;
 
-		if (!scsi_bufflen(SCpnt)) {
+		if (fcmd->inquiry_buff) {
+			cmd->fcp_cntl = (FCP_CNTL_READ | fcp_cntl);
+			fcmd->data = dma_map_single(fc->dev, fcmd->inquiry_buff,
+			                      FC_INQUIRY_SIZE, DMA_FROM_DEVICE);
+		} else if (!scsi_bufflen(SCpnt)) {
 			cmd->fcp_cntl = fcp_cntl;
 			fcmd->data = (dma_addr_t)NULL;
 		} else {
diff --git a/drivers/fc4/fcp_impl.h b/drivers/fc4/fcp_impl.h
index 41fa149..968a20e 100644
--- a/drivers/fc4/fcp_impl.h
+++ b/drivers/fc4/fcp_impl.h
@@ -39,6 +39,7 @@ struct _fc_channel;
 typedef struct fcp_cmnd {
 	struct fcp_cmnd		*next;
 	struct fcp_cmnd		*prev;
+	char*			inquiry_buff;
 	unsigned short		proto;
 	unsigned short		token;
 	unsigned int		did;
@@ -138,6 +139,7 @@ extern fc_channel *fc_channels;
 #define FC_STATUS_NO_SEQ_INIT		0x29
 #define FC_STATUS_TIMED_OUT		-1
 #define FC_STATUS_BAD_RSP		-2
+#define FC_INQUIRY_SIZE			256
 
 void fcp_queue_empty(fc_channel *);
 int fcp_init(fc_channel *);
diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
index e598a90..1cb8a39 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -46,7 +46,7 @@ static struct ctrl_inquiry {
 	struct Scsi_Host host;
 	struct pluto pluto;
 	Scsi_Cmnd cmd;
-	char inquiry[256];
+	char inquiry[FC_INQUIRY_SIZE];
 	fc_channel *fc;
 } *fcs __initdata;
 static int fcscount __initdata = 0;
@@ -120,6 +120,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		Scsi_Cmnd *SCpnt;
 		struct Scsi_Host *host;
 		struct pluto *pluto;
+		fcp_cmnd *fcmd;
 
 		if (i == fcscount) break;
 		if (fc->posmap) continue;
@@ -141,6 +142,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		SCpnt = &(fcs[i].cmd);
 		host = &(fcs[i].host);
 		pluto = (struct pluto *)host->hostdata;
+		fcmd = ((fcp_cmnd *)&(SCpnt->SCp));
 		
 		pluto->fc = fc;
 	
@@ -155,8 +157,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 	
 		SCpnt->request->cmd_flags &= ~REQ_STARTED;
 		
-		SCpnt->request_bufflen = 256;
-		SCpnt->request_buffer = fcs[i].inquiry;
+		fcmd->inquiry_buff = fcs[i].inquiry;
 		PLD(("set up %d %08lx\n", i, (long)SCpnt))
 		i++;
 	}
@@ -271,16 +272,15 @@ int pluto_release(struct Scsi_Host *host)
 
 const char *pluto_info(struct Scsi_Host *host)
 {
-	static char buf[128], *p;
+	static char buf[128];
 	struct pluto *pluto = (struct pluto *) host->hostdata;
 
 	sprintf(buf, "SUN SparcSTORAGE Array %s fw %s serial %s %dx%d on %s",
 		pluto->rev_str, pluto->fw_rev_str, pluto->serial_str,
 		host->max_channel, host->max_id, pluto->fc->name);
 #ifdef __sparc__
-	p = strchr(buf, 0);
-	sprintf(p, " PROM node %x", pluto->fc->dev->prom_node);
-#endif	
+	sprintf(buf + strlen(buf), " PROM node %x", pluto->fc->dev->prom_node);
+#endif
 	return buf;
 }
 
-- 
1.5.3.1


