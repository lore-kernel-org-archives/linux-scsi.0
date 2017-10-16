From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2] linux/types.h: Restore the ability to disable sparse endianness checks
Date: Mon, 16 Oct 2017 10:26:33 -0700
Message-ID: <20171016172633.29290-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The purpose of patch "linux/types.h: enable endian checks for all
sparse builds" was to encourage driver authors to annotate
endianness correctly in their drivers. However, since that patch
went upstream no endianness annotations in drivers have been fixed.
I think that this shows that the followed approach does not work,
probably because several driver authors do not use sparse. For
developers who are not the authors of these drivers it would take
a very significant effort to make these drivers endianness clean.
Examples are drivers/scsi/qla2xxx and drivers/infiniband/hw/nes.
Hence restore the ability to disable sparse endianness checks such
that it becomes again easy to review other sparse diagnostics for
people who want to analyze drivers they are not the author of.

References: commit 05de97003c77 ("linux/types.h: enable endian checks for all sparse builds")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
[v2]: Elaborated patch description

 include/uapi/linux/types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index 41e5914f0a8e..d3dcb0764c45 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -23,7 +23,11 @@
 #else
 #define __bitwise__
 #endif
+#if !defined(__CHECK_ENDIAN__) || __CHECK_ENDIAN__ != 0
 #define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
