From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] iscsi_tcp: Enable any size command
Date: Mon, 26 May 2008 11:31:19 +0300
Message-ID: <483A7557.3080907@panasas.com>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu> <48348EC0.5080905@cs.wisc.edu> <48353D58.2080109@panasas.com> <4835A150.2000306@cs.wisc.edu> <4835A25E.6050203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28877 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592AbYEZIcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2008 04:32:05 -0400
In-Reply-To: <4835A25E.6050203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Let through upto the largest command of 260 defined by the scsi standard.
iscsi core supports this already. Now that the scsi-ml supports it we can
start using large commands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c   |    2 +-
 include/scsi/iscsi_proto.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..826c97c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
-	.max_cmd_len		= 16,
+	.max_cmd_len		= SCSI_MAX_VARLEN_CDB_SIZE,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index e0593bf..f2a2c11 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -22,6 +22,7 @@
 #define ISCSI_PROTO_H
 
 #include <linux/types.h>
+#include <scsi/scsi.h>
 
 #define ISCSI_DRAFT20_VERSION	0x00
 
@@ -156,7 +157,7 @@ struct iscsi_ecdb_ahdr {
 	uint8_t ahstype;
 	uint8_t reserved;
 	/* 4-byte aligned extended CDB spillover */
-	uint8_t ecdb[260 - ISCSI_CDB_SIZE];
+	uint8_t ecdb[SCSI_MAX_VARLEN_CDB_SIZE - ISCSI_CDB_SIZE];
 };
 
 /* SCSI Response Header */
-- 
1.5.3.3


