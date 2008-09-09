From: Chris Leech <christopher.leech@intel.com>
Subject: [PATCH] 24-bit types: typedef and functions for accessing 3-byte
	arrays as integers
Date: Tue, 09 Sep 2008 15:59:30 -0700
Message-ID: <20080909225930.19495.64220.stgit@localhost.localdomain>
References: <41b516cb0809071052t1aea47b3hd7dc40d3bb1cfce3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15109 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYIIW7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2008 18:59:32 -0400
In-Reply-To: <41b516cb0809071052t1aea47b3hd7dc40d3bb1cfce3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>

Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
frame headers.  This patch defines __be24 and __le24 typedefs for a
structure wrapped around a 3-byte array, and functions to convert back and
forth to a 32-bit integer.

The undefs in iscsi_proto.h are because of the different calling
convention for the existing hton24 macro in the iSCSI code.  iSCSI will
be converted in a subsequent patch.

Changes from last posting:

Switched from preprocessor macros to inline functions.  The generated assembly
is the same with gcc 4.1.2 as long as the function is actually inlined.  I
applied the __always_inline attribute to all of these, after seeing that with
one of my test kernel configurations they were not being inlined without it
and the generated instructions in the iSCSI code could be considered a
regression from the existing macro.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
---

 include/linux/byteorder.h         |   44 ++++++++++++++++++++++++++++++++++++
 include/linux/byteorder/generic.h |   45 +++++++++++++++++++++++++++++++++++++
 include/linux/types.h             |    2 ++
 include/scsi/iscsi_proto.h        |    2 ++
 4 files changed, 93 insertions(+), 0 deletions(-)


diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index 29f002d..b48b88f 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -62,6 +62,42 @@
 # define __cpu_to_le64(x) ((__force __le64)__swab64(x))
 #endif
 
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
 /*
  * These helpers could be phased out over time as the base version
  * handles constant folding.
@@ -280,15 +316,19 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
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
 
@@ -332,11 +372,15 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
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
index 0846e6b..71b97dd 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -119,6 +119,47 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
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
+#define le24_to_cpu __le24_to_cpu
+#define cpu_to_le24 __cpu_to_le24
+#define be24_to_cpu __be24_to_cpu
+#define cpu_to_be24 __cpu_to_be24
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
@@ -134,11 +175,15 @@
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

