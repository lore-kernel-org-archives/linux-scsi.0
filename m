From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH 3/6] scsi: hpsa: Add/mask existing devices on rescan if visibility changes
Date: Fri, 14 Dec 2018 18:21:12 +0500
Message-ID: <20181214132115.21440-4-mironov.ivan@gmail.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214132115.21440-1-mironov.ivan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

Controller may be switched between RAID and HBA modes even without a
reboot.

When changing to HBA mode, it does some internal reset magic and
automatically removes any configured RAID arrays. Without this patch,
driver successfully detects disappearance of logical arrays, but does
not expose any physical disks.

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
---
 drivers/scsi/hpsa.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ee3d7c722a63..60f1f7949d8d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1541,6 +1541,14 @@ static inline int device_updated(struct hpsa_scsi_dev_t *dev1,
 	return 0;
 }
 
+static inline bool device_expose_changed(struct hpsa_scsi_dev_t *dev1,
+	struct hpsa_scsi_dev_t *dev2)
+{
+	if (dev1->expose_device != dev2->expose_device)
+		return true;
+	return false;
+}
+
 /* Find needle in haystack.  If exact match found, return DEVICE_SAME,
  * and return needle location in *index.  If scsi3addr matches, but not
  * vendor, model, serial num, etc. return DEVICE_CHANGED, and return needle
@@ -1569,6 +1577,8 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 			if (device_is_the_same(needle, haystack[i])) {
 				if (device_updated(needle, haystack[i]))
 					return DEVICE_UPDATED;
+				if (device_expose_changed(needle, haystack[i]))
+					return DEVICE_CHANGED;
 				return DEVICE_SAME;
 			} else {
 				/* Keep offline devices offline */
-- 
2.19.2
