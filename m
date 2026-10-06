Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802CA3EC69C;
	Tue,  6 Oct 2026 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290739; cv=none; b=utHLKYPXXqRJDnhIi0Hm3ha1PeDjxGIQfODa+ev3VMTdc3Rg8wwsDjWqhqpysYeYV7dDdDwMmLTT1eBSWr03Ua9jl/QDPWNIzX7P2EtBAf1nkJG1wFb/YQMdt0tP2WP01Fw4y0v4UfdOiVKhMYHQiORLuuDcWW7US6KwepLW0ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290739; c=relaxed/simple;
	bh=VCyfWUg9L5rYAMqpeQOCrD0luZ37uQF7Ndj08yOlgmc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYJ3e3sKA7ZDzGQKZ9y5s5lZNEjfKqLM+woYmFsos+pvjdx2uT29BKmytERfm9+RER94/Ucse7veEwJkDYCbB9T2ljp+O+nzEY/nBIN6J2xocb7pxhUX7R5sUlucDu+YQZvSDtifKihMMtRUfLbIuz8GOi9wmt0AIJpAcLcVACI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFfbDmE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFfbDmE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C91F0089B;
	Tue,  6 Oct 2026 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791290717;
	bh=CineEsJn85mwHhu+JAGswgsV1Ls3rtSi1Z+7vlR6soI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DFfbDmE1ZTZ6I3AW8llPJZQ6thGCo7rNO3lNTPT/YoCrmJXR3Yaw5vCsD9D6RE+AR
	 Jr0wpoQFpuohKgKmMbTu9VHpslPAgBbd/t1Y5yrtdQBVynpF4/nbv/lorXeinV15BL
	 iopFJyxJb2PyUFfmMXyENBTot1osWnHy1FI6lsfnL2It8dhDH3lZvsdklFeOfoc1Ki
	 9qSSpQcAHm6x91D1u+L0li1Ontm2f1jPdWCaTBWUbVZQHi3f9nAW4xujuooeTysaej
	 yWQdng/9S7K+gyHBJfNasr45IWk9G367y6OHNUhnk5rYBF5AzO9D4fEETwMG+D6aAZ
	 5qgSwjboYilAA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 5/7] zloop: add degrade_element control command
Date: Tue,  6 Oct 2026 21:45:08 +0900
Message-ID: <20261006124510.882017-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006124510.882017-1-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow users to mark storage elements of a zloop device as degraded using
the new "degrade_element" control command. The element to degrade is
indicated using the element_id option. Example:

echo "degrade_element id=0,element_id=2" > /dev/zloop-control

If the element ID identifies an all access storage element, read and write
operations targeting a zone served by the degraded lement are failed.
For a partial access storage element, read or write operations are failed
depending on the storage element type. This check for an element status
is done without taking the storage elements mutex lock, so in order to
avoid memory access ordering issues, storage element status access is
changed to use READ_ONCE() and WRITE_ONCE()

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/zloop.c | 131 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 115 insertions(+), 16 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index d6a45f214857..3913bd229910 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -38,6 +38,7 @@ enum {
 	ZLOOP_OPT_DISCARD_WRITE_CACHE	= (1 << 11),
 	ZLOOP_OPT_MAX_OPEN_ZONES	= (1 << 12),
 	ZLOOP_OPT_STOR_ELEMENTS		= (1 << 13),
+	ZLOOP_OPT_ELEMENT_ID		= (1 << 14),
 };
 
 static const match_table_t zloop_opt_tokens = {
@@ -55,6 +56,7 @@ static const match_table_t zloop_opt_tokens = {
 	{ ZLOOP_OPT_DISCARD_WRITE_CACHE, "discard_write_cache"	},
 	{ ZLOOP_OPT_MAX_OPEN_ZONES,	"max_open_zones=%u"	},
 	{ ZLOOP_OPT_STOR_ELEMENTS,	"stor_elements=%u"	},
+	{ ZLOOP_OPT_ELEMENT_ID,		"element_id=%u"		},
 	{ ZLOOP_OPT_ERR,		NULL			}
 };
 
@@ -81,6 +83,7 @@ enum zloop_stor_elements {
 #define ZLOOP_DEF_ZONE_APPEND		true
 #define ZLOOP_DEF_ORDERED_ZONE_APPEND	false
 #define ZLOOP_DEF_STOR_ELEMENTS		ZLOOP_STOR_ELEMENTS_NONE
+#define ZLOOP_DEF_ELEMENT_ID		0
 
 /* Arbitrary limit on the zone size (16GB). */
 #define ZLOOP_MAX_ZONE_SIZE_MB		16384
@@ -101,6 +104,7 @@ struct zloop_options {
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
 	enum zloop_stor_elements stor_elements;
+	unsigned int		element_id;
 };
 
 /*
@@ -982,11 +986,26 @@ static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
 	spin_lock(&zone->wp_lock);
 
 	if (zlo->nr_elements) {
+		struct blk_storage_element *se;
+
 		if (zone->cond == BLK_ZONE_COND_OFFLINE ||
 		    (zone->cond == BLK_ZONE_COND_READONLY && is_write)) {
 			ret = false;
 			goto unlock;
 		}
+
+		/*
+		 * Check the health state of the storage element serving the
+		 * zone.
+		 */
+		if (is_write)
+			se = &zlo->elements[zone->wr_se_id - 1];
+		else
+			se = &zlo->elements[zone->rd_se_id - 1];
+		if (READ_ONCE(se->status) == BLK_SE_STS_DEGRADED) {
+			ret = false;
+			goto unlock;
+		}
 	}
 
 	/*
@@ -1123,7 +1142,7 @@ static int zloop_report_elements(struct gendisk *disk,
 		unsigned int i;
 
 		for (i = 0; i < min(nr_report, zlo->nr_elements); i++, se++) {
-			switch (se->status) {
+			switch (READ_ONCE(se->status)) {
 			case BLK_SE_STS_REMOVED:
 			case BLK_SE_STS_RESTORE_ERROR:
 				se->restore_allowed = 1;
@@ -1141,6 +1160,31 @@ static int zloop_report_elements(struct gendisk *disk,
 	return 0;
 }
 
+static int zloop_degrade_element(struct zloop_device *zlo,
+				 unsigned int element_id)
+{
+	struct blk_storage_element *se;
+	int ret = 0;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	if (!element_id || element_id > zlo->nr_elements)
+		return -EINVAL;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	se = &zlo->elements[element_id - 1];
+	if (READ_ONCE(se->status) == BLK_SE_STS_OK)
+		WRITE_ONCE(se->status, BLK_SE_STS_DEGRADED);
+	else
+		ret = -EINVAL;
+
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return ret;
+}
+
 static void zloop_remove_element_work(struct work_struct *work)
 {
 	struct zloop_device *zlo = container_of(work, struct zloop_device,
@@ -1186,11 +1230,11 @@ static void zloop_remove_element_work(struct work_struct *work)
 		mutex_unlock(&zone->lock);
 	}
 
-	se->status = BLK_SE_STS_REMOVED;
+	WRITE_ONCE(se->status, BLK_SE_STS_REMOVED);
 
 	zlo->nr_removed_elements++;
-	if (paired_se && paired_se->status != BLK_SE_STS_REMOVED) {
-		paired_se->status = BLK_SE_STS_REMOVED;
+	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED) {
+		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVED);
 		zlo->nr_removed_elements++;
 	}
 
@@ -1224,7 +1268,7 @@ static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
 	 * to do.
 	 */
 	se = &zlo->elements[element_id - 1];
-	if (se->status == BLK_SE_STS_REMOVED)
+	if (READ_ONCE(se->status) == BLK_SE_STS_REMOVED)
 		goto unlock;
 
 	/*
@@ -1233,7 +1277,7 @@ static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
 	 */
 	if (se->type == BLK_SE_TYPE_READ) {
 		paired_se = &zlo->elements[se->paired_id - 1];
-		if (paired_se->status != BLK_SE_STS_REMOVED)
+		if (READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
 			nr_remove = 2;
 	}
 
@@ -1249,9 +1293,9 @@ static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
 	 * modify the zones.
 	 */
 	zlo->remove_element_id = element_id;
-	se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
-	if (paired_se && paired_se->status != BLK_SE_STS_REMOVED)
-		paired_se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
+	WRITE_ONCE(se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
+	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
+		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
 
 	schedule_delayed_work(&zlo->remove_element_work,
 			      msecs_to_jiffies(2000));
@@ -1288,12 +1332,12 @@ static void zloop_restore_elements_work(struct work_struct *work)
 
 	/* Restore all removed elements. */
 	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
-		if (se->status != BLK_SE_STS_RESTORE_IN_PROGRESS)
+		if (READ_ONCE(se->status) != BLK_SE_STS_RESTORE_IN_PROGRESS)
 			continue;
 		if (!ret)
-			se->status = BLK_SE_STS_OK;
+			WRITE_ONCE(se->status, BLK_SE_STS_OK);
 		else
-			se->status = BLK_SE_STS_RESTORE_ERROR;
+			WRITE_ONCE(se->status, BLK_SE_STS_RESTORE_ERROR);
 	}
 
 	zlo->nr_removed_elements = 0;
@@ -1330,8 +1374,8 @@ static int zloop_restore_elements(struct gendisk *disk)
 	 */
 	zlo->restore_in_progress = true;
 	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
-		if (se->status == BLK_SE_STS_REMOVED)
-			se->status = BLK_SE_STS_RESTORE_IN_PROGRESS;
+		if (READ_ONCE(se->status) == BLK_SE_STS_REMOVED)
+			WRITE_ONCE(se->status, BLK_SE_STS_RESTORE_IN_PROGRESS);
 	}
 
 	schedule_delayed_work(&zlo->restore_elements_work,
@@ -1944,6 +1988,42 @@ static int zloop_ctl_remove(struct zloop_options *opts)
 	return 0;
 }
 
+static int zloop_ctl_degrade_element(struct zloop_options *opts)
+{
+	struct zloop_device *zlo;
+	int ret = 0;
+
+	if (!(opts->mask & ZLOOP_OPT_ID)) {
+		pr_err("No ID specified for degrade_element\n");
+		return -EINVAL;
+	}
+
+	if (opts->mask & ~(ZLOOP_OPT_ID | ZLOOP_OPT_ELEMENT_ID)) {
+		pr_err("Invalid option specified for degrade_element\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&zloop_ctl_mutex);
+
+	zlo = idr_find(&zloop_index_idr, opts->id);
+	if (!zlo || zlo->state == Zlo_creating)
+		ret = -ENODEV;
+	else if (zlo->state == Zlo_deleting)
+		ret = -EINVAL;
+	if (ret)
+		goto unlock;
+
+	ret = zloop_degrade_element(zlo, opts->element_id);
+	if (!ret)
+		pr_info("Degraded element %u of device %u\n",
+			opts->id, opts->element_id);
+
+unlock:
+	mutex_unlock(&zloop_ctl_mutex);
+
+	return ret;
+}
+
 static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 {
 	substring_t args[MAX_OPT_ARGS];
@@ -1964,6 +2044,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
 	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
+	opts->element_id = ZLOOP_DEF_ELEMENT_ID;
 
 	if (!buf)
 		return 0;
@@ -2115,6 +2196,13 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 			}
 			opts->stor_elements = token;
 			break;
+		case ZLOOP_OPT_ELEMENT_ID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->element_id = token;
+			break;
 		case ZLOOP_OPT_ERR:
 		default:
 			pr_warn("unknown parameter or missing value '%s'\n", p);
@@ -2143,14 +2231,16 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 enum {
 	ZLOOP_CTL_ADD,
 	ZLOOP_CTL_REMOVE,
+	ZLOOP_CTL_DEGRADE_ELEMENT,
 };
 
 static struct zloop_ctl_op {
 	int		code;
 	const char	*name;
 } zloop_ctl_ops[] = {
-	{ ZLOOP_CTL_ADD,	"add" },
-	{ ZLOOP_CTL_REMOVE,	"remove" },
+	{ ZLOOP_CTL_ADD,		"add" },
+	{ ZLOOP_CTL_REMOVE,		"remove" },
+	{ ZLOOP_CTL_DEGRADE_ELEMENT,	"degrade_element" },
 	{ -1,	NULL },
 };
 
@@ -2198,6 +2288,9 @@ static ssize_t zloop_ctl_write(struct file *file, const char __user *ubuf,
 	case ZLOOP_CTL_REMOVE:
 		ret = zloop_ctl_remove(&opts);
 		break;
+	case ZLOOP_CTL_DEGRADE_ELEMENT:
+		ret = zloop_ctl_degrade_element(&opts);
+		break;
 	default:
 		pr_err("Invalid operation\n");
 		ret = -EINVAL;
@@ -2221,6 +2314,8 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 		tok = &zloop_opt_tokens[i];
 		if (!tok->pattern)
 			break;
+		if (tok->token == ZLOOP_OPT_ELEMENT_ID)
+			continue;
 		if (i)
 			seq_putc(seq_file, ',');
 		seq_puts(seq_file, tok->pattern);
@@ -2231,6 +2326,10 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 	seq_puts(seq_file, zloop_ctl_ops[1].name);
 	seq_puts(seq_file, " id=%d\n");
 
+	/* Degrade element operation */
+	seq_puts(seq_file, zloop_ctl_ops[2].name);
+	seq_puts(seq_file, " id=%d,element_id=%d\n");
+
 	return 0;
 }
 
-- 
2.55.0

