From: Jeff Garzik <jgarzik@pobox.com>
Subject: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 00:32:07 -0400
Message-ID: <4296A2C7.4090107@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090501080500070301000409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:61404 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261735AbVE0EcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 00:32:11 -0400
Received: from cpe-065-184-065-144.nc.res.rr.com ([65.184.65.144] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.51 #1 (Red Hat Linux))
	id 1DbWW2-0003Iy-JG
	for linux-scsi@vger.kernel.org; Fri, 27 May 2005 04:32:11 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090501080500070301000409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


SCSI EH processing already serializes things during EH, so this spinlock 
isn't really needed.

Removing the spinlock outright would break drivers that surround logic 
with spin_unlock_irq()..spin_lock_irq(), so I introduced ->unlocked_eh 
option.



--------------090501080500070301000409
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -266,6 +266,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_flush = sht->ordered_flush;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->unlocked_eh = sht->unlocked_eh;
 
 	/*
 	 * hosts/devices that do queueing must support ordered tags
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -528,10 +528,12 @@ static int scsi_send_eh_cmnd(struct scsi
 		 * abort a timed out command or not.  not sure how
 		 * we should treat them differently anyways.
 		 */
-		spin_lock_irqsave(shost->host_lock, flags);
+		if (!shost->unlocked_eh)
+			spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->hostt->eh_abort_handler)
 			shost->hostt->eh_abort_handler(scmd);
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!shost->unlocked_eh)
+			spin_unlock_irqrestore(shost->host_lock, flags);
 			
 		scmd->request->rq_status = RQ_SCSI_DONE;
 		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -752,9 +754,11 @@ static int scsi_try_to_abort_cmd(struct 
 
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	return rtn;
 }
@@ -873,9 +877,11 @@ static int scsi_try_bus_device_reset(str
 
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		scmd->device->was_reset = 1;
@@ -1061,9 +1067,11 @@ static int scsi_try_bus_reset(struct scs
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
@@ -1092,9 +1100,11 @@ static int scsi_try_host_reset(struct sc
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	if (!scmd->device->host->unlocked_eh)
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -370,6 +370,11 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * true if this LLD supports unlocked error handler hooks
+	 */
+	unsigned unlocked_eh:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;
@@ -527,6 +532,11 @@ struct Scsi_Host {
 	unsigned ordered_tag:1;
 
 	/*
+	 * true if this LLD supports unlocked error handler hooks
+	 */
+	unsigned unlocked_eh:1;
+
+	/*
 	 * Optional work queue to be utilized by the transport
 	 */
 	char work_q_name[KOBJ_NAME_LEN];

--------------090501080500070301000409--
