From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/6] [Target_Core_Mod/ConfigFS]: Add support for
	$STORAGE_OBJECT EVPD Unit Serial Number emulation
Date: Fri, 23 Jan 2009 17:59:26 -0800
Message-ID: <1232762366.24642.24.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:34483 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754024AbZAXB7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:59:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From a50c8a50550ab3d41f716711e08ec6f116a45f28 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:34:14 -0800
Subject: [PATCH 6/6] [Target_Core_Mod/ConfigFS]: Add support for $STORAGE_OBJECT EVPD Unit Serial Number emulation

This patch support for writeable EVPD Unit Serial configfs attribute at:

/sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/wwn/evpd_unit_serial

It works with Linux/Block and Linux/FILEIO $STORAGE_OBJECTS, as well as through
target_core_mod/RAMDISK subsystem plugins.

This logic checks se_subsystem_dev_t->su_dev_flags & SDF_FIRMWARE_EVPD_UNIT_SERIAL
to see if SCSI firmware (or software emulation for non SCSI devices) is being
handled by Linux/SCSI for us.  It does right by the firmware and if said device
reports EVPD INQUIRY response payload information see target_core_pscsi.c:
pscsi_transport_complete()

The changing of configfs evpd_unit_serial with this patch is limited to only while
said $STORAGE_OBJECT is *NOT* in use by $FABRIC_MOD exports.  This is mentioned
in the comment in target_core_dev_wwn_store_attr_evpd_unit_serial():

	<SNIP>
       /*
        * Check to see if any active $FABRIC_MOD exports exist.  If they
        * do exist, fail here as changing this information on the fly
        * (underneath the initiator side OS dependent multipath code)
        * could cause negative effects.
        */
       if ((dev = su_dev->se_dev_ptr)) {
               if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
                       printk(KERN_ERR "Unable to set EVPD Unit Serial while"
                               " active %d $FABRIC_MOD exports exist\n",
                               DEV_OBJ_API(dev)->check_count(
                                       &dev->dev_access_obj));
                       return(-EINVAL);
               }
       }
	<SNIP>

This logic may end up allowing to be overwritten for those who
"really know what they are doing" and to allow RAMDISK and IBLOCK/FILEIO
exports for the EVPD information that has no assoicated underlying
device firmware.  For now, this assoicated target_core_mod subsystem
plugin logic just disables emulation when firmware and Linux/SCSI LLDs
report EVPD to us upon $HBA/$STORAGE_OBJECT enablement.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |   59 +++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 5b1d275..1788fbb 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -38,6 +38,7 @@
 #include <target_core_device.h>
 #include <target_core_hba.h>
 #include <target_core_plugin.h>
+#include <target_core_seobj.h>
 #include <target_core_transport.h>
 
 #ifdef SNMP_SUPPORT
@@ -536,7 +537,7 @@ static ssize_t target_core_dev_wwn_show_attr_evpd_unit_serial (
         if (!(dev = se_dev->se_dev_ptr)) 
                 return(-ENODEV);
 
-	return(sprintf(page, "T10 EVPD Unit Serial Number:: %s\n",
+	return(sprintf(page, "T10 EVPD Unit Serial Number: %s\n",
 		&t10_wwn->unit_serial[0]));
 }
 
@@ -545,7 +546,61 @@ static ssize_t target_core_dev_wwn_store_attr_evpd_unit_serial (
 	const char *page,
 	size_t count)
 {
-	return(-ENOMEM);
+	se_subsystem_dev_t *su_dev = t10_wwn->t10_sub_dev;
+	se_device_t *dev;
+	unsigned char buf[INQUIRY_EVPD_SERIAL_LEN];
+
+	/*
+	 * If Linux/SCSI subsystem_api_t plugin got a EVPD Unit Serial
+	 * from the struct scsi_device level firmware, do not allow
+	 * EVPD Unit Serial to be emulated.
+	 *
+	 * Note this struct scsi_device could also be emulating EVPD
+	 * information from its drivers/scsi LLD.  But for now we assume
+	 * it is doing 'the right thing' wrt a world wide unique
+	 * EVPD Unit Serial Number that OS dependent multipath can depend on.
+	 */
+	if (su_dev->su_dev_flags & SDF_FIRMWARE_EVPD_UNIT_SERIAL) {
+		printk(KERN_ERR "Underlying SCSI device firmware provided EVPD"
+			" Unit Serial, ignoring request\n");
+		return(-EOPNOTSUPP);
+	}
+
+	if ((strlen(page) + 1) > INQUIRY_EVPD_SERIAL_LEN) {
+		printk(KERN_ERR "Emulated EVPD Unit Serial exceeds"
+		" INQUIRY_EVPD_SERIAL_LEN: %d\n", INQUIRY_EVPD_SERIAL_LEN);
+		return(-EOVERFLOW);
+	}
+	/*
+	 * Check to see if any active $FABRIC_MOD exports exist.  If they
+	 * do exist, fail here as changing this information on the fly 
+	 * (underneath the initiator side OS dependent multipath code)
+	 * could cause negative effects.
+	 */
+	if ((dev = su_dev->se_dev_ptr)) {
+		if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
+			printk(KERN_ERR "Unable to set EVPD Unit Serial while"
+				" active %d $FABRIC_MOD exports exist\n",
+				DEV_OBJ_API(dev)->check_count(
+					&dev->dev_access_obj));
+			return(-EINVAL);
+		}
+	}
+	/*
+	 * This currently assumes ASCII encoding for emulated EVPD Unit Serial.
+	 *
+	 * Also, strip any newline added from the userspace
+	 * echo $UUID > $TARGET/$HBA/$STORAGE_OBJECT/wwn/evpd_unit_serial
+	 */
+	memset(buf, 0, INQUIRY_EVPD_SERIAL_LEN);
+	snprintf(buf, INQUIRY_EVPD_SERIAL_LEN, "%s", page);
+	snprintf(su_dev->t10_wwn.unit_serial, INQUIRY_EVPD_SERIAL_LEN,
+			"%s", strstrip(buf));
+	su_dev->su_dev_flags |= SDF_EMULATED_EVPD_UNIT_SERIAL;
+
+	printk("Target_Core_ConfigFS: Set emulated EVPD Unit Serial: %s\n",
+			su_dev->t10_wwn.unit_serial);
+	return(count);
 }
 
 SE_DEV_WWN_ATTR(evpd_unit_serial, S_IRUGO | S_IWUSR);
-- 
1.5.4.1



