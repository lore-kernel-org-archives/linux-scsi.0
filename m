From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v10 9/9] Avoid reenabling I/O after the transport became offline
Date: Sun, 07 Apr 2013 17:05:42 +0200
Message-ID: <51618B46.2000409@acm.org>
References: <516188E5.1040008@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:41278 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab3DGPFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Apr 2013 11:05:43 -0400
In-Reply-To: <516188E5.1040008@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

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
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/scsi_lib.c   |    1 -
 drivers/scsi/scsi_sysfs.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c8698a6..c6aeafd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2163,7 +2163,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
-		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 11318cc..dd2005c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -963,7 +963,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 	if (sdev->is_visible) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		WARN(scsi_device_set_state(sdev, SDEV_CANCEL) != 0,
+		WARN(scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
+		     sdev->sdev_state != SDEV_TRANSPORT_OFFLINE,
 		     "%s: unexpected state %d\n", dev_name(&sdev->sdev_gendev),
 		     sdev->sdev_state);
 		spin_unlock_irqrestore(shost->host_lock, flags);
-- 
1.7.10.4

