From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 6/14]: Make iSCSI TMR code use
	iscsi_tpg_get_node_attrib()
Date: Fri, 19 Dec 2008 15:33:25 -0800
Message-ID: <1229729605.4560.112.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:20896 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753115AbYLSXd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:33:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 48a474887409efe398f40b33127b0c5fd4cb953b Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:16:54 -0800
Subject: [PATCH] [LIO-Target]: Make iSCSI TMR code use iscsi_tpg_get_node_attrib()

This patch makes iSCSI TMR code use iscsi_tpg_get_node_attrib() to locate
iscsi_node_attrib_t for locating ACL information about tmr_warm_reset and
tmr_cold_reset.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_tmr.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_tmr.c b/drivers/lio-core/iscsi_target_tmr.c
index 5fab8f1..d6cdb79 100644
--- a/drivers/lio-core/iscsi_target_tmr.c
+++ b/drivers/lio-core/iscsi_target_tmr.c
@@ -50,6 +50,7 @@
 #include <iscsi_target_erl1.h>
 #include <iscsi_target_erl2.h>
 #include <iscsi_target_tmr.h>
+#include <iscsi_target_tpg.h>
 #include <target_core_transport.h>
 #include <iscsi_target_util.h>
 
@@ -236,13 +237,13 @@ extern __u8 iscsi_tmr_task_warm_reset (
 	iscsi_tmr_req_t *tmr_req,
 	unsigned char *buf)
 {
-	iscsi_node_acl_t *acl = SESS(conn)->node_acl;
 	iscsi_session_t *sess = SESS(conn);
+	iscsi_node_attrib_t *na = iscsi_tpg_get_node_attrib(sess);
 #if 0
 	struct iscsi_init_task_mgt_cmnd *hdr =
 		(struct iscsi_init_task_mgt_cmnd *) buf;
 #endif	
-	if (!ISCSI_NODE_ATTRIB(acl)->tmr_warm_reset) {
+	if (!(na->tmr_warm_reset)) {
 		 TRACE_ERROR("TMR Opcode TARGET_WARM_RESET authorization failed"
 			" for Initiator Node: %s\n",
 			SESS_NODE_ACL(sess)->initiatorname);
@@ -265,11 +266,12 @@ extern __u8 iscsi_tmr_task_cold_reset (
 	unsigned char *buf)
 {
 	iscsi_session_t *sess = SESS(conn);
+	iscsi_node_attrib_t *na = iscsi_tpg_get_node_attrib(sess);
 #if 0
 	struct iscsi_init_task_mgt_cmnd *hdr =
 		(struct iscsi_init_task_mgt_cmnd *) buf;
 #endif	
-	if (!ISCSI_NODE_ATTRIB(sess->node_acl)->tmr_cold_reset) {
+	if (!(na->tmr_cold_reset)) {
 		TRACE_ERROR("TMR Opcode TARGET_COLD_RESET authorization failed"
 			" for Initiator Node: %s\n",
 			SESS_NODE_ACL(sess)->initiatorname);
-- 
1.5.4.1



