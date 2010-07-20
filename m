From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/28] libfcoe: add protocol description of FIP VN2VN mode
Date: Tue, 20 Jul 2010 15:20:19 -0700
Message-ID: <20100720222019.17116.22128.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753Ab0GTWUU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:20 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The FC-BB-6 committee is proposing a new FIP usage model called
VN_port to VN_port mode.  It allows VN_ports to discover each other
over a loss-free L2 Ethernet without any FCF or Fibre-channel fabric
services.  This is point-to-multipoint.  There is also a variant
of this called point-to-point which provides for making sure there
is just one pair of ports operating over the Ethernet fabric.

This patch defines the new message type and subtypes as well as
one new descriptor type used by VN2VN mode.

These are all still at the proposed stage and subject to change.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/fc/fc_fip.h |   46 +++++++++++++++++++++++++++++++++++++++++++---
 include/scsi/fc/fc_ns.h  |    7 +++++++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/scsi/fc/fc_fip.h b/include/scsi/fc/fc_fip.h
index 17baa19..ae25d4a 100644
--- a/include/scsi/fc/fc_fip.h
+++ b/include/scsi/fc/fc_fip.h
@@ -17,9 +17,12 @@
 #ifndef _FC_FIP_H_
 #define _FC_FIP_H_
 
+#include <scsi/fc/fc_ns.h>
+
 /*
  * This version is based on:
  * http://www.t11.org/ftp/t11/pub/fc/bb-5/08-543v1.pdf
+ * and T11 FC-BB-6 10-019v4.pdf (June 2010 VN2VN proposal)
  */
 
 #define FIP_DEF_PRI	128	/* default selection priority */
@@ -29,11 +32,24 @@
 #define FIP_FCF_FUZZ	100	/* random time added by FCF (mS) */
 
 /*
+ * VN2VN proposed-standard values.
+ */
+#define FIP_VN_FC_MAP	0x0efd00 /* MAC OUI for VN2VN use */
+#define FIP_VN_PROBE_WAIT 100	/* interval between VN2VN probes (ms) */
+#define FIP_VN_ANN_WAIT 400	/* interval between VN2VN announcements (ms) */
+#define FIP_VN_RLIM_INT 10000	/* interval between probes when rate limited */
+#define FIP_VN_RLIM_COUNT 10	/* number of probes before rate limiting */
+#define FIP_VN_BEACON_INT 8000	/* interval between VN2VN beacons */
+#define FIP_VN_BEACON_FUZZ 100	/* random time to add to beacon period (ms) */
+
+/*
  * Multicast MAC addresses.  T11-adopted.
  */
-#define FIP_ALL_FCOE_MACS	((u8[6]) { 1, 0x10, 0x18, 1, 0, 0 })
-#define FIP_ALL_ENODE_MACS	((u8[6]) { 1, 0x10, 0x18, 1, 0, 1 })
-#define FIP_ALL_FCF_MACS	((u8[6]) { 1, 0x10, 0x18, 1, 0, 2 })
+#define FIP_ALL_FCOE_MACS	((__u8[6]) { 1, 0x10, 0x18, 1, 0, 0 })
+#define FIP_ALL_ENODE_MACS	((__u8[6]) { 1, 0x10, 0x18, 1, 0, 1 })
+#define FIP_ALL_FCF_MACS	((__u8[6]) { 1, 0x10, 0x18, 1, 0, 2 })
+#define FIP_ALL_VN2VN_MACS	((__u8[6]) { 1, 0x10, 0x18, 1, 0, 4 })
+#define FIP_ALL_P2P_MACS	((__u8[6]) { 1, 0x10, 0x18, 1, 0, 5 })
 
 #define FIP_VER		1		/* version for fip_header */
 
@@ -60,6 +76,7 @@ enum fip_opcode {
 	FIP_OP_LS =	2,		/* Link Service request or reply */
 	FIP_OP_CTRL =	3,		/* Keep Alive / Link Reset */
 	FIP_OP_VLAN =	4,		/* VLAN discovery */
+	FIP_OP_VN2VN =	5,		/* VN2VN operation */
 	FIP_OP_VENDOR_MIN = 0xfff8,	/* min vendor-specific opcode */
 	FIP_OP_VENDOR_MAX = 0xfffe,	/* max vendor-specific opcode */
 };
@@ -97,11 +114,23 @@ enum fip_vlan_subcode {
 };
 
 /*
+ * Subcodes for FIP_OP_VN2VN.
+ */
+enum fip_vn2vn_subcode {
+	FIP_SC_VN_PROBE_REQ = 1,	/* probe request */
+	FIP_SC_VN_PROBE_REP = 2,	/* probe reply */
+	FIP_SC_VN_CLAIM_NOTIFY = 3,	/* claim notification */
+	FIP_SC_VN_CLAIM_REP = 4,	/* claim response */
+	FIP_SC_VN_BEACON = 5,		/* beacon */
+};
+
+/*
  * flags in header fip_flags.
  */
 enum fip_flag {
 	FIP_FL_FPMA =	0x8000,		/* supports FPMA fabric-provided MACs */
 	FIP_FL_SPMA =	0x4000,		/* supports SPMA server-provided MACs */
+	FIP_FL_REC_OR_P2P = 0x0008,	/* configured addr or point-to-point */
 	FIP_FL_AVAIL =	0x0004,		/* available for FLOGI/ELP */
 	FIP_FL_SOL =	0x0002,		/* this is a solicited message */
 	FIP_FL_FPORT =	0x0001,		/* sent from an F port */
@@ -130,6 +159,7 @@ enum fip_desc_type {
 	FIP_DT_FKA =	12,		/* advertisement keep-alive period */
 	FIP_DT_VENDOR =	13,		/* vendor ID */
 	FIP_DT_VLAN =	14,		/* vlan number */
+	FIP_DT_FC4F =	15,		/* FC-4 features */
 	FIP_DT_LIMIT,			/* max defined desc_type + 1 */
 	FIP_DT_VENDOR_BASE = 128,	/* first vendor-specific desc_type */
 };
@@ -229,6 +259,16 @@ enum fip_fka_flags {
 /* FIP_DT_FKA flags */
 
 /*
+ * FIP_DT_FC4F - FC-4 features.
+ */
+struct fip_fc4_feat {
+	struct fip_desc fd_desc;
+	__u8		fd_resvd[2];
+	struct fc_ns_fts fd_fts;
+	struct fc_ns_ff	fd_ff;
+} __attribute__((packed));
+
+/*
  * FIP_DT_VENDOR descriptor.
  */
 struct fip_vendor_desc {
diff --git a/include/scsi/fc/fc_ns.h b/include/scsi/fc/fc_ns.h
index e7d3ac4..185015d 100644
--- a/include/scsi/fc/fc_ns.h
+++ b/include/scsi/fc/fc_ns.h
@@ -100,6 +100,13 @@ struct fc_ns_fts {
 };
 
 /*
+ * FC4-features object.
+ */
+struct fc_ns_ff	{
+	__be32	fd_feat[FC_NS_TYPES * 4 / FC_NS_BPW]; /* 4-bits per FC-type */
+};
+
+/*
  * GID_PT request.
  */
 struct fc_ns_gid_pt {

