From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH 2/3] uapi: fix scsi/scsi_netlink_fc.h userspace compilation errors
Date: Wed, 1 Mar 2017 03:12:22 +0300
Message-ID: <20170301001222.GC11188@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Consistently use types from linux/types.h to fix the following
scsi/scsi_netlink_fc.h userspace compilation errors:

/usr/include/scsi/scsi_netlink_fc.h:60:2: error: unknown type name 'uint64_t'
  uint64_t seconds;
/usr/include/scsi/scsi_netlink_fc.h:61:2: error: unknown type name 'uint64_t'
  uint64_t vendor_id;
/usr/include/scsi/scsi_netlink_fc.h:62:2: error: unknown type name 'uint16_t'
  uint16_t host_no;
/usr/include/scsi/scsi_netlink_fc.h:63:2: error: unknown type name 'uint16_t'
  uint16_t event_datalen;
/usr/include/scsi/scsi_netlink_fc.h:64:2: error: unknown type name 'uint32_t'
  uint32_t event_num;
/usr/include/scsi/scsi_netlink_fc.h:65:2: error: unknown type name 'uint32_t'
  uint32_t event_code;
/usr/include/scsi/scsi_netlink_fc.h:66:2: error: unknown type name 'uint32_t'
  uint32_t event_data;
/usr/include/scsi/scsi_netlink_fc.h:67:33: error: 'uint64_t' undeclared here (not in a function)
 } __attribute__((aligned(sizeof(uint64_t))));

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/scsi/scsi_netlink_fc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scsi/scsi_netlink_fc.h
index cbf76e4..2493a0f 100644
--- a/include/uapi/scsi/scsi_netlink_fc.h
+++ b/include/uapi/scsi/scsi_netlink_fc.h
@@ -57,14 +57,14 @@
  */
 struct fc_nl_event {
 	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
-	uint64_t seconds;
-	uint64_t vendor_id;
-	uint16_t host_no;
-	uint16_t event_datalen;
-	uint32_t event_num;
-	uint32_t event_code;
-	uint32_t event_data;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u64 seconds;
+	__u64 vendor_id;
+	__u16 host_no;
+	__u16 event_datalen;
+	__u32 event_num;
+	__u32 event_code;
+	__u32 event_data;
+} __attribute__((aligned(sizeof(__u64))));
 
 
 #endif /* SCSI_NETLINK_FC_H */
-- 
ldv
