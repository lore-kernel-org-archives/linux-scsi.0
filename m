From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
Date: Wed, 19 Dec 2018 16:31:14 +0800
Message-ID: <1545208274-13736-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit bc73905abf770192 ("[SCSI] lpfc 8.3.16: SLI Additions, updates,
and code cleanup"), lpfc_memcpy_to_slim() have switched memcpy_toio() to
__write32_copy() in order to prevent unaligned 64 bit copy. Recently, we
found that lpfc_memcpy_from_slim() have similar issues, so let it switch
memcpy_fromio() to __read32_copy().

As maintainer says, it seems that we can hardly see a real "unaligned 64
bit copy", but this patch is still useful. Because in our tests we found
that lpfc doesn't support 128 bit access, but some optimized memcpy()
use 128 bit access (at lease on Loongson).

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
V2: Update commit message.

 drivers/scsi/lpfc/lpfc_compat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
index 43cf46a..0cd1e3c 100644
--- a/drivers/scsi/lpfc/lpfc_compat.h
+++ b/drivers/scsi/lpfc/lpfc_compat.h
@@ -91,8 +91,8 @@ lpfc_memcpy_to_slim( void __iomem *dest, void *src, unsigned int bytes)
 static inline void
 lpfc_memcpy_from_slim( void *dest, void __iomem *src, unsigned int bytes)
 {
-	/* actually returns 1 byte past dest */
-	memcpy_fromio( dest, src, bytes);
+	/* convert bytes in argument list to word count for copy function */
+	__ioread32_copy(dest, src, bytes / sizeof(uint32_t));
 }
 
 #endif	/* __BIG_ENDIAN */
-- 
2.7.0
