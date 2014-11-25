From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Tue, 25 Nov 2014 15:47:40 +0100
Message-ID: <5474968C.2080800@suse.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de> <547353F2.1040005@suse.de> <20141125143140.GA32570@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060101040300050905030407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaKYOro (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:47:44 -0500
In-Reply-To: <20141125143140.GA32570@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org, Webb Scales <webbnh@hp.com>, Don Brace <don.brace@pmcs.com>, Jens Axboe <axboe@kernel.dk>

This is a multi-part message in MIME format.
--------------060101040300050905030407
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 11/25/2014 03:31 PM, Christoph Hellwig wrote:
> On Mon, Nov 24, 2014 at 04:51:14PM +0100, Hannes Reinecke wrote:
>> It is useful as is, as we'll be getting prefixed logging output :-)
> 
> Use the blk-mq code path if you care :)
> 
>> Which I didn't do yet as the driver is using a larger tag map than
>> that one announced to the block layer.
>> This is to facilitate internal command submission, which should
>> always work independent on any tag starvation issues from the
>> upper layers.
> 
> This is an "issue" for a lot of drivers.  blk-mq provides a reserved_tags
> pool for that, which reserves a number of tags for internal use, those
> must be allocated using blk_mq_alloc_request with the reserved argument
> set to true.
> 
> The lockless hpsa patches expose this to SCSI, which I'm generally
> fine with, but we need to find a way to transparently make this work
> for the old code path, too.  This might be as simple as embedding a
> second blk_queue_tag structure into the Scsi_Host, adding a constant
> prefix to the tag and providing some wrappes in scsi that allow
> allocating a struct request (or rather scsi_cmnd) for internal use.
> 
I'd rather have a single map to get request/tags from; otherwise
we'd be arbitrarily starving internal requests even though the
'main' tag map is empty.
My plan was more to mark a certain range of tags as 'reserved',
and add another helper/argument to allow to dip into the reserved
pool, too.

A tentative patch is attached.
Idea is to call blk_queue_init_tags() with the actual tag size and
then blk_resize_tags() to limit the number of tags for the request
queue.
The driver can then use 'blk_allocate_tag' with the appropriate max
depth to get tags from the range [max_depth:real_max_depth].

Cheers,

Hannes

-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)

--------------060101040300050905030407
Content-Type: text/x-patch;
 name="0001-blk-tag-separate-out-blk_-allocate-release-_tag.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-blk-tag-separate-out-blk_-allocate-release-_tag.patch"

=46rom e872bb0c4c2b1f72982f4d31925d3b2f65317ffd Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 25 Nov 2014 15:43:07 +0100
Subject: [PATCH] blk-tag: separate out blk_(allocate|release)_tag

Separate out helper functions blk_allocate_tag() and
blk_release_tag().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-tag.c | 74 ++++++++++++++++++++++++++++++++++++++++++---------=
------
 1 file changed, 55 insertions(+), 19 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index a185b86..6526fff 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -244,6 +244,24 @@ int blk_queue_resize_tags(struct request_queue *q, i=
nt new_depth)
 }
 EXPORT_SYMBOL(blk_queue_resize_tags);
=20
+void blk_release_tag(struct blk_queue_tag *bqt, int tag)
+{
+	if (unlikely(!bqt))
+		return;
+
+	if (unlikely(!test_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __func__, tag);
+		return;
+	}
+	/*
+	 * The tag_map bit acts as a lock for tag_index[bit], so we need
+	 * unlock memory barrier semantics.
+	 */
+	clear_bit_unlock(tag, bqt->tag_map);
+}
+EXPORT_SYMBOL(blk_release_tag);
+
 /**
  * blk_queue_end_tag - end tag operations for a request
  * @q:  the request queue for the device
@@ -275,18 +293,43 @@ void blk_queue_end_tag(struct request_queue *q, str=
uct request *rq)
=20
 	bqt->tag_index[tag] =3D NULL;
=20
-	if (unlikely(!test_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __func__, tag);
-		return;
-	}
+	blk_release_tag(bqt, tag);
+}
+EXPORT_SYMBOL(blk_queue_end_tag);
+
+/**
+ * blk_reserve_tag - lock and return the next free tag
+ * @bqt:  tag map
+ * @max_depth: max tag depth to use
+ *
+ * Description:
+ *   Lock and return the next free tag.
+ *   The tag needs to be freed up after usage with
+ *   blk_release_tag()
+ *
+ **/
+int blk_reserve_tag(struct blk_queue_tag *bqt, int max_depth)
+{
+	int tag =3D -1;
+
+	if (!bqt)
+		return tag;
+	if (max_depth >=3D bqt->real_max_depth)
+		return -1;
+
+	do {
+		tag =3D find_first_zero_bit(bqt->tag_map, max_depth);
+		if (tag >=3D max_depth)
+			return tag;
+
+	} while (test_and_set_bit_lock(tag, bqt->tag_map));
 	/*
-	 * The tag_map bit acts as a lock for tag_index[bit], so we need
-	 * unlock memory barrier semantics.
+	 * We need lock ordering semantics given by test_and_set_bit_lock.
+	 * See blk_queue_end_tag for details.
 	 */
-	clear_bit_unlock(tag, bqt->tag_map);
+	return tag;
 }
-EXPORT_SYMBOL(blk_queue_end_tag);
+EXPORT_SYMBOL(blk_reserve_tag);
=20
 /**
  * blk_queue_start_tag - find a free tag and assign it
@@ -343,16 +386,9 @@ int blk_queue_start_tag(struct request_queue *q, str=
uct request *rq)
 			return 1;
 	}
=20
-	do {
-		tag =3D find_first_zero_bit(bqt->tag_map, max_depth);
-		if (tag >=3D max_depth)
-			return 1;
-
-	} while (test_and_set_bit_lock(tag, bqt->tag_map));
-	/*
-	 * We need lock ordering semantics given by test_and_set_bit_lock.
-	 * See blk_queue_end_tag for details.
-	 */
+	tag =3D blk_reserve_tag(bqt, max_depth);
+	if (tag =3D=3D -1)
+		return 1;
=20
 	rq->cmd_flags |=3D REQ_QUEUED;
 	rq->tag =3D tag;
--=20
1.8.5.2


--------------060101040300050905030407--
