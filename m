From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: add heartbeat sysfs host attribute
Date: Fri, 12 Aug 2011 13:03:14 -0500
Message-ID: <20110812180314.21808.59261.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:6039 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1HLSDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2011 14:03:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The cciss driver had a CCISS_HEARTBEAT ioctl which
was not implemented in hpsa.  This ioctl returned a
counter from a register on the Smart Array which the
firmware would periodically update.  It can be used
to detect certain kinds of faults (e.g. controller
lockup) by noticing when the value remains constant
for more than a second or two.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/scsi/hpsa.txt |    8 ++++++++
 drivers/scsi/hpsa.c         |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
index 891435a..0dac1e0 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.txt
@@ -47,6 +47,7 @@ HPSA specific entries in /sys
   /sys/class/scsi_host/host*/firmware_revision
   /sys/class/scsi_host/host*/resettable
   /sys/class/scsi_host/host*/transport_mode
+  /sys/class/scsi_host/host*/heartbeat
 
   the host "rescan" attribute is a write only attribute.  Writing to this
   attribute will cause the driver to scan for new, changed, or removed devices
@@ -78,6 +79,13 @@ HPSA specific entries in /sys
   kexec tools to warn the user if they attempt to designate a device which is
   unable to honor the reset_devices kernel parameter as a dump device.
 
+  The "heartbeat" read-only attribute returns the value of a heartbeat
+  counter register on a Smart Array controller as a 32 bit unsigned
+  hexadecimal integer (e.g: "0x12345678").  The value should change
+  periodically, not less than once per second.  If this value fails to
+  change for a period longer than one second, it means something has
+  gone wrong (e.g. Smart Array controller firmware has locked up.)
+
   HPSA specific disk attributes:
   ------------------------------
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b200b73..ce6bde4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -340,6 +340,21 @@ static ssize_t host_show_resettable(struct device *dev,
 	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h->board_id));
 }
 
+static ssize_t host_show_heartbeat(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+	u32 heartbeat;
+	unsigned long flags;
+
+	h = shost_to_hba(shost);
+	spin_lock_irqsave(&h->lock, flags);
+	heartbeat = readl(&h->cfgtable->HeartBeat);
+	spin_unlock_irqrestore(&h->lock, flags);
+	return snprintf(buf, 20, "0x%08x\n", heartbeat);
+}
+
 static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 {
 	return (scsi3addr[3] & 0xC0) == 0x40;
@@ -448,6 +463,8 @@ static DEVICE_ATTR(transport_mode, S_IRUGO,
 	host_show_transport_mode, NULL);
 static DEVICE_ATTR(resettable, S_IRUGO,
 	host_show_resettable, NULL);
+static DEVICE_ATTR(heartbeat, S_IRUGO,
+	host_show_heartbeat, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -462,6 +479,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_commands_outstanding,
 	&dev_attr_transport_mode,
 	&dev_attr_resettable,
+	&dev_attr_heartbeat,
 	NULL,
 };
 

