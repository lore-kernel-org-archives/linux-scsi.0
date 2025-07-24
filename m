Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A023ABB2;
	Thu, 24 Jul 2025 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394329; cv=none; b=R8sX4RWVKL0lTCVnTWc4/19J0blUP0L41UzLtJo63fi76DoxApkPm5DSDdMBEf7zs6jJaEJ6ZR4SzLhy/26bB5FPEn91IVxd3zKuExypXemmDjAufn5cXRUeCGAbec5vR5ygT/axoH/NFcs0Uui5tzxaGfBkK47NTJbbNrggtOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394329; c=relaxed/simple;
	bh=QqBKQZsgBiRJV7GutIS6D4B0EWgCxyDfd1Li1X8C4XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBNcmceT1QO8TmQLbA3cPDpGBJl0/V/g4TOla5jmG2H5+NR55hLtet+4oDdv9yLz/JDFdVfUFTEGGhQmQj3pQAtBQDOdrr38scxRYIAFvf0G+dI2IAk2XhTyH9ISL5XTWK1tSQ+cFaZqssBuTEPkfz+Zd+x6iSW9VRB7urnbGzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YTd4NZJg; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YTd4NZJg"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4dg2Gf5zlgqVB;
	Thu, 24 Jul 2025 21:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394325; x=1755986326; bh=+16M+
	DNpLAVRapJsD0qjDAtb1RMT7I3CD86BqJS2UyM=; b=YTd4NZJgQExCpKUUq6Zpf
	yRhKEVqTG27YAZL2HsMzGbEI5fzqyFZrGDVR2CJ8+rHqlwSJ5uEVyzPEsik65r5U
	xSkE34utP3eTafN7LHHclpTKJh9KLK5LDTPU1owfJkSf0cmsYXMkt7NWKakoBFoW
	WkD6dvR+is+fgtc9K331Boj/rLGE9/wFZpfBdemPXC20Vbj6WThprH+h5qb7jDVu
	wPxmcxQHM2jnCPZQimBMnNT/uuq8g636ALl2y6tHgE0z5cGqIM5jS00+9nDUv0Eu
	gOKXe78Ab9lUUjhzCKsuM50Aem3XisJLR1dmRbZY7lGCHThzwJLW3O1X1jXewhik
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d6r_rcZz6J_H; Thu, 24 Jul 2025 21:58:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4dW39cxzlgqV4;
	Thu, 24 Jul 2025 21:58:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v22 11/14] scsi: sd: Increase retry count for zoned writes
Date: Thu, 24 Jul 2025 14:57:00 -0700
Message-ID: <20250724215703.2910510-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

If the write order is preserved, increase the number of retries for
write commands sent to a sequential zone to the maximum number of
outstanding commands because in the worst case the number of times
reordered zoned writes have to be retried is (number of outstanding
writes per sequential zone) - 1.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eeaa6af294b8..587d91a9e10c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1404,6 +1404,13 @@ static blk_status_t sd_setup_read_write_cmnd(struc=
t scsi_cmnd *cmd)
 	cmd->transfersize =3D sdp->sector_size;
 	cmd->underflow =3D nr_blocks << 9;
 	cmd->allowed =3D sdkp->max_retries;
+	/*
+	 * Increase the number of allowed retries for zoned writes if the drive=
r
+	 * preserves the command order.
+	 */
+	if (rq->q->limits.features & BLK_FEAT_ORDERED_HWQ &&
+	    blk_rq_is_seq_zoned_write(rq))
+		cmd->allowed +=3D rq->q->nr_requests;
 	cmd->sdb.length =3D nr_blocks * sdp->sector_size;
=20
 	SCSI_LOG_HLQUEUE(1,
