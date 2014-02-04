From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio_integrity_add_page: check for BIO_POOL_NONE before determining nr_vecs on slab
Date: Mon, 03 Feb 2014 22:55:35 -0500
Message-ID: <yq18utrzg3s.fsf@sermon.lab.mkp.net>
References: <1391013923-24072-1-git-send-email-dmilburn@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391013923-24072-1-git-send-email-dmilburn@redhat.com> (David
	Milburn's message of "Wed, 29 Jan 2014 10:45:23 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, JBottomley@Parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "David" == David Milburn <dmilburn@redhat.com> writes:

David> When enabling DIX T10-DIF-TYPE1-IP protection you can hit the
David> bip_vec full condition which fails to attach the integrity
David> metadata and returns 0 back to bio_integrity_prep()

Looks like Kent accidentally broke this when he changed the bvec pool
setup.

David> - if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
David> + if (bip->bip_slab != BIO_POOL_NONE &&
David> +     bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
David>  		printk(KERN_ERR "%s: bip_vec full\n", __func__);
David>  		return 0;
David>  	}

We still need to check that the page will actually fit, though:


block: Fix nr_vecs for inline integrity vectors

Commit 9f060e2231ca changed the way we handle allocations for the
integrity vectors. When the vectors are inline there is no associated
slab and consequently bvec_nr_vecs() returns 0. Ensure that we check
against BIP_INLINE_VECS in that case.

Reported-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fc60b31453ee..6dea2b90b4d5 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -114,6 +114,14 @@ void bio_integrity_free(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_free);
 
+static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
+{
+	if (bip->bip_slab == BIO_POOL_NONE)
+		return BIP_INLINE_VECS;
+
+	return bvec_nr_vecs(bip->bip_slab);
+}
+
 /**
  * bio_integrity_add_page - Attach integrity metadata
  * @bio:	bio to update
@@ -129,7 +137,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
+	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
