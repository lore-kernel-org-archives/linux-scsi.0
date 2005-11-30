From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/8] iscsi: opcode check fix
Date: Tue, 29 Nov 2005 23:12:46 -0600
Message-ID: <1133327566.28356.38.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47034 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751021AbVK3FM5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:12:57 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5CtQ4009272
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:12:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Mike Christie

Must check only valid opcode bits.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0027973..ae2f7be 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -584,7 +584,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 	}
 
 	/* save opcode for later */
-	conn->in.opcode = hdr->opcode;
+	conn->in.opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	/* verify itt (itt encoding: age+cid+itt) */
 	if (hdr->itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {


