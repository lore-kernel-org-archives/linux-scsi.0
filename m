From: Sage Weil <sage@newdream.net>
Subject: [PATCH 6/8] ceph-rbd: osdc support for osd call and rollback operations
Date: Fri, 13 Aug 2010 10:40:38 -0700
Message-ID: <1281721240-26130-7-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net
List-Id: linux-scsi@vger.kernel.org

From: Yehuda Sadeh <yehuda@hq.newdream.net>

This will be used for rbd snapshots administration.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/decode.h     |    5 +++++
 fs/ceph/osd_client.c |   18 ++++++++++++++++++
 fs/ceph/osd_client.h |    6 ++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/decode.h b/fs/ceph/decode.h
index 3d25415..c5b6939 100644
--- a/fs/ceph/decode.h
+++ b/fs/ceph/decode.h
@@ -191,6 +191,11 @@ static inline void ceph_encode_string(void **p, void *end,
 		ceph_encode_need(p, end, n, bad);		\
 		ceph_encode_copy(p, pv, n);			\
 	} while (0)
+#define ceph_encode_string_safe(p, end, s, n, bad)		\
+	do {							\
+		ceph_encode_need(p, end, n, bad);		\
+		ceph_encode_string(p, end, s, n);		\
+	} while (0)
 
 
 #endif
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index 8b1d0a6..34f6fe6 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -161,6 +161,7 @@ static int op_needs_trail(int op)
 	case CEPH_OSD_OP_GETXATTR:
 	case CEPH_OSD_OP_SETXATTR:
 	case CEPH_OSD_OP_CMPXATTR:
+	case CEPH_OSD_OP_CALL:
 		return 1;
 	default:
 		return 0;
@@ -301,6 +302,23 @@ static void osd_req_encode_op(struct ceph_osd_request *req,
 		ceph_pagelist_append(req->r_trail, src->xattr.val,
 				     src->xattr.value_len);
 		break;
+	case CEPH_OSD_OP_CALL:
+		BUG_ON(!req->r_trail);
+
+		dst->cls.class_len = src->cls.class_len;
+		dst->cls.method_len = src->cls.method_len;
+		dst->cls.indata_len = cpu_to_le32(src->cls.indata_len);
+
+		ceph_pagelist_append(req->r_trail, src->cls.class_name,
+				     src->cls.class_len);
+		ceph_pagelist_append(req->r_trail, src->cls.method_name,
+				     src->cls.method_len);
+		ceph_pagelist_append(req->r_trail, src->cls.indata,
+				     src->cls.indata_len);
+		break;
+	case CEPH_OSD_OP_ROLLBACK:
+		dst->snap.snapid = cpu_to_le64(src->snap.snapid);
+		break;
 	case CEPH_OSD_OP_STARTSYNC:
 		break;
 	default:
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index 0a82bd1..6c91fb0 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -135,14 +135,20 @@ struct ceph_osd_req_op {
 			__u8 cmp_mode;     /* CEPH_OSD_CMPXATTR_MODE_* */
 		} xattr;
 		struct {
+			const char *class_name;
 			__u8 class_len;
+			const char *method_name;
 			__u8 method_len;
 			__u8 argc;
+			const char *indata;
 			u32 indata_len;
 		} cls;
 		struct {
 			u64 cookie, count;
 		} pgls;
+	        struct {
+		        u64 snapid;
+	        } snap;
 	};
 	u32 payload_len;
 };
-- 
1.7.0
