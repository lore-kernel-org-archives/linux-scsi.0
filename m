From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH 1/4] 24-bit types: typedef and functions for accessing 3-byte
	arrays as integers
Date: Wed, 10 Sep 2008 19:14:48 -0700
Message-ID: <20080911021448.23621.42553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYIKCOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 22:14:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Harvey Harrison <harvey.harrison@gmail.com>, Chris Leech <christopher.leech@intel.com>

Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
frame headers.  This patch defines __be24 and __le24 typedefs for a
structure wrapped around a 3-byte array, and functions to convert back and
forth to a 32-bit integer.

The undefs in iscsi_proto.h are because of the different calling
convention for the existing hton24 macro in the iSCSI code.  iSCSI will
be converted in a subsequent patch.

The undefs in fs/jfs/endian24.h allow JFS to continue using it's own le24
conversion macros.  JFS is converted to use these types and functions in a
subsequent patch.

Change from last posting:

Moved the 24-bit inline functions to their own header instead of having
duplicate definitions in linux/byteorder.h and linux/byteorder/generic.h

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 fs/jfs/endian24.h                 |    5 ++++
 include/linux/byteorder.h         |    9 ++++++++
 include/linux/byteorder/generic.h |   10 ++++++++
 include/linux/endian24.h          |   44 +++++++++++++++++++++++++++++++++++++
 include/linux/types.h             |    2 ++
 include/scsi/iscsi_proto.h        |    2 ++
 6 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/endian24.h


diff --git a/fs/jfs/endian24.h b/fs/jfs/endian24.h
index fa92f7f..45b6397 100644
--- a/fs/jfs/endian24.h
+++ b/fs/jfs/endian24.h
@@ -33,6 +33,9 @@
 		((__x & (__u32)0x00ff0000UL) >> 16) )); \
 })
 
+#undef __cpu_to_le24
+#undef __le24_to_cpu
+
 #if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
 	#define __cpu_to_le24(x) ((__u32)(x))
 	#define __le24_to_cpu(x) ((__u32)(x))
@@ -42,6 +45,8 @@
 #endif
 
 #ifdef __KERNEL__
+	#undef cpu_to_le24
+	#undef le24_to_cpu
 	#define cpu_to_le24 __cpu_to_le24
 	#define le24_to_cpu __le24_to_cpu
 #endif
diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index 29f002d..2334e3f 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/swab.h>
+#include <linux/endian24.h>
 
 #if defined(__LITTLE_ENDIAN) && defined(__BIG_ENDIAN)
 # error Fix asm/byteorder.h to define one endianness
@@ -280,15 +281,19 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 #ifdef __KERNEL__
 
 # define le16_to_cpu __le16_to_cpu
+# define le24_to_cpu __le24_to_cpu
 # define le32_to_cpu __le32_to_cpu
 # define le64_to_cpu __le64_to_cpu
 # define be16_to_cpu __be16_to_cpu
+# define be24_to_cpu __be24_to_cpu
 # define be32_to_cpu __be32_to_cpu
 # define be64_to_cpu __be64_to_cpu
 # define cpu_to_le16 __cpu_to_le16
+# define cpu_to_le24 __cpu_to_le24
 # define cpu_to_le32 __cpu_to_le32
 # define cpu_to_le64 __cpu_to_le64
 # define cpu_to_be16 __cpu_to_be16
+# define cpu_to_be24 __cpu_to_be24
 # define cpu_to_be32 __cpu_to_be32
 # define cpu_to_be64 __cpu_to_be64
 
@@ -332,11 +337,15 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 # define ___htons(x) __cpu_to_be16(x)
 # define ___ntohl(x) __be32_to_cpu(x)
 # define ___ntohs(x) __be16_to_cpu(x)
+# define ___hton24(x) __cpu_to_be24(x)
+# define ___ntoh24(x) __be24_to_cpu(x)
 
 # define htonl(x) ___htonl(x)
 # define ntohl(x) ___ntohl(x)
 # define htons(x) ___htons(x)
 # define ntohs(x) ___ntohs(x)
+# define hton24(x) ___hton24(x)
+# define ntoh24(x) ___ntoh24(x)
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..87cbec2 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_BYTEORDER_GENERIC_H
 #define _LINUX_BYTEORDER_GENERIC_H
 
+#include <linux/endian24.h>
+
 /*
  * linux/byteorder_generic.h
  * Generic Byte-reordering support
@@ -86,12 +88,16 @@
 #define le64_to_cpu __le64_to_cpu
 #define cpu_to_le32 __cpu_to_le32
 #define le32_to_cpu __le32_to_cpu
+#define cpu_to_le24 __cpu_to_le24
+#define le24_to_cpu __le24_to_cpu
 #define cpu_to_le16 __cpu_to_le16
 #define le16_to_cpu __le16_to_cpu
 #define cpu_to_be64 __cpu_to_be64
 #define be64_to_cpu __be64_to_cpu
 #define cpu_to_be32 __cpu_to_be32
 #define be32_to_cpu __be32_to_cpu
+#define cpu_to_be24 __cpu_to_be24
+#define be24_to_cpu __be24_to_cpu
 #define cpu_to_be16 __cpu_to_be16
 #define be16_to_cpu __be16_to_cpu
 #define cpu_to_le64p __cpu_to_le64p
@@ -134,11 +140,15 @@
 #define ___htons(x) __cpu_to_be16(x)
 #define ___ntohl(x) __be32_to_cpu(x)
 #define ___ntohs(x) __be16_to_cpu(x)
+#define ___hton24(x) __cpu_to_be24(x)
+#define ___ntoh24(x) __be24_to_cpu(x)
 
 #define htonl(x) ___htonl(x)
 #define ntohl(x) ___ntohl(x)
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)
+#define hton24(x) ___hton24(x)
+#define ntoh24(x) ___ntoh24(x)
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
diff --git a/include/linux/endian24.h b/include/linux/endian24.h
new file mode 100644
index 0000000..beffa57
--- /dev/null
+++ b/include/linux/endian24.h
@@ -0,0 +1,44 @@
+#ifndef _LINUX_ENDIAN24_H
+#define _LINUX_ENDIAN24_H
+
+#if !defined(_LINUX_BYTEORDER_H) && !defined(_LINUX_BYTEORDER_GENERIC_H)
+#error "do not include linux/endian24.h directly, use asm/byteorder.h instead"
+#endif
+
+/**
+ * __le24_to_cpu - read a 3-byte array as a 24-bit little-endian integer
+ * @x: __le24, a structure wrapper around a 3-byte array
+ */
+static __always_inline __u32 __le24_to_cpu(const __le24 x)
+{
+	return (__u32) ((x.b[2] << 16) | (x.b[1] << 8) | (x.b[0]));
+}
+
+/**
+ * __cpu_to_le24 - store a value in a 3-byte array in little-endian format
+ * @x: __u32, there is no checking to ensure only the lower 24 bits are set
+ */
+static __always_inline __le24 __cpu_to_le24(const __u32 x)
+{
+	return (__le24) { { x & 0xff, (x >> 8) & 0xff, (x >> 16) & 0xff } };
+}
+
+/**
+ * __be24_to_cpu - read a 3-byte array as a 24-bit big-endian integer
+ * @x: __be24, a structure wrapper around a 3-byte array
+ */
+static __always_inline __u32 __be24_to_cpu(const __be24 x)
+{
+	return (__u32) ((x.b[0] << 16) | (x.b[1] << 8) | (x.b[2]));
+}
+
+/**
+ * __cpu_to_be24 - store a value in a 3-byte array in big-endian format
+ * @x: __u32, there is no checking to ensure only the lower 24 bits are set
+ */
+static __always_inline __be24 __cpu_to_be24(const __u32 x)
+{
+	return (__be24) { { (x >> 16) & 0xff, (x >> 8) & 0xff, x & 0xff } };
+}
+
+#endif /* _LINUX_ENDIAN24_H */
diff --git a/include/linux/types.h b/include/linux/types.h
index d4a9ce6..85fcff7 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -188,6 +188,8 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
+typedef struct { __u8 b[3]; } __be24, __le24;
+
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index f2a2c11..429c5ff 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -35,6 +35,8 @@
 /*
  * useful common(control and data pathes) macro
  */
+#undef ntoh24
+#undef hton24
 #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
 #define hton24(p, v) { \
         p[0] = (((v) >> 16) & 0xFF); \

