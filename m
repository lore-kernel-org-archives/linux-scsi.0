Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E782D97A1;
	Mon, 11 Aug 2025 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943045; cv=none; b=k/uGLLfE2oJymOEaeeehiYSgUQ8nwLKCpcpGy4Z7WSY8GTbW7drDNW0fS3rXyFi1S65cS8y/2ek11r+tiTUYZ29FE0XzCNQsP4AlgzCJ6d8hBnlUFiWKl6+6GhmF1p4F7FToQPhrS4xAWxAW8PHFgXU0tlRnVX7DaMOXB6nSwSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943045; c=relaxed/simple;
	bh=QSOBNVdte20I8AAil1uTLmJN4Wvz90HpPHxu0p6MkL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up05i1e9hQVUiVCvfDR+VSfa1jkYxWnZ5nWtW+lZHi/gs4qlTZMDLzKSuauHRS0otmohz1PAoDbG4OeaKU3Y1OW4CCbJprDVNVPDhJAZodd0ok5kRUQVdo5nnqC0WLjWcCLzELy9f5voaT6ptadboeEJRmwHBdz9XqKV+5UQndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=b1qgwfgM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="b1qgwfgM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15Ng15Vczm0ytH;
	Mon, 11 Aug 2025 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943041; x=1757535042; bh=WQt+0
	Z78z2fHmVtFD5bKzypq6Qr0m80qLA5Cdlktrks=; b=b1qgwfgMs2ADbTgk7Rcnz
	vEcwGkFc/b20HG5eGSMO3xisYmdqRydOjYBzDrulZkKoIECHxf+QiRbpM/bf11gh
	8wL5j/rb6r904SAd38NF/d3aS6hdl5QmGprCv2h6ALNIYkjZxEi76B74c0JEwnoX
	HD9drp4UdQ3CIp6YVJIchTs9/szBXTgBZctv56tdJ4/L2MuMax4L6h6uEZwwoqhS
	ZM3aotmICGR9cqAfxPWR8lperQznK+/YCqXGfRT3jHsq5AUMLW870R7lSVv42fDG
	TbuYSWvWz8i8l1Y5f5Klz/N4YG4heG3pysW9hKMfJVvUK1OKUSP7k5aP+kfKqABO
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JRPLeh3jFjsv; Mon, 11 Aug 2025 20:10:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15NW5zzqzm0ySc;
	Mon, 11 Aug 2025 20:10:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v23 13/16] scsi: sd: Increase retry count for zoned writes
Date: Mon, 11 Aug 2025 13:08:48 -0700
Message-ID: <20250811200851.626402-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
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
index 5b8668accf8e..3ae6afc02ee5 100644
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
