From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] target_core_spc: Include target device descriptor in VPD page 83
Date: Tue, 17 Dec 2013 09:18:48 +0100
Message-ID: <1387268330-121064-7-git-send-email-hare@suse.de>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387268330-121064-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

We should be including a descriptor referring to the target device
to allow identification of different TCM instances.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_spc.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 603c411..39054d9 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -267,7 +267,7 @@ check_t10_vend_desc:
 	port = lun->lun_sep;
 	if (port) {
 		struct t10_alua_lu_gp *lu_gp;
-		u32 padding, scsi_name_len;
+		u32 padding, scsi_name_len, scsi_target_len;
 		u16 lu_gp_id = 0;
 		u16 tg_pt_gp_id = 0;
 		u16 tpgt;
@@ -402,6 +402,47 @@ check_scsi_name:
 		off += scsi_name_len;
 		/* Header size + Designation descriptor */
 		len += (scsi_name_len + 4);
+
+		/*
+		 * Target device designator
+		 */
+		buf[off] =
+			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
+		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
+		buf[off] = 0x80; /* Set PIV=1 */
+		/* Set ASSOCIATION == target device: 10b */
+		buf[off] |= 0x20;
+		/* DESIGNATOR TYPE == SCSI name string */
+		buf[off++] |= 0x8;
+		off += 2; /* Skip over Reserved and length */
+		/*
+		 * SCSI name string identifer containing, $FABRIC_MOD
+		 * dependent information.  For LIO-Target and iSCSI
+		 * Target Port, this means "<iSCSI name>" in
+		 * UTF-8 encoding.
+		 */
+		scsi_target_len = sprintf(&buf[off], "%s",
+					  tpg->se_tpg_tfo->tpg_get_wwn(tpg));
+		scsi_target_len += 1 /* Include  NULL terminator */;
+		/*
+		 * The null-terminated, null-padded (see 4.4.2) SCSI
+		 * NAME STRING field contains a UTF-8 format string.
+		 * The number of bytes in the SCSI NAME STRING field
+		 * (i.e., the value in the DESIGNATOR LENGTH field)
+		 * shall be no larger than 256 and shall be a multiple
+		 * of four.
+		 */
+		padding = ((-scsi_target_len) & 3);
+		if (padding)
+			scsi_target_len += padding;
+		if (scsi_name_len > 256)
+			scsi_name_len = 256;
+
+		buf[off-1] = scsi_target_len;
+		off += scsi_target_len;
+
+		/* Header size + Designation descriptor */
+		len += (scsi_target_len + 4);
 	}
 	buf[2] = ((len >> 8) & 0xff);
 	buf[3] = (len & 0xff); /* Page Length for VPD 0x83 */
-- 
1.7.12.4
