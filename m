From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] drivers/scsi/aic94xx/aic94xx_hwi.c: add missing kfree
Date: Sun, 29 Apr 2012 22:03:17 +0200
Message-ID: <1335729797-20604-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The free is not strictly necessary, because as long as the tc_index_array
field is not NULL, the free will performed by the calling context, in the
function asd_destroy_ha_caches.  But doing it here in this case, makes this
case consistent with the rest of the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Alternatively, the frees could be dropped from the subsequent block of
error-handling code.

 drivers/scsi/aic94xx/aic94xx_hwi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 81b736c..f7c093c 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -228,8 +228,11 @@ static int asd_init_scbs(struct asd_ha_struct *asd_ha)
 	bitmap_bytes = (asd_ha->seq.tc_index_bitmap_bits+7)/8;
 	bitmap_bytes = BITS_TO_LONGS(bitmap_bytes*8)*sizeof(unsigned long);
 	asd_ha->seq.tc_index_bitmap = kzalloc(bitmap_bytes, GFP_KERNEL);
-	if (!asd_ha->seq.tc_index_bitmap)
+	if (!asd_ha->seq.tc_index_bitmap) {
+		kfree(asd_ha->seq.tc_index_array);
+		asd_ha->seq.tc_index_array = NULL;
 		return -ENOMEM;
+	}
 
 	spin_lock_init(&seq->tc_index_lock);
 
