Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3669F2E88B6;
	Tue, 14 Oct 2025 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478968; cv=none; b=PTH0qAZnayeLsPUU4uS5JXxqOs23/pbpVgB2YhyUuEQcFoEzFaNCpb2tqfBWd0Rwq8H6iGaNxV9dtOzhU9Jiz5pwnnxv1s2+HKAB3bjpLmKvkM7kbEcBXeF5kSZ83quOSzFtKDhigoKWRlyDZxaJN8+22/Fz0y+aHh8mEPJtX00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478968; c=relaxed/simple;
	bh=2pJwqSI+9LByQQPUBAGf2dDo2TTPI7xAl8YHi1IfAPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO9cAx0EwUEUieRIdJhU59nPYqg58h/NtKFIk+0UzD9IVyM0kZzl9VTfO0sg/7pd5przHPPVpCy7ebMnhsNDFRn0ZF09aFiK8aLHnrq2ITybNezmoQFJk8XJZYGDjC2/HkrmwBGKyWzF9RX+1wzknm8uEtzQ8PerQ7qBBxbAjMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AviBfiUY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AviBfiUY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmShh1RdQzm0ySn;
	Tue, 14 Oct 2025 21:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478962; x=1763070963; bh=69lJ8
	Egzara3wnwCCVoy3epI3/wpnkh5XeGrgORLESk=; b=AviBfiUYeuCDaW5nNL6Tu
	TVBygaTmI83vvooLVMJCjjAtXbVkauTRpKFS1N3WhrdhMyg+TteJwZIib0mQXpyd
	jgDntX8l+9cT0Gg3PvYllyugpEgFkyZBlDHQEy1++ipeb2KuYedN1qy25UVZX3u9
	U98uT7zGvi8iCEzjzpcrK7YRUZn36jbXSTwP4CBEPg94nZCg8Eq3WY0jzJdQCeSk
	B414fX4QkN08C4QgUuP9wtvU9zoSvrghNTSwIE7j3sH5XxvXlU11rA9YV8+UTmGy
	ikImqwY69cCwYFoI1JMOtG9kfKvGPNwEqjLQC1kbLJwiL2K/IDaeaqY2scDRPV5T
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H9k54q5m1Fym; Tue, 14 Oct 2025 21:56:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShZ1gtZzm0ytD;
	Tue, 14 Oct 2025 21:55:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 13/20] blk-zoned: Document disk_zone_wplug_schedule_bio_work() locking
Date: Tue, 14 Oct 2025 14:54:21 -0700
Message-ID: <20251014215428.3686084-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
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
index 1df466167e55..74f0fea56eda 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -789,6 +789,8 @@ static bool blk_zone_wplug_handle_reset_all(struct bi=
o *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Take a reference on the zone write plug and schedule the submission
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
