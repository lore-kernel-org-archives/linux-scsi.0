Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDABCEEBB;
	Thu, 17 Jul 2025 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785963; cv=none; b=N4BT4cLLOpvGVf+YmYVWw+w9Bj7VQctIqD1XItoV0UiHaXadLBUIo0MpIEIdF3pLOASO1P2CEojdlGMBW1dHVwt8yDDV9JWqdYmIGCxqGL+o8MEElg6I0Bkt2TFIuN8xU2HrKv6XuADu2HqczmwKHyU4qvJsbgQtDVFzlisgjcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785963; c=relaxed/simple;
	bh=G+W+W9y3cYQbJYC//13juOjK18AzMl+1hYz3fINHuAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcIxiYfP428mYiPyiLMTGwpkBEb1Qg9PdcXx8RcC9oBgOHMFFF0lbWezLrI7Z3C1HPEDBID+jp2gBCWaGTuFqr64kj10gppwn2oo0f9n2gdhiV49jeBquBUga24fZ/yfXSwAkykqo2tBBKz7jGDjlaRcDC2a2RbumCOPHVkG9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TodWkSY/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TodWkSY/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjlfK044Mzm0ysn;
	Thu, 17 Jul 2025 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785959; x=1755377960; bh=GMMpv
	k5tFJIH6+0nNjCr0ltuM4YYRFZeWEtztPPLwHk=; b=TodWkSY/VBUA58cx9iwcE
	ALH+bkUYRsJksyuK8K71anU5XasQXc/2Qi3jml5zInt2WUh6cA7n/N7acQzU30Gw
	Eb/K7YfeJ92Xcz2deVoWXYmb4Ex4jHEI9BsbLj2fkyYwsy4rONMyDa3y57gncXgh
	bwpVb36H+inD+fzzK+2o7E7f29xyxwR+5d9rhkoofq/FHQ4LIfs31YleyDfSg6+T
	R8Ei44PA4gKAqpg8fJ0npmcrFT/MuWN/JwSQOIMDEnT0q8NSFVCHzDThpBLj1vJi
	M2VvJx6xs8xoTY1RC5HJeKZtQalQ44n6IaIPcUAfSom/FyRKsnbwOucnU8pLsTfH
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xyoVCMbzMMfJ; Thu, 17 Jul 2025 20:59:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjlf96g52zm0xkX;
	Thu, 17 Jul 2025 20:59:13 +0000 (UTC)
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
Subject: [PATCH v21 10/12] scsi: scsi_debug: Add the preserves_write_order module parameter
Date: Thu, 17 Jul 2025 13:58:06 -0700
Message-ID: <20250717205808.3292926-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250717205808.3292926-1-bvanassche@acm.org>
References: <20250717205808.3292926-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Zone write locking is not used for zoned devices if the block driver
reports that it preserves the order of write commands. Make it easier to
test not using zone write locking by adding support for setting the
driver_preserves_write_order flag.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346a..e970407cc7c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1004,6 +1004,7 @@ static int dix_reads;
 static int dif_errors;
=20
 /* ZBC global data */
+static bool sdeb_preserves_write_order;
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed dis=
ks */
 static int sdeb_zbc_zone_cap_mb;
 static int sdeb_zbc_zone_size_mb;
@@ -6607,10 +6608,15 @@ static struct sdebug_dev_info *find_build_dev_inf=
o(struct scsi_device *sdev)
=20
 static int scsi_debug_sdev_init(struct scsi_device *sdp)
 {
+	struct request_queue *q =3D sdp->request_queue;
+
 	if (sdebug_verbose)
 		pr_info("sdev_init <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
=20
+	if (sdeb_preserves_write_order)
+		q->limits.features |=3D BLK_FEAT_ORDERED_HWQ;
+
 	return 0;
 }
=20
@@ -7339,6 +7345,8 @@ module_param_named(statistics, sdebug_statistics, b=
ool, S_IRUGO | S_IWUSR);
 module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
 module_param_named(submit_queues, submit_queues, int, S_IRUGO);
 module_param_named(poll_queues, poll_queues, int, S_IRUGO);
+module_param_named(preserves_write_order, sdeb_preserves_write_order, bo=
ol,
+		   S_IRUGO);
 module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
 module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO=
);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_I=
RUGO);
@@ -7411,6 +7419,8 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4-=
>timeout, 8->recovered_err...
 MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will ge=
t new store (def=3D0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=3D0)");
 MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to m=
ax(submit_queues - 1))");
+MODULE_PARM_DESC(preserves_write_order,
+		 "Whether or not to inform the block layer that this driver preserves =
the order of WRITE commands (def=3D0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=3D0[disk])");
 MODULE_PARM_DESC(random, "If set, uniformly randomize command duration b=
etween 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=3D0)");
