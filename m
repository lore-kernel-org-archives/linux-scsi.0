Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32DC2DA776;
	Tue, 14 Oct 2025 21:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478990; cv=none; b=X4hBkYAxC6CGW5LVqEdn1SWIvJNV+0zA46k9EXTcs+WTI4+pb9hmipWe9zELAVnlcr2MlPYqYG9sCxHOBo2IaP3iQd5umJs7l2sGqEv/7pQI/0qs/nzkgj4PDFSTz6KbeE4Zo+/MUWAODCi7PwAh+uoHqXfColbwtnGUELnrSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478990; c=relaxed/simple;
	bh=j911julNyNJ4HBrVumXet+jNZqdsIZ5yt+gKluHUqz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzUPLoHWTbZ56Sd0XT/xqi/bnHNDOJaEzuSfMjRjR7NV/Nz8wDrlN7gyqrNhvgWo3D0BJx3XZW+zUwNoBU2jXm7xv/2vHhw6bVFcLwJwekx4fix9rbK5GMnnBspvzFvWrRxStNq/EpGFNEYxoddMO4Mfv7ciwe7hkNjUl1/pLcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=l7JOxT7i; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="l7JOxT7i"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSj76Fj5zm0yV3;
	Tue, 14 Oct 2025 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478986; x=1763070987; bh=tJAXp
	PY/HtpCGG8Lr86BmNDq7ubFRk1NHm1quJVKWqA=; b=l7JOxT7ixlbK4/nr0CBx1
	bSrXDm+ttBG4p3ITJihIJlybCOVyL7UOvLug5jOgyvxkfB4U2YwxF0OIkmBaxMrU
	gFxg3nZXCgiyQj3lzsO4RRxnqYyDKvUUt+eEdEmuRE4E1DIN4ZKRNNA4OSLUpwzV
	M6hJZzXcw7ChAY2M/K69xEyb5LPWuoaee/3Nehb3gZK/U15kDuZf6v+x0mDGiQ5v
	nKEufEGzcB/uOQnN7XzxXclyJ6r8pwpOSnT8Tm1Vx4lmfRZ9fA0K+R2USwzZZx71
	jTH/F4cEOmKjSBJlE7MhsLr3Np2cI1nTeqwnXvPl2WYR2+8FeE25y2dQ0a/xs/Qt
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fTezKtH4uh9n; Tue, 14 Oct 2025 21:56:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSj02CmLzm0yVF;
	Tue, 14 Oct 2025 21:56:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v25 17/20] scsi: sd: Increase retry count for zoned writes
Date: Tue, 14 Oct 2025 14:54:25 -0700
Message-ID: <20251014215428.3686084-18-bvanassche@acm.org>
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
 drivers/scsi/sd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed1..f94ce38131e5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1409,6 +1409,12 @@ static blk_status_t sd_setup_read_write_cmnd(struc=
t scsi_cmnd *cmd)
 	cmd->transfersize =3D sdp->sector_size;
 	cmd->underflow =3D nr_blocks << 9;
 	cmd->allowed =3D sdkp->max_retries;
+	/*
+	 * Increase the number of allowed retries for zoned writes if zoned
+	 * write pipelining is enabled.
+	 */
+	if (blk_pipeline_zwr(rq->q) && blk_rq_is_seq_zoned_write(rq))
+		cmd->allowed +=3D rq->q->nr_requests;
 	cmd->sdb.length =3D nr_blocks * sdp->sector_size;
=20
 	SCSI_LOG_HLQUEUE(1,
