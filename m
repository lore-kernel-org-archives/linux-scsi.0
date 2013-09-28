From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 04/23] be2iscsi: Fix negotiated parameters upload to FW
Date: Sat, 28 Sep 2013 15:35:41 -0700
Message-ID: <1380407761-2949-4-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50620 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3I1WgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:20 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4018996pdi.5
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:20 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 - Removed the check of MaxXmitDSL == 0 as this is not a possible
 case.
 - Update connection offload data structure for SKH-R adapters.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    7 +++++--
 drivers/scsi/be2iscsi/be_main.h  |   29 ++++++++++++++++-------------
 drivers/scsi/be2iscsi/be_mgmt.c  |    8 +++-----
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2496ea7..f698f7a 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -672,8 +672,7 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 			session->max_burst = 262144;
 		break;
 	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		if ((conn->max_xmit_dlength > 65536) ||
-		    (conn->max_xmit_dlength == 0))
+		if (conn->max_xmit_dlength > 65536)
 			conn->max_xmit_dlength = 65536;
 	default:
 		return 0;
@@ -924,6 +923,10 @@ static void  beiscsi_set_params_for_offld(struct beiscsi_conn *beiscsi_conn,
 		      session->max_r2t);
 	AMAP_SET_BITS(struct amap_beiscsi_offload_params, exp_statsn, params,
 		      (conn->exp_statsn - 1));
+	AMAP_SET_BITS(struct amap_beiscsi_offload_params,
+		      max_recv_data_segment_length, params,
+		      conn->max_recv_dlength);
+
 }
 
 /**
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5165515..ec75c53 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -477,7 +477,7 @@ struct amap_iscsi_sge {
 };
 
 struct beiscsi_offload_params {
-	u32 dw[5];
+	u32 dw[6];
 };
 
 #define OFFLD_PARAMS_ERL	0x00000003
@@ -507,6 +507,7 @@ struct amap_beiscsi_offload_params {
 	u8 max_r2t[16];
 	u8 pad[8];
 	u8 exp_statsn[32];
+	u8 max_recv_data_segment_length[32];
 };
 
 /* void hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
@@ -888,30 +889,32 @@ struct amap_iscsi_target_context_update_wrb_v2 {
 	u8 first_burst_length[24]; /* DWORD 3 */
 	u8 rsvd3[8]; /* DOWRD 3 */
 	u8 max_r2t[16]; /* DWORD 4 */
-	u8 rsvd4[10];   /* DWORD 4 */
+	u8 rsvd4;       /* DWORD 4 */
 	u8 hde;         /* DWORD 4 */
 	u8 dde;         /* DWORD 4 */
 	u8 erl[2];      /* DWORD 4 */
+	u8 rsvd5[6];    /* DWORD 4 */
 	u8 imd;         /* DWORD 4 */
 	u8 ir2t;        /* DWORD 4 */
+	u8 rsvd6[3];    /* DWORD 4 */
 	u8 stat_sn[32];     /* DWORD 5 */
-	u8 rsvd5[32];   /* DWORD 6 */
-	u8 rsvd6[32];   /* DWORD 7 */
+	u8 rsvd7[32];   /* DWORD 6 */
+	u8 rsvd8[32];   /* DWORD 7 */
 	u8 max_recv_dataseg_len[24];    /* DWORD 8 */
-	u8 rsvd7[8]; /* DWORD 8 */
-	u8 rsvd8[32];   /* DWORD 9 */
-	u8 rsvd9[32];   /* DWORD 10 */
+	u8 rsvd9[8]; /* DWORD 8 */
+	u8 rsvd10[32];   /* DWORD 9 */
+	u8 rsvd11[32];   /* DWORD 10 */
 	u8 max_cxns[16]; /* DWORD 11 */
-	u8 rsvd10[11]; /* DWORD  11*/
+	u8 rsvd12[11]; /* DWORD  11*/
 	u8 invld; /* DWORD 11 */
-	u8 rsvd11;/* DWORD 11*/
+	u8 rsvd13;/* DWORD 11*/
 	u8 dmsg; /* DWORD 11 */
 	u8 data_seq_inorder; /* DWORD 11 */
 	u8 pdu_seq_inorder; /* DWORD 11 */
-	u8 rsvd12[32]; /*DWORD 12 */
-	u8 rsvd13[32]; /* DWORD 13 */
-	u8 rsvd14[32]; /* DWORD 14 */
-	u8 rsvd15[32]; /* DWORD 15 */
+	u8 rsvd14[32]; /*DWORD 12 */
+	u8 rsvd15[32]; /* DWORD 13 */
+	u8 rsvd16[32]; /* DWORD 14 */
+	u8 rsvd17[32]; /* DWORD 15 */
 } __packed;
 
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 245a959..2efad04 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1411,10 +1411,6 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 
 	memset(pwrb, 0, sizeof(*pwrb));
 
-	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
-		      max_burst_length, pwrb, params->dw[offsetof
-		      (struct amap_beiscsi_offload_params,
-		      max_burst_length) / 32]);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
 		      max_burst_length, pwrb, params->dw[offsetof
 		      (struct amap_beiscsi_offload_params,
@@ -1436,7 +1432,9 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 		      params->dw[offsetof(struct amap_beiscsi_offload_params,
 		      first_burst_length) / 32]);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
-		      max_recv_dataseg_len, pwrb, BEISCSI_MAX_RECV_DATASEG_LEN);
+		      max_recv_dataseg_len, pwrb,
+		      params->dw[offsetof(struct amap_beiscsi_offload_params,
+		      max_recv_data_segment_length) / 32]);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
 		      max_cxns, pwrb, BEISCSI_MAX_CXNS);
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2, erl, pwrb,
-- 
1.7.10.4

