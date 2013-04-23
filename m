From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] libcxgbi: supress warning when we request to much space from kmalloc
Date: Tue, 23 Apr 2013 11:20:47 -0400
Message-ID: <1366730447-32428-1-git-send-email-nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

cxgbi_alloc_big_mem allocates large chunks of memory, and can occasionally
request amounts from kmalloc that exceed the allocators capacity.  This
typically leads to a stack trace from the zoned buddy allocator in the message
log.  But if kmalloc fails, cxgbi_alloc_big_mem backs off and uses vmalloc
instead.  Given that, and the fact that the two calls sites have their own error
messages if both kmalloc and vmalloc fail, I think the stack trace printing
isn't really needed.

Modify the call to kmalloc to pass __GFP_NOWARN in as well, so that internal
kmalloc warnings are suppressed.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Honggang LI <honli@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/cxgbi/libcxgbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 80fa99b..3daf996 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -658,7 +658,7 @@ static inline u32 cxgbi_tag_nonrsvd_bits(struct cxgbi_tag_format *tformat,
 static inline void *cxgbi_alloc_big_mem(unsigned int size,
 					gfp_t gfp)
 {
-	void *p = kmalloc(size, gfp);
+	void *p = kmalloc(size, gfp | __GFP_NOWARN);
 	if (!p)
 		p = vmalloc(size);
 	if (p)
-- 
1.8.1.4
