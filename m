Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A908282D91;
	Tue, 19 Nov 2024 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976141; cv=none; b=jk6prQhJ3SCq9A5oeYDB5WEHphARdAh4EUyWDNT9Abki6eAc1baLX8RutlTFZynBsYqZJd7Yi6forBECEuDA+Ry6yX65fQiVnIigV/cQ/maer7tCHUjMR/MrC6mc1L8Qn+AOxukcop1AnBYPxGrSjNRcvOE01pmPKBYYnHk23M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976141; c=relaxed/simple;
	bh=fwOdfQ/x2HOgWKEO78/wmXLgfazU3us33yLktN29+6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crafIbU9cXhi1kNr3SbEvjhcJYbMMF0NPIjxP5TmZbKLoN8sVP3qkBMlGsD1KnrdzWs5+MhpSnUKHI/Sm8aVCkoPZJHO6gN3brRVcUAl+Ao+p27N4HhQNa3la6rTfjZmxCri1X/j3g9o5TDc3SuT/dIKKxmCVlROWjBr6knOPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IsOSiKyk; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IsOSiKyk"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljR1GtqzlgT1K;
	Tue, 19 Nov 2024 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976136; x=1734568137; bh=71v0R
	Ga9kFJCqJAJTpFKNLCnmQ7dJ7JQaKkZwVvcq1w=; b=IsOSiKykek1MrG8dAjZPv
	m6uRO4HlSJPIFCmYZF89MWxpMyIow+KLruz+PYsMhdkMU84Ovteo327CbhimroXl
	7tND8WMG8macgblyYLuV5cYOOD7okrAAi3C+A3wi94N01IEh6AqeCH24ACLdvMjW
	kt5TSKG4VRlpBv4c6zXfwnVUzSySc6n3QVGwcGxcAglfkSm6KkMxN072IaqUm4ZO
	O5ko/fIzbg1WDuPvR50W/Z/dRplc48Y6jFdnDY0boYKk6904EC43seQf+VsFpebY
	z1aoUvvoCbj7Q5tOxprhD4uht/mVLF3l7aQUhntTfmaAlIDrbFVIuS5fKrU0nLDg
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A6ExA0re-6iL; Tue, 19 Nov 2024 00:28:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljL5DTFzlgVXv;
	Tue, 19 Nov 2024 00:28:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 16/26] blk-zoned: Document locking assumptions
Date: Mon, 18 Nov 2024 16:28:05 -0800
Message-ID: <20241119002815.600608-17-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 1d0f8fea7516..17fe40db1888 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -441,6 +441,8 @@ static inline void disk_put_zone_wplug(struct blk_zon=
e_wplug *zwplug)
 static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
 						 struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/* If the zone write plug was already removed, we are done. */
 	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED)
 		return false;
@@ -583,6 +585,8 @@ static inline void disk_zone_wplug_set_error(struct g=
endisk *disk,
 {
 	unsigned long flags;
=20
+	lockdep_assert_held(&zwplug->lock);
+
 	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
 		return;
=20
@@ -933,6 +937,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zon=
e_wplug *zwplug,
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
=20
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Check that the user is not attempting to write to a full zone.
 	 * We know such BIO will fail, and that would potentially overflow our
