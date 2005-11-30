From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/8] iscsi: iscsi response fix
Date: Tue, 29 Nov 2005 23:12:54 -0600
Message-ID: <1133327574.28356.42.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48570 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751053AbVK3FNT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:19 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5DHOY009281
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from Wang Zhenyu:

Must check SCSI CMD and R2T response according to the spec

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6e21798..602de27 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -642,9 +642,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 		switch(conn->in.opcode) {
 		case ISCSI_OP_SCSI_CMD_RSP:
 			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-			if (ctask->hdr.flags & ISCSI_FLAG_CMD_WRITE)
-				rc = iscsi_cmd_rsp(conn, ctask);
-			else if (!conn->in.datalen)
+			if (!conn->in.datalen)
 				rc = iscsi_cmd_rsp(conn, ctask);
 			else
 				/*
@@ -666,8 +664,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			break;
 		case ISCSI_OP_R2T:
 			BUG_ON((void*)ctask != ctask->sc->SCp.ptr);
-			if (ctask->hdr.flags & ISCSI_FLAG_CMD_WRITE &&
-			    ctask->sc->sc_data_direction == DMA_TO_DEVICE)
+			if (ctask->sc->sc_data_direction == DMA_TO_DEVICE)
 				rc = iscsi_r2t_rsp(conn, ctask);
 			else
 				rc = ISCSI_ERR_PROTO;


