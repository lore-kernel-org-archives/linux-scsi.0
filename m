From: Peter Yao <peter@exavio.com.cn>
Subject: [patch] scsi_lib.c error handler patch
Date: Fri, 20 Jun 2003 17:55:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF34A7D.2000701@exavio.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030309020307000308090003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [211.101.246.248] ([211.101.246.248]:19959 "HELO
	capitalnet.com.cn") by vger.kernel.org with SMTP id S262577AbTFTJlq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 05:41:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030309020307000308090003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

i found a bug in redhat 7.3's kernel source, which cause some failed 
commands cannot be passed to the scsi error handler thread. I searched 
this list hastily and did not find a fix. i don't know whether it is in 
the latest kernel source, just a remind. :-)

Peter Yao

--------------030309020307000308090003
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

--- drivers/scsi/scsi_lib.c	Thu Apr 18 10:50:34 2002
+++ /tmp/scsi_lib.c	Fri Jun 20 17:34:10 2003
@@ -423,6 +423,11 @@
 		 * the front of the queue, and goose the queue again.
 		 */
 		scsi_queue_next_request(q, SCpnt);
+		/* Don't forget to wake up error handler */
+                if (SCpnt->host->in_recovery && !SCpnt->host->eh_active &&
+                        atomic_read(&SCpnt->host->host_busy) == SCpnt->host->host_failed) {
+                        up(SCpnt->host->eh_wait);
+                }
 		return SCpnt;
 	}
 	/*

--------------030309020307000308090003--

