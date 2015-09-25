From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 3/4] scsi: move all obsolete ioctls to scsi_ioctl.h
Date: Fri, 25 Sep 2015 11:27:43 +0200
Message-ID: <1443173264-4105-4-git-send-email-pbonzini@redhat.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some are in scsi.h.  Keep them together in preparation for exposing them
in UAPI headers.

Cc: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/scsi/scsi.h       | 20 --------------------
 include/scsi/scsi_ioctl.h | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5e2bafdbd96f..a96df31af89e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -286,26 +286,6 @@ static inline int scsi_is_wlun(u64 lun)
 #define	SCSI_REMOVAL_ALLOW	0
 
 
-/*
- * Here are some scsi specific ioctl commands which are sometimes useful.
- *
- * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
- */
-
-/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
-#define SCSI_IOCTL_GET_IDLUN		0x5382
-
-/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
-
-/* Used to obtain the host number of a device. */
-#define SCSI_IOCTL_PROBE_HOST		0x5385
-
-/* Used to obtain the bus number for a device */
-#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
-
-/* Used to obtain the PCI location of a device */
-#define SCSI_IOCTL_GET_PCI		0x5387
-
 /* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
 static inline __u32 scsi_to_u32(__u8 *ptr)
 {
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index c81962bef7a0..2bd9d67c201a 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -12,6 +12,26 @@
 #define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
 #define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
 
+/*
+ * Here are some obsolete SCSI-specific ioctl commands.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ */
+
+/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
+#define SCSI_IOCTL_GET_IDLUN		0x5382
+
+/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
+
+/* Used to obtain the host number of a device. */
+#define SCSI_IOCTL_PROBE_HOST		0x5385
+
+/* Used to obtain the bus number for a device */
+#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
+
+/* Used to obtain the PCI location of a device */
+#define SCSI_IOCTL_GET_PCI		0x5387
+
 #ifdef __KERNEL__
 
 struct scsi_device;
-- 
2.5.0
