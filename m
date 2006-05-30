From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/5] iscsi update: return task found during search
Date: Tue, 30 May 2006 00:37:25 -0500
Message-ID: <1148967445.3005.15.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:24759 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932140AbWE3F6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 01:58:24 -0400
Received: from [192.168.0.7] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4U5w28Y027088
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 May 2006 00:58:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from davidw@netapp.com:

remove task type should return a task on success.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a223413..256b87a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -985,7 +985,7 @@ iscsi_remove_##tasktype(struct kfifo *fi
 									\
 		if (task->itt == itt) {					\
 			debug_scsi("matched task\n");			\
-			break;						\
+			return task;					\
 		}							\
 									\
 		__kfifo_put(fifo, (void*)&task, sizeof(void*));		\


