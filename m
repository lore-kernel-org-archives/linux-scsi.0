From: Joe Jin <joe.jin@oracle.com>
Subject: [PATCH 1/1] SCSI: fix scsi disk hotpulg/hotunplug race
Date: Mon, 6 Dec 2010 21:30:28 +0800
Message-ID: <20101206133028.GB19448@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:40320 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0LFNbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2010 08:31:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg.marsden@oracle.com, guru.anbalagane@oracle.com, joe.jin@oracle.com

Hi,

Trigger scsi scan when plug new disk, device also support disk
hotplug and auto scan disk, it may allocate scsi_target for same
target more then one by call scsi_alloc_target(),  this caused by
the race of __scsi_add_device() and scsi_scan_host_selected().

Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Signed-off-by: Joe Jin <joe.jin@oracle.com>

---
 scsi_scan.c |    8 +++++---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..2429771 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1508,12 +1508,14 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return ERR_PTR(-ENODEV);
 
+	mutex_lock(&shost->scan_mutex);
 	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
+	if (!starget) {
+		mutex_unlock(&shost->scan_mutex);
 		return ERR_PTR(-ENOMEM);
+	}
 	scsi_autopm_get_target(starget);
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
@@ -1521,10 +1523,10 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 		scsi_autopm_put_host(shost);
 	}
-	mutex_unlock(&shost->scan_mutex);
 	scsi_autopm_put_target(starget);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
+	mutex_unlock(&shost->scan_mutex);
 
 	return sdev;
 }

-- 
Oracle <http://www.oracle.com>
Joe Jin | Team Leader, Software Development | +8610.8278.6295
ORACLE | Linux and Virtualization
Incubator Building 2-A ZPark | Beijing China, 100094


