From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 2/8] iscsi: data under/over flow fix
Date: Fri, 13 Jan 2006 18:05:38 -0600
Message-ID: <1137197138.2720.32.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30900 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423146AbWANAFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:05:54 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E05rQL021724
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:05:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From zhenyu.z.wang@intel.com:

We need to check the ISCSI_FLAG_DATA_* flags.


Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 49d6dd5..550ff66 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -357,7 +357,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 		struct scsi_cmnd *sc = ctask->sc;
 
 		conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
-		if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
+		if (rhdr->flags & ISCSI_FLAG_DATA_UNDERFLOW) {
 			int res_count = be32_to_cpu(rhdr->residual_count);
 
 			if (res_count > 0 &&
@@ -367,9 +367,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, 
 			} else
 				sc->result = (DID_BAD_TARGET << 16) |
 					rhdr->cmd_status;
-		} else if (rhdr->flags & ISCSI_FLAG_CMD_BIDI_UNDERFLOW)
-			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
-		else if (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW) {
+		} else if (rhdr->flags & ISCSI_FLAG_DATA_OVERFLOW) {
 			sc->resid = be32_to_cpu(rhdr->residual_count);
 			sc->result = (DID_OK << 16) | rhdr->cmd_status;
 		} else


