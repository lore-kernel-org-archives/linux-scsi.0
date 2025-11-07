Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E6D2BCF6C;
	Fri,  7 Nov 2025 23:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559658; cv=none; b=tymmTP5FK8xuR8evtM+LLEyjeM85n0K+YAjHlSlccLMhcyPl4yqUZXrH2AEr34xQIaGLuYYI2deZ5MOb+Kk4+NdFFqsXdHeLt5hVOdotC/jaWhvT8J/KnVyoYfRXz9K1fV6IdyQckt51/c7hE1RTHApbw5SfRoYXtI760aK9LqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559658; c=relaxed/simple;
	bh=e1pc85v2YlZM67+SPgwia5fYR9cxMchBGvd00INBcko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/DN6S+mNi2xl5P1FNSTipgkKMIJFS0lQBd8u3EEiMCKungG0Y/Uwtlf1Sqga6CkuPMqRGzc4nZGrYh61+5ipYaKHXreU84rBQZQsHBmTEnhNuZ1l5lgYE6d6gHbwpXnuHQve8uFqHFIeFuIjyAmyw18lFAMJa+/rFcPEtuTwpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wVaH2bbb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wVaH2bbb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3GB00sbTzm17wv;
	Fri,  7 Nov 2025 23:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559654; x=1765151655; bh=dFtxN
	G8cwdbUgnV8hIdSGJAYg5m6maOJuti3OkLUzsc=; b=wVaH2bbbv0niuYyyQGvoc
	zgMwtHrYofTKUUqf+DVBvNH39xpIyT7ZAXdfMe5BdKi1P8FNAoBDN9FHavJqCs9i
	4jKw0t31tfYQCtesCMiUOo5xSktENy/kUNSoZD50RAAGJwg5JGK0qII9Nml9K2yc
	gqbC8053GSDk00Htombpaa28g3+8KnPjHPHvDg1tlRQCQnmqrw0KI18SOGf+RFHq
	iUAARQrauymNuDAfrbwY5+AyrQ6GKaQj27SxK8XIJoBX5NcahxUFvmt453J8GRO5
	z+ZvDijO4S2Y5meUCUUBDzicEhpIjH3Q8rsayODEVIP5fpbEWK//sXGLYft1uSqX
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BRu9IipjZ08W; Fri,  7 Nov 2025 23:54:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9t6f0Nzm17wy;
	Fri,  7 Nov 2025 23:54:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 10/17] blk-zoned: Document disk_zone_wplug_schedule_bio_work() locking
Date: Fri,  7 Nov 2025 15:53:03 -0800
Message-ID: <20251107235310.2098676-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Before adding more code in disk_zone_wplug_schedule_bio_work() that depen=
ds
on the zone write plug lock being held, document that all callers hold th=
is
lock.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ceb2b432e49e..b55f583cbc86 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1188,6 +1188,8 @@ void blk_zone_mgmt_bio_endio(struct bio *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Take a reference on the zone write plug and schedule the submission
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
