Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20CA1C5F13;
	Tue,  8 Jul 2025 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012492; cv=none; b=asr5FgTY5IG89b14eJnNiLVIpzGVKjYk4l9NummyC6qa7qwX1NquMdaw67aoKShJ3ounZUS+K/zc+Ltdpjof8N9oREEP/YqeAgBxqBmjpHLVNo6atFrzjUcMYOvtgd0fa+9Ud47UcIle/9pKMY5MEbWgJlD6NsFWqDmdJqP18Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012492; c=relaxed/simple;
	bh=rI474pHRmmNVZBh8halEgIz2zs6iBefPAhARf5yYXyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQKgEx1ErvmldzcLPL1cwx8LVLS25Nfkb3eCqnnKg69A1QuRY8J4K2ExIzhuKyZRcJGzCIt2Fugn2GMzQRni+eGsrzpYfaKaC9vWL8v0r05MsLui07cbbWZanVArQq8UW5BxUbnG88sAfaalArtTjt88EUX269/qgbrqgovokSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4O2aXl+Y; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4O2aXl+Y"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFbs0P9YzltKGS;
	Tue,  8 Jul 2025 22:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012487; x=1754604488; bh=ysBj8
	uMgtABKzwFBL2DiXYnmjuWfbJpLFTAgKlZUbNY=; b=4O2aXl+YYPqysrT8/w+ss
	Rvx0SmGA0L/HzUD5ZPso1CesXonpR4lfoq2bFLsgB4sx+QlpbGaXi88Uj0kOa6zv
	lApQglWtTxNpFNEhiMh5OVQmaR8gvwnHLXCHEgmCcGkrkCoo4z6zYyNRfA7OVI0b
	Kx7/dq/du3XEWA4qHw0fiaMlW5hU/eF7NNeDhPK/GxeO1PTjXgkT6SfBuLsX53vA
	5Fa1fw8n7OjOcCGYS6sbfoskRbutZ6c8YjYGRUJST0OlGMEmlVzl6DGMhGVZI/Vz
	2EnscY9fnXTe3LO6BOU/iiuXcXw8hqMvKFMTQ/IzMAWucE9mXd64rovO8VMEduE9
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kIQ8Gdl71Jpc; Tue,  8 Jul 2025 22:08:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbm0cnjzlgqVk;
	Tue,  8 Jul 2025 22:08:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 06/13] blk-zoned: Split blk_zone_wplug_bio_work()
Date: Tue,  8 Jul 2025 15:07:03 -0700
Message-ID: <20250708220710.3897958-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250708220710.3897958-1-bvanassche@acm.org>
References: <20250708220710.3897958-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 2a85e3b7b081..d2aa7671ddd6 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1257,10 +1257,8 @@ void blk_zone_write_plug_finish_request(struct req=
uest *req)
 	disk_put_zone_wplug(zwplug);
 }
=20
-static void blk_zone_wplug_bio_work(struct work_struct *work)
+static void blk_zone_submit_one_bio(struct blk_zone_wplug *zwplug)
 {
-	struct blk_zone_wplug *zwplug =3D
-		container_of(work, struct blk_zone_wplug, bio_work);
 	struct block_device *bdev;
 	unsigned long flags;
 	struct bio *bio;
@@ -1276,7 +1274,7 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 	if (!bio) {
 		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		goto put_zwplug;
+		return;
 	}
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
@@ -1300,8 +1298,15 @@ static void blk_zone_wplug_bio_work(struct work_st=
ruct *work)
 	} else {
 		blk_mq_submit_bio(bio);
 	}
+}
+
+static void blk_zone_wplug_bio_work(struct work_struct *work)
+{
+	struct blk_zone_wplug *zwplug =3D
+		container_of(work, struct blk_zone_wplug, bio_work);
+
+	blk_zone_submit_one_bio(zwplug);
=20
-put_zwplug:
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). *=
/
 	disk_put_zone_wplug(zwplug);
 }
