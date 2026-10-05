Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB646AA97;
	Mon,  5 Oct 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193612; cv=none; b=kUwXNqLGTAg9r3BHqguvwsvavIG7fFyJTXIikG53AjetBW5eSb07EIs6GHi5FXP34vBYOLPXxijeQ2dp5jAHPffSWPUvy5tq2xH/UZdA91QPAzuV8UxqKeDqxz3EvdvJYITG/AfNW5VbbPlUJ2uevcHwMs6yvro3j1WW1g8CEGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193612; c=relaxed/simple;
	bh=oxDyhfCN65Vq3GDv6qNDlYAY9O/HxObQ24tylMpksTE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ong332HPcDoDwPJUaT+LZ3MmmZgriwQJptkTXQ3SQwPRlTtLHMSSxrarCzwokH8SZ0ppSzDVYL9BISySjK2DKJ611OLyhiocEPTLyTa3YlD0ptgwWVOwyvIdnf+FxaW23j6BlsgTa8/GLCUDgEgNrzhdFUvLkWR41tfCdR1+BZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muABzZ7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muABzZ7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A9C1F0089C;
	Mon,  5 Oct 2026 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193600;
	bh=8yKS7WTtEGwO9ci+SVDL21BACrPrrsdkn6JFINouH+k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=muABzZ7FbgeYbKMnzdCPYVOCTx1IX8ESkG6QDEdcnqoJHErF0pAflCJlCGEJY+r0V
	 b0xxz+JjTUg6qxAhUYOWLZzo0/NVCL5XAqlUJh9G5Bld8DMlVh8PuwihiVNCPz0Iat
	 2xv9nFZvfeDLxveozcikHy5bEO+DfCz1ld5cKBd2Vd2O6gez92usexKXANT5AXxBxI
	 2nBvAv7SNQcD/k1NBz+f4Ed5zYbM/wRV7o3sgs7MmZqicIUaD170x0pXysHVVGg4kx
	 90LnYAZhri3QcMu97CDx28B0N+0kFSTI2lLrP/dTf90MtBHbqA8uU6WW3MARi8TixQ
	 7U8Ua/UwugwFA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5/7] zloop: add degrade_element control command
Date: Mon,  5 Oct 2026 18:46:30 +0900
Message-ID: <20261005094632.580753-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
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
depending on the storage element type.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/zloop.c | 112 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 107 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 7e6b5cc8017d..1d51060b832b 100644
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
@@ -201,6 +205,29 @@ static unsigned int rq_zone_no(struct request *rq)
 	return blk_rq_pos(rq) >> zlo->zone_shift;
 }
 
+static bool zloop_zone_healthy(struct zloop_device *zlo,
+			       struct zloop_zone *zone, bool write)
+{
+	struct blk_storage_element *se;
+
+	if (!zlo->nr_elements)
+		return true;
+
+	/* Check the zone condition first. */
+	if (zone->cond == BLK_ZONE_COND_OFFLINE)
+		return false;
+	if (zone->cond == BLK_ZONE_COND_READONLY && write)
+		return false;
+
+	/* Check the health state of the storage element serving the zone. */
+	if (write)
+		se = &zlo->elements[zone->wr_se_id - 1];
+	else
+		se = &zlo->elements[zone->rd_se_id - 1];
+
+	return se->status == BLK_SE_STS_DEGRADED;
+}
+
 /*
  * Open an already open zone. This is mostly a no-op, except for the imp open ->
  * exp open condition change that may happen. We also move a zone at the tail of
@@ -733,9 +760,7 @@ static void zloop_rw(struct zloop_cmd *cmd)
 			 zone->start + zlo->zone_size))
 		goto out;
 
-	if (zone->cond == BLK_ZONE_COND_OFFLINE)
-		goto out;
-	if (zone->cond == BLK_ZONE_COND_READONLY && is_write)
+	if (!zloop_zone_healthy(zlo, zone, is_write))
 		goto out;
 
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
@@ -1095,6 +1120,31 @@ static int zloop_report_elements(struct gendisk *disk,
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
+	if (se->status == BLK_SE_STS_OK)
+		se->status = BLK_SE_STS_DEGRADED;
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
@@ -1904,6 +1954,39 @@ static int zloop_ctl_remove(struct zloop_options *opts)
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
+	zlo = idr_find(&zloop_index_idr, opts->id);
+	if (!zlo || zlo->state == Zlo_creating)
+		ret = -ENODEV;
+	else if (zlo->state == Zlo_deleting)
+		ret = -EINVAL;
+	mutex_unlock(&zloop_ctl_mutex);
+	if (ret)
+		return ret;
+
+	ret = zloop_degrade_element(zlo, opts->element_id);
+	if (!ret)
+		pr_info("Degraded element %u of device %u\n",
+			opts->id, opts->element_id);
+
+	return ret;
+}
+
 static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 {
 	substring_t args[MAX_OPT_ARGS];
@@ -1924,6 +2007,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
 	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
+	opts->element_id = ZLOOP_DEF_ELEMENT_ID;
 
 	if (!buf)
 		return 0;
@@ -2075,6 +2159,13 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
@@ -2103,14 +2194,16 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
 
@@ -2158,6 +2251,9 @@ static ssize_t zloop_ctl_write(struct file *file, const char __user *ubuf,
 	case ZLOOP_CTL_REMOVE:
 		ret = zloop_ctl_remove(&opts);
 		break;
+	case ZLOOP_CTL_DEGRADE_ELEMENT:
+		ret = zloop_ctl_degrade_element(&opts);
+		break;
 	default:
 		pr_err("Invalid operation\n");
 		ret = -EINVAL;
@@ -2181,6 +2277,8 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 		tok = &zloop_opt_tokens[i];
 		if (!tok->pattern)
 			break;
+		if (tok->token == ZLOOP_OPT_ELEMENT_ID)
+			continue;
 		if (i)
 			seq_putc(seq_file, ',');
 		seq_puts(seq_file, tok->pattern);
@@ -2191,6 +2289,10 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
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

