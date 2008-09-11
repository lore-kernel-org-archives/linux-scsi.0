From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 2/4] 24-bit types: convert iSCSI to use the __be24 type and
	macros
Date: Wed, 10 Sep 2008 19:14:54 -0700
Message-ID: <20080911021454.23621.192.stgit@localhost.localdomain>
References: <20080911021448.23621.42553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYIKCPB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 22:15:01 -0400
In-Reply-To: <20080911021448.23621.42553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Harvey Harrison <harvey.harrison@gmail.com>, Chris Leech <christopher.leech@intel.com>, Mike Christie <michaelc@cs.wisc.edu>

The calling convention of hton24 is different now, it takes a single u32
as an argument and evaluates to a __be24 lvalue.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---

 drivers/scsi/iscsi_tcp.c   |    8 ++++----
 drivers/scsi/libiscsi.c    |    6 +++---
 include/scsi/iscsi_proto.h |   46 ++++++++++++++++++--------------------------
 3 files changed, 26 insertions(+), 34 deletions(-)


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2a2f009..c9d6e96 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -608,11 +608,11 @@ iscsi_solicit_data_init(struct iscsi_conn *conn, struct iscsi_task *task,
 	hdr->exp_statsn = r2t->exp_statsn;
 	hdr->offset = cpu_to_be32(r2t->data_offset);
 	if (r2t->data_length > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
+		hdr->dlength = hton24(conn->max_xmit_dlength);
 		r2t->data_count = conn->max_xmit_dlength;
 		hdr->flags = 0;
 	} else {
-		hton24(hdr->dlength, r2t->data_length);
+		hdr->dlength = hton24(r2t->data_length);
 		r2t->data_count = r2t->data_length;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
@@ -1311,10 +1311,10 @@ iscsi_solicit_data_cont(struct iscsi_conn *conn, struct iscsi_task *task,
 	new_offset = r2t->data_offset + r2t->sent;
 	hdr->offset = cpu_to_be32(new_offset);
 	if (left > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
+		hdr->dlength = hton24(conn->max_xmit_dlength);
 		r2t->data_count = conn->max_xmit_dlength;
 	} else {
-		hton24(hdr->dlength, left);
+		hdr->dlength = hton24(left);
 		r2t->data_count = left;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 299e075..8432318 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -105,12 +105,12 @@ void iscsi_prep_unsolicit_data_pdu(struct iscsi_task *task,
 	hdr->offset = cpu_to_be32(task->unsol_offset);
 
 	if (task->unsol_count > conn->max_xmit_dlength) {
-		hton24(hdr->dlength, conn->max_xmit_dlength);
+		hdr->dlength = hton24(conn->max_xmit_dlength);
 		task->data_count = conn->max_xmit_dlength;
 		task->unsol_offset += task->data_count;
 		hdr->flags = 0;
 	} else {
-		hton24(hdr->dlength, task->unsol_count);
+		hdr->dlength = hton24(task->unsol_count);
 		task->data_count = task->unsol_count;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
@@ -269,7 +269,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			else
 				task->imm_count = min(out_len,
 							conn->max_xmit_dlength);
-			hton24(hdr->dlength, task->imm_count);
+			hdr->dlength = hton24(task->imm_count);
 		} else
 			zero_data(hdr->dlength);
 
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 429c5ff..a778097 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -35,15 +35,7 @@
 /*
  * useful common(control and data pathes) macro
  */
-#undef ntoh24
-#undef hton24
-#define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
-#define hton24(p, v) { \
-        p[0] = (((v) >> 16) & 0xFF); \
-        p[1] = (((v) >> 8) & 0xFF); \
-        p[2] = ((v) & 0xFF); \
-}
-#define zero_data(p) {p[0]=0;p[1]=0;p[2]=0;}
+#define zero_data(x) (x) = (__be24) { .b = { 0, 0, 0 } }
 
 /* initiator tags; opaque for target */
 typedef uint32_t __bitwise__ itt_t;
@@ -61,7 +53,7 @@ struct iscsi_hdr {
 	uint8_t		flags;		/* Final bit */
 	uint8_t		rsvd2[2];
 	uint8_t		hlength;	/* AHSs total length */
-	uint8_t		dlength[3];	/* Data length */
+	__be24		dlength;	/* Data length */
 	uint8_t		lun[8];
 	itt_t		itt;		/* Initiator Task Tag, opaque for target */
 	__be32		ttt;		/* Target Task Tag */
@@ -123,7 +115,7 @@ struct iscsi_cmd {
 	uint8_t flags;
 	__be16 rsvd2;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32 data_length;
@@ -169,7 +161,7 @@ struct iscsi_cmd_rsp {
 	uint8_t response;
 	uint8_t cmd_status;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	rsvd1;
@@ -199,7 +191,7 @@ struct iscsi_async {
 	uint8_t flags;
 	uint8_t rsvd2[2];
 	uint8_t rsvd3;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	uint8_t rsvd4[8];
 	__be32	statsn;
@@ -227,7 +219,7 @@ struct iscsi_nopout {
 	uint8_t flags;
 	__be16	rsvd2;
 	uint8_t rsvd3;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
@@ -242,7 +234,7 @@ struct iscsi_nopin {
 	uint8_t flags;
 	__be16	rsvd2;
 	uint8_t rsvd3;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
@@ -258,7 +250,7 @@ struct iscsi_tm {
 	uint8_t flags;
 	uint8_t rsvd1[2];
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	itt_t	 rtt;	/* Reference Task Tag */
@@ -288,7 +280,7 @@ struct iscsi_tm_rsp {
 	uint8_t response;	/* see Response values below */
 	uint8_t qualifier;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd2[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	itt_t	 rtt;	/* Reference Task Tag */
@@ -314,7 +306,7 @@ struct iscsi_r2t_rsp {
 	uint8_t flags;
 	uint8_t rsvd2[2];
 	uint8_t	hlength;
-	uint8_t	dlength[3];
+	__be24	dlength;
 	uint8_t lun[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
@@ -332,7 +324,7 @@ struct iscsi_data {
 	uint8_t flags;
 	uint8_t rsvd2[2];
 	uint8_t rsvd3;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;
 	__be32	ttt;
@@ -352,7 +344,7 @@ struct iscsi_data_rsp {
 	uint8_t rsvd2;
 	uint8_t cmd_status;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t lun[8];
 	itt_t	 itt;
 	__be32	ttt;
@@ -376,7 +368,7 @@ struct iscsi_text {
 	uint8_t flags;
 	uint8_t rsvd2[2];
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd4[8];
 	itt_t	 itt;
 	__be32	ttt;
@@ -394,7 +386,7 @@ struct iscsi_text_rsp {
 	uint8_t flags;
 	uint8_t rsvd2[2];
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd4[8];
 	itt_t	 itt;
 	__be32	ttt;
@@ -412,7 +404,7 @@ struct iscsi_login {
 	uint8_t max_version;	/* Max. version supported */
 	uint8_t min_version;	/* Min. version supported */
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t isid[6];	/* Initiator Session ID */
 	__be16	tsih;	/* Target Session Handle */
 	itt_t	 itt;	/* Initiator Task Tag */
@@ -441,7 +433,7 @@ struct iscsi_login_rsp {
 	uint8_t max_version;	/* Max. version supported */
 	uint8_t active_version;	/* Active version */
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t isid[6];	/* Initiator Session ID */
 	__be16	tsih;	/* Target Session Handle */
 	itt_t	 itt;	/* Initiator Task Tag */
@@ -499,7 +491,7 @@ struct iscsi_logout {
 	uint8_t flags;
 	uint8_t rsvd1[2];
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd2[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be16	cid;
@@ -526,7 +518,7 @@ struct iscsi_logout_rsp {
 	uint8_t response;	/* see Logout response values below */
 	uint8_t rsvd2;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd3[8];
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	rsvd4;
@@ -570,7 +562,7 @@ struct iscsi_reject {
 	uint8_t reason;
 	uint8_t rsvd2;
 	uint8_t hlength;
-	uint8_t dlength[3];
+	__be24 dlength;
 	uint8_t rsvd3[8];
 	__be32  ffffffff;
 	uint8_t rsvd4[4];

