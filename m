From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
Date: Fri, 26 Jan 2018 20:53:06 +0800
Message-ID: <1516971186-20372-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In commit bc73905abf770192 ("[SCSI] lpfc 8.3.16: SLI Additions, updates,
and code cleanup"), lpfc_memcpy_to_slim() have switched memcpy_toio() to
__write32_copy() in order to prevent unaligned 64 bit copy. Recently, we
found that lpfc_memcpy_from_slim() have similar issues, so let it switch
memcpy_fromio() to __read32_copy().

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/scsi/lpfc/lpfc_compat.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
index 6b32b0a..47d4fad 100644
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
