From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] firmware: provide stubs for the FW_LOADER=n case
Date: Fri, 07 Mar 2008 08:57:54 -0600
Message-ID: <1204901874.2889.3.camel@localhost.localdomain>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com>
	 <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com>
	 <20080306210212.GC7430@tree.beaverton.ibm.com>
	 <1204838233.3062.53.camel@localhost.localdomain>
	 <20080306140437.8a193423.randy.dunlap@oracle.com>
	 <1204841781.3062.69.camel@localhost.localdomain>
	 <20080307045413.GB913@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36811 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759457AbYCGO57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 09:57:59 -0500
In-Reply-To: <20080307045413.GB913@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

libsas has a case where it uses the firmware loader to provide services,
but doesn't want to select it all the time.  This currently causes a
compile failure in libsas if FW_LOADER=n.  Fix this by providing error
stubs for the firmware loader API in the FW_LOADER=n case.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

On Thu, 2008-03-06 at 20:54 -0800, Greg KH wrote:
> Yes, this is what I was thinking was needed.
> 
> Care to resend it with a signed-off-by?
> 
> thanks,

Sure, attached.

James

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 33d8f20..4d10c73 100644
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




