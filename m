From: <gregkh@suse.de>
Subject: patch firmware-provide-stubs-for-the-fw_loader-n-case.patch added to gregkh-2.6 tree
Date: Fri, 07 Mar 2008 09:08:40 -0800
Message-ID: <1204909720886@kroah.org>
References: <1204901874.2889.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981AbYCGRJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2008 12:09:17 -0500
In-Reply-To: <1204901874.2889.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, djwong@us.ibm.com, greg@kroah.com, gregkh@suse.de, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com


This is a note to let you know that I've just added the patch titled

     Subject: firmware: provide stubs for the FW_LOADER=n case

to my gregkh-2.6 tree.  Its filename is

     firmware-provide-stubs-for-the-fw_loader-n-case.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From James.Bottomley@HansenPartnership.com  Fri Mar  7 08:30:11 2008
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Fri, 07 Mar 2008 08:57:54 -0600
Subject: firmware: provide stubs for the FW_LOADER=n case
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>
Message-ID: <1204901874.2889.3.camel@localhost.localdomain>


libsas has a case where it uses the firmware loader to provide services,
but doesn't want to select it all the time.  This currently causes a
compile failure in libsas if FW_LOADER=n.  Fix this by providing error
stubs for the firmware loader API in the FW_LOADER=n case.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/firmware.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -10,7 +10,10 @@ struct firmware {
 	size_t size;
 	u8 *data;
 };
+
 struct device;
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
@@ -19,4 +22,24 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+#else
+static inline int request_firmware(const struct firmware **fw,
+				   const char *name,
+				   struct device *device)
+{
+	return -EINVAL;
+}
+static inline int request_firmware_nowait(
+	struct module *module, int uevent,
+	const char *name, struct device *device, void *context,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	return -EINVAL;
+}
+
+static inline void release_firmware(const struct firmware *fw)
+{
+}
+#endif
+
 #endif


Patches currently in gregkh-2.6 which might be from James.Bottomley@HansenPartnership.com are

pci/pci-remove-parisc-consumer-of-the-pci-global_list.patch
usb/usb-enable-usb-persist-by-default.patch
driver-core/firmware-provide-stubs-for-the-fw_loader-n-case.patch
