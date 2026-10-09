Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20549BD7C;
	Fri,  9 Oct 2026 09:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536995; cv=none; b=SNZi8ydci548bxooIkIQrhuwXjxcbeEiKdJb13NGiUHZn8pzjlOUk3MT+h1l8xvkpOLVh7w1d+APxpEqG/L+rurISGmzPt6JaEMZmR1bn/kUq8VuebKro6rGpUXYl3EZDlj15l3v5+qURm0KnmdUgoJsA6DeK4FQVM1RiRO+eoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536995; c=relaxed/simple;
	bh=IQSZh75PSEu3nXdr3GZziztt0GmnixFMK6tYKjpIrhE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7MQ9eYpCcKVNcUeFfMdmm2C/hIcKrbMTgNDpxZqqvdzZyQCDCZKHyGnvpq0MHp7wi07o+cYvH1tKZhTkh1JcboEeVeLHYhZVDXEsrYKi8tGvZMtx1mgv+6qtl6X10f0wK8BzSv+5iP/5uA3SWr/trORUaHpir2RHtj6nVUpBEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWQrO/VJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWQrO/VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B24E1F00893;
	Fri,  9 Oct 2026 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536993;
	bh=BpwMjh+qJJK3YGFn0YMY0b2FLKK2DYDHdKui1fMRKxE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=iWQrO/VJ3N+Cx1Z+bn9F8vyg6sat9sEqRko9t5bw5TULFENn9trH9iBYH8/2vI2CG
	 FRKHyaE5vr9TsBVMlvdMDSjAtZel5g4koQ5dDGwyA8CkUnHS19TiO7b8jHMxPV+pau
	 6G/zR8bKjuxswz5ekaT7Rvbhbh+Kr0pebr93Q6oZqIrTs0WiW4bJjxeIs1NkOWonpP
	 Taffprnd1KDCrANUY3i7eLJoDYdMuLYaotYuocLhegLEicoyKWOmo1X4TVkXhrUqgW
	 AXFXsw/eOhfRwhjtwT6cwfq/suX5eGG9aAYl7doHGzHWzo1Av5ANrApSHA6JPoG9EI
	 R83vvmqAlEsdQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 6/9] zloop: add degrade_element control command
Date: Fri,  9 Oct 2026 18:09:42 +0900
Message-ID: <20261009090945.1504194-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009090945.1504194-1-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
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
 drivers/block/zloop.c | 91 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index c79653831fd3..a1c9f7a960cf 100644
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
@@ -1001,7 +1005,8 @@ static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
 			se = &zlo->elements[zone->wr_se_id - 1];
 		else
 			se = &zlo->elements[zone->rd_se_id - 1];
-		if (READ_ONCE(se->status) == BLK_SE_STS_REMOVE_IN_PROGRESS) {
+		if (READ_ONCE(se->status) == BLK_SE_STS_DEGRADED ||
+		    READ_ONCE(se->status) == BLK_SE_STS_REMOVE_IN_PROGRESS) {
 			ret = false;
 			goto unlock;
 		}
@@ -1173,6 +1178,31 @@ static int zloop_report_elements(struct gendisk *disk,
 	return 0;
 }
 
+static int zloop_degrade_element(struct zloop_device *zlo,
+				 unsigned int element_id)
+{
+	struct blk_se *se;
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
@@ -2000,6 +2030,42 @@ static int zloop_ctl_remove(struct zloop_options *opts)
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
+			opts->element_id, opts->id);
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
@@ -2020,6 +2086,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
 	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
+	opts->element_id = ZLOOP_DEF_ELEMENT_ID;
 
 	if (!buf)
 		return 0;
@@ -2171,6 +2238,13 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
@@ -2199,14 +2273,16 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
 
@@ -2254,6 +2330,9 @@ static ssize_t zloop_ctl_write(struct file *file, const char __user *ubuf,
 	case ZLOOP_CTL_REMOVE:
 		ret = zloop_ctl_remove(&opts);
 		break;
+	case ZLOOP_CTL_DEGRADE_ELEMENT:
+		ret = zloop_ctl_degrade_element(&opts);
+		break;
 	default:
 		pr_err("Invalid operation\n");
 		ret = -EINVAL;
@@ -2277,6 +2356,8 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 		tok = &zloop_opt_tokens[i];
 		if (!tok->pattern)
 			break;
+		if (tok->token == ZLOOP_OPT_ELEMENT_ID)
+			continue;
 		if (i)
 			seq_putc(seq_file, ',');
 		seq_puts(seq_file, tok->pattern);
@@ -2287,6 +2368,10 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
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

