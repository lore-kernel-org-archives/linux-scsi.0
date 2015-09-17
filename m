From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 2/4] scsi: cleanup scsi/scsi_ioctl.h
Date: Thu, 17 Sep 2015 15:42:16 +0200
Message-ID: <1442497338-17019-3-git-send-email-pbonzini@redhat.com>
References: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442497338-17019-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

SCSI_REMOVAL_* goes together with other SCSI command constants in
include/scsi/scsi.h.  It is also used outside the implementation
of the ioctls (and it is not part of the user API).

scsi_fctargaddress/Scsi_FCTargAddress has had no in-tree use since
commit ca61f10ab2b8 ("[SCSI] remove broken driver cpqfc", 2005-10-29).
Remove it, just in time for the the tenth anniversary of its demise.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/scsi/scsi.h       | 6 ++++++
 include/scsi/scsi_ioctl.h | 8 --------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e0a3398b1547..5e2bafdbd96f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -279,6 +279,12 @@ static inline int scsi_is_wlun(u64 lun)
 #define SCSI_INQ_PQ_NOT_CON     0x01
 #define SCSI_INQ_PQ_NOT_CAP     0x03
 
+/*
+ * PREVENT/ALLOW MEDIUM REMOVAL
+ */
+#define	SCSI_REMOVAL_PREVENT	1
+#define	SCSI_REMOVAL_ALLOW	0
+
 
 /*
  * Here are some scsi specific ioctl commands which are sometimes useful.
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index 8d19d1d233c3..c81962bef7a0 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -12,9 +12,6 @@
 #define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
 #define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
 
-#define	SCSI_REMOVAL_PREVENT	1
-#define	SCSI_REMOVAL_ALLOW	0
-
 #ifdef __KERNEL__
 
 struct scsi_device;
@@ -34,11 +31,6 @@ typedef struct scsi_idlun {
 	__u32 host_unique_id;
 } Scsi_Idlun;
 
-/* Fibre Channel WWN, port_id struct */
-typedef struct scsi_fctargaddress {
-	__u32 host_port_id;
-	unsigned char host_wwn[8]; // include NULL term.
-} Scsi_FCTargAddress;
 
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
-- 
2.5.0
