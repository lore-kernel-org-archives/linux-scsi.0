From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v14 2/6] Avoid calling __scsi_remove_device() twice
Date: Fri, 05 Jul 2013 15:24:05 +0200
Message-ID: <51D6C8F5.90009@acm.org>
References: <51D6C885.9050000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:33398 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3GENYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jul 2013 09:24:06 -0400
In-Reply-To: <51D6C885.9050000@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, David Milburn <dmilburn@redhat.com>

If something goes wrong during LUN scanning, e.g. a transport layer
failure occurs, then __scsi_remove_device() can get invoked by the
LUN scanning code for a SCSI device in state SDEV_CREATED_BLOCK and
before the SCSI device has been added to sysfs (is_visible == 0).
Make sure that even in this case the transition into state SDEV_DEL
occurs. This avoids that __scsi_remove_device() can get invoked a
second time by scsi_forget_host() if this last function is invoked
from another thread than the thread that performs LUN scanning.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index df8bd5a..124392f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2193,6 +2193,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_CREATED_BLOCK:
 			break;
 		default:
 			goto illegal;
-- 
1.7.10.4

