From: James Hogan <james.hogan@imgtec.com>
Subject: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 10:15:33 +0100
Message-ID: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
List-Id: linux-scsi@vger.kernel.org

The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
used in struct osd_cdb_head, but it isn't marked as packed. Some
architectures will round the struct size up which triggers BUILD_BUG_ON
compile errors in osd_initiator.c when the outer structs are unexpected
sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 include/scsi/scsi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..3beaef3 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -198,7 +198,7 @@ struct scsi_varlen_cdb_hdr {
 	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
-};
+} __packed;
 
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
-- 
1.7.7.6
