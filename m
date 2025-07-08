Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C21A8F84;
	Tue,  8 Jul 2025 22:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012512; cv=none; b=r6DR2Z5o3+PIbSUYDzSMQqqAa+pLnM/cRo4H2fZErMFGs4rOb2ys91F/60fzRyYXCnZ8hJug+Ae5vP4YpaL/pfnfaiwCC4SQZ2PivC9GFu/NSKp7ouTkLF1dsAX32hqBDAqVd6LegdyzsBh8VnlR5joT/moFPTwawAgXNM7ukGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012512; c=relaxed/simple;
	bh=5VBpXX+d914ntJt4xZcvyFp5NlDwlQNzDHZEW4Gkdjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gynFWIljQhbyln3J67HEa0MoWEsqOSlP89ez10B7+VHk4/Pc7T899xmtiekdPTgKHLTf7WDzMXDgvUPUwigGeN1whQPBt6xfFbE7CcOO9FqSc/u+0N6KTF3ZFzDD9NN3VyAbI4a7m/m3HO9xf1MEKln//fMsjHwJPPppM7sAl1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EYc2Llut; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EYc2Llut"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFcG14gJzltH6V;
	Tue,  8 Jul 2025 22:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012508; x=1754604509; bh=6SX0Y
	JPvsE1qcoNYIPEVrmJsT86nfDyOJqiNycGUtK0=; b=EYc2LlutNZzb3pCb0xtMM
	RlNgRyRrcIvRTUlEM2uihNSB48d1X8SI+Vd1wqG2B0GwBu3tmGA23bnRUi3a6pP2
	niLJhQi9ckFSnJJzB8pMXodLsqpp2tawbLiqUNFQ9NrCcw5e3iadoHDFHD137kQu
	NT+JUTfuvWVB+piJMnlj2axUjqc6MgnptixGyUB3ca6gSlHsnsqgXP+KjLQiNngU
	7g2vfiznN25dHNY25NPhHCQvVh79GWT13Py539FWswG49xoBSXlVpnaG5IUx/P7E
	2ELg9YS0CG8kQTcu6uN3IG830QSycJOPz6jm5lNPiLBL2WINoBug9nPvNSdgzAK0
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5osthbmQQKYT; Tue,  8 Jul 2025 22:08:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFc746xGzlgqVk;
	Tue,  8 Jul 2025 22:08:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v20 10/13] scsi: sd: Increase retry count for zoned writes
Date: Tue,  8 Jul 2025 15:07:07 -0700
Message-ID: <20250708220710.3897958-11-bvanassche@acm.org>
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
index eeaa6af294b8..9a499ca9dc3c 100644
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
+	if (rq->q->limits.driver_preserves_write_order &&
+	    blk_rq_is_seq_zoned_write(rq))
+		cmd->allowed +=3D rq->q->nr_requests;
 	cmd->sdb.length =3D nr_blocks * sdp->sector_size;
=20
 	SCSI_LOG_HLQUEUE(1,
