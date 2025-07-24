Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA76A23BCEE;
	Thu, 24 Jul 2025 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394338; cv=none; b=SW17hi7K3jXAX4QW3ACL+5E4c3Nf89yauE7nLpkPQ4H04EnenMzEkUX5kUbjYPfkz2vJHTzc6hlgnUQCwvdUx/KIzaTTVD++aPES7b+DHxwJCHkOLRxJCsVd1IeRmEk0H0jGrdIy/Tv6rEgRX+R1TG51hsWbewbcTHmEbmt4/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394338; c=relaxed/simple;
	bh=G+W+W9y3cYQbJYC//13juOjK18AzMl+1hYz3fINHuAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntM6rVYTlZHCMBCjNN68IlqMndN3Lxah7wxwIFcCVvjjoMOiOA1gdiDIpm71wCFtcIIkJcj6lHI/g+XSMDTapeBw6wLxc7WO0qA5jTu8lXIyzhi+muFDfBiyFPvZk/qVg9fpAGJQl1PiklXl7t3oNcccXmbH5GWy1aWnZbrZjGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vyJcUk9h; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vyJcUk9h"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4dq5hp5zlgqVS;
	Thu, 24 Jul 2025 21:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394333; x=1755986334; bh=GMMpv
	k5tFJIH6+0nNjCr0ltuM4YYRFZeWEtztPPLwHk=; b=vyJcUk9h+4uHt180KBcOF
	7v3uUgAbaAgxHbAoSyefBpgVxdSn+mbvOEDkN76Rfu8t1NVYxOCQAfphj+N//umH
	gB0DxXZR2eVjDIueyFjGNf+AxWxeRG6kU8FpGEjRB3b5L9f9d0ndaQRsj1Zcd+Bk
	W/uu+rYBZeu2yUWajkSEallWEHissX2xSl2ZpBd7XQG2/lLM1vDGHETcqg/n6/Gg
	UyQ775SADjiKLwrUKP6bADH46l9my+7r2NDzsTfvm1aJm+GnMSTcBjswdQq283/2
	hWEJNFUB0xAYI1ygla6IwiWZik3C++kbnU7eFnesaL0y3P+G4mAsfG26TMuu0Yc6
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6rPU1sGLz--v; Thu, 24 Jul 2025 21:58:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4df3t2LzlgqTv;
	Thu, 24 Jul 2025 21:58:45 +0000 (UTC)
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
Subject: [PATCH v22 12/14] scsi: scsi_debug: Add the preserves_write_order module parameter
Date: Thu, 24 Jul 2025 14:57:01 -0700
Message-ID: <20250724215703.2910510-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
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
