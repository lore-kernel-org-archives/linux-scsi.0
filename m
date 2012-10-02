From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/4] target: Add control CDB READ payload zero work-around
Date: Tue,  2 Oct 2012 21:16:57 +0000
Message-ID: <1349212618-348-4-git-send-email-nab@linux-iscsi.org>
References: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38194 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab2JBVWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 17:22:21 -0400
In-Reply-To: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch carries forward a work-around from tcm_loop to target
core code to explicitly clear control CDB READ paylods in order to
avoid bugs in scsi-generic user-space code for INQUIRY that do not
explicitly zero CDB payload memory.

(v2: Drop TARGET_SCF_MAP_CLEAR_MEM, and perform the explicit zero
     of READ memory for all target_submit_cmd_map_sgls users)

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d96d9aa..c33baff 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1539,6 +1539,27 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (sgl_count != 0) {
 		BUG_ON(!sgl);
 
+		/*
+		 * A work-around for tcm_loop as some userspace code via
+		 * scsi-generic do not memset their associated read buffers,
+		 * so go ahead and do that here for type non-data CDBs.  Also
+		 * note that this is currently guaranteed to be a single SGL
+		 * for this case by target core in target_setup_cmd_from_cdb()
+		 * -> transport_generic_cmd_sequencer().
+		 */
+		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
+		     se_cmd->data_direction == DMA_FROM_DEVICE) {
+			unsigned char *buf = NULL;
+
+			if (sgl)
+				buf = kmap(sg_page(sgl)) + sgl->offset;
+
+			if (buf) {
+				memset(buf, 0, sgl->length);
+				kunmap(sg_page(sgl));
+			}
+		}
+
 		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
 				sgl_bidi, sgl_bidi_count);
 		if (rc != 0) {
-- 
1.7.2.5

