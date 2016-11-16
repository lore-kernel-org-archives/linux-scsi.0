From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] bfa: turn bfa_mem_{kva,dma}_setup into inline functions
Date: Wed, 16 Nov 2016 16:14:27 +0100
Message-ID: <20161116151445.3208739-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51107 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcKPPPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 10:15:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

These two macros cause lots of warnings with gcc-7:

drivers/scsi/bfa/bfa_svc.c: In function 'bfa_fcxp_meminfo':
drivers/scsi/bfa/bfa_svc.c:521:103: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

Using inline functions makes them much more readable and avoids
the warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfa_ioc.h | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 523fb02109b6..c27ed80f12ab 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -111,20 +111,24 @@ struct bfa_meminfo_s {
 	struct bfa_mem_kva_s kva_info;
 };
 
-/* BFA memory segment setup macros */
-#define bfa_mem_dma_setup(_meminfo, _dm_ptr, _seg_sz) do {	\
-	((bfa_mem_dma_t *)(_dm_ptr))->mem_len = (_seg_sz);	\
-	if (_seg_sz)						\
-		list_add_tail(&((bfa_mem_dma_t *)_dm_ptr)->qe,	\
-			      &(_meminfo)->dma_info.qe);	\
-} while (0)
+/* BFA memory segment setup helpers */
+static inline void bfa_mem_dma_setup(struct bfa_meminfo_s *meminfo,
+				     struct bfa_mem_dma_s *dm_ptr,
+				     size_t seg_sz)
+{
+	dm_ptr->mem_len = seg_sz;
+	if (seg_sz)
+		list_add_tail(&dm_ptr->qe, &meminfo->dma_info.qe);
+}
 
-#define bfa_mem_kva_setup(_meminfo, _kva_ptr, _seg_sz) do {	\
-	((bfa_mem_kva_t *)(_kva_ptr))->mem_len = (_seg_sz);	\
-	if (_seg_sz)						\
-		list_add_tail(&((bfa_mem_kva_t *)_kva_ptr)->qe,	\
-			      &(_meminfo)->kva_info.qe);	\
-} while (0)
+static inline void bfa_mem_kva_setup(struct bfa_meminfo_s *meminfo,
+				     struct bfa_mem_kva_s *kva_ptr,
+				     size_t seg_sz)
+{
+	kva_ptr->mem_len = seg_sz;
+	if (seg_sz)
+		list_add_tail(&kva_ptr->qe, &meminfo->kva_info.qe);
+}
 
 /* BFA dma memory segments iterator */
 #define bfa_mem_dma_sptr(_mod, _i)	(&(_mod)->dma_seg[(_i)])
-- 
2.9.0

