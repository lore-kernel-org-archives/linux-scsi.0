Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0927D30CDB2;
	Wed, 27 Aug 2025 21:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330282; cv=none; b=W9iAv17uZVZFSdD3GqMXTkwSrtxTRXuYdzR9kzc+cQothwTh88YHHDlYr8ij0JVT9Z5jfg0aRtgVrSX6NTWTNIpDfOoeYsX5Ku1gG7IYqomqznk3ZExPNo4OSK6TXl4x9rSavmiTN/WoiRUtSbO8veZYmNbRpf56IsFqQCMo5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330282; c=relaxed/simple;
	bh=QSOBNVdte20I8AAil1uTLmJN4Wvz90HpPHxu0p6MkL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arjAZxFAiddzi8zXVMvz0Gd7FWK/VYdS1gqi8Ga0FlwIrBCUt4GZnmls9ee+/4RRth/wXOwXBV0UbKak4nqW1QajGzyq7/1by7HfJ5mU9ze6klBKerUPRkgKQVD/FWxdaY/ZufYbxZIkZfY+0Of8XmA102inzinpGmUSN6Y6I4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W6ga7tSS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W6ga7tSS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByQJ2fXSzm174B;
	Wed, 27 Aug 2025 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330278; x=1758922279; bh=WQt+0
	Z78z2fHmVtFD5bKzypq6Qr0m80qLA5Cdlktrks=; b=W6ga7tSScy/PnzftmJdQA
	xMQ871w54fDnYGD5QrBIeI8cuhXkqZb+emRWdU55QY6WPlWCX2Geg/eAjBpYcmOD
	vOhAHPmsO9o8xty90XEtNf5eUXjbjD4uoIHcsk0Kex2JPnIlmZgA2ExhEakttL2U
	jHC6OBF2lhNxHsIfC7PJclvblFPFG+wPlURvc+k7Koct8KwPB4HlssstYtOn9vUh
	DQ1/tTVh9oS713xhJUloZIimQZ1l4igZk02q8aosLEjHYxK6L2RF0NdF9C5AuiuH
	rI6emlKK7M45xSkt3HJSmNybSnl2F2Nd3nqdAhEooE5pzR/8uPdheHT/6Sy995qr
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ge0kvqxm3z2g; Wed, 27 Aug 2025 21:31:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByQ95K03zm0yMS;
	Wed, 27 Aug 2025 21:31:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v24 15/18] scsi: sd: Increase retry count for zoned writes
Date: Wed, 27 Aug 2025 14:29:34 -0700
Message-ID: <20250827212937.2759348-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
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
