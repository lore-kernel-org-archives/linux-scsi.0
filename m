From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/2] hpsa: export resettable host attribute
Date: Wed, 09 Mar 2011 17:00:06 -0600
Message-ID: <20110309230006.26877.68951.stgit@beardog.cce.hp.com>
References: <20110309225822.26877.94051.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110309225822.26877.94051.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This attribute, requested by Redhat, allows kexec-tools to know
whether the controller can honor the reset_devices kernel parameter
and actually reset the controller.  For kdump to work properly it
is necessary that the reset_devices parameter be honored.  This
attribute enables kexec-tools to warn the user if they attempt to
designate a non-resettable controller as the dump device.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/scsi/hpsa.txt |   12 ++++++++++++
 drivers/scsi/hpsa.c         |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
index dca6583..8b418b3 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.txt
@@ -39,6 +39,7 @@ HPSA specific entries in /sys
 
   /sys/class/scsi_host/host*/rescan
   /sys/class/scsi_host/host*/firmware_revision
+  /sys/class/scsi_host/host*/resettable
 
   the host "rescan" attribute is a write only attribute.  Writing to this
   attribute will cause the driver to scan for new, changed, or removed devices
@@ -55,6 +56,17 @@ HPSA specific entries in /sys
 	root@host:/sys/class/scsi_host/host4# cat firmware_revision
 	7.14
 
+  The "resettable" read-only attribute indicates whether a particular
+  controller is able to honor the "reset_devices" kernel parameter.  If the
+  device is resettable, this file will contain a "1", otherwise, a "0".  This
+  parameter is used by kdump, for example, to reset the controller at driver
+  load time to eliminate any outstanding commands on the controller and get the
+  controller into a known state so that the kdump initiated i/o will work right
+  and not be disrupted in any way by stale commands or other stale state
+  remaining on the controller from the previous kernel.  This attribute enables
+  kexec tools to warn the user if they attempt to designate a device which is
+  unable to honor the reset_devices kernel parameter as a dump device.
+
   HPSA specific disk attributes:
   ------------------------------
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dcabef4..415ad4f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -273,6 +273,44 @@ static ssize_t host_show_transport_mode(struct device *dev,
 			"performant" : "simple");
 }
 
+/* List of controllers which cannot be reset on kexec with reset_devices */
+static u32 unresettable_controller[] = {
+	0x324a103C, /* Smart Array P712m */
+	0x324b103C, /* SmartArray P711m */
+	0x3223103C, /* Smart Array P800 */
+	0x3234103C, /* Smart Array P400 */
+	0x3235103C, /* Smart Array P400i */
+	0x3211103C, /* Smart Array E200i */
+	0x3212103C, /* Smart Array E200 */
+	0x3213103C, /* Smart Array E200i */
+	0x3214103C, /* Smart Array E200i */
+	0x3215103C, /* Smart Array E200i */
+	0x3237103C, /* Smart Array E500 */
+	0x323D103C, /* Smart Array P700m */
+	0x409C0E11, /* Smart Array 6400 */
+	0x409D0E11, /* Smart Array 6400 EM */
+};
+
+static int ctlr_is_resettable(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
+		if (unresettable_controller[i] == h->board_id)
+			return 0;
+	return 1;
+}
+
+static ssize_t host_show_resettable(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h));
+}
+
 static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 {
 	return (scsi3addr[3] & 0xC0) == 0x40;
@@ -379,6 +417,8 @@ static DEVICE_ATTR(commands_outstanding, S_IRUGO,
 	host_show_commands_outstanding, NULL);
 static DEVICE_ATTR(transport_mode, S_IRUGO,
 	host_show_transport_mode, NULL);
+static DEVICE_ATTR(resettable, S_IRUGO,
+	host_show_resettable, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -392,6 +432,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_firmware_revision,
 	&dev_attr_commands_outstanding,
 	&dev_attr_transport_mode,
+	&dev_attr_resettable,
 	NULL,
 };
 
