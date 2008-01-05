From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] add missing transport configure points for target and host
Date: Sat, 05 Jan 2008 09:38:30 -0600
Message-ID: <1199547510.3399.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49897 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYAEPif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 10:38:35 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 554D289FB
	for <linux-scsi@vger.kernel.org>; Sat,  5 Jan 2008 09:38:32 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.il.steeleye.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xuJEzR6wIYns for <linux-scsi@vger.kernel.org>;
	Sat,  5 Jan 2008 09:38:31 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 418F48593
	for <linux-scsi@vger.kernel.org>; Sat,  5 Jan 2008 09:38:31 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

While trying to convert the SPI transport class to attribute groups, I
discovered that we don't actually have any transport configure points
for either the target or the host.  This patch adds these missing
transport class triggers.  The host one is simply done after the add,
the target one tries to be more clever and add it after devices may have
been placed on the target (so the device configure will have set up the
target parameters).

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ada72af..1dc165a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1489,6 +1489,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
+	transport_configure_device(&starget->dev);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1569,6 +1570,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  out_reap:
 	/* now determine if the target has any children at all
 	 * and if not, nuke it */
+	transport_configure_device(&starget->dev);
 	scsi_target_reap(starget);
 
 	put_device(&starget->dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 00b3866..ed83cdb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1018,6 +1018,7 @@ int scsi_sysfs_add_host(struct Scsi_Host *shost)
 	}
 
 	transport_register_device(&shost->shost_gendev);
+	transport_configure_device(&shost->shost_gendev);
 	return 0;
 }
 


