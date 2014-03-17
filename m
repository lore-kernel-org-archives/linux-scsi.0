From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFCv2 1/7] virtio-scsi.h: Add virtio_scsi_cmd_req_pi header definition
Date: Mon, 17 Mar 2014 05:32:55 +0000
Message-ID: <1395034381-656-2-git-send-email-nab@daterainc.com>
References: <1395034381-656-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395034381-656-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a virtio_scsi_cmd_req_pi header as recommened by
Paolo that contains do_pi_niov + di_pi_niov elements used for
signaling when protection information buffers are expected to
preceed the data buffers.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/virtio_scsi.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..4dc5998 100644
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
+	u16 do_pi_niov;		/* DataOUT PI Number of iovecs */
+	u16 di_pi_niov;		/* DataIN PI Number of iovecs */
+	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __packed;
+
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
 	u32 sense_len;		/* Sense data length */
-- 
1.7.2.5
