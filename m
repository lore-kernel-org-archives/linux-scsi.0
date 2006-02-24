From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/2] Block I/O while SG reset operation in progress - midlayer
 portion
Date: Fri, 24 Feb 2006 11:52:16 -0500
Message-ID: <43FF39C0.7080509@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53707 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932381AbWBXQw0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 11:52:26 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1OGqPrf026318
	for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2006 08:52:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is the midlayer portion of the patch

This patch ensures that i/o is stopped while an eh handler is being
processed. It adds a new flag, set by the async reset callers, which
augments the host-in-reset checks and stops i/o.  The async reset
callers are already synchronized to hold off until the error thread is
no longer running.

-- james s

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	2006-02-06 12:00:11.000000000 -0500
+++ b/drivers/scsi/scsi_error.c	2006-02-13 10:44:10.000000000 -0500
@@ -1654,7 +1654,9 @@ int
  scsi_reset_provider(struct scsi_device *dev, int flag)
  {
  	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
+	struct Scsi_Host *shost = dev->host;
  	struct request req;
+	unsigned long flags;
  	int rtn;

  	scmd->request = &req;
@@ -1684,6 +1686,10 @@ scsi_reset_provider(struct scsi_device *
  	 */
  	scmd->pid			= 0;

+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->tmf_in_progress = 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
  	switch (flag) {
  	case SCSI_TRY_RESET_DEVICE:
  		rtn = scsi_try_bus_device_reset(scmd);
@@ -1702,6 +1708,10 @@ scsi_reset_provider(struct scsi_device *
  		rtn = FAILED;
  	}

+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->tmf_in_progress = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
  	scsi_next_command(scmd);
  	return rtn;
  }
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2006-02-06 12:00:33.000000000 -0500
+++ b/include/scsi/scsi_host.h	2006-02-13 10:21:01.000000000 -0500
@@ -556,6 +556,9 @@ struct Scsi_Host {
  	 */
  	unsigned ordered_tag:1;

+	/* task mgmt function in progress */
+	unsigned tmf_in_progress:1;
+
  	/*
  	 * Optional work queue to be utilized by the transport
  	 */
@@ -633,7 +636,8 @@ static inline int scsi_host_in_recovery(
  {
  	return shost->shost_state == SHOST_RECOVERY ||
  		shost->shost_state == SHOST_CANCEL_RECOVERY ||
-		shost->shost_state == SHOST_DEL_RECOVERY;
+		shost->shost_state == SHOST_DEL_RECOVERY ||
+		shost->tmf_in_progress;
  }

  extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);

