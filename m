Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4865022068D;
	Mon, 16 Jun 2025 22:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113283; cv=none; b=BfWlxrP6eKnwtUyGLURgCL3E6lqrNRpAPLo8RCYnh65fSq55+XgZKKJE4zgVXAesZ0V3Ii8zb9tGyhZmKRG02FwEa32V7tlOKOsvAnzPv2SP3Cq73KmMOloYKgWdATjamVVSi1qmDvYACfFLUhAIza8oPR6cfwaxtUO50QlJPIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113283; c=relaxed/simple;
	bh=Kd1dd5huFr95E+OWVN11lbDqGnaXpx93SFNG/EYGvx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCayupo40c8obBvbxEI+UVFKicTptUCvU9iZ+EYvBjSufZZWgYVVb78JzS+YhnJB6bTtrs4uYscT0E1vVczKKQPr3DpT7GqmQ3U7DyPRbm1CQSbVE/9bxyTqqOx4sR9JD4azM+0HNiltBPc1mAga2G5eIg8es7WcX1Fnmq2UN5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nzWi9kRD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nzWi9kRD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlDd4YR8zlgqxt;
	Mon, 16 Jun 2025 22:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113279; x=1752705280; bh=Y7Jmq
	ZnByKSzKcv3V7vqe/DZ+bbEmFGlv+KJiG3EZ2U=; b=nzWi9kRDOR3SUlZWWioW4
	2mqjzmh7l/rdr31EEyJJpX6HHtNWrQagoaPa6o6DdAfXvpqm4oMx3kgaW2o6mSF0
	Hqdf15HlhlbR5wX40Je5SsJFHQP6Rde1w/KDpvZoTAbPW2dG8f9k6jVmoifqlhSp
	O4byyviE0Ptd1m0iJsf6hFWMYmZsUvjrAGIOKF6xBS8oONY6xZRBDbQSaLmO0iSB
	yRva10huaYOHFHMIHVF3adhWhkUbiTYUub3wFw9rG16l/zvR9awmWpKD11gnkn3v
	k6iShopJtzNv1aseomrO1exeS/+qNnTeaxg+vDhAqWd0RIquY0GJS0orlfCQ/cGa
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hnDg4Zfv_mtR; Mon, 16 Jun 2025 22:34:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlDV2cFHzlgqVx;
	Mon, 16 Jun 2025 22:34:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v18 08/12] scsi: core: Retry unaligned zoned writes
Date: Mon, 16 Jun 2025 15:33:08 -0700
Message-ID: <20250616223312.1607638-9-bvanassche@acm.org>
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

If zoned writes (REQ_OP_WRITE) for a sequential write required zone have
a starting LBA that differs from the write pointer, e.g. because a prior
write triggered a unit attention condition, then the storage device will
respond with an UNALIGNED WRITE COMMAND error. Retry commands that failed
with an unaligned write error.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 376b8897ab90..32f0f7d520df 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -712,6 +712,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_c=
mnd *scmd)
 		fallthrough;
=20
 	case ILLEGAL_REQUEST:
+		/*
+		 * Unaligned write command. This may indicate that zoned writes
+		 * have been received by the device in the wrong order. If write
+		 * pipelining is enabled, retry.
+		 */
+		if (sshdr.asc =3D=3D 0x21 && sshdr.ascq =3D=3D 0x04 &&
+		    req->q->limits.driver_preserves_write_order &&
+		    blk_rq_is_seq_zoned_write(req) &&
+		    scsi_cmd_retry_allowed(scmd)) {
+			SCSI_LOG_ERROR_RECOVERY(1,
+				sdev_printk(KERN_WARNING, scmd->device,
+				"Retrying unaligned write at LBA %#llx.\n",
+				scsi_get_lba(scmd)));
+			return NEEDS_RETRY;
+		}
+
 		if (sshdr.asc =3D=3D 0x20 || /* Invalid command operation code */
 		    sshdr.asc =3D=3D 0x21 || /* Logical block address out of range */
 		    sshdr.asc =3D=3D 0x22 || /* Invalid function */
