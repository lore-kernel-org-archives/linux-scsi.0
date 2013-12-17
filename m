From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/8] target_core: simplify scsi_name_len calculation
Date: Tue, 17 Dec 2013 09:18:47 +0100
Message-ID: <1387268330-121064-6-git-send-email-hare@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387268330-121064-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

scsi_name_len in spc_emulate_evpd_83 is calculated twice, with
the results of the first calculation discarded. So remove it.
And check for the maximum allowed length, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_spc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 021c3f4..603c411 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -365,16 +365,6 @@ check_lu_gp:
 		 * section 7.5.1 Table 362
 		 */
 check_scsi_name:
-		scsi_name_len = strlen(tpg->se_tpg_tfo->tpg_get_wwn(tpg));
-		/* UTF-8 ",t,0x<16-bit TPGT>" + NULL Terminator */
-		scsi_name_len += 10;
-		/* Check for 4-byte padding */
-		padding = ((-scsi_name_len) & 3);
-		if (padding != 0)
-			scsi_name_len += padding;
-		/* Header size + Designation descriptor */
-		scsi_name_len += 4;
-
 		buf[off] =
 			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
@@ -402,8 +392,11 @@ check_scsi_name:
 		 * shall be no larger than 256 and shall be a multiple
 		 * of four.
 		 */
+		padding = ((-scsi_name_len) & 3);
 		if (padding)
 			scsi_name_len += padding;
+		if (scsi_name_len > 256)
+			scsi_name_len = 256;
 
 		buf[off-1] = scsi_name_len;
 		off += scsi_name_len;
-- 
1.7.12.4
