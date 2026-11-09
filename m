Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217915;
	b=VmRY1tce6CSbs9SAWK81s8azKEY/LuLMFaEHBpV3Pf08rqqiWdhBgCI5ShZQ1rPwTnXF
	 QSfK54wtVxFXupCPxeOKjazc+Cs6+xBGXhj3bXWRahRjdZchZg3DiJMxUfgLgYWmzUV8T
	 K1WZ5UM1xupg5DJ8Dzuugs/OP4SFIC9+9lfdXeuZZQcyVX3qX7dkRxq5dNaKTRLSA09nR
	 C9pwedsQ1E7UF2PXzUdOJT+L0DMBbOR2I6+hb/sF1m84ZPEOaJWnQltZlQF+1Khsz35pq
	 /y/lpgh9qLx06zei4vJCKXqHswDvtQnhHMY1/SRHb30hDw9CDVWEHi64OHLSlYBeHVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217915;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iK1sH17vpAutlHRyCBTOlhD71ViBei/gRSydQyaQVVc=;
	b=PMceDbqFSNbyF+V5NnKNIPP1eFCuW/HUgQTnmu2f7TwPm4nFWnr3ArtY5qKoImdqx1wf
	 Em+GQKjG1NuGkKnEzwK1vIJ6c6iECAW2zb0HCBtKWGTHaOd/X90BK0eHPTZiRKRovACIW
	 5YoHBrLFPrwUKAxQAqxJA0WI49nQqX29EL3GYTNXCKKcuRku1s4zW6ev8Pc+tZIwyoYX2
	 ZiPGRA7OVriZRnZBsBm+DVd5bHRMj5CZ1E+VMf2nUqnLj1/8NkKa9JqbLY+nqffNt8Z6k
	 WSm9ECMkGLDsx4elGNq/WFB04xaVMzz6iG06fbA3G4+Ug4S1wQSVXvwHEyGy5x/ZYiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNRQUUFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914CC606D804;
	Mon,  9 Nov 2026 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNRQUUFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B351F008A2;
	Mon,  9 Nov 2026 09:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217915;
	bh=iK1sH17vpAutlHRyCBTOlhD71ViBei/gRSydQyaQVVc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=YNRQUUFp1p0jUtiM0RNW/Fkb+Rhhss+OJcmAnW8gwWR/8p9UrSoAVPR7AbJ68JIYA
	 vcGAdOQrSuw6C1uBDK1fGSHDnW78e5oKdnkNY7t2SPH3TCkC4j5E+UazNW1yJNacSA
	 wHWXTjrcPG16pfGXtiCLihuNdWfnXs9279kL/ismNi/GDV/wkHdNSvcKx7tZbg9/Zg
	 EadUmF7913xtC9NMkNVH66P5hf/E6cEJAswsEm3xBe8HuhOaqZSp/ZbYX2sFrxAwvQ
	 iZ3nvaQZgaXPsodSHZYudyBo/ZZmuzwrjWY6Fsia6VkJpqikxyBV4uS1DSl0b5e3sg
	 otbML7oJNju5w==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 08/12] zloop: add degrade_element control command
Date: Mon,  9 Nov 2026 18:51:40 +0900
Message-ID: <20261109095144.819709-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow users to mark storage elements of a zloop device as degraded using
the new "degrade_element" control command. The element to degrade is
indicated using the element_id option. Example:

echo "degrade_element id=0,element_id=2" > /dev/zloop-control

If the element ID identifies an all access storage element, both read and
write operations targeting a zone served by the degraded element are
failed. In the case of a partial access storage element, any write access
to a zone whose write element is degraded will fail, and read accesses
to a zone whose read element is degraded will result in an error.

The zoned_loop.rst documentation file is also updated to explain this new
feature.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 .../admin-guide/blockdev/zoned_loop.rst       |  22 +++-
 drivers/block/zloop.c                         | 100 +++++++++++++++++-
 2 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zoned_loop.rst b/Documentation/admin-guide/blockdev/zoned_loop.rst
index 80a564836c1b..d378fbdc1983 100644
--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -63,6 +63,7 @@ The options available for the add command can be listed by reading the
 	$ cat /dev/zloop-control
         add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache,stor_elements=%u
         remove id=%d
+        degrade_element id=%d,element_id=%u
 
 In more details, the options that can be used with the "add" command are as
 follows.
@@ -144,7 +145,26 @@ the zoned device will not be created.
 To fully delete a zoned device, after executing the remove operation, the device
 base directory containing the backing files of the device zones must be deleted.
 
-4) Example
+4) Degrading a storage element
+------------------------------
+
+When storage element emulation is enabled, storage elements can be set in a
+degraded state to emulate defective storage elements (e.g. defective heads of a
+hard disk). This is done by issuing the "degrade_element" command to
+/dev/zloop-control, specifying the ID of the target device and the ID of the
+storage element to degrade::
+
+        $ echo "degrade_element id=X,element_id=Y" > /dev/zloop-control
+
+Depending on the type of the storage element specified, a read or write access
+to sectors of a zone served by a degraded storage element will result in a
+failure. For partial access storage elements, write accesses are always failed
+if the write element serving the zone is degraded. Likewise, read accesses are
+failed if the read element serving the zone is degraded. When storage elements
+are emulated as all access physical elements, both read and write operations are
+failed when the storage element serving the zones being accessed is degraded.
+
+5) Example
 ----------
 
 The following sequence of commands creates a 2GB zoned device with zones of 64
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 75506e6a4d75..c4a0a845a096 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -39,6 +39,7 @@ enum {
 	ZLOOP_OPT_DISCARD_WRITE_CACHE	= (1 << 11),
 	ZLOOP_OPT_MAX_OPEN_ZONES	= (1 << 12),
 	ZLOOP_OPT_STOR_ELEMENTS		= (1 << 13),
+	ZLOOP_OPT_ELEMENT_ID		= (1 << 14),
 };
 
 static const match_table_t zloop_opt_tokens = {
@@ -56,6 +57,7 @@ static const match_table_t zloop_opt_tokens = {
 	{ ZLOOP_OPT_DISCARD_WRITE_CACHE, "discard_write_cache"	},
 	{ ZLOOP_OPT_MAX_OPEN_ZONES,	"max_open_zones=%u"	},
 	{ ZLOOP_OPT_STOR_ELEMENTS,	"stor_elements=%u"	},
+	{ ZLOOP_OPT_ELEMENT_ID,		"element_id=%u"		},
 	{ ZLOOP_OPT_ERR,		NULL			}
 };
 
@@ -82,6 +84,7 @@ enum zloop_stor_elements {
 #define ZLOOP_DEF_ZONE_APPEND		true
 #define ZLOOP_DEF_ORDERED_ZONE_APPEND	false
 #define ZLOOP_DEF_STOR_ELEMENTS		ZLOOP_STOR_ELEMENTS_NONE
+#define ZLOOP_DEF_ELEMENT_ID		0
 
 /* Arbitrary limit on the zone size (16GB). */
 #define ZLOOP_MAX_ZONE_SIZE_MB		16384
@@ -102,6 +105,7 @@ struct zloop_options {
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
 	enum zloop_stor_elements stor_elements;
+	unsigned int		element_id;
 };
 
 /*
@@ -1208,6 +1212,31 @@ static int zloop_report_elements(struct gendisk *disk,
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
 static int zloop_execute_remove_element(struct zloop_device *zlo)
 {
 	struct gendisk *disk = zlo->disk;
@@ -1791,6 +1820,11 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	int ret = -EINVAL;
 	bool restore;
 
+	if (opts->mask & ZLOOP_OPT_ELEMENT_ID) {
+		pr_err("Invalid option specified for add\n");
+		return -EINVAL;
+	}
+
 	__module_get(THIS_MODULE);
 
 	nr_zones = opts->capacity >> ilog2(opts->zone_size);
@@ -2074,6 +2108,49 @@ static int zloop_ctl_remove(struct zloop_options *opts)
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
+	if (!(opts->mask & ZLOOP_OPT_ELEMENT_ID)) {
+		pr_err("No element ID specified for degrade_element\n");
+		return -EINVAL;
+	}
+
+	if (opts->mask & ~(ZLOOP_OPT_ID | ZLOOP_OPT_ELEMENT_ID)) {
+		pr_err("Invalid option specified for degrade_element\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_killable(&zloop_ctl_mutex);
+	if (ret)
+		return ret;
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
+		pr_info("%pg: degraded element %u\n",
+			zlo->disk->part0, opts->element_id);
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
@@ -2094,6 +2171,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
 	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
+	opts->element_id = ZLOOP_DEF_ELEMENT_ID;
 
 	if (!buf)
 		return 0;
@@ -2245,6 +2323,13 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
@@ -2273,14 +2358,16 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
 
@@ -2328,6 +2415,9 @@ static ssize_t zloop_ctl_write(struct file *file, const char __user *ubuf,
 	case ZLOOP_CTL_REMOVE:
 		ret = zloop_ctl_remove(&opts);
 		break;
+	case ZLOOP_CTL_DEGRADE_ELEMENT:
+		ret = zloop_ctl_degrade_element(&opts);
+		break;
 	default:
 		pr_err("Invalid operation\n");
 		ret = -EINVAL;
@@ -2351,6 +2441,8 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 		tok = &zloop_opt_tokens[i];
 		if (!tok->pattern)
 			break;
+		if (tok->token == ZLOOP_OPT_ELEMENT_ID)
+			continue;
 		if (i)
 			seq_putc(seq_file, ',');
 		seq_puts(seq_file, tok->pattern);
@@ -2361,6 +2453,10 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
 	seq_puts(seq_file, zloop_ctl_ops[1].name);
 	seq_puts(seq_file, " id=%d\n");
 
+	/* Degrade element operation */
+	seq_puts(seq_file, zloop_ctl_ops[2].name);
+	seq_puts(seq_file, " id=%d,element_id=%u\n");
+
 	return 0;
 }
 
-- 
2.56.0

