From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v12 6/6] Avoid re-enabling I/O after the transport became
 offline
Date: Thu, 27 Jun 2013 16:57:47 +0200
Message-ID: <51CC52EB.9040900@acm.org>
References: <51CC5176.90609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:52012 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3F0O5t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jun 2013 10:57:49 -0400
In-Reply-To: <51CC5176.90609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

Disallow the SDEV_TRANSPORT_OFFLINE to SDEV_CANCEL transition such
that no I/O is sent to devices for which the transport is offline.
Notes:
- Functions like sd_shutdown() use scsi_execute_req() and hence
  set the REQ_PREEMPT flag. Such requests are passed to the LLD
  queuecommand callback in the SDEV_CANCEL state.
- This patch does not affect Fibre Channel LLD drivers since these
  drivers invoke fc_remote_port_chkready() before submitting a SCSI
  request to the HBA. That prevents a timeout to occur in state
  SDEV_CANCEL if the transport is offline.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c   |    1 -
 drivers/scsi/scsi_sysfs.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6a4fde7..63875c3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2180,7 +2180,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
-		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfbaa34..666b741 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -959,14 +959,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct device *dev = &sdev->sdev_gendev;
+	enum scsi_device_state sdev_state;
 	int res;
 
 	if (sdev->is_visible) {
 		spin_lock_irq(shost->host_lock);
+		sdev_state = sdev->sdev_state;
 		res = scsi_device_set_state(sdev, SDEV_CANCEL);
 		spin_unlock_irq(shost->host_lock);
 
-		if (res != 0)
+		if (res != 0 && sdev_state != SDEV_TRANSPORT_OFFLINE)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
-- 
1.7.10.4

