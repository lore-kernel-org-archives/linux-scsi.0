From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/2] hpsa: export resettable_on_kexec host attribute
Date: Tue, 08 Mar 2011 17:10:03 -0600
Message-ID: <20110308231003.22291.20417.stgit@beardog.cce.hp.com>
References: <20110308230749.22291.56200.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21023 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1CHXKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 18:10:04 -0500
In-Reply-To: <20110308230749.22291.56200.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This attribute, requested by Redhat, allows kexec-tools to know
whether the controller can honor the reset_devices kernel parameter
and actually reset the controller.  For kdump to work properly it
is necessary that the reset_devices parameter be honored.  This
attribute enables kexec-tools to warn the user if they attempt to
designate a non-resettable controller as the dump device.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dcabef4..1d4fe80 100644
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
+	0x3223103C, /* Smart Array P800 */
+	0x3234103C, /* Smart Array P400 */
+	0x323D103C, /* Smart Array P700m */
+};
+
+static int resettable_on_kexec(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
+		if (unresettable_controller[i] == h->board_id)
+			return 0;
+	return 1;
+}
+
+static ssize_t host_show_resettable_on_kexec(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	h = shost_to_hba(shost);
+	return snprintf(buf, 20, "%d\n", resettable_on_kexec(h));
+}
+
 static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 {
 	return (scsi3addr[3] & 0xC0) == 0x40;
@@ -379,6 +417,8 @@ static DEVICE_ATTR(commands_outstanding, S_IRUGO,
 	host_show_commands_outstanding, NULL);
 static DEVICE_ATTR(transport_mode, S_IRUGO,
 	host_show_transport_mode, NULL);
+static DEVICE_ATTR(resettable_on_kexec, S_IRUGO,
+	host_show_resettable_on_kexec, NULL);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
@@ -392,6 +432,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_firmware_revision,
 	&dev_attr_commands_outstanding,
 	&dev_attr_transport_mode,
+	&dev_attr_resettable_on_kexec,
 	NULL,
 };
 

