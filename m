From: Peter Yao <peter@exavio.com.cn>
Subject: [patch]scsi_error.c@2.4.22, device starved forever
Date: Tue, 26 Aug 2003 14:43:44 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F4B7220.5070008@exavio.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050107030101080309090901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [211.101.246.248] ([211.101.246.248]:60896 "HELO
	capitalnet.com.cn") by vger.kernel.org with SMTP id S263821AbTHZGfV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 02:35:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107030101080309090901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
When the error handler finish and call scsi_restart_operations, may 
forget to mark some devices starved. Patch atached.

Thanks,

Peter Yao

--------------050107030101080309090901
Content-Type: text/plain;
 name="patch_2.4.22"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_2.4.22"

--- linux-2.4.22/drivers/scsi/scsi_error.c	Thu Nov 28 23:53:14 2002
+++ /home/peter/scsi_error.c	Tue Aug 26 14:35:14 2003
@@ -1262,7 +1262,12 @@
 		    || (host->host_blocked)
 		    || (host->host_self_blocked)
 		    || (SDpnt->device_blocked)) {
-			break;
+			if (atomic_read(&SDpnt->device_busy) == 0) {
+				SDpnt->starved = 1;
+				host->some_device_starved = 1;
+				
+			}
+			continue;
 		}
 		q = &SDpnt->request_queue;
 		q->request_fn(q);

--------------050107030101080309090901--

