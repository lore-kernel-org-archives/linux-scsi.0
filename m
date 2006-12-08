From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Add missing completion to scsi_complete_async_scans()
Date: Thu, 7 Dec 2006 19:29:27 -0700
Message-ID: <20061208022927.GB2054@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59992 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1164384AbWLHC32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 21:29:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If either scsi_complete_async_scans() is called a second time
before the first call has finished, or a host scan is started while
scsi_complete_async_scans() is still sleeping, it would fail to wake up
the other task, which would sleep forever.

I've changed the kernel-doc to make it clear that
scsi_complete_async_scans() only guarantees that scans which started
before it was called are guaranteed to have finished when it returns.
I considered making it wait until all scans are completed, but it can't
guarantee that no more scans will start before it returns anyway, and it
runs the risk of confusing other callers of scsi_complete_async_scans()
for hosts actually scanning.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4d65614..0f36404 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -133,12 +133,10 @@ struct async_scan_data {
 /**
  * scsi_complete_async_scans - Wait for asynchronous scans to complete
  *
- * Asynchronous scans add themselves to the scanning_hosts list.  Once
- * that list is empty, we know that the scans are complete.  Rather than
- * waking up periodically to check the state of the list, we pretend to be
- * a scanning task by adding ourselves at the end of the list and going to
- * sleep.  When the task before us wakes us up, we take ourselves off the
- * list and return.
+ * When this function returns, any host which started scanning before
+ * this function was called will have finished its scan.  Hosts which
+ * started scanning after this function was called may or may not have
+ * finished.
  */
 int scsi_complete_async_scans(void)
 {
@@ -171,6 +169,11 @@ int scsi_complete_async_scans(void)
 
 	spin_lock(&async_scan_lock);
 	list_del(&data->list);
+	if (!list_empty(&scanning_hosts)) {
+		struct async_scan_data *next = list_entry(scanning_hosts.next,
+				struct async_scan_data, list);
+		complete(&next->prev_finished);
+	}
  done:
 	spin_unlock(&async_scan_lock);
 

