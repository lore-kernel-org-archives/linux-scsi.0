From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] scsi: fix async probe regression
Date: Fri, 25 May 2012 09:39:15 -0700
Message-ID: <20120525163529.28315.92813.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000Ab2EYQXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 12:23:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Meelis Roos <mroos@linux.ee>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>

Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
moved sd probe work out of reach of wait_for_device_probe().  Allow it
to be synced via scsi_complete_async_scans().

Cc: David Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 So this is the stop gap that allows us to keep a7a20d1 as a fix for a
 resume deadlock, and gives us time to figure out how to clarify
 async_synchronize_full() properly in the 3.6 timeframe.

 drivers/scsi/scsi_scan.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01b0374..41f9192 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -141,13 +141,13 @@ struct async_scan_data {
  * started scanning after this function was called may or may not have
  * finished.
  */
-int scsi_complete_async_scans(void)
+static void __scsi_complete_async_scans(void)
 {
 	struct async_scan_data *data;
 
 	do {
 		if (list_empty(&scanning_hosts))
-			return 0;
+			return;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
@@ -181,6 +181,14 @@ int scsi_complete_async_scans(void)
 	spin_unlock(&async_scan_lock);
 
 	kfree(data);
+}
+
+
+int scsi_complete_async_scans(void)
+{
+	__scsi_complete_async_scans();
+	async_synchronize_full_domain(&scsi_sd_probe_domain);
+
 	return 0;
 }
 

