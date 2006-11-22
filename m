From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/3] [SCSI] Make scsi_scan_host work for drivers which find their own targets
Date: Wed, 22 Nov 2006 13:24:54 -0700
Message-ID: <1164227094214-git-send-email-matthew@wil.cx>
References: <11642270942262-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:61869 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1756954AbWKVUYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 15:24:55 -0500
In-Reply-To: <11642270942262-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@rowlf.int.wil.cx>, Matthew Wilcox <matthew@wil.cx>

From: Matthew Wilcox <willy@rowlf.int.wil.cx>

If a driver can find its own targets, it can now fill in scan_finished and
(optionally) scan_start in the scsi_host_template.  Then, when it calls
scsi_scan_host(), it will be called back (from a thread if asynchronous
discovery is enabled), first to start the scan, and then at intervals to
check if the scan is completed.

Also make scsi_prep_async_scan and scsi_finish_async_scan static.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/scsi_scan.c |   27 ++++++++++++++++++++-------
 include/scsi/scsi_host.h |   18 ++++++++++++++++++
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a2ca2e9..5c7d65d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1632,7 +1632,7 @@ static void scsi_sysfs_add_devices(struc
  * that other asynchronous scans started after this one won't affect the
  * ordering of the discovered devices.
  */
-struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
+static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data;
 
@@ -1676,7 +1676,7 @@ struct async_scan_data *scsi_prep_async_
  * This function announces all the devices it has found to the rest
  * of the system.
  */
-void scsi_finish_async_scan(struct async_scan_data *data)
+static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
 
@@ -1709,12 +1709,25 @@ void scsi_finish_async_scan(struct async
 	kfree(data);
 }
 
-static int do_scan_async(void *_data)
+static void do_scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct async_scan_data *data = _data;
-	scsi_scan_host_selected(data->shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
+	if (shost->hostt->scan_finished) {
+		unsigned long start = jiffies;
+		if (shost->hostt->scan_start)
+			shost->hostt->scan_start(shost);
+
+		while (!shost->hostt->scan_finished(shost, jiffies - start))
+			msleep(10);
+	} else {
+		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);
+	}
+}
 
+static int do_scan_async(void *_data)
+{
+	struct async_scan_data *data = _data;
+	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
 	return 0;
 }
@@ -1732,10 +1745,10 @@ void scsi_scan_host(struct Scsi_Host *sh
 
 	data = scsi_prep_async_scan(shost);
 	if (!data) {
-		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
-					SCAN_WILD_CARD, 0);
+		do_scsi_scan_host(shost);
 		return;
 	}
+
 	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 }
 EXPORT_SYMBOL(scsi_scan_host);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba5b3eb..20ebcea 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -241,6 +241,24 @@ struct scsi_host_template {
 	void (* target_destroy)(struct scsi_target *);
 
 	/*
+	 * If a host has the ability to discover targets on its own instead
+	 * of scanning the entire bus, it can fill in this function and
+	 * call scsi_scan_host().  This function will be called periodically
+	 * until it returns 1 with the scsi_host and the elapsed time of
+	 * the scan in jiffies.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* scan_finished)(struct Scsi_Host *, unsigned long);
+
+	/*
+	 * If the host wants to be called before the scan starts, but
+	 * after the midlayer has set up ready for the scan, it can fill
+	 * in this function.
+	 */
+	void (* scan_start)(struct Scsi_Host *);
+
+	/*
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what
-- 
1.4.3.3

