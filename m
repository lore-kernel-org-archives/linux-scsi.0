From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/4] block: Integrity profile init function to trigger module loads
Date: Sat, 25 Aug 2018 22:40:06 -0400
Message-ID: <20180826024006.13800-4-martin.petersen@oracle.com>
References: <20180825061205.ygrjjazkooqghrqy@gondor.apana.org.au>
 <20180826024006.13800-1-martin.petersen@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180826024006.13800-1-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: Jeff.Lien@wdc.com, ard.biesheuvel@linaro.org, david.darrington@wdc.com, hch@infradead.org, jeff.furlong@wdc.com, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, tim.c.chen@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

The T10 CRC library function is built into the kernel and therefore
registered early. The hardware-accelerated CRC helpers are typically
loaded as modules and only become available later in the boot
sequence. A separate patch modifies the T10 CRC library to subscribe
to notifications from crypto and permits switching from the
table-based algorithm to a hardware accelerated ditto once the
relevant module is loaded.

However, since the dependency for "crc10dif" is already satisfied,
nothing is going to cause the hardware-accelerated kernel modules to
get loaded. Introduce an init_fn in the integrity profile that can be
called to trigger a load of modules providing the T10 CRC calculation
capability. This function will ony get called when a new integrity
profile is registered during device discovery.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c  |  5 +++++
 block/t10-pi.c         | 10 ++++++++++
 include/linux/blkdev.h |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 6121611e1316..5cacae9a2dc2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -27,6 +27,7 @@
 #include <linux/scatterlist.h>
 #include <linux/export.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "blk.h"
 
@@ -391,6 +392,7 @@ static blk_status_t blk_integrity_nop_fn(struct blk_integrity_iter *iter)
 
 static const struct blk_integrity_profile nop_profile = {
 	.name = "nop",
+	.init_fn = NULL,
 	.generate_fn = blk_integrity_nop_fn,
 	.verify_fn = blk_integrity_nop_fn,
 };
@@ -418,6 +420,9 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 
+	if (bi->profile->init_fn)
+		bi->profile->init_fn();
+
 	disk->queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
 }
 EXPORT_SYMBOL(blk_integrity_register);
diff --git a/block/t10-pi.c b/block/t10-pi.c
index a98db384048f..b83278f9163a 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -24,6 +24,7 @@
 #include <linux/t10-pi.h>
 #include <linux/blkdev.h>
 #include <linux/crc-t10dif.h>
+#include <linux/module.h>
 #include <net/checksum.h>
 
 typedef __be16 (csum_fn) (void *, unsigned int);
@@ -157,8 +158,14 @@ static blk_status_t t10_pi_type3_verify_ip(struct blk_integrity_iter *iter)
 	return t10_pi_verify(iter, t10_pi_ip_fn, 3);
 }
 
+static void t10_pi_crc_init(void)
+{
+	request_module_nowait(CRC_T10DIF_STRING);
+}
+
 const struct blk_integrity_profile t10_pi_type1_crc = {
 	.name			= "T10-DIF-TYPE1-CRC",
+	.init_fn		= t10_pi_crc_init,
 	.generate_fn		= t10_pi_type1_generate_crc,
 	.verify_fn		= t10_pi_type1_verify_crc,
 };
@@ -166,6 +173,7 @@ EXPORT_SYMBOL(t10_pi_type1_crc);
 
 const struct blk_integrity_profile t10_pi_type1_ip = {
 	.name			= "T10-DIF-TYPE1-IP",
+	.init_fn		= NULL,
 	.generate_fn		= t10_pi_type1_generate_ip,
 	.verify_fn		= t10_pi_type1_verify_ip,
 };
@@ -173,6 +181,7 @@ EXPORT_SYMBOL(t10_pi_type1_ip);
 
 const struct blk_integrity_profile t10_pi_type3_crc = {
 	.name			= "T10-DIF-TYPE3-CRC",
+	.init_fn		= t10_pi_crc_init,
 	.generate_fn		= t10_pi_type3_generate_crc,
 	.verify_fn		= t10_pi_type3_verify_crc,
 };
@@ -180,6 +189,7 @@ EXPORT_SYMBOL(t10_pi_type3_crc);
 
 const struct blk_integrity_profile t10_pi_type3_ip = {
 	.name			= "T10-DIF-TYPE3-IP",
+	.init_fn		= NULL,
 	.generate_fn		= t10_pi_type3_generate_ip,
 	.verify_fn		= t10_pi_type3_verify_ip,
 };
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 79226ca8f80f..a43c02e4f43d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1806,10 +1806,12 @@ struct blk_integrity_iter {
 };
 
 typedef blk_status_t (integrity_processing_fn) (struct blk_integrity_iter *);
+typedef void (integrity_init_fn) (void);
 
 struct blk_integrity_profile {
 	integrity_processing_fn		*generate_fn;
 	integrity_processing_fn		*verify_fn;
+	integrity_init_fn		*init_fn;
 	const char			*name;
 };
 
-- 
2.17.1
