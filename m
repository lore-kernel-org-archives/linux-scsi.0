Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22F136337;
	Tue, 19 Nov 2024 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976152; cv=none; b=fCP9bfid1zBOX8kYIpHX89y6mR/QnmM3u2aaDOROkcBWPsqM+/k5eH1UtHd22zk+jDcrRMn9jo6vUyZ/13Wk3oa/iU8yncXvjRvO9ikdlfYQmqYurFX71Yq14HBnCRAj0VgVDISRyFfyv1eOp9HqdSp6Bm202PjwZ55UQ4wr7wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976152; c=relaxed/simple;
	bh=QkqlwuuNYl4VVEnHfU3DWlFW7oW9V0AIugQBhAHScm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNiuwuRAoYbfCPFm+LGzsuwEaLqVGvvo5OrOondKVDh/NpEdrsWBzLCbUsBdXbe3HS02HLtQTr84zmbHHD8MwMkUzci2I2T6o9/W7pixsR9PuoR0HRStRACmIJ1lolpChuiFTPcQFm0Mwiv724upeNOIZGbPeT7yFqQiqC2bIwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TxF25nA+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TxF25nA+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsljf36xwzlgMVj;
	Tue, 19 Nov 2024 00:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976146; x=1734568147; bh=Q5vhR
	0hiuCOQ1QAEux5brr8vJyia4iEYYO5oL+JQtLk=; b=TxF25nA+F7GnthN1miS21
	3ZKAeWSrW6sFwc42w8cz50cApIeFOreu2HZ1rMaBN2uQL5TiDpq/Rp2s4oUWmAhA
	blkz536QOkGfZ1Qvt8VMDi5oujNlWuCdrRPui5knQcX91wck9HLmnqwlIP0iH5O3
	61M4o+pmwUUyV5L61D0M9hOxDE8gffq+0/kNT3Xp8wBK/duIk/NMS+hhtRS23s4B
	qhXmBsljKkk1+eMOJS3x5tCAfP2V4u1MrVQ4PXjc8a/RTJw+3Lv59JQZlsPIm2K6
	wkKkxWd8cIeixTC5sudX1tUKhkmk/telxRBPl79VNoqqvc8h19IeyV9LAQyffeb0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kL_jt8GtTVzZ; Tue, 19 Nov 2024 00:29:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljX5jSLzlgMVd;
	Tue, 19 Nov 2024 00:29:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v16 22/26] scsi: sd: Increase retry count for zoned writes
Date: Mon, 18 Nov 2024 16:28:11 -0800
Message-ID: <20241119002815.600608-23-bvanassche@acm.org>
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
index 8947dab132d7..117fce3b1c7b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1408,6 +1408,13 @@ static blk_status_t sd_setup_read_write_cmnd(struc=
t scsi_cmnd *cmd)
 	cmd->transfersize =3D sdp->sector_size;
 	cmd->underflow =3D nr_blocks << 9;
 	cmd->allowed =3D sdkp->max_retries;
+	/*
+	 * Increase the number of allowed retries for zoned writes if the drive=
r
+	 * preserves the command order.
+	 */
+	if (rq->q->limits.driver_preserves_write_order &&
+	    blk_rq_is_seq_zoned_write(rq))
+		cmd->allowed +=3D rq->q->nr_requests;
 	cmd->sdb.length =3D nr_blocks * sdp->sector_size;
=20
 	SCSI_LOG_HLQUEUE(1,
