Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510031C5F13;
	Tue,  8 Jul 2025 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012506; cv=none; b=Xo9RVdn+8PK/sgRMUbzXLuofWIGyK9n6ReFULOe7mSotTq2oISRUo+UCcmv658/0f2mfjp2NCC4gq7TR7t3eVI1DCtNM+lKKED5Yc1gaQ9EELJJxn54SuLJy5rxUshS8wuyk66Z4yBfjZSOzaeFViJFwyoOq7C7pC045B/AUXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012506; c=relaxed/simple;
	bh=LKUaowwYhHBpzQi1RUUJy9+WT5zg+V+uMgLKI07/MxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3vSQfVge2o4N+qPcmb8G/3SVaQcoTVGs5BcWo0gYFjoJr7/ktSOwuBtCwzIjUn5/2dk2f4CsbF64JqWEIiMLEubietYM1nPcTbJK+N0uCTWYeSsVpGCzXkoMvWQoddvCLXKTAxkqBzcbF7tMbWy1TIQViklPbMevOxpliqUVl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c/TAqdLv; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c/TAqdLv"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFc83tWKzlssy6;
	Tue,  8 Jul 2025 22:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012502; x=1754604503; bh=KdTf3
	foaDPMGs6mR8nwOgd6X/ektlFQtx8qiasBIUPU=; b=c/TAqdLvIRLXdJwWwsV+i
	Sbhi1nqRhmUP7MSikyM39q/WG4XJv/cLo4hJEQ5h0Mjg6r4zuBEbxh8ZgBw/ij4r
	GxSeDFe19RGDb0tScKTL92mgXCZROgA4r2fTJsFKbouYyRoC2YG8X4rNIMVtpRoj
	H44DIl221r1bbHV/lh1Vk3qosdmrlg5j2Bn9iM8i0gO1ZTv16NOb+F8BWtqXwH5x
	CXQC3qi9+lIa5t2I04oXpAC9Jg8InhxvXpx56zsFIIPdpOuoISsdQ4X0Z39NU11h
	ph1K2timtNgOJO5Juf95HUoXiW1wwDUE6CajWQeI+umyQ+QXKxzMj3RPQYEBh1ef
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0yB5gXPepWfV; Tue,  8 Jul 2025 22:08:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFc161BBzlgqVq;
	Tue,  8 Jul 2025 22:08:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v20 09/13] scsi: core: Retry unaligned zoned writes
Date: Tue,  8 Jul 2025 15:07:06 -0700
Message-ID: <20250708220710.3897958-10-bvanassche@acm.org>
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
