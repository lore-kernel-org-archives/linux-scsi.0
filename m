From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] fc_fip: Update to latest FC-BB-6 draft
Date: Mon,  4 Jul 2016 10:29:18 +0200
Message-ID: <1467620963-67047-2-git-send-email-hare@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbcGDI3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:35 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Update to latest FC-BB-6 draft to include FIP VN2VN VLAN notifications
and additional flags.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |  8 ++++----
 drivers/scsi/fnic/fnic_fcs.c  |  4 ++--
 drivers/scsi/fnic/fnic_fip.h  |  8 --------
 include/scsi/fc/fc_fip.h      | 21 +++++++++++++++++----
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index ada4bde..34b2b43 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -991,7 +991,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
 					"in FIP adv\n", desc->fip_dtype);
 			/* standard says ignore unknown descriptors >= 128 */
-			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+			if (desc->fip_dtype < FIP_DT_NON_CRITICAL)
 				return -EINVAL;
 			break;
 		}
@@ -1232,7 +1232,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
 					"in FIP adv\n", desc->fip_dtype);
 			/* standard says ignore unknown descriptors >= 128 */
-			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+			if (desc->fip_dtype < FIP_DT_NON_CRITICAL)
 				goto drop;
 			if (desc_cnt <= 2) {
 				LIBFCOE_FIP_DBG(fip, "FIP descriptors "
@@ -1410,7 +1410,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 			break;
 		default:
 			/* standard says ignore unknown descriptors >= 128 */
-			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
+			if (desc->fip_dtype < FIP_DT_NON_CRITICAL)
 				goto err;
 			break;
 		}
@@ -2338,7 +2338,7 @@ static int fcoe_ctlr_vn_parse(struct fcoe_ctlr *fip,
 			LIBFCOE_FIP_DBG(fip, "unexpected descriptor type %x "
 					"in FIP probe\n", dtype);
 			/* standard says ignore unknown descriptors >= 128 */
-			if (dtype < FIP_DT_VENDOR_BASE)
+			if (dtype < FIP_DT_NON_CRITICAL)
 				return -EINVAL;
 			break;
 		}
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 67669a9..fe402d0 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -359,7 +359,7 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 
 	vlan->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
 	vlan->fip.fip_op = htons(FIP_OP_VLAN);
-	vlan->fip.fip_subcode = FIP_SC_VL_REQ;
+	vlan->fip.fip_subcode = FIP_SC_VL_NOTE;
 	vlan->fip.fip_dl_len = htons(sizeof(vlan->desc) / FIP_BPW);
 
 	vlan->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
@@ -551,7 +551,7 @@ static int fnic_fcoe_handle_fip_frame(struct fnic *fnic, struct sk_buff *skb)
 			goto drop;
 		/* pass it on to fcoe */
 		ret = 1;
-	} else if (op == FIP_OP_VLAN && sub == FIP_SC_VL_REP) {
+	} else if (op == FIP_OP_VLAN && sub == FIP_SC_VL_NOTE) {
 		/* set the vlan as used */
 		fnic_fcoe_process_vlan_resp(fnic, skb);
 		ret = 0;
diff --git a/drivers/scsi/fnic/fnic_fip.h b/drivers/scsi/fnic/fnic_fip.h
index 87e74c2..7761f33 100644
--- a/drivers/scsi/fnic/fnic_fip.h
+++ b/drivers/scsi/fnic/fnic_fip.h
@@ -26,14 +26,6 @@
 
 #define FINC_MAX_FLOGI_REJECTS   8
 
-/*
- * FIP_DT_VLAN descriptor.
- */
-struct fip_vlan_desc {
-	struct fip_desc fd_desc;
-	__be16 fd_vlan;
-} __attribute__((packed));
-
 struct vlan {
 	__be16 vid;
 	__be16 type;
diff --git a/include/scsi/fc/fc_fip.h b/include/scsi/fc/fc_fip.h
index ae25d4a..9710254 100644
--- a/include/scsi/fc/fc_fip.h
+++ b/include/scsi/fc/fc_fip.h
@@ -22,7 +22,7 @@
 /*
  * This version is based on:
  * http://www.t11.org/ftp/t11/pub/fc/bb-5/08-543v1.pdf
- * and T11 FC-BB-6 10-019v4.pdf (June 2010 VN2VN proposal)
+ * and T11 FC-BB-6 13-091v5.pdf (December 2013 VN2VN proposal)
  */
 
 #define FIP_DEF_PRI	128	/* default selection priority */
@@ -109,8 +109,9 @@ enum fip_reset_subcode {
  * Subcodes for FIP_OP_VLAN.
  */
 enum fip_vlan_subcode {
-	FIP_SC_VL_REQ =	1,		/* request */
-	FIP_SC_VL_REP =	2,		/* reply */
+	FIP_SC_VL_REQ =	1,		/* vlan request */
+	FIP_SC_VL_NOTE = 2,		/* vlan notification */
+	FIP_SC_VL_VN2VN_NOTE = 3,	/* VN2VN vlan notification */
 };
 
 /*
@@ -130,6 +131,8 @@ enum fip_vn2vn_subcode {
 enum fip_flag {
 	FIP_FL_FPMA =	0x8000,		/* supports FPMA fabric-provided MACs */
 	FIP_FL_SPMA =	0x4000,		/* supports SPMA server-provided MACs */
+	FIP_FL_FCF =	0x0020,		/* originated from a controlling FCF */
+	FIP_FL_FDF =	0x0010,		/* originated from an FDF */
 	FIP_FL_REC_OR_P2P = 0x0008,	/* configured addr or point-to-point */
 	FIP_FL_AVAIL =	0x0004,		/* available for FLOGI/ELP */
 	FIP_FL_SOL =	0x0002,		/* this is a solicited message */
@@ -161,7 +164,9 @@ enum fip_desc_type {
 	FIP_DT_VLAN =	14,		/* vlan number */
 	FIP_DT_FC4F =	15,		/* FC-4 features */
 	FIP_DT_LIMIT,			/* max defined desc_type + 1 */
-	FIP_DT_VENDOR_BASE = 128,	/* first vendor-specific desc_type */
+	FIP_DT_NON_CRITICAL = 128,	/* First non-critical descriptor */
+	FIP_DT_CLR_VLINKS = 128,	/* Clear virtual links reason code */
+	FIP_DT_VENDOR_BASE = 241,	/* first vendor-specific desc_type */
 };
 
 /*
@@ -259,6 +264,14 @@ enum fip_fka_flags {
 /* FIP_DT_FKA flags */
 
 /*
+ * FIP_DT_VLAN descriptor
+ */
+struct fip_vlan_desc {
+	struct fip_desc fd_desc;
+	__be16		fd_vlan; /* Note: highest 4 bytes are unused */
+} __attribute__((packed));
+
+/*
  * FIP_DT_FC4F - FC-4 features.
  */
 struct fip_fc4_feat {
-- 
1.8.5.6

