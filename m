From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] scsi_queue_work() documented return value is incorrect
Date: Fri, 05 May 2006 09:18:43 -0500
Message-ID: <445B5EC3.5060808@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070709070701040401040506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:43154 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751123AbWEEOSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2006 10:18:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@Emulex.Com

This is a multi-part message in MIME format.
--------------070709070701040401040506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If you examine the queue_work() routine you'll see that it returns
1 on success, 0 on not queuing the work.

This patch corrects the source code documentation for the function.

Mike


--------------070709070701040401040506
Content-Type: text/x-patch;
 name="scsi_queue_work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_queue_work.patch"

Fix scsi_queue_work function documentation.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc3u/drivers/scsi/hosts.c	2006-04-27 12:32:05.000000000 -0500
+++ rc3/drivers/scsi/hosts.c	2006-05-05 09:12:53.347943283 -0500
@@ -487,7 +487,9 @@
  * @work:	Work to queue for execution.
  *
  * Return value:
- * 	0 on success / != 0 for error
+ * 	1 - work queued for execution
+ *	0 - work is already queued
+ *	-EINVAL - work queue doesn't exist
  **/
 int scsi_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 {

--------------070709070701040401040506--
