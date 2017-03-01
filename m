From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH 1/3] uapi: fix scsi/scsi_netlink.h userspace compilation errors
Date: Wed, 1 Mar 2017 03:12:17 +0300
Message-ID: <20170301001217.GB11188@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Consistently use types from linux/types.h to fix the following
scsi/scsi_netlink.h userspace compilation errors:

/usr/include/scsi/scsi_netlink.h:43:2: error: unknown type name 'uint8_t'
  uint8_t version;
/usr/include/scsi/scsi_netlink.h:44:2: error: unknown type name 'uint8_t'
  uint8_t transport;
/usr/include/scsi/scsi_netlink.h:45:2: error: unknown type name 'uint16_t'
  uint16_t magic;
/usr/include/scsi/scsi_netlink.h:46:2: error: unknown type name 'uint16_t'
  uint16_t msgtype;
/usr/include/scsi/scsi_netlink.h:47:2: error: unknown type name 'uint16_t'
  uint16_t msglen;
/usr/include/scsi/scsi_netlink.h:48:33: error: 'uint64_t' undeclared here (not in a function)
 } __attribute__((aligned(sizeof(uint64_t))));
/usr/include/scsi/scsi_netlink.h:92:2: error: expected specifier-qualifier-list before 'uint64_t'
  uint64_t vendor_id;

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/scsi/scsi_netlink.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_netlink.h
index 62b4eda..20360e1 100644
--- a/include/uapi/scsi/scsi_netlink.h
+++ b/include/uapi/scsi/scsi_netlink.h
@@ -40,12 +40,12 @@
 
 /* SCSI_TRANSPORT_MSG event message header */
 struct scsi_nl_hdr {
-	uint8_t version;
-	uint8_t transport;
-	uint16_t magic;
-	uint16_t msgtype;
-	uint16_t msglen;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u8 version;
+	__u8 transport;
+	__u16 magic;
+	__u16 msgtype;
+	__u16 msglen;
+} __attribute__((aligned(sizeof(__u64))));
 
 /* scsi_nl_hdr->version value */
 #define SCSI_NL_VERSION				1
@@ -89,10 +89,10 @@ struct scsi_nl_hdr {
  */
 struct scsi_nl_host_vendor_msg {
 	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
-	uint64_t vendor_id;
-	uint16_t host_no;
-	uint16_t vmsg_datalen;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u64 vendor_id;
+	__u16 host_no;
+	__u16 vmsg_datalen;
+} __attribute__((aligned(sizeof(__u64))));
 
 
 /*
-- 
ldv
