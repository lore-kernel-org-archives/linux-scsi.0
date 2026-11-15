Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785613;
	b=XP7fQUDmE2Z7N2vYwa6crxs751+EaGCLwjyhuBurv523Yi+HIEQhdl4Ra9LDBYcbLCn1
	 ZtsLIpzDP1AZ4cBMwpeL5rl/yVHoSOCMxn5zPzcPEtxatEjhVEgrOF54tK9m4J5kt7Nan
	 hUC1TLi1u0GBvwR6ZjtWvHzLE51fBZx1wCGcpBfEF6HRxyeVmCkGCD3OcXLfGFH59DQ3Y
	 YdtikqpkYRiunYM6O6sstjGSoKmBkuhLM4mn1EB6ssdxN3pQg3LuqBrtc1SBZEY3UB3cN
	 8veiGH9CXrobyTzp8hQFJsg6cvC1ggrqYqIjYt3fMU0DK3KKhBWANKo39DB5OVXsHpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785613;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2XLIWZRlmIHO71EpMgCFOaAvULmmLhC0jsQ8sNi2fL0=;
	b=ZzmN/sqWhrQ79zisBoKBGUdpBOa+Mry1O5to2uI/9D42YvcxC9exPeVXnNw2v63a7epc
	 ucmOm9Ajr9tU80Uj5DSJ0C2fSyCZx370AVcicmbwPEEFx2TRIEFSM1tOHgi8LF93sndpV
	 XOjJZ11OnTZB5zxOFkzr+6iELdv6pt0/W1ZX9lRmk9FcXBV/eYlpys94u8B/M/1EHay+o
	 nLQATVO0erFzyoKf4/89ha1r7GbLD1rUHngoW3KwXPu4GfwgKN6fs6TS2qXb+L7erb4gF
	 RZL+2q+/Wh7W+ldIq+v+oriK/8s3yyW4VLMsR1qIJM7zUBfnxUwpHc3VUFCP1xhVjsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMfODwPb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43714606A31F;
	Sun, 15 Nov 2026 23:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMfODwPb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D51F000C5;
	Sun, 15 Nov 2026 23:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785613;
	bh=2XLIWZRlmIHO71EpMgCFOaAvULmmLhC0jsQ8sNi2fL0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=aMfODwPbUzoNe9DmoVlp399gxYXwlughhwqQ6phjY+X4m0VPoUeA7O9gaVay4nbzQ
	 eylrrZtzM8uOarQHtkT0mxccvDYQXuheQukTS1f3RuHmxFvYwuOfKQeoCaGOETeUSG
	 KGLNFww5Jj5JACfLCV8hIHWkvvLr4Bn74yrvzb69+df0Ujjfji7trqBmSHDgVDSbQZ
	 j23wBveHC38NuUoISEPOerCKFTiMt5+OoDjkKoXIT5ccex2WDbOc0M+v/bhYZ3f67e
	 01wf0UtLDB3geZRgXb8LL/mlFI3+1cknzfzG1uPgT6hLGjouP2hF4cS56POVyTmNTE
	 1/gpisXyjLSrQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 03/13] block: allow dropping all zone write plugs on revalidation
Date: Mon, 16 Nov 2026 08:33:17 +0900
Message-ID: <20261115233327.941586-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
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

