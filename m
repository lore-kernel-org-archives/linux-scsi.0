From: David Milburn <dmilburn@redhat.com>
Subject: [PATCH] bio_integrity_add_page: check for BIO_POOL_NONE before determining nr_vecs on slab
Date: Wed, 29 Jan 2014 10:45:23 -0600
Message-ID: <1391013923-24072-1-git-send-email-dmilburn@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, JBottomley@Parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When enabling DIX T10-DIF-TYPE1-IP protection you can hit the
bip_vec full condition which fails to attach the integrity metadata
and returns 0 back to bio_integrity_prep()

[    3.837493] sd 0:0:17:1089486880: [sda] Enabling DIX T10-DIF-TYPE1-IP protection
[    3.839089] sd 0:0:17:1089486880: [sda] Attached SCSI disk
[    3.841309] bio_integrity_add_page: bip_vec full

<debug>
[  439.180928] bio_integrity_prep: sectors 8 len 64
[  439.180929] bio_integrity_prep: nr_pages 1 end 706577 start 706576
[  439.180930] bio_integrity_alloc: bs 00000000b2c87880 nr_vecs 1
[  439.180931] bio_integrity_alloc: nr_vecs 1 inline_vecs 4
[  439.180932] bio_integrity_alloc: bip->bip_vec 00000000aeaf9158 bip->bip_slab 15
[  439.180933] bio_integrity_prep: offset 704 nr_pages 1
[  439.180934] bio_integrity_add_page: len 64 offset 704
[  439.180935] bio_integrity_add_page: bip_vec full bip_vcnt 0 bvec_nr_vecs 0 bip_slab 15
<debug>

Ultimately you can BUG_ON(!nents) in scsi_alloc_sgtable()

scsi_init_io
 blk_integrity_rq
  scsi_alloc_sgtable

With attached patch device functions normally

<dmesg>
[  198.481838] sd 0:0:24:1089486880: [sda] Enabling DIF Type 1 protection
[  198.481845] sd 0:0:24:1089486880: [sda] 209715200 512-byte logical blocks: (107 GB/100 GiB)
[  198.482552] sd 0:0:24:1089486880: [sda] Write Protect is off
[  198.482556] sd 0:0:24:1089486880: [sda] Mode Sense: ed 00 00 08
[  198.482889] sd 0:0:24:1089486880: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  198.485850]  sda: sda1
[  198.485926] sd 0:0:24:1089486880: [sda] Enabling DIX T10-DIF-TYPE1-IP protection
[  198.487652] sd 0:0:24:1089486880: [sda] Attached SCSI disk
[  276.566682] XFS (sda1): Mounting Filesystem
[  276.576558] XFS (sda1): Ending clean mount
<dmesg>

Signed-off-by: David Milburn <dmilburn@redhat.com>
---
 fs/bio-integrity.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 45e944f..9d36a09 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -129,7 +129,8 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
+	if (bip->bip_slab != BIO_POOL_NONE && 
+	    bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
