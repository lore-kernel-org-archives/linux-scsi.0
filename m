Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DBE1AAC4;
	Tue, 19 Nov 2024 00:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976121; cv=none; b=K7NcoLzyREFwO1LBNfz1xwf96pfFOgeQr6MH3lslLgr6heJ7cDSbiOh/btQ2BoREqDCsQnaJzfuDQFcHrxxiFFme9ZdJGTXhIfhtqswHcnpLAg5HaiF10W6TaKz996MgKKiRyp8qtRPJPLIYaL8WWLFECwgNhFAtlE2W1ToDfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976121; c=relaxed/simple;
	bh=PjxHhccj2+TAGbA3DmBSp7d2J57ecWn+uCXAsj6mh4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdiE9PX8xeTq+29X38YsvBlA7NwN7UyOk0PDUdTIWMVeYl+h4odeRQwNOekx4DBTcjgHeNvkeEMk+Q1SzXFgUUXYJvBjxisQC6L7VSatQUg2DNlsQY9nBEA2P36K2Eqfzxx/1PMusYOzbAioCrfjEuhkrmXWccMD0Le8/tCLExA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ohkNRHiF; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ohkNRHiF"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslj21vMpzlgMVP;
	Tue, 19 Nov 2024 00:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976114; x=1734568115; bh=5tCYU
	FxX5QB6W+S/nygz6fD4vmkqD7ZMkhY3othO4o4=; b=ohkNRHiFdrU5i+gPhGegX
	tWt8tAYeezAKqW8Yd5+DgbURaHFF3wz0A2oN+xZkh6cRbBD1JDKpqfns8TOcx1PJ
	2NaI7Yt3DGTABgUFMqUIP5iewQse9+B7rToBGYskGhcbNERHIgsD9B68Zy8ezNqd
	5fRorevHsugHCU2IIjNOajr+e4IXRHmnBSYoKkCaZ1qH8k2K8GgsSdWmjQ8xVhZL
	x/AReUOtTqqMDN7KpYbtSDwcAoTUe9xqBQrRenFMS6TpKayAIo3xSlw1rRYLD+gr
	yFvwGo9Wb0r9GJF6AZzzc15pYpV5393kRMg1B1fwUzdl5mHpHap5jtnrPG26fRS4
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id noDKav8J8OUX; Tue, 19 Nov 2024 00:28:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslhx0j5pzlgVnY;
	Tue, 19 Nov 2024 00:28:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 03/26] blk-zoned: Split queue_zone_wplugs_show()
Date: Mon, 18 Nov 2024 16:27:52 -0800
Message-ID: <20241119002815.600608-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Reduce the indentation level of the code in queue_zone_wplugs_show() by
moving the body of the loop in that function into a new function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e5c8ab1eab9f..7e6e6ebb6235 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1838,37 +1838,41 @@ int blk_revalidate_disk_zones(struct gendisk *dis=
k)
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
=20
 #ifdef CONFIG_BLK_DEBUG_FS
+static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
+				  struct seq_file *m)
+{
+	unsigned int zwp_wp_offset, zwp_flags;
+	unsigned int zwp_zone_no, zwp_ref;
+	unsigned int zwp_bio_list_size;
+	unsigned long flags;
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+	zwp_zone_no =3D zwplug->zone_no;
+	zwp_flags =3D zwplug->flags;
+	zwp_ref =3D refcount_read(&zwplug->ref);
+	zwp_wp_offset =3D zwplug->wp_offset;
+	zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
+		   zwp_wp_offset, zwp_bio_list_size);
+}
=20
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
 {
 	struct request_queue *q =3D data;
 	struct gendisk *disk =3D q->disk;
 	struct blk_zone_wplug *zwplug;
-	unsigned int zwp_wp_offset, zwp_flags;
-	unsigned int zwp_zone_no, zwp_ref;
-	unsigned int zwp_bio_list_size, i;
-	unsigned long flags;
+	unsigned int i;
=20
 	if (!disk->zone_wplugs_hash)
 		return 0;
=20
 	rcu_read_lock();
-	for (i =3D 0; i < disk_zone_wplugs_hash_size(disk); i++) {
-		hlist_for_each_entry_rcu(zwplug,
-					 &disk->zone_wplugs_hash[i], node) {
-			spin_lock_irqsave(&zwplug->lock, flags);
-			zwp_zone_no =3D zwplug->zone_no;
-			zwp_flags =3D zwplug->flags;
-			zwp_ref =3D refcount_read(&zwplug->ref);
-			zwp_wp_offset =3D zwplug->wp_offset;
-			zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
-			spin_unlock_irqrestore(&zwplug->lock, flags);
-
-			seq_printf(m, "%u 0x%x %u %u %u\n",
-				   zwp_zone_no, zwp_flags, zwp_ref,
-				   zwp_wp_offset, zwp_bio_list_size);
-		}
-	}
+	for (i =3D 0; i < disk_zone_wplugs_hash_size(disk); i++)
+		hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[i],
+					 node)
+			queue_zone_wplug_show(zwplug, m);
 	rcu_read_unlock();
=20
 	return 0;
