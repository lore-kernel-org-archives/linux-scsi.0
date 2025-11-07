Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA9E207A22;
	Fri,  7 Nov 2025 23:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559674; cv=none; b=AzDpbQyJ1hMfBffnI0fQbf+SOd5jN40yJIgNO5FkrkmvWcBImrP//ogFGA/2a1AezM3Uh+ATO+KljEFNMK2h1YzQ+h9RQPdFUP13RgWgSR9I6mfagaD5fKc2AqhfzpPGsmQhC8q+ve6WeeGzMw54h3qdGW1nHG+y6ByPbP53Ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559674; c=relaxed/simple;
	bh=Dxjj/z438uyg4NWSJfapQlXohqgwmfklPoWiVwvTWxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlL6YqkdVEGVNpZWxkUW1TTRyeaRYuWViGwkSPBkdM+hqT5KK5RjTmWNm0HkJmJPazucyZQkPuDeQBK2KqyS8UNQJcOUGn3ty2ec+bY0mcIfXleKZ3/HleBIGWAwBLLZvVvgOqx23rOyBXKiECljshjT2ix4ps+LTGUjcBdZ7P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cPa+8NNS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cPa+8NNS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3GBJ3D70zm17wj;
	Fri,  7 Nov 2025 23:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559670; x=1765151671; bh=9uGqP
	SWQ7mmqV7Q8TuG0ntUubVAXeuUj8g8f4B/fubo=; b=cPa+8NNS1b8Luja4Bjbnd
	5DYkFiPI3KGyeidRYH31UNSv5v7if8jUKvYG5PFZ50MunAkkUYtdx9QF16qAfiRC
	iLBdyGYWccXI7qaS2BET90dCP1W5nI0ghfZof3hn7FfxQDF3UtOUWUF/HMP7DDX7
	Np5qq0ovqHGdtFxXjYp2RQDv7M0AKfH28YqwCcnXasWtuOsID98o+4Y/AIrpYLAF
	lbx0k/hoKQHU8xKNcOErSlicmOvRqWMt5D1EA/ls0xW0QhT4/+DUL2NDoJyBFVqO
	bJbfgWagBc410p58V+1coVODdsSdMvSI7NE5tEMNNUxXGXTKAzv8NtSTfVL2kE9c
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id P6nrtJtvpWly; Fri,  7 Nov 2025 23:54:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3GB91jP7zm17wZ;
	Fri,  7 Nov 2025 23:54:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v26 13/17] scsi: core: Retry unaligned zoned writes
Date: Fri,  7 Nov 2025 15:53:06 -0800
Message-ID: <20251107235310.2098676-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
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
index 1c13812a3f03..ff2675013e31 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -713,6 +713,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_c=
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
+		    blk_pipeline_zwr(req->q) &&
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
