From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3 ver2] pluto/fc - fix INQUIRY still using !use_sg commands
Date: Mon, 15 Oct 2007 20:00:22 +0200
Message-ID: <4713AAB6.8070709@panasas.com>
References: <4713A175.9020408@panasas.com> <4713A491.7020701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa5.bezeqint.net ([192.115.104.19]:52426 "EHLO sa5.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765179AbXJOSAk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 14:00:40 -0400
In-Reply-To: <4713A491.7020701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>linux-scsi <linux>
Cc: FUJITA Tomonori <tomof@acm.org>

Some people, me included, might like this approach better

----

  - pluto.c was still issuing use_sg == 0 commands down to
    fc.c, which was already converted. Fix that by adding
    a member to hold the inquiry_sg in struct fcp_cmnd
    and using it when mapping/unmapping of command payload,
    if needed.

  - Also fix a compilation warning in pluto_info() now that
    driver can be compiled not only on sparc.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/fc4/fc.c       |   21 +++++++++++++--------
 drivers/fc4/fcp_impl.h |    2 ++
 drivers/scsi/pluto.c   |   21 +++++++++++++--------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
index 48c3b62..5a0eba5 100644
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -429,11 +429,15 @@ static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hd
 			if (sense_len > sizeof(SCpnt->sense_buffer)) sense_len = sizeof(SCpnt->sense_buffer);
 			memcpy(SCpnt->sense_buffer, ((char *)(rsp+1)), sense_len);
 		}
-		
-		if (fcmd->data)
-			dma_unmap_sg(fc->dev, scsi_sglist(SCpnt),
+
+		if (fcmd->data) {
+			struct scatterlist *sg = fcmd->inquiry_sg ?
+				fcmd->inquiry_sg : scsi_sglist(SCpnt);
+
+			dma_unmap_sg(fc->dev, sg,
 				     scsi_sg_count(SCpnt),
 				     SCpnt->sc_data_direction);
+		}
 		break;
 	default:
 		host_status=DID_ERROR; /* FIXME */
@@ -776,12 +780,11 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 		} else
 			fcp_cntl = FCP_CNTL_QTYPE_UNTAGGED;
 
-		if (!scsi_bufflen(SCpnt)) {
+		if (!scsi_bufflen(SCpnt) && !fcmd->inquiry_sg) {
 			cmd->fcp_cntl = fcp_cntl;
 			fcmd->data = (dma_addr_t)NULL;
 		} else {
 			struct scatterlist *sg;
-			int nents;
 
 			switch (SCpnt->cmnd[0]) {
 			case WRITE_6:
@@ -792,9 +795,11 @@ static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
 				cmd->fcp_cntl = (FCP_CNTL_READ | fcp_cntl); break;
 			}
 
-			sg = scsi_sglist(SCpnt);
-			nents = dma_map_sg(fc->dev, sg, scsi_sg_count(SCpnt),
-					   SCpnt->sc_data_direction);
+			sg = fcmd->inquiry_sg ? fcmd->inquiry_sg :
+				scsi_sglist(SCpnt);
+
+			BUG_ON(scsi_sg_count(SCpnt) > 1);
+			dma_map_sg(fc->dev, sg, 1, SCpnt->sc_data_direction);
 			fcmd->data = sg_dma_address(sg);
 			cmd->fcp_data_len = sg_dma_len(sg);
 		}
diff --git a/drivers/fc4/fcp_impl.h b/drivers/fc4/fcp_impl.h
index 41fa149..728f36d 100644
--- a/drivers/fc4/fcp_impl.h
+++ b/drivers/fc4/fcp_impl.h
@@ -39,6 +39,7 @@ struct _fc_channel;
 typedef struct fcp_cmnd {
 	struct fcp_cmnd		*next;
 	struct fcp_cmnd		*prev;
+	struct scatterlist	*inquiry_sg;
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
index e598a90..df231d3 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -14,6 +14,8 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/scatterlist.h>
+
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
 #endif
@@ -46,7 +48,8 @@ static struct ctrl_inquiry {
 	struct Scsi_Host host;
 	struct pluto pluto;
 	Scsi_Cmnd cmd;
-	char inquiry[256];
+	char inquiry[FC_INQUIRY_SIZE];
+	struct scatterlist inquiry_sg;
 	fc_channel *fc;
 } *fcs __initdata;
 static int fcscount __initdata = 0;
@@ -120,6 +123,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		Scsi_Cmnd *SCpnt;
 		struct Scsi_Host *host;
 		struct pluto *pluto;
+		fcp_cmnd *fcmd;
 
 		if (i == fcscount) break;
 		if (fc->posmap) continue;
@@ -141,6 +145,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		SCpnt = &(fcs[i].cmd);
 		host = &(fcs[i].host);
 		pluto = (struct pluto *)host->hostdata;
+		fcmd = ((fcp_cmnd *)&(SCpnt->SCp));
 		
 		pluto->fc = fc;
 	
@@ -154,9 +159,10 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		SCpnt->cmd_len = COMMAND_SIZE(INQUIRY);
 	
 		SCpnt->request->cmd_flags &= ~REQ_STARTED;
-		
-		SCpnt->request_bufflen = 256;
-		SCpnt->request_buffer = fcs[i].inquiry;
+		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
+
+		sg_init_one(&fcs[i].inquiry_sg, &fcs[i].inquiry, 256);
+		fcmd->inquiry_sg = &fcs[i].inquiry_sg;
 		PLD(("set up %d %08lx\n", i, (long)SCpnt))
 		i++;
 	}
@@ -271,16 +277,15 @@ int pluto_release(struct Scsi_Host *host)
 
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


