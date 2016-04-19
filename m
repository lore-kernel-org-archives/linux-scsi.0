From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 08/13] iscsi-target: use conn_transport->transport_type in text rsp
Date: Wed, 20 Apr 2016 00:00:15 +0530
Message-ID: <9837aa56f3ab5098cfb1d3544e0534e36382ba69.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:23355 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932231AbcDSSbJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2016 14:31:09 -0400
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

Use conn_transport->transport_type instead of
ISCSI_TCP to build text response.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 28fc7fb..348337c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3513,7 +3513,8 @@ static int iscsit_send_text_rsp(
 	struct iscsi_text_rsp *hdr = (struct iscsi_text_rsp *)cmd->pdu;
 	int text_length;
 
-	text_length = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
+	text_length = iscsit_build_text_rsp(cmd, conn, hdr,
+				conn->conn_transport->transport_type);
 	if (text_length < 0)
 		return text_length;
 
-- 
2.0.2

