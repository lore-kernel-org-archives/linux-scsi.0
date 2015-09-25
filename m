From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 2/4] scsi: cleanup scsi/scsi_ioctl.h
Date: Fri, 25 Sep 2015 11:27:42 +0200
Message-ID: <1443173264-4105-3-git-send-email-pbonzini@redhat.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbbIYJ1y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 05:27:54 -0400
In-Reply-To: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

SCSI_REMOVAL_* goes together with other SCSI command constants in
include/scsi/scsi.h.  It is also used outside the implementation
of the ioctls (and it is not part of the user API).

scsi_fctargaddress/Scsi_FCTargAddress has had no in-tree use since
commit ca61f10ab2b8 ("[SCSI] remove broken driver cpqfc", 2005-10-29).
Remove it, just in time for the the tenth anniversary of its demise.

Cc: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
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


