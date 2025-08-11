Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035052D97AB;
	Mon, 11 Aug 2025 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943038; cv=none; b=FwwvYLOQgbkBq79kz56mMRe9i7CksXlqTNqGHftj9ZM8WAdIzNdIjFQ9nRHO1Ps5E8laCf/EsN3OucK1Ju3GUljJUNvXdxH7lsS5ywODfksTsiojop6PArlYerDpRIhuer5PsUiy6vZNTgheFpbRHhRBhZ2Vt2jOMgPigaMa5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943038; c=relaxed/simple;
	bh=vx+URFFoX2y+Fr7FHZNrk6xy2Np7LEh6hQy/PohAEOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVnQ5qlpgCjrgcRDjQyM/hWZZnjbKvHfdBYzPJVp15zRFZ6ZZ+GPCEojvLvkL02C/m8snd3Tkbi0C0V94UCHtQYTm0te/bG8kVVh2WTnV7S2NOQ2rpujKFgK1/s+iVdS/PhX5bGUdUZkhAOcWATOao9qDy/8HLcRrMqYNPjyNm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Wx2TzAxq; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Wx2TzAxq"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15NX2MCczm0yVF;
	Mon, 11 Aug 2025 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943034; x=1757535035; bh=U7Wxt
	Cpksc6+5gKUgMalhJM+/uGQ9rfYULDAFngKYjo=; b=Wx2TzAxqfUzL7I5gqmnta
	jsTwx+j4xOr3omsOE6hP+BqjEVlFMNPv/Ui5uyxRkp7jfvDe9cjfNY8V09z5Wqp0
	cNSyUs3G7dT3Xy/qadPlLeZ8VXD+gsqH45WfaQvM6PeNHn7rM3tPBehgi+3vbzW5
	4iLNJYrkvhEhARz5E3t2rExmTUdwuDGZRs+iPTqKwtVyE+nVoRWvW7LMQMTT/Cig
	8N9PFrtfhq3HP4QEZLfPqGxTN0SrFI+ZNnE4ay7+qMeUy7K/lVq8iattYFfBehy4
	iJLUrzSIBwnHpZPPWric7iDsztkFwzUfnQT/HJGWFivHVnBlRTfvE/6FDjevqkdQ
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xtcCcY8Rfpue; Mon, 11 Aug 2025 20:10:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15NP34xvzm0yVL;
	Mon, 11 Aug 2025 20:10:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v23 12/16] scsi: core: Retry unaligned zoned writes
Date: Mon, 11 Aug 2025 13:08:47 -0700
Message-ID: <20250811200851.626402-13-bvanassche@acm.org>
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
index 746ff6a1f309..812b18e9b9de 100644
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
