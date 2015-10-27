From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scsi: hpsa: fix multiple issues in path_info_show
Date: Tue, 27 Oct 2015 23:16:43 +0100
Message-ID: <1445984203-3288-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Handzik <joseph.t.handzik@hp.com>, Don Brace <don.brace@pmcs.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Kevin Barnett <kevin.barnett@pmcs.com>, Scott Teel <scott.teel@pmcs.com>, Tomas Henzl <thenzl@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm not familiar with this code, but path_info_show() (added in
8270b86243658 "hpsa: add sysfs entry path_info to show box and
bay information") seems to be broken in multiple ways.

First, there's

  817 return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
  818         path[0], path[1], path[2], path[3],
  819         path[4], path[5], path[6], path[7]);

so hopefully output_len contains the combined length of the eight
strings. Otherwise, snprintf will stop copying to the output
buffer, but still end up reporting that combined length - which
in turn would result in user-space getting a bunch of useless nul
bytes (thankfully the upper sysfs layer seems to clear the output
buffer before passing it to the various ->show routines). But we have

  767         output_len = snprintf(path[i],
  768                         PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s ",
  769                         h->scsi_host->host_no,
  770                         hdev->bus, hdev->target, hdev->lun,
  771                         scsi_device_type(hdev->devtype));

so output_len at best contains the length of the last string printed.

Inside the loop, we then otherwise add to output_len. By magic,
we still have PATH_STRING_LEN available every time... This
wouldn't really be a problem if the bean-counting has been done
properly and each line actually does fit in 50 bytes, and maybe
it does, but I don't immediately see why. Suppose we end up
taking this branch:

  802                         output_len += snprintf(path[i] + output_len,
  803                                 PATH_STRING_LEN,
  804                                 "BOX: %hhu BAY: %hhu %s\n",
  805                                 box, bay, active);

An optimistic estimate says this uses strlen("BOX: 1 BAY: 2
Active\n") which is 21. Now add the 20 bytes guaranteed by the
%20.20s and then some for the rest of that format string, and
we're easily over 50 bytes. I don't think we can get over 100
bytes even being pessimistic, so this just means we'll scribble
into the next path[i+1] and maybe get that overwritten later,
leading to some garbled output (in fact, since we'd overwrite the
previous string's 0-terminator, we could end up with one very
long string and then print various suffixes of that, leading to
much more than 400 bytes of output). Except of course when we're
filling path[7], where overrunning it means writing random stuff
to the kernel stack, which is usually a lot of fun.

We can fix all of that and get rid of the 400 byte stack buffer by
simply writing directly to the given output buffer, which the upper
layer guarantees is at least PAGE_SIZE. s[c]nprintf doesn't care where
it is writing to, so this doesn't make the spin lock hold time any
longer. Using scnprintf ensures that output_len always represents the
number of bytes actually written to the buffer, so we'll report the
proper amount to the upper layer.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/hpsa.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8dd0df..b892ae90e292 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -726,7 +726,6 @@ static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
 }
 
 #define MAX_PATHS 8
-#define PATH_STRING_LEN 50
 
 static ssize_t path_info_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
@@ -742,9 +741,7 @@ static ssize_t path_info_show(struct device *dev,
 	u8 path_map_index = 0;
 	char *active;
 	unsigned char phys_connector[2];
-	unsigned char path[MAX_PATHS][PATH_STRING_LEN];
 
-	memset(path, 0, MAX_PATHS * PATH_STRING_LEN);
 	sdev = to_scsi_device(dev);
 	h = sdev_to_hba(sdev);
 	spin_lock_irqsave(&h->devlock, flags);
@@ -764,8 +761,9 @@ static ssize_t path_info_show(struct device *dev,
 		else
 			continue;
 
-		output_len = snprintf(path[i],
-				PATH_STRING_LEN, "[%d:%d:%d:%d] %20.20s ",
+		output_len += scnprintf(buf + output_len,
+				PAGE_SIZE - output_len,
+				"[%d:%d:%d:%d] %20.20s ",
 				h->scsi_host->host_no,
 				hdev->bus, hdev->target, hdev->lun,
 				scsi_device_type(hdev->devtype));
@@ -773,9 +771,9 @@ static ssize_t path_info_show(struct device *dev,
 		if (is_ext_target(h, hdev) ||
 			(hdev->devtype == TYPE_RAID) ||
 			is_logical_dev_addr_mode(hdev->scsi3addr)) {
-			output_len += snprintf(path[i] + output_len,
-						PATH_STRING_LEN, "%s\n",
-						active);
+			output_len += scnprintf(buf + output_len,
+						PAGE_SIZE - output_len,
+						"%s\n", active);
 			continue;
 		}
 
@@ -787,36 +785,34 @@ static ssize_t path_info_show(struct device *dev,
 		if (phys_connector[1] < '0')
 			phys_connector[1] = '0';
 		if (hdev->phys_connector[i] > 0)
-			output_len += snprintf(path[i] + output_len,
-				PATH_STRING_LEN,
+			output_len += scnprintf(buf + output_len,
+				PAGE_SIZE - output_len,
 				"PORT: %.2s ",
 				phys_connector);
 		if (hdev->devtype == TYPE_DISK &&
 			hdev->expose_state != HPSA_DO_NOT_EXPOSE) {
 			if (box == 0 || box == 0xFF) {
-				output_len += snprintf(path[i] + output_len,
-					PATH_STRING_LEN,
+				output_len += scnprintf(buf + output_len,
+					PAGE_SIZE - output_len,
 					"BAY: %hhu %s\n",
 					bay, active);
 			} else {
-				output_len += snprintf(path[i] + output_len,
-					PATH_STRING_LEN,
+				output_len += scnprintf(buf + output_len,
+					PAGE_SIZE - output_len,
 					"BOX: %hhu BAY: %hhu %s\n",
 					box, bay, active);
 			}
 		} else if (box != 0 && box != 0xFF) {
-			output_len += snprintf(path[i] + output_len,
-				PATH_STRING_LEN, "BOX: %hhu %s\n",
+			output_len += scnprintf(buf + output_len,
+				PAGE_SIZE - output_len, "BOX: %hhu %s\n",
 				box, active);
 		} else
-			output_len += snprintf(path[i] + output_len,
-				PATH_STRING_LEN, "%s\n", active);
+			output_len += scnprintf(buf + output_len,
+				PAGE_SIZE - output_len, "%s\n", active);
 	}
 
 	spin_unlock_irqrestore(&h->devlock, flags);
-	return snprintf(buf, output_len+1, "%s%s%s%s%s%s%s%s",
-		path[0], path[1], path[2], path[3],
-		path[4], path[5], path[6], path[7]);
+	return output_len;
 }
 
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
-- 
2.6.1
