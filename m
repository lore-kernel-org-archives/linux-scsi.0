From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/11] iscsi bugfixes: send correct error values to userspace
Date: Mon, 24 Jul 2006 15:47:11 -0500
Message-ID: <1153774031.1040.32.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:13760 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751437AbWGXUrO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:47:14 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKkrNn012525
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:47:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In the xmit patch we are sending a -EXXX value to iscsi_conn_failure
which is causing userspace to get confused.

We should be sending a ISCSI_ERR_* value that userspace understands.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 848fb2a..88dafdf 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -843,7 +843,7 @@ more:
 		       if (rc == -EAGAIN)
 				goto nomore;
 		       else {
-				iscsi_conn_failure(conn, rc);
+				iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 				return 0;
 		       }
 		}
@@ -859,7 +859,7 @@ more:
 			}
 			tcp_conn->in_progress = IN_PROGRESS_DATA_RECV;
 		} else if (rc) {
-			iscsi_conn_failure(conn, rc);
+			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 			return 0;
 		}
 	}
@@ -897,7 +897,7 @@ more:
 		if (rc) {
 			if (rc == -EAGAIN)
 				goto again;
-			iscsi_conn_failure(conn, rc);
+			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 			return 0;
 		}
 		tcp_conn->in.copy -= tcp_conn->in.padding;


