Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFDE38F651
	for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2026 21:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774474058; cv=none; b=oLBMhJPZXe17ENGftazNOoPcquxMTipl9ZMtvD7RZUqfw52Z/vTh2fGzlQFZMVMjRis5Nv96e93I5n+5odfN2xh1e8pax4+LjoE82lBzuMwUzN1ha5xGbepI3l8u4y0Lca+1GCizB4UVZAuzvmywNsXRwJPrGPQmH+HFalp/LVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774474058; c=relaxed/simple;
	bh=DAeVOpXFv6hQLAOEiIiRvdmfIhC21seVLoLmJa/XsIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQd7eTr/oTahqeQlXCYQQ9/1Al4JinuANkUWVMdAibHZBKi8YP0aJNOIXjXIpSishpNXQqV9kkAT0G0Vsy4eeCxP0+RPlKzixFGy3QIKZYrIQeMrpB5rCZktb23evBFhDmD/ubaN/PbKL7rHbJn+j9nKG8KjMUeeP2qV0i3qrCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V4V2tHS0; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V4V2tHS0"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fh0P05T1xz1XMFjb;
	Wed, 25 Mar 2026 21:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1774474047; x=1777066048; bh=VUC6PccSqxRT4cCnI7HRvTi42f2p7n99+zH
	XulC90z0=; b=V4V2tHS0tkaRoUNyZaGCqgcMGnwpI1QN4tpOn3SiyrMUYknCIFz
	6dUdQZvvPguA5Vnj9Z5tdASClGfg7pj/nR4a5WcIXq+Zw0mzBp2PC4mvcncDP/cv
	D4zVKC5UFD3oOnXzgpjl/bpVd6gxUIqD5MCDunZSjNNWwUf2pMHpHNGZjyv5WQ9l
	5IdO75RgPnxLDsgr9Y2mQzoYbPZyxSw/1MGb6ajljZBJLYO7oE4sPJeGthbNp9dK
	DgDiWpdwL2G2z28hNGFnhz+xEydLm3J1SbcUk+GipIAQ8iTBiR0HRlJl7WIMwCA9
	TesQK2GPwxoWKSqcaqOu/dwIhWNi+MI5fsg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m_ut7oBOtMVY; Wed, 25 Mar 2026 21:27:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fh0Nt3YWHz1XMFjY;
	Wed, 25 Mar 2026 21:27:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] scsi_debug: Support configuring the maximum segment size
Date: Wed, 25 Mar 2026 14:27:17 -0700
Message-ID: <20260325212717.2846862-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add a kernel module parameter for configuring the maximum segment size.
Note: blk_validate_limits() considers zero as the default and changes it
into a valid value. Values between 1 and BLK_MIN_SEGMENT_SIZE are rejecte=
d
by blk_validate_limits().

This patch enables testing SCSI support for segments smaller than the
page size.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
Cc: John Garry <john.g.garry@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>

Changes compared to v1:
 - Removed sdebug_driver_template.max_segment_size.
 - Changed the default max_segment_size value from BLK_MAX_SEGMENT_SIZE i=
nto
   UINT_MAX (this is the same as the current limit, -1U).
 - Explained in the patch description that blk_validate_limits() rejects
   values between 1 and BLK_MIN_SEGMENT_SIZE.

 drivers/scsi/scsi_debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..44309a16eb68 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -915,6 +915,7 @@ static int sdebug_host_max_queue;	/* per host */
 static int sdebug_lowest_aligned =3D DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns =3D DEF_MAX_LUNS;
 static int sdebug_max_queue =3D SDEBUG_CANQUEUE;	/* per submit queue */
+static unsigned int sdebug_max_segment_size =3D UINT_MAX;
 static unsigned int sdebug_medium_error_start =3D OPT_MEDIUM_ERR_ADDR;
 static int sdebug_medium_error_count =3D OPT_MEDIUM_ERR_NUM;
 static int sdebug_ndelay =3D DEF_NDELAY;	/* if > 0 then unit is nanoseco=
nds */
@@ -7366,6 +7367,7 @@ module_param_named(lowest_aligned, sdebug_lowest_al=
igned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IR=
UGO);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int,
@@ -7449,6 +7451,7 @@ MODULE_PARM_DESC(lowest_aligned, "lowest aligned lb=
a (def=3D0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> fla=
t address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=3D=
1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def=
))");
+MODULE_PARM_DESC(max_segment_size, "max bytes in a single segment");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow =
on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return M=
EDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=3D0 -> igno=
re)");
@@ -9539,7 +9542,6 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.sg_tablesize =3D		SG_MAX_SEGMENTS,
 	.cmd_per_lun =3D		DEF_CMD_PER_LUN,
 	.max_sectors =3D		-1U,
-	.max_segment_size =3D	-1U,
 	.module =3D		THIS_MODULE,
 	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
@@ -9566,6 +9568,7 @@ static int sdebug_driver_probe(struct device *dev)
 	}
 	hpnt->can_queue =3D sdebug_max_queue;
 	hpnt->cmd_per_lun =3D sdebug_max_queue;
+	hpnt->max_segment_size =3D sdebug_max_segment_size;
 	if (!sdebug_clustering)
 		hpnt->dma_boundary =3D PAGE_SIZE - 1;
=20
