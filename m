Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8D84A0C;
	Mon, 16 Jun 2025 22:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113297; cv=none; b=ukI9WF0oh6XL7gE3hK83UcfnZ+51k4WZS8VVzSqSCgCaCxvrARvxY9EK8zUcMKNfhLx5PqwsBaVcAENjLHqz9tzavB7PBFmBR6XCNjr/BsaA3mnxvcDcRcXEuE0HFI8l0GpigtZ/eFUQ1eFdgBrPl/YPSvFZvQ86hP9y0Y0p5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113297; c=relaxed/simple;
	bh=yWEPQmP8nFQ9yUmKXi4e2tufhCHjEyr5ZO3WD+Vymtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHCYVMAtBLRmr9wR5x8YeWfZ3T0ERL/1zyTQBsun3IYB82LuYQgXDUA7c5BExyzhZa/c3JJCeaU65RhPXBqwselyAnhrlMLU4b5EHxh+o0Ww3E5zhWFjSwZ1M0sB43nYwHAekwEooCr4gKM5oWySzzx/NEsG98CXwGpGpFgwkbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W4Togw2s; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W4Togw2s"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlDv0RVkzlgqxr;
	Mon, 16 Jun 2025 22:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113293; x=1752705294; bh=w1sG3
	TOiywRbcIeqeoGch3zZcEOXACvywEVY7r5KDws=; b=W4Togw2sr2YvSw+md5xu9
	OTYWakYI9yd/rFPVxC0G9LG30nWsg2e2amcZW4J3aAXKdKxNK0M8OllxoiqbK3Iz
	OSPMPjpg4mLeXyJBpuhHy7TtAdwggOwlJ59E59AvAQiN9VJ5RX4gdtCy2hT4VzYY
	tdUlEkkEZTDNkw1KbwU7o1bbExRTt5IHHTtcVir6SAZnxPixDr54jC1ZcGsThkh3
	VxWEZZNOTdiPeLndiaZ65kNhvtk4C0L5ONTvy4TPj/FpkRSuFjlux8n7rbzXAM4I
	qTOLevzSajJfrBjto9un/0PUeMiER61w826Qx3MeXUKfEqJ0C9wd4JDvqc2kC3jC
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zN9nXgBYdUtS; Mon, 16 Jun 2025 22:34:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlDl0lYCzlgqVx;
	Mon, 16 Jun 2025 22:34:46 +0000 (UTC)
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
Subject: [PATCH v18 10/12] scsi: scsi_debug: Add the preserves_write_order module parameter
Date: Mon, 16 Jun 2025 15:33:10 -0700
Message-ID: <20250616223312.1607638-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aef33d1e346a..5575bc8a833d 100644
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
@@ -6607,10 +6608,14 @@ static struct sdebug_dev_info *find_build_dev_inf=
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
+	q->limits.driver_preserves_write_order =3D sdeb_preserves_write_order;
+
 	return 0;
 }
=20
@@ -7339,6 +7344,8 @@ module_param_named(statistics, sdebug_statistics, b=
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
@@ -7411,6 +7418,8 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4-=
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
