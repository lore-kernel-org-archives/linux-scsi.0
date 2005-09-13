From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/9] iscsi: handle nonlinear skbs
Date: Mon, 12 Sep 2005 21:01:35 -0500
Message-ID: <1126576895.29245.23.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:18361 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932315AbVIMCBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:01:52 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D21oMs010021
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:01:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

>From zhenyu.z.wang@intel.com

Fix oops from nonlinear skb usage.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1061,7 +1061,6 @@ iscsi_tcp_data_recv(read_descriptor_t *r
 {
 	int rc;
 	struct iscsi_conn *conn = rd_desc->arg.data;
-	int start = skb_headlen(skb);
 	int processed;
 	char pad[ISCSI_PAD_LEN];
 	struct scatterlist sg;
@@ -1070,7 +1069,7 @@ iscsi_tcp_data_recv(read_descriptor_t *r
 	 * Save current SKB and its offset in the corresponding
 	 * connection context.
 	 */
-	conn->in.copy = start - offset;
+	conn->in.copy = skb->len - offset;
 	conn->in.offset = offset;
 	conn->in.skb = skb;
 	conn->in.len = conn->in.copy;


