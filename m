Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47F23ED69;
	Tue,  8 Jul 2025 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012482; cv=none; b=bSuFeaURQOHbywiH9Le5Z3K5FbQ3cX6z5rg0XFEqEy9ZIkh8KIfOXPK3xTF6ri4BAZJip9+8XkxfLfS5YWafpKCAOEZENsXw2f6AkYjFyxv1a2ih6XIsgOBfRWKS0O9QtOBSfRreYdbnSLCNO/YtgmA4bn+8kgoQNPA//8wLLhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012482; c=relaxed/simple;
	bh=9jns3wq6nP99XpgnGvkdXDZuR2pcrmhMF8fbySBxPHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWULWDgwtVFvu1Y9BQYMzb7iQTfS8rRxxNPZ+e2+1fvfCxeczbqtGkCJ6/ij1NfsSd5yhXnOg2Wj77ott7MYWR5jLWTrQyEbWj2dtsRj/q1OJOAOEWs63mGP743DGipBuf3LUG6edtJggFqf1n/dD0+xRCN+gpAdw19yk1Tu54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EaCUw7X1; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EaCUw7X1"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFbh1c2XzltKGS;
	Tue,  8 Jul 2025 22:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012478; x=1754604479; bh=P3Z8Q
	N15w7tbGHD98/vVr41q6VAfETg3kfI9Wt585bw=; b=EaCUw7X1r9EuA+l1XhYCj
	0kp96F4M7Xaz07QFRH9y97q/C2GqLS6mMu+vcIZ+DaUm2sF/tndB3ysd/xZ2PhJD
	GH5hYwlQitz4X2GeZgFKk0pT7fWJYYBAvsorf7bCIp7hPCi5sZcOnENk6xwumwEx
	MdSo3q+l/uLD3nCsvrzU3U4UHnD2Gqu24FwTze0SwM2MaN2gsZnV+/AEHORLy/XS
	XRdXMSR/IPpkGldsaD+DawBVEhP+4lCIg+8/+sUE7C6cC4/WJJLtq8AEZ43mMrTm
	wqL2M4/OqycLWeDkY3VGTwxB6KwYnsFleedSL+4VEHTNGBAWXYwn253gTBruqXHe
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8HCY5j8mOEZ3; Tue,  8 Jul 2025 22:07:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbb1t3dzlh3sX;
	Tue,  8 Jul 2025 22:07:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 04/13] blk-zoned: Split an if-statement
Date: Tue,  8 Jul 2025 15:07:01 -0700
Message-ID: <20250708220710.3897958-5-bvanassche@acm.org>
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

Prepare for moving code from disk_zone_wplug_add_bio() into its caller.
Split an if-statement and also the comment above that if-statement. No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3f285e372460..089f106fd82e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1029,14 +1029,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	/* Indicate that this BIO is being handled using zone write plugging. *=
/
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
=20
+	/* If the zone is already plugged, add the BIO to the plug BIO list. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
+		goto plug;
 	/*
-	 * If the zone is already plugged, add the BIO to the plug BIO list.
 	 * Do the same for REQ_NOWAIT BIOs to ensure that we will not see a
 	 * BLK_STS_AGAIN failure if we let the BIO execute.
-	 * Otherwise, plug and let the BIO execute.
 	 */
-	if ((zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) ||
-	    (bio->bi_opf & REQ_NOWAIT))
+	if (bio->bi_opf & REQ_NOWAIT)
 		goto plug;
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
@@ -1045,6 +1045,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 		return true;
 	}
=20
+	/* Otherwise, plug and submit the BIO. */
 	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
