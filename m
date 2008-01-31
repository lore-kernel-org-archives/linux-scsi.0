From: michaelc@cs.wisc.edu
Subject: [PATCH 11/12] libiscsi: fix session age rollover and remove cid encoding
Date: Thu, 31 Jan 2008 13:36:53 -0600
Message-ID: <1201808218585-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
 <1201808216137-git-send-email-michaelc@cs.wisc.edu>
 <12018082174157-git-send-email-michaelc@cs.wisc.edu>
 <1201808217738-git-send-email-michaelc@cs.wisc.edu>
 <12018082172234-git-send-email-michaelc@cs.wisc.edu>
 <1201808217932-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760484AbYAaThB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:01 -0500
In-Reply-To: <1201808217932-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The session age mask is only 4 bits, but session->age is 32. When
it gets larger then 15 and we try to or the bits some bits get
dropped and the check for session age in iscsi_verify_itt is useless.

The ISCSI_CID_MASK related bits are also useless since cid is always
one.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c    |   14 ++++----------
 include/scsi/iscsi_proto.h |    4 ++--
 include/scsi/libiscsi.h    |    2 --
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c76bd5c..cfffabd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -160,7 +160,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
 	hdr->opcode = ISCSI_OP_SCSI_CMD;
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-	hdr->itt = build_itt(ctask->itt, conn->id, session->age);
+	hdr->itt = build_itt(ctask->itt, session->age);
 	hdr->data_length = cpu_to_be32(scsi_bufflen(sc));
 	hdr->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
@@ -706,14 +706,6 @@ int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			return ISCSI_ERR_BAD_ITT;
 		}
 
-		if (((__force u32)hdr->itt & ISCSI_CID_MASK) !=
-		    (conn->id << ISCSI_CID_SHIFT)) {
-			iscsi_conn_printk(KERN_ERR, conn,
-					  "iscsi: received itt %x, expected "
-					  "CID (%x)\n",
-					  (__force u32)hdr->itt, conn->id);
-			return ISCSI_ERR_BAD_ITT;
-		}
 		itt = get_itt(hdr->itt);
 	} else
 		itt = ~0U;
@@ -777,7 +769,7 @@ static void iscsi_prep_mtask(struct iscsi_conn *conn,
 	 */
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(mtask->itt, conn->id, session->age);
+		hdr->itt = build_itt(mtask->itt, session->age);
 		/*
 		 * TODO: We always use immediate, so we never hit this.
 		 * If we start to send tmfs or nops as non-immediate then
@@ -2037,6 +2029,8 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 		conn->stop_stage = 0;
 		conn->tmf_state = TMF_INITIAL;
 		session->age++;
+		if (session->age == 16)
+			session->age = 0;
 		break;
 	case STOP_CONN_TERM:
 		conn->stop_stage = 0;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 318a909..5ffec8a 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -45,8 +45,8 @@
 /* initiator tags; opaque for target */
 typedef uint32_t __bitwise__ itt_t;
 /* below makes sense only for initiator that created this tag */
-#define build_itt(itt, id, age) ((__force itt_t)\
-	((itt) | ((id) << ISCSI_CID_SHIFT) | ((age) << ISCSI_AGE_SHIFT)))
+#define build_itt(itt, age) ((__force itt_t)\
+	((itt) | ((age) << ISCSI_AGE_SHIFT)))
 #define get_itt(itt) ((__force uint32_t)(itt_t)(itt) & ISCSI_ITT_MASK)
 #define RESERVED_ITT ((__force itt_t)0xffffffff)
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5daa83c..9b955a9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -70,8 +70,6 @@ enum {
 #define ISCSI_SUSPEND_BIT		1
 
 #define ISCSI_ITT_MASK			(0xfff)
-#define ISCSI_CID_SHIFT			12
-#define ISCSI_CID_MASK			(0xffff << ISCSI_CID_SHIFT)
 #define ISCSI_AGE_SHIFT			28
 #define ISCSI_AGE_MASK			(0xf << ISCSI_AGE_SHIFT)
 
-- 
1.5.2.1

