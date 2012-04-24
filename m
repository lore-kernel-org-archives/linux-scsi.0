From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] scsi: wait in scsi_remove_host till async scan ends
Date: Tue, 24 Apr 2012 15:10:17 +0200
Message-ID: <4F96A639.2030306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2DXNKT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 09:10:19 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3ODAIPd026445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2012 09:10:19 -0400
Received: from localhost.localdomain (dhcp-27-219.brq.redhat.com [10.34.27.219])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3ODAHNT021405
	for <linux-scsi@vger.kernel.org>; Tue, 24 Apr 2012 09:10:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

When a driver is rmmoded while a async scan is in progress, the lld is removed, and accessing
the host_template will causes a BUG : BUG: unable to handle kernel paging request at ffffffffa01874b8
This patch waits in the scsi_remove_host until the async scan ends. The scan thread checks for the host
state and the thread can end faster when the SHOST_CANCEL state is set. 

Another possibility - locking the lld with try_module_get before the scan starts does have problems
with 'rmmod --wait' (BUG again), the reason is that in scsi_device_get we don't check the return value
of try_module_get. When this gets fixed, this code could be replaced with a try_module_get approach.
(This was added 85b6c720b0931101c8bcc3a5abdc2b8514b0fb4b [SCSI] sd: fix cache flushing on module removal (and individual device removal)

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..269b23f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -33,6 +33,7 @@
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -172,6 +173,12 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	
+	while (shost->async_scan)
+		msleep(10);
+	/* the above while block needs to wait for a host_lock
+	 * this is now provided by the next code block
+	 */
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 29c4c04..02a36b2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1743,10 +1743,9 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		goto err;
-	data->shost = scsi_host_get(shost);
-	if (!data->shost)
-		goto err;
+		return NULL;
+
+	data->shost = shost;
 	init_completion(&data->prev_finished);
 
 	mutex_lock(&shost->scan_mutex);
@@ -1762,10 +1761,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	spin_unlock(&async_scan_lock);
 
 	return data;
-
- err:
-	kfree(data);
-	return NULL;
 }
 
 /**
@@ -1800,9 +1795,6 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	scsi_sysfs_add_devices(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	mutex_unlock(&shost->scan_mutex);
 
@@ -1816,7 +1808,11 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	spin_unlock(&async_scan_lock);
 
 	scsi_autopm_put_host(shost);
-	scsi_host_put(shost);
+	
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->async_scan = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	
 	kfree(data);
 }
 
@@ -1827,8 +1823,14 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
 		if (shost->hostt->scan_start)
 			shost->hostt->scan_start(shost);
 
-		while (!shost->hostt->scan_finished(shost, jiffies - start))
+		while (!shost->hostt->scan_finished(shost, jiffies - start)) {
 			msleep(10);
+			if (!scsi_host_scan_allowed(shost)) {
+				printk (KERN_INFO "scsi: host not in proper  "
+					"state, async scan aborted ...\n");
+				break;
+			}
+		}
 	} else {
 		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
 				SCAN_WILD_CARD, 0);


