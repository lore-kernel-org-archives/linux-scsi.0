Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13B3AF650
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786744213; cv=none; b=lqwMLt3uXpGals6ifa+PrWF8bqaPbBcu/PyAIHVOWSRFCtxze+2it86ubd40VncuIq1HTfLxB6Cl5ldZylsnsUg8ar+pf44+/eBoppdu8ny2MtHpa6l7BKNgcAV4QKgHDEm5XXhLxk98WKOfEYbAMGao05Wojp2/GU9WdSi9mbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786744213; c=relaxed/simple;
	bh=VEcywqhIyt1q79jiTcLPkpWCOpvRhsw1mToomhAaWQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nbvLL105R6rt+v35WLaEOFjMC5oBE4J9TrB1vtMMMCVyptLzcWPr0NN6SNsxJcv5AKkWqBGI4XZsMXusA1PRmV2ucEkd0i97ppxPpuO7FvDnuHODiOzIukRAWLlEaG4qmyGNS3HOzJqWY/HA2BfVAHpNqKvDySBi2ovA//TeJHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iH7JTNsf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iH7JTNsf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hMG9b271Bzlfvq4;
	Fri, 14 Aug 2026 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786744203; x=1789336204; bh=M4nurLwhzNShZPP/Av/U+8mj6qvCXV6RvTR
	nP7t+Xdk=; b=iH7JTNsfiL+4Hbhfrx2q6ywsGAk3fQ/iMih8FnTynADKz/iuNjt
	jbc8QhpFz6tsfCGsHfYx6a3IKX0nPSztQesPcUnJoRVCWBg2wns9J9qP3AZWNkDJ
	IQOUtPPWCMXcZQ5zh/ex5TmRFmVuj1FKszpbY6stbQvfO6syjoeZjgfEM4lIbLX3
	cRkfAwsNis5O4p2Gi/HHFy4e/jSvn+bLOc1ffESXxE/Jd/369R5dMWZMnCmCrQkR
	K/qnnHDmSTf9q+slM4S8KXvHqdq8WUcuvd+rb1GZw1SYb+SFs7iyFGxU603kc1Tp
	BkZLy7v6QO9AK79x/l7eQGlJLtxyeIhDtGw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5dNYk2KkBYbK; Fri, 14 Aug 2026 21:50:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hMG9N1Sl4zlfvpn;
	Fri, 14 Aug 2026 21:49:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Subject: [PATCH] ufs: core: Disable queue depth tracking support
Date: Fri, 14 Aug 2026 14:49:47 -0700
Message-ID: <20260814214951.80673-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Disable queue depth tracking support because:
 - UFS devices shouldn't need queue tracking support. If the host sends
   less than or equal to bQueueDepth commands to the UFS device, no TASK
   SET FULL condition should be reported. If a TASK SET FULL condition
   is reported anyway, the host->host_blocked variable will be set and
   the SCSI command will be requeued. Submission of the SCSI command
   will be retried after another SCSI command has completed.
 - The queue depth tracking code is not thread-safe. With MCQ enabled,
   scsi_track_queue_full() may be called from multiple CPU cores
   concurrently. This is not safe because individual
   scsi_track_queue_full() calls are not serialized.
 - scsi_track_queue_full() is called from interrupt context but not all
   code called by scsi_track_queue_full() is IRQ-safe. Here is an
   example of a call chain that may cause interrupts to be enabled,
   something that is not allowed from interrupt context:

   ufshcd_mcq_poll_cqe_lock()
     ufshcd_compl_one_cqe()
       scsi_done()
         blk_mq_complete_request()
           scsi_complete()
             scsi_decide_disposition()
               scsi_handle_queue_full()
                 scsi_track_queue_full()
                   scsi_change_queue_depth()
                     blk_set_queue_depth()
                       rq_qos_queue_depth_changed()
                         ioc_rqos_queue_depth_changed()
                           spin_lock_irq()
                           spin_unlock_irq() <- enables interrupts

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  4 ++++
 drivers/ufs/core/ufshcd.c           | 16 ----------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
index acbd787de265..19a6400d1ec4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1044,6 +1044,10 @@ static void srp_remove_target(struct srp_target_po=
rt *target)
 	WARN_ON_ONCE(target->state !=3D SRP_TARGET_REMOVED);
=20
 	srp_del_scsi_host_attr(target->scsi_host);
+	/*
+	 * The srp_remove_host() call decrements the rport reference count.
+	 * Keep the rport as long as its needed.
+	 */
 	srp_rport_get(target->rport);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 67745d2796d0..59212a3a46de 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5602,20 +5602,6 @@ static int ufshcd_sdev_init(struct scsi_device *sd=
ev)
 	return 0;
 }
=20
-/**
- * ufshcd_change_queue_depth - change queue depth
- * @sdev: pointer to SCSI device
- * @depth: required depth to set
- *
- * Change queue depth and make sure the max. limits are not crossed.
- *
- * Return: new queue depth.
- */
-static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth=
)
-{
-	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue))=
;
-}
-
 /**
  * ufshcd_sdev_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
@@ -9662,7 +9648,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.sdev_init		=3D ufshcd_sdev_init,
 	.sdev_configure		=3D ufshcd_sdev_configure,
 	.sdev_destroy		=3D ufshcd_sdev_destroy,
-	.change_queue_depth	=3D ufshcd_change_queue_depth,
 	.eh_abort_handler	=3D ufshcd_abort,
 	.eh_device_reset_handler =3D ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   =3D ufshcd_eh_host_reset_handler,
@@ -9673,7 +9658,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
 	.host_tagset		=3D true,
-	.track_queue_depth	=3D 1,
 	.skip_settle_delay	=3D 1,
 	.sdev_groups		=3D ufshcd_driver_groups,
 };
