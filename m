Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511CA1FAC34;
	Mon, 11 Aug 2025 20:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943059; cv=none; b=li6SWQQfvxyozC7i0sO249A7MjY7d2oWR6xV6+Lhb6EwvS2vVWp/kaDj0RnXmxibPfYUpzWHgpvFIOmprMEKRDWbm6euHAvKeO/ofI90z0Sz2VhgQkWXwyFknhpQybwPR2/gvlSYYyS7t6jJJbyvjj9OXXMtZ6aJGivmQPM71NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943059; c=relaxed/simple;
	bh=FtMkBOaZpvtbTvnIg1Try6JpT6+hqXGv6mr4zfVHsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV0WFdRb9TN8zMstLm+Q+kvYilDQMTjE04nea8bntYxrC4hvhnDDgZgVTWk4C9JAyTa9sAayPucp+7Bo6UH9yNTllwqdeBlLLZUoSX9qLyGmXdxN9kc3iuHQnZg0tyf7u4lZulDftsgfc6kZWIonsgMh1D96GwwJws/dC+o+1xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e1Z8ZESS; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e1Z8ZESS"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15Nx4lsHzm0ySq;
	Mon, 11 Aug 2025 20:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943055; x=1757535056; bh=5RQus
	nApJu9g3cHLH+jJybZyE2/ODcFaeLeMM4wdAhk=; b=e1Z8ZESS7d6KtqISwl1aX
	tjKg89Zv4/B80bhjPPBVnMDfvF6DZUo4yB9ue5taxAlaQQJu3adkkwKg+jdbZ0Ng
	7yKXRFc3UQwk5b2EsSinIMyHCUccIk3EFfLGrkDyCzTD48Iwlghh22+vpE/cCEJV
	aQW1IZXcMXDb09cIJiHBxN/0hFeffVV2sdvLRMA9lfpeTcOAuOZYvBuOfHnT2ypn
	b13YuLgdp/27oqS1eqnh406Yvfuc4sR4S2AXsHeTTrxnXAl7vNONzkvTof8BTKpn
	YQL+BEMrJGB0qcnLgzWlA10VbbCpPr/MCOqbL7Hor4e4Mnj3KkFUCzpCTTaK4ez2
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uye4npdKgoZ8; Mon, 11 Aug 2025 20:10:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15Nn3cTdzm0ytb;
	Mon, 11 Aug 2025 20:10:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v23 15/16] scsi: scsi_debug: Support injecting unaligned write errors
Date: Mon, 11 Aug 2025 13:08:50 -0700
Message-ID: <20250811200851.626402-16-bvanassche@acm.org>
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

Allow user space software, e.g. a blktests test, to inject unaligned
write errors.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f38cc1ce23a1..f84b9744c79d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -230,6 +230,7 @@ struct tape_block {
 #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
 #define SDEBUG_OPT_HOST_BUSY		0x8000
 #define SDEBUG_OPT_CMD_ABORT		0x10000
+#define SDEBUG_OPT_UNALIGNED_WRITE	0x20000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
 #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
@@ -237,7 +238,8 @@ struct tape_block {
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
 				  SDEBUG_OPT_SHORT_TRANSFER | \
 				  SDEBUG_OPT_HOST_BUSY | \
-				  SDEBUG_OPT_CMD_ABORT)
+				  SDEBUG_OPT_CMD_ABORT | \
+				  SDEBUG_OPT_UNALIGNED_WRITE)
 #define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
=20
@@ -4915,6 +4917,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
 	u8 *cmd =3D scp->cmnd;
 	bool meta_data_locked =3D false;
=20
+	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
+		     atomic_read(&sdeb_inject_pending))) {
+		atomic_set(&sdeb_inject_pending, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE,
+				UNALIGNED_WRITE_ASCQ);
+		return check_condition_result;
+	}
+
 	switch (cmd[0]) {
 	case WRITE_16:
 		ei_lba =3D 0;
