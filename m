From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10-PI: Getting failed tag info
Date: Mon, 15 Dec 2014 19:45:39 -0500
Message-ID: <yq1zjao8lsc.fsf@sermon.lab.mkp.net>
References: <54892468.5060300@vlnb.net> <yq1r3w5blys.fsf@sermon.lab.mkp.net>
	<20141215081857.GA24067@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25821 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaLPAqJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 19:46:09 -0500
In-Reply-To: <20141215081857.GA24067@infradead.org> (Christoph Hellwig's
	message of "Mon, 15 Dec 2014 00:18:57 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> I really don't like adding new errno codes for all these.

This was mainly done to accommodate Darrick's work on aio extensions. If
these errors were forever trapped inside the kernel I would agree with
you but the plan is to make this generally applicable.

Christoph> I'd much rather have a integrity error field with specific
Christoph> codes in the bio.

My original device qualification code did this. I also had one that
included a field for the offending LBA but that appears to be lost in
the mist of time.

(Patch against a 2.6.3x era kernel so will need some massaging).

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index ba48f0b..716285a 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -757,6 +757,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_idx = bip_src->bip_idx;
 	bip->bip_flags = bip_src->bip_flags;
+	bip->bip_completion = bip_src->bip_completion;
 
 	return 0;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1aa9ee4..b4c08b8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -163,6 +163,21 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+enum bio_integrity_errors {
+	BIP_ERR_NONE = 0,	/* no error */
+	BIP_ERR_CTRL_GUARD,	/* controller detected guard tag error */
+	BIP_ERR_CTRL_APP,	/* controller detected app tag error */
+	BIP_ERR_CTRL_REF,	/* controller detected ref tag error */
+	BIP_ERR_DISK_GUARD,	/* disk detected guard tag error */
+	BIP_ERR_DISK_APP,	/* disk detected app tag error */
+	BIP_ERR_DISK_REF,	/* disk detected ref tag error */
+};
+
+struct bio_integrity_completion {
+	enum bio_integrity_errors	error;
+};
+
 /*
  * bio integrity payload
  */
@@ -173,13 +188,14 @@ struct bio_integrity_payload {
 
 	void			*bip_buf;	/* generated integrity data */
 	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
+	struct bio_integrity_completion	*bip_completion; /* I/O completion */
 
 	unsigned int		bip_size;
 
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_idx;	/* current bip_vec index */
-	unsigned short		bip_flags;	/* control and status flags */
+	unsigned short		bip_flags;	/* control flags */
 
 	struct work_struct	bip_work;	/* I/O completion */
 	struct bio_vec		bip_vec[0];	/* embedded bvec array */

The thing that bugged me about this approach was the shared completion
mask for all clones. I felt that was a bit icky. However, it seemed like
a major hassle to have this be clone-private and have to register endio
handlers for each and every clone to get status bubbled up. That was
something that the switch to errnos handled much more elegantly.
However, if we want to have accurate offset reporting we will need to do
the completion struct thing.

Open to ideas. The many-clones-to-one-completion-status issue isn't
entirely trivial to tackle.

-- 
Martin K. Petersen	Oracle Linux Engineering
