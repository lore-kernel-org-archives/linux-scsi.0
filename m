From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] target: add kernel-doc overview in target_core_user.[hc]
Date: Fri, 22 Dec 2017 21:40:38 -0800
Message-ID: <7e8662e8-f554-cc8c-0287-6a22f561692b@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Make documentation on target-supported userspace-I/O design be
usable by kernel-doc by using "DOC:".

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc:	"Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc:	"James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc:	"Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc:	Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc:	Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/target/target_core_user.c     |    6 +++++-
 include/uapi/linux/target_core_user.h |   11 ++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

--- linux-next-20171221.orig/drivers/target/target_core_user.c
+++ linux-next-20171221/drivers/target/target_core_user.c
@@ -42,7 +42,11 @@
 
 #include <linux/target_core_user.h>
 
-/*
+/**
+ * DOC: Userspace I/O
+ * Userspace I/O
+ * -------------
+ *
  * Define a shared-memory interface for LIO to pass SCSI commands and
  * data to userspace for processing. This is to allow backends that
  * are too complex for in-kernel support to be possible.
--- linux-next-20171221.orig/include/uapi/linux/target_core_user.h
+++ linux-next-20171221/include/uapi/linux/target_core_user.h
@@ -9,21 +9,22 @@
 
 #define TCMU_VERSION "2.0"
 
-/*
+/**
+ * DOC: Ring Design
  * Ring Design
  * -----------
  *
  * The mmaped area is divided into three parts:
- * 1) The mailbox (struct tcmu_mailbox, below)
- * 2) The command ring
- * 3) Everything beyond the command ring (data)
+ * 1) The mailbox (struct tcmu_mailbox, below);
+ * 2) The command ring;
+ * 3) Everything beyond the command ring (data).
  *
  * The mailbox tells userspace the offset of the command ring from the
  * start of the shared memory region, and how big the command ring is.
  *
  * The kernel passes SCSI commands to userspace by putting a struct
  * tcmu_cmd_entry in the ring, updating mailbox->cmd_head, and poking
- * userspace via uio's interrupt mechanism.
+ * userspace via UIO's interrupt mechanism.
  *
  * tcmu_cmd_entry contains a header. If the header type is PAD,
  * userspace should skip hdr->length bytes (mod cmdr_size) to find the


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
