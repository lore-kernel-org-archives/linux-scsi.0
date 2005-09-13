From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/9] iscsi: fix ahs len
Date: Mon, 12 Sep 2005 21:01:41 -0500
Message-ID: <1126576901.29245.25.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19385 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932399AbVIMCCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:02:10 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D225pe010027
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:02:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from tomof@acm.org

Fix AHS Length

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -557,7 +557,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 	conn->data_copied = 0;
 
 	/* read AHS */
-	conn->in.ahslen = hdr->hlength*(4*sizeof(__u16));
+	conn->in.ahslen = hdr->hlength * 4;
 	conn->in.offset += conn->in.ahslen;
 	conn->in.copy -= conn->in.ahslen;
 	if (conn->in.copy < 0) {


