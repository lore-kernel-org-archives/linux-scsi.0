From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v9 9/9] Avoid reenabling I/O after the transport became offline
Date: Fri, 15 Feb 2013 13:10:33 +0100
Message-ID: <511E25B9.3080301@acm.org>
References: <511E23DD.2030309@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:48273 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab3BOMKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 07:10:34 -0500
In-Reply-To: <511E23DD.2030309@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

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
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c   |    1 -
 drivers/scsi/scsi_sysfs.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41c0eb1..fbf7826 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2158,7 +2158,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
-		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1463931..d0ca3e9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -963,7 +963,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 	if (sdev->is_visible) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0);
+		WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0
+			     && sdev->sdev_state != SDEV_TRANSPORT_OFFLINE);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		bsg_unregister_queue(sdev->request_queue);
-- 
1.7.10.4

