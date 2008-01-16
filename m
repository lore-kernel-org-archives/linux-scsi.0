From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH] [FCoE] Bug in calling sg_set_page()
Date: Wed, 16 Jan 2008 11:09:37 -0800
Message-ID: <20080116190936.3060.27051.stgit@zydesk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50685 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYAPTP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 14:15:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Offset and length are not correctly passed to sg_set_page().

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/openfc/openfc_scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 29d5cc8..63242be 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -322,8 +322,8 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 			 */
 			ASSERT(fp->fr_sg_len < FC_FRAME_SG_LEN);
 			fsg = &fp->fr_sg[fp->fr_sg_len++];
-			sg_set_page(fsg, sg_page(sg), sg->offset + offset,
-				    sg_bytes);
+			sg_set_page(fsg, sg_page(sg),
+				    sg_bytes, sg->offset + offset);
 		} else {
 			u_int off = offset + sg->offset;
 

