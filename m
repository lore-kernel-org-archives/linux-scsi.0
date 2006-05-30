From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/5] iscsi update: fix run list corruption
Date: Tue, 30 May 2006 00:37:22 -0500
Message-ID: <1148967442.3005.14.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:24247 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932133AbWE3F55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 01:57:57 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U5vaWD027085
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 00:57:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from davidw@netapp.com:

We must grab the session lock when modifying the running lists.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9630025..a223413 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -552,8 +552,10 @@ static int iscsi_data_xmit(struct iscsi_
         if (unlikely(__kfifo_len(conn->immqueue))) {
 	        while (__kfifo_get(conn->immqueue, (void*)&conn->mtask,
 			           sizeof(void*))) {
+			spin_lock_bh(&conn->session->lock);
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
+			spin_unlock_bh(&conn->session->lock);
 		        if (tt->xmit_mgmt_task(conn, conn->mtask))
 			        goto again;
 	        }
@@ -568,8 +570,10 @@ static int iscsi_data_xmit(struct iscsi_
 		 * iscsi tcp may readd the task to the xmitqueue to send
 		 * write data
 		 */
+		spin_lock_bh(&conn->session->lock);
 		if (list_empty(&conn->ctask->running))
 			list_add_tail(&conn->ctask->running, &conn->run_list);
+		spin_unlock_bh(&conn->session->lock);
 		if (tt->xmit_cmd_task(conn, conn->ctask))
 			goto again;
 	}
@@ -580,8 +584,10 @@ static int iscsi_data_xmit(struct iscsi_
         if (unlikely(__kfifo_len(conn->mgmtqueue))) {
 	        while (__kfifo_get(conn->mgmtqueue, (void*)&conn->mtask,
 			           sizeof(void*))) {
+			spin_lock_bh(&conn->session->lock);
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
+			spin_unlock_bh(&conn->session->lock);
 		        if (tt->xmit_mgmt_task(conn, conn->mtask))
 			        goto again;
 	        }


