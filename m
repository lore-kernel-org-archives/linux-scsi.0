From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH] OpenFCoE: additional patch for using scatterlist in 2.6.24.
Date: Mon, 10 Dec 2007 17:27:57 -0800
Message-ID: <20071211012714.27651.69486.stgit@yzou2-DESK.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXLKB27 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2007 20:28:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use sg_next() to walk the list instead of doing sg++ and sg_limit.

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/openfc/openfc_scsi.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 86e6895..031d32d 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -181,7 +181,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 	struct scsi_cmnd *sc;
 	struct scatterlist *fsg;
 	struct scatterlist *sg;
-	struct scatterlist *sg_limit;
+	u_int nsg;
 	struct scatterlist local_sg;
 	struct fc_frame *fp = NULL;
 	struct openfc_softc *openfcp = fsp->openfcp;
@@ -226,12 +226,12 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 	sc = fsp->cmd;
 	if (sc->use_sg) {
 		sg = (struct scatterlist *)sc->request_buffer;
-		sg_limit = sg + sc->use_sg;
+		nsg = sc->use_sg;
 	} else {
 		/* this should not happen */
 		sg_init_one(&local_sg, sc->request_buffer, sc->request_bufflen);
 		sg = &local_sg;
-		sg_limit = sg + 1;
+		nsg = 1;
 	}
 	remaining = len;
 	frame_offset = offset;
@@ -242,10 +242,11 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 	if (page_count(sg_page(sg)) == 0)
 		using_sg = 0;
 
-	while (remaining > 0 && sg < sg_limit) {
+	while (remaining > 0 && nsg > 0) {
 		if (offset >= sg->length) {
 			offset -= sg->length;
-			sg++;
+			sg = sg_next(sg);
+			nsg--;
 			continue;
 		}
 		if (!fp) {
@@ -270,9 +271,8 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 			 */
 			ASSERT(fp->fr_sg_len < FC_FRAME_SG_LEN);
 			fsg = &fp->fr_sg[fp->fr_sg_len++];
-			fsg->page_link = sg->page_link;
-			fsg->offset = sg->offset + offset;
-			fsg->length = sg_bytes;
+			sg_set_page(fsg, sg_page(sg), sg->offset + offset,
+				    sg_bytes);
 		} else {
 			u_int off = offset + sg->offset;
 
@@ -762,7 +762,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 int openfc_cp_to_user(struct fc_scsi_pkt *fsp, uint offset, void *buf, int len)
 {
 	struct scatterlist *sg;
-	struct scatterlist *sg_limit;
+	u_int nsg;
 	u_int32_t remaining, sg_bytes;
 	u_int32_t copy_len = 0;
 	u_int off;
@@ -772,13 +772,14 @@ int openfc_cp_to_user(struct fc_scsi_pkt *fsp, uint offset, void *buf, int len)
 	sc = fsp->cmd;
 
 	sg = (struct scatterlist *)sc->request_buffer;
-	sg_limit = sg + sc->use_sg;
+	nsg = sc->use_sg;
 	remaining = len;
 
-	while (remaining > 0 && sg < sg_limit) {
+	while (remaining > 0 && nsg > 0) {
 		if (offset >= sg->length) {
 			offset -= sg->length;
-			sg++;
+			sg = sg_next(sg);
+			nsg--;
 			continue;
 		}
 		sg_bytes = min(remaining, sg->length - offset);
