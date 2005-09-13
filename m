From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/9] iscsi: nodelay fix
Date: Mon, 12 Sep 2005 21:01:28 -0500
Message-ID: <1126576888.29245.21.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17337 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932304AbVIMCBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:01:37 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D21agi010015
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:01:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

>From tomof@acm.org

I'm not sure about this. I don't think that NODELAY option hurts
performance. However, open-iscsi does not use MSG_MORE properly with
sendpage, so NODELAY option hurts the open-iscsi performance.

I've attached a patch to fix NODELAY and MSG_MORE problems and the
write performance results with disktest.

I use Opteron boxes connected directly, Chelsio NICs, 1500-byte MTU,
64 KB I/O size, and the iSCSI parameters on open-iscsi web site.

With only NODELAY fix, the performance drops, as you said. On the
other hand, NODELAY and MSG_MORE fixes improve the performance
overall.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1385,7 +1385,7 @@ iscsi_sendpage(struct iscsi_conn *conn, 
 	BUG_ON(buf->sent + size > buf->sg.length);
 	if (size > *count)
 		size = *count;
-	if (buf->sent + size != buf->sg.length)
+	if (buf->sent + size != buf->sg.length || *count != size)
 		flags |= MSG_MORE;
 
 	res = iscsi_send(sk, buf, size, flags);


