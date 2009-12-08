From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/5] hpsa: rename too generic variable names
Date: Tue, 08 Dec 2009 15:38:17 -0600
Message-ID: <20091208213817.23493.9266.stgit@beardog.cce.hp.com>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:15980 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbZLHVgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 16:36:32 -0500
In-Reply-To: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: rename too generic variable names

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   50 +++++++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dc5e518..8b8ddfc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -196,9 +196,9 @@ static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 }
 
 static struct task_struct *hpsa_scan_thread;
-static DEFINE_MUTEX(scan_mutex);
-static LIST_HEAD(scan_q);
-static int scan_thread(void *data);
+static DEFINE_MUTEX(hpsa_scan_mutex);
+static LIST_HEAD(hpsa_scan_q);
+static int hpsa_scan_func(void *data);
 
 /**
  * add_to_scan_list() - add controller to rescan queue
@@ -219,11 +219,15 @@ static int add_to_scan_list(struct ctlr_info *h)
 	if (h->busy_initializing)
 		return 0;
 
+	/*
+	 * If we don't get the lock, it means the driver is unloading
+	 * and there's no point in scheduling a new scan.
+	 */
 	if (!mutex_trylock(&h->busy_shutting_down))
 		return 0;
 
-	mutex_lock(&scan_mutex);
-	list_for_each_entry(test_h, &scan_q, scan_list) {
+	mutex_lock(&hpsa_scan_mutex);
+	list_for_each_entry(test_h, &hpsa_scan_q, scan_list) {
 		if (test_h == h) {
 			found = 1;
 			break;
@@ -231,10 +235,10 @@ static int add_to_scan_list(struct ctlr_info *h)
 	}
 	if (!found && !h->busy_scanning) {
 		INIT_COMPLETION(h->scan_wait);
-		list_add_tail(&h->scan_list, &scan_q);
+		list_add_tail(&h->scan_list, &hpsa_scan_q);
 		ret = 1;
 	}
-	mutex_unlock(&scan_mutex);
+	mutex_unlock(&hpsa_scan_mutex);
 	mutex_unlock(&h->busy_shutting_down);
 
 	return ret;
@@ -257,24 +261,24 @@ static void remove_from_scan_list(struct ctlr_info *h)
 {
 	struct ctlr_info *test_h, *tmp_h;
 
-	mutex_lock(&scan_mutex);
-	list_for_each_entry_safe(test_h, tmp_h, &scan_q, scan_list) {
+	mutex_lock(&hpsa_scan_mutex);
+	list_for_each_entry_safe(test_h, tmp_h, &hpsa_scan_q, scan_list) {
 		if (test_h == h) { /* state 2. */
 			list_del(&h->scan_list);
 			complete_all(&h->scan_wait);
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 			return;
 		}
 	}
 	if (h->busy_scanning) { /* state 3. */
-		mutex_unlock(&scan_mutex);
+		mutex_unlock(&hpsa_scan_mutex);
 		wait_for_completion(&h->scan_wait);
 	} else { /* state 1, nothing to do. */
-		mutex_unlock(&scan_mutex);
+		mutex_unlock(&hpsa_scan_mutex);
 	}
 }
 
-/* scan_thread() - kernel thread used to rescan controllers
+/* hpsa_scan_func() - kernel thread used to rescan controllers
  * @data:	 Ignored.
  *
  * A kernel thread used scan for drive topology changes on
@@ -285,7 +289,7 @@ static void remove_from_scan_list(struct ctlr_info *h)
  *
  * returns 0.
  **/
-static int scan_thread(__attribute__((unused)) void *data)
+static int hpsa_scan_func(__attribute__((unused)) void *data)
 {
 	struct ctlr_info *h;
 	int host_no;
@@ -297,22 +301,22 @@ static int scan_thread(__attribute__((unused)) void *data)
 			break;
 
 		while (1) {
-			mutex_lock(&scan_mutex);
-			if (list_empty(&scan_q)) {
-				mutex_unlock(&scan_mutex);
+			mutex_lock(&hpsa_scan_mutex);
+			if (list_empty(&hpsa_scan_q)) {
+				mutex_unlock(&hpsa_scan_mutex);
 				break;
 			}
-			h = list_entry(scan_q.next, struct ctlr_info,
+			h = list_entry(hpsa_scan_q.next, struct ctlr_info,
 					scan_list);
 			list_del(&h->scan_list);
 			h->busy_scanning = 1;
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 			host_no = h->scsi_host ?  h->scsi_host->host_no : -1;
 			hpsa_update_scsi_devices(h, host_no);
 			complete_all(&h->scan_wait);
-			mutex_lock(&scan_mutex);
+			mutex_lock(&hpsa_scan_mutex);
 			h->busy_scanning = 0;
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 		}
 	}
 	return 0;
@@ -341,7 +345,7 @@ static int check_for_unit_attention(struct ctlr_info *h,
 	 * except that it's quite likely that we will get more than one
 	 * REPORT_LUNS_CHANGED condition in quick succession, which means
 	 * that those which occur after the first one will likely happen
-	 * *during* the scan_thread's rescan.  And the rescan code is not
+	 * *during* the hpsa_scan_thread's rescan.  And the rescan code is not
 	 * robust enough to restart in the middle, undoing what it has already
 	 * done, and it's not clear that it's even possible to do this, since
 	 * part of what it does is notify the SCSI mid layer, which starts
@@ -3511,7 +3515,7 @@ static int __init hpsa_init(void)
 {
 	int err;
 	/* Start the scan thread */
-	hpsa_scan_thread = kthread_run(scan_thread, NULL, "hpsa_scan");
+	hpsa_scan_thread = kthread_run(hpsa_scan_func, NULL, "hpsa_scan");
 	if (IS_ERR(hpsa_scan_thread)) {
 		err = PTR_ERR(hpsa_scan_thread);
 		return -ENODEV;

