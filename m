From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/10] hpsa: update device attributes when they change
Date: Thu, 19 Jan 2012 14:01:30 -0600
Message-ID: <20120119200130.17835.54975.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@hp.com>

Certain types of changes to devices should not be interpreted as a device
change that would cause the device to be removed and re-added.  These include
RAID level and Firmware revision changes.  However, these attribute changes DO
need to be reflected in the controller info structure's dev structure list, so
that sysfs and /proc info files for the devices will reflect the new values.

Signed-off-by: Scott Teel <scott.stacy.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bf75e4c..56a4e8a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -675,6 +675,20 @@ lun_assigned:
 	return 0;
 }
 
+/* Update an entry in h->dev[] array. */
+static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
+	int entry, struct hpsa_scsi_dev_t *new_entry)
+{
+	/* assumes h->devlock is held */
+	BUG_ON(entry < 0 || entry >= HPSA_MAX_DEVICES);
+
+	/* Raid level changed. */
+	h->dev[entry]->raid_level = new_entry->raid_level;
+	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d updated.\n",
+		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,
+		new_entry->target, new_entry->lun);
+}
+
 /* Replace an entry from h->dev[] array. */
 static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 	int entry, struct hpsa_scsi_dev_t *new_entry,
@@ -781,10 +795,25 @@ static inline int device_is_the_same(struct hpsa_scsi_dev_t *dev1,
 	return 1;
 }
 
+static inline int device_updated(struct hpsa_scsi_dev_t *dev1,
+	struct hpsa_scsi_dev_t *dev2)
+{
+	/* Device attributes that can change, but don't mean
+	 * that the device is a different device, nor that the OS
+	 * needs to be told anything about the change.
+	 */
+	if (dev1->raid_level != dev2->raid_level)
+		return 1;
+	return 0;
+}
+
 /* Find needle in haystack.  If exact match found, return DEVICE_SAME,
  * and return needle location in *index.  If scsi3addr matches, but not
  * vendor, model, serial num, etc. return DEVICE_CHANGED, and return needle
- * location in *index.  If needle not found, return DEVICE_NOT_FOUND.
+ * location in *index.
+ * In the case of a minor device attribute change, such as RAID level, just
+ * return DEVICE_UPDATED, along with the updated device's location in index.
+ * If needle not found, return DEVICE_NOT_FOUND.
  */
 static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 	struct hpsa_scsi_dev_t *haystack[], int haystack_size,
@@ -794,15 +823,19 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 #define DEVICE_NOT_FOUND 0
 #define DEVICE_CHANGED 1
 #define DEVICE_SAME 2
+#define DEVICE_UPDATED 3
 	for (i = 0; i < haystack_size; i++) {
 		if (haystack[i] == NULL) /* previously removed. */
 			continue;
 		if (SCSI3ADDR_EQ(needle->scsi3addr, haystack[i]->scsi3addr)) {
 			*index = i;
-			if (device_is_the_same(needle, haystack[i]))
+			if (device_is_the_same(needle, haystack[i])) {
+				if (device_updated(needle, haystack[i]))
+					return DEVICE_UPDATED;
 				return DEVICE_SAME;
-			else
+			} else {
 				return DEVICE_CHANGED;
+			}
 		}
 	}
 	*index = -1;
@@ -838,6 +871,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	 * sd[] and remove them from h->dev[], and for any
 	 * devices which have changed, remove the old device
 	 * info and add the new device info.
+	 * If minor device attributes change, just update
+	 * the existing device structure.
 	 */
 	i = 0;
 	nremoved = 0;
@@ -858,6 +893,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 			 * at the bottom of hpsa_update_scsi_devices()
 			 */
 			sd[entry] = NULL;
+		} else if (device_change == DEVICE_UPDATED) {
+			hpsa_scsi_update_entry(h, hostno, i, sd[entry]);
 		}
 		i++;
 	}
