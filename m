Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE8B30CDB2;
	Wed, 27 Aug 2025 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330290; cv=none; b=aIpLDcWSydDkAS3aexS+9ZjE/31xAvmOHBbhESVQJMmYbwY+DNhw1jb/+EkvWSC+y+DIpbSDU8GPuiJnh4SRcxnTpBijAk7iEAw0/XN6vI85peUh4bkznMysp/e4uoi54Lc5/rhmuNkQ524lsMasnrKIfsHUhvAL2HQ45DHoGmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330290; c=relaxed/simple;
	bh=LkJoy4Ea3vO3xHob9kIsKTc/KJp6fmflyK9oF5QLpc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaR0blgLn9ufwCy7u1Sl4MWCf3ot+IMpLVro7tzUc9IN8Ci0Xvvaso+MsptFgVQV0lnaIxpu33CpILLD4SAvD8jMrHVjTQko9EojHui4L51V0qHpksJzEOiqNfs7rSm/8crmvpAJLGHwqXmhZLtqu4CXj96Sj4eOsyzGtXMUU3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xFePlN30; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xFePlN30"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByQR5bCPzm0yNK;
	Wed, 27 Aug 2025 21:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330285; x=1758922286; bh=PDKHv
	wU+LgEM8xkz/Ow2dkN/k1vPpL6bO7Aq94El7Uo=; b=xFePlN30AYcGVBqKnBIKo
	6VzA3ZVsqF1IaZ51ZwueoRpPV6SspuLtlirZjI4z6oAmeNlRc8L/41+tlzGRvA/2
	2zwByN2dCqnIYIM4GTgfhj6YAndFpB5gxSI99bX23YUvUPS6Vyb/5nJBriF74LVY
	Pd5qDZyTxxAoXBC3W5Z3+4NO2O/85+m9Cx41fZqdadrXFW5krwM/prQxX7Lnwxx0
	56Ii0+zGRrPyrDwSG44USdhzEPTSWBEfZxCDpwrVFrcstwOOVu7sC8czjtkSyH/5
	kG+lb1IWHHeSpdDbCoPu+TB9hLPmuk/J1Ydy6iusrjgjDqUi2ZnRPNulul2LuvWV
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YepgXM01xdUU; Wed, 27 Aug 2025 21:31:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByQH436Pzm0yQX;
	Wed, 27 Aug 2025 21:31:18 +0000 (UTC)
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
Subject: [PATCH v24 16/18] scsi: scsi_debug: Add the preserves_write_order module parameter
Date: Wed, 27 Aug 2025 14:29:35 -0700
Message-ID: <20250827212937.2759348-17-bvanassche@acm.org>
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

Make it easier to test write pipelining by adding support for setting the
BLK_FEAT_ORDERED_HWQ flag.

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
index 353cb60e1abe..2eeed9f63c69 100644
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
@@ -6630,10 +6631,15 @@ static struct sdebug_dev_info *find_build_dev_inf=
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
@@ -7362,6 +7368,8 @@ module_param_named(statistics, sdebug_statistics, b=
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
@@ -7434,6 +7442,8 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4-=
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
