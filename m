Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1CA2E6D2C;
	Mon, 30 Jun 2025 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322686; cv=none; b=WpAt6w8rWPhk1VRtykrWC5zN9tJf0ae9Vkfoczd32xgcZ6RsCK0DxlRhhzLstSdD587YS3d6ZX+WsqymNp5yQyKC07pPsvas8Wtw5eiJ2mk3O8xsu4qmP77uc+NOpMAjzylxcw04J3vdQVZMoPMqooQJb7FRS1Fin2OLHggdE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322686; c=relaxed/simple;
	bh=t2dLqiVV93nIpk4hAhMdRoS/atQvk65z071/Yn98h5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8RnCo6ZG4wBJsNy5d8EpYBHMsuRvv5+Qdne9xik9lROaWAngOJfYIwjycLO/g1FLgkwC8c+MzIKqXO1ryuxodzq8twlU3j3XIYJOvzWVuzbxn1p850QtSgzpLpZk9lGr6OGm9BtTxzytkkBFR+wFDS9PYt6DFET1JmYHAbhlr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WHUJX32e; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WHUJX32e"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLVN3LGQzm1HbT;
	Mon, 30 Jun 2025 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322682; x=1753914683; bh=igGoR
	aDrwEsquUk50FNqWwB9z+w2YY76hv9v+5TDYQU=; b=WHUJX32evhmK2KI3EJmhk
	gcVJixHifSTdKh9FQtMuJWRflefO0RGY8931DgvWhyHrlmiAIAIQGfkpqpGBJmKQ
	hCM+7FArld5Vp0DfKQmOnY/fvYGL2Z6UnMaGtc5tEQ9C8OlUCIpVC6oxmAIGPWqO
	WTWcKgMvHHYz9oHS8cxyNTdD1A9dqbEUgRPJkBopIYzBXxN4cJbGxYFORFhIujUz
	pHmhGwIqAkC6JIvRyPJgqxkigiPe+grMZ2co9glp+FdZgwD7qnEN4TdBqPq25MKx
	04AOmXFSOxVBaonJUfXkdunUnS8QVPdsylfOt5zbG3N4pmE4jUKgQGn/hIKQxExQ
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XbxnqP4yxI32; Mon, 30 Jun 2025 22:31:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLVF08hDzm0bfX;
	Mon, 30 Jun 2025 22:31:16 +0000 (UTC)
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
Subject: [PATCH v19 10/11] scsi: scsi_debug: Support injecting unaligned write errors
Date: Mon, 30 Jun 2025 15:30:02 -0700
Message-ID: <20250630223003.2642594-11-bvanassche@acm.org>
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
index 5575bc8a833d..963246f5894a 100644
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
