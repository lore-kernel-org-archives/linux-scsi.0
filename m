From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v11 4/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Wed, 12 Jun 2013 14:53:20 +0200
Message-ID: <51B86F40.3020407@acm.org>
References: <51B86E26.6030108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46884 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3FLMxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 08:53:21 -0400
In-Reply-To: <51B86E26.6030108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

Changing the state of a SCSI device via sysfs into "cancel" or
"deleted" prevents removal of these devices by scsi_remove_host().
Hence do not allow this. Also, introduce the symbolic name
INVALID_SDEV_STATE, representing a value different from any valid
SCSI device state. Update scsi_device_set_state() such that gcc
does not issue a warning about an enumeration value not being
handled inside a switch statement.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: David Milburn <dmilburn@redhat.com>
---
 drivers/scsi/scsi_lib.c    |    2 ++
 drivers/scsi/scsi_sysfs.c  |    5 +++--
 include/scsi/scsi_device.h |    6 +++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d57b5e1..e1cc1d1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2183,6 +2183,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		}
 		break;
 
+	case INVALID_SDEV_STATE:
+		goto illegal;
 	}
 	sdev->sdev_state = state;
 	return 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f869ef85..fe3ea686 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -594,7 +594,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 {
 	int i;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	enum scsi_device_state state = 0;
+	enum scsi_device_state state = INVALID_SDEV_STATE;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -604,7 +604,8 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 			break;
 		}
 	}
-	if (!state)
+	if (state == INVALID_SDEV_STATE || state == SDEV_CANCEL ||
+	    state == SDEV_DEL)
 		return -EINVAL;
 
 	if (scsi_device_set_state(sdev, state))
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cc64587..cc1b52a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -29,7 +29,11 @@ struct scsi_mode_data {
  * scsi_lib:scsi_device_set_state().
  */
 enum scsi_device_state {
-	SDEV_CREATED = 1,	/* device created but not added to sysfs
+	INVALID_SDEV_STATE,	/* Not a valid SCSI device state but a
+				 * symbolic name that can be used wherever
+				 * a value is needed that is different from
+				 * any valid SCSI device state. */
+	SDEV_CREATED,		/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
 	SDEV_RUNNING,		/* device properly configured
 				 * All commands allowed */
-- 
1.7.10.4

