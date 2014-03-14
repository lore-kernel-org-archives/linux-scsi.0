From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2] scsi: Change sense buffer size to 252
Date: Fri, 14 Mar 2014 14:00:05 +0800
Message-ID: <1394776805-6784-1-git-send-email-famz@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaCNF75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 01:59:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, hare@suse.de

According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
increase the values.

Tested by hacking QEMU to fake virtio-scsi request sense len to 252.
Without this patch the driver stops working immediately when it gets the
request.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/linux/virtio_scsi.h | 2 +-
 include/scsi/scsi_cmnd.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..a437f7f 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -28,7 +28,7 @@
 #define _LINUX_VIRTIO_SCSI_H
 
 #define VIRTIO_SCSI_CDB_SIZE   32
-#define VIRTIO_SCSI_SENSE_SIZE 96
+#define VIRTIO_SCSI_SENSE_SIZE 252
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91558a1..a64dac03 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -104,7 +104,7 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-#define SCSI_SENSE_BUFFERSIZE 	96
+#define SCSI_SENSE_BUFFERSIZE 	252
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
-- 
1.9.0

