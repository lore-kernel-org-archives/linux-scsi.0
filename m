From: Sam Ravnborg <sam@ravnborg.org>
Subject: scsi_netlink: fix userspace warnings in scsi_netlink.h
Date: Sun, 15 Aug 2010 22:12:05 +0200
Message-ID: <20100815201205.GB4571@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

"make headers_check" gave following warning:

CHECK   include/scsi (3 files)
include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>

It has previously been discussed the value of fixing
scsi headers because glibc had their own copies of scsi headers.

But that does not matter at all as there may ibe other
users of the exported headers and exported headers
should be warning free.

The following patch does two things:
1) include linux/types.h as suggested in the warning
2) replace all uses of uintxx_t with the kernel exportable variants

uintxx_t belongs to the namespace of
userspace - and not in the kernel.
At least not in the exprted headers.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 58ce8fe..180ed38 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -23,6 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
+#include <linux/types.h>
 
 
 /*
@@ -40,12 +41,12 @@
 
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
@@ -89,10 +90,10 @@ struct scsi_nl_hdr {
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
