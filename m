From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] Fix compile warnings on x86_64 caused by OFC_DBG
Date: Mon, 14 Jan 2008 15:25:27 -0800
Message-ID: <20080114232527.25270.24964.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYANXt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 18:49:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/fcoe/fcoe_dev.c      |   10 ++++++----
 drivers/scsi/ofc/libfc/fc_print.c     |    2 +-
 drivers/scsi/ofc/libfc/fcs_state.c    |    4 ++--
 drivers/scsi/ofc/libsa/sa_state.c     |   14 +++++++-------
 drivers/scsi/ofc/openfc/openfc_scsi.c |    6 +++---
 5 files changed, 19 insertions(+), 17 deletions(-)


diff --git a/drivers/scsi/ofc/fcoe/fcoe_dev.c b/drivers/scsi/ofc/fcoe/fcoe_dev.c
index a05c31e..6b263f1 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_dev.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_dev.c
@@ -93,7 +93,8 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (unlikely(debug_fcoe)) {
 		OFC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
 		       "end:%p sum:%d dev:%s", skb->len, skb->data_len,
-		       skb->head, skb->data, skb->tail, skb->end, skb->csum,
+			skb->head, skb->data, skb_tail_pointer(skb), 
+			skb_end_pointer(skb), skb->csum,
 		       skb->dev ? skb->dev->name : "<NULL>");
 
 	}
@@ -464,9 +465,10 @@ int fcoe_percpu_receive_thread(void *arg)
 		if (unlikely(debug_fcoe)) {
 			OFC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
 			       "tail:%p end:%p sum:%d dev:%s",
-			       skb->len, skb->data_len,
-			       skb->head, skb->data, skb->tail, skb->end,
-			       skb->csum, skb->dev ? skb->dev->name : "<NULL>");
+				skb->len, skb->data_len,
+				skb->head, skb->data, skb_tail_pointer(skb), 
+				skb_end_pointer(skb), skb->csum, 
+				skb->dev ? skb->dev->name : "<NULL>");
 		}
 
 		/*
diff --git a/drivers/scsi/ofc/libfc/fc_print.c b/drivers/scsi/ofc/libfc/fc_print.c
index e21b4a0..ae6fa1e 100644
--- a/drivers/scsi/ofc/libfc/fc_print.c
+++ b/drivers/scsi/ofc/libfc/fc_print.c
@@ -74,7 +74,7 @@ void fc_print_frame_hdr(const char *msg, const struct fc_frame *fp)
 	op = (u_char *) (fh + 1);
 
 	if (len < sizeof(*fh)) {
-		OFC_DBG("dump_frame: %s: short frame: len 0x%d\n", msg, len);
+		OFC_DBG("dump_frame: %s: short frame: len 0x%zx\n", msg, len);
 	} else if (fc_print_verbose) {
 		fc_print_lookup(fh->fh_r_ctl, r_ctl, sizeof(r_ctl),
 				fc_print_rctls, sizeof(fc_print_rctls));
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index d970ac9..794f440 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -108,11 +108,11 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	outer_port = ap->fca_port;
 	mfs = fc_port_get_max_frame_size(outer_port);
 	if (mfs < FC_MIN_MAX_PAYLOAD) {
-		OFC_DBG("port max frame size only %d (0x%x) bytes - "
+		OFC_DBG("port max frame size only %zx (0x%zx) bytes - "
 		       "setting to %d", mfs, mfs, FC_MIN_MAX_PAYLOAD);
 		mfs = 1024;
 	} else if (mfs > FC_MAX_PAYLOAD + sizeof(struct fc_frame_header)) {
-		OFC_DBG("port max frame size too large: %d (0x%x) bytes\n",
+		OFC_DBG("port max frame size too large: %zx (0x%zx) bytes\n",
 		       mfs, mfs);
 		mfs = FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
 	}
diff --git a/drivers/scsi/ofc/libsa/sa_state.c b/drivers/scsi/ofc/libsa/sa_state.c
index 732d26d..815e703 100644
--- a/drivers/scsi/ofc/libsa/sa_state.c
+++ b/drivers/scsi/ofc/libsa/sa_state.c
@@ -113,7 +113,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		case SST_STATE:
 			if (dp->sd_in == 0) {
 				OFC_DBG("state table %s has invalid state %d "
-				       "at STATE entry %d",
+				       "at STATE entry %ld",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
@@ -124,7 +124,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		case SST_FROM:
 			if (dp->sd_in == 0) {
 				OFC_DBG("state table %s has invalid state %d "
-				       "at FROM entry %d",
+				       "at FROM entry %ld",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
@@ -133,7 +133,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		case SST_EVENT:
 			if (dp->sd_in == 0) {
 				OFC_DBG("state table %s has invalid event %d "
-				       "at EVENT entry %d",
+				       "at EVENT entry %ld",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
@@ -143,7 +143,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		case SST_HANDLER:
 			if (dp->sd_ptr == NULL) {
 				OFC_DBG("state table %s has invalid hander %d "
-				       "at HANDLER entry %d",
+				       "at HANDLER entry %ld",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
@@ -153,19 +153,19 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		case SST_NEXT:
 			if (cur_state == 0) {
 				OFC_DBG("state table %s has no current state "
-				       "for NEXT entry %d",
+				       "for NEXT entry %ld",
 				       name, dp - state_desc);
 				error++;
 			}
 			if (dp->sd_in >= event_limit) {
 				OFC_DBG("state table %s has event %d "
-				       "out of range at NEXT entry %d",
+				       "out of range at NEXT entry %ld",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
 			if (dp->sd_next == 0 || dp->sd_next >= state_limit) {
 				OFC_DBG("state table %s has state %d "
-				       "out of range at NEXT entry %d",
+				       "out of range at NEXT entry %ld",
 				       name, dp->sd_next, dp - state_desc);
 				error++;
 			}
diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 29d5cc8..7785875 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -123,7 +123,7 @@ static void openfc_scsi_recv_data(struct fc_scsi_pkt *fsp, struct fc_frame *fp)
 		if (openfc_debug) {
 			OFC_DBG("data received past end.	 "
 			       "len %zx offset %zx "
-			       "data_len %zx\n", len, offset, fsp->data_len);
+			       "data_len %x\n", len, offset, fsp->data_len);
 		}
 		openfc_scsi_retry(fsp);
 		return;
@@ -513,7 +513,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 					} else {
 						OFC_DBG("xfer len less then "
 						       "data_len xfer-len %zx"
-						       " len %zx \n",
+						       " len %x \n",
 						       fsp->xfer_len,
 						       fsp->data_len);
 						fsp->status_code =
@@ -530,7 +530,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 					} else {
 						OFC_DBG("xfer len greater than "
 						       "data_len xfer-len %zx"
-						       " len %zx \n",
+						       " len %x \n",
 						       fsp->xfer_len,
 						       fsp->data_len);
 						fsp->status_code =

