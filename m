From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 11/15] Staging: hv: storvsc: Cleanup the code for generating protocol version
Date: Thu, 12 Jan 2012 12:38:04 -0800
Message-ID: <1326400688-13544-11-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56911
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755478Ab2ALUlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 15:41:46 -0500
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Cleanup the code for generating protocol version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index da71294..629edd1 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -61,10 +61,13 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  * version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1).
  */
 
-#define VMSTOR_PROTOCOL_MAJOR(VERSION_)		(((VERSION_) >> 8) & 0xff)
-#define VMSTOR_PROTOCOL_MINOR(VERSION_)		(((VERSION_))      & 0xff)
-#define VMSTOR_PROTOCOL_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
-						 (((MINOR_) & 0xff)))
+static inline u16 storvsc_get_version(u8 major, u8 minor)
+{
+	u16 version;
+
+	version = ((major << 8) | minor);
+	return version;
+}
 
 /*
  * Version history:
@@ -74,9 +77,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  * Win7: 4.2
  */
 
-#define VMSTOR_PROTOCOL_VERSION_CURRENT VMSTOR_PROTOCOL_VERSION(4, 2)
-
-
+#define VMSTOR_CURRENT_MAJOR  4
+#define VMSTOR_CURRENT_MINOR  2
 
 
 /*
@@ -170,7 +172,7 @@ struct vmstorage_channel_properties {
 /*  This structure is sent during the storage protocol negotiations. */
 struct vmstorage_protocol_version {
 	/* Major (MSW) and minor (LSW) version numbers. */
-	unsigned short major_minor;
+	u16 major_minor;
 
 	/*
 	 * Revision number is auto-incremented whenever this file is changed
@@ -179,7 +181,7 @@ struct vmstorage_protocol_version {
 	 * builds.
 	 * This is only used on the windows side. Just set it to 0.
 	 */
-	unsigned short revision;
+	u16 revision;
 } __packed;
 
 /* Channel Property Flags */
@@ -687,7 +689,12 @@ static int storvsc_channel_init(struct hv_device *device)
 	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
 	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	vstor_packet->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
+	vstor_packet->version.major_minor =
+		storvsc_get_version(VMSTOR_CURRENT_MAJOR, VMSTOR_CURRENT_MINOR);
+
+	/*
+	 * The revision number is only used in Windows; set it to 0.
+	 */
 	vstor_packet->version.revision = 0;
 
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
-- 
1.7.4.1

