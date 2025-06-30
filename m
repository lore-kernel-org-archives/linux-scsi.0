Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5962EA149;
	Mon, 30 Jun 2025 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322674; cv=none; b=IrAujihZLrjZnmHzF4aNXxcl56t+i+/oFy1+WAPNn6w3ryFGsZuCWQeizejrqa1//HUtUnUqoaka/9deU5/FkRgpjlqh9NX+QQ5bkhm2/qwAucOLPTYvd9wCuwp1DqV0yMhSLpbFLi/fXE1gU2HbCdkCMfdRNLxDbI3b+pB38q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322674; c=relaxed/simple;
	bh=dFAcw8eDQw0VtPzqgrkRQZ94gUMfcy23v+aQMCyOusw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9s59qQVF8pipUaVB413uRhTLcXYRFBnpYQQlDVjoW8w4dw5tkU3ST1riI0TcvyS4Zll1SO5fhuP+ZcbN7p3PAXZbT3PacJPyl+v57RrQev8zYRiANpAiDiuzUSl6PyYiuhlw7Xm5X++112SoTASOfZ79QdwvTQSeucXhOuou/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vFg/LU9Q; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vFg/LU9Q"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLV74XbJzm0bfn;
	Mon, 30 Jun 2025 22:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322669; x=1753914670; bh=Ga5J3
	j5MWVZpsDWOGPQ1rbLEtAl56z4ONXUShhBY274=; b=vFg/LU9Q7rBl+bHS0Df/a
	SPTT2g065ffkUWl2oufaIlU46fJho/ERqWJE+0YbLUS++5acg4r7nqclu4EtzVGi
	stKaV6pU+N4q9NptOdOzVxnB9F9+KVTN32zZzplcgkB94oP2Abm3snjCpXBoC7lP
	kYFRkSe/fhhU88F1TbQiQ86Kzriidyc952p4uWwYBV03xQ3o8tFVj5u329IUgIMS
	S73o3XzqNeYHrXz0z613NxrGYzzZxFO3n2sWUi/5SORtYtrg4uc+ilGVTUskcTiz
	kg9kKo8QnXweSFKR+jCZLBYrKHDjj9oC8JepsebXYJZWc74jZylMuukF75L2ioGC
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yGnSsKVLRXSq; Mon, 30 Jun 2025 22:31:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLV06T0Nzm1HcJ;
	Mon, 30 Jun 2025 22:31:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v19 08/11] scsi: sd: Increase retry count for zoned writes
Date: Mon, 30 Jun 2025 15:30:00 -0700
Message-ID: <20250630223003.2642594-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250630223003.2642594-1-bvanassche@acm.org>
References: <20250630223003.2642594-1-bvanassche@acm.org>
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
index 3f6e87705b62..75ff6af37ecc 100644
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
