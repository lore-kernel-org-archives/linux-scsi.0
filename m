Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A797711F;
	Tue, 19 Nov 2024 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976139; cv=none; b=s72rQSsDQqtIV7iavE+cDmLSozCbw41NDMpANvnkFD/l5ihwmjAqMAbwGE85GI70yrV1Aa22k2wCr3zVo1DZCl3/lNHp+JzpYGBUNxejK5QXLnr9+9+nP7r/WTFXq7Uop5H6sOq1hU72yeBU7uafljtx5yLS3vHN2NIjYcvp+Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976139; c=relaxed/simple;
	bh=ZL+N+xB9nnJlFQeOnW84AorIn6wz09Q7mmzClFv5/Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfiag1NyCwPhJGUv8WA1EXQEyqO5EZDY0g35TILe80pG4oa6e7j2MMOmN587oIKt71XOP07GJpentoSvjl9rwzfznR0w1cRTjXj1PVuRyDxl3ylkizWjpMREhvqM1UpLCf6icJZIBL2yYs1bpS892NEe+OmdgmtttnvRVAhk5T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nRPmXmIg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nRPmXmIg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljP2zvTzlgMVY;
	Tue, 19 Nov 2024 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976134; x=1734568135; bh=Nk0D2
	kBxuDtV2SY+RnXHM5qpiqmKRg2f69nFTovfeK4=; b=nRPmXmIgcdDQlyDSMXmMO
	/d++gFKUFFzLKDE0nfs8ycXhrS3f/mhwumTitlyEg369dM8CuNctWXEFugIDJXLx
	16dVzubsoHnUsbVYoihjhSb2rGxU5/3+5kIkH8nq81J1bJo2xVlnqHNmVmhqhOJG
	ffEts8IxZiWSjP64ybIpYlUZ1RhlA3BEQNHlUWEhoOzFV/D0JpiGxJBNd9QlMRXJ
	muTjVIp9+InHaOBnff4LVJSoQqBFdNPxTSCIxdMrWu0kKKqer4v18hfHHIJarivl
	kpUlAJ8uo0+CWIi1GpmWQHGSi41BofvlPv/hz9agupFqpjgMlOmcPR1k4KnZoytt
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5yC0ktTUZ6Cx; Tue, 19 Nov 2024 00:28:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljK0dT0zlgMVV;
	Tue, 19 Nov 2024 00:28:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 15/26] blk-zoned: Document the locking order
Date: Mon, 18 Nov 2024 16:28:04 -0800
Message-ID: <20241119002815.600608-16-bvanassche@acm.org>
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
 block/blk-zoned.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ded38fa9ae3d..1d0f8fea7516 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -51,7 +51,8 @@ static const char *const zone_cond_name[] =3D {
  *       reference is dropped whenever the zone of the zone write plug i=
s reset,
  *       finished and when the zone becomes full (last write BIO to the =
zone
  *       completes).
- * @lock: Spinlock to atomically manipulate the plug.
+ * @lock: Spinlock to atomically manipulate the plug. Outer lock relativ=
e to
+ *	disk->zone_wplugs_lock.
  * @flags: Flags indicating the plug state.
  * @zone_no: The number of the zone the plug is managing.
  * @wp_offset: The zone write pointer location relative to the start of =
the zone
