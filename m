Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A5B3AD53F
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359306; cv=none; b=bpG6ix/hBU7kL6dHqQ1g+aL6MBZPV5AsOYKPqiy0N9aDPHwF1rv8nqk4NbZT9i6pTMjr39qtpdJOV4u4OgZFQ830Uv9MjRSbWmYEx0ESd+e4AMZjkmNCsXk9DuDCB2gZgZF+tnyJmV2pOw4t9b+E/yRaiVNHFTAnsVzLLLqwF3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359306; c=relaxed/simple;
	bh=oa+TNanQwnJRVgl/MxlamE2DB45eGidIPqL8Tf8a5Ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvovvBy15YveP9Z25HKWurWfBjloHhsdbxumY3WuRp53wMh13+xG64ff5bhKdSwU8xUP/5ELTjSl0dG+f3A/xXo9EgB/6XzEFSCWnCvtxoOCyIDHQ/8Xy98mwe7xlo8l8G5jaGJP9+LkESMoW7dQ17amEfFEWpoaf4ZxIy1GxwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=uVhMF5j9; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="uVhMF5j9"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666GjVg62473025
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Zu1ZqB7NUllfMesoTc8olroYVsL+20MY9eJt+TJsvvM=; b=uVhMF5j9Oz9V
	K1pFNyscumNieEoVdwwqIJnJ/1VmCEtqz3SUUo4Jkr3EtqYhG2XRAPEZ0+E9I986
	1tv+51q1j4TuN5S+dznHMHmGGMxBsORKXG6aMpWCiUR+cY9juGjSKBdmfivyEssw
	GYoujtmmnshCmizY6OnHsmiYGtvBWpEPfB3uSJVovffRXXhYqzonQza9LhzgAhBX
	LOThmtBL3X0oe0jW9x9yxofwma57thpBQ2MFCLECWpe9aHIzuZStfKc/Uj076BIE
	Kg8RRPjvXygBmj+cMOci7r8hxSmhzHBoVMw7rUUYCdnD2uIfLdIZ7KOClQOcdy+3
	CCqjYPrSOw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4f7ktefmsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:02 -0700 (PDT)
Received: from twshared13926.03.snb2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:02 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1193F249DC703; Mon,  6 Jul 2026 10:34:55 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 4/6] blk-mq: add a shared zone to tag fairness
Date: Mon, 6 Jul 2026 10:34:36 -0700
Message-ID: <20260706173438.3537347-5-kbusch@meta.com>
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
X-Authority-Analysis: v=2.4 cv=UdJhjqSN c=1 sm=1 tr=0 ts=6a4be746 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=EsMd7e7EX1TKK8BlWRoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX+YAHzvuN/JWi
 K/GG9SWOYtaMj6BexmX0/UcHGpkDQVAfxKQzED1aWH4d2BS4/oKskM78PcUR5Yh/HUluCxQB04S
 MbQnwVTP6qbvYHmQE4aqzOp86YQHiX0bMCEtEIDacNyr2jz2PV01i5rfBQSQZwn7gO1dFRXzADj
 szo3krvTgMYBsvHvyxwtID4zsX/tphpjAvjLc3W3HDpCYx4xao3wqOQlZWvQIiyAihvBCuW0ePy
 4PM02sY6cLU1Q/rN5vngIiMhk81qpHxbcwYEcVe909/H1I0AC1JijUMRBxhYa7Pb1b+DqjcwIPt
 Ddi5WXlnSYnAl3nlccu/MlWxVYo/FvAmZ2OUXENN/J4vmR/VrIMbWPuVDnvS4vf9Lz2P337Pu0N
 BO1iMaZRnCV+T0hVDNQXO+Wi73sNJ6NA0QA5DQcfEVYdXKegOsmEmLb02m+zk+HynA139ypiGzB
 5uT34RkDZTjPWeORrew==
X-Proofpoint-GUID: SvWnhRqLp8wwlyX2GjrOUh3zuE1s_Oiy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX9qEgmx3RRgNI
 gV8NwdqxpB7JEo7C0mbRMgjzGEBcaiu93TVU0SHuUftZte0RaBtGs7y+UDbmA3uWpK5o6qHfg1a
 y+5wWtPPTfiZ9SWeBNT4RCQY22FM7tk=
X-Proofpoint-ORIG-GUID: SvWnhRqLp8wwlyX2GjrOUh3zuE1s_Oiy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Private slices of the sbitmap can strand an under utilized queue's tags.
Allow a driver to request some percentage of tags to be reserved into a
common shared pool that anyone may allocate from. The default 0 means
the entire tag set is divided up among its users; 100 means no one has
an exclusive window and can therefore allocate from the entire tag
space.

Shared tags being outside the private zone makes it so we can't do a
sbitmap range weight to find its active commands, so the debugfs count
may no longer accurate. Count the hctx's actual tags via
__blk_mq_hctx_tag_busy_iter() to provide accuracy over performance for
debugfs.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-mq-tag.c     | 94 +++++++++++++++++++++++++++++++-----------
 block/blk-mq.c         |  3 ++
 include/linux/blk-mq.h |  5 +++
 3 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 58cf480df9c69..aa7dbceb60dcd 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -144,54 +144,79 @@ static inline bool blk_mq_tag_is_windowed(struct bl=
k_mq_alloc_data *data)
 	       (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED);
 }
=20
+struct blk_mq_tag_win {
+	unsigned int priv_min;
+	unsigned int priv_max;
+	unsigned int shared_min;
+	unsigned int shared_max;
+};
+
 static bool blk_mq_tag_active_window(struct blk_mq_hw_ctx *hctx,
-				     unsigned int depth, unsigned int *min,
-				     unsigned int *max)
+				     unsigned int depth,
+				     struct blk_mq_tag_win *w)
 {
 	unsigned int users =3D READ_ONCE(hctx->tags->active_queues);
 	int slot =3D READ_ONCE(*blk_mq_tag_win_slot(hctx));
-	unsigned int p, rem, pos;
+	unsigned int fair, priv, pct, pos;
+
+	if (users <=3D 1 || depth <=3D 1)
+		return false;
=20
-	if (users <=3D 1 || slot < 0 || depth <=3D 1)
+	fair =3D depth / users;
+	if (!fair)
 		return false;
=20
-	p =3D depth / users;
-	if (!p)
+	pct =3D 100 - min(hctx->queue->tag_set->shared_pct, 100u);
+	priv =3D fair * pct / 100;
+	if (!priv)
 		return false;
=20
 	/*
 	 * Slots are allocated from a bitmap and freed out of order, so a slot
 	 * index can exceed the active-user count once lower slots are freed.
 	 * Convert it to a position based on how many active slots precede it.
+	 * If a slot could not be assigned, the window is confined to the
+	 * shared range.
 	 */
-	pos =3D bitmap_weight(hctx->tags->active_slots, slot);
-	rem =3D depth - p * users;
-	*min =3D pos * p;
-	*max =3D pos * p + p + rem;
-	if (*max > depth)
-		*max =3D depth;
+	pos =3D slot >=3D 0 ? bitmap_weight(hctx->tags->active_slots, slot) : u=
sers;
+	if (pos < users) {
+		w->priv_min =3D pos * priv;
+		w->priv_max =3D w->priv_min + priv;
+	} else {
+		w->priv_min =3D w->priv_max =3D 0;
+	}
=20
+	w->shared_min =3D min(users * priv, depth);
+	w->shared_max =3D depth;
+
+	if (w->priv_min =3D=3D w->priv_max && w->shared_min =3D=3D w->shared_ma=
x)
+		return false;
 	return true;
 }
=20
-int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt)
+static int __blk_mq_get_tag_window(struct sbitmap_queue *bt,
+				   struct blk_mq_tag_win *w)
 {
-	unsigned int min, max;
+	if (w->priv_max > w->priv_min) {
+		int tag =3D sbitmap_queue_get_range(bt, w->priv_min, w->priv_max);
=20
-	if (blk_mq_tag_active_window(hctx, bt->sb.depth, &min, &max))
-		return sbitmap_queue_get_range(bt, min, max);
-	return __sbitmap_queue_get(bt);
+		if (tag >=3D 0)
+			return tag;
+	}
+
+	if (w->shared_max > w->shared_min)
+		return sbitmap_queue_get_range(bt, w->shared_min, w->shared_max);
=20
+	return BLK_MQ_NO_TAG;
 }
=20
-unsigned int blk_mq_hctx_active(struct blk_mq_hw_ctx *hctx)
+int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt)
 {
-	struct sbitmap *sb =3D &hctx->tags->bitmap_tags.sb;
-	unsigned int min, max;
+	struct blk_mq_tag_win w;
=20
-	if (!blk_mq_tag_active_window(hctx, sb->depth, &min, &max))
-		return sbitmap_weight(sb);
-	return sbitmap_weight_range(sb, min, max - min);
+	if (blk_mq_tag_active_window(hctx, bt->sb.depth, &w))
+		return __blk_mq_get_tag_window(bt, &w);
+	return __sbitmap_queue_get(bt);
 }
=20
 static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
@@ -604,6 +629,29 @@ static void __blk_mq_hctx_tag_busy_iter(struct blk_m=
q_hw_ctx *hctx,
 	bt_for_each(hctx, hctx->queue, &tags->bitmap_tags, fn, priv, false);
 }
=20
+static bool blk_mq_count_active(struct request *rq, void *priv)
+{
+	(*(unsigned int *)priv)++;
+	return true;
+}
+
+unsigned int blk_mq_hctx_active(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q =3D hctx->queue;
+	unsigned int count =3D 0;
+	int srcu_idx;
+
+	if (!percpu_ref_tryget(&q->q_usage_counter))
+	        return 0;
+
+	srcu_idx =3D srcu_read_lock(&q->tag_set->tags_srcu);
+	__blk_mq_hctx_tag_busy_iter(hctx, blk_mq_count_active, &count);
+	srcu_read_unlock(&q->tag_set->tags_srcu, srcu_idx);
+
+	blk_queue_exit(q);
+	return count;
+}
+
 /**
  * blk_mq_queue_tag_busy_iter - iterate over all requests with a driver =
tag
  * @q:		Request queue to examine.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 56ab6ac5ec696..cc56baee74fe8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4845,6 +4845,9 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set=
)
 		set->queue_depth =3D BLK_MQ_MAX_DEPTH;
 	}
=20
+	if (set->shared_pct > 100)
+		set->shared_pct =3D 100;
+
 	if (!set->nr_maps)
 		set->nr_maps =3D 1;
 	else if (set->nr_maps > HCTX_MAX_TYPES)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 22cc09d5ef320..59847ac7d319c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -515,6 +515,10 @@ enum hctx_type {
  * @numa_node:	   NUMA node the storage adapter has been connected to.
  * @timeout:	   Request processing timeout in jiffies.
  * @flags:	   Zero or more BLK_MQ_F_* flags.
+ * @shared_pct:	   Percent of tags dedicated to non-exclusive use. 0 mea=
ns
+ *		   the entire tagset is divided among the users for exclusive
+ *		   per-user access, and 100 means the entire tag space is
+ *		   available to all queue contexts that share it.
  * @driver_data:   Pointer to data owned by the block driver that create=
d this
  *		   tag set.
  * @tags:	   Tag sets. One tag set per hardware queue. Has @nr_hw_queues
@@ -544,6 +548,7 @@ struct blk_mq_tag_set {
 	int			numa_node;
 	unsigned int		timeout;
 	unsigned int		flags;
+	unsigned int		shared_pct;
 	void			*driver_data;
=20
 	struct blk_mq_tags	**tags;
--=20
2.52.0

