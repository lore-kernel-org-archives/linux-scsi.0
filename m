From: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Tue, 10 Apr 2012 13:38:53 +0100
Message-ID: <4F8429DD.3010700@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
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
index f34a5a8..c75c8c8 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -196,7 +196,7 @@ struct scsi_varlen_cdb_hdr {
 	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
-};
+} __packed;
 
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
-- 
1.7.7.6
