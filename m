Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDEE214A6A;
	Mon, 16 Jun 2025 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113290; cv=none; b=WxSw0Th/e4TJGxG/CYMs5zwgUXwhB6e0C85Zc1kXeRrPMKHxNvrbcEa8jbzUkXv9KtY63MnL2/WlIqAnBLM8pN2c+Q666NOGJ4TQFUH0yQ6Ki5vmZ0A6inpNN63W5ZKGPJrnV9mRwVHsu2mM92Sm8wR9Lx2SuyXLM3zodcVkZVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113290; c=relaxed/simple;
	bh=dFAcw8eDQw0VtPzqgrkRQZ94gUMfcy23v+aQMCyOusw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9fJgcQhbVJU3Lp4pjbhzs5mAkmJlZXuv3DYCtiHKVNiUCoIZpr03pLLlTyUrt5xHIThvHBSQ0BHnJAaVeW7xn0QXXbiPamkP7FR8UU4dD4bCFSXGN+6vaZHr5lKt2MA/d88XO+mEsxx1lKt03kbADIViRPuvW8PAEz4WCwOj3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vvSgtFRv; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vvSgtFRv"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlDl6Z6gzlgqVy;
	Mon, 16 Jun 2025 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113286; x=1752705287; bh=Ga5J3
	j5MWVZpsDWOGPQ1rbLEtAl56z4ONXUShhBY274=; b=vvSgtFRvoWl/pN1mEQg9H
	LZfp5tTQqqk6R21KCz9gbTAfg9GE0MJTtp2g8GM7BW93E3XbTvGAPbZWraQ8vhhA
	cYtTeeYfZ70bj76rOIg23gS60qHUTyYAJqT+EcFv1cPzBKLiF835PLYmPOK5vQyp
	ugrgBjZnRZ9WDC1LZJzfNTNaw/YPu3s0fzK4PD0k0o97LqT6QVZDVFv+6sH2otWe
	m0sLljJfMNVCHtoOVZrGq292vOe3Wa8epd1PMguI9jGb5r/LOsSsYeHghph3sx+f
	s7MlJsEtvGmKgtOtTAyUZsO7U5/J/zBrd/gfHHUx6H9z7mH9PypUfr7Dep/VogKC
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OmOXXrzsEVKc; Mon, 16 Jun 2025 22:34:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlDc5fmJzlgqVt;
	Mon, 16 Jun 2025 22:34:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v18 09/12] scsi: sd: Increase retry count for zoned writes
Date: Mon, 16 Jun 2025 15:33:09 -0700
Message-ID: <20250616223312.1607638-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
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
