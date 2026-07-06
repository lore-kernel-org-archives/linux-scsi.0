Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B84F3AEF4C
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359316; cv=none; b=Gwqex3b4kWLODDUWSt4NTHYvOagdtyyxaJGx1xUJSY5zcgW1sS+yyYIl8K82tXbeKlYbK3w0xMsZu1ag6NgG4vjOgyKLuiyth9U3Zz2Z6Pbxmd6gE7P02nIxz1fZ2M3isjjBOiRENDslznJ0X219vc8u8qAaTIAfWSZCNH87fXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359316; c=relaxed/simple;
	bh=BqPdyTPD9g4eA7Vw/b+ozX6+6/rApC5MI3SnAIeszwQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJ7bwcJxAYUZLzfjnY2XOqptAtmxa+rOpqVrSUJpYWhBtCeBOgKu31QPCZODjt5BGifEad529o8tILEGgm6eByTSaq7wL8wvIOB9hbwWhIUO2UMRZfTHct2NonJgZiIq8ggpsnqBkq8Y9qG4yfWn3UveeWkLHQy+7JYSLET3jY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fCuzD7nI; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fCuzD7nI"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666GjHPS1857558
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=HlvS8n/owgoTgAFmeU7a1nOT8euROTEsxbhMc6rA8+8=; b=fCuzD7nICqkx
	+EEtdSoaQtXJpcsYbEsrDX998l+i2iYL9yssYQHE35GCtZ09XHioN5vc6JWoXd7M
	FSeanWAtW4vkVGnqNOVUh9WjZtjs+SqqNKcH/2e0rSv46/S2wmkHfamKZkbzxQdT
	gCxJUo/s6edB60BRw8B3ZpM4K/JUeTn8iHektNepotvsgwwHNOW63d8OHYaLP8Ut
	1daA7KlAiLa630WGr3OnZe7tnjO3x3HVq5/41ChZbweRsR4eCREZB8PHeCZGW1Fl
	C469HMyDwiffTRWWcOJjPQRn3KfRn3/bbjCI6SZpRQ2vf56SeX37PsPuB/GJReO9
	zj9EOqKoLg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4f6wg1m9b4-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:13 -0700 (PDT)
Received: from twshared1653.04.snb2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:11 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 035F5249DC6D4; Mon,  6 Jul 2026 10:34:54 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 1/6] lib/sbitmap: add ranged allocation, bounded wakeup relay, and ranged weight
Date: Mon, 6 Jul 2026 10:34:33 -0700
Message-ID: <20260706173438.3537347-2-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706173438.3537347-1-kbusch@meta.com>
References: <20260706173438.3537347-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ogaAu_okehAkX-yRUTA9i73a0x_9Wx-R
X-Proofpoint-ORIG-GUID: ogaAu_okehAkX-yRUTA9i73a0x_9Wx-R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfXzp+hBtXn1Tfo
 yZETQ7mk6xBs6/0DBswhqG89X8SHqNH+qqbsHvEdOC5bJmwdExvkU/Eo0MwrUJNZxYFYZiUml5m
 dJdGOBlt5XHgQqafucw880KcY3a5KKAMqatJcrY3QUr35ZTSCKaH2iWgdyPete/bAkiTfeZ6mGA
 onqErgUNJi2b9MR6yILuJnmK0RxSzW/da2WLcHuXY/OQMytiKMEu9R9WzF4fJRJhFqe/0S6WCFb
 fIPvNu0UcY8N3vA7RF25CM8maAC+jyCHrWs2OSprcDrFy2kGJAhL/UPJtZWDq048isETNWLsmI1
 E6fqRibdBgsLgdEd87ceiPS9jr4JhHZb8Orn+f/hck70B0DMqvso7o9fuH+AajbMbjNLFQKiZu0
 SeC0fdfXUBN0iDc00TrRncg2AICH3IC5i5VhYTxVZTyyCo3A/AWZW6SSgXuHsojkjlsrx83i3m8
 Tvs/Zd4jGdCfRbUnb9w==
X-Authority-Analysis: v=2.4 cv=EpfiaycA c=1 sm=1 tr=0 ts=6a4be751 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=-vEB9NHOSM2DkkWZcV4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX/XeY1Rhdsc+j
 9KwLZm1WdeTwRwM8QyhVG/0EEq/rfc+YAZyNnhnt4IY7nty2iVQGnF0k2A/Ow+oayBu+7yxn4u7
 sj9SdbZqOQK1XNhO62VkmZPComwidrI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Add some helpers that let a caller carve a shared bitmap into per-user
windows.

  * sbitmap_queue_get_range() allocates a free bit only within requested =
range.
  * sbitmap_queue_wake_up_relay() hands a wakeup to another waiter when t=
he
    woken one cannot use the freed bit (it fell outside that waiter's win=
dow).
  * sbitmap_weight_range() counts set (and not cleared) bits in a sub-ran=
ge.

No callers yet. The intention is for blk-mq users for shared tag
fairness without requiring per-io atomic accounting operations.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/sbitmap.h |  53 +++++++++++
 lib/sbitmap.c           | 200 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 253 insertions(+)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index cc7ad189caa5c..9fceda5d9de51 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -86,6 +86,7 @@ struct sbitmap {
=20
 #define SBQ_WAIT_QUEUES 8
 #define SBQ_WAKE_BATCH 8
+#define SBQ_RELAY_BUDGET SBQ_WAKE_BATCH
=20
 /**
  * struct sbq_wait_state - Wait queue in a &struct sbitmap_queue.
@@ -149,6 +150,14 @@ struct sbitmap_queue {
 	 * @wakeup_cnt: Number of thread wake ups issued.
 	 */
 	atomic_t wakeup_cnt;
+
+	/**
+	 * @relay_credits: Remaining range-relay wakeups allowed before the nex=
t
+	 * genuine completion. Refilled by sbitmap_queue_wake_up() and consumed
+	 * by sbitmap_queue_wake_up_relay(); bounds the relay chain so it canno=
t
+	 * cycle when no waiter can use a freed bit.
+	 */
+	atomic_t relay_credits;
 };
=20
 /**
@@ -375,6 +384,18 @@ void sbitmap_show(struct sbitmap *sb, struct seq_fil=
e *m);
  */
 unsigned int sbitmap_weight(const struct sbitmap *sb);
=20
+/**
+ * sbitmap_weight_range() - Return how many set and not cleared bits in =
a
+ * sub-range of a &struct sbitmap.
+ * @sb: Bitmap to check.
+ * @off: First bit of the range.
+ * @len: Number of bits in the range.
+ *
+ * Return: How many bits in [@off, @off + @len) are set and not cleared.
+ */
+unsigned int sbitmap_weight_range(const struct sbitmap *sb, unsigned int=
 off,
+				  unsigned int len);
+
 /**
  * sbitmap_bitmap_show() - Write a hex dump of a &struct sbitmap to a &s=
truct
  * seq_file.
@@ -472,6 +493,22 @@ unsigned long __sbitmap_queue_get_batch(struct sbitm=
ap_queue *sbq, int nr_tags,
 int sbitmap_queue_get_shallow(struct sbitmap_queue *sbq,
 			      unsigned int shallow_depth);
=20
+/**
+ * sbitmap_queue_get_range() - Try to allocate a free bit from a restric=
ted
+ * range of a &struct sbitmap_queue, with preemption already disabled.
+ * @sbq: Bitmap queue to allocate from.
+ * @min: First bit (inclusive) the caller is allowed to allocate.
+ * @max: Last bit (exclusive) the caller is allowed to allocate.
+ *
+ * Allocation is confined to the [@min, @max) window. This lets several =
users
+ * share one bitmap while each is bounded to its own (possibly overlappi=
ng)
+ * window, providing fairness without a separate per-user accounting cou=
nter.
+ *
+ * Return: Non-negative allocated bit number if successful, -1 otherwise=
.
+ */
+int sbitmap_queue_get_range(struct sbitmap_queue *sbq, unsigned int min,
+			    unsigned int max);
+
 /**
  * sbitmap_queue_get() - Try to allocate a free bit from a &struct
  * sbitmap_queue.
@@ -575,6 +612,22 @@ void sbitmap_queue_wake_all(struct sbitmap_queue *sb=
q);
  */
 void sbitmap_queue_wake_up(struct sbitmap_queue *sbq, int nr);
=20
+/**
+ * sbitmap_queue_wake_up_relay() - Relay a wakeup to the next waiter.
+ * @sbq: Bitmap queue to wake up.
+ * @cur: The relaying waiter's own wait queue, skipped so it does not wa=
ke
+ *       itself (it is about to sleep again); may be NULL.
+ *
+ * Wake a single waiter on the next active wait queue without touching t=
he
+ * wake_batch accounting. Intended for range-limited allocation: a waite=
r that
+ * was woken but could not use the freed bit (it fell outside the waiter=
's
+ * allowed range) calls this to pass the wakeup along to another waiter =
that
+ * may be able to use it. The relay is bounded by a credit budget refill=
ed
+ * only by genuine completions, so it cannot cycle indefinitely.
+ */
+void sbitmap_queue_wake_up_relay(struct sbitmap_queue *sbq,
+				 struct sbq_wait_state *cur);
+
 /**
  * sbitmap_queue_show() - Dump &struct sbitmap_queue information to a &s=
truct
  * seq_file.
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 4d188d05db153..3264085b4d533 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -338,6 +338,130 @@ static int sbitmap_get_shallow(struct sbitmap *sb, =
unsigned long shallow_depth)
 	return nr;
 }
=20
+/*
+ * Find and set a free bit in the [low, high) sub-range of a single word=
.
+ * Wraps back to @low once so a free bit below @hint is still found.
+ */
+static int __sbitmap_get_word_range(unsigned long *word, unsigned int lo=
w,
+				    unsigned int high, unsigned int hint)
+{
+	bool wrap;
+	int nr;
+
+	if (hint < low || hint >=3D high)
+		hint =3D low;
+	/* don't wrap if already starting from the bottom of the range */
+	wrap =3D hint > low;
+
+	while (1) {
+		nr =3D find_next_zero_bit(word, high, hint);
+		if (unlikely(nr >=3D high)) {
+			if (wrap) {
+				hint =3D low;
+				wrap =3D false;
+				continue;
+			}
+			return -1;
+		}
+		if (!test_and_set_bit_lock(nr, word))
+			break;
+		hint =3D nr + 1;
+		if (hint >=3D high) {
+			if (!wrap)
+				return -1;
+			hint =3D low;
+			wrap =3D false;
+		}
+	}
+
+	return nr;
+}
+
+static int sbitmap_find_bit_in_word_range(struct sbitmap_word *map,
+					  unsigned int low, unsigned int high,
+					  unsigned int hint)
+{
+	int nr;
+
+	do {
+		nr =3D __sbitmap_get_word_range(&map->word, low, high, hint);
+		if (nr !=3D -1)
+			break;
+		if (!sbitmap_deferred_clear(map, high, low, false))
+			break;
+	} while (1);
+
+	return nr;
+}
+
+/*
+ * Allocate a bit restricted to the [min, max) range of the bitmap. Used=
 to
+ * carve the shared depth into (possibly overlapping) per-user windows w=
ithout
+ * a separate accounting counter: a user simply cannot allocate outside =
its
+ * window.
+ */
+static int __sbitmap_get_range(struct sbitmap *sb, unsigned int min,
+			       unsigned int max, unsigned int hint)
+{
+	unsigned int min_index, max_index, index;
+	unsigned int nwords, i;
+	int nr =3D -1;
+
+	if (max > sb->depth)
+		max =3D sb->depth;
+	if (min >=3D max)
+		return -1;
+
+	min_index =3D SB_NR_TO_INDEX(sb, min);
+	max_index =3D SB_NR_TO_INDEX(sb, max - 1);
+	nwords =3D max_index - min_index + 1;
+
+	if (hint < min || hint >=3D max)
+		hint =3D min;
+	index =3D SB_NR_TO_INDEX(sb, hint);
+
+	for (i =3D 0; i < nwords; i++) {
+		unsigned int word_base =3D index << sb->shift;
+		unsigned int word_depth =3D __map_depth(sb, index);
+		unsigned int low, high, h;
+
+		low =3D (index =3D=3D min_index) ? SB_NR_TO_BIT(sb, min) : 0;
+		high =3D (index =3D=3D max_index) ? SB_NR_TO_BIT(sb, max - 1) + 1 :
+					      word_depth;
+		h =3D (hint >=3D word_base && hint < word_base + word_depth) ?
+			SB_NR_TO_BIT(sb, hint) : low;
+
+		nr =3D sbitmap_find_bit_in_word_range(&sb->map[index], low,
+						    high, h);
+		if (nr !=3D -1) {
+			nr +=3D word_base;
+			break;
+		}
+
+		if (++index > max_index)
+			index =3D min_index;
+	}
+
+	return nr;
+}
+
+static int sbitmap_get_range(struct sbitmap *sb, unsigned int min,
+			     unsigned int max)
+{
+	int nr;
+	unsigned int hint, depth;
+
+	if (WARN_ON_ONCE(unlikely(!sb->alloc_hint)))
+		return -1;
+
+	depth =3D READ_ONCE(sb->depth);
+	hint =3D update_alloc_hint_before_get(sb, depth);
+	nr =3D __sbitmap_get_range(sb, min, max, hint);
+	update_alloc_hint_after_get(sb, depth, hint, nr);
+
+	return nr;
+}
+
 bool sbitmap_any_bit_set(const struct sbitmap *sb)
 {
 	unsigned int i;
@@ -377,6 +501,38 @@ unsigned int sbitmap_weight(const struct sbitmap *sb=
)
 }
 EXPORT_SYMBOL_GPL(sbitmap_weight);
=20
+unsigned int sbitmap_weight_range(const struct sbitmap *sb, unsigned int=
 off,
+				  unsigned int len)
+{
+	unsigned int weight =3D 0;
+	unsigned int end =3D off + len;
+	unsigned int index;
+
+	if (end > sb->depth)
+		end =3D sb->depth;
+
+	for (index =3D SB_NR_TO_INDEX(sb, off); index < sb->map_nr; index++) {
+		const struct sbitmap_word *word =3D &sb->map[index];
+		unsigned int base =3D index << sb->shift;
+		unsigned int wbits =3D __map_depth(sb, index);
+		unsigned int lo, hi;
+		unsigned long val;
+
+		if (base >=3D end)
+			break;
+		val =3D READ_ONCE(word->word) & ~READ_ONCE(word->cleared);
+		lo =3D (off > base) ? off - base : 0;
+		hi =3D (end - base < wbits) ? end - base : wbits;
+		if (lo)
+			val &=3D ~((1UL << lo) - 1);
+		if (hi < BITS_PER_LONG)
+			val &=3D (1UL << hi) - 1;
+		weight +=3D hweight_long(val);
+	}
+	return weight;
+}
+EXPORT_SYMBOL_GPL(sbitmap_weight_range);
+
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m)
 {
 	seq_printf(m, "depth=3D%u\n", sb->depth);
@@ -462,6 +618,7 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq=
, unsigned int depth,
 	atomic_set(&sbq->ws_active, 0);
 	atomic_set(&sbq->completion_cnt, 0);
 	atomic_set(&sbq->wakeup_cnt, 0);
+	atomic_set(&sbq->relay_credits, 0);
=20
 	sbq->ws =3D kzalloc_node(SBQ_WAIT_QUEUES * sizeof(*sbq->ws), flags, nod=
e);
 	if (!sbq->ws) {
@@ -573,6 +730,13 @@ int sbitmap_queue_get_shallow(struct sbitmap_queue *=
sbq,
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_get_shallow);
=20
+int sbitmap_queue_get_range(struct sbitmap_queue *sbq, unsigned int min,
+			    unsigned int max)
+{
+	return sbitmap_get_range(&sbq->sb, min, max);
+}
+EXPORT_SYMBOL_GPL(sbitmap_queue_get_range);
+
 void sbitmap_queue_min_shallow_depth(struct sbitmap_queue *sbq,
 				     unsigned int min_shallow_depth)
 {
@@ -629,10 +793,46 @@ void sbitmap_queue_wake_up(struct sbitmap_queue *sb=
q, int nr)
 	} while (!atomic_try_cmpxchg(&sbq->wakeup_cnt,
 				     &wakeups, wakeups + wake_batch));
=20
+	atomic_set(&sbq->relay_credits, SBQ_RELAY_BUDGET);
 	__sbitmap_queue_wake_up(sbq, wake_batch);
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_wake_up);
=20
+/*
+ * Wake a single waiter on the next active wait queue, bypassing the
+ * wake_batch accounting (no bit was freed). This "relays" a wakeup that=
 the
+ * current waiter consumed but could not use - e.g. the freed bit fell o=
utside
+ * its allowed allocation range - so a waiter that *can* use a free bit =
gets a
+ * chance to run. Relaying continues, one hop per failed waiter, until a=
 usable
+ * waiter is found or the chain credits drain.
+ */
+void sbitmap_queue_wake_up_relay(struct sbitmap_queue *sbq,
+				 struct sbq_wait_state *cur)
+{
+	int wake_index, i;
+
+	if (!atomic_read(&sbq->ws_active))
+		return;
+
+	if (atomic_dec_if_positive(&sbq->relay_credits) < 0)
+		return;
+
+	wake_index =3D atomic_read(&sbq->wake_index);
+	for (i =3D 0; i < SBQ_WAIT_QUEUES; i++) {
+		struct sbq_wait_state *ws =3D &sbq->ws[wake_index];
+
+		wake_index =3D sbq_index_inc(wake_index);
+		if (ws !=3D cur && waitqueue_active(&ws->wait)) {
+			wake_up_nr(&ws->wait, 1);
+			break;
+		}
+	}
+
+	if (wake_index !=3D atomic_read(&sbq->wake_index))
+		atomic_set(&sbq->wake_index, wake_index);
+}
+EXPORT_SYMBOL_GPL(sbitmap_queue_wake_up_relay);
+
 static inline void sbitmap_update_cpu_hint(struct sbitmap *sb, int cpu, =
int tag)
 {
 	if (likely(!sb->round_robin && tag < sb->depth))
--=20
2.52.0

