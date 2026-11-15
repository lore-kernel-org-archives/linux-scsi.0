Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754222;
	b=xYwL6iBbezO4BchrN+4/n5Nc1nQ+W/3WTebEbiipzckxvpdYGMLAiiBnIvllyn7w09p/
	 U0GrL8t+ySsV1rCttyCBo9bkNVfbpOcjZpYdxyugK958ARDSrlJ2fu085Oc0itVFELDli
	 ThUcd770s2AodQ/cI16DDJbtX7YFWGgeS5m7oBxT8Qz+taYtotHihXmBKVsqfXYKYLYJJ
	 69cph68yPsl/DIY4p9khwMav+M4zOuHqQBn8O+apLAhWHNuY28/YWRCVxf14pqpXDnzc2
	 lrjSEW6ErapDUlD6ZDNpG10WTmxkleio39+/qWVt7dTdBpp3VpaqVu7Qm913rCmatKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754222;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2XLIWZRlmIHO71EpMgCFOaAvULmmLhC0jsQ8sNi2fL0=;
	b=1ycU1toZaC6XM+Vd4cIYWg+SRjFMGhmQBTg8HIV0lTFV8SHDuFlRhle2fT213CNrjZRH
	 6oKAUKz/pzDepN5NhBY976t2jX/WMPU85JjI2yo3W8YPp0gOItJ3dSjRWUS+qXthj6hsm
	 FfhPz1MDiVsgqYU2/C8qK6DtVvp76jkEME3/pRVdzOzVvEcwFKOT0+KJDnPwt24BSqp4J
	 dzt/+MNYVXmzKAIPaKZITXcBtJ3vP2lVUio26OmqEUL8xR+4CPwapAzv6bbNykk9xBLU7
	 tLJ+cu+TXu/pFbzOoGnBzrFBfCUWLnxeFobWnOd3ZlIu6GMcjkdTyeIqA51UWOWuiRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLmHU62p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A785606A327;
	Sun, 15 Nov 2026 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLmHU62p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3796B1F000C4;
	Sun, 15 Nov 2026 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754222;
	bh=2XLIWZRlmIHO71EpMgCFOaAvULmmLhC0jsQ8sNi2fL0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=WLmHU62peTqY2T9Ag3RbSUH21+EJsWGO1LJWU2QzRM/GTcK4D6amZJQDNBlaF2BN2
	 uIfeQ4OCG85JNdPtJ3ljF8iyLp/8kzjimiBaCQLaaaiQ9bpZjHGnwbwb986FyAHZSq
	 CUv0fS3DP4BT7fQfOQAUW8OYy1C8w/qay3kxTtNfdsIVsMYGmBJ/ivBXPv6Mjk3siU
	 K2vO9rI6tyeVx2iZ7CgWW8gYSpL4wY55WIaDGWM43maTw29uQhHuyosjb5fqRngvLq
	 bdJXvrq/4uxHj91E9ZXNVjZxx6+jAoaDNfuI3TilTc6HLvYGiQV8wCj0cw4TIDcqh0
	 t0+PDzpzayknw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 03/13] block: allow dropping all zone write plugs on revalidation
Date: Sun, 15 Nov 2026 23:50:05 +0900
Message-ID: <20261115145015.938426-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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

In preparation for supporting storage element depopulation, modify the
function disk_revalidate_zones() to take an additional boolean parameter
drop_all_zwplugs to force removing all zone write plugs from a disk hash
table.  Removing all zone write plugs is done in the same manner as for a
capacity change, using the function disk_drop_zone_wplug() applied to all
hashed zone write plugs.

Calls to disk_revalidate_zones() with the argument drop_all_zwplugs set to
true will be used when restoring depopulated storage elements as such
operation clears all sequential zones, modifying them to be empty.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 600d6bd008ae..3761e634650e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2552,7 +2552,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	return ret;
 }
 
-static int disk_revalidate_zones(struct gendisk *disk)
+static int disk_revalidate_zones(struct gendisk *disk, bool drop_all_zwplugs)
 {
 	struct blk_revalidate_zone_args args = { };
 	struct blk_report_zones_args rep_args = {
@@ -2563,6 +2563,9 @@ static int disk_revalidate_zones(struct gendisk *disk)
 	int retries = 2;
 	int ret;
 
+	if (drop_all_zwplugs)
+		disk_for_all_zone_wplugs(disk, disk_drop_zone_wplug, NULL);
+
 again:
 	ret = disk_revalidate_capacity(disk, &args);
 	if (ret)
@@ -2647,7 +2650,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	 * eventually change the disk zone information.
 	 */
 	mutex_lock(&disk->zone_revalidate_mutex);
-	ret = disk_revalidate_zones(disk);
+	ret = disk_revalidate_zones(disk, false);
 	mutex_unlock(&disk->zone_revalidate_mutex);
 
 	return ret;
-- 
2.56.0

