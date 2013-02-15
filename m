From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v9 4/9] Disallow changing the device state via sysfs into
 "deleted"
Date: Fri, 15 Feb 2013 13:06:56 +0100
Message-ID: <511E24E0.9040502@acm.org>
References: <511E23DD.2030309@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:43218 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab3BOMG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 07:06:57 -0500
In-Reply-To: <511E23DD.2030309@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

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
index 555d2a8..d2a2a2f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2179,6 +2179,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		}
 		break;
 
+	case INVALID_SDEV_STATE:
+		goto illegal;
 	}
 	sdev->sdev_state = state;
 	return 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c46751b..47c1e0e 100644
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
index e65c62e..08a2878 100644
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

