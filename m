Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86E2EA16F;
	Mon, 30 Jun 2025 22:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322668; cv=none; b=AxVTIOHLnOU1c6vsrXEuCBTy+5VbiPkWzrWXMkI7+1V+YzwcuPJEWhGOWFjhcl9pAiclIF2JYCCkhcJM9SdTj2zeb6IbQ2NMmmsnpFrIe//CeBXjNWnanDCyO8iRoXH3f3UQ6paodukU9UlOxrWjhjsw4JNoJGMj3wj9HIK21aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322668; c=relaxed/simple;
	bh=LKUaowwYhHBpzQi1RUUJy9+WT5zg+V+uMgLKI07/MxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB8EdmowYsFIqtb/tQRKTpfJoeaKE+wTPVuA5tu/SCpqW3C/q7rK10p0dxkSW27Pzd4N6H6dejRsAYwa8LW5SbqjJo4NMgGhPdEjRrKjYiryvMChpCXoinr/bG0wFGrqEuHfZg1jdNooz/kO8lKCpsMe6bUvle7qDPjI55HmGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bO8Y6pek; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bO8Y6pek"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLV16164zm0c2s;
	Mon, 30 Jun 2025 22:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322664; x=1753914665; bh=KdTf3
	foaDPMGs6mR8nwOgd6X/ektlFQtx8qiasBIUPU=; b=bO8Y6pekT6QXMoqfKxlUC
	5x1k9KK6dEL1qogIgsrWIgK9HZ7DgsPNMkLSdrpfV4l3zvR+CA3rN0C7wdzaGq3i
	akibti5jUOis00zOwyOXAIVltH5A6FItu1ZJxxa9lByIp+yNtfQayh6n6oBoHffP
	v5n5XMeNu86h/47Q9UIWcMyWCsMSD/BGBhzSZodv32UcmQ9aMfpwApsDArGY0VHR
	MaupTr/5jwXdEQzyLfztOofxRIfDdO/YKO8Fu4OvuGEhN2mCUdh1bXf6YZUx1lBB
	VnKWVaHFTxZm8lb3rvK4XT7p9cPFXGHElvNqrsFe3CmBCUo/VuqEvmqzFEMvluEa
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o9gh31kmvhTF; Mon, 30 Jun 2025 22:31:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTv1Nw1zm0bgJ;
	Mon, 30 Jun 2025 22:30:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v19 07/11] scsi: core: Retry unaligned zoned writes
Date: Mon, 30 Jun 2025 15:29:59 -0700
Message-ID: <20250630223003.2642594-8-bvanassche@acm.org>
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
index 746ff6a1f309..d742fa67fe0e 100644
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
