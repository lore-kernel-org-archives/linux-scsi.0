From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/5] md: add cpu cache flushes after kmapping and modifying a page
Date: Sun, 4 Jun 2006 12:41:20 +0900
Message-ID: <11493924803060-git-send-email-htejun@gmail.com>
References: <1149392479501-git-send-email-htejun@gmail.com>
Reply-To: Tejun Heo <htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1149392479501-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, rmk@arm.linux.org.uk, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Add calls to flush_kernel_dcache_page() after CPU has kmapped and
modified a page.  This fixes PIO cache coherency bugs on architectures
with aliased caches.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

 drivers/md/raid1.c     |    1 +
 drivers/md/raid5.c     |    6 ++++--
 drivers/md/raid6main.c |    6 ++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

716500bdf7de6acb87e36c8146d83dd3c429bc82
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4070eff..30ca7cf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -720,6 +720,7 @@ static struct page **alloc_behind_pages(
 			goto do_sync_io;
 		memcpy(kmap(pages[i]) + bvec->bv_offset,
 			kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
+		flush_kernel_dcache_page(pages[i]);
 		kunmap(pages[i]);
 		kunmap(bvec->bv_page);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3184360..3adb64f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -813,10 +813,12 @@ static void copy_data(int frombio, struc
 			
 		if (clen > 0) {
 			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
-			if (frombio)
+			if (frombio) {
 				memcpy(pa+page_offset, ba+b_offset, clen);
-			else
+			} else {
 				memcpy(ba+b_offset, pa+page_offset, clen);
+				flush_kernel_dcache_page(kmap_atomic_to_page(ba));
+			}
 			__bio_kunmap_atomic(ba, KM_USER0);
 		}
 		if (clen < len) /* hit end of page */
diff --git a/drivers/md/raid6main.c b/drivers/md/raid6main.c
index bc69355..b9700bd 100644
--- a/drivers/md/raid6main.c
+++ b/drivers/md/raid6main.c
@@ -727,10 +727,12 @@ static void copy_data(int frombio, struc
 
 		if (clen > 0) {
 			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
-			if (frombio)
+			if (frombio) {
 				memcpy(pa+page_offset, ba+b_offset, clen);
-			else
+			} else {
 				memcpy(ba+b_offset, pa+page_offset, clen);
+				flush_kernel_dcache_page(kmap_atomic_to_page(ba));
+			}
 			__bio_kunmap_atomic(ba, KM_USER0);
 		}
 		if (clen < len) /* hit end of page */
-- 
1.3.2


