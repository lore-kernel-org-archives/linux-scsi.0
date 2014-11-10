From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 1/5] [SCSI] Fnic: Not probing all the vNICS via fnic_probe on boot
Date: Mon, 10 Nov 2014 12:54:32 -0800
Message-ID: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:57178 "EHLO
	alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKJVC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 16:02:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

In fnic_dev_wait, Wait for finish to complete at least three times in two
seconds while loop before returning -ETIMEDOUT as sometime
 schedule_timeout_uninterruptible takes more than two seconds to wake up.

- Increment fnic version from 1.6.0.11 to 1.6.0.12

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_main.c | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index bf8d34c..69dee68 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.11"
+#define DRV_VERSION		"1.6.0.12"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8c56fdc..782e6a8 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -438,21 +438,30 @@ static int fnic_dev_wait(struct vnic_dev *vdev,
 	unsigned long time;
 	int done;
 	int err;
+	int count;
+
+	count = 0;
 
 	err = start(vdev, arg);
 	if (err)
 		return err;
 
-	/* Wait for func to complete...2 seconds max */
+	/* Wait for func to complete.
+	* Sometime schedule_timeout_uninterruptible take long time
+	* to wake up so we do not retry as we are only waiting for
+	* 2 seconds in while loop. By adding count, we make sure
+	* we try atleast three times before returning -ETIMEDOUT
+	*/
 	time = jiffies + (HZ * 2);
 	do {
 		err = finished(vdev, &done);
+		count++;
 		if (err)
 			return err;
 		if (done)
 			return 0;
 		schedule_timeout_uninterruptible(HZ / 10);
-	} while (time_after(time, jiffies));
+	} while (time_after(time, jiffies) || (count < 3));
 
 	return -ETIMEDOUT;
 }
-- 
1.8.5.4

