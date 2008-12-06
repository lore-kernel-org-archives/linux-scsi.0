From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: correct command abort logic
Date: Sat, 6 Dec 2008 09:41:39 -0600
Message-ID: <20081206154139.GA13534@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58158 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbYLFPlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2008 10:41:46 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB6Ff3hn017680
	for <linux-scsi@vger.kernel.org>; Sat, 6 Dec 2008 08:41:03 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB6FfkwT210504
	for <linux-scsi@vger.kernel.org>; Sat, 6 Dec 2008 08:41:46 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB6FfjZo002626
	for <linux-scsi@vger.kernel.org>; Sat, 6 Dec 2008 08:41:45 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Santiago Leon <santil@us.ibm.com>

The logic is swapped when we determine if a command that we're trying
to abort has already completed.  This will keep us from freeing event
structures at the correct time, fail to unmap command data properly 
and throw off our request_limit count.

Signed-off-by: Robert Jennings <rcjenn@us.ibm.com>

---

 ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6cad175..2d9db9b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1099,7 +1099,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (found_evt == NULL) {
+	if (found_evt != NULL) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%lx completed\n",
 			    tsk_mgmt->task_tag);
