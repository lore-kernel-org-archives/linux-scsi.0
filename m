Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C729D30CD85;
	Wed, 27 Aug 2025 21:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330277; cv=none; b=s+sh77KzQpaQV2DHTIjfnS4mjwPSiAd39W2V+5HI+ZDrRy/Jctpoa0D2B9qdzqsFtd/eqWoloMc5oyvKLGkJqU9Q+tQ/TSMsMP9efk05b4t96lyxikFIfslEQ3jNjbAP6hBlQDawAgS6OR+U3PHXFn1iqngADOUhvAlsjX2dwDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330277; c=relaxed/simple;
	bh=vx+URFFoX2y+Fr7FHZNrk6xy2Np7LEh6hQy/PohAEOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj4EyRekMqPc0/ABdJ4btdJ9TeYA5hMoKW4m+UFj03jQgeFOhUizWKpQRptvfVcUONP0dNXrz/jTOkmADk9nt4hxaOL6xE4fZk7T7wN20EGVCw9mHlstetfs+SG+ZE+t8lEHfxJhCfiv84JtkHW+yn23KmYTXhrPTogiivON8HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TM1EAIE8; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TM1EAIE8"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByQB6RxNzm174H;
	Wed, 27 Aug 2025 21:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330272; x=1758922273; bh=U7Wxt
	Cpksc6+5gKUgMalhJM+/uGQ9rfYULDAFngKYjo=; b=TM1EAIE8LOje2H07juzm4
	tgKah2PM9dFE2Py2qSP8tm/eDyhwJ+rgL/5VSJ31086oSIbL1PVssiRw4OVN9W0q
	vhqWH8ZNy3+GjJbnxp6YAUaHwdlba5n0Gc7Q6xgCJ6fIsN431I4JSS+r+ENhvIKp
	TdzXv0LZ5VREo05nmItiB+2bZKdIRfyMYv3yKJYEE2InjSopkmNc5QoW53QVAdNc
	ZtSxgZBr78dN5txpUQMsuEu3zLJTzFyMZhUlV478LNtoxGDHWLYcCMllU6cVwu8s
	KacH2rg/wjKIdUXnmwXOhE0m582ppXneCEsgMc8W1HTxrsqjc2ci3vUQRlqWvD7p
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 96en2gObU0OI; Wed, 27 Aug 2025 21:31:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByQ36n9Zzm174D;
	Wed, 27 Aug 2025 21:31:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v24 14/18] scsi: core: Retry unaligned zoned writes
Date: Wed, 27 Aug 2025 14:29:33 -0700
Message-ID: <20250827212937.2759348-15-bvanassche@acm.org>
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
