From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
Date: Thu, 22 May 2014 02:26:17 +0000
Message-ID: <1400725582-5521-2-git-send-email-nab@daterainc.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1400725582-5521-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a virtio_scsi_cmd_req_pi header as recommened by
Paolo that contains do_pi_niov + di_pi_niov elements used for
signaling when protection information buffers are expected to
preceed the data buffers.

Also add new VIRTIO_SCSI_F_T10_PI feature bit to be used to signal
host support.

v4 changes:
   - Use pi_bytesout + pi_bytesin instead of niovs (mst + paolo)

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/virtio_scsi.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..7344906 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -35,11 +35,23 @@ struct virtio_scsi_cmd_req {
 	u8 lun[8];		/* Logical Unit Number */
 	u64 tag;		/* Command identifier */
 	u8 task_attr;		/* Task attribute */
-	u8 prio;
+	u8 prio;		/* SAM command priority field */
 	u8 crn;
 	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
 } __packed;
 
+/* SCSI command request, followed by protection information */
+struct virtio_scsi_cmd_req_pi {
+	u8 lun[8];		/* Logical Unit Number */
+	u64 tag;		/* Command identifier */
+	u8 task_attr;		/* Task attribute */
+	u8 prio;		/* SAM command priority field */
+	u8 crn;
+	u32 pi_bytesout;	/* DataOUT PI Number of bytes */
+	u32 pi_bytesin;		/* DataIN PI Number of bytes */
+	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __packed;
+
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
 	u32 sense_len;		/* Sense data length */
@@ -97,6 +109,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_F_INOUT                    0
 #define VIRTIO_SCSI_F_HOTPLUG                  1
 #define VIRTIO_SCSI_F_CHANGE                   2
+#define VIRTIO_SCSI_F_T10_PI		       3
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
-- 
1.7.10.4
