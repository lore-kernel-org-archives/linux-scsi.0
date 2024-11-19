Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA0525632;
	Tue, 19 Nov 2024 00:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976143; cv=none; b=SfuVhhmhI2Zuq2aD4fGkviEilaX+P+qGYVW0aj4PQJJBmN7lR/Oj/TQ5PMkxmx1GjL5pWiiUQY5rDDZsoGaZxuAe1kaiIgW16RWH85sfSoXMacIebUmOC9xrrlSyPIaUcwM7JDNOq7wi0RMkm7/iVVL0gvbbQN3oxZWE05fYKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976143; c=relaxed/simple;
	bh=CE632OLHkRVhdjSCwwDmV09yw1UiRoQewtJ+mADvMkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/0ohiNPj+a1149QNYLuWCFLKGGCgQDTeiHCreukp+YkaB12yeJk2ksEkwuXKbwbZBa9mqFsx8L+WttYsMVjBt4QXW0QRqqsO8dVf8pnCR+fzqBfYyrXRWd9YBlOZWwf080xyKKv46VGQdq+cZF0x+GboEqKxxxXwcs1t2yB5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jQ10niYo; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jQ10niYo"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljV1TD6zlgT1M;
	Tue, 19 Nov 2024 00:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976139; x=1734568140; bh=OHDmu
	ir9C2Gpk82PnlQKADcYSuAXlDxCFRO42HlpWPo=; b=jQ10niYoH/12bdZMfXfeU
	wtkSe40/c4r9bB4vw+GO5KM3gpaDGrhbU2t8FKhcf2IC/Q4zGJYa8erlih7Vhhel
	iq3Xo6lanYVsDJdnOPFTs+wZo3r0i18L3sxc9tbc/3ZFtHJOymuamtNS5y2vSjxs
	vnxReqYO2UC/iqln5cgDKsfZBdBpN7ct0v8KasHQ9zyLHuggOXlfA0rsaDexrcae
	mwcfjmFq+LoKPE6FFhFVC88swFVz2tc29P1Gpeps2Gxs31kZ82ryIl24ndozHj5B
	MZjRDKDf/WMugdfqGkCR1AjMXMBSg+Lk+sjHfFWdMf44N4vUjQHPqoiF1ASWPqks
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id V83q5IkwGgpO; Tue, 19 Nov 2024 00:28:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljP6ks0zlgMVV;
	Tue, 19 Nov 2024 00:28:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 18/26] blk-zoned: Make disk_should_remove_zone_wplug() more robust
Date: Mon, 18 Nov 2024 16:28:07 -0800
Message-ID: <20241119002815.600608-19-bvanassche@acm.org>
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

Make the disk_should_remove_zone_wplug() behavior independent of the
number of zwplug references held by the caller.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 2b4783026450..59f6559b94da 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -457,12 +457,9 @@ static inline bool disk_should_remove_zone_wplug(str=
uct gendisk *disk,
 	 * blk_zone_write_plug_finish_request() (e.g. with split BIOs
 	 * that are chained). In such case, disk_zone_wplug_unplug_bio()
 	 * should not attempt to remove the zone write plug until all BIO
-	 * completions are seen. Check by looking at the zone write plug
-	 * reference count, which is 2 when the plug is unused (one reference
-	 * taken when the plug was allocated and another reference taken by the
-	 * caller context).
+	 * completions are seen.
 	 */
-	if (refcount_read(&zwplug->ref) > 2)
+	if (zwplug->wp_offset !=3D zwplug->wp_offset_compl)
 		return false;
=20
 	/* We can remove zone write plugs for zones that are empty or full. */
