From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/10] [FCoE] Remove ASSERTs from openfc
Date: Tue, 22 Jan 2008 16:36:55 -0800
Message-ID: <20080123003655.8469.20410.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62768 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658AbYAWAur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:50:47 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---

 drivers/scsi/ofc/openfc/openfc_attr.c  |    1 -
 drivers/scsi/ofc/openfc/openfc_if.c    |    3 ---
 drivers/scsi/ofc/openfc/openfc_ioctl.c |    1 -
 drivers/scsi/ofc/openfc/openfc_pkt.c   |    4 ----
 drivers/scsi/ofc/openfc/openfc_scsi.c  |   24 +++++++++++-------------
 5 files changed, 11 insertions(+), 22 deletions(-)


diff --git a/drivers/scsi/ofc/openfc/openfc_attr.c b/drivers/scsi/ofc/openfc/openfc_attr.c
index 12b00c3..d2a3b17 100644
--- a/drivers/scsi/ofc/openfc/openfc_attr.c
+++ b/drivers/scsi/ofc/openfc/openfc_attr.c
@@ -33,7 +33,6 @@
 #include <scsi/scsi_transport_fc.h>
 
 #include "fc_types.h"
-#include "sa_assert.h"
 #include "fc_port.h"
 #include "fc_remote_port.h"
 #include "fcdev.h"
diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 0b0c782..179f750 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -34,7 +34,6 @@
 #include <scsi/scsi_tcq.h>
 
 #include "fc_types.h"
-#include "sa_assert.h"
 #include "fc_port.h"
 #include "fc_event.h"
 #include "fc_remote_port.h"
@@ -277,8 +276,6 @@ static int openfc_queuecommand(struct scsi_cmnd *sc_cmd,
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
-	ASSERT(done != NULL);
-
 	openfcp = (struct openfc_softc *)sc_cmd->device->host->hostdata;
 
 	if (openfcp->state != OPENFC_RUNNING) {
diff --git a/drivers/scsi/ofc/openfc/openfc_ioctl.c b/drivers/scsi/ofc/openfc/openfc_ioctl.c
index d04164b..60662d9 100644
--- a/drivers/scsi/ofc/openfc/openfc_ioctl.c
+++ b/drivers/scsi/ofc/openfc/openfc_ioctl.c
@@ -28,7 +28,6 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_tcq.h>
 
-#include "sa_assert.h"
 #include "fc_types.h"
 #include "fc_encaps.h"
 #include "fc_frame.h"
diff --git a/drivers/scsi/ofc/openfc/openfc_pkt.c b/drivers/scsi/ofc/openfc/openfc_pkt.c
index baaa77f..ecb1aae 100644
--- a/drivers/scsi/ofc/openfc/openfc_pkt.c
+++ b/drivers/scsi/ofc/openfc/openfc_pkt.c
@@ -32,7 +32,6 @@
  */
 #include "sa_kernel.h"
 #include "fc_types.h"
-#include "sa_assert.h"
 #include "fc_event.h"
 #include "fc_port.h"
 #include "fc_remote_port.h"
@@ -69,8 +68,6 @@ struct fc_scsi_pkt *openfc_alloc_scsi_pkt(struct openfc_softc *openfcp)
 {
 	struct fc_scsi_pkt *sp;
 
-	ASSERT(openfcp != NULL);
-
 	sp = kmem_cache_alloc(openfcp->openfc_scsi_pkt_cachep,
 			      openfcp->alloc_flags);
 	if (sp) {
@@ -110,7 +107,6 @@ int openfc_free_scsi_pkt(struct fc_scsi_pkt *sp)
 void openfc_scsi_pkt_hold(struct fc_scsi_pkt *sp)
 {
 	atomic_inc(&sp->ref_cnt);
-	ASSERT(atomic_read(&sp->ref_cnt) != 0);
 }
 
 void openfc_scsi_pkt_release(struct fc_scsi_pkt *sp)
diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 9c7f9bb..f4c742f 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -34,7 +34,6 @@
  * non linux dot h files
  */
 #include "fc_types.h"
-#include "sa_assert.h"
 #include "fc_event.h"
 #include "fc_port.h"
 #include "fc_remote_port.h"
@@ -268,12 +267,12 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 		}
 	}
 	mfs = fc_seq_mfs(sp);
-	ASSERT(mfs >= FC_MIN_MAX_PAYLOAD);
-	ASSERT(mfs <= FC_MAX_PAYLOAD);
+	WARN_ON(mfs > FC_MAX_PAYLOAD);
+	WARN_ON(mfs < FC_MIN_MAX_PAYLOAD);
 	if (mfs > 512)
 		mfs &= ~(512 - 1);	/* round down to block size */
-	ASSERT(mfs >= FC_MIN_MAX_PAYLOAD);	/* won't go below 256 */
-	ASSERT(len > 0);
+	WARN_ON(mfs < FC_MIN_MAX_PAYLOAD);	/* won't go below 256 */
+	WARN_ON(len <= 0);
 	sc = fsp->cmd;
 	if (sc->use_sg) {
 		sg = (struct scatterlist *)sc->request_buffer;
@@ -288,7 +287,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 	frame_offset = offset;
 	tlen = 0;
 	sp = fc_seq_start_next_fctl(sp, FC_FC_REL_OFF);
-	ASSERT(sp);
+	WARN_ON(!sp);
 
 	if (page_count(sg_page(sg)) == 0)
 		using_sg = 0;
@@ -320,7 +319,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 			 * because we can unpin the memory when the
 			 * status of this I/O is received
 			 */
-			ASSERT(fp->fr_sg_len < FC_FRAME_SG_LEN);
+			WARN_ON(fp->fr_sg_len > FC_FRAME_SG_LEN);
 			fsg = &fp->fr_sg[fp->fr_sg_len++];
 			sg_set_page(fsg, sg_page(sg),
 				    sg_bytes, sg->offset + offset);
@@ -355,11 +354,11 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 		}
 		fp = NULL;
 
-		ASSERT(!error);
 		if (error) {
 			/*
 			 * we need to handle this case -XXX
 			 */
+			WARN_ON(1);
 			openfc_scsi_retry(fsp);
 			return;
 		}
@@ -440,7 +439,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		 * received XFER RDY from the target
 		 * need to send data to the target
 		 */
-		ASSERT(!(fp->fr_flags & FCPHF_CRC_UNCHECKED));
+		WARN_ON(fp->fr_flags & FCPHF_CRC_UNCHECKED);
 		dd = fc_frame_payload_get(fp, sizeof(*dd));
 		WARN_ON(!dd);
 		fsp->state = OPENFC_SRB_IN_DATA_TRANS;
@@ -467,7 +466,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		 * received a DATA frame
 		 * next we will copy the data to the system buffer
 		 */
-		ASSERT(fp->fr_len >= sizeof(*fh));	/* len may be 0 */
+		WARN_ON(fp->fr_len < sizeof(*fh));	/* len may be 0 */
 		fsp->state = OPENFC_SRB_IN_DATA_TRANS;
 		openfc_scsi_recv_data(fsp, fp);
 
@@ -478,7 +477,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 		 */
 		spin_unlock(&qp->scsi_pkt_lock);
 	} else if (r_ctl == FC_RCTL_DD_CMD_STATUS) {
-		ASSERT(!(fp->fr_flags & FCPHF_CRC_UNCHECKED));
+		WARN_ON(fp->fr_flags & FCPHF_CRC_UNCHECKED);
 
 		/*
 		 * NULL out the outstanding cmd pointer.
@@ -725,7 +724,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		spin_unlock(&qp->scsi_pkt_lock);
 	}
 	diskp = fsp->disk;
-	ASSERT(fsp != NULL);
+
 	switch (event) {
 	case FC_EV_TIMEOUT:
 		/*
@@ -933,7 +932,6 @@ int openfc_target_reset(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 				goto out;
 			}
 			sc_cmd = (struct scsi_cmnd *)ofsp->cmd;
-			ASSERT(sc_cmd != NULL);
 			opid = pid;
 			otid = sc_cmd->device->id;
 			olun = sc_cmd->device->lun;

