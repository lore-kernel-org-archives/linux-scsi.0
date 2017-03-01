From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH 3/3] uapi: fix scsi/scsi_bsg_fc.h userspace compilation errors
Date: Wed, 1 Mar 2017 03:12:38 +0300
Message-ID: <20170301001238.GD11188@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Include <linux/types.h> and consistently use types it provides
to fix the following scsi/scsi_bsg_fc.h userspace compilation errors:

/usr/include/scsi/scsi_bsg_fc.h:83:2: error: unknown type name 'uint8_t'
  uint8_t  reserved;
/usr/include/scsi/scsi_bsg_fc.h:86:2: error: unknown type name 'uint8_t'
  uint8_t  port_id[3];
/usr/include/scsi/scsi_bsg_fc.h:104:2: error: unknown type name 'uint8_t'
  uint8_t  reserved;
/usr/include/scsi/scsi_bsg_fc.h:107:2: error: unknown type name 'uint8_t'
  uint8_t  port_id[3];
/usr/include/scsi/scsi_bsg_fc.h:128:2: error: unknown type name 'uint8_t'
  uint8_t  command_code;
/usr/include/scsi/scsi_bsg_fc.h:131:2: error: unknown type name 'uint8_t'
  uint8_t  port_id[3];
/usr/include/scsi/scsi_bsg_fc.h:168:2: error: unknown type name 'uint32_t'
  uint32_t status;  /* See FC_CTELS_STATUS_xxx */
/usr/include/scsi/scsi_bsg_fc.h:172:3: error: unknown type name 'uint8_t'
   uint8_t action;  /* fragment_id for CT REJECT */
/usr/include/scsi/scsi_bsg_fc.h:173:3: error: unknown type name 'uint8_t'
   uint8_t reason_code;
/usr/include/scsi/scsi_bsg_fc.h:174:3: error: unknown type name 'uint8_t'
   uint8_t reason_explanation;
/usr/include/scsi/scsi_bsg_fc.h:175:3: error: unknown type name 'uint8_t'
   uint8_t vendor_unique;
/usr/include/scsi/scsi_bsg_fc.h:191:2: error: unknown type name 'uint8_t'
  uint8_t  reserved;
/usr/include/scsi/scsi_bsg_fc.h:194:2: error: unknown type name 'uint8_t'
  uint8_t  port_id[3];
/usr/include/scsi/scsi_bsg_fc.h:199:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word0; /* revision & IN_ID */
/usr/include/scsi/scsi_bsg_fc.h:200:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word1; /* GS_Type, GS_SubType, Options, Rsvd */
/usr/include/scsi/scsi_bsg_fc.h:201:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word2; /* Cmd Code, Max Size */
/usr/include/scsi/scsi_bsg_fc.h:221:2: error: unknown type name 'uint64_t'
  uint64_t vendor_id;
/usr/include/scsi/scsi_bsg_fc.h:224:2: error: unknown type name 'uint32_t'
  uint32_t vendor_cmd[0];
/usr/include/scsi/scsi_bsg_fc.h:231:2: error: unknown type name 'uint32_t'
  uint32_t vendor_rsp[0];
/usr/include/scsi/scsi_bsg_fc.h:250:2: error: unknown type name 'uint8_t'
  uint8_t els_code;
/usr/include/scsi/scsi_bsg_fc.h:268:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word0; /* revision & IN_ID */
/usr/include/scsi/scsi_bsg_fc.h:269:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word1; /* GS_Type, GS_SubType, Options, Rsvd */
/usr/include/scsi/scsi_bsg_fc.h:270:2: error: unknown type name 'uint32_t'
  uint32_t preamble_word2; /* Cmd Code, Max Size */
/usr/include/scsi/scsi_bsg_fc.h:282:2: error: unknown type name 'uint32_t'
  uint32_t msgcode;
/usr/include/scsi/scsi_bsg_fc.h:306:2: error: unknown type name 'uint32_t'
  uint32_t result;
/usr/include/scsi/scsi_bsg_fc.h:309:2: error: unknown type name 'uint32_t'
  uint32_t reply_payload_rcv_len;

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/scsi/scsi_bsg_fc.h | 54 +++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
index 3031b90..2b0b851 100644
--- a/include/uapi/scsi/scsi_bsg_fc.h
+++ b/include/uapi/scsi/scsi_bsg_fc.h
@@ -22,6 +22,8 @@
 #ifndef SCSI_BSG_FC_H
 #define SCSI_BSG_FC_H
 
+#include <linux/types.h>
+
 /*
  * This file intended to be included by both kernel and user space
  */
@@ -80,10 +82,10 @@
  * with the transport upon completion of the login.
  */
 struct fc_bsg_host_add_rport {
-	uint8_t		reserved;
+	__u8	reserved;
 
 	/* FC Address Identier of the remote port to login to */
-	uint8_t		port_id[3];
+	__u8	port_id[3];
 };
 
 /* Response:
@@ -101,10 +103,10 @@ struct fc_bsg_host_add_rport {
  * remain logged in with the remote port.
  */
 struct fc_bsg_host_del_rport {
-	uint8_t		reserved;
+	__u8	reserved;
 
 	/* FC Address Identier of the remote port to logout of */
-	uint8_t		port_id[3];
+	__u8	port_id[3];
 };
 
 /* Response:
@@ -125,10 +127,10 @@ struct fc_bsg_host_els {
 	 * ELS Command Code being sent (must be the same as byte 0
 	 * of the payload)
 	 */
-	uint8_t 	command_code;
+	__u8	command_code;
 
 	/* FC Address Identier of the remote port to send the ELS to */
-	uint8_t		port_id[3];
+	__u8	port_id[3];
 };
 
 /* Response:
@@ -165,14 +167,14 @@ struct fc_bsg_ctels_reply {
 	 * Note: x_RJT/BSY status will indicae that the rjt_data field
 	 *   is valid and contains the reason/explanation values.
 	 */
-	uint32_t	status;		/* See FC_CTELS_STATUS_xxx */
+	__u32	status;			/* See FC_CTELS_STATUS_xxx */
 
 	/* valid if status is not FC_CTELS_STATUS_OK */
 	struct	{
-		uint8_t	action;		/* fragment_id for CT REJECT */
-		uint8_t	reason_code;
-		uint8_t	reason_explanation;
-		uint8_t	vendor_unique;
+		__u8	action;		/* fragment_id for CT REJECT */
+		__u8	reason_code;
+		__u8	reason_explanation;
+		__u8	vendor_unique;
 	} rjt_data;
 };
 
@@ -188,17 +190,17 @@ struct fc_bsg_ctels_reply {
  * and whether to tear it down after the request.
  */
 struct fc_bsg_host_ct {
-	uint8_t		reserved;
+	__u8	reserved;
 
 	/* FC Address Identier of the remote port to send the ELS to */
-	uint8_t		port_id[3];
+	__u8	port_id[3];
 
 	/*
 	 * We need words 0-2 of the generic preamble for the LLD's
 	 */
-	uint32_t	preamble_word0;	/* revision & IN_ID */
-	uint32_t	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
-	uint32_t	preamble_word2;	/* Cmd Code, Max Size */
+	__u32	preamble_word0;	/* revision & IN_ID */
+	__u32	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
+	__u32	preamble_word2;	/* Cmd Code, Max Size */
 
 };
 /* Response:
@@ -218,17 +220,17 @@ struct fc_bsg_host_vendor {
 	 * Identifies the vendor that the message is formatted for. This
 	 * should be the recipient of the message.
 	 */
-	uint64_t vendor_id;
+	__u64	vendor_id;
 
 	/* start of vendor command area */
-	uint32_t vendor_cmd[0];
+	__u32	vendor_cmd[0];
 };
 
 /* Response:
  */
 struct fc_bsg_host_vendor_reply {
 	/* start of vendor response area */
-	uint32_t vendor_rsp[0];
+	__u32	vendor_rsp[0];
 };
 
 
@@ -247,7 +249,7 @@ struct fc_bsg_rport_els {
 	 * ELS Command Code being sent (must be the same as
 	 * byte 0 of the payload)
 	 */
-	uint8_t els_code;
+	__u8	els_code;
 };
 
 /* Response:
@@ -265,9 +267,9 @@ struct fc_bsg_rport_ct {
 	/*
 	 * We need words 0-2 of the generic preamble for the LLD's
 	 */
-	uint32_t	preamble_word0;	/* revision & IN_ID */
-	uint32_t	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
-	uint32_t	preamble_word2;	/* Cmd Code, Max Size */
+	__u32	preamble_word0;	/* revision & IN_ID */
+	__u32	preamble_word1;	/* GS_Type, GS_SubType, Options, Rsvd */
+	__u32	preamble_word2;	/* Cmd Code, Max Size */
 };
 /* Response:
  *
@@ -279,7 +281,7 @@ struct fc_bsg_rport_ct {
 
 /* request (CDB) structure of the sg_io_v4 */
 struct fc_bsg_request {
-	uint32_t msgcode;
+	__u32	msgcode;
 	union {
 		struct fc_bsg_host_add_rport	h_addrport;
 		struct fc_bsg_host_del_rport	h_delrport;
@@ -303,10 +305,10 @@ struct fc_bsg_reply {
 	 *    msg and status fields. The per-msgcode reply structure
 	 *    will contain valid data.
 	 */
-	uint32_t result;
+	__u32	result;
 
 	/* If there was reply_payload, how much was recevied ? */
-	uint32_t reply_payload_rcv_len;
+	__u32	reply_payload_rcv_len;
 
 	union {
 		struct fc_bsg_host_vendor_reply		vendor_reply;
-- 
ldv
