Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A38A93D;
	Tue, 19 Nov 2024 00:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976156; cv=none; b=DIcwMOhYb0hwIpsZN2ah34/MAIVwSf607QPbMcKcoROpbJX4PSUgOsL+9q4GpneZXdelR9W6qnfDRW5dvpzwofVFSbRFwUjakLujWjRmoFyW4Iaot0cahb5smZuJwy1Ym508dexEt6T5NsM2eGtCdrP3izgwh2+KRAzRVnZoawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976156; c=relaxed/simple;
	bh=j4sz/qBNMekuofU1ktxXDEUv8Uh022s1uRb3hgBcN9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1e4DCybiakeQfiT5MHyJ0x4t78Uf+izjjBZXWH0IYVJsb3qG2EY1Do8dgnBfp3O8sfqS/Fl9EAQh9Z7eI9GXyo8WiAsaJ/1YhORUJn8Ir6Dxr4OKd/qMWKGsYLN8nVRktzcEoURLhU6NRwq7/HPJwHKLvHgVNOBwAA4ashD6J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fEL64GDZ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fEL64GDZ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsljk618fzlgMVl;
	Tue, 19 Nov 2024 00:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976148; x=1734568149; bh=HSoRR
	Z7v34DsckbfLaZU4jruxRl81/x/BHT3EsdK8So=; b=fEL64GDZdMKon94/empXM
	bSjxEMZocC93mnYGVsdngexs8/XTxygonzv1vZuW99GSKM/VxZfLWMMzzl10PFRk
	+MKZYdoAOtm6AUCa2YyVwN/xOaGebbuWpsW9IKoPQu0SINEusZWhs7C3p0DK2T4K
	JtxzAV4jpSOUDldPpqjmQ2khAMaaFmWtJIO0Te6g2vUtnbTXCOyVqTL33/p3vnNw
	X2mI1QAq/myRAhe148XFLxian5I2Kb1oyaOpjknRpUXXbOYPQY40YwT+4ILMX7w3
	953ROHJ0FTTjYbEQXth0Yg7uJ2GBtvYwi8JMtn/xzh6qQHHH37pVBDB79mdELTin
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6khAYI1PbBwx; Tue, 19 Nov 2024 00:29:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljZ5zNmzlgVXv;
	Tue, 19 Nov 2024 00:29:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v16 23/26] scsi: scsi_debug: Add the preserves_write_order module parameter
Date: Mon, 18 Nov 2024 16:28:12 -0800
Message-ID: <20241119002815.600608-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
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
index b52513eeeafa..1b5a9cc27fbd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -927,6 +927,7 @@ static int dix_reads;
 static int dif_errors;
=20
 /* ZBC global data */
+static bool sdeb_preserves_write_order;
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed dis=
ks */
 static int sdeb_zbc_zone_cap_mb;
 static int sdeb_zbc_zone_size_mb;
@@ -5881,10 +5882,14 @@ static struct sdebug_dev_info *find_build_dev_inf=
o(struct scsi_device *sdev)
=20
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
+	struct request_queue *q =3D sdp->request_queue;
+
 	if (sdebug_verbose)
 		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
=20
+	q->limits.driver_preserves_write_order =3D sdeb_preserves_write_order;
+
 	return 0;
 }
=20
@@ -6620,6 +6625,8 @@ module_param_named(statistics, sdebug_statistics, b=
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
@@ -6692,6 +6699,8 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4-=
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
