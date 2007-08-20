From: Matthew Wilcox <matthew@wil.cx>
Subject: (unknown)
Date: Mon, 20 Aug 2007 09:18:48 -0600
Message-ID: <118762312894-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:42903 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbXHTPSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 11:18:51 -0400
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

If kthread_run failed, we would fail to scan the host, and leak the
allocated async_scan_data.  Since using a separate thread is just an
optimisation, do the scan synchronously if we fail to spawn a thread.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 309b224..a001ca1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1799,6 +1799,7 @@ static int do_scan_async(void *_data)
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
+	struct task_struct *p;
 	struct async_scan_data *data;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1810,7 +1811,9 @@ void scsi_scan_host(struct Scsi_Host *shost)
 		return;
 	}
 
-	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
+	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
+	if (IS_ERR(p))
+		do_scan_async(data);
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
