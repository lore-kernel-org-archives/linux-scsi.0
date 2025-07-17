Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F13EEBB;
	Thu, 17 Jul 2025 20:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785957; cv=none; b=lhfpD5CqX60eywv14Y8YYMNq3iFqJexDli7B0WcIA0mm7hXa8ppUb5QDOU05IIAyEoa2MFREx/5E8C19px159OOioIOQk6OJJBEIq6l2blAbeicSeKCk+5PZ7yIUHQ8TnDHhyYd/xhbHgeOpSNnrmBOvaQVhuXcSFyJi7H8qcB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785957; c=relaxed/simple;
	bh=QqBKQZsgBiRJV7GutIS6D4B0EWgCxyDfd1Li1X8C4XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndhL7qc/idkNCmcfU6ropiwIr0z3QNCGLbU0t1OIesxIfknyrT/I2gBSMEKxMN+Ws0l6lGgvl2Pmew1ofE4ry543t0we0yHQu+9U1JuvzmKt5lmbGEi67Ti5S179arW3uYPvq2YVcJALD9LUCJkMrIb6F2Z90krW5/QyO0oeFXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=grrKDK8V; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="grrKDK8V"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjlfB6kxwzm0yTw;
	Thu, 17 Jul 2025 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785953; x=1755377954; bh=+16M+
	DNpLAVRapJsD0qjDAtb1RMT7I3CD86BqJS2UyM=; b=grrKDK8V2XyP4FJ8RauYD
	I8ru4P8be8O+dfgRFrgxSAeTiSm+4oMcdg7lNQcmJhEOGkEBjuXFSQ39vXrCgc9m
	OH3NMuGrcHWikP4nWvDkQ+4+5DjAfn2YAwAUv7qo6Zm7GGoZRV+JO3Uep2z0mV49
	V3KQvIZnpHwSXSiYl5F4oJ6HUC0KixmOnFf6YQH7PxAqHan3d8mQCXitoI0dcqH8
	nZI4M5o1wL2P17ECX+oqhpJ0CgmdHT5nuUjcEIp75/4FAUHfxa6J7msR0mQO1JWo
	asH89ga6nIosKt2W6AqCmmalLHoHdgTASRaljN9ec4ETFgH1GQPRVInYu10WaC5N
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aUD3EJwhM7SH; Thu, 17 Jul 2025 20:59:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjlf417SCzm1742;
	Thu, 17 Jul 2025 20:59:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v21 09/12] scsi: sd: Increase retry count for zoned writes
Date: Thu, 17 Jul 2025 13:58:05 -0700
Message-ID: <20250717205808.3292926-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250717205808.3292926-1-bvanassche@acm.org>
References: <20250717205808.3292926-1-bvanassche@acm.org>
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
